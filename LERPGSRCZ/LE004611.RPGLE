     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Effective Interest Rate Update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending module                              *
      *                                                               *
      *  LE004611 - LE Effective Interest Rate Period Update          *
      *                                                               *
      *  Function:  This new program will be created to generate the  *
      *             present and future cash flows for the calculation *
      *             of the effective interest rate.  It will also     *
      *             update EIR detail file.                           *
      *                                                               *
      *  Component of: LEC004611                                      *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR784436           Date 22Jun11               *
      *                 AR782803           Date 03Jun11               *
      *                 AR747507           Date 24May11               *
      *                 262607             Date 27Jan10               *
      *                 262665             Date 16Jun09               *
      *                 262654             Date 11May09               *
      *                 262628             Date 03Apr09               *
      *                 262618             Date 17Mar09               *
      *                 262600             Date 19Feb09               *
      *                 248603             Date 05Feb08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17290           Date 25Apr08               *
      *                 CAS019A            Date 26Jul07               *
      *                 248260             Date 17May07               *
      *                 CAS019             Date 29May07               *
      *                 246573             Date 21Mar07               *
      *                 240808             Date 29May06               *
      *                 240779             Date 20May06               *
      *                 CAS016  *CREATE    Date 28Feb06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR784436 - Wrong amortised F/D/P to date and amortised cost  *
      *             after change in base rate                         *
      *  AR782803 - Cash flow of principal amount is doubled          *
      *  AR747507 - Incorrect EIR computed on discounted loan. Create *
      *             Present Cash flow record when processing start    *
      *             amount for discounted loans. (Child: Artf747508)  *
      *  262607 - Don't process fully prepaid loans                   *
      *  262665 - Consider interest calculation basis from loan if    *
      *           not defined on IAS ICD                              *
      *  262654 - Enlarge EIR output field to match size of EIR       *
      *           field on LE and MM files.                           *
      *  262628 - Produce an audit report showing the cash flows      *
      *           sent to ZAEIRCALC for the calculation of the EIR.   *
      *  262618 - Ignore Past Due cash flows to avoid duplication of  *
      *           events. Rework of core fix 258942.                  *
      *  262600 - Rewrite subroutines SRCFAmortLife, SRCFAmortise,    *
      *           SRCFPresent  to ensure correct results when EIR is  *
      *           recalculated.                                       *
      *           Create a dummy cash flow for the outstanding        *
      *           principal and interest at the end of the EIR        *
      *           period - if this happens before loan maturity.      *
      *           Add outstanding interest to the dummy cash          *
      *           flow event created for principal at start of EIR    *
      *           period.                                             *
      *  248603 - Wrong EIR because loan maturity falls on holiday.   *
      *           Use adjusted maturity date when generating future   *
      *           cash flows and when computing for EIR. Zeroise      *
      *           EFNDEI when maturity has been adjusted forward.     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17290 - Additional filters for EIRD/ERAP Cashflows        *
      *  CAS019A - CAS016 Upgrade to Midasplus-Alphanumeric Customer  *
      *            (Recompile)                                        *
      *  248260 - Amort Separately Fees' EIR not computed correctly   *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  246573 - EIR incorrectly computed with past due transactions *
      *  240808 - Cashflow with incorrect amortisation amount.        *
      *  240779 - Missing posting of daily accruals of discount.      *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period)                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
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
      ** +--------------------------------------+
      ** Ê F-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
 
      ** Midas LE Effective Interest Rate Detail File
     FLEEIRDL7  UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LEEIRHD0)
     F                                     PREFIX(PR_:2)
 
      ** Midas LE EIR Amortisation Over Period Detail
     FLEERAPL3  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Effective Interest Rate Detail File
     FLEEIRDL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEEIRDD0:LEEIRDD3)
     F                                     PREFIX(CR_:2)
 
      ** Midas LE EIR Present Cash Flow File
     FLEEIRPL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Midas LE EIR Future Cash Flow File
     FLEEIRFL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Midas LE Loan Details File
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(CL)
 
      ** Midas EIR Loan Amount History File
     FLEHTRNL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas EIR Cash Flow Detail File
     FLECFSFL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas EIR Cash Flow Detail File
     FLECFLSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LECFLSD0:LECFLSDF)
 
      ** Midas LE Effective Interest Rate Amortisation file
     F*LEEIRAL5  IF   E           K DISK    INFSR(*PSSR)                                      240808
     F***LEEIRAL5  UF   E           K DISK    INFSR(*PSSR)                             240808 262600
 
      * Midas LE Lending Fees File
     F***LEFEEDLI  IF   E           K DISK    INFSR(*PSSR)                                    CAS019
     FLEFEEDLN  IF   E           K DISK    INFSR(*PSSR)                                       CAS019
 
      ** Midas LE Cashflows File for Amortisation Calc
     FLEAMRTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
                                                                                              262628
      ** Midas LE EIR Calculation Audit Report                                                262628
     FLE004611P1O    E             PRINTER INFDS(SPOOL1)                                      262628
 
      ****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** Ê D-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D ##OX1           S             80    DIM(11) CTDATA PERRCD(1)
 
      ***Array*for*determining*proportions*of*amounts*and*fees*********                       262600
     D*WFPropAmt       S             15P 0 DIM(99)                                            262600
     D*WFSeq****       S              2  0 DIM(99)                                            262600
     D*WFXrate**       S             11P 7 DIM(99)                                            262600
     D*WFMDin***       S              1A   DIM(99)                                            262600
     D*WFAmrtAmtToDt   S             15P 0 DIM(99)                                            262600
     D*WFeePostAmt     S             15P 0 DIM(99)                                            262600
      ** +--------------------------------------+
      ** Ê External data areas                  Ê
      ** Ê ===================                  Ê
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
 
      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
 
      ** Program Status Data Structure
      /COPY ZACPYSRC,PSDS
                                                                                              262628
      ** File Information Data Structure for LE004611P1.                                      262628
     D SPOOL1          DS                                                                     262628
     D  SFILE1                83     92                                                       262628
     D  SFNUM1               123    124B 0                                                    262628
     D  OFLLN1               188    189B 0                                                    262628
     D  PRTLN1               367    368B 0                                                    262628
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Midas Modules details accessed via access program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Hedging ICD Details
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
 
      ** Fee Details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
 
      ** General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      * Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
                                                                                              262628
      ** External data structure for Currency Details                                         262628
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  262628
 
      ** ZAEIRF Data Structure
     D ZAEIRF        E DS                  EXTNAME(ZAEIRFPD)
 
      ** ZAAMRT Data Structure
     D ZAAMRT        E DS                  EXTNAME(ZAAMRTPD)
 
      ** QCMDEXC Parameters
     D pMESOVR         S             80A
     D pMESLEN         S             15P 5 INZ(80)
 
     D @RUN            S              1
     D @ICBS           S              1S 0
     D @NDYY           S              3S 0
 
      ** ZINTDY Parameters
     D ZZINDY          S              5  0
     D ZZBEG           S              5  0
     D ZZEND           S              5  0
     D ZZCALC          S              1A
                                                                                              262600
      ** Parameters for calling GLINTC                                                        262600
     D pZIBEG          S              5  0                                                    262600
     D pZIEND          S              5  0                                                    262600
     D pZICALC         S              1  0                                                    262600
     D pZIAMT          S             15  0                                                    262600
     D pZIRATE         S             11  7                                                    262600
     D pZINTR          S             30  9                                                    262600
                                                                                              262628
      ** Currency key                                                                         262628
     D PCCY            S              3A                                                      262628
                                                                                              262628
      ** ZSEdit parms                                                                         262628
     D ZFLD15          S             15P 0                                                    262628
     D ZDECS           S              1P 0                                                    262628
     D ZECODE          S              1A                                                      262628
     D ZOUT21          S             21A                                                      262628
                                                                                              262628
      ** ZEdit2 parms                                                                         262628
     D ZFIELD          S             16A                                                      262628
     D ZADEC           S              2P 0                                                    262628
                                                                                              262628
      ** ZSFile parms                                                                         262628
     D ZSEQ            S              5A                                                      262628
     D ZSENTY          S              3A                                                      262628
     D ZSNUM           S              6S 0                                                    262628
     D ZSERR           S              1A                                                      262628
 
      ** Work Variables
     D wEvCD           S              5  0
     D wCFOpen         S              1A
     D wAMRTOpen       S              1A
     D wSTRec          S              1A
     D wERAPRec        S              1A   INZ('N')
     D*WCAMT****       S                   LIKE(PRAM)                                         262600
     D*WAllFeePaidTdy  S             17P 0                                                    262600
     D wEIFSEQ         S                   LIKE(EIFSEQ)
     D*wIX******       S              2S 0                                                    262600
     D*wAmortAmount    S             15P 0                                                    262600
     D*wNumOfFees      S              2S 0                                                    262600
     D*wkFeePropSum    S             20P 5                                                    262600
     D*WPropTOTI       S             20P 5                                                    262600
     D*WPrevAmrtToDt   S                   LIKE(FEAMTD)                                       262600
     D*WkPropSum       S             20P 5                                                    262600
     D WEIAMTD         S             15P 0                                                    262600
     D WTime           S              4F                                                      262600
     D WkCPAM          S                   LIKE(CPAM)                                         262600
     D WkVDAT          S                   LIKE(VDAT)                                         262600
     D WkINTR          S                   LIKE(INTR)                                         262600
     D WkEIR           S             16S 8                                                    262628
     D RQDLN1          S              3S 0                                                    262628
     D DIFLN1          S              3S 0                                                    262628
     D ZDAYNO          S              5  0                                                    262628
     D ZDATE           S              6  0                                                    262628
     D ZADATE          S              7A                                                      262628
     D PRtCd           S              7A                                                      262628
     D POpTn           S              7A                                                      262628
     D WPRVEIR         S              1A                                                    AR784436
 
      ** Key fields
     D kEITRAN         S                   LIKE(EITRAN)
     D kEIDate         S                   LIKE(EIENDT)
     D kEIFSEQ         S                   LIKE(EIFSEQ)
 
      ** Work fields for SR/SREIRCalc
      ** Input Parameter
     D*PInpTNRF*       S              6S 0                                                    CLE148
     D PInpTNRF        S              6A                                                      CLE148
     D PInpStartEff    S              5P 0
     D PInpEndEff      S              5P 0
 
      ** Output Parameter
     D*POutEIR**       S             14P12                                                    262654
     D POutEIR         S             15P10                                                    262654
     D PReturnCode     S              7A
 
      ** Whether or not *PSSR has been run previously
     D RunBefore       S              1A
 
      ** Parameters for AOBANKR0
     D pRetCode        S              7A
     D pOption         S              7A
 
      ** ZAAMRTCALC Parameter (Alpha)
     D PAmortDSA       S            200A
 
      ** ZAAMRTCALC DS breakdown
     D PAmortDS        DS           200
     D  PPGMName                     10A   INZ('LE004611')
     D  wEffIntRate                  15P10
     D  wEISTDT                       5P 0
     D  wEIENDT                       5P 0
     D  CLLNRF
     D  wMaturityDate                 5P 0
     D  wStartPrd                     5P 0
     D  wEndDate                      5P 0
     D  wTOTI                        13P 0
     D  wAccInd                       1A   INZ('L')
     D  wEIDPTD                      15P 0
     D  wEICPTD                      15P 0
     D  wIntCalcBasis                 1P 0
     D  wProcType                     1A
     D  wkLoanInd                     1A
     D  pStopAccrualF                 1A
     D  wAmrtAmt                     17P 0
     D  pDrtPrcTdy                   15P 0
     D  pClnPrcTdy                   15P 0
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** Ê                                                                Ê
      ** Ê Initial processing is performed automatically: the *INZSR is   Ê
      ** Ê executed at program activation.                                Ê
      ** Ê                                                                Ê
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Open Cash flow file
     C                   EVAL      wCFOpen = 'N'
     C                   OPEN      LEEIRPL0
     C                   OPEN      LEEIRFL0
     C                   OPEN      LEAMRTL0
     C                   EVAL      wAMRTOpen = 'Y'
     C                   EVAL      wCFOpen = 'Y'
 
      ** Process cash flows for Amortisation over Period
     C                   EXSR      SRCFAmortPrd
 
      ** Process cash flows for Amortisation over Life
     C                   EXSR      SRCFAmortLife
                                                                                              262628
      ** Print report footer                                                                  262628
     C                   EXSR      RepFooter                                                  262628
 
      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCFAmortPrd - Generate Amortisation Cashflows over Period    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRCFAmortPrd  BEGSR
 
      ** Read thru Amortisation Over Period Detail File
     C     *LOVAL        SETLL     LEERAPL3
     C                   READ      LEERAPL3
 
     C                   DOW       NOT %EOF(LEERAPL3)
 
     C                   EVAL      wERAPRec = 'Y'
      ** Check recalculation indicator
     C                   IF        EIRCAL = 'Y'
     C     EITRAN        CHAIN     CLOANCLF                           20
                                                                                              262628
      ** Print report header                                                                  262628
     C                   EVAL      *IN50 = *ON                                                262628
     C                   EXSR      RepHeader                                                  262628
 
      ** Clear cash flow records for next EIR processing
     C                   EXSR      SRClearCF
 
      ** Save period details for present/future cashflow processing
     C                   EVAL      wEIENDT = EIENDT
     C                   EVAL      wEISTDT = EISTDT
     C                   EVAL      kEITRAN = EITRAN
 
      ** Generate Present Cashflows
     C                   EVAL      kEIDate = EISTDT
     C                   EVAL      wEIFSEQ = EIFSEQ
     C                   EXSR      SRCFPresent
     C                   EVAL      kEIFSEQ = EIFSEQ
 
      ** Generate Future Cashflows
     C                   EXSR      SRCFFuture
 
      ** Determine EIR by calling calculator
     C                   EVAL      PInpTNRF = EITRAN
     C                   EVAL      PInpStartEff = EISTDT
     C                   EVAL      PInpEndEff   = EIENDT
     C                   EXSR      SREIRCalc
 
      ** Amend Recalculation indicator to blank and update File
     C                   EVAL      EIRCAL = ' '
     C                   EVAL      EIEIR = wEffIntRate
     C                   UPDATE    LEERAPD0
     C                   ENDIF
 
      ** Read Next Amortisation Over Period Detail File
     C                   READ      LEERAPL3
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                       262600
      **SRCFAmortLife*-*Generate*Amortisation*Cashflows*over*Life******                       262600
      *****************************************************************                       262600
      **Called*by:*Main************************************************                       262600
      *****************************************************************                       262600
      **Calls:*SRCFPresent,*SRCFFuture*********************************                       262600
      *****************************************************************                       262600
      *****************************************************************
      **********                                                                              262600
     C*****SRCFAmortLife BEGSR                                                                262600
      **********                                                                              262600
      ***Read*thru*EIR*Detail*File*************************************                       262600
     C******LOVAL        SETLL     LEEIRDD3                                                   262600
     C**********         READ      LEEIRDD3                                                   262600
     C**********         DOW       NOT %EOF(LEEIRDL3)                                         262600
      **********                                                                              262600
     C**********         EVAL      wERAPRec = 'N'                                             262600
      ***Check*loan*details********************************************                       262600
     C*****CR_TRAN       CHAIN     CLOANCLF                           20                      262600
      **********                                                                              262600
      ***Clear*cash*flow*records*for*next*EIR*processing***************                       262600
     C**********         EXSR      SRClearCF                                                  262600
      **********                                                                              262600
      ***Check*Previous*EIR*period*************************************                       262600
     C**********         EVAL      kEITRAN = CR_TRAN                                          262600
     C**********         EVAL      kEIDate = CR_STDT                                          262600
     C*****KLoanDate     SETLL     LEEIRDD0                                                   262600
     C**********         READP     LEEIRDD0                                                   262600
      **********                                                                              262600
      ***Recalculate*previous*period***********************************                       262600
     C**********         IF        NOT %EOF(LEEIRDL7)                                         262600
     C**********                   AND CR_TRAN = PR_TRAN                                      262600
      **********                                                                              262600
      ***Get*EIR*of*previous*record************************************                       262600
     C**********         EVAL      PR_EIR = PR_EIR                                            262600
      **********                                                                              262600
     C**********         IF        CR_DPTD = 0                                                262600
      **********                                                                              262600
     C**********         IF        CR_STDT < PR_LADT                                          262600
     C**********                   OR PR_LADT = 0                                             262600
      **********                                                                              262600
      ***Determine*amortisation*amount*********************************                       262600
     C**********         EXSR      SRAmortAmt                                                 262600
      **********                                                                              262600
      ***Set*parameter*to*compute*for*amortisation*for*EIR*start*******                       262600
      ***date*until*last*amortisation*date.****************************                       262600
      **********                                                                              262600
     C**********         EVAL      wkLoanInd  = 'L'                                           262600
     C**********         EVAL      wStartPrd  = PR_STDT                                       262600
     C**********         EVAL      wEndDate   = CR_STDT                                       262600
     C**********         EVAL      wEISTDT    = PR_STDT                                240808 262600
     C**********         EVAL      wEIENDT    = CR_STDT                                240808 262600
      **********                                                                              262600
      ***No.*of*Days*in*Interest*Year**********************************                240808 262600
     C**********         EVAL      @ICBS = CLICBS                                      240808 262600
     C**********         EXSR      SRDayNum                                            240808 262600
     C**********         MOVE      ZZCALC        wIntCalcBasis                                262600
     C**********         EVAL      wIntCalcBasis = CLICBS                              CAS019 262600
      **********                                                                              262600
     C**********         EVAL      wTOTI = *ZERO                                              262600
     C**********         IF        CLPTYP = 63                                                262600
     C**********                   OR CLPTYP = 65                                             262600
     C**********                   OR CLPTYP = 67                                             262600
     C**********         EVAL      wProcType = 'D'                                            262600
      **********                                                                              262600
     C**********         EVAL      kEITRAN = PR_TRAN                                          262600
     C**********         EVAL      kEIFSEQ = *ZEROS                                           262600
     C**********         EVAL      wEISTDT = PR_STDT                                          262600
     C*****KTranFSeq     CHAIN     LEEIRAL5                                                   262600
     C**********         IF        %FOUND(LEEIRAL5)                                           262600
     C**********         EVAL      EAAAMT = EAAMNT - EAAAMP                                   262600
     C**********         EVAL      wTOTI = EAAAMT                                             262600
     C**********         UPDATE    LEEIRAD0                                                   262600
     C**********         ENDIF                                                                262600
     C**********         ELSE                                                                 262600
     C**********         EVAL      wProcType = ' '                                            262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Set*previous*dirty*and*clean*price*to*zero*since*amortisation*                       262600
      ***being*calculated*begins*at*EIR*start*date*********************                       262600
     C**********         EVAL      wEIDPTD = PR_DPTD                                          262600
     C**********         EVAL      wEICPTD = PR_CPTD                                          262600
     C**********         EVAL      wEffIntRate = PR_EIR                                       262600
      **********                                                                              262600
     C**********         EVAL      PStopAccrualF = ' '                                        262600
     C**********         TESTB     '3'           CLLONI                   50                  262600
     C**********         IF        *IN50 = *ON                                                262600
     C**********         EVAL      PStopAccrualF = 'Y'                                        262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Call*AmortCalc************************************************                       262600
     C**********         EXSR      SRAmortCalc                                                262600
      **********                                                                              262600
      ***Set*dirty*and*clean*price*************************************                       262600
     C**********         EVAL(R)   PR_PRCP = PR_CPTD
     C**********         EVAL(R)   PR_PRDP = PR_DPTD
     C**********         EVAL(R)   PR_CPTD = pClnPrcTdy                                       262600
     C**********         EVAL(R)   PR_DPTD = pDrtPrcTdy                                       262600
     C**********         EVAL      PR_AMAJ = wAmrtAmt                                         262600
     C**********         EVAL      PR_LADT = wEndDate - 1                                     262600
     C**********         EVAL      PR_RCAL = ' '                                              262600
     C**********         UPDATE    LEEIRDD0                                                   262600
     C**********         ENDIF                                                                262600
     C**********         ENDIF                                                                262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***If*no*previous*period*exist*for*the*loan*compute*current*period                      262600
     C**********         EVAL      kEITRAN = CR_TRAN                                          262600
     C**********         EVAL      kEIDate = CR_STDT                                          262600
      **********                                                                              262600
      ***Save*period*details*for*present/future*cashflow*processing****                       262600
     C**********         EVAL      wEIENDT = CR_ENDT                                          262600
     C**********         EVAL      wEISTDT = CR_STDT                                          262600
     C**********         EVAL      wEIFSEQ = 0                                                262600
      ***Generate*Present*Cashflows************************************                       262600
     C**********         EXSR      SRCFPresent                                                262600
      **********                                                                              262600
      ***Generate*Future*Cashflows*************************************                       262600
     C**********         EVAL      kEIDate = CR_STDT                                          262600
     C**********         EXSR      SRCFFuture                                                 262600
      **********                                                                              262600
      ***Determine*EIR*by*calling*calculator***************************                       262600
     C**********         EVAL      PInpTNRF = CR_TRAN                                         262600
     C**********         EVAL      PInpStartEff = CR_STDT                                     262600
      **********                                                                       248603 262600
     C**********         CALL      'ZFWDT'                                             248603 262600
     C**********         PARM      CR_ENDT       PInpDay                               248603 262600
     C**********         PARM                    PDaysFwd                              248603 262600
     C**********         PARM      *ZERO         POutDay                               248603 262600
     C**********         PARM      CLCCY         PCYCD                                 248603 262600
     C**********         PARM      *BLANKS       PLocation                             248603 262600
      **********                                                                       248603 262600
     C**********         SELECT                                                        248603 262600
     C**********         WHEN      POutDay = CR_ENDT                                   248603 262600
     C**********         EVAL      PInpEndEff   = CR_ENDT                                     262600
     C**********         WHEN      POutDay > CR_ENDT                                   248603 262600
     C**********                   OR POutDay < CR_ENDT                                248603 262600
     C**********         EVAL      PInpEndEff   = POutDay                              248603 262600
     C**********         ENDSL                                                         248603 262600
     C**********         EXSR      SREIRCalc                                                  262600
      **********                                                                              262600
      ***Amend*Recalculation*indicator*to*blank*and*update*File********                       262600
     C**********         EVAL      CR_RCAL = ' '                                              262600
     C**********         EVAL      CR_EIR = wEffIntRate                                       262600
      **********                                                                              262600
     C**********         UPDATE    LEEIRDD3                                                   262600
      **********                                                                              262600
      ***Read*next*EIR*Detail*File*************************************                       262600
     C**********         READ      LEEIRDL3                                                   262600
     C**********         ENDDO                                                                262600
      **********                                                                              262600
     C**********         ENDSR                                                                262600
      *****************************************************************
      /EJECT
      *****************************************************************                       262600
      *                                                               *                       262600
      * SRCFAmortLife - Calculate EIR over loan life                  *                       262600
      *                                                               *                       262600
      * Called by: Main                                               *                       262600
      *                                                               *                       262600
      * Calls: SRDayNum, SRZINTDY, SRClearAMRT, SRCFAmortise,         *                       262600
      *        SRAmortCalc, SRClearCF, SRCFPresent, SRCFFuture        *                       262600
      *        SREIRCalc, RepHeader, ZFWDT                            *                       262600
      *                                                               *                       262600
      *****************************************************************                       262600
                                                                                              262600
     C     SRCFAmortLife BEGSR                                                                262600
                                                                                              262600
     C                   EVAL      wERAPRec = 'N'                                             262600
                                                                                              262600
      ** Read thru EIR Detail File                                                            262600
     C     *LOVAL        SETLL     LEEIRDD3                                                   262600
     C                   READ      LEEIRDD3                                                   262600
                                                                                              262600
     C                   DOW       NOT %EOF(LEEIRDL3)                                         262600
                                                                                              262600
      ** Access loan details                                                                  262600
     C     CR_TRAN       CHAIN     CLOANCLF                                                   262600
                                                                                              262607
      ** If loan fully prepaid setoff recalc flag and don't process                           262607
     C                   IF        CLCPAM = *ZERO                                             262607
     C                             AND CLVDAT < BJRDNB                                        262607
     C                   EVAL      CR_RCAL = ' '                                              262607
     C                   UPDATE    LEEIRDD3                                                   262607
     C                   READ      LEEIRDD3                                                   262607
     C                   ITER                                                                 262607
     C                   ENDIF                                                                262607
                                                                                              262600
      ** Clear cash flow records for next EIR processing                                      262600
     C                   EXSR      SRClearCF                                                  262600
                                                                                              262628
      ** Print report header                                                                  262628
     C                   EVAL      *IN50 = *OFF                                               262628
     C                   EXSR      RepHeader                                                  262628
                                                                                              262600
      ** No. of Days in Interest Year                                                         262600
     C                   EVAL      @ICBS = CLICBS                                             262600
     C                   EXSR      SRDayNum                                                   262600
                                                                                              262600
      ** Reset work fields for prices at start of period                                      262600
     C                   EVAL      wEIDPTD = *ZERO                                            262600
     C                   EVAL      wEICPTD = *ZERO                                            262600
     C                   EVAL      wEIAMTD = *ZERO                                            262600
     C                   EVAL      PR_LADT = *ZERO                                            262600
     C                   EVAL      WPRVEIR = 'N'                                            AR784436
                                                                                              262600
      ** Access previous period details                                                       262600
     C                   EVAL      kEITRAN = CR_TRAN                                          262600
     C                   EVAL      kEIDate = CR_STDT                                          262600
     C     KLoanDate     SETLL     LEEIRDD0                                                   262600
     C     CR_TRAN       READPE    LEEIRDD0                                                   262600
                                                                                              262600
      ** If details of previous period found                                                  262600
     C                   IF        NOT %EOF(LEEIRDL7)                                         262600
                                                                                              262600
      ** If Last Amortisation Date is on or after EIR Period Start Date                       262600
      ** then there was a backvalued amendment and we need to recalcu-                        262600
      ** late the Amortised Cost at the end of the previous period                            262600
     C                   IF        CR_STDT <= PR_LADT                                         262600
     C                   EVAL      wEISTDT = PR_STDT                                          262600
                                                                                              262600
      ** Determine amortised cost at beginning of previous period. This                       262600
      ** can either be zero (if previous period was the first in the                          262600
      ** loan life) or can be obtained from the period before previous.                       262600
                                                                                              262600
     C     CR_TRAN       READPE    LEEIRDD0                                                   262600
                                                                                              262600
     C                   IF        %EOF(LEEIRDL7)                                             262600
     C                   EVAL      wEIDPTD = *ZERO                                            262600
     C                   EVAL      wEICPTD = *ZERO                                            262600
     C                   EVAL      wEIAMTD = *ZERO                                            262600
     C                   ELSE                                                                 262600
     C                   EVAL      wEIDPTD = PR_DPTD                                          262600
     C                   EVAL      wEICPTD = PR_CPTD                                          262600
     C                   EVAL      wEIAMTD = PR_AMTD                                          262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Reposition to the previous period                                                    262600
     C     KLoanDate     SETLL     LEEIRDD0                                                   262600
     C     CR_TRAN       READPE    LEEIRDD0                                                   262600
                                                                                              262600
      ** If Last Amortisation Date is before EIR Period Start Date                            262600
      ** then there is no backvalued amendment and we need to recalcu-                        262600
      ** late the Amortised Cost from the Last Amortisation Date                              262600
     C                   ELSE                                                                 262600
     C                   EVAL      wEISTDT = PR_LADT                                          262600
     C                   EVAL      wEIDPTD = PR_DPTD                                          262600
     C                   EVAL      wEICPTD = PR_CPTD                                          262600
     C                   EVAL      wEIAMTD = PR_AMTD                                          262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Clear previous amortisation cash flows                                               262600
     C                   EXSR      SRClearAMRT                                                262600
                                                                                              262600
      ** Setup parameters and amortisation cash flows in order to                             262600
      ** calculate the amortised cost at the start of the new period                          262600
                                                                                              262600
     C                   EVAL      wEffIntRate = PR_EIR                                       262600
     C                   EVAL      wEIENDT    = CR_ENDT                                       262600
     C                   EVAL      wMaturityDate = CLMDAT                                     262600
     C                   EVAL      wStartPrd  = wEISTDT                                       262600
     C                   EVAL      wEndDate   = CR_STDT                                       262600
     C                   EVAL      wTOTI = CLTOTI                                             262600
     C                   EVAL      wIntCalcBasis = CLICBS                                     262600
     C                   IF        CLPTYP = 63 OR CLPTYP = 65 OR CLPTYP = 67                  262600
     C                   EVAL      wProcType = 'D'                                            262600
     C                   ELSE                                                                 262600
     C                   EVAL      wProcType = *BLANKS                                        262600
     C                   ENDIF                                                                262600
     C                   EVAL      wkLoanInd  = 'L'                                           262600
                                                                                              262600
      ** Generate cash flows for previous period                                              262600
     C                   EXSR      SRCFAmortise                                               262600
                                                                                              262600
     C                   EVAL      WPRVEIR = 'Y'                                            AR784436
     C                   IF        wAccInd <> 'F'                                           AR784436
      ** Call AmortCalc                                                                       262600
     C                   EXSR      SRAmortCalc                                                262600
                                                                                              262600
      ** Increase work fields for prices at start of period                                   262600
     C                   EVAL      wEIDPTD = pDrtPrcTdy                                       262600
     C                   EVAL      wEICPTD = pClnPrcTdy                                       262600
     C                   EVAL      wEIAMTD = wEIAMTD + WAmrtAmt                               262600
                                                                                              262600
      ** Update the details of the previous EIR period on file                                262600
     C                   EVAL      PR_CPTD = pClnPrcTdy                                       262600
     C                   EVAL      PR_DPTD = pDrtPrcTdy                                       262600
     C                   EVAL      PR_AMTD = wEIAMTD                                          262600
     C                   EVAL      PR_LADT = CR_STDT                                          262600
                                                                                              262600
     C                   UPDATE    LEEIRDD0                                                   262600
     C                   ENDIF                                                              AR784436
                                                                                              262600
      ** Write the initial cash flow to reflect the amortised cost                            262600
      ** up to the beginning of the current period                                            262600
     C                   EVAL      EPFLDT = CR_STDT                                           262600
     C                   EVAL      EPTNMR = CR_TRAN                                           262600
     C                   IF        wAccInd <> 'F'                                           AR784436
     C                   EVAL      EPCAMT = PR_DPTD                                           262600
     C                   ELSE                                                               AR784436
     C                   EVAL      EPCAMT = CR_DPTD                                         AR784436
     C                   ENDIF                                                              AR784436
     C                   IF        CLPTYP = 66                                                262600
     C                             OR CLPTYP = 67                                             262600
     C                             OR CLPTYP = 69                                             262600
     C                   EVAL      EPIOIN = 'I'                                               262600
     C                   ELSE                                                                 262600
     C                   EVAL      EPIOIN = 'O'                                               262600
     C                   ENDIF                                                                262600
     C                   EVAL      @ICBS = CLICBS                                             262600
     C                   EXSR      SRDayNum                                                   262600
     C                   EVAL      EPNDYY = @NDYY                                             262600
     C                   EVAL      ZZBEG = CR_STDT                                            262600
     C                   EVAL      ZZEND = CR_ENDT                                            262600
     C                   EXSR      SRZINTDY                                                   262600
     C                   EVAL      EPNDEI = ZZINDY                                            262600
                                                                                              262600
      ** If first day accrual then subtract one day of interest                               262600
     C**********         IF        wAccInd = 'F'                                     262600 AR784436
     C**********         EVAL(R)   WTime = 1/@NDYY                                   262600 AR784436
     C**********         EVAL(H)   EPCAMT = EPCAMT / ((1 + PR_EIR) ** WTime)         262600 AR784436
     C**********         ENDIF                                                       262600 AR784436
                                                                                              262600
     C                   WRITE     ZAEIRPD0                                                   262600
                                                                                              262628
      ** Output details of dummy cash flow to report                                          262628
     C                   EVAL      LFFLDT = EPFLDT                                            262628
     C                   EVAL      LFCAMT = EPCAMT                                            262628
     C                   EVAL      LFIOIN = EPIOIN                                            262628
     C                   EVAL      LFFTYP = 'DUMM'                                            262628
     C                   EXSR      RepDetail                                                  262628
                                                                                              262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Save period details for present/future cashflow processing                           262600
     C                   EVAL      wEIENDT = CR_ENDT                                          262600
     C                   EVAL      wEISTDT = CR_STDT                                          262600
     C                   EVAL      wEIFSEQ = 0                                                262600
                                                                                              262600
      ** Generate Present Cashflows                                                           262600
     C                   EXSR      SRCFPresent                                                262600
                                                                                              262600
      ** Generate Future Cashflows                                                            262600
     C                   EXSR      SRCFFuture                                                 262600
                                                                                              262600
      ** Determine EIR by calling calculator                                                  262600
     C                   EVAL      PInpTNRF = CR_TRAN                                         262600
     C                   EVAL      PInpStartEff = kEIDATE                                     262600
                                                                                              248603
     C                   CALL      'ZFWDT'                                                    248603
     C                   PARM      CR_ENDT       PInpDay                                      248603
     C                   PARM                    PDaysFwd                                     248603
     C                   PARM      *ZERO         POutDay                                      248603
     C                   PARM      CLCCY         PCYCD                                        248603
     C                   PARM      *BLANKS       PLocation                                    248603
     C                   EVAL      PInpEndEff   = POutDay                                     248603
     C                   EXSR      SREIRCalc                                                  262600
     C                   IF        wAccInd = 'F' AND                                        AR784436
     C                             WPRVEIR = 'Y'                                            AR784436
     C                   EVAL      WEISTDT = PR_LADT                                        AR784436
      ** Call AmortCalc                                                                     AR784436
     C                   EXSR      SRAmortCalc                                              AR784436
                                                                                            AR784436
      ** Increase work fields for prices at start of period                                 AR784436
     C                   EVAL      wEIDPTD = pDrtPrcTdy                                     AR784436
     C                   EVAL      wEICPTD = pClnPrcTdy                                     AR784436
     C                   EVAL      wEIAMTD = wEIAMTD + WAmrtAmt                             AR784436
                                                                                            AR784436
      ** Update the details of the previous EIR period on file                              AR784436
     C                   EVAL(R)   PR_PRCP = PR_CPTD                                        AR784436
     C                   EVAL(R)   PR_PRDP = PR_DPTD                                        AR784436
     C                   EVAL      PR_CPTD = pClnPrcTdy                                     AR784436
     C                   EVAL      PR_DPTD = pDrtPrcTdy                                     AR784436
     C                   EVAL      PR_AMTD = wEIAMTD                                        AR784436
     C                   EVAL      PR_LADT = CR_STDT                                        AR784436
                                                                                            AR784436
     C                   UPDATE    LEEIRDD0                                                 AR784436
     C                   ENDIF                                                              AR784436
                                                                                              262600
      ** Amend current period details                                                         262600
     C                   EVAL      CR_RCAL = ' '                                              262600
     C                   EVAL      CR_EIR = wEffIntRate                                       262600
     C                   EVAL      CR_AMTD = wEIAMTD                                          262600
     C                   EVAL      CR_DPTD = wEIDPTD                                          262600
     C                   EVAL      CR_CPTD = wEICPTD                                          262600
     C                   EVAL      CR_LADT = PR_LADT                                          262600
                                                                                              262600
     C                   UPDATE    LEEIRDD3                                                   262600
                                                                                              262600
      ** Read next EIR Detail File                                                            262600
     C                   READ      LEEIRDL3                                                   262600
     C                   ENDDO                                                                262600
                                                                                              262600
     C                   ENDSR                                                                262600
      *****************************************************************
      *****************************************************************                       262600
      **SRCFPresent*-*Generate*Present*Cash*flows**********************                       262600
      *****************************************************************                       262600
      **Called*by:*SRCFAmortPrd****************************************                       262600
      *****************************************************************                       262600
      **Calls:*None****************************************************                       262600
      *****************************************************************                       262600
      *****************************************************************
      **********                                                                              262600
     C*****SRCFPresent   BEGSR                                                                262600
      **********                                                                              262600
     C**********         EVAL      wSTRec = 'N'                                               262600
      **********                                                                              262600
     C*****CLLNRF        SETLL     LECFLSL0                                                   262600
     C*****CLLNRF        READE     LECFLSL0                                                   262600
     C**********         DOW       NOT %EOF(LECFLSL0)                                         262600
     C**********                   AND LFFLDT <= wEISTDT                                      262600
      **********                                                                              262600
      ***If*LEERAPPD,*do*not*include*cashflows*less*than*start*of*period                      262600
     C**********         IF        wERAPRec = 'Y'                                             262600
     C**********                   AND LFFLDT < wEISTDT                                       262600
      ***LEERAPPD,*inclued*only*fee*for*the*period*********************                       262600
     C**********                   OR wERAPRec = 'Y'                                          262600
     C**********                   AND wEIFSEQ <> LFFSEQ                                      262600
     C**********                   AND LFFSEQ <> 0                                            262600
      ***Non-fees,*do*not*include*less*than*start*of*period************                       262600
     C**********                   OR LFFSEQ = 0                                              262600
     C**********                   AND LFFLDT < wEISTDT                                       262600
     C*****CLLNRF        READE     LECFLSL0                                                   262600
     C**********         ITER                                                                 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Principal*repayments*and*change*of*principal*amount***********                       262600
     C**********         IF        LFFLDT = wEISTDT                                           262600
     C**********         IF        LFFTYP = 'SPIN'                                            262600
     C**********                   OR LFFTYP = 'PINC'                                         262600
     C**********                   OR LFFTYP = 'SSRP'                                         262600
     C**********                   OR LFFTYP = 'SRPY'                                         262600
     C**********                   OR LFFTYP = 'SRPA'                                         262600
     C**********                   OR LFFTYP = 'RPAY'                                         262600
     C**********                   OR LFFTYP = 'SPTF'                                         262600
     C**********                   OR LFFTYP = 'PTFA'                                         262600
     C**********                   OR LFFTYP = 'SPTT'                                         262600
     C**********                   OR LFFTYP = 'PTTA'                                         262600
     C**********                   OR LFFTYP = 'SINT'                                         262600
     C**********                   OR LFFTYP = 'INTP'                                         262600
     C*****CLLNRF        READE     LECFLSL0                                                   262600
     C**********         ITER                                                                 262600
     C**********         ENDIF                                                                262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Exclude*shadow*amounts*in*EIR*computation*********************                248260 262600
     C**********         IF        LFIOIN = 'S'                                        248260 262600
     C*****CLLNRF        READE     LECFLSL0                                            248260 262600
     C**********         ITER                                                          248260 262600
     C**********         ENDIF                                                         248260 262600
      **********                                                                       248260 262600
     C**********         EVAL      EPFLDT = LFFLDT                                            262600
      **********                                                                              262600
      ***Fees*for*LEEIRDPD*********************************************                       262600
     C**********         IF        LFFSEQ <> 0                                                262600
     C**********         EVAL      kEITRAN = LFLNRF                                           262600
     C**********         EVAL      kEIFSEQ = LFFSEQ                                           262600
      **********                                                                              262600
     C**********         IF        wERAPRec <> 'Y'                                            262600
      ***Check*if*fee*is*amortised*separately*or*not*******************                       262600
     C*****KFSeq         CHAIN     LEFEEDLI                                                   CAS019
     C**********         IF        %FOUND(LEFEEDLI)                                           CAS019
     C*****KFSeq         CHAIN     LEFEEDLN                                            CAS019 262600
     C**********         IF        %FOUND(LEFEEDLN)                                    CAS019 262600
     C**********         EVAL      EPFLDT = wEISTDT                                           262600
     C**********         EVAL      EPCAMT = FEFAMT                                            262600
     C**********         ELSE                                                                 262600
     C*****CLLNRF        READE     LECFLSL0                                                   262600
     C**********         ITER                                                                 262600
     C**********         ENDIF                                                                262600
     C**********         ELSE                                                          248260 262600
     C**********         EVAL      EPCAMT = LFCAMT                                     248260 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Get*cash flow amount                                                                 262600
     C*****KTranFSeq     CHAIN     LEEIRAL5                                                   262600
     C**********         IF        %FOUND(LEEIRAL5)                                           262600
     C**********         EVAL      EPCAMT = EAAAMT                                            240779
     C**********         EVAL      EPCAMT = EAAAMT - EAAAMP                            240779 240808
     C**********         EVAL      EAAAMT = EAAMNT - EAAAMP                            240808 262600
     C**********         UPDATE    LEEIRAD0                                            240808 262600
     C**********         EVAL      EPCAMT = EAAAMT                                     240808 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ELSE                                                                 262600
      ***Cashflow*Amount*for*non-fees**********************************                       262600
     C**********         EVAL      EPCAMT = LFCAMT                                            262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Cashflow*Transaction*Number***********************************                       262600
     C**********         EVAL      EPTNMR = LFLNRF                                            262600
      **********                                                                              262600
      ***Incoming/outgoing*indicator***********************************                       262600
     C**********         EVAL      EPIOIN = LFIOIN                                            262600
      **********                                                                              262600
      ***No.*of*Days*in*Interest*Year**********************************                       262600
     C**********         EVAL      @ICBS = LFICBS                                             262600
     C**********         EXSR      SRDayNum                                                   262600
     C**********         EVAL      EPNDYY = @NDYY                                             262600
      **********                                                                              262600
      ***No.of*Days*from*end*of*Effec**********************************                       262600
      **********                                                                              262600
     C**********         Z-ADD     EPFLDT        ZZBEG                                        262600
     C**********         Z-ADD     wEIENDT       ZZEND                                        262600
     C**********         EXSR      SRZINTDY                                                   262600
     C**********         Z-ADD     ZZINDY        EPNDEI                                       262600
      **********                                                                              262600
      ***Write*present*cash*flow*to*file*******************************                       262600
     C**********         WRITE     ZAEIRPD0                                                   262600
      **********                                                                              262600
      ***Check*for*ST*record*for*the*principal*cash*flow***************                       262600
     C**********         IF        LFFTYP = 'SAMT'                                            262600
     C**********                   OR LFFTYP = 'SSAM'                                         262600
     C**********         EVAL      wSTRec = 'Y'                                               262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C*****CLLNRF        READE     LECFLSL0                                                   262600
     C**********         ENDDO                                                                262600
      **********                                                                              262600
      ***Principal*Cash*Flow*******************************************                       262600
     C**********         IF        wSTRec = 'N'                                               262600
     C*****KLoanDate     SETGT     LEHTRNL0                                                   262600
     C**********         READP     LEHTRNL0                                                   262600
     C**********         IF        NOT %EOF(LEHTRNL0)                                         262600
     C**********                   AND kEITRAN = TRNO                                         262600
     C**********         EVAL      EPFLDT = wEISTDT                                           262600
      ***Cashflow*Transaction*Number***********************************                       262600
     C**********         EVAL      EPTNMR = TRNO                                              262600
      **********                                                                              262600
      ***No.*of*Days*in*Interest*Year**********************************                       262600
     C**********         EVAL      @ICBS = CLICBS                                             262600
     C**********         EXSR      SRDayNum                                                   262600
     C**********         EVAL      EPNDYY = @NDYY                                             262600
      **********                                                                              262600
      ***No.of*Days*from*end*of*Effec**********************************                       262600
      **********                                                                              262600
     C**********         Z-ADD     wEISTDT       ZZBEG                                        262600
     C**********         Z-ADD     wEIENDT       ZZEND                                        262600
     C**********         EXSR      SRZINTDY                                                   262600
     C**********         Z-ADD     ZZINDY        EPNDEI                                       262600
      **********                                                                              262600
      ***Cashflow*amount***********************************************                       262600
     C**********         IF        AMTP = 'ST'                                                262600
     C**********         EVAL      EPCAMT = PRAM                                              262600
     C**********         ELSE                                                                 262600
     C**********         EVAL      EPCAMT = CPAM                                              262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Incoming/outgoing*indicator***********************************                       262600
     C**********         IF        CLPTYP = 66                                                262600
     C**********                   OR CLPTYP = 67                                             262600
     C**********                   OR CLPTYP = 69                                             262600
     C**********         EVAL      EPIOIN = 'I'                                               262600
     C**********         ELSE                                                                 262600
     C**********         EVAL      EPIOIN = 'O'                                               262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         WRITE     ZAEIRPD0                                                   262600
     C**********         ENDIF                                                                262600
     C**********         ENDIF                                                                262600
      ***Discount******************************************************                       262600
     C**********         IF        CLTOTI <> 0                                                262600
     C**********                   AND wERAPRec <> 'Y'                                        262600
     C**********         EVAL      EPCAMT = CLTOTI                                            262600
     C**********         EVAL      kEIFSEQ = 0                                                262600
     C*****KTranFSeq     CHAIN     LEEIRAL5                                                   262600
     C**********         IF        %FOUND(LEEIRAL5)                                           262600
     C**********         EVAL      EPCAMT = EAAAMT                                            240779
     C**********         EVAL      EPCAMT = EAAAMT - EAAAMP                            240779 240808
     C**********         EVAL      EAAAMT = EAAMNT - EAAAMP                            240808 262600
     C**********         UPDATE    LEEIRAD0                                            240808 262600
     C**********         EVAL      EPCAMT = EAAAMT                                     240808 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Incoming/outgoing*indicator***********************************                       262600
     C**********         IF        CLPTYP = 66                                                262600
     C**********                   OR CLPTYP = 67                                             262600
     C**********                   OR CLPTYP = 69                                             262600
     C**********         EVAL      EPIOIN = 'O'                                               262600
     C**********         ELSE                                                                 262600
     C**********         EVAL      EPIOIN = 'I'                                               262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         WRITE     ZAEIRPD0                                                   262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ENDSR                                                                262600
      *****************************************************************                       262600
      /EJECT                                                                                  262600
      *****************************************************************                       262600
      *                                                               *                       262600
      * SRCFPresent - Generate Present Cash flows                     *                       262600
      *                                                               *                       262600
      * Called by: SRCFAmortLife                                      *                       262600
      *            SRCFAmortPrd                                       *                       262600
      *                                                               *                       262600
      * Calls: SRZINTDY                                               *                       262600
      *                                                               *                       262600
      *****************************************************************                       262600
                                                                                              262600
     C     SRCFPresent   BEGSR                                                                262600
                                                                                              262600
     C     KLoanDate     SETLL     LECFLSL0                                                   262600
     C     KLoanDate     READE     LECFLSL0                                                   262600
     C                   DOW       NOT %EOF(LECFLSL0)                                         262600
                                                                                              262600
      ** If previous EIR period has been recalculated then exclude                            262600
      ** cash flows happening on EIR period start date                                        262600
     C                   IF        wERAPRec <> 'Y'                                            262600
     C                   IF        wEIDPTD <> *ZERO                                           262600
     C                             AND LFFLDT = CR_STDT                                       262600
     C     KLoanDate     READE     LECFLSL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Exclude shadow amounts in EIR computation                                            262600
     C                   IF        LFIOIN = 'S'                                               262600
     C     KLoanDate     READE     LECFLSL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
                                                                                              262618
      ** Exclude Past Due events in EIR computation                                           262618
     C                   IF        LFFTYP = 'PDPR'                                            262618
     C                             OR LFFTYP = 'PDIN'                                         262618
     C     KLoanDate     READE     LECFLSL0                                                   262618
     C                   ITER                                                                 262618
     C                   ENDIF                                                                262618
                                                                                              262600
      ** If processing EIR for one fee ignore other fees                                      262600
     C                   IF        wERAPRec = 'Y'                                             262600
     C                             AND LFFSEQ <> 0                                            262600
     C                             AND LFFSEQ <> wEIFSEQ                                      262600
     C     KLoanDate     READE     LECFLSL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** If processing EIR at loan level ignore fees that amortise                            262600
      ** separately                                                                           262600
     C                   IF        wERAPRec = 'N'                                             262600
     C                             AND LFFSEQ <> 0                                            262600
     C                   EVAL      kEIFSEQ = LFFSEQ                                           262600
     C     KFSeq         CHAIN     LEFEEDLN                                                   262600
     C                   IF        NOT %FOUND(LEFEEDLN)                                       262600
     C     KLoanDate     READE     LECFLSL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Cashflow Date                                                                        262600
     C                   EVAL      EPFLDT = LFFLDT                                            262600
                                                                                              262600
      ** Cashflow Amount                                                                      262600
     C                   EVAL      EPCAMT = LFCAMT                                            262600
                                                                                              262600
      ** Cashflow Transaction Number                                                          262600
     C                   EVAL      EPTNMR = LFLNRF                                            262600
                                                                                              262600
      ** Incoming/outgoing indicator                                                          262600
     C                   EVAL      EPIOIN = LFIOIN                                            262600
                                                                                              262600
      ** No. of Days in Interest Year                                                         262600
     C                   EVAL      @ICBS = LFICBS                                             262600
     C                   EXSR      SRDayNum                                                   262600
     C                   EVAL      EPNDYY = @NDYY                                             262600
                                                                                              262600
      ** No.of Days from end of Effec                                                         262600
                                                                                              262600
     C                   Z-ADD     EPFLDT        ZZBEG                                        262600
     C                   Z-ADD     wEIENDT       ZZEND                                        262600
     C                   EXSR      SRZINTDY                                                   262600
     C                   Z-ADD     ZZINDY        EPNDEI                                       262600
                                                                                              262600
      ** Write present cash flow to file                                                      262600
     C                   WRITE     ZAEIRPD0                                                   262600
     C                   EXSR      RepDetail                                                  262628
                                                                                            AR747507
      ** Discount                                                                           AR747507
     C                   IF        CLTOTI <> 0                                              AR747507
     C                             And LFFTYP = 'SAMT'                                      AR747507
     C                             And wERAPRec <> 'Y'                                      AR747507
     C                   EVAL      EPCAMT = CLTOTI                                          AR747507
      ** Incoming/outgoing indicator                                                        AR747507
     C                   IF        CLPTYP = 66                                              AR747507
     C                             Or CLPTYP = 67                                           AR747507
     C                             Or CLPTYP = 69                                           AR747507
     C                   EVAL      EPIOIN = 'O'                                             AR747507
     C                   ELSE                                                               AR747507
     C                   EVAL      EPIOIN = 'I'                                             AR747507
     C                   ENDIF                                                              AR747507
     C                   WRITE     ZAEIRPD0                                                 AR747507
     C**********         EXSR      RepDetail                                       AR747507 AR782803
     c                   ENDIF                                                              AR747507
                                                                                              262600
     C     KLoanDate     READE     LECFLSL0                                                   262600
     C                   ENDDO                                                                262600
                                                                                              262600
      ** If processing EIR for a period then calculate the outstanding                        262600
      ** principal and interest amount at period start date (unless                           262600
      ** this is the same as the loan start date, in which case the                           262600
      ** start date cash flow would have already been output).                                262600
     C                   IF        wERAPRec = 'Y'                                             262600
     C                             AND wEISTDT <> CLVDAT                                      262600
     C     KLoanDate     SETGT     LEHTRNL0                                                   262600
     C     kEITRAN       READPE    LEHTRNL0                                                   262600
     C                   IF        NOT %EOF(LEHTRNL0)                                         262600
                                                                                              262600
     C                   EVAL      EPFLDT = wEISTDT                                           262600
      ** Cashflow Transaction Number                                                          262600
     C                   EVAL      EPTNMR = TRNO                                              262600
                                                                                              262600
      ** No. of Days in Interest Year                                                         262600
     C                   EVAL      @ICBS = CLICBS                                             262600
     C                   EXSR      SRDayNum                                                   262600
     C                   EVAL      EPNDYY = @NDYY                                             262600
                                                                                              262600
      ** No.of Days from end of Effec                                                         262600
                                                                                              262600
     C                   Z-ADD     wEISTDT       ZZBEG                                        262600
     C                   Z-ADD     wEIENDT       ZZEND                                        262600
     C                   EXSR      SRZINTDY                                                   262600
     C                   Z-ADD     ZZINDY        EPNDEI                                       262600
                                                                                              262600
      ** Cashflow amount                                                                      262600
     C                   IF        AMTP = 'ST'                                                262600
     C                   EVAL      EPCAMT = PRAM                                              262600
     C                   ELSE                                                                 262600
     C                   EVAL      EPCAMT = CPAM                                              262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Calculate outstanding interest and add to principal amount                           262600
     C                   IF        VDAT = wEISTDT                                             262600
     C                   EVAL      EISINT = AITC                                              262600
     C                   ELSE                                                                 262600
                                                                                              262600
     C                   EVAL      pZIBEG  = VDAT                                             262600
     C                   EVAL      pZIEND  = wEISTDT                                          262600
     C                   EVAL      pZICALC = CLICBS                                           262600
     C                   EVAL      pZIAMT  = EPCAMT                                           262600
     C                   EVAL      pZIRATE = INTR                                             262600
                                                                                              262600
     C                   CALL      'GLINTC'                                                   262600
     C                   PARM                    pZIBEG                                       262600
     C                   PARM                    pZIEND                                       262600
     C                   PARM                    pZICALC                                      262600
     C                   PARM                    pZIAMT                                       262600
     C                   PARM                    pZIRATE                                      262600
     C                   PARM                    pZINTR                                       262600
                                                                                              262600
     C                   EVAL      EISINT = AITC + pZINTR - IPRD                              262600
     C                   ENDIF                                                                262600
                                                                                              262600
     C                   EVAL      EPCAMT = EPCAMT + EISINT                                   262600
                                                                                              262600
      ** Incoming/outgoing indicator                                                          262600
     C                   IF        CLPTYP = 66                                                262600
     C                             OR CLPTYP = 67                                             262600
     C                             OR CLPTYP = 69                                             262600
     C                   EVAL      EPIOIN = 'I'                                               262600
     C                   ELSE                                                                 262600
     C                   EVAL      EPIOIN = 'O'                                               262600
     C                   ENDIF                                                                262600
                                                                                              262600
     C                   WRITE     ZAEIRPD0                                                   262600
                                                                                              262628
      ** Output details of dummy cash flow to report                                          262628
     C                   EVAL      LFFLDT = EPFLDT                                            262628
     C                   EVAL      LFCAMT = EPCAMT                                            262628
     C                   EVAL      LFIOIN = EPIOIN                                            262628
     C                   EVAL      LFFTYP = 'DUMM'                                            262628
     C                   EXSR      RepDetail                                                  262628
                                                                                              262600
     C                   ENDIF                                                                262600
     C                   ENDIF                                                                262600
                                                                                              262600
     C                   ENDSR                                                                262600
                                                                                              262600
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCFFuture - Generate Future Cash Flows                       *
      *                                                               *
      * Called by: SRCFAmortPrd                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCFFuture    BEGSR
                                                                                              262600
      ** If calculating EIR over a period which ends before Loan                              262600
      ** Maturity then calculate the outstanding principal and                                262600
      ** interest at the end of the period. To do so, access history                          262600
      ** details at start of period and then consider impact of cash                          262600
      ** flows during period.                                                                 262600
                                                                                              262600
     C                   IF        wERAPRec = 'Y'                                             262600
     C                             AND wEIENDT < CLMDAT                                       262600
     C                   EVAL      WkCPAM = *ZERO                                             262600
     C                   EVAL      EIEINT = *ZERO                                             262600
     C     KLoanDate     SETGT     LEHTRNL0                                                   262600
     C     kEITRAN       READPE    LEHTRNL0                                                   262600
     C                   IF        NOT %EOF(LEHTRNL0)                                         262600
     C                   EVAL      WkVDAT = VDAT                                              262600
     C                   IF        AMTP = 'ST'                                                262600
     C                   EVAL      WkCPAM = PRAM                                              262600
     C                   ELSE                                                                 262600
     C                   EVAL      WkCPAM = CPAM                                              262600
     C                   ENDIF                                                                262600
     C                   EVAL      EIEINT = AITC - IPRD                                       262600
     C                   EVAL      WkINTR = INTR                                              262600
     C                   ENDIF                                                                262600
     C                   ENDIF                                                                262600
 
     C     KLoanDate     SETGT     LECFSFL0
     C     kEITRAN       READE     LECFSFL0
                                                                                              248603
     C                   CALL      'ZFWDT'                                                    248603
     C                   PARM      wEIENDT       PInpDay           5 0                        248603
     C                   PARM                    PDaysFwd          2 0                        248603
     C                   PARM      *ZERO         POutDay           5 0                        248603
     C                   PARM      CLCCY         PCYCD             3                          248603
     C                   PARM      *BLANKS       PLocation         3                          248603
                                                                                              248603
     C                   DOW       NOT %EOF(LECFSFL0)
     C**********                   AND LFFLDT <= wEIENDT                                      248603
     C                             AND LFFLDT <= POutDay                                      248603
     C                             AND LFLNRF = kEITRAN
 
      ** Exclude shadow amounts in EIR computation                                            248260
     C                   IF        LFIOIN = 'S'                                               248260
     C     kEITRAN       READE     LECFSFL0                                                   248260
     C                   ITER                                                                 248260
     C                   ENDIF                                                                248260
                                                                                              262618
      ** Exclude Past Due events in EIR computation                                           262618
     C                   IF        LFFTYP = 'PDPR'                                            262618
     C                             OR LFFTYP = 'PDIN'                                         262618
     C     CLLNRF        READE     LECFSFL0                                                   262618
     C                   ITER                                                                 262618
     C                   ENDIF                                                                262618
                                                                                              262600
      ** If processing EIR for one fee ignore other fees                                      262600
     C                   IF        wERAPRec = 'Y'                                             262600
     C                             AND LFFSEQ <> 0                                            262600
     C                             AND LFFSEQ <> wEIFSEQ                                      262600
     C     CLLNRF        READE     LECFSFL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** If processing EIR at loan level ignore fees that amortise                            262600
      ** separately                                                                           262600
     C                   IF        wERAPRec = 'N'                                             262600
     C                             AND LFFSEQ <> 0                                            262600
     C                   EVAL      kEIFSEQ = LFFSEQ                                           262600
     C     KFSeq         CHAIN     LEFEEDLN                                                   262600
     C                   IF        NOT %FOUND(LEFEEDLN)                                       262600
     C     CLLNRF        READE     LECFSFL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
     C                   ENDIF                                                                262600
                                                                                              248260
      ** Cashflow Transaction Number
     C                   EVAL      EFTNMR = LFLNRF
 
      ** Cashflow Date
     C                   EVAL      EFFLDT = LFFLDT
 
      ** Cashflow Amount
     C**********         IF        LFFSEQ <> 0                                       BUG17290 262600
      ***A*non-zero fee sequence on the cashflow file denotes a fee                  BUG17290 262600
     C**********         EVAL      kEITRAN = LFLNRF                                  BUG17290 262600
     C**********         EVAL      kEIFSEQ = LFFSEQ                                  BUG17290 262600
      **********                                                                     BUG17290 262600
      ***For*future cashflows, inclusion of fees are dependent on                    BUG17290 262600
      ***1)*the*amort start being reached, hence a record in LEEIRAPD                BUG17290 262600
      ***being*present; 2) for fees amortising separately, it should                 BUG17290 262600
      ***be*only included when processing records for LEERAPPD and                   BUG17290 262600
      ***3)*for*fees amortising over life, should only be included                   BUG17290 262600
      ***when*processing LEEIRDPD records                                            BUG17290 262600
      **********                                                                     BUG17290 262600
     C*****KTranFSeq     CHAIN     LEEIRAL5                                          BUG17290 262600
     C**********         IF        NOT %FOUND(LEEIRAL5)                              BUG17290 262600
     C*****kEITRAN       READE     LECFSFL0                                          BUG17290 262600
     C**********         ITER                                                        BUG17290 262600
     C**********         ENDIF                                                       BUG17290 262600
      **********                                                                     BUG17290 262600
     C*****KFSeq         CHAIN     LEFEEDLN                                          BUG17290 262600
      **********                                                                     BUG17290 262600
     C**********         IF        NOT %FOUND(LEFEEDLN)                              BUG17290 262600
     C**********                   AND wERAPRec = 'N'                                BUG17290 262600
     C**********                   OR %FOUND(LEFEEDLN)                               BUG17290 262600
     C**********                   AND wERAPRec = 'Y'                                BUG17290 262600
     C*****kEITRAN       READE     LECFSFL0                                          BUG17290 262600
     C**********         ITER                                                        BUG17290 262600
     C**********         ENDIF                                                       BUG17290 262600
      **********                                                                     BUG17290 262600
     C**********         ENDIF                                                       BUG17290 262600
      **********                                                                     BUG17290 262600
     C                   EVAL      EFCAMT = LFCAMT
 
      ** Incoming/outgoing indicator
     C                   EVAL      EFIOIN = LFIOIN
 
      ** No. of Days in Interest Year
     C                   EVAL      @ICBS = LFICBS
     C                   EXSR      SRDayNum
     C                   EVAL      EFNDYY = @NDYY
 
      ** No.of Days from end of Effec
 
     C                   Z-ADD     LFFLDT        ZZBEG
     C                   Z-ADD     wEIENDT       ZZEND
     C                   EXSR      SRZINTDY
     C                   SELECT                                                               248603
     C                   WHEN      ZZINDY < 0                                                 248603
     C                   Z-ADD     *ZEROS        EFNDEI                                       248603
     C                   WHEN      ZZINDY >= 0                                                248603
     C                   Z-ADD     ZZINDY        EFNDEI
     C                   ENDSL                                                                248603
 
      ** Write Future Cash flow record to file
     C                   WRITE     ZAEIRFD0
     C                   EXSR      RepDetail                                                  262628
                                                                                              262600
      ** Update outstanding accrued interest                                                  262600
     C                   IF        wERAPRec = 'Y'                                             262600
     C                             AND wEIENDT < CLMDAT                                       262600
                                                                                              262600
     C                   EVAL      pZIBEG  = WkVDAT                                           262600
     C                   EVAL      pZIEND  = LFFLDT                                           262600
     C                   EVAL      pZICALC = LFICBS                                           262600
     C                   EVAL      pZIAMT  = WkCPAM                                           262600
     C                   EVAL      pZIRATE = WkINTR                                           262600
                                                                                              262600
     C                   CALL      'GLINTC'                                                   262600
     C                   PARM                    pZIBEG                                       262600
     C                   PARM                    pZIEND                                       262600
     C                   PARM                    pZICALC                                      262600
     C                   PARM                    pZIAMT                                       262600
     C                   PARM                    pZIRATE                                      262600
     C                   PARM                    pZINTR                                       262600
                                                                                              262600
     C                   EVAL      EIEINT = EIEINT + pZINTR                                   262600
     C                   IF        LFFTYP = 'INTP'                                            262600
     C                             OR LFFTYP = 'SINT'                                         262600
     C                             OR LFFTYP = 'MINT'                                         262600
     C                             OR LFFTYP = 'SMIN'                                         262600
     C                             OR LFFTYP = 'SRPI'                                         262600
     C                   EVAL      EIEINT = EIEINT - LFCAMT                                   262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** Update work fields used to calculate interest                                        262600
     C                   EVAL      WkVDAT = LFFLDT                                            262600
     C                   EVAL      WkINTR = LFIRAT                                            262600
                                                                                              262600
      ** Update work field used to keep track of outstanding capital                          262600
     C                   SELECT                                                               262600
                                                                                              262600
     C                   WHEN      LFFTYP = 'SPIN'                                            262600
     C                             OR LFFTYP = 'PINC'                                         262600
     C                             OR LFFTYP = 'SPTT'                                         262600
     C                             OR LFFTYP = 'PTTA'                                         262600
     C                   EVAL      WkCPAM = WkCPAM + LFCAMT                                   262600
                                                                                              262600
     C                   WHEN      LFFTYP = 'SSRP'                                            262600
     C                             OR LFFTYP = 'SRPY'                                         262600
     C                             OR LFFTYP = 'SRPA'                                         262600
     C                             OR LFFTYP = 'RPAY'                                         262600
     C                             OR LFFTYP = 'SPTF'                                         262600
     C                             OR LFFTYP = 'PTFA'                                         262600
     C                   EVAL      WkCPAM = WkCPAM - LFCAMT                                   262600
                                                                                              262600
     C                   ENDSL                                                                262600
     C                   ENDIF                                                                262600
 
      ** Read Next Cashflow Record
     C     kEITRAN       READE     LECFSFL0
     C                   ENDDO
                                                                                              262600
      ** If Maturity event not included in the EIR period output a                            262600
      ** dummy cash flow event for the outstanding principal and                              262600
      ** interest at the end of the period.                                                   262600
     C                   IF        wERAPRec = 'Y'                                             262600
     C                             AND wEIENDT < CLMDAT                                       262600
                                                                                              262600
      ** Cashflow Date                                                                        262600
     C                   EVAL      EFFLDT = wEIENDT                                           262600
                                                                                              262600
      ** Cashflow Transaction Number                                                          262600
     C                   EVAL      EFTNMR = TRNO                                              262600
                                                                                              262600
      ** No. of Days in Interest Year                                                         262600
     C                   EVAL      @ICBS = CLICBS                                             262600
     C                   EXSR      SRDayNum                                                   262600
     C                   EVAL      EFNDYY = @NDYY                                             262600
                                                                                              262600
      ** No.of Days from end of Effec                                                         262600
     C                   EVAL      EFNDEI = *ZERO                                             262600
                                                                                              262600
      ** Cashflow amount                                                                      262600
     C                   EVAL      EFCAMT = WkCPAM                                            262600
                                                                                              262600
      ** Calculate outstanding interest and add to principal amount                           262600
     C                   IF        wEIENDT > WkVDAT                                           262600
                                                                                              262600
     C                   EVAL      pZIBEG  = WkVDAT                                           262600
     C                   EVAL      pZIEND  = wEIENDT                                          262600
     C                   EVAL      pZICALC = CLICBS                                           262600
     C                   EVAL      pZIAMT  = WkCPAM                                           262600
     C                   EVAL      pZIRATE = WkINTR                                           262600
                                                                                              262600
     C                   CALL      'GLINTC'                                                   262600
     C                   PARM                    pZIBEG                                       262600
     C                   PARM                    pZIEND                                       262600
     C                   PARM                    pZICALC                                      262600
     C                   PARM                    pZIAMT                                       262600
     C                   PARM                    pZIRATE                                      262600
     C                   PARM                    pZINTR                                       262600
                                                                                              262600
     C                   EVAL      EIEINT = EIEINT + pZINTR                                   262600
     C                   ENDIF                                                                262600
                                                                                              262600
     C                   EVAL      EFCAMT = WkCPAM + EIEINT                                   262600
                                                                                              262600
      ** Incoming/outgoing indicator                                                          262600
     C                   IF        CLPTYP = 66                                                262600
     C                             OR CLPTYP = 67                                             262600
     C                             OR CLPTYP = 69                                             262600
     C                   EVAL      EFIOIN = 'O'                                               262600
     C                   ELSE                                                                 262600
     C                   EVAL      EFIOIN = 'I'                                               262600
     C                   ENDIF                                                                262600
                                                                                              262600
     C                   WRITE     ZAEIRFD0                                                   262600
                                                                                              262628
      ** Output details of dummy cash flow to report                                          262628
     C                   EVAL      LFFLDT = EFFLDT                                            262628
     C                   EVAL      LFCAMT = EFCAMT                                            262628
     C                   EVAL      LFIOIN = EFIOIN                                            262628
     C                   EVAL      LFFTYP = 'DUMM'                                            262628
     C                   EXSR      RepDetail                                                  262628
     C                   ENDIF                                                                262600
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                       262600
      **SRAmortAmt*-*Compute*for*the*amortisation*amount***************                       262600
      *****************************************************************                       262600
      **Called*by:*****************************************************                       262600
      *****************************************************************                       262600
      **Calls:*None****************************************************                       262600
      *****************************************************************                       262600
      *****************************************************************
     C*****SRAmortAmt    BEGSR                                                                262600
      **********                                                                              262600
      ***Clear*previous*amortisation*cash*flows************************                       262600
     C**********         EXSR      SRClearAMRT                                                262600
      **********                                                                              262600
      ***Determine*sum*of*fee*amounts*and*proportion*of*each*fee*******                       262600
     C**********         EXSR      SRAllFeeAmts                                               262600
      **********                                                                              262600
     C**********         EVAL      wPropTOTI = *ZERO                                          262600
     C**********         EVAL      wPrevAmrtToDt = *ZERO                                      262600
      **********                                                                              262600
      **If*Discounted*Loan*********************************************                       262600
     C**********         IF        CLTOTI <> 0                                                262600
      **********                                                                              262600
     C**********         EVAL      kEITRAN = CLLNRF                                           262600
     C**********         EVAL      kEIFSEQ = *ZEROS                                           262600
      **********                                                                              262600
     C*****KFSeq         CHAIN     LEEIRAL5                                                   262600
     C**********         IF        %FOUND(LEEIRAL5)                                           262600
     C**********         EVAL(R)   wPropTOTI = EAAAMT                                         262600
      **********                                                                              262600
     C*****KFSeq         READE     LEEIRAL5                                                   262600
     C**********         IF        NOT %EOF(LEEIRAL5)                                         262600
     C**********         EVAL(R)   wPrevAmrtToDt = EAAAMP                                     262600
     C**********         ELSE                                                                 262600
     C**********         EVAL(R)   wPrevAmrtToDt = *ZEROS                                     262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Add*saved*Total*Interest*and*sum*of*all*Fees*associated*to*the                       262600
      ***loan*to*determine*the*total*amount*to*be*amortisted.**********                       262600
     C**********         EVAL(R)   wkPropSum = wPropTOTI + wkFeePropSum                       262600
      **********                                                                              262600
      ***Generate*amortisation*cash*flows******************************                       262600
     C**********         EXSR      SRCFAmortise                                               262600
      **********                                                                              262600
     C**********         ENDSR                                                                262600
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                       262600
      **SRAllFeeAmts*-*Comput*for*all*fee*amounts*and*save*to*array****                       262600
      *****************to*be*use*for*determining*proportions***********                       262600
      *****************************************************************                       262600
      **Called*by:*****************************************************                       262600
      *****************************************************************                       262600
      **Calls:*None****************************************************                       262600
      *****************************************************************                       262600
      *****************************************************************
     C*****SrAllFeeAmts  BEGSR                                                                262600
      **********                                                                              262600
      ***Initialise*total*fee*amount.*Also*the*array*and*index*for*****                       262600
      ***determining*proportion*of*each*fee****************************                       262600
     C**********         EVAL      wFPropAmt (*) = *ZERO                                      262600
     C**********         EVAL      wFSeq(*) = *ZERO                                           262600
     C**********         EVAL      wFXrate(*) = *ZERO                                         262600
     C**********         EVAL      wFMDin(*) = *BLANKS                                        262600
     C**********         EVAL      wAmortAmount = *ZERO                                       262600
     C**********         EVAL      wFAmrtAmtToDt(*) = *ZERO                                   262600
     C**********         EVAL      wIx = *ZERO                                                262600
      **********                                                                              262600
      ***Process*all*live*fees*attached*to*the*loan********************                       262600
     C*****CLLNRF        SETLL     LEFEEDLI                                                   CAS019
     C*****CLLNRF        READE     LEFEEDLI                                                   CAS019
     C**********         DOW       NOT %EOF(LEFEEDLI)                                         CAS019
     C*****CLLNRF        SETLL     LEFEEDLN                                            CAS019 262600
     C*****CLLNRF        READE     LEFEEDLN                                            CAS019 262600
     C**********         DOW       NOT %EOF(LEFEEDLN)                                  CAS019 262600
      ***Compute*for*all*fees*settled*today.***************************                       262600
     C**********         IF        FERECI <> 'R' AND                                          262600
     C**********                   FERECI <> '*' AND                                          262600
     C**********                   FELOAN <> *ZERO AND                                        262600
     C**********                   FEADJY = 'Y' AND                                           262600
     C**********                   FEAMTD <> FEFAMT                                           262600
      **********                                                                              262600
      ***Include*only*those*fees*whose*Amortisation********************                       262600
      ***Start*Date*is*on*or*before*Event*Control*Date*****************                       262600
      **********                                                                              262600
     C**********         IF        FESTPD <= wEvCD                                            262600
      **********                                                                              262600
      ***Increment*array*index*****************************************                       262600
     C**********         EVAL      wIx = WIx + 1                                              262600
      **********                                                                              262600
      ***Store*the*respective*fee*sequences*to*array*for*chain/update*later                   262600
     C**********         EVAL(R)   wFSeq(WIx) = FEFSEQ                                        262600
      **********                                                                              262600
      ***Get*the*Amount*to*be*Amortised*from*Effective*Interest*Rate***                       262600
      ***Amortisation*Details*file.************************************                       262600
     C*****KFSeq         CHAIN     LEEIRAL5                                                   262600
     C**********         IF        %FOUND(LEEIRAL5)                                           262600
     C**********         EVAL(R)   wFPropAmt(WIx) = EAAAMT                                    262600
      **********                                                                              262600
      ***If*loan*currency*is*not*the*same*as*fee*currency,*convert*****                       262600
     C**********         IF        CLCCY <> FEFCCY                                            262600
      **********                                                                              262600
     C**********         IF        EAMDIN = 'M'                                               262600
     C**********         EVAL(R)   wAmortAmount = FEAMTD * EAXRAT                             262600
     C**********         ELSE                                                                 262600
     C**********         EVAL(R)   wAmortAmount = FEAMTD / EAXRAT                             262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         EVAL      wFXrate(WIx) = EAXRAT                                      262600
     C**********         EVAL      wFMDin(WIx)  = EAMDIN                                      262600
      ***Same*Currency*************************************************                       262600
     C**********         ELSE                                                                 262600
     C**********         EVAL(R)   wAmortAmount = FEAMTD                                      262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Subtract*Amortised*to*Date*of*LEEIRAPD*(Previous*Period)******                       262600
      ***from*Amort.*to*Date*(LEFEED)**********************************                       262600
      **********                                                                              262600
     C*****KFSeq         READE     LEEIRAL5                                                   262600
     C**********         IF        NOT %EOF(LEEIRAL5)                                         262600
     C**********         EVAL      wFAmrtAmtToDt(WIx) = wAmortAmount - EAAAMP                 262600
     C**********         ELSE                                                                 262600
     C**********         EVAL      wFAmrtAmtToDt(WIx) = wAmortAmount                          262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***Negative*Result***********************************************                       262600
     C**********         IF        wFAmrtAmtToDt(WIx) < 0                                     262600
     C**********         EVAL      wFAmrtAmtToDt(WIx) = *ZEROS                                262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ENDIF                                                                262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C*****CLLNRF        READE     LEFEEDLI                                                   CAS019
     C*****CLLNRF        READE     LEFEEDLN                                            CAS019 262600
      **********                                                                              262600
     C**********         ENDDO                                                                262600
      **********                                                                              262600
      ***Note*down*number*of*fees*processed****************************                       262600
     C**********         EVAL      wNumOfFees = wIx                                           262600
      **********                                                                              262600
      ***Compute*sum*of*proportioned*fee*amount************************                       262600
     C**********         Z-ADD     0             wkFeePropSum                                 262600
     C**********         IF        wIx > *ZERO                                                262600
     C**********         XFOOT     wFPropAmt     wkFeePropSum                                 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ENDSR                                                                262600
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                       262600
      **SRCFAmort*-*Generate*Amortisation*cashflow*********************                       262600
      *****************************************************************                       262600
      **Called*by:*SRCFAmortLife***************************************                       262600
      *****************************************************************                       262600
      **Calls:*None****************************************************                       262600
      *****************************************************************                       262600
      *****************************************************************
     C*****SRCFAmortise  BEGSR                                                                262600
      **********                                                                              262600
     C**********         CLEAR                   ZAAMRT                                       262600
      **********                                                                              262600
      ***Create*Cash*Flows*from*EIR*Start*Date*************************                       262600
     C**********         EVAL      kEITRAN = CLLNRF                                           262600
     C**********         EVAL      kEIDate = PR_STDT                                          262600
      **********                                                                              262600
     C**********         EVAL      wMaturityDate = CLMDAT                                     262600
      **********                                                                              262600
     C**********         EVAL      wStartPrd = PR_STDT                                        262600
      **********                                                                              262600
      ***Obtain*Cashflows*from*LECFSFPD********************************                       262600
     C*****CLLNRF        SETLL     LECFSFL0                                                   262600
     C*****CLLNRF        READE     LECFSFL0                                                   262600
      **********                                                                              262600
      ***Write*all*cashflows*from*EIR*Start*of*previous*period*to*EIR*Start of current period 262600
     C**********         DOW       NOT %EOF(LECFSFL0)                                         262600
     C**********                   AND LFFLDT < CR_STDT                                       262600
      **********                                                                              262600
     C**********         EVAL      ZAAMRT = ZAEIRF                                            246573
      **********                                                                              262600
      ***Exclude*start*amount******************************************                       262600
     C**********         IF        LFFTYP = 'SAMT'                                            262600
     C**********                   OR LFFTYP = 'SSAM'                                         262600
      ***Non-fees*equal*to*EIR*period*start*date***********************                       262600
     C**********                   OR LFFTYP <> 'EFAC' AND LFFTYP <> 'SFAM'                   262600
     C**********                   AND LFFTYP <> 'SFBT' AND LFFLDT = PR_STDT                  262600
      ***Shadow*rollover*principal*only.*******************************                       262600
     C**********                   OR LFFTYP = 'ROPR' AND LFFLDT = PR_STDT                    262600
      **********                                                                              262600
     C*****CLLNRF        READE     LECFSFL0                                                   262600
     C**********         ITER                                                                 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***If*not*Fee,*process*present*&*future*cashflows*only***********                       262600
     C**********         IF        LFFSEQ = 0  AND                                            262600
     C**********                   LFFLDT < PR_STDT                                           262600
     C*****CLLNRF        READE     LECFSFL0                                                   262600
     C**********         ITER                                                                 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
      ***If*Fee,*get*the*amount*from*LEEIRAPD**************************                       262600
      **********                                                                              262600
     C**********         IF        LFFSEQ <> 0                                                262600
      **********                                                                              262600
     C**********         EVAL      kEITRAN = LFLNRF                                           262600
     C**********         EVAL      kEIFSEQ = LFFSEQ                                           262600
      **********                                                                              262600
      ***If*amortised*separately,*skip*********************************                       262600
     C*****KFSeq         CHAIN     LEFEEDLI                                                   CAS019
     C**********         IF        NOT %FOUND(LEFEEDLI)                                       CAS019
     C*****KFSeq         CHAIN     LEFEEDLN                                            CAS019 262600
     C**********         IF        NOT %FOUND(LEFEEDLN)                                CAS019 262600
     C*****CLLNRF        READE     LECFSFL0                                                   262600
     C**********         ITER                                                                 262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C*****KFSeq         CHAIN     LEEIRAL5                                                   262600
     C**********         IF        %FOUND(LEEIRAL5)                                           262600
     C**********         EVAL      EPCAMT = EAAAMT                                            262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         EVAL      EPTNMR = LFLNRF                                            262600
     C**********         EVAL      EPFLDT = LFFLDT                                            262600
     C**********         EVAL      EPCAMT = LFCAMT                                            262600
     C**********         EVAL      EPIOIN = LFIOIN                                            262600
      **********                                                                              262600
      ***Set*Cashflow*types*for*ZAAMRTCALC*****************************                       262600
      **********                                                                              262600
     C**********         SELECT                                                               262600
      **********                                                                              262600
     C**********         WHEN      LFFTYP = 'EFAC'                                            262600
     C**********                   OR LFFTYP = 'SFAM'                                         262600
     C**********                   OR LFFTYP = 'SFBT'                                         262600
     C**********         EVAL      EPCFTP = 'FEEA'                                            262600
      **********                                                                              262600
      ***If*a*cashflow*written*is*a*fee*that*is*not*in*Loan*Currency,**                       262600
      ***obtain*the*converted*amount*from*LEEIRAPD*before*writing******                       262600
      ***to*ZAAMRTPD***************************************************                       262600
      **********                                                                              262600
     C**********         IF        LFCYCD <> CLCCY                                            262600
      **********                                                                              262600
     C**********         EVAL      kEIFSEQ = FEFSEQ                                           262600
     C*****KFSeq         CHAIN     LEEIRAL5                                                   262600
      **********                                                                              262600
     C**********         IF        %FOUND(LEEIRAL5)                                           262600
     C**********         EVAL      WCAMT = EAAMNT                                             262600
     C**********         ENDIF                                                                262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         WHEN      LFFTYP = 'SPIN'                                            262600
     C**********                   OR LFFTYP = 'PINC'                                         262600
     C**********                   OR LFFTYP = 'SSRP'                                         262600
     C**********                   OR LFFTYP = 'SRPY'                                         262600
     C**********                   OR LFFTYP = 'SRPA'                                         262600
     C**********                   OR LFFTYP = 'RPAY'                                         262600
     C**********                   OR LFFTYP = 'SPTF'                                         262600
     C**********                   OR LFFTYP = 'PTFA'                                         262600
     C**********                   OR LFFTYP = 'SPTT'                                         262600
     C**********                   OR LFFTYP = 'PTTA'                                         262600
     C**********         EVAL      EPCFTP = 'PCPL'                                            262600
      **********                                                                              262600
     C**********         WHEN         LFFTYP = 'INTP'                                         262600
     C**********                   OR LFFTYP = 'SINT'                                         262600
     C**********                   OR LFFTYP = 'MINT'                                         262600
     C**********                   OR LFFTYP = 'SMIN'                                         262600
     C**********         EVAL      EPCFTP = 'INTP'                                            262600
      **********                                                                              262600
     C**********         OTHER                                                                262600
     C**********         EVAL      EPCFTP = *BLANKS                                           262600
     C**********         ENDSL                                                                262600
      **********                                                                              262600
     C**********         IF           LFFTYP = 'ROIN'                                         262600
     C**********                      AND LFFLDT = PR_STDT                                    262600
     C**********         IF           CLPTYP = 66                                             262600
     C**********                      OR CLPTYP = 67                                          262600
     C**********                      OR CLPTYP = 69                                          262600
     C**********         EVAL      EPIOIN = 'I'                                               262600
     C**********         ELSE                                                                 262600
     C**********         EVAL      EPIOIN = 'O'                                               262600
     C**********         ENDIF                                                                262600
     C**********         ENDIF                                                                262600
      **********                                                                              262600
     C**********         WRITE     ZAAMRTD0                                                   262600
      **********                                                                              262600
     C*****CLLNRF        READE     LECFSFL0                                                   262600
     C**********         ENDDO                                                                262600
      **********                                                                              262600
     C**********         ENDSR                                                                262600
      *****************************************************************                       262600
      *                                                               *                       262600
      * SRCFAmortise - Generate Amortisation cashflow for previous    *                       262600
      *                EIR period                                     *                       262600
      *                                                               *                       262600
      * Called by: SRCFAmortLife                                      *                       262600
      *                                                               *                       262600
      * Calls: None                                                   *                       262600
      *                                                               *                       262600
      *****************************************************************                       262600
     C     SRCFAmortise  BEGSR                                                                262600
                                                                                              262600
      ** Obtain Cashflows from LECFSFPD                                                       262600
     C     CLLNRF        SETLL     LECFSFL0                                                   262600
     C     CLLNRF        READE     LECFSFL0                                                   262600
                                                                                              262600
      ** Write all cashflows from EIR Start of previous period to EIR Start of current period 262600
     C                   DOW       NOT %EOF(LECFSFL0)                                         262600
     C                   IF        LFFLDT >= WStartPrd                                        262600
     C                             AND LFFLDT <= WEndDate                                     262600
     C                             AND LFIOIN <> 'S'                                          262600
                                                                                              262600
      ** Exclude start amount                                                                 262600
     C                   IF        LFFTYP = 'SAMT'                                            262600
     C                             OR LFFTYP = 'SSAM'                                         262600
     C     CLLNRF        READE     LECFSFL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
                                                                                              262600
      ** If fee is amortised separately, skip                                                 262600
                                                                                              262600
     C                   IF        LFFSEQ <> 0                                                262600
                                                                                              262600
     C                   EVAL      kEITRAN = LFLNRF                                           262600
     C                   EVAL      kEIFSEQ = LFFSEQ                                           262600
                                                                                              262600
     C     KFSeq         CHAIN     LEFEEDLN                                                   262600
     C                   IF        NOT %FOUND(LEFEEDLN)                                       262600
     C     CLLNRF        READE     LECFSFL0                                                   262600
     C                   ITER                                                                 262600
     C                   ENDIF                                                                262600
     C                   ENDIF                                                                262600
                                                                                              262600
     C                   EVAL      EPTNMR = LFLNRF                                            262600
     C                   EVAL      EPFLDT = LFFLDT                                            262600
     C                   EVAL      EPCAMT = LFCAMT                                            262600
     C                   EVAL      EPIOIN = LFIOIN                                            262600
                                                                                              262600
      ** Set Cashflow types for ZAAMRTCALC                                                    262600
                                                                                              262600
     C                   SELECT                                                               262600
                                                                                              262600
     C                   WHEN      LFFTYP = 'EFAC'                                            262600
     C                             OR LFFTYP = 'SFAM'                                         262600
     C                             OR LFFTYP = 'SFBT'                                         262600
     C                   EVAL      EPCFTP = 'FEEA'                                            262600
                                                                                              262600
     C                   WHEN      LFFTYP = 'SPIN'                                            262600
     C                             OR LFFTYP = 'PINC'                                         262600
     C                             OR LFFTYP = 'SSRP'                                         262600
     C                             OR LFFTYP = 'SRPY'                                         262600
     C                             OR LFFTYP = 'SRPA'                                         262600
     C                             OR LFFTYP = 'RPAY'                                         262600
     C                             OR LFFTYP = 'SPTF'                                         262600
     C                             OR LFFTYP = 'PTFA'                                         262600
     C                             OR LFFTYP = 'SPTT'                                         262600
     C                             OR LFFTYP = 'PTTA'                                         262600
     C                   EVAL      EPCFTP = 'PCPL'                                            262600
                                                                                              262600
     C                   WHEN         LFFTYP = 'INTP'                                         262600
     C                             OR LFFTYP = 'SINT'                                         262600
     C                             OR LFFTYP = 'MINT'                                         262600
     C                             OR LFFTYP = 'SMIN'                                         262600
     C                             OR LFFTYP = 'SRPI'                                         262600
     C                   EVAL      EPCFTP = 'INTP'                                            262600
                                                                                              262600
     C                   OTHER                                                                262600
     C                   EVAL      EPCFTP = *BLANKS                                           262600
     C                   ENDSL                                                                262600
                                                                                              262600
     C                   EVAL      EPNDYY = *ZERO                                             262600
     C                   EVAL      EPNDEI = *ZERO                                             262600
                                                                                              262600
     C                   WRITE     ZAAMRTD0                                                   262600
                                                                                              262600
     C                   ENDIF                                                                262600
                                                                                              262600
     C     CLLNRF        READE     LECFSFL0                                                   262600
     C                   ENDDO                                                                262600
                                                                                              262600
     C                   ENDSR                                                                262600
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClearCF - Clear Cashflow files                              *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRClearCF     BEGSR
 
     C                   IF        wCFOpen = 'Y'
     C                   CLOSE     LEEIRPL0
     C                   CLOSE     LEEIRFL0
     C                   EVAL      wCFOpen = 'N'
     C                   ENDIF
 
     C                   MOVEL     ##OX1(9)      pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   MOVEL     ##OX1(10)     pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   IF        wCFOpen = 'N'
     C                   OPEN      LEEIRPL0
     C                   OPEN      LEEIRFL0
     C                   EVAL      wCFOpen = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClearAMRT - Clear Amortisation cash flow                    *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRClearAMRT   BEGSR
 
     C                   IF        wAMRTOpen = 'Y'
     C                   CLOSE     LEAMRTL0
     C                   EVAL      wAMRTOpen = 'N'
     C                   ENDIF
 
     C                   MOVEL     ##OX1(11)     pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   IF        wAMRTOpen = 'N'
     C                   OPEN      LEAMRTL0
     C                   EVAL      wAMRTOpen = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREIRCalc - Calling calculator to determine EIR               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREIRCalc     BEGSR
 
     C                   MOVEL     ##OX1(1)      pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   MOVEL     ##OX1(2)      pMESOVR
 
      * Override ZAEIRFPD
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   EVAL      POutEIR      = *ZERO
     C                   EVAL      PReturnCode  = *BLANKS
 
     C                   CALLB     'ZAEIRCALC'
 
      ** Input Parameter
     C                   PARM                    PInpTNRF
     C                   PARM                    PInpStartEff
     C                   PARM                    PInpEndEff
 
      ** Output Parameter
     C                   PARM                    POutEIR
     C                   PARM                    PReturnCode
 
     C                   MOVEL     ##OX1(3)      pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   MOVEL     ##OX1(4)      pMESOVR
 
      * Override ZAEIRFPD
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
      ** Save Effective Interest Rate for Adjustment Computation
     C                   EVAL      wEffIntRate = POutEIR
                                                                                              262628
      ** Write report header if required                                                      262628
     C                   Z-ADD     3             RQDLN1                                       262628
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                       262628
     C     DIFLN1        IFLE      RQDLN1                                                     262628
     C                   WRITE     LE004611H1                                                 262628
     C                   ENDIF                                                                262628
      *                                                                                       262628
      * Format and print EIR on audit report                                                  262628
     C                   EVAL      WkEIR = POutEIR * 100                                      262628
     C                   MOVE      WkEIR         ZFIELD                                       262628
     C                   EVAL      ZADEC = 8                                                  262628
                                                                                              262628
     C                   CALLB     'ZEDIT2'                                                   262628
     C                   PARM                    ZFIELD           16                          262628
     C                   PARM                    ZADEC             2 0                        262628
                                                                                              262628
     C                   EVAL      REIR   = ZFIELD                                            262628
     C                   WRITE     LE004611D2                                                 262628
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmortCalc - Compute amortisation                            *
      *                                                               *
      * Called by: SRCFAmortLife                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRAmortCalc   BEGSR
 
 
     C                   MOVEL     ##OX1(5)      pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   MOVEL     ##OX1(7)      pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   MOVE      PAMORTDS      PAmortDSA
 
      ** Call Amortisation Calculator
     C                   CALLB     'ZAAMRTCALC'
     C                   PARM                    PAmortDSA
 
     C                   MOVEL     PAmortDSA     PAMORTDS
 
     C                   MOVEL     ##OX1(6)      pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   MOVEL     ##OX1(8)      pMESOVR
     C                   CALL      'QCMDEXC'
     C                   PARM                    pMESOVR
     C                   PARM                    pMESLEN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDayNum - Determine No. of Days in Interest Years            *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDayNum      BEGSR
 
      ** If No. of Days in a Year in Hedging ICD is blank, use
      ** the common processing in Midas which are the following.
     C                   IF        FSNDYR = *BLANKS
                                                                                              262665
     C                   MOVE      @ICBS         ZZCALC                                       262665
                                                                                              262665
      ** Calculation Methods are:
     C                   SELECT
 
      ** 1  Actual/365
      ** 4  365/365 (excluding 29/02)
     C                   WHEN      @ICBS = 1 or @ICBS = 4
     C                   Z-ADD     365           @NDYY
 
      ** 2  Actual/360
      ** 3  360/360 (sometimes called 30/360)
      ** 5  365/360 (excluding 29/02)
     C                   WHEN      @ICBS = 2 or @ICBS = 3 or
     C                             @ICBS = 5
     C                   Z-ADD     360           @NDYY
 
      ** 6  Actual/366
     C                   WHEN      @ICBS = 6
     C                   Z-ADD     366           @NDYY
     C                   ENDSL
 
     C                   ELSE
 
     C                   MOVE      FSNDYR        @NDYY
     C                   SELECT
     C                   WHEN      @NDYY  = 360
     C                   EVAL      ZZCALC = '3'
     C                   WHEN      @NDYY  = 365
     C                   EVAL      ZZCALC = '4'
     C                   WHEN      @NDYY  = 366
     C                   EVAL      ZZCALC = '6'
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZINTDY - Call ZINTDY module for no. of days calculation     *
      *          for a given start and end date and calculation       *
      *          basis.                                               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRZINTDY      BEGSR
 
     C                   CALLB     'ZINTDY'
     C                   PARM                    PRetCode
     C                   PARM                    ZZINDY
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZCALC
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  262628
      *****************************************************************                       262628
      *                                                               *                       262628
      * RepHeader - Format and write report header for a loan or a fee*                       262628
      *                                                               *                       262628
      * Called by: SRCFAmortLife, SRCFAmortPrd                        *                       262628
      *                                                               *                       262628
      * Calls: ZDate2                                                 *                       262628
      *                                                               *                       262628
      *****************************************************************                       262628
     C     RepHeader     BEGSR                                                                262628
                                                                                              262628
     C                   MOVE      CLLNRF        RLNRF                                        262628
     C                   MOVE      CLCNUM        RCNUM                                        262628
     C                   MOVE      CLCCY         RCCY                                         262628
     C                   MOVE      EIFSEQ        RFSEQ                                        262628
                                                                                              262628
     C                   IF        wERAPRec = 'Y'                                             262628
     C                   EVAL      ZDAYNO = EISTDT                                            262628
     C                   ELSE                                                                 262628
     C                   EVAL      ZDAYNO = CR_STDT                                           262628
     C                   ENDIF                                                                262628
     C                   EXSR      ZDate2                                                     262628
     C                   EVAL      RSTPD = ZADATE                                             262628
                                                                                              262628
     C                   IF        wERAPRec = 'Y'                                             262628
     C                   EVAL      ZDAYNO = EIENDT                                            262628
     C                   ELSE                                                                 262628
     C                   EVAL      ZDAYNO = CR_ENDT                                           262628
     C                   ENDIF                                                                262628
     C                   EXSR      ZDate2                                                     262628
     C                   EVAL      RENPD = ZADATE                                             262628
                                                                                              262628
     C                   WRITE     LE004611H1                                                 262628
                                                                                              262628
     C                   WRITE     LE004611H2                                                 262628
                                                                                              262628
     C                   ENDSR                                                                262628
      /EJECT                                                                                  262628
      *****************************************************************                       262628
      *                                                               *                       262628
      * RepDetail - Format and write cash flow details on report      *                       262628
      *                                                               *                       262628
      * Called by: SRCFAmortLife, SRCFAmortPrd                        *                       262628
      *                                                               *                       262628
      * Calls: ZDate2                                                 *                       262628
      *                                                               *                       262628
      *****************************************************************                       262628
     C     RepDetail     BEGSR                                                                262628
                                                                                              262628
     C                   EVAL      ZDAYNO = LFFLDT                                            262628
     C                   EXSR      ZDate2                                                     262628
     C                   EVAL      RCDATE = ZADATE                                            262628
                                                                                              262628
     C                   EVAL      ZFLD15 = LFCAMT                                            262628
     C                   EVAL      PCCY = CLCCY                                               262628
     C                   EXSR      ZSEdit                                                     262628
     C                   EVAL      RCSFL  = ZOUT21                                            262628
                                                                                              262628
     C                   EVAL      RSIGN = LFIOIN                                             262628
                                                                                              262628
     C                   EVAL      RTYPE = LFFTYP                                             262628
                                                                                              262628
     C                   EVAL      *IN51 = *ON                                                262628
                                                                                              262628
      ** Write report header if required                                                      262628
     C                   Z-ADD     1             RQDLN1                                       262628
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                       262628
     C     DIFLN1        IFLE      RQDLN1                                                     262628
     C                   WRITE     LE004611H1                                                 262628
     C                   ENDIF                                                                262628
                                                                                              262628
     C                   WRITE     LE004611D1                                                 262628
                                                                                              262628
     C                   ENDSR                                                                262628
      /EJECT                                                                                  262628
      *****************************************************************                       262628
      *                                                               *                       262628
      * RepFooter - Format and write report footer                    *                       262628
      *                                                               *                       262628
      * Called by: Main                                               *                       262628
      *                                                               *                       262628
      *****************************************************************                       262628
     C     RepFooter     BEGSR                                                                262628
                                                                                              262628
      ** Write report header if required or if no details                                     262628
     C                   Z-ADD     3             RQDLN1                                       262628
     C     OFLLN1        SUB       PRTLN1        DIFLN1                                       262628
     C     DIFLN1        IFLE      RQDLN1                                                     262628
     C     *IN51         OREQ      *OFF                                                       262628
     C                   WRITE     LE004611H1                                                 262628
     C                   ENDIF                                                                262628
                                                                                              262628
     C                   WRITE     LE004611F1                                                 262628
                                                                                              262628
     C                   ENDSR                                                                262628
      /EJECT                                                                                  262628
      *****************************************************************                       262628
      *                                                               *                       262628
      *  ZDate2 - Call to 'ZDate2'                                    *                       262628
      *                                                               *                       262628
      *****************************************************************                       262628
                                                                                              262628
     C     ZDate2        BEGSR                                                                262628
                                                                                              262628
     C                   CALL      'ZDATE2'                                                   262628
     C                   PARM                    ZDAYNO                                       262628
     C                   PARM                    BJDFIN                                       262628
     C                   PARM      *ZERO         ZDATE                                        262628
     C                   PARM      *BLANKS       ZADATE                                       262628
                                                                                              262628
     C                   ENDSR                                                                262628
      /EJECT                                                                                  262628
      *****************************************************************                       262628
      *                                                               *                       262628
      *  ZSEdit - Call to 'ZSEDIT'                                    *                       262628
      *                                                               *                       262628
      *****************************************************************                       262628
                                                                                              262628
     C     ZSEdit        BEGSR                                                                262628
                                                                                              262628
     C                   CALL      'AOCURRR0'                                                 262628
     C                   PARM      *BLANKS       PRtCd                                        262628
     C                   PARM      '*KEY   '     POptn                                        262628
     C                   PARM                    PCCY                                         262628
     C     SDCURR        PARM      SDCURR        DSSDY                                        262628
                                                                                              262628
     C                   EVAL      ZDECS = A6NBDP                                             262628
                                                                                              262628
     C                   CALL      'ZSEDIT'                                                   262628
     C                   PARM                    ZFLD15                                       262628
     C                   PARM                    ZDECS                                        262628
     C                   PARM      'J'           ZECODE                                       262628
     C                   PARM                    ZOUT21                                       262628
                                                                                              262628
     C                   ENDSR                                                                262628
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
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Access Bank ICD
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
 
      ** Access General Ledger
     C                   CALLB     'AOGELRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDGELRPD'
     C                   EVAL      Dbase = 2
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if the system is set to Last Day Accrual
     C                   IF        BKALDI <> 'Y'
     C                   EVAL      wAccInd = 'F'
     C                   ENDIF
 
      ** Access Object for Hedge ICD
     C                   CALLB     'AOHEDGR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDHEDG        PARM      SDHEDG        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDHEDGPD'
     C                   EVAL      Dbase = 4
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Calculate Event Control Date
 
     C                   IF        (BJDNWD - 1) > BKAPDT
     C                   EVAL      wEvCD = BKAPDT
     C                   ELSE
     C                   EVAL      wEvCD = BJDNWD - 1
     C                   ENDIF
                                                                                              262628
      ** Ensure Report Spool File recorded by RCF.                                            262628
     C                   Z-ADD     SFNUM1        ZSNUM                                        262628
                                                                                              262628
     C                   CALL      'ZSFILE'                                                   262628
     C                   PARM                    ZSEQ                                         262628
     C                   PARM                    ZSENTY                                       262628
     C                   PARM                    SFILE1                                       262628
     C                   PARM                    ZSNUM                                        262628
     C                   PARM                    ZSERR                                        262628
 
     C     KLoanDate     KLIST
     C                   KFLD                    kEITRAN
     C                   KFLD                    kEIDate
 
     C     KFSeq         KLIST
     C                   KFLD                    kEITRAN
     C                   KFLD                    kEIFSEQ
 
     C*****KTranFSeq     KLIST                                                                262600
     C**********         KFLD                    kEITRAN                                      262600
     C**********         KFLD                    kEIFSEQ                                      262600
     C**********         KFLD                    wEISTDT                                      262600
 
     C                   ENDSR
      *****************************************************************
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
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
** ##OX1
OVRDBF FILE(ZAEIRPL0) TOFILE(LEEIRPL0) SEQONLY(*YES 500)
OVRDBF FILE(ZAEIRFL0) TOFILE(LEEIRFL0) SEQONLY(*YES 500)
DLTOVR FILE(ZAEIRPL0)
DLTOVR FILE(ZAEIRFL0)
OVRDBF FILE(ZAAMRTL0) TOFILE(LEAMRTL0) SEQONLY(*YES 500)
DLTOVR FILE(ZAAMRTL0)
OVRDBF FILE(ZAHTRNL0) TOFILE(LEHTRNL0) SEQONLY(*YES 500)
DLTOVR FILE(ZAHTRNL0)
CLRPFM FILE(LEEIRPPD)
CLRPFM FILE(LEEIRFPD)
CLRPFM FILE(LEAMRTPD)
