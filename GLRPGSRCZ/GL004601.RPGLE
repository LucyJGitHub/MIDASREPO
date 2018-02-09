     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Generated Entries Account Transfer')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004601 - Midas GL Generated Entries Account Transfer       *
      *                                                               *
      *  Function:  This program generates postings for Account       *
      *             Transfers during Close of Business                *
      *                                                               *
      *  Called By: GLC004601 - Generation of Account Transfer Payment*
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034016           Date 16Jun15               *
      *                 MD029951           Date 25Feb15               *
      *                 AR1075388          Date 21Nov13               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR1014090          Date 11Feb13               *
      *                 AR1009263          Date 25Jul12               *
      *                 AR958673           Date 24Apr11               *
      *                 CRE072             Date 30Jun11               *
      *                 AR845655           Date 06Oct11               *
      *                 CRE075             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG28036           Date 16Aug10               *
      *                 BUG27831B          Date 11Aug10               *
      *                 BUG27825A          Date 08Jul10               *
      *                 BUG27831A          Date 03Aug10               *
      *                 BUG27825           Date 22Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27394           Date 26Apr10               *
      *                 BUG27561           Date 27Apr10               *
      *                 BUG27299           Date 19Apr10               *
      *                 BUG27389           Date 05Apr10               *
      *                 CAP204A            Date 22Mar10               *
      *                 BUG27212           Date 16Mar10               *
      *                 BUG27201A          Date 15Mar10               *
      *                 BUG27201           Date 11Mar10               *
      *                 BUG27196           Date 11Mar10               *
      *                 BUG27195           Date 10Mar10               *
      *                 CAP204 *CREATE     Date 05Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034016 - Same Customer Name in the DR/CR transaction       *
      *  MD029951 - Account Transfer - Narratives wrong on file       *
      *             APOSTPD. Transaction Reference value should be    *
      *             replaced by Statement Narrative if available.     *
      *           - Applied for MD032180.                             *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR1014090 - GLC30 failed due to FOOB in GETXPD               *
      *              (Child:AR1014091)                                *
      *  AR1009263 - Database error occured due to accessing ICD of   *
      *              Analytical Accounting. Amended to only to do so  *
      *              when Analytical Accounting is switched ON. Used  *
      *              BGN0ST instead of BGNOST as basis for setting    *
      *              default value profit centre. (Child: AR1009264)  *
      *              Same code as AR958673 + check on BGN0ST instead  *
      *              BGNOST. Keep code of AR958673 and refer to       *
      *              AR1009263 for check on BGN0ST                    *
      *  AR958673 - Database error in GLC004603 00001 (Child:AR958677)*
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *  AR845655 - Update datatype of Paying Bank to Alphanumeric    *
      *             (Recompile)                                       *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *  BUG28036 - Only send forward transfers with value date       *
      *             within the period of balances                     *
      *  BUG27831B - COB performance issue                            *
      *  BUG27825A- Use "ADD" operation code for records and postings *
      *             counter("ADD" sets value to zero automatically    *
      *             when value exceeds 5 digits)                      *
      *  BUG27831A - Forward Account Transfer Processing              *
      *  BUG27825 - Reset trailer counter for more than 99997 records *
      *  BUG27394 - Add new field Record ID to allow logical deletion *
      *             of this file (Recompile)                          *
      *  BUG27561 - GLC004601 00001 failed                            *
      *  BUG27299 - Account is not in transaction branch should not   *
      *             be in the failed account transfers list           *
      *  BUG27389 - Executed account transfers should be displayed    *
      *             in the listview                                   *
      *  CAP204A - CR027 Remove cheque postings                       *
      *  BUG27212 - Future valued transaction postings are missing    *
      *             after COB                                         *
      *  BUG27201A - Imbalance in postings still occurs               *
      *  BUG27201 - Imbalance in postings of cross currency account   *
      *             transfers with net fees                           *
      *  BUG27196 - Remove hash total calculation of GLATMIPD         *
      *  BUG27195 - Some branch fields are not populated              *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    nn         Function of Indicator                           *
      *    20         Check for rejection code '02' or '12'           *
      *    21         Check for rejection code '01' or '11'           *
      *    30         Print exchange rate                             *
      *    40         Check for difference                            *
      *    91         Checks for carry                                *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRGenPost - Generate postings for account transfer            *
      * SRTranPost - Generate transaction postings                    *
      * SRCmnPost - Clear GETXPD fields and setup common entries      *
      * SRCrosCur - Generate additional postings for cross-currency   *
      * SRIntBrch - Generate additional postings for inter-branch     *
      * SRFees - Handle fee details                                   *
      * SRFeePost - Generate fee postings                             *
      **SRChqPost*-*Generate*cheque*postings***************************                      CAP204A
      * SRWrtPost - Write postings to APOSTPDF                        *
      * SRWrtHist - Write account transfer to history file            *
      * SRZZAdd - Calculate hash fields                               *
      * SROpenPrtf - Open prtf if the prtf is not open                *
      * SRBreakBrc - Branch break in report                           *
      * SRPrntTrl - Write branch trailer in report                    *
      * SRFrmtDetl - Setup report details                             *
      * SRPrntDetl - Print report details                             *
      * SRFrmtDetl2 - Format fee or exchange rate report details      *
      * SRPrntDetl2 - Print fee or exchange rate details              *
      * SRAudit - Write audit report                                  *
      * SROverflow - Write header if overflow                         *
      * SRGetCust - Gets customer details.                            *
      * SRGetBrch - Access Branch details                             *
      * SRGetCcy - Access Currency details                            *
      * SRGetATST - Access A/C Transfer Type/Subtype details          *
      * SRGetAcod - Access A/C Code Details                           *
      * SRGetAcct - Access Account Details                            *
      * SRConvAmt - Convert amount to base currency                   *
      * SRCrosCnv - Cross currency conversion                         *
      * SRZEdit - Format amount                                       *
      **SRChkSusp*-*Check*if*account*is*a*suspense*account*************                    BUG27831A
      * SRChkMvt  - check movement                                    *                       CRE072
      * SRFindMvt - find movement                                     *                       CRE072
      * SRFndGLAC - find movement in GLACPHL3                         *                       CRE072
      * SRFndAPOS - find movement in GLPOSTL6                         *                       CRE072
      * SRFndRSAC - find movement in ZTACMTL0                         *                       CRE072
      * SRKeepMvt - keep movement                                     *                       CRE072
      * SRGetGLAC - get movement in GLACPHL3                          *                       CRE072
      * SRGetAPOS - get movement in GLPOSTL6                          *                       CRE072
      * SRGetRSAC - get movement in ZTACMTL0                          *                       CRE072
      * SRFlgFnd  - Flag movement as found                            *                       CRE072
      * SRFlgPrn  - Flag movement as printed                          *                       CRE072
      * SRSetPHKy - Set GLACPHL3 key fileds                           *                       CRE072
      * SRSetPDKy - Set GLPOSTL6 key fileds                           *                       CRE072
      * SRSetZTKy - Set ZTACMTL0 key fileds                           *                       CRE072
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Midas GL Account Transfer Manual Input File
     FGLATMIL0  UF   E           K DISK    INFSR(*PSSR)
 
      ***Midas*GL*Account*Transfer*Manual*Input*File*-*Trailer                              BUG27196
     F***GLATTRPD  IF   E             DISK    INFSR(*PSSR)                                  BUG27196
 
      ***Midas*GL*Failed*Account*Transfer*Extract*File*****************                     BUG28036
     F***GLFLTRL1  IF   E           K DISK    INFSR(*PSSR)                                  BUG28036
                                                                                           BUG27831A
      ** Retail Account Balance Check ICD File                                             BUG27831A
     FSDABCIPD  IF   E             DISK    INFSR(*PSSR)                                    BUG27831A
                                                                                            BUG28036
      ** Midas GL Account Extension File                                                    BUG28036
     FGLACNTL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG28036
                                                                                              CRE072
      ** Midas GL Account Movements sel. TTYP='ZT'                                            CRE072
     FZTACMTL0  IF   E           K DISK    INFSR(*PSSR)                                       CRE072
     F                                     PREFIX(ZT_)                                        CRE072
                                                                                              CRE072
      ** Midas GL Account Postings Detail sel SPOS='GE-TX'                                    CRE072
     FGLPOSTL6  IF   E           K DISK    INFSR(*PSSR)                                       CRE072
     F                                     PREFIX(PD_)                                        CRE072
     F                                     RENAME(APOSTPDF:GLPOSTD0)                          CRE072
                                                                                              CRE072
      ** Midas GL Accounts Post History sel SPOS='GE-TX'                                      CRE072
     FGLACPHL3  IF   E           K DISK    INFSR(*PSSR)                                       CRE072
     F                                     PREFIX(PH_)                                        CRE072
     F                                     RENAME(APOSTPDF:GLACPHD0)                          CRE072
                                                                                              CRE072
      ** Midas GL Passbook Unprinted Account Movements                                        CRE072
     FGLPUAMPD  O    E             DISK    INFSR(*PSSR)                                       CRE072
     F                                     PREFIX(Pb_)                                        CRE072
     F                                     RENAME(APOSTPDF:GLPUAMD0)                          CRE072
 
      ** Midas GL Generated Entries Account Transfer - Header
     FGETXHH    O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(H_)
 
      ** Midas GL Generated Entries Account Transfer - Detail
     FGETXPD    O    E             DISK    INFSR(*PSSR)
 
      ** Midas GL Generated Entries Account Transfer - Trailer
     FGETXZZ    O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(T_)
 
      ** Midas GL Account Transfer Manual Input File - History
     FGLHATMPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLATMID0:GLATMID1)
     F                                     PREFIX(H_)                                       BUG27299
 
      ** Midas GL Forward Transfer list                                                     BUG28036
     FGLFTRVPD  O    E             DISK    RENAME(GLFTRVD0:GLFTRVF) INFSR(*PSSR)            BUG28036
     F                                     PREFIX(O_)                                       BUG28036
                                                                                            BUG28036
      ** Midas GL Generated Entries Account Transfer - Detail
     FGL004601P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas GL Generated Entries Account Transfer - Audit
     FGL004601AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for Trading ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D   QQACCD2     E                     EXTFLD(QQACCD)
 
      ** DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D   QQDFAC2     E                     EXTFLD(QQDFAC)
 
      ** External DS for PCA Details
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
 
      ** External DS for Account Codes
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D                                     PREFIX(A_)
 
      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC)
 
      ** External DS for A/C Transfer Type/Subtype
     D SDATST        E DS                  EXTNAME(SDATSTPD)
                                                                                              CRE072
      ** External DS for SAR Details                                                          CRE072
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE072
                                                                                              CRE072
      ** DS for Midas GL Generated Entries Account Transfer - Detail                          CRE072
     D SDGETX        E DS                  EXTNAME(GETXPD)                                    CRE072
     D   QQZZ019     E                     EXTFLD(ZZ019)                                      CRE072
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Long DS for access programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS for Main Branch Details
     D MNBRCH        E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(M:1)
 
      ** DS for Debit Branch Details
     D DBBRCH        E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(D:1)
 
      ** DS for Credit Branch Details
     D CRBRCH        E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(C:1)
 
      ** DS for Booking Branch Details
     D BKBRCH        E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(B:1)
 
      ***DS*for*Cheque*Branch*Details                                                        CAP204A
     D***CQBRCH*       E DS                  EXTNAME(SDBRCHPD)                               CAP204A
     D**********                           PREFIX(T:1)                                       CAP204A
 
      ** DS for Account Transfer File
     D GLATMI        E DS                  EXTNAME(GLATMIPD)
 
      ** DS for Account Transfer History File
     D GLHATM        E DS                  EXTNAME(GLHATMPD)
     D                                     PREFIX(H_)
 
      ** DS for GLPOSTL6                                                                      CRE072
     D GLPOST        E DS                  EXTNAME(APOSTPD)                                   CRE072
     D                                     PREFIX(PD_)                                        CRE072
                                                                                              CRE072
      ** DS for GLACPHL3                                                                      CRE072
     D GLACPH        E DS                  EXTNAME(GLACPHPD)                                  CRE072
     D                                     PREFIX(PH_)                                        CRE072
                                                                                              CRE072
      ** DS for GLPUAML0                                                                      CRE072
     D GLPUAM        E DS                  EXTNAME(GLPUAMPD)                                  CRE072
     D                                     PREFIX(Pb_)                                        CRE072
                                                                                              CRE072
      **  External data structures for Forward Transfer List                                BUG28036
     D GLFTRV        E DS                  EXTNAME(GLFTRVPD:*OUTPUT)                        BUG28036
                                                                                            BUG28036
      **  External DS for Fee Branch                                                          CRE067
     D FEEBRCH       E DS                  EXTNAME(SDBRCHPD)                                  CRE067
     D                                     PREFIX(F:1)                                        CRE067
                                                                                              CRE067
      ** File Information Data Structure for GL004601P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for GL004601AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ***Array*containing*the*rejection*codes*of*GLFLTRPD**************                     BUG28036
     D*REJCDE***       S              2A   DIM(15)                                          BUG28036
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZEDIT
     D PZField         S             16A
     D PZDec           S              1  0
 
      ** Parameters for ZCONVZ1 and ZCCYCN
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
 
      ** Parameters for ZSFILE
     D PSeq            S              5A
     D SEnty           S              3A
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1A
 
      ** Parameters for access object programs
     D PRetCode        S              7A
     D POption         S              7A
     D PCust           S             10A
     D PBranch         S              3A
     D PCcy            S              3A
     D PKyst           S              7A
     D PTrty           S              2A
     D PTrst           S              5A
     D PAcod           S             10A
     D PCnum           S              6A
     D PAccy           S              3A
     D PAcsq           S              2A
     D PBrca           S              3A
     D PRetl           S             10A
     D PSARD           S              6A                                                      CRE072
 
      ** Other fields used
     D WkCtrDt         S              5  0
     D WRun            S              1A
     D WIdx            S              2  0                                                  BUG27299
     D WRejCde         S              2A                                                    BUG27299
     D WHasFees        S              1A   INZ('N')
     D WAcctPrnt       S              1A   INZ('N')
     D WFirst          S              1A   INZ('N')
     D WNoRec          S              5  0 INZ(0)
     D***WTotRec         S              5  0 INZ(0)                                         BUG27196
     D WTotFees        S             15  0 INZ(0)                                           BUG27201
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WSuspnse        S              1A
     D WSuspAct        S              1A
     D WBKBrch         S              3A
     D WDRBrch         S              3A
     D WCRBrch         S              3A
     D***WCQBrch         S              3A                                                   CAP204A
     D WPayCust        S              6A
     D WPayBrch        S              3A
     D WPayCcy         S              3A
     D WFeeNo          S              1A
     D***WChqAmt         S                   LIKE(R1DAMT)                                    CAP204A
     D WBNbdp          S                   LIKE(A6NBDP)
     D WBCcyEq         S                   LIKE(A6SPAE)
     D WFeeAmt         S                   LIKE(R1F1AM)
     D WFeeCcy         S                   LIKE(R1F1CU)
     D WFeeEqv         S                   LIKE(R1F1CE)
     D WFeeXrt         S                   LIKE(R1F1EX)
     D WFeeAcd         S                   LIKE(ATF1CD)
     D*WkProc4**       S              1A                                          BUG27831A BUG28036
     D WkShdwPost      S              1A   INZ('N')                                         BUG28036
     D WkEndPrd        S                   LIKE(R1EXDT)                                     BUG28036
     D WkDateIn        S                   LIKE(R1EXDT)                                     BUG28036
     D WkCtr           S              2  0                                                  BUG28036
     D WkFwDay         S              2  0 INZ(1)                                           BUG28036
     D*ZNRDYS***       S              2  0 INZ(1)                                           BUG28036
 
      ** Cross Currency work fields
     D WPosFlag        S              1A
     D WDCcy           S              3A
     D WCCcy           S              3A
     D WDDrCr          S              1  0
     D WCDrCr          S              1  0
     D WCAsoc          S             10A
     D DrAmt           S                   LIKE(R1DAMT)
     D CrAmt           S                   LIKE(R1CAMT)
     D WDAmt           S                   LIKE(R1DAMT)
     D WCAmt           S                   LIKE(R1CAMT)
     D WDNbdp          S                   LIKE(A6NBDP)
     D WCNbdp          S                   LIKE(A6NBDP)
     D WDRate          S                   LIKE(A6SPRT)
     D WCRate          S                   LIKE(A6SPRT)
     D WDMdin          S                   LIKE(A6MDIN)
     D WCMdin          S                   LIKE(A6MDIN)
     D WDSpae          S                   LIKE(A6SPAE)
     D WCSpae          S                   LIKE(A6SPAE)
 
      ** Inter-branch work fields
     D WPosFlag2       S              1A
     D WCNUM1          S              6A
     D WCNUM2          S              6A
     D WBRCA1          S              3A
     D WBRCA2          S              3A
     D WCCY1           S              3A
     D WCCY2           S              3A
     D WPSTA1          S                   LIKE(PSTA)
     D WDRCR1          S              1  0
     D WACOD1          S             10A
     D WACOD2          S             10A
     D WACOD3          S             10A
     D WACOD4          S             10A
 
      ** Hash totals calculation
     D ZZAMT           S             15  3 INZ(0)
     D ZZAMT2          S             15  3 INZ(0)                                          AR1014090
     D WCHMT           S             18                                                    AR1014090
     D ZZAMTI          S             15  0 INZ(0)
     D ZZAMTD          S              3  0 INZ(0)
     D ZZTOTI          S             15  0 INZ(0)
     D ZZTOTD          S              3  0 INZ(0)
     D***ZZTOTI1         S             15  0 INZ(0)                                         BUG27196
     D***ZZTOTD1         S              3  0 INZ(0)                                         BUG27196
     D ZZTOTI2         S             15  0 INZ(0)
     D ZZTOTD2         S              3  0 INZ(0)
 
     D WFeeBrch        S              3A                                                      CRE067
     D WFeeCust        S              6A                                                      CRE067
     D WFeeSeq         S              2S 0                                                    CRE067
                                                                                              CRE072
      ** Passbook Printing work fields                                                        CRE072
     D WPbDrCr         S              1P 0                                                    CRE072
     D WPbLoc          S              4A                                                      CRE072
     D WPbDrFnd        S              1A                                                      CRE072
     D WPbDrPrn        S              1A                                                      CRE072
     D WPbDrLoc        S              4A                                                      CRE072
     D WPbCrFnd        S              1A                                                      CRE072
     D WPbCrPrn        S              1A                                                      CRE072
     D WPbCrLoc        S              4A                                                      CRE072
                                                                                              CRE072
      ** ZTACMTL0 key fields                                                                  CRE072
     D KZTCUSN         S              6A                                                      CRE072
     D KZTCCYD         S              3A                                                      CRE072
     D KZTASNC         S              2  0                                                    CRE072
     D KZTBRCA         S              3A                                                      CRE072
     D KZTDORC         S              1  0                                                    CRE072
     D KZTACDE         S             10  0                                                    CRE072
     D KZTOTR1         S             20A                                                      CRE072
                                                                                              CRE072
      ** GLPOSTL6 key fields                                                                  CRE072
     D KPDCNUM         S              6A                                                      CRE072
     D KPDCCY          S              3A                                                      CRE072
     D KPDACSQ         S              2  0                                                    CRE072
     D KPDDRCR         S              1  0                                                    CRE072
     D KPDBRCA         S              3A                                                      CRE072
     D KPDACOD         S             10  0                                                    CRE072
     D KPDOTRF         S             21A                                                      CRE072
                                                                                              CRE072
      ** GLACPHL3 key fields                                                                  CRE072
     D KPHCNUM         S              6A                                                      CRE072
     D KPHCCY          S              3A                                                      CRE072
     D KPHACSQ         S              2  0                                                    CRE072
     D KPHDRCR         S              1  0                                                    CRE072
     D KPHBRCA         S              3A                                                      CRE072
     D KPHACOD         S             10  0                                                    CRE072
     D KPHOTRF         S             21A                                                      CRE072
                                                                                              CRE072
      ** Switchable features                                                                  CRE072
     D CRE072          S              1A                                                      CRE072
                                                                                              CRE067
      ** Other variables                                                                    BUG28036
     D/COPY ZSRSRC,ZHOLILE                                                                  BUG28036
     D/COPY ZSRSRC,ZHOLELE                                                                  BUG28036
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
                                                                                           BUG27831A
      ** If both credit and debit processing type are 4, no forward                        BUG27831A
      ** transfers to be sent to MQ.                                                       BUG27831A
                                                                                           BUG27831A
     C**********         EVAL      WkProc4 = 'N'                                  BUG27831A BUG28036
     C                   IF        WMODE = 'N'                                             BUG27831A
     C                   READ      SDABCIPD                                                BUG27831A
     C**********         IF        ABTFDR = 4                                     BUG27831A BUG28036
     C**********                   AND ABTFCR = 4                                 BUG27831A BUG28036
     C**********         EVAL      WkProc4 = 'Y'                                  BUG27831A BUG28036
     C**********         ENDIF                                                    BUG27831A BUG28036
     C                   ENDIF                                                             BUG27831A
      *
      ** Read through Account Transfer files
      *
     C     *LOVAL        SETLL     GLATMIL0
     C                   READ      GLATMIL0
     C                   DOW       NOT(%EOF(GLATMIL0))
 
      ** Categorise Forward transfers.                                                      BUG28036
                                                                                            BUG28036
     C                   IF        WMODE = 'N' AND R1ABCF <> 'Y'                            BUG28036
     C                             AND R1RECI = 'D'                                         BUG28036
     C                   EXSR      SrProcFwdAT                                              BUG28036
     C                   ELSE                                                               BUG28036
     C                   EVAL      WkShdwPost = 'Y'                                         BUG28036
     C                   ENDIF                                                              BUG28036
                                                                                            BUG28036
     C**********         EVAL      WTotRec = WTotRec + 1                                    BUG27196
     C**********         EVAL      ZZAMT = (R1DAMT + R1CAMT + R1F1AM +                      BUG27196
     C**********                           R1F2AM + R1F3AM + R1F4AM +                       BUG27196
     C**********                           R1F5AM + R1F6AM) / 1000                          BUG27196
     C**********         EVAL      ZZTOTI = ZZTOTI1                                         BUG27196
     C**********         EVAL      ZZTOTD = ZZTOTD1                                         BUG27196
     C**********         EXSR      SRZZAdd                                                  BUG27196
     C**********         EVAL      ZZTOTI1 = ZZTOTI                                         BUG27196
     C**********         EVAL      ZZTOTD1 = ZZTOTD                                         BUG27196
 
      ** Check if account transfer is to execute today
      ** Generate postings
      ** If shadow posting are to be generated, execute                                     BUG27212
      ** forward valued account transfers                                                   BUG27212
 
     C                   IF        R1EXDT <= WkCtrDt AND R1RECI = 'D'
     C                             AND WMODE <> 'N'                                        BUG27831A
     C**********                   OR (R1EXDT >= WkCtrDt AND WMODE = 'N')          BUG27212 BUG27389
      *****************************************************************           BUG27831A BUG28036
      ***Note*that*when*WMODE*=*'N',*CoB*is*already*on*ICI.************           BUG27831A BUG28036
      ***BANK*details*were*already*updated*with*new*rundate*and*new****           BUG27831A BUG28036
      ***next*working*day**********************************************           BUG27831A BUG28036
      *****************************************************************           BUG27831A BUG28036
      ***Generate*forward*shadow*postings*for*the*following*live*records:         BUG27831A BUG28036
      ***1)*due*on*next*cob*run*but*processing*type*is*both*'4'********           BUG27831A BUG28036
      ***2)*due*on*next*cob*run*but*ABC*checking*already*performed*****           BUG27831A BUG28036
      ***3)*not*due*on*next*CoB*run************************************           BUG27831A BUG28036
      ***Records*that*will*not*fall*under*any*of*above*conditions*will*           BUG27831A BUG28036
      ***be*sent*out*for*validation*via*MQ*(GLC004604)*****************           BUG27831A BUG28036
      *****************************************************************           BUG27831A BUG28036
     C**********                   OR (R1EXDT <= WkCtrDt AND WMODE = 'N'          BUG27831A BUG28036
     C**********                   AND R1RECI = 'D' AND WkProc4 = 'Y')            BUG27831A BUG28036
      *****************************************************************           BUG27831A BUG28036
     C**********                   OR (R1EXDT <= WkCtrDt AND WMODE = 'N'          BUG27831A BUG28036
     C**********                   AND R1RECI = 'D' AND R1ABCF = 'Y' )            BUG27831A BUG28036
      *****************************************************************           BUG27831A BUG28036
     C**********                   OR (R1EXDT >  WkCtrDt AND WMODE = 'N'          BUG27831A BUG28036
     C**********                   OR (R1EXDT >= WkCtrDt AND WMODE = 'N'          BUG27389 BUG27831A
     C**********                   AND R1RECI = 'D')                               BUG27389 BUG28036
                                                                                            BUG28036
      ** When WMODE = 'N', forward transfers are being processed.                           BUG28036
                                                                                            BUG28036
     C                             OR R1RECI = 'D' AND WMODE = 'N'                          BUG28036
     C                             AND WkShdwPost = 'Y'                                     BUG28036
 
      ** Check if change in branch
 
     C                   IF        WBKBrch <> R1BRCA
 
      ** Perform initial print of header
 
     C                   IF        WFirst = 'N'
     C                   EXSR      SROpenPrtf
     C                   EVAL      RRBRCD = R1BRCA
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'Y'
 
      ** If not first time run, open a new printer
      ** file for change in branch
 
     C                   ELSE
     C                   EXSR      SRBreakBrc
     C                   ENDIF
 
      ** Retrieve booking branch details
 
     C                   EVAL      WBKBrch = R1BRCA
     C                   EVAL      PBranch = WBKBrch
     C                   EXSR      SRGetBrch
     C                   EVAL      BKBRCH = SDBRCH
     C                   ENDIF
 
     C**********         IF        WNoRec = 99997                                 BUG27825 BUG27825A
     C**********         Z-ADD     0             WNoRec                           BUG27825 BUG27825A
     C**********         ENDIF                                                    BUG27825 BUG27825A
     C**********         EVAL      WNoRec = WNoRec + 1                                     BUG27825A
     C                   ADD       1             WNoRec                                    BUG27825A
 
      ** Generate postings
 
     C                   EXSR      SRGenPost
 
      ** Write to historic file
 
     C     WMODE         IFEQ      'Y'
     C                   EXSR      SRWrtHist
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CRE072
      ** Check Reversed Account Transfer                                                      CRE072
      ** if unprinted account movements are needed to keep for Passbook printing              CRE072
      *                                                                                       CRE072
     C                   IF        R1RECI = 'R' AND                                           CRE072
     C                             CRE072 = 'Y'                                               CRE072
      *                                                                                       CRE072
      ** Check Movements of Debit account                                                     CRE072
      *                                                                                       CRE072
     C                   EVAL      DRCR = 0                                                   CRE072
     C                   EXSR      SRChkMvt                                                   CRE072
      *                                                                                       CRE072
      ** Check Movements of Credit account                                                    CRE072
      *                                                                                       CRE072
     C                   EVAL      DRCR = 1                                                   CRE072
     C                   EXSR      SRChkMvt                                                   CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
 
     C                   READ      GLATMIL0
     C                   ENDDO
 
      ** Print last trailer
 
     C                   IF        T_NORE1 <> 0                                             BUG27196
     C                   EXSR      SRPrntTrl
     C                   ENDIF                                                              BUG27196
 
      ** Write trailer file
 
     C                   EVAL      T_RECI = 'Z'
     C                   EVAL      T_NORE1 = T_NORE1 + 2
     C                   EVAL      T_HRWN = ZZTOTI2
     C                   EVAL      T_HRDC = ZZTOTD2
     C                   WRITE     APOSTZZF
 
      ** Print audit
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************                     BUG28036
      /EJECT                                                                                BUG28036
      *****************************************************************                     BUG28036
      *                                                               *                     BUG28036
      *  SrProcFwdAT - Categorise forward account transfer according  *                     BUG28036
      *                to their processing type and value date        *                     BUG28036
      *                                                               *                     BUG28036
      *****************************************************************                     BUG28036
     C     SrProcFwdAT   BEGSR                                                              BUG28036
                                                                                            BUG28036
     C                                                                                      BUG28036
     C     KyDrAc        CHAIN     GLACNTL3                                                 BUG28036
     C                   IF        NOT %FOUND(GLACNTL3)                                     BUG28036
     C     *LOCK         IN        LDA                                                      BUG28036
     C                   EVAL      DBFile = 'GLACNTQD'                                      BUG28036
     C                   MOVEL     R1DBRE        DBKey                                      BUG28036
     C                   EVAL      DBPgm = 'GL004601'                                       BUG28036
     C                   EVAL      DBase = 12                                               BUG28036
     C                   OUT       LDA                                                      BUG28036
     C                   EXSR      *PSSR                                                    BUG28036
     C                   ENDIF                                                              BUG28036
                                                                                            BUG28036
     C                   SELECT                                                             BUG28036
     C                   WHEN      F1IABC  <> 'Y'                                           BUG28036
     C                   EVAL      WkShdwPost = 'Y'                                         BUG28036
                                                                                            BUG28036
     C                   WHEN      ABTFDR  = 4                                              BUG28036
     C                   EVAL      WkShdwPost = 'Y'                                         BUG28036
                                                                                            BUG28036
     C                   WHEN      ABTFDR  = 3                                              BUG28036
     C                   IF        R1EXDT <= WkCtrDt                                        BUG28036
     C                   EVAL      WkShdwPost = 'N'                                         BUG28036
     C                   EXSR      SrWriteFTRV                                              BUG28036
     C                   ELSE                                                               BUG28036
     C                   EVAL      WkShdwPost = 'Y'                                         BUG28036
     C                   ENDIF                                                              BUG28036
                                                                                            BUG28036
     C                   OTHER                                                              BUG28036
     C                   EXSR      SrGetBalPrd                                              BUG28036
     C                   IF        R1DRVL <= WkEndPrd                                       BUG28036
     C                   EVAL      WkShdwPost = 'N'                                         BUG28036
     C                   EXSR      SrWriteFTRV                                              BUG28036
     C                   ELSE                                                               BUG28036
     C                   EVAL      WkShdwPost = 'Y'                                         BUG28036
     C                   ENDIF                                                              BUG28036
                                                                                            BUG28036
     C                   ENDSL                                                              BUG28036
                                                                                            BUG28036
     C                   ENDSR                                                              BUG28036
      *****************************************************************                     BUG28036
      /EJECT                                                                                BUG28036
      *****************************************************************                     BUG28036
      *                                                               *                     BUG28036
      *  SrWriteFTRV  - List records to send out for ABC validation   *                     BUG28036
      *                                                               *                     BUG28036
      *****************************************************************                     BUG28036
     C     SrWriteFTRV   BEGSR                                                              BUG28036
                                                                                            BUG28036
     C                   EVAL      TRTREF = R1TREF                                          BUG28036
     C                   EVAL      TREXDT = R1EXDT                                          BUG28036
     C                   EVAL      TRRCVD = *BLANK                                          BUG28036
     C                   EVAL      TRRERR = *BLANK                                          BUG28036
     C                   EVAL      TRTSNT = *BLANK                                          BUG28036
                                                                                            BUG28036
      ** List of forward account transfers for validation.                                  BUG28036
     C                   WRITE     GLFTRVF       GLFTRV                                     BUG28036
                                                                                            BUG28036
     C                   ENDSR                                                              BUG28036
      *****************************************************************                     BUG28036
      /EJECT                                                                                BUG28036
      *****************************************************************                     BUG28036
      *                                                               *                     BUG28036
      *  SrGetBalPrd  - Get balance period                            *                     BUG28036
      *                                                               *                     BUG28036
      *****************************************************************                     BUG28036
     C     SrGetBalPrd   BEGSR                                                              BUG28036
                                                                                            BUG28036
     C                   IF        ABNDYF <= 1                                              BUG28036
     C                   EVAL      WkEndPrd = BJDNWD                                        BUG28036
     C                   ELSE                                                               BUG28036
     C                   EVAL      WkCtr = 2                                                BUG28036
     C                   EVAL      WkDateIn = BJDNWD                                        BUG28036
     C                   DOW       WkCtr <= ABNDYF                                          BUG28036
     C                   EVAL      WkDateIn = WkDatein + 1                                  BUG28036
                                                                                            BUG28036
      ** Location currency                                                                  BUG28036
                                                                                            BUG28036
     C                   Z-ADD     WkDateIn      ZDAYNO                                     BUG28036
     C                   MOVE      BJLCCY        ZCCY                                       BUG28036
     C                   MOVE      *BLANKS       ZLOC                                       BUG28036
     C                   MOVE      *BLANKS       ZIND                                       BUG28036
     C                   EXSR      ZCHKH                                                    BUG28036
     C                   MOVE      ZIND          LOCIND            1                        BUG28036
                                                                                            BUG28036
      ** Account currency                                                                   BUG28036
                                                                                            BUG28036
     C                   Z-ADD     WkDateIn      ZDAYNO                                     BUG28036
     C                   MOVE      CCY           ZCCY                                       BUG28036
     C                   MOVE      *BLANKS       ZLOC                                       BUG28036
     C                   MOVE      *BLANKS       ZIND                                       BUG28036
     C                   EXSR      ZCHKH                                                    BUG28036
     C                   MOVE      ZIND          ACTIND            1                        BUG28036
                                                                                            BUG28036
     C                   IF        LOCIND = 'W' OR ACTIND = 'W'                             BUG28036
     C                   ADD       1             WkCtr                                      BUG28036
     C                   ENDIF                                                              BUG28036
     C                                                                                      BUG28036
     C                   ENDDO                                                              BUG28036
     C                   EVAL      WkEndPrd = WkDateIn                                      BUG28036
     C                                                                                      BUG28036
     C                   ENDIF                                                              BUG28036
                                                                                            BUG28036
     C                   ENDSR                                                              BUG28036
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenPost - Generate postings for account transfer           *
      *                                                               *
      *****************************************************************
     C     SRGenPost     BEGSR
 
      ** Retrieve branch details of debit and credit branch
 
     C                   IF        WDRBrch <> R1DBBR
     C                   EVAL      WDRBrch = R1DBBR
     C                   EVAL      PBranch = WDRBrch
     C                   EXSR      SRGetBrch
     C                   EVAL      DBBRCH = SDBRCH
     C                   ENDIF
 
     C                   IF        WCRBrch <> R1CRBR
     C                   EVAL      WCRBrch = R1CRBR
     C                   EVAL      PBranch = WCRBrch
     C                   EXSR      SRGetBrch
     C                   EVAL      CRBRCH = SDBRCH
     C                   ENDIF
 
      ** Retreive A/C Transfer Type/Subtype details
 
     C                   EXSR      SRGetATST
 
      ** Transaction Postings
 
     C                   EXSR      SRTranPost
 
      ** Fee Postings
 
     C                   EVAL      WHasFees = 'N'
     C                   IF        R1F1AM <> 0 OR R1F2AM <> 0 OR
     C                             R1F3AM <> 0 OR R1F4AM <> 0 OR
     C                             R1F5AM <> 0 OR R1F6AM <> 0
     C                   EVAL      WHasFees = 'Y'
     C                   EXSR      SRFees
     C                   ENDIF
 
      ***Cheque*Postings                                                                     CAP204A
 
     C**********         EVAL      WChqAmt = R1DAMT                                          CAP204A
     C**********         EXSR      SRChqPost                                                 CAP204A
 
      ** Print exchange rate details
 
     C                   EVAL      *IN30 = *ON
     C                   EXSR      SRPrntDetl2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTranPost - Generate transaction postings                   *
      *                                                               *
      *****************************************************************
     C     SRTranPost    BEGSR
 
     C                   EVAL      DrAmt = R1DAMT
     C                   EVAL      CrAmt = R1CAMT
 
      ** Create normal transaction postings for debit account
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = R1DBCU
     C                   EVAL      CCY = R1DBCY
     C                   EVAL      ACSQ = R1DBSQ
     C                   EVAL      ACNO = R1DBRE
     C                   EVAL      PSTA = R1DAMT
     C                   EVAL      VALD = R1DRVL
     C                   MOVE      R1DRTT        TRAT
     C                   EVAL      DRCR = 0
      *                                                                                     MD029951
      ** If Statement Narrative is not blanks, move value to PNAR                           MD029951
      *                                                                                     MD029951
     C                   IF        R1DBSN <> *BLANKS                                        MD029951
     C                   EVAL      PNAR = R1DBSN                                            MD029951
     C                   ENDIF                                                              MD029951
                                                                                            MD029951
     C                   EVAL      ASOC = R1CRCU
     C                   EVAL      BRCA = R1DBBR
     C**********         EVAL      CHQN = R1CHNO                                            BUG27561
     C                   Z-ADD     R1CHNO        CHQN                                       BUG27561
     C                   BITON     '0'           PRIN
     C                   EVAL      ACOD = R1DBAC
 
      ** Check if post to suspense account or not for debit
 
     C                   EVAL      WSuspAct = 'D'
     C**********         EXSR      SRChkSusp                                               BUG27831A
     C                   EXSR      SRGetAcod
     C                   IF        CRE072 = 'Y'                                               CRE072
     C                   EXSR      SRSetPsIn                                                  CRE072
     C                   ENDIF                                                                CRE072
     C                   EXSR      SRWrtPost
 
      ** Create normal transaction postings for credit account
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = R1CRCU
     C                   EVAL      CCY = R1CRCY
     C                   EVAL      ACSQ = R1CRSQ
     C                   EVAL      ACNO = R1CRRE
     C                   EVAL      PSTA = R1CAMT
     C                   EVAL      VALD = R1CRVL
     C                   MOVE      R1CRTT        TRAT
     C                   EVAL      DRCR = 1
      *                                                                                     MD029951
      ** If Statement Narrative is not blanks, move value to PNAR                           MD029951
      *                                                                                     MD029951
     C                   IF        R1CRSN <> *BLANKS                                        MD029951
     C                   EVAL      PNAR = R1CRSN                                            MD029951
     C                   ENDIF                                                              MD029951
                                                                                            MD029951
     C                   EVAL      ASOC = R1DBCU
     C                   EVAL      BRCA = R1CRBR
     C                   BITON     '0'           PRIN
     C                   EVAL      ACOD = R1CRAC
 
      ** Check if post to suspense account or not for credit
 
     C                   EVAL      WSuspAct = 'C'
     C**********         EXSR      SRChkSusp                                               BUG27831A
     C                   EXSR      SRGetAcod
     C                   IF        CRE072 = 'Y'                                               CRE072
     C                   EXSR      SRSetPsIn                                                  CRE072
     C                   ENDIF                                                                CRE072
     C                   EXSR      SRWrtPost
 
      ** Check if need to post to wash account                                               CAP204A
                                                                                             CAP204A
     C                   IF        ATWACC <> *ZEROS                                          CAP204A
     C                   EXSR      SRCmnPost                                                 CAP204A
     C                   EVAL      CNUM = B8BICN                                             CAP204A
     C                   EVAL      CCY = R1DBCY                                              CAP204A
     C                   EVAL      PSTA = R1DAMT                                             CAP204A
     C                   EVAL      DRCR = 1                                                  CAP204A
     C                   EVAL      BRCA = R1DBBR                                             CAP204A
     C                   EVAL      ACOD = ATWACC                                             CAP204A
     C                   EXSR      SRGetAcod                                                 CAP204A
     C                   EXSR      SRWrtPost                                                 CAP204A
     C                   EVAL      DRCR = 0                                                  CAP204A
     C                   EXSR      SRWrtPost                                                 CAP204A
     C                   ENDIF                                                               CAP204A
                                                                                             CAP204A
      ** Generate postings for cross-currency account transfer
 
     C                   IF        R1DBCY <> R1CRCY
 
      ** Retrieve debit currency details
 
     C                   EVAL      WDCcy = R1DBCY
     C                   EVAL      PCcy = WDCcy
     C                   EXSR      SRGetCcy
     C                   EVAL      WDNbdp = A6NBDP
     C                   EVAL      WDRate = A6SPRT
     C                   EVAL      WDMdin = A6MDIN
     C                   EVAL      WDSpae = A6SPAE
 
      ** Retrieve credit currency details
 
     C                   EVAL      WCCcy = R1CRCY
     C                   EVAL      PCcy = WCCcy
     C                   EXSR      SRGetCcy
     C                   EVAL      WCNbdp = A6NBDP
     C                   EVAL      WCRate = A6SPRT
     C                   EVAL      WCMdin = A6MDIN
     C                   EVAL      WCSpae = A6SPAE
                                                                                            BUG27201
      ** If transaction has net fees, get the total fees                                    BUG27201
      ** in account currency equivalent                                                     BUG27201
                                                                                            BUG27201
     C                   IF        R1FGRS = 'N'                                             BUG27201
     C                   EVAL      WTotFees = R1F1CE + R1F2CE +                             BUG27201
     C                                        R1F3CE + R1F4CE +                             BUG27201
     C                                        R1F5CE + R1F6CE                               BUG27201
                                                                                            BUG27201
      ** Get the gross amount of the fee paying account                                     BUG27201
      ** This amount should be posted in spot trade account                                 BUG27201
                                                                                            BUG27201
     C                   IF        R1FPAY = 'D'                                             BUG27201
     C                   EVAL      DrAmt = DrAmt - WTotFees                                 BUG27201
     C                   ELSE                                                               BUG27201
     C                   EVAL      CrAmt = CrAmt + WTotFees                                 BUG27201
     C                   ENDIF                                                              BUG27201
                                                                                            BUG27201
     C                   ENDIF                                                              BUG27201
 
     C                   EVAL      WDAmt = DrAmt
     C                   EVAL      WCAmt = CrAmt
     C                   EVAL      WDDrCr = 1
     C                   EVAL      WCDrCr = 0
     C                   EVAL      WCAsoc = B8BICN
     C                   EVAL      WPosFlag = 'T'
     C                   EXSR      SRCrosCur
 
      ** Generate interbranch postings for cross-currency
      ** Account transfer
 
     C                   EVAL      WPosFlag2 = 'C'
 
     C                   IF        R1DBBR <> R1BRCA
     C                   EVAL      WCNUM1 = D8BICN
     C                   EVAL      WCCY1 = R1DBCY
     C**********         EVAL      WPSTA1 = R1DAMT                                         BUG27201A
     C                   EVAL      WPSTA1 = DrAmt                                          BUG27201A
     C                   EVAL      WBRCA1 = R1DBBR                                          BUG27195
     C                   EVAL      WDRCR1 = 1
     C                   EVAL      WACOD1 = D8DTAC
     C                   EVAL      WACOD2 = M8DFAC
     C                   EVAL      WACOD3 = B8DFAC
     C                   EVAL      WACOD4 = M8DTAC
     C                   EXSR      SRIntBrch
     C                   ENDIF
 
     C                   IF        R1CRBR <> R1BRCA
     C                   EVAL      WCNUM1 = C8BICN
     C                   EVAL      WCCY1 = R1CRCY
     C**********         EVAL      WPSTA1 = R1CAMT                                         BUG27201A
     C                   EVAL      WPSTA1 = CrAmt                                          BUG27201A
     C                   EVAL      WBRCA1 = R1CRBR                                          BUG27195
     C                   EVAL      WDRCR1 = 0
     C                   EVAL      WACOD1 = C8DFAC
     C                   EVAL      WACOD2 = M8DTAC
     C                   EVAL      WACOD3 = B8DTAC
     C                   EVAL      WACOD4 = M8DFAC
     C                   EXSR      SRIntBrch
     C                   ENDIF
 
      ** Generate postings for single currency account transfer
 
     C                   ELSE
 
     C                   IF        R1DBBR <> R1CRBR
     C                   EVAL      WPosFlag2 = 'S'
     C                   EVAL      WCNUM1 = D8BICN
     C                   EVAL      WCNUM2 = C8BICN
     C                   EVAL      WCCY1 = R1DBCY
     C                   EVAL      WCCY2 = R1CRCY
 
      ** If type of fees is 'net', post gross amount for
      ** single currency inter-branch
 
     C                   IF        R1FGRS = 'N'
 
     C                   IF        R1FPAY = 'D'
     C                   EVAL      WPSTA1 = R1CAMT
     C                   ELSE
     C                   EVAL      WPSTA1 = R1DAMT
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WPSTA1 = R1DAMT
     C                   ENDIF
 
     C                   EVAL      WBRCA1 = R1DBBR
     C                   EVAL      WBRCA2 = R1CRBR
     C                   EVAL      WDRCR1 = 1
     C                   EVAL      WACOD1 = D8DTAC
     C                   EVAL      WACOD2 = M8DFAC
     C                   EVAL      WACOD3 = C8DFAC
     C                   EVAL      WACOD4 = M8DTAC
     C                   EXSR      SRIntBrch
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Print report details
 
     C                   EXSR      SRPrntDetl
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCmnPost - Clear GETXPD fields and setup common entries     *
      *                                                               *
      *****************************************************************
     C     SRCmnPost     BEGSR
 
      ** Clear detail file
 
     C                   CLEAR                   APOSTPDF
 
      ** Common Entries
 
     C                   EVAL      RECI = 'P'
     C                   EVAL      IPDN = *BLANKS
     C**********         EVAL      PSTD = BJRDNB                                            BUG27212
     C                   EVAL      PSTD = R1EXDT                                            BUG27212
     C                   EVAL      VALD = BJRDNB
     C                   EVAL      ACSQ = 01
 
     C                   EVAL      PNAR = R1TREF
     C                   EVAL      ASOC = '000000'
     C**********         EVAL      SPOS = 'GE-TX'                                           BUG27196
     C                   MOVE      'GE-TX'       SPOS                                       BUG27196
 
     C                   BITOFF    '01234567'    PRIN
     C                   EVAL      GETP = 'L'
     C                   EVAL      ACUM = 1
 
     C**********         IF        BGNOST = 'Y'                                            AR1009263
     C                   IF        BGN0ST = 'Y'                                            AR1009263
     C                   EVAL      PRFC = FTPRFP
     C                   ENDIF
 
     C                   EVAL      PTIM = 235959
     C                   EVAL      OTST = R1TRST
     C                   EVAL      OTTP = R1TRTY
     C                   EVAL      OTRF = R1TREF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrosCur - Generate additional postings for cross-currency  *
      *                                                               *
      *****************************************************************
     C     SRCrosCur     BEGSR
 
     C                   IF        WDCcy <> BJCYCD OR WBCcyEq <> *BLANKS
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = B8BICN
     C                   EVAL      CCY = WDCcy
     C                   EVAL      PSTA = DrAmt
     C                   EVAL      DRCR = WDDrCr
     C                   EVAL      BRCA = R1BRCA
 
      ** Execute some additional checking for fee posting
 
     C                   IF        WPosFlag = 'F'
     C                   EVAL      ASOC = WPayCust
     C                   ENDIF
 
     C                   MOVE      BLSPTA        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = B8BICN
     C                   EVAL      CCY = BJCYCD
 
     C                   IF        WPosFlag = 'T' AND WCCcy = BJCYCD
     C                   EVAL      PSTA = WCAmt
     C                   ELSEIF    WDCcy = BJCYCD                                          BUG27201A
     C                   EVAL      PSTA = DrAmt                                            BUG27201A
     C                   ELSE
     C                   EVAL      PAmount = WDAmt
     C                   EVAL      PFrXRate = WDRate
     C                   EVAL      PFrMDIn = WDMdin
     C                   EVAL      PFrCurrency = WDCcy
     C                   EVAL      PFrDecPlace = WDNbdp
     C                   EXSR      SRConvAmt
     C                   EVAL      PSTA = POutAmount
     C                   ENDIF
 
     C                   IF        WDDrCr = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
      ** Execute some additional checking for fee posting
 
     C                   IF        WPosFlag = 'F'
     C                   EVAL      ASOC = WPayCust
     C                   ENDIF
 
     C                   EVAL      BRCA = R1BRCA
     C                   MOVE      WDSpae        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
     C                   ENDIF
 
     C                   IF        WCCcy <> BJCYCD OR WBCcyEq <> *BLANKS
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = B8BICN
     C                   EVAL      CCY = WCCcy
     C                   EVAL      PSTA = CrAmt
     C                   EVAL      DRCR = WCDrCr
     C                   EVAL      BRCA = R1BRCA
 
      ** Execute some additional checking for transaction posting
 
     C                   MOVE      BLSPTA        ACOD
     C                   EXSR      SRGetAcod
     C                   IF        WPosFlag = 'T'
     C                   IF        ACSC = 'IN' OR ACSC = 'EX'
     C                   EVAL      ASOC = WCAsoc
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ASOC = WCAsoc
     C                   ENDIF
 
     C                   EVAL      BRCA = R1BRCA
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = B8BICN
     C                   EVAL      CCY = BJCYCD
 
     C                   IF        WPosFlag = 'T' AND WDCcy = BJCYCD
     C                   EVAL      PSTA = WDAmt
     C                   ELSEIF    WCCcy = BJCYCD                                          BUG27201A
     C                   EVAL      PSTA = CrAmt                                            BUG27201A
     C                   ELSE
     C                   EVAL      PAmount = WDAmt
     C                   EVAL      PFrXRate = WDRate
     C                   EVAL      PFrMDIn = WDMdin
     C                   EVAL      PFrCurrency = WDCcy
     C                   EVAL      PFrDecPlace = WDNbdp
     C                   EXSR      SRConvAmt
     C                   EVAL      PSTA = POutAmount
     C                   ENDIF
 
      ** Execute some additional checking for transaction or fee posting
 
     C                   EVAL      BRCA = R1BRCA
     C                   MOVE      WCSpae        ACOD
     C                   EXSR      SRGetAcod
     C                   IF        WPosFlag = 'T' OR WPosFlag = 'F'
     C                   IF        ACSC = 'IN' OR ACSC = 'EX'
     C                   EVAL      ASOC = WCAsoc
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ASOC = WCAsoc
     C                   ENDIF
 
     C                   IF        WCDrCr = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      BRCA = R1BRCA
     C                   EXSR      SRWrtPost
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIntBrch - Generate additional postings for inter-branch    *
      *                                                               *
      *****************************************************************
     C     SRIntBrch     BEGSR
 
     C                   IF        WPosFlag2 <> 'S'
 
      ** Generate inter-branch postings via Main Branch
 
     C                   IF        BKIEMB = 'Y' AND WBRCA1 <> BKMABR
     C                             AND R1BRCA <> BKMABR
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = M8BICN
     C                   EVAL      CCY = WCCY1
     C                   EVAL      DRCR = WDRCR1
     C                   EVAL      BRCA = WBRCA1
     C                   MOVE      WACOD1        ACOD
     C                   EXSR      SRGetAcod
 
      ** Entries specific to fees
 
     C                   IF        WPosFlag2 = 'F'
     C                   IF        (ACSC = 'IN' OR ACSC = 'EX')
     C                   EVAL      ASOC = WPayCust
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      PSTA = WPSTA1
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = WCNUM1
     C                   EVAL      CCY = WCCY1
     C                   EVAL      PSTA = WPSTA1
 
     C                   IF        WDRCR1 = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      BRCA = BKMABR
     C                   MOVE      WACOD2        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = M8BICN
     C                   EVAL      CCY = WCCY1
     C                   EVAL      PSTA = WPSTA1
 
     C                   IF        WDRCR1 = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      BRCA = R1BRCA
     C                   MOVE      WACOD3        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = B8BICN
     C                   EVAL      CCY = WCCY1
     C                   EVAL      PSTA = WPSTA1
 
     C                   EVAL      DRCR = WDRCR1
     C                   EVAL      BRCA = BKMABR
     C                   MOVE      WACOD4        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
      ** Generate inter-branch postings not via Main Branch
 
     C                   ELSE
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = B8BICN
     C                   EVAL      CCY = WCCY1
     C                   EVAL      PSTA = WPSTA1
 
     C                   EVAL      DRCR = WDRCR1
     C                   EVAL      BRCA = WBRCA1
     C                   MOVE      WACOD1        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = WCNUM1
     C                   EVAL      CCY = WCCY1
     C                   EVAL      PSTA = WPSTA1
 
     C                   IF        WDRCR1 = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      BRCA = R1BRCA
     C                   MOVE      WACOD3        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   ENDIF
 
      ** For transaction postings and cheque postings single currency
 
     C                   ELSE
 
      ** Generate inter-branch postings via Main Branch
 
     C                   IF        BKIEMB = 'Y' AND WBRCA1 <> BKMABR
     C                             AND WBRCA2 <> BKMABR
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = M8BICN
     C                   EVAL      CCY = WCCY1
     C                   EVAL      DRCR = WDRCR1
     C                   EVAL      BRCA = WBRCA1
     C                   MOVE      WACOD1        ACOD
     C                   EXSR      SRGetAcod
     C                   EVAL      PSTA = WPSTA1
 
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = WCNUM1
     C                   EVAL      CCY = WCCY1
     C                   EVAL      PSTA = WPSTA1
 
     C                   IF        WDRCR1 = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      BRCA = BKMABR
     C                   MOVE      WACOD2        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = M8BICN
     C                   EVAL      CCY = WCCY2
     C                   EVAL      PSTA = WPSTA1
 
     C                   IF        WDRCR1 = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      BRCA = WBRCA2
     C                   MOVE      WACOD3        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = WCNUM2
     C                   EVAL      CCY = WCCY2
     C                   EVAL      PSTA = WPSTA1
 
     C                   EVAL      DRCR = WDRCR1
     C                   EVAL      BRCA = BKMABR
     C                   MOVE      WACOD4        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
      ** Generate inter-branch postings not via Main Branch
 
     C                   ELSE
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = WCNUM2
     C                   EVAL      CCY = WCCY1
     C                   EVAL      PSTA = WPSTA1
 
     C                   EVAL      DRCR = WDRCR1
     C                   EVAL      BRCA = WBRCA1
     C                   MOVE      WACOD1        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = WCNUM1
     C                   EVAL      CCY = WCCY2
     C                   EVAL      PSTA = WPSTA1
 
     C                   IF        WDRCR1 = 0
     C                   EVAL      DRCR = 1
     C                   ELSE
     C                   EVAL      DRCR = 0
     C                   ENDIF
 
     C                   EVAL      BRCA = WBRCA2
     C                   MOVE      WACOD3        ACOD
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFees - Handle fee details                                  *
      *                                                               *
      *****************************************************************
     C     SRFees        BEGSR
 
      ** Store fee paying customer details
 
     C                   IF        R1FPAY = 'D'
     C                   EVAL      WPayCust = R1DBCU
     C                   EVAL      WPayBrch = R1DBBR
     C                   EVAL      WPayCcy = R1DBCY
     C                   ELSE
     C                   EVAL      WPayCust = R1CRCU
     C                   EVAL      WPayBrch = R1CRBR
     C                   EVAL      WPayCcy = R1CRCY
     C                   ENDIF
 
      ** Fee 1
 
     C                   IF        R1F1AM <> 0
     C                   EVAL      WFeeNo = '1'
     C                   EVAL      WFeeAmt = R1F1AM
     C                   EVAL      WFeeCcy = R1F1CU
     C                   EVAL      WFeeEqv = R1F1CE
     C                   EVAL      WFeeXrt = R1F1EX
                                                                                              CRE067
      ** Check if Fee Income Account has been entered                                         CRE067
      ** If Fee Income Account was entered, post fees to Fee Income                           CRE067
      ** Acct, otherwise, post fees to Booking Branch Internal Customer                       CRE067
                                                                                              CRE067
     C                   IF        R1F1BR <> *BLANKS                                          CRE067
     C                   EVAL      PBranch = R1F1BR                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1F1BR                                          CRE067
     C                   EVAL      WFeeCust = R1F1CR                                          CRE067
     C                   EVAL      WFeeSeq = R1F1AS                                           CRE067
     C                   EVAL      WFeeAcd = R1F1AC                                           CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      PBranch = R1BRCA                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1BRCA                                          CRE067
     C                   EVAL      WFeeCust = B8BICN                                          CRE067
     C                   EVAL      WFeeSeq = 01                                               CRE067
     C                   EVAL      WFeeAcd = ATF1CD
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   EXSR      SRFeePost
     C                   ENDIF
 
      ** Fee 2
 
     C                   IF        R1F2AM <> 0
     C                   EVAL      WFeeNo = '2'
     C                   EVAL      WFeeAmt = R1F2AM
     C                   EVAL      WFeeCcy = R1F2CU
     C                   EVAL      WFeeEqv = R1F2CE
     C                   EVAL      WFeeXrt = R1F2EX
     C                                                                                        CRE067
     C                   IF        R1F2BR <> *BLANKS                                          CRE067
     C                   EVAL      PBranch = R1F2BR                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1F2BR                                          CRE067
     C                   EVAL      WFeeCust = R1F2CR                                          CRE067
     C                   EVAL      WFeeSeq = R1F2AS                                           CRE067
     C                   EVAL      WFeeAcd = R1F2AC                                           CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      PBranch = R1BRCA                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1BRCA                                          CRE067
     C                   EVAL      WFeeCust = B8BICN                                          CRE067
     C                   EVAL      WFeeSeq = 01                                               CRE067
     C                   EVAL      WFeeAcd = ATF2CD
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   EXSR      SRFeePost
     C                   ENDIF
 
      ** Fee 3
 
     C                   IF        R1F3AM <> 0
     C                   EVAL      WFeeNo = '3'
     C                   EVAL      WFeeAmt = R1F3AM
     C                   EVAL      WFeeCcy = R1F3CU
     C                   EVAL      WFeeEqv = R1F3CE
     C                   EVAL      WFeeXrt = R1F3EX
                                                                                              CRE067
     C                   IF        R1F3BR <> *BLANKS                                          CRE067
     C                   EVAL      PBranch = R1F3BR                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1F3BR                                          CRE067
     C                   EVAL      WFeeCust = R1F3CR                                          CRE067
     C                   EVAL      WFeeSeq = R1F3AS                                           CRE067
     C                   EVAL      WFeeAcd = R1F3AC                                           CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      PBranch = R1BRCA                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1BRCA                                          CRE067
     C                   EVAL      WFeeCust = B8BICN                                          CRE067
     C                   EVAL      WFeeSeq = 01                                               CRE067
     C                   EVAL      WFeeAcd = ATF3CD
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   EXSR      SRFeePost
     C                   ENDIF
 
      ** Fee 4
 
     C                   IF        R1F4AM <> 0
     C                   EVAL      WFeeNo = '4'
     C                   EVAL      WFeeAmt = R1F4AM
     C                   EVAL      WFeeCcy = R1F4CU
     C                   EVAL      WFeeEqv = R1F4CE
     C                   EVAL      WFeeXrt = R1F4EX
                                                                                              CRE067
     C                   IF        R1F4BR <> *BLANKS                                          CRE067
     C                   EVAL      PBranch = R1F4BR                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1F4BR                                          CRE067
     C                   EVAL      WFeeCust = R1F4CR                                          CRE067
     C                   EVAL      WFeeSeq = R1F4AS                                           CRE067
     C                   EVAL      WFeeAcd = R1F4AC                                           CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      PBranch = R1BRCA                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1BRCA                                          CRE067
     C                   EVAL      WFeeCust = B8BICN                                          CRE067
     C                   EVAL      WFeeSeq = 01                                               CRE067
     C                   EVAL      WFeeAcd = ATF4CD
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   EXSR      SRFeePost
     C                   ENDIF
 
      ** Fee 5
 
     C                   IF        R1F5AM <> 0
     C                   EVAL      WFeeNo = '5'
     C                   EVAL      WFeeAmt = R1F5AM
     C                   EVAL      WFeeCcy = R1F5CU
     C                   EVAL      WFeeEqv = R1F5CE
     C                   EVAL      WFeeXrt = R1F5EX
                                                                                              CRE067
     C                   IF        R1F5BR <> *BLANKS                                          CRE067
     C                   EVAL      PBranch = R1F5BR                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1F5BR                                          CRE067
     C                   EVAL      WFeeCust = R1F5CR                                          CRE067
     C                   EVAL      WFeeSeq = R1F5AS                                           CRE067
     C                   EVAL      WFeeAcd = R1F5AC                                           CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      PBranch = R1BRCA                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1BRCA                                          CRE067
     C                   EVAL      WFeeCust = B8BICN                                          CRE067
     C                   EVAL      WFeeSeq = 01                                               CRE067
     C                   EVAL      WFeeAcd = ATF5CD
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   EXSR      SRFeePost
     C                   ENDIF
 
      ** Fee 6
 
     C                   IF        R1F6AM <> 0
     C                   EVAL      WFeeNo = '6'
     C                   EVAL      WFeeAmt = R1F6AM
     C                   EVAL      WFeeCcy = R1F6CU
     C                   EVAL      WFeeEqv = R1F6CE
     C                   EVAL      WFeeXrt = R1F6EX
                                                                                              CRE067
     C                   IF        R1F6BR <> *BLANKS                                          CRE067
     C                   EVAL      PBranch = R1F6BR                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1F6BR                                          CRE067
     C                   EVAL      WFeeCust = R1F6CR                                          CRE067
     C                   EVAL      WFeeSeq = R1F6AS                                           CRE067
     C                   EVAL      WFeeAcd = R1F6AC                                           CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      PBranch = R1BRCA                                           CRE067
     C                   EXSR      SrGetBrch                                                  CRE067
     C                   EVAL      FEEBRCH = SDBRCH                                           CRE067
     C                   EVAL      WFeeBrch = R1BRCA                                          CRE067
     C                   EVAL      WFeeCust = B8BICN                                          CRE067
     C                   EVAL      WFeeSeq = 01                                               CRE067
     C                   EVAL      WFeeAcd = ATF6CD
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   EXSR      SRFeePost
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFeePost - Generate fee postings                            *
      *                                                               *
      *****************************************************************
     C     SRFeePost     BEGSR
 
     C                   EXSR      SRCmnPost
     C**********         EVAL      CNUM = B8BICN                                              CRE067
     C                   EVAL      CNUM = WFeeCust                                            CRE067
     C                   EVAL      CCY = WFeeCcy
     C                   EVAL      PSTA = WFeeAmt
     C                   EVAL      DRCR = 1
      *                                                                                     MD029951
     C                   IF        R1FGRS <> 'N'                                            MD029951
     C                   SELECT                                                             MD029951
     C     WFeeNo        WHENEQ    '1 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F1DS                   MD029951
     C     WFeeNo        WHENEQ    '2 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F2DS                   MD029951
     C     WFeeNo        WHENEQ    '3 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F3DS                   MD029951
     C     WFeeNo        WHENEQ    '4 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F4DS                   MD029951
     C     WFeeNo        WHENEQ    '5 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F5DS                   MD029951
     C     WFeeNo        WHENEQ    '6 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F6DS                   MD029951
     C                   ENDSL                                                              MD029951
     C                   ENDIF                                                              MD029951
      *                                                                                     MD029951
     C**********         EVAL      BRCA = R1BRCA                                              CRE067
     C                   EVAL      BRCA = WFeeBrch                                            CRE067
     C                   EVAL      ACSQ = WFeeSeq                                             CRE067
     C                   EVAL      ACOD = WFeeAcd
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
      ** If type of fee is gross, generate additional postings
 
     C                   IF        R1FGRS <> 'N'
 
      ** Create fee postings for debit account if gross fees
 
     C                   IF        R1FPAY = 'D'
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = R1DBCU
     C                   EVAL      CCY = R1DBCY
     C                   EVAL      ACSQ = R1DBSQ
     C                   EVAL      ACNO = R1DBRE
     C                   EVAL      PSTA = WFeeEqv
     C                   EVAL      VALD = R1DRVL
     C                   MOVE      R1DRTT        TRAT
     C                   EVAL      DRCR = 0
     C                   EVAL      ASOC = WPayCust
     C                   EVAL      BRCA = R1DBBR
     C**********         EVAL      CHQN = R1CHNO                                            BUG27561
     C                   Z-ADD     R1CHNO        CHQN                                       BUG27561
     C                   BITON     '0'           PRIN
     C                   EVAL      ACOD = R1DBAC
     C                   EVAL      FEEFLG = 'F'
 
     C                   SELECT                                                             MD029951
     C     WFeeNo        WHENEQ    '1 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F1DS                   MD029951
     C     WFeeNo        WHENEQ    '2 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F2DS                   MD029951
     C     WFeeNo        WHENEQ    '3 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F3DS                   MD029951
     C     WFeeNo        WHENEQ    '4 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F4DS                   MD029951
     C     WFeeNo        WHENEQ    '5 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F5DS                   MD029951
     C     WFeeNo        WHENEQ    '6 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F6DS                   MD029951
     C                   ENDSL                                                              MD029951
      *                                                                                     MD029951
      ** Check if post to suspense account or not for debit
 
     C                   EVAL      WSuspAct = 'D'
     C**********         EXSR      SRChkSusp                                               BUG27831A
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
      ***Generate*cheque*postings*for*this*fee*if*applicable                                 CAP204A
 
     C**********         EVAL      WChqAmt = WFeeEqv                                         CAP204A
     C**********         EXSR      SRChqPost                                                 CAP204A
 
     C                   ELSE
 
      ** Create fee postings for credit account if gross fees
 
     C                   EXSR      SRCmnPost
     C                   EVAL      CNUM = R1CRCU
     C                   EVAL      CCY = R1CRCY
     C                   EVAL      ACSQ = R1CRSQ
     C                   EVAL      ACNO = R1CRRE
     C                   EVAL      PSTA = WFeeEqv
     C                   EVAL      VALD = R1CRVL
     C                   MOVE      R1CRTT        TRAT
     C                   EVAL      DRCR = 0
     C                   EVAL      ASOC = WPayCust
     C                   EVAL      BRCA = R1CRBR
     C                   BITON     '0'           PRIN
     C                   EVAL      ACOD = R1CRAC
     C                   EVAL      FEEFLG = 'F'
 
     C                   SELECT                                                             MD029951
     C     WFeeNo        WHENEQ    '1 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F1DS                   MD029951
     C     WFeeNo        WHENEQ    '2 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F2DS                   MD029951
     C     WFeeNo        WHENEQ    '3 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F3DS                   MD029951
     C     WFeeNo        WHENEQ    '4 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F4DS                   MD029951
     C     WFeeNo        WHENEQ    '5 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F5DS                   MD029951
     C     WFeeNo        WHENEQ    '6 '                                                     MD029951
     C                   EVAL      PNAR = %SUBST(R1TREF:1) + ' ' + R1F6DS                   MD029951
     C                   ENDSL                                                              MD029951
      *                                                                                     MD029951
      ** Check if post to suspense account or not for credit
 
     C                   EVAL      WSuspAct = 'C'
     C**********         EXSR      SRChkSusp                                               BUG27831A
     C                   EXSR      SRGetAcod
     C                   EXSR      SRWrtPost
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Generate cross-currency entries for fees
 
     C                   IF        WFeeCcy <> WPayCcy
     C                   EVAL      DrAmt = WFeeAmt
     C                   EVAL      CrAmt = WFeeEqv
     C                   EVAL      WDAmt = WFeeAmt
     C                   EVAL      WDDrCr = 0
     C                   EVAL      WCDrCr = 1
     C                   EVAL      WCAsoc = WPayCust
     C                   EVAL      WPosFlag = 'F'
 
      ** Retrieve fee currency details
 
     C                   EVAL      WDCcy = WFeeCcy
     C                   EVAL      PCcy = WDCcy
     C                   EXSR      SRGetCcy
     C                   EVAL      WDNbdp = A6NBDP
     C                   EVAL      WDRate = A6SPRT
     C                   EVAL      WDMdin = A6MDIN
     C                   EVAL      WDSpae = A6SPAE
 
      ** Retrieve paying customer currency details
 
     C                   EVAL      WCCcy = WPayCcy
     C                   EVAL      PCcy = WCCcy
     C                   EXSR      SRGetCcy
     C                   EVAL      WCSpae = A6SPAE
 
     C                   EXSR      SRCrosCur
 
     C                   ENDIF
 
      ** Generate inter-branch entries for fees
 
     C                   IF        WFeeCcy <> WPayCcy                                         CRE067
     C                   IF        R1BRCA <> WPayBrch
     C                   EVAL      WPosFlag2 = 'F'
 
     C                   IF        R1FPAY = 'D'
     C                   EVAL      WCNUM1 = D8BICN
     C                   EVAL      WCCY1 = R1DBCY
     C                   EVAL      WBRCA1 = R1DBBR
     C                   EVAL      WACOD1 = D8DTAC
     C                   ELSE
     C                   EVAL      WCNUM1 = C8BICN
     C                   EVAL      WCCY1 = R1CRCY
     C                   EVAL      WBRCA1 = R1CRBR
     C                   EVAL      WACOD1 = C8DTAC
     C                   ENDIF
 
     C                   EVAL      WPSTA1 = WFeeEqv
     C                   EVAL      WDRCR1 = 1
     C                   EVAL      WACOD2 = M8DFAC
     C                   EVAL      WACOD3 = B8DFAC
     C                   EVAL      WACOD4 = M8DTAC
     C                   EXSR      SRIntBrch
     C                   ENDIF
                                                                                              CRE067
     C                   IF        R1BRCA <> WFeeBrch                                         CRE067
     C                   EVAL      WCNUM1 = F8BICN                                            CRE067
     C                   EVAL      WCCY1  = WFeeCcy                                           CRE067
     C                   EVAL      WPSTA1 = WFeeAmt                                           CRE067
     C                   EVAL      WBRCA1 = WFeeBrch                                          CRE067
     C                   EVAL      WDRCR1 = 0                                                 CRE067
     C                   EVAL      WACOD1 = F8DFAC                                            CRE067
     C                   EVAL      WACOD2 = M8DTAC                                            CRE067
     C                   EVAL      WACOD3 = B8DTAC                                            CRE067
     C                   EVAL      WACOD4 = M8DFAC                                            CRE067
     C                   EXSR      SRIntBrch                                                  CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   ELSE                                                                 CRE067
                                                                                              CRE067
      ** Single currency inter-branch entry                                                   CRE067
                                                                                              CRE067
     C                   IF        WFeeBrch <> WPayBrch                                       CRE067
     C                   EVAL      WPosFlag2 = 'S'                                            CRE067
                                                                                              CRE067
     C                   IF        R1FPAY = 'D'                                               CRE067
     C                   EVAL      WCNUM1 = D8BICN                                            CRE067
     C                   EVAL      WCCY1 = R1DBCY                                             CRE067
     C                   EVAL      WBRCA1 = R1DBBR                                            CRE067
     C                   EVAL      WACOD1 = D8DTAC                                            CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      WCNUM1 = C8BICN                                            CRE067
     C                   EVAL      WCCY1 = R1CRCY                                             CRE067
     C                   EVAL      WBRCA1 = R1CRBR                                            CRE067
     C                   EVAL      WACOD1 = C8DTAC                                            CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   EVAL      WBRCA2 = F8BRCD                                            CRE067
     C                   EVAL      WCNUM2 = F8BICN                                            CRE067
     C                   EVAL      WCCY2 = WFeeCcy                                            CRE067
     C                   EVAL      WPSTA1 = WFeeAmt                                           CRE067
     C                   EVAL      WDRCR1 = 1                                                 CRE067
     C                   EVAL      WACOD2 = M8DFAC                                            CRE067
     C                   EVAL      WACOD3 = F8DFAC                                            CRE067
     C                   EVAL      WACOD4 = M8DTAC                                            CRE067
     C                   EXSR      SRIntBrch                                                  CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   ENDIF                                                                CRE067
 
      ** Print fee details
 
     C                   EVAL      *IN30 = *OFF
     C                   EXSR      SRPrntDetl2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ***SRChqPost*-*Generate*cheque*postings**************************                      CAP204A
      *                                                               *
      *****************************************************************
     C*****SRChqPost     BEGSR                                                               CAP204A
 
      ***Cheque*account*should*not*be*blanks*or*be*equal*to                                  CAP204A
      ***Debit*account                                                                       CAP204A
 
     C**********         IF        (R1CHBR <> *BLANKS AND R1CHCU <> *BLANKS                  CAP204A
     C**********                   AND R1CHCY <> *BLANKS AND R1CHAC <> 0                     CAP204A
     C**********                   AND R1CHSQ <> 0) AND (R1CHBR <> R1DBBR                    CAP204A
     C**********                   OR R1CHCU <> R1DBCU OR R1CHCY <> R1DBCY                   CAP204A
     C**********                   OR R1CHAC <> R1DBAC OR R1CHSQ <> R1DBSQ)                  CAP204A
 
      ***Retrieve*Cheque*Branch*details                                                      CAP204A
 
     C**********         IF        WCQBrch <> R1CHBR                                         CAP204A
     C**********         EVAL      WCQBrch = R1CHBR                                          CAP204A
     C**********         EVAL      PBranch = WCQBrch                                         CAP204A
     C**********         EXSR      SRGetBrch                                                 CAP204A
     C**********         EVAL      CQBRCH = SDBRCH                                           CAP204A
     C**********         ENDIF                                                               CAP204A
 
     C**********         IF        R1DBCY <> R1CHCY                                          CAP204A
 
      ***Retrieve*debit*currency*details                                                     CAP204A
 
     C**********         EVAL      WDCcy = R1DBCY                                            CAP204A
     C**********         EVAL      PCcy = WDCcy                                              CAP204A
     C**********         EXSR      SRGetCcy                                                  CAP204A
     C**********         EVAL      WDNbdp = A6NBDP                                           CAP204A
     C**********         EVAL      WDRate = A6SPRT                                           CAP204A
     C**********         EVAL      WDMdin = A6MDIN                                           CAP204A
     C**********         EVAL      WDSpae = A6SPAE                                           CAP204A
 
      ***Retrieve*cheque*currency*details                                                    CAP204A
 
     C**********         EVAL      WCCcy = R1CHCY                                            CAP204A
     C**********         EVAL      PCcy = WCCcy                                              CAP204A
     C**********         EXSR      SRGetCcy                                                  CAP204A
     C**********         EVAL      WCNbdp = A6NBDP                                           CAP204A
     C**********         EVAL      WCRate = A6SPRT                                           CAP204A
     C**********         EVAL      WCMdin = A6MDIN                                           CAP204A
     C**********         EVAL      WCSpae = A6SPAE                                           CAP204A
 
      ***Convert*debit*amount*to*cheque*currency                                             CAP204A
 
     C**********         EVAL      PAmount = WChqAmt                                         CAP204A
     C**********         EVAL      PFrCurrency = R1DBCY                                      CAP204A
     C**********         EVAL      PToCurrency = R1CHCY                                      CAP204A
     C**********         EVAL      PFrXRate = WDRate                                         CAP204A
     C**********         EVAL      PToXRate = WCRate                                         CAP204A
     C**********         EVAL      PFrMDIn = WDMdin                                          CAP204A
     C**********         EVAL      PToMDIn = WCMdin                                          CAP204A
     C**********         EVAL      PFrDecPlace = WDNbdp                                      CAP204A
     C**********         EVAL      PToDecPlace = WCNbdp                                      CAP204A
     C**********         EXSR      SRCrosCnv                                                 CAP204A
     C**********         EVAL      DrAmt = WChqAmt                                           CAP204A
     C**********         EVAL      CrAmt = POutAmount                                        CAP204A
 
     C**********         ELSE                                                                CAP204A
     C**********         EVAL      DrAmt = WChqAmt                                           CAP204A
     C**********         EVAL      CrAmt = WChqAmt                                           CAP204A
     C**********         ENDIF                                                               CAP204A
 
      ***Create*normal*cheque*postings*for*debit*account                                     CAP204A
 
     C**********         EXSR      SRCmnPost                                                 CAP204A
     C**********         EVAL      CNUM = R1DBCU                                             CAP204A
     C**********         EVAL      CCY = R1DBCY                                              CAP204A
     C**********         EVAL      ACSQ = R1DBSQ                                             CAP204A
     C**********         EVAL      ACNO = R1DBRE                                             CAP204A
     C**********         EVAL      PSTA = DrAmt                                              CAP204A
     C**********         EVAL      VALD = R1DRVL                                             CAP204A
     C**********         MOVE      R1DRTT        TRAT                                        CAP204A
     C**********         EVAL      DRCR = 1                                                  CAP204A
     C**********         EVAL      BRCA = R1DBBR                                             CAP204A
     C**********         EVAL      CHQN = R1CHNO                                             CAP204A
     C**********         BITON     '0'           PRIN                                        CAP204A
     C**********         EVAL      ACOD = R1DBAC                                             CAP204A
 
      ***Check*if*post*to*suspense*account*or*not*for*debit                                  CAP204A
 
     C**********         EVAL      WSuspAct = 'D'                                            CAP204A
     C**********         EXSR      SRChkSusp                                                 CAP204A
     C**********         EXSR      SRGetAcod                                                 CAP204A
     C**********         EXSR      SRWrtPost                                                 CAP204A
 
      ***Create*normal*cheque*postings*for*cheque*account                                    CAP204A
 
     C**********         EXSR      SRCmnPost                                                 CAP204A
     C**********         EVAL      CNUM = R1CHCU                                             CAP204A
     C**********         EVAL      CCY = R1CHCY                                              CAP204A
     C**********         EVAL      ACSQ = R1CHSQ                                             CAP204A
     C**********         EVAL      ACNO = R1CHRE                                             CAP204A
     C**********         EVAL      PSTA = CrAmt                                              CAP204A
     C**********         EVAL      VALD = R1CRVL                                             CAP204A
     C**********         EVAL      DRCR = 0                                                  CAP204A
     C**********         EVAL      BRCA = R1CHBR                                             CAP204A
     C**********         EVAL      CHQN = R1CHNO                                             CAP204A
     C**********         BITON     '0'           PRIN                                        CAP204A
     C**********         EVAL      ACOD = R1CHAC                                             CAP204A
     C**********         EXSR      SRGetAcod                                                 CAP204A
     C**********         EXSR      SRWrtPost                                                 CAP204A
 
      ***Generate*cross-currency*postings                                                    CAP204A
 
     C**********         IF        R1DBCY <> R1CHCY                                          CAP204A
     C**********         EVAL      WDAmt = DrAmt                                             CAP204A
     C**********         EVAL      WDDrCr = 0                                                CAP204A
     C**********         EVAL      WCDrCr = 1                                                CAP204A
     C**********         EVAL      WCAsoc = '000000'                                         CAP204A
     C**********         EVAL      WPosFlag = 'C'                                            CAP204A
     C**********         EXSR      SRCrosCur                                                 CAP204A
 
      ***Generate*interbranch*postings                                                       CAP204A
 
     C**********         EVAL      WPosFlag2 = 'C'                                           CAP204A
 
     C**********         IF        R1DBBR <> R1BRCA                                          CAP204A
     C**********         EVAL      WCNUM1 = D8BICN                                           CAP204A
     C**********         EVAL      WCCY1 = R1DBCY                                            CAP204A
     C**********         EVAL      WPSTA1 = DrAmt                                            CAP204A
     C**********         EVAL      WDRCR1 = 0                                                CAP204A
     C**********         EVAL      WACOD1 = D8DFAC                                           CAP204A
     C**********         EVAL      WACOD2 = M8DTAC                                           CAP204A
     C**********         EVAL      WACOD3 = B8DTAC                                           CAP204A
     C**********         EVAL      WACOD4 = M8DFAC                                           CAP204A
     C**********         EXSR      SRIntBrch                                                 CAP204A
     C**********         ENDIF                                                               CAP204A
 
     C**********         IF        R1CHBR <> R1BRCA                                          CAP204A
     C**********         EVAL      WCNUM1 = T8BICN                                           CAP204A
     C**********         EVAL      WCCY1 = R1CHCY                                            CAP204A
     C**********         EVAL      WPSTA1 = CrAmt                                            CAP204A
     C**********         EVAL      WDRCR1 = 1                                                CAP204A
     C**********         EVAL      WACOD1 = T8DTAC                                           CAP204A
     C**********         EVAL      WACOD2 = M8DFAC                                           CAP204A
     C**********         EVAL      WACOD3 = B8DFAC                                           CAP204A
     C**********         EVAL      WACOD4 = M8DTAC                                           CAP204A
     C**********         EXSR      SRIntBrch                                                 CAP204A
     C**********         ENDIF                                                               CAP204A
 
      ***Cheque*currency*is*the*same*as*debit*currency                                       CAP204A
 
     C**********         ELSE                                                                CAP204A
 
     C**********         IF        R1DBBR <> R1CHBR                                          CAP204A
     C**********         EVAL      WPosFlag2 = 'S'                                           CAP204A
     C**********         EVAL      WCNUM1 = D8BICN                                           CAP204A
     C**********         EVAL      WCNUM2 = T8BICN                                           CAP204A
     C**********         EVAL      WCCY1 = R1DBCY                                            CAP204A
     C**********         EVAL      WCCY2 = R1CHCY                                            CAP204A
     C**********         EVAL      WPSTA1 = DrAmt                                            CAP204A
     C**********         EVAL      WBRCA1 = R1DBBR                                           CAP204A
     C**********         EVAL      WBRCA2 = R1CHBR                                           CAP204A
     C**********         EVAL      WDRCR1 = 0                                                CAP204A
     C**********         EVAL      WACOD1 = D8DFAC                                           CAP204A
     C**********         EVAL      WACOD2 = M8DTAC                                           CAP204A
     C**********         EVAL      WACOD3 = T8DTAC                                           CAP204A
     C**********         EVAL      WACOD4 = M8DFAC                                           CAP204A
     C**********         EXSR      SRIntBrch                                                 CAP204A
 
     C**********         ENDIF                                                               CAP204A
 
     C**********         ENDIF                                                               CAP204A
 
     C**********         ENDIF                                                               CAP204A
 
     C**********         ENDSR                                                               CAP204A
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrtPost - Write postings to APOSTPDF                       *
      *                                                               *
      *****************************************************************
     C     SRWrtPost     BEGSR
 
      ** Calculate hash integer and decimal first
 
     C                   EVAL      ZZAMT = PSTA/1000
     C                   EVAL      ZZTOTI = ZZTOTI2
     C                   EVAL      ZZTOTD = ZZTOTD2
     C                   EXSR      SRZZAdd
     C                   EVAL      ZZTOTI2 = ZZTOTI
     C                   EVAL      ZZTOTD2 = ZZTOTD
 
      ** Add 1 to the no. of records written
 
     C**********         IF        T_NORE1 = 99997                                BUG27825 BUG27825A
     C**********         Z-ADD     0             T_NORE1                          BUG27825 BUG27825A
     C**********         ENDIF                                                    BUG27825 BUG27825A
     C**********         EVAL      T_NORE1 = T_NORE1 + 1                                   BUG27825A
     C                   ADD       1             T_NORE1                                   BUG27825A
     C                   WRITE     APOSTPDF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrtHist - Write account transfer to history file           *
      *                                                               *
      *****************************************************************
     C     SRWrtHist     BEGSR
 
     C                   EVAL      GLHATM = GLATMI
     C                   EVAL      H_R1RECI = 'M'                                           BUG27389
     C                   WRITE     GLATMID1
 
     C                   DELETE    GLATMID0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZZAdd - Calculate hash fields                              *
      *                                                               *
      *****************************************************************
     C     SRZZAdd       BEGSR
 
      **   Setup fields to be hashed
 
     C**********         Z-ADD     ZZAMT         ZZAMT                  91                 AR1014090
     C***91*****         Z-SUB     ZZAMT         ZZAMT                                     AR1014090
     C**********         Z-ADD     ZZAMT         ZZAMTI                                    AR1014090
     C**********         MOVE      ZZAMT         ZZAMTD                                    AR1014090
 
      ** Add decimal part and check for carry
 
     C**********         ADD       ZZAMTD        ZZTOTD                                    AR1014090
     C*****ZZTOTD        COMP      ZZAMTD                               91                 AR1014090
     C***91*****         ADD       1             ZZAMTI                                    AR1014090
 
      ** Add integer part
 
     C**********         ADD       ZZAMTI        ZZTOTI                                    AR1014090
     C                   MOVE      *BLANKS       WCHMT                                     AR1014090
     C                   Z-ADD     0             ZZAMT2                                    AR1014090
     C                   IF        ZZTOTI < 0                                              AR1014090
     C                   EVAL      ZZTOTI = ZZTOTI * -1                                    AR1014090
     C                   EVAL      ZZTOTD = ZZTOTD * -1                                    AR1014090
     C                   MOVEL     ZZTOTI        WCHMT                                     AR1014090
     C                   MOVE      ZZTOTD        WCHMT                                     AR1014090
     C                   MOVE      WCHMT         ZZAMT2                                    AR1014090
     C                   EVAL      ZZAMT2 = ZZAMT2 * -1                                    AR1014090
     C                   ELSE                                                              AR1014090
     C                   MOVEL     ZZTOTI        WCHMT                                     AR1014090
     C                   MOVE      ZZTOTD        WCHMT                                     AR1014090
     C                   MOVE      WCHMT         ZZAMT2                                    AR1014090
     C                   ENDIF                                                             AR1014090
     C                   ADD       ZZAMT         ZZAMT2                                    AR1014090
     C                   Z-ADD     ZZAMT2        ZZTOTI                                    AR1014090
     C                   MOVE      ZZAMT2        ZZTOTD                                    AR1014090
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROpenPrtf - Open prtf if the prtf is not open               *
      *                                                               *
      *****************************************************************
     C     SROpenPrtf    BEGSR
 
      ** If the prtf is not open
 
     C                   OPEN      GL004601P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANK        SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *BLANK        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSerr         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBreakBrc - Branch break in report                          *
      *                                                               *
      *****************************************************************
     C     SRBreakBrc    BEGSR
 
     C                   EXSR      SRPrntTrl
     C                   IF        NOT(%EOF(GLATMIL0))
     C                   CLOSE     GL004601P1
 
      ** Open prtf if the prtf is not open
 
     C                   OPEN      GL004601P1
     C                   EVAL      RRBRCD = R1BRCA
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrntTrl - Write branch trailer in report                   *
      *                                                               *
      *****************************************************************
     C     SRPrntTrl     BEGSR
 
      ** Setup trailer fields
 
     C                   EVAL      RRBRCD = WBKBrch
     C                   EVAL      NORE = WNoRec
     C                   EVAL      WNoRec = 0
 
      ** Write out report trailer.
 
     C**********         EVAL      RqdLn1 = 3                                               BUG27825
     C                   EVAL      RqdLn1 = 8                                               BUG27825
     C                   EXSR      SROverflow
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFrmtDetl - Setup report details                            *
      *                                                               *
      *****************************************************************
     C     SRFrmtDetl    BEGSR
 
      ** Setup report fields
 
     C                   EVAL      RRTREF = R1TREF
     C                   MOVE      R1CHNO        RRCHNO
 
      ** Check if print of debit or credit details
 
     C                   IF        *IN31 = *OFF
     C                   MOVE      R1DBAC        RRACNO
     C                   EVAL      RRNARR = R1DBSN
     C                   EVAL      RRCCY = R1DBCY
     C                   EVAL      PCust = R1DBCU
     C                   MOVE      R1DAMT        PZField
     C                   ELSE
     C                   MOVE      R1CRAC        RRACNO
     C                   EVAL      RRNARR = R1CRSN
     C                   EVAL      RRCCY = R1CRCY
     C**********         EVAL      PCust = R1DBCU                                           MD034016
     C                   EVAL      PCust = R1CRCU                                           MD034016
     C                   MOVE      R1CAMT        PZField
     C                   ENDIF
 
     C                   EXSR      SRGetCust
     C                   EVAL      RRCRNM = BBCRNM
     C                   EVAL      PCcy = RRCCY
     C                   EXSR      SRGetCcy
     C                   EVAL      PZDec = A6NBDP
     C                   EXSR      SRZEdit
     C                   EVAL      RRAMT = PZField
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrntDetl - Print report details                            *
      *                                                               *
      *****************************************************************
     C     SRPrntDetl    BEGSR
 
     C                   EVAL      WAcctPrnt = 'N'
     C                   EVAL      RqdLn1 = 7
     C                   EXSR      SROverflow
 
      ** If account details not printed during
      ** overflow, print account details
 
     C                   IF        WAcctPrnt = 'N'
     C                   EVAL      *IN31 = *OFF
     C                   EXSR      SRFrmtDetl
     C                   WRITE     DETAIL
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRFrmtDetl
     C                   WRITE     DETAIL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFrmtDetl2 - Format fee or exchange rate report details     *
      *                                                               *
      *****************************************************************
     C     SRFrmtDetl2   BEGSR
 
      ** Setup report fields
 
     C                   IF        *IN30 = *OFF
     C                   EVAL      RRFEE = WFeeNo
     C                   EVAL      RRFCCY = WFeeCcy
 
     C                   EVAL      PCcy = RRFCCY
     C                   EXSR      SRGetCcy
     C                   EVAL      PZDec = A6NBDP
     C                   MOVE      WFeeAmt       PZField
     C                   EXSR      SRZEdit
     C                   EVAL      RRFAMT = PZField
 
     C                   ELSE
     C                   EVAL      RREXRT = R1EXCH
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrntDetl2 - Print fee or exchange rate details             *
      *                                                               *
      *****************************************************************
     C     SRPrntDetl2   BEGSR
 
     C                   EXSR      SRFrmtDetl2
     C                   EVAL      RqdLn1 = 3
     C                   EXSR      SROverflow
     C                   WRITE     DETAIL2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANK        SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANK        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If there is a record read, write audit control report.
 
     C**********         IF        WTotRec <> 0                                             BUG27196
 
     C**********         READ      GLATTRPD                                                 BUG27196
     C**********         IF        NOT(%EOF(GLATTRPD))                                      BUG27196
     C**********         EVAL      RCOUNT1 = T1NORC                                         BUG27196
     C**********         EVAL      RHASI1 = T1HRWN                                          BUG27196
     C**********         EVAL      RHASD1 = T1HRDC                                          BUG27196
     C**********         ENDIF                                                              BUG27196
 
     C**********         EVAL      RCOUNT2 = WTotRec                                        BUG27196
     C**********         EVAL      RHASI2 = ZZTOTI1                                         BUG27196
     C**********         EVAL      RHASD2 = ZZTOTD1                                         BUG27196
 
      ***Check*if*there*is*a*difference                                                     BUG27196
 
     C**********         IF        (RCOUNT1 <> RCOUNT2) OR (RHASI1 <> RHASI2)               BUG27196
     C**********                   OR (RHASD1 <> RHASD2)                                    BUG27196
     C**********         EVAL      *IN40 = *ON                                              BUG27196
     C**********         EVAL      *INU7 = *ON                                              BUG27196
     C**********         EVAL      *INU8 = *ON                                              BUG27196
     C**********         ENDIF                                                              BUG27196
 
     C                   IF        T_NORE1-2 <> 0                                           BUG27196
     C                   EVAL      RCOUNT3 = T_NORE1
     C                   EVAL      RHASI3 = ZZTOTI2
     C                   EVAL      RHASD3 = ZZTOTD2
     C                   WRITE     CONTROL
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR ='1'
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROverflow - Write header if overflow                        *
      *                                                               *
      *****************************************************************
     C     SROverflow    BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** If overflow has occured, write header
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
 
      ** Reprint account details if overflow for fees
 
     C                   IF        WHasFees = 'Y'
     C                   EVAL      *IN31 = *OFF
     C                   EXSR      SRFrmtDetl
     C                   WRITE     DETAIL
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRFrmtDetl
     C                   WRITE     DETAIL
     C                   EVAL      WAcctPrnt = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCust - Gets customer details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetCust     BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBrch - Access Branch details                            *
      *                                                               *
      *****************************************************************
     C     SRGetBrch     BEGSR
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBKey = PBranch
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCcy - Access Currency details                           *
      *                                                               *
      *****************************************************************
     C     SRGetCcy      BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCcy
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetATST - Access A/C Transfer Type/Subtype details         *
      *                                                               *
      *****************************************************************
     C     SRGetATST     BEGSR
 
     C                   CALL      'AOATSTR0'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      R1TRTY        PTrty
     C                   PARM      R1TRST        PTrst
     C     SDATST        PARM      SDATST        DSLDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDATSTPD'
     C                   EVAL      DBKey = PTrty
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcod - Access A/C Code Details                          *
      *                                                               *
      *****************************************************************
     C     SRGetAcod     BEGSR
 
     C                   MOVE      ACOD          PAcod
     C                   CALL      'AOACODR0'
 
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PAcod
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDACODPD'
     C                   EVAL      DBKey = PAcod
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ACSC = A_A5ACSC
     C                   EVAL      ATYP = A_A5ACTY
 
     C                   IF        ATYP = 'R'
     C                   EVAL      RIND = 1
     C                   ELSE
     C                   EVAL      RIND = 0
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcct - Retrieve account details                         *
      *                                                               *
      *****************************************************************
     C     SRGetAcct     BEGSR
 
      ** Access GL Account Details
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      *BLANKS       PRetl
     C                   PARM                    PCnum
     C                   PARM                    PAccy
     C                   PARM                    PAcod
     C                   PARM                    PAcsq
     C                   PARM                    PBrca
     C     SDACCT        PARM      SDACCT        DSSDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK AND PRetCode <> '*NRF'
     C                             AND PRetCode <> '*CLOSE'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = PCnum + PAccy + PAcod +
     C                                     PAcsq + PBrca
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSEIF    PRetCode = '*NRF'
     C                   CLEAR                   SDACCT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvAmt - Convert amount to base currency                  *
      *                                                               *
      *****************************************************************
     C     SRConvAmt     BEGSR
 
     C                   CALL      'ZCONVZ1'
     C                   PARM                    PAmount
     C                   PARM                    PFrXRate
     C                   PARM                    PFrMDIn
     C                   PARM                    PFrCurrency
     C                   PARM      BJCYCD        PToCurrency
     C                   PARM                    PFrDecPlace
     C                   PARM      WBNbdp        PToDecPlace
     C                   PARM                    POutAmount
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCrosCnv - Cross currency conversion                        *
      *                                                               *
      *****************************************************************
     C     SRCrosCnv     BEGSR
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEdit - Format amount                                      *
      *                                                               *
      *****************************************************************
     C     SRZEdit       BEGSR
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZDec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRSetPsIn - Set posting indicator                            *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRSetPsIn     BEGSR                                                                CRE072
      *                                                                                       CRE072
      ** Set ZTACMTL0 key fileds                                                              CRE072
      *                                                                                       CRE072
     C                   EVAL      KZTDORC = DRCR                                             CRE072
     C                   EXSR      SRSetZTKy                                                  CRE072
      *                                                                                       CRE072
      ** Access shadow posting record off LF/ZTACMTL0                                         CRE072
      *                                                                                       CRE072
     C     KZTACMT       CHAIN     ZTACMTL0                                                   CRE072
      *                                                                                       CRE072
     C                   IF        NOT(%EOF(ZTACMTL0))                                        CRE072
     C                   IF        ZT_APBI = 'Y'                                              CRE072
     C                   BITON     '3'           PRIN                                         CRE072
     C                   ENDIF                                                                CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRChkMvt                                                     *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRChkMvt      BEGSR                                                                CRE072
      *                                                                                       CRE072
      ** Initialise Passbook Printing work fileds                                             CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbDrFnd = 'N'                                             CRE072
     C                   EVAL      WPbDrPrn = 'N'                                             CRE072
     C                   EVAL      WPbDrLoc = *BLANKS                                         CRE072
     C                   EVAL      WPbCrFnd = 'N'                                             CRE072
     C                   EVAL      WPbCrPrn = 'N'                                             CRE072
     C                   EVAL      WPbCrLoc = *BLANKS                                         CRE072
      *                                                                                       CRE072
      ** Find Primary Movement on posting tables                                              CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbDrCr = DRCR                                             CRE072
     C                   EXSR      SRFindMvt                                                  CRE072
      *                                                                                       CRE072
      ** Find Counterpart Movement on posting tables                                          CRE072
      *                                                                                       CRE072
     C                   IF        DRCR = 0                                                   CRE072
     C                   EVAL      WPbDrCr = 1                                                CRE072
     C                   ELSE                                                                 CRE072
     C                   EVAL      WPbDrCr = 0                                                CRE072
     C                   ENDIF                                                                CRE072
     C                   EXSR      SRFindMvt                                                  CRE072
      *                                                                                       CRE072
      ** If one is printed and another is not printed                                         CRE072
      ** Keep unprinted movements                                                             CRE072
      *                                                                                       CRE072
     C                   IF        WPbDrFnd = 'Y' AND                                         CRE072
     C                             WPbCrFnd = 'Y' AND                                         CRE072
     C                             NOT(WPbCrPrn = WPbDrPrn)                                   CRE072
      *                                                                                       CRE072
     C                   IF        WPbDrPrn = 'N'                                             CRE072
     C                   EVAL      WPbDrCr = 0                                                CRE072
     C                   EVAL      WPbLoc = WPbDrLoc                                          CRE072
     C                   ELSE                                                                 CRE072
     C                   EVAL      WPbDrCr = 1                                                CRE072
     C                   EVAL      WPbLoc = WPbCrLoc                                          CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   EXSR      SRKeepMvt                                                  CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRKeepMvt                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRKeepMvt     BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   CLEAR                   APOSTPDF                                     CRE072
      *                                                                                       CRE072
     C                   SELECT                                                               CRE072
      *                                                                                       CRE072
     C                   WHEN      WPbLoc = 'GLAC'                                            CRE072
     C                   EXSR      SRGetGLAC                                                  CRE072
      *                                                                                       CRE072
     C                   WHEN      WPbLoc = 'APOS'                                            CRE072
     C                   EXSR      SRGetAPOS                                                  CRE072
      *                                                                                       CRE072
     C                   WHEN      WPbLoc = 'RSAC'                                            CRE072
     C                   EXSR      SRGetRSAC                                                  CRE072
      *                                                                                       CRE072
     C                   ENDSL                                                                CRE072
      *                                                                                       CRE072
     C                   WRITE     GLPUAMD0                                                   CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRGetRSAC                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRGetRSAC     BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   EVAL      KZTDORC = WPbDrCr                                          CRE072
     C                   EXSR      SRSetZTKy                                                  CRE072
      *                                                                                       CRE072
     C     KZTACMT       CHAIN     ZTACMTL0                                                   CRE072
      *                                                                                       CRE072
     C                   IF        %FOUND(ZTACMTL0)                                           CRE072
      *                                                                                       CRE072
      ** Move values to GLPUAML0 fields                                                       CRE072
      *                                                                                       CRE072
     C                   EXSR      SRCmnPost                                                  CRE072
     C                   EVAL      CNUM = R1DBCU                                              CRE072
     C                   EVAL      CCY = R1DBCY                                               CRE072
     C                   EVAL      ACSQ = R1DBSQ                                              CRE072
     C                   EVAL      ACNO = R1DBRE                                              CRE072
     C                   EVAL      PSTA = R1DAMT                                              CRE072
     C                   EVAL      VALD = R1DRVL                                              CRE072
     C                   MOVE      R1DRTT        TRAT                                         CRE072
     C                   EVAL      DRCR = 0                                                   CRE072
     C                   EVAL      ASOC = R1CRCU                                              CRE072
     C                   EVAL      BRCA = R1DBBR                                              CRE072
     C                   Z-ADD     R1CHNO        CHQN                                         CRE072
     C                   BITON     '0'           PRIN                                         CRE072
     C                   EVAL      ACOD = R1DBAC                                              CRE072
     C                   EXSR      SRGetAcod                                                  CRE072
      *                                                                                       CRE072
     C                   MOVE      SDGETX        GLPUAM                                       CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRGetAPOS                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRGetAPOS     BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   EVAL      KPDDRCR = WPbDrCr                                          CRE072
     C                   EXSR      SRSetPDKy                                                  CRE072
      *                                                                                       CRE072
     C                   EVAL      GLPOST = *BLANKS                                           CRE072
     C     KGLPOST       CHAIN     GLPOSTL6                                                   CRE072
      *                                                                                       CRE072
     C                   IF        %FOUND(GLPOSTL6)                                           CRE072
      *                                                                                       CRE072
      ** Move values to GLPUAML0 fields                                                       CRE072
      *                                                                                       CRE072
     C                   MOVE      GLPOST        GLPUAM                                       CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRGetGLAC                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRGetGLAC     BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   EVAL      KPHDRCR = WPbDrCr                                          CRE072
     C                   EXSR      SRSetPHKy                                                  CRE072
      *                                                                                       CRE072
     C                   EVAL      GLACPH = *BLANKS                                           CRE072
     C     KGLACPH       CHAIN     GLACPHL3                                                   CRE072
      *                                                                                       CRE072
     C                   IF        %FOUND(GLACPHL3)                                           CRE072
      *                                                                                       CRE072
      ** Move values to GLPUAML0 fields                                                       CRE072
      *                                                                                       CRE072
     C                   MOVE      GLACPH        GLPUAM                                       CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRFindMvt                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRFindMvt     BEGSR                                                                CRE072
      *                                                                                       CRE072
      ** Find in Accounts Post History - Detail                                               CRE072
      *                                                                                       CRE072
     C                   IF        (WPbDrCr = 0 AND WPbDrFnd = 'N') OR                        CRE072
     C                             (WPbDrCr = 1 AND WPbCrFnd = 'N')                           CRE072
     C                   EXSR      SRFndGLAC                                                  CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
      ** Find in Account Postings Detail                                                      CRE072
      *                                                                                       CRE072
     C                   IF        (WPbDrCr = 0 AND WPbDrFnd = 'N') OR                        CRE072
     C                             (WPbDrCr = 1 AND WPbCrFnd = 'N')                           CRE072
     C                   EXSR      SRFndAPOS                                                  CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
      ** Find in Account movements                                                            CRE072
      *                                                                                       CRE072
     C                   IF        (WPbDrCr = 0 AND WPbDrFnd = 'N') OR                        CRE072
     C                             (WPbDrCr = 1 AND WPbCrFnd = 'N')                           CRE072
     C                   EXSR      SRFndRSAC                                                  CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRFndGLAC                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRFndGLAC     BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   EVAL      KPHDRCR = WPbDrCr                                          CRE072
     C                   EXSR      SRSetPHKy                                                  CRE072
      *                                                                                       CRE072
     C     KGLACPH       CHAIN     GLACPHL3                                                   CRE072
      *                                                                                       CRE072
     C                   IF        %FOUND(GLACPHL3)                                           CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbLoc = 'GLAC'                                            CRE072
     C                   EXSR      SRFlgFnd                                                   CRE072
      *                                                                                       CRE072
     C                   TESTB     '3'           PH_PRIN                  11                  CRE072
     C                   IF        *IN11 = *ON                                                CRE072
     C                   EXSR      SRFlgPrn                                                   CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRFndAPOS                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRFndAPOS     BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   EVAL      KPDDRCR = WPbDrCr                                          CRE072
     C                   EXSR      SRSetPDKy                                                  CRE072
      *                                                                                       CRE072
     C     KGLPOST       CHAIN     GLPOSTL6                                                   CRE072
      *                                                                                       CRE072
     C                   IF        %FOUND(GLPOSTL6)                                           CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbLoc = 'APOS'                                            CRE072
     C                   EXSR      SRFlgFnd                                                   CRE072
      *                                                                                       CRE072
     C                   TESTB     '3'           PD_PRIN                  11                  CRE072
     C                   IF        *IN11 = *ON                                                CRE072
     C                   EXSR      SRFlgPrn                                                   CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRFndRSAC                                                    *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRFndRSAC     BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   EVAL      KZTDORC = WPbDrCr                                          CRE072
     C                   EXSR      SRSetZTKy                                                  CRE072
      *                                                                                       CRE072
     C     KZTACMT       CHAIN     ZTACMTL0                                                   CRE072
      *                                                                                       CRE072
     C                   IF        %FOUND(ZTACMTL0)                                           CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbLoc = 'RSAC'                                            CRE072
     C                   EXSR      SRFlgFnd                                                   CRE072
      *                                                                                       CRE072
     C                   IF        ZT_APBI = 'Y'                                              CRE072
     C                   EXSR      SRFlgPrn                                                   CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRFlgFnd                                                     *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRFlgFnd      BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   IF        WPbDrCr = 0                                                CRE072
      *                                                                                       CRE072
      ** Flag Debit movement as found                                                         CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbDrFnd = 'Y'                                             CRE072
     C                   EVAL      WPbDrLoc = WPbLoc                                          CRE072
      *                                                                                       CRE072
     C                   ELSE                                                                 CRE072
      *                                                                                       CRE072
      ** Flag Credit movement as found                                                        CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbCrFnd = 'Y'                                             CRE072
     C                   EVAL      WPbCrLoc = WPbLoc                                          CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRFlgPrn                                                                             CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRFlgPrn      BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   IF        WPbDrCr = 0                                                CRE072
      *                                                                                       CRE072
      ** Flag Debit movement as printed                                                       CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbDrPrn = 'Y'                                             CRE072
      *                                                                                       CRE072
     C                   ELSE                                                                 CRE072
      *                                                                                       CRE072
      ** Flag Crebit movement as printed                                                      CRE072
      *                                                                                       CRE072
     C                   EVAL      WPbCrPrn = 'Y'                                             CRE072
      *                                                                                       CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRSetPHKy - Set GLACPHL3 key fileds                          *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRSetPHKy     BEGSR                                                                CRE072
      *                                                                                       CRE072
      ** Setup key to access LF/GLACPHL3                                                      CRE072
      *                                                                                       CRE072
     C                   EVAL      KPHOTRF = *BLANKS                                          CRE072
     C                   EVAL      KPHCNUM = *BLANKS                                          CRE072
     C                   EVAL      KPHCCY  = *BLANKS                                          CRE072
     C                   EVAL      KPHACOD = *ZERO                                            CRE072
     C                   EVAL      KPHACSQ = *ZERO                                            CRE072
     C                   EVAL      KPHBRCA = *BLANKS                                          CRE072
      *                                                                                       CRE072
     C                   EVAL      KPHOTRF = R1TREF                                           CRE072
     C                   IF        DRCR = 0                                                   CRE072
     C                   EVAL      KPHCNUM = R1DBCU                                           CRE072
     C                   EVAL      KPHCCY  = R1DBCY                                           CRE072
     C                   EVAL      KPHACOD = R1DBAC                                           CRE072
     C                   EVAL      KPHACSQ = R1DBSQ                                           CRE072
     C                   EVAL      KPHBRCA = R1DBBR                                           CRE072
     C                   ELSE                                                                 CRE072
     C                   EVAL      KPHCNUM = R1CRCU                                           CRE072
     C                   EVAL      KPHCCY  = R1CRCY                                           CRE072
     C                   EVAL      KPHACOD = R1CRAC                                           CRE072
     C                   EVAL      KPHACSQ = R1CRSQ                                           CRE072
     C                   EVAL      KPHBRCA = R1CRBR                                           CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRSetPDKy - Set GLPOSTL6 key fileds                          *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRSetPDKy     BEGSR                                                                CRE072
      *                                                                                       CRE072
      ** Setup key to access LF/GLPOSTL6                                                      CRE072
      *                                                                                       CRE072
     C                   EVAL      KPDOTRF = *BLANKS                                          CRE072
     C                   EVAL      KPDCNUM = *BLANKS                                          CRE072
     C                   EVAL      KPDCCY  = *BLANKS                                          CRE072
     C                   EVAL      KPDACOD = *ZERO                                            CRE072
     C                   EVAL      KPDACSQ = *ZERO                                            CRE072
     C                   EVAL      KPDBRCA = *BLANKS                                          CRE072
      *                                                                                       CRE072
     C                   EVAL      KPDOTRF = R1TREF                                           CRE072
     C                   IF        DRCR = 0                                                   CRE072
     C                   EVAL      KPDCNUM = R1DBCU                                           CRE072
     C                   EVAL      KPDCCY  = R1DBCY                                           CRE072
     C                   EVAL      KPDACOD = R1DBAC                                           CRE072
     C                   EVAL      KPDACSQ = R1DBSQ                                           CRE072
     C                   EVAL      KPDBRCA = R1DBBR                                           CRE072
     C                   ELSE                                                                 CRE072
     C                   EVAL      KPDCNUM = R1CRCU                                           CRE072
     C                   EVAL      KPDCCY  = R1CRCY                                           CRE072
     C                   EVAL      KPDACOD = R1CRAC                                           CRE072
     C                   EVAL      KPDACSQ = R1CRSQ                                           CRE072
     C                   EVAL      KPDBRCA = R1CRBR                                           CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************                       CRE072
      *                                                               *                       CRE072
      *  SRSetZTKy - Set ZTACMTL0 key fileds                          *                       CRE072
      *                                                               *                       CRE072
      *****************************************************************                       CRE072
     C     SRSetZTKy     BEGSR                                                                CRE072
      *                                                                                       CRE072
      ** Setup key to access LF/ZTACMTL0                                                      CRE072
      *                                                                                       CRE072
     C                   EVAL      KZTOTR1 = *BLANKS                                          CRE072
     C                   EVAL      KZTCUSN = *BLANKS                                          CRE072
     C                   EVAL      KZTCCYD = *BLANKS                                          CRE072
     C                   EVAL      KZTACDE = *ZERO                                            CRE072
     C                   EVAL      KZTASNC = *ZERO                                            CRE072
     C                   EVAL      KZTBRCA = *BLANKS                                          CRE072
      *                                                                                       CRE072
     C                   EVAL      KZTOTR1 = R1TREF                                           CRE072
     C                   IF        DRCR = 0                                                   CRE072
     C                   EVAL      KZTCUSN = R1DBCU                                           CRE072
     C                   EVAL      KZTCCYD = R1DBCY                                           CRE072
     C                   EVAL      KZTACDE = R1DBAC                                           CRE072
     C                   EVAL      KZTASNC = R1DBSQ                                           CRE072
     C                   EVAL      KZTBRCA = R1DBBR                                           CRE072
     C                   ELSE                                                                 CRE072
     C                   EVAL      KZTCUSN = R1CRCU                                           CRE072
     C                   EVAL      KZTCCYD = R1CRCY                                           CRE072
     C                   EVAL      KZTACDE = R1CRAC                                           CRE072
     C                   EVAL      KZTASNC = R1CRSQ                                           CRE072
     C                   EVAL      KZTBRCA = R1CRBR                                           CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
      *****************************************************************                       CRE072
      /EJECT                                                                                  CRE072
      *****************************************************************
      *****************************************************************                    BUG27831A
      ***SRChkSusp*-*Check*if*account*is*a*suspense*account************                    BUG27831A
      *****************************************************************                    BUG27831A
      *****************************************************************
     C*****SRChkSusp     BEGSR                                                             BUG27831A
      *****************************************************************                    BUG27831A
     C**********         EVAL      WSuspnse = 'N'                                          BUG27831A
     C**********         EVAL      *IN20 = *OFF                                   BUG27299 BUG27831A
     C**********         EVAL      PCnum = CNUM                                            BUG27831A
     C**********         EVAL      PAccy = CCY                                             BUG27831A
     C**********         EVAL      PBrca = BRCA                                            BUG27831A
     C**********         MOVE      ACSQ          PAcsq                                     BUG27831A
     C**********         MOVE      ACOD          PAcod                                     BUG27831A
     C**********         EXSR      SRGetAcct                                               BUG27831A
     C**********         EXSR      SRGetAcod                                               BUG27831A
      *****************************************************************                    BUG27831A
     C*****R1TREF        CHAIN     GLFLTRL1                                                BUG27831A
     C**********         IF        %FOUND(GLFLTRL1)                                        BUG27831A
     C**********         MOVEA     G1REJC        REJCDE                                    BUG27831A
      *****************************************************************                    BUG27831A
     C**********         IF        WSuspAct = 'D' AND G1DBBR = BRCA  AND                   BUG27831A
     C**********                   G1DBCU = CNUM  AND G1DBCY = CCY   AND                   BUG27831A
     C**********                   G1DBAC = ACOD  AND G1DBSQ = ACSQ                        BUG27831A
      *****************************************************************                    BUG27831A
     C*****'02'*         LOOKUP    REJCDE                                 20      BUG27299 BUG27831A
     C*****'01'*         LOOKUP    REJCDE                                 21      BUG27299 BUG27831A
     C**********         EVAL      WIdx = 1                                       BUG27299 BUG27831A
     C**********         DOW       WIdx <= 10 AND *IN20 <> *ON                    BUG27299 BUG27831A
     C**********         MOVE      WIdx          WRejCde                          BUG27299 BUG27831A
     C*****WRejCde       LOOKUP    REJCDE                                 20      BUG27299 BUG27831A
     C**********         EVAL      WIdx = WIdx + 1                                BUG27299 BUG27831A
     C**********         ENDDO                                                    BUG27299 BUG27831A
     C**********         IF        (*IN20 = *ON AND ACATYP = 'R') OR              BUG27299 BUG27831A
     C**********                   (*IN21 = *ON AND A_A5ACTY = 'R')               BUG27299 BUG27831A
     C**********         IF        (*IN20 = *ON)                                  BUG27299 BUG27831A
     C**********         EVAL      WSuspnse = 'Y'                                          BUG27831A
     C**********         EVAL      CNUM = D8BICN                                 BUG27201A BUG27831A
     C**********         ENDIF                                                             BUG27831A
      *****************************************************************                    BUG27831A
     C**********         ELSEIF    WSuspAct = 'C' AND G1CRBR = BRCA  AND                   BUG27831A
     C**********                   G1CRCU = CNUM  AND G1CRCY = CCY   AND                   BUG27831A
     C**********                   G1CRAC = ACOD  AND G1CRSQ = ACSQ                        BUG27831A
      *****************************************************************                    BUG27831A
     C*****'12'*         LOOKUP    REJCDE                                 20      BUG27299 BUG27831A
     C*****'11'*         LOOKUP    REJCDE                                 21      BUG27299 BUG27831A
     C**********         EVAL      WIdx = 11                                      BUG27299 BUG27831A
     C**********         DOW       WIdx <= 19 AND *IN20 <> *ON                    BUG27299 BUG27831A
     C**********         MOVE      WIdx          WRejCde                          BUG27299 BUG27831A
     C*****WRejCde       LOOKUP    REJCDE                                 20      BUG27299 BUG27831A
     C**********         EVAL      WIdx = WIdx + 1                                BUG27299 BUG27831A
     C**********         ENDDO                                                    BUG27299 BUG27831A
     C**********         IF        (*IN20 = *ON AND ACATYP = 'R') OR              BUG27299 BUG27831A
     C**********                   (*IN21 = *ON AND A_A5ACTY = 'R')               BUG27299 BUG27831A
     C**********         IF        (*IN20 = *ON)                                  BUG27299 BUG27831A
     C**********         EVAL      WSuspnse = 'Y'                                          BUG27831A
     C**********         EVAL      CNUM = C8BICN                                 BUG27201A BUG27831A
     C**********         ENDIF                                                             BUG27831A
      *****************************************************************                    BUG27831A
     C**********         ENDIF                                                             BUG27831A
      *****************************************************************                    BUG27831A
     C**********         ENDIF                                                             BUG27831A
      *****************************************************************                    BUG27831A
      ***If*post*to*suspense*account,*change*some**********************                    BUG27831A
      ***entries*of*the*posting****************************************                    BUG27831A
      *****************************************************************                    BUG27831A
     C**********         IF        WSuspnse = 'Y'                                          BUG27831A
     C**********         EVAL      CNUM = B8BICN                                 BUG27201A BUG27831A
     C**********         EVAL      ACSQ = 01                                               BUG27831A
     C**********         EVAL      BRCA = R1BRCA                                 BUG27201A BUG27831A
     C**********         MOVE      BKACCD        ACOD                                      BUG27831A
     C**********         EVAL      ASOC = '000000'                                         BUG27831A
     C**********         EVAL      ACNO = *ZEROS                                  BUG27212 BUG27831A
     C**********         EVAL      TRAT = *ZEROS                                  BUG27212 BUG27831A
     C**********         ENDIF                                                             BUG27831A
      *****************************************************************                    BUG27831A
     C**********         ENDSR                                                             BUG27831A
      *****************************************************************
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
 
      ** Receive Parameter List.
     C     *ENTRY        PLIST
     C                   PARM                    WMODE             1
      *
     C     *DTAARA       DEFINE                  LDA
 
     C     KyDrAc        KLIST                                                              BUG28036
     C                   KFLD                    R1DBCU                                     BUG28036
     C                   KFLD                    R1DBCY                                     BUG28036
     C                   KFLD                    R1DBAC                                     BUG28036
     C                   KFLD                    R1DBSQ                                     BUG28036
     C                   KFLD                    R1DBBR                                     BUG28036
                                                                                            BUG28036
      *                                                                                       CRE072
      ** ZTACMTL0 key fields                                                                  CRE072
      *                                                                                       CRE072
     C     KZTACMT       KLIST                                                                CRE072
     C                   KFLD                    KZTCUSN                                      CRE072
     C                   KFLD                    KZTCCYD                                      CRE072
     C                   KFLD                    KZTASNC                                      CRE072
     C                   KFLD                    KZTBRCA                                      CRE072
     C                   KFLD                    KZTDORC                                      CRE072
     C                   KFLD                    KZTACDE                                      CRE072
     C                   KFLD                    KZTOTR1                                      CRE072
      *                                                                                       CRE072
      ** GLPOSTL6 key fields                                                                  CRE072
      *                                                                                       CRE072
     C     KGLPOST       KLIST                                                                CRE072
     C                   KFLD                    KPDCNUM                                      CRE072
     C                   KFLD                    KPDCCY                                       CRE072
     C                   KFLD                    KPDACSQ                                      CRE072
     C                   KFLD                    KPDDRCR                                      CRE072
     C                   KFLD                    KPDBRCA                                      CRE072
     C                   KFLD                    KPDACOD                                      CRE072
     C                   KFLD                    KPDOTRF                                      CRE072
      *                                                                                       CRE072
      ** GLACPHL3 key fields                                                                  CRE072
      *                                                                                       CRE072
     C     KGLACPH       KLIST                                                                CRE072
     C                   KFLD                    KPHCNUM                                      CRE072
     C                   KFLD                    KPHCCY                                       CRE072
     C                   KFLD                    KPHACSQ                                      CRE072
     C                   KFLD                    KPHDRCR                                      CRE072
     C                   KFLD                    KPHBRCA                                      CRE072
     C                   KFLD                    KPHACOD                                      CRE072
     C                   KFLD                    KPHOTRF                                      CRE072
      *                                                                                       CRE072
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error processing
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get base currency details
 
     C                   EVAL      PCcy = BJCYCD
     C                   EXSR      SRGetCcy
     C                   EVAL      WBNbdp = A6NBDP
     C                   EVAL      WBCcyEq = A6SPAE
 
      ** Access General Ledger ICD
 
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKey  = POption
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve main branch internal customer
 
     C                   IF        BKMABR <> *BLANKS
     C                   EVAL      PBranch = BKMABR
     C                   EXSR      SRGetBrch
     C                   EVAL      MNBRCH = SDBRCH
     C                   ENDIF
 
      ** Access Trade ICD
 
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDTRADPD'
     C                   EVAL      DBKey  = POption
     C                   EVAL      DBPgm = 'GL004601'
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *****************************************************************                     AR958673
      ***Access*PCA*Details********************************************                     AR958673
      *****************************************************************                     AR958673
     C**********         CALL      'AOPCACR0'                                               AR958673
     C**********         PARM      *BLANKS       PRetCode                                   AR958673
     C**********         PARM      '*FIRST '     POption                                    AR958673
     C*****SDPCAC        PARM      SDPCAC        DSFDY                                      AR958673
      *****************************************************************                     AR958673
     C**********         IF        PRetCode <> *BLANKS                                      AR958673
     C******LOCK         IN        LDA                                                      AR958673
     C**********         EVAL      DBFile = 'SDPCACPD'                                      AR958673
     C**********         EVAL      DBKey  = POption                                         AR958673
     C**********         EVAL      DBPgm = 'GL004601'                                       AR958673
     C**********         EVAL      DBase  = 4                                               AR958673
     C**********         OUT       LDA                                                      AR958673
     C**********         EXSR      *PSSR                                                    AR958673
     C**********         ENDIF                                                              AR958673
 
      ** Access the Midas Modules
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            AR958673
      ** Access PCA Details                                                                 AR958673
                                                                                            AR958673
     C     BGN0ST        IFEQ      'Y'                                                      AR958673
     C                   CALL      'AOPCACR0'                                               AR958673
     C                   PARM      *BLANKS       PRetCode                                   AR958673
     C                   PARM      '*FIRST '     POption                                    AR958673
     C     SDPCAC        PARM      SDPCAC        DSFDY                                      AR958673
                                                                                            AR958673
     C                   IF        PRetCode <> *BLANKS                                      AR958673
     C     *LOCK         IN        LDA                                                      AR958673
     C                   EVAL      DBFile = 'SDPCACPD'                                      AR958673
     C                   EVAL      DBKey  = POption                                         AR958673
     C                   EVAL      DBPgm = 'GL004601'                                       AR958673
     C                   EVAL      DBase  = 4                                               AR958673
     C                   OUT       LDA                                                      AR958673
     C                   EXSR      *PSSR                                                    AR958673
     C                   ENDIF                                                              AR958673
     C                   ENDIF                                                              AR958673
                                                                                            AR958673
      *                                                                                       CRE072
      ** Check if switchable feature CRE072 - BankFusion Midas Teller Related Changes         CRE072
      *                                                                                       CRE072
     C                   CALL      'AOSARDR0'                                                 CRE072
     C                   PARM      *BLANKS       PRetCode                                     CRE072
     C                   PARM      '*VERIFY'     POption                                      CRE072
     C                   PARM      'CRE072'      PSARD                                        CRE072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE072
      *                                                                                       CRE072
     C                   IF        PRetCode <> *BLANKS  AND                                   CRE072
     C                             PRetCode <> '*NRF   '                                      CRE072
     C     *LOCK         IN        LDA                                                        CRE072
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE072
     C                   EVAL      DBKey  = 'CRE072'                                          CRE072
     C                   EVAL      DBPgm = 'GL004601'                                         CRE072
     C                   EVAL      DBase = 13                                                 CRE072
     C                   OUT       LDA                                                        CRE072
     C                   EXSR      *PSSR                                                      CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   IF        PRetCode = *BLANKS                                         CRE072
     C                   EVAL      CRE072 = 'Y'                                               CRE072
     C                   ELSE                                                                 CRE072
     C                   EVAL      CRE072 = 'N'                                               CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
 
      ** Set correct event control date depending on processing mode                       BUG27831B
                                                                                           BUG27831B
     C                   IF        WMODE = 'N'                                             BUG27831B
                                                                                           BUG27831B
     C                   CALL      'ZFWDT'                                                 BUG27831B
     C                   PARM                    BJDNWD                                    BUG27831B
     C**********         PARM                    ZNRDYS                           BUG27831B BUG28036
     C*****BJDNWD        PARM      *ZERO         WkCtrDt                          BUG27831B BUG28036
     C                   PARM                    WkFwDay                                    BUG28036
     C     WkCtrDt       PARM      *ZERO         WkCtrDt                                    BUG28036
     C**********         PARM                    BJCYCD                           BUG27831B BUG28036
     C                   PARM                    BJLCCY                                     BUG28036
     C                   PARM                    BJSLCD                                    BUG27831B
                                                                                           BUG27831B
      ** WkCtrDt is the day before next working after BJDNWD.                               BUG28036
     C                   EVAL      WkCtrDt = WkCtrDt -1                                     BUG28036
     C                   ELSE                                                               BUG28036
                                                                                           BUG27831B
     C**********         ENDIF                                                    BUG27831B BUG28036
                                                                                           BUG27831B
      ** Set event control date to the less of the Accrual Profit Date and Date
      ** of the Next Working Day minus 1
 
     C                   EVAL      WkCtrDt = BJDNWD - 1
 
     C                   IF        WkCtrDt > BKAPDT
     C                   EVAL      WkCtrDt = BKAPDT
     C                   ENDIF
                                                                                            BUG28036
     C                   ENDIF                                                              BUG28036
 
      ** Write to GETXHH
 
     C                   EVAL      H_RECI = 'H'
     C                   WRITE     APOSTHHF
 
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
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   ENDIF
 
      ** Write Audit Report
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SRAudit
 
     C                   ENDSR
      *****************************************************************                     BUG28036
     C/COPY ZSRSRC,ZCHKHLE                                                                  BUG28036
     C/COPY ZSRSRC,ZACCHLE                                                                  BUG28036
 
