     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Tax Calculation for Trades Sale')             *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading module.                           *
      *                                                               *
      *  SEVTRADTAX - Tax Calculation for Trades Sale                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26839           Date 05Jan10               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG22911           Date 17Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11193           Date 02May06               *
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 237063             Date 20Nov05               *
      *                 236137             Date 20Sep05               *
      *                 236346             DATE 04OCT05               *
      *                 236732             Date 28Oct05               *
      *                 236453             Date 24Oct05               *
      *                 236411             Date 07Oct05               *
      *                 235909             Date 04Jul05               *
      *                 234675             Date 05Jul05               *
      *                 235546             Date 09Aug05               *
      *                 236247             Date 28Sep05               *
      *                 234635             Date 04Jul05               *
      *                 234599             Date 01Jul05               *
      *                 234577             Date 29Jun05               *
      *                 234797             Date 27Jun05               *
      *                 234440             Date 22Jun05               *
      *                 236812             Date 15Jun05               *
      *                 234010             Date 08Jun05               *
      *                 233566             Date 17May05               *
      *                 233867             Date 01Jun05               *
      *                 233774             Date 30May05               *
      *                 233569             Date 19May05               *
      *                 233283             Date 28Apr05               *
      *                 233038             Date 14Mar05               *
      *                 232543             Date 16Mar05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26839 - JA1_Threshold limit of the main joint customer was*
      *             utilized by the member                            *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG22911 - Changes for Correct Tax Calculation               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *           (Recompile)                                         *
      *  CER034A - LF046 German Features - New Fields and Enquiries   *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  236137 - Change Control for CGL031 Parts 4 & 5.              *
      *           Several changes in the Taxation of Savings Income   *
      *           functionality.                                      *
      *           - De Minimis Rules consideration.                   *
      *           - Taxable Amount of Amortized Discount basis        *
      *           consideration.                                      *
      *           - Amortized Premium deduction consideration.        *
      *           - Tax Calculation.                                  *
      *  236346 - Permitting the user to amend the interest may result*
      *           in a negative EU tax being generated. In case the   *
      *           EU tax is negative, reset the EU tax to zero.       *
      *  236732 - Improve update processing for file SDCSINPD.        *
      *  236453 - Negative interest sold must be zeroised             *
      *  236411 - For Funds, if purchase prior to transition date,    *
      *           delta NAV calulation should consider the higher     *
      *           of the position average price and and the NAV at    *
      *           transition date                                     *
      *         - CH and negative delta TIS : Taxable Amount = 0      *
      *           as in LUX and is no more Delta NAV                  *
      *  235909 - For Joint Accounts, Calculate EU tax per member.    *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation.                                 *
      *  235546 - Due to back valuations, need to pass date to        *
      *           ETCPOSRTT so that the record for this date is       *
      *           returned if the transaction is back valued instead  *
      *           of the current position                             *
      *  236247 - Unlock record to avoid database error when different*
      *           users are amending trades                           *
      *  234635 - Ex-coupon processing                                *
      *  234599 - Unnecessary database errors occurring               *
      *  234577 - Error in position retieved.0 tax on short sales.    *
      *  234797 - Interest over transition date wrong
      *  234440 - Position Management (Access ETCPOSND)               *
      *  236812 - No EU Tax is not being calculated at all            *
      *  234010 - Trade Input on funds with "unknown" tax status.     *
      *  233566 - Add fields to CDEPPD                                *
      *  233867 - The tax basket must be accessed with the value date *
      *           instead of the current run date                     *
      *  233774 - SEVTRADTAX incorrect for Bonds zero coupon & Funds  *
      *  233569 - Field initialization                                *
      *  233283 - Calculation of taxable amount prorata temporis      *
      *  233038 - Incorrect access to country of tax                  *
      *  232543 - Fix for CGL031                                      *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Investment Types File
     FINVTP     IF   E           K DISK    INFSR(*pssr)
 
      ** Customer Positions File
     F***CPOSN**   UF A E           K DISK    INFSR(*pssr)                                    234440
     F**********                           COMMIT                                             234440
 
      ** Security Withholding Tax Details
     FSESWHTL0  IF   E           K DISK    INFSR(*pssr)
 
      ** Joint Account Member Details
     FSDJACCLB  IF   E           K DISK    INFSR(*pssr)
 
      ** Tax Calculation Methods file
     FSDTXCML1  IF   E           K DISK    INFSR(*pssr)
 
      ** Customer Income File
     FSDCSINPD  O    E             DISK    INFSR(*pssr)
 
      ***Customer*Income*File******************************************                       236732
     F***SDCSINL6  UF   E           K DISK    INFSR(*pssr)                                    236732
     F**********                           RENAME(SDCSIND0:SDCSIND6)                          236732
      ** Customer Income by Transaction no./Module ID                                         236732
     FSDCSINLD  UF   E           K DISK    INFSR(*pssr)                                       236732
     F                                     RENAME(SDCSIND0:SDCSINDL)                          236732
                                                                                              233566
      ** Customer Positions file                                                              233566
     F**CDEPD***IF   E           K DISK    INFSR(*PSSR)                                233566 236812
     F**CDEPS***IF   E           K DISK    INFSR(*PSSR)                                236812 234440
     F**********                           PREFIX(C_)                                  233566 234440
                                                                                              233566
      ***Prices*file***************************************************                233566 236812
     F*PRICR****IF   E           K DISK    INFSR(*PSSR)                                233566 236812
                                                                                              234010
      ** Security Non-Diary Events file                                                       234010
     FSECEO     IF   E           K DISK    INFSR(*PSSR)                                       234010
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                              233774
      ** Array for manipulating decimal positions                                             233774
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)                            233774
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(W_)
     D  CDArr                183    230
     D  CRArr                231    242
                                                                                              234440
      ** EU Tax Customer Position                                                             234440
     D ETCPOSND      E DS                  EXTNAME(ETCPOSND)                                  234440
 
      ** Valid Trade Details
     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
     D                                     PREFIX(V_)
 
      ** Client Details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035
 
      ** External DS for Location Code
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** External DS for Country of Tax Code
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** External DS for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** External DS for Non Account Holder Details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** External DS for Securities Clients
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** External DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Country of Tax Rates
     D SECNTR        E DS                  EXTNAME(SECNTRPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** Third DS for Access Programs, Long Data Structure                                  BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** Data Structure for JNSTAT                                                            233566
     D JNSTAT        E DS                  EXTNAME(JNSTAT) DTAARA(JNSTAT)                     233566
     D                                     PREFIX(JN)                                         233566
                                                                                              233566
      *                                                                                     BUG22911
      ** Data area for Midas SD Tax Parameter File                                          BUG22911
     D SDTXPA        E DS                  EXTNAME(SDTXPAPD)                                BUG22911
      *                                                                                     BUG22911
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
     D ProcFlag        S              1A
     D TXBSFlag        S              1A
     D WAmorDscF       S              1A
     D WIntSldFl       S              1A
     D WTNLUFlag       S              1A
     D WWCUST          S              6A
     D FAVPP           S             15P 8
     D AVPVD           S             15P 8
     D ZZACINT1        S             15P 0
     D ZZACINT2        S             15P 1
     D NODAYS1         S              5  0
     D NODAYS2         S              5  0
     D @@BRCA          S              3A
     D @@COLC          S              2A
     D @@CTAX          S              2A
     D @@CUST          S              6A
     D @@ENDD          S              5  0
     D @@FILE          S             10A
     D @@IAED          S             15  0
     D @@INVP          S             10A
     D @@JANO          S              6A
     D @@KEY           S             10A
     D @@MODI          S              1A
     D @@NARF          S             10A
     D @@OCCY          S              3A
     D @@RTRN          S              7A
     D @@STAT          S              5A
     D @@STRD          S              5  0
     D @@TAXA          S             15  0
     D @@TAXR          S              6  4
     D @@TOTI          S             15  0
     D @@TOTO          S             15  0
     D*@@TRRF***       S             18A                                                      CGL035
     D @@TRRF          S             24A                                                      CGL035
     D @@TRTE          S              1A
     D @@TXBS          S              2A
     D @@TXCY          S              3A
     D @@TXR1          S              6  4
     D @@JAMG          S              1A
     D*@@WTAC***       S              4  0                                                    CGL035
     D @@WTAC          S             10P 0                                                    CGL035
     D @DLCCD          S              3A
     D @DTDBA          S              3A
     D @PCUST          S              6A
     D @PNAHO          S             10A
     D PCURR           S              3A
     D @PCTTA          S              2A
     D @PTABD          S              1  0
     D @PKEY1          S             10A
     D @PKYST          S              7A
     D @PCTRT          S              2A
     D @PCTRR          S              2A
     D @PCRTT          S              7A
     D @PTXBS          S              2A
     D @PDATE          S              5P 0
     D @PNARR          S             15A
     D @PRATE          S              6P 4
     D ZRP             S              1A
     D WAMT            S             15  0
     D IRATE           S             15  9
     D WAVPD           S                   LIKE(AVPVD)
     D WCNCD           S                   LIKE(DVCNCD)
     D*WCNCZ****       S                   LIKE(BBCNCZ)                                       233038
     D WCOLC           S                   LIKE(BBCOLC)                                       233038
     D WCURRKEY        S                   LIKE(TSOCCY)
     D WCUST           S                   LIKE(JCCUST)
     D WNAHO           S                   LIKE(JCNAHO)
     D WDATEYYYY       S                   LIKE(TSIPDT)
     D WFAVPD          S                   LIKE(V_FSPP)
     D WFSRD           S                   LIKE(V_FSPP)
     D WJANO           S                   LIKE(JCJANO)
     D WLTAX           S                   LIKE(S1RASO)
     D WPINTM          S                   LIKE(V_NOML)
     D*WPURINT**       S                   LIKE(CSPI)                                         234440
     D WSECTYPE        S              1A
     D*WSTART***       S                   LIKE(EWEDT1)                                       234440
     D WTAXAMTIS       S             15  0
     D WTRAB           S              6P 4
     D WTXAMTBP        S             15  0                                                    236137
     D WTXAMTBD        S             15  0
     D WTXAMTBI        S             15  0
     D WTXAMTF         S             15  0
     D WTXAMTF1        S             15  0
     D WTXAMTF2        S             15  0
     D WTXBLAMT        S             15  0
     D*WWDAY1***       S              5  0                                             233283 234440
     D*WWDAY2***       S              5  0                                             233283 234440
     D ZZLCD           S              5P 0
     D ZZNCD           S              5P 0
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
     D WMMDD           S              4A
     D WMonth          S              2  0
     D WYear1          S              2A
     D WYear2          S              4A
     D ZFLD15          S             15  0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21
     D ZADEC           S              1P 0
     D WModID          S              1A
     D WTradNo         S              6S 0
     D WFndCSIN        S              1A
     D WOldTNLU        S              5P 0
     D PRTCD           S              7A
     D POPTN           S              7A
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZRATEX          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZMDIX           S              1A
     D ZAMTCI          S             15P 0
     D ZEXCH           S             13P 8
     D ZMD             S              1A
     D ZCCYI           S              3A
     D ZCCYO           S              3A
     D ZCDPI           S              1P 0
     D ZCDPO           S              1P 0
     D ZAMTCO          S             15P 0
     D PTSTNLU         S              5P 0
     D W_NomCcyDec     S              1  0                                                    233774
     D***W_NDec          S              1  0                                           233774 CGL035
     D W_NuDec         S              1  0                                                    CGL035
     D*WT_CDNV**       S             15  0                                             236812 234440
     D*WT_CNPV**       S             15  0                                             236812 234440
     D*WT_CNSV**       S             15  0                                             236812 234440
     D*WT_SAFP**       S             15  0                                             236812 234440
     D*WT_SAFS**       S             15  0                                             236812 234440
     D*WT_CSAV**       S             15  0                                             236812 234440
     D*WT_AFP***       S             15  8                                             236812 234440
     D WPRICE          S             15P 8                                                    236137
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Output(s) fields
     D EUTX            S             13P 0
     D EUTS            S             13P 0
     D DDEUTX          S             16A
                                                                                              233774
     D ZNOML           S             15  0                                                    233774
     D ZPRC            S             16  9                                                    233774
     D ZCONS           S             15  0                                                    233774
                                                                                              233566
     D*KSecurity       S             10A                                               233566 234440
     D*KBranch**       S              3A                                               233566 234440
     D*KMarket**       S              1A                                               233566 234440
     D*KBook****       S              2A                                               233566 234440
     D*KCustomer       S              6  0                                             233566 234440
     D*KPriceType      S              2A                                               233566 234440
     D*KDate****       S                   LIKE(BJRDNB)                                233566 234440
      *****************************************************************                233566 234440
     D*ZZAPW****       S                   LIKE(PPRC)                                  233566 236812
     D*ZZAPC****       S                   LIKE(C_CDNT)                                233566 234440
     D*ZNNOMP***       S                   LIKE(C_CDNT)                                233566 234440
     D*NCSAV****       S                   LIKE(C_CDNT)                                233566 234440
     D*WCSAV****       S                   LIKE(C_CDNT)                                233566 234440
     D KSNSN           S                   LIKE(SNSN)                                         234010
     D KSNET           S                   LIKE(SNET)                                         234010
     D KSNDT           S                   LIKE(SNDT)                                         234010
                                                                                              236137
      ** Parameters for ZAACTUAR                                                              236137
                                                                                              236137
     D ZRTCD           S             10                                                       236137
     D ZISSD           S              5  0                                                    236137
     D ZISSP           S             15  8                                                    236137
     D ZMATD           S              5  0                                                    236137
     D ZMATP           S             15  8                                                    236137
     D ZDYBS           S              1                                                       236137
     D ZDVBS           S              1                                                       236137
     D ZCDDS           S             48                                                       236137
     D ZCRDS           S             12                                                       236137
     D ZVALD           S              5  0                                                    236137
     D ZFSPR           S             15  8                                                    236137
                                                                                              236137
     D WWDAYS          S              8  3                                                    236137
      *                                                                                       CER048
      ** Parameters for Taxes                                                                 CER048
      *                                                                                       CER048
     D PInth           S              1A                                                      CER048
     D*PStxb****       S              2P 0                                           CER048 BUG22911
     D*PStac****       S             10P 0                                           CER048 BUG22911
     D*PSttr****       S              6P 4                                           CER048 BUG22911
     D*PSttp****       S              1A                                             CER048 BUG22911
     D*PStxa****       S             15P 0                                           CER048 BUG22911
     D CER048          S              1A                                                      CER048
     D PSard           S              6A                                                      CER048
 
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
 
     C*****CPOSKEY       KLIST                                                                234440
     C**********         KFLD                    V_TDBA                                       234440
     C**********         KFLD                    W_SESN                                       234440
     C**********         KFLD                    V_TCNR                                       234440
 
     C     SESNKEY       KLIST
     C                   KFLD                    W_SESN
 
     C     TXCMKEY       KLIST
     C                   KFLD                    S1CTTA
     C                   KFLD                    @@CTAX
 
     C     KLINVT        KLIST
     C                   KFLD                    W_NMCY
     C                   KFLD                    W_SITP
 
     C     KCSIN         KLIST
     C**********         KFLD                    V_LCD                                        236732
     C**********         KFLD                    WModID                                       236732
     C                   KFLD                    WTradNo
     C                   KFLD                    WModID                                       236732
                                                                                              233566
     C*****KPric         KLIST                                                         233566 234440
     C**********         KFLD                    KSecurity                             233566 234440
     C**********         KFLD                    KBranch                               233566 234440
     C**********         KFLD                    KMarket                               233566 234440
     C**********         KFLD                    KBook                                 233566 234440
     C**********         KFLD                    KCustomer                             233566 234440
     C**********         KFLD                    KPriceType                            233566 234440
      *****************************************************************                233566 234440
     C*****KPricD        KLIST                                                         233566 234440
     C**********         KFLD                    KSecurity                             233566 234440
     C**********         KFLD                    KBranch                               233566 234440
     C**********         KFLD                    KMarket                               233566 234440
     C**********         KFLD                    KBook                                 233566 234440
     C**********         KFLD                    KCustomer                             233566 234440
     C**********         KFLD                    KPriceType                            233566 234440
     C**********         KFLD                    KDate                                 233566 234440
      **********                                                                       233566 234440
     C*****KCdep         KLIST                                                         233566 234440
     C**********         KFLD                    KSecurity                             233566 234440
     C**********         KFLD                    KCustomer                             233566 234440
     C**********         KFLD                    KSecurity                                    233566
     C**********         KFLD                    KBranch                               233566 234440
                                                                                              233566
     C     KSNDEV        KLIST                                                                234010
     C                   KFLD                    KSNSN                                        234010
     C                   KFLD                    KSNET                                        234010
     C                   KFLD                    KSNDT                                        234010
                                                                                              234010
     C     KSNDEVP       KLIST                                                                234010
     C                   KFLD                    KSNSN                                        234010
     C                   KFLD                    KSNET                                        234010
                                                                                              234010
      ** Initialization
     C                   EVAL      WSECTYPE = *BLANK
     C                   EVAL      DDEUTX = *BLANK
     C                   EVAL      EUTX = 0
     C                   EVAL      EUTS = 0
     C                   MOVEL     V_TCNR        WWCUST
     C                   MOVE      'N'           WAmorDscF
     C                   MOVE      'N'           WIntSldFl
 
     C                   IF        ProcFlag = 'D'
     C                   EXSR      SRDelete
     C                   GOTO      ENDPROG
     C                   ENDIF
 
     C                   EVAL      WFndCSIN = *BLANKS                                         236137
     C                   IF        ProcFlag = 'C'
     C                             OR        ProcFlag = 'A'
     C                   MOVE      'S'           WModID
     C                   MOVE      V_TDRF        WTradNo
     C*****KCSIN         SETLL     SDCSIND6                                                   236732
     C**********         READ      SDCSIND6                                                   236732
     C     KCSIN         SETLL     SDCSINDL                                                   236732
     C     KCSIN         READE(E)  SDCSINDL                                                   236732
     C**********         IF        NOT %EOF(SDCSINL6) AND                                     236732
     C**********                   TSRDNB = V_LCD AND                                         236732
     C**********                   TSMODI = WModID AND                                        236732
     C**********                   TSDLLN = WTradNo                                           236732
     C                   IF        NOT %EOF(SDCSINLD)                                         236732
     C                   MOVE      'Y'           WFndCSIN
     C                   MOVE      TSTNLU        WOldTNLU
     C                   ELSE                                                                 236732
     C                   EVAL      WFndCSIN = 'N'                                             236732
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve customer details
 
     C                   EXSR      SRRtvCustDet
 
      ** Check if tax computation is needed
 
     C**********         IF        V_TDTP <> 'TP' OR W_SETX <> 'Y'                            234635
     C                   IF        V_TDTP <> 'TP' AND V_ACIN <> 'X'                           234635
     C                             OR W_SETX <> 'Y'                                           234635
     C                             OR PROT = '2' OR PROT = '4'
     C                             AND W_SETX <> 'Y'                                          234675
     C                             OR (BFCLAS <> 'S' AND BFCLAS <> 'D')
     C                             OR (V_TDVD < EWEDT1)                                       234577
     C                   EVAL      DDEUTX = *BLANK
     C                   EVAL      EUTX = 0
     C                   EVAL      EUTS = 0
     C                   GOTO      ENDPROG
     C                   ENDIF
                                                                                              233774
      ** Retrieve the currency details of nominal currency                                    233774
                                                                                              233774
     C                   EVAL      WCURRKEY = W_NMCY                                          233774
     C                   EXSR      SRRtvCurrDet                                               233774
     C                   MOVE      A6NBDP        W_NomCcyDec                                  233774
                                                                                              234440
      ** Access Customer Position                                                             234440
                                                                                              234440
     C**********         CALLB     'SEETCPRTV'                                         234440 234577
     C**********         PARM                    RetCodeIn                             234440 234577
     C**********         PARM                    V_TDBA                                234440 234577
     C**********         PARM                    V_TCNR                                234440 234577
     C**********         PARM                    V_TDSS                                234440 234577
     C**********         PARM                    V_PTFR                                234440 234577
     C**********         PARM                    V_TDMI                                234440 234577
     C**********         PARM                    V_TDVD                                234440 234577
     C**********         PARM                    ETCPOSND                              234440 234577
     C                   CALL      'SEETCPRTT'                                                234577
     C                   PARM                    RetCodeIn                                    234577
     C                   PARM                    V_TDBA                                       234577
     C                   PARM                    V_TCNR                                       234577
     C                   PARM                    V_TDSS                                       234577
     C                   PARM                    V_PTFR                                       234577
     C                   PARM                    V_TDMI                                       234577
     C                   PARM      'T'           TranType          1                          234577
     C                   PARM                    V_TDRF                                       234577
     C                   PARM                    V_TDVD                                       235546
     C                   PARM                    ETCPOSND                                     234577
                                                                                              234440
      ** Calculate the average fiscal price from the customer position details                234440
                                                                                              234440
     C                   IF        CSNV   <> 0                                                234440
     C**********         EVAL      W_NDec = 5 - W_NMDP + W_NomCcyDec                   234440 CGL035
     C**********         EVAL      FAVPP = (CSAV/CSNV) / POWER8(W_NDec)                234440 CGL035
     C                   EVAL      W_NuDec = 5 - W_NMDP + W_NomCcyDec                         CGL035
     C                   EVAL      FAVPP = (CSAV/CSNV) / POWER8(W_NuDec)                      CGL035
     C                   IF        W_SPBS = 'P'                                               234440
     C                   EVAL      FAVPP = FAVPP * 100                                        234440
     C                   ENDIF                                                                234440
     C                   ELSE                                                                 234440
     C                   EVAL      FAVPP = 0                                                  234440
     C                   ENDIF                                                                234440
                                                                                              234440
      ** Calculate the average price from the customer position details                       234440
                                                                                              234440
     C                   IF        CSNV   <> 0                                                234440
     C**********         EVAL      W_NDec = 5 - W_NMDP + W_NomCcyDec                   234440 CGL035
     C**********         EVAL      AVPVD = (APNC/CSNV) / POWER8(W_NDec)                234440 CGL035
     C                   EVAL      W_NuDec = 5 - W_NMDP + W_NomCcyDec                         CGL035
     C                   EVAL      AVPVD = (APNC/CSNV) / POWER8(W_NuDec)                      CGL035
     C                   IF        W_SPBS = 'P'                                               234440
     C                   EVAL      AVPVD = AVPVD * 100                                        234440
     C                   ENDIF                                                                234440
     C                   ELSE                                                                 234440
     C                   EVAL      AVPVD = 0                                                  234440
     C                   ENDIF                                                                234440
 
      ***Compute*for*the*fiscal*average*purchase*price*and*average*price at value date        234440
      *****************************************************************                       234440
     C*****CPOSKEY       SETGT     CPOSN                                                      236812
     C**********         READP     CPOSN                                                      236812
     C**********         If        %EOF(CPOSN)  OR RECI <> 'D'                                236812
     C**********                   OR CSBA <> V_TDBA OR CSSC <> W_SESN                        236812
     C**********                   OR CSCN <> V_TCNR                                          236812
     C**********         GOTO      ENDPROG                                                    236812
     C**********         ELSE                                                                 236812
      ***Calculate*the*Average*Fiscal*Price*numerator*value*date*on-line               233566 234440
      *****************************************************************                233566 234440
     C**********         EXSR      SRCalCSAV                                           233566 234440
     C**********         IF        ZNNOMP <> 0                                         236812 234440
     C**********         EVAL      FAVPP = WT_CSAV / ZNNOMP                            236812 234440
     C**********         EVAL      FAVPP = FAVPP * POWER8(5 - W_NomCcyDec)             236812 234440
     C**********         IF        W_SPBS = 'P'                                        236812 234440
     C**********         EVAL      FAVPP = FAVPP * 100                                 236812 234440
     C**********         ENDIF                                                         236812 234440
     C**********         ELSE                                                          236812 234440
     C**********         EVAL      FAVPP = 0                                           236812 234440
     C**********         ENDIF                                                         236812 234440
      *****************************************************************                       234440
      ***Ensure*that*divide*by*zero*will*not*happen********************                       234440
      *****************************************************************                       234440
     C*****CSNV*         IFEQ      0                                                   236812 234440
     C**********         EVAL      FAVPP = 0                                                  236812
     C**********         EVAL      AVPVD = 0                                                  234440
     C**********         ELSE                                                                 234440
     C**********         EVAL      FAVPP = CSAV / CSNV                                        233774
     C**********         EVAL      AVPVD = CSPV / CSNV                                        233774
     C**********         EVAL      W_NDec = 5 - W_NMDP + W_NomCcyDec                   233774 234440
     C**********         EVAL      FAVPP = (CSAV/CSNV) / POWER8(W_NDec)                233774 236812
     C**********         EVAL      AVPVD = (CSPV/CSNV) / POWER8(W_NDec)                233774 234440
     C**********         ENDIF                                                                234440
     C**********         ENDIF                                                                236812
 
      ** No tax computation if no record found.
 
     C                   IF        TXBSFlag = 'N'
     C                   GOTO      ENDPROG
     C                   ENDIF
 
      ** Retrieve security country of tax.
 
     C*****W_CPNR        IFNE      0                                                          233774
     C     SESNKEY       CHAIN     SESWHTL0
     C                   IF        NOT %FOUND(SESWHTL0)
     C                   EVAL      WLTAX = 0
     C                   ELSE
     C     S1TABD        IFEQ      0
     C                   EVAL      WLTAX = S1RASO
     C                   ELSE
 
      ** If tax deducted at source is different from zero.
 
     C                   CALL      'AOSCTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      S1CTTA        @PCTTA
     C                   PARM      S1TABD        @PTABD
     C     SECNTR        PARM      SECNTR        DSFDY
 
      ** Database Error
 
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     @PCTTA        DBKEY
     C                   MOVE      @PTABD        DBKEY
     C                   EVAL      DBFILE = 'SECNTRL0'
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      WLTAX = TXRASO
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C**********         ELSE                                                                 233774
     C**********         EVAL      WLTAX = 0                                                  233774
     C**********         ENDIF                                                                233774
 
      ** Bonds
 
     C                   IF        PROT = '1' OR PROT ='3' OR PROT = '5'
     C                             OR PROT = '6' OR PROT = '8' OR PROT = '9'
     C                   EVAL      WSECTYPE = 'B'
     C                   EXSR      SRCmpTxbAmtB
     C                   ENDIF
 
      ** Funds
 
     C     PROT          IFEQ      '7'
     C     PROT          OREQ      '4'                                                        234675
     C     W_SETX        ANDEQ     'Y'                                                        234675
     C                   EVAL      WSECTYPE = 'F'
     C                   EXSR      SRCmpTxbAmtF
     C                   ENDIF
 
     C     ENDPROG       TAG
     C                   IF        EUTX <> 0
     C                   MOVE      EUTX          ZFLD15
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANKS       ZECHAR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        DDEUTX
     C                   ENDIF
     C**********         UNLOCK    SDCSINL6                                            236247 236732
     C                   UNLOCK    SDCSINLD                                                   236732
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCustDet - Retrieve Customer Details                      *
      *****************************************************************
     C     SRRtvCustDet  BEGSR
 
      ** Investment type
 
     C     KLINVT        CHAIN     INVTPDF
 
      ** Database Error
 
     C                   IF        NOT %FOUND(INVTP)
     C                   MOVEL     W_NMCY        DBKEY
     C                   MOVE      W_SITP        DBKEY
     C                   MOVEL     'INVTP   '    DBFILE
     C                   MOVEL     '911'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Customer classification
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WWCUST        @PCUST
     C     SDSECS        PARM      SDSECS        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C**********         EVAL      DBKEY = @PCUST                                             234599
     C**********         EVAL      DBFILE = 'SDSECSPD'                                        234599
     C**********         MOVEL     '912'         DBASE                                        234599
     C**********         EXSR      *PSSR                                                      234599
     C                   CLEAR                   SDSECS                                       234599
     C                   END
 
      ** Branch details
 
     C**********         CALL      'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      V_TDBA        @DTDBA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      **  Database Error
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = '*KEY   '
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Country code details
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      A8LCCD        @DLCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
      **  Database Error
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = '*KEY   '
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     *BLANK        @PKEY1
     C                   MOVEL     V_TCNR        @PKEY1
 
      ** Customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    @PKEY1
     C                   PARM                    @PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C     PRTCD         IFNE      *BLANK
     C**********         MOVEL     @PKYST        DBKEY                                        234599
     C**********         EVAL      DBFILE = 'SDCUSTPD'                                        234599
     C**********         MOVEL     '903'         DBASE                                        234599
     C**********         EXSR      *PSSR                                                      234599
     C                   CLEAR                   SDCUST                                       234599
     C                   ENDIF
 
      ** Tax basket
 
     C                   EVAL      WCNCD = DVCNCD
     C**********         EVAL      WCNCZ = BBCNCZ                                             233038
     C                   EVAL      WCOLC = BBCOLC                                             233038
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT
     C**********         PARM      WCNCZ         @PCTRR                                       233038
     C                   PARM      WCOLC         @PCTRR                                       233038
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
     C                   IF        PRTCD = '*NRF   '
 
     C**********         EVAL      WCNCZ = *BLANK                                             233038
     C                   EVAL      WCOLC = *BLANK                                             233038
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCTRT
     C**********         PARM      WCNCZ         @PCTRR                                       233038
     C                   PARM      WCOLC         @PCTRR                                       233038
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      ** Database Error
 
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     @PCTRT        DBKEY
     C                   MOVE      @PCTRR        DBKEY
     C                   EVAL      DBFILE = 'SDCTTXPD'
     C                   MOVEL     '904'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Tax rate
 
     C                   MOVE      'N'           TXBSFlag
 
     C                   CALL      'AOTXBSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         @PCRTT
     C                   PARM      EWTXBS        @PTXBS
     C**********         PARM      BJRDNB        @PDATE                                       233867
     C                   PARM      V_TDVD        @PDATE                                       233867
     C                   PARM      *BLANK        @PNARR
     C                   PARM      *ZERO         @PRATE
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANK  AND
     C                             PRTCD <> '*NRF   '
     C                   MOVEL     @PCRTT        DBKEY
     C                   MOVE      @PTXBS        DBKEY
     C                   EVAL      DBFILE = 'SDTXBSPD'
     C                   MOVEL     '916'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *   If the retrieved Tax Basket is *BLANKS and the Customer is a Joint                235909
      *     Customer then perform Tax Calculations per member.                              235909
     C     EWTXBS        IFEQ      *BLANKS                                                  235909
     C     BBCUST        SETLL     SDJACCLB                               55                235909
     C                   ENDIF                                                              235909
                                                                                            235909
     C**********         IF        PRTCD = *BLANK                                           235909
     C                   IF        PRTCD = *BLANK OR *IN55=*ON                              235909
     C                   EVAL      WTRAB = @PRATE
     C                   MOVE      'Y'           TXBSFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCurrDet - Retrieve Currency Details                      *
      *****************************************************************
     C     SRRtvCurrDet  BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCURRKEY      PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = PCURR
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   MOVEL     '915'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCmpTxbAmtB - Compute for the taxable amount for Bonds       *
      *                                                               *                       236137
      * 236137 - Both calculation of Accrued Discount and Sold        *                       236137
      *          Interest taxable amounts were changed to take in     *                       236137
      *          account Tax Calculation Basis and De Minimis Rule    *                       236137
      *          from SDCTTXPD Country of Tax Codes.                  *                       236137
      *****************************************************************
     C     SRCmpTxbAmtB  BEGSR
 
      ** (1) Compute for Accrued Discount
                                                                                              234635
     C                   IF        V_TDTP <> 'TS'                                             234635
 
      ** If Tax Calculation Basis from SDCTTXPD Country of Tax is equal to 'S'                236137
      ** (Straight Line), WFSRD must be calculated as now:                                    236137
     C                   IF        EWTXCB = 'S'                                               236137
     C                   EVAL      WFSRD = V_FSPP - FAVPP
                                                                                              236137
      ** Else, if Tax Calculation Basis is 'A' (Actuarial), WFSRD must be                     236137
      ** calculated by using actuarial interpolation module.                                  236137
     C                   ELSE                                                                 236137
                                                                                              236137
      ** If the Issue Date is filled and the Issue Price is greater                           236137
      ** than 0 and less than 100, default Maturity Price to 100.                             236137
                                                                                              236137
     C                   EVAL      ZMATP = 0                                                  236137
     C                   IF        W_ISSD <> *ZERO AND                                        236137
     C                             W_ISSP > 0 AND W_ISSP < 100                                236137
     C                   EVAL      ZMATP = 100                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   EXSR      ZAACTUAR                                                   236137
     C                   EVAL      WFSRD = ZFSPR - FAVPP                                      236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C     WFSRD         IFLE      0
     C     W_ISSP        ORGE      100                                                        234577
     C     W_SPBS        OREQ      'U'                                                        234577
     C     CSNV          OREQ      0                                                          234577
     C                   EVAL      WTXAMTBD = 0
     C                   ELSE
     C**********         EVAL      WTXAMTBD = V_NOML * WFSRD                                  233774
     C                   EVAL      ZNOML = V_NOML                                             233774
     C                   EVAL      ZPRC  = WFSRD                                              233774
     C                   EXSR      SRZCNSD                                                    233774
     C                   EVAL      WTXAMTBD = ZCONS                                           233774
     C                   ENDIF
                                                                                              234440
     C                   ENDIF                                                                234635
                                                                                              234635
      * Calculate trade profit/loss = nominal sold * (trade price - average price)            234440
                                                                                              234440
     C**********         EVAL      ZNOML = V_NOML                                      234440 234797
     C**********         EVAL      ZPRC  = V_PRIC - AVPVD                              234440 234797
     C**********         EXSR      SRZCNSD                                             234440 234797
     C**********         Z-ADD     ZCONS         TradePL          15 0                 234440 234797
                                                                                              234440
      * Discount earned is lesser of trade p/l and accrued discount (No tax if a loss)        234440
                                                                                              234440
     C*****TradePL       IFLT      WTXAMTBD                                            234440 234797
     C**********         EVAL      WTXAMTBD = TradePL                                  234440 234797
     C**********         ENDIF                                                         234440 234797
     C*****WTXAMTBD      IFLT      0                                                   234440 234797
     C**********         EVAL      WTXAMTBD = 0                                        234440 234797
     C**********         ENDIF                                                         234440 234797
 
      ** (2) Compute for Sold Interest Discount
      ** Compute for the last coupon date
 
     C                   CALLB     'ZLCD'
     C                   PARM                    W_ISSD
     C                   PARM                    W_ITLD
     C                   PARM                    W_FCPN
     C                   PARM                    W_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    W_LCPN                                     BUG11164
     C                   PARM                    V_TDVD
     C                   PARM                    BJDFIN
     C                   PARM                    W_NMCY
     C                   PARM                    W_SITP
     C                   PARM                    W_BCNV
     C                   PARM                    W_HCY1                                       237063
     C                   PARM                    W_HCY2                                       237063
     C                   PARM                    W_HCY3                                       237063
     C                   PARM                    W_HCY4                                       237063
     C                   PARM                    W_HCY5                                       237063
     C                   PARM                    W_HCY6                                       237063
     C                   PARM                    W_HCY7                                       237063
     C                   PARM                    W_HCY8                                       237063
     C                   PARM                    W_HCY9                                       237063
     C                   PARM                    ZZLCD
 
     C**********         If        ZZLCD < EWEDT1 AND EWTRT1 = '1'                            234440
     C**********         EVAL      WSTART = EWEDT1                                            234440
     C**********         ELSE                                                                 234440
     C**********         EVAL      WSTART = ZZLCD                                             234440
     C**********         ENDIF                                                                234440
 
      ** Compute for the next coupon date
 
     C                   CALLB     'ZNCD'
     C                   PARM                    W_ITLD
     C                   PARM                    W_FCPN
     C                   PARM                    W_MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    V_TDVD
     C                   PARM                    BJDFIN
     C                   PARM                    W_NMCY
     C                   PARM                    W_SITP
     C                   PARM                    W_BCNV
     C                   PARM                    ZZLCD
     C                   PARM                    W_HCY1                                       237063
     C                   PARM                    W_HCY2                                       237063
     C                   PARM                    W_HCY3                                       237063
     C                   PARM                    W_HCY4                                       237063
     C                   PARM                    W_HCY5                                       237063
     C                   PARM                    W_HCY6                                       237063
     C                   PARM                    W_HCY7                                       237063
     C                   PARM                    W_HCY8                                       237063
     C                   PARM                    W_HCY9                                       237063
     C                   PARM                    ZZNCD
 
      ** Compute for the accrued coupon
 
     C                   IF        V_TDTP <> 'TS'                                             234635
                                                                                              234635
     C**********         EVAL      WAMT = V_NOML                                              234440
     C                   EVAL      WAMT = CSNV                                                234440
     C                   EVAL      IRATE = V_TDCR
 
      ***Retrieve*currency*details of nominal currency                                232543  234440
                                                                                              232543
     C**********         EVAL      WCURRKEY = W_NMCY                                   232543 233774
     C**********         EXSR      SRRtvCurrDet                                        232543 233774
     C**********         MOVE      A6NBDP        W_NMDP                                232543 233774
      *****************************************************************                232543 234440
     C*****W_NMDP        IFEQ      1                                                   233283 233774
     C*****W_NomCcyDec   IFEQ      1                                                   233774 234440
     C**********         EVAL      WAMT = WAMT *10                                     233283 234440
     C**********         ENDIF                                                         233283 234440
      *****************************************************************                233283 234440
     C*****W_NMDP        IFEQ      2                                                   233283 233774
     C*****W_NomCcyDec   IFEQ      2                                                   233774 234440
     C**********         EVAL      WAMT = WAMT *100                                    233283 234440
     C**********         ENDIF                                                         233283 234440
      *****************************************************************                233283 234440
     C*****W_NMDP        IFEQ      3                                                   233283 233774
     C*****W_NomCcyDec   IFEQ      3                                                   233774 234440
     C**********         EVAL      WAMT = WAMT *1000                                   233283 234440
     C**********         ENDIF                                                         233283 234440
                                                                                              233283
     C                   CALLB     'ZACCR'
     C                   PARM                    WAMT
     C                   PARM                    IRATE
     C**********         PARM                    WSTART                                       234440
     C                   PARM                    ZZLCD                                        234440
     C                   PARM                    V_TDVD
     C                   PARM                    SECTY
     C                   PARM                    W_IADJ
     C                   PARM                    ZZNCD
     C**********         PARM                    W_NMDP                                       233774
     C                   PARM                    W_NomCcyDec                                  233774
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
 
      ** Output
 
     C                   PARM                    ZZACINT1
     C                   PARM                    ZZACINT2
     C                   PARM                    ZRP
     C                   PARM                    NODAYS1
     C                   PARM                    NODAYS2
                                                                                              234797
      ** If position date is prior to last coupon date, purchased interest must be zeroized   234797
                                                                                              234797
     C     CSDA          IFLE      ZZLCD                                                      234797
     C                   Z-ADD     0             CSPI                                         234797
     C                   ENDIF                                                                234797
 
      ** Taxable accrued interest on the sale = Total accrued interest liquidated             234440
                                                                                              234440
     C     CSNV          IFNE      0                                                          234440
     C                   EVAL      WTXAMTBI = V_ITRA - (CSPI * V_NOML/CSNV)                   234440
                                                                                              236453
     C     WTXAMTBI      IFLT      0                                                          236453
     C                   EVAL      WTXAMTBI = 0                                               236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   ELSE                                                                 234440
     C                   EVAL      WTXAMTBI = 0                                               234440
     C                   ENDIF                                                                234440
                                                                                              234440
     C                   ENDIF                                                                234635
                                                                                              234635
     C                   IF        V_TDTP = 'TS' AND V_ACIN ='X'                              234635
     C                   IF        V_TDVD <= ZZNCD AND V_TDVD >= ZZLCD                        234635
     C                   EVAL      WTXAMTBI = V_ITRA * -1                                     234635
     C                   EVAL      WTXAMTBD = 0                                               234635
     C                   ELSE                                                                 234635
     C                   EVAL      WTXAMTBI = 0                                               234635
     C                   EVAL      WTXAMTBD = 0                                               234635
     C                   ENDIF                                                                234635
     C                   ENDIF                                                                234635
                                                                                              234635
     C                   IF        V_TDTP = 'TP' AND V_ACIN ='X'                              234635
     C                   IF        V_TDVD <= ZZNCD AND V_TDVD >= ZZLCD                        234635
     C                   EVAL      WTXAMTBI = 0                                               234635
     C                   ENDIF                                                                234635
     C                   ENDIF                                                                234635
                                                                                              234635
     C*****WSTART        IFEQ      ZZLCD                                                      234440
     C*****CSNV*         IFEQ      0                                                          234440
     C**********         EVAL      WPURINT = 0                                                234440
     C**********         ELSE                                                                 234440
     C**********         EVAL      WPINTM = V_NOML / CSNV                                     234440
     C**********         EVAL      WPURINT = CSPI * WPINTM                                    234440
     C**********         ENDIF                                                                234440
      *****************************************************************                       234440
     C**********         EVAL      ZZACINT1 = ZZACINT1 - WPURINT                              234440
     C**********         ENDIF                                                                234440
      **********                                                                              234440
     C**********         EVAL      WTXAMTBI = ZZACINT1                                        234440
      *****************************************************************                       234440
      ***Compute*for*the*tax*amount*for*Accrued*Discount***************                       234440
      ***or*Funds*Taxable*Amount***************************************                       234440
      *****************************************************************                       234440
     C**********         IF        EWTRT1 = '1'                                        233283 234440
     C**********         IF        V_TDVD > EWEDT1                                     233283 234440
     C**********         EVAL      WWDAY1 = V_TDVD - CSDA                              233283 234440
     C**********         EVAL      WWDAY2 = V_TDVD - EWEDT1                            233283 234440
     C**********         EVAL      WTXAMTBD = (WTXAMTBD * WWDAY2) / WWDAY1             233283 234440
     C**********         ELSE                                                          233283 234440
     C**********         EVAL      WTXAMTBD = *ZEROS                                   233283 234440
     C**********         ENDIF                                                         233283 234440
     C**********         ENDIF                                                         233283 234440
                                                                                              233283
      ** Determine if amortized discount is taxable or not depending on                       236137
      ** De Minimis Rule if it is applicable.                                                 236137
                                                                                              236137
     C                   IF        V_TDTP <> 'TS' AND W_ISSP < 100                            236137
                                                                                              236137
     C                   IF        EWDMAP = 'Y'                                               236137
                                                                                              236137
     C                   EVAL      WPRICE = 100 - W_ISSP                                      236137
     C                   IF        WPRICE <= EWTTDP                                           236137
                                                                                              236137
      ** Calculate the number of days from Issue Date to Maturity date, half-adjusted.        236137
     C                   EVAL(H)   WWDAYS = (W_MATY - W_ISSD) / 365                           236137
                                                                                              236137
     C                   IF        WWDAYS <> 0 AND                                            236137
     C                             (WPRICE / WWDAYS) <= EWYRDP                                236137
     C                   EVAL      WTXAMTBD = 0                                               236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
      ** Amortized premium can be offset against the coupons received for tax purpose.        236137
                                                                                              236137
     C                   IF        V_TDTP <> 'TS' AND W_ISSD <> 0                             236137
     C                                            AND W_ISSP > 100                            236137
     C                             AND EWPADD = 'Y'                                           236137
                                                                                              236137
      ** (a) Compute for premium amount.                                                      236137
                                                                                              236137
      ** If Tax Calculation Basis from SDCTTXPD Country of Tax is equal to 'S'                236137
      ** (Straight Line), premium amount must be calculated as follows:                       236137
     C                   IF        EWTXCB = 'S'                                               236137
     C                   EVAL      WFSRD = LAVP - 100                                         236137
                                                                                              236137
      ** Else, if Tax Calculation Basis is 'A' (Actuarial), premium amount                    236137
      ** must be calculated by using actuarial interpolation module.                          236137
     C                   ELSE                                                                 236137
                                                                                              236137
     C                   EVAL      ZMATP = 100                                                236137
     C                   EXSR      ZAACTUAR                                                   236137
     C                   EVAL      WFSRD = ZFSPR - 100                                        236137
                                                                                              236137
     C                   ENDIF                                                                236137
     C                   EVAL      ZNOML = V_NOML                                             236137
     C                   EVAL      ZPRC  = WFSRD                                              236137
     C                   EXSR      SRZCNSD                                                    236137
     C                   EVAL      WTXAMTBP = ZCONS                                           236137
                                                                                              236137
      ** (b) Compute for amortized premium amount from latter of the initial                  236137
      **     purchase date and the effective date when the transaction type is                236137
      **     equal to "1", what is already done within position management                    236137
      **     (ETCPOSND), and the sale value date.                                             236137
                                                                                              236137
     C                   EVAL      WTXAMTBP = ZCONS                                           236137
     C                                      * (V_TDVD - CSDA)                                 236137
     C                                      / (W_MATY - CSDA)                                 236137
                                                                                              236137
      ** (c) Deduct amortized premium amount from sold interest taxable amount.               236137
                                                                                              236137
     C                   EVAL      WTXAMTBI = WTXAMTBI - WTXAMTBP                             236137
     C                   IF        WTXAMTBI < 0                                               236137
     C                   EVAL      WTXAMTBI = 0                                               236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
      ** Compute for the tax amount for Accrued Discount                                      234440
                                                                                              234440
     C                   EVAL      WTXBLAMT = WTXAMTBD
     C                   EXSR      SRCmpTxAmtB1
 
      * Compute for the tax amount for Interest Sold (Bonds only)
 
     C                   EVAL      WTXBLAMT = WTXAMTBI
     C                   EXSR      SRCmpTxAmtB2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCmpTxbAmtF - Compute for the taxable amount for Funds       *
      *                                                               *                       236137
      * 236137 - Country of Tax Codes "TIS Taxable Only" indicator    *                       236137
      *          consideration for taxable amount calculation.        *                       236137
      *****************************************************************
     C     SRCmpTxbAmtF  BEGSR
                                                                                              233569
     C                   EVAL      WTXAMTF1 = *ZEROS                                          233569
     C                   EVAL      WTXAMTF2 = *ZEROS                                          233569
     C                   EVAL      WTXAMTF  = *ZEROS                                          233569
     C                   EVAL      WFAVPD   = *ZEROS                                          236411
      *                                                                                       236411
      * If purchase prior to the transition date, consider the higher of the NAV at trans.    236411
      * date and the Average price                                                            236411
      *                                                                                       236411
     c                   IF        APDT <= EWEDT1                                             236411
      *                                                                                       236411
     C                   EVAL      KSNSN = W_SESN                                             236411
     C                   EVAL      KSNET = 'PR'                                               236411
     C                   EVAL      KSNDT = EWEDT1                                             236411
     C     KSNDEV        SETLL     SNDEVDF                                                    236411
     C     KSNDEVP       READE     SNDEVDF                                33                  236411
                                                                                              236411
     C                   IF        *IN33 = *OFF AND                                           236411
     C                             RECI = 'D'                                                 236411
     C                   IF        SNPR >= AVPVD                                              236411
     C                   EVAL      AVPVD = SNPR                                               236411
     C                   ELSE                                                                 236411
     C                   EVAL      AVPVD = AVPVD                                              236411
     C                   ENDIF                                                                236411
     C                   ENDIF                                                                236411
                                                                                              236411
     C                   ENDIF                                                                236411
                                                                                              236411
 
     C                   If        V_FSPP > FAVPP AND  V_PRIC > AVPVD
     C                   EVAL      WFAVPD = V_FSPP - FAVPP
     C**********         EVAL      WTXAMTF1 = WFAVPD * V_NOML                                 233774
     C                   EVAL      ZNOML = V_NOML                                             233774
     C                   EVAL      ZPRC  = WFAVPD                                             233774
     C                   EXSR      SRZCNSD                                                    233774
     C                   EVAL      WTXAMTF1 = ZCONS                                           233774
                                                                                              233774
     C                   EVAL      WAVPD = V_PRIC - AVPVD
     C**********         EVAL      WTXAMTF2 = WAVPD * V_NOML                                  233774
     C                   EVAL      ZNOML = V_NOML                                             233774
     C                   EVAL      ZPRC  = WAVPD                                              233774
     C                   EXSR      SRZCNSD                                                    233774
     C                   EVAL      WTXAMTF2 = ZCONS                                           233774
     C                   ENDIF
 
     C     WTXAMTF1      IFGT      WTXAMTF2
     C     WFAVPD        ANDNE     *ZERO                                                      234010
     C                   EVAL      WTXAMTF = WTXAMTF2
     C                   ELSE
     C                   EVAL      WTXAMTF = WTXAMTF1
     C                   ENDIF
                                                                                              236137
      ** If Country of Tax Codes "TIS Taxable Only" indicator is set to "Y",                  236137
      ** taxable amount must be sale interest price minus the purchase interest               236137
      ** price (on an average basis if multiple purchases on the same position)               236137
      ** times the nominal being sold.                                                        236137
     C     EWTIST        IFEQ      'Y'                                                        236137
     C                   EVAL      WTXAMTF = WTXAMTF1                                         236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              234010
     C     WFAVPD        IFEQ      *ZERO                                                      234010
     C     V_FSPP        ANDEQ     *ZERO                                                      234010
     C     CSDA          IFGE      EWEDT1                                                     234010
     C                   EVAL      WAVPD = V_PRIC - AVPVD                                     234797
     C                   EVAL      ZNOML = V_NOML                                             234797
     C                   EVAL      ZPRC  = WAVPD                                              234797
     C                   EXSR      SRZCNSD                                                    234797
     C                   EVAL      WTXAMTF  = ZCONS                                           234797
     C**********         EVAL      WTXAMTF = WTXAMTF2                                  234010 234797
     C                   ELSE                                                                 234010
                                                                                              234010
     C                   EVAL      KSNSN = W_SESN                                             234010
     C                   EVAL      KSNET = 'PR'                                               234010
     C                   EVAL      KSNDT = EWEDT1                                             234010
     C     KSNDEV        SETLL     SNDEVDF                                                    234010
     C     KSNDEVP       READE     SNDEVDF                                33                  234010
                                                                                              234010
     C                   EVAL      WTXAMTF2 = *ZERO                                           234010
                                                                                              234010
     C                   IF        *IN33 = *OFF AND                                           234010
     C                             RECI = 'D'                                                 234010
      * Use Price rather than Fiscal Price from sndevd                                        234577
     C**********         IF        SNFP >= AVPVD                                       234010 234577
     C**********         EVAL      WAVPD = V_PRIC - SNFP                               234010 234577
     C                   IF        SNPR >= AVPVD                                              234577
     C                   EVAL      WAVPD = V_PRIC - SNPR                                      234577
     C                   ELSE                                                                 234010
     C                   EVAL      WAVPD = V_PRIC - AVPVD                                     234010
     C                   ENDIF                                                                234010
                                                                                              234010
     C                   EVAL      ZNOML = V_NOML                                             234010
     C                   EVAL      ZPRC  = WAVPD                                              234010
     C                   EXSR      SRZCNSD                                                    234010
     C                   EVAL      WTXAMTF2 = ZCONS                                           234010
                                                                                              234010
     C                   ELSE                                                                 234010
                                                                                              234010
     C                   EVAL      WAVPD = V_PRIC - AVPVD                                     234010
     C                   EVAL      ZNOML = V_NOML                                             234010
     C                   EVAL      ZPRC  = WAVPD                                              234010
     C                   EXSR      SRZCNSD                                                    234010
     C                   EVAL      WTXAMTF2 = ZCONS                                           234010
                                                                                              234010
     C                   ENDIF                                                                234010
                                                                                              234010
     C                   EVAL      WTXAMTF = WTXAMTF2                                         234010
     C                   ENDIF                                                                234010
     C                   ENDIF                                                                234010
                                                                                              234797
      ***When*negative*delta*fiscal*price,*taxable*amount*equal*zero*in*Lux.*and       234797 236137
      ***delta*NAV*in*Switzerland                                                      234797 236137
      ** When negative delta fiscal price, taxable amount must be delta Nav when              236137
      ** Tax Calculation Basis was set to "S"' within Country of Tax Codes file               236137
      ** and set to 0 otherwise.                                                              236137
                                                                                              234797
     C     FAVPP         IFGT      V_FSPP                                                     234797
     C*****WCNCD         IFEQ      'CH'                                                234797 236411
     C**********         EVAL      WAVPD = V_PRIC - AVPVD                              234797 236411
     C**********         EVAL      ZNOML = V_NOML                                      234797 236411
     C**********         EVAL      ZPRC  = WAVPD                                       234797 236411
     C**********         EXSR      SRZCNSD                                             234797 236411
     C**********         EVAL      WTXAMTF  = ZCONS                                    234797 236411
     C**********         ELSE                                                          234797 236411
     C                   EVAL      WTXAMTF = *ZERO                                            234797
     C**********         ENDIF                                                         234797 236411
     C                   ENDIF                                                                234797
                                                                                              234797
     C     WTXAMTF       IFLT      *ZERO                                                      234797
     C                   EVAL      WTXBLAMT = *ZERO                                           234797
     C                   ELSE                                                                 234797
     C                   EVAL      WTXBLAMT = WTXAMTF
     C                   EXSR      SRCmpTxAmtB1
     C                   ENDIF                                                                234797
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  233774
      *****************************************************************                       233774
      * SRZCNSD - Subroutine to calculate for the consideration       *                       233774
      *****************************************************************                       233774
     C     SRZCNSD       BEGSR                                                                233774
                                                                                              233774
     C                   CALLB     'ZCNSD'                                                    233774
     C                   PARM                    ZNOML                                        233774
     C                   PARM                    ZPRC                                         233774
     C                   PARM                    W_SPBS                                       233774
     C                   PARM                    W_NMDP                                       233774
     C                   PARM                    W_NomCcyDec                                  233774
     C                   PARM                    ZCONS                                        233774
                                                                                              233774
     C                   ENDSR                                                                233774
      *****************************************************************                       233774
      /EJECT
      *****************************************************************
      * SRCmpTxAmtB1 - Compute for the tax amount for Accrued Discount*
      *              or Funds Taxable Amount                          *
      *****************************************************************
     C     SRCmpTxAmtB1  BEGSR
                                                                                              234577
      ** Initialize parameter fields                                                          234577
                                                                                              234577
     C                   EVAL      @@JANO = *Zeros                                            234577
     C                   EVAL      @@NARF = *Blanks                                           234577
     C                   EVAL      @@INVP = *Blanks                                           234577
 
      ** Call Zatxclpi module
 
     C                   EXSR      SRZatxclpi
 
     C                   SELECT
 
     C                   WHEN      @@RTRN = 'ERROR'
     C                   EVAL      DBKEY = @@KEY
     C                   EVAL      DBFILE = @@FILE
     C                   MOVEL     '906'         DBASE
     C                   EXSR      *PSSR
 
     C                   WHEN      @@RTRN <> 'JOINT'
 
     C                   If        @@STAT = 'TAXAB' or @@STAT = 'DISCL'
     C                             or @@STAT = 'SELF'
     C                   EXSR      SRTaxAmtCalc
     C                   MOVE      'Y'           WAmorDscF
     C                   EXSR      SRWritetoFile
     C                   EVAL      EUTX = @@TAXA
     C                   EVAL      EUTS = @@TAXA
     C                   ENDIF
 
     C                   WHEN      @@RTRN = 'JOINT'
     C                   EXSR      SRJoint1
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCmpTxAmtB2 - Compute for the tax amount for Interest Sold   *
      *              (Bonds Only)                                     *
      *****************************************************************
     C     SRCmpTxAmtB2  BEGSR
                                                                                              234577
      ** Initialize parameter fields                                                          234577
                                                                                              234577
     C                   EVAL      @@JANO = *Zeros                                            234577
     C                   EVAL      @@NARF = *Blanks                                           234577
     C                   EVAL      @@INVP = *Blanks                                           234577
 
      ** Call Zatxclpi module
 
     C                   EXSR      SRZatxclpi
 
     C                   SELECT
 
     C                   WHEN      @@RTRN = 'ERROR'
     C                   EVAL      DBKEY = @@KEY
     C                   EVAL      DBFILE = @@FILE
     C                   MOVEL     '909'         DBASE
     C                   EXSR      *PSSR
 
     C                   WHEN      @@RTRN <> 'JOINT'
 
     C                   If        @@STAT = 'TAXAB' or @@STAT = 'DISCL'
     C                             or @@STAT = 'SELF'
     C                   EXSR      SRTaxAmtCalc
     C                   MOVE      'Y'           WIntSldFl
     C                   EXSR      SRWritetoFile
     C                   EVAL      EUTX = EUTX + @@TAXA
     C                   EVAL      EUTS = EUTS + @@TAXA
     C                   ENDIF
 
     C                   WHEN      @@RTRN = 'JOINT'
     C                   EXSR      SRJoint2
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRJoint1 - 'JOINT' return code on accrued discount or funds   *
      *          taxable amount calculation                           *
      *****************************************************************
     C     SRJoint1      BEGSR
 
     C                   MOVEL     V_TCNR        WJANO
     C                   EVAL      WCUST = *BLANK
 
     C     WJANO         SETLL     SDJACCLB
     C                   READ      SDJACCLB
 
     C                   DOW       NOT %EOF(SDJACCLB)
     C                             AND JCJANO = WJANO
 
     C                   EXSR      SRZatxclja
 
     C                   If        @@RTRN = 'ERROR'
     C                   EVAL      DBKEY = @@KEY
     C                   EVAL      DBFILE = @@FILE
     C                   MOVEL     '907'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   If        @@STAT = 'TAXAB' or @@STAT = 'DISCL'
     C                             or @@STAT = 'SELF'
     C                   EXSR      SRTaxAmtCalc
     C                   MOVE      'Y'           WAmorDscF
     C                   EXSR      SRWritetoFile
     C                   EVAL      EUTX = EUTX + @@TAXA
     C                   EVAL      EUTS = EUTS + @@TAXA
     C                   ENDIF
 
     C                   If        @@RTRN = 'NOTAX'
     C                             or @@RTRN = 'TAXAB'
     C                   READ      SDJACCLB
     C                   ENDIF
 
     C                   If        @@RTRN = 'LAST '
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRJoint2 - 'JOINT' return code on accrued discount or funds   *
      *          taxable amount calculation                           *
      *****************************************************************
     C     SRJoint2      BEGSR
 
     C                   MOVEL     V_TCNR        WJANO
     C                   EVAL      WCUST = *BLANK
 
     C     WJANO         SETLL     SDJACCLB
     C                   READ      SDJACCLB
 
     C                   DOW       NOT %EOF(SDJACCLB)
     C                             AND JCJANO = WJANO
 
     C                   EXSR      SRZatxclja
 
     C                   If        @@RTRN = 'ERROR'
     C                   EVAL      DBKEY = @@KEY
     C                   EVAL      DBFILE = @@FILE
     C                   MOVEL     '910'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   If        @@STAT = 'TAXAB' or @@STAT = 'DISCL'
     C                             or @@STAT = 'SELF'
     C                   EXSR      SRTaxAmtCalc
     C                   MOVE      'Y'           WIntSldFl
     C                   EXSR      SRWritetoFile
     C                   EVAL      EUTX = EUTX + @@TAXA
     C                   EVAL      EUTS = EUTS + @@TAXA
     C                   ENDIF
 
 
     C                   If        @@RTRN = 'NOTAX'
     C                             or @@RTRN = 'TAXAB'
     C                   READ      SDJACCLB
     C                   ENDIF
 
     C                   If        @@RTRN = 'LAST '
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZatxclpi - Call ZATXCLPI module                             *
      *****************************************************************
     C     SRZatxclpi    BEGSR
 
     C                   CALL      'ZATXCLPI'
 
      ** Module Id
      ** Transaction Reference
      ** Branch Code
      ** Customer Number
      ** Interest Calculation Start Date
      ** Interest Calculation End Date
      ** Total Interest Amount
      ** Tax Rate Applicable for Band
      ** Settlement Currency
 
     C                   PARM      'S'           @@MODI
     C                   PARM      V_TDRF        @@TRRF
     C                   PARM      V_TDBA        @@BRCA
     C                   PARM      WWCUST        @@CUST
     C                   PARM      0             @@STRD
     C                   PARM      0             @@ENDD
     C                   PARM      WTXBLAMT      @@TOTI
     C                   PARM      WTRAB         @@TAXR
     C                   PARM      V_SETC        @@OCCY
     C                   PARM      *BLANKS       PInth                                        CER048
 
      ** Output
      ** Interest Amount at Effective Date
      ** Tax amount
      ** Interest Amount
      ** Tax Currency
      ** Country of tax
      ** Tax Basket
      ** EU Withholding Tax Account Code
      ** Country of Location
      ** Customer Status
      ** Transition Type at End
      ** Tax Rate of Tax Period 1
      ** Database Error Key
      ** Database Error File
      ** Return Code
 
     C                   PARM                    @@IAED
     C                   PARM                    @@TAXA
     C                   PARM                    @@TOTO
     C                   PARM                    @@TXCY
     C                   PARM                    @@CTAX
     C                   PARM                    @@TXBS
     C                   PARM                    @@WTAC
     C                   PARM                    @@COLC
     C                   PARM                    @@STAT
     C                   PARM                    @@TRTE
     C                   PARM                    @@TXR1
     C**********         PARM      *ZEROS        PStxb                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStac                               CER048 BUG22911
     C**********         PARM      *ZEROS        PSttr                               CER048 BUG22911
     C**********         PARM      *BLANKS       PSttp                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStxa                               CER048 BUG22911
     C                   PARM                    @@KEY
     C                   PARM                    @@FILE
     C                   PARM                    @@RTRN
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
 
      * If Calculated tax is negative, reset the tax to zero.                                 236346
     C     @@TAXA        IFLT      *ZERO                                                      236346
     C                   Eval      @@TAXA = 0                                                 236346
     C                   EndIf                                                                236346
                                                                                              236346
     C     @@TOTO        IFLT      *ZERO                                                      236346
     C                   Eval      @@TOTO = 0                                                 236346
     C                   EndIf                                                                236346
                                                                                              236346
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZatxclja - Call ZATXCLJA module                             *
      *****************************************************************
     C     SRZatxclja    BEGSR
 
     C                   CALL      'ZATXCLJA'
 
      ** Module Id
      ** Transaction Reference
      ** Branch Code
      ** Joint Account Number
      ** Customer Number
      ** Non-account Holder Reference
      ** Investment Proportion
      ** Interest Calculation Start Date
      ** Interest Calculation End Date
      ** Total Interest Amount
      ** Tax Rate Applicable for Band
      ** Settlement Currency
 
     C                   PARM      'S'           @@MODI
     C                   PARM      V_TDRF        @@TRRF
     C                   PARM      V_TDBA        @@BRCA
     C                   PARM      WWCUST        @@JANO
     C                   PARM      JCCUST        @@CUST
     C                   PARM      JCNAHO        @@NARF
     C                   PARM      JCINVP        @@INVP
     C                   PARM      JCPAHT        @@PAHT            1                        BUG26839
     C                   PARM      0             @@STRD
     C                   PARM      0             @@ENDD
     C                   PARM      WTXBLAMT      @@TOTI
     C                   PARM      WTRAB         @@TAXR
     C                   PARM      V_SETC        @@OCCY
     C                   PARM      *BLANKS       PInth                                        CER048
 
      ** Output
      ** Interest Amount at Effective Date
      ** Tax amount
      ** Interest Amount
      ** Tax Currency
      ** Country of tax
      ** Tax Basket
      ** EU Withholding Tax Account Code
      ** Country of Location
      ** Customer Status
      ** Transition Type at End
      ** Tax Rate of Tax Period 1
      ** Database Error Key
      ** Database Error File
      ** Return Code
 
     C                   PARM                    @@IAED
     C                   PARM                    @@TAXA
     C                   PARM                    @@TOTO
     C                   PARM                    @@TXCY
     C                   PARM                    @@CTAX
     C                   PARM                    @@TXBS
     C                   PARM                    @@WTAC
     C                   PARM                    @@COLC
     C                   PARM                    @@STAT
     C                   PARM                    @@TRTE
     C                   PARM                    @@TXR1
     C                   PARM                    @@JAMG
     C**********         PARM      *ZEROS        PStxb                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStac                               CER048 BUG22911
     C**********         PARM      *ZEROS        PSttr                               CER048 BUG22911
     C**********         PARM      *BLANKS       PSttp                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStxa                               CER048 BUG22911
     C                   PARM                    @@KEY
     C                   PARM                    @@FILE
     C                   PARM                    @@RTRN
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
 
      * If Calculated tax is negative, reset the tax to zero.                                 236346
     C     @@TAXA        IFLT      *ZERO                                                      236346
     C                   Eval      @@TAXA = 0                                                 236346
     C                   EndIf                                                                236346
                                                                                              236346
     C     @@TOTO        IFLT      *ZERO                                                      236346
     C                   Eval      @@TOTO = 0                                                 236346
     C                   EndIf                                                                236346
                                                                                              236346
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTaxAmtCalc - Tax amount computation based from tax          *
      *                calculation method.                            *
      *****************************************************************
     C     SRTaxAmtCalc  BEGSR
 
     C     TXCMKEY       CHAIN     SDTXCML1
     C                   IF        NOT %FOUND(SDTXCML1)
     C                   EVAL      TCTXCM = 1
     C                   ENDIF
 
      ** Tax calculation method = 1 or no record found on SDTXCML1
 
     C                   SELECT
     C                   WHEN      TCTXCM = 1 or WLTAX = 0
     C                   EVAL      @@TAXA = @@TAXA
 
      ** Tax calculation method = 2
 
     C                   WHEN      TCTXCM = 2
     C**********         EVAL      WTAXAMTIS = @@TAXR * (@@TOTI - (WLTAX *                    234440
     C**********                   @@TOTI / 100)) / 100                                       234440
     C                   EVAL      WTAXAMTIS = @@TAXR * (@@TOTO - (WLTAX *                    234440
     C                             @@TOTO / 100)) / 100                                       234440
     C     WTAXAMTIS     IFLT      0
     C                   EVAL      @@TAXA = 0
     C                   ELSE
     C                   EVAL      @@TAXA = WTAXAMTIS
     C                   ENDIF
 
      ** Tax calculation method = 3
 
     C                   WHEN      TCTXCM = 3
     C**********         EVAL      WTAXAMTIS = @@TAXA - (WLTAX * @@TOTI / 100)                234440
     C                   EVAL      WTAXAMTIS = @@TAXA - (WLTAX * @@TOTO / 100)                234440
     C     WTAXAMTIS     IFLT      0
     C                   EVAL      @@TAXA = 0
     C                   ELSE
     C                   EVAL      @@TAXA = WTAXAMTIS
     C                   ENDIF
 
      ** Tax calculation method = 4
 
     C                   WHEN      TCTXCM = 4
     C                   EVAL      @@TAXA = 0
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRWritetoFile  - Write to PF/SDCSINPD                         *
      *****************************************************************
     C     SRWritetoFile BEGSR
 
      ** Initialize fields of PF/SDCSINPD
 
     C                   EXSR      SRInitFields
 
      ** Customer income generation date
      ** Tax calculation Date
 
     C                   EVAL      TSRDNB = BJRDNB
     C                   EVAL      TSEDAT = V_TDVD
 
      ** Tax year and month
 
     C                   EVAL      ZDAYNO = V_TDVD
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZDATE         WMMDD
     C                   MOVE      ZDATE         WYear1
 
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     WMMDD         WMonth
     C                   ELSE
     C                   MOVE      WMMDD         WMonth
     C                   ENDIF
 
     C                   EVAL      WYear2 = '20' + Wyear1
     C                   MOVEL     WYear2        TSTAXY
     C                   EVAL      TSTAXM = WMonth
 
      ** Country of tax
      ** Booking branch code
      ** Joint account number
      ** Customer number
      ** Non-account holder reference
      ** Investment type
      ** Residence country code
 
     C                   EVAL      TSCTRT = @@CTAX
     C                   EVAL      TSBRCA = @@BRCA
     C                   MOVEL     @@JANO        TSJOIN
     C                   EVAL      TSCUST = @@CUST
     C                   EVAL      TSNAHO = @@NARF
     C                   EVAL      TSINVP = @@INVP
     C                   EVAL      TSRCTR = @@COLC
 
      ** Customer Status
 
     C                   SELECT
     C     @@STAT        WHENEQ    'DISCL'
     C                   EVAL      TSSTAT = 'D'
     C     @@STAT        WHENEQ    'SELF'
     C                   EVAL      TSSTAT = 'S'
     C     @@STAT        WHENEQ    'TAXAB'
     C                   EVAL      TSSTAT = 'T'
     C                   ENDSL
 
     C     @@NARF        IFNE      *BLANK
 
      ** Retrieve non account holder details
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      @@NARF        @PNAHO
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = @PNAHO
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   MOVEL     '914'         DBASE
     C                   EXSR      *PSSR
 
     C                   ELSE
      ** Family name
      ** First name
      ** Street
      ** Zip code
      ** City
      ** Tax identification number
      ** Date of birth
      ** Country code of birth
     C                   EVAL      TSFAMN = NHIDE1
     C                   EVAL      TSFIRN = NHIDE2
     C                   EVAL      TSSTRT = NHIDE3 + ' ' + NHIDE4
     C                   EVAL      TSZIPC = NHZIPC
     C                   EVAL      TSCITY = NHCITY
     C                   EVAL      TSRTIN = NHTINO
     C                   EVAL      TSDBTH = NHDBTH
     C                   EVAL      TSTBTH = NHBTHT
     C                   EVAL      TSCBTH = NHBTHC
     C                   ENDIF
 
     C                   ELSE
     C     @@CUST        IFNE      *BLANK
 
      ** Retrieve additional customer details.
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      @@CUST        @PCUST
     C     SDACUS        PARM      SDACUS        DSSDY
 
      ** Database error.
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = @PCUST
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   MOVEL     '913'         DBASE
     C                   EXSR      *PSSR
 
     C                   ELSE
      ** Family name
      ** First name
      ** Street
      ** Zip code
      ** City
      ** Tax identification number
      ** Date of birth
      ** Country code of birth
     C                   EVAL      TSFAMN = E5CNA1
     C                   EVAL      TSFIRN = E5CNA2
     C                   EVAL      TSSTRT = E5CNA3 + ' ' + E5CNA4
     C                   EVAL      TSZIPC = E5ZIPC
     C                   EVAL      TSCITY = E5CITY
     C                   EVAL      TSRTIN = E5TINO
     C                   EVAL      TSDBTH = E5DBTH
     C                   EVAL      TSTBTH = E5BTHT
     C                   EVAL      TSCBTH = E5BTHC
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Interest payment date
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    V_TDVD
     C                   PARM                    WDATEYYYY
     C                   PARM                    RetCodeIn
     C                   EVAL      TSIPDT = WDATEYYYY
 
      ** Tax basket
      ** Eu withholding tax code
 
     C                   MOVEL     @@TXBS        TSTXBS
     C                   EVAL      TSWTAC = @@WTAC
 
      ** Original currency code
 
     C                   EVAL      TSOCCY = W_NMCY
     C                   EVAL      WCURRKEY = TSOCCY
 
      ** Retrieve currency details of original currency
 
     C                   EXSR      SRRtvCurrDet
 
      ** Original currency spot rate
 
     C     A6MDIN        IFEQ      'D'
     C                   EVAL      TSOCSR = A6SPRT
     C                   ELSE
     C                   EVAL      TSOCSR = 1 / A6SPRT
     C                   ENDIF
 
      ** Original currency multiply/divide
      ** Original currency decimal places
 
     C                   EVAL      TSOCMD = 'D'
     C                   EVAL      TSOCDP = A6NBDP
     C                   EVAL      ZADEC  = A6NBDP
 
      ** Settlement currency code
 
     C                   EVAL      TSSCCY = V_SETC
     C                   EVAL      WCURRKEY = TSSCCY
 
      ** Retrieve currency details of settlement currency
 
     C                   EXSR      SRRtvCurrDet
 
      ** Settlement currency spot rate
 
     C     A6MDIN        IFEQ      'D'
     C                   EVAL      TSSCSR = A6SPRT
     C                   ELSE
     C                   EVAL      TSSCSR = 1 / A6SPRT
     C                   ENDIF
 
      ** Settlement currency multiply/divide
      ** Settlement currency decimal places
 
     C                   EVAL      TSSCMD = 'D'
     C                   EVAL      TSSCDP = A6NBDP
 
      ** Tax currency code
 
     C                   EVAL      TSTXCY = @@TXCY
     C                   EVAL      WCURRKEY = TSTXCY
 
      ** Retrieve currency details of tax currency
 
     C                   EXSR      SRRtvCurrDet
 
      ** Tax currency spot rate
 
     C     A6MDIN        IFEQ      'D'
     C                   EVAL      TSTCSR = A6SPRT
     C                   ELSE
     C                   EVAL      TSTCSR = 1 / A6SPRT
     C                   ENDIF
 
      ** Tax currency multiply/divide
      ** Tax currency decimal places
 
     C                   EVAL      TSTCMD = 'D'
     C                   EVAL      TSTCDP = A6NBDP
 
      ** Original/settlement currency exchange rate
 
     C                   EVAL      TSXROS = V_TDER
 
      ** Retrieve currency exchange rate
 
     C                   EVAL      ZRATE1 = TSSCSR
     C                   EVAL      ZRATE2 = TSTCSR
     C                   EVAL      ZMDI1 = TSSCMD
     C                   EVAL      ZMDI2 = TSTCMD
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      *ZERO         ZRATEX
     C                   PARM      *BLANK        ZMDIX
 
      ** Settlement/tax currency exchange rate
      ** Original/settlement cross rate multiply/divide
      ** Settlement/tax cross rate multiply /divide
 
     C                   EVAL      TSXRST = ZRATEX
     C                   EVAL      TSOSMD = V_TMDI
     C                   EVAL      TSSTMD = ZMDIX
 
      ** Module identifier
 
     C                   EVAL      TSMODI = 'S'
 
      ** Instrument reference
 
     C                   IF        WAmorDscF = 'Y'
     C                   EVAL      TSINST = V_TDRF + ' - Amortised Discount'
     C                   MOVE      'N'           WAmorDscf
     C                   ENDIF
 
     C                   IF        WIntSldFl = 'Y'
     C                   EVAL      TSINST = V_TDRF + ' - Interest Sold'
     C                   MOVE      'N'           WintSldFl
     C                   ENDIF
 
      ** Deal Type/Trade type
      ** Deal sub-type/trade sub-type
      ** Deal number/trade number
 
     C                   EVAL      TSTRTP = V_TDTP
     C                   EVAL      TSTRST = V_TSUB
     C                   MOVEL     V_TDRF        TSDLLN
 
      ** Account code
      ** Account sequence
      ** IBAN number
 
     C                   EVAL      TSACOD = 0
     C                   EVAL      TSACSQ = 0
     C                   EVAL      TSIBAN = *BLANK
 
      ** Security event type
      ** Security shortname
      ** Security report name
      ** Security ISIN number
 
     C                   EVAL      TSETYP = *BLANK
     C                   EVAL      TSSESN = W_SESN
     C                   EVAL      TSSRPN = W_SRPN
     C                   EVAL      TSISIN = W_ISNO
 
      ** Principal amount in original currency
      ** Gross interest amount in original currency
 
     C                   EVAL      TSPAMT = V_TCTR
     C                   EVAL      TSGINT = @@TOTO
 
      ** Tax rate
      ** Tax deducted at source in original currency
 
     C     TSSTAT        IFEQ      'T'
     C                   EVAL      TSTXRT = @@TAXR
     C                   EVAL      TSTXSR = @@TAXA
     C                   ENDIF
 
      ** Net interest amount in original ccy
 
     C                   EVAL      TSNINT = TSGINT - TSTXSR
 
      ** Principal amount in settlement currency
 
     C     TSOCCY        IFEQ      TSSCCY
     C                   EVAL      TSPAMS = TSPAMT
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSPAMT        ZAMTCI
     C                   PARM      TSXROS        ZEXCH
     C                   PARM      TSOSMD        ZMD
     C                   PARM      TSOCCY        ZCCYI
     C                   PARM      TSSCCY        ZCCYO
     C                   PARM      TSOCDP        ZCDPI
     C                   PARM      TSSCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSPAMS = ZAMTCO
     C                   ENDIF
 
      ** Gross interest amount in settlement currency
 
     C     TSOCCY        IFEQ      TSSCCY
     C                   EVAL      TSGINS = @@TOTO
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      @@TOTO        ZAMTCI
     C                   PARM      TSXROS        ZEXCH
     C                   PARM      TSOSMD        ZMD
     C                   PARM      TSOCCY        ZCCYI
     C                   PARM      TSSCCY        ZCCYO
     C                   PARM      TSOCDP        ZCDPI
     C                   PARM      TSSCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSGINS = ZAMTCO
     C                   ENDIF
 
      ** Tax deducted at source in settlement currency
 
     C     TSOCCY        IFEQ      TSSCCY
     C                   EVAL      TSTXSS = @@TAXA
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      @@TAXA        ZAMTCI
     C                   PARM      TSXROS        ZEXCH
     C                   PARM      TSOSMD        ZMD
     C                   PARM      TSOCCY        ZCCYI
     C                   PARM      TSSCCY        ZCCYO
     C                   PARM      TSOCDP        ZCDPI
     C                   PARM      TSSCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSTXSS = ZAMTCO
     C                   ENDIF
 
      ** Net interest amount in settlement currency
      ** Principal amount in tax currency
 
     C                   EVAL      TSNINS = TSGINS - TSTXSS
     C     TSTXCY        IFEQ      TSSCCY
     C                   EVAL      TSPAMC = TSPAMS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSPAMS        ZAMTCI
     C                   PARM      TSXRST        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      TSTXCY        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      TSTCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSPAMC = ZAMTCO
     C                   ENDIF
 
      ** Gross interest amount in tax currency
 
     C     TSTXCY        IFEQ      TSSCCY
     C                   EVAL      TSGINC = TSGINS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSGINS        ZAMTCI
     C                   PARM      TSXRST        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      TSTXCY        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      TSTCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSGINC = ZAMTCO
     C                   ENDIF
 
      ** Tax deducted at source in tax currency
 
     C     TSTXCY        IFEQ      TSSCCY
     C                   EVAL      TSTXSC = TSTXSS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSTXSS        ZAMTCI
     C                   PARM      TSXRST        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      TSTXCY        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      TSTCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSTXSC = ZAMTCO
     C                   ENDIF
 
      ** Net interest amount in tax currency
 
     C                   EVAL      TSNINC = TSGINC - TSTXSC
 
      ** Retrieve currency details of bank currency
 
     C                   EVAL      WCURRKEY = BJCYCD
     C                   EXSR      SRRtvCurrDet
 
      ** Principal amount in base currency
 
     C     BJCYCD        IFEQ      TSSCCY
     C                   EVAL      TSPAMB = TSPAMS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSPAMS        ZAMTCI
     C                   PARM      TSSCSR        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      BJCYCD        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      A6NBDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSPAMB = ZAMTCO
     C                   ENDIF
 
      ** Gross interest amount in base currency
 
     C     BJCYCD        IFEQ      TSSCCY
     C                   EVAL      TSGINB = TSGINS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSGINS        ZAMTCI
     C                   PARM      TSSCSR        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      BJCYCD        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      A6NBDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSGINB = ZAMTCO
     C                   ENDIF
 
      ** Tax deducted at source in base currency
 
     C     BJCYCD        IFEQ      TSSCCY
     C                   EVAL      TSTXSB = TSTXSS
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      TSTXSS        ZAMTCI
     C                   PARM      TSSCSR        ZEXCH
     C                   PARM      TSSTMD        ZMD
     C                   PARM      TSSCCY        ZCCYI
     C                   PARM      BJCYCD        ZCCYO
     C                   PARM      TSSCDP        ZCDPI
     C                   PARM      A6NBDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSTXSB = ZAMTCO
     C                   ENDIF
 
      ** Net interest amount in base currency
 
     C                   EVAL      TSNINB = TSGINB - TSTXSB
 
      ** Customer income processed
 
     C                   EVAL      TSINPR = 'N'
 
      ** Write record to SDCSINPD if process flag parameter = Insert
 
     C                   IF        ProcFlag = 'I'
 
      ** Get transaction no of last update, one for every trade number
 
     C                   IF        WTNLUFlag = 'N'
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PTSTNLU
     C                   MOVE      'Y'           WTNLUFlag
     C                   ENDIF
     C                   EVAL      TSTNLU = PTSTNLU
 
     C                   WRITE     SDCSIND0
     C                   ENDIF
 
      ** Change SDCSINPD during Change mode.
 
     C                   IF        ProcFlag = 'C'and WFndCSIN = 'Y'
     C                             OR        ProcFlag = 'A'and WFndCSIN = 'Y'
     C                   EVAL      TSTNLU = WOldTNLU
     C**********         UPDATE    SDCSIND6                                                   236732
     C**********         READ      SDCSIND6                                                   236732
     C                   UPDATE    SDCSINDL                                                   236732
     C     KCSIN         READE(E)  SDCSINDL                                                   236732
     C                   IF        NOT %EOF(SDCSINLD)                                         236732
     C                   MOVE      'Y'           WFndCSIN                                     236732
     C                   MOVE      TSTNLU        WOldTNLU                                     236732
     C                   ELSE                                                                 236732
     C                   EVAL      WFndCSIN = 'N'                                             236732
     C                   ENDIF                                                                236732
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInitFields - Initialise PF/SDCSINPD                         *
      *****************************************************************
     C     SRInitFields  BEGSR
 
     C                   EVAL      TSTAXY = 0
     C                   EVAL      TSTAXM = 0
     C*****              EVAL      TSJOIN = 0                                                CSD027A
     C                   EVAL      TSJOIN = *BLANK                                           CSD027A
     C                   EVAL      TSNAHO = *BLANK
     C                   EVAL      TSINVP = *BLANK
     C                   EVAL      TSSTAT = *BLANK
     C                   EVAL      TSFAMN = *BLANK
     C                   EVAL      TSFIRN = *BLANK
     C                   EVAL      TSSTRT = *BLANK
     C                   EVAL      TSZIPC = *BLANK
     C                   EVAL      TSCITY = *BLANK
     C                   EVAL      TSRTIN = *BLANK
     C                   EVAL      TSDBTH = *BLANK
     C                   EVAL      TSTBTH = *BLANK
     C                   EVAL      TSCBTH = *BLANK
     C                   EVAL      TSTXRT = 0
     C                   EVAL      TSTXSR = 0
     C                   EVAL      TSNINT = 0
     C                   EVAL      TSPAMS = 0
     C                   EVAL      TSGINS = 0
     C                   EVAL      TSTXSS = 0
     C                   EVAL      TSNINS = 0
     C                   EVAL      TSPAMC = 0
     C                   EVAL      TSGINC = 0
     C                   EVAL      TSTXSC = 0
     C                   EVAL      TSNINC = 0
     C                   EVAL      TSPAMB = 0
     C                   EVAL      TSGINB = 0
     C                   EVAL      TSTXBS = 0
     C                   EVAL      TSNINB = 0
     C                   EVAL      TSTNLU = 0
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EVAL      TSSTXB = *ZEROS                                            CER048
     C                   EVAL      TSSTAC = *ZEROS                                            CER048
     C                   EVAL      TSSTRT = *ZEROS                                            CER048
     C                   EVAL      TSSTDO = *ZEROS                                            CER048
     C                   EVAL      TSSTDS = *ZEROS                                            CER048
     C                   EVAL      TSSTDT = *ZEROS                                            CER048
     C                   EVAL      TSSTDB = *ZEROS                                            CER048
     C                   EVAL      TSPTHU = *ZEROS                                            CER048
     C                   EVAL      TSPTUT = *ZEROS                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       233566
      **SRCalCSAV*-*Subroutine*to*Calculate*the*Average*Fiscal*Price***                233566 234440
      **************Numerator*at*Value*Date****************************                233566 234440
      *****************************************************************                       233566
     C*****SRCalCSAV     BEGSR                                                         233566 234440
      *****************************************************************                233566 234440
      ***Retrieve*Market*indicator*from*CDEPPD*************************                233566 236812
      *****************************************************************                233566 236812
     C**********         EXSR      SRRtvMktInd                                         233566 236812
      *****************************************************************                233566 234440
     C**********         EVAL      CSAV = *ZEROS                                       233566 234440
     C**********         EVAL      ZZAPW = *ZEROS                                      233566 236812
      *****************************************************************                233566 234440
      ***Access*Price*details******************************************                233566 234440
      *****************************************************************                233566 234440
     C**********         EVAL      KMarket = V_TDMI                                    236812 234440
     C**********         EVAL      KSecurity = W_SESN                                  233566 234440
     C**********         EVAL      KBranch = BBBRCD                                    233566 234440
     C**********         EVAL      KBook = *Blanks                                     233566 234440
     C**********         MOVE      V_TCNR        KCustomer                             233566 234440
     C**********         EVAL      KPriceType = 'CV'                                   233566 234440
      *****************************************************************                236812 234440
      ***Build*up*customer*current*customer*position*from*CDEPPD*******                236812 234440
     C**********         EXSR      SRRtvCustHd                                         236812 234440
      *****************************************************************                233566 234440
     C*****KPric         SETLL     PRICR                                               233566 236812
     C*****KPric         READE     PRICR                                               233566 236812
      *****************************************************************                233566 236812
      ***If*price*is*found*********************************************                233566 236812
      *****************************************************************                233566 236812
     C**********         IF        NOT %EOF(PRICR)                                     233566 236812
      *****************************************************************                233566 236812
      ***If*Value*Date*is*equal*to*previous*run*date*******************                233566 236812
      *****************************************************************                233566 236812
     C**********         IF        PVDT = JNPRUN                                       233566 236812
     C**********         EVAL      ZZAPW = PEXI                                        233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 236812
      ***If*Value*date*is*equal*to*rundate,*price*becomes*the*average**                233566 236812
      ***fiscal*price**************************************************                233566 236812
      *****************************************************************                233566 236812
     C**********         IF        PVDT = BJRDNB                                       233566 236812
     C**********         EVAL      CSAV = PEXI                                         233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 236812
      ***If*Value*date*is*less*than*previous*rundate*******************                233566 236812
      *****************************************************************                233566 236812
     C**********         IF        PVDT < JNPRUN                                       233566 236812
     C**********         EVAL      KDate = BJRDNB                                      233566 236812
     C*****KPricD        CHAIN     PRICR                                               233566 236812
     C**********         IF        %FOUND(PRICR)                                       233566 236812
     C**********         EVAL      CSAV = PEXI                                         233566 236812
     C**********         ELSE                                                          233566 236812
      *****************************************************************                233566 236812
      ***Access*price*file*with*date*=*previous*date*******************                233566 236812
      *****************************************************************                233566 236812
     C**********         EVAL      KDate = JNPRUN                                      233566 236812
     C*****KPricD        CHAIN     PRICR                                               233566 236812
     C**********         IF        %FOUND(PRICR)                                       233566 236812
     C**********         EVAL      ZZAPW = PEXI                                        233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 236812
      ***Calculate*average*fiscal*price********************************                233566 234440
      *****************************************************************                233566 234440
     C**********         IF        CSAV = *ZEROS                                       233566 236812
      *****************************************************************                233566 234440
      ***Access*CPOSND*************************************************                233566 236812
      ***Access*CPOSND*for*Average*Fiscal*Price*Numerator*(COB)********         233566 236812 234440
      *****************************************************************                233566 234440
     C*****CPOSKEY       CHAIN     CPOSN                                               233566 234440
     C**********         IF        %FOUND(CPOSN)                                       233566 234440
     C**********         EVAL      WT_CSAV = CSAV                                      236812 234440
     C**********         ELSE                                                          236812 234440
     C**********         EVAL      WT_CSAV = 0                                         236812 234440
      *****************************************************************                233566 234440
      ***If*found,*value*date*=*prev*rundate***************************                233566 236812
      *****************************************************************                233566 236812
     C**********         IF        ZZAPW <> *ZEROS                                     233566 236812
     C**********         EVAL      ZZAPC = CSNV * ZZAPW                                233566 236812
     C**********         ELSE                                                          233566 236812
     C**********         EVAL      ZZAPC = CSAV                                        233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 234440
     C**********         ENDIF                                                         233566 234440
      *****************************************************************                233566 234440
     C**********         ENDSR                                                                234440
      ***Calculate*price*using*SROLCAP*********************************                       234440
      *****************************************************************                       234440
     C**********         EXSR      SROLCAP                                             233566 236812
      *****************************************************************                233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 236812
     C**********         ENDSR                                                         233566 236812
      *****************************************************************                       233566
      **/EJECT*********************************************************                233566 236812
      *****************************************************************                       233566
      **SROLCAP********************************************************                233566 236812
      *****************************************************************                       233566
     C*****SROLCAP       BEGSR                                                         233566 236812
      *****************************************************************                233566 234440
     C**********         EVAL      ZNNOMP = C_CDNV  + C_CNSV  + C_CNPV                 233566 236812
     C**********         EVAL      ZNNOMP = WT_CDNV  + WT_CNSV  + WT_CNPV              236812 234440
      *****************************************************************                233566 234440
      ***If*NP*and*new*NP*both*long************************************                233566 234440
      *****************************************************************                233566 234440
     C**********         IF        C_CDNV > *ZEROS AND ZNNOMP > *ZEROS                 233566 236812
     C**********         EVAL      NCSAV = C_CDNV + C_CNPV                                    233566
     C**********         IF        NCSAV < *ZEROS                                             233566
     C**********         EVAL      NCSAV = C_CNSV                                             233566
     C**********         EVAL      WCSAV = C_SPSV                                             233566
     C**********         ELSE                                                                 233566
     C**********         EVAL      WCSAV = ZZAPC + C_SAPV                                     233566
     C**********         ENDIF                                                                233566
     C**********         EVAL      CSAV = WCSAV / NCSAV                                       233566
     C**********         IF        WT_CDNV > *ZEROS AND ZNNOMP > *ZEROS                233566 234440
     C**********         EVAL      WT_AFP = WT_CSAV / WT_CDNV                          233566 234440
     C**********         EVAL      WT_CSAV = WT_CSAV + (WT_CNPV * WT_AFP)              233566 234440
     C**********                             + WT_SAFS                                 233566 234440
     C**********         ENDIF                                                         233566 234440
      *****************************************************************                233566 234440
      ***If*NP*long*or*flat,*new*NP*short******************************                233566 234440
      *****************************************************************                233566 234440
     C**********         IF        C_CDNV >= *ZEROS AND                                233566 236812
     C**********                   ZNNOMP < *ZEROS                                     233566 236812
     C**********         IF        C_CNSV  = *ZEROS                                    233566 236812
     C**********         EVAL      CSAV = *ZEROS                                       233566 236812
     C**********         ELSE                                                          233566 236812
     C**********         EVAL      CSAV = C_SPSV / C_CNSV                              233566 236812
     C**********         ENDIF                                                         233566 236812
     C**********         IF        WT_CDNV >= *ZERO AND ZNNOMP < *ZERO                 233566 234440
     C**********         EVAL      WT_AFP = ZNNOMP * (WT_SAFP / WT_CNPV)               233566 234440
     C**********         ENDIF                                                         233566 234440
      *****************************************************************                233566 234440
      ***If*NP*short*or*flat,*new*NP*long******************************                233566 234440
      *****************************************************************                233566 234440
     C**********         IF        C_CDNV <= *ZEROS AND                                233566 236812
     C**********                   ZNNOMP > *ZEROS                                     233566 236812
     C**********         IF        C_CNPV = *ZEROS                                     233566 236812
     C**********         EVAL      CSAV = *ZEROS                                       233566 236812
     C**********         ELSE                                                          233566 236812
     C**********         EVAL      CSAV = C_SAPV / C_CNPV                              233566 236812
     C**********         ENDIF                                                         233566 236812
     C**********         IF        WT_CDNV <= *ZERO AND ZNNOMP > *ZERO                 233566 234440
     C**********         EVAL      WT_AFP = ZNNOMP * (WT_SAFS / WT_CNSV)               233566 234440
     C**********         ENDIF                                                         233566 234440
      *****************************************************************                233566 234440
      ***If*new*NP*flat************************************************                233566 234440
      *****************************************************************                233566 234440
     C**********         IF        ZNNOMP = *ZEROS                                     233566 234440
     C**********         EVAL      CSAV = *ZEROS                                       233566 236812
     C**********         EVAL      WT_CSAV = 0                                         233566 234440
     C**********         ENDIF                                                         233566 234440
      *****************************************************************                233566 234440
      ***If*price*basis*'P',*multiply*by*100*to*fetch*the*true*price***                233566 234440
      *****************************************************************                233566 234440
     C**********         IF        W_SPBS = 'P'                                        233566 236812
     C**********         EVAL      CSAV = CSAV * 100                                   233566 236812
     C**********         ENDIF                                                         233566 236812
      *****************************************************************                233566 234440
      ***Reformat*price*from*nominal*currency*decimal*place*to*a*******                233566 234440
      ***straith*15,8*price********************************************                233566 234440
      *****************************************************************                233566 234440
     C**********         EVAL      W_NDec = 5 - W_NMDP + W_NomCcyDec                   233566 236812
     C**********         EVAL      CSAV = CSAV / POWER8 (W_NDec)                       233566 236812
      **********                                                                       233566 234440
     C**********         ENDSR                                                         233566 234440
      *****************************************************************                       233566
      /EJECT                                                                                  233566
      *****************************************************************                       233566
      **SRRtvMktInd*-*Subroutine*to*retrieve*the*Market*Indicator******                233566 236812
      * SRRtvCustHd - Subroutine to retrieve the Market Indicator     *                233566 236812
      *****************************************************************                       233566
     C*****SRRtvMktInd   BEGSR                                                         233566 236812
     C*****SRRtvCustHd   BEGSR                                                         236812 234440
      *****************************************************************                233566 234440
     C**********         EVAL      WT_CDNV = 0                                         236812 234440
     C**********         EVAL      WT_CNPV = 0                                         236812 234440
     C**********         EVAL      WT_CNSV = 0                                         236812 234440
     C**********         EVAL      WT_SAFP = 0                                         236812 234440
     C**********         EVAL      WT_SAFS = 0                                         236812 234440
     C**********         EVAL      WT_CSAV = 0                                         236812 234440
     C**********         EVAL      WT_AFP  = 0                                         236812 234440
     C*****KCdep         CHAIN     CDEPPDF                                             233566 236812
     C*****KCdep         CHAIN     CDEPPDF                            89               236812 234440
      *****************************************************************                233566 234440
     C**********         IF        %FOUND(CDEPD)                                       233566 236812
     C**********         EVAL      KMarket = C_CDMK                                    233566 236812
     C**********         ELSE                                                          233566 236812
     C**********         EVAL      KMarket = *BLANKS                                   233566 236812
     C**********         ENDIF                                                         233566 236812
     C******IN89         DOWEQ     '0'                                                 236812 234440
     C**********         EVAL      WT_CDNV = WT_CDNV + C_CDNV                          236812 234440
     C**********         EVAL      WT_CNPV = WT_CNPV + C_CNPV                          236812 234440
     C**********         EVAL      WT_CNSV = WT_CNSV + C_CNSV                          236812 234440
     C**********         EVAL      WT_SAFP = WT_SAFP + C_SAFP                          236812 234440
     C**********         EVAL      WT_SAFS = WT_SAFS + C_SAFS                          236812 234440
     C*****KCdep         READE     CDEPPDF                                89           236812 234440
     C**********         ENDDO                                                         236812 234440
      *****************************************************************                233566 234440
     C**********         ENDSR                                                         233566 234440
      *****************************************************************                       233566
      /EJECT                                                                                  233566
      *****************************************************************
      * SRDelete - Delete records from PF/SDCSINPD                    *
      *****************************************************************
     C     SRDelete      BEGSR
 
     C                   MOVE      'S'           WModID
     C                   MOVE      V_TDRF        WTradNo
 
     C*****KCSIN         SETLL     SDCSIND6                                                   236732
     C**********         READ      SDCSIND6                                                   236732
     C     KCSIN         SETLL     SDCSINDL                                                   236732
     C     KCSIN         READE(E)  SDCSINDL                                                   236732
 
     C**********         DOW       NOT %EOF(SDCSINL6) AND                                     236732
     C**********                   TSRDNB = V_LCD AND                                         236732
     C**********                   TSMODI = WModID AND                                        236732
     C**********                   TSDLLN = WTradNo                                           236732
                                                                                              236732
     C                   DOW       NOT %EOF(SDCSINLD)                                         236732
     C**********         DELETE    SDCSIND6                                                   236732
     C**********         READ      SDCSIND6                                                   236732
     C                   DELETE    SDCSINDL                                                   236732
     C     KCSIN         READE(E)  SDCSINDL                                                   236732
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  236137
      *****************************************************************                       236137
      *                                                               *                       236137
      * ZAACTUAR - Actuarial Interpolation of a rate.                 *                       236137
      *                                                               *                       236137
      * Called By:                                                    *                       236137
      * SRCmpTxbAmtB - Compute for the taxable amount for Bonds       *                       236137
      *                                                               *                       236137
      * Calls:                                                        *                       236137
      * ZAACTUAR - Midas ZA Actuarial Interpolation of a Rate.        *                       236137
      *                                                               *                       236137
      *****************************************************************                       236137
     C     ZAACTUAR      BEGSR                                                                236137
                                                                                              236137
     C                   CALLB     'ZAACTUAR'                                                 236137
                                                                                              236137
      ** Return Code                                                                          236137
     C                   PARM      *BLANKS       ZRTCD                                        236137
                                                                                              236137
      ** INPUTS                                                                               236137
      ** ------                                                                               236137
      ** Issue Date                                                                           236137
      ** Issue Price                                                                          236137
      ** Maturity Date                                                                        236137
      ** Maturity Price                                                                       236137
      ** Day Basis                                                                            236137
      ** Div Basis                                                                            236137
      ** Coupon Dates array.                                                                  236137
      ** Coupon Rate indicators array.                                                        236137
      ** Last Coupon Date.                                                                  BUG11164
      ** Value Date                                                                           236137
     C                   PARM      W_ISSD        ZISSD                                        236137
     C                   PARM      W_ISSP        ZISSP                                        236137
     C                   PARM      W_MATY        ZMATD                                        236137
     C                   PARM                    ZMATP                                        236137
     C                   PARM      W_DYBS        ZDYBS                                        236137
     C                   PARM      W_DVBS        ZDVBS                                        236137
     C                   PARM      CDArr         ZCDDS                                        236137
     C                   PARM      CRArr         ZCRDS                                        236137
     C                   PARM                    W_LCPN                                     BUG11164
     C                   PARM      V_TDVD        ZVALD                                        236137
                                                                                              236137
      ** OUTPUTS                                                                              236137
      ** ------                                                                               236137
      ** Fiscal Price                                                                         236137
     C                   PARM                    ZFSPR                                        236137
                                                                                              236137
     C                   ENDSR                                                                236137
      *****************************************************************                       236137
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
      ** Valid Trade Details
      ** Security Details
      ** Update Flag
 
     C                   PARM                    RetCodeIn
     C                   PARM                    ValidTrad
     C                   PARM                    SECTY
     C                   PARM                    ProcFlag
 
      ** OUTPUTS
      ** EU Tax Screen Format
      ** EU Tax in Nominal Currency File Format
      ** EU Tax in Settlement Currency File Format
 
     C                   PARM                    DDEUTX
     C                   PARM                    EUTX
     C                   PARM                    EUTS
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   MOVE      'N'           WTNLUFlag
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*VERIFY'     POPTN                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C*                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   END                                                                  CER048
                                                                                              233566
      ** Access JNSTAT                                                                        233566
                                                                                              233566
     C                   IN        JNSTAT                                                     233566
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION                                          233774
00000001                                                                                      233774
00000010                                                                                      233774
00000100                                                                                      233774
00001000                                                                                      233774
00010000                                                                                      233774
00100000                                                                                      233774
01000000                                                                                      233774
10000000                                                                                      233774
