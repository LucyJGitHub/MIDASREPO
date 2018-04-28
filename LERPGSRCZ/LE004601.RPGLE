     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE EIR Period Split')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending module                              *
      *                                                               *
      *  LE004601 - LE Effective Interest Rate Period Split           *
      *                                                               *
      *  Function:  This module creates the periods pertinent to EIR  *
      *                                                               *
      *  Component of: LEC004601                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR750613           Date 05Jul11               *
      *                 CLE139             Date 06Dec10               *
      *                 257859             Date 17Feb09               *
      *                 258788             Date 06Feb09               *
      *                 257858             Date 12Nov08               *
      *                 257769             Date 12Nov08               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17970           Date 21Apr08               *
      *                 BUG17313           Date 03Apr08               *
      *                 CAS019A            Date 26Jul07               *
      *                 248261             Date 18May07               *
      *                 246564             Date 21Mar07               *
      *                 240648             Date 25May06               *
      *                 240646             Date 09May06               *
      *                 240305             Date 02May06               *
      *                 240643             Date 01May06               *
      *                 240636             Date 18Apr06               *
      *                 CAS016  *CREATE    Date 28Feb06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  AR750613 - No amortisation when forward value date is        *
      *             entered                                           *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  257859 - Rewrite SrChkAdj subroutine.                        *
      *           Correct errors in copy of LEEIRAPD records          *
      *           LEEIRAPD records for separate fees are lost if no   *
      *           records present on LEEIRDPD for the loan.           *
      *           Seton EIR recalculation flag for separate fees in   *
      *           case of changes to loan details.                    *
      *  258788 - No EIR/Amortisation computed for forward valued     *
      *           loans during COB on value date. Added a filter such *
      *           that LEEIRDPD record will only be created until     *
      *           loan value date is equal to or less than to event   *
      *           control date.                                       *
      *  257858 - EIR not calculated on fees amortised over period    *
      *  257769 - Missing Fee Amortisation when fee starts after loan *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17970- Change processing from Fee Start Date to Amort     *
      *            Start Date                                         *
      *  BUG17313- Always write to file if loan is amortising.        *
      *  CAS019A - CAS016 Upgrade to Midasplus-Alphanumeric Customer  *
      *            (Recompile)                                        *
      *  248261 - Fee was not reflected in EIRA and EIRD              *
      *  246564 - Missing EIRA records when new fee is inserted       *
      *  240648 - Double amount in 'Adj to Yld' field on LOAC         *
      *  240646 - Ensured that LEFEED and CLOANCL are updated         *
      *  240305 - Ensured that only current period has RCAL and ADJP  *
      *           set to 'Y'                                          *
      *  240643 - EIRA records not properly produced                  *
      *  240636 - Program goes through an Infinite Loop               *
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
 
      ** Midas SD Loan types/sub-types
     FSDLOANL3  IF   E           K DISK
 
      ** Midas LE Loans by Loan Type/Sub type
     FCLOANL8   UF   E           K DISK
 
      ** Midas LE EIR History File
     FLEHTRNL0  IF   E           K DISK    PREFIX(HS)
 
      ** Midas LE Effective Interest Rate Detail by Loan number and desc dates
     FLEEIRDL0  IF   E           K DISK
 
      ** Midas LE Effective Interest Rate File
     FLENEIRPD  O    E           K DISK    RENAME(LEEIRDD0:LENEIRD0)
     F                                     PREFIX(NW)
 
      ** Midas LE Effective Interest Rate Detail by Loan number
     FLEEIRAL4  IF   E           K DISK
 
      ** Midas LE Effective Interest Rate Detail File
     FLENERAPD  O    E           K DISK    RENAME(LEEIRAD0:LENERAD0)
     F                                     PREFIX(NW)
 
      ** Midas LE EIR Amortisation Over Period Detail
     FLEERAPPD  O    E           K DISK    PREFIX(EP:2)
 
      ** Midas LE EIR Amortisation Over Period Detail
     F***LEERAPL2  IF   E           K DISK    RENAME(LEERAPD0:LEERAPD2)                       257859
     FLEERAPL2  UF   E           K DISK    RENAME(LEERAPD0:LEERAPD2)                          257859
 
      ** Midas LE Backvalued Loan Amendments File keyed by loan number and date
     FLEAMDTL0  IF   E           K DISK
 
      ** Midas LE Loans File by Loan/Start select unamort amort sep 'N'
     FLEFEEDLL  UF   E           K DISK    RENAME(LEFEEDF:LEFEEDFL)
 
      ** Midas LE Loans File by Loan amort sep 'N' live or deleted only
     F***LEFEEDLK  IF   E           K DISK    RENAME(LEFEEDF:LEFEEDFK)                        240646
     FLEFEEDLK  UF   E           K DISK    RENAME(LEFEEDF:LEFEEDFK)                           240646
 
      ** Midas LE Loans File by Loan/Start select unamort amort sep 'Y'
     FLEFEEDLM  UF   E           K DISK    RENAME(LEFEEDF:LEFEEDFM)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** Ê D-specs                              Ê
      ** Ê =======                              Ê
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** Ê Named constants                      Ê
      ** Ê ===============                      Ê
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** Ê Arrays and Data Structures           Ê
      ** Ê ==========================           Ê
      ** +--------------------------------------+
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Midas General Ledger ICD file
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for Midas Hedging ICD file
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
 
      ** External data structure for Currency Details File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for LEEIRDPD
     D OldEIRFormat  E DS                  EXTNAME(LEEIRDPD)
 
      ** External data structure for LEEIRDPD
     D NEWEIRFormat  E DS                  EXTNAME(LENEIRPD)
     D                                     PREFIX(NW)
 
      ** Temporary DS for EIRD
     D PrvEIRFormat  E DS                  EXTNAME(LEEIRDPD)
     D                                     PREFIX(TM)
 
      ** External data structure for LEEIRAPD
     D OldEIRAFmt    E DS                  EXTNAME(LEEIRAPD)
 
      ** External data structure for LEEIRDPD
     D NewEIRAFmt    E DS                  EXTNAME(LENERAPD)
     D                                     PREFIX(NW)
 
      ** External data structure for LEERAPPD
     D ERAPFormat    E DS                  EXTNAME(LEERAPPD)
     D                                     PREFIX(EP:2)
 
      ** +--------------------------------------+
      ** Ê Declared variables                   Ê
      ** Ê ==================                   Ê
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Parameters
 
     D PRetCode        S              7A
     D POption         S              7A
     D PCurrency       S              3A
 
      ** Parameters for calling GLINTC
     D pZIBEG          S              5  0
     D pZIEND          S              5  0
     D pZICALC         S              1  0
     D pZIAMT          S             15  0
     D pZIRATE         S             11  7
     D pZINTR          S             30  9
 
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
 
      ** Work Fields
 
      ** Temporary Fields for Initial Exchange Rate
     D WExchangeRte    S             11P 7
     D WMultDivInd     S              1A
 
     D WEvCD           S              5P 0
     D WControlDate    S              5P 0
     D WDate           S              5P 0
 
     D WMode           S              1A   INZ(' ')
     D WFeeFoundF      S              1A
     D WFSeq           S              2S 0
     D WWriteEIRDF     S              1A   INZ('N')                                           248261
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
 
      ** Read Deal Type/Sub Type combinations to index deals file
     C     *LOVAL        SETLL     SDLOANL3
     C                   READ      SDLOANL3
 
     C                   DOW       NOT %EOF(SDLOANL3)
 
     C     KLoanType     SETLL     CLOANL8
     C     KLoanType     READE     CLOANL8
 
      ** Read thru Loans file
     C                   DOW       NOT %EOF(CLOANL8)
 
      ** Skip loans valuing before the cut over date and do not have
      ** set Maturity Dates
     C                   IF        FSNLAC > VDAT
     C                             OR FSNLAC <= VDAT
     C                             AND MDAT = 0
     C     KLoanType     READE     CLOANL8
     C                   ITER
     C                   ENDIF
 
     C**********         EVAL      WWriteEIRDF = 'N'                                 248261 BUG17313
      *                                                                                     BUG17313
      * Always write to file if amortising loan                                             BUG17313
     C                   EVAL      WWriteEIRDF = 'Y'                                        BUG17313
     C                   EXSR      SrAmortLife
     C                   EXSR      SrAmortPeriod
 
     C                   UPDATE    CLOANCLF
     C     KLoanType     READE     CLOANL8
 
     C                   ENDDO
     C                   READ      SDLOANL3
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortLife - Process EIR records of valid loans              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SrChkAmend                                             *
      *                                                               *
      *****************************************************************
 
     C     SrAmortLife   BEGSR
 
      ** Check if an EIRD record exists for the loan
     C     LNRF          SETGT     LEEIRDL0
     C     LNRF          READPE    LEEIRDL0
 
     C                   SELECT
 
     C                   WHEN      NOT %EOF(LEEIRDL0)
     C                             AND EIRCAL <> 'Y' AND EIADJP <> 'Y'
 
     C                   EVAL      WControlDate = *HIVAL
 
      ** Copy all records from LEEIRDPD to LENEIRPD
     C                   EXSR      SrCopyEIRD
 
      ** Copy all records from LEEIRAPD to LENERAPD
     C                   EXSR      SrCopyEIRA
 
     C                   WHEN      NOT %EOF(LEEIRDL0)
     C                             AND EIADJP = 'Y'
     C                   EXSR      SrChkAdj
 
     C                   OTHER
     C     VDAT          IFLE      WeVCD                                                      258788
     C                   EXSR      SrNewEIR
                                                                                              257859
      ** Copy all records from LEEIRAPD to LENERAPD in case there are                         257859
      ** fees amortising separately                                                           257859
                                                                                              257859
     C                   EVAL      WControlDate = *HIVAL                                      257859
     C                   EXSR      SrCopyEIRA                                                 257859
     C                   ENDIF                                                                258788
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmortPeriod - Process EIR records of Fees amortised         *
      *                 independently                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrAmortPeriod BEGSR
 
     C     LNRF          SETLL     LEFEEDLM
     C     LNRF          READE     LEFEEDLM
 
     C                   DOW       NOT %EOF(LEFEEDLM)
     C                   IF        (FERECI <> '*')                                            248261
     C                   EVAL      WFSeq = FEFSEQ
     C     KLoanFSeq3    CHAIN     LEERAPL2
     C                   SELECT
 
     C                   WHEN      NOT %FOUND(LEERAPL2)
     C**********                   AND FEPSTD <= WEvCd                                      BUG17970
     C                             AND FESTPD <= WEvCd                                      BUG17970
 
     C                   CLEAR                   ERAPFormat
     C**********         EVAL      EPSTDT = FEPSTD                                          BUG17970
     C                   EVAL      EPSTDT = FESTPD                                          BUG17970
     C                   EVAL      EPENDT = FEENPD
     C                   EVAL      NWEISTDT = EPSTDT
     C                   EVAL      NWEIENDT = EPENDT
 
     C                   EVAL      WMode = 'F'
     C                   EXSR      SrNewEIRA
     C                   EVAL      FEFEAM = NWEAAMNT
     C**********         EVAL      TFAM = FEFEAM + TFAM                                       240648
     C                   UPDATE    LEFEEDFM
 
     C                   EVAL      EPRECI = 'D'
     C                   EVAL      EPTRAN = LNRF
     C                   EVAL      EPFSEQ = FEFSEQ
     C                   EVAL      EPRCAL = 'Y'
     C                   EVAL      EPFEEA = NWEAAMNT
     C**********         EXSR      SrCompERAPInt                                              248261
     C                   WRITE     LEERAPD0
     C                   ENDSL
 
     C                   ENDIF                                                                248261
     C     LNRF          READE     LEFEEDLM
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNewEIR - Create New EIR Periods and the corresponding       *
      *            details                                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrNewEIR      BEGSR
 
     C                   CLEAR                   NewEIRFormat
     C                   EVAL      NWEIRECI = 'D'
     C                   EVAL      NWEITRAN = LNRF
     C                   EVAL      NWEISTDT = VDAT
     C                   EVAL      NWEIENDT = MDAT
     C                   EVAL      NWEIRCAL = 'Y'
 
     C                   EVAL      WMode = *BLANKS
     C                   IF        TOTI <> 0
     C                   EVAL      WMode = ' '
     C                   EXSR      SrNewEIRA
     C                   EVAL      NWEIDSTD = TOTI
     C                   EVAL      NWEIFDPA = TOTI
     C                   EVAL      DSAM = TOTI
     C                   EVAL      WWriteEIRDF = 'Y'                                          248261
     C                   ENDIF
 
     C*****LNRF*         SETLL     LEFEEDLL                                                   257859
     C*****LNRF*         READE     LEFEEDLL                                                   257859
     C**********         DOW       NOT %EOF(LEFEEDLL)                                         257859
     C     LNRF          SETLL     LEFEEDLK                                                   257859
     C     LNRF          READE     LEFEEDLK                                                   257859
     C                   DOW       NOT %EOF(LEFEEDLK)                                         257859
     C**********                   AND FEPSTD <= BJRDNB                                     BUG17970
     C**********                   AND FESTPD <= BJRDNB                            BUG17970 AR750613
     C                             AND FESTPD <= WeVCD                                      AR750613
     C**********                   AND FERECI <> '*'                                          248261
     C                   IF        FERECI <> '*'                                              248261
     C                   EVAL      WMode = 'F'
     C                   EVAL      WWriteEIRDF = 'Y'                                          248261
     C                   EXSR      SrNewEIRA
     C                   EVAL      NWEIFDPA = NWEIFDPA + NWEAAMNT
     C                   EVAL      FEFEAM = NWEAAMNT
     C**********         EVAL      TFAM = FEFEAM + TFAM                                       240648
     C**********         UPDATE    LEFEEDFL                                                   257859
     C                   UPDATE    LEFEEDFK                                                   257859
     C                   ENDIF                                                                248261
     C*****LNRF*         READE     LEFEEDLL                                                   257859
     C     LNRF          READE     LEFEEDLK                                                   257859
     C                   ENDDO
 
     C                   EVAL      TFDP = TFAM + DSAM
 
     C                   IF        WWriteEIRDF = 'Y'                                          248261
     C                   WRITE     LENEIRD0
     C                   ENDIF                                                                248261
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       257859
      *****************************************************************                       257859
      **SrChkAdj*-*Check*adjustments*processing*for*loan***************                       257859
      *****************************************************************                       257859
      **Called*by:*SrProcess*******************************************                       257859
      *****************************************************************                       257859
      **Calls:*None****************************************************                       257859
      *****************************************************************                       257859
      *****************************************************************                       257859
      *****************************************************************                       257859
     C*****SrChkAdj      BEGSR                                                                257859
      *****************************************************************                       257859
      ***Check*if*a*backvalued*amendment*exists*on*the*loan************                       257859
     C*****LNRF*         SETLL     LEAMDTL0                                                   257859
     C*****LNRF*         READE     LEAMDTL0                                                   257859
      *****************************************************************                       257859
     C**********         IF        %EOF(LEAMDTL0)                                             257859
      *****************************************************************                       257859
     C**********         EVAL      WControlDate = BJRDNB                                      257859
      ***Discard EIR Periods before control date. not needed here                             257859
     C**********         DOW       WControlDate < EISTDT                                      257859
     C*****LNRF*         READPE    LEEIRDL0                                                   257859
     C**********         ENDDO                                                                257859
      *****************************************************************                       257859
      ***Check*if*there*are*fees*not*yet*amortising*that*are*earlier*than Rundate             257859
     C**********         EVAL      WDate = WControlDate                                       257859
     C*****KLoanDate     SETLL     LEFEEDLL                                                   257859
     C*****LNRF*         READPE    LEFEEDLL                                                   257859
      *****************************************************************                       257859
     C**********         IF        %EOF(LEFEEDLL)                                             257859
      ***When*there*are*no*fees,*create*new*records*in*EIRD*from*EIR***                       257859
      ***Start*progressively*upto*rundate******************************                       257859
      *****************************************************************                       257859
     C**********         EVAL      WControlDate = BJRDNB                                      257859
      *****************************************************************                       257859
     C**********         EXSR      SrCopyEIRD                                                 257859
      *****************************************************************                       257859
     C**********         EVAL      NewEIRFormat = PrvEIRFormat                                257859
      *****************************************************************                240643 257859
     C**********         EXSR      SrCopyEIRA                                          240643 257859
      *****************************************************************                240643 257859
     C*****KLoanDate     SETLL     LEFEEDLK                                            240643 240648
     C*****KLoanDate     READE     LEFEEDLK                                            240643 240648
     C*****LNRF*         SETLL     LEFEEDLK                                            240648 257859
     C**********         READ      LEFEEDLK                                            240648 257859
      *****************************************************************                240643 257859
     C**********         DOW       NOT %EOF(LEFEEDLK)                                  240643 257859
      *****************************************************************                240643 257859
     C**********         EVAL      NWEISTDT = FEPSTD                                   240643 240648
     C**********         EVAL      NWEISTDT = WControlDate                             240648 257859
     C**********         EVAL      WMode = 'F'                                         240643 257859
     C**********         IF        FERECI = '*'                                        240643 257859
     C**********         EVAL      NWEIFDPA = FEFAMT - EIFDPA                          240643 257859
     C**********         EVAL      TFAM = TFAM - FEFEAM                                240646 240648
     C**********         EVAL      TFDP = TFDP - FEFEAM                                240646 240648
     C**********         ENDIF                                                         240643 257859
      *****************************************************************                240643 257859
     C**********         IF        FERECI <> '*'                                       240643 257859
     C*****KLnFSeqDte    CHAIN     LEEIRAL4                                            240643 257859
     C**********         IF        %FOUND(LEEIRAL4)                                    240643 257859
     C**********         EVAL      NewEIRAFmt = OldEIRAFmt                             240643 257859
     C**********         IF        NWEASTDT <> BJRDNB                                  240643 257859
     C**********         EVAL      NWEASTDT = BJRDNB                                   240646 257859
     C**********         ENDIF                                                         240643 257859
     C**********         WRITE     LENERAD0                                            240643 257859
     C**********         ELSE                                                          240643 257859
     C**********         EXSR      SrNewEIRA                                           240643 257859
     C**********         EVAL      NWEIFDPA = NWEIFDPA + NWEAAMNT                      240646 257859
     C**********         EVAL      FEFEAM = NWEAAMNT                                   240646 257859
     C**********         UPDATE    LEFEEDFK                                            240646 257859
     C**********         EVAL      TFAM = TFAM + FEFEAM                                240646 240648
     C**********         EVAL      TFDP = TFDP + FEFEAM                                240646 240648
     C**********         ENDIF                                                         240643 257859
     C**********         ENDIF                                                         240643 257859
      *****************************************************************                240643 257859
     C***  KLoanDate     READE     LEFEEDLK                                                   240643
     C*****LNRF*         READE     LEFEEDLK                                            240648 257859
     C**********         ENDDO                                                         240643 257859
      *****************************************************************                240643 257859
     C**********         EVAL      NWEIRCAL = 'Y'                                             257859
     C**********         EVAL      NWEISTDT = BJRDNB                                          257859
     C**********         EVAL      WMode = ' '                                         240643 240648
     C**********         EVAL      FEFSEQ = *ZEROS                                     240648 257859
     C*****KLoanFSeq     CHAIN     LEEIRAL4                                            240648 257859
     C**********         IF        %FOUND(LEEIRAL4)                                    240648 257859
     C**********         EVAL      NewEIRAFmt = OldEIRAFmt                             240648 257859
     C**********         EVAL      NWEASTDT = BJRDNB                                   240648 257859
     C**********         WRITE     LENERAD0                                            240648 257859
     C**********         ENDIF                                                         240648 257859
     C**********         EXSR      SrNewEIRA                                           240643 240648
     C**********         WRITE     LENEIRD0                                                   257859
      *****************************************************************                       257859
     C**********         ELSE                                                                 257859
      ***If*there*are*backvalued*fees*present,*discard*previously*written                     257859
      ***that*are*after*last*fee*date**********************************                       257859
      *****************************************************************                       257859
      ***Identify*earliest*backvalued*fee******************************                       257859
     C**********         DOW       NOT %EOF(LEFEEDLL)                                         257859
     C*****LNRF*         READPE    LEFEEDLL                                                   257859
     C**********         ENDDO                                                                257859
      *****************************************************************                       257859
     C**********         EVAL      WControlDate = FEPSTD                                      246564
     C**********         EVAL      WControlDate = FEPSTD - 1                         246564 BUG17970
     C**********         EVAL      WControlDate = FESTPD - 1                         BUG17970 257859
     C**********         CLEAR                   PrvEIRFormat                          246564 257859
      *****************************************************************                       257859
      ***Copy*All*records*before*first*backvalued*fee******************                       257859
     C**********         EXSR      SrCopyEIRD                                                 257859
      *****************************************************************                       257859
     C**********         EVAL      WDate = WControlDate                                       257859
     C*****KLoanDate     SETLL     LEFEEDLK                                                   257859
     C*****LNRF*         READE     LEFEEDLK                                                   257859
      *****************************************************************                       257859
     C**********         DOU       NOT %EOF(LEFEEDLK)                                         240636
     C**********         DOU       %EOF(LEFEEDLK)                                      240636 257859
     C**********                   OR FEPSTD > WEvCD                                        BUG17970
     C**********                   OR FESTPD > WEvCD                                 BUG17970 257859
      *****************************************************************                       257859
     C**********         IF        FEPSTD < WControlDate                                    BUG17970
     C**********         IF        FESTPD < WControlDate                             BUG17970 257859
     C*****LNRF*         READE     LEFEEDLK                                                   257859
     C**********         ITER                                                                 257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
      ***Note:*PrvEIRFormat*came*from*SrCopyEIRD***********************                       257859
     C**********         IF        TMEITRAN = *ZEROS                                   246564 257859
     C*****LNRF*         CHAIN     LEEIRDL0                                            246564 257859
     C**********         EVAL      NewEIRFormat = OldEIRFormat                         246564 257859
     C**********         ELSE                                                          246564 257859
     C**********         EVAL      NewEIRFormat = PrvEIRFormat                                257859
     C**********         ENDIF                                                         246564 257859
     C**********         EVAL      NWEISTDT = FEPSTD                                        BUG17970
     C**********         EVAL      NWEISTDT = FESTPD                                 BUG17970 257859
     C**********         IF        FERECI = '*'                                               257859
     C**********         EVAL      NWEIFDPA = FEFAMT - EIFDPA                                 257859
     C**********         EVAL      TFAM = TFAM - FEFEAM                                240646 240648
     C**********         EVAL      TFDP = TFDP - FEFEAM                                240646 240648
     C**********         ELSE                                                                 257859
     C**********         EVAL      NWEIFDPA = FEFAMT + EIFDPA                                 257859
     C**********         ENDIF                                                                257859
     C**********         EVAL      WMode = ' '                                         240643 257859
     C**********         EXSR      SrNewEIRA                                           240643 257859
     C**********         WRITE     LENEIRD0                                                   257859
     C**********         EVAL      PrvEIRFormat = NewEIRFormat                                257859
      *****************************************************************                       257859
     C**********         IF        FERECI <> '*'                                              257859
     C*****KLnFSeqDte    CHAIN     LEEIRAL4                                                   257859
     C**********         IF        %FOUND(LEEIRAL4)                                           257859
     C**********         EVAL      NewEIRAFmt = OldEIRAFmt                                    257859
     C**********         WRITE     LENERAD0                                                   257859
     C**********         ELSE                                                                 257859
     C**********         EXSR      SrNewEIRA                                           240636 257859
     C**********         EVAL      NWEIFDPA = NWEIFDPA + NWEAAMNT                      240646 257859
     C**********         EVAL      FEFEAM = NWEAAMNT                                   240646 257859
     C**********         UPDATE    LEFEEDFK                                            240646 257859
     C**********         EVAL      TFAM = TFAM + FEFEAM                                240646 240648
     C**********         EVAL      TFDP = TFDP + FEFEAM                                240646 240648
     C**********         ENDIF                                                                257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
     C*****LNRF*         READE     LEFEEDLK                                                   257859
     C**********         ENDDO                                                                257859
      *****************************************************************                       257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
     C**********         ELSE                                                                 257859
      *****************************************************************                       257859
      ***If*a*backvalued*amendment*is*present,*check*if*a*backvalued*fee                      257859
      ***occurs*earlier*than*it****************************************                       257859
      ***Check*if*there*are*fees*not*yet*amortising*that*are*earlier*than Amend date          257859
     C**********         EVAL      WDate = AMVDAT                                             257859
     C*****KLoanDate     SETGT     LEFEEDLL                                                   257859
     C*****LNRF*         READPE    LEFEEDLL                                                   257859
      *****************************************************************                       257859
     C**********         DOW       NOT %EOF(LEFEEDLL)                                         257859
     C**********         EVAL      WFeeFoundF = 'Y'                                           257859
     C*****LNRF*         READPE    LEFEEDLL                                                   257859
     C**********         ENDDO                                                                257859
      *****************************************************************                       257859
     C**********         IF        WFeeFoundf = 'Y'                                           257859
     C**********         EVAL      WControlDate = FEPSTD                                    BUG17970
     C**********         EVAL      WControlDate = FESTPD                             BUG17970 257859
     C**********         ELSE                                                                 257859
     C**********         EVAL      WControlDate = AMVDAT                                      257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
      ***Copy*All records before first backvalued fee                                         257859
      *****************************************************************                       257859
     C**********         EXSR      SrCopyEIRD                                                 257859
      *****************************************************************                       257859
     C**********         EVAL      WDate = WControlDate                                       257859
     C*****KLoanDate     SETLL     LEFEEDLK                                                   257859
     C*****LNRF*         READE     LEFEEDLK                                                   257859
      *****************************************************************                       257859
     C**********         DOU       %EOF(LEFEEDLK)                                             257859
     C**********                   OR FEPSTD > WEvCD                                        BUG17970
     C**********                   OR FESTPD > WEvCD                                 BUG17970 257859
      *****************************************************************                       257859
     C**********         IF        WFeeFoundf = 'Y'                                           257859
     C**********                   AND FEPSTD < WControlDate                                BUG17970
     C**********                   AND FESTPD < WControlDate                         BUG17970 257859
     C*****LNRF*         READE     LEFEEDLK                                                   257859
     C**********         ITER                                                                 257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
     C**********         IF        WFeeFoundf <> 'Y'                                          257859
     C**********         EVAL      NewEIRFormat = PrvEIRFormat                                257859
     C**********         EVAL      NWEISTDT = AMVDAT                                          257859
     C**********         EVAL      WMode = ' '                                         240643 257859
     C**********         EXSR      SrNewEIRA                                           240643 257859
     C**********         EVAL      NWEIRCAL = 'Y'                                             257859
     C**********         WRITE     LENEIRD0                                                   257859
     C**********         ELSE                                                                 257859
      *****************************************************************                       257859
      ***Note:*PrvEIRFormat*came*from*SrCopyEIRD***********************                       257859
     C**********         EVAL      NewEIRFormat = PrvEIRFormat                                257859
     C**********         EVAL      NWEISTDT = FEPSTD                                        BUG17970
     C**********         EVAL      NWEISTDT = FESTPD                                 BUG17970 257859
     C**********         IF        FERECI = '*'                                               257859
     C**********         EVAL      NWEIFDPA = FEFAMT - EIFDPA                                 257859
     C**********         EVAL      TFAM = TFAM - FEFEAM                                240646 240648
     C**********         EVAL      TFDP = TFDP - FEFEAM                                240646 240648
     C**********         ELSE                                                                 257859
     C**********         EVAL      NWEIFDPA = FEFAMT + EIFDPA                                 257859
     C**********         ENDIF                                                                257859
     C**********         EVAL      WMode = ' '                                         240643 257859
     C**********         EXSR      SrNewEIRA                                           240643 257859
     C**********         WRITE     LENEIRD0                                                   257859
     C**********         EVAL      PrvEIRFormat = NewEIRFormat                                257859
      *****************************************************************                       257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
     C**********         IF        FERECI <> '*'                                              257859
     C*****KLnFSeqDte    CHAIN     LEEIRAL4                                                   257859
     C**********         IF        %FOUND(LEEIRAL4)                                           257859
     C**********         EVAL      NewEIRAFmt = OldEIRAFmt                                    257859
     C**********         WRITE     LENERAD0                                                   257859
     C**********         ELSE                                                                 257859
     C**********         EXSR      SrNewEIRA                                           240636 257859
     C**********         EVAL      NWEIFDPA = NWEIFDPA + NWEAAMNT                      240646 257859
     C**********         EVAL      FEFEAM = NWEAAMNT                                   240646 257859
     C**********         UPDATE    LEFEEDFK                                            240646 257859
     C**********         EVAL      TFAM = TFAM + FEFEAM                                240646 240648
     C**********         EVAL      TFDP = TFDP + FEFEAM                                240646 240648
     C**********         ENDIF                                                                257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
     C*****LNRF*         READE     LEFEEDLK                                                   257859
     C**********         ENDDO                                                                257859
      *****************************************************************                       257859
     C**********         ENDIF                                                                257859
      *****************************************************************                       257859
     C**********         ENDSR                                                                257859
      *****************************************************************                       257859
      *                                                               *                       257859
      * SrChkAdj - Check adjustments processing for loan              *                       257859
      *                                                               *                       257859
      * Called by: SrProcess                                          *                       257859
      *                                                               *                       257859
      * Calls: SrNewEIR                                               *                       257859
      *        SrCopyEIRD                                             *                       257859
      *        SrCopyEIRA                                             *                       257859
      *                                                               *                       257859
      *****************************************************************                       257859
                                                                                              257859
     C     SrChkAdj      BEGSR                                                                257859
                                                                                              257859
      *  Determine earliest date since when EIR needs to be recalculated                      257859
      *  This is normally the run date, but could be earlier in the                           257859
      *  following cases:                                                                     257859
      *  - a fee enters its amortisation period today                                         257859
      *  - a fee which was being amortised has been reversed today                            257859
      *  - a backvalued loan amendment was entered today                                      257859
                                                                                              257859
     C                   EVAL      WControlDate = BJRDNB                                      257859
                                                                                              257859
     C     LNRF          SETLL     LEFEEDLK                                                   257859
     C     LNRF          READE     LEFEEDLK                                                   257859
                                                                                              257859
     C                   DOW       NOT %EOF(LEFEEDLK)                                         257859
                                                                                              257859
     C                   IF        FERECI <> '*'                                              257859
     C                             AND FESTPD >= BJRDNB                                       257859
     C                             AND FESTPD <= wEVCD                                        257859
     C                             OR FERECI = '*'                                            257859
     C                             AND FESTPD <= BJRDNB                                       257859
     C                             AND FEORED < BJRDNB                                        257859
     C                   IF        FESTPD < WControlDate                                      257859
     C                   EVAL      WControlDate = FESTPD                                      257859
     C                   ENDIF                                                                257859
     C                   ENDIF                                                                257859
                                                                                              257859
     C     LNRF          READE     LEFEEDLK                                                   257859
     C                   ENDDO                                                                257859
                                                                                              257859
     C     LNRF          CHAIN     LEAMDTL0                                                   257859
     C                   IF        %Found(LEAMDTL0)                                           257859
     C                             AND AMVDAT < WControlDate                                  257859
     C                   EVAL      WControlDate = AMVDAT                                      257859
     C                   ENDIF                                                                257859
                                                                                              257859
      ** If control date is same as loan start date then store details                        257859
      ** of existing record on EIRD and copy records on EIRA                                  257859
                                                                                              257859
     C                   IF        WControlDate = VDAT                                        257859
     C                   EVAL      PrvEIRFormat = OldEIRFormat                                257859
     C                   EVAL      WControlDate = BJRDNB                                      257859
     C                   EXSR      SrCopyEIRA                                                 257859
     C                   EVAL      WControlDate = VDAT                                        257859
                                                                                              257859
      ** Otherwise copy records from old files up to control date                             257859
     C                   ELSE                                                                 257859
                                                                                              257859
     C                   EXSR      SrCopyEIRD                                                 257859
     C                   EXSR      SrCopyEIRA                                                 257859
     C                   ENDIF                                                                257859
                                                                                              257859
      ** and write a new EIRA record for each new fee                                         257859
                                                                                              257859
     C     LNRF          SETLL     LEFEEDLL                                                   257859
     C     LNRF          READE     LEFEEDLL                                                   257859
     C                   DOW       NOT %EOF(LEFEEDLL)                                         257859
     C                   IF        FERECI <> '*'                                              257859
     C                             AND FESTPD <= wEVCD                                        257859
     C                   EVAL      WMode = 'F'                                                257859
     C                   EXSR      SrNewEIRA                                                  257859
     C                   EVAL      TMEIFDPA = TMEIFDPA + NWEAAMNT                             257859
     C                   EVAL      FEFEAM = NWEAAMNT                                          257859
     C                   UPDATE    LEFEEDFL                                                   257859
     C                   ENDIF                                                                257859
     C     LNRF          READE     LEFEEDLL                                                   257859
     C                   ENDDO                                                                257859
                                                                                              257859
      ** and write a new EIRD record to trigger EIR recalculation in                          257859
      ** LE004611                                                                             257859
                                                                                              257859
     C                   EVAL      NewEIRFormat = PrvEIRFormat                                257859
     C                   EVAL      NWEIRECI = 'D'                                             257859
     C                   EVAL      NWEISTDT = WControlDate                                    257859
     C                   EVAL      NWEIADJP = ' '                                             257859
     C                   EVAL      NWEIRCAL = 'Y'                                             257859
     C                   WRITE     LENEIRD0                                                   257859
                                                                                              257859
      ** Check if there are separate fees attached to the loan which                          257859
      ** start their amortisation period on or after the control date.                        257859
      ** If yes, set on the EIR recalculation indicator and copy across                       257859
      ** their EIRA record.                                                                   257859
                                                                                              257859
     C     LNRF          SETLL     LEERAPL2                                                   257859
     C     LNRF          READE     LEERAPL2                                                   257859
                                                                                              257859
     C                   DOW       NOT %EOF(LEERAPL2)                                         257859
                                                                                              257859
     C                   IF        EIRECI = 'D'                                               257859
     C                             AND EISTDT >= WControlDate                                 257859
                                                                                              257859
     C                   EVAL      NWEIRCAL = 'Y'                                             257859
     C                   UPDATE    LEERAPD2                                                   257859
                                                                                              257859
     C                   EVAL      FEFSEQ = EIFSEQ                                            257859
     C     KLoanFSeq     CHAIN     LEEIRAL4                                                   257859
     C                   IF        %FOUND(LEEIRAL4)                                           257859
     C                   EVAL      NewEIRAFmt = OldEIRAFmt                                    257859
     C                   WRITE     LENERAD0                                                   257859
     C                   ENDIF                                                                257859
                                                                                              257859
     C                   ENDIF                                                                257859
                                                                                              257859
     C     LNRF          READE     LEERAPL2                                                   257859
     C                   ENDDO                                                                257859
                                                                                              257859
     C                   ENDSR                                                                257859
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCopyEIRD - Process EIR records to be retained               *
      *                                                               *
      * Called by: SrChkAmd                                           *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrCopyEIRD    BEGSR
 
      ** Read Through EIRD Records from initial record up to control date
     C     LNRF          SETLL     LEEIRDL0
     C     LNRF          READE     LEEIRDL0
 
     C**********         DOW       EISTDT <= WControlDate                                     246564
     C                   DOW       EISTDT < WControlDate                                      246564
     C                             AND NOT %EOF(LEEIRDL0)
 
     C                   EVAL      NewEIRFormat = OldEIRFormat
     C                   EVAL      NWEIADJP = ' '                                             240305
     C                   EVAL      NWEIRCAL = ' '                                             240305
     C                   WRITE     LENEIRD0
      ** Save last EIR record before the control date
     C                   EVAL      PrvEIRFormat = NewEIRFormat
 
     C     LNRF          READE     LEEIRDL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCopyEIRA - Process EIR details to be retained               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrCopyEIRA    BEGSR
 
      ** Read Through EIRD Records from initial record up to control date
     C     LNRF          SETLL     LEEIRAL4
     C     LNRF          READE     LEEIRAL4
 
     C**********         DOW       EISTDT < WControlDate                                      257859
     C**********                   AND NOT %EOF(LEEIRAL4)                                     257859
     C                   DOW       NOT %EOF(LEEIRAL4)                                         257859
     C                   IF        EASTDT < WControlDate                                      257859
 
     C                   EVAL      NewEIRAFmt = OldEIRAFmt
     C                   WRITE     LENERAD0
     C                   ENDIF                                                                257859
      ***Save*last*EIR*record*before*the*control*date******************                       257859
     C**********         EVAL      PrvEIRFormat = NewEIRFormat                                257859
 
     C     LNRF          READE     LEEIRAL4
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCompERAPInt - Compute Interest for ERAP                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SrCompERAPInt BEGSR
 
     C                   EVAL      WDate = EPSTDT
     C     KLoanDate     SETGT     LEHTRNL0
     C                   READP     LEHTRNL0
 
     C                   IF        HSVDAT = EPSTDT
     C                   EVAL      EPSINT = HSAITC
     C                   ELSE
 
     C                   EVAL      pZIBEG  = HSVDAT
     C                   EVAL      pZIEND  = EPSTDT
     C                   EVAL      pZICALC = HSCALC
     C                   EVAL      pZIAMT  = HSCPAM
     C                   EVAL      pZIRATE = HSINTR
 
     C                   CALL      'GLINTC'
     C                   PARM                    pZIBEG
     C                   PARM                    pZIEND
     C                   PARM                    pZICALC
     C                   PARM                    pZIAMT
     C                   PARM                    pZIRATE
     C                   PARM                    pZINTR
 
     C                   EVAL      EPSINT = HSAITC + pZINTR - HSIPRD
     C                   ENDIF
 
     C                   EVAL      WDate = EPENDT
     C     KLoanDate     SETGT     LEHTRNL0
     C                   READP     LEHTRNL0
 
     C                   IF        HSVDAT = EPENDT
     C                   EVAL      EPEINT = HSAITC
     C                   ELSE
 
     C                   EVAL      pZIBEG  = HSVDAT
     C                   EVAL      pZIEND  = EPENDT
     C                   EVAL      pZICALC = HSCALC
     C                   EVAL      pZIAMT  = HSCPAM
     C                   EVAL      pZIRATE = HSINTR
 
     C                   CALL      'GLINTC'
     C                   PARM                    pZIBEG
     C                   PARM                    pZIEND
     C                   PARM                    pZICALC
     C                   PARM                    pZIAMT
     C                   PARM                    pZIRATE
     C                   PARM                    pZINTR
 
     C                   EVAL      EPEINT = HSAITC + pZINTR - HSIPRD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCreateEIRA - Create New EIRA Records                        *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrCreateEIRA  BEGSR
 
     C                   CLEAR                   NewEIRAFmt
      ** Discount
     C                   IF        TOTI <> 0
     C                             AND WMode <> 'F'
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrCurr
     C                   EVAL      NWEARECI = 'D'
     C                   EVAL      NWEATYPE = 'D'
     C                   EVAL      NWEATRAN = LNRF
     C                   EVAL      NWEAFCOD = *ZEROS
     C                   EVAL      NWEAFSEQ = *ZEROS
     C                   EVAL      NWEACCY = CCY
     C                   EVAL      NWEAXRAT = A6SPRT
     C                   EVAL      NWEAMDIN = A6MDIN
     C                   EVAL      NWEASTDT = EISTDT
     C                   EVAL      NWEAENDT = EIENDT
     C                   EVAL      NWEASDAM = EISTDT
     C                   EVAL      NWEAEDAM = EIENDT
     C*                  MOVE      WAmortAmnt    NWEAAMNT
     C                   MOVE      TOTI          NWEAOAMT
     C                   ENDIF
 
      ** Fee
     C                   IF        WMode = 'F'
     C                   EVAL      PCurrency = FEFCCY
     C                   EXSR      SrCurr
 
      ** Convert Fee Currency when it is not the Loan Currency
     C                   IF        CCY <> FEFCCY
     C                   EVAL      PFrCurrency = FEFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = FEFAMT
     C                   EXSR      SrConvert
     C                   ELSE
 
      ** If this is not a new record, use Existing exchange Rates
     C                   IF        WExchangeRte = 0
     C                   EVAL      POutXRat = A6SPRT
     C                   EVAL      POutMDIn = A6MDIN
     C                   EVAL      POutAmount = FEFAMT
     C                   ELSE
     C                   EVAL      POutXRat = WExchangeRte
     C                   EVAL      POutMDIn = WMultDivInd
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNewEIRA - Create New EIRA Records                           *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrNewEIRA     BEGSR
 
      ** Discount
     C                   CLEAR                   NewEIRAFmt
     C                   IF        TOTI <> 0
     C                             AND WMode <> 'F'
     C                   EVAL      PCurrency = CCY
     C                   EXSR      SrCurr
     C                   EVAL      NWEARECI = 'D'
     C                   EVAL      NWEATYPE = 'D'
     C                   EVAL      NWEATRAN = LNRF
     C                   EVAL      NWEAFCOD = *ZEROS
     C                   EVAL      NWEAFSEQ = *ZEROS
     C                   EVAL      NWEACCY = CCY
     C                   EVAL      NWEAXRAT = A6SPRT
     C                   EVAL      NWEAMDIN = A6MDIN
     C                   EVAL      NWEASTDT = NWEISTDT
     C                   EVAL      NWEAENDT = NWEIENDT
     C                   EVAL      NWEASDAM = VDAT
     C                   EVAL      NWEAEDAM = MDAT
     C                   EVAL      NWEAAMNT = TOTI
     C                   EVAL      NWEAOAMT = TOTI
 
      ** Provide Defaulting for LE004611/LE004651
     C**********         IF        NWEASTDT = NWEASDAM                                        257769
     C                   EVAL      NWEAAAMT = TOTI
     C**********         ELSE                                                                 257769
     C**********         EVAL      NWEAAAMT = *ZEROS                                          257769
     C**********         ENDIF                                                                257769
 
     C                   ENDIF
 
      ** Fee
     C                   IF        WMode = 'F'
     C                             AND FERECI <> '*'
     C                   EVAL      PCurrency = FEFCCY
     C                   EXSR      SrCurr
 
      ** Convert Fee Currency when it is not the Loan Currency
     C                   IF        CCY <> FEFCCY
     C                   EVAL      PFrCurrency = FEFCCY
     C                   EVAL      PToCurrency = CCY
     C                   EVAL      PAmount = FEFAMT
     C                   EXSR      SrConvert
     C                   ELSE
 
      ** If this is not a new record, use Existing exchange Rates
     C*                  IF        WExchangeRt  = 0
     C                   EVAL      POutXRat = A6SPRT
     C                   EVAL      POutMDIn = A6MDIN
     C                   EVAL      POutAmount = FEFAMT
     C*                  ELSE
     C*                  EVAL      POutXRat = WExchangeRte
     C*                  EVAL      POutMDIn = WMultDivInd
     C*                  ENDIF
     C                   ENDIF
 
     C                   EVAL      NWEARECI = 'D'
     C                   EVAL      NWEATRAN = FELOAN
     C                   EVAL      NWEAFCOD = FEFCOD
     C                   EVAL      NWEAFSEQ = FEFSEQ
     C                   EVAL      NWEACCY = FEFCCY
     C                   EVAL      NWEAXRAT = POutXRat
     C                   EVAL      NWEAMDIN = POutMDIn
     C                   EVAL      NWEASTDT = NWEISTDT
     C                   EVAL      NWEAENDT = NWEIENDT
     C**********         EVAL      NWEASDAM = FEPSTD                                        BUG17970
     C                   EVAL      NWEASDAM = FESTPD                                        BUG17970
     C                   EVAL      NWEAEDAM = FEENPD
     C                   MOVE      POutAmount    NWEAAMNT
     C                   EVAL      NWEAOAMT = FEFAMT
     C                   EVAL      NWEAAAMP = *ZERO
 
      ** Provide Defaulting for LE004611/LE004651
     C**********         IF        NWEASTDT = NWEASDAM                                        257769
     C                   EVAL      NWEAAAMT = FEFAMT
     C**********         ELSE                                                                 257769
     C**********         EVAL      NWEAAAMT = *ZERO                                           257769
     C**********         ENDIF                                                                257769
 
     C                   ENDIF
                                                                                              257858
     C                   EVAL      NWEIRCAL = 'Y'                                             257858
 
     C                   WRITE     LENERAD0
 
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
     C*                            AND WExchangeRte = 0
 
      ** If target currency is not the base currency, do cross
      ** currency conevrt
 
     C                   EVAL      PCurrency = PToCurrency
     C                   EXSR      SrCurr
 
     C                   EVAL      PToXRate = A6SPRT
     C                   EVAL      PToMDIn = A6MDIN
     C                   EVAL      PToDecPlace = A6NBDP
 
     C                   CALLB     'ZCCYCN'
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
 
      ** If Temporary exchange rate is not Zero, use it instead
     C*                  IF        WExchangeRte <> 0
     C*                  EVAL      PFrXRate = WExchangeRte
     C*                  EVAL      PFrMDIn = WMultDivInd
     C*                  ENDIF
 
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
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey = *BLANKS
     C                   EVAL      DbPGM = 'LE004601'
     C                   EVAL      Dbase = *ZERO
     C                   OUT       LDA
 
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
     C                   EVAL      WEvCD = BKAPDT
     C                   ELSE
     C                   EVAL      WEvCD = BJDNWD - 1
     C                   ENDIF
 
     C     KLoanType     KLIST
     C                   KFLD                    AYLNTY
     C                   KFLD                    AYLNST
 
     C     KLoanDate     KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    WDate
 
     C     KLoanFSeq     KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    FEFSEQ
 
     C     KLoanFSeq3    KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    WFSEQ
 
     C     KLnFSeqDte    KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    FEFSEQ
     C                   KFLD                    FESTPD
 
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
