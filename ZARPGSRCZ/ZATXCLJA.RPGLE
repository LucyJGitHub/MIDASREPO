     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA European W/Tax Calculation for Joint Acc.')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZATXCLJA - European Withholding Tax Calculation for          *
      *             Joint Accounts                                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 MD030924           Date 07Oct14               *
      *                 CER069             Date 03Jul14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR744769           Date 28Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26979           Date 22Jan10               *
      *                 BUG26938           Date 21Jan10               *
      *                 BUG26869           Date 13Jan10               *
      *                 BUG26839           Date 05Jan10               *
      *                 BUG26833           Date 09Dec09               *
      *                 BUG26790           Date 27Nov09               *
      *                 BUG26581           Date 13Nov09               *
      *                 BUG26692           Date 11Nov09               *
      *                 BUG26703           Date 09Nov09               *
      *                 BUG26206           Date 02Oct09               *
      *                 BUG24197           Date 02Jun09               *
      *                 BUG24630A          Date 02Jul09               *
      *                 BUG24630           Date 01Jul09               *
      *                 BUG24521           Date 23Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24029           Date 19May09               *
      *                 BUG24053           Date 20May09               *
      *                 BUG24016           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23657A          Date 22Apr09               *
      *                 BUG23657           Date 13Apr09               *
      *                 BUG23090           Date 25Feb09               *
      *                 BUG22953A          Date 25Feb09               *
      *                 BUG23071           Date 23Feb09               *
      *                 BUG22911           Date 17Feb09               *
      *                 BUG22953           Date 17Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22580           Date 02Feb09               *
      *                 BUG22754           Date 10Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 236461             Date 18Oct05               *
      *                 236399             Date 17Oct05               *
      *                 235663             Date 29Sep05               *
      *                 236065             Date 13Sep05               *
      *                 235303             Date 03Aug05               *
      *                 235045             Date 17Jul05               *
      *                 236825             Date 26Jun05               *
      *                 233795             Date 30May05               *
      *                 233269             Date 27Apr05               *
      *                 233252             Date 27Apr05               *
      *                 233251             Date 27Apr05               *
      *                 232543             Date 01Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD030924 - For Customer combi S with Transaction Tax         *
      *             Indicator A, taxes were computed                  *
      *  CER069 - German Tax Enhancement                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR744769 - Total tax amount discrepancy brought by rounding  *
      *             off issue (Child: AR744770)                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26979 - Serious Midas error encountered while trying      *
      *             to roll-over                                      *
      *  BUG26938 - Non-account holders as members are not taxed      *
      *             (based on BRD 2.07 version )                      *
      *  BUG26869 - No tax calculated for Joint customer with NAH as  *
      *             members (Recompile)                               *
      *  BUG26876 - JA2_Incorrect computation/posting of EU Tax on    *
      *             a retail account                                  *
      *  BUG26839 - JA1_Threshold limit of the main joint customer was*
      *             utilized by the member                            *
      *  BUG26833 - DLC0603 00001                                     *
      *  BUG26790 - DLC0606B 00001 Database error in SDACUSPD         *
      *  BUG26581 - Federal State Code used has zero amount           *
      *  BUG26692 - Double Postings of MM Interest in the Limit       *
      *             Utilisation Enquiry                               *
      *  BUG26703 - SD200205P1 report does not break the data down    *
      *             by state code                                     *
      *  BUG26206 - Incorrect EU tax calculation                      *
      *  BUG24197 - Incorrect Gross Interest                          *
      *              Applied as 24521.                                *
      *  BUG24630A - In MM and Retail Interest Calculation Threshold  *
      *              is not being Deducted.                           *
      *  BUG24630 - In MM and Retail Interest Calculation Threshold is*
      *              not being Deducted.                              *
      *  BUG24521 - Utilisation at Joint Account was not reflected    *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG24053 - Non taxable transaction generated third tax in    *
      *             SDCSINPD                                          *
      *  BUG24016 - Blank State Code is not handled                   *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23657A - Threshold/Certificate Value date and Expiry Date *
      *              re-open non-account holder not considered        *
      *  BUG23657 - Threshold/Certificate Value date and expiry date  *
      *  BUG23090 - Used DSLDY instead of DSSDY to prevent looping    *
      *             after producing dump in DL1705                    *
      *  BUG22953A - Secondary and Main tax not calculated on OSIC    *
      *  BUG23071 - Cannot do the roll over for Money market          *
      *  BUG22911 - Changes for Correct Tax Calculation               *
      *  BUG22953 - Secondary and Main tax not calculated on OSIC     *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  BUG22754 - Incorrect main and secondary tax calculations     *
      *  CER034A - LF046 German Features - New Fields and Enquiries   *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  236461 - Change access object for customer to also consider  *
      *           'Closed' customer.                                  *
      *  236399 - Decimal data error due to field BJRDNB being blank. *
      *           Call AOBANKR0 to load SDBANKPD.  Also, directly     *
      *           coded *PSSR, so that for any exemption error,       *
      *           return parameter 'ERROR' will be returned, for      *
      *           calling program to fail or end in error.            *
      *  235663 - Retrieve correct Tax Basket record                  *
      *           reversing out 236065 as this is a better fix        *
      *  236065 - Incorrect detail for customer with No Tax           *
      *  235303 - Customer Tax details error                          *
      *  235045 - Tax wrongly caluclated for 0/100                    *
      *           Incorrect detail for customer with No Tax           *
      *  236825 - Tax wrongly rounded                                 *
      *  233795 - Tax amount 10x higher if Joint Customer.            *
      *  233269 - Errors on ZATXCLJA and ZATXCLPI (Recompile)         *
      *  233252 - ZATXCLJA must consider joint account type           *
      *  233251 - ZATXCLJA fields incorrectly setup                   *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         End of file SDTXBSL1                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRtvTaxDet - Retrieve Tax Details                           *
      *  SRRtvIntDet - Retrieve Interest Details                      *
      *  SRCalIntAmt - Calculate Interest Amount at Effective Date    *
      *  SRRtvTaxRate - Retrieve Tax Period and Tax Rate              *
      *  SRCalTaxAmt - Calculate Tax Amount                           *
      *  SRRtvBranch - Retrieve Branch Details                        *
      *  SRRtvLoc - Retrieve Location                                 *
      *  SRCntyCode - Retrieve Country Code                           *
      *  SRJointAccDet - Joint Account Details                        *
      *  SRRtvCustTax - Retrieve Customer by Country of Tax           *
      *  SRRtvCust - Retrieve Customer Details                        *
      *  SRRtvNAHOTax - Access Non Account Holder Tax Details         *
      *  SRRtvNonAcc - Access Non Account Holder details              *
      *  SRRtvTxBasket - Retrieve Tax Basket                          *
      *  SRInvtRatio - Determine ratio of investment proportion       *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Joint Account Details by Joint/Cust
     FSDJACCL5  IF   E           K DISK    INFSR(*PSSR)

      ** Joint Account Details by Joint/Non Accnt Holder
     FSDJACCL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD6)

      ** Customer Details by Country of Tax
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)

      ** Country of Tax Codes
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)

      ** Tax Basket Details
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)

      ** Non-account Holders by Country of Tax
     FSDNHTXL1  IF   E           K DISK    INFSR(*PSSR)

      ***EU*Tax*Accruals*at*Effective Dates****************************                       233269
     F***GLETXAL1  UF   E           K DISK    INFSR(*PSSR)                                    233269
      **********                                                                     CER048 BUG22911
      ***Interest*Payment*History*File                                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
     F***SDINPHL1  IF   E           K DISK    INFSR(*PSSR)                           CER048 BUG22911
                                                                                              CER054
      ** Federal State Codes Keyed By State Codes                                             CER054
     FSDGESTL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054
                                                                                              CER054
      ** Religious Affiliation Codes Keyed by Religious Affiliation                           CER054
     FSDRLAFL0  IF   E           K DISK    INFSR(*PSSR)                                       CER054

      ** Midas SD Tax Status Changes Details                                                  CER069
     FSDTSCHPD  O    E           K DISK    INFSR(*PSSR)                                       CER069
                                                                                              CER069
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
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
      **********                                                                   BUG22754 BUG22911
      ***Array*containing*powers*for*Ccy*conversion                                BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     D*Power****       S              7  3 DIM(7) CTDATA PERRCD(1)                 BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External DS for Additional Customer Details                                          233252
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                  233252
                                                                                              233252
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035

      ** External DS for Country Codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** External DS for Location Codes
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)

      ** External DS for Non-Account Holders
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *                                                                                       CER048
      ** External DS for Sar Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048

      ** External DS for Short-data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for Long-data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              236461
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     236461
      **********                                                                   BUG22754 BUG22911
      ***External*DS*for*Currency*Details                                          BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     D*SDCURR***     E DS                  EXTNAME(SDCURRPD)                       BUG22754 BUG22911
      *                                                                                     BUG22911
      ** Midas SD Tax Parameter File                                                        BUG22911
      *                                                                                     BUG22911
     D SDTXPA        E DS                  EXTNAME(SDTXPAPD)                                BUG22911
      *
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
     D PJANO           S              6A
     D PCUST           S              6A
     D PNARF           S             10A
     D PINVP           S             10A
     D PPAHT           S              1A                                                    BUG26839
     D PSTRD           S              5P 0
     D PENDD           S              5P 0
     D PTOTI           S             15P 0
     D PTAXR           S              6P 4
     D POCCY           S              3A
     D PInth           S              1A                                                      CER048

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
     D PJAMG           S              1A
     D*PStxb****       S              2P 0                                           CER048 BUG22911
     D*PStac****       S             10P 0                                           CER048 BUG22911
     D*PSttr****       S              6P 4                                           CER048 BUG22911
     D*PSttp****       S              1A                                             CER048 BUG22911
     D*PStxa****       S             15P 0                                           CER048 BUG22911
     D PKEY            S             10A
     D PFILE           S             10A
     D PRTRN           S              7A
     D PNonAccnt       S                   LIKE(PNARF)
     D P@TRN           S              7A                                                    BUG23071

      ** Work Fields
     D WEDAT           S              5P 0
     D WTRTS           S              1A
     D WSTR1           S              5P 0
     D WEND1           S              5P 0
     D WACC1           S             15P 0
     D WTXR1           S              6P 4
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
     D WETXS           S              1A
     D WPosition       S              5  0
     D WMulValue       S              5  0
     D WDivValue       S              5  0
     D WStart          S              5  0
     D WEnd            S              5  0
     D WRead           S              2  0
     D WNumerator      S              5A
     D WDenominator    S              5A
     D WPTXR           S              6P 4                                                  AR744769
     D*WCuth****       S             15P 0                                           CER048 BUG22911
     D*WSchk****       S             15P 0                                           CER048 BUG22911
     D WToto           S             15P 0                                                    CER048
     D WTaxable        S             15P 0                                                  BUG24521
     D***WPrevEAACCR     S                   LIKE(EAACCR)                                     233269
     D InvolveCust     S                   LIKE(PCUST)
     D InvolveNARF     S                   LIKE(PNARF)
     D InvolveINVP     S                   LIKE(PINVP)
     D Tax1            S             15  0
     D Tax2            S             15  0
     D Tax3            S             15  0
     D Tax4            S             15  0
     D Tax5            S             15  0
     D WCntr           S              1  0
     D JCOLC           S              2A
     D WAudit          S              1A                                                      CER069
     D WTaxStat        S              1A                                                      CER069
     D WExpiry         S              5P 0                                                    CER069
     D WValDate        S              5P 0                                                    CER069
      *                                                                                       CER048
      ** German Taxes Feature                                                                 CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
     D CER069          S              1A                                                      CER069

      ** Key Fields
     D KJANO           S              6A
     D KNAHO           S             10A
     D KCUST           S              6A
     D KCTTX           S              2A
     D KCOLC           S                   LIKE(PCOLC)
     D KCTAX           S                   LIKE(PCTAX)
     D KEffDate        S                   LIKE(PENDD)
     D KModule         S                   LIKE(PMODI)
     D KTrRef          S                   LIKE(PTRRF)
     D KStxbs          S              2A                                                      CER048
      **********                                                                   BUG22754 BUG22911
     D PCcy            S              3A                                           BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     D*WUtth           S             15P 0                                         BUG22754 BUG22911
     D*WORate          S             13P 8                                         BUG22754 BUG22911
     D*WODecP          S              1P 0                                         BUG22754 BUG22911
     D*WOMdin          S              1A                                           BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
      ***Parameters*for*Conversion*Routine                                         BUG22754 BUG22911
      **********                                                                   BUG22754 BUG22911
     D*PAmtcI***       S             15P 0                                         BUG22754 BUG22911
     D*PAmtcO***       S             15P 0                                         BUG22754 BUG22911
                                                                                              CER054
     D WRLAF           S              4A                                                      CER054
                                                                                              CER054
      ** Third Tax Basket                                                                     CER054
     D KTtxbs          S              2A                                                      CER054
                                                                                              CER054
      ** State Codes                                                                          CER054
     D KSTCD           S              2A                                                      CER054
                                                                                              CER054
      ** Religious Affiliation Code                                                           CER054
     D KRLAF           S              4A                                                      CER054


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

     C                   EVAL      PStcd  = *BLANKS                                           CER054
     C                   EVAL      PRlaf  = *BLANKS                                           CER054
     C                   EVAL      PTtxb  = *ZEROS                                            CER054
     C                   EVAL      PTtac  = *ZEROS                                            CER054
     C                   EVAL      PTttr  = *ZEROS                                            CER054
     C                   EVAL      PTttp  = *BLANKS                                           CER054
     C                   EVAL      PTtxa  = *ZEROS                                            CER054
                                                                                              CER069
     C                   EVAL      WAudit = ' '                                               CER069
                                                                                              CER054
      ** Retrieve Tax Details: Customer Status, Tax Basket, Tax Currency Retrieval

     C                   EXSR      SRRtvTaxDet

     C*************      IF        PSTAT = 'DISCL'  OR                                       235045
     C*************                PSTAT = 'SELF '  OR                                       235045
     C*************                PSTAT = 'TAXAB'                                           235045

     C                   EXSR      SRInvtRatio

     C                   EVAL(H)   PTOTO = PTOTI * WMulValue / WDivValue
     C                   EVAL(H)   WTaxable = PTOTI * WMulValue / WDivValue                 BUG24521

     C**********         IF        PMODI <> 'S'                                               233269
      **********                                                                              233269
      ***Interest Accrued in the Different Periods Retrieval                                  233269
      **********                                                                              233269
     C**********         EXSR      SRRtvIntDet                                                233269
      **********                                                                              233269
      ***Interest Amount at Effective Date Calculation                                        233269
      **********                                                                              233269
     C**********         EXSR      SRCalIntAmt                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269
     C                   EVAL      PIAED  = PTOTI                                             233269
     C************       ENDIF                                                                235045

     C                   IF        PSTAT = 'TAXAB'

      ** Retrieve Tax Pariod and Tax Rates

     C**********         IF        PMODI <> 'S'                                               233269
     C                   EXSR      SRRtvTaxRate
     C**********         ENDIF                                                                233269

      ** Calculate Tax Amount

     C**********         EXSR      SRCalTaxAmt                                                233269
     C**********         EVAL      PTAXA = (PTOTO * PTXR1) / 100                       233269 236825
     C                   EVAL(H)   PTAXA = (PTOTO * PTXR1) / 100                              236825
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
                                                                                              CER054
     C**********         ELSE                                                        CER048 BUG22911
     C                   ENDIF                                                              BUG22911
      *                                                                                     BUG22911
     C**********         EVAL(H)   PTAXA = (PTOTO * PTXR1) / 100                     236825 BUG24521
     C                   EVAL(H)   PTAXA = (WTaxable * PTXR1) / 100                         BUG24521
     C                   IF        CER054 = 'Y' AND EWTTAM = 'Y'                              CER054
     C**********         EVAL      PTAXA = PTOTO / ( (100/PTXR1) + (PTttr/100) )    CER054 BUG24630A
     C**********         EVAL      PTAXA = WTaxable/((100/PTXR1) + (PTttr/100) )  BUG24630A AR744769
     C                   EVAL(H)   WPTXR = (100/PTXR1) + (PTttr/100)                        AR744769
     C                   EVAL(H)   PTAXA = WTaxable / WPTXR                                 AR744769
     C                   ENDIF                                                                CER054
      *                                                                                     BUG22911
     C                   IF        CER048 = 'Y'                                             BUG22911
     C                   EVAL(H)   PSTXA = (PTAXA * PSttr) / 100                            BUG22911
     C                   IF        CER054 = 'Y'                                               CER054
     C**********         EVAL      PTTXA = (PTAXA * PTttr) / 100                     CER054 AR744769
     C                   EVAL(H)   PTTXA = (PTAXA * PTttr) / 100                            AR744769
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        CER069 = 'Y' AND WAudit = 'Y'                              CER069
     C                   EVAL      TRCUST = BBCUST                                            CER069
     C                   EVAL      TRCRNM = BBCRNM                                            CER069
     C                   EVAL      TRCRTN = BBCRTN                                            CER069
     C                   EVAL      TRCOLC = PCOLC                                             CER069
     C                   EVAL      TRCVDT = WValDate                                          CER069
     C                   EVAL      TRCEEX = WExpiry                                           CER069
     C                   EVAL      TRETXS = WTaxStat                                          CER069
     C                   EVAL      TRDREF = PTRRF                                             CER069
     C                   EVAL      TRDDAT = PENDD                                             CER069
     C                   EVAL      TRCCY  = PTXCY                                             CER069
     C                   EVAL      TRGINT = PTOTO                                             CER069
     C                   EVAL      TRTTAX = PTAXA                                             CER069
     C                   WRITE     SDTSCHD0                                                   CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvTaxDet - Retrieve Tax Details
      *****************************************************************
     C     SRRtvTaxDet   BEGSR

      ** Retrieve Branch Details

     C                   EVAL      PBranch = PBRCA
     C                   EXSR      SRRtvBranch

      ** Retrieve Location

     C                   EVAL      PLocation = A8LCCD
     C                   EXSR      SRRtvLoc
     C                   EVAL      PCTAX = DVCNCD

      ** Retrieve Joint Account Details in SDCUSTL1

     C                   EVAL      PKey1 = *Blanks
     C                   MOVEL     PJANO         PKey1
     C                   EXSR      SRRtvCust
     C                   EVAL      JCOLC = BBCOLC

      ** Retrieve Country Code details

     C**********         EVAL      PCountry = JCOLC                                           233251
     C                   EVAL      PCountry = PCTAX                                           233251
     C                   EXSR      SRCntyCode

     C                   IF        A4JAMG = *Blanks  OR
     C                             A4JAMG = '0'
     C                   EVAL      PRTRN = 'NOTAX  '
     C***********        RETURN                                                               235045
     C                   ENDIF

      ** Retrieve Joint Account country of tax in SDACTXL1

     C                   EVAL      KCUST = PJANO
     C                   EVAL      KCTAX = PCTAX
     C                   EXSR      SRRtvCustTax
     C                   EVAL      WETXS = AXETXS

      ** Store value of passed PCUST, PNARF and PINVP

     C                   EVAL      InvolveCUST = PCUST
     C                   EVAL      InvolveNARF = PNARF
     C                   EVAL      InvolveINVP = PINVP

      ** If Customer is not blank

     C                   IF        PCUST <> *Blanks
      ** transfer code after validation of Joint Account Management (A4JAMG)                BUG26206
      **********                                                                            BUG26206
      **********                                                                     233252 BUG26206
      ***Retrieve Joint Account Type in SDACUSL1                                     233252 BUG26206
      **********                                                                     233252 BUG26206
     C**********         EVAL      PCustomer = PCUST                                 233252 BUG26206
     C**********         EXSR      SRRtvACust                                        233252 BUG26206
      **********                                                                            BUG26206
      ***Retrieve Customer Details in SDCUSTL1                                              BUG26206
      **********                                                                            BUG26206
     C**********         EVAL      PKey1 = *Blanks                                          BUG26206
     C**********         MOVEL     PCUST         PKey1                                      BUG26206
     C**********         EXSR      SRRtvCust                                                BUG26206
     C**********         EVAL      PCOLC = BBCOLC                                           BUG26206
      **********                                                                            BUG26206

      ** Retrieve country of tax in SDACTXL1
      *
     C                   EVAL      KCUST = PCUST
     C                   EVAL      KCTAX = PCTAX
     C                   EXSR      SRRtvCustTax
                                                                                            BUG26869
     C                   ENDIF                                                              BUG26869
                                                                                            BUG26869
     C                   IF        PCUST <> *BLANKS OR                                      BUG26869
     C                             A4JAMG = '3' AND PCUST = *BLANKS                         BUG26869

      ** If Joint Management Account is 1, 2 or 3

     C                   EVAL      PJAMG = A4JAMG

     C                   IF        A4JAMG = '1'  OR
     C                             A4JAMG = '2'  OR
     C                             A4JAMG = '3'
                                                                                              CER069
     C                   IF        CER069 = 'Y'                                               CER069
                                                                                              CER069
     C                   EVAL      WAudit = 'Y'                                               CER069
     C                   EVAL      WTaxStat = AXETXS                                          CER069
     C                   EVAL      WExpiry = AXCEEX                                           CER069
     C                   EVAL      WValDate = AXCVDT                                          CER069
     C                                                                                        CER069
     C                   ENDIF                                                                CER069

     C                   SELECT
     C                   WHEN      AXETXS = 'S'
     C                   EVAL      PSTAT = 'SELF '
     C                   EVAL      PRTRN = 'NOTAX  '

     C                   WHEN      AXETXS = 'D'
     C                   EVAL      PSTAT = 'DISCL'
     C                   EVAL      PRTRN = 'NOTAX  '

     C                   WHEN      AXETXS = 'E'
     C                   EVAL      PSTAT = 'NOTAP'
     C                   EVAL      PRTRN = 'NOTAX  '
     C**************     RETURN                                                               235045

     C                   OTHER
     C                   EVAL      PSTAT = 'TAXAB'
     C                   EVAL      PRTRN = 'TAXAB  '
     C                   ENDSL

     C                   ENDIF

     C                   IF        A4JAMG = '1'
     C                   EVAL      PCUST = InvolveCUST
     C                   ENDIF

     C**********         IF        A4JAMG = '2'                                             BUG26839
     C**********         EVAL      KJANO = PJANO                                            BUG26839
     C**********         EXSR      SRJointAccDet                                            BUG26839
                                                                                            BUG26839
      ** Check if the joint account member is the prime account holder.                     BUG26839
     C**********         IF        A4JAMG = '2'  AND                               BUG26839 BUG26876
     C**********                   PPAHT = 'Y'                                     BUG26839 BUG26876
     C**********         EVAL      PCUST = InvolveCUST                             BUG26839 BUG26876
     C**********         EVAL      PNARF = *Blanks                                 BUG26839 BUG26876
     C**********         EVAL      PINVP = '1/1       '                            BUG26839 BUG26876
     C**********         EVAL      PRTRN = 'LAST   '                               BUG26839 BUG26876
     C                   IF        A4JAMG = '2'                                             BUG26876
     C                   EVAL      KJANO = PJANO                                            BUG26876
     C                   EXSR      SRJointAccDet                                            BUG26876
                                                                                            BUG26839
     C                   ENDIF

     C                   IF        A4JAMG = '3'  AND
     C                             WETXS <> *Blanks
     C                   EVAL      PCUST = PJANO
     C                   EVAL      PNARF = *Blanks
     C                   EVAL      PINVP = '1/1       '
     C                   EVAL      PRTRN = 'LAST   '
     C                   ENDIF

     C                   IF        A4JAMG = '3'  AND
     C                             WETXS = *Blanks
     C                   EVAL      PCUST = InvolveCUST
     C                   EVAL      PINVP = InvolveINVP
     C                   ENDIF
      *                                                                                     BUG26206
      ** transfered to use updated PCUST value when needed                                  BUG26206
      ** Retrieve Joint Account Type in SDACUSL1                                            BUG26206
                                                                                            BUG26206
     C                   EVAL      PCustomer = PCUST                                        BUG26206
     C                   EXSR      SRRtvACust                                               BUG26206
                                                                                            BUG26206
      ** Retrieve Customer Details in SDCUSTL1                                              BUG26206
                                                                                            BUG26206
     C                   EVAL      PKey1 = *Blanks                                          BUG26206
     C                   MOVEL     PCUST         PKey1                                      BUG26206
     C                   EXSR      SRRtvCust                                                BUG26206
     C                   EVAL      PCOLC = BBCOLC                                           BUG26206

     C                   ENDIF

      ** If Non-Account Holder is not blank

     C                   IF        PNARF <> *Blanks

      ** Access Non-Account Holder details - SDNAHOL1

     C                   EVAL      PNonAccnt = PNARF
     C                   EXSR      SRRtvNonAcc

     C                   IF        NHPIND <> 'Y'
     C                   EVAL      PSTAT = 'NOTAP'
     C                   EVAL      PRTRN = 'NOTAX  '
     C*************      RETURN                                                               235045
     C                   ENDIF

     C                   EVAL      PCOLC = NHCOLC

      ** Retrieve country of tax in SDNHTXL1

     C                   EVAL      KNAHO = PNARF
     C                   EVAL      KCTTX = PCTAX
     C                   EXSR      SRRtvNAHOTax

      ** If Joint Management Account is 1, 2 or 3

     C                   IF        A4JAMG = '1'  OR
     C                             A4JAMG = '2'  OR
     C                             A4JAMG = '3'

     C                   IF        CER069 = 'Y'                                               CER069
     C                   EVAL      WAudit = 'Y'                                               CER069
     C                   EVAL      WTaxStat = NXETXS                                          CER069
     C                   EVAL      WExpiry = NXCEEX                                           CER069
     C                   EVAL      WValDate = NXCVDT                                          CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   SELECT
     C                   WHEN      NXETXS = 'S'
     C                   EVAL      PSTAT = 'SELF '
     C                   EVAL      PRTRN = 'NOTAX'

     C                   WHEN      NXETXS = 'D'
     C                   EVAL      PSTAT = 'DISCL'
     C                   EVAL      PRTRN = 'NOTAX'

     C                   WHEN      NXETXS = 'E'
     C                   EVAL      PSTAT = 'NOTAP'
     C                   EVAL      PRTRN = 'NOTAX'
     C************       RETURN                                                               235045

     C                   OTHER
     C                   EVAL      PSTAT = 'TAXAB'
     C                   EVAL      PRTRN = 'TAXAB'
     C                   ENDSL

     C                   ENDIF

     C                   IF        A4JAMG = '3'  AND
     C                             WETXS = *Blanks
     C                   EVAL      PNARF = InvolveNARF
     C                   EVAL      PINVP = InvolveINVP
     C                   ENDIF

     C                   IF        A4JAMG = '1'
     C                   EVAL      PNARF = InvolveNARF
     C                   ENDIF

      ** Retrieve Joint Account Details for A4JAMG = '2'                                    BUG26938
                                                                                            BUG26938
     C                   IF        A4JAMG = '2'                                             BUG26938
     C                   EVAL      KJANO = PJANO                                            BUG26938
     C                   EXSR      SRJointAccDet                                            BUG26938
     C                   ENDIF                                                              BUG26938
                                                                                            BUG26938
     C                   ENDIF

      ** Retrieve Tax Basket in SDCTTXL1

     C                   EVAL      KCTAX = PCTAX
     C                   EVAL      KCOLC = PCOLC
     C                   EXSR      SRRtvTxBasket
     C                   EVAL      PTXBS = EWTXBS
     C                   MOVE      EWWTAC        PWTAC
     C                   IF        EWTRT2 = *Blank                                           233251
     C                   EVAL      PTRTE = EWTRT1                                            233251
     C                   ELSE                                                                233251
     C                   EVAL      PTRTE = EWTRT2                                            233251
     C                   ENDIF                                                               233251

      ***Retrieve*Tax*Currency*in*SDCTRYL1*****************************                       233251
      **********                                                                              233251
     C**********         EVAL      PCountry = PCTAX                                           233251
     C**********         EXSR      SRCntyCode                                                 233251

     C                   IF        A4TXCY <> *Blanks
     C                   EVAL      PTXCY = A4TXCY
     C                   ELSE
     C                   EVAL      PTXCY = POCCY
     C                   ENDIF
                                                                                              CER069
     C                   IF        CER069 = 'Y' AND WAudit = 'Y'                              CER069
     C                   EXSR      SRTSCH                                                     CER069
     C                   ENDIF                                                                CER069

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ***SRRtvIntDet*-*Retrieve*Interest*Details***********************                       233269
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
     C**********         DOW       NOT %EOF(GLETXAL1)                                         233269
     C**********         IF        WRead < 6                                                  233269
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
     C**********         ENDIF                                                                233269
     C**********         ENDDO                                                                233269
      **********                                                                              233269
     C**********         ENDSR                                                                233269
      *****************************************************************
      /EJECT
      *****************************************************************
      ***SRCalIntAmt*-*Calculate*Interest*Amount*at*Effective*Date*****                       233269
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
     C**********         ENDSR                                                                233269
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvTaxRate - Retrieve Tax Period and Tax Rate
      *****************************************************************
     C     SRRtvTaxRate  BEGSR

     C     KTaxBkt1      KLIST
     C                   KFLD                    PCTAX
     C                   KFLD                    PTXBS

     C     KTaxBasket    KLIST
     C                   KFLD                    PCTAX
     C                   KFLD                    PTXBS
     C                   KFLD                    KEffDate

     C**********         EVAL      KEffDate = WSTR1                                           235663
                                                                                              235663
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
     C                   IF        A4JAMG = '3'  AND                                        BUG26692
     C                             WETXS <> *Blanks                                         BUG26692
     C                   EVAL      PRTRN = 'LAST'                                           BUG26692
     C                   ELSE                                                               BUG26692
     C                   EVAL      PRTRN = 'NOTAX'
     C***************    RETURN                                                               236065
     C                   ENDIF                                                              BUG26692
     C                   RETURN                                                               235663
     C                   ENDIF

     C**********         IF        TBCRTT = PCTAX  AND                                        233269
     C**********                   TBTXBS = PTXBS  AND                                        233269
     C**********                   TBEFDT < PENDD                                             233269
     C**********         EVAL      WTXR1 = TBTRAB                                             233269
     C**********         EVAL      PTXR1 = TBTRAB                                             233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
      **********                                                                              233269
     C**********         EVAL      KEffDate = PENDD                                           233269
     C*****KTaxBasket    SETGT     SDTXBSL1                                                   233269
     C**********         READP     SDTXBSL1                                                   233269
      **********                                                                              233269
     C**********         IF        TBTRTY = '2'                                               233269
     C                   EVAL      WEND1 = PENDD
     C                   EVAL      PTXR1 = TBTRAB
     C                   EVAL      WTXR1 = TBTRAB
     C**********         EVAL      PTRTE = TBTRTY                                             233251
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         IF        TBTRTY = '1'                                               233269
     C**********         EVAL      PTRTE = TBTRTY                                             233251
      **********                                                                              233269
     C**********         EVAL      WCntr = 0                                                  233269
     C**********         EVAL      KEffDate = WSTR1                                           233269
     C*****KTaxBasket    SETLL     SDTXBSL1                                                   233269
     C**********         READ      SDTXBSL1                               03                  233269
      **********                                                                              233269
     C**********         DOW       *IN03 = *OFF AND WCntr <=4                                 233269
     C**********                   AND TBCRTT = PCTAX                                         233269
     C**********                   AND TBTXBS = PTXBS                                         233269
      **********                                                                              233269
     C**********         IF        TBEFDT < PENDD                                             233269
      **********                                                                              233269
     C**********         SELECT                                                               233269
     C**********         WHEN      WCntr = 1                                                  233269
     C**********         EVAL      WEND1 = TBEFDT                                             233269
     C**********         EVAL      WSTR2 = TBEFDT                                             233269
     C**********         EVAL      WTXR2 = TBTRAB                                             233269
     C**********         EVAL      WEND2 = 0                                                  233269
     C**********         WHEN      WCntr = 2                                                  233269
     C**********         EVAL      WEND2 = TBEFDT                                             233269
     C**********         EVAL      WSTR3 = TBEFDT                                             233269
     C**********         EVAL      WTXR3 = TBTRAB                                             233269
     C**********         EVAL      WEND3 = 0                                                  233269
     C**********         WHEN      WCntr = 3                                                  233269
     C**********         EVAL      WEND3 = TBEFDT                                             233269
     C**********         EVAL      WSTR4 = TBEFDT                                             233269
     C**********         EVAL      WTXR4 = TBTRAB                                             233269
     C**********         EVAL      WEND4 = 0                                                  233269
     C**********         WHEN      WCntr = 4                                                  233269
     C**********         EVAL      WEND4 = TBEFDT                                             233269
     C**********         EVAL      WSTR5 = TBEFDT                                             233269
     C**********         EVAL      WTXR5 = TBTRAB                                             233269
     C**********         EVAL      WEND5 = PENDD                                              233269
     C**********         ENDSL                                                                233269
      **********                                                                              233269
     C**********         ELSE                                                                 233269
     C**********         SELECT                                                               233269
     C**********         WHEN      WCntr = 1                                                  233269
     C**********         EVAL      WEND1 = PENDD                                              233269
     C**********         WHEN      WCntr = 2                                                  233269
     C**********         EVAL      WEND2 = PENDD                                              233269
     C**********         WHEN      WCntr = 3                                                  233269
     C**********         EVAL      WEND3 = PENDD                                              233269
     C**********         WHEN      WCntr = 4                                                  233269
     C**********         EVAL      WEND4 = PENDD                                              233269
     C**********         ENDSL                                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269
      **********                                                                              233269
     C**********         EVAL      WCntr = WCntr + 1                                          233269
     C**********         READ      SDTXBSL1                               03                  233269
     C**********         ENDDO                                                                233269
      **********                                                                              233269
     C**********         ENDIF                                                                233269

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ***SRCalTaxAmt*-*Calculate*Tax*Amount****************************                       233269
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
     C**********         EVAL      PTAXA = PTAXA * WMulValue / WDivValue                      233269
      **********                                                                              233269
     C**********         ENDSR                                                                233269
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvBranch - Retrieve Branch Details
      *****************************************************************
     C     SRRtvBranch   BEGSR

      ** Access Branch details

     C**********         CALL      'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY

      ** No Record Found/ Error Encountered

     C                   IF        PRtcd <> *BLANKS
     C                   MOVEL     PBranch       PKEY
     C                   EVAL      PFILE = 'SDBRCHL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvLoc - Retrieve Location
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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCntyCode - Retrieve Country Code
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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRJointAccDet - Joint Account Details
      *****************************************************************
     C     SRJointAccDet BEGSR

      ** Retrieve Prime Account Holder

     C                   IF        PCUST <> *BLANKS
     C     KJANO         CHAIN     SDJACCL5

     C                   IF        %FOUND(SDJACCL5)
     C                   EVAL      PCUST = JCCUST
     C                   EVAL      PNARF = *Blanks
     C**********         EVAL      PINVP = JCINVP                                             233251
     C                   EVAL      PINVP = '1/1       '                                       233251
     C                   EVAL      PRTRN = 'LAST   '
     C                   ENDIF

      ** If not found, non-account holder reference number

     C                   ELSE
     C     KJANO         CHAIN     SDJACCL6

     C                   IF        %FOUND(SDJACCL6)
     C                   EVAL      PCUST = *Blanks
     C                   EVAL      PNARF = JCNAHO
     C**********         EVAL      PINVP = JCINVP                                           BUG26938
     C                   EVAL      PINVP = '1/1       '                                     BUG26938
     C                   EVAL      PRTRN = 'LAST   '
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvCustTax - Retrieve Customer by Country of Tax
      *****************************************************************
     C     SRRtvCustTax  BEGSR

     C     KCustByTax    KLIST
     C                   KFLD                    KCUST
     C                   KFLD                    KCTAX

      ** Access Customer by Country of Tax

     C     KCustByTax    CHAIN     SDACTXL1

      ** No Record Found

     C                   IF        NOT %FOUND(SDACTXL1)
     C                   EVAL      PKEY = PCUST + PCTAX
     C                   EVAL      PFILE = 'SDACTXL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvCust - Retrieve Customer Details
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

     C                   ENDSR
      *****************************************************************                       233252
      /EJECT                                                                                  233252
      *****************************************************************                       233252
      * SRRtvACust - Retrieve Additional Customer Details                                     233252
      *****************************************************************                       233252
     C     SRRtvACust    BEGSR                                                                233252
                                                                                              233252
      ** Access Additional Customer Details                                                   233252
                                                                                              233252
     C                   CALL      'AOACUSR0'                                                 233252
     C                   PARM      *Blanks       PRtcd                                        233252
     C                   PARM      '*KEY   '     POptn                                        233252
     C                   PARM                    PCustomer                                    233252
     C*****SDACUS        PARM      SDACUS        DSSDY                               233252 BUG23090
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23090
                                                                                              233252
      ** No Record Found or Joint Acount Type is 'N'                                          233252
                                                                                              233252
     C                   IF        PRtcd  = '*NRF   ' OR                                      233252
     C                             PRtcd  = '*EMPTY ' OR                                      233252
     C                             PRtcd  = '*CUSDEL' OR                                    BUG26790
     C                             PRtcd  = '*CUSCLO' OR                                    BUG26790
     C                             PRtcd  = '*EOF   ' OR                                      233252
     C                             E5JATP = 'N'       AND                                     233252
     C                             PRtcd  = *BLANKS   OR                                      233252
     C                             E5JATP = ' '       AND                                     233252
     C                             PRtcd  = *BLANKS                                           233252
     C                   EVAL      PSTAT = 'NOTAP '                                           233252
     C                   EVAL      PRTRN = 'NOTAX  '                                          233252
     C***************    RETURN                                                               236065
     C                   RETURN                                                               235663
     C                   ELSE                                                                 233252
                                                                                              233252
      ** Error Encountered                                                                    233252
                                                                                              233252
     C                   IF        PRtcd <> *Blanks                                           233252
     C                   MOVEL     PCustomer     PKEY                                         233252
     C                   EVAL      PFILE = 'SDACUSPD'                                         233252
     C                   EVAL      PRTRN = 'ERROR  '                                          233252
     C                   RETURN                                                               233252
     C                   ENDIF                                                                233252
     C                   ENDIF                                                                233252
                                                                                              233252
     C     ERtvACust     ENDSR                                                                233252
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvNAHOTax - Access Non Account Holder Tax Details
      *****************************************************************
     C     SRRtvNAHOTax  BEGSR

      ** Set up key list

     C     KNonAccHold   KLIST
     C                   KFLD                    KNAHO
     C                   KFLD                    KCTTX

      ** Retrieve Non-account Holder details

     C     KNonAccHold   CHAIN     SDNHTXL1

     C                   IF        NOT %FOUND(SDNHTXL1)
     C                   EVAL      PKEY = PNARF + PCTAX
     C                   EVAL      PFILE = 'SDNHTXL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvNonAcc - Access Non Account Holder details
      *****************************************************************
     C     SRRtvNonAcc   BEGSR

     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PNonAccnt
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029

      ** No Record Found/ Error Encountered

     C                   IF        PRtcd <> *BLANKS
     C                   MOVEL     PNARF         PKEY
     C                   EVAL      PFILE = 'SDNAHOL1  '
     C                   EVAL      PRTRN = 'ERROR  '
     C                   RETURN
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRtvTxBasket - Retrieve Tax Basket
      *****************************************************************
     C     SRRtvTxBasket BEGSR

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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRInvtRatio - Determine ratio of investment proportion
      *****************************************************************
     C     SRInvtRatio   BEGSR

     C                   EVAL      WMulValue = *Zeros
     C                   EVAL      WDivValue = *Zeros

      ** Search '/' from the PINVP startting at position 2

     C                   EVAL      WPosition = %SCAN('/':PINVP:2)

      ** If '/' not found, or if '/' is on position 1, set ratio to 1

     C                   IF        WPosition = 0
     C                   EVAL      WMulValue = 1
     C                   EVAL      WDivValue = 1
     C                   ELSE

      ** Get the value on the left hand of '/' and set as multiplied value
      ** Get the value on the right hand of '/' and set as divide value

     C                   EVAL      WStart = WPosition - 1
     C                   EVAL      WEnd = WPosition + 1
     C                   EVAL      WNumerator = %SUBST(PINVP:1:WStart)
     C                   EVAL      WDenominator = %SUBST(PINVP:WEnd)

     C                   EVALR     WNumerator = %TRIM(WNumerator)                             233795
     C                   EVALR     WDenominator = %TRIM(WDenominator)                         233795
                                                                                              233795
     C                   MOVEL     WNumerator    WMulValue
     C                   MOVEL     WDenominator  WDivValue
     C                   ENDIF

      ** Trap possible blanks or zero value

     C************       IF        WMulValue = *Zeros  OR                                     235045
     C************                 WDivValue = *Zeros                                         235045
     C                   IF        WDivValue = *Zeros                                         235045
     C************       EVAL      WMulValue = 1                                              235045
     C                   EVAL      WDivValue = 1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER048
      *                                                               *                       CER048
      *  SRCalcStax - Calculate Secondary Tax Details                 *                       CER048
      *                                                               *                       CER048
      *  Called by: MAIN Processing                                   *                       CER048
      *                                                               *                       CER048
      *  Calls: None                                                  *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCalcStax    BEGSR                                                                CER048
      *                                                                                       CER048
     C**********         EVAL      WToto = PTOTO                                     CER048 BUG22911
     C**********         IF        WToto < *Zero                                   BUG22953 BUG22911
     C**********         EVAL      WToto = WToto * -1                              BUG22953 BUG22911
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
     C**********         EVAL      WSchk = WToto + TIUTTH                   CER048 BUG22754 BUG22911
     C**********         EVAL      WSchk = WToto + WUtth                           BUG22754 BUG22911
     C**********         EVAL      WCuth = TICUTH                           CER048 BUG22754 BUG22911
     C**********         EVAL      WToto = WSchk - WCuth                             CER048 BUG22911
     C**********         ENDIF                                                       CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         IF        WSchk <= WCuth                                    CER048 BUG22911
     C**********         EVAL      WToto = *ZEROS                                    CER048 BUG22911
     C**********         ENDIF                                                       CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         ENDIF                                                       CER048 BUG22911
      *                                                                                     BUG23657
      ** Clear / Populate DS/SDTXDT                                                         BUG23657
      ***Process*only*account*holders                                             BUG23657A BUG26938
      *                                                                                    BUG23657A
     C**********         IF        PCUST <> *BLANKS                               BUG23657A BUG26938
      *                                                                                    BUG23657A
     C                   CLEAR                   SDTXDT                                     BUG26979
     C                   IF        PCUST <> *BLANKS                                         BUG26979
     C                   EVAL      PEVDT = E5EVDT                                           BUG23657
     C                   EVAL      PEXDT = E5ETXT                                           BUG23657
     C                   ENDIF                                                              BUG26979
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
     C                   PARM                    PTOTO                                      BUG22911
      *                                                                                     BUG22911
      ** Customer                                                                           BUG22911
      *                                                                                     BUG22911
     C                   PARM                    PCUST                                      BUG22911
      *                                                                                     BUG26979
      ** Non Account Holder                                                                 BUG26979
      *                                                                                     BUG26979
     C                   PARM                    PNARF                                      BUG26979
      *                                                                                     BUG22911
      ** Original Currency                                                                  BUG22911
      *                                                                                     BUG22911
     C                   PARM                    POCCY                                      BUG22911
      *                                                                                     BUG23657
      ** Exemption and Certificate Dates                                                    BUG23657
     C                   PARM                    SDTXDT                                     BUG23657
      *                                                                                     BUG22911
      ** Joint Management Account Type                                                      BUG26839
     C                   PARM                    PJAMG                                      BUG26839
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
      ** Initialize ouput fields                                                           BUG23657A
      *                                                                                    BUG23657A
     C**********         ELSE                                                     BUG23657A BUG26938
     C**********         EVAL      WToto = 0                                      BUG23657A BUG26938
     C**********         ENDIF                                                    BUG23657A BUG26938
      *                                                                                     BUG22911
     C**********         IF        WToto < *Zero                                  BUG22911 BUG22953A
     C**********         EVAL      WToto = WToto * -1                             BUG22911 BUG22953A
     C**********         ENDIF                                                    BUG22911 BUG22953A
      *                                                                                     BUG22911
     C**********         EVAL      PTOTO = WTOTO                                   BUG22911 BUG24521
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
     C                   KFLD                    KCTTX                                        CER048
     C                   KFLD                    KStxbs                                       CER048
     C                   KFLD                    KEffDate                                     CER048
                                                                                              CER048
     C     KSecTaxBS1    KLIST                                                                CER048
     C                   KFLD                    KCTTX                                        CER048
     C                   KFLD                    KStxbs                                       CER048
      *                                                                                       CER048
     C                   EVAL      KCTTX = EWCTRT                                             CER048
     C                   MOVE      PStxb         KStxbs                                       CER048
      **********                                                                     CER048 BUG22911
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
     C**********         EVAL(H)   PTAXA = (WToto * PTXR1) / 100                     CER048 BUG22911
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
      * SRRtvRelgAffn - Retrieve Religious Affiliation Codes details  *                       CER054
      *****************************************************************                       CER054
     C     SRRtvRelgAffn BEGSR                                                                CER054
      *                                                                                       CER054
      ** Access Religious Affiliation Codes file                                              CER054
      *                                                                                       CER054
     C                   IF        PCUST <> *BLANKS AND                                       CER054
     C                             PNARF = *BLANKS                                            CER054
     C                   EVAL      KRLAF = E5RLAF                                             CER054
     C                   ELSEIF    PCUST = *BLANKS AND                                        CER054
     C                             PNARF <> *BLANKS                                           CER054
     C                   EVAL      KRLAF = NHRLAF                                             CER054
     C                   ENDIF                                                                CER054
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
      *                                                                                       CER054
     C                   IF        PCUST <> *BLANKS AND                                       CER054
     C                             PNARF = *BLANKS                                            CER054
     C                   EVAL      KSTCD = E5STCD                                             CER054
     C                   ELSEIF    PCUST = *BLANKS AND                                        CER054
     C                             PNARF <> *BLANKS                                           CER054
     C                   EVAL      KSTCD = NHSTCD                                             CER054
     C                   ENDIF                                                                CER054
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
     C                   EXSR      SRRtvRelgAffn                                              CER054
      *                                                                                       CER054
      ** Retrieve state details                                                               CER054
      *                                                                                       CER054
     C                   EVAL      WRLAF = %XLATE(LO:UP:KRLAF)                                CER054
                                                                                              CER054
     C**********         IF        E5STCD <> *BLANKS OR NHSTCD <> *BLANKS          BUG26703 BUG26833
     C**********         EXSR      SRRtvGrmState                                   BUG26703 BUG26833
     C**********         ENDIF                                                     BUG26703 BUG26833
     C                   IF        WRLAF <> 'NONE'                                            CER054
     C                   IF        E5STCD <> *BLANKS OR NHSTCD <> *BLANKS                   BUG26833
     C                   EXSR      SRRtvGrmState                                            BUG26833
     C                   ENDIF                                                              BUG26833
     C**********                   AND E5STCD <> *BLANKS                           BUG24016 BUG26833
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
      * SRTSCH - Set Tax Status                                       *                       CER069
      *****************************************************************                       CER069
     C     SRTSCH        BEGSR                                                                CER069
                                                                                              CER069
     C                   EVAL      WAudit = *BLANKS                                           CER069
                                                                                              CER069
     C                   IF        PINTH = 'A'                                                CER069
     C                   IF        PSJobName = 'DLC0606B'                                     CER069
     C                             OR PSJobName = 'REC62A'                                    CER069
     C                             OR PSJobName = 'REC62N'                                    CER069
     C                   IF        (WTaxStat = 'S' OR WTaxStat = 'E'                          CER069
     C                             OR WTaxStat = 'D') AND PCOLC = EWCTRT                      CER069
     C**********                   AND WExpiry <= PENDD AND WExpiry <> 0             CER069 MD030924
     C                             AND WExpiry < PENDD AND WExpiry <> 0                     MD030924
     C                   EVAL      WAudit = 'Y'                                               CER069
     C                   EVAL      PSTAT = 'TAXAB'                                            CER069
     C                   EVAL      PRTRN = 'TAXAB'                                            CER069
     C                   IF        E5EVDT = 0                                                 CER069
     C                   EVAL      WTaxStat = 'Y'                                             CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      WTaxStat = 'T'                                             CER069
     C                   ENDIF                                                                CER069
     C                   ENDIF                                                                CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   IF        WTaxStat = 'S' OR WTaxStat = 'E'                           CER069
     C                             OR WTaxStat = 'D'                                          CER069
     C                   EVAL      PINTH = 'N'                                                CER069
     C                   ELSE                                                                 CER069
     C                   EVAL      PINTH = WTaxStat                                           CER069
     C                   ENDIF                                                                CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
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
      ** Transaction Reference
      ** Booking Branch
      ** Joint Account Number
      ** Customer Number
      ** Non-account Holder Reference
      ** Investment Type
      ** Prime Account Holder Indicator                                                     BUG26839
      ** Interest Calculation Start Date
      ** Interest Calculation End Date
      ** Total Interest Amount
      ** Tax Rate Applicable for Band
      ** Original Currency
      ** Threshold Indicator                                                                  CER048

     C                   PARM                    PMODI
     C                   PARM                    PTRRF
     C                   PARM                    PBRCA
     C                   PARM                    PJANO
     C                   PARM                    PCUST
     C                   PARM                    PNARF
     C                   PARM                    PINVP
     C                   PARM                    PPAHT                                      BUG26839
     C                   PARM                    PSTRD
     C                   PARM                    PENDD
     C                   PARM                    PTOTI
     C                   PARM                    PTAXR
     C                   PARM                    POCCY
     C                   PARM                    PInth                                        CER048

      ** OUTPUTS
      ** Interest Amount at Effective Date
      ** Tax Amount
      ** Interest Amount
      ** Tax Currency
      ** Country of Tax
      ** Tax Basket
      ** EU Withholding Tax Account Code
      ** Country of Location
      ** Customer Status
      ** Transition Type at End
      ** Tax Rate of Tax Period
      ***Secondary*Tax*Basket                                                        CER048 BUG22911
      ***Secondary*Tax*basket*Action*Code                                            CER048 BUG22911
      ***Secondary*Tax*Rate                                                          CER048 BUG22911
      ***Secondary*Transition*Type                                                   CER048 BUG22911
      ***Secondary*Tax*Amount                                                        CER048 BUG22911
      ** Database Error Key
      ** Database Error File
      ** Return Code
      ** Data Structure for Secondary Tax Parameters                                        BUG22911
     C                   PARM                    PIAED
     C                   PARM                    PTAXA
     C                   PARM                    PTOTO
     C                   PARM                    PTXCY
     C                   PARM                    PCTAX
     C                   PARM                    PTXBS
     C                   PARM                    PWTAC
     C                   PARM                    PCOLC
     C                   PARM                    PSTAT
     C                   PARM                    PTRTE
     C                   PARM                    PTXR1
     C                   PARM                    PJAMG
     C**********         PARM                    PStxb                               CER048 BUG22911
     C**********         PARM                    PStac                               CER048 BUG22911
     C**********         PARM                    PSttr                               CER048 BUG22911
     C**********         PARM                    PSttp                               CER048 BUG22911
     C**********         PARM                    PStxa                               CER048 BUG22911
     C                   PARM                    PKEY
     C                   PARM                    PFILE
     C                   PARM                    PRTRN
     C                   PARM      SDTXPA        DSSDY                                      BUG22911
      *                                                                                       236399
      ** Access Bank details                                                                  236399
      *                                                                                       236399
     C                   CALL      'AOBANKR0'                                                 236399
     C                   PARM      '*DBERR '     PRtcd                                        236399
     C                   PARM      '*FIRST '     POptn                                        236399
     C     SDBANK        PARM      SDBANK        DSFDY                                        236399
      *                                                                                       236399
      ** Database error                                                                       236399
      *                                                                                       236399
     C                   IF        PRtcd <> *BLANKS                                           236399
     C                   EVAL      DBFILE = 'SDBANKPD'                                        236399
     C                   EVAL      DBASE = 991                                                236399
     C                   EVAL      DBKEY = POptn                                              236399
     C                   EXSR      *PSSR                                                      236399
     C                   ENDIF                                                                236399
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
     C                   EVAL      DBASE = 992                                                CER048
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
     C                   EVAL      DBASE = 993                                                CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
                                                                                              CER054
      *                                                                                       CER069
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
      ** Database error                                                                       CER069
      *                                                                                       CER069
     C                   IF        PRtcd <> *BLANKS AND                                       CER069
     C                             PRtcd <> '*NRF'                                            CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBASE = 994                                                CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   EXSR      *PSSR                                                      CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
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
      ***/COPY*ZACPYSRC,PSSR_ILE                                                              236399
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
**  CPY@
(c) Finastra International Limited 2004
