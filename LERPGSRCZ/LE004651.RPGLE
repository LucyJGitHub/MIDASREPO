     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Amortised Cost UP/UL and Non-linear Amort')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE004651 - Fee & Discount Non Linear Amort A/C               *
      *                                                               *
      *  Function:  This program calculates for the loan's            *
      *             amortisation (from EIR start date until           *
      *             event control date less amortised amount          *
      *             to date) based on a non-linear method and         *
      *             generates corresponding account keys.             *
      *                                                               *
      *  Called By: LEC004651                                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 AR1056323          Date 14Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR811536           Date 16Sep11               *
      *                 AR814162           Date 05Sep11               *
      *                 AR811215           Date 07Sep11               *
      *                 AR821740           Date 29Aug11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 264058             Date 15Feb10               *
      *                 263866             Date 21Jan10               *
      *                 262652             Date 27Apr09               *
      *                 262625             Date 20Mar09               *
      *                 262621             Date 20Mar09               *
      *                 262608             Date 12Mar09               *
      *                 262607             Date 26Feb09               *
      *                 262600             Date 19Feb09               *
      *                 258620             Date 28Jan09
      *                 258474             Date 17Jan09               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG17315A          Date 14Apr08               *
      *                 BUG17318           Date 04Apr08               *
      *                 BUG17315           Date 03Apr08               *
      *                 CAS019A            Date 26Jul07               *
      *                 248260             Date 21May07               *
      *                 CAS019             Date 20Apr07               *
      *                 240798             Date 21Jun06               *
      *                 240797             Date 21Jun06               *
      *                 240748             Date 06Jun06               *
      *                 CAS016  *CREATE    Date 28Feb06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR811536- Incorrect amortised cost on a loan with fee        *
      *            different from loan currency                       *
      *  AR814162 - Reverse amortised fee amount still reflected in   *
      *             LE004621P1 report                                 *
      *  AR811215- Amortised to date not stored correctly on LEEIRAPD *
      *            for separate fees in ccy different from loan       *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  264058 - Wrong parameters in Override commands, causing      *
      *           wrong Amortised Cost.                               *
      *  263866 - Settlement and Accrual Reversal account keys not    *
      *           produced if next day is a holiday.                  *
      *           Also, 'E' key never reversed.                       *
      *  262652 - File controls out of balance in LE0470 due to       *
      *           LKEYFEZ not being updated.                          *
      *  262625 - Amortised to Date not stored on LEEIRAPD and LEFEED *
      *           for separate fees in currency different from loan.  *
      *  262621 - Use half-adjust to avoid rounding errors            *
      *  262608 - Complete fix 258474 by accessing NPV details file.  *
      *  262607 - Wrong amortisation amount in case of loan prepay-   *
      *           ment                                                *
      *  262600 - Wrong amortisation amount in case of EIR recalcu-   *
      *           lation.                                             *
      *           Field AFDP on CLOANCL updated wrongly.              *
      *           Remove unused files from F specs.                   *
      *           Consider accrued interest at beginning of EIR       *
      *           period.                                             *
      *           Cash flows after EIR Period Start Date ignored.     *
      *  258620 - Wrong Amortised To Date amount in LE004621P1 and    *
      *           xxAyyN_nnF ackey amount should be the difference    *
      *           between today and yesterday's amortisation.         *
      *  258474 - Do not generate non-linear UP/UL when NPV=0 and     *
      *           yield curve=*blanks.                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG17315A - Rounding-off discrepancy                         *
      *  BUG17318 - xxEyyN_nnF account key has incorrect amount       *
      *             Addition of Fee currency in LE004621 Report       *
      *  BUG17315- Amortised F/D/P to date does not exactly match     *
      *            the total per amortised to dates for fees and      *
      *            discounts in LE004621P1(report)                    *
      *  CAS019A - CAS016 Upgrade to Midasplus-Alphanumeric Customer  *
      *  248260 - Amort Separately Fees' EIR not computed correctly   *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  240798 - Surpressed UP/UL posting on last day                *
      *  240797 - Program dumps on Maturity                           *
      *  240748 - Incorrect Amortisation on Interest Payment Dates    *
      *  CAS016 - IAS39 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period)                                       *
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
 
      ** LE004651 report files
     FLE004651AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
     FLE004651P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FLE004651P2O    E             PRINTER USROPN
     F                                     INFDS(SPOOL2)
     FLE004651P3O    E             PRINTER USROPN
     F                                     INFDS(SPOOL3)
 
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
 
      ***Midas*LE*Effective*Interest*Rate*Details**********************                       262600
     F***LEEIRDL8  IF   E           K DISK    INFSR(*PSSR)                                    262600
     F**********                           RENAME(LEEIRDD0:LEEIRDDX)                          262600
     F**********                           PREFIX(F8:2)                                       262600
 
      ** Midas LE Effective Interest Rate Details
     FLEEIRDLD  UF   E           K DISK    INFSR(*PSSR)
 
      ** LE EIR Amortisation Over Period
     FLEERAPL2  UF   E           K DISK    INFSR(*PSSR)
 
      ** LE EIR Amortisation Over Period History File
     FLEERAHPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEERAPD0:LEERAHD0)
 
      ** Midas LE Fees File by Loan reference and Fee sequence
     FLEFEEDLD  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Fees File (Over Life of the loan)
     F***LEFEEDLI  UF   E           K DISK    INFSR(*PSSR)                                    CAS019
     FLEFEEDLN  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     RENAME(LEFEEDF:LEFEEDFI)
 
      ** Midas LE Fees File (Over period)
     FLEFEEDLJ  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDFJ)
 
      ** Midas LE Effective Interest Rate Amortisation File
     FLEEIRAL5  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Cash Flows Using All-in-Rate
     FLECFSFL0  IF   E           K DISK    INFSR(*PSSR)
 
     FLECFSFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LECFLSD0:LECFLSD1)
     F                                     RENAME(LECFLFD0:LECFLFD1)
 
      ** Midas LE Cashflows File for Amortisation Calc
     FLEAMRTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
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
 
      ***Midas*Fee*Extract*Detail*for*Loans****************************                       262600
     F***LEPEFLD   UF   E           K DISK    INFSR(*PSSR)                                    262600
      **********                                                                              262600
      ***Midas*Fee*Extract*Trailer*for*Loans***************************                       262600
     F***LEPEFLZ   UF   E           K DISK    INFSR(*PSSR)                                    262600
 
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
 
      ** Array containing overrides
     D ##OVR           S             80    DIM(5)  CTDATA PERRCD(1)
 
      ** Array for determining proportions of amounts and fees
     D WFPropAmt       S             15P 0 DIM(99)
     D WFSeq           S              2  0 DIM(99)
     D WFXrate         S             11P 7 DIM(99)
     D WFMDin          S              1A   DIM(99)
     D WFAmrtAmtToDt   S             15P 0 DIM(99)
     D WFeePostAmt     S             15P 0 DIM(99)
 
      ** File Information Data Structure for LE004651P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for LE004651P2.
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for LE004651P3.
     D SPOOL3          DS
     D  SFILE3                83     92
     D  SFNUM3               123    124B 0
     D  OFLLN3               188    189B 0
     D  PRTLN3               367    368B 0
 
      ** File Information Data Structure for LE004651AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  OFLLNU               188    189B 0
     D  PRTLNU               367    368B 0
 
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
     D  WkCLAS                11     14                                                       CAS019
 
      ** Divide up start of month date
     D SMDT            DS             6
     D  SMDD                   1      2
     D  SM                     3      4  0
     D  SY                     4      6  0
 
 
      ** Divide up start of month date for U.S.A. format
     D SMDTUS          DS             6
     D  SMUS                   1      2
     D  SMDDUS                 3      4  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** QCMDEXC Parameters
     D PCommand        S             80A
     D PCmdLen         S             15P 5 INZ(80)
 
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
     D PINT6DY         S             15P 7
 
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
     D P1OPEN          S              1A   INZ('N')
     D P2OPEN          S              1A   INZ('N')
     D P3OPEN          S              1A   INZ('N')
     D RQDLN1          S              3S 0
     D RQDLN2          S              3S 0
     D RQDLN3          S              3S 0
     D DIFLN1          S              3S 0
     D DIFLN2          S              3S 0
     D DIFLN3          S              3S 0
 
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
     D WCurrentBRCA    S              3A
     D WkPELAP         S              5P 0
     D WDiscLoanF      S              1A
     D WAllFeeHist     S             17P 0
     D WkKeyAmt        S             13S 0
     D WEvntCtlD       S              5P 0
     D WLoanPostAmt    S             18P 0
     D WkMult          S              3  0
     D WPropTOTI       S             20P 5
     D WkPropSum       S             20P 5
     D WkFeePropSum    S             20P 5
     D WAmortAmount    S             15P 0
     D WkACAMNT        S             15S 0
     D WkANADJF        S              1A
     D WkNPVAF         S              1A
     D WNewBrcaF       S              1A
     D WFAcKeyG        S              1S 0
     D WLoanReversFA   S              1A
     D WLoanReversFT   S              1A
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
     D WAccessF        S              4A
     D WLstDayAmrt     S              1A
     D WPostUPULF      S              1A
     D WAddAcKeyF      S              1A
     D Wx              S              2S 0
 
     D KFEESQ          S              2S 0
     D KRcdT           S              1A
     D KDate           S              5P 0
     D*KLoan****       S              6S 0                                                    CLE148
     D KLoan           S              6A                                                      CLE148
     D KFSeq           S              2S 0
     D KSDate          S                   LIKE(EISTDT)
     D WAmtToDate      S                   LIKE(AFDP)
     D WCheckDt        S                   LIKE(FEPSTD)
     D WkFEFAMT        S                   LIKE(FEFAMT)
     D WAmrtoDate      S                   LIKE(AFDP)
     D WEirStDate      S                   LIKE(EISTDT)
     D WFeePostAmt1    S                   LIKE(FEAMTD)
     D WAmrtToDt1      S                   LIKE(FEAMTD)
     D WDAmrtToDt      S                   LIKE(FEAMTD)
     D WPrevAmrtToDt   S                   LIKE(FEAMTD)
     D WAdjNPos        S                   LIKE(ANADJ)
     D WDiscLonVF      S              1A
     D WLoanProcess    S              1A
     D WLoanReversDP   S              1A
     D WLEFEUpd        S              1A
     D WPrepayment     S              1A                                                      262607
     D WkYAINT         S                   LIKE(YAINT)                                        262608
 
     D CLE004          S              1A
     D CLE005          S              1A
     D CEU004          S              1A
 
     D CLE134          S              1A                                                      CLE134
     D WFEAUT          S              1A                                                      CLE134
 
      ** ZAAMRTCALC Parameter (Alpha)
     D PAmortDSA       S            200A
 
      ** ZAAMRTCALC DS breakdown
     D PAmortDS        DS           200
     D  PPGMName                     10A   INZ('LE004651')
     D  EIEIR                        15P10
     D  EISTDT                        5P 0
     D  EIENDT                        5P 0
     D  LNRF
     D  WMaturityDate                 5P 0
     D  WStartDate                    5P 0
     D  WEndDate                      5P 0
     D  WToti                        13P 0
     D  WAccInd                       1A   INZ('L')
     D  WDirtyPrc                    15P 0
     D  WCleanPrc                    15P 0
     D  WIntCalcBasis                 1P 0
     D  WProcType                     1A
     D  WkLoanInd                     1A
     D  PStopAccrualF                 1A
     D  WAmrtAmt                     17P 0
     D  PDrtPrcTdy                   15P 0
     D  PClnPrcTdy                   15P 0
 
     ICLOANCLF
     I              RSTM                        FERSTM
     I              RONS                        FERONS
     I              RIBN                        FERIBN
     I              RIBA                        FERIBA
     I              ROBN                        FEROBN
     I              ROCN                        FEROCN
     I              PSTM                        FEPSTM
     I              PONS                        FEPONS
     I              PIBN                        FEPIBN
     I              PIBA                        FEPIBA
     I              POBN                        FEPOBN
     I              POCN                        FEPOCN
     I              RCRN                        FERCRN
     I              RCRA                        FERCRA
     I              RVNO                        FERVNO
     I              AWBN                        FEAWBN
     I              AWBA                        FEAWBA
     I              BENN                        FEBENN
     I              BENA                        FEBENA
     I              DTP1                        FEDTP1
     I              DTP2                        FEDTP2
     I              DTP3                        FEDTP3
     I              DTP4                        FEDTP4
     I              DCHG                        FEDCHG
     I              BTB1                        FEBTB1
     I              BTB2                        FEBTB2
     I              BTB3                        FEBTB3
     I              BTB4                        FEBTB4
     I              BTB5                        FEBTB5
     I              BTB6                        FEBTB6
     I              CVMR                        FECVMR
     I              OSDB                        FEOSDB
     I              OMDB                        FEOMDB
     I              IUSR                        FEIUSR
     I              AUSR                        FEAUSR
     I              XUSR                        FEXUSR
     I              PCRF                        FEPCRF
     I              PCOB                        FEPCOB
     I              LSWC                        FELSWC
     I              LSWS                        FELSWS
 
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
 
      ** Check if the loan whose Loan Type/Sub Type has been flagged for
      ** non linear amortisation was entered before the cutoff date
     C                   IF        FSNLAC > VDAT
     C                   READ      CLOANLB
     C                   ITER
     C                   ENDIF
 
      ** Initialise flags to update CLOANLB and LEEIRDLD file
     C                   EVAL      WUpdCLOAN = 'N'
     C                   EVAL      WUpdLEEIR = 'N'
     C                   EVAL      WAccessF = *BLANKS
     C                   EVAL      WLoanProcess = 'N'
     C                   EVAL      WPostUPULF = *BLANK
     C                   EVAL      WToti = *ZEROS                                             240748
     C                   EVAL      WkANADJF = 'N'                                             240748
     C                   EVAL      WAdjNPos = *ZEROS                                          240748
     C                   EVAL      WkYAINT = *ZEROS                                           262608
     C                   EVAL      WPrepayment = 'N'                                          262607
     C                   IF        CPAM = *ZERO                                               262607
     C                             AND VDAT < BJRDNB                                          262607
     C                   EVAL      WPrepayment = 'Y'                                          262607
     C                   ENDIF                                                                262607
 
     ** Control report processing (open or close reports)
     C                   EXSR      SrReportProc
 
      ** Initially set-up part of account key for loans
     C                   EXSR      SrACKeyInit
 
      ** Process loans that are live or matured today
     C                   IF        RECI = 'D'
     C                             OR RECI = 'M'
     C                             AND MDAT >= BJRDNB
 
      ** Check if Amortised Cost Accounting indicator is 'Y'
     C     KLoanTS       CHAIN     SDLOANL1
     C                   IF        %FOUND(SDLOANL1) AND
     C                             AYACAI = 'Y'
 
      ** If Discounted Loan and Value Date is on or before Event Control Date
      ** and Non-linear Amortisation is 0, generate Settlement Account key
     C                   EVAL      WDiscLonVF = 'N'
 
     C                   IF        WDiscLoanF = 'Y' AND
     C                             VDAT <= WEvntCtlD AND
     C                             AMDS = *ZERO
     C                   EVAL      WDiscLonVF = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WDiscLonVF = 'N'
 
      ** Generate Report
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
     C                   ENDIF
 
     ** Process all fee reversals for this loan
     C                   EXSR      SrReverseFee
 
      ** Generate Additional Account Keys
     C                   EXSR      SrFeeAckyGen
 
     C                   EVAL      WAddAcKeyF = *BLANK
 
     ** Process today's amortisation (Over Life)
     C                   EXSR      SrEIRDProc
 
     ** Generate UP/UL account keys and report for loan
     C                   IF        WAccessF = 'EIRD'
     C                   EVAL      WPostUPULF = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WPostUPULF = 'N'
 
      ** Generate account key if non-linear amortisation
      ** adjustment not yet posted is not zero
     C                   IF        WAdjNPos <> *ZERO
 
     C                   EVAL      WkANADJF = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WkANADJF = 'N'
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
     C                   ENDIF
     C
     C                   ENDIF
 
      ** Update LEEIRDPD if update flag has been set to 'Y'
     C                   IF        WUpdLEEIR = 'Y'
     C                   UPDATE    LEEIRDD0
     C                   ENDIF
 
     ** Process today's amortisation (Over Period)
     C                   EXSR      SrERAPProc
 
      ** Update CLOANLB if update flag has been set to 'Y'
     C                   IF        WUpdCLOAN = 'Y'
     C                   EVAL      YAINT  = WkYAINT                                           262608
     C                   UPDATE    CLOANCLF
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDIF
 
      ** For reversed loans, generate reversal account keys
     C                   IF        WNewBrcaF = 'Y'
     C                   EXSR      SrReverseLoan
     C                   EVAL      WNewBrcaF = 'N'
     C                   ENDIF
 
     C                   READ      CLOANLB
     C                   ENDDO
 
      ** Close spool files and update trailer files
      ** Only when there are records read
     C**********         IF        RALoanCnt > 0                                              262652
     C                   IF        (RALoanCnt > 0) or (RAFeesCnt > 0)                         262652
     C                   EXSR      SrClsP1
     C                   EXSR      SrClsP2
     C                   EXSR      SrClsP3
     C                   UPDATE    LKEY1ZZF
     C                   UPDATE    LKEYFEZF
     C                   ENDIF
 
      ** Process audit report
     C                   EXSR      SrAudit
 
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrACKeyInit - Initial account key set-up                     *
      *****************************************************************
     C     SrACKeyInit   BEGSR
                                                                                              262608
      ** Access NPV details file                                                              262608
     C                   CLEAR     *ALL          LENPVAD0                                     262608
     C     LNRF          CHAIN     LENPVAL0                                                   262608
 
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
      *  SrReverseLoan - Process loan reversals                       *
      *****************************************************************
     C     SrReverseLoan BEGSR
 
      ** Process all reversed loans today
     C                   READ      PETEMPLN
 
     C                   DOW       NOT %EOF(PETEMPLN)
 
     C                   EVAL      WLoanReversFA = 'N'
     C                   EVAL      WLoanReversFT = 'N'
     C                   EVAL      WLoanReversDP = 'N'
     C
     C                   IF        RECI = 'R' AND
     C                             BRCA = WCurrentBRCA AND
     C                             LCD  = WEvntCtlD AND
     C                             AMDS <> *ZERO
 
      ** Check if Amortised Cost Accounting indicator is 'Y'
     C     KLoanTS       CHAIN     SDLOANL1
     C                   IF        %FOUND(SDLOANL1) AND
     C                             AYACAI = 'Y'
 
      ** Initially set-up part of account key for loans
     C                   EXSR      SrACKeyInit
 
     ** Process all fee reversals for this loan
     C                   EXSR      SrReverseFee
 
      ** Set loan reversal flag to 'Y' (for the Amortised Amount - AMDS)
      ** Generate account key for current loan
     C                   EVAL      WLoanReversFA = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WLoanReversFA = 'N'
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
      ** Set loan reversal flag to 'Y' (for the Discount Amount - TOTI)
      ** Generate account key for current loan
     C                   EVAL      WLoanReversFT = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WLoanReversFT = 'N'
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
      ** Set loan reversal flag to 'Y' (for the Dirty Price - UP/UL)
      ** Generate account key for current loan
     C                   EVAL      WLoanReversDP = 'Y'
     C                   EXSR      SrLoanAcKey
     C                   EVAL      WLoanReversDP = 'N'
 
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
      *  SrReportProc - Control open and close of reports            *
      *****************************************************************
     C     SrReportProc  BEGSR
 
      ** Check for change in branch being processed
     C                   IF        BRCA <> WCurrentBRCA
 
      ** Close the previous branch's spool files if any is open
     C                   IF        WCurrentBRCA <> *BLANK
     C                   EXSR      SrClsP1
     C                   EXSR      SrClsP2
     C                   EXSR      SrClsP3
     C                   ENDIF
 
      ** Access the next Branch's Details
     C                   EVAL      PBRCA = BRCA
     C                   EXSR      SrBranch
     C                   EVAL      RBRCA = A8BRCD
     C                   EVAL      RBRNM = A8BRNM
 
      ** Open the next branch's spool files
     C                   EXSR      SrOpnP1
     C                   EXSR      SrOpnP2
     C                   EXSR      SrOpnP3
 
      ** Set current working branch
     C                   EVAL      WCurrentBRCA = BRCA
 
      ** Set new branch flag to 'Y'
     C                   EVAL      WNewBrcaF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrClsP1 - Close P1 Processing                                *
      *****************************************************************
     C     SrClsP1       BEGSR
 
      ** If no details are generated for this branch, write no details
     C                   IF        RFeesCnt1 = *ZERO
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
     C                   CLOSE     LE004651P1
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
     C                   IF        RFeesCnt2 = *ZERO
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
     C                   CLOSE     LE004651P2
     C                   EVAL      P2OPEN = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrClsP3 - Close P3 Processing                                *
      *****************************************************************
     C     SrClsP3       BEGSR
 
      ** If no details are generated for this branch, write no details
     C                   IF        RLoanCnt = *ZERO
     C                   EVAL      RQDLN3 = 4
     C                   EVAL      DIFLN3 = OFLLN3 - PRTLN3
     C                   IF        DIFLN3 <= RQDLN3
     C                   WRITE     HEADP3
     C                   ENDIF
     C                   WRITE     DETAIL33
     C                   ELSE
 
      ** Print number of account keys generated for this branch
     C                   EVAL      RQDLN3 = 4
     C                   EVAL      DIFLN3 = OFLLN3 - PRTLN3
     C                   IF        DIFLN3 <= RQDLN3
     C                   WRITE     HEADP3
     C                   ENDIF
     C                   WRITE     DETAIL32
     C                   ENDIF
 
      ** Check that sufficient lines remain for the footer. If not,
      ** write out the header on a new page
     C                   EVAL      RQDLN3 = 4
     C                   EVAL      DIFLN3 = OFLLN3 - PRTLN3
     C                   IF        DIFLN3 <= RQDLN3
     C                   WRITE     HEADP3
     C                   ENDIF
 
      ** Write footer
     C                   WRITE     TRAILP3
 
      ** Close the spool file
     C                   IF        P3OPEN = 'Y'
     C                   CLOSE     LE004651P3
     C                   EVAL      P3OPEN = 'N'
     C                   ENDIF
 
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
     C                   MOVE      'N'           P3OPEN
 
      ** Report work fields
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1
 
     C                   Z-ADD     0             RQDLN2
     C                   Z-ADD     0             DIFLN2
 
     C                   Z-ADD     0             RQDLN3
     C                   Z-ADD     0             DIFLN3
      ** Record counts
     C                   Z-ADD     0             RLoanCnt
     C                   Z-ADD     0             RFeesCnt1
     C                   Z-ADD     0             RFeesCnt2
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
     C
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
     C                   IF        P1OPEN <> 'Y'
     C                   OPEN      LE004651P1
     C                   EVAL      P1OPEN = 'Y'
     C                   EVAL      RFeesCnt1 = *ZERO
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
     C                   IF        P2OPEN <> 'Y'
     C                   OPEN      LE004651P2
     C                   EVAL      P2OPEN = 'Y'
     C                   EVAL      RFeesCnt2 = *ZERO
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
      ** calling program.
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
      *  SrOpnP3 - Open P3 processing                                 *
      *****************************************************************
     C     SrOpnP3       BEGSR
 
      ** Open P2 printer file
     C                   IF        P3OPEN <> 'Y'
     C                   OPEN      LE004651P3
     C                   EVAL      P3OPEN = 'Y'
     C                   EVAL      RLoanCnt = *ZERO
     C                   ENDIF
 
      ** Ensure report spool file recorded by RCF
     C                   Z-ADD     SFNUM3        ZSNUM
 
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM                    ZSENTY
     C                   PARM                    SFILE3
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
     C                   WRITE     HEADP3
 
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
      *  SrReverseFee - Process fee reversals                         *
      *****************************************************************
     C     SrReverseFee  BEGSR
 
      ** Process all fees that have been reversed today
 
     C     LNRF          SETLL     LEFEEDLD
     C     LNRF          READE     LEFEEDLD
 
     C                   DOW       NOT %EOF(LEFEEDLD)
 
     C                   IF        FERECI = '*'        AND
     C                             FELCHT =  'D'       AND
     C**********                   FELCHD =  WEvntCtlD AND                                    263866
     C                             FELCHD =  BJRDNB    AND                                    263866
     C                             FEORED <> BJRDNB    AND
     C**********                   FELOAN <> *ZERO     AND                                    CLE148
     C                             FELOAN <> *BLANKS   AND                                    CLE148
     C                             FEADJY = 'Y'
 
      ** Initialise flag to update LEFEEDLD file
     C                   EVAL      WUpdLEFEE = 'N'
     C
      ** Initialise flag for Settlement Account Key Generation
     C                   EVAL      WFAcKeyG  = *ZERO
 
      ** Non-linear Settlement Amount
     C                   IF        FESAMT <> *ZEROS
 
     C                   EVAL      WFAcKeyG  = 1
 
      ** Generate reversal settlement account key for the fee amount
     C                   EXSR      SrFeeAcKey
 
      ** Output account key details to report
 
     C                   IF        FEAMRI = 'Y'
     C                   EXSR      SrFeeRprt1
     C                   ELSE
     C                   EXSR      SrFeeRprt2
     C                   ENDIF
 
     C                   ENDIF
 
      ** Fee amount to be amortised non-linearly
     C**********         IF        FENLAI = 'Y'  AND                                          263866
     C                   IF        FEADJY = 'Y'  AND                                          263866
     C                             FEFEAM <> 0
 
     C                   EVAL      WFAcKeyG  = 2
 
      ** Generate reversal non-linear amortisation
      ** account key for Fee amount to be amortised
     C                   EXSR      SrFeeAcKey
 
      ** Output account key details to report
      *
     C                   IF        FEAMRI = 'Y'
     C                   EXSR      SrFeeRprt1
     C                   ELSE
     C                   EXSR      SrFeeRprt2
     C                   ENDIF
 
     C                   ENDIF
 
      ** Generate reversal Non-linear Amortisation Account Key for the
      ** Amortised Amount if Non-linear Amortised Amount <> 0
     C                   IF        FEAMTD <> *ZERO
 
     C                   EVAL      WFAcKeyG  = 3
 
     C                   EXSR      SrFeeAcKey
 
      ** Output account key details to report
 
     C                   IF        FEAMRI = 'Y'
     C                   EXSR      SrFeeRprt1
     C                   ELSE
     C                   EXSR      SrFeeRprt2
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update fee related files
 
     C                   EXSR      SrFeeDBUpd
 
      ** Update LEFEED if update flag has been set to 'Y'
     C                   IF        WUpdLEFEE = 'Y'
     C                   UPDATE    LEFEEDF
     C                   ENDIF
 
      ** If Amortised Separately, move to history file
     C                   IF        FEAMRI = 'Y'
     C     KEffIntR      CHAIN     LEERAPL2
     C                   IF        %FOUND(LEERAPL2)
      ** Write to History File
     C                   WRITE     LEERAHD0
      ** Delete from EIR Amortisation Over Period Detail File
     C                   DELETE    LEERAPD0
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     LNRF          READE     LEFEEDLD
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFeeAcKey - Generate non-linear amortisation account key    *
      *               for the amortised amount                        *
      *****************************************************************
     C     SrFeeAcKey    BEGSR
 
      ** Initialise LKEYFED fields
     C                   CLEAR                   LKEYFEDF
 
      ** Initialise account key work DS
     C                   EVAL      WkAkey = *BLANKS
 
      ** Set loan type (pos 1-2) and sub type (pos 4-5) for account key
     C                   EVAL      WkLTyp = LTYP
     C                   EVAL      WkLSTp = SUTP
     C                   EVAL      WkCLAS = CLAS                                              CAS019
 
      ** Set position 3 to 'R' for Settlement
      ** Set position 3 to 'E' for EIR
      ** Set position 3 to 'A' for Amortisation
 
     C                   SELECT
 
     C                   WHEN      WFAcKeyG = 1
     C                   EVAL      WkTyp1 = 'R'
 
     C                   WHEN      WFAcKeyG = 2
     C                   EVAL      WkTyp1 = 'E'
 
     C                   WHEN      WFAcKeyG = 3
     C                   EVAL      WkTyp1 = 'A'
 
     C                   ENDSL
 
      ** position 6 to 'N' to denote non-linear amortisation
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
     C**********         EVAL      FKCNUM = FECNUM                                           CAS019A
     C                   MOVEL     FECNUM        FKCNUM                                      CAS019A
     C                   EVAL      FKBRCD = FEBRCA
     C                   EVAL      FKACSQ = LASQ
     C                   EVAL      FKEDAT = WAPDAT
     C                   EVAL      FKECCY = FEFCCY
     C                   EVAL      FKSETP = FESTTL
     C                   EVAL      FKOSAC = FEOURS
 
     C                   IF        CLE005 = 'Y'
 
     C                   IF        CLE004 = 'N'
     C                             OR  CLE004 = 'Y'
     C                             AND PTFI = *BLANK
     C                   MOVE      OSDB          FKOSBR
     C                   MOVE      RONS          FKOSAC
     C                   MOVE      RSTM          FKSETP
     C                   ENDIF
     C                   IF        CLE004 = 'Y'
     C                   IF        PTFI =  'P'
     C                   MOVE      OMDB          FKOSBR
     C                   MOVE      PONS          FKOSAC
     C                   MOVE      PSTM          FKSETP
     C                   ENDIF
     C                   IF        PTFI =  'I'
     C                   MOVE      *BLANKS       FKOSBR
     C                   MOVE      *BLANKS       FKOSAC
     C                   MOVE      *BLANKS       FKSETP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      FKSLID = FEPSTD
 
      ** For reversals, post Non-Linear Amortised Fee to Date
     C                   IF        FERECI = '*'
     C                   EVAL      FKREVI = 1
     C
     C                   SELECT
 
     C                   WHEN      WFAcKeyG  = 1
     C                   EVAL      FKEAMT = FESAMT
 
     C                   WHEN      WFAcKeyG  = 2
     C**********         EVAL      FKEAMT = FEFEAM                                          BUG17318
     C                   EVAL      FKEAMT = FESAMT                                          BUG17318
 
     C                   WHEN      WFAcKeyG  = 3
     C                   EVAL      FKEAMT = FEAMTD
 
     C                   ENDSL
 
     C                   ELSE
 
      ** else, post Non-Linear Amortised Fee for the day
     C                   EVAL      FKREVI = 0
 
      ** If fee currency is not the same as loan currency, convert amount
      ** to be posted back to fee currency, except for last amortisation
      ** to be posted since value is already in fee currency (this is
      ** determined by the 'EIENDT > WEvntCtlD' condition). Refer to
      ** SR/SrProcessFees to see computation.
 
     C                   IF        WAddAcKeyF <> 'Y'
      ** Amortised over life
 
     C                   IF        WAccessF = 'EIRD'
 
     C                   IF        CCY <> FEFCCY AND
     C                             EIENDT > WEvntCtlD
     C                   IF        WFMDin(WIx) = 'M'
     C**********         EVAL(R)   WFeePostAmt(WIx) = WFeePostAmt(WIx) /                      262621
     C                   EVAL(H)   WFeePostAmt(WIx) = WFeePostAmt(WIx) /                      262621
     C                                                WFXrate(WIx)
     C                   ELSE
     C**********         EVAL(R)   WFeePostAmt(WIx) = WFeePostAmt(WIx) *                      262621
     C                   EVAL(H)   WFeePostAmt(WIx) = WFeePostAmt(WIx) *                      262621
     C                                                WFXrate(WIx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      FKEAMT = WFeePostAmt(WIx)
 
     C                   ELSE
      ** Amortised over period
     C                   IF        CCY <> FEFCCY AND
     C                             EIENDT > WEvntCtlD
     C     KEffIntR      CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
 
     C                   IF        EAMDIN = 'M'
     C**********         EVAL(R)   WFeePostAmt1 = WFeePostAmt1 /                              262621
     C                   EVAL(H)   WFeePostAmt1 = WFeePostAmt1 /                              262621
     C                                                EAXRAT
     C                   ELSE
     C**********         EVAL(R)   WFeePostAmt1 = WFeePostAmt1 *                              262621
     C                   EVAL(H)   WFeePostAmt1 = WFeePostAmt1 *                              262621
     C                                                EAXRAT
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         ELSE                                                                 262625
     C                   ENDIF                                                                262625
 
     C                   EVAL      FKEAMT = WFeePostAmt1
     C**********         ENDIF                                                                262625
 
     C                   ENDIF
 
     C                   ELSE
 
     C**********         IF        WFAcKeyG = 2                                             BUG17318
     C**********         EVAL      FKEAMT = FEFEAM                                          BUG17318
     C**********         ELSE                                                               BUG17318
     C                   EVAL      FKEAMT = FEFAMT
     C**********         ENDIF                                                              BUG17318
 
     C                   ENDIF
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
 
     C                   IF        WAddAcKeyF = 'Y'
 
     C                   IF        FEAMRI = 'Y'
     C                   ADD       1             RFeesCnt1
     C                   ELSE
     C                   ADD       1             RFeesCnt2
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WAccessF = 'EIRD'
     C                   ADD       1             RFeesCnt2
     C                   ELSE
     C                   ADD       1             RFeesCnt1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ADD       1             RAFeesCnt
 
      ** Write new account key to file
     C                   WRITE     LKEYFEDF
 
      ** Update fee account keys trailer
     C                   EXSR      SrFeeAKTrail
 
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
      /EJECT
      *****************************************************************
      *  SrFeeRprt1 - Output generated account key detail to report   *
      *                           (Over Period)                       *
      *****************************************************************
     C     SrFeeRprt1    BEGSR
 
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
      *  SrFeeRprt2 - Output generated account key detail to report   *
      *                           (Over Life)                         *
      *****************************************************************
     C     SrFeeRprt2    BEGSR
 
      ** Initialise report detail fields
     C                   CLEAR                   DETAIL21
 
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
      *  SrFeeDBUpd - Update fee related files                        *
      *****************************************************************
     C     SrFeeDBUpd    BEGSR
 
      ** File Updates for Reversals
     C                   IF        FERECI = '*'
      ** Update CLOANLB file fields
      ** If loan and fee currency are not the same, convert
     C                   EVAL      WkFEFAMT = 0
 
     C                   IF        CCY <> FEFCCY
     C     KEffIntR      CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
 
     C                   IF        EAMDIN = 'M'
     C**********         EVAL(R)   WkFEFAMT = FEFAMT * EAXRAT                                 262621
     C                   EVAL(H)   WkFEFAMT = FEFAMT * EAXRAT                                 262621
     C                   ELSE
     C**********         EVAL(R)   WkFEFAMT = FEFAMT / EAXRAT                                 262621
     C                   EVAL(H)   WkFEFAMT = FEFAMT / EAXRAT                                 262621
     C                   ENDIF
 
     C                   ENDIF
      ** Loan and fee currency are the same
     C                   ELSE
     C                   EVAL      WkFEFAMT = FEFAMT
     C                   ENDIF
     C
     C                   EVAL      TFDP  = TFDP  - WkFEFAMT
     C                   EVAL      TFDPA = TFDPA - WkFEFAMT
     C                   EVAL      TFAM  = TFAM  - WkFEFAMT                                   263866
     C                   EVAL      AFDP = AFDP - FEAMTD                                     AR814162
 
     C                   EVAL      WUpdCLOAN = 'Y'
 
      ** Zeroise Non-Linear Amortised Fee to Date
      ** and update Non-linear Amort. Ind. to prevent reposting
     C                   EVAL      FEAMTD = *ZERO
      *
     C                   EVAL      FESAMT = *ZERO
      *
     C                   EVAL      FENLAI = 'R'
 
     C                   EVAL      WUpdLEFEE = 'Y'
 
      ** File Updates for Non-Reversals
     C                   ELSE
 
      ** Update LEFEEDLD file
     C                   IF        WAccessF = 'EIRD'
     C                   EVAL      FEAMTD = WFeePostAmt(WIx) + FEAMTD
     C                   ELSE
     C                   EVAL      FEAMTD = WFeePostAmt1 + FEAMTD
     C                   ENDIF
 
      ** Update Amortised to Date in LEEIRAPD
     C     KEffIntR      CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
     C                   IF        CCY <> FEFCCY
     C                   IF        EAMDIN = 'M'
     C**********         EVAL      EAAAMP = FEAMTD * EAXRAT                                BUG17315A
     C                   EVAL(H)   EAAAMP = FEAMTD * EAXRAT                                BUG17315A
     C                   ELSE
     C**********         EVAL      EAAAMP = FEAMTD / EAXRAT                                BUG17315A
     C                   EVAL(H)   EAAAMP = FEAMTD / EAXRAT                                BUG17315A
     C                   ENDIF
     C                   ELSE
     C                   EVAL      EAAAMP = FEAMTD
     C                   ENDIF
 
     C                   UPDATE    LEEIRAD0
 
     C                   ENDIF
 
     C                   EVAL      FEAFES = FEAMTD
     C                   EVAL      FELADT = WEvntCtlD
 
     C                   EVAL      WUpdLEFEE = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrEIRDProc - Process today's amortisation (over life)        *
      *****************************************************************
     C     SrEIRDProc    BEGSR
 
      ** Clear Record format
 
     C                   CLEAR                   LEEIRDD0
 
     C     LNRF          CHAIN     LEEIRDLD
     C                   IF        %FOUND(LEEIRDLD) AND
     C                             EIRECI = 'D' AND
     C                             EIFDPA <> 0  OR
     C                             %FOUND(LEEIRDLD) AND
     C                             EIRECI = 'M' AND
     C                             EIFDPA <> 0
 
     C                   OPEN      LEAMRTL0
 
     C                   EVAL      WAccessF = 'EIRD'
 
     C                   EXSR      SrAmortise
 
      ** Update loan related files
     C                   IF        WkPropSum <> *ZERO
     C                   EXSR      SrLoanDBUpd
     C                   ENDIF
 
     C                   IF        EIENDT <= WEvntCtlD
     C                   EVAL      EIRECI = 'M'
     C                   EVAL      WUpdLEEIR = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrERAPProc - Process today's amortisation (Over Period)      *
      *****************************************************************
     C     SrERAPProc    BEGSR
 
      ** Clear Record Format
     C                   CLEAR                   LEERAPD0
 
      ** Compute for sum fee amounts and proportion of each fee
 
     C     LNRF          SETLL     LEERAPL2
     C     LNRF          READE     LEERAPL2
     C                   DOW       NOT %EOF(LEERAPL2)
 
     C                   OPEN      LEAMRTL0
 
     C                   IF        FSNDYR = *BLANK
     C                   EVAL      WIntCalcBasis = ICBS
     C                   ENDIF
 
     C                   EVAL      WAccessF = *BLANKS
 
     C                   EXSR      SrCrtCshFlow1
 
     C                   EXSR      SrProcessFee1
 
      ** Update LEERAPPD
     C                   IF        WFeePostAmt1 <> *ZERO
 
     C                   EVAL      EIRECI = RECI
     C                   EVAL      EIAMTD = WAmrtAmt
     C                   EVAL      EIPRCP = EICPTD
     C                   EVAL      EIPRDP = EIDPTD
     C                   EVAL(R)   EICPTD = PClnPrcTdy
     C                   EVAL(R)   EIDPTD = PDrtPrcTdy
 
      ** Last day of amortisation
     C                   IF        WLstDayAmrt = 'Y'
 
      ** Write to Amortised over period history file
     C                   WRITE     LEERAHD0
 
      ** Delete from Amortised over period file
     C                   DELETE    LEERAPD0
 
     C                   ELSE
 
      ** Not last day of amortisation, update file
     C                   UPDATE    LEERAPD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     LNRF          READE     LEERAPL2
 
     C                   ENDDO
 
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
 
     C                   IF        WkFeePropSum <> 0
     C                   EXSR      SrProcessFees
     C                   ENDIF
 
      ** Process loan updates and report details
     C                   EVAL      WLoanPostAmt = 0
 
     C                   IF        WDiscLoanF = 'Y' AND
     C                             WPropTOTI <> *ZERO
     C                   EVAL      WLoanProcess = 'Y'
     C                   EXSR      SrProcessLoan
     C                   EVAL      WLoanProcess = 'N'
     C                   ENDIF
 
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
 
      ** Set calculation basis and number of days in a year if not
      ** already determined by 'No. of Days in a Year' in Hedge ICD
     C                   IF        FSNDYR = *BLANK
     C                   EVAL      WIntCalcBasis = ICBS
     C                   ENDIF
 
      ** Compute for sum fee amounts and proportion of each fee
     C                   EXSR      SrAllFeeAmts
 
      ** Set aside total interest (TOTI) amount from loan details
      ** which will be used later in allocating the amortised amount
      ** across the different postings
     C                   EVAL      WPropTOTI = *ZERO
     C                   EVAL      WPrevAmrtToDt = *ZERO
 
      **If Discounted Loan
     C                   IF        WDiscLoanF = 'Y'
      *
     C                   EVAL      KLoan = LNRF
     C                   EVAL      KFSeq = *ZEROS
 
     C     KLoanFSeq     CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
     C**********         EVAL(R)   WPropTOTI = EAAAMT                                       AR811536
     C                   EVAL(R)   WPropTOTI = EAAMNT                                       AR811536
 
     C     KLoanFSeq     READE     LEEIRAL5
     C                   IF        NOT %EOF(LEEIRAL5)
     C                   EVAL(R)   WPrevAmrtToDt = EAAAMP
     C                   ELSE
     C                   EVAL(R)   WPrevAmrtToDt = *ZEROS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Add saved Total Interest and sum of all Fees associated to the
      ** loan to determine the total amount to be amortisted. This will
      ** be used in allocating the amortisation for the day across the
      ** different postings.
     C                   EVAL(R)   WkPropSum = WPropTOTI + WkFeePropSum
 
      ** Create Cash flow records in LEAMRTPD
     C                   IF        WPrepayment = 'N'                                          262607
     C                   EXSR      SrCrtCshFlow
 
      ** In case loan has been fully prepaid no need to calculate                             262607
      ** amortisation amount                                                                  262607
     C                   ELSE                                                                 262607
     C                   CLOSE     LEAMRTL0                                                   262607
     C                   EVAL      PDrtPrcTdy = 0                                             262607
     C                   EVAL      PClnPrcTdy = 0                                             262607
     C                   EVAL      EIEIR  = 0                                                 262607
     C                   EVAL      WAmrtAmt = EIFDPA                                          262607
     C                   EVAL      EILADT = BJRDNB                                            262607
     C                   IF        EIAMAJ <> 0                                                262607
     C                   EVAL      WAmrtAmt = WAmrtAmt + EIAMAJ                               262607
     C                   EVAL      EIAMAJ = 0                                                 262607
     C                   ENDIF                                                                262607
     C                   ENDIF                                                                262607
                                                                                              262607
     C                   ENDSR
      *****************************************************************
      *  SrCrtCshFlow - Create Cash Flow Records                      *
      *****************************************************************
     C     SrCrtCshFlow  BEGSR
 
      ** Create Cash Flows from EIR Start Date
     C                   EVAL      KDate = EISTDT
 
     C                   EVAL      WMaturityDate = EIENDT
 
     C                   EVAL      WStartDate = EISTDT
                                                                                              262600
      ** Amortise only from last amortisation date                                            262600
     C                   IF        EILADT > EISTDT                                            262600
     C                   EVAL      WStartDate = EILADT                                        262600
     C                   ENDIF                                                                262600
 
      ** Check if the system is set to Last Day Accrual
     C                   IF        BKALDI <> 'Y'
     C                   EVAL      WAccInd = 'F'
     C                   ENDIF
 
      ** Obtain Cashflows from LECFLSPD
     C     LNRF          SETLL     LECFSFL0
     C     LNRF          READE     LECFSFL0
 
      ** Write all cashflows from EIR Start to Event Control Date
     C                   DOW       NOT %EOF(LECFSFL0)
     C                             AND LFFLDT <= WEvntCtlD
     C                             AND WAccInd = 'L'
     C                             OR NOT %EOF(LECFSFL0)
     C**********                   AND LFFLDT <= (WEvntCtlD + 1)                              240647
     C                             AND LFFLDT <= WEvntCtlD                                    240647
     C                             AND WAccInd = 'F'
 
      ** Exclude shadow cashflows                                                             248260
     C*                  IF        LFIOIN = 'S'                                               248260
     C*    LNRF          READE     LECFSFL0                                                   248260
     C*                  ITER                                                                 248260
     C*                  ENDIF                                                                248260
                                                                                              248260
      ** Exclude shadow cashflows                                                             262600
     C                   IF        LFIOIN = 'S'                                               262600
     C     LNRF          READE     LECFSFL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Exclude cashlows already included in Dirty Price passed as                           262600
      ** a parameter                                                                          262600
     C                   IF        LFFLDT <= EILADT                                           262600
     C     LNRF          READE     LECFSFL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Exclude start amount
     C                   IF        LFFTYP = 'SAMT'
     C                             OR LFFTYP = 'SSAM'
      ***Non-fees*equal*to*EIR*period*start*date***********************                       262600
     C**********                   OR LFFTYP <> 'EFAC' AND LFFTYP <> 'SFAM'                   262600
     C**********                   AND LFFTYP <> 'SFBT' AND LFFLDT = EISTDT                   262600
      ***Shadow*rollover*principal*only.*******************************                       262600
     C**********                   OR LFFTYP = 'ROPR' AND LFFLDT = EISTDT                     262600
 
     C     LNRF          READE     LECFSFL0
     C                   ITER
     C                   ENDIF
 
      ** If not Fee, process present & future cashflows only
     C                   IF        LFFSEQ = 0  AND
     C                             LFFLDT < EISTDT
     C     LNRF          READE     LECFSFL0
     C                   ITER
     C                   ENDIF
 
      ** If Fee, but Amortised Separately, skip
     C                   IF        LFFSEQ <> 0
 
     C                   EVAL      KLoan = LFLNRF
     C                   EVAL      KFSeq = LFFSEQ
 
     C*****KLoanFSeq     CHAIN     LEFEEDLI                                                   CAS019
     C**********         IF        NOT %FOUND(LEFEEDLI)                                       CAS019
     C     KLoanFSeq     CHAIN     LEFEEDLN                                                   CAS019
     C                   IF        NOT %FOUND(LEFEEDLN)                                       CAS019
     C     LNRF          READE     LECFSFL0
     C                   ITER
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   EVAL      EPTNMR = LFLNRF
     C                   EVAL      EPFLDT = LFFLDT
     C                   EVAL      EPCAMT = LFCAMT
     C                   EVAL      EPIOIN = LFIOIN
 
      ** If Fee and Cash Flow Date is less than EIR Start Date (means previous cash flow)
      ** Cash Flow Date should be the EIR Start Date
     C                   IF        LFFSEQ <> 0 AND
     C                             LFFLDT < EISTDT
     C                   EVAL      EPFLDT = EISTDT
     C                   ENDIF
 
      ** If Fee, get the amount from LEEIRAPD
 
     C                   IF        LFFSEQ <> 0
      *
     C                   EVAL      KLoan = LFLNRF
     C                   EVAL      KFSeq = LFFSEQ
      *
     C     KLoanFSeq     CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
     C**********         EVAL      EPCAMT = EAAAMT                                          AR811536
     C                   EVAL      EPCAMT = EAAMNT                                          AR811536
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set Cashflow types for ZAAMRTCALC
 
     C                   SELECT
 
     C                   WHEN      LFFTYP = 'EFAC'
     C                             OR LFFTYP = 'SFAM'
     C                             OR LFFTYP = 'SFBT'
     C                   EVAL      EPCFTP = 'FEEA'
      *
 
     C                   WHEN      LFFTYP = 'SPIN'
     C                             OR LFFTYP = 'PINC'
     C                             OR LFFTYP = 'SSRP'
     C                             OR LFFTYP = 'SRPY'
     C                             OR LFFTYP = 'SRPA'
     C                             OR LFFTYP = 'RPAY'
     C                             OR LFFTYP = 'SPTF'
     C                             OR LFFTYP = 'PTFA'
     C                             OR LFFTYP = 'SPTT'
     C                             OR LFFTYP = 'PTTA'
     C                   EVAL      EPCFTP = 'PCPL'
 
     C                   WHEN         LFFTYP = 'INTP'
     C                             OR LFFTYP = 'SINT'
     C                             OR LFFTYP = 'MINT'
     C                             OR LFFTYP = 'SMIN'
     C                   EVAL      EPCFTP = 'INTP'
 
     C                   OTHER
     C                   EVAL      EPCFTP = *BLANKS
     C                   ENDSL
 
     C                   IF           LFFTYP = 'ROIN' AND LFFLDT = EISTDT
     C                   IF           PTYP = 66 OR PTYP = 67 OR PTYP = 69
     C                   EVAL      EPIOIN = 'I'
     C                   ELSE
     C                   EVAL      EPIOIN = 'O'
     C                   ENDIF
     C                   ENDIF
 
     C                   WRITE     ZAAMRTD0
     C     LNRF          READE     LECFSFL0
 
     C                   ENDDO
 
      ** Override LEAMRTPD
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(1)      PCommand
     C                   PARM                    PCmdLen
 
      ** Override LEHTRNPD
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(3)      PCommand
     C                   PARM                    PCmdLen
 
      ** Discounted Loan
     C                   IF        PTYP = 63 OR PTYP = 65
     C                             OR PTYP = 67
     C                   EVAL      WProcType = 'D'
     C                   ELSE
     C                   EVAL      WProcType = ' '
     C                   ENDIF
 
     C                   IF        WEvntCtlD < EIENDT
     C                   Eval      WEndDate = WEvntCtlD
     C                   Else
     C                   Eval      WEndDate = EIENDT
     C                   EndIf
 
     C                   EVAL      PStopAccrualF = ' '
     C                   TESTB     '3'           LONI                     50
     C                   IF        *IN50 = *ON
     C                   EVAL      PStopAccrualF = 'Y'
     C                   ENDIF
 
     C                   IF        WDiscLoanF = 'Y'
      *
     C                   EVAL      KLoan = LFLNRF
     C                   EVAL      KFSeq = *ZEROS
 
     C     KLoanFSeq     CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
     C**********         EVAL      WToti = EAAAMT                                           AR811536
     C                   EVAL      WToti = EAAMNT                                           AR811536
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WkLoanInd  = 'L'
     C**********         Z-ADD     *ZEROS        WDirtyPrc                                    262600
     C**********         Z-ADD     *ZEROS        WCleanPrc                                    262600
     C                   EVAL      WDirtyPrc = EIDPTD                                         262600
     C                   EVAL      WCleanPrc = EICPTD                                         262600
                                                                                              262600
     C                   MOVE      PAMORTDS      PAmortDSA
 
      ** Call Amortisation Calculator
     C                   CALLB     'ZAAMRTCALC'
     C                   PARM                    PAmortDSA
 
     C                   MOVEL     PAmortDSA     PAMORTDS
 
     C                   CLOSE     LEAMRTL0
 
      ** Clear LEAMRTPD
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(5)      PCommand
     C                   PARM                    PCmdLen
 
      ** Update Last Amortisation Date
     C                   EVAL      EILADT = WEndDate
     C                   EVAL      WAmrtAmt = EIAMTD + WAmrtAmt                               262600
 
     C                   IF        EIAMAJ <> 0
     C                   EVAL      WAmrtAmt = WAmrtAmt + EIAMAJ
     C                   EVAL      EIAMAJ = 0
     C                   ENDIF
 
      ** Delete Override
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(2)      PCommand
     C                   PARM                    PCmdLen
 
      ** Delete Override
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(4)      PCommand
     C                   PARM                    PCmdLen
 
     C                   ENDSR
      *****************************************************************
      *  SrCrtCshFlow1 - Create Cash Flow Records (LEERAPPD)          *
      *****************************************************************
     C     SrCrtCshFlow1 BEGSR
 
      ** Create Cash Flows from EIR Start Date
     C                   EVAL      KDate = EISTDT
 
     C                   EVAL      WMaturityDate = EIENDT
 
     C                   EVAL      WStartDate = EISTDT
 
      ** Check if the system is set to Last Day Accrual
     C                   IF        BKALDI <> 'Y'
     C                   EVAL      WAccInd = 'F'
     C                   ENDIF
 
      ** Obtain Cashflows from LECFLSPD
     C     KCashFlow1    SETLL     LECFSFL1
     C*****KCashFlow1    READE     LECFSFL1                                                   262600
     C     KCashFlow2    READE     LECFSFL1                                                   262600
 
      ** Write all cashflows from EIR Start to Event Control Date
     C                   DOW       NOT %EOF(LECFSFL1)
     C                             AND LFFLDT <= WEvntCtlD
     C                             AND WAccInd = 'L'
     C                             OR NOT %EOF(LECFSFL1)
     C**********                   AND LFFLDT <= (WEvntCtlD + 1)                              240647
     C                             AND LFFLDT <= WEvntCtlD                                    240647
     C                             AND WAccInd = 'F'
 
     C                   EVAL      EPTNMR = LFLNRF
     C                   EVAL      EPFLDT = LFFLDT
     C                   EVAL      EPCAMT = LFCAMT
     C                   EVAL      EPIOIN = LFIOIN
 
      ** Set Cashflow types for ZAAMRTCALC
     C                   EVAL      EPCFTP = 'FEEA'
 
     C                   WRITE     ZAAMRTD0
     C     KCashFlow2    READE     LECFSFL1
 
     C                   ENDDO
 
      ** Override LEAMRTPD
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(1)      PCommand
     C                   PARM                    PCmdLen
 
      ** Override LEHTRNPD
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(3)      PCommand
     C                   PARM                    PCmdLen
 
     C                   EVAL      WProcType = ' '
 
     C                   IF        WEvntCtlD < EIENDT
     C                   Eval      WEndDate = WEvntCtlD
     C                   Else
     C                   Eval      WEndDate = EIENDT
     C                   EndIf
 
     C                   EVAL      PStopAccrualF = ' '
     C                   TESTB     '3'           LONI                     50
     C                   IF        *IN50 = *ON
     C                   EVAL      PStopAccrualF = 'Y'
     C                   ENDIF
 
     C**********         EVAL      WToti = *ZEROS                                             262600
     C                   EVAL      WToti = - EISINT                                           262600
 
     C                   EVAL      WkLoanInd  = 'L'
     C                   Z-ADD     *ZEROS        WDirtyPrc
     C                   Z-ADD     *ZEROS        WCleanPrc
     C                   MOVE      PAMORTDS      PAmortDSA
 
      ** Call Amortisation Calculator
     C                   CALLB     'ZAAMRTCALC'
     C                   PARM                    PAmortDSA
 
     C                   MOVEL     PAmortDSA     PAMORTDS
 
     C                   CLOSE     LEAMRTL0
 
      ** Clear LEAMRTPD
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(5)      PCommand
     C                   PARM                    PCmdLen
 
      ** Update Last Amortisation Date
     C                   EVAL      EILADT = WEndDate
 
      ** Delete Override
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(2)      PCommand
     C                   PARM                    PCmdLen
 
      ** Delete Override
     C                   CALL      'QCMDEXC'
     C                   PARM      ##OVR(4)      PCommand
     C                   PARM                    PCmdLen
 
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
     C                   EVAL      WFPropAmt (*) = *ZERO
     C                   EVAL      WFSeq(*) = *ZERO
     C                   EVAL      WFXrate(*) = *ZERO
     C                   EVAL      WFMDin(*) = *BLANKS
     C                   EVAL      WAmortAmount = *ZERO
     C                   EVAL      WFAmrtAmtToDt(*) = *ZERO
     C                   EVAL      WIx = *ZERO
 
      ** Process all live fees attached to the loan
     C*****LNRF          SETLL     LEFEEDLI                                                   CAS019
     C*****LNRF          READE     LEFEEDLI                                                   CAS019
     C**********         DOW       NOT %EOF(LEFEEDLI)                                         CAS019
     C     LNRF          SETLL     LEFEEDLN                                                   CAS019
     C     LNRF          READE     LEFEEDLN                                                   CAS019
     C                   DOW       NOT %EOF(LEFEEDLN)                                         CAS019
      ** Compute for all fees settled today.
     C                   IF        FERECI <> 'R' AND
     C                             FERECI <> '*' AND
     C**********                   FELOAN <> *ZERO AND                                        CLE148
     C                             FELOAN <> *BLANKS AND                                      CLE148
     C                             FEADJY = 'Y' AND
     C                             FEAMTD <> FEFAMT
 
      ** Include only those fees whose Amortisation
      ** Start Date is on or before Event Control Date
 
     C                   IF        FESTPD <= WEvntCtlD
 
      ** Increment array index
     C                   EVAL      WIx = WIx + 1
 
      ** Store the respective fee sequences to array for chain/update later
     C                   EVAL(R)   WFSeq(WIx) = FEFSEQ
 
      ** Get the Amount to be Amortised from Effective Interest Rate
      ** Amortisation Details file.
     C     KEffIntR      CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
     C**********         EVAL(R)   WFPropAmt(WIx) = EAAAMT                                  AR811536
     C                   EVAL(R)   WFPropAmt(WIx) = EAAMNT                                  AR811536
 
      ** If loan currency is not the same as fee currency, convert
     C                   IF        CCY <> FEFCCY
 
     C                   IF        EAMDIN = 'M'
     C**********         EVAL(R)   WAmortAmount = FEAMTD * EAXRAT                             262621
     C                   EVAL(H)   WAmortAmount = FEAMTD * EAXRAT                             262621
     C                   ELSE
     C**********         EVAL(R)   WAmortAmount = FEAMTD / EAXRAT                             262621
     C                   EVAL(H)   WAmortAmount = FEAMTD / EAXRAT                             262621
     C                   ENDIF
 
     C                   EVAL      WFXrate(WIx) = EAXRAT
     C                   EVAL      WFMDin(WIx)  = EAMDIN
      ** Same Currency
     C                   ELSE
     C                   EVAL(R)   WAmortAmount = FEAMTD
     C                   ENDIF
 
      ** Subtract Amortised to Date of LEEIRAPD (Previous Period)
      ** from Amort. to Date (LEFEED)
 
     C     KEffIntR      READE     LEEIRAL5
     C                   IF        NOT %EOF(LEEIRAL5)
     C                   EVAL      WFAmrtAmtToDt(WIx) = WAmortAmount - EAAAMP
     C                   ELSE
     C                   EVAL      WFAmrtAmtToDt(WIx) = WAmortAmount
     C                   ENDIF
 
      ***Negative*Result***********************************************                       258620
     C**********         IF        WFAmrtAmtToDt(WIx) < 0                                     258620
     C**********         EVAL      WFAmrtAmtToDt(WIx) = *ZEROS                                258620
     C**********         ENDIF                                                                258620
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C*****LNRF          READE     LEFEEDLI                                                   CAS019
     C     LNRF          READE     LEFEEDLN                                                   CAS019
 
     C                   ENDDO
 
      ** Note down number of fees processed
     C                   EVAL      WNumOfFees = WIx
 
      ** Compute sum of proportioned fee amount
     C                   Z-ADD     0             WkFeePropSum
     C                   IF        WIx > *ZERO
     C                   XFOOT     WFPropAmt     WkFeePropSum
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrFeeAckyGen - Generate Additional Account Keys              *
      *                                                               *
      *****************************************************************
     C     SrFeeAckyGen  BEGSR
 
      ** Process all live fees attached to the loan
     C     LNRF          SETLL     LEFEEDLD
     C     LNRF          READE     LEFEEDLD
 
     C                   DOW       NOT %EOF(LEFEEDLD)
      ** Compute for all fees settled today.
     C                   IF        FERECI <> 'R' AND
     C                             FERECI <> '*' AND
     C**********                   FELOAN <> *ZERO AND                                        CLE148
     C                             FELOAN <> *BLANKS AND                                      CLE148
     C                             FEADJY = 'Y'
 
      ** Initialise Additional Account Key Flag
     C                   EVAL      WAddAcKeyF = *BLANK
 
      ** Initialise Work Variable
     C                   EVAL      WCheckDt = *ZERO
     C                   EVAL      WLEFEUpd = 'N'
 
      ** Amortising or Bullet Fee
     C                   IF        FEPYON = 'S' OR
     C                             FEPYON = ' '
     C                   EVAL      WCheckDt = FEPSTD
     C                   ELSE
 
      ** Accruing or Repetitive Fee
     C                   IF        FENPYD <> 0
     C                   EVAL      WCheckDt = FENPYD
     C                   ELSE
     C                   EVAL      WCheckDt = FEPEND
     C                   ENDIF
 
     C                   ENDIF
     C
      *                                                                                       CLE134
     C                   MOVE      FEAUTO        WFEAUT                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   IF        WFEAUT = 'C'  OR FEAUT2  = 'C'                             CLE134
     C                   MOVE      'Y'           WFEAUT                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
      ** If Adjustment to Yield Fees Settlement Date is on or before Event Control Date
      ** and Non-linear Settlement Amount is zero and Auto Settle Indicator is 'Y'
      ** Generate Settlement Account Key
     C                   IF        WCheckDt <= WEvntCtlD AND
     C                             FESAMT = 0 AND
     C**********                   FEAUTO = 'Y'                                               CLE134
     C                             WFEAUT = 'Y'                                               CLE134
 
     C                   EVAL      WFAcKeyG = 1
     C                   EVAL      WAddAcKeyF = 'Y'
 
     C                   EXSR      SrFeeAcKey
 
      ** Output account key details to report
     C                   IF        FKEAMT <> *ZERO
 
     C                   IF        FEAMRI = 'Y'
     C                   EXSR      SrFeeRprt1
     C                   ELSE
     C                   EXSR      SrFeeRprt2
     C                   ENDIF
 
     C                   ENDIF
 
      ** Add to Non-linear Settlement Amount
     C                   ADD       FEFAMT        FESAMT
 
     C                   EVAL      WLEFEUpd = 'Y'
 
     C                   ENDIF
 
      ** If Adjustment to Yield Fees Amortisation Start Date is on or before
      ** Event Control Date and Amortised to Date is zero
     C                   IF        FESTPD <= WEvntCtlD AND
     C                             FEAMTD = *ZERO
 
     C                   EVAL      WFAcKeyG = 2
     C                   EVAL      WAddAcKeyF = 'Y'
 
     C                   EXSR      SrFeeAcKey
 
      ** Output account key details to report
     C                   IF        FKEAMT <> *ZERO
 
     C                   IF        FEAMRI = 'Y'
     C                   EXSR      SrFeeRprt1
     C                   ELSE
     C                   EXSR      SrFeeRprt2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Adjustment to Yield Amortised Separately Fee Amortisation End Date
      ** is on or before Event Control Date and Non-linear Amortised to Date is zero
     C                   IF        FEAMRI = 'Y' AND
     C                             FEENPD <= WEvntCtlD AND
     C                             FEAMTD = *ZERO
 
     C                   EVAL      WFAcKeyG = 3
     C                   EVAL      WAddAcKeyF = 'Y'
 
     C                   EXSR      SrFeeAcKey
 
      ** Output account key details to report
     C                   IF        FKEAMT <> *ZERO
 
     C                   IF        FEAMRI = 'Y'
     C                   EXSR      SrFeeRprt1
     C                   ELSE
     C                   EXSR      SrFeeRprt2
     C                   ENDIF
 
     C                   ENDIF
 
      ** Move the Whole Fee Amount to Non-Linear Amortised Fee to Date
     C                   EVAL      FEAMTD = FEFAMT
 
     C                   EVAL      WLEFEUpd = 'Y'
 
     C                   ENDIF
 
      ** Update LE Fees master detail Amount
     C                   IF        WLEFEUpd = 'Y'
     C                   UPDATE    LEFEEDF
     C                   ENDIF
 
     C                   ENDIF
 
     C     LNRF          READE     LEFEEDLD
     C                   ENDDO
     C
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
     C                   EVAL      WFeePostAmt(*) = *ZERO
     C                   DOW       WNumOfFees > WIx
 
      ** Increment array index
     C                   EVAL      WIx = WIx + 1
 
      ** Calculate proportion of amortised amount to be posted for
      ** the current fee
     C**********         EVAL      WFeePostAmt(WIx) = (WFPropAmt(WIx)/WkPropSum             BUG17315
     C**********                                * WAmrtAmt) - WFAmrtAmtToDt(WIx)            BUG17315
     C                   EVAL(H)   WFeePostAmt(WIx) = (WFPropAmt(WIx)/WkPropSum             BUG17315
     C                                          * WAmrtAmt) - WFAmrtAmtToDt(WIx)            BUG17315
 
      ** On the fee's last day of amortisation, post the difference
      ** between the fee's settled amount and it's non-linear
      ** amortisation amount to date thus avoid discrepancies between
      ** the final non-linear amortisation to date and settled amount
     C                   IF        EIENDT <= WEvntCtlD
     C                   EVAL      KFeeSq = WFSeq(WIx)
     C*****KFees         CHAIN     LEFEEDLD                                                   240797
     C     KFees         CHAIN(N)  LEFEEDLD                                                   240797
     C                   IF        FEAMTS <> 0
     C                   EVAL      WFeePostAmt(WIx) = FEAMTS - FEAMTD
     C                   ELSE
     C                   EVAL      WFeePostAmt(WIx) = FEFAMT - FEAMTD
     C                   ENDIF
     C                   ENDIF
 
      ** Process only if posting amount is not zero
     C                   IF        WFeePostAmt(WIx) <> *ZERO
     C                   EVAL      KFeeSq = WFSeq(WIx)
 
     C*****KFees         CHAIN     LEFEEDLI                                                   CAS019
     C**********         IF        %FOUND(LEFEEDLI)                                           CAS019
     C     KFees         CHAIN     LEFEEDLN                                                   CAS019
     C                   IF        %FOUND(LEFEEDLN)                                           CAS019
 
      ** Initialise flag to update LEFEEDLD file
     C                   EVAL      WUpdLEFEE = 'N'
 
      ** Generate Non-linear Account Key for current fee
     C                   EVAL      WFAcKeyG = 3
      *
     C                   EXSR      SrFeeAcKey
 
     C                   IF        FKEAMT <> *ZERO
      ** Output account key details to report
     C                   EXSR      SrFeeRprt2
 
      ** Update fee related files
     C                   EXSR      SrFeeDBUpd
     C                   ENDIF
 
      ** Update LEFEED if update flag has been set to 'Y'
     C                   IF        WUpdLEFEE = 'Y'
     C                   UPDATE    LEFEEDFI
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcessFee1 - Process fee updates and report details       *
      *****************************************************************
     C     SrProcessFee1 BEGSR
 
     C                   EVAL      WLstDayAmrt = 'N'
 
     C     KCashFlow2    CHAIN     LEFEEDLJ
     C                   IF        %FOUND(LEFEEDLJ)
 
     C                   IF        FEFCCY <> CCY
 
     C     KCashFlow2    CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
     C                   IF        EAMDIN = 'M'
     C**********         EVAL(R)   WAmrtToDt1 = FEAMTD * EAXRAT                               262621
     C                   EVAL(H)   WAmrtToDt1 = FEAMTD * EAXRAT                               262621
     C                   ELSE
     C**********         EVAL(R)   WAmrtToDt1 = FEAMTD / EAXRAT                               262621
     C                   EVAL(H)   WAmrtToDt1 = FEAMTD / EAXRAT                               262621
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL(R)   WAmrtToDt1 = FEAMTD
     C                   ENDIF
     C
     C                   EVAL      WFeePostAmt1 =  WAmrtAmt  - WAmrtToDt1
 
      ** On the fee's last day of amortisation, post the difference
      ** between the fee's settled amount and it's non-linear
      ** amortisation amount to date thus avoid discrepancies between
      ** the final non-linear amortisation to date and settled amount
     C                   IF        EIENDT <= WEvntCtlD
     C                   IF        FEAMTS <> 0
     C                   EVAL      WFeePostAmt1 = FEAMTS - FEAMTD
     C                   ELSE
     C                   EVAL      WFeePostAmt1 = FEFAMT - FEAMTD
     C                   ENDIF
 
     C                   EVAL      WLstDayAmrt = 'Y'
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process only if posting amount is not zero
     C                   IF        WFeePostAmt1 <> *ZERO
 
     C     KCashFlow2    CHAIN     LEFEEDLJ
     C                   IF        %FOUND(LEFEEDLJ)
 
      ** Initialise flag to update LEFEEDLD file
     C                   EVAL      WUpdLEFEE = 'N'
 
      ** Generate Non-linear Account Key for current fee
     C                   EVAL      WFAcKeyG = 3
      *
     C                   EXSR      SrFeeAcKey
 
     C                   IF        FKEAMT <> *ZERO
      ** Output account key details to report
     C                   EXSR      SrFeeRprt1
 
      ** Update fee related files
     C                   EXSR      SrFeeDBUpd
     C                   ENDIF
 
      ** Update LEFEED if update flag has been set to 'Y'
     C                   IF        WUpdLEFEE = 'Y'
     C                   UPDATE    LEFEEDFJ
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
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
     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   EVAL      ZZTOTI = FZVLRF
     C                   EVAL      ZZTOTD = FZVLRL
     C                   EXSR      SrGLZAdd
     C                   EVAL      FZVLRF = ZZTOTI
     C                   EVAL      FZVLRL = ZZTOTD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcessLoan - Process loan updates and report details      *
      *****************************************************************
     C     SrProcessLoan BEGSR
 
     C                   EVAL      WDAmrtToDt = *ZEROS
 
     C                   EVAL      WDAmrtToDt = AMDS - WPrevAmrtToDt
 
     C                   IF        WDAmrtToDt < 0
     C                   EVAL      WDAmrtToDt = *ZEROS
     C                   ENDIF
      ** Calculate proportion of amortised amount to be posted for
      ** the current loan
     C**********         EVAL      WLoanPostAmt = (WPropTOTI/WkPropSum)                     BUG17315
     C**********                                   * WAmrtAmt - WDAmrtToDt                  BUG17315
     C                   EVAL(H)   WLoanPostAmt = (WPropTOTI/WkPropSum)                     BUG17315
     C                                             * WAmrtAmt - WDAmrtToDt                  BUG17315
 
      ** On the loan's last day of amortisation, post the difference
      ** between the total interest amount and it's non-linear
      ** amortisation amount to date thus avoid discrepancies between
      ** the final non-linear amortisation to date and total interest
     C                   IF        EIENDT <= WEvntCtlD
     C                   EVAL      WLoanPostAmt  = TOTI - AMDS
     C                   ENDIF
 
      ** Generate account key for current loan
     C                   EXSR      SrLoanAcKey
 
      ** Output account key details to report if posted amount
      ** is not zero
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
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
     C                   EVAL      WkCLAS = CLAS                                              CAS019
 
      ** Set position 3 to 'A' to denote an accrual date event
     C                   EVAL      WkTyp1 = 'A'
 
      ** Set position 6 to 'N' for nonlinear
     C                   EVAL      WkNlnr = 'N'
 
      ** Set position 7 to 9
     C                   EVAL      Wk7to9 = WkBKAKY
 
      ** Set fields for LKEY1DP based on output in LE0450
     C                   EVAL      LKRECI  =  'D'
     C                   EVAL      LKLNNO  =  LNRF
     C**********         EVAL      LKCNUM  =  CNUM                                           CAS019A
     C                   MOVEL     CNUM          LKCNUM                                      CAS019A
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
 
     C                   SELECT
      ** Discounted Loan that valued today
     C                   WHEN      WDiscLonVF = 'Y'
     C                   EVAL      WkTyp1 = 'V'
     C                   EVAL      WkACAMNT = TOTI
     C                   EVAL      LKEDAT   =  WEvntCtlD
 
      ** Discount Amount - TOTI
     C                   WHEN      WLoanReversFT = 'Y'
     C                   EVAL      WkTyp1 = 'V'
     C                   EVAL      LKREVI = 1
     C                   EVAL      WkACAMNT = TOTI
     C                   EVAL      LKEDAT   =  WEvntCtlD
 
      ** Amortised Amount - AMDS
     C                   WHEN      WLoanReversFA = 'Y'
     C                   EVAL      LKREVI  =  1
     C                   EVAL      WkACAMNT = AMDS
     C                   EVAL      LKEDAT   =  WEvntCtlD
 
      ** Daily Non-linear Amortisation
     C                   WHEN      WLoanProcess = 'Y'
 
     C                   EVAL      WkACAMNT = WLoanPostAmt
     C                   EVAL      LKEDAT   = WEvntCtlD
 
      ** Non-linear Amortisation Adjustment not yet posted
     C                   WHEN      WkANADJF = 'Y'
 
     C                   EVAL      WkACAMNT = ANADJ
     C                   EVAL      LKEDAT   = BJRDNB
 
     C                   IF        PTYP <> 67
     C                   EVAL      WkTyp2 = 'D'
     C                   ELSE
     C                   EVAL      WkTyp2 = 'C'
     C                   EVAL      WkACAMNT = 0 - WkACAMNT
     C                   ENDIF
 
      ** Dirty Price - UP/UL
     C                   WHEN      WLoanReversDP = 'Y'
     C**********         IF        EIDPTD <> 0                                                262608
     C                   IF        YAINT  <> 0                                                262608
     C                   EVAL      LKREVI  =  1
     C**********         EVAL      WkACAMNT = EIDPTD                                          258474
     C**********         EVAL      WkACAMNT = LNNPVA - EIDPTD                          258474 262608
     C                   EVAL      WkACAMNT = YAINT                                           262608
     C                   EVAL      LKEDAT   =  WEvntCtlD
     C                   EVAL      WkNlnr = *BLANK
     C                   EVAL      Wk7to9 = ' NU'
      *
     C                   IF        WKACAMNT > 0
     C                   EVAL      WkTyp2 = 'P'
     C                   ELSE
     C                   EVAL      WkACAMNT = -(WKACAMNT)
     C                   EVAL      WkTyp2 = 'L'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WHEN      WPostUPULF = 'Y'
 
     C                   EVAL      WkNlnr = *BLANK
     C                   EVAL      Wk7to9 = ' NU'
 
      ***Post*Dirty*Price*today****************************************                       262608
      ** Post Nonlinear Unrealised Profit/Loss                                                262608
     C                   IF        EIDPTD <> 0
     C                             AND EIENDT > WEvntCtlD                                     240798
     C                   EVAL      LKREVI  =  0
     C**********         EVAL      WkACAMNT = EIDPTD                                          258474
     C                   EVAL      WkACAMNT = LNNPVA - EIDPTD                                 258474
     C                   EVAL      LKEDAT   =  WEvntCtlD
      *
     C                   IF        WKACAMNT > 0
     C                   EVAL      WkTyp2 = 'P'
     C                   ELSE
     C                   EVAL      WkACAMNT = -(WKACAMNT)
     C                   EVAL      WkTyp2 = 'L'
     C                   ENDIF
 
      ** Set account key and event amount
      ** Do not generate unrealised UP/UL if NPV = 0 and Yield curve is blank.                258474
     C                   IF        LNNPVA <> 0                                                258474
     C                             and LNYLDC <> *blank                                       258474
     C                   EVAL      WkYAINT  = LNNPVA - EIDPTD                                 262608
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
 
     ** Generate Report
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF                                                                258474
                                                                                              258474
     C                   ENDIF
 
      ***Post*Reversal*of*Yesterday's*Dirty*Price**********************                       262608
      ** Post Reversal of Yesterday's NL Unrealised P/L                                       262608
     C**********         IF        EIPRDP <> 0                                                262608
     C                   IF        YAINT  <> 0                                                262608
     C                   EVAL      LKREVI  =  1
     C**********         EVAL      WkACAMNT = EIPRDP                                          262608
     C                   EVAL      WkACAMNT = YAINT                                           262608
     C                   EVAL      LKEDAT   =  WEvntCtlD
      *
     C                   IF        WKACAMNT > 0
     C                   EVAL      WkTyp2 = 'P'
     C                   ELSE
     C                   EVAL      WkACAMNT = -(WKACAMNT)
     C                   EVAL      WkTyp2 = 'L'
     C                   ENDIF
 
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
 
     ** Generate Report
     C                   IF        LKEAMT <> *ZERO
     C                   EXSR      SrLoanReprt
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        WPostUPULF <> 'Y'
 
      ** Populate WkTyp2
     C                   IF        WLoanReversDP <> 'Y' AND
     C                             WkANADJF <> 'Y'
     C                   IF        TOTI > *ZERO
     C                   EVAL      WkTyp2 = 'D'
     C                   ELSE
     C                   EVAL      WkTyp2 = 'P'
     C                   EVAL      WkACAMNT = 0 - WkACAMNT
     C                   ENDIF
     C                   ENDIF
 
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
 
     C                   ENDIF
 
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
 
     C                   EVAL      WEirStDate = EISTDT
 
      ***Update*Loan*details*file*for*non-reversals********************                       262600
     C*****LNRF*         SETLL     LEEIRDL8                                                   262600
     C*****LNRF*         READE     LEEIRDL8                                                   262600
     C**********         DOW       NOT %EOF(LEEIRDL8) AND                                     262600
     C**********                   F8STDT <> WEirStDate                                       262600
      **********                                                                              262600
     C**********         IF        F8RECI = 'D' AND                                           262600
     C**********                   F8FDPA <> *ZERO  OR                                        262600
     C**********                   F8RECI = 'M' AND                                           262600
     C**********                   F8FDPA <> *ZERO                                            262600
     C**********         ADD       F8AMTD        WAmrtoDate                                   262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C*****LNRF*         READE     LEEIRDL8                                                   262600
     C**********         ENDDO                                                                262600
 
     C**********         EVAL      AFDP = WAmrtAmt + WamrtoDate                               262600
     C                   EVAL      AFDP = WAmrtAmt                                            262600
 
     C                   EVAL      AMDS = AMDS + WLoanPostAmt
     C                   EVAL      AMADJ = AMADJ + ANADJ
     C                   EVAL      DSAM = DSAM - WLoanPostAmt
     C                   EVAL      YMCOST = AMCOST
     C                   EVAL      AMCOST = PDrtPrcTdy
 
     C                   EVAL      WUpdCLOAN = 'Y'
 
      ** Update EIR details file
     C                   EVAL      EIRECI = RECI
     C                   EVAL      EIAMTD = WAmrtAmt
     C                   EVAL      EIPRCP = EICPTD
     C                   EVAL      EIPRDP = EIDPTD
     C                   EVAL(R)   EICPTD = PClnPrcTdy
     C                   EVAL(R)   EIDPTD = PDrtPrcTdy
 
      ** Move ANADJ to temporary variable before update
     C                   EVAL      WAdjNPos = ANADJ
 
     C                   EVAL      ANADJ = *ZERO
 
     C                   EVAL      WUpdLEEIR = 'Y'
 
      ** Update EIRA Amortised to Date for Discounted Loan
     C                   EVAL      KLoan = LNRF
     C                   EVAL      KFSeq = *ZEROS
 
     C     KLoanFSeq     CHAIN     LEEIRAL5
     C                   IF        %FOUND(LEEIRAL5)
     C**********         EVAL      EAAAMP = WAmrtAmt                                        AR811215
     C                   EVAL      EAAAMP = AMDS                                            AR811215
     C                   UPDATE    LEEIRAD0
     C                   ENDIF
 
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
     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   EVAL      ZZTOTI = LZVLRF
     C                   EVAL      ZZTOTD = LZVLRL
     C                   EXSR      SrGLZAdd
     C                   EVAL      LZVLRF = ZZTOTI
     C                   EVAL      LZVLRL = ZZTOTD
 
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
      *  SrLoanReprt - Output generated account key detail to report  *
      *****************************************************************
     C     SrLoanReprt   BEGSR
 
      ** Initialise report detail fields
     C                   CLEAR                   DETAIL31
 
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
 
      ** Write P3 header if required
     C                   Z-ADD     8             RQDLN3
     C     OFLLN3        SUB       PRTLN3        DIFLN3
     C     DIFLN3        IFLE      RQDLN3
     C                   WRITE     HEADP3
     C                   ENDIF
 
     C                   WRITE     DETAIL31
 
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
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY
 
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
                                                                                              CLE134
     C                   IF        PRtCd = *BLANKS                                            CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
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
     C                   KFLD                    CLAS                                         CAS019
 
      ** Key list for LEEIRAL5 keyed on loan number and fee sequence
     C     KEffIntR      KLIST
     C                   KFLD                    FELOAN
     C                   KFLD                    FEFSEQ
 
      ** Key list for LEEIRAL5 keyed on loan number and fee sequence
     C     KLoanFSeq     KLIST
     C                   KFLD                    KLoan
     C                   KFLD                    KFSeq
 
      ** Key list for LEFEEDLD keyed on loan number and fee sequence
     C     KFees         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    KFeeSq
 
      ** Key list for FCLTYL1 keyed on facility branch, facility
      ** customer, facility type, and facility sequence
     C     KFacility     KLIST
     C                   KFLD                    FCLB
     C                   KFLD                    FCUS
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ
 
      ** Key list for LECFSFL1
     C     KCashFlow1    KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    EIFSEQ
     C                   KFLD                    KDate
 
      ** Key list for LECFSFL2
     C     KCashFlow2    KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    EIFSEQ
 
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
      *                                                                                       264058
      ** Remove SEQONLY parameter from overrides of ZAHTRNL0 and ZAAMRTL0                     264058
      *                                                                                       264058
**  CPY@
(c) Finastra International Limited 2006
** ##OVR
OVRDBF FILE(ZAAMRTL0) TOFILE(LEAMRTL0)                                                        264058
DLTOVR FILE(ZAAMRTL0)
OVRDBF FILE(ZAHTRNL0) TOFILE(LEHTRNL0)                                                        264058
DLTOVR FILE(ZAHTRNL0)
CLRPFM FILE(LEAMRTPD)
