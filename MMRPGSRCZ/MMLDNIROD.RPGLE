     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits rollover defaulting')          *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIROD - LOANS/DEPOSITS & NAS ISSUED ROLLOVER DEFAULTING  *
      *                                                               *
      *  Function:  This module determines various attributes of the  *
      *             deal that would roll over a given deal: e.g. new  *
      *             value date, maturity date, principal etc.         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 MD026788           Date 18Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR848507           Date 25Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26839           Date 05Jan10               *
      *                 BUG23711B          Date 07Jun09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23711A          Date 09May09               *
      *                 BUG23711           Date 24Apr09               *
      *                 BUG23550           Date 27Mar09               *
      *                 BUG22911           Date 17Feb09               *
      *                 BUG22756           Date 10Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CDL081             Date 14Dec09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255405             Date 04Aug08               *
      *                 246101             Date 02Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243842             Date 29Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 239547             Date 28Apr06               *
      *                 238592             Date 21Mar06               *
      *                 BUG8761            Date 27Jun06               *
      *                 220554             Date 06Jun06               *
      *                 CDL013             Date 08Jun06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027A            Date 09May06               *
      *                 CSD027             Date 09Dec05               *
      *                 234407             Date 04Jul05               *
      *                 233815             Date 07Jun05               *
      *                 233283             Date 28Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG5916            Date 16Feb05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190809             DATE 13Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             DATE 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 CAP004  *CREATE    Date 13Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *  MD026788 - Always use the Deal Customer for European Tax     *
      *             checking when system value UseDealCustforEuTax    *
      *             is 'Y'.                                           *
      *           - Applied for MD031062                              *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR848507 - Actual Interest in rolled over deal defaults to   *
      *             the interest of the original                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,MMH00011                                 *
      *             WNCPYSRC,MMH00012                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26839 - JA1_Threshold limit of the main joint customer was*
      *             utilized by the member                            *
      *  BUG23711B - Incorrect interest reversal on rollover          *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23711A - Incorrect interest reversal on rollover          *
      *  BUG23711 - Incorrect interest reversal on rollover           *
      *  BUG23550 - Rollover amount is incorrect if threshold utilised*
      *  BUG22911 - Changes for Correct Tax Calculation               *
      *  BUG22756 - Tax is deducted when MM Deal is set to Taxable 'N'*
      *  CER048 - German Features - Taxes                             *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL081 - Tiered withholding tax rounding upgrade             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255405 - Reverse fix 246101 so that default spread rate is   *
      *           the rate of the existing deal as per user request.  *
      *  246101 - Always default spread rate from MM Interest file.   *
      *  243842 - Display warning message if Rollover Freq = A and    *
      *           SDGELRPD is daily accrual.                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  239547 - Always default interest calcuation basis from the   *
      *           original for both "R" and "C" actions.              *
      *  238592 - Set Rollover action correctly.                      *
      *  BUG8761- The Rollover Deals Maintenance shows an incorrect   *
      *           interest rate. The interest rate of the previous    *
      *           deal being rolled-over should be used as the        *
      *           default interest rate.                              *
      *  220554 - Interest calculation method should default to that  *
      *           of the deal being rolled over if it is not from an  *
      *           In currency to Euro (action code 'C').              *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  234407 - Error in Rollover when the settlement is on Nostro  *
      *  233815 - Calculation prorata temporis according to the       *
      *           effective date incorrect                            *
      *  233283 - Calculation of taxable amount prorata temporis      *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating rate CDs issued                            *
      *  BUG5916 - Default Rundate in Deal Date for the new           *
      *            (rollover) deal.                                   *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  190809 - Action code was processed incorrectly.              *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
     FDLINTRL2  IF   E           K DISK
     FDLINTRL1  IF   E           K DISK
     F                                     RENAME(FDINTRP0:FDINTRP1)
     FSDJACCLB  IF   E           K DISK                                                       CGL031
                                                                                              CGL031
     FSDSTAAL1  IF   E           K DISK    INFSR(*PSSR)                                       CDL013
      *********                                                                   BUG23550 BUG23711A
      **Midas*SD Customer Income by Deal/Trade Number                             BUG23550 BUG23711A
      *********                                                                   BUG23550 BUG23711A
     F***SDCSINLD  IF   E           K DISK                                        BUG23550 BUG23711A
     F/COPY WNCPYSRC,MMLDNIOF01
 
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
 
     D DlFilFmt      E DS                  EXTNAME(MMDELDPP)
      * Deal in File Format
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                 BUG5916
     D @BJDFIN       E                     EXTFLD(BJDFIN)                                    BUG5916
      ** EXTERNAL DS FOR BANK DETAILS                                                        BUG5916
                                                                                             BUG5916
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  243842
     D                                     PREFIX(BK_)                                        243842
      ** External DS for general ledger details                                               243842
                                                                                              243842
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
                                                                                              233283
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  233283
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     233283
      ** External DS For branch details                                                       233283
                                                                                              233283
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  233283
      ** External DS For Customer Details                                                     233283
                                                                                              233283
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  233283
      ** External DS for Location Code                                                        233283
                                                                                              233283
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  233283
      ** External DS for Country of Tax Code                                                  233283
                                                                                              CGL031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL031
      ** External DS for SAR Details                                                          CGL031
                                                                                             BUG5916
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG5916
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   BUG5916
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *                                                                                     BUG22911
      ** Data area for Midas SD Tax Parameter File                                          BUG22911
     D SDTXPA        E DS                  EXTNAME(SDTXPAPD)                                BUG22911
      *                                                                                     BUG22911
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
     D CDL013          S              1A                                                      CDL013
     D CGL165          S              1A                                                      CGL165
                                                                                              CDL033
     D CDL033          S              1A                                                      CDL033
     D WSP             S              1A   DIM(12)                                            CDL033
     D*WCsin****       S              1A                                          BUG23711 BUG23711A
                                                                                              CDL033
                                                                                              CGL031
     D CGL031          S              1A                                                      CGL031
     D PRTCD           S              7A                                                      CGL031
     D POPTN           S              7A                                                      CGL031
     D PSARD           S              6A                                                      CGL031
     D PBranch         S              3A                                                      CGL031
     D***PCustNum        S              6S 0                                          CGL031 CSD027A
     D PCustNum        S              6A                                                     CSD027A
     D PCurrency       S              3A                                                      CGL031
     D PSetType        S              2S 0                                                    CGL031
     D*PSetAcc         S             12A                                               CGL031 CGL035
     D PSetAcc         S             18A                                                      CGL035
     D PRetCode        S             10A                                                      CGL031
     D*PAccCode        S              4S 0                                             CGL031 CGL035
     D PAccCode        S             10S 0                                                    CGL035
     D PAccSeq         S              2S 0                                                    CGL031
     D PMemosInd       S              1A                                                      CGL031
     D PPronoInd       S              1A                                                      CGL031
     D PModuleID       S              1A                                                      CGL031
     D*PTransRef       S             18A                                               CGL031 CGL035
     D PTransRef       S             24A                                                      CGL035
     D PCustomer       S              6A                                                      CGL031
     D PICStrDate      S              5P 0                                                    CGL031
     D PICEndDate      S              5P 0                                                    CGL031
     D PTotalInt       S             15P 0                                                    CGL031
     D WTotalInt       S             15P 0                                                 BUG23711A
     D WHKslid         S              5P 0                                                 BUG23711A
     D PTaxRateAB      S              6P 4                                                    CGL031
     D POrigCcy        S              3A                                                      CGL031
     D PIntEfDat       S             15P 0                                                    CGL031
     D PTaxAmt         S             15P 0                                                    CGL031
     D PIntAmt         S             15P 0                                                    CGL031
     D PTaxCcy         S              3A                                                      CGL031
     D PCtryOfTax      S              2A                                                      CGL031
     D PTaxBasket      S              2A                                                      CGL031
     D*PEUWTaxAcCd     S              4P 0                                             CGL031 CGL035
     D PEUWTaxAcCd     S             10P 0                                                    CGL035
     D PCtryOfLoc      S              2A                                                      CGL031
     D PCustStat       S              5A                                                      CGL031
     D PTrnTypEnd      S              1A                                                      CGL031
     D PTaxRatePd      S              6P 4                                                    CGL031
     D PJntAccMng      S              1A                                                      CGL031
     D PDBaseKey       S             10A                                                      CGL031
     D PDBaseFil       S             10A                                                      CGL031
     D PReturn         S              7A                                                      CGL031
     D PJointAcNo      S              6A                                                      CGL031
     D PNAHRef         S             10A                                                      CGL031
     D PInvProp        S             10A                                                      CGL031
      *                                                                                       CER048
     D PInth           S              1A                                                      CER048
     D********** PStxb           S              2P 0                                 CER048 BUG22911
     D********** PStac           S             10P 0                                 CER048 BUG22911
     D********** PSttr           S              6P 4                                 CER048 BUG22911
     D********** PSttp           S              1A                                   CER048 BUG22911
     D********** PStxa           S             15P 0                                 CER048 BUG22911
                                                                                              CGL031
     D WCustomer       S              6A                                                      CGL031
     D WDealNo         S              6A                                                      CGL031
     D WEUTaxAmt       S             15P 0                                                    CGL031
                                                                                              CGL031
     D @ENDD           S              5  0                                                    233283
     D @STRD           S              5  0                                                    233283
     D @PKEY1          S             10A                                                      233283
     D @PKYST          S              7A                                                      233283
     D WCNCD           S              2A                                                      233283
     D WCOLC           S              2A                                                      233283
     D WDY1            S              5P 0                                                    233283
     D WDY2            S              5P 0                                                    233283
                                                                                              233283
     D W#BSRD          S              1A                                                      CDL081
     D W#NBRD          S              1A                                                      CDL081
     D CDL081          S              1A                                                      CDL081
                                                                                              CDL081
     D P@RTCD          S              7A                                                      CDL081
     D P@OP01          S             20A                                                      CDL081
     D P@VL01          S            200A                                                      CDL081
     D P@OP02          S             20A                                                      CDL081
     D P@VL02          S            200A                                                      CDL081
     D P@OP03          S             20A                                                      CDL081
     D P@VL03          S            200A                                                      CDL081
     D P@OP04          S             20A                                                      CDL081
     D P@VL04          S            200A                                                      CDL081
     D P@OP05          S             20A                                                      CDL081
     D P@VL05          S            200A                                                      CDL081
     D P@OP06          S             20A                                                      CDL081
     D P@VL06          S            200A                                                      CDL081
     D P@OP07          S             20A                                                      CDL081
     D P@VL07          S            200A                                                      CDL081
     D P@OP08          S             20A                                                      CDL081
     D P@VL08          S            200A                                                      CDL081
     D P@OP09          S             20A                                                      CDL081
     D P@VL09          S            200A                                                      CDL081
     D P@OP10          S             20A                                                      CDL081
     D P@VL10          S            200A                                                      CDL081
                                                                                              CDL081
     D C#BASE          C                   CONST('BasCcyTaxRoundDown')                        CDL081
     D C#NBAS          C                   CONST('NBasCcyTaxRoundDown')                       CDL081
     D UseDealCust     C                   CONST('UseDealCustforEuTax')                     MD026788
     D WSecTxAmt       S             15P 0                                                    CER048
     D CER048          S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
     D W3rdTxAmt       S             15P 0                                                    CER054
      *                                                                                       CER048
     D********* WSGINT          S             15P 0                               BUG23550 BUG23711A
     D********* WSTXSR          S             15P 0                               BUG23550 BUG23711A
     D********* WSSTDO          S             15P 0                               BUG23550 BUG23711A
     D********* WSIPDT          S              5P 0                               BUG23550 BUG23711A
     D ZIBEG           S              5  0                                                 BUG23711A
     D ZIEND           S              5  0                                                 BUG23711A
     D ZICALC          S              1  0                                                 BUG23711A
     D ZIAMT           S             15  0                                                 BUG23711A
     D ZIRATE          S             11  7                                                 BUG23711A
     D ZINTR           S             30  9                                                 BUG23711A
     D WFlag           S              1A                                                   BUG23711A
     D/COPY WNCPYSRC,MMLDNIOD01
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      ** Initialization
      *
     C                   EXSR      INIT
      *
      * Check rollover action is valid
      *
     C                   EXSR      CHECK_RACT
      *
      * Set up the new action code
      *
     C                   EXSR      SETN_ACTN
      *
      * Set up the new deal number
      *
     C                   EXSR      SETN_DLNO
      *
      * Set up the new rollover deal number
      *
     C                   EXSR      SETN_DADN
      *
      * Set up the new value date
      *
     C                   EXSR      SETN_VDAT
      *
      * Set up the new (deal) currency
      *
     C                   EXSR      SETN_CCY
     C/COPY WNCPYSRC,MMLDNIOC01
      *
      * Set up the new rollover amount
      *
     C                   EXSR      SETN_RAMN
     C/COPY WNCPYSRC,MMLDNIOC02
      *
      * Set up the new maturity date
      *
     C                   EXSR      SETN_MDAT
      *                                                                                      BUG5916
      * Set up the new deal date                                                             BUG5916
      *                                                                                      BUG5916
     C                   EXSR      SETN_DLDT                                                 BUG5916
      *
      * If base rate is NOT present
      *
     C     HKBSRC        IFEQ      *BLANKS
      *
      * Set up the new interest rate
      *
     C                   EXSR      SETN_INTR
      *
      * Else, if base rate is present
      *
     C                   ELSE
      *
      * Set up the new base rate code/spread
      *
     C                   EXSR      SETN_BRTE
     C                   ENDIF
      *                                                                                     AR848507
      * Set up the new actual interest rate                                                 AR848507
      *                                                                                     AR848507
     C                   EXSR      SETN_AIR                                                 AR848507
      *
      * Set up the new interest calculation method
      *
     C                   EXSR      SETN_ICMT
      *
      * Set up the new base currency rate
      *
     C                   EXSR      SETN_BRAT
      *
      * Set up the new total interest
      *
     C                   EXSR      SETN_TOTI
      *
      * Set up the new deal customer shortname
      *
     C                   EXSR      SETN_CSNM
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHECK_RACT - CHECK ROLLOVER ACTION IS VALID
      ******************************************************************
     C     CHECK_RACT    BEGSR
                                                                                              238592
      ** Default to 'R' if Rollover Action field is blank                                     238592
                                                                                              238592
     C     DDRACT        IFEQ      *BLANKS                                                    238592
     C                   MOVE      'R'           DDRACT                                       238592
     C                   ENDIF                                                                238592
      *
      ** If CEU015 is switched on and rollover from
      ** an 'in' currency to Euros is required.
      *
     C     CEU015        IFEQ      'Y'
     C*****DDRACT        ANDEQ     'C'                                                        190809
      *
      ** Get the deal currency details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      HKCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   MOVEL     HKCCY         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Rollover action must be 'R' or 'C' (C=rollover into Euros)
      ** (Can only be 'C' if CEU015 is on, and currency is an 'in' ccy)
      *
     C*****CEU015        IFNE      'Y'                                                        190809
     C*****CEU015        OREQ      'Y'                                                        190809
     C*****DDRACT        ANDEQ     'C'                                                        190809
     C*****A6INCY        ANDNE     'Y'                                                        190809
     C*****DDRACT        ORNE      'C'                                                        190809
     C**********         MOVE      'R'           DDRACT                                       190809
     C**********         END                                                                  190809
     C*                                                                                       190809
     C     CEU015        IFEQ      'Y'                                                        190809
     C     A6INCY        ANDEQ     'Y'                                                        190809
     C     DDRACT        IFNE      'R'                                                        190809
     C                   MOVE      'C'           DDRACT                                       190809
     C                   ENDIF                                                                190809
     C                   ELSE                                                                 190809
     C                   MOVE      'R'           DDRACT                                       190809
     C                   ENDIF                                                                190809
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_ACTN - SET UP NEW ACTION CODE
      ******************************************************************
     C     SETN_ACTN     BEGSR
      *
     C                   MOVEL     'I'           DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_DLNO - SET UP NEW DEAL NUMBER
      ******************************************************************
     C     SETN_DLNO     BEGSR
      *
     C                   MOVEL     *BLANK        DDDLNO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_DADN - SET UP NEW ROLLOVER DEAL NUMBER
      ******************************************************************
     C     SETN_DADN     BEGSR
      *
     C                   MOVEL     HKDN38        DDDADN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_VDAT - SET UP NEW VALUE DATE
      ******************************************************************
     C     SETN_VDAT     BEGSR
      *
      * Transform the maturity date from old deal
      * into the value date of the new deal
      *
     C                   MOVE      HKMDYY        @@YEAR
     C                   MOVE      HKMDMM        @@MNTH
     C                   MOVE      HKMDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDATYMD
     C                   MOVE      @@DTOU        DDVDAT
     C                   EXSR      CVTDATMDN
     C                   Z-ADD     @@DAYN        OldMatDate
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_CCY  - SET UP NEW (DEAL) CURRENCY
      ******************************************************************
     C     SETN_CCY      BEGSR
      *
      ** New deal currency is old deal currency or Euros
      *
     C     DDRACT        IFEQ      'C'
     C                   MOVE      BKEURO        DDCCY
     C                   ELSE
     C                   MOVE      HKCCY         DDCCY
     C                   ENDIF
      *
     C                   ENDSR
     C/COPY WNCPYSRC,MMLDNIOC03
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_RAMN - SET UP NEW ROLLOVER AMOUNT
      ******************************************************************
     C     SETN_RAMN     BEGSR
      *
      ** Make principal and total interest positive
      *
     C     HKAMNP        IFLT      *ZERO
     C                   Z-SUB     HKAMNP        HKAMNP
     C                   END
     C     HKMTTI        IFLT      *ZERO
     C                   Z-SUB     HKMTTI        HKMTTI
     C                   END
      *
      ** Calculate the interest tax for interest paid separately
      ** non up-front interest deals (that are taxable)
      *
     C                   Z-ADD     *ZERO         OldTaxAmt        13 0
      *                                                                                       CDL013
      *** if CAR CDL013 is installed.                                                         CDL013
     C     CDL013        IFEQ      'Y'                                                        CDL013
     C     HKIPDS        ANDEQ     'N'                                                        CDL013
     C/COPY WNCPYSRC,MMH00011
      *                                                                                       CDL013
      *** if Tax indicator is ZERO set WHT rate to ZERO.                                      CDL013
     C     HKMTAX        IFEQ      '0'                                                        CDL013
     C                   Z-ADD     0             ULWHTR            5 2                        CDL013
     C                   ELSE                                                                 CDL013
      *                                                                                       CDL013
      *** Set WHT rate.                                                                       CDL013
     C                   SELECT                                                               CDL013
     C     HKMTAX        WHENEQ    '1'                                                        CDL013
     C                   Z-ADD     ETXR1         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '2'                                                        CDL013
     C                   Z-ADD     ETXR2         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '3'                                                        CDL013
     C                   Z-ADD     ETXR3         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '4'                                                        CDL013
     C                   Z-ADD     ETXR4         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '5'                                                        CDL013
     C                   Z-ADD     ETXR5         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '6'                                                        CDL013
     C                   Z-ADD     ETXR6         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '7'                                                        CDL013
     C                   Z-ADD     ETXR7         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '8'                                                        CDL013
     C                   Z-ADD     ETXR8         ULWHTR                                       CDL013
     C     HKMTAX        WHENEQ    '9'                                                        CDL013
     C                   Z-ADD     ETXR9         ULWHTR                                       CDL013
     C                   ENDSL                                                                CDL013
      *                                                                                       CDL013
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
      *** If WHT rate is ZERO set tax amount to ZERO.                                         CDL013
     C     ULWHTR        IFEQ      *ZERO                                                      CDL013
     C                   Z-ADD     0             OldTaxAmt                                    CDL013
      *                                                                                       CDL013
      *** otherwise calculate tax amount.                                                     CDL013
     C                   ELSE                                                                 CDL013
      *                                                                                       CDL013
      *** if Deal Ccy is equal to Base Ccy round down Interest Amount.                        CDL013
      *** and CDL081 is off                                                                   CDL081
      *                                                                                       CDL081
     C     HKCCY         IFEQ      BJCYCD                                                     CDL013
     C     CDL081        ANDEQ     'N'                                                        CDL081
      *                                                                                       CDL013
      *** set work adjustment field according to decimal places.                              CDL013
     C                   SELECT                                                               CDL013
     C     HKCYDP        WHENEQ    1                                                          CDL013
     C                   Z-ADD     10            ULWKAD            4 0                        CDL013
     C     HKCYDP        WHENEQ    2                                                          CDL013
     C                   Z-ADD     100           ULWKAD                                       CDL013
     C     HKCYDP        WHENEQ    3                                                          CDL013
     C                   Z-ADD     1000          ULWKAD                                       CDL013
     C     HKCYDP        WHENEQ    0                                                          CDL013
     C                   Z-ADD     1             ULWKAD                                       CDL013
     C                   ENDSL                                                                CDL013
      *                                                                                       CDL013
      *** round down Interest Amount.                                                         CDL013
     C     HKMTTI        DIV       ULWKAD        ULTINT           15 0                        CDL013
     C                   MULT      ULWKAD        ULTINT                                       CDL013
      *                                                                                       CDL013
      *** calculate and then round down Tax Amount.                                           CDL013
     C     ULTINT        MULT      ULWHTR        OldTaxAmt                                    CDL013
     C                   DIV       100           OldTaxAmt                                    CDL013
     C     OldTaxAmt     DIV       ULWKAD        ULTXAM           15 0                        CDL013
     C     ULTXAM        MULT      ULWKAD        OldTaxAmt                                    CDL013
      *                                                                                       CDL013
      *** otherwise (Deal Ccy NOT = Base Ccy) calculate Tax amount                            CDL013
      *** without rounding down.                                                              CDL013
     C                   ELSE                                                                 CDL013
     C     HKMTTI        MULT      ULWHTR        OldTaxAmt                                    CDL013
                                                                                              CDL081
      ** Check if tax amount is to be rounded down                                            CDL081
                                                                                              CDL081
     C     HKCCY         IFEQ      BJCYCD                                                     CDL081
     C     CDL081        ANDEQ     'Y'                                                        CDL081
     C     W#BSRD        ANDEQ     'Y'                                                        CDL081
     C     HKCCY         ORNE      BJCYCD                                                     CDL081
     C     CDL081        ANDEQ     'Y'                                                        CDL081
     C     W#NBRD        ANDEQ     'Y'                                                        CDL081
     C                   DIV       100           OldTaxAmt                                    CDL081
     C                   ELSE                                                                 CDL081
     C                   DIV(H)    100           OldTaxAmt                                    CDL013
     C                   ENDIF                                                                CDL081
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
     C                   ENDIF                                                                CDL013
     C/COPY WNCPYSRC,MMH00012
      *                                                                                       CDL013
      *** otherwise perform Original Tax calculations.                                        CDL013
     C                   ELSE                                                                 CDL013
      *                                                                                       CDL013
      *
     C     HKIPDS        IFEQ      'N'
     C     HKFUID        ANDNE     'Y'
     C     HKMTAX        ANDEQ     'Y'
      *
      ** If BRT SAR is Installed
      *
     C     S01383        IFEQ      'Y'
      *
      ** Access Customer Tax indicator
      *
     C     HKCNUM        CHAIN     SDCBRTL1                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDCBRTL1'    DBFILE
     C                   MOVEL     '101'         DBASE
     C                   MOVEL     HKCNUM        DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Calculate Tax for Liable and Part Liable Customers
      *
     C     TAXIND        IFEQ      'L'
     C     TAXIND        OREQ      'P'
      *
      ** If the Maturity Date is Less than the effective date use the
      ** previous rate
      *
     C     OldMatDate    IFLT      DEFF
     C     HKMTTI        MULT      PBRTR         OldTaxAmt
     C                   ELSE
     C     HKMTTI        MULT      BRTR          OldTaxAmt
     C                   END
      *
      ** If Partially Liable, half Tax payable
      *
     C     TAXIND        IFEQ      'P'
     C                   DIV       2             OldTaxAmt
     C                   END
     C                   END
      *
      ** ELSE BRT SAR is NOT Installed
      *
     C                   ELSE
      *
     C     CGL165        IFEQ      'Y'                                                        CGL165
      *                                                                                       CGL165
     C                   Z-ADD     HKMTTI        PINTA                                        CGL165
     C                   CALL      'GL024000'                                                 CGL165
     C                   PARM                    PRCOD1            1                          CGL165
     C                   PARM      'AOOUMM'      PCPGM             6                          CGL165
     C                   PARM      *BLANKS       PBRCA             3                          CGL165
     C                   PARM      *BLANKS       PCNUM             6                          CGL165
     C                   PARM      *BLANKS       PACNO            10                          CGL165
     C                   PARM      *BLANKS       PCCY              3                          CGL165
     C                   PARM                    PINTA            15 0                        CGL165
     C                   PARM      HKTAX1        PTXC1             2                          CGL165
     C                   PARM      HKTAX2        PTXC2             2                          CGL165
     C                   PARM      *ZEROS        PCPDT             5 0                        CGL165
     C                   PARM      *ZEROS        PVDAT             5 0                        CGL165
     C                   PARM      *ZEROS        PMDAT             5 0                        CGL165
     C                   PARM      *ZEROS        PINRT            11 7                        CGL165
     C                   PARM      *BLANKS       PDTYP             2                          CGL165
     C                   PARM      *ZEROS        PPCPL            15 0                        CGL165
     C                   PARM      *BLANKS       PACOD            10                          CGL165
     C                   PARM      *ZEROS        PACSQ             2 0                        CGL165
     C                   PARM                    PWTXA            15 0                        CGL165
     C                   PARM                    PSTXA            15 0                        CGL165
      *                                                                                       CGL165
     C     PWTXA         ADD       PSTXA         OldTaxAmt                                    CGL165
     C                   ELSE                                                                 CGL165
      ** Calculate Hong Kong/Withholding Tax
      *
     C     HKMTTI        MULT      BNHKTR        OldTaxAmt
     C                   ENDIF                                                                CGL165
     C                   END
      *
      ** Round down or Half Adjust
      *
     C     HKRDFC        IFEQ      'Y'
     C                   DIV       100           OldTaxAmt
     C                   ELSE
     C                   DIV(H)    100           OldTaxAmt
     C                   END
     C                   END
      *                                                                                       CDL013
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
      *                                                                                    BUG23711A
     C                   MOVE      HKSLYY        @@YEAR                                    BUG23711A
     C                   MOVE      HKSLMM        @@MNTH                                    BUG23711A
     C                   MOVE      HKSLDD        @@DAY                                     BUG23711A
     C     @@DTIN        IFNE      *ZEROS                                                  BUG23711A
     C                   EXSR      CVTDATYMD                                               BUG23711A
     C                   EXSR      CVTDATMDN                                               BUG23711A
     C                   Z-ADD     @@DAYN        WHKslid                                   BUG23711A
     C                   END                                                               BUG23711A
      *                                                                                    BUG23711A
      *                                                                                    BUG23711A
     C                   EVAL      WFlag = *BLANKS                                         BUG23711A
      *                                                                                    BUG23711A
     C                   IF        CER048 = 'Y'                                            BUG23711A
      *                                                                                    BUG23711A
      *                                                                                    BUG23711A
     C                   IF        HKDVSD <> WHKslid                                       BUG23711A
      *                                                                                    BUG23711A
     C                   EVAL      WFlag = 'Y'                                             BUG23711A
      *                                                                                    BUG23711A
     C**********         MOVE      EWTRT1        ZICALC                          BUG23711A BUG23711B
     C                   MOVE      HKICMT        ZICALC                                    BUG23711B
      *                                                                                    BUG23711A
     C                   CALLB     'GLINTC'                                                BUG23711A
      ** Inputs                                                                            BUG23711A
     C                   PARM      WHKslid       ZIBEG                                     BUG23711A
     C                   PARM      HKMATD        ZIEND                                     BUG23711A
     C                   PARM                    ZICALC                                    BUG23711A
     C                   PARM      HKAMNP        ZIAMT                                     BUG23711A
     C                   PARM      HKINTR        ZIRATE                                    BUG23711A
      ** Output                                                                            BUG23711A
     C                   PARM      *ZEROS        ZINTR                                     BUG23711A
      *                                                                                    BUG23711A
     C                   EVAL      PTotalInt = ZINTR                                       BUG23711A
     C                   EVAL      WTotalInt = PTotalInt                                   BUG23711A
      *                                                                                    BUG23711A
     C                   ENDIF                                                             BUG23711A
      *                                                                                    BUG23711A
     C                   ENDIF                                                             BUG23711A
      *                                                                                       CGL031
      ** Apply EU Withholding tax if applicable                                               CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C**********         IF        (HKMTAX = 'T' OR  HKMTAX = 'Y')                 BUG22756 BUG22911
     C                   EXSR      SRCalEUTax                                                 CGL031
     C**********         ENDIF                                                     BUG22756 BUG22911
     C                   ENDIF                                                                CGL031
      *
      ** If interest is not paid separately and is not up front,
      ** the new principal is the old principal plus interest minus tax.
      ** Otherwise the new principal is the old principal.
      *
     C     HKIPDS        IFEQ      'N'
     C     HKFUID        ANDNE     'Y'
     C     HKAMNP        ADD       HKMTTI        NewPrinc
     C                   SUB       OldTaxAmt     NewPrinc         15 0
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   SUB       WEUTaxAmt     NewPrinc                                     CGL031
      *                                                                                       CER048
      ** Set the new principal for CER048                                                     CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   SUB       WSecTxAmt     NewPrinc                                     CER048
      *                                                                                       CER054
      ** Set the new principal for CER054                                                     CER054
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   SUB       W3rdTxAmt     NewPrinc                                     CER054
     C                   ENDIF                                                                CER054
      *                                                                                    BUG23711A
     C                   IF        WFlag = 'Y'                                             BUG23711A
      *                                                                                    BUG23711A
     C                   SUB       HKMTTI        NewPrinc                                  BUG23711A
     C                   ADD       WTotalInt     NewPrinc                                  BUG23711A
      *                                                                                    BUG23711A
     C                   ENDIF                                                             BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         IF        TSEDAT < HKMATD AND                            BUG23711 BUG23711A
     C**********                   WCsin = 'Y'                                    BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         SUB       HKMTTI        NewPrinc                         BUG23711 BUG23711A
     C**********         ADD       PTotalInt     NewPrinc                         BUG23711 BUG23711A
     C**********         SUB       WSGINT        NewPrinc                         BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         ENDIF                                                    BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
     C                   ELSE
     C                   Z-ADD     HKAMNP        NewPrinc
     C                   END
      *
      ** Format the new principal for screen output
      *
     C                   Z-ADD     NewPrinc      @@AMTW
     C                   Z-ADD     HKCYDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDRAMN
      *
      ** If rollover from an 'in' currency to Euros is required
      ** convert the new principal amount to its Euro equivalent
      *
     C     DDRACT        IFEQ      'C'
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      NewPrinc      P@FRAM           18 3
     C                   PARM      HKCCY         P@FRCY            3
     C                   PARM      BKEURO        P@TOCY            3
     C                   PARM      *ZERO         P@OUTA           15 0
     C                   PARM                    P@INTA           18 3
     C                   PARM                    P@EXRT           15 9
     C                   PARM                    P@MDIN            1
      *
      * DATABASE ERROR
      *
     C     P@RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'EU0200'      DBFILE
     C                   MOVE      '102'         DBASE
     C                   MOVEL     HKCCY         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Format the Euro equivalent amount for screen output
      *
     C                   Z-ADD     P@OUTA        @@AMTW
     C                   Z-ADD     EuroNBDP      @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDAMNP
     C                   ELSE
     C                   MOVE      DDRAMN        DDAMNP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CGL031
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      * SRCalEUTax - Calculate EU Withholding Tax                                             CGL031
      *****************************************************************                       CGL031
     C     SRCalEuTax    BEGSR                                                                CGL031
                                                                                              CGL031
     C                   IF        HKIPDS = 'N' and                                           CGL031
     C                             HKFUID <> 'Y'                                              CGL031
                                                                                              CGL031
     C                   IF        HKTYPE = 'IT' or                                           CGL031
     C                             HKTYPE = 'TD' or                                           CGL031
     C                             HKTYPE = 'CD' or                                           CGL031
     C                             HKTYPE = 'DT' and CDL006 = 'Y' or                          CGL031
     C                             HKTYPE = 'LT' and CDL006 = 'Y' or                          CGL031
     C                             HKTYPE = 'FT' and CDL006 = 'Y'                             CGL031
                                                                                              CGL031
     C                   IF        HKIPDS = 'Y'                                               234407
     C                   MOVEL     HKIMET        PSetType                                     234407
     C                   MOVEL     HKINSA        PSetAcc                                      234407
     C                   MOVE      HKINSA        PBranch                                      234407
     C                   EVAL      PCurrency = HKCCY                                          234407
     C                   ELSE                                                                 234407
                                                                                              234407
     C                   EVAL      PBranch = HKBRCA                                           CGL031
     C                   MOVE      HKCNUM        PCustomer                                    CGL031
     C                   EVAL      PCurrency = HKCCY                                          CGL031
     C                   EVAL      PSetType = HKPSTM                                          CGL031
     C                   EVAL      PSetAcc = HKPONS                                           CGL031
     C                   ENDIF                                                                234407
                                                                                              CGL031
      ** Retrieve Interest Settlement Customer                                                CGL031
                                                                                              CGL031
     C                   IF        PSetType <> 00                                             234407
     C                             AND PSetType <> 01                                         234407
     C                             AND PSetType <> 02                                         234407
     C                             AND PSetType <> 08                                         234407
     C                             AND PSetType <> 12                                         234407
     C                             AND DealCust <> 'Y'                                      MD026788
                                                                                              234407
     C                   EXSR      SRGetSetAc                                                 CGL031
                                                                                              CGL031
     C                   MOVE      PCustNum      WCustomer                                    CGL031
     C                   MOVE      HKDN38        WDealNo                                      CGL031
                                                                                              234407
     C                   ELSE                                                                 234407
     C                   MOVE      HKCNUM        WCustomer                                    234407
     C                   MOVE      HKDN38        WDealNo                                      234407
     C                   ENDIF                                                                234407
                                                                                              CGL031
     C                   EVAL      WEUTaxAmt = *Zero                                          CGL031
                                                                                              CGL031
     C                   EVAL      WSecTxAmt = *ZEROS                                         CER048
     C                   EVAL      W3rdTxAmt = *ZEROS                                         CER054
      *                                                                                       CER048
      ** Calculate Taxable Amount                                                             233283
                                                                                              233283
     C                   EXSR      SRRtvCustDet                                               233283
                                                                                              233283
      ** Calculate Withholding Tax                                                            CGL031
                                                                                              CGL031
     C                   EXSR      SRCallZPI                                                  CGL031
                                                                                              CGL031
     C                   SELECT                                                               CGL031
                                                                                              CGL031
     C                   WHEN      PReturn = 'ERROR'                                          CGL031
     C                   EVAL      DBASE = 103                                                CGL031
     C                   EVAL      DBFILE = PDBaseFil                                         CGL031
     C                   EVAL      DBKEY  = PDBaseKey                                         CGL031
     C                   EXSR      *PSSR                                                      CGL031
                                                                                              CGL031
     C                   WHEN      PReturn <> 'JOINT'                                         CGL031
     C                   EVAL      WEUTaxAmt = PTaxAmt                                        CGL031
                                                                                              CGL031
     C                   EVAL      WSecTxAmt = PStxa                                          CER048
     C                   EVAL      W3rdTxAmt = PTtxa                                          CER054
      *                                                                                       CER048
     C                   WHEN      PReturn = 'JOINT'                                          CGL031
                                                                                              CGL031
      ** Process JOINT accounts                                                               CGL031
                                                                                              CGL031
     C                   EXSR      SRProcJA                                                   CGL031
                                                                                              CGL031
     C                   ENDSL                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      * SRGetSetAc - Retrieve Settlement Account                                              CGL031
      *****************************************************************                       CGL031
     C     SRGetSetAc    BEGSR                                                                CGL031
                                                                                              CGL031
     C                   CALLB     'ZAGETSETAC'                                               CGL031
                                                                                              CGL031
      ** Outputs                                                                              CGL031
     C                   PARM                    PRetCode                                     CGL031
     C                   PARM                    PAccCode                                     CGL031
     C                   PARM                    PAccSeq                                      CGL031
     C                   PARM                    PMemosInd                                    CGL031
     C                   PARM                    PPronoInd                                    CGL031
                                                                                              CGL031
      ** Input/Output                                                                         CGL031
     C                   PARM                    PBranch                                      CGL031
     C                   PARM                    PCustNum                                     CGL031
     C                   PARM                    PCurrency                                    CGL031
                                                                                              CGL031
      ** Inputs                                                                               CGL031
     C                   PARM                    PSetType                                     CGL031
     C                   PARM                    PSetAcc                                      CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       233283
      /EJECT                                                                                  233283
      *****************************************************************                       233283
      * SRRtvCustDet - Retrieve Customer Details                      *                       233283
      *****************************************************************                       233283
     C     SRRtvCustDet  BEGSR                                                                233283
                                                                                              233283
      ** Branch details                                                                       233283
                                                                                              233283
     C                   CALL      'AOBRCHR0'                                                 233283
     C                   PARM      *BLANKS       PRTCD                                        233283
     C                   PARM      '*KEY   '     POPTN                                        233283
     C                   PARM                    HKBRCA                                       233283
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        233283
                                                                                              233283
      **  Database Error                                                                      233283
                                                                                              233283
     C     PRTCD         IFNE      *BLANKS                                                    233283
     C                   EVAL      DBKEY = '*KEY   '                                          233283
     C                   EVAL      DBFILE = 'SDBRCHPD'                                        233283
     C                   EVAL      DBASE  = 107                                               233283
     C                   EXSR      *PSSR                                                      233283
     C                   ENDIF                                                                233283
                                                                                              233283
      ** Country code details                                                                 233283
                                                                                              233283
     C                   CALL      'AOLOCNR0'                                                 233283
     C                   PARM      *BLANKS       PRTCD                                        233283
     C                   PARM      '*KEY   '     POPTN                                        233283
     C                   PARM                    A8LCCD                                       233283
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        233283
                                                                                              233283
      **  Database Error                                                                      233283
                                                                                              233283
     C     PRTCD         IFNE      *BLANKS                                                    233283
     C                   EVAL      DBKEY = '*KEY   '                                          233283
     C                   EVAL      DBFILE = 'SDLOCNPD'                                        233283
     C                   EVAL      DBASE  = 108                                               233283
     C                   EXSR      *PSSR                                                      233283
     C                   ENDIF                                                                233283
                                                                                              233283
      ** Customer details                                                                     233283
                                                                                              233283
     C                   MOVEL     *BLANKS       @PKEY1                                       233283
     C                   MOVEL     HKCNUM        @PKEY1                                       233283
                                                                                              233283
     C                   CALL      'AOCUSTR0'                                                 233283
     C                   PARM      *BLANK        PRTCD                                        233283
     C                   PARM      '*KEY   '     POPTN                                        233283
     C                   PARM                    @PKEY1                                       233283
     C                   PARM                    @PKYST                                       233283
     C     SDCUST        PARM      SDCUST        DSSDY                                        233283
                                                                                              233283
      ** Database Error                                                                       233283
                                                                                              233283
     C     PRTCD         IFNE      *BLANK                                                     233283
     C                   MOVEL     @PKYST        DBKEY                                        233283
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        233283
     C                   EVAL      DBASE  = 109                                               233283
     C                   EXSR      *PSSR                                                      233283
     C                   ENDIF                                                                233283
                                                                                              233283
      ** Country of Tax                                                                       233283
                                                                                              233283
     C                   EVAL      WCNCD = DVCNCD                                             233283
     C                   EVAL      WCOLC = BBCOLC                                             233283
                                                                                              233283
     C                   CALL      'AOCTTXR0'                                                 233283
     C                   PARM      *BLANKS       PRTCD                                        233283
     C                   PARM      '*KEY   '     POPTN                                        233283
     C                   PARM                    WCNCD                                        233283
     C                   PARM                    WCOLC                                        233283
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        233283
                                                                                              233283
     C                   IF        PRTCD = '*NRF   '                                          233283
                                                                                              233283
     C                   EVAL      WCOLC = *BLANK                                             233283
     C                   CALL      'AOCTTXR0'                                                 233283
     C                   PARM      *BLANKS       PRTCD                                        233283
     C                   PARM      '*KEY   '     POPTN                                        233283
     C                   PARM                    WCNCD                                        233283
     C                   PARM                    WCOLC                                        233283
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        233283
                                                                                              233283
      ** Database Error                                                                       233283
                                                                                              233283
     C     PRTCD         IFNE      *BLANK                                                     233283
     C                   MOVEL     WCNCD         DBKEY                                        233283
     C                   MOVE      WCOLC         DBKEY                                        233283
     C                   EVAL      DBFILE = 'SDCTTXPD'                                        233283
     C                   EVAL      DBASE  = 110                                               233283
     C                   EXSR      *PSSR                                                      233283
     C                   ENDIF                                                                233283
     C                   ENDIF                                                                233283
                                                                                              233283
     C                   IF        HKSLID > *ZERO                                             233283
     C                   EVAL      @STRD = HKSLID                                             233283
     C                   ELSE                                                                 233283
     C                   EVAL      @STRD = HKDVSD                                             233283
     C                   ENDIF                                                                233283
                                                                                              233283
      ** Set up end date                                                                      233283
                                                                                              233283
     C                   EVAL      @ENDD = HKMATD                                             233283
      **********                                                                  BUG23550 BUG23711A
     C**********         IF        CER048 = 'Y'                                    BUG23550 BUG23711
      **********                                                                  BUG23550 BUG23711A
     C**********         RESET                   WSGINT                           BUG23550 BUG23711A
     C**********         RESET                   WSTXSR                           BUG23550 BUG23711A
     C**********         RESET                   WSSTDO                           BUG23550 BUG23711A
     C**********         EVAL      WCsin  = 'N'                                   BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         IF        CER048 = 'Y'                                   BUG23711 BUG23711A
      **********                                                                  BUG23550 BUG23711A
     C*****HKDN38        SETLL     SDCSINLD                                       BUG23550 BUG23711A
     C*****HKDN38        READE     SDCSINLD                               88      BUG23550 BUG23711A
      **********                                                                  BUG23550 BUG23711A
     C**********         DOW       *IN88 = *OFF                                   BUG23550 BUG23711A
      **********                                                                  BUG23550 BUG23711A
     C**********         EVAL      WCsin  = 'Y'                                   BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         IF        TSEDAT <> HKDVSD                               BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         EVAL      WSGINT = TSGINT + WSGINT                       BUG23550 BUG23711A
     C**********         EVAL      WSTXSR = TSTXSR + WSTXSR                       BUG23550 BUG23711A
     C**********         EVAL      WSSTDO = TSSTDO + WSSTDO                       BUG23550 BUG23711A
     C**********         EVAL      @STRD = TSEDAT                                 BUG23550 BUG23711A
      **********                                                                  BUG23550 BUG23711A
     C**********         ENDIF                                                    BUG23711 BUG23711A
     C*****HKDN38        READE     SDCSINLD                               88      BUG23550 BUG23711A
      **********                                                                  BUG23550 BUG23711A
     C**********         ENDDO                                                    BUG23550 BUG23711A
     C**********         ENDIF                                                    BUG23550 BUG23711A
                                                                                              233283
      ** Calculate taxable interest amount                                                    233283
                                                                                              233283
     C                   IF        WFlag <> 'Y'                                            BUG23711A
      *                                                                                    BUG23711A
     C                   IF        EWTRT1 = '1'                                               233283
     C                             AND @STRD < EWEDT1                                         233815
     C                   EVAL      WDY1 = @ENDD - @STRD                                       233283
     C                   EVAL      WDY2 = @ENDD - EWEDT1                                      233283
     C                   EVAL(H)   PTotalInt = (HKMTTI * WDY2) / WDY1                         233283
     C                   ELSE                                                                 233283
     C                   EVAL      PTotalInt = HKMTTI                                         233283
     C                   ENDIF                                                                233283
      *                                                                                    BUG23711A
     C                   ENDIF                                                             BUG23711A
                                                                                              233283
     C                   ENDSR                                                                233283
      *****************************************************************                       CGL031
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      * SRCallZPI - Calculate EU Withhlding Tax for Private Individual                        CGL031
      *****************************************************************                       CGL031
     C     SRCallZPI     BEGSR                                                                CGL031
                                                                                              CGL031
     C                   EVAL      PInth = *BLANKS                                            CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      PInth = 'T'                                                CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      PInth = 'N'                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C**********         EVAL      PTotalInt = PTotalInt - WSGINT                 BUG23550 BUG23711A
      **********                                                                  BUG23550 BUG23711A
     C                   CALL      'ZATXCLPI'                                                 CGL031
                                                                                              CGL031
      ** Input parameters                                                                     CGL031
     C                   PARM      'D'           PModuleID                                    CGL031
     C                   PARM      WDealNo       PTransRef                                    CGL031
     C                   PARM      HKBRCA        PBranch                                      CGL031
     C                   PARM      WCustomer     PCustomer                                    CGL031
     C**********         PARM      HKDVSD        PICStrDate                            CGL031 233283
     C**********         PARM      HKMATD        PICEndDate                            CGL031 233283
     C**********         PARM      HKMTTI        PTotalInt                             CGL031 233283
     C                   PARM                    PICStrDate                                   233283
     C                   PARM                    PICEndDate                                   233283
     C                   PARM                    PTotalInt                                    233283
     C                   PARM      *ZERO         PTaxRateAB                                   CGL031
     C                   PARM      HKCCY         POrigCcy                                     CGL031
     C**********         PARM                    PInth                               CER048 BUG22911
     C                   PARM      HKMTAX        PInth                                      BUG22911
                                                                                              CGL031
      ** Output parameters                                                                    CGL031
     C                   PARM                    PIntEfDat                                    CGL031
     C                   PARM                    PTaxAmt                                      CGL031
     C                   PARM                    PIntAmt                                      CGL031
     C                   PARM                    PTaxCcy                                      CGL031
     C                   PARM                    PCtryOfTax                                   CGL031
     C                   PARM                    PTaxBasket                                   CGL031
     C                   PARM                    PEUWTaxAcCd                                  CGL031
     C                   PARM                    PCtryOfLoc                                   CGL031
     C                   PARM                    PCustStat                                    CGL031
     C                   PARM                    PTrnTypEnd                                   CGL031
     C                   PARM                    PTaxRatePd                                   CGL031
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Basket                                                        CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStxb                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Account*Code                                                  CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStac                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Rate                                                          CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PSttr                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Transition*Type                                                   CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PSttp                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Amount                                                        CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStxa                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C                   PARM                    PDBaseKey                                    CGL031
     C                   PARM                    PDBaseFil                                    CGL031
     C                   PARM                    PReturn                                      CGL031
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
                                                                                              CGL031
      **********                                                                  BUG23550 BUG23711A
     C**********         EVAL      PTotalInt = PTotalInt + WSGINT                 BUG23550 BUG23711A
     C**********         EVAL      PTaxAmt = PTaxAmt + WSTXSR                     BUG23550 BUG23711A
     C**********         EVAL      PStxa = PStxa + WSSTDO                         BUG23550 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         IF        TSEDAT < HKMATD AND                            BUG23711 BUG23711A
     C**********                   WCsin  = 'Y'                                   BUG23711 BUG23711A
     C**********         EVAL      PTaxAmt = PTaxAmt - WSTXSR                     BUG23711 BUG23711A
     C**********         EVAL      PStxa = PStxa - WSSTDO                         BUG23711 BUG23711A
     C**********         ENDIF                                                    BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      * SRCallZJA - Calculate EU Withhlding Tax for Joint Account                             CGL031
      *****************************************************************                       CGL031
     C     SRCallZJA     BEGSR                                                                CGL031
                                                                                              CGL031
     C**********         EVAL      PTotalInt = PTotalInt - WSGINT                 BUG23550 BUG23711A
      **********                                                                  BUG23550 BUG23711A
     C                   CALL      'ZATXCLJA'                                                 CGL031
                                                                                              CGL031
      ** Input parameters                                                                     CGL031
     C                   PARM      'D'           PModuleID                                    CGL031
     C                   PARM      WDealNo       PTransRef                                    CGL031
     C                   PARM      HKBRCA        PBranch                                      CGL031
     C                   PARM      WCustomer     PJointAcNo                                   CGL031
     C                   PARM      JCCUST        PCustomer                                    CGL031
     C                   PARM      JCNAHO        PNAHRef                                      CGL031
     C                   PARM      JCINVP        PInvProp                                     CGL031
     C                   PARM      JCPAHT        PPrmAcHldr        1                        BUG26839
     C**********         PARM      HKDVSD        PICStrDate                            CGL031 233283
     C**********         PARM      HKMATD        PICEndDate                            CGL031 233283
     C**********         PARM      HKMTTI        PTotalInt                             CGL031 233283
     C                   PARM                    PICStrDate                                   233283
     C                   PARM                    PICEndDate                                   233283
     C                   PARM                    PTotalInt                                    233283
     C                   PARM      *ZERO         PTaxRateAB                                   CGL031
     C                   PARM      HKCCY         POrigCcy                                     CGL031
     C**********         PARM                    PInth                               CER048 BUG22911
     C                   PARM      HKMTAX        PInth                                      BUG22911
                                                                                              CGL031
      ** Output parameters                                                                    CGL031
     C                   PARM                    PIntEfDat                                    CGL031
     C                   PARM                    PTaxAmt                                      CGL031
     C                   PARM                    PIntAmt                                      CGL031
     C                   PARM                    PTaxCcy                                      CGL031
     C                   PARM                    PCtryOfTax                                   CGL031
     C                   PARM                    PTaxBasket                                   CGL031
     C                   PARM                    PEUWTaxAcCd                                  CGL031
     C                   PARM                    PCtryOfLoc                                   CGL031
     C                   PARM                    PCustStat                                    CGL031
     C                   PARM                    PTrnTypEnd                                   CGL031
     C                   PARM                    PTaxRatePd                                   CGL031
     C                   PARM                    PJntAccMng                                   CGL031
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Basket                                                        CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStxb                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Account*Code                                                  CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStac                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Rate                                                          CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PSttr                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Transition*Type                                                   CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PSttp                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
      ***Secondary*Tax*Amount                                                        CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C**********         PARM                    PStxa                               CER048 BUG22911
      **********                                                                     CER048 BUG22911
     C                   PARM                    PDBaseKey                                    CGL031
     C                   PARM                    PDBaseFil                                    CGL031
     C                   PARM                    PReturn                                      CGL031
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
      **********                                                                  BUG23550 BUG23711A
     C**********         EVAL      PTotalInt = PTotalInt + WSGINT                 BUG23550 BUG23711A
     C**********         EVAL      PTaxAmt = PTaxAmt + WSTXSR                     BUG23550 BUG23711A
     C**********         EVAL      PStxa = PStxa + WSSTDO                         BUG23550 BUG23711A
      **********                                                                  BUG23711 BUG23711A
     C**********         IF        TSEDAT < HKMATD AND                            BUG23711 BUG23711A
     C**********                   WCsin  = 'Y'                                   BUG23711 BUG23711A
     C**********         EVAL      PTaxAmt = PTaxAmt - WSTXSR                     BUG23711 BUG23711A
     C**********         EVAL      PStxa = PStxa - WSSTDO                         BUG23711 BUG23711A
     C**********         ENDIF                                                    BUG23711 BUG23711A
      **********                                                                  BUG23711 BUG23711A
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      * SRProcJA - Process Joint Accounts                                                     CGL031
      *****************************************************************                       CGL031
     C     SRProcJA      BEGSR                                                                CGL031
                                                                                              CGL031
     C     WCustomer     SETLL     SDJACCLB                                                   CGL031
     C     WCustomer     READE     SDJACCLB                               21                  CGL031
                                                                                              CGL031
     C                   DOW       *IN21 = *OFF                                               CGL031
                                                                                              CGL031
     C                   EXSR      SRCallZJA                                                  CGL031
                                                                                              CGL031
     C                   IF        PReturn = 'ERROR'                                          CGL031
     C                   EVAL      DBASE = 104                                                CGL031
     C                   EVAL      DBFILE = PDBaseFil                                         CGL031
     C                   EVAL      DBKEY  = PDBaseKey                                         CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PCustStat = 'TAXAB'                                        CGL031
     C                   EVAL      WEUTaxAmt = WEUTaxAmt + PTaxAmt                            CGL031
     C                   EVAL      WSecTxAmt = WSecTxAmt + PStxa                              CER048
     C                   EVAL      W3rdTxAmt = W3rdTxAmt + PTtxa                              CER054
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PReturn = 'NOTAX'                                          CGL031
     C                             OR PReturn = 'TAXAB'                                       CGL031
     C     WCustomer     READE     SDJACCLB                               21                  CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PReturn = 'LAST'                                           CGL031
     C                   MOVE      *ON           *IN21                                        CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDDO                                                                CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_MDAT - SET UP NEW MATURITY DATE
      ******************************************************************
     C     SETN_MDAT     BEGSR
      *
      * If not automatic rollover, the new maturity date is unknown
      * Otherwise, calculate it.
      *
     C     HKAURO        IFNE      'Y'
     C                   Z-ADD     0             NewMatDate
     C                   MOVE      *BLANKS       DDMDAT
     C                   ELSE
      *
     C                   MOVE      HKROFQ        WWROFQ            1                          243842
     C     HKROFQ        IFEQ      'A'                                                        243842
     C     BK_BKAPFQ     ANDEQ     'D'                                                        243842
     C     HKROFQ        OREQ      'A'                                                        243842
     C     BK_BKAPFQ     ANDEQ     'W'                                                        243842
     C     HKROFQ        OREQ      'A'                                                        243842
     C     BK_BKAPFQ     ANDEQ     'F'                                                        243842
     C                   MOVE      'M'           WWROFQ                                       243842
     C                   ENDIF                                                                243842
                                                                                              243842
     C                   CALLB     'ZFRQA'
     C**********         PARM      HKROFQ        ZFREQ             1                          243842
     C                   PARM      WWROFQ        ZFREQ             1                          243842
     C                   PARM      OldMatDate    ZDAYNO            5 0
     C                   PARM      HKRLDN        ZMDAY             2 0
     C                   PARM      DDCCY         ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
     C                   PARM                    BJDFIN
      *
     C                   Z-ADD     ZDAYNO        NewMatDate        5 0
     C                   EXSR      CVTDATDMY
     C                   MOVE      ZDATE         DDMDAT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                 BUG5916
      *****************************************************************                      BUG5916
      * SETN_DLDT - SET UP NEW DEAL DATE                                                     BUG5916
      ******************************************************************                     BUG5916
     C     SETN_DLDT     BEGSR                                                               BUG5916
      *                                                                                      BUG5916
      ** Set deal date to be today's date for the new deal                                   BUG5916
     C                   Z-ADD     BJRDNB        ZDAYNO                                      BUG5916
     C                   EXSR      CVTDATDMY                                                 BUG5916
     C                   MOVE      ZDATE         DDDLDT                                      BUG5916
     C                   ENDSR                                                               BUG5916
     C********************************************************************                   BUG5916
      /EJECT
      *****************************************************************
      * SETN_INTR - SET UP NEW INTEREST RATE
      ******************************************************************
     C     SETN_INTR     BEGSR
      *
      ** Get interest rate record at or prior to new maturity date
      *
     C     DLINTRK       KLIST                                                                 S0143
     C                   KFLD                    DDCCY                                         S0143
     C                   KFLD                    NewMatDate                                    S0143
     C     DLINTRK       CHAIN     DLINTRL2                           64
      *
     C                   MOVE      '0'           *IN65
     C     *IN64         IFEQ      '1'
     C     DLINTRK       SETLL     DLINTRL2
     C*****NewMatDate    IFGT      0                                                   246101 255405
     C                   READP     DLINTRL2                               65
     C**********         ELSE                                                          246101 255405
     C**********         READ      DLINTRL2                               65           246101 255405
     C**********         ENDIF                                                         246101 255405
     C                   ENDIF
      *
      ** If no interest rate record is found
      *
     C     *IN65         IFEQ      '1'
     C     HWCCY         ORNE      DDCCY
      *
     C     DDRACT        IFNE      'C'
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      HKINTR        @@AMTW
     C                   ELSE
     C                   Z-ADD     *ZERO         @@AMTW
     C                   ENDIF
      *
      ** If an interest rate record is found
      *
     C                   ELSE
      *
      ** If period is yearly, use 'yearly' interest rates
      *
     C     HWTPRD        IFEQ      'Y'
     C                   MOVE      'Y'           YEARLY            1
     C     DLINTRK       CHAIN     DLINTRL1                           64
      *
      ** IF NO EXACT RECORD USE PRECEDING ONE
      *
     C     *IN64         IFEQ      '1'
     C     DLINTRK       SETLL     DLINTRL1
     C                   READP     DLINTRL1                               65
     C                   END
     C                   ELSE
     C                   MOVE      'N'           YEARLY
     C                   END
      *
      * Set Near rate
      * Use bid or offer rate according to deal type
      *
     C     HKMTYP        IFEQ      'CI'
     C     HKMTYP        OREQ      'TI'
     C     HKMTYP        OREQ      'IP'
     C     HKMTYP        OREQ      'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     HKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C/COPY WNCPYSRC,MMLDNIOC05
     C                   Z-ADD     HWLDRT        ZINRAT
     C                   ELSE
     C                   Z-ADD     HWBRRT        ZINRAT
     C                   ENDIF
      *
      * Set Near date
      *
     C                   Z-ADD     HWPRDN        ZINDAT
      *
      * Set broken date - date at which interest rate is to be calculated
      *
     C                   Z-ADD     NewMatDate    ZIBDAT
      *
      ** GET NEXT RECORD FROM APPROPRIATE FILE
      *
     C     YEARLY        IFEQ      'Y'
     C                   READ      DLINTRL1                               65
     C                   ELSE
     C                   READ      DLINTRL2                               65
     C                   END
      *
      ** FIND INTERPOLATED RATE IF NECESSARY
      *
     C     HWCCY         IFEQ      DDCCY
     C     HWTPRD        ANDNE     'D'
      *
      * Set Far rate
      * Use bid or offer rate according to deal type
      *
     C     HKMTYP        IFEQ      'CI'
     C     HKMTYP        OREQ      'TI'
     C     HKMTYP        OREQ      'IP'
     C     HKMTYP        OREQ      'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     HKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C/COPY WNCPYSRC,MMLDNIOC06
     C                   Z-ADD     HWLDRT        ZIFRAT
     C                   ELSE
     C                   Z-ADD     HWBRRT        ZIFRAT
     C                   ENDIF
      *
      * Set Far date
      *
     C                   Z-ADD     HWPRDN        ZIFDAT
      *
      * Interpolate rate
      *
     C**********         CALLB     'ZINTPL'                                                   CAS001
     C                   CALL      'ZAINTPL'                                                  CAS001
     C                   PARM                    ZINDAT            5 0
     C                   PARM                    ZIBDAT            5 0
     C                   PARM                    ZIFDAT            5 0
     C                   PARM                    ZINRAT           13 9
     C                   PARM                    ZIFRAT           13 9
     C                   PARM                    ZIBRAT           13 9
      *
      * Interest rate calculated = 'broken' rate (as at broken date)
      *
     C                   Z-ADD(H)  ZIBRAT        WIntRat          11 7
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      WIntRat       @@AMTW
      *
      ** ELSE USE RATE FROM FIRST RECORD
      *
     C                   ELSE
     C                   Z-ADD(H)  ZINRAT        WIntRat
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      WIntRat       @@AMTW
     C                   ENDIF
      *****************************************************************               BUG8761 246101
      ***Use*the*interest*rate*of*the*previous*deal*being*rolled-******               BUG8761 246101
      ***over*as*the*default*interest*rate.****************************               BUG8761 246101
      *****************************************************************               BUG8761 246101
     C**********         MOVE      HKINTR        @@AMTW                               BUG8761 246101
     C                   MOVE      HKINTR        @@AMTW                                       255405
     C                   ENDIF
      *
      * Format interest rate for screen output
      *
     C     @@AMTW        IFNE      *ZERO
     C                   MOVE      7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDSPRT
     C/COPY WNCPYSRC,MMLDNIOC07
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_BRTE - SET UP NEW BASE RATE CODE & SPREAD
      ******************************************************************
     C     SETN_BRTE     BEGSR
      *
      * Base rate code for screen output
      *
     C                   MOVE      HKBSRC        DDBSRC
      *
      * Format spread for screen output
      *
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      HKSPRD        @@AMTW
     C/COPY WNCPYSRC,MMLDNIOC08
      *                                                                                       CDL033
      ** Allow negative spread                                                                CDL033
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     HKSPRD        IFLT      *ZEROS                                                     CDL033
     C                   Z-ADD     1             PS                2 0                        CDL033
     C                   ELSE                                                                 CDL033
     C                   Z-ADD     0             PS                2 0                        CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   MOVE      7             @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDSPRT
      *                                                                                       CDL033
      ** Allow negative spread                                                                CDL033
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     0             IFNE      PS                                                         CDL033
                                                                                              CDL033
     C                   MOVEA     DDSPRT        WSP                                          CDL033
     C                   MOVEL     ' '           WW1               1                          CDL033
                                                                                              CDL033
     C     1             DO        12            PS                                           CDL033
     C                   MOVE      WSP(PS)       WW2               1                          CDL033
                                                                                              CDL033
     C     WW1           IFEQ      ' '                                                        CDL033
     C     WW2           ANDNE     ' '                                                        CDL033
     C     PS            ANDNE     1                                                          CDL033
     C     PS            SUB       1             PS1               2 0                        CDL033
     C                   MOVE      '-'           WSP(PS1)                                     CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   MOVEL     WW2           WW1                                          CDL033
     C                   ENDDO                                                                CDL033
                                                                                              CDL033
     C                   MOVEA     WSP           DDSPRT                                       CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C/COPY WNCPYSRC,MMLDNIOC09
      *
     C                   ENDSR
      *****************************************************************                     AR848507
      /EJECT                                                                                AR848507
      *****************************************************************                     AR848507
      * SETN_AIR - SET UP NEW ACTUAL INTEREST RATE                                          AR848507
      ******************************************************************                    AR848507
     C     SETN_AIR      BEGSR                                                              AR848507
      *                                                                                     AR848507
      ** Reset Actual Interest Rate for recalculation                                       AR848507
      *                                                                                     AR848507
     C                   MOVE      *BLANKS       DDAIR                                      AR848507
      *                                                                                     AR848507
     C                   ENDSR                                                              AR848507
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_ICMT - SET UP NEW INTEREST CALCULATION METHOD
      ******************************************************************
     C     SETN_ICMT     BEGSR
      *
      ** Default Interest calculation method
      *
     C*****DDRACT******  IFEQ      'C'                                                        220554
     C     DDRACT        IFNE      'C'                                                        220554
     C                   MOVE      HKICMT        DDICMT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_BRAT - SET UP NEW BASE CURRENCY RATE
      ******************************************************************
     C     SETN_BRAT     BEGSR
      *
     C                   MOVE      *BLANK        DDBRAT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_TOTI - SET UP NEW TOTAL INTEREST
      ******************************************************************
     C     SETN_TOTI     BEGSR
      *
     C                   MOVE      *BLANK        DDTOTI
     C                   MOVEL     '*'           DDTOTI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETN_CSNM - SET UP NEW CUSTOMER SHORTNAME
      ******************************************************************
     C     SETN_CSNM     BEGSR
      *
     C                   MOVEL     HKCSNM        DDCSNM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDATYMD - CONVERT DATE FROM YYYYMMDD TO DDMMYY (OR MMDDYY)  *
      *****************************************************************
     C     CVTDATYMD     BEGSR
      *
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDATDMY - CONVERT DATE FROM DAY NUMBER TO DDMMYY (OR MMDDYY)*
      *****************************************************************
     C     CVTDATDMY     BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDATMDN - CONVERT DATE FROM DDMMYY TO MIDAS DAY NUMBER      *
      *****************************************************************
     C     CVTDATMDN     BEGSR
      *
     C                   CALLB     'ZA0270'
     C                   PARM                    @@DTOU            6 0
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        @@RTN             1
     C                   PARM      *ZERO         @@DAYN            5 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANKS       DDACTN
     C                   MOVE      *BLANKS       DDDLNO
     C                   MOVE      *BLANKS       DDDADN
     C                   MOVE      *BLANKS       DDVDAT
     C                   MOVE      *BLANKS       DDMDAT
     C                   MOVE      *BLANKS       DDCCY
     C                   MOVE      *BLANKS       DDRAMN
     C                   MOVE      *BLANKS       DDBSRC
     C                   MOVE      *BLANKS       DDSPRT
     C                   MOVE      *BLANKS       DDICMT
     C                   MOVE      *BLANKS       DDBRAT
     C                   MOVE      *BLANKS       DDTOTI
      *
     C                   MOVE      *BLANKS       DDCSNM
     C                   MOVE      *BLANKS       DDAMNP
     C                   Z-ADD     *ZERO         OldMatDate
     C                   MOVE      *BLANKS       DDDLDT                                      BUG5916
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * ROLLOVER ACTION CODE
     C                   PARM                    DDRACT            1
      *
      * ROLLOVER DEAL DETAILS
     C                   PARM                    DlFilFmt
      *
      * ICD
      * Date format
      * Euro currency code
      * Currency decimal separator
      * Hong Kong tax rate
      * BRT installed
      * Euro rollover installed
      * Euro currency decimal places
      * Date Effective From
      * Previous basic rate tax
      * Basic rate tax
     C                   PARM                    BJDFIN            1
     C                   PARM                    BKEURO            3
     C                   PARM                    BNDCSP            1
     C                   PARM                    BNHKTR            5 2
     C                   PARM                    S01383            1
     C                   PARM                    CEU015            1
     C                   PARM                    EuroNBDP          1 0
     C                   PARM                    DEFF              5 0
     C                   PARM                    PBRTR             7 5
     C                   PARM                    BRTR              7 5
     C                   PARM                    CDL033                                       CDL033
      *
      * OUTPUT PARAMETERS
      *
      * Action code
      * Deal number
      * Rollover Deal Number
      * Value Date
      * Maturity Date
      * Currency
      * Rollover Amount
      * Base Rate Code
      * Spread/Rate
      * Interest Calc. Method
      * Base Currency Rate
      * Total interest
     C                   PARM                    DDACTN            1
     C                   PARM                    DDDLNO            6
     C                   PARM                    DDDADN            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDMDAT            6
     C                   PARM                    DDCCY             3
     C                   PARM                    DDRAMN           14
     C                   PARM                    DDBSRC            2
     C                   PARM                    DDSPRT           12
     C                   PARM                    DDICMT            1
     C                   PARM                    DDBRAT           13
     C                   PARM                    DDTOTI           14
      *
      * Customer shortname
      * Principal amount
      * Old Maturity Date
     C                   PARM                    DDCSNM           10
     C                   PARM                    DDAMNP           14
     C                   PARM                    OldMatDate        5 0
      * New deal date
     C                   PARM                    DDDLDT            6                         BUG5916
      * New actual interest rate                                                            AR848507
     C                   PARM                    DDAIR            12                        AR848507
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNIROD'   DBPGM
      *                                                                                       CGL031
      ** Determine if CGL031 is installed.                                                    CGL031
      *                                                                                       CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
      *                                                                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   IF        PRTCD = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
      ** Database Error                                                                       CGL031
      *                                                                                       CGL031
     C                   IF        PRTCD  <> *BLANKS AND                                      CGL031
     C                             PRTCD <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBKEY = 'CGL031'                                           CGL031
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBASE = 106                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                     MD026788
      ** Access system values                                                               MD026788
      *                                                                                     MD026788
     C                   IF        CGL031 = 'Y'                                             MD026788
     C                   CALLB     'AOSVALR0'                                               MD026788
     C                   PARM      *BLANKS       P@RTCD                                     MD026788
     C                   PARM      UseDealCust   P@OP01                                     MD026788
     C                   PARM                    P@VL01                                     MD026788
     C                   PARM                    P@OP02                                     MD026788
     C                   PARM                    P@VL02                                     MD026788
     C                   PARM                    P@OP03                                     MD026788
     C                   PARM                    P@VL03                                     MD026788
     C                   PARM                    P@OP04                                     MD026788
     C                   PARM                    P@VL04                                     MD026788
     C                   PARM                    P@OP05                                     MD026788
     C                   PARM                    P@VL05                                     MD026788
     C                   PARM                    P@OP06                                     MD026788
     C                   PARM                    P@VL06                                     MD026788
     C                   PARM                    P@OP07                                     MD026788
     C                   PARM                    P@VL07                                     MD026788
     C                   PARM                    P@OP08                                     MD026788
     C                   PARM                    P@VL08                                     MD026788
     C                   PARM                    P@OP09                                     MD026788
     C                   PARM                    P@VL09                                     MD026788
     C                   PARM                    P@OP10                                     MD026788
     C                   PARM                    P@VL10                                     MD026788
                                                                                            MD026788
     C                   IF        P@RTCD <> *BLANKS                                        MD026788
     C     *LOCK         IN        LDA                                                      MD026788
     C                   EVAL      DBKEY  = P@OP01                                          MD026788
     C                   EVAL      DBASE  = 113                                             MD026788
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD026788
     C                   OUT       LDA                                                      MD026788
     C                   EXSR      *PSSR                                                    MD026788
     C                   ENDIF                                                              MD026788
      *                                                                                     MD026788
     C                   MOVEL     P@VL01        DealCust          1                        MD026788
     C                   ENDIF                                                              MD026788
      *                                                                                       CDL013
     C                   CALLB     'AOSARDR0'                                                 CDL013
     C                   PARM      *BLANKS       @RTCD                                        CDL013
     C                   PARM      '*VERIFY'     @OPTN                                        CDL013
     C                   PARM      'CDL013'      @SARD                                        CDL013
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL013
     C     @RTCD         IFEQ      *BLANKS                                                    CDL013
      *                                                                                       CDL013
      ** Set CAR indicator to 'Y', set Tax Indicator ON and                                   CDL013
      ** declare work field to access WHT ICD extension file.                                 CDL013
     C                   MOVE      'Y'           CDL013                                       CDL013
     C                   MOVEL     'RETAIL'      WTYPE            10                          CDL013
      *                                                                                       CDL013
      ** Open & access WHT ICD extension file to retrieve WHT rate                            CDL013
     C     WTYPE         CHAIN     SDSTAAL1                           70                      CDL013
      *                                                                                       CDL013
      ** If CHAIN failed                                                                      CDL013
     C     *IN70         IFEQ      '1'                                                        CDL013
     C                   EXSR      *PSSR                                                      CDL013
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
     C                   ELSE                                                                 CDL013
      *                                                                                       CDL013
     C     @RTCD         IFNE      '*NRF   '                                                  CDL013
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL013
     C                   Z-ADD     2             DBASE                                        CDL013
     C                   MOVEL     'CDL013'      DBKEY                                        CDL013
     C                   EXSR      *PSSR                                                      CDL013
     C                   ENDIF                                                                CDL013
     C                   MOVE      'N'           CDL013                                       CDL013
      *                                                                                       CDL013
     C                   ENDIF                                                                CDL013
                                                                                              CGL031
      *                                                                                       CER048
      ** Access SAR details file to determine if CER048 is installed                          CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*VERIFY'     POPTN                                        CER048
     C                   PARM      'CER048'      PSARD                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database Error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRTCD  <> *BLANKS AND                                      CER048
     C                             PRTCD <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 107                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRTCD = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      *                                                                                       CER054
      ** Access SAR details file to determine if CER054 is installed                          CER054
      *                                                                                       CER054
     C                   CALLB     'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRTCD                                        CER054
     C                   PARM      '*VERIFY'     POPTN                                        CER054
     C                   PARM      'CER054'      PSARD                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
      ** Database Error                                                                       CER054
      *                                                                                       CER054
     C                   IF        PRTCD  <> *BLANKS AND                                      CER054
     C                             PRTCD <> '*NRF   '                                         CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBASE = 111                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        PRTCD = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   ELSE                                                                 CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C/COPY WNCPYSRC,MMLDNIOC04
      *
      ** Access Bank details via access program                                              BUG5916
      *  (database error handling done in access program)                                    BUG5916
     C                   CALLB     'AOBANKR0'                                                BUG5916
     C                   PARM      '*DBERR '     @RTCD             7                         BUG5916
     C                   PARM      '*FIRST '     @OPTN             7                         BUG5916
     C     SDBANK        PARM      SDBANK        DSFDY                                       BUG5916
      *                                                                                      BUG5916
      ** Access General Ledger details via access program                                     243842
      *  (database error handling done in access program)                                     243842
     C                   CALLB     'AOGELRR1'                                                 243842
     C                   PARM      '*DBERR '     @RTCD                                        243842
     C                   PARM      '*FIRST '     @OPTN                                        243842
     C     SDGELR        PARM      SDGELR        DSSDY                                        243842
                                                                                              CDL081
      ** Check if CDL081 is installed                                                         CDL081
                                                                                              CDL081
     C                   EVAL      CDL081 = 'N'                                               CDL081
     C                   CALLB     'AOSARDR0'                                                 CDL081
     C                   PARM      *BLANKS       PRTCD                                        CDL081
     C                   PARM      '*VERIFY'     POPTN                                        CDL081
     C                   PARM      'CDL081'      PSARD                                        CDL081
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL081
                                                                                              CDL081
     C                   IF        PRTCD <> *BLANKS                                           CDL081
     C                             AND PRTCD <> '*NRF'                                        CDL081
     C     *LOCK         IN        LDA                                                        CDL081
     C                   EVAL      DBASE  = 111                                               CDL081
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL081
     C                   EVAL      DBKEY  = PSARD                                             CDL081
     C                   OUT       LDA                                                        CDL081
     C                   EXSR      *PSSR                                                      CDL081
     C                   ENDIF                                                                CDL081
                                                                                              CDL081
     C                   IF        PRTCD = *BLANKS                                            CDL081
     C                   EVAL      CDL081 = 'Y'                                               CDL081
     C                   ENDIF                                                                CDL081
                                                                                              CDL081
      ** Access withholding tax round down system values if CDL081 is on                      CDL081
                                                                                              CDL081
     C                   IF        CDL081 = 'Y'                                               CDL081
     C                   CALLB     'AOSVALR0'                                                 CDL081
     C                   PARM      *BLANKS       P@RTCD                                       CDL081
     C                   PARM      C#BASE        P@OP01                                       CDL081
     C                   PARM                    P@VL01                                       CDL081
     C                   PARM      C#NBAS        P@OP02                                       CDL081
     C                   PARM                    P@VL02                                       CDL081
     C                   PARM                    P@OP03                                       CDL081
     C                   PARM                    P@VL03                                       CDL081
     C                   PARM                    P@OP04                                       CDL081
     C                   PARM                    P@VL04                                       CDL081
     C                   PARM                    P@OP05                                       CDL081
     C                   PARM                    P@VL05                                       CDL081
     C                   PARM                    P@OP06                                       CDL081
     C                   PARM                    P@VL06                                       CDL081
     C                   PARM                    P@OP07                                       CDL081
     C                   PARM                    P@VL07                                       CDL081
     C                   PARM                    P@OP08                                       CDL081
     C                   PARM                    P@VL08                                       CDL081
     C                   PARM                    P@OP09                                       CDL081
     C                   PARM                    P@VL09                                       CDL081
     C                   PARM                    P@OP10                                       CDL081
     C                   PARM                    P@VL10                                       CDL081
                                                                                              CDL081
     C                   IF        P@RTCD <> *BLANKS                                          CDL081
     C     *LOCK         IN        LDA                                                        CDL081
     C                   IF        P@VL01 = '*NRF'                                            CDL081
     C                   EVAL      DBKEY  = P@OP01                                            CDL081
     C                   ENDIF                                                                CDL081
     C                   IF        P@VL02 = '*NRF'                                            CDL081
     C                   EVAL      DBKEY  = P@OP02                                            CDL081
     C                   ENDIF                                                                CDL081
     C                   EVAL      DBASE  = 112                                               CDL081
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL081
     C                   OUT       LDA                                                        CDL081
     C                   EXSR      *PSSR                                                      CDL081
     C                   ENDIF                                                                CDL081
                                                                                              CDL081
      ** Setup tax amount rounding down indicators                                            CDL081
                                                                                              CDL081
     C                   EVAL      W#BSRD = P@VL01                                            CDL081
     C                   EVAL      W#NBRD = P@VL02                                            CDL081
     C                   ENDIF                                                                CDL081
                                                                                              CGL165
      ** Check if CGL165 is installed                                                         CGL165
     C                   EVAL      CGL165 = 'N'                                               CGL165
     C                   CALL      'AOSARDR0'                                                 CGL165
     C                   PARM      *BLANKS       PRTCD                                        CGL165
     C                   PARM      '*VERIFY'     POPTN                                        CGL165
     C                   PARM      'CGL165'      PSARD                                        CGL165
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL165
                                                                                              CGL165
     C                   IF        PRTCD = *BLANKS                                            CGL165
     C                   EVAL      CGL165 = 'Y'                                               CGL165
     C                   ENDIF                                                                CGL165
                                                                                              CDL081
                                                                                              243842
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
