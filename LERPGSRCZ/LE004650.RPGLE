     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee and Discount Amortisation A/C Key Gen')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004650 - Midas LE Fee and Discount Amortisation A/C Key    *
      *             Generation (Non-Linear)                           *
      *                                                               *
      *  Function:  This program calculates for the loan's daily      *
      *             amortisation based on a non-linear method and     *
      *             generates corresponding account keys.             *
      *                                                               *
      *  Called By: LEC004650                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CLE071             Date 18Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 AR1056323          Date 14Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR821740           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 243984             Date 28Oct08               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13408A          Date 12Mar07               *
      *                 BUG13382           Date 28Feb07               *
      *                 BUG13408           Date 28Feb07               *
      *                 BUG13407           Date 28Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 239022             Date 19Jul06               *
      *                 BUG10876           Date 04May06               *
      *                 BUG10875A          Date 12May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10875           Date 16Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 Bug9668            Date 02Jan06               *
      *                 BUG9472            Date 06Dec05               *
      *                 BUG9428            Date 05Dec05               *
      *                 BUG9243            Date 15Nov05               *
      *                 233545             Date 18May05               *
      *                 233601             Date 24May05               *
      *                 232928             Date 08Apr05               *
      *                 233612             Date 20May05               *
      *                 233578             Date 19May05               *
      *                 CAS011             Date 16May05               *
      *                 232771             Date 21Mar05               *
      *                 232630             Date 14Mar05               *
      *                 232628             Date 14Mar05               *
      *                 232348             Date 21Feb05               *
      *                 232309             Date 21Feb05               *
      *                 232307             Date 21Feb05               *
      *                 232306             Date 09Feb05               *
      *                 232305             Date 08Feb05               *
      *                 232304             Date 07Feb05               *
      *                 231712             Date 08Feb05               *
      *                 231710             Date 25Jan05               *
      *                 231708             Date 07Jan05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  243984 - Considered the RAFeesCnt in writing to DB.          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG13408A - Reopen BUG13408. SrFeeReprt subr should not be   *
      *              executed for History record(LEFHST).             *
      *  BUG13382 - Incorrect distribution of discount & fee          *
      *             on LE004650P1 & LE004650P2                        *
      *  BUG13408 - Double take up of account key for the fee amount  *
      *              in the LE004650P1 Report.                        *
      *  BUG13407 - Unrealized P/L on revaluation of loans            *
      *             not reversed on the following day                 *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  239022 - Correction of fix233601 on Hash Totaling. Add the   *
      *           number of records in NORE field and use LKEYFEZ     *
      *           fields not LKEY1ZZ fields.                          *
      *  BUG10876 - Applied part of SC238567                          *
      *  BUG10875A (Reopen) - Receiver value too small to hold result *
      *                      (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10875 - Receiver value too small to hold result           *
      *             (Recompile)                                       *
      *  CLE042 - Extended Loan Sub Type                              *
      *  Bug9668 - Incorrect report details.                          *
      *  BUG9472 - Should exclude non-auto settle fees as events for  *
      *            these fees are not projected.                      *
      *  BUG9428 - Program dumps, "Record 7 member LEFEEDLH already   *
      *            locked to this job".                               *
      *  BUG9243 - LE004650 Dumps when no loans are processed         *
      *            (Applied fix 235242)                               *
      *  233545 - Cut-off Date (Recompile)                            *
      *  233601 - Generate Non Linear account keys.                   *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  233612 - Stop Accruals processing to be included in          *
      *           Nonlinear amortisation computation                  *
      *  233578 - Process loans maturing today and ensure correct     *
      *           postings                                            *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  232771 - Include fees on maturity on the last period         *
      *  232630 - Incorrect non-linear amortization.                  *
      *  232628 - CAS009 Rollover patch (LE).                         *
      *  232348 - Introduce cut-off date for non-linear amortisation  *
      *  232309 - Settlement on LKEYFED is incorrect when fee is a    *
      *           participant fee.                                    *
      *  232307 - Settlement details of the loan are overridden by    *
      *           fee settlement details.                             *
      *  232306 - Wrong value is stored in DSAM, EIAMTD and AFDP      *
      *  232305 - Account keys are not produced for one off fees and  *
      *           discount loan.                                      *
      *  232304 - Make the negative value to positive before adding   *
      *           it to the hash totals.                              *
      *  231712 - Amortisation Processing removed from LE004650       *
      *           ZAAMRTCALC created to do Amortisation computation   *
      *  231710 - Amended to amortise non-linearly accruing and one   *
      *           off fees. Also amortisation will begin at the start *
      *           of the EIR period.                                  *
      *  231708 - Fixed incorrect notation of discounts and premiums  *
      *           in account keys. Due to non-linear computations,    *
      *           discounts and premiums postings can either be       *
      *           positive or negative.                               *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    37         Multi-branch environment                        *
      *                                                               *
      *    98         Date Format                                     *
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *    U7+U8      Database Error                                  *
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
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** LE004650 report files
     FLE004650AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
     FLE004650P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FLE004650P2O    E             PRINTER USROPN
     F                                     INFDS(SPOOL2)
 
      ** Midas LE Loans by branch/loan number
     FCLOANLB   UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Loans File
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CK)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANZ1F)
 
      ** Midas Loan Types/Sub-types Retrieval index
     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Effective Interest Rate Details
     F***LEEIRDL0  UF   E           K DISK    INFSR(*PSSR)                                    233578
     FLEEIRDL8  UF   E           K DISK    INFSR(*PSSR)                                       233578
 
      ** Midas LE Fees File by Loan reference and Fee sequence
     F***LEFEEDLC  UF   E           K DISK    INFSR(*PSSR)                                    CAS011
     FLEFEEDLD  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
 
      ** Midas LE Fees File/History File                                                      233601
     F***LEFEEDLG  UF   E           K DISK    INFSR(*PSSR)                             233601 CAS011
     FLEFEEDLH  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     RENAME(LEFEEDF:LEFEEDDF)                           233601
     F                                     RENAME(LEFHSTF:LEFHSTDF)                           233601
     F                                     INFDS(FEESDS)                                      233601
                                                                                              233601
      ** Midas LE Effective Interest Rate Amortisation File
     FLEEIRAL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Cash Flows Using All-in-Rate                                                231712
     FLECFSFL0  IF   E           K DISK    INFSR(*PSSR)                                       231712
                                                                                              231712
      ** Midas LE Cashflows File for Amortisation Calc                                        231712
     FLEAMRTL0  UF A E           K DISK    INFSR(*PSSR)                                       231712
                                                                                              231712
      ** Midas Re-valued LE Customer Loans by Loan Number
     FLENPVAL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Loans File Copy Pre-Update
     FPETEMPLN  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANRV)
 
      ** Midas Lending Fees History
     FLEFHSTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Facility File "A" Record - By Branch
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FC)
 
      ** Midas LE Actions Today Header file
     FACTN5DH   IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Action File Control
     FACTN5DNL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CO)
 
      ** Midas LE Action File Detail
     FACTN5DKL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC)
 
      ** Midas LE Lending Fee Account Keya Detail
     FLKEYFED   O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F:1)
 
      ** Midas LE Lending Fees Account Keys Trailer
     FLKEYFEZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FZ:2)
 
      ** Midas LE Loan Account Keys Detail
     FLKEY1DP   O  A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LK)
 
      ** Midas LE Loan Account Keys Trailer
     FLKEY1ZZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LZ)
 
      ** Midas Fee Extract Detail for Loans
     FLEPEFLD   UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Fee Extract Trailer for Loans
     FLEPEFLZ   UF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ External data areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** True and False can be used for indicators being on or off
     D True            C                   *ON
     D False           C                   *OFF
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
      /COPY ZACPYSRC,PSDS
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array containing overrides                                                           231712
     D ##OVR           S             56    DIM(2)  CTDATA PERRCD(1)                           231712
                                                                                              231712
      ** Array for determining proportions of amounts and fees
     D WFPropAmt       S             15P 0 DIM(99)
     D WFSeq           S              2  0 DIM(99)
     D**********WFXrate         S             11P 7 DIM(99)                                 BUG13382
     DWFXrate          S             13P 8 DIM(99)                                          BUG13382
     D WFMDin          S              1A   DIM(99)
     D WAmortAmount    S             15P 0 DIM(99)                                            231710
     D WFeePostAmt     S             15P 0 DIM(99)                                            231710
 
      ** File Information Data Structure for LE004620P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for LE004620P2.
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for LE004620AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  OFLLNU               188    189B 0
     D  PRTLNU               367    368B 0
 
     ** File Status Data Structure for LEFEEDLF                                               233601
     D FEESDS          DS                                                                     233601
     D  FEEREC           *RECORD                                                              233601
                                                                                              233601
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for SC Switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for the Hedging ICD
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
 
      ** External data structure for SD Fee Codes
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
 
      ** Account key work data structure/variables
     D WkAkey          DS
     D  WkLTyp                 1      2
     D  WkTyp1                 3      3
     D  WkLSTp                 4      5
     D  WkNlnr                 6      6
     D  WkRcrs                 7      7
     D  WkFCOD                 8      9
     D  Wk7to9                 7      9
     D  WkTyp2                10     10
     D  WkCLAS                11     14                                                       CLE042
 
      *** Divide up start of month date
     D SMDT            DS             6
     D  SMDD                   1      2
     D  SM                     3      4  0
     D  SY                     4      6  0
 
 
      *** Divide up start of month date for U.S.A. format
     D SMDTUS          DS             6
     D  SMUS                   1      2
     D  SMDDUS                 3      4  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** QCMDEXC Parameters                                                                   231712
     D PCommand        S             56A                                                      231712
     D PCmdLen         S             15P 5 INZ(56)                                            231712
                                                                                              231712
      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A
 
      ** Parameter variables for Access objects
     D PRtCd           S              7A
     D POpTn           S              7A
     D PSard           S              6A
     D PBrca           S              3A
     D PCcy            S              3A
 
      ** ZINTDY parameters
     D PRetCdeOut      S             10A
     D PZINDY          S              5P 0
     D PZBEG           S              5P 0
     D PZEND           S              5P 0
     D PZCALC          S              1A
     D***PINT6DY*      S             15P 7                                                    242286
     D PINT6DY         S             15P 9                                                    242286
 
      ** ZDate2 parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
      ** ZSEdit parameters
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
 
      ** ZSFile parameters
     D ZSEQ            S              5A
     D ZSENTY          S              3A
     D ZSNUM           S              6S 0
     D ZSERR           S              1A
 
     D P1OPEN          S              1A
     D P2OPEN          S              1A
     D RQDLN1          S              3S 0
     D RQDLN2          S              3S 0
     D DIFLN1          S              3S 0
     D DIFLN2          S              3S 0
 
      ** Work variables for trailer update
     D ZZAMT           S             15P 3
     D ZZAMTI          S             15P 0
     D ZZAMTD          S              3P 0
     D ZZNEGD          S              5A
     D ZZTOTI          S             15P 0
     D ZZTOTD          S              3P 0
     D ZZWK2           S              4P 0
     D ZZWK3           S             15P 0
 
      ** Work variables
     D WkIntDays       S              5P 0
     D WDaysInYear     S              5P 0
     D***WIntCalcBasis   S              5P 0                                                  231712
     D WCurrentBRCA    S              3A
     D WkPELAP         S              5P 0
     D WDiscLoanF      S              1A
     D WReversAMTPF    S              1A
     D***WAccrdInt       S             15P 0                                                  231712
     D WAllFeePaidTdy  S             17P 0                                                    231710
     D WAllFeeAmts     S             17P 0
     D WAllFeeHist     S             17P 0
     D WkKeyAmt        S             13S 0                                                    233601
     D***WAmrtAmt        S             17P 0                                                  231712
     D***WClnPrcTdy      S              8F                                                    231712
     D***WClnPrcPrv      S              8F                                                    231712
     D***WDrtPrcTdy      S              8F                                                    231712
     D***WDrtPrcPrv      S              8F                                                    231712
     D***WNetPrcpl       S              8F                                                    231712
     D WEvntCtlD       S              5P 0
     D**WFeePostAmt     S             18P 0                                                   231710
     D WAllFeePostAmt  S             18P 0                                                    231710
     D WLoanPostAmt    S             18P 0
     D WkMult          S              3  0
     D WPropTOTI       S             20P 5
     D WkPropSum       S             20P 5
     D WkFeePropSum    S             20P 5
     D WkACAMNT        S             15S 0
     D WkLoanBF        S              1A
     D WkANADJF        S              1A
     D WkNPVAF         S              1A
     D WNewBrcaF       S              1A
     D WLoanReversF    S              1A
     D WUpdCLOAN       S              1A
     D WUpdLEFEE       S              1A
     D WUpdLEEIR       S              1A
     D WkBKAKY         S              4A
     D WSavedInCCY     S              3A
     D WSavedOutCCY    S              3A
     D WIX             S              2S 0
     D WNumOfFees      S              2S 0
     D WkACAMTP        S              2A
     D WInCcy          S              3A
     D WOutCcy         S              3A
     D WInAmt          S             15P 0
     D WOutAmt         S             15P 0
     D WTime           S              4F
     D WkFEAMTD        S             15P 0
 
     D KFEESQ          S              2S 0
     D KRcdT           S              1A
     D KDate           S              5P 0                                                    231712
     D*KLoan****       S              6S 0                                             231712 CLE148
     D KLoan           S              6A                                                      CLE148
     D KFSeq           S              2S 0                                                    231712
 
     D CLE004          S              1A
     D CLE005          S              1A
     D CEU004          S              1A
 
     D WFEAUT          S              1A                                                      CLE134
     D CLE134          S              1A                                                      CLE134
 
      ** ZAAMRTCALC Parameter (Alpha)                                                         231712
     D PAmortDSA       S            200A                                                      231712
                                                                                              231712
      ** ZAAMRTCALC DS breakdown                                                              231712
     D PAmortDS        DS           200                                                       231712
     D  PPGMName                     10A   INZ('LE004650')                                    231712
     D  EIEIR                        15P10                                                    231712
     D  EISTDT                        5P 0                                                    231712
     D  EIENDT                        5P 0                                                    231712
     D  LNRF                                                                                  231712
     D  WMaturityDate                 5P 0                                                    233578
     D  WStartDate                    5P 0                                                    231712
     D  WEndDate                      5P 0                                                    231712
     D  TOTI                         13P 0                                                    231712
     D  WAccInd                       1A   INZ('L')                                           231712
     D  EIDPTD                       15P 0                                                    231712
     D  EICPTD                       15P 0                                                    231712
     D  WIntCalcBasis                 1P 0                                                    231712
     D  WProcType                     1A                                                      231712
     D  WkLoanInd                     1A                                                      232928
     D  PStopAccrualF                 1A                                                      233612
     D  WAmrtAmt                     17P 0                                                    231712
     D  PDrtPrcTdy                   15P 0                                                    231712
     D  PClnPrcTdy                   15P 0                                                    231712
                                                                                              231712
     ICLOANCLF                                                                                232307
     I              RSTM                        FERSTM                                        232307
     I              RONS                        FERONS                                        232307
     I              RIBN                        FERIBN                                        232307
     I              RIBA                        FERIBA                                        232307
     I              ROBN                        FEROBN                                        232307
     I              ROCN                        FEROCN                                        232307
     I              PSTM                        FEPSTM                                        232307
     I              PONS                        FEPONS                                        232307
     I              PIBN                        FEPIBN                                        232307
     I              PIBA                        FEPIBA                                        232307
     I              POBN                        FEPOBN                                        232307
     I              POCN                        FEPOCN                                        232307
     I              RCRN                        FERCRN                                        232307
     I              RCRA                        FERCRA                                        232307
     I              RVNO                        FERVNO                                        232307
     I              AWBN                        FEAWBN                                        232307
     I              AWBA                        FEAWBA                                        232307
     I              BENN                        FEBENN                                        232307
     I              BENA                        FEBENA                                        232307
     I              DTP1                        FEDTP1                                        232307
     I              DTP2                        FEDTP2                                        232307
     I              DTP3                        FEDTP3                                        232307
     I              DTP4                        FEDTP4                                        232307
     I              DCHG                        FEDCHG                                        232307
     I              BTB1                        FEBTB1                                        232307
     I              BTB2                        FEBTB2                                        232307
     I              BTB3                        FEBTB3                                        232307
     I              BTB4                        FEBTB4                                        232307
     I              BTB5                        FEBTB5                                        232307
     I              BTB6                        FEBTB6                                        232307
     I              CVMR                        FECVMR                                        232307
     I              OSDB                        FEOSDB                                        232307
     I              OMDB                        FEOMDB                                        232307
     I              IUSR                        FEIUSR                                        232307
     I              AUSR                        FEAUSR                                        232307
     I              XUSR                        FEXUSR                                        232307
     I              PCRF                        FEPCRF                                        232307
     I              PCOB                        FEPCOB                                        232307
     I              LSWC                        FELSWC                                        232307
     I              LSWS                        FELSWS                                        232307
                                                                                              232307
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      ** MAIN PROCEDURE                                                   *
      *********************************************************************
 
      ** Process all loans whose corresponding amortised cost accounting
      ** indicator in the loan type and subtype file is set to 'Y'
     C                   READ      CLOANLB
 
     C                   DOW       NOT %EOF(CLOANLB)
 
      ** Check if the loan whose Loan Type/Sub Type has been flagged for                      232348
      ** non linear amortisation was entered before the cutoff date                           232348
     C                   IF        FSNLAC > VDAT                                              232348
     C                   READ      CLOANLB                                                    232348
     C                   ITER                                                                 232348
     C                   ENDIF                                                                232348
                                                                                              232348
      ** Initialise flags to update CLOANLB and LEEIRDL0 file
     C                   EVAL      WUpdCLOAN = 'N'
     C                   EVAL      WUpdLEEIR = 'N'
 
     ** Control report processing (open or close reports)
     C                   EXSR      SrReportProc
 
      ** Initially set-up part of account key for loans
     C                   EXSR      SrACKeyInit
 
      ** Process loans that are live or for reversals
     C                   IF        RECI = 'D'
     C                             OR RECI = 'M'                                              232630
     C                             AND MDAT >= BJRDNB                                         232630
 
     C     KLoanTS       CHAIN     SDLOANL1
 
     C                   IF        %FOUND(SDLOANL1) AND
     C                             AYACAI = 'Y'
 
      ** Access current EIR record and process if found and F/D/P amortising
      ** from EIR start date (EIFDPA) is not zero
     C*****LNRF*         CHAIN     LEEIRDL0                                                   233578
     C     LNRF          CHAIN     LEEIRDL8                                                   233578
     C**********         IF        %FOUND(LEEIRDL0) AND                                       233578
     C                   IF        %FOUND(LEEIRDL8) AND                                       233578
     C                             EIRECI =  'D'    AND
     C                             EIFDPA <> *ZERO
     C                             OR %FOUND(LEEIRDL8) AND                                    233578
     C                             EIRECI =  'M'    AND                                       233578
     C                             EIFDPA <> *ZERO                                            233578
     C**********                   OR %FOUND(LEEIRDL0) AND                             232628 233578
     C                             OR %FOUND(LEEIRDL8) AND                                    233578
     C                             EIRECI =  'T'    AND                                       232628
     C                             EIFDPA <> *ZERO                                            232628
 
     ** Process all fee reversals for this loan
     C                   EXSR      SrReverseFee
 
     ** Process today's amortisation
     C                   EXSR      SrAmortise
 
      ** Generate account keys for non-linear amortisation adjustment
      ** not yet posted and unrealised re-valued profit
     C                   EXSR      SrOtherAckey
 
      ** Update loan related files
     C                   IF        WkPropSum <> *ZERO
     C                   EXSR      SrLoanDBUpd
     C                   ENDIF
 
     C                   IF        EIENDT <= WEvntCtlD                                        232628
     C                   EVAL      EIRECI = 'M'                                               232628
     C                   EVAL      WUpdLEEIR = 'Y'                                            232628
     C                   ENDIF                                                                232628
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Update CLOANLB if update flag has been set to 'Y'
     C                   IF        WUpdCLOAN = 'Y'
     C                   UPDATE    CLOANCLF
     C                   ENDIF
 
      ** Update LEEIRDPD if update flag has been set to 'Y'
     C                   IF        WUpdLEEIR = 'Y'
     C                   UPDATE    LEEIRDD0
     C                   ENDIF
 
     ** For reversed loans, generate reversal account keys
     C                   IF        WNewBrcaF = 'Y'
     C                   EXSR      SrReverseLoan
     C                   EVAL      WNewBrcaF = 'N'
     C                   ENDIF
 
      ** Process next Loan detail
     C                   READ      CLOANLB
     C                   ENDDO
 
      ** Close spool files and update trailer files
      ** Only when there are records read                                                    BUG9243
     C**********         IF        RALoanCnt > 0                                      BUG9243 243984
     C                   IF        (RALoanCnt > 0) or (RAFeesCnt > 0)                         243984
     C                   EXSR      SrClsP1
     C                   EXSR      SrClsP2
     C                   UPDATE    LKEY1ZZF
     C                   UPDATE    LKEYFEZF
     C                   ENDIF                                                               BUG9243
 
      ** Process audit report
     C                   EXSR      SrAudit
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrACKeyInit - Initial account key set-up                     *
      *****************************************************************
     C     SrACKeyInit   BEGSR
 
      ** Set Flag for Discount Loans
     C                   IF        PTYP = 63 OR
     C                             PTYP = 65 OR
     C                             PTYP = 67
     C                   EVAL      WDiscLoanF = 'Y'
     C                   ELSE
     C                   EVAL      WDiscLoanF = 'N'
     C                   ENDIF
 
      ** To determine position 6-9 of account key, check for
      ** recourse indicator (CLOANCL), syndication and agent
      ** customer (FCLTYL1). Codes are adopted from SR/LOANA
      ** in LE0450. Value for pos 6-9 is saved to WkBKAKY.
 
     C                   EVAL      WkBKAKY =  *BLANKS
 
      ** Retrieve related record from facilities file
     C     KFacility     CHAIN     FCLTYL1
 
     C                   EVAL      PBRCA = FCBRCA
     C                   EXSR      SrBranch
 
     C                   IF        FCSYIN = 'Y'
 
      ** Set position 8 to 'S' for syndicated. Unless Agent on
      ** Branch is not same as the Agent on the Facility.
     C                   IF        A8SYCU = FCANUM
     C                   IF        RCSI = 'Y'
     C                   EVAL      WkBKAKY =  'RS '
     C                   ELSE
     C                   EVAL      WkBKAKY =  ' S '
     C                   ENDIF
     C                   ELSE
     C                   IF        RCSI = 'Y'
     C                   EVAL      WkBKAKY =  'R  '
     C                   ELSE
     C                   EVAL      WkBKAKY =  '   '
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        RCSI = 'Y'
     C                   EVAL      WkBKAKY =  'R  '
     C                   ELSE
     C                   EVAL      WkBKAKY =  '   '
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReverseFee - Process fee reversals                         *
      *****************************************************************
     C     SrReverseFee  BEGSR
 
      ** Process all fees that have been reversed today
     C*****LNRF          SETLL     LEFEEDLC                                                   CAS011
     C*****LNRF          READE     LEFEEDLC                                                   CAS011
     C     LNRF          SETLL     LEFEEDLD                                                   CAS011
     C     LNRF          READE     LEFEEDLD                                                   CAS011
 
     C**********         DOW       NOT %EOF(LEFEEDLC)                                         CAS011
     C                   DOW       NOT %EOF(LEFEEDLD)                                         CAS011
 
     C                   MOVE      FEAUTO        WFEAUT                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   IF        WFEAUT = 'C' or FEAUT2 = 'C'                               CLE134
     C                   MOVE      'Y'           WFEAUT                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
 
     C                   IF        FERECI = '*'        AND
     C                             FELCHT =  'D'       AND
     C                             FELCHD =  WEvntCtlD AND
     C                             FEORED <> BJRDNB    AND
     C**********                   FELOAN <> *ZERO     AND                                    CLE148
     C                             FELOAN <> *BLANKS   AND                                    CLE148
     C                             FEADJY = 'Y'        AND
     C**********                   FEAUTO = 'Y'        AND                            BUG9472 CLE134
     C                             WFEAUT = 'Y'        AND                                    CLE134
     C                             FEAMTD <> *ZERO
 
      ***Initialise*flag*to*update*LEFEEDLC*file***********************                       CAS011
      ***Initialise flag to update LEFEEDLD file                                              CAS011
     C                   EVAL      WUpdLEFEE = 'N'
 
      ** Generate reversal account key for current fee
     C                   EXSR      SrFeeAcKey
 
     C                   IF        FKEAMT <> *ZERO
      ** Output account key details to report
     C                   EXSR      SrFeeReprt
 
      ** Update fee related files
     C                   EXSR      SrFeeDBUpd
     C                   ENDIF
 
      ** Update LEFEED if update flag has been set to 'Y'
     C                   IF        WUpdLEFEE = 'Y'
     C                   UPDATE    LEFEEDF
     C                   ENDIF
 
     C                   ENDIF
 
     C*****LNRF          READE     LEFEEDLC                                                   CAS011
     C     LNRF          READE     LEFEEDLD                                                   CAS011
     C                   ENDDO
                                                                                              233601
      ** Post reversal for Fee amount to be amortised non-linearly                            233601
                                                                                              233601
     C*****LNRF*         SETLL     LEFEEDLG                                            233601 CAS011
     C*****LNRF*         READE     LEFEEDLG                                            233601 CAS011
     C**********         DOW       NOT %EOF(LEFEEDLG)                                  233601 CAS011
     C**********                   AND %FOUND(LEFEEDLG)                                233601 CAS011
     C     LNRF          SETLL     LEFEEDLH                                                   CAS011
     C     LNRF          READE     LEFEEDLH                                                   CAS011
     C                   DOW       NOT %EOF(LEFEEDLH)                                         CAS011
     C                             AND %FOUND(LEFEEDLH)                                       CAS011
     C                   IF            FERECI = '*'                                           233601
     C                             AND FENLAI = 'Y'                                           233601
      ** Reverse EIR acocunt key                                                            BUG10876
     C                   EVAL      WkTyp1 = 'E'                                             BUG10876
     C                   EVAL      FKEDAT = WEvntCtlD                                       BUG10876
     C                   EVAL      WkKeyAmt = FEFEAM                                          233601
     C                   EVAL      FKREVI = 1                                                 233601
     C                   EXSR      SrFeeAccK                                                  233601
     C                   EXSR      SrFeeReprt                                                 233601
     C                   EVAL      FENLAI = 'R'                                               233601
                                                                                              233601
     C                   IF        FEEREC = 'LEFEEDDF'                                        233601
     C                   UPDATE    LEFEEDDF                                                   233601
     C                   ELSE                                                                 233601
     C                   UPDATE    LEFHSTDF                                                   233601
     C                   ENDIF                                                                233601
     C                   ADD       1             RFeesCnt                                     233601
     C                   ADD       1             RAFeesCnt                                    233601
     C                   ENDIF                                                                233601
                                                                                              233601
     C*****LNRF*         READE     LEFEEDLG                                            233601 CAS011
     C     LNRF          READE     LEFEEDLH                                                   CAS011
     C                   ENDDO                                                                233601
                                                                                              233601
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAmortise - Process loan's amortisation for today           *
      *****************************************************************
     C     SrAmortise    BEGSR
 
      ** Compute for today's amortisation amount
     C                   EXSR      SrGetAmrtAmt
 
      ** Process fee updates and report details
     C                   EVAL      WAllFeePostAmt = 0                                         232306
                                                                                              232306
     C                   IF        WkFeePropSum <> 0
     C                   EXSR      SrProcessFees
     C                   ENDIF
 
      ** Process loan updates and report details
     C                   EVAL      WLoanPostAmt = 0                                           232306
                                                                                              232306
     C                   IF        WDiscLoanF = 'Y' AND
     C                             WPropTOTI <> *ZERO
     C                   EXSR      SrProcessLoan
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReverseLoan - Process loan reversals                       *
      *****************************************************************
     C     SrReverseLoan BEGSR
 
      ** Process all reversed loans today
     C                   READ      PETEMPLN
 
     C                   DOW       NOT %EOF(PETEMPLN)
 
     C                   EVAL      WLoanReversF = 'N'
     C                   IF        RECI = 'R' AND
     C                             BRCA = BRCA AND
     C                             LCD  = WEvntCtlD AND
     C                             AMDS <> *ZERO
 
     C     KLoanTS       CHAIN     SDLOANL1
     C                   IF        %FOUND(SDLOANL1) AND
     C                             AYACAI = 'Y'
 
      ** Initially set-up part of account key for loans
     C                   EXSR      SrACKeyInit
 
     ** Process all fee reversals for this loan
     C                   EXSR      SrReverseFee
 
      ** Set loan reversal flag to 'Y'
     C                   EVAL      WLoanReversF = 'Y'
 
      ** Generate account key for current loan
     C                   EXSR      SrLoanAcKey
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   READ      PETEMPLN
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrGetAmrtAmt - Computes for today's amortisation amount      *
      *                                                               *
      *  Amortisation Amount = D * (1+r)^t   -   D * (1+r)^(t-1)      *
      *                      = Clean Price   -   Previous Clean Price *
      *****************************************************************
     C     SrGetAmrtAmt  BEGSR
 
      ** Codes Relevant to the Computation of the Amortisation Amount has                     231712
      ** been commented out of this program and is now being done in                          231712
      ** ZAAMRTCALC                                                                           231712
                                                                                              231712
      ** Set calculation basis and number of days in a year if not
      ** already determined by 'No. of Days in a Year' in Hedge ICD
     C                   IF        FSNDYR = *BLANK
     C                   EVAL      WIntCalcBasis = ICBS
 
     C**********         SELECT                                                               231712
     C**********         WHEN      WIntCalcBasis = 2 OR                                       231712
     C**********                   WIntCalcBasis = 3 OR                                       231712
     C**********                   WIntCalcBasis = 5                                          231712
     C**********         Z-ADD     360           WDaysInYear                                  231712
     C**********         WHEN      WIntCalcBasis = 1 OR                                       231712
     C**********                   WIntCalcBasis = 4                                          231712
     C**********         Z-ADD     365           WDaysInYear                                  231712
     C**********         WHEN      WIntCalcBasis = 6                                          231712
     C**********         Z-ADD     366           WDaysInYear                                  231712
     C**********         ENDSL                                                                231712
     C                   ENDIF
 
      ** Compute for sum fee amounts and proportion of each fee
     C                   EXSR      SrAllFeeAmts
 
      ** Compute for sum of settled amounts in lending fees history file
     C                   EXSR      SrAllFeeHist
 
      ***Add*proportioned*TOTI*to*the*sum*of*proportioned*fee*amount***                       231710
      ** Set aside total interest (TOTI) amount from loan details                             231710
      ** which will be used later in allocating the amortised amount
      ** across the different postings
     C                   EVAL      WPropTOTI = *ZERO
     C**********         IF        TOTI <> *ZERO                                              231712
     C**********         IF        VDAT < ORED                                                231710
     C**********         EVAL      PZBEG = ORED                                               231710
     C**********         ELSE                                                                 231710
     C**********         EVAL      PZBEG = VDAT                                               231710
     C**********         ENDIF                                                                231710
     C**********         EVAL      PZEND = EIENDT                                             231710
     C**********         EXSR      SrZINTDY                                                   231710
     C**********         IF        BKALDI = 'Y'                                               231710
     C**********         EVAL      WkIntDays = PZINDY                                         231710
     C**********         ELSE                                                                 231710
     C**********         EVAL      WkIntDays = PZINDY + 1                                     231710
     C**********         ENDIF                                                                231710
     C**********         EVAL(R)   WPropTOTI = TOTI / WkIntDays                               231710
     C                   IF        TOTI <> *ZERO                                              231712
     C                   EVAL(R)   WPropTOTI = TOTI                                           231710
     C                   ENDIF
 
      ***Add*proportion*from*Total*Interest*and*sum*of*all*Fees*to*****                       231710
      ***determine*the*sum*of*proportions******************************                       231710
      ** Add saved Total Interest and sum of all Fees associated to the                       231710
      ** loan to determine the total amount to be amortisted. This will                       231710
      ** be used in allocating the amortisation for the day across the                        231710
      ** different postings.                                                                  231710
     C                   EVAL(R)   WkPropSum = WPropTOTI + WkFeePropSum
 
      ***Compute*for*Net*Principal*************************************                       231712
     C**********         EVAL(R)   WNetPrcpl = CPAM - WAllFeePaidTdy - TOTI            231710 231712
     C**********         EVAL(R)   WNetPrcpl = CPAM - WAllFeeAmts - TOTI                      231710
     C**********                               - WAllFeeHist                                  231710
 
      ***Compute*for*Accrued*Interest**********************************                       231712
     C**********         EVAL(R)   WAccrdInt = AIPD - IPRD + AIAP                             231710
     C**********         EVAL(R)   WAccrdInt = AIPD + AIAP                             231710 231712
                                                                                              231710
      **If*last*amortisation*date*is*zero,*use*EIR*period*start*date***                231710 231712
                                                                                              231712
      ** Last Accrual Date is the EIR Start Date when the Last                                231712
      ** Amortisation Date is Zero                                                            231712
     C                   EVAL      KDate = EISTDT                                             231712
     C                   EVAL      WMaturityDate = MDAT                                       233578
     C                   IF        EILADT = *ZERO                                             231710
     C**********         EVAL      EILADT = EISTDT                                     231710 231712
     C                   EVAL      WStartDate = EISTDT                                        231712
     C                   ELSE                                                                 231712
     C                   EVAL      WStartDate = EILADT                                        231712
     C                   ENDIF                                                                231710
 
      ***Compute*for*t*(number*of*days*between*event*control***********                       231712
      ***date*and*value*date).*If*Accrue*on*Last*Day*Indicator*********                       231712
      ***from*SDGELRPD*is*set*to*first*day*accrual,*add*1.*************                       231712
     C**********         MOVE      WIntCalcBasis PZCALC                                       231712
     C**********         EVAL      PZBEG = EILADT                                      231710 231712
     C**********         EVAL      PZEND = WEvntCtlD                                          231712
     C**********         EVAL      PZBEG = EISTDT                                             231710
     C**********         IF        BKALDI <> 'Y'                                              231710
     C**********         EVAL      PZBEG = PZBEG + 1                                          231710
     C**********         ENDIF                                                                231710
     C**********         EXSR      SrZINTDY                                                   231712
                                                                                              231712
      ** Check if the system is set to Last Day Accrual                                       231712
     C                   IF        BKALDI <> 'Y'                                              231710
     C                   EVAL      WAccInd = 'F'                                              231712
     C**********         IF        PZBEG = EISTDT                                      231710 231712
     C**********         EVAL      PZINDY = PZINDY + 1                                 231710 231712
     C**********         ENDIF                                                         231710 231712
     C**********         IF        PZEND = EIENDT                                      231710 231712
     C**********                   AND PZINDY <> 0                                     231710 231712
     C**********         EVAL      PZINDY = PZINDY - 1                                 231710 231712
     C**********         ENDIF                                                         231710 231712
     C                   ENDIF                                                                231710
                                                                                              231710
     C**********         EVAL(R)   WTime = PZINDY/WDaysInYear                                 231712
 
      ***Compute*for*Dirty*Price***************************************                       231712
     C**********         IF        EIDPTD = 0                                          231710 231712
     C**********         EVAL(R)   WDrtPrcTdy = WNetPrcpl * ((1 + EIEIR)                      231712
     C**********                                ** WTime)                                     231712
     C**********         ELSE                                                          231710 231712
     C**********         EVAL(R)   WDrtPrcTdy = EIDPTD * ((1 + EIEIR)                  231710 231712
     C**********                                ** WTime) - WAllFeePaidTdy             231710 231712
     C**********         ENDIF                                                         231710 231712
 
      ***Compute*for*Clean*Price***************************************                       231712
     C**********         EVAL(R)   WClnPrcTdy = WDrtPrcTdy - WAccrdInt                        231712
 
      ***Set*for*Previous*Clean*Price**********************************                       231712
     C**********         EVAL      WClnPrcPrv = EIPRCP                                        231712
 
      ***Finally,*compute*today's*Amortisation*Amount******************                       231712
     C**********         IF        WClnPrcPrv <> *ZERO                                        231712
     C**********         EVAL(R)   WAmrtAmt = WClnPrcTdy - WClnPrcPrv                         231712
     C**********         ELSE                                                                 231712
     C**********         EVAL(R)   WAmrtAmt = WClnPrcTdy - WNetPrcpl                          231712
     C**********         ENDIF                                                                231712
 
      ** Obtain Cashflows from LECFLSPD                                                       231712
     C     KCashFlow     SETLL     LECFSFL0                                                   231712
     C     KCashFlow     READE     LECFSFL0                                                   231712
                                                                                              231712
      ** Write all cashflows from EIR Start to Event Control Date                             231712
     C                   DOW       NOT %EOF(LECFSFL0)                                         231712
     C                             AND LFFLDT <= WEvntCtlD                                    231712
     C                             AND WAccInd = 'L'                                          231712
     C                             OR NOT %EOF(LECFSFL0)                                      231712
     C                             AND LFFLDT <= (WEvntCtlD + 1)                              231712
     C                             AND WAccInd = 'F'                                          231712
                                                                                              231712
      ** Exclude start amount                                                                 231712
     C                   IF        LFFTYP = 'SAMT'                                            231712
     C                             OR LFFTYP = 'SSAM'                                         232628
      ** Non-fees equal to EIR period start date                                              232628
     C                             OR LFFTYP <> 'EFAC' AND LFFTYP <> 'SFAM'                   232628
     C                             AND LFFTYP <> 'SFBT' AND LFFLDT = EISTDT                   232628
      ** Shadow rollover principal only.                                                      232628
     C                             OR LFFTYP = 'ROPR' AND LFFLDT = EISTDT                     232628
                                                                                              232628
     C     LNRF          READE     LECFSFL0                                                   231712
     C                   ITER                                                                 231712
     C                   ENDIF                                                                231712
                                                                                              231712
     C                   EVAL      EPTNMR = LFLNRF                                            231712
     C                   EVAL      EPFLDT = LFFLDT                                            231712
     C                   EVAL      EPCAMT = LFCAMT                                            231712
     C                   EVAL      EPIOIN = LFIOIN                                            231712
                                                                                              231712
      ** Set Cashflow types for ZAAMRTCALC                                                    231712
                                                                                              231712
     C                   SELECT                                                               231712
                                                                                              231712
     C                   WHEN      LFFTYP = 'EFAC'                                            231712
     C                             OR LFFTYP = 'SFAM'                                         231712
     C                             OR LFFTYP = 'SFBT'                                         231712
     C                   EVAL      EPCFTP = 'FEEA'                                            231712
                                                                                              231712
      ** If a cashflow written is a fee that is not in Loan Currency,                         231712
      ** obtain the converted amount from LEEIRAPD before writing                             231712
      ** to ZAAMRTPD                                                                          231712
                                                                                              231712
     C                   IF        LFCYCD <> CCY                                              231712
                                                                                              231712
     C                   EVAL      KLoan = LFLNRF                                             231712
     C                   EVAL      KFSeq = LFFSEQ                                             231712
                                                                                              231712
     C     KLoanFSeq     CHAIN     LEEIRAL4                                                   231712
                                                                                              231712
     C                   IF        %FOUND(LEEIRAL4)                                           231712
     C                   EVAL      EPCAMT = EAAMNT                                            231712
     C                   ENDIF                                                                231712
     C                   ENDIF                                                                231712
                                                                                              231712
     C                   WHEN      LFFTYP = 'SPIN'                                            231712
     C                             OR LFFTYP = 'PINC'                                         231712
     C                             OR LFFTYP = 'SSRP'                                         231712
     C                             OR LFFTYP = 'SRPY'                                         231712
     C                             OR LFFTYP = 'SRPA'                                         231712
     C                             OR LFFTYP = 'RPAY'                                         231712
     C                             OR LFFTYP = 'SPTF'                                         231712
     C                             OR LFFTYP = 'PTFA'                                         231712
     C                             OR LFFTYP = 'SPTT'                                         231712
     C                             OR LFFTYP = 'PTTA'                                         231712
     C                   EVAL      EPCFTP = 'PCPL'                                            231712
                                                                                              232628
     C                   WHEN         LFFTYP = 'INTP'                                         232628
     C                             OR LFFTYP = 'SINT'                                         232628
     C                             OR LFFTYP = 'MINT'                                         232628
     C                             OR LFFTYP = 'SMIN'                                         232628
     C                   EVAL      EPCFTP = 'INTP'                                            232628
                                                                                              231712
     C                   OTHER                                                                231712
     C                   EVAL      EPCFTP = *BLANKS                                           231712
     C                   ENDSL                                                                231712
                                                                                              231712
     C                   IF           LFFTYP = 'ROIN' AND LFFLDT = EISTDT                     232628
     C                   IF           PTYP = 66 OR PTYP = 67 OR PTYP = 69                     232628
     C                   EVAL      EPIOIN = 'I'                                               232628
     C                   ELSE                                                                 232628
     C                   EVAL      EPIOIN = 'O'                                               232628
     C                   ENDIF                                                                232628
     C                   ENDIF                                                                232628
                                                                                              232628
     C                   WRITE     ZAAMRTD0                                                   231712
     C     LNRF          READE     LECFSFL0                                                   231712
                                                                                              231712
     C                   ENDDO                                                                231712
                                                                                              231712
      ** Override LEAMRTPD                                                                    231712
     C                   CALL      'QCMDEXC'                                                  231712
     C                   PARM      ##OVR(1)      PCommand                                     231712
     C                   PARM                    PCmdLen                                      231712
                                                                                              231712
     C                   IF        PTYP = 63 OR PTYP = 65                                     231712
     C                             OR PTYP = 67                                               231712
     C                   EVAL      WProcType = 'D'                                            231712
     C                   ELSE                                                                 231712
     C                   EVAL      WProcType = ' '                                            231712
     C                   ENDIF                                                                231712
                                                                                              231712
     C                   IF        WEvntCtlD < EIENDT                                         232628
     C                   Eval      WEndDate = WEvntCtlD                                       231712
     C                   Else                                                                 232628
     C                   Eval      WEndDate = EIENDT                                          232628
     C                   EndIf                                                                232628
                                                                                              232628
     C                   EVAL      PStopAccrualF = ' '                                        233612
     C                   TESTB     '3'           LONI                     50                  233612
     C                   IF        *IN50 = *ON                                                233612
     C                   EVAL      PStopAccrualF = 'Y'                                        233612
     C                   ENDIF                                                                233612
                                                                                              233612
     C                   EVAL      WkLoanInd  = 'L'                                           232928
     C                   MOVE      PAMORTDS      PAmortDSA                                    231712
                                                                                              231712
      ** Call Amortisation Calculator                                                         231712
     C                   CALLB     'ZAAMRTCALC'                                               231712
     C                   PARM                    PAmortDSA                                    231712
                                                                                              231712
     C                   MOVEL     PAmortDSA     PAMORTDS                                     231712
                                                                                              231712
      ** Update Last Amortisation Date                                                        231712
     C                   EVAL      EILADT = WEndDate                                          231712
     C                   IF        EIAMAJ <> 0                                                231712
     C                   EVAL      WAmrtAmt = WAmrtAmt + EIAMAJ                               231712
     C                   EVAL      EIAMAJ = 0                                                 231712
     C                   ELSE                                                                 231712
     C                   EVAL      WAmrtAmt = WAmrtAmt + EIAMTD                               231712
     C                   ENDIF                                                                231712
                                                                                              231712
      ** Delete Override                                                                      231712
     C                   CALL      'QCMDEXC'                                                  231712
     C                   PARM      ##OVR(2)      PCommand                                     231712
     C                   PARM                    PCmdLen                                      231712
                                                                                              231712
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAllFeeHist - Compute for sum of settled amounts in lending *
      *                 fees history file                             *
      *****************************************************************
     C     SrAllFeeHist  BEGSR
 
      ** Initialise total fee history amount
     C                   EVAL      WAllFeeHist = *ZERO
 
      ** Process all live fees attached to the loan
     C     LNRF          SETLL     LEFHSTL0
     C     LNRF          READE     LEFHSTL0
 
     C                   DOW       NOT %EOF(LEFHSTL0)
 
      ** Process only if associated fee code has its Adjustment
      ** to Yield field set to 'Y'
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    HIFCOD
     C     SDFEE         PARM      SDFEE         DSFDY
 
     C                   IF        AUADJY = 'Y'
 
      ** If loan currency is not the same as fee currency, retrieve
      ** equivalent value from the LE Effective Interest Rate
      ** Amortisation Details file.
     C                   IF        CCY <> HIFCCY
     C     KEffIntR2     CHAIN     LEEIRAL4
     C                   IF        %FOUND(LEEIRAL4)
     C                   EVAL(R)   WAllFeeHist = WAllFeeHist + EAAMNT
     C                   ENDIF
     C                   ELSE
     C                   EVAL(R)   WAllFeeHist = WAllFeeHist + HIAMTS
     C                   ENDIF
     C                   ENDIF
 
     C     LNRF          READE     LEFHSTL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAllFeeAmts - Compute for all fee amounts and save to array *
      *                 to be used for determining proportions        *
      *****************************************************************
     C     SrAllFeeAmts  BEGSR
 
      ** Initialise total fee amount. Also the array and index for
      ** determining proportion of each fee
     C                   EVAL      WAllFeeAmts = *ZERO
     C                   EVAL      WAllFeePaidTdy = *ZERO                                     231710
     C                   EVAL      WFPropAmt (*) = *ZERO
     C                   EVAL      WFSeq(*) = *ZERO
     C                   EVAL      WFXrate(*) = *ZERO
     C                   EVAL      WFMDin(*) = *BLANKS
     C                   EVAL      WAmortAmount(*) = *ZERO                                    231710
     C                   EVAL      WIx = *ZERO
 
      ***Set*end*date*for*determining*number*of*days*for*each*fee******                       231710
     C**********         EVAL      PZEND = EIENDT                                             231710
 
      ** Process all live fees attached to the loan
     C*****LNRF          SETLL     LEFEEDLC                                                   CAS011
     C*****LNRF          READE     LEFEEDLC                                                   CAS011
     C     LNRF          SETLL     LEFEEDLD                                                   CAS011
     C     LNRF          READE(N)  LEFEEDLD                                                  Bug9428
     C*****LNRF*         READE     LEFEEDLD                                           CAS011 Bug9428
 
     C**********         DOW       NOT %EOF(LEFEEDLC)                                         CAS011
     C                   DOW       NOT %EOF(LEFEEDLD)                                         CAS011
 
      ***To*generate*account*keys,*conditions*when*they*were*suppressed                       231710
      ***in*LER130*must*be*met.*Notes*beside*the*conditions*below*are**                       231710
      ***the*subroutines*where*these*were*taken*from*for*reference.****                       231710
     C**********         IF        FERECI = 'D' AND                             MAIN          231710
     C**********                   FECALT = *BLANKS AND                         SR/DETAIL     231710
     C**********                   FEPYON = 'S' AND                             SR/DETAIL     231710
     C**********                   FEADJY = 'Y' AND                             Design        231710
     C**********                   FEPSTD <= WAPDAT AND                         SR/DETAIL     231710
     C**********                   BKAPDT >= BJRDNB AND                         SR/ACCRUE     231710
     C**********                   BKAPDT <  BJDNWD AND                         SR/ACCRUE     231710
     C**********                   FEAMTS <> *ZERO OR                           Design        231710
     C**********                   FERECI = 'D' AND                             MAIN          231710
     C**********                   FECALT = *BLANKS AND                         SR/DETAIL     231710
     C**********                   FEPYON = 'S' AND                             SR/DETAIL     231710
     C**********                   FEADJY = 'Y' AND                             Design        231710
     C**********                   FEPSTD <= WAPDAT AND                         SR/DETAIL     231710
     C**********                   BKAPDT >= BJRDNB AND                         SR/ACCRUE     231710
     C**********                   BKAPDT <  BJDNWD AND                         SR/ACCRUE     231710
     C**********                   FEAMTS = *ZERO AND                           Design        231710
     C**********                   FEDDAT <> 0                                                231710
                                                                                              231710
      ** Compute for all fees settled today.                                                  231710
     C**********         IF        FERECI <> 'R' AND                                  231710 Bug9668
     C                   IF        FERECI <> '*' AND                                         Bug9668
     C**********                   FELOAN <> *ZERO AND                                 231710 CLE148
     C                             FELOAN <> *BLANKS AND                                      CLE148
     C**********                   FEAUTO = 'Y' AND                                   BUG9472 CLE134
     C                             WFEAUT = 'Y' AND                                           CLE134
     C                             FEADJY = 'Y'                                               231710
     C                   IF        FESDAT = WEvntCtlD                                         231710
     C                   EVAL(R)   WAllFeePaidTdy = WAllFeePaidTdy + FEAMTS                   231710
     C                   ENDIF                                                                231710
     C                   IF        FEDDAT = WEvntCtlD                                         231710
     C                   EVAL(R)   WAllFeePaidTdy = WAllFeePaidTdy + FEAMTO                   231710
     C                   ENDIF                                                                231710
     C                   ENDIF                                                                231710
                                                                                              231710
      ** Process all live fees whose cashflow date is within the EIR period.                  231710
     C**********         IF        FERECI <> 'R' AND                                  231710 Bug9668
     C                   IF        FERECI <> '*' AND                                         Bug9668
     C**********                   FELOAN <> *ZERO AND                                 231710 CLE148
     C                             FELOAN <> *BLANKS AND                                      CLE148
     C                             FEADJY = 'Y' AND                                           231710
     C**********                   FEAUTO = 'Y' AND                                   BUG9472 CLE134
     C                             WFEAUT = 'Y' AND                                           CLE134
     C                             FEAMTD <> FEFAMT                                           231710
                                                                                              231710
     C                   IF        FEPYON = 'S' AND                                           231710
     C                             FEPSTD >= EISTDT AND                                       232628
     C                             (MDAT <> EIENDT AND                                        232771
     C                             FEPSTD < EIENDT OR                                         231710
     C                             MDAT = EIENDT AND                                          232771
     C                             FEPSTD <= EIENDT) OR                                       232771
     C                             FEPYON = *BLANK AND                                        231710
     C                             FEPSTD >= EISTDT AND                                       232628
     C                             (MDAT <> EIENDT AND                                        232771
     C                             FEPSTD < EIENDT OR                                         231710
     C                             MDAT = EIENDT AND                                          232771
     C                             FEPSTD <= EIENDT) OR                                       232771
     C                             FEPYON = 'E' AND                                           231710
     C                             FEPEND >= EISTDT AND                                       232628
     C                             (MDAT <> EIENDT AND                                        232771
     C                             FEPEND < EIENDT OR                                         231710
     C                             MDAT = EIENDT AND                                          232771
     C                             FEPEND <= EIENDT) OR                                       232771
     C                             FEPYON = 'N' AND                                           231710
     C                             FENPYD >= EISTDT AND                                       232628
     C                             (MDAT <> EIENDT AND                                        232771
     C                             FENPYD < EIENDT AND                                        231710
     C                             MDAT = EIENDT AND                                          232771
     C                             FEPEND <= EIENDT) OR                                       232771
     C                             FENPYD <> *ZERO OR                                         231710
     C                             FEPYON = 'N' AND                                           231710
     C                             FEPEND >= EISTDT AND                                       232628
     C                             (MDAT <> EIENDT AND                                        232771
     C                             FEPEND < EIENDT AND                                        231710
     C                             MDAT = EIENDT AND                                          232771
     C                             FEPEND <= EIENDT) OR                                       232771
     C                             FENPYD = *ZERO                                             231710
 
      ** Increment array index
     C                   EVAL      WIx = WIx + 1
 
      ***Get*number*of*days*between*EIR*end*date*and*Fee*start*date*to*                       231710
      ***be*used*for*determining*fee's*amortisation*per*day************                       231710
     C**********         IF        FECALC <> *ZERO                                            231710
     C**********         MOVE      FECALC        PZCALC                                       231710
     C**********         ELSE                                                                 231710
     C**********         MOVE      WIntCalcBasis PZCALC                                       231710
     C**********         ENDIF                                                                231710
     C**********         IF        FEPSTD < FEORED                                            231710
     C**********         EVAL      PZBEG = FEORED                                             231710
     C**********         ELSE                                                                 231710
     C**********         EVAL      PZBEG = FEPSTD                                             231710
     C**********         ENDIF                                                                231710
     C**********         EXSR      SrZINTDY                                                   231710
     C**********         IF        BKALDI = 'Y'                                               231710
     C**********         EVAL      WkIntDays = PZINDY                                         231710
     C**********         ELSE                                                                 231710
     C**********         EVAL      WkIntDays = PZINDY + 1                                     231710
     C**********         ENDIF                                                                231710
      *****************************************************************                       231710
      ***Determine*multiplier*to*a*fee's*daily*amortisation.*Significant                      231710
      ***when*fee*starts*on*a*non-working*day*else*multiplier*only*****                       231710
      ***computes*to*1.************************************************                       231710
     C**********         IF        FELADT = *ZERO                                             231710
      **********                                                                              231710
     C**********         IF        FEPSTD < FEORED                                            231710
     C**********         EVAL      WkMult = WEvntCtlD - FEORED                                231710
     C**********         ELSE                                                                 231710
     C**********         EVAL      WkMult = WEvntCtlD - FEPSTD                                231710
     C**********         ENDIF                                                                231710
      **********                                                                              231710
     C**********         IF        BKALDI <> 'Y'                                              231710
     C**********         EVAL      WkMult = WkMult + 1                                        231710
     C**********         ENDIF                                                                231710
      **********                                                                              231710
     C**********         ELSE                                                                 231710
     C**********         EVAL      WkMult = WEvntCtlD - FELADT                                231710
     C**********         ENDIF                                                                231710
 
      ** Store the respective fee sequences to array for chain/update later
     C                   EVAL(R)   WFSeq(WIx) = FEFSEQ
 
      ** If loan currency is not the same as fee currency, retrieve
      ** equivalent value from the LE Effective Interest Rate
      ** Amortisation Details file.                                                           231710
      ***Amortisation*Details*file.*Compute*total*fee*amounts*and******                       231710
      ***also*set*to*each*array*to*its*relative*value*to*determine*****                       231710
      ***proportions*later.*Multiply*with*multiplier*at*the*end.*******                       231710
     C                   IF        (FEPYON <> 'N')                                          BUG13382
     C                   IF        CCY <> FEFCCY
     C     KEffIntR      CHAIN     LEEIRAL4
     C                   IF        %FOUND(LEEIRAL4)
     C**********         EVAL(R)   WFPropAmt(WIx) = EAAMNT / WkIntDays                        231710
     C                   EVAL(R)   WFPropAmt(WIx) = EAAMNT                                    231710
     C                   IF        EAMDIN = 'M'                                               231710
     C                   EVAL(R)   WAmortAmount(WIx)= FEAMTD * EAXRAT                         231710
     C                   ELSE                                                                 231710
     C                   EVAL(R)   WAmortAmount(WIx)= FEAMTD / EAXRAT                         231710
     C                   ENDIF                                                                231710
     C                   EVAL(R)   WAllFeeAmts = WAllFeeAmts + EAAMNT
     C                   EVAL      WFXrate(WIx) = EAXRAT
     C                   EVAL      WFMDin(WIx)  = EAMDIN
     C                   ENDIF
     C                   ELSE
     C                   EVAL(R)   WAmortAmount(WIx)= FEAMTD                                  231710
     C                   IF        FEAMTS <> 0
     C**********         EVAL(R)   WFPropAmt(WIx) = FEAMTS / WkIntDays                        231710
     C                   EVAL(R)   WFPropAmt(WIx) = FEAMTS                                    231710
     C                   EVAL(R)   WAllFeeAmts = WAllFeeAmts + FEAMTS
     C                   ELSE
     C**********         EVAL(R)   WFPropAmt(WIx) = FEFAMT / WkIntDays                        231710
     C                   EVAL(R)   WFPropAmt(WIx) = FEFAMT                                    231710
     C                   EVAL(R)   WAllFeeAmts = WAllFeeAmts + FEFAMT
     C                   ENDIF
     C                   ENDIF
     C
     C                   ELSE                                                               BUG13382
      *                                                                                     BUG13382
      ** Accumulate all fees from Effective Interest Rate Amortisation File                 BUG13382
      *                                                                                     BUG13382
     C                   EVAL(R)   WFPropAmt(WIx) = *ZEROS                                  BUG13382
     C     KEffIntR      SETLL     LEEIRAL4                                                 BUG13382
     C     KEffIntR      READE     LEEIRAL4                                                 BUG13382
     C                   DOW       NOT %EOF(LEEIRAL4)                                       BUG13382
     C                   IF        (EATYPE ='N')                                            BUG13382
     C                   EVAL(R)   WFPropAmt(WIx) = WFPropAmt(WIx) + EAAMNT                 BUG13382
     C                   EVAL(R)   WAllFeeAmts = WAllFeeAmts + EAAMNT                       BUG13382
     C                   ENDIF                                                              BUG13382
     C     KEffIntR      READE     LEEIRAL4                                                 BUG13382
     C                   ENDDO                                                              BUG13382
     C                   EVAL(R)   WAmortAmount(WIx)= FEAMTD                                BUG13382
     C                   ENDIF                                                              BUG13382
     C**********         EVAL      WFPropAmt(WIx) = WFPropAmt(WIx) * WkMult                   231710
     C                   ENDIF
     C                   ENDIF                                                                231710
 
     C*****LNRF          READE     LEFEEDLC                                                   CAS011
     C     LNRF          READE     LEFEEDLD                                                   CAS011
     C                   ENDDO
 
      ** Note down number of fees processed
     C                   EVAL      WNumOfFees = WIx
 
      ** Compute sum of proportioned fee amount
     C                   Z-ADD     0             WkFeePropSum                                 232305
     C                   IF        WIx > *ZERO
     C                   XFOOT     WFPropAmt     WkFeePropSum
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcessFees - Process fee updates and report details       *
      *****************************************************************
     C     SrProcessFees BEGSR
 
      ** Process all fees whose fee details were previously stored in
      ** the fee sequence and amount arrays
     C                   EVAL      WIx = *ZERO
     C                   EVAL      WFeePostAmt(*) = *ZERO                                     231710
     C                   DOW       WNumOfFees > WIx
 
      ** Increment array index
     C                   EVAL      WIx = WIx + 1
 
      ** Calculate proportion of amortised amount to be posted for
      ** the current fee
     C**********         EVAL      WFeePostAmt = (WFPropAmt(WIx)/WkPropSum)                   231710
     C**********                                 * WAmrtAmt                                   231710
     C                   EVAL      WFeePostAmt(WIx) = (WFPropAmt(WIx)/WkPropSum               231710
     C**********                                 * WAmrtAmt)                           231710 231712
     C                                           * WAmrtAmt) - WAmortAmount(WIx)              231712
 
      ** On the fee's last day of amortisation, post the difference
      ** between the fee's settled amount and it's non-linear
      ** amortisation amount to date thus avoid discrepancies between
      ** the final non-linear amortisation to date and settled amount
     C                   IF        EIENDT <= WEvntCtlD
     C                   EVAL      KFeeSq = WFSeq(WIx)                                        233578
     C*****KFees         CHAIN     LEFEEDLC                                            233578 CAS011
     C     KFees         CHAIN     LEFEEDLD                                                   CAS011
     C                   IF        FEAMTS <> 0
     C**********         EVAL      WFeePostAmt = FEAMTS - FEAMTD                              231710
     C                   EVAL      WFeePostAmt(WIx) = FEAMTS - FEAMTD                         231710
     C                   ELSE
     C**********         EVAL      WFeePostAmt = FEFAMT - FEAMTD                              231710
     C                   EVAL      WFeePostAmt(WIx) = FEFAMT - FEAMTD                         231710
     C                   ENDIF
     C                   ENDIF
 
      ** Process only of posting amount is not zero
     C**********         IF        WFeePostAmt <> *ZERO                                       231710
     C                   IF        WFeePostAmt(WIx) <> *ZERO                                  231710
     C                   EVAL      KFeeSq = WFSeq(WIx)
     C*****KFees         CHAIN     LEFEEDLC                                                   CAS011
     C**********         IF        %FOUND(LEFEEDLC)                                           CAS011
     C     KFees         CHAIN     LEFEEDLD                                                   CAS011
     C                   IF        %FOUND(LEFEEDLD)                                           CAS011
 
      ***Initialise*flag*to*update*LEFEEDLC*file***********************
      ** Initialise flag to update LEFEEDLD file                                              CAS011
     C                   EVAL      WUpdLEFEE = 'N'
 
      ** Generate account key for current fee
     C                   EXSR      SrFeeAcKey
 
     C                   IF        FKEAMT <> *ZERO
      ** Output account key details to report
     C                   EXSR      SrFeeReprt
 
      ** Update fee related files
     C                   EXSR      SrFeeDBUpd
     C                   ENDIF
 
      ** Update LEFEED if update flag has been set to 'Y'
     C                   IF        WUpdLEFEE = 'Y'
     C                   UPDATE    LEFEEDF
     C                   ELSE                                                                BUG9428
     C                   UNLOCK    LEFEEDLD                                                  BUG9428
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
                                                                                              231710
      ** Compute sum of posted fee amounts                                                    231710
     C                   IF        WIx > *ZERO                                                231710
     C                   XFOOT     WFeePostAmt   WAllFeePostAmt                               231710
     C                   ENDIF                                                                231710
 
      ** Post Fee amount to be amortised non-linearly                                         233601
                                                                                              233601
     C*****LNRF*         SETLL     LEFEEDLG                                            233601 CAS011
     C*****LNRF*         READE     LEFEEDLG                                            233601 CAS011
     C**********         DOW       NOT %EOF(LEFEEDLG)                                  233601 CAS011
     C**********                   AND %FOUND(LEFEEDLG)                                233601 CAS011
     C     LNRF          SETLL     LEFEEDLH                                                   CAS011
     C     LNRF          READE     LEFEEDLH                                                   CAS011
     C                   DOW       NOT %EOF(LEFEEDLH)                                         CAS011
     C                             AND %FOUND(LEFEEDLH)                                       CAS011
     C                   IF            FERECI <> '*'                                          233601
     C                             AND FENLAI <> 'Y'                                          233601
     C                   EVAL      WkTyp1 = 'E'                                             BUG10876
     C                   EVAL      FKEDAT = WEvntCtlD                                       BUG10876
     C**********         EVAL      WkKeyAmt = FEFEAM                                  233601 Bug9668
     C                   EVAL      WkKeyAmt = FEFAMT                                         Bug9668
     C                   EVAL      FKREVI = 0                                                 233601
     C                   EXSR      SrFeeAccK                                                  233601
      *                                                                                     BUG13408
      ** For recurring fee                                                                  BUG13408
      *                                                                                     BUG13408
     C                   IF        FEEREC = 'LEFEEDDF' AND FEPYON = 'N'                     BUG13408
     C     KEffIntR      SETLL     LEEIRAL4                                                 BUG13408
     C     KEffIntR      READE     LEEIRAL4                                                 BUG13408
     C                   DOW       NOT %EOF(LEEIRAL4)                                       BUG13408
     C                             AND EATYPE = FEPYON                                      BUG13408
     C                   EXSR      SrFeeReprt                                               BUG13408
     C     KEffIntR      READE     LEEIRAL4                                                 BUG13408
     C                   ENDDO                                                              BUG13408
      **                                                                                    BUG13408
      *                                                                                    BUG13408A
      ** SrFeeRprt subroutine should not be executed for LEFHST record                     BUG13408A
      *                                                                                    BUG13408A
     C**********         ELSE                                                     BUG13408 BUG13408A
     C**********         EXSR      SrFeeReprt                                       233601 BUG13408A
     C                   ENDIF                                                              BUG13408
      *                                                                                     BUG13408
     C                   EVAL      FENLAI = 'Y'                                               233601
     C                   IF        FEEREC = 'LEFEEDDF'                                        233601
     C                   UPDATE    LEFEEDDF                                                   233601
     C                   ELSE                                                                 233601
     C                   UPDATE    LEFHSTDF                                                   233601
     C                   ENDIF                                                                233601
     C                   ADD       1             RFeesCnt                                     233601
     C                   ADD       1             RAFeesCnt                                    233601
     C                   ENDIF                                                                233601
     C*****LNRF*         READE     LEFEEDLG                                            233601 CAS011
     C     LNRF          READE     LEFEEDLH                                                   CAS011
     C                   ENDDO                                                                233601
                                                                                              233601
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcessLoan - Process loan updates and report details      *
      *****************************************************************
     C     SrProcessLoan BEGSR
 
      ** Calculate proportion of amortised amount to be posted for
      ** the current loan
     C                   EVAL      WLoanPostAmt = (WPropTOTI/WkPropSum)
     C**********                                   * WAmrtAmt                                 231712
     C**********                                   * WAmrtAmt - AFDP                   231712 232630
     C                                             * WAmrtAmt - AMDS                          232630
 
      ** On the loan's last day of amortisation, post the difference                          231710
      ** between the total interest amount and it's non-linear                                231710
      ** amortisation amount to date thus avoid discrepancies between                         231710
      ** the final non-linear amortisation to date and total interest                         231710
     C                   IF        EIENDT <= WEvntCtlD                                        231710
     C                   EVAL      WLoanPostAmt  = TOTI - AMDS                                231710
     C                   ENDIF                                                                231710
                                                                                              231710
      ** Initialise flag for Reversal amendment type
     C                   EVAL      WReversAMTPF = 'N'
 
      ** Chain action file control
     C     KActTdy       CHAIN     ACTN5DNL0
     C                   IF        %FOUND(ACTN5DNL0)
 
      ** Read thru on file control
     C     KActTdy       SETLL     ACTN5DKL0
     C     KActTdy       READE     ACTN5DKL0
 
     C                   DOW       NOT %EOF(ACTN5DKL0)
 
      ** Set flag to 'Y' if one of the amendment types associated to
      ** the loan is a reversal.
     C                   IF        ACAMTP = 'RV'
     C                   EVAL      WReversAMTPF = 'Y'
     C                   ENDIF
 
      ** Process loan details for Amendment type 'MC' or Multicurrency
      ** rollovers.
     C                   IF        ACAMTP = 'MC'
     C                   EXSR      SrMCcyRoll
     C                   ENDIF
 
      ** Process amendment types where account keys were suppressed in
      ** LE0450 (when non-linear amortisation method is used)
     C                   IF        ACAMTP = 'RE' AND
     C                             ACRLCY <> *BLANKS AND
     C                             ACECIN = 'N' OR
     C                             ACAMTP = 'MA' AND
     C                             COLNMA = 'Y' OR
     C                             ACAMTP = 'LS' OR
     C                             ACAMTP = 'ST' OR
     C                             ACAMTP = 'RO' AND
     C                             PTYP = 63 OR
     C                             ACAMTP = 'RO' AND
     C                             PTYP = 65 AND
     C                             CLE004 = 'Y' OR
     C                             ACAMTP = 'RO' AND
     C                             PTYP = 67 AND
     C                             CLE004 = 'Y'
 
     C                   EVAL      WkACAMTP = ACAMTP
 
      ** Generate account key for current loan
     C                   EXSR      SrLoanAcKey
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
     C                   ENDIF
 
     C     KActTdy       READE     ACTN5DKL0
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        WReversAMTPF = 'N' AND
     C                             WDiscLoanF = 'Y'
 
     C                   EVAL      WkACAMTP = *BLANK
     C                   TESTB     '01'          ACEI                     89
     C     KCLoanB       CHAIN     CLOAN
     C                   IF        %FOUND() AND
     C                             *IN89 = *ON AND
     C                             (CKRECI = 'D' OR
     C                              CKRECI = 'R')
 
      ** Generate account key for current loan
     C                   EVAL      WkLoanBF = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WkLoanBF = 'N'
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrOtherAckey - Generate account keys for non-linear          *
      *                 amortisation adjustment not yet posted        *
      *                 and unrealised re-valued profit               *
      *****************************************************************
     C     SrOtherAckey  BEGSR
 
      ** Generate account key if non-linear amortisation
      ** adjustment not yet posted is not zero
     C                   EVAL      WkANADJF = 'N'
     C                   EVAL      WkACAMTP = *BLANK
     C                   IF        ANADJ <> *ZERO
 
     C                   EVAL      WkANADJF = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WkANADJF = 'N'
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
     C                   ENDIF
 
      ** Generate account key for Unrealised re-valued profit
     C                   EVAL      WkNPVAF  = 'N'
     C     LNRF          CHAIN     LENPVAL0
     C                   IF        %FOUND(LENPVAL0)
 
     C                   EVAL      WkNPVAF  = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WkNPVAF  = 'N'
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFeeAcKey - Generate account key for current fee            *
      *****************************************************************
     C     SrFeeAcKey    BEGSR
 
      ** Initialise LKEYFED fields
     C                   CLEAR                   LKEYFEDF
 
      ** Initialise account key work DS
     C                   EVAL      WkAkey = *BLANKS
 
      ** Set loan type (pos 1-2) and sub type (pos 4-5) for account key
     C                   EVAL      WkLTyp = LTYP
     C                   EVAL      WkLSTp = SUTP
     C                   EVAL      WkCLAS = CLAS                                              CLE042
 
      ** Set position 3 to 'A' to denote an accrual date event and
      ** position 6 to 'N' to denote non-linear amortisation
     C                   EVAL      WkTyp1 = 'A'
     C                   EVAL      WkNlnr = 'N'
 
      ** Set position 7 to 9
     C                   IF        RCSI  = 'R' OR
     C                             RCSI  = 'Y'
     C                   EVAL      WkRcrs = 'R'
     C                   ENDIF
 
     C                   IF        CLE004 = 'Y' AND
     C                             CLE005 = 'Y' AND
     C                             (PTFI = 'I' OR
     C                              PTFI = 'P')
     C                   EVAL      WkRcrs = PTFI
     C                   ENDIF
 
     C                   MOVE      FEFCOD        WkFCOD
     C                   EVAL      WkTyp2 = 'F'
 
      ** Lending Fees account key details
     C                   EVAL      FKRECI = 'L'
     C                   EVAL      FKAKEY = WkAkey
     C                   EVAL      FKLNNO = FELOAN
     C                   EVAL      FKCNUM = FECNUM
     C                   EVAL      FKBRCD = FEBRCA
     C                   EVAL      FKACSQ = LASQ
     C                   EVAL      FKEDAT = WAPDAT
     C                   EVAL      FKECCY = FEFCCY
     C                   EVAL      FKSETP = FESTTL
     C                   EVAL      FKOSAC = FEOURS
                                                                                              232309
     C                   IF        CLE005 = 'Y'                                               232309
                                                                                              232309
     C                   IF        CLE004 = 'N'                                               232309
     C                             OR  CLE004 = 'Y'                                           232309
     C                             AND PTFI = *BLANK                                          232309
     C                   MOVE      OSDB          LKOSBR                                       232309
     C                   MOVE      RONS          LKOSAC                                       232309
     C                   MOVE      RSTM          LKSETP                                       232309
     C                   ENDIF                                                                232309
     C                   IF        CLE004 = 'Y'                                               232309
     C                   IF        PTFI =  'P'                                                232309
     C                   MOVE      OMDB          LKOSBR                                       232309
     C                   MOVE      PONS          LKOSAC                                       232309
     C                   MOVE      PSTM          LKSETP                                       232309
     C                   ENDIF                                                                232309
     C                   IF        PTFI =  'I'                                                232309
     C                   MOVE      *BLANKS       LKOSBR                                       232309
     C                   MOVE      *BLANKS       LKOSAC                                       232309
     C                   MOVE      *BLANKS       LKSETP                                       232309
     C                   ENDIF                                                                232309
     C                   ENDIF                                                                232309
     C                   ENDIF                                                                232309
                                                                                              232309
     C                   EVAL      FKSLID = FEPSTD
 
      ** For reversals, post Non-Linear Amortised Fee to Date
     C                   IF        FERECI = '*'
     C                   EVAL      FKREVI = 1
     C                   EVAL      FKEAMT = FEAMTD
     C                   ELSE
 
      ** else, post Non-Linear Amortised Fee for the day
     C                   EVAL      FKREVI = 0
 
      ** If fee currency is not the same as loan currency, convert amount
      ** to be posted back to fee currency, except for last amortisation
      ** to be posted since value is already in fee currency (this is
      ** determined by the 'EIENDT > WEvntCtlD' condition). Refer to
      ** SR/SrProcessFees to see computation.
     C                   IF        CCY <> FEFCCY AND
     C                             EIENDT > WEvntCtlD
     C                   IF        WFMDin(WIx) = 'M'
     C**********         EVAL(R)   WFeePostAmt = WFeePostAmt / WFXrate(WIx)                   231710
     C                   EVAL(R)   WFeePostAmt(WIx) = WFeePostAmt(WIx) /                      231710
     C                                                WFXrate(WIx)                            231710
     C                   ELSE
     C**********         EVAL(R)   WFeePostAmt = WFeePostAmt * WFXrate(WIx)                   231710
     C                   EVAL(R)   WFeePostAmt(WIx) = WFeePostAmt(WIx) *                      231710
     C                                                WFXrate(WIx)                            231710
     C                   ENDIF
     C                   ENDIF
     C**********         EVAL      FKEAMT = WFeePostAmt                                       231710
     C                   EVAL      FKEAMT = WFeePostAmt(WIx)                                  231710
     C                   ENDIF
 
      ** If the settlement currency is entered and the amount is not 0
      ** then output the settlement currency on the account key
     C                   IF        CEU004 = 'Y' AND
     C                             FESCCY <>  *BLANK AND
     C                             FESCCY <>  FEFCCY AND
     C                             FKEAMT <>  *ZERO
     C                   EVAL      FKSCCY = FESCCY
     C                   ENDIF
 
     C                   IF        FKEAMT <> *ZERO
 
      ** Increment number of fee account key processed
     C                   ADD       1             RFeesCnt
     C                   ADD       1             RAFeesCnt
 
      ** Write new account key to file
     C                   WRITE     LKEYFEDF
 
      ** Update fee account keys trailer
     C                   EXSR      SrFeeAKTrail
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  233601
      *****************************************************************                       233601
      *                                                               *                       233601
      * SrFeeAccK - Generate Account Key Fee amount to be amortised   *                       233601
      *                                                               *                       233601
      *****************************************************************                       233601
                                                                                              233601
     C     SrFeeAccK     BEGSR                                                                233601
                                                                                              233601
     C                   EVAL      WkLtyp = LTYP                                              233601
     C**********         EVAL      WkTyp1 = 'E'                                      233601 BUG10876
     C                   EVAL      WkLSTp = SUTP                                              233601
     C                   EVAL      WkCLAS = CLAS                                              CLE042
     C                   EVAL      WkNlnr = 'N'                                               233601
     C                   EVAL      WkRcrs = *BLANK                                            233601
     C                   IF        RCSI  = 'R' OR                                           BUG10876
     C                             RCSI  = 'Y'                                              BUG10876
     C                   EVAL      WkRcrs = 'R'                                             BUG10876
     C                   ENDIF                                                              BUG10876
     C                   IF        CLE004 = 'Y' AND                                         BUG10876
     C                             CLE005 = 'Y' AND                                         BUG10876
     C                             (PTFI = 'I' OR                                           BUG10876
     C                              PTFI = 'P')                                             BUG10876
     C                   EVAL      WkRcrs = PTFI                                            BUG10876
     C                   ENDIF                                                              BUG10876
     C                   MOVE      FEFCOD        WkFCOD                                       233601
     C                   EVAL      WkTyp2 = 'F'                                               233601
     C**********         EVAL      FKRECI = 'D'                                      233601 BUG10876
     C                   EVAL      FKRECI = 'L'                                             BUG10876
     C                   EVAL      FKAKEY = WkAkey                                            233601
     C                   EVAL      FKLNNO = LNRF                                              233601
     C                   EVAL      FKCNUM = CNUM                                              233601
     C**********         EVAL      FKBRCD = BRCA                                     233601 BUG10876
     C                   EVAL      FKBRCD = FEBRCA                                          BUG10876
     C                   EVAL      FKACSQ = LASQ                                              233601
     C**********         EVAL      FKEDAT = WEvntCtlD                                233601 BUG10876
     C                   EVAL      FKEAMT = WkKeyAmt                                          233601
     C                   EVAL      FKECCY = CCY                                               233601
     C**********         EVAL      FKSETP = SDST                                     233601 BUG10876
     C**********         EVAL      FKOSAC = OSDA                                     233601 BUG10876
     C                   EVAL      FKSETP = FESTTL                                          BUG10876
     C                   EVAL      FKOSAC = FEOURS                                          BUG10876
     C                   EVAL      FKOTHA = 0                                                 233601
     C                   EVAL      FKOTHC = *BLANK                                            233601
     C                   EVAL      FKEXRT = 0                                                 233601
     C                   EVAL      FKSTDT = VDAT                                              233601
     C                   EVAL      FKSLID = FEPSTD                                            233601
     C                   EVAL      FKMDAT = 0                                                 233601
     C                   EVAL      FKBRTT = 0                                                 233601
     C                   EVAL      FKBRTE = 0                                                 233601
     C                   EVAL      FKRTSP = 0                                                 233601
     C                   EVAL      FKINTR = 0                                                 233601
     C                   EVAL      FKSSEQ = 0                                                 233601
     C                   EVAL      FKCPAM = CPAM                                              233601
     C                   EVAL      FKPACD = 0                                                 233601
     C                   EVAL      FKCFTP = *BLANK                                            233601
     C                   EVAL      FKFAMT = 0                                                 233601
     C**********         EVAL      FKPRFC = PRFC                                     233601 BUG10876
     C                   EVAL      FKPRFC = FEPRFC                                          BUG10876
     C                   EVAL      FKOSBR = FEOSBR                                            233601
     C                   EVAL      FKCMPY = *BLANK                                            233601
     C                   EVAL      FKBOKC = BOKC                                              233601
     C                   EVAL      FKADAT = 0                                                 233601
     C                   EVAL      FKSCCY = FESCCY                                            233601
                                                                                            BUG10876
     C                   IF        CLE005 = 'Y'                                             BUG10876
                                                                                            BUG10876
     C                   IF        CLE004 = 'N'                                             BUG10876
     C                             OR  CLE004 = 'Y'                                         BUG10876
     C                             AND PTFI = *BLANK                                        BUG10876
     C                   MOVE      OSDB          LKOSBR                                     BUG10876
     C                   MOVE      RONS          LKOSAC                                     BUG10876
     C                   MOVE      RSTM          LKSETP                                     BUG10876
     C                   ENDIF                                                              BUG10876
     C                   IF        CLE004 = 'Y'                                             BUG10876
     C                   IF        PTFI =  'P'                                              BUG10876
     C                   MOVE      OMDB          LKOSBR                                     BUG10876
     C                   MOVE      PONS          LKOSAC                                     BUG10876
     C                   MOVE      PSTM          LKSETP                                     BUG10876
     C                   ENDIF                                                              BUG10876
     C                   IF        PTFI =  'I'                                              BUG10876
     C                   MOVE      *BLANKS       LKOSBR                                     BUG10876
     C                   MOVE      *BLANKS       LKOSAC                                     BUG10876
     C                   MOVE      *BLANKS       LKSETP                                     BUG10876
     C                   ENDIF                                                              BUG10876
     C                   ENDIF                                                              BUG10876
     C                   ENDIF                                                              BUG10876
                                                                                            BUG10876
     C                   IF        FKEAMT <> *ZERO                                            243984
                                                                                              243984
      ** Increment number of fee account key processed                                        243984
                                                                                              243984
     C                   ADD       1             RFeesCnt                                     243984
     C                   ADD       1             RAFeesCnt                                    243984
      *                                                                                       243984
     C                   WRITE     LKEYFEDF                                                   233601
                                                                                              239022
      ** Update fee account keys trailer                                                      239022
     C                   EXSR      SrFeeAKTrail                                               239022
      *                                                                                       243984
     C                   ENDIF                                                                243984
      *                                                                                       243984
                                                                                              239022
      ***Update Totals*****************************************************************233601 239022
      *********************************************************************************233601 239022
     C**********         EVAL      ZZAMT = WkKeyAmt / 1000                             233601 239022
      *********************************************************************************233601 239022
     C**********         IF        ZZAMT < 0                                           233601 239022
     C**********         Z-SUB     ZZAMT         ZZAMT                                 233601 239022
     C**********         ENDIF                                                         233601 239022
      *********************************************************************************233601 239022
     C**********         Z-ADD     LZVLRF        ZZTOTI                                233601 239022
     C**********         Z-ADD     LZVLRL        ZZTOTD                                233601 239022
     C**********         EXSR      SrGLZAdd                                            233601 239022
     C**********         Z-ADD     ZZTOTI        LZVLRF                                233601 239022
     C**********         Z-ADD     ZZTOTD        LZVLRL                                233601 239022
                                                                                              233601
     C                   ENDSR                                                                233601
                                                                                              233601
      *****************************************************************                       233601
      /EJECT
      *****************************************************************
      *  SrFeeReprt - Output generated account key detail to report   *
      *****************************************************************
     C     SrFeeReprt    BEGSR
 
      ** Initialise report detail fields
     C                   CLEAR                   DETAIL11
 
      ** Set report details fields
     C                   MOVE      FKCNUM        RCNUM
     C                   MOVE      FKLNNO        RLOAN
     C                   MOVE      FEFSEQ        RFSEQ
     C                   MOVE      FKAKEY        RAKEY
     C                   MOVE      FEFCCY        RCCY
     C                   MOVE      FKREVI        RRIND
 
     C                   EVAL      PCCY = RCCY
     C                   MOVE      FKEAMT        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        RAMNT
 
      ** Write P1 header if required
     C                   Z-ADD     8             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETAIL11
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrConvAmnt - Convert 'IN' amount to 'OUT' amount from 'IN'   *
      *               currency to 'OUT' currency. Uses ZXRATE and     *
      *               ZCONV                                           *
      *****************************************************************
     C     SrConvAmnt    BEGSR
 
      ** Get exchange rate and multiply/divide indicator if 'IN' or
      ** 'OUT' currency has changed if either of the previously used
      ** currencies has changed
     C                   IF        WSavedInCCY <> WInCCY OR
     C                             WSavedOutCCY <> WOutCcy
 
      ** Retrieve details of 'IN' currency
     C                   EVAL      PCCY = WInCCY
     C                   EVAL      WSavedInCCY = WInCCY
     C                   EXSR      SrCurrency
 
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   Z-ADD     A6NBDP        ZNBDP1            1 0
 
      ** Retrieve details of 'OUT' currency
     C                   EVAL      PCCY = WOutCcy
     C                   EVAL      WSavedOutCCY = WOutCcy
     C                   EXSR      SrCurrency
 
     C                   MOVE      A6MDIN        ZMDI2
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   Z-ADD     A6NBDP        ZNBDP2            1 0
 
      ** Obtain cross exchange rate & cross multiply/divide indicator
     C                   EXSR      SrZXRATE
     C                   ENDIF
 
      ** Convert 'IN' amount to 'OUT' amount
     C                   MOVE      WInCcy        ZCCYI
     C                   MOVE      WOutCcy       ZCCYO
     C                   Z-ADD     ZNBDP1        ZCDPI
     C                   Z-ADD     ZNBDP2        ZCDPO
     C                   EVAL      ZAMTCI = WInAmt
     C                   EXSR      SrZCONV
 
      ** Set output work amount to converted amount
     C                   EVAL      WOutAmt = ZAMTCO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrMCcyRoll - Multi-Ccy rollover file processing              *
      *****************************************************************
     C     SrMCcyRoll    BEGSR
 
      ** Retrieve Loan B (CLOANCK) record to get new currency (CKNCCY)
     C     KCLoanB       CHAIN     CLOAN
 
      ** Set 'IN' and 'OUT' currencies
     C                   EVAL      WInCcy = CCY
     C                   EVAL      WOutCcy = CKNCCY
 
      ** Reset the following fields based on new currency
     C                   EVAL      WInAMT = TFDP
     C                   EXSR      SrConvAmnt
     C                   EVAL      TFDP   = WOutAmt
 
     C                   EVAL      WInAMT = TFDPA
     C                   EXSR      SrConvAmnt
     C                   EVAL      TFDPA  = WOutAmt
 
     C                   EVAL      WInAMT = TFAM
     C                   EXSR      SrConvAmnt
     C                   EVAL      TFAM   = WOutAmt
 
     C                   EVAL      WInAMT = TFAC
     C                   EXSR      SrConvAmnt
     C                   EVAL      TFAC   = ZAMTCO
 
     C                   EVAL      WInAMT = AFDP - TOTI
     C                   EXSR      SrConvAmnt
     C                   EVAL      AFDP   = WOutAmt
 
     C                   EVAL      WInAMT = CFDP
     C                   EXSR      SrConvAmnt
     C                   EVAL      CFDP   = WOutAmt
 
     C                   EVAL      AMDS   = *ZERO
     C                   EVAL      AMADJ  = *ZERO
     C                   EVAL      ANADJ  = *ZERO
 
      ** Set on flag to update CLOANLB
     C                   EVAL      WUpdCLOAN = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFeeDBUpd - Update fee related files                        *
      *****************************************************************
     C     SrFeeDBUpd    BEGSR
 
      ** File Updates for Reversals
     C                   IF        FERECI = '*'
 
      ** Update LEEIRDL0 file fields
     C     KEffIntR      SETLL     LEEIRAL4
     C     KEffIntR      READE     LEEIRAL4
     C                   DOW       NOT %EOF(LEEIRAL4)
      **                                                                                      231710
      ** All fees are supposed to be amortised, thus no need for this.                        231710
     C**********         IF        EATYPE = 'S'                                               231710
     C                   EVAL      EIFDPA = EIFDPA - EAAMNT
     C**********         ENDIF                                                                231710
     C     KEffIntR      READE     LEEIRAL4
     C                   ENDDO
 
      ** If loan and fee currencies are not the same, compute for the
      ** equivalent of Non-Linear Amortised Fee to Date in loan currency
     C                   EVAL      WkFEAMTD = 0                                               232306
     C                   IF        CCY <> FEFCCY
     C                   IF        EAMDIN = 'M'
     C                   EVAL(R)   WkFEAMTD = FEAMTD * EAXRAT
     C                   ELSE
     C                   EVAL(R)   WkFEAMTD = FEAMTD / EAXRAT
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      EIAMTD = EIAMTD - WkFEAMTD
 
     C                   EVAL      WUpdLEEIR = 'Y'
 
      ** Update CLOANLB file fields
     C                   EVAL      TFDP  = TFDP  - EAAMNT
     C                   EVAL      TFDPA = TFDPA - EAAMNT
     C                   EVAL      TFAM  = TFAM  - EAAMNT
     C                   EVAL      AFDP  = AFDP  - WkFEAMTD
 
     C                   EVAL      WUpdCLOAN = 'Y'
 
      ** Zeroise Non-Linear Amortised Fee to Date to prevent reposting
     C                   EVAL      FEAMTD = *ZERO
 
     C                   EVAL      WUpdLEFEE = 'Y'
 
      ** File Updates for Non-Reversals
     C                   ELSE
 
      ***Update*LEFEEDLC*file******************************************                       CAS011
      ** Update LEFEEDLD file                                                                 CAS011
     C**********         EVAL      FEAMTD = WFeePostAmt + FEAMTD                              231710
     C                   EVAL      FEAMTD = WFeePostAmt(WIx) + FEAMTD                         231710
     C                   EVAL      FEAFES = FEAMTD
     C                   EVAL      FELADT = WEvntCtlD
 
     C                   EVAL      WUpdLEFEE = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLoanAcKey - Generate account key for current loan          *
      *****************************************************************
     C     SrLoanAcKey   BEGSR
 
      ** Initialise LKEY1DP fields
     C                   CLEAR                   LKEY1DPF
 
      ** Initialise account key work DS
     C                   EVAL      WkAkey = *BLANKS
     C                   EVAL      WkACAMNT = *ZERO
 
      ** Set loan type (pos 1-2) and sub type (pos 4-5) for account key
     C                   EVAL      WkLTyp = LTYP
     C                   EVAL      WkLSTp = SUTP
     C                   EVAL      WkCLAS = CLAS                                              CLE042
 
      ** Set position 3 to 'A' to denote an accrual date event
     C                   EVAL      WkTyp1 = 'A'
 
      ** Set position 6 to 'N' for nonlinear
     C                   EVAL      WkNlnr = 'N'
 
      ** Set position 7 to 9
     C                   EVAL      Wk7to9 = WkBKAKY
 
      ** Set fields for LKEY1DP based on output in LE0450
     C                   EVAL      LKRECI  =  'D'
     C                   EVAL      LKLNNO  =  LNRF
     C                   EVAL      LKCNUM  =  CNUM
     C                   EVAL      LKBRCA  =  BRCA
     C                   EVAL      LKACSQ  =  LASQ
     C                   EVAL      LKEDAT  =  ACVDAT
     C                   EVAL      LKECCY  =  CCY
     C                   EVAL      LKSETP  =  ACSETP
     C                   EVAL      LKOSAC  =  ACOSAC
     C                   EVAL      LKREVI  =  *ZERO
     C                   EVAL      LKOTHA  =  *ZERO
     C                   EVAL      LKOTHC  =  *BLANK
     C                   EVAL      LKEXRT  =  *ZERO
     C                   EVAL      LKSTDT  =  VDAT
     C                   EVAL      LKSLID  =  SLID
     C                   EVAL      LKMDAT  =  MDAT
     C                   EVAL      LKBRTT  =  BRTT
     C                   EVAL      LKBRTE  =  BRTE
     C                   EVAL      LKRTSP  =  RTSP
     C                   EVAL      LKINTR  =  INTR
     C                   EVAL      LKSSEQ  =  2
     C                   EVAL      LKCPAM  =  CPAM
     C                   EVAL      LKPACD  =  *ZERO
     C                   EVAL      LKICBS  =  *ZERO
     C                   EVAL      LKACOF  =  ACOF
     C                   EVAL      LKZZ002 =  *BLANKS
     C                   EVAL      LKFACO  =  FACO
     C                   IF        ACFACO <> *BLANKS
     C                   EVAL      LKFACO  =  ACFACO
     C                   ENDIF
     C                   EVAL      LKPRFC  =  PRFC
     C                   EVAL      LKOSBR  =  ACOSBR
     C                   EVAL      LKBOKC  =  BOKC
     C                   EVAL      LKPELAP =  WkPELAP
     C                   EVAL      LKORED  =  ORED
     C                   EVAL      LKOLNO  =  OLNO
     C                   EVAL      LKPTFR  =  PTFR
     C                   EVAL      LKSCCY  =  SCCY
     C                   EVAL      LKANUM  =  FCANUM
     C                   EVAL      LKROLN  =  ACROLN
     C                   EVAL      LKGASS  =  *BLANK
 
      ** Set particular fields for LKEY1DP depending on the amendment
      ** type as coded in LE0450
     C                   SELECT
 
      ** Start Date
     C                   WHEN      WkACAMTP = 'ST'
 
      ** Set pos 3 to 'V' to denote start/value date event
     C                   EVAL      WkTyp1 = 'V'
     C                   EVAL      LKAKEY  =  WkAkey
     C                   EVAL      WkACAMNT = TOTI
 
      ** Repayment Schedule
     C                   WHEN      WkACAMTP = 'RE'
 
     C                   EVAL      WkACAMNT = TOTI + AITC - AMADJ
     C                   EVAL      LKPACD  =  IACD
     C                   EVAL      LKICBS  =  WIntCalcBasis
 
      ** Maturity
     C                   WHEN      WkACAMTP = 'MA'
 
     C**********         EVAL      WkACAMNT = TOTI + AITC - AMADJ                             232630
     C                   EVAL      WkACAMNT = WLoanPostAmt                                    232630
     C                   EVAL      LKPACD  =  IACD
     C                   EVAL      LKICBS  =  WIntCalcBasis
 
      ** Loan Subtype
     C                   WHEN      WkACAMTP = 'LS'
 
      ** For SR/LOANSR in LE0450, 2 account key generations were suppressed
      ** by this enhancement. First was the generation of the old loan type
      ** subtype account key. The other was the generation of the new loan
      ** subtype account key.
     C                   EVAL      WkACAMNT = AMADJ
     C                   EVAL      LKEDAT  =  BJRDNB
 
     C                   EVAL      WkTyp2 = 'D'
     C                   EVAL      LKAKEY  =  WkAkey
     C                   EVAL      LKEAMT  =  WkACAMNT
 
     C**********         IF        WkACAMNT > *ZERO                                           231708
     C                   IF        TOTI > *ZERO                                               231708
     C                   EVAL      WkTyp2 = 'D'
     C                   ELSE
     C                   EVAL      WkTyp2 = 'P'
     C                   EVAL      WkACAMNT = 0 - WkACAMNT
     C                   ENDIF
 
      ** Old loan type/sub type (first account key)
     C                   EVAL      LKREVI  =  1
     C                   IF        LKEAMT <> *ZERO
     C                   ADD       1             RLoanCnt
     C                   ADD       1             RALoanCnt
 
      ** Write new account key to file
     C                   WRITE     LKEY1DPF
 
      ** Update loan account keys trailer
     C                   EXSR      SrLoanAKTrail
 
      ** Write report detail for old loan type/sub type
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
      ** New loan type/sub type (second account key)
     C                   EVAL      LKREVI  =  *ZERO
     C                   EVAL      WkLTyp = ACLTYP
     C                   EVAL      WkLSTp = ACSUTP
     C                   EVAL      WkCLAS = ACCLAS                                            CLE042
 
 
      ** Rollovers
     C                   WHEN      WkACAMTP = 'RO'
 
     C                   EVAL      WkACAMNT = TOTI + AITC - AMADJ
     C                   EVAL      LKMDAT  =  NROD
     C                   EVAL      LKBRTT  =  ACBRTT
     C                   EVAL      LKBRTE  =  ACBRTE
     C                   EVAL      LKRTSP  =  ACRTSP
 
     C                   EVAL      LKPACD  =  IACD
     C                   EVAL      LKICBS  =  WIntCalcBasis
 
      ** Loan 'B' Record
     C                   WHEN      WkLoanBF = 'Y'
 
      ** Posting of daily non-linear amortisation
     C                   EVAL      WkACAMNT = WLoanPostAmt
     C                   EVAL      LKEDAT   =  WEvntCtlD
 
      ** Loan reversals
     C                   WHEN      WLoanReversF = 'Y'
 
     C                   EVAL      LKREVI  =  1
     C                   EVAL      WkACAMNT = AMDS
     C                   EVAL      LKEDAT   =  WEvntCtlD
 
      ** Posting for Non-linear Amortisation Adjustment not yet posted
     C                   WHEN      WkANADJF = 'Y'
 
     C                   EVAL      WkACAMNT = ANADJ
 
      ** Posting for Unrealised revalued profit
     C                   WHEN      WkNPVAF  = 'Y'
 
      ** Reverse posting for Yesterday's Accrued Interest
     C                   EVAL      LKEDAT  =  BJRDNB
     C                   EVAL      WkNlnr = *BLANK
     C                   EVAL      Wk7to9 = ' NU'
 
     C                   IF        YAINT <> *ZERO
     C                   EVAL      WkACAMNT = YAINT
 
     C                   IF        WkACAMNT > *ZERO
     C                   EVAL      WkTyp2 = 'P'
     C                   ELSE
     C                   EVAL      WkTyp2 = 'L'
     C                   EVAL      WkACAMNT = 0 - WkACAMNT
     C                   ENDIF
 
      ** Set account key and event amount                                                   BUG13407
     C                   EVAL      LKAKEY  =  WkAkey                                        BUG13407
     C                   EVAL      LKEAMT  =  WkACAMNT                                      BUG13407
                                                                                            BUG13407
     C                   EVAL      LKREVI  =  1
     C                   IF        LKEAMT <> *ZERO
     C                   ADD       1             RLoanCnt
     C                   ADD       1             RALoanCnt
 
      ** Write new account key to file
     C                   WRITE     LKEY1DPF
 
      ** Update loan account keys trailer
     C                   EXSR      SrLoanAKTrail
 
      ** Write report detail for old loan type/sub type
     C                   EXSR      SrLoanReprt
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      LKREVI  =  *ZERO                                         BUG13407
     C**********         EVAL(R)   YAINT = LNNPVA - WClnPrcTdy                                231712
     C                   EVAL(R)   YAINT = LNNPVA - PClnPrcTdy                                231712
     C                   EVAL      WkACAMNT = YAINT
     C                   EVAL      WUpdCLOAN = 'Y'
 
     C                   ENDSL
 
      ** Determine position 10 of account key accordingly:
      ** For NLA discount/premium not yet posted -> D (+) or C (-)
      ** For Unrealised revalued profit/loss -> P (+) or L (-)
      ** For NLA discount/premium posted -> D (+) or P (-)
     C**********         IF        WkACAMNT > *ZERO                                           231708
     C**********         SELECT                                                               231708
     C**********         WHEN      WkANADJF = 'Y'                                             231708
     C**********         EVAL      WkTyp2 = 'D'                                               231708
     C**********         WHEN      WkNPVAF  = 'Y'                                             231708
     C**********         EVAL      WkTyp2 = 'P'                                               231708
     C**********         OTHER                                                                231708
     C**********         EVAL      WkTyp2 = 'D'                                               231708
     C**********         ENDSL                                                                231708
     C**********         ELSE                                                                 231708
     C**********         SELECT                                                               231708
     C**********         WHEN      WkANADJF = 'Y'                                             231708
     C**********         EVAL      WkTyp2 = 'C'                                               231708
     C**********         WHEN      WkNPVAF  = 'Y'                                             231708
     C**********         EVAL      WkTyp2 = 'L'                                               231708
     C**********         OTHER                                                                231708
     C**********         EVAL      WkTyp2 = 'P'                                               231708
     C**********         ENDSL                                                                231708
     C**********         EVAL      WkACAMNT = 0 - WkACAMNT                                    231708
     C**********         ENDIF                                                                231708
     C                   SELECT                                                               231708
     C                   WHEN      WkANADJF = 'Y'                                             231708
     C                   IF        PTYP <> 67                                                 231708
     C                   EVAL      WkTyp2 = 'D'                                               231708
     C                   ELSE                                                                 231708
     C                   EVAL      WkTyp2 = 'C'                                               231708
     C                   EVAL      WkACAMNT = 0 - WkACAMNT                                    231708
     C                   ENDIF                                                                231708
     C                   WHEN      WkNPVAF  = 'Y'                                             231708
     C                   IF        WkACAMNT > *ZERO                                           231708
     C                   EVAL      WkTyp2 = 'P'                                               231708
     C                   ELSE                                                                 231708
     C                   EVAL      WkTyp2 = 'L'                                               231708
     C                   EVAL      WkACAMNT = 0 - WkACAMNT                                    231708
     C                   ENDIF                                                                231708
     C                   OTHER                                                                231708
     C                   IF        TOTI > *ZERO                                               231708
     C                   EVAL      WkTyp2 = 'D'                                               231708
     C                   ELSE                                                                 231708
     C                   EVAL      WkTyp2 = 'P'                                               231708
     C                   EVAL      WkACAMNT = 0 - WkACAMNT                                    231708
     C                   ENDIF                                                                231708
     C                   ENDSL                                                                231708
 
      ** Set account key and event amount
     C                   EVAL      LKAKEY  =  WkAkey
     C                   EVAL      LKEAMT  =  WkACAMNT
 
     C                   IF        LKEAMT <> *ZERO
 
      ** Increment number of loan account key processed
     C                   ADD       1             RLoanCnt
     C                   ADD       1             RALoanCnt
 
      ** Write new account key to file
     C                   WRITE     LKEY1DPF
 
      ** Update loan account keys trailer
     C                   EXSR      SrLoanAKTrail
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLoanReprt - Output generated account key detail to report  *
      *****************************************************************
     C     SrLoanReprt   BEGSR
 
      ** Initialise report detail fields
     C                   CLEAR                   DETAIL21
 
      ** Set report details fields
     C                   MOVE      LKCNUM        RCNUM
     C                   MOVE      LKLNNO        RLOAN
     C**********         IF        LKOLNO <> *ZERO                                            CLE148
     C                   MOVE      LKOLNO        ROLNO
     C**********         ENDIF                                                                CLE148
     C                   MOVE      LKAKEY        RAKEY
     C                   MOVE      LKEAMT        RAMNT
     C                   MOVE      LKECCY        RCCY
     C                   MOVE      LKREVI        RRIND
 
     C                   EVAL      PCCY = RCCY
     C                   MOVE      LKEAMT        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        RAMNT
 
      ** Write P2 header if required
     C                   Z-ADD     8             RQDLN2
     C     OFLLN2        SUB       PRTLN2        DIFLN2
     C     DIFLN2        IFLE      RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
     C                   WRITE     DETAIL21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLoanDBUpd - Update loan details to file                    *
      *****************************************************************
     C     SrLoanDBUpd   BEGSR
 
      ** For loan reversals no need to update CLOANCL but set record id
      ** for LEEIRDPD to '*'
     C                   IF        CHTP = 'R' AND
     C                             LCD = BJRDNB
     C                   EVAL      WUpdCLOAN = 'N'
 
     C                   EVAL      EIRECI = '*'
     C                   EVAL      WUpdLEEIR = 'Y'
 
     C                   ELSE
 
      ** Update Loan details file for non-reversals
     C**********         EVAL      AFDP = AFDP + WAmrtAmt + ANADJ                             231710
     C**********         EVAL      AMDS = AMDS + WLoanPostAmt + ANADJ                         231710
     C**********         EVAL      AFDP = AFDP + WAllFeePostAmt + WLoanPostAmt         231710 232630
     C                   EVAL      AFDP = WAmrtAmt                                            232630
     C                   EVAL      AMDS = AMDS + WLoanPostAmt                                 231710
     C                   EVAL      AMADJ = AMADJ + ANADJ
     C                   EVAL      DSAM = DSAM - WLoanPostAmt
     C                   EVAL      YMCOST = AMCOST
     C**********         EVAL      AMCOST = WClnPrcTdy                                        231712
     C**********         EVAL      AMCOST = PClnPrcTdy                                 231712 232630
     C                   EVAL      AMCOST = PDrtPrcTdy                                        232630
 
     C                   EVAL      WUpdCLOAN = 'Y'
 
      ** Update EIR details file
     C                   EVAL      EIRECI = RECI
     C**********         EVAL      EIAMTD = WAmrtAmt + EIAMTD + ANADJ                         231710
     C**********         EVAL      EIAMTD = EIAMTD + WAllFeePostAmt +                  231710 231712
     C**********                            WLoanPostAmt                               231710 231712
     C                   EVAL      EIAMTD = WAmrtAmt                                          231712
     C                   EVAL      EIPRCP = EICPTD
     C                   EVAL      EIPRDP = EIDPTD
     C**********         EVAL(R)   EICPTD = WClnPrcTdy                                        231712
     C**********         EVAL(R)   EIDPTD = WDrtPrcTdy                                        231712
     C                   EVAL(R)   EICPTD = PClnPrcTdy                                        231712
     C                   EVAL(R)   EIDPTD = PDrtPrcTdy                                        231712
 
     C                   EVAL      ANADJ = *ZERO
 
     C                   EVAL      WUpdLEEIR = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReportProc - Control open and close of reports            *
      *****************************************************************
     C     SrReportProc  BEGSR
 
      ** Check for change in branch being processed
     C                   IF        BRCA <> WCurrentBRCA
 
      ** Close the previous branch's spool files if any is open
     C                   IF        WCurrentBRCA <> *BLANK
     C                   EXSR      SrClsP1
     C                   EXSR      SrClsP2
     C                   ENDIF
 
      ** Access the next Branch's Details
     C                   EVAL      PBRCA = BRCA
     C                   EXSR      SrBranch
     C                   EVAL      RBRCA = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
 
      ** Open the next branch's spool files
     C                   EXSR      SrOpnP1
     C                   EXSR      SrOpnP2
 
      ** Set current working branch
     C                   EVAL      WCurrentBRCA = BRCA
 
      ** Set new branch flag to 'Y'
     C                   EVAL      WNewBrcaF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZINTDY - Compute number of days between 2 dates            *
      *****************************************************************
     C     SrZINTDY      BEGSR
 
     C                   CALLB     'ZINTDY'
     C                   PARM                    PRetCdeOut
     C                   PARM                    PZINDY
     C                   PARM                    PZBEG
     C                   PARM                    PZEND
     C                   PARM                    PZCALC
     C                   PARM                    PINT6DY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZXRATE - Cross currency rate calculation                   *
      *****************************************************************
     C     SrZXRATE      BEGSR
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM      *ZERO         ZRATEX           13 8
     C                   PARM      *BLANKS       ZMDIX             1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZCONV - Cross currency amount conversion                   *
      *****************************************************************
     C     SrZCONV       BEGSR
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM      ZRATEX        ZEXCH            13 8
     C                   PARM      ZMDIX         ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrReportInit - Report initialisation                         *
      *****************************************************************
     C     SrReportInit  BEGSR
 
      ** Printer file "open" flags
     C                   MOVE      'N'           P1OPEN
     C                   MOVE      'N'           P2OPEN
 
      ** Report work fields
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1
 
     C                   Z-ADD     0             RQDLN2
     C                   Z-ADD     0             DIFLN2
 
      ** Record counts
     C                   Z-ADD     0             RLoanCnt
     C                   Z-ADD     0             RFeesCnt
     C                   Z-ADD     0             RALoanCnt
     C                   Z-ADD     0             RAFeesCnt
 
      ** Current brance being processed
     C                   MOVE      *BLANKS       WCurrentBRCA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SrAudit - Output audit report                                *
      *****************************************************************
     C     SrAudit       BEGSR
 
      ** Ensure report spool file recorded by RCF
     C                   Z-ADD     SFNUMU        ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Output report header
     C                   WRITE     HEADAU
 
     C                   SELECT
 
      ** If DB error occured, print the DB error information
     C                   WHEN      (*INU7 = *ON)
     C                   WRITE     DBERROR
 
      ** If no records read, print "No Details" message
     C                   WHEN      RALoanCnt = *ZERO AND
     C                             RAFeesCnt = *ZERO
     C                   WRITE     NODTLS
 
      ** If records were processed, print file control details
     C                   OTHER
     C                   WRITE     CONTROL
 
     C                   ENDSL
 
      ** Set on last record indicator and end program
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrOpnP1 - Open P1 processing                                 *
      *****************************************************************
     C     SrOpnP1       BEGSR
 
      ** Open P1 printer file
     C                   IF        P1OPEN = 'N'
     C                   OPEN      LE004650P1
     C                   EVAL      P1OPEN = 'Y'
     C                   EVAL      RFeesCnt = *ZERO
     C                   ENDIF
 
      ** Ensure report spool file recorded by RCF
     C                   Z-ADD     SFNUM1        ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program.
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Write header
     C                   WRITE     HEADP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrOpnP2 - Open P2 processing                                 *
      *****************************************************************
     C     SrOpnP2       BEGSR
 
      ** Open P2 printer file
     C                   IF        P2OPEN = 'N'
     C                   OPEN      LE004650P2
     C                   EVAL      P2OPEN = 'Y'
     C                   EVAL      RLoanCnt = *ZERO
     C                   ENDIF
 
      ** Ensure report spool file recorded by RCF
     C                   Z-ADD     SFNUM2        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE2
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Write header
     C                   WRITE     HEADP2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrClsP1 - Close P1 Processing                                *
      *****************************************************************
     C     SrClsP1       BEGSR
 
      ** If no details are generated for this branch, write no details
     C                   IF        RFeesCnt = *ZERO
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     DETAIL13
     C                   ELSE
 
      ** Print number of account keys generated for this branch
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     DETAIL12
     C                   ENDIF
 
      ** Check that sufficient lines remain for the footer. If not,
      ** write out the header on a new page
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write footer
     C                   WRITE     TRAILP1
 
      ** Close the spool file
     C                   IF        P1OPEN = 'Y'
     C                   CLOSE     LE004650P1
     C                   EVAL      P1OPEN = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrClsP2 - Close P2 Processing                                *
      *****************************************************************
     C     SrClsP2       BEGSR
 
      ** If no details are generated for this branch, write no details
     C                   IF        RLoanCnt = *ZERO
     C                   EVAL      RQDLN2 = 4
     C                   EVAL      DIFLN2 = OFLLN2 - PRTLN2
     C                   IF        DIFLN2 <= RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     DETAIL23
     C                   ELSE
 
      ** Print number of account keys generated for this branch
     C                   EVAL      RQDLN2 = 4
     C                   EVAL      DIFLN2 = OFLLN2 - PRTLN2
     C                   IF        DIFLN2 <= RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
     C                   WRITE     DETAIL22
     C                   ENDIF
 
      ** Check that sufficient lines remain for the footer. If not,
      ** write out the header on a new page
     C                   EVAL      RQDLN2 = 4
     C                   EVAL      DIFLN2 = OFLLN2 - PRTLN2
     C                   IF        DIFLN2 <= RQDLN2
     C                   WRITE     HEADP2
     C                   ENDIF
 
      ** Write footer
     C                   WRITE     TRAILP2
 
      ** Close the spool file
     C                   IF        P2OPEN = 'Y'
     C                   CLOSE     LE004650P2
     C                   EVAL      P2OPEN = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrComputeAPD - Compute for accual profit work date. Copied   *
      *                 from SR/INIT in LER130.                       *
      *****************************************************************
     C     SrComputeAPD  BEGSR
 
 
      ** Use previous end of year and month of RUNDAY to check whether
      ** the current month should be used for the array index
     C     BJPEYD        ADD       1             START             5 0
     C                   Z-ADD     START         ZDAYNO
     C                   EXSR      SrZDATE2
     C     ZDATE         IFEQ      *ZERO
     C     ZADATE        ANDEQ     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     START         DBKEY
     C                   MOVEL     'ZDATE2  '    DBFILE
     C                   MOVEL     '009'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     ZDATE         STDTN             6 0
     C                   MOVE      ZADATE        STDTA             7
 
      ** Store the day fields of the start of year date
     C                   MOVEL     STDTA         DDSY              2
 
      ** Set up next working day minus 1
     C     BJDNWD        SUB       1             WNWDS1            5 0
 
      ** Calculate the start of month date by converting the date of
      ** next working day to date format and inserting the start of
      ** year day number
     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   EXSR      SrZDATE2
     C     ZDATE         IFEQ      *ZERO
     C     ZADATE        ANDEQ     *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     BJDNWD        DBKEY
     C                   MOVEL     'ZDATE2  '    DBFILE
     C                   MOVEL     '010'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     ZDATE         WDATE             6 0
     C                   MOVE      ZADATE        GADATE            7
 
      ** If the date format is to be European (DDMMYY) then use the
      ** correct data structure
     C                   MOVE      WDATE         SMDT              6
     C     BJDFIN        IFEQ      'D'
     C                   MOVEL     DDSY          SMDT
 
      ** Divide WDATE (converted date of next working day) by 10000
      ** to get the day number (2 DIGITS)
     C     WDATE         DIV       10000         DNWDDD            2 0
 
     C                   ELSE
 
      ** Otherwise use the U.S.A.-defined date data structure
      ** (MMDDYY) for manipulation.
     C                   MOVE      WDATE         SMDTUS            6
     C                   MOVE      DDSY          SMDDUS
     C                   MOVE      SMDDUS        SMDD
     C                   MOVE      SMUS          SM
 
      ** Divide WDATE (converted date of next working day) by 100
      ** to get the day number (2 DIGITS) by putting the result in a
      ** 2 digit field.
     C     WDATE         DIV       100           DNWDDD            2 0
 
     C                   ENDIF
 
      ** Move the start of year day into a 2 digit field for later comp   E45703
     C                   MOVEL     DDSY          WKDDSY            2 0
 
      ** If the day number of the date of next working
      ** day is less than the start of month day subtract
      ** one from the month number of the date of next working day
      ** this ensures that the conversion and checking of the start
      ** of month date is performed on the current month & not the next
     C     WKDDSY        IFGT      DNWDDD
     C                   SUB       1             SM
     C     SM            IFEQ      0
     C                   Z-ADD     12            SM
     C                   SUB       1             SY
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      SMDT          GDATE             6 0
 
      ** Convert the constructed start date to day format
     C                   MOVE      '0'           GRTCD
     C                   CALL      'LERDATEF'
     C                   PARM                    GDATE
     C                   PARM                    GDAYNO            5 0
     C                   PARM                    GRTCD             1
     C                   Z-ADD     GDAYNO        SMDY              5 0
 
      ** Check whether the start of the new month falls after RUND
      ** and on or before the date of next working day and if so
      ** use the last day of the month as the accrual/profit day
     C     SMDY          IFGT      BJRDNB
     C     SMDY          ANDLE     BJDNWD
     C     BKAPDT        ANDEQ     BJRDNB
     C     SMDY          SUB       1             WAPDAT
     C     SM            SUB       1             A                 2 0
 
     C                   ELSE
     C                   Z-ADD     SM            A
 
      ** Find the lesser of next working day minus 1 and accrual profit
      ** day
     C     BKAPDT        IFLT      WNWDS1
     C                   Z-ADD     BKAPDT        WAPDAT            5 0
     C                   ELSE
     C                   Z-ADD     WNWDS1        WAPDAT
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ZSEdit - Call to 'ZSEDIT'                                    *
      *****************************************************************
     C     ZSEdit        BEGSR
 
     C                   EXSR      SrCurrency
     C                   EVAL      ZDECS = A6NBDP
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZDate2 - Convert day number to date                        *
      *****************************************************************
     C     SrZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrBranch - Retrieve branch details                           *
      *****************************************************************
     C     SrBranch      BEGSR
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBRCHPD'
     C                   EVAL      DBKEY  =  PBRCA
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCurrency - Retrieve Currency Details                       *
      *****************************************************************
     C     SrCurrency    BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRPD'
     C                   EVAL      DBKEY  =  PCCY
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrGLZAdd - Adds a running amount to a total amount           *
      *****************************************************************
     C     SrGLZAdd      BEGSR
 
     C                   IF        ZZAMT = *ZERO
     C                   LEAVESR
     C                   ENDIF
 
      ** Split ZZAMT into integer and decimal fields.
 
     C                   EVAL      ZZAMTI = ZZAMT
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD now contain a 'sign' zone.
 
     C                   EXSR      SrGLZSum
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrGLZSum - Carries out the addition for SrGLZAdd             *
      *****************************************************************
     C     SrGLZSum      BEGSR
 
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF
 
     C                   IF        ZZAMTI = *ZERO AND
     C                             ZZAMTD = *ZERO
     C                   EXSR      SrZSEnd
     C                   LEAVESR
     C                   ENDIF
 
      ** Determine the sign of ZZAMTI & ZZAMTD
 
     C                   IF        ZZAMTI < *ZERO OR
     C                             ZZAMTD < *ZERO
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
 
      ** Determine the sign of ZZTOTI and ZZTOTD
 
     C                   IF        ZZTOTI = *ZERO AND
     C                             ZZTOTD = *ZERO
     C                   EVAL      ZZTOTI = ZZAMTI
     C                   EVAL      ZZTOTD = ZZAMTD
     C                   EXSR      SrZSEnd
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        ZZTOTI < *ZERO OR
     C                             ZZTOTD < *ZERO
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
      ** If the signs differ, bypass overflow checks
 
     C                   IF        *IN91 <> *IN92
     C                   EXSR      SrZOfPs
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      ZZWK2 = ZZAMTD + ZZTOTD
 
     C                   IF        ZZWK2 > 999 OR
     C                             ZZWK2 < -999
 
     C                   IF        *IN92 = *ON
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZAMTI + 1
     C                   ENDIF
 
     C                   EVAL      ZZWK3 = ZZWK3 + ZZTOTI
 
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZTOTI + ZZAMTI
     C                   ENDIF
 
      ** If mod. ZZWK3 is < mod. ZZTOTI, then overflow has occurred.
 
     C                   IF        (*IN92 = *ON AND ZZWK3 > ZZTOTI) OR
     C                             (*IN92 = *OFF AND ZZWK3 < ZZTOTI)
     C                   EVAL      ZZAMT = *ZERO
     C                   EVAL      *IN99 = *ON
     C                   ELSE
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF
 
     C                   EXSR      SrZSEnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZOfPs - Bypass overflow processing for SrGLZSum            *
      *****************************************************************
     C     SrZOfPs       BEGSR
 
      ** If ZZAMT was negative, make it positive for comparison with ZZTOT
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
      ** If ZZTOT was negative, make it positive for comparison with ZZAMT
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** If ZZTOT = ZZAMT, return zero
 
     C                   IF        ZZTOTI = ZZAMTI AND
     C                             ZZTOTD = ZZAMTD
     C                   EVAL      ZZTOTI = *ZERO
     C                   EVAL      ZZTOTD = *ZERO
     C                   EXSR      SrZSEnd
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *IN93 = *OFF
 
     C                   IF        ZZTOTI > ZZAMTI OR
     C                             ZZTOTD > ZZAMTD
 
     C                   EVAL      *IN93 = *ON
 
     C                   IF        ZZAMTD > ZZTOTD
     C                   EVAL      ZZTOTI = ZZTOTI - 1
     C                   EVAL      ZZWK2 = ZZTOTD + 1000
     C                   EVAL      ZZTOTD = ZZWK2 - ZZAMTD
     C                   ELSE
     C                   EVAL      ZZTOTD = ZZTOTD - ZZAMTD
     C                   ENDIF
 
     C                   EVAL      ZZTOTI = ZZTOTI - ZZAMTI
 
     C                   ELSE
 
     C                   IF        ZZTOTD > ZZAMTD
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   EVAL      ZZWK2 = ZZAMTD + 1000
     C                   EVAL      ZZTOTI = ZZWK3 - ZZTOTI
     C                   EVAL      ZZTOTD = ZZWK2 - ZZTOTD
     C                   ELSE
     C                   EVAL      ZZTOTI = ZZAMTI - ZZTOTI
     C                   EVAL      ZZTOTD = ZZAMTD - ZZTOTD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Reverse the sign of ZZTOT if the larger I/P fields were negative
 
     C                   EVAL      *IN94 = *OFF
 
     C                   IF        (*IN93 = *ON AND *IN91 = *ON) OR
     C                             (*IN93 = *OFF AND *IN92 = *ON)
     C                   EVAL      *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Restore the sign of ZZAMTI & ZZAMTD if it was reversed
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
     C                   EXSR      SrZSEnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZSEnd - End processing for SrGLZSum                        *
      *****************************************************************
     C     SrZSEnd       BEGSR
 
      ** If ZZTOTD = zero and ZZTOTI is negatuive, set ZZNEGD
 
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN91 = *OFF
 
     C                   IF        ZZTOTD = *ZERO AND
     C                             ZZTOTI < *ZERO
     C                   EVAL      ZZNEGD = '.000-'
     C                   EVAL      *IN96 = *ON
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrLoanAKTrail - Update loans account key trailer              *
      *****************************************************************
     C     SrLoanAKTrail BEGSR
 
      ** Increment number of records on file
     C                   EVAL      LZNORE = LZNORE + 1
 
      ** Update value of records
     C                   EVAL      ZZAMT  = LKEAMT / 1000
     C                   IF        ZZAMT < 0                                                  232304
     C                   Z-SUB     ZZAMT         ZZAMT                                        232304
     C                   ENDIF                                                                232304
     C                   EVAL      ZZTOTI = LZVLRF
     C                   EVAL      ZZTOTD = LZVLRL
     C                   EXSR      SrGLZAdd
     C                   EVAL      LZVLRF = ZZTOTI
     C                   EVAL      LZVLRL = ZZTOTD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrFeeAkTrail - Update fees account key trailer                *
      *****************************************************************
     C     SrFeeAKTrail  BEGSR
 
      ** Increment number of records on file
     C                   EVAL      FZNORE = FZNORE + 1
 
      ** Update value of records
     C                   EVAL      ZZAMT  = FKEAMT / 1000
     C                   IF        ZZAMT < 0                                                  232304
     C                   Z-SUB     ZZAMT         ZZAMT                                        232304
     C                   ENDIF                                                                232304
     C                   EVAL      ZZTOTI = FZVLRF
     C                   EVAL      ZZTOTD = FZVLRL
     C                   EXSR      SrGLZAdd
     C                   EVAL      FZVLRF = ZZTOTI
     C                   EVAL      FZVLRL = ZZTOTD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Set up standard DB error fields
     C     *LOCK         IN        LDA
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
 
      ** Call access program for bank details - title, run date and
      ** run day number
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  027
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Midas Modules
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSSDY
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check System if Multi-Branch environment
 
     C                   IF        BGMBIN = 'Y'
     C                   SETON                                        32
     C                   ENDIF
 
      ** Access General Ledger details
     C**********         CALL      'AOGELRR0'                                                 CAS011
     C                   CALL      'AOGELRR1'                                                 CAS011
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDGELRPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  262
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CLE004 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CLE004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF    '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SCSARDPD'
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBASE  =  053
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CLE004 = 'Y'
     C                   ELSE
     C                   EVAL      CLE004 = 'N'
     C                   ENDIF
 
      ** Check if CLE005 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CLE005'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF    '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SCSARDPD'
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBASE  =  403
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CLE005 = 'Y'
     C                   ELSE
     C                   EVAL      CLE005 = 'N'
     C                   ENDIF
 
      ** Check if CEU004 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF    '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SCSARDPD'
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBASE  =  258
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CEU004 = 'Y'
     C                   ELSE
     C                   EVAL      CEU004 = 'N'
     C                   ENDIF
      *                                                                                       CLE134
      ** Check if CLE134 is installed                                                         CLE134
      *                                                                                       CLE134
     C                   MOVE      'N'           CLE134                                       CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRtCd                                        CLE134
     C                   PARM      '*VERIFY'     POptn                                        CLE134
     C                   PARM      'CLE134'      PSard                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C                   IF        PRtCd = *BLANKS                                            CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C                   ENDIF                                                                CLE134
 
      ** Access Hedging details
     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDHEDG        PARM      SDHEDG        DSFDY
 
      ** Database error
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHEDGPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  585
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If Amortisation Method is 'L', end program since this only
      ** generates account keys for the Non-linear method
     C                   IF        FSAMRM = 'L'
     C                   EVAL      *INLR  =  *ON
     C                   RETURN
     C                   ENDIF
 
      ** Use the following as calculation basis if No. of days in
      ** a year has been specified in the Hedging ICD file
     C                   IF        FSNDYR <> *BLANK
     C                   MOVE      FSNDYR        WDaysInYear
     C                   SELECT
     C                   WHEN      FSNDYR = '360'
     C                   EVAL      WIntCalcBasis = 3
     C                   WHEN      FSNDYR = '365'
     C                   EVAL      WIntCalcBasis = 4
     C                   WHEN      FSNDYR = '366'
     C                   EVAL      WIntCalcBasis = 6
     C                   ENDSL
     C                   ENDIF
 
      ** Compute for Accrual Profit work date
     C                   EXSR      SrComputeAPD
 
      ** Key list for CLOANCL keyed on loan type and subtype
     C     KLoanTS       KLIST
     C                   KFLD                    LTYP
     C                   KFLD                    SUTP
     C                   KFLD                    CLAS                                         CLE042
 
      ** Key list for LEEIRAL4 keyed on loan number and fee sequence
     C     KEffIntR      KLIST
     C                   KFLD                    FELOAN
     C                   KFLD                    FEFSEQ
 
     C     KEffIntR2     KLIST
     C                   KFLD                    HILNRF
     C                   KFLD                    HIFSEQ
 
      ** Key list for LEEIRAL4 keyed on loan number and fee sequence                          231712
     C     KLoanFSeq     KLIST                                                                231712
     C                   KFLD                    KLoan                                        231712
     C                   KFLD                    KFSeq                                        231712
                                                                                              231712
      ***Key*list*for*LEFEEDLC*keyed*on*loan*number*and*fee*sequence***                       CAS011
      ** Key list for LEFEEDLD keyed on loan number and fee sequence                          CAS011
     C     KFees         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    KFeeSq
 
      ** Key list for CLOAN keyed on loan number and record type = 'B'
     C     KCLoanB       KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    KRcdT
     C                   EVAL      KRCDT = 'B'
 
      ** Key list for LEACT5L0 keyed on branch and loan number
     C     KActTdy       KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    LNRF
 
      ** Key list for FCLTYL1 keyed on facility branch, facility
      ** customer, facility type, and facility sequence
     C     KFacility     KLIST
     C                   KFLD                    FCLB
     C                   KFLD                    FCUS
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ
                                                                                              231712
      ** Key list for LECFSFL0                                                                231712
     C     KCashFlow     KLIST                                                                231712
     C                   KFLD                    LNRF                                         231712
     C                   KFLD                    KDate                                        231712
 
      ** Determine event control date
     C                   EVAL      WEvntCtlD = BJDNWD - 1
     C                   IF        BKAPDT < WEvntCtlD
     C                   EVAL      WEvntCtlD = BKAPDT
     C                   ENDIF
 
      ** Read LE Action file to retrieve Previous profit accrual date
     C                   READ      ACTN5DH
     C                   EVAL      WkPELAP = PELAP
 
      ** Set file pointer to first record in the loans trailer file
     C                   READ      LKEY1ZZ
 
      ** Database error
     C                   IF        %EOF(LKEY1ZZ)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LKEY1ZZ'
     C                   EVAL      DBASE = 445
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set file pointer to first record in the fees trailer file
     C                   READ      LKEYFEZ
 
      ** Database error
     C                   IF        %EOF(LKEYFEZ)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LKEYFEZ'
     C                   EVAL      DBASE = 735
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise report processing
     C                   EXSR      SrReportInit
 
      ** Initialise work variables
     C                   EVAL      WSavedInCCY  = *BLANKS
     C                   EVAL      WSavedOutCCY = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RunBefore = *BLANK
     C                   DUMP
     C                   EVAL      RunBefore = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SrAudit
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
** ##OVR                                                                                      231712
OVRDBF FILE(ZAAMRTL0) TOFILE(LEAMRTL0) SEQONLY(*YES 500)
DLTOVR FILE(ZAAMRTL0)
