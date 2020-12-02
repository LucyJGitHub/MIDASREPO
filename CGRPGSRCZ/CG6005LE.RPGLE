     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Lending commencement confirmations')          *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6005LE - Lending Commencement Confirmations (ILE)          *
     F*                                                               *
     F*  Function:  This program extracts data for Commencement       *
     F*  ( I/C )    Confirmations.                                    *
     F*  (I/C Term)                                                   *
     F*                                                               *
     F*  Called By: CG6000 - Lending Commencement Confirmations Driver*
     F*                                                               *
     F*  Calls :    CG3999 - Pack/Unpack Extracted Data               *
     F*             CG6001 - General Loan Details                     *
     F*             CG9010 - Create Item Reference Records            *
     F*             CG9020 - Write Data to UDC Extract Files          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CLE172             Date 23Oct20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD047993           Date 23Sep17               *
      *                 MD035545           Date 11Sep15               *
      *                 CLE141             Date 08Feb16               *
      *                 MD029242           Date 25Nov14               *
      *                 AR996895           Date 25Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR322732           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR822053           Date 29Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 263666             Date 01Feb10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23004           Date 21Feb09               *
      *                 CER016A            Date 19May08               *
      *                 CER038             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 246141             Date 26Mar07               *
      *                 245914             Date 22Feb07               *
      *                 245082             Date 29Jan07               *
      *                 164847             Date 30Nov06               *
      *                 BUG12990           Date 05Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 25Sep06               *
      *                 130998             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CIR013             Date 25Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE031             Date 05Feb03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      *                 177914             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR004             Date 20Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU014             Date 04Jun98               *
      *                 126017             Date 14Nov97               *
     F*                 121768             DATE 19FEB98               *
     F*                 CLE005             DATE 22May97               *
     F*                 S01408             Date 10JUL96               *
     F*                 CCG008 *CREATE     Date 30OCT95               *
     F*                                                               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*  AMENDMENT HISTORY                                            *
     F*                                                               *
      *  CLE172 - Libor Deregulation - Lending                        *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047993 - Modified MD035545. Removed dependency on Accrue   *
      *             on Last Day indicator.                            *
      *  MD035545 - LE: Interest Calculation in Leap year. Consider   *
      *             Accrue on Last Day Indicator for method 6.        *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  MD029242 - System should generate Dealing CM correspondences *
      *             also for the Customers with SWIFT-Id (suppressed  *
      *             by CER038)                                        *
      *           - Created new system value to condition the         *
      *             suppression of correspondence if customer has     *
      *             Swift ID                                          *
      *  AR996895 - Incorrect accrual interest calculation            *
      *             (Child: AR996897) (Recompile)                     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
      *           - Prevent LTRIX RRN 1 from being locked (Recompile) *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR822053 - Incorrect value of Effective Annual Interest Rate *
      *             in CGUXMLPD                                       *
      *  CER049 - Stamp Tax (Portuguese Features Upgrade)             *
      *  CRE073 - Portuguese Feature - Interest Rate Rounding         *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  263666 - Recompiled due to changes in ZINTDYZ2               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23004 - The counterparty is a SWIFT participant and still *
      *            a paper confirmation has been produced             *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  CER038 - Additional fields added to Correspondence           *
      *  246141 - Recompiled due to changes in ZINTDYZ2               *
      *  245914 - Review interest calculation.                        *
      *  245082 - Loans with first and last day accrual should be     *
      *           treated as first day accruals until maturity        *
      *           date.  Then add one day on the maturity date.       *
      *           Applied fix 235784 from Release 4.                  *
      *  164847 - Recompile over changes in /COPY ZINTDYZ2.           *
      *  BUG12990 - Recompiled due to changes in ZINTDYZ2/ZINTDYZ2LE  *
      *  242286 - Recompile over changes in /COPY ZINTDYZ2.           *
      *  130998 - If not using extended settlements use old fields.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompile)                   *
      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2 - Specific Base Rate*
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *           Recompile over GLINTC and ZINTDY.                   *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE031 - Lending Enhancements.                               *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *  177914 - Confirmation reflected 0 interest. Calculate        *
      *           interest whatever the repayment type is.            *
      *  CSD006 - Use DSSDY for call to AOBSTRR0.                     *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
      *  CIR004 - Dealing Calculation Method Change.                  *
      *         - Recompiled due to GLINTC and ZINTDY changes         *
     F*  CEU014 - EMU User Defined Correspondence Changes.            *
     F*  126017 - Correction to interest calculation for calculation  *
     F*           basis 6 in SR/GLINTC. Add SR/ZDAT10                 *
     F*  121768 - Recompile over changed GLINTCZ1                     *
     F*  CLE005 - Customer Lending Enhancements - Others (T3)         *
     F*  S01408 - Core hook CG6005CCP1 added.                         *
     F*           Core hook CG6005CCP2 added.                         *
     F*  CCG008 - User Defined Correspondence - Lending               *
     F*                                                               *
     F*****************************************************************
     F*
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     INFSR(SRFILE)
     FLOAMS     IF   E           K DISK                                         S01518
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
     F                                     INFSR(SRFILE)
      *                                                                                       CER049
      ** Stamp Tax file                                                                       CER049
      *                                                                                       CER049
     FCLONCLL1  IF   E           K DISK
      *                                                                                       CER050
     FLEAPRHI0  IF   E           K DISK
      *                                                                                       CER050
     F*
     F/COPY WNCPYSRC,CG6005F001
      /TITLE FUNCTION OF INDICATORS
     F*****************************************************************
     F*                                                               *
     F*  F U N  C T I O N    O F    I N D I C A T O R S               *
     F*                                                               *
     F*  90         Poffered for READE LOOPS                          *
     F*  99         General error indicator                           *
     F*                                                               *
     F*****************************************************************
      /TITLE SUBROUTINE INDEX
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E    I N D E X                             *
     F*                                                               *
     F*  Main routine                                                 *
     F*  SRMAIN  -  Main Processing                                   *
     F*  SRDETL  -  Obtain Detail Information                         *
     F*  L01CC   -  Lending Commencement Confirmations                *
     F*  LOANA   -  Loan Associated Details                           *
     F*  LOAN    -  Process Loan Details                              *
     F*  L@ROL   -  Process Rollover Details                          *
     F*  L@REP   -  Process Repayment Details                         *
     F*  L@IPY   -  Process Interest Payment Details                  *
     F*  L@GUAR  -  Process Guarantee Details                         *
     F*  SRSDET  -  Set-up Settlement Details                         *
     F*  SRINZF  -  Initialise Fields on Each Invocation              *
     F*  SRINIT  -  Initial Processing - On First Call                *
     F*  SRADTA  -  Accumulate RDEs and Associated Data               *
     F*  SRODTA  -  Output Accumulated Data to CGUDTAPD               *
     F*  SRBIND  -  Generate Binding Numbers                          *
     F*  SRPATH  -  Generate Path String                              *
     F*  SRRFMN  -  Reformat RDE Data                                 *
     F*  SRDCDT  -  Determine Currency Details                        *
     F*  SRGENR  -  Generate Reference Number                         *
     F*  SRICAL  -  Calculate Interest                                *
     F*  ZFLAC   -  Calculate End Date                                *
     F*  GLINTC  -  Calculate Interest Between any 2 day numbers      *
     F*  AOBANKR0 - Retrive Bank Details                              *
     F*  AOBRCHRO - Retrive Branch Details                            *
     F*  AOBSRTRO - Retrive Base Rate Code Details                    *
     F*  AOCURRRO - Retrive Currency Details                          *
     F*  AOCUSTR0 - Retrieve Customer Details                         *
     F*                                                               *
     F*****************************************************************
     D/EJECT
     D*
     D**  Copyright array.
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
     D/COPY ZSRSRC,ZINTDYZ1LE
     D/COPY ZSRSRC,ZDATE9Z2LE
     D/COPY ZSRSRC,ZDAT10Z1LE
     D*
     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
     D*
     D/COPY ZSRSRC,ZDATE9Z1LE
     D*
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D*
     D CPYR            DS
     D**  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D*
     D ##SDS           DS
      *
     D #@SDS           DS
     D**  Packed data string.
     D  #@S                 5632   5632
     D*
     D                 DS
     D**  Number Field
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
     D                 DS
     D** Used to convert item reference from character to numeric
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
     D*
     D                 DS
     D  ##NCIT                 1      6
     D  NMCY                   1      3
     D  SITP                   4      6
     D                 DS
     D  ##CCCC                 1      5
     D  ##CCY                  1      3
     D  ##CCD                  4      5
     D*
     D**  Loan details parameter for call to CG99LSET.
     D*
     D PDETLS          DS           256
     D* Currency
     D  ##CCY1                 1      3
     D* Customer Number
     D  ##CNUM                 4      9
     D* Branch
     D  ##BRCA                10     12
     D*
     D**  Settlement Instructions Parameter for call to CG99LSET.
     D*
     D P0PARM          DS           768
     D**  Pay - Branch
     D  P0POBR                 1      3
     D**  Receipt - Branch
     D  P0ROBR                 4      6
     D**  Receipt - Settlement Method
     D  P0RSTM                 7      8  0
     D**  Receipt - Our Nostro
     D  QQRONS                 9     20
     D**  Receipt - Intermediary Bank
     D  P0RIBN                21     28
     D**  Receipt - Intermediary Bank a/c
     D  P0RIBA                29     63
     D**  Receipt - Ordering Bank No.
     D  P0ROBN                64     69
     D**  Receipt - Ordering Customer
     D  P0ROCN                70     75
     D**  Pay - Settlement Method
     D  P0PSTM                76     77  0
     D**  Pay - Our Nostro
     D  QQPONS                78     89
     D**  Pay - Intermediary Bank
     D  P0PIBN                90     97
     D**  Pay - Intermediary Bank a/c
     D  P0PIBA                98    132
     D**  Pay - Ordering Bank No.
     D  P0POBN               133    138
     D**  Pay - Ordering Customer No.
     D  P0POCN               139    144
     D**  Receiver Correspondent No.
     D  P0RCRN               145    152
     D**  Receiver Correspondent A/C 1
     D  P0RCRA               153    187
     D**  Receiver Number
     D  P0RVNO               188    195
     D**  A/C with Bank No.
     D  P0AWBN               196    203
     D**  A/C with Bank A/C Line
     D  P0AWBA               204    238
     D**  Beneficiary No.
     D  P0BENN               239    246
     D**  Beneficiary A/C Line
     D  P0BENA               247    281
     D**  Details of Pay 1
     D  P0DTP1               282    316
     D**  Details of Pay 2
     D  P0DTP2               317    351
     D**  Details of Pay 3
     D  P0DTP3               352    386
     D**  Details of Pay 4
     D  P0DTP4               387    421
     D**  Details of Charges
     D  P0DCHG               422    424
     D**  Bank to Bank Info 1
     D  P0BTB1               425    459
     D**  Bank to Bank Info 2
     D  P0BTB2               460    494
     D**  Bank to Bank Info 3
     D  P0BTB3               495    529
     D**  Bank to Bank Info 4
     D  P0BTB4               530    564
     D**  Bank to Bank Info 5
     D  P0BTB5               565    599
     D**  Bank to Bank Info 6
     D  P0BTB6               600    634
     D**  Special Instruction 1
     D  P0SPI1               635    664
     D**  Special Instruction 2
     D  P0SPI2               665    694
     D**  Special Instruction 3
     D  P0SPI3               695    724
     D**  Settlement Currency                                             CEU014
     D  P0STCY               725    727                                         CEU014
     D  P0PSCY               728    730
     D  P0RONS               731    748
     D  P0PONS               749    766
     D*
     D**  UDC Details
     D*
     D P1PARM          DS           256
     D**  Output Sequence
     D  P1OSEQ                 1      9  0
     D**  UDC item number
     D  P1ITEM                10     17  0
     D**  This bind level
     D  P1TBIN                18     25  0
     D**  Previous bind level
     D  P1PBIN                26     33  0
     D*
     D**  Loan details Parameters for call to CG6001.
     D*
     D P@PARM          DS           256
     D**  Loan Reference
     D  P@LNRF                 1      6
     D**  Cancel/Amend Field
     D  P@CNAM                 7      7
     D*
     D**  Facility details Parameter for call to CG6001
     D*
     D P4PARM          DS           256
     D**  Facility customer
     D  P4FCUS                 1      6
     D**  Facility type
     D  P4FTYP                 7      9  0
     D**  Facility Seq
     D  P4FSEQ                10     11  0
     D*
     D**  For error reporting
     D*
     D**  Named constants
     D*
     D W#PTYP          C                   CONST('LOAN COMMC')
     D W#PST1          C                   CONST('CALL LOAN ')
     D W#PST2          C                   CONST('TERM LOAN ')
     D W#PST3          C                   CONST('DISC LOAN ')
     D W#PST4          C                   CONST('TERM PA PU')
     D W#PST5          C                   CONST('DISC PA PU')
     D W#PST6          C                   CONST('TERM PA SL')
     D W#PST7          C                   CONST('DISC PA SL')
     D W#PST8          C                   CONST('GUAR ISSUE')
     D W#PST9          C                   CONST('CALL PA PU')
     D W#PS10          C                   CONST('CALL PA SL')
     D W#PS11          C                   CONST('RISK PA PU')
     D W#PS12          C                   CONST('RISK P SL1')
     D W#PS13          C                   CONST('RISK P SL2')
     D W#PS14          C                   CONST('FLAT LOAN ')
     D #SUPRS          C                   CONST('SupCorr4CustwSwiftID')
     D*
     D DSPARM        E DS                  EXTNAME(LTRIX)
     D** External DS for parameter passed from CG6000
     D  ##RCD1       E                     EXTFLD(RCDT)
     D  ##CHT1       E                     EXTFLD(CHTP)
     D*
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
     D**  External DS for incomplete reference
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  External DS for Bank details
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D**  External DS for branch details
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D**  External DS for customer details
     D  QQDFA1       E                     EXTFLD(QQDFAC)
     D*
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D**  External DS for base rate details
     D*
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
     D**  External DS for currency details
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D** Switchable Feature details
     D*
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D* DS for GL ICD Details
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  First DS for access programs, short data structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Second DS for access programs, long data structure
     D*
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
     D**  Record format of PF/CGUDTAPD for use as a parameter
     D*
     D**  DS to store subroutine specific data.
     D**  - Saved Path
     D*
     D ##PATH          DS                  OCCURS(20)
     D  ##GRPS                 1      6
     D*
     D ##BIND          DS                  OCCURS(20)
     D  ##PBIN                 1      6  0 INZ(1)
     D  ##TBIN                 7     12  0 INZ(1)
     D*
     D                 DS
     D  #@BIND                 1      6  0 INZ(1)
     D*
     D #PDS            DS
     D  P1                     1      3  0 INZ(0)
     D  P2                     4      6  0
     D  P3                     7      9  0
     D  P4                    10     12  0
     D  P5                    13     15  0
     D*
     D SVAL1           DS           200
     D  SVAL11                 1      1
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQDFA2       E                     EXTFLD(QQACCD)
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *
     D WPARML          C                   CONST('LECalcBasis6LeapYear')
     I/EJECT
     I*
     ICLOANCLF
     I** Rename fields of CLOANCL
     I              RECI                        ##RECI
     I              LNRF                        ##LNRF
     I              RCDT                        ##RCDT
     I              MRIN                        ##MRIN
     I              PTYP                        ##PTYP
     I              CNUM                        ##CNUM
     I              BRCA                        ##BRCA
     I              LTYP                        ##LTYP
     I              SUTP                        ##SUTP
     I              DDAT                        ##DDAT
     I              VDAT                        ##VDAT
     I              MDAT                        ##MDAT
     I              LASQ                        ##LASQ
     I              FCUS                        ##FCUS
     I              FTYP                        ##FTYP
     I              FSEQ                        ##FSEQ
     I              CCY                         ##CCY1
     I              CPAM                        ##CPAM
     I              INTC                        ##INTC
     I              INTR                        ##INTR
     I              BRTT                        ##BRTT
     I              BRTE                        ##BRTE
     I              RTSP                        ##RTSP
     I              MARG                        ##MARG
     I              SPIN                        ##SPIN
     I              CHIN                        ##CHIN
     I              WTRT                        ##WTRT
     I              WTIN                        ##WTIN
     I              REPT                        ##REPT
     I              RAMT                        ##RAMT
     I              NRPD                        ##NRPD
     I              RFRQ                        ##RFRQ
     I              RDYN                        ##RDYN
     I              FCCY                        ##FCCY
     I              LIND                        ##LIND
     I              CRSK                        ##CRSK
     I              ACOF                        ##ACOF
     I              NACD                        ##NACD
     I              RELI                        ##RELI
     I              AUTO                        ##AUT1
     I              PSAM                        ##PSAM
     I              BCXR                        ##BCXR
     I              FCXR                        ##FCXR
     I              SDST                        ##SDST
     I              OSDA                        ##OSDA
     I              TSTN                        ##TSTN
     I              MDST                        ##MDST
     I              OMDA                        ##OMDA
     I              TMAN                        ##TMAN
     I              FACO                        ##FACO
     I              RLDT                        ##RLDT
     I              NROD                        ##NROD
     I              RLFQ                        ##RLFQ
     I              RLDY                        ##RLDY
     I              RDFC                        ##RDFC
     I              NBRA                        ##NBRA
     I              NRTS                        ##NRTS
     I              NSIN                        ##NSIN
     I              NCAS                        ##NCAS
     I              AWTP                        ##AWTP
     I              WTRD                        ##WTRD
     I              WTWD                        ##WTWD
     I              IWOD                        ##IWOD
     I              PWOD                        ##PWOD
     I              BMDI                        ##BMDI
     I              FMDI                        ##FMDI
     I              PDIN                        ##PDIN
     I              LSWC                        ##LSWC
     I              LSWS                        ##LSWS
     I              OSDB                        ##OSDB
     I              OMDB                        ##OMDB
     I              ORBR                        ##ORBR
     I              PRFC                        ##PRFC
     I              FCLB                        ##FCLB
     I              MLNR                        ##MLNR
     I              BTIN                        ##BTIN
     I              BLDY                        ##BLDY
     I              OLNO                        ##OLNO
     I              RCSI                        ##RCSI
     I              ICBS                        ##ICBS
     I              IPFR                        ##IPFR
     I              TOTI                        ##TOTI
     I              NIDT                        ##NIDT
     I              IBDT                        ##IBDT
     I              SLID                        ##SLID
     I              AIPD                        ##AIPD
     I              DLRC                        ##DLRC
     I              IACD                        ##IACD
     I              AITC                        ##AITC
     I              TFEP                        ##TFEP
     I              AIAP                        ##AIAP
     I              IPRD                        ##IPRD
     I              IPRM                        ##IPRM
     I              ICTD                        ##ICTD
     I              AIMN                        ##AIMN
     I              RBDT                        ##RBDT
     I              NOPS                        ##NOPS
     I              NCHI                        ##NCHI
     I              IFDY                        ##IFDY
     I              LONI                        ##LONI
     I              CNFI                        ##CNFI
     I              ACEI                        ##ACEI
     I              TLXI                        ##TLXI
     I              CBLI                        ##CBLI
     I              ORED                        ##ORED
     I              LCD                         ##LCD
     I              CHTP                        ##CHTP
     I              TNLU                        ##TNLU
     I              ADDI                        ##ADDI
     I              ORMD                        ##ORMD
     I              ORTI                        ##ORTI
     I              BOKC                        ##BOKC
     I              COCU                        ##COCU
     I              RECE                        ##RECE
     I              OMDT                        ##OMDT
     I              NIPD                        ##NIPD
     I              NMDT                        ##NMDT
     I              APMI                        ##APMI
     I              RSTM                        ##RSTM
     I              RONS                        ##RONS
     I              RIBN                        ##RIBN
     I              RIBA                        ##RIBA
     I              ROBN                        ##ROBN
     I              ROCN                        ##ROCN
     I              PSTM                        ##PSTM
     I              PONS                        ##PONS
     I              PIBN                        ##PIBN
     I              PIBA                        ##PIBA
     I              POBN                        ##POBN
     I              POCN                        ##POCN
     I              RCRN                        ##RCRN
     I              RCRA                        ##RCRA
     I              RVNO                        ##RVNO
     I              AWBN                        ##AWBN
     I              AWBA                        ##AWBA
     I              BENN                        ##BENN
     I              BENA                        ##BENA
     I              DTP1                        ##DTP1
     I              DTP2                        ##DTP2
     I              DTP3                        ##DTP3
     I              DTP4                        ##DTP4
     I              DCHG                        ##DCHG
     I              BTB1                        ##BTB1
     I              BTB2                        ##BTB2
     I              BTB3                        ##BTB3
     I              BTB4                        ##BTB4
     I              BTB5                        ##BTB5
     I              BTB6                        ##BTB6
     I              CVMR                        ##CVMR
     I              PTFR                        ##PTFR
     I              SCCY                        ##STCY                          CEU014
     I              ADIF                        ##ADIF
     I              ADCF                        ##ADCF
     I              CHGA                        ##CHGA
     I              ICIF                        ##ICIF
     I              FLTI                        ##FLTI
     I              FRPD                        ##FRPD
     I              REXR                        ##REXR
     I              REXI                        ##REXI
     I              PSCY                        ##PSCY
     I              PEXR                        ##PEXR
     I              PEXI                        ##PEXI
     I              BASR                        ##BASR
     I              NBSR                        ##NBSR
     I              OCDT                        ##OCDT
     I              EAIR                        ##EAIR
     I              CNSP                        ##CNSP
     I              CNSG                        ##CNSG
     I              RDMT                        ##RDMT
     I              RDFD                        ##RDFD
     I*
     ICLOANCKF
     I** Rename fields of CLOANCK
     I              RECI                        ##RECI
     I              LNRF                        ##LNRF
     I              RCDT                        ##RCDT
     I              MRIN                        ##MRIN
     I              NAR1                        ##NAR1
     I              NAR2                        ##NAR2
     I              NAR3                        ##NAR3
     I              NAR4                        ##NAR4
     I              OPAM                        ##OPAM
     I              FRBC                        ##FRBC
     I              YPLN                        ##YPLN
     I              YFLN                        ##YFLN
     I              YWLN                        ##YWLN
     I              ABLN                        ##ABLN
     I              YPLC                        ##YPLC
     I              YFLC                        ##YFLC
     I              YWLC                        ##YWLC
     I              ABLC                        ##ABLC
     I              WWLN                        ##WWLN
     I              IWLN                        ##IWLN
     I              PWLN                        ##PWLN
     I              RDST                        ##RDST
     I              SPI1                        ##SPI1
     I              SPI2                        ##SPI2
     I              SPI3                        ##SPI3
     I              YILN                        ##YILN
     I              F57U                        ##F57U
     I              ORVD                        ##ORVD
     I              THRN                        ##THRN
     I              NPRAM                       ##NPAM
     I              NDAM                        ##NDAM
     I              RLBR                        ##RLBR
     I              ORED                        ##ORED
     I              LCD                         ##LCD
     I              CHTP                        ##CHTP
     I              TNLU                        ##TNLU
     I*
     ILOAMSDKF
     I** Rename fields of LOAMSDK
     I              VDAT                        ##VDA1
     I              AMTP                        ##AMT1
     I/COPY WNCPYSRC,CG6005I001
     I*
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Process     :  MAINLINE                                      *
     C*  Function    :  Mainline Processing                           *
     C*                                                               *
     C*  Called by   :  None                                          *
     C*  Calls       :  SRINIT - Initial Processing - On First Call   *
     C*                 SRINZF - Initialise Fields on Each Invocation *
     C*                 SRMAIN - Main Processing                      *
     C*                                                               *
     C*****************************************************************
     C*
     C**  Parameter list for current program invocation.
     C*
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD            1
     C                   PARM                    ##AUTO            1
     C                   PARM                    ##SPPS            1
     C                   PARM                    DSPARM
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
     C*
     C**  Initial processing - Once Only.
     C*
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
     C*
     C**  Initialisation processing.
     C*
     C                   EXSR      SRINZF
     C*
     C**  Main processing.
     C*
     C                   EXSR      SRMAIN
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C**  Terminate program.
     C*
     C                   RETURN
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRMAIN                                        *
     C*  Function    :  Main Processing                               *
     C*                                                               *
     C*  Called by   :  MAINLINE - Mainline Processing                *
     C*  Calls       :  SRDETL - Obtain Detail Information            *
     C*                 SRGENR - Generate Reference Number            *
     C*                 L01CC  - Lending Commencement Confirmations   *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRMAIN        BEGSR                                                  ** SRMAIN **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
     C*
     C**  Obtain Detail Information.
     C*
     C                   EXSR      SRDETL
     C*
     C**  Generate reference number by writing to PF/CGUDCRPD.
     C**  If no confirmation to be produced, then bypass.
     C*
     C                   MOVE      'N'           ##COPD
     C/COPY WNCPYSRC,CG6005C020
      *                                                                                       CER038
     C                   MOVE      'N'           ##SPPS
     C     CER038        IFEQ      'Y'
     C                   EXSR      SRAUTO
     C     ##SPPS        IFEQ      'Y'
     C     ##SPPS        CABEQ     'Y'           EXMAIN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER038
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C**  Extract.
     C*
     C                   EXSR      L01CC
     C*
     C     EXMAIN        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRMAI9        ENDSR                                                  ** SRMAI9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRDETL                                        *
     C*  Function    :  Obtain Detail Information                     *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  None                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRDETL        BEGSR                                                  ** SRDETL **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'DETAIL'      @STK(Q)
     C*
     C     KCLOAN        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RCDT
     C*
     C                   MOVEL     'A'           RCDT              1
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 01 *
     C                   Z-ADD     1             W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C                   MOVEL     'B'           RCDT
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 02 *
     C                   Z-ADD     2             W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                   CLE005
      ** If CLE005 is on, for proc. type 72, access CLOANCL to            CLE005
      ** get the processing type of the loan sold, then rechain           CLE005
      ** back to using the original loan                                  CLE005
      *                                                                   CLE005
     C     ##PTYP        IFEQ      72                                                          CLE00
     C     CLE005        ANDEQ     'Y'                                                         CLE00
     C                   MOVE      *BLANK        WOLN70            1                           CLE00
     C**********           Z-ADDLNRF      WOLNRF  60                                   CLE005 CLE148
     C                   MOVEL     LNRF          WOLNRF            6
     C**********           Z-ADD##OLNO    LNRF                                         CLE005 CSD027
     C                   MOVE      ##OLNO        LNRF
     C                   MOVEL     'A'           RCDT              1                           CLE00
      *                                                                   CLE005
     C     KCLOAN        CHAIN     CLOAN                              88                       CLE00
     C     *IN88         IFEQ      '1'                                                         CLE00
     C                   MOVEL     'CLOAN   '    W0FILE                         ************   CLE00
     C                   MOVEL     LNRF          W0KEY                          * DBERR 13 *   CLE00
     C                   Z-ADD     13            W0ERNB                         ************   CLE00
     C                   MOVEL     'MEM5004'     W0MSGD                                        CLE00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CLE00
     C                   EXSR      SRERR                                                       CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE005
     C     ##PTYP        IFEQ      70                                                          CLE00
     C                   MOVE      'Y'           WOLN70                                        CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE005
      ** Rechain CLOANCL to get original loan details                     CLE005
      *                                                                   CLE005
     C**********           Z-ADDWOLNRF    LNRF                                         CLE005 CLE148
     C                   MOVEL     WOLNRF        LNRF
     C                   MOVEL     'A'           RCDT              1                           CLE00
      *                                                                   CLE005
     C     KCLOAN        CHAIN     CLOAN                              88                       CLE00
     C     *IN88         IFEQ      '1'                                                         CLE00
     C                   MOVEL     'CLOAN   '    W0FILE                         ************   CLE00
     C                   MOVEL     LNRF          W0KEY                          * DBERR 14 *   CLE00
     C                   Z-ADD     14            W0ERNB                         ************   CLE00
     C                   MOVEL     'MEM5004'     W0MSGD                                        CLE00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CLE00
     C                   EXSR      SRERR                                                       CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE005
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE005
     C/COPY WNCPYSRC,CG6005C001
     C*
     C** If an equal loan reference has been read, check if amendment
     C** type is 'RE'.   If it is, store the repayment value date to be
     C** used later in the calculation.
     C*
     C                   MOVE      *BLANKS       ##AMT1
     C     LNRF          CHAIN     LOAMS                              87
     C*
     C     *IN87         DOWEQ     '0'
     C********** ##AMT1    ANDNE'RE'                                                          245914
     C     ##AMT1        IFEQ      'RE'
     C                   Z-ADD     ##VDA1        ##RPDT            5 0
     C**********           ELSE                                                               245914
     C                   END
     C     LNRF          READE     LOAMS                                  87
     C**********           END                                                                245914
     C                   END
     C*
     C/COPY WNCPYSRC,CG6005C005
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRDET9        ENDSR                                                  ** SRDET9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRGENR                                        *
     C*  Function    :  Generate reference number by writing to       *
     C*                 PF/CGUDCRPD                                   *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  CG9010 - Create Item Reference Records        *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRGENR        BEGSR                                                  ** SRGENR **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
     C*
     C**  Generate reference number and check if further processing
     C**  required. Set up all available information in the record
     C**  format before calling.
     C*
     C                   CLEAR                   ##UDCR
     C*
     C**  Booking/Main Branch (Mandatory).
     C*
     C                   MOVEL     ##BRCA        DRBRCA
     C*
     C**  Originating Branch (Optional).
     C*
     C                   MOVEL     ##ORBR        DRORBR
     C*
     C**  Module identifier (Mandatory).
     C*
     C                   MOVEL     'LE'          DRMODI
     C*
     C**  Midas Transaction Number (Mandatory).
     C*
     C                   MOVEL     LNRF          DRMTRN
     C*
     C**  Midas GL Account Reference CNUMCCYACODACSQBRCA  (Optional).
     C*
     C                   MOVEL     *BLANKS       DRMACT
     C*
     C**  Print Type.
     C*
     C                   MOVEL     W#PTYP        DRPTYP
     C*
     C**  Print Sub-type.
     C*
     C                   SELECT
     C     ##PTYP        WHENEQ    61
     C                   MOVEL     W#PST1        DRPSTP
     C     ##PTYP        WHENEQ    62
     C                   MOVEL     W#PST2        DRPSTP
     C     ##PTYP        WHENEQ    63
     C                   MOVEL     W#PST3        DRPSTP
     C     ##PTYP        WHENEQ    64
     C                   MOVEL     W#PST4        DRPSTP
     C     ##PTYP        WHENEQ    65
     C                   MOVEL     W#PST5        DRPSTP
     C     ##PTYP        WHENEQ    66
     C                   MOVEL     W#PST6        DRPSTP
     C     ##PTYP        WHENEQ    67
     C                   MOVEL     W#PST7        DRPSTP
     C     ##PTYP        WHENEQ    70
     C                   MOVEL     W#PST8        DRPSTP
     C                   ENDSL
      *                                                                   CLE005
     C     CLE005        IFEQ      'Y'                                                         CLE00
     C     ##PTYP        IFEQ      68                                                          CLE00
     C                   MOVEL     W#PST9        DRPSTP                                        CLE00
     C                   ENDIF                                                                 CLE00
     C     ##PTYP        IFEQ      69                                                          CLE00
     C                   MOVEL     W#PS10        DRPSTP                                        CLE00
     C                   ENDIF                                                                 CLE00
     C     ##PTYP        IFEQ      71                                                          CLE00
     C                   MOVEL     W#PS11        DRPSTP                                        CLE00
     C                   ENDIF                                                                 CLE00
     C     ##PTYP        IFEQ      72                                                          CLE00
     C     WOLN70        IFEQ      'Y'                                                         CLE00
     C                   MOVEL     W#PS13        DRPSTP                                        CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVEL     W#PS12        DRPSTP                                        CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
      *                                                                   CLE005
      ** If Flat Rate Personal Loans (Rule of 78s) CLE028 is                                  CLE028
      ** installed, set print item subtype field to 'FLAT LOAN' if                            CLE028
      ** processing a Flat Rate Personal Loan.                                                CLE028
      *                                                                                       CLE028
     C     ##PTYP        IFEQ      80
     C     CLE028        ANDEQ     'Y'
     C                   MOVEL     W#PS14        DRPSTP
     C                   ENDIF
      *                                                                                       CLE028
     C/COPY WNCPYSRC,CG6005C012
     C*
     C**  Auto Transmission indicator.
     C*
     C                   MOVEL     'N'           DRATRM
     C*
     C**  Cheque Reference (Optional).
     C*
     C                   MOVEL     *BLANKS       DRCHQR
     C*
     C**  Further Reference (Optional).
     C*
     C                   MOVEL     *BLANKS       DRFREF
     C*
     C**  Customer Number (Mandatory).
     C*
     C                   MOVEL     ##CNUM        ##CUST
     C*
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD            7
     C                   PARM      '*GEN'        ##MODE           10
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM                    ##CUST            6
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA            8
     C*
     C**  Blank return code implies generate correspondence.
     C**  CGD1270 => no error, but suppress output for this transaction.
     C*
     C     ##RTCD        IFEQ      *BLANK
      *                                                                                       CCG015
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C*
     C                   MOVE      'Y'           ##COPD
     C*
     C                   ELSE
     C*
     C     ##RTCD        IFNE      'CGD1270'
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          ************
     C                   Z-ADD     3             W0ERNB                         * DBERR 03 *
     C                   MOVEL     'CGD1286'     W0MSGD                         ************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     EXGENR        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  L01CC                                         *
     C*  Function    :  Lending Commencement Confirmations            *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 LOANA  - Loan Associated Details              *
     C*                 LOAN   - Process Loan Details                 *
     C*                 L@IPY  - Process Interest Payment Details     *
     C*                 L@ROL  - Process Rollover Details             *
     C*                 L@REP  - Process Repayment Details            *
     C*                 L@GUAR - Process Guarantee Details            *
     C*                 SRSDET - Set-up Settlement Details            *
     C*                                                               *
     C*****************************************************************
     C*
     C     L01CC         BEGSR                                                  ** L01CC  **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L01CC '      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'l01CC '      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
      *                                                                                       CCG015
     C                   EXSR      LOANA
     C                   EXSR      LOAN
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG6005CCP1                                           S01408
     C*                                                                   S01408
     C                   EXSR      L@IPY
     C                   EXSR      L@ROL
     C                   EXSR      L@REP
     C                   EXSR      L@GUAR
      *                                                                                       CER049
      ** Stamp Tax                                                                            CER049
      *                                                                                       CER049
     C     CER049        IFEQ      'Y'
     C                   EXSR      LNSTAX
     C                   ENDIF
      *                                                                                       CER049
     C                   EXSR      SRSDET
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     L01CC9        ENDSR                                                  ** L01CC9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOAN                                          *
     C*  Function    :  Process Loan details                          *
     C*                                                               *
     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRICAL - Calculate Interest                   *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                 AOBSRTRO - Retrive Base Rate Code Details     *
     C*                                                               *
     C*****************************************************************
     C*
     C     LOAN          BEGSR                                                  ** LOAN   **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOAN  '      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOAN  '      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
      *                                                                                       CLE172
      ** Init New Fields LIBOR                                                                CLE172
      *                                                                                       CLE172
     C                   MOVEL     *BLANKS       BLRT              1                          CLE172
     C                   MOVEL     *BLANKS       LBDY              2 0                        CLE172
     C                   MOVEL     *BLANKS       LODY              2 0                        CLE172
     C                   MOVEL     *BLANKS       PDLY              2 0                        CLE172
     C                   MOVEL     *BLANKS       BADJ             13 8                        CLE172
     C                   MOVEL     *BLANKS       WGHT              1                          CLE172
     C                   MOVEL     *BLANKS       BRAC              1 0                        CLE172
     C                   MOVEL     *BLANKS       LBAC              2 0                        CLE172
     C                   MOVEL     *BLANKS       PRPL             22 0                        CLE172
     C                   MOVEL     *BLANKS       AVOP              1                          CLE172
     C                   MOVEL     *BLANKS       CART             2015                        CLE172
     C                   MOVEL     *BLANKS       LICA             13 8                        CLE172
     C                   MOVEL     *BLANKS       ITAC             13 8                        CLE172
     C                   MOVEL     *BLANKS       ITAM             13 8                        CLE172
     C*
     C**  Base Rate Name.
     C*
     C     ##BRTT        IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       ##BSRN           30
     C                   ELSE
     C*
     C                   MOVEL     ##BRTT        ##BSRC
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      ##CCY1        ##CYCD            3
     C                   PARM                    ##BSRC            2
     C********** SDBSRT    PARM SDBSRT    DSFDY                                 CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBSRTPD'    W0FILE
     C     ##CYCD        CAT       ##BSRC        W0KEY                          ************
     C                   Z-ADD     4             W0ERNB                         * DBERR 04 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C                   MOVEL     BABSRN        ##BSRN
     C*
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BASERATN'    #@RDE
     C                   MOVE      'AM'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##BSRN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE036
      ** If CLE036 is installed, process base rate.                                           CLE036
      *                                                                                       CLE036
     C     CLE036        IFEQ      'Y'
      *                                                                                       CLE036
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BASE RAT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##BASR        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   ENDIF
     C*
     C**  Base Rate Type.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BASERATT'    #@RDE
     C                   MOVE      'YP'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##BRTT        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Currency Description.
     C*
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6CYNM        ##WRK            14
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CCY_DESC'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##WRK         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Current Principal (Amount).
     C*
     C     ##RCD1        IFEQ      'R'
     C                   Z-ADD     ##NPAM        ##PAMT           13 0
     C                   ELSE
     C                   Z-ADD     ##CPAM        ##PAMT
      *                                                                                       CLE028
      ** If Flat Rate Personal Loans (Rule of 78s) CLE028 is                                  CLE028
      ** installed , the Principal Amount confirmed must include                              CLE028
      ** interest and charges where these have been added on.                                 CLE028
      *                                                                                       CLE028
     C     ##ADCF        IFEQ      'Y'
     C     ##PTYP        ANDEQ     80
     C     CLE028        ANDEQ     'Y'
     C                   ADD       ##CHGA        ##PAMT
     C                   ENDIF
      *                                                                                       CLE028
     C     ##ADIF        IFEQ      'Y'
     C     ##PTYP        ANDEQ     80
     C     CLE028        ANDEQ     'Y'
     C                   ADD       ##FLTI        ##PAMT
     C                   ENDIF
      *                                                                                       CLE028
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR PRIN'    #@RDE
     C                   MOVE      'CL'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##PAMT        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6005C015
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Currency.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CURRENCY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##CCY1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Deal Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'DEAL DAT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##DDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Discount Rate.
     C*
     C     ##RCD1        IFNE      'R'
     C*
     C     ##PTYP        IFEQ      63
     C     ##PTYP        OREQ      65
     C     ##PTYP        OREQ      67
     C                   Z-ADD     ##INTR        ##DISC           11 7
     C                   ELSE
     C                   Z-ADD     0             ##DISC
     C                   END
     C*
     C                   ELSE
     C*
     C     ##NBRA        IFEQ      *ZERO
     C     CLE036        ANDEQ     'N'
     C     ##NBRA        OREQ      *ZERO
     C     ##NBSR        ANDEQ     *ZERO
     C     CLE036        ANDEQ     'Y'
     C                   Z-ADD     0             ##BASE           11 7
     C                   ELSE
     C*
     C     ##NBRA        IFNE      *ZERO
     C                   MOVEL     ##NBRA        ##BSRC
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      ##CCY1        ##CYCD            3
     C                   PARM                    ##BSRC            2
     C********** SDBSRT    PARM SDBSRT    DSFDY                                 CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBSRTPD'    W0FILE
     C     ##CYCD        CAT       ##BSRC        W0KEY                          ************
     C                   Z-ADD     5             W0ERNB                         * DBERR 05 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     BAVDNR        IFGT      ##RLDT
     C                   Z-ADD     BACBSR        ##BASE
     C                   ELSE
     C                   Z-ADD     BANBRT        ##BASE
     C                   END
     C                   ENDIF
      *                                                                                       CLE036
      ** If CLE036 is on and ##NBSR is not zero, ##NBRA should have been zero                 CLE036
      ** so set ##BASE to ##NBSR to get discount rate.                                        CLE036
      *                                                                                       CLE036
     C     ##NBSR        IFNE      *ZERO
     C     CLE036        ANDEQ     'Y'
     C                   Z-ADD     ##NBSR        ##BASE
     C                   ENDIF
     C*
     C                   END
     C*
     C     ##NSIN        IFEQ      'A'
     C     ##BASE        ADD       ##NRTS        ##DISC
     C                   ELSE
     C     ##NSIN        IFEQ      'S'
     C     ##BASE        SUB       ##NRTS        ##DISC
     C                   ELSE
     C     ##NRTS        DIV       100           ##WWRK           13 9
     C     ##WWRK        MULT      ##BASE        ##DISC
     C     ##DISC        IFEQ      0
     C                   Z-ADD     ##INTR        ##DISC
     C                   END
     C                   END
     C                   END
     C*
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'DSC RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##DISC        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Rate.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'GRS DISC'    #@RDE
     C                   MOVE      'NT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TOTI        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6005C016
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Gross Interest.
     C*
     C********** ##REPT    IFEQ 1                                                             177914
     C********** ##REPT    OREQ 3                                                             177914
     C**********           Z-ADD0         ##TINT                                              177914
     C**********           ELSE                                                               177914
     C                   EXSR      SRICAL
     C**********           END                                                                177914
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'GRS INTR'    #@RDE
     C                   MOVE      'ST'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TINT        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6005C017
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Interest Calculation Basis.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT CALB'    #@RDE
     C                   MOVE      'AS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ICBS        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Interest capitalization indicator.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT CAP '    #@RDE
     C                   MOVE      'IN'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##INTC        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Interest Rate.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##INTR        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Loan Reference.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOAN REF'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LNRF          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Loan Total.
     C*
     C     ##RCD1        IFEQ      'R'
     C     ##NPAM        SUB       ##NDAM        ##TTAL
     C                   ELSE
     C     ##PTYP        IFEQ      61
     C     ##PTYP        OREQ      62
     C     ##PTYP        OREQ      64
     C     ##PTYP        OREQ      66
     C     ##PTYP        OREQ      68                                                          CLE00
     C     CLE005        ANDEQ     'Y'                                                         CLE00
     C     ##PTYP        OREQ      69                                                          CLE00
     C     CLE005        ANDEQ     'Y'                                                         CLE00
     C     ##PTYP        OREQ      80
     C     CLE028        ANDEQ     'Y'
     C     ##CPAM        ADD       ##TINT        ##TTAL           13 0
     C                   ELSE
     C     ##PTYP        IFEQ      63
     C     ##PTYP        OREQ      65
     C     ##PTYP        OREQ      67
     C     ##CPAM        SUB       ##TOTI        ##TTAL
     C                   END
     C                   END
      *                                                                                       CLE028
      ** If Flat Rate Personal Loans (Rule of 78s) is installed and                           CLE028
      ** Add on Charges Flag is 'Y', charge amount will be included                           CLE028
      ** in the Loan Amount of a Flat Rate Personal Loans.                                    CLE028
      *                                                                                       CLE028
     C     ##ADCF        IFEQ      'Y'
     C     ##PTYP        ANDEQ     80
     C     CLE028        ANDEQ     'Y'
     C                   ADD       ##CHGA        ##TTAL
     C                   ENDIF
      *                                                                                       CLE028
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOAN TOT'    #@RDE
     C                   MOVE      'AL'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##TTAL        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6005C018
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Maturity Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'MATUR DA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##MDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Run date; production time.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RUNDAT  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BJRDNB        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Spread.
     C*
     C     ##SPIN        IFEQ      'A'
     C                   Z-ADD     ##RTSP        ##SPRD           11 7
     C                   ELSE
     C                   Z-SUB     ##RTSP        ##SPRD
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'SPREAD  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##SPRD        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Value Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'VALUE DA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##VDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Current Principal in Settlement Currency                         CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'C_PRN_SC'    #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
      ** If Lending Enhancements is installed, make use                                       CLE031
      ** the appropriate settlement currency.                                                 CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
      ** Retrieve the currency details of Loan Currency                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WLINCY            1
     C     ##CCY1        IFNE      *BLANKS
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6INCY        WLINCY
     C                   Z-ADD     A6NBDP        WLNBDP            1 0
     C                   ENDIF
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     ##PTYP        IFEQ      66
     C     ##PTYP        OREQ      67
     C     CLE005        OREQ      'Y'
     C     ##PTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     ##PTYP        ANDEQ     72
      *                                                                                       CLE031
      ** Conversion is done only if Receipt Settlement currency is                            CLE031
      ** non-blank and different from Loan Currency.                                          CLE031
      *                                                                                       CLE031
     C     ##CCY1        IFNE      ##STCY
     C     ##STCY        ANDNE     *BLANKS
      *                                                                                       CLE031
      ** Retrieve the currency details of Receipt Settlement Currency.                        CLE031
      *                                                                                       CLE031
     C                   MOVEL     ##STCY        ##CCY
     C                   EXSR      SRDCDT
      *                                                                                       CLE031
      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
      ** is satisfied:                                                                        CLE031
      ** 1. Loan currency is 'In' currency                                                    CLE031
      ** 2. Receipt settlement currency is 'In' currency                                      CLE031
      *                                                                                       CLE031
     C     WLINCY        IFEQ      'Y'
     C     A6INCY        OREQ      'Y'
      *                                                                                       CLE031
     C                   Z-ADD     ##PAMT        P@FRAM
     C                   MOVE      ##CCY1        P@FRCY
     C                   MOVE      ##STCY        P@TOCY
     C                   EXSR      D@EURO
     C                   MOVEL     ##OUTA        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** If the above condition is not satisfied, convert the Principal Amount                CLE031
      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
      ** from CLOANCL.                                                                        CLE031
      *                                                                                       CLE031
     C                   Z-ADD     ##REXR        ZEXCH
     C                   MOVE      ##REXI        ZMD
     C                   Z-ADD     ##PAMT        ZAMTCI
     C                   MOVE      ##CCY1        ZCCYI
     C                   MOVE      ##STCY        ZCCYO
     C                   Z-ADD     WLNBDP        ZCDPI
     C                   Z-ADD     A6NBDP        ZCDPO
      *                                                                                       CLE031
     C                   EXSR      ZCONV
      *                                                                                       CLE031
     C                   MOVEL     ZAMTCO        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** Conversion is done only if Pay Settlement currency is                                CLE031
      ** non-blank and different from Loan Currency.                                          CLE031
      *                                                                                       CLE031
     C     ##CCY1        IFNE      ##PSCY
     C     ##PSCY        ANDNE     *BLANKS
      *                                                                                       CLE031
      ** Retrieve the currency details of Pay Settlement Currency.                            CLE031
      *                                                                                       CLE031
     C                   MOVEL     ##PSCY        ##CCY
     C                   EXSR      SRDCDT
      *                                                                                       CLE031
      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
      ** is satisfied:                                                                        CLE031
      ** 1. Loan currency is 'In' currency                                                    CLE031
      ** 2. Pay Settlement Currency is 'In' currency                                          CLE031
      *                                                                                       CLE031
     C     WLINCY        IFEQ      'Y'
     C     A6INCY        OREQ      'Y'
      *                                                                                       CLE031
     C                   Z-ADD     ##PAMT        P@FRAM
     C                   MOVE      ##CCY1        P@FRCY
     C                   MOVE      ##PSCY        P@TOCY
     C                   EXSR      D@EURO
     C                   MOVEL     ##OUTA        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** If the above condition is not satisfied, convert the Principal Amount                CLE031
      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
      ** from CLOANCL.                                                                        CLE031
      *                                                                                       CLE031
     C                   Z-ADD     ##PEXR        ZEXCH
     C                   MOVE      ##PEXI        ZMD
     C                   Z-ADD     ##PAMT        ZAMTCI
     C                   MOVE      ##CCY1        ZCCYI
     C                   MOVE      ##PSCY        ZCCYO
     C                   Z-ADD     WLNBDP        ZCDPI
     C                   Z-ADD     A6NBDP        ZCDPO
      *                                                                                       CLE031
     C                   EXSR      ZCONV
      *                                                                                       CLE031
     C                   MOVEL     ZAMTCO        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     ##STCY        ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     ##STCY        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     ##PAMT        P@FRAM                                        CEU01
     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
     C                   MOVE      ##STCY        P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C                   ENDIF
     C*                                                                   CEU014
     C** Loan Total in Settlement Currency                                CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'L_TOT_SC'    #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
      ** If Lending Enhancements is installed, make use of                                    CLE031
      ** the appropriate settlement currency.                                                 CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
      ** Retrieve the currency details of Loan Currency                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WLINCY            1
     C     ##CCY1        IFNE      *BLANKS
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6INCY        WLINCY
     C                   Z-ADD     A6NBDP        WLNBDP            1 0
     C                   ENDIF
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     ##PTYP        IFEQ      66
     C     ##PTYP        OREQ      67
     C     CLE005        OREQ      'Y'
     C     ##PTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     ##PTYP        ANDEQ     72
      *                                                                                       CLE031
      ** Conversion is done only if Receipt Settlement currency is                            CLE031
      ** non-blank and different from Loan Currency.                                          CLE031
      *                                                                                       CLE031
     C     ##CCY1        IFNE      ##STCY
     C     ##STCY        ANDNE     *BLANKS
      *                                                                                       CLE031
      ** Retrieve the currency details of Receipt Settlement Currency.                        CLE031
      *                                                                                       CLE031
     C                   MOVEL     ##STCY        ##CCY
     C                   EXSR      SRDCDT
      *                                                                                       CLE031
      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
      ** is satisfied:                                                                        CLE031
      ** 1. Loan currency is 'In' currency                                                    CLE031
      ** 2. Receipt settlement currency is 'In' currency                                      CLE031
      *                                                                                       CLE031
     C     WLINCY        IFEQ      'Y'
     C     A6INCY        OREQ      'Y'
      *                                                                                       CLE031
     C                   Z-ADD     ##TTAL        P@FRAM
     C                   MOVE      ##CCY1        P@FRCY
     C                   MOVE      ##STCY        P@TOCY
     C                   EXSR      D@EURO
     C                   MOVEL     ##OUTA        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** If the above condition is not satisfied, convert the Loan Total                      CLE031
      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
      ** from CLOANCL.                                                                        CLE031
      *                                                                                       CLE031
     C                   Z-ADD     ##REXR        ZEXCH
     C                   MOVE      ##REXI        ZMD
     C                   Z-ADD     ##TTAL        ZAMTCI
     C                   MOVE      ##CCY1        ZCCYI
     C                   MOVE      ##STCY        ZCCYO
     C                   Z-ADD     WLNBDP        ZCDPI
     C                   Z-ADD     A6NBDP        ZCDPO
      *                                                                                       CLE031
     C                   EXSR      ZCONV
      *                                                                                       CLE031
     C                   MOVEL     ZAMTCO        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** Conversion is done only if Pay Settlement currency is                                CLE031
      ** non-blank and different from Loan Currency.                                          CLE031
      *                                                                                       CLE031
     C     ##CCY1        IFNE      ##PSCY
     C     ##PSCY        ANDNE     *BLANKS
      *                                                                                       CLE031
      ** Retrieve the currency details of Pay Settlement Currency.                            CLE031
      *                                                                                       CLE031
     C                   MOVEL     ##PSCY        ##CCY
     C                   EXSR      SRDCDT
      *                                                                                       CLE031
      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
      ** is satisfied:                                                                        CLE031
      ** 1. Loan currency is 'In' currency                                                    CLE031
      ** 2. Pay Settlement Currency is 'In' currency                                          CLE031
      *                                                                                       CLE031
     C     WLINCY        IFEQ      'Y'
     C     A6INCY        OREQ      'Y'
      *                                                                                       CLE031
     C                   Z-ADD     ##TTAL        P@FRAM
     C                   MOVE      ##CCY1        P@FRCY
     C                   MOVE      ##PSCY        P@TOCY
     C                   EXSR      D@EURO
     C                   MOVEL     ##OUTA        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** If the above condition is not satisfied, convert the Loan Total                      CLE031
      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
      ** from CLOANCL.                                                                        CLE031
      *                                                                                       CLE031
     C                   Z-ADD     ##PEXR        ZEXCH
     C                   MOVE      ##PEXI        ZMD
     C                   Z-ADD     ##TTAL        ZAMTCI
     C                   MOVE      ##CCY1        ZCCYI
     C                   MOVE      ##PSCY        ZCCYO
     C                   Z-ADD     WLNBDP        ZCDPI
     C                   Z-ADD     A6NBDP        ZCDPO
      *                                                                                       CLE031
     C                   EXSR      ZCONV
      *                                                                                       CLE031
     C                   MOVEL     ZAMTCO        ##DATA
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     ##STCY        ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     ##STCY        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     ##TTAL        P@FRAM                                        CEU01
     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
     C                   MOVE      ##STCY        P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C                   ENDIF
     C*                                                                   CEU014
     C**  20 RDEs extracted for this group set so accumulate them and     CEU014
     C**  the associated data.                                            CEU014
     C*                                                                   CEU014
     C                   EXSR      SRADTA                                                      CEU01
     C                   Z-ADD     0             R1                                            CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C*                                                                   CEU014
     C** determine the Equivalent Currency                                CEU014
     C*                                                                   CEU014
     C                   MOVE      *BLANKS       EQCY              3                           CEU01
     C                   MOVE      ##CCY1        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C     A6INCY        IFEQ      'Y'                                                         CEU01
     C                   MOVE      BKEURO        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C     ##CCY1        IFEQ      BKEURO                                                      CEU01
     C                   MOVEL     ##CNUM        ##KEY2                                        CEU01
     C                   CALL      'AOCUSTR0'                                                  CEU01
     C                   PARM      *BLANKS       ##RTCD                                        CEU01
     C                   PARM      '*KEY   '     ##OPTN                                        CEU01
     C                   PARM                    ##KEY2           10                           CEU01
     C                   PARM      *BLANKS       ##KYST            7                           CEU01
     C     SDCUST        PARM      SDCUST        DSSDY                                         CEU01
     C*                                                                   CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
     C                   MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
     C                   MOVEL     ##CNUM        W0KEY                          ************   CEU01
     C                   Z-ADD     18            W0ERNB                         * DBERR 18 *   CEU01
     C                   MOVEL     'MEM5004'     W0MSGD                         ************   CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C                   MOVE      BBDINC        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C** Current Principal in Equivalent Currency                         CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'C_PRN_EQ'    #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     ##PAMT        P@FRAM                                        CEU01
     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
     C                   MOVE      EQCY          P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C** Loan Total in Equivalent Currency                                CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'L_TOT_EQ'    #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     ##TTAL        P@FRAM                                        CEU01
     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
     C                   MOVE      EQCY          P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C** Equivalent Currency                                              CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
     C                   MOVE      'Y '          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##DATA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C** Equivalent Currency Description                                  CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
     C                   MOVE      'YD'          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     A6CYNM        ##DATA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C     CLE143        IFEQ      'Y'
      *                                                                                       CLE143
      ** Original Contract Date                                                               CLE143
      *                                                                                       CLE143
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ORIGCDAT'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##OCDT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE143
      ** Effective Annual Interest Rate                                                       CLE143
      *                                                                                       CLE143
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'EFFAINTR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##EAIR        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C**********           MOVEL'7'       ##DCPA                                     CLE143 AR822053
     C                   MOVEL     '8'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE143
      ** CLE143 Switchable Feature status RDE                                                 CLE143
      *                                                                                       CLE143
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CLE143F '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CLE143        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   ENDIF
      *                                                                                       CLE143
      ** Contractual Spread                                                                   CRE073
      *                                                                                       CRE073
     C     CRE073        IFEQ      'Y'
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CONTSPR'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##CNSP        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** Contractual Spread Sign                                                              CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CONTSSG'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##CNSG        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** Rounding Method                                                                      CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RNDMTD'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDMT        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** Rounding Fraction/Decimal                                                            CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RNDFRCD'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDFD        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** CRE073 Switchable Feature                                                            CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CRE073F'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CRE073        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
     C                   ENDIF
      *                                                                                       CRE073
      ** CLE141 Switchable Feature status RDE                                                 CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CLE141F '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CLE141        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*                                                                                       CLE141
     C** DETERMINE THE BUSINESS DAY CONVENTION FOR INTEREST AND PRIN. SETTLEMENT              CLE141
     C*                                                                                       CLE141
     C     CLE141        IFEQ      'Y'
      *                                                                                       CLE141
      ** Interest and Principal Currency 1                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR1INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C1PI          IFNE      *BLANKS
     C                   MOVEL     C1PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 2                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR2INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C2PI          IFNE      *BLANKS
     C                   MOVEL     C2PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 3                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR3INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C3PI          IFNE      *BLANKS
     C                   MOVEL     C3PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 4                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR4INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C4PI          IFNE      *BLANKS
     C                   MOVEL     C4PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 5                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR5INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C5PI          IFNE      *BLANKS
     C                   MOVEL     C5PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 6                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR6INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C6PI          IFNE      *BLANKS
     C                   MOVEL     C6PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 7                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR7INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C7PI          IFNE      *BLANKS
     C                   MOVEL     C7PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C*                                                                                       CLE141
     C**  20 RDEs extracted for this group set so accumulate them and                         CLE141
     C**  the associated data.                                                                CLE141
     C*                                                                                       CLE141
     C                   EXSR      SRADTA
     C                   Z-ADD     0             R1
      *                                                                                       CLE141
      ** Interest and Principal Currency 8                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR8INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C8PI          IFNE      *BLANKS
     C                   MOVEL     C8PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 9                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR9INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C9PI          IFNE      *BLANKS
     C                   MOVEL     C9PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Currency 10                                                   CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR0INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C0PI          IFNE      *BLANKS
     C                   MOVEL     C0PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 1                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC1INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L1PI          IFNE      *BLANKS
     C                   MOVEL     L1PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 1                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD            7
     C                   PARM      '*KEY    '    UFOPTN            7
     C                   PARM      L1PI          UFLOCN            3
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON1INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 2                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC2INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L2PI          IFNE      *BLANKS
     C                   MOVEL     L2PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 2                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L2PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON2INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 3                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC3INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L3PI          IFNE      *BLANKS
     C                   MOVEL     L3PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 3                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L3PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON3INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 4                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC4INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L4PI          IFNE      *BLANKS
     C                   MOVEL     L4PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 4                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L4PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON4INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 5                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC5INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L5PI          IFNE      *BLANKS
     C                   MOVEL     L5PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 5                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L5PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON5INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 6                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC6INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L6PI          IFNE      *BLANKS
     C                   MOVEL     L6PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 6                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L6PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON6INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 7                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC7INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L7PI          IFNE      *BLANKS
     C                   MOVEL     L7PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 7                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L7PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON7INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 8                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC8INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L8PI          IFNE      *BLANKS
     C                   MOVEL     L8PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 8                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L8PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON8INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C*                                                                                       CLE141
     C**  20 RDEs extracted for this group set so accumulate them and                         CLE141
     C**  the associated data.                                                                CLE141
     C*                                                                                       CLE141
     C                   EXSR      SRADTA
     C                   Z-ADD     0             R1
      *                                                                                       CLE141
      ** Interest and Principal Location 9                                                    CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC9INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L9PI          IFNE      *BLANKS
     C                   MOVEL     L9PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 9                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L9PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON9INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Interest and Principal Location 10                                                   CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC0INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L0PI          IFNE      *BLANKS
     C                   MOVEL     L0PI          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 10                                                            CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L0PI          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON0INTP'    #@RDE
     C                   MOVE      'AY'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 1                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR1ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C1PR          IFNE      *BLANKS
     C                   MOVEL     C1PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 2                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR2ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C2PR          IFNE      *BLANKS
     C                   MOVEL     C2PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 3                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR3ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C3PR          IFNE      *BLANKS
     C                   MOVEL     C3PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 4                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR4ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C4PR          IFNE      *BLANKS
     C                   MOVEL     C4PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 5                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR5ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C5PR          IFNE      *BLANKS
     C                   MOVEL     C5PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 6                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR6ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C6PR          IFNE      *BLANKS
     C                   MOVEL     C6PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 7                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR7ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C7PR          IFNE      *BLANKS
     C                   MOVEL     C7PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 8                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR8ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C8PR          IFNE      *BLANKS
     C                   MOVEL     C8PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 9                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR9ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C9PR          IFNE      *BLANKS
     C                   MOVEL     C9PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Currency 10                                                 CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUR0ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     C0PR          IFNE      *BLANKS
     C                   MOVEL     C0PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 1                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC1ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L1PR          IFNE      *BLANKS
     C                   MOVEL     L1PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 1                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L1PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON1ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 2                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC2ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L2PR          IFNE      *BLANKS
     C                   MOVEL     L2PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 1                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L2PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON2ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 3                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC3ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L3PR          IFNE      *BLANKS
     C                   MOVEL     L3PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 3                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L3PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON3ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C*                                                                                       CLE141
     C**  20 RDEs extracted for this group set so accumulate them and                         CLE141
     C**  the associated data.                                                                CLE141
     C*                                                                                       CLE141
     C                   EXSR      SRADTA
     C                   Z-ADD     0             R1
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 4                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC4ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L4PR          IFNE      *BLANKS
     C                   MOVEL     L4PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 4                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L4PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON4ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 5                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC5ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L5PR          IFNE      *BLANKS
     C                   MOVEL     L5PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 5                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L5PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON5ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 6                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC6ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L6PR          IFNE      *BLANKS
     C                   MOVEL     L6PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 6                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L6PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON6ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 7                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC7ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L7PR          IFNE      *BLANKS
     C                   MOVEL     L7PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 7                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L7PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON7ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 8                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC8ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L8PR          IFNE      *BLANKS
     C                   MOVEL     L8PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 8                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L8PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON8ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 9                                                  CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC9ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L9PR          IFNE      *BLANKS
     C                   MOVEL     L9PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 9                                                             CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L9PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON9ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
      ** Rollover and Rate Fixing Location 10                                                 CLE141
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOC0ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE141
     C     L0PR          IFNE      *BLANKS
     C                   MOVEL     L0PR          ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE141
      ** Retrieve Location Name 10                                                            CLE141
      *                                                                                       CLE141
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       UFRTCD
     C                   PARM      '*KEY    '    UFOPTN
     C                   PARM      L0PR          UFLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *                                                                                       CLE141
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LON0ROLL'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   MOVEL     DVLCNM        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE141
     C                   ENDIF
     C*                                                                                       CLE141
     C/COPY WNCPYSRC,CG6005C006
      *                                                                                       CER050
     C     CER050        IFEQ      'Y'
     C                   EXSR      ZI@APR
     C                   ENDIF
      *                                                                                       CLE172
      ** LIBOR Deregulation BACKWARD-LOOKING RATE                                             CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'TE'          #@RDE                                        CLE172
     C                   MOVEL     'BCKLOKRA'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     BLRT          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Averaging Option                                                                     CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'N'           #@RDE                                        CLE172
     C                   MOVEL     'AVGOPTIO'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     AVOP          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Compounded/Average Rate                                                              CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'AR'          #@RDE                                        CLE172
     C                   MOVEL     'COMPOUND'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     CART          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Lookback Days                                                                        CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'AY'          #@RDE                                        CLE172
     C                   MOVEL     'LOOKBCKD'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     LBDY          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Lockout Days                                                                         CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'AY'          #@RDE                                        CLE172
     C                   MOVEL     'LOCKOUTD'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     LODY          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Delayed Payment Days                                                                 CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'YS'          #@RDE                                        CLE172
     C                   MOVEL     'DLYPAYDA'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     PDLY          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Benchmark Adjustment Days                                                            CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'OD'          #@RDE                                        CLE172
     C                   MOVEL     'BMRKADJC'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     BADJ          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Weight Convention                                                                    CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'OD'          #@RDE                                        CLE172
     C                   MOVEL     'BMRKADJC'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     WGHT          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Base Rate Code for Accrual                                                           CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'TE'          #@RDE                                        CLE172
     C                   MOVEL     'BRACCRRA'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     BRAC          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Lookback Days for Accrual                                                            CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'TE'          #@RDE                                        CLE172
     C                   MOVEL     'BRACCRRA'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     LBAC          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Principal                                                                            CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'L'           #@RDE                                        CLE172
     C                   MOVEL     'PRINCIPA'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     PRPL          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Line Items                                                                           CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'S'           #@RDE                                        CLE172
     C                   MOVEL     'LINEITEM'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     LICA          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Interest Amounts Accrued For Each Day                                                CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'D'           #@RDE                                        CLE172
     C                   MOVEL     'INTACCRE'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     ITAC          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *                                                                                       CLE172
      ** Interest                                                                             CLE172
      *                                                                                       CLE172
     C                   ADD       1             R1                                           CLE172
     C                   CLEAR                   R#DATA                                       CLE172
     C                   CLEAR                   R#DEFN                                       CLE172
     C                   CLEAR                   #@RDE                                        CLE172
     C                   MOVE      'T'           #@RDE                                        CLE172
     C                   MOVEL     'INTAMOUN'    #@RDE                                        CLE172
     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
     C                   MOVEL     ITAM          R#DATA                                       CLE172
     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
      *
     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
     C*
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOAN9         ENDSR                                                  ** LOAN9  **
     C*
     C*****************************************************************
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG6005CCP2                                           S01408
     C*                                                                   S01408
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  L@ROL                                         *
     C*  Function    :  Process Rollover Details                      *
     C*                                                               *
     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                 AOBSRTRO - Retrive Base Rate Code Details     *
     C*                                                               *
     C*****************************************************************
     C*
     C     L@ROL         BEGSR                                                  ** L@ROL  **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L@ROL '      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'L_ROL '      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C**  Next Base Rate Name.
     C*
     C     ##NBRA        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       ##NBRN           30
     C                   ELSE
     C*
     C                   MOVEL     ##NBRA        ##BSRC
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      ##CCY1        ##CYCD            3
     C                   PARM                    ##BSRC            2
     C********** SDBSRT    PARM SDBSRT    DSFDY                                 CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBSRTPD'    W0FILE
     C     ##CYCD        CAT       ##BSRC        W0KEY                          ************
     C                   Z-ADD     6             W0ERNB                         * DBERR 06 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C                   MOVEL     BABSRN        ##NBRN
     C*
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT BSRN'    #@RDE
     C                   MOVE      'AM'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NBRN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE036
      ** If CLE036 is installed, process next base rate.                                      CLE036
      *                                                                                       CLE036
     C     CLE036        IFEQ      'Y'
      *                                                                                       CLE036
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT BSRA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NBSR        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   ENDIF
     C*
     C**  Next Base Rate Type.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT BSRT'    #@RDE
     C                   MOVE      'YP'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NBRA        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Next Interest Calculation Basis.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT INTC'    #@RDE
     C                   MOVE      'LB'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NCAS        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Next Rollover Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT RLDA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NROD        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Next Spread.
     C*
     C     ##NSIN        IFEQ      'A'
     C                   Z-ADD     ##NRTS        ##NSPR           11 7
     C                   ELSE
     C                   Z-SUB     ##NRTS        ##NSPR
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT SPRE'    #@RDE
     C                   MOVE      'AD'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NSPR        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Rollover Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ROLL DAT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RLDT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Rollover Day in Month.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ROLL DAY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RLDY        ##DATA
     C                   MOVEL     'Day   '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Rollover Frequency.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ROLL FRE'    #@RDE
     C                   MOVE      'Q '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RLFQ        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Rollover Indicator.
     C*
     C     ##RCD1        IFEQ      'R'
     C                   MOVE      'Y'           ##ROIN            1
     C                   ELSE
     C                   MOVE      ' '           ##ROIN
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ROLLIND '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##ROIN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
     C*
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     L@ROL9        ENDSR                                                  ** L@ROL9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  L@REP                                         *
     C*  Function    :  Process Repayment Details                     *
     C*                                                               *
     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                                                               *
     C*****************************************************************
     C*
     C     L@REP         BEGSR                                                  ** L@REP  **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L@REP '      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'L_REP '      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C**  Next Repayment Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT RPDA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NRPD        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Repayment Amount.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'REPAY AM'    #@RDE
     C                   MOVE      'NT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RAMT        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     ##CCY1        ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6005C019
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Repayment Day in Month.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'REPAY DA'    #@RDE
     C                   MOVE      'Y '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RDYN        ##DATA
     C                   MOVEL     'Day   '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Repayment Frequency.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'REPAY FR'    #@RDE
     C                   MOVE      'EQ'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##RFRQ        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Repayment Type.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'REPAY TY'    #@RDE
     C                   MOVE      'PE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##REPT        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
     C*
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     L@REP9        ENDSR                                                  ** L@REP9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  L@IPY                                         *
     C*  Function    :  Process Interest Payment details              *
     C*                                                               *
     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                                                               *
     C*****************************************************************
     C*
     C     L@IPY         BEGSR                                                  ** L@IPY  **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L@IPY '      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'L_IPY '      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C**  Interest Payment Day.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT DAY '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##IFDY        ##DATA
     C                   MOVEL     'Day   '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Interest Payment Frequency.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT FREQ'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##IPFR        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Next Interest Payment Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT IPDA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NIDT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C/COPY WNCPYSRC,CG6005C014
     C*
     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
     C*
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     L@IPY9        ENDSR                                                  ** L@IPY9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  L@GUAR                                        *
     C*  Function    :  Process Guarantee details                     *
     C*                                                               *
     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                 AOCUSTR0 - Retrieve Customer Details          *
     C*                                                               *
     C*****************************************************************
     C*
     C     L@GUAR        BEGSR                                                  ** L@GUAR **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L@GUAR'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'L_GUAR'      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C********** ##RECE    IFEQ 0                                                             CSD027
     C     ##RECE        IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       ##GRNM           20
     C                   MOVEL     *BLANKS       ##GRTN           10
     C                   ELSE
     C*
     C                   MOVEL     ##RECE        ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1           10
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     ##RECE        W0KEY                          ************
     C                   Z-ADD     7             W0ERNB                         * DBERR 07 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C                   MOVEL     BBCRNM        ##GRNM
     C                   MOVEL     BBCRTN        ##GRTN
     C*
     C                   END
     C*
     C**  Receiver of Guarantee Name.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RECGUANA'    #@RDE
     C                   MOVE      'M '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##GRNM        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Receiver of Guarantee Town.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'N '          #@RDE
     C                   MOVEL     'RECGUATW'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##GRTN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C/COPY WNCPYSRC,CG6005C007
     C*
     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
     C*
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     L@GUA9        ENDSR                                                  ** L@GUA9 **
     C*
     C*****************************************************************
      /EJECT                                                                                  CER049
      *****************************************************************                       CER049
      *                                                               *                       CER049
      *  Subroutine  :  LNSTAX                                        *                       CER049
      *  Function    :  Process Stamp Tax information                 *                       CER049
      *                                                               *                       CER049
      *  Called by   :  L01CC  - Lending Commencement Confirmations   *                       CER049
      *  Calls       :  SRPATH - Generate Path String                 *                       CER049
      *                 SRADTA - Accumulate RDEs and Associated Data  *                       CER049
      *                 SRODTA - Output Accumulated Data to CGUDTAPD  *                       CER049
      *                                                               *                       CER049
      *****************************************************************                       CER049
      *                                                                                       CER049
     C     LNSTAX        BEGSR                                                  ** LNSTAX **
      *                                                                                       CER049
      ** Set up subroutine stack name.                                                        CER049
      *                                                                                       CER049
     C                   ADD       1             Q
     C                   MOVEL     'LNSTAX'      @STK(Q)
      *                                                                                       CER049
     C                   ADD       1             P1
      *                                                                                       CER049
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LNSTAX'      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
      *                                                                                       CER049
     C                   Z-ADD     0             R1                3 0
      *                                                                                       CER049
      ** Set Loan number key                                                                  CER049
      *                                                                                       CER049
     C**********           Z-ADDLNRF      K1LNRF  60                                   CER049 CLE148
     C                   MOVEL     LNRF          K1LNRF            6
      *                                                                                       CER049
      ** Retrieve the stamp tax record for the loan                                           CER049
      *                                                                                       CER049
     C     K1LNRF        CHAIN     CLONCLL1                           98
      *                                                                                       CER049
      ** If record found, extract stamp tax data                                              CER049
      *                                                                                       CER049
     C     *IN98         IFEQ      *OFF
      *                                                                                       CER049
      ** Stamp Tax Liable Flag                                                                CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZSTAXFLG'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQTAX         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Principal Tax flag                                                                   CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXPRFL'    #@RDE
     C                   MOVE      'G '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQPRIN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Start Date for Principal Tax                                                         CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXPRDT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQPDTE        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Average Balance Flag                                                                 CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXAVFL'    #@RDE
     C                   MOVE      'G '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQAVBL        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Start Date for Average Balance                                                       CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXAVDT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQADTE        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Interest Tax Flag                                                                    CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXINFL'    #@RDE
     C                   MOVE      'G '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQSINT        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Start Date for Interest Tax                                                          CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXINDT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQIDTE        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Debit Account Reference                                                              CER049
      *                                                                                       CER049
     C     LQDCST        CAT       LQDCCY        WDRAC1            9
     C                   MOVEL     WDRAC1        WDRAC2           19
     C                   MOVE      LQDACD        WDRAC2
     C                   MOVEL     WDRAC2        WDRAC3           21
     C                   MOVE      LQDASC        WDRAC3
     C     WDRAC3        CAT       LQDBRC        WDRACC           24
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ACCOUNT'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     WDRACC        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Stamp Tax amount                                                                     CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'Z_TAX_AM'    #@RDE
     C                   MOVE      'T '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQSTAB        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     LQDCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Stamp Tax On Interest                                                                CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXINAM'    #@RDE
     C                   MOVE      'T '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQSTAI        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     LQDCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
      ** Stamp Tax on Average This Month                                                      CER049
      *                                                                                       CER049
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZTAXAVAM'    #@RDE
     C                   MOVE      'T '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LQTAXE        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     LQDCCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER049
     C                   ENDIF
      *                                                                                       CER049
      ** Accumulate RDEs and associated data and output to PF/CGUDTPD.                        CER049
      *                                                                                       CER049
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *                                                                                       CER049
      ** Decrement Path DS index.                                                             CER049
      *                                                                                       CER049
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
     C                   EXSR      POPGRS
      *                                                                                       CER049
      ** Unwind subroutine stack name.                                                        CER049
      *                                                                                       CER049
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *                                                                                       CER049
     C     LNSTA9        ENDSR                                                  ** LNSTA9 **
      *                                                                                       CER049
      *****************************************************************                       CER049
      * Subroutine  :  ZI@APR                                         *                       CER050
      * Function    :  Extract - Annualised Percentage Rate (APR)     *                       CER050
      *                                                               *                       CER050
      * Called by   :                                                 *                       CER050
      * Calls       :                                                 *                       CER050
      *****************************************************************                       CER050
     C     ZI@APR        BEGSR
      *                                                                                       CER050
      **  Only if processing type is 61, 62 or 63                                             CER050
     C     ##PTYP        IFEQ      61
     C     ##PTYP        OREQ      62
     C     ##PTYP        OREQ      63
      *                                                                                       CER050
      * Run this process only if Do not print APR is set to Blank                             CER050
      *                                                                                       CER050
     C     APRC          IFEQ      'Y'
     C     LNRF          CHAIN     LEAPRHI0                           89
      *                                                                                       CER050
      * Look for the first element in blank in series                                         CER050
     C                   Z-ADD     1             R1
     C     ##R(R1)       DOUEQ     *BLANKS
     C     R1            OREQ      20
     C                   ADD       1             R1
     C                   ENDDO
     C*                                                                                       CER050
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZI_AAPR '    #@RDE            10
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     IAPRR         R#DATA
     C                   MOVEL     IAPRR         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '2'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*                                                                                       CER050
     C                   END
     C                   ENDIF
      *                                                                                       CER050
     C                   ENDSR
      *                                                                                       CER050
      *****************************************************************                       CER050
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANA                                         *
     C*  Function    :  Loan Associated Details                       *
     C*                                                               *
     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 CG6001 - General Loan Details                 *
     C*****************************************************************
     C*
     C     LOANA         BEGSR                                                  ** LOANA  **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANA '      @STK(Q)
     C*
     C                   EXSR      SRPATH
     C*
     C                   MOVEL     S#PATH        P2PARM
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN
     C*
     C**  Set up data.
     C*
     C                   CLEAR                   P4PARM
     C                   MOVE      *BLANKS       P@CNAM
     C     ##CHT1        IFEQ      'R'
     C     ##CHT1        OREQ      'A'
     C                   MOVEL     ##CHT1        P@CNAM
     C                   END
     C*
     C                   MOVE      LNRF          P@LNRF
     C                   CALL      'CG6001'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    P1PARM                         UDC Details
     C                   PARM                    P2PARM          140            Path Details
     C                   PARM                    P@PARM                         Loan Details
     C                   PARM                    P4PARM                         Facility Details
     C                   PARM                    ##AUTO
     C                   PARM                    ##REFR
     C                   PARM                    P@ICR
     C                   PARM      'N'           ##MAST
     C*
     C**  Reset Sequence number.
     C*
     C                   Z-ADD     P1OSEQ        ##OSEQ
     C*
     C     EXXPAY        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOANA9        ENDSR                                                  ** LOANA9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRSDET                                        *
     C*  Function    :  Set-up settlement details                     *
     C*                                                               *
     C*  Called by   :  L01CC - Lending Commencement Confirmations    *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 CG99LSET - To set-up settlement details       *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRSDET        BEGSR                                                  ** SRSDET **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRSDET'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*                                                                                       CCG015
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'L_SETL'      ##GRPS
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   MOVEL     S#PATH        P2PARM
     C*
     C**  Setup the parameters for CG99LSET.
     C*
     C                   CLEAR                   P0PARM
     C                   MOVEL     ##OSDB        P0POBR
     C                   MOVEL     ##OMDB        P0ROBR
     C                   Z-ADD     ##RSTM        P0RSTM
     C                   MOVEL     ##RONS        P0RONS
     C                   MOVEL     ##RIBN        P0RIBN
     C                   MOVEL     ##RIBA        P0RIBA
     C**********           Z-ADD##ROBN    P0ROBN                                              CSD027
     C**********           Z-ADD##ROCN    P0ROCN                                              CSD027
     C                   MOVE      ##ROBN        P0ROBN
     C                   MOVE      ##ROCN        P0ROCN
     C                   Z-ADD     ##PSTM        P0PSTM
     C                   MOVEL     ##PONS        P0PONS
     C                   MOVEL     ##PIBN        P0PIBN
     C                   MOVEL     ##PIBA        P0PIBA
     C**********           Z-ADD##POBN    P0POBN                                              CSD027
     C**********           Z-ADD##POCN    P0POCN                                              CSD027
     C                   MOVE      ##POBN        P0POBN
     C                   MOVE      ##POCN        P0POCN
     C                   MOVEL     ##RCRN        P0RCRN
     C                   MOVEL     ##RCRA        P0RCRA
     C                   MOVEL     ##RVNO        P0RVNO
     C                   MOVEL     ##AWBN        P0AWBN
     C                   MOVEL     ##AWBA        P0AWBA
     C                   MOVEL     ##BENN        P0BENN
     C                   MOVEL     ##BENA        P0BENA
     C                   MOVEL     ##DTP1        P0DTP1
     C                   MOVEL     ##DTP2        P0DTP2
     C                   MOVEL     ##DTP3        P0DTP3
     C                   MOVEL     ##DTP4        P0DTP4
     C                   MOVEL     ##DCHG        P0DCHG
     C                   MOVEL     ##BTB1        P0BTB1
     C                   MOVEL     ##BTB2        P0BTB2
     C                   MOVEL     ##BTB3        P0BTB3
     C                   MOVEL     ##BTB4        P0BTB4
     C                   MOVEL     ##BTB5        P0BTB5
     C                   MOVEL     ##BTB6        P0BTB6
     C                   MOVEL     ##SPI1        P0SPI1
     C                   MOVEL     ##SPI2        P0SPI2
     C                   MOVEL     ##SPI3        P0SPI3
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     CLE031        OREQ      'Y'
     C                   MOVEL     ##STCY        P0STCY                                        CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
     C                   MOVEL     ##PSCY        P0PSCY
     C                   ENDIF
     C*
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN
      *                                                                                       130998
      * If settlement method set in old fields and not in new then use                        130998
      *                                                                                       130998
     C     ##MDST        IFNE      0
     C     P0RSTM        ANDEQ     0
     C                   MOVEL     ##MDST        P0RSTM                         *Settlemt type
     C                   MOVEL     ##OMDB        P0ROBR                         *Settlemt branch
     C                   MOVEL     ##OMDA        P0RONS                         *Our nostro/ A/C
     C                   MOVEL     ##TMAN        P0RIBN                         *Their nostro
     C                   ENDIF
     C*                                                                                       130998
     C     ##SDST        IFNE      0
     C     P0PSTM        ANDEQ     0
     C                   MOVEL     ##SDST        P0PSTM                         *Settlemt type
     C                   MOVEL     ##OSDB        P0POBR                         *Settlemt branch
     C                   MOVEL     ##OSDA        P0PONS                         *Our nostro/ A/C
     C                   MOVEL     ##TSTN        P0AWBN                         *Their nostro
     C                   MOVEL     ##FACO        P0BENN                         *For account of
     C                   ENDIF
     C*
     C                   CALL      'CG99LSET'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD
     C                   PARM                    P1PARM
     C                   PARM                    P2PARM          140
     C                   PARM                    PDETLS
     C                   PARM                    P0PARM
     C                   PARM                    ##REFR
     C                   PARM                    P@ICR
     C                   PARM      'N'           ##MAST
     C*
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     'CG99LSET'    W0FILE
     C                   MOVEL     'W0RTN'       W0KEY                          ************
     C                   Z-ADD     8             W0ERNB                         * DBERR 08 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C**  Reset Sequence number.
     C*
     C                   Z-ADD     P1OSEQ        ##OSEQ
     C*                                                                                       CCG015
     C**  Decrement Path DS index                                                             CCG015
     C*                                                                                       CCG015
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRSDE9        ENDSR                                                  ** SRSDE9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRINZF                                        *
     C*  Function    :  Initialise Fields on Each Invocation          *
     C*                                                               *
     C*  Called by   :  MAINLINE - Mainline Processing                *
     C*  Calls       :  None                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRINZF        BEGSR                                                  ** SRINZF **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINZF'      @STK(Q)
     C*
     C**  Initialise work fields.
     C*
     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        ##W157           15 7
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
     C*
     C**  Initialise output sequence (to CGUDTAPD).
     C*
     C                   Z-ADD     *ZEROS        ##OSEQ
     C*
     C**  DJU Additions for CG4999 1st version.
     C*
     C                   MOVE      *BLANKS       #@RDE            10
     C     *LIKE         DEFINE    ##TBIN        #@TBIN
     C*
     C     1             OCCUR     ##BIND
     C                   RESET                   ##BIND
     C                   RESET                   #@BIND
     C                   RESET                   #PDS
      *                                                                                       CCG015
      ** Initialise XML increment                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      INIXML
     C*
     C     EXINZ         TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRINZ9        ENDSR                                                  ** SRINZ9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRINIT                                        *
     C*  Function    :  Initial processing - On First Call            *
     C*                                                               *
     C*  Called by   :  MAINLINE - Mainline Processing                *
     C*  Calls       :  AOBANKR0 - Retrive Bank Details               *
     C*                 SRDCDT   - Determine Currency Details         *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRINIT        BEGSR                                                  ** SRINIT **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
     C/COPY WNCPYSRC,CG6005C003
     C*
     C**  Retrieve Bank details.
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    W0FILE
     C                   MOVEL     '*FIRST'      W0KEY                          ************
     C                   Z-ADD     9             W0ERNB                         * DBERR 09 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
     C*
     C**  Determine Number of decimal places - Base currency.
     C*
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0
      *                                                                   CEU014
      ** Access GL ICD for Euro currency code                             CEU014
      *                                                                   CEU014
     C**********           CALL 'AOGELRR0'                                             CEU014 CGL029
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       ##RTCD                                        CEU01
     C                   PARM      '*FIRST '     ##OPTN                                        CEU01
     C********** SDGELR    PARM SDGELR    DSFDY                                        CEU014 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY
      *                                                                   CEU014
      ** DATABASE ERROR                                                   CEU014
      *                                                                   CEU014
     C     ##RTCD        IFNE      *BLANKS                                                     CEU01
     C                   MOVEL     'SDGELRPD'    W0FILE                                        CEU01
     C                   MOVEL     ##OPTN        W0KEY                          ***************CEU01
     C                   Z-ADD     17            W0ERNB                         * DB ERROR 17 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CLE005
      ** Check if CLE005 is ON                                            CLE005
      *                                                                   CLE005
     C                   CALL      'AOSARDR0'                                                  CLE00
     C                   PARM      *BLANKS       ##RTCD            7                           CLE00
     C                   PARM      '*KEY    '    ##OPTN            7                           CLE00
     C                   PARM      'CLE005'      PSARD             6                           CLE00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE00
     C*                                                                   CLE005
     C     ##RTCD        IFEQ      *BLANK                                                      CLE00
     C                   MOVE      'Y'           CLE005            1                           CLE00
     C                   ELSE                                                                  CLE00
     C                   MOVE      'N'           CLE005                                        CLE00
     C     ##RTCD        IFNE      '*NRF    '                                                  CLE00
     C                   MOVEL     'SCSARDPD'    W0FILE                                        CLE00
     C                   MOVEL     'CLE005'      W0KEY                          ************   CLE00
     C                   Z-ADD     15            W0ERNB                         * DBERR 15 *   CLE00
     C                   MOVEL     'MEM5003'     W0MSGD                         ************   CLE00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CLE00
     C                   EXSR      SRERR                                                       CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
     C*
      ** Check if CEU014 is switched on                                   CEU014
      *                                                                   CEU014
     C                   CALL      'AOSARDR0'                                                  CEU01
     C                   PARM      *BLANKS       ##RTCD            7                           CEU01
     C                   PARM      '*KEY    '    ##OPTN            7                           CEU01
     C                   PARM      'CEU014'      PSARD             6                           CEU01
     C     SCSARD        PARM      SCSARD        DSFDY                                         CEU01
     C*                                                                   CEU014
     C     ##RTCD        IFEQ      *BLANK                                                      CEU01
     C                   MOVE      'Y'           CEU014            1                           CEU01
     C                   ELSE                                                                  CEU01
     C                   MOVE      'N'           CEU014                                        CEU01
     C     ##RTCD        IFNE      '*NRF    '                                                  CEU01
     C                   MOVEL     'SCSARDPD'    W0FILE                                        CEU01
     C                   MOVEL     'CEU014'      W0KEY                          ************   CEU01
     C                   Z-ADD     16            W0ERNB                         * DBERR 16 *   CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ************   CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CCG015
      ** Access Switchable Features file and check if CCG015 is                               CCG015
      ** installed                                                                            CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG015'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CCG015
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
      *                                                                                       CCG015
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     19            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
     C                   ENDIF
      *                                                                                       CLE028
      ** Check if Flat Rate Personal Loans (Rule of 78s) is installed.                        CLE028
      *                                                                                       CLE028
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      'CLE028'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C*                                                                                       CLE028
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CLE028            1
     C                   ELSE
     C                   MOVE      'N'           CLE028
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CLE028'      W0KEY
     C                   Z-ADD     20            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE028
      ** Access Switchable Features file and check if CLE031 is                               CLE031
      ** installed                                                                            CLE031
      *                                                                                       CLE031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CLE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE031
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CLE031            1
     C                   ELSE
     C                   MOVE      'N'           CLE031
      *                                                                                       CLE031
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     20            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE036
      ** Check if CLE036 is installed.                                                        CLE036
      *                                                                                       CLE036
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CLE036'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE036
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE036            1
     C                   ELSE
     C                   MOVE      'N'           CLE036
      *                                                                                       CLE036
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     21            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CLE036
     C                   ENDIF
     C*                                                                   CEU014
     C/COPY WNCPYSRC,CG6005C013
     C**  Copyright Statement.
     C*
     C                   MOVEA     CPY@          ACT@             80
     C/COPY WNCPYSRC,CG6005C002
      *                                                                                       CER038
      ** Check if CER038 is ON                                                                CER038
      *                                                                                       CER038
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*KEY    '    ##OPTN            7
     C                   PARM      'CER038'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER038
     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CER038            1
     C                   ELSE
     C                   MOVE      'N'           CER038
     C                   ENDIF
      *                                                                                       CER038
      ** Check if CLE143 is ON                                                                CLE143
      *                                                                                       CLE143
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY '    ##OPTN
     C                   PARM      'CLE143'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE143
     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE143            1
     C                   ELSE
     C                   MOVE      'N'           CLE143
     C                   ENDIF
     C/COPY WNCPYSRC,CGH00020
      *                                                                                       CLE143
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *                                                                                     BUG23004
     C     ##RTCD        IFNE      *BLANKS
      *                                                                                     BUG23004
      ** Database error                                                                     BUG23004
      *                                                                                     BUG23004
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ************
     C                   Z-ADD     20            W0ERNB                         * DB ERROR 2
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                     BUG23004
      ** Call access program for message details                                            BUG23004
      *                                                                                     BUG23004
     C     BGSWCL        IFEQ      'Y'
     C                   CALL      'AOMGMER0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMGME        PARM      SDMGME        DSFDY
      *                                                                                     BUG23004
     C     ##RTCD        IFNE      *BLANKS
      *                                                                                     BUG23004
      ** Database error                                                                     BUG23004
      *                                                                                     BUG23004
     C                   MOVEL     'AOMGMER0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ************
     C                   Z-ADD     24            W0ERNB                         * DB ERROR 2
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG23004
      ** Call access program for trading data details                                       BUG23004
      *                                                                                     BUG23004
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *                                                                                     BUG23004
     C     ##RTCD        IFNE      *BLANKS
      *                                                                                     BUG23004
      ** Database error                                                                     BUG23004
      *                                                                                     BUG23004
     C                   MOVEL     'AOTRADR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ************
     C                   Z-ADD     22            W0ERNB                         * DB ERROR 2
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CRE073
      ** Check if CRE073 is ON                                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY '    ##OPTN
     C                   PARM      'CRE073'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CRE073
     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE073            1
     C                   ELSE
     C                   MOVE      'N'           CRE073
     C                   ENDIF
      *                                                                                       CRE073
      ** Check if CER049 is installed.                                                        CER049
      *                                                                                       CER049
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER049'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER049
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CER049            1
     C                   ELSE
     C                   MOVE      'N'           CER049
      *                                                                                       CER049
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     31            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CER049
     C                   ENDIF
      *                                                                                     MD029242
      ** If CER038 is switched on, check if Suppress Correspondence for                     MD029242
      ** Customer with Swift ID is 'Y/N'                                                    MD029242
      *                                                                                     MD029242
     C     CER038        IFEQ      'Y'
     C                   MOVEL     *BLANKS       SUPCON            1
     C                   CALL      'AOSVALR0'
     C                   PARM                    P@RTCD            7
     C                   PARM      #SUPRS        P@OP01           20
     C     SVAL1         PARM                    P@VL01          200
     C                   PARM      *BLANK        P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM      *BLANK        P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM      *BLANK        P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM      *BLANK        P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM      *BLANK        P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM      *BLANK        P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM      *BLANK        P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM      *BLANK        P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM      *BLANK        P@OP10           20
     C                   PARM                    P@VL10          200
      *                                                                                     MD029242
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SDSVALPD'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 50 *
     C                   Z-ADD     50            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                     MD029242
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     SVAL11        SUPCON
     C                   ENDIF
      *                                                                                     MD029242
     C                   ENDIF
      *                                                                                       CER049
      ** Access SAR details file to determine if CER050 is installed.                         CER050
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CER050'      ##SARD            6
      *                                                                                       CER050
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CER050            1
     C                   ELSE
     C                   MOVEL     'N'           CER050
     C                   END
      *                                                                                       CER050
      ** Check if CLE141 is installed.                                                        CLE141
      *                                                                                       CLE141
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE141'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE141
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE141            1
     C                   ELSE
     C                   MOVE      'N'           CLE141
     C                   ENDIF
     C*
      *                                                                                     MD035545
      ** Retrieve system value setting                                                      MD035545
      *                                                                                     MD035545
     C                   MOVEL     WPARML        P@OP01
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       W0RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200
      *                                                                                     MD035545
      ** If system value is not found then default value to 'N'                             MD035545
      *                                                                                     MD035545
     C     W0RTCD        IFNE      '       '
     C                   MOVE      'N'           WCALC6
     C                   ELSE
     C                   MOVEL     P@VL01        WCALC6
     C********** WCALC6    IFEQ 'Y'                                                MD035545 MD047993
     C********** BKALDI    ANDEQ'Y'                                                MD035545 MD047993
     C**********           MOVE 'Y'       WCALC6                                   MD035545 MD047993
     C**********           ELSE                                                    MD035545 MD047993
     C**********           MOVE 'N'       WCALC6                                   MD035545 MD047993
     C**********           ENDIF                                                   MD035545 MD047993
     C                   ENDIF
     C     EXINIT        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRINI9        ENDSR                                                  ** SRINI9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRADTA                                        *
     C*  Function    :  Accumulate RDEs and Associated Data           *
     C*                                                               *
     C*  Called by   :  LOAN   - Process Loan Details                 *
     C*                 L@ROL  - Process Rollover Details             *
     C*                 L@REP  - Process Repayment Details            *
     C*                 L@IPY  - Process Interest Payment Details     *
     C*                 L@GUAR - Process Guarantee Details            *
     C*  Calls       :  CG3999 - Pack/Unpack Extracted Data           *
     C*                 SRRFMN - Reformat RDE Data                    *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRADTA        BEGSR                                                  ** SRADTA **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRADTA'      @STK(Q)
     C*
     C**  Reformat RDE data.
     C*
     C                   EXSR      SRRFMN
     C*
     C**  Pack RDEs and associated data into data string.
     C*
     C                   CLEAR                   ##SDS
      *                                                                                       CCG015
      ** If CCG015 is installed, value of W0ACT is '*NEWARR'                                  CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    W0ACT
     C                   MOVEL     *BLANK        W0SPAT
     C                   ENDIF
      *                                                                                       CCG015
     C                   CALL      'CG3999'
     C                   PARM      *BLANK        ##RTCD
     C**********           PARM '*PACK   'W0ACT                                               CCG015
     C                   PARM                    W0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'CG3999  '    W0FILE                         ************
     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 10 *
     C                   Z-ADD     10            W0ERNB                         ************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   EXSR      WRTRDE
     C*
     C**  Append Data from pack routine.
     C*
     C     #@SDS         CAT       ##SDS:0       #@SDS
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
     C*
     C     EXADTA        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRADT9        ENDSR                                                  ** SRADT9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRODTA                                        *
     C*  Function    :  Output Accumulated Data to CGUDTAPD           *
     C*                                                               *
     C*  Called by   :  LOAN   - Process Loan Details                 *
     C*                 L@ROL  - Process Rollover Details             *
     C*                 L@REP  - Process Repayment Details            *
     C*                 L@IPY  - Process Interest Payment Details     *
     C*                 L@GUAR - Process Guarantee Details            *
     C*  Calls       :  CG9020 - Write Data to UDC Extract Files      *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRODTA        BEGSR                                                  ** SRODTA **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRODTA'      @STK(Q)
     C*
     C**  Initialise Write Format Parameter.
     C*
     C                   CLEAR                   W0FMT
     C*
     C**  Set up Control Information.
     C*
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     ##PBIN        DEPBIN
     C                   Z-ADD     ##TBIN        DETBIN
     C                   MOVE      'FR'          DEFSLI
     C/COPY WNCPYSRC,CG6005C008
     C                   MOVE      *BLANKS       W0PATH
     C/COPY WNCPYSRC,CG6005C009
     C                   MOVEL     S#PATH        W0PATH
     C*
     C**  Append Data from pack routine.
     C*
     C     W0FMT         CAT       #@SDS:0       W0FMT
     C*
     C**  Output PF/CGUDTAPD Record.
     C*
     C     CCG015        IFEQ      'N'
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*WRITE  '    W0ACT
     C                   PARM                    W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM      *BLANK        W0TITL            7
     C                   PARM      *BLANK        W0ULIN            7
     C                   PARM                    W0CMT
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'CG9020  '    W0FILE                         ************
     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 11 *
     C                   Z-ADD     11            W0ERNB                         ************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C*
     C                   CLEAR                   #@SDS
     C*
     C     EXODTA        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRODT9        ENDSR                                                  ** SRODT9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRBIND                                        *
     C*  Function    :  Generate Binding Numbers                      *
     C*                                                               *
     C*  Called by   :  All Repeating Group Set Subroutines           *
     C*  Calls       :  None                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRBIND        BEGSR                                                  ** SRBIND **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRBIND'      @STK(Q)
     C*
     C     P1            SUB       1             P2
     C*
     C     P2            OCCUR     ##BIND
     C                   Z-ADD     ##TBIN        #@TBIN
     C*
     C     P1            OCCUR     ##BIND
     C                   Z-ADD     #@TBIN        ##PBIN
     C                   ADD       1             #@BIND
     C                   Z-ADD     #@BIND        ##TBIN
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRBIN9        ENDSR                                                  ** SRBIN9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRPATH                                        *
     C*  Function    :  Generate Path String                          *
     C*                                                               *
     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
     C*                 LOAN   - Process Loan Details                 *
     C*                 L@ROL  - Process Rollover Details             *
     C*                 L@REP  - Process Repayment Details            *
     C*                 L@IPY  - Process Interest Payment Details     *
     C*                 L@GUAR - Process Guarantee Details            *
     C*                 LOANA  - Loan Associated Details              *
     C*  Calls       :  None                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRPATH        BEGSR                                                  ** SRPATH **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)
     C*
     C                   CLEAR                   S#PATH
     C*
     C**  Set up Path.
     C*
     C                   DO        P1            P2
     C     P2            OCCUR     ##PATH
     C     S#PATH        CAT       '\':0         S#PATH
     C     S#PATH        CAT       ##GRPS:0      S#PATH
     C                   END
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRPAT9        ENDSR                                                  ** SRPAT9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRRFMN                                        *
     C*  Function    :  Reformat RDE Data                             *
     C*                                                               *
     C*  Called by   :  SRADTA - Accumulate RDEs and Associated Data  *
     C*  Calls       :  None                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRRFMN        BEGSR                                                  ** SRRFMN **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRRFMN'      @STK(Q)
     C*
     C                   Z-ADD     0             #1
     C*
     C**  Loop through RDE's and data.
     C*
     C     #1            DOUEQ     20
     C*
     C                   ADD       1             #1
     C                   MOVEL     ##R(#1)       R#DEFN
     C                   MOVEL     ##D(#1)       R#DATA
     C*
     C**  If data present and RDE is edited.
     C*
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
     C*
     C**  Reformat Amount.
     C*
     C                   Z-ADD     1             #2
     C     *BLANK        LOOKUP    ##NUMA(#2)                             99    *
     C                   Z-ADD     20            #3
     C                   Z-ADD     0             ##WNUM
     C*
     C     #2            DOWGT     1
     C     #2            ANDLE     20
     C     #3            ANDGT     1
     C                   SUB       1             #2
     C                   MOVEL     ##NUMA(#2)    ##W(#3)
     C                   SUB       1             #3
     C                   ENDDO
     C*
     C**  Sign the amount.
     C*
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     ##WNUM        ##NUMB
     C                   ELSE
     C                   Z-ADD     ##WNUM        ##NUMB
     C                   END
     C*
     C**  Default Edit Type.
     C*
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   END
     C*
     C**  Default Decimal Places.
     C*
     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   END
     C*
     C**  New RDE data.
     C*
     C                   MOVEL     R#DATA        ##D(#1)
     C*
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C     EXRFMN        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRRFM9        ENDSR                                                  ** SRRFM9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRDCDT                                        *
     C*  Function    :  Determine Currency Details                    *
     C*                                                               *
     C*  Called by   :  LOAN   - Process Loan Details                 *
     C*                 L@REP  - Process Repayment Details            *
     C*                 SRINIT - Initial Processing - On First Call   *
     C*  Calls       :  AOCURRRO - Retrive Currency Details           *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRDCDT        BEGSR                                                  ** SRDCDT **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
     C*
     C**  Access array of Currency Details already loaded.
     C*
     C                   Z-ADD     1             C                 3 0
     C     ##CCY         LOOKUP    ##CY(C)                                99
     C*
     C**  If no match is found determine the next free space in the
     C**  loaded currency array.
     C*
     C     *IN99         IFEQ      *OFF
     C*
     C                   Z-ADD     1             C
     C     *BLANK        LOOKUP    ##CY(C)                                99
     C*
     C**  If no space is left, set the Currency Data data structure to
     C**  the 101st occurrence so that when the new details are
     C**  retrieved no existing details are overwritten.
     C*
     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR
     C*
     C**  If a space is found, set up the new currency into the array
     C**  and position the Currency Data data structure on the
     C**  occurrence matching the array index.
     C*
     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
     C*
     C**  Retrieve the currency details.
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C                   PARM      ##CCY         ##CCYP            3            I:Currency Code
     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY                          ************
     C                   Z-ADD     12            W0ERNB                         * DBERR 12 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C**  If the currency has been retrieved earlier, position the
     C**  Currency Data data structure on the relevant occurrence.
     C*
     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF
     C/COPY WNCPYSRC,CG6005C004
     C*
     C     EXDCDT        TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRDCD9        ENDSR                                                  ** SRDCD9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRICAL                                        *
     C*  Function    :  Calculate Interest                            *
     C*                                                               *
     C*  Called by   :  LOAN   - Process Loan Details                 *
     C*  Calls       :  ZFLAC  - Calculate End Date                   *
     C*                 GLINTC - Calculate Interest Between any 2     *
     C*                          day numbers                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRICAL        BEGSR                                                  ** SRICAL **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRICAL'      @STK(Q)
      *                                                                                       CLE028
      ** If Flat Rate Personal Loans (Rule of 78s) is installed,                              CLE028
      ** Gross Interest of flat rate personal loans is computed as per                        CLE028
      ** the Rule of 78s.  GROSS INTEREST is equal to Total Flat Interest                     CLE028
      *                                                                                       CLE028
     C     CLE028        IFEQ      'Y'
     C     ##PTYP        ANDEQ     80
      *                                                                                       CLE028
     C                   Z-ADD     ##FLTI        ZINTR
      *                                                                                       CLE028
     C                   ELSE
      *                                                                                       CLE028
     C*
     C                   Z-ADD     ##VDAT        ZIBEG
     C                   Z-ADD     ##ICBS        ZICALC
     C                   Z-ADD     ##CPAM        ZIAMT
     C                   Z-ADD     ##INTR        ZIRATE
     C**********           Z-ADD##VDAT    ZVDAT                                               245082
     C                   Z-ADD     ##MDAT        ZMDAT
     C                   Z-ADD     0             ZIEND
     C*
     C     ##REPT        IFNE      1
     C     ##REPT        ANDNE     3
      *                                                                                       245914
     C**  If repayment schedule exists for the loan, use the repayment
     C**  value date.
     C*
     C     ##RPDT        IFGT      0
     C                   Z-ADD     ##RPDT        ZIEND
     C                   Z-ADD     0             ##RPDT
     C**********           ELSE                                                               245914
     C                   END
     C*
     C**  else, if repayment date is not zero, use repayment date.                            245914
     C*                                                                                       245914
     C     ##NRPD        IFGT      0
     C     ##NRPD        IFLT      ZIEND
     C     ZIEND         OREQ      0
     C                   Z-ADD     ##NRPD        ZIEND
     C                   END
     C                   END
     C*                                                                                       245914
     C**  else, if rollover date is not zero, use rollover date.
     C*
     C     ##RLDT        IFGT      0
     C     ##RLDT        IFLT      ZIEND
     C     ZIEND         OREQ      0
     C                   Z-ADD     ##RLDT        ZIEND
     C**********           ELSE                                                               245914
     C                   END
     C                   END
     C*
     C**  else,if interest pay date is not zero, use interest pay date.
     C*
     C     ##NIDT        IFGT      0
     C                   Z-ADD     ##NIDT        ZIEND
     C**********           ELSE                                                               245914
     C                   END
     C*
     C**  else, use maturity date.
     C*
     C     ZIEND         IFEQ      0
     C                   Z-ADD     ##MDAT        ZIEND
     C                   END
     C**********           END                                                                245914
     C**********           END                                                                245914
     C*                                                                                       245914
     C                   ELSE
     C*                                                                                       245914
     C** If repayment type 1 or 3                                                             245914
     C*                                                                                       245914
     C**  If repayment schedule exists for the loan, use the repayment                        245914
     C**  value date.                                                                         245914
     C*                                                                                       245914
     C     ##RPDT        IFGT      0
     C                   Z-ADD     ##RPDT        ZIEND
     C                   Z-ADD     0             ##RPDT
     C                   END
     C*                                                                                       245914
     C**  else, if repayment date is not zero, use repayment date.                            245914
     C*                                                                                       245914
     C     ##NRPD        IFGT      0
     C     ##NRPD        IFLT      ZIEND
     C     ZIEND         OREQ      0
     C                   Z-ADD     ##NRPD        ZIEND
     C                   END
     C                   END
     C*                                                                                       245914
     C**  else, if rollover date is not zero, use rollover date.                              245914
     C*                                                                                       245914
     C     ##RLDT        IFGT      0
     C     ##RLDT        IFLT      ZIEND
     C     ZIEND         OREQ      0
     C                   Z-ADD     ##RLDT        ZIEND
     C                   END
     C                   END
     C*                                                                                       245914
     C**  else,if interest pay date is not zero, use interest pay date.                       245914
     C*                                                                                       245914
     C     ##NIDT        IFGT      0
     C                   Z-ADD     ##NIDT        ZIEND
     C                   END
     C*                                                                                       245914
     C**  else, use maturity date.                                                            245914
     C*                                                                                       245914
     C     ZIEND         IFEQ      0
     C                   Z-ADD     ##MDAT        ZIEND
     C                   END
     C                   ENDIF
     C*
     C                   MOVE      ##ADDI        ADDI              1
      *                                                                                       245914
     C     ZIEND         IFNE      0
      *                                                                                       245914
     C                   EXSR      ZFLAC
     C/COPY WNCPYSRC,CG6005C010
     C                   EXSR      GLINTC
     C/COPY WNCPYSRC,CG6005C011
     C                   ELSE
     C                   Z-ADD     0             ZINTR
     C                   ENDIF
     C                   ENDIF
     C*
     C** Round down interest if required
     C*
     C     ##RDFC        IFEQ      'Y'
     C     ##PTYP        ANDNE     80
     C                   Z-ADD     ZINTR         ##TINT           13 0
     C                   ELSE
     C                   Z-ADD(H)  ZINTR         ##TINT
     C                   END
     C/COPY WNCPYSRC,CGH00027
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRICA9        ENDSR                                                  ** SRICA9 **
     C*
     C*****************************************************************
     C/SPACE 5                                                            CEU014
      *****************************************************************   CEU014
      * Subroutine  :  D@EURO                                         *   CEU014
      * Function    :  EURO Currency Conversion:                      *   CEU014
      *                Converts P@FRAM in P@FRCY to ##OUTA in P@TOCY. *   CEU014
      * Called by   :  LOAN                                           *   CEU014
      *                                                               *   CEU014
      * Calls       :  EU0200                                         *   CEU014
      *                SRERR                                          *   CEU014
      *****************************************************************   CEU014
     C     D@EURO        BEGSR                                                                 CEU01
      *                                                                   CEU014
     C                   Z-ADD     0             ##OUTA           13 0                         CEU01
     C                   CALL      'EU0200'                                                    CEU01
     C                   PARM      *BLANKS       P@RTCD            7            Return Code    CEU01
     C                   PARM                    P@FRAM           18 3          FROM Ccy AmountCEU01
     C                   PARM                    P@FRCY            3            FROM Currency  CEU01
     C                   PARM                    P@TOCY            3            TO Currency    CEU01
     C                   PARM      0             P@OUTA           15 0          Outright AmountCEU01
     C                   PARM      0             P@INTA           18 3          Interim Amount CEU01
     C                   PARM      0             P@EXRT           15 9          Exchange Rate  CEU01
     C                   PARM      *BLANK        P@MDIN            1            Mult/Div Ind.  CEU01
      *                                                                   CEU014
      ** Database error handling:                                         CEU014
      *                                                                   CEU014
     C     P@RTCD        IFEQ      '*ERROR*'                                                   CEU01
     C                   MOVEL     'EU0200  '    W0FILE                                        CEU01
     C                   MOVEL     '*CALL   '    W0KEY                          ***************CEU01
     C                   Z-ADD     17            W0ERNB                         * DB ERROR 17 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
      *                                                                   CEU014
      ** Otherwise, store amount in settlement currency as ##OUTA         CEU014
      *                                                                   CEU014
     C                   ELSE                                                                  CEU01
     C                   MOVE      P@OUTA        ##OUTA                                        CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU014
     C                   ENDSR                                                                 CEU01
      *****************************************************************   CEU014
     C/EJECT
      *****************************************************************                       CER038
      *  Subroutine  -  SRAUTO                                        *                       CER038
      *  Function    -  Auto transmission processing                  *                       CER038
      *                                                               *                       CER038
      *  Called by   -                                                *                       CER038
      *  Calls       -                                                *                       CER038
      *****************************************************************                       CER038
     C     SRAUTO        BEGSR
      *                                                                                       CER038
      ** Set up subroutine stack name                                                         CER038
      *                                                                                       CER038
     C                   ADD       1             Q
     C                   MOVEL     'SRAUTO'      @STK(Q)
      *                                                                                       CER038
      ** Get Branch Details                                                                   CER038
      *                                                                                       CER038
     C     BRCA          IFNE      ##BRCD
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      BRCA          ##BRCD            3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *                                                                                       CER038
      ** Database error                                                                       CER038
      *                                                                                       CER038
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     BRCA          W0KEY                          ***************
     C                   Z-ADD     27            W0ERNB                         * DB ERROR 27 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *                                                                                       CER038
      ** Get Customer Details for Loan customer number                                        CER038
      ** Get Customer Details for Branch Internal Customer (Sender)                           CER038
      *                                                                                       CER038
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      A8BICN        ##KEY1           10
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *                                                                                       CER038
      ** Database error                                                                       CER038
      *                                                                                       CER038
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY                          ***************
     C                   Z-ADD     28            W0ERNB                          DB ERROR 28 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CER038
      ** Store Booking Branch, Branch Internal Customer Number and Name                       CER038
      *                                                                                       CER038
     C     *LIKE         DEFINE    BRCA          BBBRCA
     C                   MOVEL     BRCA          BBBRCA
     C     *LIKE         DEFINE    BBCUST        BBBICN
     C                   MOVEL     BBCUST        BBBICN
     C     *LIKE         DEFINE    BBCRNM        BICRNM
     C                   MOVEL     BBCRNM        BICRNM
      *                                                                                       CER038
      ** Store : Sender's (i.e. Branch)                                                       CER038
      **             SWIFT TID Address,                                                       CER038
      **             STTX Address                                                             CER038
      **             Telex Address                                                            CER038
      ** (All used in message routing)                                                        CER038
      *                                                                                       CER038
     C                   MOVEL     A8BTID        ##SCSD
     C                   MOVEL     BBSTAD        ##SSTD
     C                   MOVEL     BBTXA1        ##STXA
      *                                                                                       CER038
      ** Get Customer Details for loan customer (Receiver)                                    CER038
      *                                                                                       CER038
     C                   MOVE      *BLANKS       ##KEY1
     C                   MOVEL     ##CNUM        ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1           10
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *                                                                                       CER038
      ** Database error                                                                       CER038
      *                                                                                       CER038
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     ##CNUM        W0KEY                          **************
     C                   Z-ADD     29            W0ERNB                         * DB ERROR 29*
     C                   MOVEL     'MEM5004'     W0MSGD                         **************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CER038
      ** Store Customer Name                                                                  CER038
      *                                                                                       CER038
     C     *LIKE         DEFINE    BBCRNM        CPCRNM
     C                   MOVEL     BBCRNM        CPCRNM
      *                                                                                       CER038
      ** Store : Destination Customer's (i.e. Counterparty)                                   CER038
      **             SWIFT TID Address,                                                       CER038
      **             STTX Address                                                             CER038
      **             Telex Address                                                            CER038
      **             Default Network for MTnnn messages                                       CER038
      ** (All used in message routing)                                                        CER038
      *                                                                                       CER038
     C                   MOVEL     BBCSID        ##DCSD
     C                   MOVEL     BBSTAD        ##DSTD
     C                   MOVEL     BBTXA1        ##DTXA
     C                   MOVEL     BBDNW3        ##DDNW                         *MT300 messages
      *                                                                                       CER038
      ** Determine Message Routing                                                            CER038
      *                                                                                       CER038
     C                   CALL      'CG99DTMR'                           99
     C                   PARM                    ##SCSD           12
     C                   PARM                    ##SSTD           12
     C                   PARM                    ##STXA           10
     C                   PARM                    ##DCSD           12
     C                   PARM                    ##DSTD           12
     C                   PARM                    ##DTXA           10
     C                   PARM                    ##DDNW            6
     C                   PARM      BGMSDL        ##MSDL            1
     C                   PARM      BGMTMI        ##MTMI            1
     C                   PARM      BLSWPY        ##SWPY            1 0
     C                   PARM      BLTXPY        ##TXPY            1 0
     C                   PARM      *BLANKS       ##NETW            6
     C                   PARM      *BLANKS       ##RTCD            7
      *                                                                                       CER038
     C     *IN99         IFEQ      '1'
     C     ##RTCD        ORNE      *BLANKS
      *                                                                                       CER038
      ** Database error                                                                       CER038
      *                                                                                       CER038
     C                   MOVEL     'CG99DTMR'    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 30 *
     C                   Z-ADD     30            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CER038
     C                   EXSR      SRDAUT
     C                   MOVEL     'N'           ##SPPS
     C                   MOVEL     ##AUTO        DRATRM
      *                                                                                       CER038
      ** if auto transmission                                                                 CER038
      *                                                                                       CER038
     C     ##AUTO        IFEQ      'Y'
     C     CER038        ANDEQ     'Y'
     C     SUPCON        ANDEQ     'Y'
      *                                                                                       CER038
      ** set suppress indicator                                                               CER038
      *                                                                                       CER038
     C                   MOVE      'Y'           ##SPPS
      *                                                                                       CER038
     C                   ENDIF
      *                                                                                       CER038
     C     EXAUTO        TAG
      *                                                                                       CER038
      ** Unwind subroutine stack name                                                         CER038
      *                                                                                       CER038
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *                                                                                       CER038
     C                   ENDSR
      *****************************************************************                       CER038
     C/EJECT                                                                                  CER038
      *****************************************************************                       CER038
      *  Subroutine  -  SRDAUT                                        *                       CER038
      *  Function    -  Determine if Auto-Transmission of             *                       CER038
      *                 Confirmation                                  *                       CER038
      *                                                               *                       CER038
      *  Called by   -                                                *                       CER038
      *  Calls       -                                                *                       CER038
      *****************************************************************                       CER038
     C     SRDAUT        BEGSR
      *                                                                                       CER038
      ** Set up subroutine stack name                                                         CER038
      *                                                                                       CER038
     C                   ADD       1             Q
     C                   MOVEL     'SRDAUT'      @STK(Q)
      *                                                                                       CER038
      **********                                                                     CER038 BUG23004
      ***Call*access*program*for*midas*modules*details                               CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C**********           CALL 'AOMMODR0'                                           CER038 BUG23004
     C**********           PARM *BLANKS   ##RTCD                                     CER038 BUG23004
     C**********           PARM '*FIRST  '##OPTN                                     CER038 BUG23004
     C********** SDMMOD    PARM SDMMOD    DSFDY                                      CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C********** ##RTCD    IFNE *BLANKS                                              CER038 BUG23004
      **********                                                                     CER038 BUG23004
      ***Database*error                                                              CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C**********           MOVEL'AOMMODR0'W0FILE                                     CER038 BUG23004
     C**********           MOVEL'*CALL'   W0KEY            ************              CER038 BUG23004
     C**********           Z-ADD20        W0ERNB           * DB ERROR 2              CER038 BUG23004
     C**********           MOVEL'MEM5003' W0MSGD           ************              CER038 BUG23004
     C**********           MOVEL'MIDAS  ' W0MSGF                                     CER038 BUG23004
     C**********           EXSR SRERR                                                CER038 BUG23004
     C**********           END                                                       CER038 BUG23004
      **********                                                                     CER038 BUG23004
      ***Call*access program for message details                                     CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C********** BGSWCL    IFEQ 'Y'                                                  CER038 BUG23004
     C**********           CALL 'AOMGMER0'                                           CER038 BUG23004
     C**********           PARM *BLANKS   ##RTCD                                     CER038 BUG23004
     C**********           PARM '*FIRST  '##OPTN                                     CER038 BUG23004
     C********** SDMGME    PARM SDMGME    DSFDY                                      CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C********** ##RTCD    IFNE *BLANKS                                              CER038 BUG23004
      **********                                                                     CER038 BUG23004
      ***Database error                                                              CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C**********           MOVEL'AOMGMER0'W0FILE                                     CER038 BUG23004
     C**********           MOVEL'*CALL'   W0KEY            ************              CER038 BUG23004
     C**********           Z-ADD24        W0ERNB           * DB ERROR 2              CER038 BUG23004
     C**********           MOVEL'MEM5003' W0MSGD           ************              CER038 BUG23004
     C**********           MOVEL'MIDAS  ' W0MSGF                                     CER038 BUG23004
     C**********           EXSR SRERR                                                CER038 BUG23004
     C**********           END                                                       CER038 BUG23004
     C**********           END                                                       CER038 BUG23004
      **********                                                                     CER038 BUG23004
      ***Call*access program for trading data details                                CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C**********           CALL 'AOTRADR0'                                           CER038 BUG23004
     C**********           PARM *BLANKS   ##RTCD                                     CER038 BUG23004
     C**********           PARM '*FIRST  '##OPTN                                     CER038 BUG23004
     C********** SDTRAD    PARM SDTRAD    DSFDY                                      CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C********** ##RTCD    IFNE *BLANKS                                              CER038 BUG23004
      **********                                                                     CER038 BUG23004
      ***Database error                                                              CER038 BUG23004
      **********                                                                     CER038 BUG23004
     C**********           MOVEL'AOTRADR0'W0FILE                                     CER038 BUG23004
     C**********           MOVEL'*CALL'   W0KEY            ************              CER038 BUG23004
     C**********           Z-ADD22        W0ERNB           * DB ERROR 2              CER038 BUG23004
     C**********           MOVEL'MEM5003' W0MSGD           ************              CER038 BUG23004
     C**********           MOVEL'MIDAS  ' W0MSGF                                     CER038 BUG23004
     C**********           EXSR SRERR                                                CER038 BUG23004
     C**********           END                                                       CER038 BUG23004
     C                   MOVEL     'N'           ##AUTO            1
      *                                                                                       CER038
     C     BGSWCL        IFEQ      'Y'
     C     BGMTCL        OREQ      'Y'
      *                                                                                       CER038
     C     ##NETW        IFNE      'PAPER '
     C     ##NETW        OREQ      'PAPER '
     C     ENFFCR        ANDNE     'Y'
     C                   MOVEL     'Y'           ##AUTO
     C                   END
     C                   END
      *                                                                                       CER038
      **  Unwind subroutine stack name                                                        CER038
      *                                                                                       CER038
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *                                                                                       CER038
     C                   ENDSR
      *                                                                                       CER038
      *****************************************************************                       CER038
     C/EJECT                                                                                  CER038
      *****************************************************************                       CER038
     C/COPY ZSRSRC,ZFLACZ2ILE
     C/EJECT
     C/COPY ZSRSRC,GLINTCZ1LE
     C/EJECT
     C/COPY ZSRSRC,ZDAT10Z2LE                                               126017
     C/EJECT                                                              126017
     C/COPY ZSRSRC,ZINTDYZ2LE
     C/EJECT
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT
     C/COPY CGCPYSRC,CGNWEXILE                                                               CCG015
     C/EJECT                                                                                  CCG015
     C/COPY ZSRSRC,ZCONVZ1ILE                                                                CLE031
     C/EJECT                                                                                  CLE031

** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION                                           CLE031
0000001                                                                                       CLE031
0000010                                                                                       CLE031
0000100                                                                                       CLE031
0001000                                                                                       CLE031
0010000                                                                                       CLE031
0100000                                                                                       CLE031
1000000                                                                                       CLE031
