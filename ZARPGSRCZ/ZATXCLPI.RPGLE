     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA European W/Tax Calc for Private Indvdual')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZATXCLPI - European Withholding Tax Calculation for          *
      *             Private Individuals                               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD053600           Date 28Nov19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 MD030924           Date 07Oct14               *
      *                 CER069             Date 03Jul14               *
      *                 MD027307A          Date 19Aug14               *
      *                 MD027318           Date 09Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR744769           Date 28Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26979           Date 22Jan10               *
      *                 BUG26839           Date 05Jan10               *
      *                 BUG26790           Date 27Nov09               *
      *                 BUG26581           Date 13Nov09               *
      *                 BUG26703           Date 09Nov09               *
      *                 BUG24630A          Date 02Jul09               *
      *                 BUG24630           Date 01Jul09               *
      *                 BUG24521           Date 23Jun09               *
      *                 BUG24344           Date 17Jun06               *
      *                 BUG24197           Date 02Jun09               *
      *                 BUG24051           Date 28May09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24053           Date 20May09               *
      *                 BUG24029           Date 19May09               *
      *                 BUG24016           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23657           Date 13Apr09               *
      *                 BUG23090           Date 25Feb09               *
      *                 BUG22953A          Date 25Feb09               *
      *                 BUG23071           Date 23Feb09               *
      *                 BUG22911           Date 17Feb09               *
      *                 BUG22953           Date 17Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22754           Date 10Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 06May06               *
      *                 236461             Date 18Oct05               *
      *                 236399             Date 18Oct05               *
      *                 235663             Date 30Sep05               *
      *                 236065             Date 13Sep05               *
      *                 235303             Date 03Aug05               *
      *                 236825             Date 26Jun05               *
      *                 233269             Date 27Apr05               *
      *                 232543             Date 14Mar05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053600 - Missing tax total in Report SD200205P1            *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD030924 - For Customer combi S with Transaction Tax         *
      *             Indicator A, taxes were computed                  *
      *  CER069 - German Tax Enhancement                              *
      *  MD027307A - Second tax is deducted twice.                    *
      *  (Reopen)   - Need to correct fix done for MD027318.          *
      *  MD027318 - Payment message deduct only main tax instead of   *
      *             both taxes.                                       *
      *           - Include second and third tax in the tax amount    *
      *             removed by BUG22911.                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR744769 - Total tax amount discrepancy brought by rounding  *
      *             off issue (Child: AR744770)                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26979 - Serious Midas error encountered while trying      *
      *             to roll-over                                      *
      *  BUG26839 - JA1_Threshold limit of the main joint customer was*
      *             utilized by the member                            *
      *  BUG26790 - DLC0606B 00001 Database error in SDACUSPD         *
      *  BUG26581 - Federal State Code used has zero amount           *
      *  BUG26703 - SD200205P1 report does not break the data down    *
      *             by state code                                     *
      *  BUG24630A - In MM and Retail Interest Calculation Threshold  *
      *              is not being Deducted.                           *
      *  BUG24630 - In MM and Retail Interest Calculation Threshold is*
      *              not being Deducted.                              *
      *  BUG24197 - Incorrect Gross Interest                          *
      *              Applied as 24521                                 *
      *  BUG24521 - Utilisation at Joint Account was not reflected    *
      *  BUG24344 - Incorrect calculation of tax                      *
      *  BUG24051 - Incorrect Threshold Utilisation Postings          *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG24053 - Non taxable transaction generated third tax in    *
      *             SDCSINPD                                          *
      *  BUG24016 - Blank State Code is not handled                   *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23657 - Threshold/Certificate Value date and expiry date  *
      *  BUG23090 - Used DSLDY instead of DSSDY to prevent loopingl   *
      *             after producing dump in DL1705                    *
      *  BUG22953A - Secondary and Main tax not calculated on OSIC    *
      *  BUG23071 - Cannot do the roll over for Money market          *
      *  BUG22911 - Changes for Correct Tax Calculation               *
      *  BUG22953 - Secondary and Main tax not calculated on OSIC     *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22754 - Incorrect main and secondary tax calculations     *
      *  CER048 - German Features - Taxes                             *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  236461 - Change access object for customer to also consider  *
      *           'Closed' customer.                                  *
      *  236399 - Include code of subroutine *PSSR in the program, so *
      *           that for any exemption error, return parameter      *
      *           'ERROR' will be returned, for calling program to    *
      *           fail or end in error.                               *
      *  235663 - Retrieve correct Tax Basket record                  *
      *           reversing out 236065 as this is a better fix        *
      *  236065 - Incorrect detail for customer with No Tax           *
      *  235303 - Customer Tax details error                          *
      *  236825 - Tax wrongly rounded                                 *
      *  233269 - Errors on ZATXCLJA and ZATXCLPI                     *
      *  232543 - Fix for CGL031                                      *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Customer Details by Country of Tax
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)

      ** Country of Tax Codes Details
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)

      ** SD Tax Basket Details
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)

      ***EU*Tax*Accruals*at*Effective*Dates****************************                       233269
     F***GLETXAL1  UF   E           K DISK    INFSR(*PSSR)                                    233269
      **********                                                                     CER048 BUG22911
      ***Interest Payment History File                                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
     F***SDINPHL1  IF   E           K DISK    INFSR(*PSSR)                           CER048 BUG22911
                                                                                              CER054
      ** Federal State Codes Keyed by State Codes                                             CER054
     FSDGESTL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054
                                                                                              CER054
      ** Religious Affiliation Codes Keyed by Religious Affiliation                           CER054
     FSDRLAFL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054

      ** Tax Status Change Details of Tax Paid                                                CER069
     FSDTSCHPD  O    E             DISK    INFSR(*PSSR)                                       CER069
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      ***********                                                                  BUG22754 BUG22911
      ***Array*containing*powers*for*Ccy*conversion                                BUG22754 BUG22911
      ***********                                                                  BUG22754 BUG22911
     D*Power*****      S              7  3 DIM(7) CTDATA PERRCD(1)                 BUG22754 BUG22911
      ***********                                                                  BUG22754 BUG22911
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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

     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                       CER054
     D LO              C                   'abcdefghijklmnopqrstuvwxyz'                       CER054
                                                                                              CER054
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Accrual Amount array
     D TACCR           S             15  0 DIM(20)

      ** Start Date array
     D TSTRD           S             15  0 DIM(20)

      ** Dummy Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Dummy Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              236461
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     236461

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External DS for Location Details
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)

      ** External DS for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035

      ** External DS for Country codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *                                                                                       CER048
      ** External DS for Sar Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
      **********                                                                   BUG22754 BUG22911
      ***External*DS*for*Currency*Details                                          BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     D*SDCURR***     E DS                  EXTNAME(SDCURRPD)                       BUG22754 BUG22911
      *                                                                                     BUG22911
      ** Midas SD Tax Parameter File                                                        BUG22911
      *                                                                                     BUG22911
     D SDTXPA        E DS                  EXTNAME(SDTXPAPD)                                BUG22911
      *                                                                                     BUG23657
      ** Exemption and Certificate Dates                                                    BUG23657
     D SDTXDT          DS                                                                   BUG23657
     D   PEVDT                             LIKE(E5EVDT)                                     BUG23657
     D   PEXDT                             LIKE(E5ETXT)                                     BUG23657

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Access object parameter list
     D PBranch         S              3A
     D PLocation       S              3A
     D PCustomer       S              6A
     D PCountry        S              2A
     D PKey1           S             10A
     D PKySt           S              7A
     D POptn           S              7A
     D PRtcd           S              7A
     D PSard           S              6A                                                      CER048

      ** Input Parameter
     D PMODI           S              1A
     D*PTRRF****       S             18A                                                      CGL035
     D PTRRF           S             24A                                                      CGL035
     D PBRCA           S              3A
     D PCUST           S              6A
     D PNARF           S             10A                                                    BUG26979
     D PSTRD           S              5P 0
     D PENDD           S              5P 0
     D PTOTI           S             15P 0
     D PTAXR           S              6P 4
     D POCCY           S              3A
     D PInth           S              1A                                                      CER048
     D WTOTO           S             15P 0                                                  BUG22911

      ** Output Parameter
     D PIAED           S             15P 0
     D PTAXA           S             15P 0
     D PTOTO           S             15P 0
     D PTXCY           S              3A
     D PCTAX           S              2A
     D PTXBS           S              2A
     D*PWTAC****       S              4P 0                                                    CGL035
     D PWTAC           S             10P 0                                                    CGL035
     D PCOLC           S              2A
     D PSTAT           S              5A
     D PTRTE           S              1A
     D PTXR1           S              6P 4
     D*PStxb****       S              2P 0                                           CER048 BUG22911
     D*PStac****       S             10P 0                                           CER048 BUG22911
     D*PSttr****       S              6P 4                                           CER048 BUG22911
     D*PSttp****       S              1A                                             CER048 BUG22911
     D*PStxa****       S             15P 0                                           CER048 BUG22911
     D PKEY            S             10A
     D PFILE           S             10A
     D PRTRN           S              7A
     D P@TRN           S              7A                                                    BUG23071

      ** Work Fields
     D WPrevEAACCR     S             13P 0
     D PerformIntCal   S              1A
     D KCTAX           S              2A
     D KCOLC           S              2A
     D KCTAX1          S              2A
     D KCUST           S              6A
     D KModule         S              1A
     D*KTrRef***       S             18A                                                      CGL035
     D KTrRef          S             24A                                                      CGL035
     D KEffDate        S              5P 0
     D KCttx           S              2A                                                      CER048
     D KStxbs          S              2A                                                      CER048
     D WRead           S              1  0

     D Tax1            S             15P 0
     D Tax2            S             15P 0
     D Tax3            S             15P 0
     D Tax4            S             15P 0
     D Tax5            S             15P 0
     D WEDAT           S              5P 0
     D WTRTS           S              1A
     D WSTR1           S              5P 0
     D WEND1           S              5P 0
     D WTXR1           S              6P 4
     D WACC1           S             15P 0
     D WSTR2           S              5P 0
     D WEND2           S              5P 0
     D WTXR2           S              6P 4
     D WACC2           S             15P 0
     D WSTR3           S              5P 0
     D WEND3           S              5P 0
     D WTXR3           S              6P 4
     D WACC3           S             15P 0
     D WSTR4           S              5P 0
     D WEND4           S              5P 0
     D WACC4           S             15P 0
     D WTXR4           S              6P 4
     D WSTR5           S              5P 0
     D WEND5           S              5P 0
     D WTXR5           S              6P 4
     D WACC5           S             15P 4
     D WPTXR           S              6P 4                                                  AR744769
     D WTaxable        S             15P 0                                                  BUG24521
     D*WCuth****       S             15P 0                                           CER048 BUG22911
     D*WSchk****       S             15P 0                                           CER048 BUG22911
     D*WToti****       S             15P 0                                           CER048 BUG22911
      *                                                                                       CER048
      ** German Taxes Feature                                                                 CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
      **********                                                                   BUG22754 BUG22911
     D*PCcy*****       S              3A                                           BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     D*WUtth****       S             15P 0                                         BUG22754 BUG22911
     D*WORate***       S             13P 8                                         BUG22754 BUG22911
     D*WODecP***       S              1P 0                                         BUG22754 BUG22911
     D*WOMdin***       S              1A                                           BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
      ***Parameters*for*Conversion*Routine                                         BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     D*PAmtcI***       S             15P 0                                         BUG22754 BUG22911
     D*PAmtcO***       S             15P 0                                         BUG22754 BUG22911
                                                                                              CER054
     D CER054          S              1A                                                      CER054
     D WRLAF           S              4A                                                      CER054
                                                                                              CER054
      ** Third Tax Basket                                                                     CER054
     D KTtxbs          S              2A                                                      CER054
                                                                                              CER054
      ** State Code                                                                           CER054
     D KSTCD           S              2A                                                      CER054
                                                                                              CER054
      ** Religious Affiliation Code                                                           CER054
     D KRLAF           S              4A                                                      CER054
     D CER069          S              1A                                                      CER069
     D TaxChg          S              1A   Inz(*Blanks)                                       CER069

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

      ** Initialization

     C                   EVAL      PerformIntCal = *Blanks

      ** Initialise output fields

     C                   EVAL      PIAED  = *ZEROS
     C                   EVAL      PTAXA  = *ZEROS
     C                   EVAL      PTOTO  = *ZEROS
     C                   EVAL      PTXCY  = *BLANK
     C                   EVAL      PCTAX  = *BLANK
     C                   EVAL      PTXBS  = *BLANK
     C                   EVAL      PWTAC  = *ZEROS
     C                   EVAL      PCOLC  = *BLANK
     C                   EVAL      PSTAT  = *BLANK
     C                   EVAL      PTRTE  = *BLANK
     C                   EVAL      PTXR1  = *ZEROS
     C                   EVAL      PKEY   = *BLANK
     C                   EVAL      PFILE  = *BLANK
     C                   EVAL      PRTRN  = *BLANK
      *                                                                                       CER048
      ** Initialise Taxes Output Variables                                                    CER048
      *                                                                                       CER048
     C                   EVAL      PStxb  = *ZEROS                                            CER048
     C                   EVAL      PStac  = *ZEROS                                            CER048
     C                   EVAL      PSttr  = *ZEROS                                            CER048
     C                   EVAL      PSttp  = *BLANKS                                           CER048
     C                   EVAL      PStxa  = *ZEROS                                            CER048
     C                   EVAL      PUtil  = *ZEROS                                          BUG22911
     C                   EVAL      PPort  = *ZEROS                                          BUG22911
      *                                                                                       CER054
     C                   EVAL      PStcd  = *BLANKS                                           CER054
     C                   EVAL      PRlaf  = *BLANKS                                           CER054
     C                   EVAL      PTtxb  = *ZEROS                                            CER054
     C                   EVAL      PTtac  = *ZEROS                                            CER054
     C                   EVAL      PTttr  = *ZEROS                                            CER054
     C                   EVAL      PTttp  = *BLANKS                                           CER054
     C                   EVAL      PTtxa  = *ZEROS                                            CER054
     C                   EVAL      TaxChg = *Blanks                                           CER069

      ** Retrieve Tax Details: Customer Status, Tax Basket, Tax Currency Retrieval

     C                   EXSR      SRRtvTaxDet

     C                   IF        PSTAT = 'DISCL'  OR
     C                             PSTAT = 'SELF '  OR
     C                             PSTAT = 'TAXAB'  OR
     C                             PerformIntCal = 'Y'

     C                   EVAL      PTOTO = PTOTI
     C                   EVAL      WTaxable = PTOTI                                         BUG24521

     C**********         IF        PMODI <> 'S'                                               233269
      **********                                                                              233269
      ***Retrieve Interest Details: Interest Accrued in Diff Period                           233269
      **********                                                                              233269
     C**********         EXSR      SRRtvIntDet                                                233269
      **********                                                                              233269
      ***Interest Calculation: Interest Amount at Effective Date                              233269
      **********                                                                              233269
     C**********         EXSR      SRCalIntAmt                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269
                                                                                              233269
     C                   EVAL      PIAED  = PTOTI                                             233269
     C                   ENDIF


     C                   IF        PSTAT = 'TAXAB'

      ** Retrieve Tax Pariod and Tax Rates

     C**********         IF        PMODI <> 'S'                                               233269
     C                   EXSR      SRRtvTaxRate
     C**********         ENDIF                                                                233269

      ** Calculate Tax Amount

     C**********         EXSR      SRCalTaxAmt                                                233269
     C**********         EVAL      PTAXA = (PTOTI * PTXR1) / 100                       233269 236825
     C                   EVAL(H)   PTAXA = (PTOTI * PTXR1) / 100                              236825
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EXSR      SRCalcStax                                                 CER048
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EXSR      SRRtrvTtax                                                 CER054
     C                   ELSE                                                               BUG26581
      ** Retrieve State Code to populate SDCSINPD for Withholding Tax per Federal           BUG26581
      ** State Report                                                                       BUG26581
     C                   EXSR      SRRtvGrmState                                            BUG26581
     C                   ENDIF                                                                CER054
     C**********         ELSE                                                        CER048 BUG22911
     C                   ENDIF                                                              BUG22911
      *                                                                                     BUG22911
     C**********         EVAL(H)   PTAXA = (PTOTI * PTXR1) / 100                     236825 BUG24051
     C**********         EVAL(H)   PTAXA = (PTOTO * PTXR1) / 100                   BUG24051 BUG24521
     C                   EVAL(H)   PTAXA = (WTaxable * PTXR1) / 100                         BUG24521
     C                   IF        CER054 = 'Y' AND EWTTAM = 'Y'                              CER054
     C**********         EVAL      PTAXA = PTOTI / ( (100/PTXR1) + (PTttr/100) )     CER054 BUG24344
     C**********         EVAL      PTAXA = PTOTO / ( (100/PTXR1) + (PTttr/100) )  BUG24344 BUG24630A
     C**********         EVAL      PTAXA = WTaxable/((100/PTXR1) + (PTttr/100) )  BUG24630A AR744769
     C                   EVAL(H)   WPTXR = (100/PTXR1) + (PTttr/100)                        AR744769
     C                   EVAL(H)   PTAXA = WTaxable / WPTXR                                 AR744769
     C                   ENDIF                                                                CER054
      *                                                                                     BUG22911
     C                   IF        CER048 = 'Y'                                             BUG22911
     C                   EVAL(H)   PSTXA = (PTAXA * PSttr) / 100                            BUG22911
     C**********         EVAL      PTAXA = PTAXA + PSTXA                          MD027318 MD027307A
     C                   IF        CER054 = 'Y'                                               CER054
     C**********         EVAL      PTTXA = (PTAXA * PTttr) / 100                     CER054 AR744769
     C                   EVAL(H)   PTTXA = (PTAXA * PTttr) / 100                            AR744769
     C**********         EVAL      PTAXA = PTAXA + PSTXA                          MD027318 MD027307A
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      * If Tax Status has been changed and interest is capitalisating and tax                 CER069
      * has been deducted, output details to log file for use in generating a report          CER069
     C                   IF        CER069 = 'Y' and TaxChg = 'Y'                              CER069
     C                   EVAL      TRCUST = BBCUST                                            CER069
     C                   EVAL      TRCRNM = BBCRNM                                            CER069
     C                   EVAL      TRCRTN = BBCRTN                                            CER069
     C                   EVAL      TRCOLC = BBCOLC                                            CER069
     C                   EVAL      TRCVDT = AXCVDT                                            CER069
     C                   EVAL      TRCEEX = AXCEEX                                            CER069
     C                   EVAL      TRETXS = AXETXS                                            CER069
     C                   EVAL      TRDREF = PTRRF                                             CER069
     C                   EVAL      TRDDAT = PENDD                                             CER069
     C                   EVAL      TRCCY  = PTXCY                                             CER069
     C                   EVAL      TRGINT = PTOTO                                             CER069
     C                   EVAL      TRTTAX = PTAXA                                             CER069
     C                   WRITE     SDTSCHD0                                                   CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvTaxDet - Retrieve Tax Details
      *****************************************************************
     C     SRRtvTaxDet   BEGSR

      ** Retrieve Branch Details

     C                   EVAL      PBranch = PBRCA
     C                   EXSR      SRRtvBranch

      ** Retrieve Location

     C                   EVAL      PLocation = A8LCCD
     C                   EXSR      SRRtvLoc
     C                   EVAL      PCTAX = DVCNCD

      ** Retrieve Additional Customer Details

     C                   EVAL      PCustomer = PCUST
     C                   EXSR      SRRtvACust

      ** Retrieve Customer by Country of Tax

     C                   EVAL      KCTAX1 = PCTAX
     C                   EVAL      KCUST  = PCUST
     C                   EXSR      SRRtvCustTax

      ** Retrieve Customer Details

     C                   EVAL      PKey1 = *Blanks
     C                   MOVEL     PCUST         PKey1
     C                   EXSR      SRRtvCust
     C                   EVAL      PCOLC = BBCOLC

      ** Retrieve Country of Tax

     C                   EVAL      KCTAX = PCTAX
     C                   EVAL      KCOLC = PCOLC
     C                   EXSR      SRRtvCTax
     C                   EVAL      PTXBS = EWTXBS
     C                   MOVE      EWWTAC        PWTAC

      ** Retrieve Coutry Code details

     C                   EVAL      PCountry = PCTAX
     C                   EXSR      SRCntyCode

     C                   IF        A4TXCY <> *Blanks
     C                   EVAL      PTXCY = A4TXCY
     C                   ELSE
     C                   EVAL      PTXCY = POCCY
     C                   ENDIF

     C                   IF        CER069 = 'Y'                                               CER069
     C                   EXSR      SRTSCH                                                     CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   SELECT
     C                   WHEN      AXETXS = 'S'
     C                   EVAL      PSTAT = 'SELF '
     C                   EVAL      PRTRN = 'NOTAX  '
     C                   EVAL      PerformIntCal = 'Y'

     C                   WHEN      AXETXS = 'D'
     C                   EVAL      PSTAT = 'DISCL'
     C                   EVAL      PRTRN = 'NOTAX  '
     C                   EVAL      PerformIntCal = 'Y'

     C                   WHEN      AXETXS = 'E'
     C                   EVAL      PSTAT = 'NOTAP'
     C                   EVAL      PRTRN = 'NOTAX  '
     C***************    RETURN                                                               236065
     C                   RETURN                                                               235663

     C                   OTHER
     C                   EVAL      PSTAT = 'TAXAB'
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **SRRtvIntDet*-*Retrieve*Interest Details************************                       233269
      *****************************************************************
     C*****SRRtvIntDet   BEGSR                                                                233269
      **********                                                                              233269
     C*****KTaxAccr      KLIST                                                                233269
     C**********         KFLD                    KModule                                      233269
     C**********         KFLD                    KTrRef                                       233269
      **********                                                                              233269
      ***Read*all accrual records on file                                                     233269
      **********                                                                              233269
     C**********         EVAL      KModule = PMODI                                            233269
     C**********         EVAL      KTrRef = PTRRF                                             233269
     C**********         EVAL      WRead = 1                                                  233269
      **********                                                                              233269
     C*****KTaxAccr      SETLL     GLETXAL1                                                   233269
     C*****KTaxAccr      READE     GLETXAL1                                                   233269
      **********                                                                              233269
     C**********         DOW       NOT %EOF(GLETXAL1)  AND                                    233269
     C**********                   WRead < 6                                                  233269
      **********                                                                              233269
     C**********         SELECT                                                               233269
     C**********         WHEN      WRead = 1                                                  233269
     C**********         EVAL      WACC1 = EAACCR                                             233269
     C**********         WHEN      WRead = 2                                                  233269
     C**********         EVAL      WACC2 = EAACCR - WPrevEAACCR                               233269
     C**********         WHEN      WRead = 3                                                  233269
     C**********         EVAL      WACC3 = EAACCR - WPrevEAACCR                               233269
     C**********         WHEN      WRead = 4                                                  233269
     C**********         EVAL      WACC4 = EAACCR - WPrevEAACCR                               233269
     C**********         WHEN      WRead = 5                                                  233269
     C**********         EVAL      WACC5 = EAACCR - WPrevEAACCR                               233269
     C**********         ENDSL                                                                233269
      **********                                                                              233269
      ***Set*accrual processed flag to 'Y'                                                    233269
      **********                                                                              233269
     C**********         EVAL      WPrevEAACCR = EAACCR                                       233269
     C**********         EVAL      EAACPR = 'Y'                                               233269
     C**********         UPDATE    GLETXAD0                                                   233269
      **********                                                                              233269
     C*****KTaxAccr      READE     GLETXAL1                                                   233269
      **********                                                                              233269
     C**********         EVAL      WRead = WRead + 1                                          233269
     C**********         ENDDO                                                                233269
      **********                                                                              233269
     C*****ERtvIntDet    ENDSR                                                                233269
      *****************************************************************
      /EJECT
      *****************************************************************
      **SRCalIntAmt*-*Calculate*Interest*Amount*at*Effective*Date******                       233269
      *****************************************************************
     C*****SRCalIntAmt   BEGSR                                                                233269
      **********                                                                              233269
     C**********         IF        EWEDT1 <> *Zeros  AND                                      233269
     C**********                   EWEDT2 =  *Zeros                                           233269
      **********                                                                              233269
     C**********         SELECT                                                               233269
     C**********         WHEN      EWTRT1 = '1'                                               233269
     C**********         EVAL      WTRTS  = '1'                                               233269
     C**********         EVAL      PIAED  = PTOTI - WACC1                                     233269
     C**********         EVAL      WSTR1  = EWEDT1                                            233269
      **********                                                                              233269
     C**********         WHEN      EWTRT1 = '2'                                               233269
     C**********         EVAL      WTRTS  = '2'                                               233269
     C**********         EVAL      PIAED  = PTOTI                                             233269
     C**********         EVAL      WSTR1  = PSTRD                                             233269
     C**********         ENDSL                                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         IF        EWEDT2 <> *Zeros                                           233269
      **********                                                                              233269
     C**********         SELECT                                                               233269
     C**********         WHEN      EWTRT2 = '1'                                               233269
     C**********         EVAL      WTRTS  = '1'                                               233269
     C**********         EVAL      PIAED  = PTOTI - WACC1                                     233269
     C**********         EVAL      WSTR1  = EWEDT2                                            233269
      **********                                                                              233269
     C**********         WHEN      EWTRT2 = '2'                                               233269
     C**********         EVAL      WTRTS  = '2'                                               233269
     C**********         EVAL      PIAED  = PTOTI                                             233269
     C**********         EVAL      WSTR1  = PSTRD                                             233269
     C**********         ENDSL                                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C*****ECalIntAmt    ENDSR                                                                233269
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvTaxRate - Retrieve Tax Period and Tax Rate
      *****************************************************************
     C     SRRtvTaxRate  BEGSR

     C     KTaxBasket    KLIST
     C                   KFLD                    PCTAX
     C                   KFLD                    PTXBS
     C                   KFLD                    KEffDate

     C**********         EVAL      KEffDate = WSTR1                                           235663

     C                   IF        PENDD <> *ZERO                                             235663
     C                   EVAL      KEffDate = PENDD                                           235663
     C                   ELSE                                                                 235663
     C                   EVAL      KEffDate = BJRDNB                                          235663
     C                   ENDIF                                                                235663
                                                                                              235663
     C*****KTaxBasket    SETLL     SDTXBSL1                                                   235663
     C**********         READ      SDTXBSL1                                                   235663
     C     KTaxBasket    SETGT     SDTXBSL1                                                   235663
     C                   READP     SDTXBSL1                                                   235663

     C**********         IF        %EOF(SDTXBSL1)   OR                                        235663
     C**********                   TBCRTT <> PCTAX  AND                                       235663
     C**********                   TBTXBS <> PTXBS  AND                                       235663
     C**********                   TBEFDT >= PENDD                                            235663
     C                   IF        %EOF(SDTXBSL1)   OR                                        235663
     C                             TBCRTT <> PCTAX  OR                                        235663
     C                             TBTXBS <> PTXBS                                            235663
     C                   EVAL      PRTRN = 'NOTAX'
     C***************    RETURN                                                               236065
     C                   RETURN                                                               235663
     C                   ENDIF

     C**********         IF        TBCRTT = PCTAX  AND                                        233269
     C**********                   TBTXBS = PTXBS  AND                                        233269
     C**********                   TBEFDT < PENDD                                             233269
     C**********         EVAL      PTXR1 = TBTRAB                                             233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         EVAL      KEffDate = PENDD                                           233269
     C*****KTaxBasket    SETGT     SDTXBSL1                                                   233269
     C**********         READP     SDTXBSL1                                                   233269
      **********                                                                              233269
     C**********         IF        TBTRTY = '2'                                               233269
     C                   EVAL      WEND1 = PENDD
     C                   EVAL      PTXR1 = TBTRAB
     C                   EVAL      PTRTE = TBTRTY
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         IF        TBTRTY = '1'                                               233269
     C**********         EVAL      PTRTE = TBTRTY                                             233269
      **********                                                                              233269
     C**********         READ      SDTXBSL1                                                   233269
      **********                                                                              233269
     C**********         IF        TBCRTT = PCTAX  AND                                        233269
     C**********                   TBTXBS = PTXBS  AND                                        233269
     C**********                   TBEFDT < PENDD                                             233269
     C**********         EVAL      WEND1 = TBEFDT                                             233269
     C**********         EVAL      WSTR2 = TBEFDT                                             233269
     C**********         EVAL      WTXR2 = TBTRAB                                             233269
     C**********         EVAL      WEND2 = 0                                                  233269
     C**********         ELSE                                                                 233269
     C**********         EVAL      WEND1 = PENDD                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         READ      SDTXBSL1                                                   233269
      **********                                                                              233269
     C**********         IF        TBCRTT = PCTAX  AND                                        233269
     C**********                   TBTXBS = PTXBS  AND                                        233269
     C**********                   TBEFDT < PENDD                                             233269
     C**********         EVAL      WEND2 = TBEFDT                                             233269
     C**********         EVAL      WSTR3 = TBEFDT                                             233269
     C**********         EVAL      WTXR3 = TBTRAB                                             233269
     C**********         EVAL      WEND3 = 0                                                  233269
     C**********         ELSE                                                                 233269
     C**********         EVAL      WEND2 = PENDD                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         READ      SDTXBSL1                                                   233269
      **********                                                                              233269
     C**********         IF        TBCRTT = PCTAX  AND                                        233269
     C**********                   TBTXBS = PTXBS  AND                                        233269
     C**********                   TBEFDT < PENDD                                             233269
     C**********         EVAL      WEND3 = TBEFDT                                             233269
     C**********         EVAL      WSTR4 = TBEFDT                                             233269
     C**********         EVAL      WTXR4 = TBTRAB                                             233269
     C**********         EVAL      WEND4 = 0                                                  233269
     C**********         ELSE                                                                 233269
     C**********         EVAL      WEND3 = PENDD                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         READ      SDTXBSL1                                                   233269
      **********                                                                              233269
     C**********         IF        TBCRTT = PCTAX  AND                                        233269
     C**********                   TBTXBS = PTXBS  AND                                        233269
     C**********                   TBEFDT < PENDD                                             233269
     C**********         EVAL      WEND4 = TBEFDT                                             233269
     C**********         EVAL      WSTR5 = TBEFDT                                             233269
     C**********         EVAL      WTXR5 = TBTRAB                                             233269
     C**********         EVAL      WEND5 = PENDD                                              233269
     C**********         ELSE                                                                 233269
     C**********         EVAL      WEND4 = PENDD                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269

     C     ERtvTaxRate   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **SRCalTaxAmt*-*Calculate*Tax*Amount*****************************                       233269
      *****************************************************************
     C*****SRCalTaxAmt   BEGSR                                                                233269
      **********                                                                              233269
     C**********         IF        PMODI = 'S'                                                233269
     C**********         EVAL      WTRTS = '2'                                                233269
     C**********         EVAL      PTRTE = '2'                                                233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         IF        WTRTS = '1'  AND                                           233269
     C**********                   PSTRD < WSTR1                                              233269
      **********                                                                              233269
     C**********         IF        PTRTE = '1'                                                233269
     C**********         EVAL      Tax1 = (WACC2 * WTXR2) / 100                               233269
     C**********         EVAL      Tax2 = (WACC3 * WTXR3) / 100                               233269
     C**********         EVAL      Tax3 = (WACC4 * WTXR4) / 100                               233269
     C**********         EVAL      Tax4 = (WACC5 * WTXR5) / 100                               233269
     C**********         EVAL      PTAXA = Tax1 + Tax2 + Tax3 + Tax4                          233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         IF        PTRTE = '2'                                                233269
     C**********         EVAL      PTAXA = ((PTOTI - WACC1) * PTXR1) / 100                    233269
     C**********         ENDIF                                                                233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         IF        WTRTS = '2'    AND                                         233269
     C**********                   PSTRD < WSTR1  OR                                          233269
     C**********                   PSTRD >= WSTR1                                             233269
      **********                                                                              233269
     C**********         IF        PTRTE = '1'                                                233269
     C**********         EVAL      Tax1 = (WACC1 * WTXR1) / 100                               233269
     C**********         EVAL      Tax2 = (WACC2 * WTXR2) / 100                               233269
     C**********         EVAL      Tax3 = (WACC3 * WTXR3) / 100                               233269
     C**********         EVAL      Tax4 = (WACC4 * WTXR4) / 100                               233269
     C**********         EVAL      Tax5 = (WACC5 * WTXR5) / 100                               233269
     C**********         EVAL      PTAXA = Tax1 + Tax2 + Tax3 + Tax4 + Tax5                   233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         IF        PTRTE = '2'                                                233269
     C**********         IF        PMODI = 'S'                                                233269
     C**********         EVAL      PTAXA = (PTOTI * PTAXR) / 100                              233269
     C**********         ELSE                                                                 233269
     C**********         EVAL      PTAXA = (PTOTI * PTXR1) / 100                              233269
     C**********         ENDIF                                                                233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C*****ECalTaxAmt    ENDSR                                                                233269
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvBranch - Retrieve Branch Details
      *****************************************************************
     C     SRRtvBranch   BEGSR

      ** Access Branch details

     C**********         CALL      'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBranch
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL035
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL035

      ** No Record Found/ Error Encountered

     C                   IF        PRtcd <> *BLANKS
     C                   MOVEL     PBranch       PKEY
     C                   EVAL      PFILE = 'SDBRCHL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C     ERtvBranch    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvLoc - Retrieve Location
      *****************************************************************
     C     SRRtvLoc      BEGSR

      ** Access Location details

     C                   CALL      'AOLOCNR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PLocation
     C     SDLOCN        PARM      SDLOCN        DSFDY

      ** No Record Found/ Error Encountered

     C                   IF        PRtcd <> *BLANKS
     C                   MOVEL     PLocation     PKEY
     C                   EVAL      PFILE = 'SDLOCNL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C     ERtvLoc       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvACust - Retrieve Additional Customer Details
      *****************************************************************
     C     SRRtvACust    BEGSR

      ** Access Additional Customer Details

     C                   CALL      'AOACUSR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustomer
     C*****SDACUS        PARM      SDACUS        DSSDY                                      BUG23090
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23090

      ** No Record Found or Joint Acount Type is 'N'

     C                   IF        PRtcd  = '*NRF   ' OR
     C                             PRtcd  = '*EMPTY ' OR
     C                             PRtcd  = '*CUSDEL' OR                                    BUG26790
     C                             PRtcd  = '*CUSCLO' OR                                    BUG26790
     C                             PRtcd  = '*EOF   ' OR
     C                             E5JATP = 'N'       AND
     C                             PRtcd  = *BLANKS   OR                                      232543
     C                             E5JATP = ' '       AND                                     232543
     C                             PRtcd  = *BLANKS
     C                   EVAL      PSTAT = 'NOTAP '
     C                   EVAL      PRTRN = 'NOTAX  '
     C***************    RETURN                                                               236065
     C                   RETURN                                                               235663
     C                   ELSE

      ** Error Encountered

     C                   IF        PRtcd <> *Blanks
     C                   MOVEL     PCustomer     PKEY
     C                   EVAL      PFILE = 'SDACUSPD'
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   ENDIF
     C                   ENDIF

      ** Joint Account Type is 'Y'

     C                   IF        E5JATP = 'Y'  AND
     C                             PRtcd  = *BLANKS
     C                   EVAL      PRTRN = 'JOINT  '
     C                   RETURN
     C                   END

     C     ERtvACust     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCustTax - Retrieve Customer by Country of Tax
      *****************************************************************
     C     SRRtvCustTax  BEGSR

     C     KCustByTax    KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KCTAX1

      ** Access Customer by Country of Tax

     C     KCustByTax    CHAIN     SDACTXL1

      ** No Record Found

     C                   IF        NOT %FOUND(SDACTXL1)
     C                   EVAL      PKEY = PCUST + PCTAX
     C                   EVAL      PFILE = 'SDACTXL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C     ERtvCustTax   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCust - Retrieve Customer Details
      *****************************************************************
     C     SRRtvCust     BEGSR

      ** Access Customer Details

     C**********         CALL      'AOCUSTR0'                                                 236461
     C                   CALL      'AOCUSTR2'                                                 236461
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM      *Blanks       PKySt
     C*****SDCUST        PARM      SDCUST        DSSDY                                        236461
     C     SDCUST        PARM      SDCUST        DSLDY                                        236461

      ** No Record Found/ Error Encountered

     C                   IF        PRtcd <> *Blanks
     C                             AND BBCLST <> 'Y'                                          236461
     C**********         EVAL      PKEY = PCUST                                               236461
     C                   EVAL      PKEY = PKey1                                               236461
     C                   EVAL      PFILE = 'SDCUSTL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C     ERtvCust      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCTax - Retrieve Customer Tax Details
      *****************************************************************
     C     SRRtvCTax     BEGSR

     C     KCustTax      KLIST
     C                   KFLD                    KCTAX
     C                   KFLD                    KCOLC

      ** Access Customer by Country of Tax

     C     KCustTax      CHAIN     SDCTTXL1

      ** No Record Found, access customer with blank Country Location

     C                   IF        NOT %FOUND(SDCTTXL1)
     C                   EVAL      KCOLC = *Blanks
     C     KCustTax      CHAIN     SDCTTXL1

     C*******            IF        NOT %FOUND(SDCTTXL1)                                       235303
     C                   IF        NOT %FOUND(SDCTTXL1)  OR                                   235303
     C                             EWTXS1 = 'E'                                               235303
     C                   EVAL      PRTRN = 'NOTAX  '
     C***************    RETURN                                                               236065
     C                   RETURN                                                               235663
     C                   ENDIF
     C                   ENDIF

     C     ERtvCTax      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCntyCode - Retrieve Country Code
      *****************************************************************
     C     SRCntyCode    BEGSR

      ** Access Country Code

     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCountry
     C     SDCTRY        PARM      SDCTRY        DSFDY

      ** No Record Found/ Error Encountered

     C                   IF        PRtcd <> *BLANKS
     C                   MOVEL     PCTAX         PKEY
     C                   EVAL      PFILE = 'SDCTRYL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C     ECntyCode     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER048
      *                                                               *                       CER048
      *  SRCalcStax - Calculate Secondary Tax Details                                         CER048
      *                                                               *                       CER048
      *  Called by: MAIN Processing                                   *                       CER048
      *                                                               *                       CER048
      *  Calls: None                                                  *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCalcStax    BEGSR                                                                CER048
      *                                                                                       CER048
     C**********         EVAL      WToti = PTOTI                                     CER048 BUG22911
     C**********         IF        WToti < *Zero                                   BUG22953 BUG22911
     C**********         EVAL      WToti = WToti * -1                              BUG22953 BUG22911
     C**********         ENDIF                                                     BUG22953 BUG22911
     C**********         EVAL      WCuth = *ZEROS                                    CER048 BUG22911
     C**********         EVAL      WUtth = *ZEROS                                  BUG22754 BUG22911
     C**********         EVAL      WORate = *ZEROS                                 BUG22754 BUG22911
     C**********         EVAL      WODecP = *ZEROS                                 BUG22754 BUG22911
     C**********         EVAL      WOMdin = *BLANKS                                BUG22754 BUG22911
     C**********         EVAL      WSchk = *ZEROS                                    CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Applying*Threshold,*if*any*on*Taxable*Amount                                CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         IF        PInth = 'T' AND EWTHMD = 'Y'                      CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Check*for*threshold*details*in*interest*payment*history*file                CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C*****PCUST         CHAIN     SDINPHL1                                          CER048 BUG22911
     C**********         IF        %FOUND(SDINPHL1)                                  CER048 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      WUtth = TIUTTH                                  BUG22754 BUG22911
     C**********         EVAL      WCuth = TICUTH                                  BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
      ***Currency*Details*for*Tax*Currency                                         BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      PCcy = PTXCY                                    BUG22754 BUG22911
     C**********         EXSR      SRCurrDetl                                      BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         IF        PRtcd = *BLANKS                                 BUG22754 BUG22911
     C**********         EVAL      WORate = A6SPRT                                 BUG22754 BUG22911
     C**********         EVAL      WODecP = A6NBDP                                 BUG22754 BUG22911
     C**********         EVAL      WOMdin = A6MDIN                                 BUG22754 BUG22911
     C**********         ENDIF                                                     BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
      ***Tax*Currency*not*equal*to*base*currency,*perform*conversion               BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         IF        PTXCY <> BJCYCD                                 BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
      ***Currency*Details*for*Base*Currency                                        BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      PCcy = BJCYCD                                   BUG22754 BUG22911
     C**********         EXSR      SRCurrDetl                                      BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      ZAMTF = WCuth                                   BUG22754 BUG22911
     C**********         EXSR      SRExchDetl                                      BUG22754 BUG22911
     C**********         EVAL      WCuth = ZAMTT                                   BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      ZAMTF = WUtth                                   BUG22754 BUG22911
     C**********         EXSR      SRExchDetl                                      BUG22754 BUG22911
     C**********         EVAL      WUtth = ZAMTT                                   BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         ENDIF                                                     BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      WCuth = WCuth * (10 ** WODecP)                  BUG22754 BUG22911
     C**********         EVAL      WUtth = WUtth * (10 ** WODecP)                  BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      WSchk = WToti + TIUTTH                   CER048 BUG22754 BUG22911
     C**********         EVAL      WSchk = WToti + WUtth                           BUG22754 BUG22911
     C**********         EVAL      WCuth = TICUTH                           CER048 BUG22754 BUG22911
     C**********         EVAL      WToti = WSchk - WCuth                             CER048 BUG22911
     C**********         ENDIF                                                       CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         IF        WSchk <= WCuth                                    CER048 BUG22911
     C**********         EVAL      WToti = *ZEROS                                    CER048 BUG22911
     C**********         ENDIF                                                       CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         ENDIF                                                       CER048 BUG22911
      *                                                                                     BUG23657
      ** Clear / Populate DS/SDTXDT                                                         BUG23657
     C                   EVAL      PEVDT = E5EVDT                                           BUG23657
     C                   EVAL      PEXDT = E5ETXT                                           BUG23657
      *                                                                                     BUG22911
      ** Check Threshold                                                                    BUG22911
      *                                                                                     BUG22911
     C                   CALL      'ZATXCLTH'                                               BUG22911
      *                                                                                     BUG22911
      ** Input Parameters                                                                   BUG22911
      *                                                                                     BUG22911
      *                                                                                     BUG22911
      ** Interest Taxable                                                                   BUG22911
      *                                                                                     BUG22911
     C                   PARM                    PINTH                                      BUG22911
      *                                                                                     BUG22911
      ** Threshold Method                                                                   BUG22911
      *                                                                                     BUG22911
     C                   PARM                    EWTHMD                                     BUG22911
      *                                                                                     BUG22911
      ** Gross Interest                                                                     BUG22911
      *                                                                                     BUG22911
     C                   PARM                    PTOTI                                      BUG22911
      *                                                                                     BUG22911
      ** Customer                                                                           BUG22911
      *                                                                                     BUG22911
     C                   PARM                    PCUST                                      BUG22911
      *                                                                                     BUG22911
      ** Non Account Holder                                                                 BUG26979
      *                                                                                     BUG26979
     C                   PARM      *BLANK        PNARF                                      BUG26979
      *                                                                                     BUG26979
      ** Original Currency                                                                  BUG22911
      *                                                                                     BUG22911
     C                   PARM                    POCCY                                      BUG22911
      *                                                                                     BUG23657
      ** Exemption and Certificate Dates                                                    BUG23657
     C                   PARM                    SDTXDT                                     BUG23657
      *                                                                                     BUG22911
      ** Joint Management Account Type                                                      BUG26839
     C                   PARM      A4JAMG        PJAMG             1                        BUG26839
      ** Output Parameters                                                                  BUG22911
      *                                                                                     BUG22911
      *                                                                                     BUG22911
      ** Output Gross Interest                                                              BUG22911
      *                                                                                     BUG22911
     C                   PARM      *ZEROS        WTOTO                                      BUG22911
      *                                                                                     BUG22911
      ** Utilisation up to Threshold                                                        BUG22911
      *                                                                                     BUG22911
     C                   PARM      *ZEROS        PUTIL                                      BUG22911
      *                                                                                     BUG22911
      ** Portion of Threshold                                                               BUG22911
      *                                                                                     BUG22911
     C                   PARM      *ZEROS        PPORT                                      BUG22911
      *                                                                                     BUG22911
      ** Database Error Key                                                                 BUG22911
      *                                                                                     BUG22911
     C                   PARM      *BLANKS       PKEY                                       BUG22911
      *                                                                                     BUG22911
      ** Database Error File                                                                BUG22911
      *                                                                                     BUG22911
     C                   PARM      *BLANKS       PFILE                                      BUG22911
      *                                                                                     BUG22911
      ** Return Code                                                                        BUG22911
      *                                                                                     BUG22911
     C**********         PARM      *BLANKS       PRTRN                             BUG22911 BUG23071
      *                                                                                     BUG23071
     C                   PARM      *BLANKS       P@TRN                                      BUG23071
      *                                                                                     BUG22911
     C**********         IF        PRTRN <> *BLANKS                                BUG22911 BUG23071
     C                   IF        P@TRN <> *BLANKS                                         BUG23071
     C                   RETURN                                                             BUG22911
     C                   ENDIF                                                              BUG22911
      *                                                                                     BUG22911
     C**********         IF        WToto < *Zero                                  BUG22911 BUG22953A
     C**********         EVAL      WToto = WToto * -1                             BUG22911 BUG22953A
     C**********         ENDIF                                                    BUG22911 BUG22953A
      *                                                                                     BUG22911
     C**********         EVAL      PTOTI = WTOTO                                   BUG22911 BUG24051
     C**********         EVAL      PTOTO = WTOTO                                   BUG24051 BUG24521
     C**********         EVAL      PTOTO = WTOTO                                  BUG24630 BUG24630A
     C                   EVAL      WTaxable = WTOTO                                         BUG24521
      *                                                                                       CER048
      ** Set Output Parameters Secondary Tax Account Code and Tax                             CER048
      ** Basket                                                                               CER048
      *                                                                                       CER048
     C                   MOVE      EWSTAC        PStac                                        CER048
     C                   MOVE      EWSTXB        PStxb                                        CER048
      *                                                                                       CER048
      ** Build a key list to retrieve tax rate and transition type                            CER048
      *                                                                                       CER048
     C     KSecTaxBS     KLIST                                                                CER048
     C                   KFLD                    KCttx                                        CER048
     C                   KFLD                    KStxbs                                       CER048
     C                   KFLD                    KEffDate                                     CER048
      *                                                                                       CER048
     C     KSecTaxBS1    KLIST                                                                CER048
     C                   KFLD                    KCTTX                                        CER048
     C                   KFLD                    KStxbs                                       CER048
      *                                                                                       CER048
     C                   EVAL      KCttx = EWCTRT                                             CER048
     C                   MOVE      PStxb         KStxbs                                       CER048
      *                                                                                       CER048
     C**********         IF        PENDD <> *ZEROS                                   CER048 BUG22911
     C**********         EVAL      KEffDate = PENDD                                  CER048 BUG22911
     C**********         ELSE                                                        CER048 BUG22911
     C**********         EVAL      KEffDate = BJRDNB                                 CER048 BUG22911
     C**********         ENDIF                                                       CER048 BUG22911
      *                                                                                       CER048
      ** Set Output Parameters Secondary Tax Rate and Transition Type                         CER048
      *                                                                                       CER048
     C     KSecTaxBS     SETGT     SDTXBSL1                                                   CER048
     C     KSecTaxBS1    READPE    SDTXBSL1                                                   CER048
     C                   IF        NOT %EOF(SDTXBSL1)                                         CER048
     C                   EVAL      PSttr = TBTRAB                                             CER048
     C                   EVAL      PSttp = TBTRTY                                             CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      PSttr = *ZEROS                                             CER048
     C                   EVAL      PSttp = *BLANKS                                            CER048
     C                   ENDIF                                                                CER048
      **********                                                                     CER048 BUG22911
      ***Calculate*Tax*Amount*and*Secondary*Tax                                      CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         EVAL(H)   PTAXA = (WToti * PTXR1) / 100                     CER048 BUG22911
     C**********         EVAL(H)   PStxa = (PTAXA * PSttr) / 100                     CER048 BUG22911
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      ***SRCurrDetl*-*Get*the*Currency*Details*************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      ***Called*by:*SRCalcStax*****************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      ***Calls:*None***************************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
     C*****SRCurrDetl    BEGSR                                                     BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         CALL      'AOCURRR0'                                      BUG22754 BUG22911
     C**********         PARM      *BLANKS       PRtcd                             BUG22754 BUG22911
     C**********         PARM      '*KEY   '     POptn                             BUG22754 BUG22911
     C**********         PARM                    PCcy                              BUG22754 BUG22911
     C*****SDCURR        PARM      SDCURR        DSSDY                             BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         ENDSR                                                     BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      */EJECT***                                                                   BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      ***SRExchDetl*-*Currency*Conversion*on*Amount*Fields*************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      ***Called*by:*SRCalcStax*****************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      ***Calls:*None***************************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
     C*****SRExchDetl    BEGSR                                                     BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
      ***Convert*the*Amounts*in*Tax*Currency*from*Base*Currency                    BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EVAL      ZCDPF = A6NBDP                                  BUG22754 BUG22911
     C**********         EVAL      ZCDPT = WODecp                                  BUG22754 BUG22911
     C**********         EVAL      ZCRSRT = WORate                                 BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         IF        WOMdin = 'M'                                    BUG22754 BUG22911
     C**********         EVAL      ZCRSMD = 'D'                                    BUG22754 BUG22911
     C**********         ELSE                                                      BUG22754 BUG22911
     C**********         EVAL      ZCRSMD = 'M'                                    BUG22754 BUG22911
     C**********         ENDIF                                                     BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         EXSR      ZCCYXR                                          BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     C**********         ENDSR                                                     BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      */EJECT***                                                                   BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      */COPY*ZSRSRC,ZCCYXR_ILE                                                     BUG22754 BUG22911
      *****************************************************************            BUG22754 BUG22911
      */EJECT***                                                                   BUG22754 BUG22911
      *****************************************************************                       CER054
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      * SRRtvRelgAffn - Retrieve Religious Affiliation Codes details  *                       CER054
      *****************************************************************                       CER054
     C     SRRtvRelgAffn BEGSR                                                                CER054
      *                                                                                       CER054
      ** Access Religious Affiliation Codes file                                              CER054
      *                                                                                       CER054
     C     KRLAF         CHAIN     SDRLAFL0                                                   CER054
                                                                                              CER054
     C                   IF        NOT %FOUND(SDRLAFL0)                                       CER054
     C                   EVAL      PKEY = KRLAF                                               CER054
     C                   EVAL      PFILE = 'SDRLAFL0  '                                       CER054
     C                   EVAL      PRTRN = 'ERROR   '                                         CER054
     C                   DUMP                                                               BUG24029
     C                   RETURN                                                               CER054
     C                   END                                                                  CER054
                                                                                              CER054
     C                   EVAL      PRlaf = AFRLAF                                             CER054
                                                                                              CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      * SRRtvGrmState - Retrieve State Codes details                  *                       CER054
      *****************************************************************                       CER054
     C     SRRtvGrmState BEGSR                                                                CER054
      *                                                                                       CER054
      ** Access Federal States Codes file                                                     CER054
      *                                                                                     MD053600
     C                   IF        PCUST <> *BLANKS                                         MD053600
     C                   EVAL      KSTCD = E5STCD                                           MD053600
     C                   ENDIF                                                              MD053600
      *                                                                                       CER054
     C                   IF        CER054 = 'N' and KSTCD = *BLANKS                         BUG26581
     C                   EVAL      PStcd = *BLANKS                                          BUG26581
     C                   ELSE                                                               BUG26581
     C     KSTCD         CHAIN     SDGESTL0                                                   CER054
                                                                                              CER054
     C                   IF        NOT %FOUND(SDGESTL0)                                       CER054
     C                   EVAL      PKEY = KSTCD                                               CER054
     C                   EVAL      PFILE = 'SDGESTL0  '                                       CER054
     C                   EVAL      PRTRN = 'ERROR   '                                         CER054
     C                   DUMP                                                               BUG24029
     C                   RETURN                                                               CER054
     C                   END                                                                  CER054
                                                                                              CER054
     C                   EVAL      PStcd = GESTCD                                             CER054
     C                   END                                                                BUG26581
                                                                                              CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER054
      /EJECT                                                                                  CER054
      *****************************************************************                       CER054
      * SRRtrvTtax - Retrieve Third Tax Rate                          *                       CER054
      *****************************************************************                       CER054
     C     SRRtrvTtax    BEGSR                                                                CER054
      *                                                                                       CER054
      ** Retrieve religious affiliation details                                               CER054
      *                                                                                       CER054
     C                   EVAL      KRLAF = E5RLAF                                             CER054
     C                   EXSR      SRRtvRelgAffn                                              CER054
      *                                                                                       CER054
      ** Retrieve state details                                                               CER054
      *                                                                                       CER054
     C                   EVAL      WRLAF = %XLATE(LO:UP:E5RLAF)                               CER054
                                                                                              CER054
     C                   IF        E5STCD <> *BLANKS                                        BUG26703
     C                   EVAL      KSTCD = E5STCD                                           BUG26703
     C                   EXSR      SRRtvGrmState                                            BUG26703
     C                   ENDIF                                                              BUG26703
     C                   IF        WRLAF <> 'NONE'                                            CER054
     C                             AND E5STCD <> *BLANKS                                    BUG24016
     C**********         EVAL      KSTCD = E5STCD                                    CER054 BUG26703
     C**********         EXSR      SRRtvGrmState                                     CER054 BUG26703
     C                   MOVE      GETXBS        PTtxb                                      BUG24053
     C                   ELSE                                                               BUG24053
     C                   MOVE      *BLANKS       PTtxb                                      BUG24053
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Set Output Parameters Third Tax Account Code and Tax Basket                          CER054
      *                                                                                       CER054
     C                   MOVE      EWTTAC        PTtac                                        CER054
     C**********         MOVE      GETXBS        PTtxb                               CER054 BUG24053
      *                                                                                       CER054
      ** Build a key list to retrieve tax rate and transition type                            CER054
      *                                                                                       CER054
     C     K3rdTaxBS     KLIST                                                                CER054
     C                   KFLD                    KCttx                                        CER054
     C                   KFLD                    KTtxbs                                       CER054
     C                   KFLD                    KEffDate                                     CER054
                                                                                              CER054
     C     K3rdTaxBS1    KLIST                                                                CER054
     C                   KFLD                    KCttx                                        CER054
     C                   KFLD                    KTtxbs                                       CER054
                                                                                              CER054
     C                   EVAL      KCttx = EWCTRT                                             CER054
     C                   MOVE      PTtxb         KTtxbs                                       CER054
      *                                                                                       CER054
      ** Set Output Parameters Third Tax Rate                                                 CER054
      *                                                                                       CER054
     C     K3rdTaxBS     SETGT     SDTXBSL1                                                   CER054
     C     K3rdTaxBS1    READPE    SDTXBSL1                                                   CER054
     C                   IF        NOT %EOF(SDTXBSL1)                                         CER054
     C                             AND EWTEDT <= BJRDNB                                       CER054
     C                   EVAL      PTttr = TBTRAB                                             CER054
     C                   EVAL      PTttp = TBTRTY                                             CER054
     C                   ELSE                                                                 CER054
     C                   EVAL      PTttr = *ZEROS                                             CER054
     C                   EVAL      PTttp = *BLANKS                                            CER054
     C                   ENDIF                                                                CER054
                                                                                              CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER069
      /EJECT                                                                                  CER069
      *****************************************************************                       CER069
      * SRTSCH - Set-up correct tax values if tax flag is 'A'         *                       CER069
      *****************************************************************                       CER069
     C     SRTSCH        BEGSR                                                                CER069
      *                                                                                       CER069
      * Perform processing only when PINTH is 'A'                                             CER069
      * 'A' = signifies usage of Tax Flag defined at Customer Level                           CER069
     C                   IF        PINTH = 'A'                                                CER069
      *                                                                                       CER069
      * If coming from dealing or retail interest capitalisation                              CER069
     C                   IF        PSJobName = 'DLC0606B'                                     CER069
     C                             OR PSJobName = 'REC62A'                                    CER069
     C                             OR PSJobName = 'REC62N'                                    CER069
      * If Customer is flagged as Self Reporting, Exempt or Disclosed, check if               CER069
      * Certificate details have been defined. If so and Certificate Expiry date              CER069
      * is actually prior to date interest is due to be paid, set the Customer status         CER069
      * to be taxable.                                                                        CER069
     C                   IF        (AXETXS = 'S' or AXETXS = 'D'                              CER069
     C                             or AXETXS = 'E') and AXCEEX <> 0                           CER069
     C**********                   and AXCEEX <= PENDD                               CER069 MD030924
     C                             and AXCEEX < PENDD                                       MD030924
     C                   MOVE      'Y'           TaxChg                                       CER069
     C                   IF        E5EVDT = 0                                                 CER069
     C                   EVAL      AXETXS = 'Y'                                               CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      AXETXS = 'T'                                               CER069
     C                   ENDIF                                                                CER069
     C                   ENDIF                                                                CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
      * Set Interest Threshold flag (PINTH) to be N (Non-taxable) when                        CER069
      * tax indicator is 'S','E',or 'D', otherwise set PINTH to be                            CER069
      * equal to AXETXS value                                                                 CER069
      *                                                                                       CER069
     C                   IF        AXETXS='S' or AXETXS='E' or AXETXS='D'                     CER069
     C                   EVAL      PINTH = 'N'                                                CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      PINTH = AXETXS                                             CER069
     C                   ENDIF                                                                CER069
     C                                                                                        CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
     C                   ENDSR                                                                CER069
      *****************************************************************                       CER054
      /EJECT                                                                                  CER054
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** INPUTS
      ** Module ID
     C                   PARM                    PMODI

      ** Transaction Reference
     C                   PARM                    PTRRF

      ** Booking Branch
     C                   PARM                    PBRCA

      ** Customer Number
     C                   PARM                    PCUST

      ** Interest Calculation Start Date
     C                   PARM                    PSTRD

      ** Interest Calculation End Date
     C                   PARM                    PENDD

      ** Total Interest Amount
     C                   PARM                    PTOTI

      ** Tax Rate Applicable for Band
     C                   PARM                    PTAXR

      ** Original Currency
     C                   PARM                    POCCY
      *                                                                                       CER048
      ** Threshold Indicator                                                                  CER048
      *                                                                                       CER048
     C                   PARM                    PInth                                        CER048

      ** OUTPUTS
      ** Interest Amount at Effective Date
     C                   PARM                    PIAED

      ** Tax Amount
     C                   PARM                    PTAXA

      ** Interest Amount
     C                   PARM                    PTOTO

      ** Tax Currency
     C                   PARM                    PTXCY

      ** Country of Tax
     C                   PARM                    PCTAX

      ** Tax Basket
     C                   PARM                    PTXBS

      ** EU Withholding Tax Account Code
     C                   PARM                    PWTAC

      ** Country of Location
     C                   PARM                    PCOLC

      ** Customer Status
     C                   PARM                    PSTAT

      ** Transition Type at End
     C                   PARM                    PTRTE

      ** Tax Rate of Tax Period
     C                   PARM                    PTXR1
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Basket                                                        CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStxb                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary Tax Account Code                                                  CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStac                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary Tax Rate                                                          CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PSttr                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary Transition Type                                                   CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PSttp                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary Tax Amount                                                        CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStxa                               CER048 BUG22911

      ** Database Error Key
     C                   PARM                    PKEY

      ** Database Error File
     C                   PARM                    PFILE

      ** Return Code
     C                   PARM                    PRTRN
      *                                                                                     BUG22911
      ** Secondary Tax Parameters                                                           BUG22911
      *                                                                                     BUG22911
     C                   PARM      SDTXPA        DSSDY                                      BUG22911

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CER048
      ** Test if CER048 is installed                                                          CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF'                                            CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 002                                                CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ENDIF                                                                CER048

      *                                                                                       CER054
      ** Test if CER054 is installed                                                          CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   ELSE                                                                 CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Database error                                                                       CER054
      *                                                                                       CER054
     C                   IF        PRtcd <> *BLANKS AND                                       CER054
     C                             PRtcd <> '*NRF'                                            CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBASE = 003                                                CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
                                                                                              CER054
      ** Test if CER069 is installed                                                          CER069
      *                                                                                       CER069
     C                   CALL      'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtcd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
      *                                                                                       CER069
     C                   IF        PRtcd = *BLANKS                                            CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      CER069 = 'N'                                               CER069
     C                   ENDIF                                                                CER069
      *                                                                                       CER069
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       236399
      *                                                               *                       236399
      * *PSSR  - Program exception error routine                      *                       236399
      *          Called automatically if a program error occurs,      *                       236399
      *          or directly by the program code using EXSR.          *                       236399
      *          This subroutine DUMPs the program just once.         *                       236399
      *                                                               *                       236399
      * Called by: (**calling routines**)                             *                       236399
      *                                                               *                       236399
      * Calls:                                                        *                       236399
      *                                                               *                       236399
      *****************************************************************                       236399
      *                                                                                       236399
     C     *PSSR         BEGSR                                                                236399
      *                                                                                       236399
     C     @RUN          IFEQ      *BLANK                                                     236399
     C                   MOVE      'Y'           @RUN              1                          236399
     C                   DUMP                                                                 236399
     C                   ENDIF                                                                236399
      *                                                                                       236399
     C                   EVAL      PRTRN = 'ERROR  '                                          236399
     C                   EVAL      *INU7 = *ON                                                236399
     C                   EVAL      *INU8 = *ON                                                236399
     C                   EVAL      *INLR = *ON                                                236399
     C                   RETURN                                                               236399
      *                                                                                       236399
     C                   ENDSR                                                                236399
      ********************************************************************
      ***/COPY*ZACPYSRC,PSSR_ILE
      ********************************************************************
      *                                                                                     BUG22911
      ** The Following Array Data has been Physically Deleted                               BUG22911
      ** POWER - ARRAY OF POWERS FOR CURRENCY*CONVERSION                                    BUG22911
      ** 0000001                                                                            BUG22911
      ** 0000010                                                                            BUG22911
      ** 0000100                                                                            BUG22911
      ** 0001000                                                                            BUG22911
      ** 0010000                                                                            BUG22911
      ** 0100000                                                                            BUG22911
      ** 1000000                                                                            BUG22911
      *                                                                                     BUG22911
