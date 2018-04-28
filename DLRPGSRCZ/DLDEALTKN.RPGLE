     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Deal Take-on Module')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDEALTKN - Take-on tax calculation on deposit deals         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CER070             Date 25Nov14               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26839           Date 05Jan10               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23325           Date 01Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG22911           Date 17Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER034A            Date 19May08               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16152A          Date 07Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CGL035             Date 01Mar05               *
      *                 236453             Date 26Sep05               *
      *                 236446             Date 11Oct05               *
      *                 236064             Date 14Sep05               *
      *                 235320             Date 05Aug05               *
      *                 235045  *CREATE    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26839 - JA1_Threshold limit of the main joint customer was*
      *             utilized by the member                            *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23325 - Enquiries have been changed only to show the local*
      *             tax that has been calculated for residents where a*
      *             threshold method is used. This is because we      *
      *             cannot predict how much the tax will be in the    *
      *             future as we do not know how much of the threshold*
      *             will have been used at that time.                 *
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
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16152A - Do not include reverse deal transactions during  *
      *              take-on                                          *
      *  CDL027A- Conversion of customer number to alpha.             *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  236453 - Historic interest process incorrect                 *
      *         - Change access object for customer to also consider  *
      *           'Closed' customer.                                  *
      *         - Setup Instrument Reference.                         *
      *         - Recalculate amounts of interest for Call Deposit    *
      *           ==> Based on PF/HISTSAA                             *
      *         - Don't Consider 'TD / FI'                            *
      *  236446 - Correction of TLIFIX/PASFIX                         *
      *           Set generation date to rund -1 to avoid all tax     *
      *           amounts calculated posted during next COB.          *
      *  236064 - Settlement method 03 does not have a customer       *
      *           so need to default the customer to deal customer    *
      *  235320 - Joint account holder field not set to blanks for    *
      *           non joint customers                                 *
      *  235045 - Calculate tax on deal for take-on                   *
      *                                                               *
      *****************************************************************
 
     FDEALSALL  IF   E           K DISK    PREFIX(D_)
     F                                     IGNORE(DEALSDBF)
     F*****                                IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(FXDEALP0)
     F                                     IGNORE(DLBHISD0)
     F******                               IGNORE(DLCHISD0)
     F                                     IGNORE(DLDHISD0)
     F                                     IGNORE(DLEHISD0)
     F                                     IGNORE(DLGHISD0)
 
     FSDJACCLB  IF   E           K DISK
 
      ** Tax Calculation Methods file
     FSDTXCML1  IF   E           K DISK    INFSR(*pssr)
                                                                                              236453
      ** Historic Deal Events                                                                 236453
     FHIST4     IF   E           K DISK    PREFIX(H_)                                         236453
 
      ** Customer Income File
     FSDCSINPD  O    E             DISK    INFSR(*pssr)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data Structure for Bank Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * External DS for Branch Details
 
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      * External DS for Location Details
 
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
      * External DS for Securities Clients
 
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      ** External DS for Additional Customer Details
 
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      ** External DS for Non Account Holder Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * Data Structure for Currency Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL035
      ** External DS for Customer
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     236453
 
      *                                                                                       CER048
      ** External DS for Sar Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
      *                                                                                     BUG22911
      ** Data area for Midas SD Tax Parameter File                                          BUG22911
     D SDTXPA        E DS                  EXTNAME(SDTXPAPD)                                BUG22911
      *                                                                                     BUG22911
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ZZBEG           S              5P 0
     D ZZBEG2          S              5P 0                                                    236453
     D IP1Date         S              5P 0                                                    236453
     D ZZEND           S              5P 0
     D @@IDays         S              5P 0
     D @@TDays         S              5P 0
 
     D @PCUST          S              6A
     D @PNAHO          S             10A
 
     D PCURR           S              3A
     D PDBaseKey       S             10A
     D PDBaseFil       S             10A
     D PReturn         S              7A
     D PJointAcNo      S              6A
     D PNAHRef         S             10A
     D PInvProp        S             10A
     D PBranch         S              3A
     D*PCustNum*       S              6S 0                                                   CSD027A
     D PCustNum        S              6A                                                     CSD027A
     D PCurrency       S              3A
     D PSetType        S              2S 0
     D*PSetAcc**       S             12A                                                      CGL035
     D PSetAcc         S             18A                                                      CGL035
     D PRetCode        S             10A
     D*PAccCode*       S              4S 0                                                    CGL035
     D PAccCode        S             10S 0                                                    CGL035
     D PAccSeq         S              2S 0
     D PMemosInd       S              1A
     D PPronoInd       S              1A
     D PModuleID       S              1A
     D PCustomer       S              6A
     D PCtryOfTax      S              2A
     D PCtryOfLoc      S              2A
     D PCustStat       S              5A
     D*PEUWTaxAcCd     S              4P 0                                                    CGL035
     D PEUWTaxAcCd     S             10P 0                                                    CGL035
     D PICStrDate      S              5P 0
     D PICEndDate      S              5P 0
     D PIntEfDat       S             15P 0
     D PIntAmt         S             15P 0
     D PJntAccMng      S              1A
     D POrigCcy        S              3A
     D POPTN           S              7A
     D PTaxAmt         S             15P 0
     D PTaxBasket      S              2A
     D PTaxCcy         S              3A
     D PTaxRateAB      S              6P 4
     D PTaxRatePd      S              6P 4
     D PTotalInt       S             15P 0
     D PTotalInt1      S             15P 0                                                    236453
     D PTotalInt2      S             15P 0                                                    236453
     D SavedAmnt       S             15P 0                                                    236453
     D*PTransRef       S             18A                                                      CGL035
     D PTransRef       S             24A                                                      CGL035
     D PTrnTypEnd      S              1A
     D PTSTNLU         S              5P 0
     D PRTCD           S              7A
 
     D WCustomer       S              6A
     D WCNCD           S              2A
     D WCOLC           S              2A
     D WCURRKEY        S                   LIKE(TSOCCY)
     D WDATEYYYY       S                   LIKE(TSIPDT)
     D WDealNo         S              6A
     D WEUTaxAmt       S             15P 0
     D WMMDD           S              4A
     D WMonth          S              2  0
     D WYear1          S              2A
     D WYear2          S              4A
     D WELGTx          S              1A                                                    BUG23325
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
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
     D ZZLCD           S              5P 0
     D ZZNCD           S              5P 0
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
     D ZADEC           S              1P 0
      *                                                                                       CER048
      ** New Variables                                                                        CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D PInth           S              1A                                                      CER048
     D*PStxb****       S              2P 0                                           CER048 BUG22911
     D*PStac****       S             10P 0                                           CER048 BUG22911
     D*PStrt****       S              6P 4                                           CER048 BUG22911
     D*PSttp****       S              1A                                             CER048 BUG22911
     D*PStxa****       S             15P 0                                           CER048 BUG22911
     D PSard           S              6A                                                      CER048
     D WSecTxAmt       S             15P 0                                                    CER048
 
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
 
     C     *LOVAL        SETLL     DEALSALL
 
     C                   DOW       *IN30 = '0'
     C                   READ      DEALSALL                               30
     C**********         IF        *IN30 = '0'                                             BUG16152A
      ** Don't process reversed deals                                                      BUG16152A
     C                   IF        *IN30 = '0' AND D_RECI <> 'R'                           BUG16152A
                                                                                              236453
      ** Don't consider 'TD / FI'                                                             236453
     C                   IF        D_DTYP = 'TD' AND D_DLST = 'FI'                            236453
     C                   ITER                                                                 236453
     C                   ENDIF                                                                236453
                                                                                              236453
     C                   IF        D_DTYP = 'IT'  OR D_DTYP = 'TD'
     C                             OR D_DTYP = 'CD' OR D_DTYP = 'DT'
     C                             OR D_DTYP = 'LT' OR D_DTYP = 'FT'
 
     C                   IF        D_POBR <> '   '
     C                   EVAL      PBranch = D_POBR
     C                   ELSE
     C                   EVAL      PBranch = D_BRCA
     C                   ENDIF
     C                   MOVE      D_CNUM        PCustomer
     C                   EVAL      PCurrency = D_CCY
     C                   EVAL      PSetType = D_PSTM
     C                   EVAL      PSetAcc = D_PONS
 
     C                   EVAL      WEUTaxAmt = *Zero
     C                   EVAL      WSecTxAmt = *ZEROS                                         CER048
     C                   EXSR      SRRtvEff
     C                   IF        ( D_MDAT >= EWEDT1  AND D_MDAT < BJRDNB )
     C                              OR ( D_SLID <> D_VDAT AND D_SLID <> 0
     C                                   AND D_SLID >= EWEDT1
     C                                   AND D_SLID < BJRDNB )
 
      ** Retrieve Interest Settlement Customer
 
     C                   EXSR      SRGetSetAc
 
     C                   MOVE      PCustNum      WCustomer
     C                   MOVE      D_DLNO        WDealNo
 
     C                   EXSR      SRInterest
     C                   EXSR      SRCal_Tax
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Return
 
     C                   SETON                                        LR
      *****************************************************************
      /EJECT
      *****************************************************************
      * 10.80.48.53- Retrieve Settlement Account
      *****************************************************************
     C     SRGetSetAc    BEGSR
      *
     C                   EVAL      PCustNum = D_CNUM
 
     C                   IF        PSetType <> 00
     C                   CALLB     'ZAGETSETAC'
 
      ** Outputs
     C                   PARM                    PRetCode
     C                   PARM                    PAccCode
     C                   PARM                    PAccSeq
     C                   PARM                    PMemosInd
     C                   PARM                    PPronoInd
 
      ** Input/Output
     C                   PARM                    PBranch
     C                   PARM                    PCustNum
     C                   PARM                    PCurrency
 
      ** Inputs
     C                   PARM                    PSetType
     C                   PARM                    PSetAcc
                                                                                              236064
     C*****PCustNum      IFEQ      0                                                  236064 CSD027A
     C     PCustNum      IFEQ      *BLANKS                                                   CSD027A
     C                   EVAL      PCustNum = D_CNUM                                          236064
     C                   ENDIF                                                                236064
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvEff - Retrieve Effective Date                            *
      *                                                               *
      *****************************************************************
     C     SRRtvEff      BEGSR
 
     C                   MOVEL     D_BRCA        @BRCH             3
     C**********         CALLB     'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCH
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL035
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL035
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = D_BRCA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     A8LCCD        @LCCD             3
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LCCD
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = A8LCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     *BLANK        @PKEY1           10
     C                   MOVEL     D_CNUM        @PKEY1
 
      ** Customer details
 
     C**********         CALL      'AOCUSTR0'                                                 236453
     C                   CALL      'AOCUSTR2'                                                 236453
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @PKEY1
     C                   PARM                    @PKYST            7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        236453
     C     SDCUST        PARM      SDCUST        DSLDY                                        236453
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C     BBCLST        ANDNE     'Y'                                                        236453
     C**********         EVAL      DBKEY = @PKYST                                             236453
     C                   EVAL      DBKEY = @PKEY1                                             236453
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Country of Tax
 
     C                   EVAL      WCNCD = DVCNCD
     C                   EVAL      WCOLC = BBCOLC
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT            2
     C                   PARM      WCOLC         @PCTRR            2
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
     C                   IF        @RTCD = '*NRF   '
 
     C                   EVAL      WCOLC = *BLANK
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCNCD         @PCTRT
     C                   PARM      WCOLC         @PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DBKEY = @PCTRT + ' ' + @PCTRR
     C                   EVAL      DBFILE = 'SDCTTXPD'
     C                   EVAL      DBASE = 6
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WELGTx = *BLANKS                                         BUG23325
      *                                                                                     BUG23325
      ** Check for type of Tax based on Residents and Non Residents                         BUG23325
      *                                                                                     BUG23325
     C                   IF        EWCTRT <> BBCOLC                                         BUG23325
      *                                                                                     BUG23325
      ** European Withholding Tax Type                                                      BUG23325
      *                                                                                     BUG23325
     C                   EVAL      WELGTx = 'E'                                             BUG23325
     C                   ELSEIF    EWCTRT = BBCOLC AND                                      BUG23325
     C                             EWTHMD = 'Y' AND                                         BUG23325
     C                             CER048 = 'Y'                                             BUG23325
      *                                                                                     BUG23325
      ** German Withholding Tax Type                                                        BUG23325
      *                                                                                     BUG23325
     C                   EVAL      WELGTx = 'G'                                             BUG23325
     C                   ELSEIF    EWCTRT = BBCOLC AND                                      BUG23325
     C                             EWTHMD = 'N' AND                                         BUG23325
     C                             CER048 = 'Y'                                             BUG23325
      *                                                                                     BUG23325
      ** Local Withholding Tax Type                                                         BUG23325
      *                                                                                     BUG23325
     C                   EVAL      WELGTx = 'L'                                             BUG23325
      *                                                                                     BUG23325
     C                   ENDIF                                                              BUG23325
      *                                                                                     BUG23325
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRInterest - Calculate Interest between  effective date and   *
      *              last interest payment date                       *
      *****************************************************************
     C     SRInterest    BEGSR
 
     C                   IF        D_VDAT > EWEDT1
     C                   EVAL      ZZBEG = D_VDAT
     C                   ELSE
     C                   EVAL      ZZBEG = EWEDT1
     C                   ENDIF
 
     C                   EVAL      ZZEND = 0
     C                   IF        D_SLID <> 0 AND D_SLID <> D_VDAT
     C                   EVAL      ZZEND = D_SLID
     C                   ENDIF
 
     C                   IF        ZZEND = 0 AND D_MDAT <> 0
     C                             OR ( D_MDAT > ZZEND AND D_MDAT >= EWEDT1
     C                                                 AND D_MDAT < BJRDNB )
     C                   EVAL      ZZEND = D_MDAT
     C                   ENDIF
 
     C                   IF        D_INTC = 'Y'
     C                   EVAL      PTotalInt = D_ICTD
     C                   ELSE
     C                   EVAL      PTotalInt = D_IPRD
     C                   ENDIF
 
     C                   IF        D_VDAT <> ZZBEG AND D_VDAT <> ZZEND
     C                   EVAL      @@IDays = ZZEND - ZZBEG
     C                   EVAL      @@TDays = ZZEND - D_VDAT
     C                   EVAL      PTotalInt = PTotalInt * @@IDays / @@TDays
     C                   ENDIF
                                                                                              236453
     C** Special processing for Call Deposit                                                  236453
     C                   If        D_DTYP = 'CD'                                - B1          236453
     C                   Eval      @@IDays = 0                                                236453
     C                   Eval      @@TDays = 0                                                236453
     C                   Eval      PTotalInt1 = 0                                             236453
     C                   Eval      PTotalInt2 = 0                                             236453
     C                   Eval      SavedAmnt = 0                                              236453
     C                   MOVEL     *BLANKS       EXIT              1                          236453
                                                                                              236453
     C** Retrieve all 'IP' related to that Deal                                               236453
     C     KHIST1        SETGT     HIST4                                                      236453
     C     KHIST2        READPE    HIST4                                  63                  236453
                                                                                              236453
     C** Do While not EOF                                                                     236453
     C     *IN63         DOWEQ     False                                        - B2          236453
                                                                                              236453
     C** If Event Date > Effective Date ==> Cumulate interest                                 236453
     C*****              If        H_RTYP = 'IP' AND H_EDAT > EWEDT1            - B3   236453 236453
     C                   If        H_RTYP = 'IP' AND H_EDAT >= EWEDT1           - B3          236453
     C                   Eval      PTotalInt1 = PTotalInt1 + H_EAMT                           236453
     C                   Eval      IP1Date = H_EDAT                                           236453
     C                   Eval      SavedAmnt = H_EAMT                                         236453
     C                   Endif                                                  - E3          236453
                                                                                              236453
     C** If before Effective Date ==> Substract last amount added to calculate %              236453
     C                   If        H_RTYP = 'IP' AND H_EDAT < EWEDT1            - B3          236453
     C                   Eval      Exit = 'Y'                                                 236453
     C                   Eval      PTotalInt1 = PTotalInt1 - SavedAmnt                        236453
     C                   If        PTotalInt1 < 0                                             236453
     C                   Eval      PTotalInt1 = 0                                             236453
     C                   Endif                                                                236453
     C                   Leave                                                                236453
     C                   Endif                                                  - E3          236453
                                                                                              236453
     C     KHIST2        READPE    HIST4                                  63                  236453
     C                   ENDDO                                                  - E2          236453
                                                                                              236453
     C** Recalculate first period of interest after Effective Date                            236453
     C** Add it to cumulated interest amounts                                                 236453
     C                   If        Exit = 'Y'                                   - B2          236453
     C                             And PTotalInt1 >= 0                                        236453
     C                   Eval      ZZBEG = EWEDT1                                             236453
     C                   Eval      ZZEND = IP1Date                                            236453
     C                   Eval      ZZBEG2 = H_EDAT                                            236453
     C                   Eval      @@TDays = ZZEND - ZZBEG2                                   236453
     C                   Eval      @@IDays = ZZEND - ZZBEG                                    236453
     C                   Eval      PTotalInt2 = SavedAmnt * @@IDays / @@TDays                 236453
     C                   Eval      PTotalInt = PTotalInt1 + PTotalInt2                        236453
     C                   Else                                                   - X2          236453
     C                   Eval      PTotalInt = PTotalInt1                                     236453
     C                   Endif                                                  - E2          236453
                                                                                              236453
     C                   ENDIF                                                  - E1          236453
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRCal_Tax - Calculate Tax for the Interest                    *
      *****************************************************************
     C     SRCal_Tax     BEGSR
 
      ** Calculate Withholding Tax
 
     C                   EXSR      SRCallZPI
 
     C                   SELECT
 
     C                   WHEN      PReturn = 'ERROR'
     C                   EVAL      DBASE = 103
     C                   EVAL      DBFILE = PDBaseFil
     C                   EVAL      DBKEY  = PDBaseKey
     C                   EXSR      *PSSR
 
     C                   WHEN      PReturn <> 'JOINT'
     C                   EVAL      WEUTaxAmt = PTaxAmt
     C                   EVAL      WSecTxAmt = PStxa                                          CER048
     C                   EVAL      PJointAcNo = *BLANKS
     C                   EVAL      PInvProp = *BLANKS
     C                   IF        PTaxCcy <> '   '
     C                   EXSR      SR_OutFile
     C                   ENDIF
 
     C                   WHEN      PReturn = 'JOINT'
 
      ** Process JOINT accounts
 
     C                   EXSR      SRProcJA
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCallZPI - Calculate EU Withhlding Tax for Private Individual
      *****************************************************************
     C     SRCallZPI     BEGSR
 
     C                   MOVE      *BLANKS       PJointAcNo                                   235320
     C                   MOVE      *BLANKS       PNAHRef                                      235320
     C                   MOVE      *BLANKS       PInvProp                                     235320
     C                   EVAL      PInth = *BLANKS                                          BUG23325
      *                                                                                     BUG23325
     C                   IF        CER048 = 'Y'                                             BUG23325
     C                   EVAL      PInth = D_TAXI                                           BUG23325
     C                   ENDIF                                                              BUG23325
                                                                                              235320
     C                   CALL      'ZATXCLPI'
 
      ** Input parameters
     C                   PARM      'D'           PModuleID
     C                   PARM      WDealNo       PTransRef
     C                   PARM      D_BRCA        PBranch
     C                   PARM      WCustomer     PCustomer
     C                   PARM                    PICStrDate
     C                   PARM                    PICEndDate
     C                   PARM                    PTotalInt
     C                   PARM      *ZERO         PTaxRateAB
     C                   PARM      D_CCY         POrigCcy
     C**********         PARM      'T'           PInth                               CER048 BUG23325
     C                   PARM                    PInth                                      BUG23325
 
      ** Output parameters
     C                   PARM                    PIntEfDat
     C                   PARM                    PTaxAmt
     C                   PARM                    PIntAmt
     C                   PARM                    PTaxCcy
     C                   PARM                    PCtryOfTax
     C                   PARM                    PTaxBasket
     C                   PARM                    PEUWTaxAcCd
     C                   PARM                    PCtryOfLoc
     C                   PARM                    PCustStat
     C                   PARM                    PTrnTypEnd
     C                   PARM                    PTaxRatePd
     C**********         PARM      *ZEROS        PStxb                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStac                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStrt                               CER048 BUG22911
     C**********         PARM      *BLANKS       PSttp                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStxa                               CER048 BUG22911
     C                   PARM                    PDBaseKey
     C                   PARM                    PDBaseFil
     C                   PARM                    PReturn
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCallZJA - Calculate EU Withhlding Tax for Joint Account
      *****************************************************************
     C     SRCallZJA     BEGSR
 
     C                   MOVE      JCCUST        PCustomer
     C                   CALL      'ZATXCLJA'
 
      ** Input parameters
     C                   PARM      'D'           PModuleID
     C                   PARM      WDealNo       PTransRef
     C                   PARM      D_BRCA        PBranch
     C                   PARM      WCustomer     PJointAcNo
     C                   PARM                    PCustomer
     C                   PARM      JCNAHO        PNAHRef
     C                   PARM      JCINVP        PInvProp
     C                   PARM      JCPAHT        PPrmActInd        1                        BUG26839
     C                   PARM                    PICStrDate
     C                   PARM                    PICEndDate
     C                   PARM                    PTotalInt
     C                   PARM      *ZERO         PTaxRateAB
     C                   PARM      D_CCY         POrigCcy
     C**********         PARM      'T'           PInth                               CER048 BUG23325
     C                   PARM                    PInth                                      BUG23325
 
      ** Output parameters
     C                   PARM                    PIntEfDat
     C                   PARM                    PTaxAmt
     C                   PARM                    PIntAmt
     C                   PARM                    PTaxCcy
     C                   PARM                    PCtryOfTax
     C                   PARM                    PTaxBasket
     C                   PARM                    PEUWTaxAcCd
     C                   PARM                    PCtryOfLoc
     C                   PARM                    PCustStat
     C                   PARM                    PTrnTypEnd
     C                   PARM                    PTaxRatePd
     C                   PARM                    PJntAccMng
     C**********         PARM      *ZEROS        PStxb                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStac                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStrt                               CER048 BUG22911
     C**********         PARM      *BLANKS       PSttp                               CER048 BUG22911
     C**********         PARM      *ZEROS        PStxa                               CER048 BUG22911
     C                   PARM                    PDBaseKey
     C                   PARM                    PDBaseFil
     C                   PARM                    PReturn
     C     SDTXPA        PARM      SDTXPA        DSSDY                                      BUG22911
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProcJA - Process Joint Accounts
      *****************************************************************
     C     SRProcJA      BEGSR
 
     C     WCustomer     SETLL     SDJACCLB
     C     WCustomer     READE     SDJACCLB                               21
 
     C                   DOW       *IN21 = *OFF
 
     C                   EXSR      SRCallZJA
 
     C                   IF        PReturn = 'ERROR'
     C                   EVAL      DBASE = 104
     C                   EVAL      DBFILE = PDBaseFil
     C                   EVAL      DBKEY  = PDBaseKey
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PCustStat = 'TAXAB'
 
     C                   IF        PTaxCcy <> '   '
     C                   EXSR      SR_OutFile
     C                   ENDIF
 
     C                   EVAL      WEUTaxAmt = WEUTaxAmt + PTaxAmt
     C                   EVAL      WSecTxAmt = WSecTxAmt + PStxa                              CER048
 
     C                   ENDIF
 
     C                   IF        PReturn = 'NOTAX'
     C                             OR PReturn = 'TAXAB'
     C     WCustomer     READE     SDJACCLB                               21
     C                   ENDIF
 
     C                   IF        PReturn = 'LAST'
     C                   MOVE      *ON           *IN21
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SR_OutFile - Output result file                               *
      *                                                               *
      *****************************************************************
 
     C     SR_OutFile    BEGSR
 
      ** Initialize fields of PF/SDCSINPD
 
     C                   EXSR      SRInitFields
 
      ** Tax calculation Date
 
     C**********         EVAL      TSRDNB = BJRDNB                                            236446
     C                   EVAL      TSRDNB = BJRDNB - 1                                        236446
     C                   EVAL      TSEDAT = ZZEND
 
      ** Tax year and month
 
     C                   EVAL      ZDAYNO = ZZEND
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
 
     C                   EVAL      TSCTRT = PCtryOfTax
     C                   EVAL      TSBRCA = D_BRCA
     C                   MOVEL     PJointAcNo    TSJOIN
     C                   MOVE      PCustomer     TSCUST
     C                   EVAL      TSNAHO = PNAHRef
     C                   EVAL      TSINVP = PInvProp
     C                   EVAL      TSRCTR = PCtryOfLoc
 
      ** Customer Status
 
     C                   SELECT
     C     PCustStat     WHENEQ    'DISCL'
     C                   EVAL      TSSTAT = 'D'
     C     PCustStat     WHENEQ    'SELF'
     C                   EVAL      TSSTAT = 'S'
     C     PCustStat     WHENEQ    'TAXAB'
     C                   EVAL      TSSTAT = 'T'
     C                   ENDSL
 
     C     PNAHRef       IFNE      *BLANK
 
      ** Retrieve non account holder details
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PNAHRef       @PNAHO
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
     C     PCustomer     IFNE      *BLANK
 
      ** Retrieve additional customer details.
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCustomer     @PCUST
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
     C                   PARM                    ZZEND
     C                   PARM                    WDATEYYYY
     C                   PARM                    RetCodeIn
     C                   EVAL      TSIPDT = WDATEYYYY
 
      ** Tax basket
      ** Eu withholding tax code
 
     C                   MOVEL     PTaxBasket    TSTXBS
     C                   EVAL      TSWTAC = PEUWTaxAcCd
      *                                                                                       CER048
      ** Secondary Tax basket                                                                 CER048
      ** Secondary tax A/c code                                                               CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
      *                                                                                       CER048
     C                   EVAL      TSSTAC = PStac                                             CER048
     C                   EVAL      TSPTHU = *ZEROS                                            CER048
     C                   MOVEL     PStxb         TSSTXB                                       CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
      ** Original currency code
 
     C                   EVAL      TSOCCY = D_CCY
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
 
     C                   EVAL      TSSCCY = D_CCY
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
 
     C                   EVAL      TSTXCY = PTaxCcy
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
 
     C                   EVAL      TSXROS = 1
 
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
     C                   EVAL      TSOSMD = 'M'
     C                   EVAL      TSSTMD = ZMDIX
 
      ** Module identifier
 
     C                   EVAL      TSMODI = 'D'
 
      ** Deal Type/Trade type
      ** Deal sub-type/trade sub-type
      ** Deal number/trade number
 
     C                   EVAL      TSTRTP = D_DTYP
     C                   EVAL      TSTRST = D_DLST
     C                   MOVEL     D_DLNO        TSDLLN
      *                                                                                       236453
      ** Instrument Reference                                                                 236453
     C                   MOVEL     D_DLNO        AADLNO            6                          236453
     C                   MOVEL     'Deposit '    WWRK1            12                          236453
     C                   MOVE      'No. '        WWRK1                                        236453
     C     WWRK1         CAT       AADLNO        WWRK2            18                          236453
     C                   MOVEL     WWRK2         TSINST                                       236453
 
      ** Account code
      ** Account sequence
      ** IBAN number
 
     C                   EVAL      TSACOD = 0
     C                   EVAL      TSACSQ = 0
     C                   EVAL      TSIBAN = *BLANK
 
      ** Principal amount in original currency
      ** Gross interest amount in original currency
 
     C                   EVAL      TSPAMT = D_PCPL
     C                   EVAL      TSGINT = PIntAmt
 
      ** Tax rate
      ** Tax deducted at source in original currency
      *                                                                                       CER048
      ** Secondary Tax rate                                                                   CER048
      ** Secondary Tax deducted at source in original currency                                CER048
      *                                                                                       CER048
 
     C     TSSTAT        IFEQ      'T'
     C                   EVAL      TSTXRT = PTaxRatePd
     C                   EVAL      TSTXSR = PTaxAmt
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
     C**********         EVAL      TSSTRA = PStrt                                    CER048 BUG22911
     C                   EVAL      TSSTRA = PSttr                                           BUG22911
     C                   EVAL      TSSTDO = PStxa                                             CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF
 
      ** Net interest amount in original ccy
 
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
     C                   EVAL      TSNINT = TSGINT - TSTXSR - TSSTDO                          CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      TSNINT = TSGINT - TSTXSR
     C                   ENDIF                                                                CER048
 
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
     C                   EVAL      TSGINS = PIntAmt
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      PIntAmt       ZAMTCI
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
     C                   EVAL      TSTXSS = PTaxAmt
     C                   ELSE
     C                   CALLB     'ZCONV'
     C                   PARM      PTaxAmt       ZAMTCI
     C                   PARM      TSXROS        ZEXCH
     C                   PARM      TSOSMD        ZMD
     C                   PARM      TSOCCY        ZCCYI
     C                   PARM      TSSCCY        ZCCYO
     C                   PARM      TSOCDP        ZCDPI
     C                   PARM      TSSCDP        ZCDPO
     C                   PARM      *ZERO         ZAMTCO
     C                   EVAL      TSTXSS = ZAMTCO
     C                   ENDIF
      *                                                                                       CER048
      ** Secondary Tax deducted at source in settlement currency                              CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
      *                                                                                       CER048
     C                   IF        TSOCCY = TSSCCY                                            CER048
     C                   EVAL      TSSTDS = PStxa                                             CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   CALLB     'ZCONV'                                                    CER048
     C                   PARM      PStxa         ZAMTCI                                       CER048
     C                   PARM      TSXROS        ZEXCH                                        CER048
     C                   PARM      TSOSMD        ZMD                                          CER048
     C                   PARM      TSOCCY        ZCCYI                                        CER048
     C                   PARM      TSSCCY        ZCCYO                                        CER048
     C                   PARM      TSOCDP        ZCDPI                                        CER048
     C                   PARM      TSSCDP        ZCDPO                                        CER048
     C                   PARM      *ZEROS        ZAMTCO                                       CER048
     C                   EVAL      TSSTDS = ZAMTCO                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
      ** Net interest amount in settlement currency
      ** Principal amount in tax currency
 
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
     C                   EVAL      TSNINS = TSGINS - TSTXSS - TSSTDS                          CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      TSNINS = TSGINS - TSTXSS
     C                   ENDIF                                                                CER048
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
      *                                                                                       CER048
      ** Secondary Tax deducted at source in Tax Currency                                     CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
      *                                                                                       CER048
     C                   IF        TSTXCY = TSSCCY                                            CER048
     C                   EVAL      TSSTDT = TSSTDS                                            CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   CALLB     'ZCONV'                                                    CER048
     C                   PARM      TSSTDS        ZAMTCI                                       CER048
     C                   PARM      TSXRST        ZEXCH                                        CER048
     C                   PARM      TSSTMD        ZMD                                          CER048
     C                   PARM      TSSCCY        ZCCYI                                        CER048
     C                   PARM      TSTXCY        ZCCYO                                        CER048
     C                   PARM      TSSCDP        ZCDPI                                        CER048
     C                   PARM      TSTCDP        ZCDPO                                        CER048
     C                   PARM      *ZEROS        ZAMTCO                                       CER048
     C                   EVAL      TSSTDT = ZAMTCO                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
      ** Net interest amount in tax currency
 
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
     C                   EVAL      TSNINS = TSGINC - TSTXSC - TSSTDT                          CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      TSNINC = TSGINC - TSTXSC
     C                   ENDIF                                                                CER048
 
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
      *                                                                                       CER048
      ** Secondary Tax deducted at source in Base Currency                                    CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
      *                                                                                       CER048
     C                   IF        BJCYCD = TSSCCY                                            CER048
     C                   EVAL      TSSTDB = TSSTDT                                            CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   CALLB     'ZCONV'                                                    CER048
     C                   PARM      TSSTDT        ZAMTCI                                       CER048
     C                   PARM      TSSCSR        ZEXCH                                        CER048
     C                   PARM      TSSTMD        ZMD                                          CER048
     C                   PARM      TSSCCY        ZCCYI                                        CER048
     C                   PARM      BJCYCD        ZCCYO                                        CER048
     C                   PARM      TSSCDP        ZCDPI                                        CER048
     C                   PARM      A6NBDP        ZCDPO                                        CER048
     C                   PARM      *ZEROS        ZAMTCO                                       CER048
     C                   EVAL      TSSTDB = ZAMTCO                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
      ** Net interest amount in base currency
 
     C                   IF        CER048 = 'Y'                                               CER048
     C                             AND WELGTx <> 'E'                                        BUG23325
     C                   EVAL      TSNINB = TSGINB - TSTXSB - TSSTDB                          CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      TSNINB = TSGINB - TSTXSB
     C                   ENDIF                                                                CER048
 
      ** Customer income processed
 
     C                   EVAL      TSINPR = 'N'
 
      ** Get transaction no of last update, one for every trade number
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PTSTNLU
 
     C                   EVAL      TSTNLU = PTSTNLU
 
     C                   WRITE     SDCSIND0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInitFields - Initialise PF/SDCSINPD                         *
      *****************************************************************
     C     SRInitFields  BEGSR
 
     C                   EVAL      TSTAXY = 0
     C                   EVAL      TSTAXM = 0
     C**********         EVAL      TSJOIN = 0                                                CSD027A
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
     C                   EVAL      TSSTXB = *ZEROS                                            CER048
     C                   EVAL      TSSTAC = *ZEROS                                            CER048
     C                   EVAL      TSSTRA = *ZEROS                                            CER048
     C                   EVAL      TSSTDO = *ZEROS                                            CER048
     C                   EVAL      TSSTDS = *ZEROS                                            CER048
     C                   EVAL      TSSTDT = *ZEROS                                            CER048
     C                   EVAL      TSSTDB = *ZEROS                                            CER048
 
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
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '1'           DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                                       CER048
      ** Access SAR details file to determine if CER048 is installed                          CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*VERIFY'     POPTN                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database error                                                                       CER048
      *                                                                                       CER048
     C                   IF        (PRTCD <> *BLANKS) AND                                     CER048
     C                             (PRTCD <> '*NRF')                                          CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 916                                                CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRTCD = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *
      ** Define key list for file
     C     KHIST1        Klist                                                                236453
     C                   Kfld                    D_CNUM                                       236453
     C                   Kfld                    D_DLNO                                       236453
     C                   Kfld                    BJRDNB                                       236453
                                                                                              236453
     C     KHIST2        Klist                                                                236453
     C                   Kfld                    D_CNUM                                       236453
     C                   Kfld                    D_DLNO                                       236453
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
