000100210122     H DEBUG
000200210122      *****************************************************************
000300210122/*STD *  RPGBASEBND                                                   *
000400210122/*EXI *  TEXT('Midas CG Lending commencement confirmations')          *
000500210122     F*****************************************************************
000600210122     F*                                                               *
000700210122     F*  Midas - User Defined Correspondence                          *
000800210122     F*                                                               *
000900210122     F*  CG6005LE - Lending Commencement Confirmations (ILE)          *
001000210122     F*                                                               *
001100210122     F*  Function:  This program extracts data for Commencement       *
001200210122     F*  ( I/C )    Confirmations.                                    *
001300210122     F*  (I/C Term)                                                   *
001400210122     F*                                                               *
001500210122     F*  Called By: CG6000 - Lending Commencement Confirmations Driver*
001600210122     F*                                                               *
001700210122     F*  Calls :    CG3999 - Pack/Unpack Extracted Data               *
001800210122     F*             CG6001 - General Loan Details                     *
001900210122     F*             CG9010 - Create Item Reference Records            *
002000210122     F*             CG9020 - Write Data to UDC Extract Files          *
002100210122     F*                                                               *
002200210122      *  (c) Finastra International Limited 2001                      *
002300210122     F*                                                               *
002400210122      *  Last Amend No. CLE172             Date 23Oct20               *
002500210122      *  Prev Amend No. CSD103             Date 10Aug20               *
002600210122      *                 CER050             Date 16Jun19               *
002700210122      *                 MD046248           Date 27Oct17               *
002800210122      *                 MD047993           Date 23Sep17               *
002900210122      *                 MD035545           Date 11Sep15               *
003000210122      *                 CLE141             Date 08Feb16               *
003100210122      *                 MD029242           Date 25Nov14               *
003200210122      *                 AR996895           Date 25Nov12               *
003300210122      *                 CLE134             Date 01Aug12               *
003400210122      *                 AR322732           Date 23Jul12               *
003500210122      *                 CLE148             Date 23Jul12               *
003600210122      *                 AR822053           Date 29Aug11               *
003700210122      *                 CER049             Date 06Dec10               *
003800210122      *                 CRE073             Date 06Dec10               *
003900210122      *                 CLE143             Date 06Dec10               *
004000210122      *                 263666             Date 01Feb10               *
004100210122      *                 CER059             Date 19Jul10               *
004200210122      *                 BUG23004           Date 21Feb09               *
004300210122      *                 CER016A            Date 19May08               *
004400210122      *                 CER038             Date 19May08               *
004500210122      * Bank Fusion Midas 1.4 Base -----------------------------------*
004600210122      * Midas Plus 1.4 Base 04 ---------------------------------------*
004700210122      *                 246141             Date 26Mar07               *
004800210122      *                 245914             Date 22Feb07               *
004900210122      *                 245082             Date 29Jan07               *
005000210122      *                 164847             Date 30Nov06               *
005100210122      *                 BUG12990           Date 05Jan07               *
005200210122      * Midas Plus 1.3 ----------- Base ------------------------------*
005300210122      *                 242286             Date 25Sep06               *
005400210122      *                 130998             Date 06Jun06               *
005500210122      *                 CSD031             Date 10Apr06               *
005600210122      *                 CSD027             Date 09Dec05               *
005700210122      *                 CLE042             Date 06Sep05               *
005800210122      *                 CLE106             Date 01Aug04               *
005900210122      *                 CLE036             Date 22Sep03               *
006000210122      *                 CIR013             Date 25Apr05               *
006100210122      *                 CSW037A            Date 02May05               *
006200210122      *                 CSD025             Date 11Jan05               *
006300210122      *                 CSW037             Date 15Dec04               *
006400210122      *                 CSW036             Date 15Dec04               *
006500210122      *                 CLE025             Date 20Oct03               *
006600210122      *                 CSC022             Date 24Feb04               *
006700210122      *                 CGL029             Date 01Sep03               *
006800210122      *                 CLE031             Date 05Feb03               *
006900210122      *                 CLE028             Date 27Jun02               *
007000210122      * Midas Release 4.01 -------------------------------------------*
007100210122      *                 CCG015             Date 09Aug01               *
007200210122      *                 177914             Date 14Jan02               *
007300210122      * Midas Release 4 --------------- Base -------------------------*
007400210122      * Midas DBA 3.05 -----------------------------------------------*
007500210122      *                 CSD006             Date 15May01               *
007600210122      *                 CLE011             Date 07Nov00               *
007700210122      * Midas DBA 3.03 -----------------------------------------------*
007800210122      *                 CIR004             Date 20Jan00               *
007900210122      * Midas DBA 3.00 ---------------- Base -------------------------*
008000210122      *                 CEU014             Date 04Jun98               *
008100210122      *                 126017             Date 14Nov97               *
008200210122     F*                 121768             DATE 19FEB98               *
008300210122     F*                 CLE005             DATE 22May97               *
008400210122     F*                 S01408             Date 10JUL96               *
008500210122     F*                 CCG008 *CREATE     Date 30OCT95               *
008600210122     F*                                                               *
008700210122     F*                                                               *
008800210122     F*---------------------------------------------------------------*
008900210122     F*  AMENDMENT HISTORY                                            *
009000210122     F*                                                               *
009100210122      *  CLE172 - Libor Deregulation - Lending                        *
009200210122      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
009300210122      *  CER050 - Annualised Percentage Rate                          *
009400210122      *  MD046248 - Finastra Rebranding                               *
009500210122      *  MD047993 - Modified MD035545. Removed dependency on Accrue   *
009600210122      *             on Last Day indicator.                            *
009700210122      *  MD035545 - LE: Interest Calculation in Leap year. Consider   *
009800210122      *             Accrue on Last Day Indicator for method 6.        *
009900210122      *  CLE141 - Currency and Location Business Day Convention for   *
010000210122      *           Lending Transactions                                *
010100210122      *  MD029242 - System should generate Dealing CM correspondences *
010200210122      *             also for the Customers with SWIFT-Id (suppressed  *
010300210122      *             by CER038)                                        *
010400210122      *           - Created new system value to condition the         *
010500210122      *             suppression of correspondence if customer has     *
010600210122      *             Swift ID                                          *
010700210122      *  AR996895 - Incorrect accrual interest calculation            *
010800210122      *             (Child: AR996897) (Recompile)                     *
010900210122      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
011000210122      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
011100210122      *           - Prevent LTRIX RRN 1 from being locked (Recompile) *
011200210122      *  CLE148 - Alpha Loan Reference                                *
011300210122      *  AR822053 - Incorrect value of Effective Annual Interest Rate *
011400210122      *             in CGUXMLPD                                       *
011500210122      *  CER049 - Stamp Tax (Portuguese Features Upgrade)             *
011600210122      *  CRE073 - Portuguese Feature - Interest Rate Rounding         *
011700210122      *  CLE143 - Original Loan Contract Date & Effective Interest    *
011800210122      *           Rate                                                *
011900210122      *  263666 - Recompiled due to changes in ZINTDYZ2               *
012000210122      *  CER059 - German Feature Upgrade to Delhi                     *
012100210122      *  BUG23004 - The counterparty is a SWIFT participant and still *
012200210122      *            a paper confirmation has been produced             *
012300210122      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
012400210122      *            to Midas Plus (Recompile)                          *
012500210122      *  CER038 - Additional fields added to Correspondence           *
012600210122      *  246141 - Recompiled due to changes in ZINTDYZ2               *
012700210122      *  245914 - Review interest calculation.                        *
012800210122      *  245082 - Loans with first and last day accrual should be     *
012900210122      *           treated as first day accruals until maturity        *
013000210122      *           date.  Then add one day on the maturity date.       *
013100210122      *           Applied fix 235784 from Release 4.                  *
013200210122      *  164847 - Recompile over changes in /COPY ZINTDYZ2.           *
013300210122      *  BUG12990 - Recompiled due to changes in ZINTDYZ2/ZINTDYZ2LE  *
013400210122      *  242286 - Recompile over changes in /COPY ZINTDYZ2.           *
013500210122      *  130998 - If not using extended settlements use old fields.   *
013600210122      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
013700210122      *  CSD027 - Conversion Of Customer Number to Alpha              *
013800210122      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
013900210122      *  CLE106 - Syndications Manager. (Recompile)                   *
014000210122      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2 - Specific Base Rate*
014100210122      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
014200210122      *           Recompile over GLINTC and ZINTDY.                   *
014300210122      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
014400210122      *  CSD025 - Customer De-Activation                              *
014500210122      *  CSW037 - Additional Field Data on MT300/MT320                *
014600210122      *  CSW036 - Dual SWIFT BIC held on Client Details               *
014700210122      *  CLE025 - Credit Lines (Recompile)                            *
014800210122      *  CSC022 - Commitment Control Changes for MidasPlus            *
014900210122      *           (Recompile)                                         *
015000210122      *  CGL029 - Increase Account Code to 10 digits                  *
015100210122      *  CLE031 - Lending Enhancements.                               *
015200210122      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
015300210122      *  CCG015 - Correspondence Manager Phase 1                      *
015400210122      *  177914 - Confirmation reflected 0 interest. Calculate        *
015500210122      *           interest whatever the repayment type is.            *
015600210122      *  CSD006 - Use DSSDY for call to AOBSTRR0.                     *
015700210122      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
015800210122      *           Recompile                                           *
015900210122      *  CIR004 - Dealing Calculation Method Change.                  *
016000210122      *         - Recompiled due to GLINTC and ZINTDY changes         *
016100210122     F*  CEU014 - EMU User Defined Correspondence Changes.            *
016200210122     F*  126017 - Correction to interest calculation for calculation  *
016300210122     F*           basis 6 in SR/GLINTC. Add SR/ZDAT10                 *
016400210122     F*  121768 - Recompile over changed GLINTCZ1                     *
016500210122     F*  CLE005 - Customer Lending Enhancements - Others (T3)         *
016600210122     F*  S01408 - Core hook CG6005CCP1 added.                         *
016700210122     F*           Core hook CG6005CCP2 added.                         *
016800210122     F*  CCG008 - User Defined Correspondence - Lending               *
016900210122     F*                                                               *
017000210122     F*****************************************************************
017100210122     F*
017200210122     FCLOAN     IF   E           K DISK
017300210122     F                                     IGNORE(CLOANHHF)
017400210122     F                                     IGNORE(CLOANZ1F)
017500210122     F                                     INFSR(SRFILE)
017600210122     FLOAMS     IF   E           K DISK                                         S01518
017700210122     F                                     IGNORE(LOAMSDHF)
017800210122     F                                     IGNORE(LOAMSZ1F)
017900210122     F                                     INFSR(SRFILE)
018000210122      *                                                                                       CER049
018100210122      ** Stamp Tax file                                                                       CER049
018200210122      *                                                                                       CER049
018300210122     FCLONCLL1  IF   E           K DISK
018400210122      *                                                                                       CER050
018500210122     FLEAPRHI0  IF   E           K DISK
018600210122      *                                                                                       CER050
018700210122     F*
018800210122     F/COPY WNCPYSRC,CG6005F001
018900210122      /TITLE FUNCTION OF INDICATORS
019000210122     F*****************************************************************
019100210122     F*                                                               *
019200210122     F*  F U N  C T I O N    O F    I N D I C A T O R S               *
019300210122     F*                                                               *
019400210122     F*  90         Poffered for READE LOOPS                          *
019500210122     F*  99         General error indicator                           *
019600210122     F*                                                               *
019700210122     F*****************************************************************
019800210122      /TITLE SUBROUTINE INDEX
019900210122     F*****************************************************************
020000210122     F*                                                               *
020100210122     F*  S U B R O U T I N E    I N D E X                             *
020200210122     F*                                                               *
020300210122     F*  Main routine                                                 *
020400210122     F*  SRMAIN  -  Main Processing                                   *
020500210122     F*  SRDETL  -  Obtain Detail Information                         *
020600210122     F*  L01CC   -  Lending Commencement Confirmations                *
020700210122     F*  LOANA   -  Loan Associated Details                           *
020800210122     F*  LOAN    -  Process Loan Details                              *
020900210122     F*  L@ROL   -  Process Rollover Details                          *
021000210122     F*  L@REP   -  Process Repayment Details                         *
021100210122     F*  L@IPY   -  Process Interest Payment Details                  *
021200210122     F*  L@GUAR  -  Process Guarantee Details                         *
021300210122     F*  SRSDET  -  Set-up Settlement Details                         *
021400210122     F*  SRINZF  -  Initialise Fields on Each Invocation              *
021500210122     F*  SRINIT  -  Initial Processing - On First Call                *
021600210122     F*  SRADTA  -  Accumulate RDEs and Associated Data               *
021700210122     F*  SRODTA  -  Output Accumulated Data to CGUDTAPD               *
021800210122     F*  SRBIND  -  Generate Binding Numbers                          *
021900210122     F*  SRPATH  -  Generate Path String                              *
022000210122     F*  SRRFMN  -  Reformat RDE Data                                 *
022100210122     F*  SRDCDT  -  Determine Currency Details                        *
022200210122     F*  SRGENR  -  Generate Reference Number                         *
022300210122     F*  SRICAL  -  Calculate Interest                                *
022400210122     F*  ZFLAC   -  Calculate End Date                                *
022500210122     F*  GLINTC  -  Calculate Interest Between any 2 day numbers      *
022600210122     F*  AOBANKR0 - Retrive Bank Details                              *
022700210122     F*  AOBRCHRO - Retrive Branch Details                            *
022800210122     F*  AOBSRTRO - Retrive Base Rate Code Details                    *
022900210122     F*  AOCURRRO - Retrive Currency Details                          *
023000210122     F*  AOCUSTR0 - Retrieve Customer Details                         *
023100210122     F*                                                               *
023200210122     F*****************************************************************
023300210122     D/EJECT
023400210122     D*
023500210122     D**  Copyright array.
023600210122     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
023700210122     D*
023800210122     D/COPY CGCPYSRC,CGPACKDLE
023900210122     D/COPY CGCPYSRC,SRERRDLE
024000210122     D/COPY ZSRSRC,ZINTDYZ1LE
024100210122     D/COPY ZSRSRC,ZDATE9Z2LE
024200210122     D/COPY ZSRSRC,ZDAT10Z1LE
024300210122     D*
024400210122     D**  Array of Currencies accessed by program
024500210122     D ##CY            S              3    DIM(100)
024600210122     D*
024700210122     D/COPY ZSRSRC,ZDATE9Z1LE
024800210122     D*
024900210122     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
025000210122     D*
025100210122     D CPYR            DS
025200210122     D**  Data Structure for Compilation - Copyright Insertion
025300210122     D  ##CPY                  1     80
025400210122     D*
025500210122     D ##SDS           DS
025600210122      *
025700210122     D #@SDS           DS
025800210122     D**  Packed data string.
025900210122     D  #@S                 5632   5632
026000210122     D*
026100210122     D                 DS
026200210122     D**  Number Field
026300210122     D  ##W                    1     20
026400210122     D                                     DIM(20)
026500210122     D  ##WNUM                 1     20  0
026600210122     D                 DS
026700210122     D** Used to convert item reference from character to numeric
026800210122     D  ##ITMA                 1      8
026900210122     D  ##ITEM                 1      8  0
027000210122     D*
027100210122     D                 DS
027200210122     D  ##NCIT                 1      6
027300210122     D  NMCY                   1      3
027400210122     D  SITP                   4      6
027500210122     D                 DS
027600210122     D  ##CCCC                 1      5
027700210122     D  ##CCY                  1      3
027800210122     D  ##CCD                  4      5
027900210122     D*
028000210122     D**  Loan details parameter for call to CG99LSET.
028100210122     D*
028200210122     D PDETLS          DS           256
028300210122     D* Currency
028400210122     D  ##CCY1                 1      3
028500210122     D* Customer Number
028600210122     D  ##CNUM                 4      9
028700210122     D* Branch
028800210122     D  ##BRCA                10     12
028900210122     D*
029000210122     D**  Settlement Instructions Parameter for call to CG99LSET.
029100210122     D*
029200210122     D P0PARM          DS           768
029300210122     D**  Pay - Branch
029400210122     D  P0POBR                 1      3
029500210122     D**  Receipt - Branch
029600210122     D  P0ROBR                 4      6
029700210122     D**  Receipt - Settlement Method
029800210122     D  P0RSTM                 7      8  0
029900210122     D**  Receipt - Our Nostro
030000210122     D  QQRONS                 9     20
030100210122     D**  Receipt - Intermediary Bank
030200210122     D  P0RIBN                21     28
030300210122     D**  Receipt - Intermediary Bank a/c
030400210122     D  P0RIBA                29     63
030500210122     D**  Receipt - Ordering Bank No.
030600210122     D  P0ROBN                64     69
030700210122     D**  Receipt - Ordering Customer
030800210122     D  P0ROCN                70     75
030900210122     D**  Pay - Settlement Method
031000210122     D  P0PSTM                76     77  0
031100210122     D**  Pay - Our Nostro
031200210122     D  QQPONS                78     89
031300210122     D**  Pay - Intermediary Bank
031400210122     D  P0PIBN                90     97
031500210122     D**  Pay - Intermediary Bank a/c
031600210122     D  P0PIBA                98    132
031700210122     D**  Pay - Ordering Bank No.
031800210122     D  P0POBN               133    138
031900210122     D**  Pay - Ordering Customer No.
032000210122     D  P0POCN               139    144
032100210122     D**  Receiver Correspondent No.
032200210122     D  P0RCRN               145    152
032300210122     D**  Receiver Correspondent A/C 1
032400210122     D  P0RCRA               153    187
032500210122     D**  Receiver Number
032600210122     D  P0RVNO               188    195
032700210122     D**  A/C with Bank No.
032800210122     D  P0AWBN               196    203
032900210122     D**  A/C with Bank A/C Line
033000210122     D  P0AWBA               204    238
033100210122     D**  Beneficiary No.
033200210122     D  P0BENN               239    246
033300210122     D**  Beneficiary A/C Line
033400210122     D  P0BENA               247    281
033500210122     D**  Details of Pay 1
033600210122     D  P0DTP1               282    316
033700210122     D**  Details of Pay 2
033800210122     D  P0DTP2               317    351
033900210122     D**  Details of Pay 3
034000210122     D  P0DTP3               352    386
034100210122     D**  Details of Pay 4
034200210122     D  P0DTP4               387    421
034300210122     D**  Details of Charges
034400210122     D  P0DCHG               422    424
034500210122     D**  Bank to Bank Info 1
034600210122     D  P0BTB1               425    459
034700210122     D**  Bank to Bank Info 2
034800210122     D  P0BTB2               460    494
034900210122     D**  Bank to Bank Info 3
035000210122     D  P0BTB3               495    529
035100210122     D**  Bank to Bank Info 4
035200210122     D  P0BTB4               530    564
035300210122     D**  Bank to Bank Info 5
035400210122     D  P0BTB5               565    599
035500210122     D**  Bank to Bank Info 6
035600210122     D  P0BTB6               600    634
035700210122     D**  Special Instruction 1
035800210122     D  P0SPI1               635    664
035900210122     D**  Special Instruction 2
036000210122     D  P0SPI2               665    694
036100210122     D**  Special Instruction 3
036200210122     D  P0SPI3               695    724
036300210122     D**  Settlement Currency                                             CEU014
036400210122     D  P0STCY               725    727                                         CEU014
036500210122     D  P0PSCY               728    730
036600210122     D  P0RONS               731    748
036700210122     D  P0PONS               749    766
036800210122     D*
036900210122     D**  UDC Details
037000210122     D*
037100210122     D P1PARM          DS           256
037200210122     D**  Output Sequence
037300210122     D  P1OSEQ                 1      9  0
037400210122     D**  UDC item number
037500210122     D  P1ITEM                10     17  0
037600210122     D**  This bind level
037700210122     D  P1TBIN                18     25  0
037800210122     D**  Previous bind level
037900210122     D  P1PBIN                26     33  0
038000210122     D*
038100210122     D**  Loan details Parameters for call to CG6001.
038200210122     D*
038300210122     D P@PARM          DS           256
038400210122     D**  Loan Reference
038500210122     D  P@LNRF                 1      6
038600210122     D**  Cancel/Amend Field
038700210122     D  P@CNAM                 7      7
038800210122     D*
038900210122     D**  Facility details Parameter for call to CG6001
039000210122     D*
039100210122     D P4PARM          DS           256
039200210122     D**  Facility customer
039300210122     D  P4FCUS                 1      6
039400210122     D**  Facility type
039500210122     D  P4FTYP                 7      9  0
039600210122     D**  Facility Seq
039700210122     D  P4FSEQ                10     11  0
039800210122     D*
039900210122     D**  For error reporting
040000210122     D*
040100210122     D**  Named constants
040200210122     D*
040300210122     D W#PTYP          C                   CONST('LOAN COMMC')
040400210122     D W#PST1          C                   CONST('CALL LOAN ')
040500210122     D W#PST2          C                   CONST('TERM LOAN ')
040600210122     D W#PST3          C                   CONST('DISC LOAN ')
040700210122     D W#PST4          C                   CONST('TERM PA PU')
040800210122     D W#PST5          C                   CONST('DISC PA PU')
040900210122     D W#PST6          C                   CONST('TERM PA SL')
041000210122     D W#PST7          C                   CONST('DISC PA SL')
041100210122     D W#PST8          C                   CONST('GUAR ISSUE')
041200210122     D W#PST9          C                   CONST('CALL PA PU')
041300210122     D W#PS10          C                   CONST('CALL PA SL')
041400210122     D W#PS11          C                   CONST('RISK PA PU')
041500210122     D W#PS12          C                   CONST('RISK P SL1')
041600210122     D W#PS13          C                   CONST('RISK P SL2')
041700210122     D W#PS14          C                   CONST('FLAT LOAN ')
041800210122     D #SUPRS          C                   CONST('SupCorr4CustwSwiftID')
041900210122     D*
042000210122     D DSPARM        E DS                  EXTNAME(LTRIX)
042100210122     D** External DS for parameter passed from CG6000
042200210122     D  ##RCD1       E                     EXTFLD(RCDT)
042300210122     D  ##CHT1       E                     EXTFLD(CHTP)
042400210122     D*
042500210122     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
042600210122     D**  External DS for incomplete reference
042700210122     D*
042800210122     D SDBANK        E DS                  EXTNAME(SDBANKPD)
042900210122     D**  External DS for Bank details
043000210122     D*
043100210122     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
043200210122     D**  External DS for branch details
043300210122     D*
043400210122     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
043500210122     D**  External DS for customer details
043600210122     D  QQDFA1       E                     EXTFLD(QQDFAC)
043700210122     D*
043800210122     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
043900210122     D**  External DS for base rate details
044000210122     D*
044100210122     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
044200210122     D**  External DS for currency details
044300210122     D*
044400210122     D SCSARD        E DS                  EXTNAME(SCSARDPD)
044500210122     D** Switchable Feature details
044600210122     D*
044700210122     D SDGELR        E DS                  EXTNAME(SDGELRPD)
044800210122     D* DS for GL ICD Details
044900210122     D*
045000210122     D DSFDY         E DS                  EXTNAME(DSFDY)
045100210122     D**  First DS for access programs, short data structure
045200210122     D*
045300210122     D DSSDY         E DS                  EXTNAME(DSSDY)
045400210122     D**  Second DS for access programs, long data structure
045500210122     D*
045600210122     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
045700210122     D**  Record format of PF/CGUDTAPD for use as a parameter
045800210122     D*
045900210122     D**  DS to store subroutine specific data.
046000210122     D**  - Saved Path
046100210122     D*
046200210122     D ##PATH          DS                  OCCURS(20)
046300210122     D  ##GRPS                 1      6
046400210122     D*
046500210122     D ##BIND          DS                  OCCURS(20)
046600210122     D  ##PBIN                 1      6  0 INZ(1)
046700210122     D  ##TBIN                 7     12  0 INZ(1)
046800210122     D*
046900210122     D                 DS
047000210122     D  #@BIND                 1      6  0 INZ(1)
047100210122     D*
047200210122     D #PDS            DS
047300210122     D  P1                     1      3  0 INZ(0)
047400210122     D  P2                     4      6  0
047500210122     D  P3                     7      9  0
047600210122     D  P4                    10     12  0
047700210122     D  P5                    13     15  0
047800210122     D*
047900210122     D SVAL1           DS           200
048000210122     D  SVAL11                 1      1
048100210122      *
048200210122     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
048300210122      *
048400210122     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
048500210122      *
048600210122     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
048700210122     D  QQDFA2       E                     EXTFLD(QQACCD)
048800210122     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
048900210122      *
049000210122     D WPARML          C                   CONST('LECalcBasis6LeapYear')
049100210122     I/EJECT
049200210122     I*
049300210122     ICLOANCLF
049400210122     I** Rename fields of CLOANCL
049500210122     I              RECI                        ##RECI
049600210122     I              LNRF                        ##LNRF
049700210122     I              RCDT                        ##RCDT
049800210122     I              MRIN                        ##MRIN
049900210122     I              PTYP                        ##PTYP
050000210122     I              CNUM                        ##CNUM
050100210122     I              BRCA                        ##BRCA
050200210122     I              LTYP                        ##LTYP
050300210122     I              SUTP                        ##SUTP
050400210122     I              DDAT                        ##DDAT
050500210122     I              VDAT                        ##VDAT
050600210122     I              MDAT                        ##MDAT
050700210122     I              LASQ                        ##LASQ
050800210122     I              FCUS                        ##FCUS
050900210122     I              FTYP                        ##FTYP
051000210122     I              FSEQ                        ##FSEQ
051100210122     I              CCY                         ##CCY1
051200210122     I              CPAM                        ##CPAM
051300210122     I              INTC                        ##INTC
051400210122     I              INTR                        ##INTR
051500210122     I              BRTT                        ##BRTT
051600210122     I              BRTE                        ##BRTE
051700210122     I              RTSP                        ##RTSP
051800210122     I              MARG                        ##MARG
051900210122     I              SPIN                        ##SPIN
052000210122     I              CHIN                        ##CHIN
052100210122     I              WTRT                        ##WTRT
052200210122     I              WTIN                        ##WTIN
052300210122     I              REPT                        ##REPT
052400210122     I              RAMT                        ##RAMT
052500210122     I              NRPD                        ##NRPD
052600210122     I              RFRQ                        ##RFRQ
052700210122     I              RDYN                        ##RDYN
052800210122     I              FCCY                        ##FCCY
052900210122     I              LIND                        ##LIND
053000210122     I              CRSK                        ##CRSK
053100210122     I              ACOF                        ##ACOF
053200210122     I              NACD                        ##NACD
053300210122     I              RELI                        ##RELI
053400210122     I              AUTO                        ##AUT1
053500210122     I              PSAM                        ##PSAM
053600210122     I              BCXR                        ##BCXR
053700210122     I              FCXR                        ##FCXR
053800210122     I              SDST                        ##SDST
053900210122     I              OSDA                        ##OSDA
054000210122     I              TSTN                        ##TSTN
054100210122     I              MDST                        ##MDST
054200210122     I              OMDA                        ##OMDA
054300210122     I              TMAN                        ##TMAN
054400210122     I              FACO                        ##FACO
054500210122     I              RLDT                        ##RLDT
054600210122     I              NROD                        ##NROD
054700210122     I              RLFQ                        ##RLFQ
054800210122     I              RLDY                        ##RLDY
054900210122     I              RDFC                        ##RDFC
055000210122     I              NBRA                        ##NBRA
055100210122     I              NRTS                        ##NRTS
055200210122     I              NSIN                        ##NSIN
055300210122     I              NCAS                        ##NCAS
055400210122     I              AWTP                        ##AWTP
055500210122     I              WTRD                        ##WTRD
055600210122     I              WTWD                        ##WTWD
055700210122     I              IWOD                        ##IWOD
055800210122     I              PWOD                        ##PWOD
055900210122     I              BMDI                        ##BMDI
056000210122     I              FMDI                        ##FMDI
056100210122     I              PDIN                        ##PDIN
056200210122     I              LSWC                        ##LSWC
056300210122     I              LSWS                        ##LSWS
056400210122     I              OSDB                        ##OSDB
056500210122     I              OMDB                        ##OMDB
056600210122     I              ORBR                        ##ORBR
056700210122     I              PRFC                        ##PRFC
056800210122     I              FCLB                        ##FCLB
056900210122     I              MLNR                        ##MLNR
057000210122     I              BTIN                        ##BTIN
057100210122     I              BLDY                        ##BLDY
057200210122     I              OLNO                        ##OLNO
057300210122     I              RCSI                        ##RCSI
057400210122     I              ICBS                        ##ICBS
057500210122     I              IPFR                        ##IPFR
057600210122     I              TOTI                        ##TOTI
057700210122     I              NIDT                        ##NIDT
057800210122     I              IBDT                        ##IBDT
057900210122     I              SLID                        ##SLID
058000210122     I              AIPD                        ##AIPD
058100210122     I              DLRC                        ##DLRC
058200210122     I              IACD                        ##IACD
058300210122     I              AITC                        ##AITC
058400210122     I              TFEP                        ##TFEP
058500210122     I              AIAP                        ##AIAP
058600210122     I              IPRD                        ##IPRD
058700210122     I              IPRM                        ##IPRM
058800210122     I              ICTD                        ##ICTD
058900210122     I              AIMN                        ##AIMN
059000210122     I              RBDT                        ##RBDT
059100210122     I              NOPS                        ##NOPS
059200210122     I              NCHI                        ##NCHI
059300210122     I              IFDY                        ##IFDY
059400210122     I              LONI                        ##LONI
059500210122     I              CNFI                        ##CNFI
059600210122     I              ACEI                        ##ACEI
059700210122     I              TLXI                        ##TLXI
059800210122     I              CBLI                        ##CBLI
059900210122     I              ORED                        ##ORED
060000210122     I              LCD                         ##LCD
060100210122     I              CHTP                        ##CHTP
060200210122     I              TNLU                        ##TNLU
060300210122     I              ADDI                        ##ADDI
060400210122     I              ORMD                        ##ORMD
060500210122     I              ORTI                        ##ORTI
060600210122     I              BOKC                        ##BOKC
060700210122     I              COCU                        ##COCU
060800210122     I              RECE                        ##RECE
060900210122     I              OMDT                        ##OMDT
061000210122     I              NIPD                        ##NIPD
061100210122     I              NMDT                        ##NMDT
061200210122     I              APMI                        ##APMI
061300210122     I              RSTM                        ##RSTM
061400210122     I              RONS                        ##RONS
061500210122     I              RIBN                        ##RIBN
061600210122     I              RIBA                        ##RIBA
061700210122     I              ROBN                        ##ROBN
061800210122     I              ROCN                        ##ROCN
061900210122     I              PSTM                        ##PSTM
062000210122     I              PONS                        ##PONS
062100210122     I              PIBN                        ##PIBN
062200210122     I              PIBA                        ##PIBA
062300210122     I              POBN                        ##POBN
062400210122     I              POCN                        ##POCN
062500210122     I              RCRN                        ##RCRN
062600210122     I              RCRA                        ##RCRA
062700210122     I              RVNO                        ##RVNO
062800210122     I              AWBN                        ##AWBN
062900210122     I              AWBA                        ##AWBA
063000210122     I              BENN                        ##BENN
063100210122     I              BENA                        ##BENA
063200210122     I              DTP1                        ##DTP1
063300210122     I              DTP2                        ##DTP2
063400210122     I              DTP3                        ##DTP3
063500210122     I              DTP4                        ##DTP4
063600210122     I              DCHG                        ##DCHG
063700210122     I              BTB1                        ##BTB1
063800210122     I              BTB2                        ##BTB2
063900210122     I              BTB3                        ##BTB3
064000210122     I              BTB4                        ##BTB4
064100210122     I              BTB5                        ##BTB5
064200210122     I              BTB6                        ##BTB6
064300210122     I              CVMR                        ##CVMR
064400210122     I              PTFR                        ##PTFR
064500210122     I              SCCY                        ##STCY                          CEU014
064600210122     I              ADIF                        ##ADIF
064700210122     I              ADCF                        ##ADCF
064800210122     I              CHGA                        ##CHGA
064900210122     I              ICIF                        ##ICIF
065000210122     I              FLTI                        ##FLTI
065100210122     I              FRPD                        ##FRPD
065200210122     I              REXR                        ##REXR
065300210122     I              REXI                        ##REXI
065400210122     I              PSCY                        ##PSCY
065500210122     I              PEXR                        ##PEXR
065600210122     I              PEXI                        ##PEXI
065700210122     I              BASR                        ##BASR
065800210122     I              NBSR                        ##NBSR
065900210122     I              OCDT                        ##OCDT
066000210122     I              EAIR                        ##EAIR
066100210122     I              CNSP                        ##CNSP
066200210122     I              CNSG                        ##CNSG
066300210122     I              RDMT                        ##RDMT
066400210122     I              RDFD                        ##RDFD
066500210122     I*
066600210122     ICLOANCKF
066700210122     I** Rename fields of CLOANCK
066800210122     I              RECI                        ##RECI
066900210122     I              LNRF                        ##LNRF
067000210122     I              RCDT                        ##RCDT
067100210122     I              MRIN                        ##MRIN
067200210122     I              NAR1                        ##NAR1
067300210122     I              NAR2                        ##NAR2
067400210122     I              NAR3                        ##NAR3
067500210122     I              NAR4                        ##NAR4
067600210122     I              OPAM                        ##OPAM
067700210122     I              FRBC                        ##FRBC
067800210122     I              YPLN                        ##YPLN
067900210122     I              YFLN                        ##YFLN
068000210122     I              YWLN                        ##YWLN
068100210122     I              ABLN                        ##ABLN
068200210122     I              YPLC                        ##YPLC
068300210122     I              YFLC                        ##YFLC
068400210122     I              YWLC                        ##YWLC
068500210122     I              ABLC                        ##ABLC
068600210122     I              WWLN                        ##WWLN
068700210122     I              IWLN                        ##IWLN
068800210122     I              PWLN                        ##PWLN
068900210122     I              RDST                        ##RDST
069000210122     I              SPI1                        ##SPI1
069100210122     I              SPI2                        ##SPI2
069200210122     I              SPI3                        ##SPI3
069300210122     I              YILN                        ##YILN
069400210122     I              F57U                        ##F57U
069500210122     I              ORVD                        ##ORVD
069600210122     I              THRN                        ##THRN
069700210122     I              NPRAM                       ##NPAM
069800210122     I              NDAM                        ##NDAM
069900210122     I              RLBR                        ##RLBR
070000210122     I              ORED                        ##ORED
070100210122     I              LCD                         ##LCD
070200210122     I              CHTP                        ##CHTP
070300210122     I              TNLU                        ##TNLU
070400210122     I*
070500210122     ILOAMSDKF
070600210122     I** Rename fields of LOAMSDK
070700210122     I              VDAT                        ##VDA1
070800210122     I              AMTP                        ##AMT1
070900210122     I/COPY WNCPYSRC,CG6005I001
071000210122     I*
071100210122     C/EJECT
071200210122     C*****************************************************************
071300210122     C*                                                               *
071400210122     C*  Process     :  MAINLINE                                      *
071500210122     C*  Function    :  Mainline Processing                           *
071600210122     C*                                                               *
071700210122     C*  Called by   :  None                                          *
071800210122     C*  Calls       :  SRINIT - Initial Processing - On First Call   *
071900210122     C*                 SRINZF - Initialise Fields on Each Invocation *
072000210122     C*                 SRMAIN - Main Processing                      *
072100210122     C*                                                               *
072200210122     C*****************************************************************
072300210122     C*
072400210122     C**  Parameter list for current program invocation.
072500210122     C*
072600210122     C     *ENTRY        PLIST
072700210122     C                   PARM                    W0RTN             7
072800210122     C                   PARM                    W0CMT             3
072900210122     C                   PARM                    ##COPD            1
073000210122     C                   PARM                    ##AUTO            1
073100210122     C                   PARM                    ##SPPS            1
073200210122     C                   PARM                    DSPARM
073300210122     C*
073400210122     C**  Set up subroutine stack name.
073500210122     C*
073600210122     C                   ADD       1             Q
073700210122     C                   MOVEL     'MAIN'        @STK(Q)
073800210122     C*
073900210122     C**  Initial processing - Once Only.
074000210122     C*
074100210122     C     ##INIT        IFEQ      *BLANK
074200210122     C                   EXSR      SRINIT
074300210122     C                   MOVE      'Y'           ##INIT            1
074400210122     C                   ENDIF
074500210122     C*
074600210122     C**  Initialisation processing.
074700210122     C*
074800210122     C                   EXSR      SRINZF
074900210122     C*
075000210122     C**  Main processing.
075100210122     C*
075200210122     C                   EXSR      SRMAIN
075300210122     C*
075400210122     C**  Unwind subroutine stack name.
075500210122     C*
075600210122     C                   MOVEA     *BLANKS       @STK(Q)
075700210122     C                   SUB       1             Q
075800210122     C*
075900210122     C**  Terminate program.
076000210122     C*
076100210122     C                   RETURN
076200210122     C*
076300210122     C*****************************************************************
076400210122     C/EJECT
076500210122     C*****************************************************************
076600210122     C*                                                               *
076700210122     C*  Subroutine  :  SRMAIN                                        *
076800210122     C*  Function    :  Main Processing                               *
076900210122     C*                                                               *
077000210122     C*  Called by   :  MAINLINE - Mainline Processing                *
077100210122     C*  Calls       :  SRDETL - Obtain Detail Information            *
077200210122     C*                 SRGENR - Generate Reference Number            *
077300210122     C*                 L01CC  - Lending Commencement Confirmations   *
077400210122     C*                                                               *
077500210122     C*****************************************************************
077600210122     C*
077700210122     C     SRMAIN        BEGSR                                                  ** SRMAIN **
077800210122     C*
077900210122     C**  Set up subroutine stack name.
078000210122     C*
078100210122     C                   ADD       1             Q                 5 0
078200210122     C                   MOVEL     'SRMAIN'      @STK(Q)
078300210122     C*
078400210122     C**  Obtain Detail Information.
078500210122     C*
078600210122     C                   EXSR      SRDETL
078700210122     C*
078800210122     C**  Generate reference number by writing to PF/CGUDCRPD.
078900210122     C**  If no confirmation to be produced, then bypass.
079000210122     C*
079100210122     C                   MOVE      'N'           ##COPD
079200210122     C/COPY WNCPYSRC,CG6005C020
079300210122      *                                                                                       CER038
079400210122     C                   MOVE      'N'           ##SPPS
079500210122     C     CER038        IFEQ      'Y'
079600210122     C                   EXSR      SRAUTO
079700210122     C     ##SPPS        IFEQ      'Y'
079800210122     C     ##SPPS        CABEQ     'Y'           EXMAIN
079900210122     C                   ENDIF
080000210122     C                   ENDIF
080100210122      *                                                                                       CER038
080200210122     C                   EXSR      SRGENR
080300210122     C     ##COPD        CABEQ     'N'           EXMAIN
080400210122     C*
080500210122     C**  Extract.
080600210122     C*
080700210122     C                   EXSR      L01CC
080800210122     C*
080900210122     C     EXMAIN        TAG
081000210122     C*
081100210122     C**  Unwind subroutine stack name.
081200210122     C*
081300210122     C                   MOVEA     *BLANKS       @STK(Q)
081400210122     C                   SUB       1             Q
081500210122     C*
081600210122     C     SRMAI9        ENDSR                                                  ** SRMAI9 **
081700210122     C*
081800210122     C*****************************************************************
081900210122     C/EJECT
082000210122     C*****************************************************************
082100210122     C*                                                               *
082200210122     C*  Subroutine  :  SRDETL                                        *
082300210122     C*  Function    :  Obtain Detail Information                     *
082400210122     C*                                                               *
082500210122     C*  Called by   :  SRMAIN - Main Processing                      *
082600210122     C*  Calls       :  None                                          *
082700210122     C*                                                               *
082800210122     C*****************************************************************
082900210122     C*
083000210122     C     SRDETL        BEGSR                                                  ** SRDETL **
083100210122     C*
083200210122     C**  Set up subroutine stack name.
083300210122     C*
083400210122     C                   ADD       1             Q
083500210122     C                   MOVEL     'DETAIL'      @STK(Q)
083600210122     C*
083700210122     C     KCLOAN        KLIST
083800210122     C                   KFLD                    LNRF
083900210122     C                   KFLD                    RCDT
084000210122     C*
084100210122     C                   MOVEL     'A'           RCDT              1
084200210122     C     KCLOAN        CHAIN     CLOAN                              88
084300210122     C     *IN88         IFEQ      '1'
084400210122     C                   MOVEL     'CLOAN   '    W0FILE                         ************
084500210122     C                   MOVEL     LNRF          W0KEY                          * DBERR 01 *
084600210122     C                   Z-ADD     1             W0ERNB                         ************
084700210122     C                   MOVEL     'MEM5004'     W0MSGD
084800210122     C                   MOVEL     'MIDAS  '     W0MSGF
084900210122     C                   EXSR      SRERR
085000210122     C                   END
085100210122     C*
085200210122     C                   MOVEL     'B'           RCDT
085300210122     C     KCLOAN        CHAIN     CLOAN                              88
085400210122     C     *IN88         IFEQ      '1'
085500210122     C                   MOVEL     'CLOAN   '    W0FILE                         ************
085600210122     C                   MOVEL     LNRF          W0KEY                          * DBERR 02 *
085700210122     C                   Z-ADD     2             W0ERNB                         ************
085800210122     C                   MOVEL     'MEM5004'     W0MSGD
085900210122     C                   MOVEL     'MIDAS  '     W0MSGF
086000210122     C                   EXSR      SRERR
086100210122     C                   END
086200210122      *                                                                   CLE005
086300210122      ** If CLE005 is on, for proc. type 72, access CLOANCL to            CLE005
086400210122      ** get the processing type of the loan sold, then rechain           CLE005
086500210122      ** back to using the original loan                                  CLE005
086600210122      *                                                                   CLE005
086700210122     C     ##PTYP        IFEQ      72                                                          CLE00
086800210122     C     CLE005        ANDEQ     'Y'                                                         CLE00
086900210122     C                   MOVE      *BLANK        WOLN70            1                           CLE00
087000210122     C**********           Z-ADDLNRF      WOLNRF  60                                   CLE005 CLE148
087100210122     C                   MOVEL     LNRF          WOLNRF            6
087200210122     C**********           Z-ADD##OLNO    LNRF                                         CLE005 CSD027
087300210122     C                   MOVE      ##OLNO        LNRF
087400210122     C                   MOVEL     'A'           RCDT              1                           CLE00
087500210122      *                                                                   CLE005
087600210122     C     KCLOAN        CHAIN     CLOAN                              88                       CLE00
087700210122     C     *IN88         IFEQ      '1'                                                         CLE00
087800210122     C                   MOVEL     'CLOAN   '    W0FILE                         ************   CLE00
087900210122     C                   MOVEL     LNRF          W0KEY                          * DBERR 13 *   CLE00
088000210122     C                   Z-ADD     13            W0ERNB                         ************   CLE00
088100210122     C                   MOVEL     'MEM5004'     W0MSGD                                        CLE00
088200210122     C                   MOVEL     'MIDAS  '     W0MSGF                                        CLE00
088300210122     C                   EXSR      SRERR                                                       CLE00
088400210122     C                   ENDIF                                                                 CLE00
088500210122      *                                                                   CLE005
088600210122     C     ##PTYP        IFEQ      70                                                          CLE00
088700210122     C                   MOVE      'Y'           WOLN70                                        CLE00
088800210122     C                   ENDIF                                                                 CLE00
088900210122      *                                                                   CLE005
089000210122      ** Rechain CLOANCL to get original loan details                     CLE005
089100210122      *                                                                   CLE005
089200210122     C**********           Z-ADDWOLNRF    LNRF                                         CLE005 CLE148
089300210122     C                   MOVEL     WOLNRF        LNRF
089400210122     C                   MOVEL     'A'           RCDT              1                           CLE00
089500210122      *                                                                   CLE005
089600210122     C     KCLOAN        CHAIN     CLOAN                              88                       CLE00
089700210122     C     *IN88         IFEQ      '1'                                                         CLE00
089800210122     C                   MOVEL     'CLOAN   '    W0FILE                         ************   CLE00
089900210122     C                   MOVEL     LNRF          W0KEY                          * DBERR 14 *   CLE00
090000210122     C                   Z-ADD     14            W0ERNB                         ************   CLE00
090100210122     C                   MOVEL     'MEM5004'     W0MSGD                                        CLE00
090200210122     C                   MOVEL     'MIDAS  '     W0MSGF                                        CLE00
090300210122     C                   EXSR      SRERR                                                       CLE00
090400210122     C                   ENDIF                                                                 CLE00
090500210122      *                                                                   CLE005
090600210122     C                   ENDIF                                                                 CLE00
090700210122      *                                                                   CLE005
090800210122     C/COPY WNCPYSRC,CG6005C001
090900210122     C*
091000210122     C** If an equal loan reference has been read, check if amendment
091100210122     C** type is 'RE'.   If it is, store the repayment value date to be
091200210122     C** used later in the calculation.
091300210122     C*
091400210122     C                   MOVE      *BLANKS       ##AMT1
091500210122     C     LNRF          CHAIN     LOAMS                              87
091600210122     C*
091700210122     C     *IN87         DOWEQ     '0'
091800210122     C********** ##AMT1    ANDNE'RE'                                                          245914
091900210122     C     ##AMT1        IFEQ      'RE'
092000210122     C                   Z-ADD     ##VDA1        ##RPDT            5 0
092100210122     C**********           ELSE                                                               245914
092200210122     C                   END
092300210122     C     LNRF          READE     LOAMS                                  87
092400210122     C**********           END                                                                245914
092500210122     C                   END
092600210122     C*
092700210122     C/COPY WNCPYSRC,CG6005C005
092800210122     C**  Unwind subroutine stack name.
092900210122     C*
093000210122     C                   MOVEA     *BLANKS       @STK(Q)
093100210122     C                   SUB       1             Q
093200210122     C*
093300210122     C     SRDET9        ENDSR                                                  ** SRDET9 **
093400210122     C*
093500210122     C*****************************************************************
093600210122     C/EJECT
093700210122     C*****************************************************************
093800210122     C*                                                               *
093900210122     C*  Subroutine  :  SRGENR                                        *
094000210122     C*  Function    :  Generate reference number by writing to       *
094100210122     C*                 PF/CGUDCRPD                                   *
094200210122     C*                                                               *
094300210122     C*  Called by   :  SRMAIN - Main Processing                      *
094400210122     C*  Calls       :  CG9010 - Create Item Reference Records        *
094500210122     C*                                                               *
094600210122     C*****************************************************************
094700210122     C*
094800210122     C     SRGENR        BEGSR                                                  ** SRGENR **
094900210122     C*
095000210122     C**  Set up subroutine stack name.
095100210122     C*
095200210122     C                   ADD       1             Q
095300210122     C                   MOVEL     'SRGENR'      @STK(Q)
095400210122     C*
095500210122     C**  Generate reference number and check if further processing
095600210122     C**  required. Set up all available information in the record
095700210122     C**  format before calling.
095800210122     C*
095900210122     C                   CLEAR                   ##UDCR
096000210122     C*
096100210122     C**  Booking/Main Branch (Mandatory).
096200210122     C*
096300210122     C                   MOVEL     ##BRCA        DRBRCA
096400210122     C*
096500210122     C**  Originating Branch (Optional).
096600210122     C*
096700210122     C                   MOVEL     ##ORBR        DRORBR
096800210122     C*
096900210122     C**  Module identifier (Mandatory).
097000210122     C*
097100210122     C                   MOVEL     'LE'          DRMODI
097200210122     C*
097300210122     C**  Midas Transaction Number (Mandatory).
097400210122     C*
097500210122     C                   MOVEL     LNRF          DRMTRN
097600210122     C*
097700210122     C**  Midas GL Account Reference CNUMCCYACODACSQBRCA  (Optional).
097800210122     C*
097900210122     C                   MOVEL     *BLANKS       DRMACT
098000210122     C*
098100210122     C**  Print Type.
098200210122     C*
098300210122     C                   MOVEL     W#PTYP        DRPTYP
098400210122     C*
098500210122     C**  Print Sub-type.
098600210122     C*
098700210122     C                   SELECT
098800210122     C     ##PTYP        WHENEQ    61
098900210122     C                   MOVEL     W#PST1        DRPSTP
099000210122     C     ##PTYP        WHENEQ    62
099100210122     C                   MOVEL     W#PST2        DRPSTP
099200210122     C     ##PTYP        WHENEQ    63
099300210122     C                   MOVEL     W#PST3        DRPSTP
099400210122     C     ##PTYP        WHENEQ    64
099500210122     C                   MOVEL     W#PST4        DRPSTP
099600210122     C     ##PTYP        WHENEQ    65
099700210122     C                   MOVEL     W#PST5        DRPSTP
099800210122     C     ##PTYP        WHENEQ    66
099900210122     C                   MOVEL     W#PST6        DRPSTP
100000210122     C     ##PTYP        WHENEQ    67
100100210122     C                   MOVEL     W#PST7        DRPSTP
100200210122     C     ##PTYP        WHENEQ    70
100300210122     C                   MOVEL     W#PST8        DRPSTP
100400210122     C                   ENDSL
100500210122      *                                                                   CLE005
100600210122     C     CLE005        IFEQ      'Y'                                                         CLE00
100700210122     C     ##PTYP        IFEQ      68                                                          CLE00
100800210122     C                   MOVEL     W#PST9        DRPSTP                                        CLE00
100900210122     C                   ENDIF                                                                 CLE00
101000210122     C     ##PTYP        IFEQ      69                                                          CLE00
101100210122     C                   MOVEL     W#PS10        DRPSTP                                        CLE00
101200210122     C                   ENDIF                                                                 CLE00
101300210122     C     ##PTYP        IFEQ      71                                                          CLE00
101400210122     C                   MOVEL     W#PS11        DRPSTP                                        CLE00
101500210122     C                   ENDIF                                                                 CLE00
101600210122     C     ##PTYP        IFEQ      72                                                          CLE00
101700210122     C     WOLN70        IFEQ      'Y'                                                         CLE00
101800210122     C                   MOVEL     W#PS13        DRPSTP                                        CLE00
101900210122     C                   ELSE                                                                  CLE00
102000210122     C                   MOVEL     W#PS12        DRPSTP                                        CLE00
102100210122     C                   ENDIF                                                                 CLE00
102200210122     C                   ENDIF                                                                 CLE00
102300210122     C                   ENDIF                                                                 CLE00
102400210122      *                                                                   CLE005
102500210122      ** If Flat Rate Personal Loans (Rule of 78s) CLE028 is                                  CLE028
102600210122      ** installed, set print item subtype field to 'FLAT LOAN' if                            CLE028
102700210122      ** processing a Flat Rate Personal Loan.                                                CLE028
102800210122      *                                                                                       CLE028
102900210122     C     ##PTYP        IFEQ      80
103000210122     C     CLE028        ANDEQ     'Y'
103100210122     C                   MOVEL     W#PS14        DRPSTP
103200210122     C                   ENDIF
103300210122      *                                                                                       CLE028
103400210122     C/COPY WNCPYSRC,CG6005C012
103500210122     C*
103600210122     C**  Auto Transmission indicator.
103700210122     C*
103800210122     C                   MOVEL     'N'           DRATRM
103900210122     C*
104000210122     C**  Cheque Reference (Optional).
104100210122     C*
104200210122     C                   MOVEL     *BLANKS       DRCHQR
104300210122     C*
104400210122     C**  Further Reference (Optional).
104500210122     C*
104600210122     C                   MOVEL     *BLANKS       DRFREF
104700210122     C*
104800210122     C**  Customer Number (Mandatory).
104900210122     C*
105000210122     C                   MOVEL     ##CNUM        ##CUST
105100210122     C*
105200210122     C                   CALL      'CG9010'
105300210122     C                   PARM                    ##RTCD            7
105400210122     C                   PARM      '*GEN'        ##MODE           10
105500210122     C                   PARM      W0CMT         ##CMT             3
105600210122     C                   PARM                    ##CUST            6
105700210122     C                   PARM                    ##UDCR
105800210122     C                   PARM                    ##ITMA            8
105900210122     C*
106000210122     C**  Blank return code implies generate correspondence.
106100210122     C**  CGD1270 => no error, but suppress output for this transaction.
106200210122     C*
106300210122     C     ##RTCD        IFEQ      *BLANK
106400210122      *                                                                                       CCG015
106500210122     C     DRPTYP        CAT(P)    ':':0         COLON            11
106600210122     C     COLON         CAT(P)    DRPSTP:0      ##REFR
106700210122     C                   EXSR      WRAPRF
106800210122     C*
106900210122     C                   MOVE      'Y'           ##COPD
107000210122     C*
107100210122     C                   ELSE
107200210122     C*
107300210122     C     ##RTCD        IFNE      'CGD1270'
107400210122     C                   MOVEL     'CG9010  '    W0FILE
107500210122     C                   MOVEL     ##RTCD        W0KEY                          ************
107600210122     C                   Z-ADD     3             W0ERNB                         * DBERR 03 *
107700210122     C                   MOVEL     'CGD1286'     W0MSGD                         ************
107800210122     C                   MOVEL     'CGUSRMSG'    W0MSGF
107900210122     C                   EXSR      SRERR
108000210122     C                   ENDIF
108100210122     C*
108200210122     C                   ENDIF
108300210122     C*
108400210122     C     EXGENR        TAG
108500210122     C*
108600210122     C**  Unwind subroutine stack name.
108700210122     C*
108800210122     C                   MOVEA     *BLANKS       @STK(Q)
108900210122     C                   SUB       1             Q
109000210122     C*
109100210122     C                   ENDSR
109200210122     C*
109300210122     C*****************************************************************
109400210122     C/EJECT
109500210122     C*****************************************************************
109600210122     C*                                                               *
109700210122     C*  Subroutine  :  L01CC                                         *
109800210122     C*  Function    :  Lending Commencement Confirmations            *
109900210122     C*                                                               *
110000210122     C*  Called by   :  SRMAIN - Main Processing                      *
110100210122     C*  Calls       :  SRPATH - Generate Path String                 *
110200210122     C*                 LOANA  - Loan Associated Details              *
110300210122     C*                 LOAN   - Process Loan Details                 *
110400210122     C*                 L@IPY  - Process Interest Payment Details     *
110500210122     C*                 L@ROL  - Process Rollover Details             *
110600210122     C*                 L@REP  - Process Repayment Details            *
110700210122     C*                 L@GUAR - Process Guarantee Details            *
110800210122     C*                 SRSDET - Set-up Settlement Details            *
110900210122     C*                                                               *
111000210122     C*****************************************************************
111100210122     C*
111200210122     C     L01CC         BEGSR                                                  ** L01CC  **
111300210122     C*
111400210122     C**  Set up subroutine stack name.
111500210122     C*
111600210122     C                   ADD       1             Q
111700210122     C                   MOVEL     'L01CC '      @STK(Q)
111800210122     C*
111900210122     C                   ADD       1             P1
112000210122     C*
112100210122     C     P1            OCCUR     ##PATH
112200210122     C                   MOVEL(P)  'l01CC '      ##GRPS
112300210122     C                   EXSR      SRPATH
112400210122     C                   EXSR      PSHGRS
112500210122      *                                                                                       CCG015
112600210122     C                   EXSR      LOANA
112700210122     C                   EXSR      LOAN
112800210122     C*                                                                   S01408
112900210122     C/COPY WNCPYSRC,CG6005CCP1                                           S01408
113000210122     C*                                                                   S01408
113100210122     C                   EXSR      L@IPY
113200210122     C                   EXSR      L@ROL
113300210122     C                   EXSR      L@REP
113400210122     C                   EXSR      L@GUAR
113500210122      *                                                                                       CER049
113600210122      ** Stamp Tax                                                                            CER049
113700210122      *                                                                                       CER049
113800210122     C     CER049        IFEQ      'Y'
113900210122     C                   EXSR      LNSTAX
114000210122     C                   ENDIF
114100210122      *                                                                                       CER049
114200210122     C                   EXSR      SRSDET
114300210122     C*
114400210122     C**  Decrement Path DS index.
114500210122     C*
114600210122     C     P1            OCCUR     ##PATH
114700210122     C                   CLEAR                   ##GRPS
114800210122     C                   SUB       1             P1
114900210122      *                                                                                       CCG015
115000210122     C                   EXSR      POPGRS
115100210122     C*
115200210122     C**  Unwind subroutine stack name.
115300210122     C*
115400210122     C                   MOVEA     *BLANKS       @STK(Q)
115500210122     C                   SUB       1             Q
115600210122     C*
115700210122     C     L01CC9        ENDSR                                                  ** L01CC9 **
115800210122     C*
115900210122     C*****************************************************************
116000210122     C/EJECT
116100210122     C*****************************************************************
116200210122     C*                                                               *
116300210122     C*  Subroutine  :  LOAN                                          *
116400210122     C*  Function    :  Process Loan details                          *
116500210122     C*                                                               *
116600210122     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
116700210122     C*  Calls       :  SRPATH - Generate Path String                 *
116800210122     C*                 SRICAL - Calculate Interest                   *
116900210122     C*                 SRDCDT - Determine Currency Details           *
117000210122     C*                 SRADTA - Accumulate RDEs and Associated Data  *
117100210122     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
117200210122     C*                 AOBSRTRO - Retrive Base Rate Code Details     *
117300210122     C*                                                               *
117400210122     C*****************************************************************
117500210122     C*
117600210122     C     LOAN          BEGSR                                                  ** LOAN   **
117700210122     C*
117800210122     C**  Set up subroutine stack name.
117900210122     C*
118000210122     C                   ADD       1             Q
118100210122     C                   MOVEL     'LOAN  '      @STK(Q)
118200210122     C*
118300210122     C                   ADD       1             P1
118400210122     C*
118500210122     C     P1            OCCUR     ##PATH
118600210122     C                   MOVEL(P)  'LOAN  '      ##GRPS
118700210122     C                   EXSR      SRPATH
118800210122     C                   EXSR      PSHGRS
118900210122     C*
119000210122     C                   Z-ADD     0             R1                3 0
119100210122     C*
119200210122     C**  Base Rate Name.
119300210122     C*
119400210122     C********** ##BRTT    IFEQ      0                                                        CSD103
119500210122     C     ##BRTT        IFEQ      *BLANKS                                                    CSD103
119600210122     C                   MOVEL     *BLANKS       ##BSRN           30
119700210122     C                   ELSE
119800210122     C*
119900210122     C                   MOVEL     ##BRTT        ##BSRC
120000210122     C                   CALL      'AOBSRTR0'
120100210122     C                   PARM      *BLANKS       ##RTCD
120200210122     C                   PARM      '*KEY   '     ##OPTN
120300210122     C                   PARM      ##CCY1        ##CYCD            3
120400210122     C                   PARM                    ##BSRC            2
120500210122     C********** SDBSRT    PARM SDBSRT    DSFDY                                 CSD006
120600210122     C     SDBSRT        PARM      SDBSRT        DSSDY
120700210122     C*
120800210122     C     ##RTCD        IFNE      *BLANK
120900210122     C                   MOVEL     'SDBSRTPD'    W0FILE
121000210122     C     ##CYCD        CAT       ##BSRC        W0KEY                          ************
121100210122     C                   Z-ADD     4             W0ERNB                         * DBERR 04 *
121200210122     C                   MOVEL     'MEM5004'     W0MSGD                         ************
121300210122     C                   MOVEL     'MIDAS  '     W0MSGF
121400210122     C                   EXSR      SRERR
121500210122     C                   END
121600210122     C*
121700210122     C                   MOVEL     BABSRN        ##BSRN
121800210122     C*
121900210122     C                   END
122000210122     C*
122100210122     C                   ADD       1             R1
122200210122     C                   CLEAR                   R#DATA
122300210122     C                   CLEAR                   R#DEFN
122400210122     C                   CLEAR                   #@RDE
122500210122     C                   MOVEL     'BASERATN'    #@RDE
122600210122     C                   MOVE      'AM'          #@RDE
122700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
122800210122     C                   MOVEL     ##BSRN        R#DATA
122900210122     C                   MOVEL     R#DATA        ##D(R1)
123000210122     C                   MOVEL     R#DEFN        ##R(R1)
123100210122      *                                                                                       CLE036
123200210122      ** If CLE036 is installed, process base rate.                                           CLE036
123300210122      *                                                                                       CLE036
123400210122     C     CLE036        IFEQ      'Y'
123500210122      *                                                                                       CLE036
123600210122     C                   ADD       1             R1
123700210122     C                   CLEAR                   R#DATA
123800210122     C                   CLEAR                   R#DEFN
123900210122     C                   CLEAR                   #@RDE
124000210122     C                   MOVEL     'BASE RAT'    #@RDE
124100210122     C                   MOVE      'E '          #@RDE
124200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
124300210122     C                   MOVEL     ##BASR        R#DATA
124400210122     C                   MOVEL     R#DATA        ##D(R1)
124500210122     C                   MOVEL     R#DEFN        ##R(R1)
124600210122     C                   ENDIF
124700210122     C*
124800210122     C**  Base Rate Type.
124900210122     C*
125000210122     C                   ADD       1             R1
125100210122     C                   CLEAR                   R#DATA
125200210122     C                   CLEAR                   R#DEFN
125300210122     C                   CLEAR                   #@RDE
125400210122     C                   MOVEL     'BASERATT'    #@RDE
125500210122     C                   MOVE      'YP'          #@RDE
125600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
125700210122     C                   MOVEL     ##BRTT        R#DATA
125800210122     C                   MOVEL     R#DATA        ##D(R1)
125900210122     C                   MOVEL     R#DEFN        ##R(R1)
126000210122     C*
126100210122     C**  Currency Description.
126200210122     C*
126300210122     C                   MOVEL     ##CCY1        ##CCY
126400210122     C                   EXSR      SRDCDT
126500210122     C                   MOVEL     A6CYNM        ##WRK            14
126600210122     C*
126700210122     C                   ADD       1             R1
126800210122     C                   CLEAR                   R#DATA
126900210122     C                   CLEAR                   R#DEFN
127000210122     C                   CLEAR                   #@RDE
127100210122     C                   MOVEL     'CCY_DESC'    #@RDE
127200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
127300210122     C                   MOVEL     ##WRK         R#DATA
127400210122     C                   MOVEL     R#DATA        ##D(R1)
127500210122     C                   MOVEL     R#DEFN        ##R(R1)
127600210122     C*
127700210122     C**  Current Principal (Amount).
127800210122     C*
127900210122     C     ##RCD1        IFEQ      'R'
128000210122     C                   Z-ADD     ##NPAM        ##PAMT           13 0
128100210122     C                   ELSE
128200210122     C                   Z-ADD     ##CPAM        ##PAMT
128300210122      *                                                                                       CLE028
128400210122      ** If Flat Rate Personal Loans (Rule of 78s) CLE028 is                                  CLE028
128500210122      ** installed , the Principal Amount confirmed must include                              CLE028
128600210122      ** interest and charges where these have been added on.                                 CLE028
128700210122      *                                                                                       CLE028
128800210122     C     ##ADCF        IFEQ      'Y'
128900210122     C     ##PTYP        ANDEQ     80
129000210122     C     CLE028        ANDEQ     'Y'
129100210122     C                   ADD       ##CHGA        ##PAMT
129200210122     C                   ENDIF
129300210122      *                                                                                       CLE028
129400210122     C     ##ADIF        IFEQ      'Y'
129500210122     C     ##PTYP        ANDEQ     80
129600210122     C     CLE028        ANDEQ     'Y'
129700210122     C                   ADD       ##FLTI        ##PAMT
129800210122     C                   ENDIF
129900210122      *                                                                                       CLE028
130000210122     C                   END
130100210122     C*
130200210122     C                   ADD       1             R1
130300210122     C                   CLEAR                   R#DATA
130400210122     C                   CLEAR                   R#DEFN
130500210122     C                   CLEAR                   #@RDE
130600210122     C                   MOVEL     'CUR PRIN'    #@RDE
130700210122     C                   MOVE      'CL'          #@RDE
130800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
130900210122     C                   MOVEL     ##PAMT        ##DATA
131000210122     C                   MOVEL     'Amount'      ##RDEC
131100210122     C                   MOVEL     'L'           ##RDET
131200210122     C                   MOVEL     ##CCY1        ##CCY
131300210122     C                   EXSR      SRDCDT
131400210122     C/COPY WNCPYSRC,CG6005C015
131500210122     C                   MOVEL     A6NBDP        ##DCPA
131600210122     C                   MOVEL     R#DATA        ##D(R1)
131700210122     C                   MOVEL     R#DEFN        ##R(R1)
131800210122     C*
131900210122     C**  Currency.
132000210122     C*
132100210122     C                   ADD       1             R1
132200210122     C                   CLEAR                   R#DATA
132300210122     C                   CLEAR                   R#DEFN
132400210122     C                   CLEAR                   #@RDE
132500210122     C                   MOVEL     'CURRENCY'    #@RDE
132600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
132700210122     C                   MOVEL     ##CCY1        R#DATA
132800210122     C                   MOVEL     R#DATA        ##D(R1)
132900210122     C                   MOVEL     R#DEFN        ##R(R1)
133000210122     C*
133100210122     C**  Deal Date.
133200210122     C*
133300210122     C                   ADD       1             R1
133400210122     C                   CLEAR                   R#DATA
133500210122     C                   CLEAR                   R#DEFN
133600210122     C                   CLEAR                   #@RDE
133700210122     C                   MOVEL     'DEAL DAT'    #@RDE
133800210122     C                   MOVE      'E '          #@RDE
133900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
134000210122     C                   MOVEL     ##DDAT        ##DATA
134100210122     C                   MOVEL     'Date  '      ##RDEC
134200210122     C                   MOVEL     R#DATA        ##D(R1)
134300210122     C                   MOVEL     R#DEFN        ##R(R1)
134400210122     C*
134500210122     C**  Discount Rate.
134600210122     C*
134700210122     C     ##RCD1        IFNE      'R'
134800210122     C*
134900210122     C     ##PTYP        IFEQ      63
135000210122     C     ##PTYP        OREQ      65
135100210122     C     ##PTYP        OREQ      67
135200210122     C                   Z-ADD     ##INTR        ##DISC           11 7
135300210122     C                   ELSE
135400210122     C                   Z-ADD     0             ##DISC
135500210122     C                   END
135600210122     C*
135700210122     C                   ELSE
135800210122     C*
135900210122     C********** ##NBRA        IFEQ      *ZERO                                                CSD103
136000210122     C     ##NBRA        IFEQ      *BLANKS                                                    CSD103
136100210122     C     CLE036        ANDEQ     'N'                                                        CLE036
136200210122     C********** ##NBRA        OREQ      *ZERO                                         CLE036 CSD103
136300210122     C     ##NBRA        OREQ      *BLANKS                                                    CSD103
136400210122     C     ##NBSR        ANDEQ     *ZERO                                                      CLE036
136500210122     C     CLE036        ANDEQ     'Y'                                                        CLE036
136600210122     C                   Z-ADD     0             ##BASE           11 7
136700210122     C                   ELSE
136800210122     C*
136900210122     C********** ##NBRA        IFNE      *ZERO                                                CSD103
137000210122     C     ##NBRA        IFNE      *BLANKS                                                    CSD103
137100210122     C                   MOVEL     ##NBRA        ##BSRC
137200210122     C                   CALL      'AOBSRTR0'
137300210122     C                   PARM      *BLANKS       ##RTCD
137400210122     C                   PARM      '*KEY   '     ##OPTN
137500210122     C                   PARM      ##CCY1        ##CYCD            3
137600210122     C                   PARM                    ##BSRC            2
137700210122     C********** SDBSRT    PARM SDBSRT    DSFDY                                 CSD006
137800210122     C     SDBSRT        PARM      SDBSRT        DSSDY
137900210122     C*
138000210122     C     ##RTCD        IFNE      *BLANK
138100210122     C                   MOVEL     'SDBSRTPD'    W0FILE
138200210122     C     ##CYCD        CAT       ##BSRC        W0KEY                          ************
138300210122     C                   Z-ADD     5             W0ERNB                         * DBERR 05 *
138400210122     C                   MOVEL     'MEM5004'     W0MSGD                         ************
138500210122     C                   MOVEL     'MIDAS  '     W0MSGF
138600210122     C                   EXSR      SRERR
138700210122     C                   END
138800210122     C*
138900210122     C     BAVDNR        IFGT      ##RLDT
139000210122     C                   Z-ADD     BACBSR        ##BASE
139100210122     C                   ELSE
139200210122     C                   Z-ADD     BANBRT        ##BASE
139300210122     C                   END
139400210122     C                   ENDIF
139500210122      *                                                                                       CLE036
139600210122      ** If CLE036 is on and ##NBSR is not zero, ##NBRA should have been zero                 CLE036
139700210122      ** so set ##BASE to ##NBSR to get discount rate.                                        CLE036
139800210122      *                                                                                       CLE036
139900210122     C     ##NBSR        IFNE      *ZERO
140000210122     C     CLE036        ANDEQ     'Y'
140100210122     C                   Z-ADD     ##NBSR        ##BASE
140200210122     C                   ENDIF
140300210122     C*
140400210122     C                   END
140500210122     C*
140600210122     C     ##NSIN        IFEQ      'A'
140700210122     C     ##BASE        ADD       ##NRTS        ##DISC
140800210122     C                   ELSE
140900210122     C     ##NSIN        IFEQ      'S'
141000210122     C     ##BASE        SUB       ##NRTS        ##DISC
141100210122     C                   ELSE
141200210122     C     ##NRTS        DIV       100           ##WWRK           13 9
141300210122     C     ##WWRK        MULT      ##BASE        ##DISC
141400210122     C     ##DISC        IFEQ      0
141500210122     C                   Z-ADD     ##INTR        ##DISC
141600210122     C                   END
141700210122     C                   END
141800210122     C                   END
141900210122     C*
142000210122     C                   END
142100210122     C*
142200210122     C                   ADD       1             R1
142300210122     C                   CLEAR                   R#DATA
142400210122     C                   CLEAR                   R#DEFN
142500210122     C                   CLEAR                   #@RDE
142600210122     C                   MOVEL     'DSC RATE'    #@RDE
142700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
142800210122     C                   MOVEL     ##DISC        ##DATA
142900210122     C                   MOVEL     'Rate  '      ##RDEC
143000210122     C                   MOVEL     'L'           ##RDET
143100210122     C                   MOVEL     '7'           ##DCPA
143200210122     C                   MOVEL     R#DATA        ##D(R1)
143300210122     C                   MOVEL     R#DEFN        ##R(R1)
143400210122     C*
143500210122     C**  Rate.
143600210122     C*
143700210122     C                   ADD       1             R1
143800210122     C                   CLEAR                   R#DATA
143900210122     C                   CLEAR                   R#DEFN
144000210122     C                   CLEAR                   #@RDE
144100210122     C                   MOVEL     'GRS DISC'    #@RDE
144200210122     C                   MOVE      'NT'          #@RDE
144300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
144400210122     C                   MOVEL     ##TOTI        ##DATA
144500210122     C                   MOVEL     'Amount'      ##RDEC
144600210122     C                   MOVEL     'L'           ##RDET
144700210122     C                   MOVEL     ##CCY1        ##CCY
144800210122     C                   EXSR      SRDCDT
144900210122     C/COPY WNCPYSRC,CG6005C016
145000210122     C                   MOVEL     A6NBDP        ##DCPA
145100210122     C                   MOVEL     R#DATA        ##D(R1)
145200210122     C                   MOVEL     R#DEFN        ##R(R1)
145300210122     C*
145400210122     C**  Gross Interest.
145500210122     C*
145600210122     C********** ##REPT    IFEQ 1                                                             177914
145700210122     C********** ##REPT    OREQ 3                                                             177914
145800210122     C**********           Z-ADD0         ##TINT                                              177914
145900210122     C**********           ELSE                                                               177914
146000210122     C                   EXSR      SRICAL
146100210122     C**********           END                                                                177914
146200210122     C*
146300210122     C                   ADD       1             R1
146400210122     C                   CLEAR                   R#DATA
146500210122     C                   CLEAR                   R#DEFN
146600210122     C                   CLEAR                   #@RDE
146700210122     C                   MOVEL     'GRS INTR'    #@RDE
146800210122     C                   MOVE      'ST'          #@RDE
146900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
147000210122     C                   MOVEL     ##TINT        ##DATA
147100210122     C                   MOVEL     'Amount'      ##RDEC
147200210122     C                   MOVEL     'L'           ##RDET
147300210122     C                   MOVEL     ##CCY1        ##CCY
147400210122     C                   EXSR      SRDCDT
147500210122     C/COPY WNCPYSRC,CG6005C017
147600210122     C                   MOVEL     A6NBDP        ##DCPA
147700210122     C                   MOVEL     R#DATA        ##D(R1)
147800210122     C                   MOVEL     R#DEFN        ##R(R1)
147900210122     C*
148000210122     C**  Interest Calculation Basis.
148100210122     C*
148200210122     C                   ADD       1             R1
148300210122     C                   CLEAR                   R#DATA
148400210122     C                   CLEAR                   R#DEFN
148500210122     C                   CLEAR                   #@RDE
148600210122     C                   MOVEL     'INT CALB'    #@RDE
148700210122     C                   MOVE      'AS'          #@RDE
148800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
148900210122     C                   MOVEL     ##ICBS        R#DATA
149000210122     C                   MOVEL     R#DATA        ##D(R1)
149100210122     C                   MOVEL     R#DEFN        ##R(R1)
149200210122     C*
149300210122     C**  Interest capitalization indicator.
149400210122     C*
149500210122     C                   ADD       1             R1
149600210122     C                   CLEAR                   R#DATA
149700210122     C                   CLEAR                   R#DEFN
149800210122     C                   CLEAR                   #@RDE
149900210122     C                   MOVEL     'INT CAP '    #@RDE
150000210122     C                   MOVE      'IN'          #@RDE
150100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
150200210122     C                   MOVEL     ##INTC        R#DATA
150300210122     C                   MOVEL     R#DATA        ##D(R1)
150400210122     C                   MOVEL     R#DEFN        ##R(R1)
150500210122     C*
150600210122     C**  Interest Rate.
150700210122     C*
150800210122     C                   ADD       1             R1
150900210122     C                   CLEAR                   R#DATA
151000210122     C                   CLEAR                   R#DEFN
151100210122     C                   CLEAR                   #@RDE
151200210122     C                   MOVEL     'INT RATE'    #@RDE
151300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
151400210122     C                   MOVEL     ##INTR        ##DATA
151500210122     C                   MOVEL     'Rate  '      ##RDEC
151600210122     C                   MOVEL     'L'           ##RDET
151700210122     C                   MOVEL     '7'           ##DCPA
151800210122     C                   MOVEL     R#DATA        ##D(R1)
151900210122     C                   MOVEL     R#DEFN        ##R(R1)
152000210122     C*
152100210122     C**  Loan Reference.
152200210122     C*
152300210122     C                   ADD       1             R1
152400210122     C                   CLEAR                   R#DATA
152500210122     C                   CLEAR                   R#DEFN
152600210122     C                   CLEAR                   #@RDE
152700210122     C                   MOVEL     'LOAN REF'    #@RDE
152800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
152900210122     C                   MOVEL     LNRF          R#DATA
153000210122     C                   MOVEL     R#DATA        ##D(R1)
153100210122     C                   MOVEL     R#DEFN        ##R(R1)
153200210122     C*
153300210122     C**  Loan Total.
153400210122     C*
153500210122     C     ##RCD1        IFEQ      'R'
153600210122     C     ##NPAM        SUB       ##NDAM        ##TTAL
153700210122     C                   ELSE
153800210122     C     ##PTYP        IFEQ      61
153900210122     C     ##PTYP        OREQ      62
154000210122     C     ##PTYP        OREQ      64
154100210122     C     ##PTYP        OREQ      66
154200210122     C     ##PTYP        OREQ      68                                                          CLE00
154300210122     C     CLE005        ANDEQ     'Y'                                                         CLE00
154400210122     C     ##PTYP        OREQ      69                                                          CLE00
154500210122     C     CLE005        ANDEQ     'Y'                                                         CLE00
154600210122     C     ##PTYP        OREQ      80
154700210122     C     CLE028        ANDEQ     'Y'
154800210122     C     ##CPAM        ADD       ##TINT        ##TTAL           13 0
154900210122     C                   ELSE
155000210122     C     ##PTYP        IFEQ      63
155100210122     C     ##PTYP        OREQ      65
155200210122     C     ##PTYP        OREQ      67
155300210122     C     ##CPAM        SUB       ##TOTI        ##TTAL
155400210122     C                   END
155500210122     C                   END
155600210122      *                                                                                       CLE028
155700210122      ** If Flat Rate Personal Loans (Rule of 78s) is installed and                           CLE028
155800210122      ** Add on Charges Flag is 'Y', charge amount will be included                           CLE028
155900210122      ** in the Loan Amount of a Flat Rate Personal Loans.                                    CLE028
156000210122      *                                                                                       CLE028
156100210122     C     ##ADCF        IFEQ      'Y'
156200210122     C     ##PTYP        ANDEQ     80
156300210122     C     CLE028        ANDEQ     'Y'
156400210122     C                   ADD       ##CHGA        ##TTAL
156500210122     C                   ENDIF
156600210122      *                                                                                       CLE028
156700210122     C                   END
156800210122     C*
156900210122     C                   ADD       1             R1
157000210122     C                   CLEAR                   R#DATA
157100210122     C                   CLEAR                   R#DEFN
157200210122     C                   CLEAR                   #@RDE
157300210122     C                   MOVEL     'LOAN TOT'    #@RDE
157400210122     C                   MOVE      'AL'          #@RDE
157500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
157600210122     C                   MOVEL     ##TTAL        ##DATA
157700210122     C                   MOVEL     'Amount'      ##RDEC
157800210122     C                   MOVEL     'L'           ##RDET
157900210122     C                   MOVEL     ##CCY1        ##CCY
158000210122     C                   EXSR      SRDCDT
158100210122     C/COPY WNCPYSRC,CG6005C018
158200210122     C                   MOVEL     A6NBDP        ##DCPA
158300210122     C                   MOVEL     R#DATA        ##D(R1)
158400210122     C                   MOVEL     R#DEFN        ##R(R1)
158500210122     C*
158600210122     C**  Maturity Date.
158700210122     C*
158800210122     C                   ADD       1             R1
158900210122     C                   CLEAR                   R#DATA
159000210122     C                   CLEAR                   R#DEFN
159100210122     C                   CLEAR                   #@RDE
159200210122     C                   MOVEL     'MATUR DA'    #@RDE
159300210122     C                   MOVE      'TE'          #@RDE
159400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
159500210122     C                   MOVEL     ##MDAT        ##DATA
159600210122     C                   MOVEL     'Date  '      ##RDEC
159700210122     C                   MOVEL     R#DATA        ##D(R1)
159800210122     C                   MOVEL     R#DEFN        ##R(R1)
159900210122     C*
160000210122     C**  Run date; production time.
160100210122     C*
160200210122     C                   ADD       1             R1
160300210122     C                   CLEAR                   R#DATA
160400210122     C                   CLEAR                   R#DEFN
160500210122     C                   CLEAR                   #@RDE
160600210122     C                   MOVEL     'RUNDAT  '    #@RDE
160700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
160800210122     C                   MOVEL     BJRDNB        ##DATA
160900210122     C                   MOVEL     'Date  '      ##RDEC
161000210122     C                   MOVEL     R#DATA        ##D(R1)
161100210122     C                   MOVEL     R#DEFN        ##R(R1)
161200210122     C*
161300210122     C**  Spread.
161400210122     C*
161500210122     C     ##SPIN        IFEQ      'A'
161600210122     C                   Z-ADD     ##RTSP        ##SPRD           11 7
161700210122     C                   ELSE
161800210122     C                   Z-SUB     ##RTSP        ##SPRD
161900210122     C                   END
162000210122     C*
162100210122     C                   ADD       1             R1
162200210122     C                   CLEAR                   R#DATA
162300210122     C                   CLEAR                   R#DEFN
162400210122     C                   CLEAR                   #@RDE
162500210122     C                   MOVEL     'SPREAD  '    #@RDE
162600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
162700210122     C                   MOVEL     ##SPRD        ##DATA
162800210122     C                   MOVEL     'Rate  '      ##RDEC
162900210122     C                   MOVEL     'L'           ##RDET
163000210122     C                   MOVEL     '7'           ##DCPA
163100210122     C                   MOVEL     R#DATA        ##D(R1)
163200210122     C                   MOVEL     R#DEFN        ##R(R1)
163300210122     C*
163400210122     C**  Value Date.
163500210122     C*
163600210122     C                   ADD       1             R1
163700210122     C                   CLEAR                   R#DATA
163800210122     C                   CLEAR                   R#DEFN
163900210122     C                   CLEAR                   #@RDE
164000210122     C                   MOVEL     'VALUE DA'    #@RDE
164100210122     C                   MOVE      'TE'          #@RDE
164200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
164300210122     C                   MOVEL     ##VDAT        ##DATA
164400210122     C                   MOVEL     'Date  '      ##RDEC
164500210122     C                   MOVEL     R#DATA        ##D(R1)
164600210122     C                   MOVEL     R#DEFN        ##R(R1)
164700210122     C*
164800210122     C** Current Principal in Settlement Currency                         CEU014
164900210122     C*                                                                   CEU014
165000210122     C                   ADD       1             R1                                            CEU01
165100210122     C                   CLEAR                   R#DATA                                        CEU01
165200210122     C                   CLEAR                   R#DEFN                                        CEU01
165300210122     C                   CLEAR                   #@RDE                                         CEU01
165400210122     C                   MOVEL     'C_PRN_SC'    #@RDE                                         CEU01
165500210122     C                   MOVE      'CY'          #@RDE                                         CEU01
165600210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
165700210122     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
165800210122     C                   MOVEL     'L'           ##RDET                                        CEU01
165900210122     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
166000210122     C*                                                                   CEU014
166100210122      ** If Lending Enhancements is installed, make use                                       CLE031
166200210122      ** the appropriate settlement currency.                                                 CLE031
166300210122      *                                                                                       CLE031
166400210122     C     CLE031        IFEQ      'Y'
166500210122      *                                                                                       CLE031
166600210122      ** Retrieve the currency details of Loan Currency                                       CLE031
166700210122      *                                                                                       CLE031
166800210122     C                   MOVE      *BLANKS       WLINCY            1
166900210122     C     ##CCY1        IFNE      *BLANKS
167000210122     C                   MOVEL     ##CCY1        ##CCY
167100210122     C                   EXSR      SRDCDT
167200210122     C                   MOVE      A6INCY        WLINCY
167300210122     C                   Z-ADD     A6NBDP        WLNBDP            1 0
167400210122     C                   ENDIF
167500210122      *                                                                                       CLE031
167600210122      ** For parts sold loans.                                                                CLE031
167700210122      *                                                                                       CLE031
167800210122     C     ##PTYP        IFEQ      66
167900210122     C     ##PTYP        OREQ      67
168000210122     C     CLE005        OREQ      'Y'
168100210122     C     ##PTYP        ANDEQ     69
168200210122     C     CLE005        OREQ      'Y'
168300210122     C     ##PTYP        ANDEQ     72
168400210122      *                                                                                       CLE031
168500210122      ** Conversion is done only if Receipt Settlement currency is                            CLE031
168600210122      ** non-blank and different from Loan Currency.                                          CLE031
168700210122      *                                                                                       CLE031
168800210122     C     ##CCY1        IFNE      ##STCY
168900210122     C     ##STCY        ANDNE     *BLANKS
169000210122      *                                                                                       CLE031
169100210122      ** Retrieve the currency details of Receipt Settlement Currency.                        CLE031
169200210122      *                                                                                       CLE031
169300210122     C                   MOVEL     ##STCY        ##CCY
169400210122     C                   EXSR      SRDCDT
169500210122      *                                                                                       CLE031
169600210122      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
169700210122      ** is satisfied:                                                                        CLE031
169800210122      ** 1. Loan currency is 'In' currency                                                    CLE031
169900210122      ** 2. Receipt settlement currency is 'In' currency                                      CLE031
170000210122      *                                                                                       CLE031
170100210122     C     WLINCY        IFEQ      'Y'
170200210122     C     A6INCY        OREQ      'Y'
170300210122      *                                                                                       CLE031
170400210122     C                   Z-ADD     ##PAMT        P@FRAM
170500210122     C                   MOVE      ##CCY1        P@FRCY
170600210122     C                   MOVE      ##STCY        P@TOCY
170700210122     C                   EXSR      D@EURO
170800210122     C                   MOVEL     ##OUTA        ##DATA
170900210122     C                   MOVEL     A6NBDP        ##DCPA
171000210122     C                   MOVEL     R#DATA        ##D(R1)
171100210122      *                                                                                       CLE031
171200210122     C                   ELSE
171300210122      *                                                                                       CLE031
171400210122      ** If the above condition is not satisfied, convert the Principal Amount                CLE031
171500210122      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
171600210122      ** from CLOANCL.                                                                        CLE031
171700210122      *                                                                                       CLE031
171800210122     C                   Z-ADD     ##REXR        ZEXCH
171900210122     C                   MOVE      ##REXI        ZMD
172000210122     C                   Z-ADD     ##PAMT        ZAMTCI
172100210122     C                   MOVE      ##CCY1        ZCCYI
172200210122     C                   MOVE      ##STCY        ZCCYO
172300210122     C                   Z-ADD     WLNBDP        ZCDPI
172400210122     C                   Z-ADD     A6NBDP        ZCDPO
172500210122      *                                                                                       CLE031
172600210122     C                   EXSR      ZCONV
172700210122      *                                                                                       CLE031
172800210122     C                   MOVEL     ZAMTCO        ##DATA
172900210122     C                   MOVEL     A6NBDP        ##DCPA
173000210122     C                   MOVEL     R#DATA        ##D(R1)
173100210122     C                   ENDIF
173200210122     C                   ENDIF
173300210122      *                                                                                       CLE031
173400210122     C                   ELSE
173500210122      *                                                                                       CLE031
173600210122      ** Conversion is done only if Pay Settlement currency is                                CLE031
173700210122      ** non-blank and different from Loan Currency.                                          CLE031
173800210122      *                                                                                       CLE031
173900210122     C     ##CCY1        IFNE      ##PSCY
174000210122     C     ##PSCY        ANDNE     *BLANKS
174100210122      *                                                                                       CLE031
174200210122      ** Retrieve the currency details of Pay Settlement Currency.                            CLE031
174300210122      *                                                                                       CLE031
174400210122     C                   MOVEL     ##PSCY        ##CCY
174500210122     C                   EXSR      SRDCDT
174600210122      *                                                                                       CLE031
174700210122      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
174800210122      ** is satisfied:                                                                        CLE031
174900210122      ** 1. Loan currency is 'In' currency                                                    CLE031
175000210122      ** 2. Pay Settlement Currency is 'In' currency                                          CLE031
175100210122      *                                                                                       CLE031
175200210122     C     WLINCY        IFEQ      'Y'
175300210122     C     A6INCY        OREQ      'Y'
175400210122      *                                                                                       CLE031
175500210122     C                   Z-ADD     ##PAMT        P@FRAM
175600210122     C                   MOVE      ##CCY1        P@FRCY
175700210122     C                   MOVE      ##PSCY        P@TOCY
175800210122     C                   EXSR      D@EURO
175900210122     C                   MOVEL     ##OUTA        ##DATA
176000210122     C                   MOVEL     A6NBDP        ##DCPA
176100210122     C                   MOVEL     R#DATA        ##D(R1)
176200210122      *                                                                                       CLE031
176300210122     C                   ELSE
176400210122      *                                                                                       CLE031
176500210122      ** If the above condition is not satisfied, convert the Principal Amount                CLE031
176600210122      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
176700210122      ** from CLOANCL.                                                                        CLE031
176800210122      *                                                                                       CLE031
176900210122     C                   Z-ADD     ##PEXR        ZEXCH
177000210122     C                   MOVE      ##PEXI        ZMD
177100210122     C                   Z-ADD     ##PAMT        ZAMTCI
177200210122     C                   MOVE      ##CCY1        ZCCYI
177300210122     C                   MOVE      ##PSCY        ZCCYO
177400210122     C                   Z-ADD     WLNBDP        ZCDPI
177500210122     C                   Z-ADD     A6NBDP        ZCDPO
177600210122      *                                                                                       CLE031
177700210122     C                   EXSR      ZCONV
177800210122      *                                                                                       CLE031
177900210122     C                   MOVEL     ZAMTCO        ##DATA
178000210122     C                   MOVEL     A6NBDP        ##DCPA
178100210122     C                   MOVEL     R#DATA        ##D(R1)
178200210122     C                   ENDIF
178300210122     C                   ENDIF
178400210122     C                   ENDIF
178500210122      *                                                                                       CLE031
178600210122     C                   ELSE
178700210122      *                                                                                       CLE031
178800210122     C     CEU014        IFEQ      'Y'                                                         CEU01
178900210122     C     ##STCY        ANDNE     *BLANKS                                                     CEU01
179000210122     C                   MOVEL     ##STCY        ##CCY                                         CEU01
179100210122     C                   EXSR      SRDCDT                                                      CEU01
179200210122     C                   Z-ADD     ##PAMT        P@FRAM                                        CEU01
179300210122     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
179400210122     C                   MOVE      ##STCY        P@TOCY                                        CEU01
179500210122     C                   EXSR      D@EURO                                                      CEU01
179600210122     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
179700210122     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
179800210122     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
179900210122     C                   ENDIF                                                                 CEU01
180000210122      *                                                                                       CLE031
180100210122     C                   ENDIF
180200210122     C*                                                                   CEU014
180300210122     C** Loan Total in Settlement Currency                                CEU014
180400210122     C*                                                                   CEU014
180500210122     C                   ADD       1             R1                                            CEU01
180600210122     C                   CLEAR                   R#DATA                                        CEU01
180700210122     C                   CLEAR                   R#DEFN                                        CEU01
180800210122     C                   CLEAR                   #@RDE                                         CEU01
180900210122     C                   MOVEL     'L_TOT_SC'    #@RDE                                         CEU01
181000210122     C                   MOVE      'CY'          #@RDE                                         CEU01
181100210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
181200210122     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
181300210122     C                   MOVEL     'L'           ##RDET                                        CEU01
181400210122     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
181500210122     C*                                                                   CEU014
181600210122      ** If Lending Enhancements is installed, make use of                                    CLE031
181700210122      ** the appropriate settlement currency.                                                 CLE031
181800210122      *                                                                                       CLE031
181900210122     C     CLE031        IFEQ      'Y'
182000210122      *                                                                                       CLE031
182100210122      ** Retrieve the currency details of Loan Currency                                       CLE031
182200210122      *                                                                                       CLE031
182300210122     C                   MOVE      *BLANKS       WLINCY            1
182400210122     C     ##CCY1        IFNE      *BLANKS
182500210122     C                   MOVEL     ##CCY1        ##CCY
182600210122     C                   EXSR      SRDCDT
182700210122     C                   MOVE      A6INCY        WLINCY
182800210122     C                   Z-ADD     A6NBDP        WLNBDP            1 0
182900210122     C                   ENDIF
183000210122      *                                                                                       CLE031
183100210122      ** For parts sold loans.                                                                CLE031
183200210122      *                                                                                       CLE031
183300210122     C     ##PTYP        IFEQ      66
183400210122     C     ##PTYP        OREQ      67
183500210122     C     CLE005        OREQ      'Y'
183600210122     C     ##PTYP        ANDEQ     69
183700210122     C     CLE005        OREQ      'Y'
183800210122     C     ##PTYP        ANDEQ     72
183900210122      *                                                                                       CLE031
184000210122      ** Conversion is done only if Receipt Settlement currency is                            CLE031
184100210122      ** non-blank and different from Loan Currency.                                          CLE031
184200210122      *                                                                                       CLE031
184300210122     C     ##CCY1        IFNE      ##STCY
184400210122     C     ##STCY        ANDNE     *BLANKS
184500210122      *                                                                                       CLE031
184600210122      ** Retrieve the currency details of Receipt Settlement Currency.                        CLE031
184700210122      *                                                                                       CLE031
184800210122     C                   MOVEL     ##STCY        ##CCY
184900210122     C                   EXSR      SRDCDT
185000210122      *                                                                                       CLE031
185100210122      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
185200210122      ** is satisfied:                                                                        CLE031
185300210122      ** 1. Loan currency is 'In' currency                                                    CLE031
185400210122      ** 2. Receipt settlement currency is 'In' currency                                      CLE031
185500210122      *                                                                                       CLE031
185600210122     C     WLINCY        IFEQ      'Y'
185700210122     C     A6INCY        OREQ      'Y'
185800210122      *                                                                                       CLE031
185900210122     C                   Z-ADD     ##TTAL        P@FRAM
186000210122     C                   MOVE      ##CCY1        P@FRCY
186100210122     C                   MOVE      ##STCY        P@TOCY
186200210122     C                   EXSR      D@EURO
186300210122     C                   MOVEL     ##OUTA        ##DATA
186400210122     C                   MOVEL     A6NBDP        ##DCPA
186500210122     C                   MOVEL     R#DATA        ##D(R1)
186600210122      *                                                                                       CLE031
186700210122     C                   ELSE
186800210122      *                                                                                       CLE031
186900210122      ** If the above condition is not satisfied, convert the Loan Total                      CLE031
187000210122      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
187100210122      ** from CLOANCL.                                                                        CLE031
187200210122      *                                                                                       CLE031
187300210122     C                   Z-ADD     ##REXR        ZEXCH
187400210122     C                   MOVE      ##REXI        ZMD
187500210122     C                   Z-ADD     ##TTAL        ZAMTCI
187600210122     C                   MOVE      ##CCY1        ZCCYI
187700210122     C                   MOVE      ##STCY        ZCCYO
187800210122     C                   Z-ADD     WLNBDP        ZCDPI
187900210122     C                   Z-ADD     A6NBDP        ZCDPO
188000210122      *                                                                                       CLE031
188100210122     C                   EXSR      ZCONV
188200210122      *                                                                                       CLE031
188300210122     C                   MOVEL     ZAMTCO        ##DATA
188400210122     C                   MOVEL     A6NBDP        ##DCPA
188500210122     C                   MOVEL     R#DATA        ##D(R1)
188600210122     C                   ENDIF
188700210122     C                   ENDIF
188800210122      *                                                                                       CLE031
188900210122     C                   ELSE
189000210122      *                                                                                       CLE031
189100210122      ** Conversion is done only if Pay Settlement currency is                                CLE031
189200210122      ** non-blank and different from Loan Currency.                                          CLE031
189300210122      *                                                                                       CLE031
189400210122     C     ##CCY1        IFNE      ##PSCY
189500210122     C     ##PSCY        ANDNE     *BLANKS
189600210122      *                                                                                       CLE031
189700210122      ** Retrieve the currency details of Pay Settlement Currency.                            CLE031
189800210122      *                                                                                       CLE031
189900210122     C                   MOVEL     ##PSCY        ##CCY
190000210122     C                   EXSR      SRDCDT
190100210122      *                                                                                       CLE031
190200210122      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
190300210122      ** is satisfied:                                                                        CLE031
190400210122      ** 1. Loan currency is 'In' currency                                                    CLE031
190500210122      ** 2. Pay Settlement Currency is 'In' currency                                          CLE031
190600210122      *                                                                                       CLE031
190700210122     C     WLINCY        IFEQ      'Y'
190800210122     C     A6INCY        OREQ      'Y'
190900210122      *                                                                                       CLE031
191000210122     C                   Z-ADD     ##TTAL        P@FRAM
191100210122     C                   MOVE      ##CCY1        P@FRCY
191200210122     C                   MOVE      ##PSCY        P@TOCY
191300210122     C                   EXSR      D@EURO
191400210122     C                   MOVEL     ##OUTA        ##DATA
191500210122     C                   MOVEL     A6NBDP        ##DCPA
191600210122     C                   MOVEL     R#DATA        ##D(R1)
191700210122      *                                                                                       CLE031
191800210122     C                   ELSE
191900210122      *                                                                                       CLE031
192000210122      ** If the above condition is not satisfied, convert the Loan Total                      CLE031
192100210122      ** using ZCONV and the appropriate settlement exchange rate and indicator               CLE031
192200210122      ** from CLOANCL.                                                                        CLE031
192300210122      *                                                                                       CLE031
192400210122     C                   Z-ADD     ##PEXR        ZEXCH
192500210122     C                   MOVE      ##PEXI        ZMD
192600210122     C                   Z-ADD     ##TTAL        ZAMTCI
192700210122     C                   MOVE      ##CCY1        ZCCYI
192800210122     C                   MOVE      ##PSCY        ZCCYO
192900210122     C                   Z-ADD     WLNBDP        ZCDPI
193000210122     C                   Z-ADD     A6NBDP        ZCDPO
193100210122      *                                                                                       CLE031
193200210122     C                   EXSR      ZCONV
193300210122      *                                                                                       CLE031
193400210122     C                   MOVEL     ZAMTCO        ##DATA
193500210122     C                   MOVEL     A6NBDP        ##DCPA
193600210122     C                   MOVEL     R#DATA        ##D(R1)
193700210122     C                   ENDIF
193800210122     C                   ENDIF
193900210122     C                   ENDIF
194000210122      *                                                                                       CLE031
194100210122     C                   ELSE
194200210122      *                                                                                       CLE031
194300210122     C     CEU014        IFEQ      'Y'                                                         CEU01
194400210122     C     ##STCY        ANDNE     *BLANKS                                                     CEU01
194500210122     C                   MOVEL     ##STCY        ##CCY                                         CEU01
194600210122     C                   EXSR      SRDCDT                                                      CEU01
194700210122     C                   Z-ADD     ##TTAL        P@FRAM                                        CEU01
194800210122     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
194900210122     C                   MOVE      ##STCY        P@TOCY                                        CEU01
195000210122     C                   EXSR      D@EURO                                                      CEU01
195100210122     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
195200210122     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
195300210122     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
195400210122     C                   ENDIF                                                                 CEU01
195500210122      *                                                                                       CLE031
195600210122     C                   ENDIF
195700210122     C*                                                                   CEU014
195800210122     C**  20 RDEs extracted for this group set so accumulate them and     CEU014
195900210122     C**  the associated data.                                            CEU014
196000210122     C*                                                                   CEU014
196100210122     C                   EXSR      SRADTA                                                      CEU01
196200210122     C                   Z-ADD     0             R1                                            CEU01
196300210122     C*                                                                   CEU014
196400210122     C     CEU014        IFEQ      'Y'                                                         CEU01
196500210122     C*                                                                   CEU014
196600210122     C** determine the Equivalent Currency                                CEU014
196700210122     C*                                                                   CEU014
196800210122     C                   MOVE      *BLANKS       EQCY              3                           CEU01
196900210122     C                   MOVE      ##CCY1        ##CCY                                         CEU01
197000210122     C                   EXSR      SRDCDT                                                      CEU01
197100210122     C     A6INCY        IFEQ      'Y'                                                         CEU01
197200210122     C                   MOVE      BKEURO        EQCY                                          CEU01
197300210122     C                   ENDIF                                                                 CEU01
197400210122     C     ##CCY1        IFEQ      BKEURO                                                      CEU01
197500210122     C                   MOVEL     ##CNUM        ##KEY2                                        CEU01
197600210122     C                   CALL      'AOCUSTR0'                                                  CEU01
197700210122     C                   PARM      *BLANKS       ##RTCD                                        CEU01
197800210122     C                   PARM      '*KEY   '     ##OPTN                                        CEU01
197900210122     C                   PARM                    ##KEY2           10                           CEU01
198000210122     C                   PARM      *BLANKS       ##KYST            7                           CEU01
198100210122     C     SDCUST        PARM      SDCUST        DSSDY                                         CEU01
198200210122     C*                                                                   CEU014
198300210122     C     ##RTCD        IFNE      *BLANK                                                      CEU01
198400210122     C                   MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
198500210122     C                   MOVEL     ##CNUM        W0KEY                          ************   CEU01
198600210122     C                   Z-ADD     18            W0ERNB                         * DBERR 18 *   CEU01
198700210122     C                   MOVEL     'MEM5004'     W0MSGD                         ************   CEU01
198800210122     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
198900210122     C                   EXSR      SRERR                                                       CEU01
199000210122     C                   ENDIF                                                                 CEU01
199100210122     C*                                                                   CEU014
199200210122     C                   MOVE      BBDINC        EQCY                                          CEU01
199300210122     C                   ENDIF                                                                 CEU01
199400210122     C*                                                                   CEU014
199500210122     C                   ENDIF                                                                 CEU01
199600210122     C*                                                                   CEU014
199700210122     C** Current Principal in Equivalent Currency                         CEU014
199800210122     C*                                                                   CEU014
199900210122     C                   ADD       1             R1                                            CEU01
200000210122     C                   CLEAR                   R#DATA                                        CEU01
200100210122     C                   CLEAR                   R#DEFN                                        CEU01
200200210122     C                   CLEAR                   #@RDE                                         CEU01
200300210122     C                   MOVEL     'C_PRN_EQ'    #@RDE                                         CEU01
200400210122     C                   MOVE      'CY'          #@RDE                                         CEU01
200500210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
200600210122     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
200700210122     C                   MOVEL     'L'           ##RDET                                        CEU01
200800210122     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
200900210122     C*                                                                   CEU014
201000210122     C     CEU014        IFEQ      'Y'                                                         CEU01
201100210122     C     EQCY          ANDNE     *BLANKS                                                     CEU01
201200210122     C                   MOVEL     EQCY          ##CCY                                         CEU01
201300210122     C                   EXSR      SRDCDT                                                      CEU01
201400210122     C                   Z-ADD     ##PAMT        P@FRAM                                        CEU01
201500210122     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
201600210122     C                   MOVE      EQCY          P@TOCY                                        CEU01
201700210122     C                   EXSR      D@EURO                                                      CEU01
201800210122     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
201900210122     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
202000210122     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
202100210122     C                   ENDIF                                                                 CEU01
202200210122     C*                                                                   CEU014
202300210122     C** Loan Total in Equivalent Currency                                CEU014
202400210122     C*                                                                   CEU014
202500210122     C                   ADD       1             R1                                            CEU01
202600210122     C                   CLEAR                   R#DATA                                        CEU01
202700210122     C                   CLEAR                   R#DEFN                                        CEU01
202800210122     C                   CLEAR                   #@RDE                                         CEU01
202900210122     C                   MOVEL     'L_TOT_EQ'    #@RDE                                         CEU01
203000210122     C                   MOVE      'CY'          #@RDE                                         CEU01
203100210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
203200210122     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
203300210122     C                   MOVEL     'L'           ##RDET                                        CEU01
203400210122     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
203500210122     C*                                                                   CEU014
203600210122     C     CEU014        IFEQ      'Y'                                                         CEU01
203700210122     C     EQCY          ANDNE     *BLANKS                                                     CEU01
203800210122     C                   MOVEL     EQCY          ##CCY                                         CEU01
203900210122     C                   EXSR      SRDCDT                                                      CEU01
204000210122     C                   Z-ADD     ##TTAL        P@FRAM                                        CEU01
204100210122     C                   MOVE      ##CCY1        P@FRCY                                        CEU01
204200210122     C                   MOVE      EQCY          P@TOCY                                        CEU01
204300210122     C                   EXSR      D@EURO                                                      CEU01
204400210122     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
204500210122     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
204600210122     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
204700210122     C                   ENDIF                                                                 CEU01
204800210122     C*                                                                   CEU014
204900210122     C** Equivalent Currency                                              CEU014
205000210122     C*                                                                   CEU014
205100210122     C                   ADD       1             R1                                            CEU01
205200210122     C                   CLEAR                   R#DATA                                        CEU01
205300210122     C                   CLEAR                   R#DEFN                                        CEU01
205400210122     C                   CLEAR                   #@RDE                                         CEU01
205500210122     C                   MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
205600210122     C                   MOVE      'Y '          #@RDE                                         CEU01
205700210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
205800210122     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
205900210122     C*                                                                   CEU014
206000210122     C     CEU014        IFEQ      'Y'                                                         CEU01
206100210122     C     EQCY          ANDNE     *BLANKS                                                     CEU01
206200210122     C                   MOVEL     EQCY          ##DATA                                        CEU01
206300210122     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
206400210122     C                   ENDIF                                                                 CEU01
206500210122     C*                                                                   CEU014
206600210122     C** Equivalent Currency Description                                  CEU014
206700210122     C*                                                                   CEU014
206800210122     C                   ADD       1             R1                                            CEU01
206900210122     C                   CLEAR                   R#DATA                                        CEU01
207000210122     C                   CLEAR                   R#DEFN                                        CEU01
207100210122     C                   CLEAR                   #@RDE                                         CEU01
207200210122     C                   MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
207300210122     C                   MOVE      'YD'          #@RDE                                         CEU01
207400210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
207500210122     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
207600210122     C*                                                                   CEU014
207700210122     C     CEU014        IFEQ      'Y'                                                         CEU01
207800210122     C     EQCY          ANDNE     *BLANKS                                                     CEU01
207900210122     C                   MOVEL     A6CYNM        ##DATA                                        CEU01
208000210122     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
208100210122     C                   ENDIF                                                                 CEU01
208200210122     C*                                                                   CEU014
208300210122     C     CLE143        IFEQ      'Y'
208400210122      *                                                                                       CLE143
208500210122      ** Original Contract Date                                                               CLE143
208600210122      *                                                                                       CLE143
208700210122     C                   ADD       1             R1
208800210122     C                   CLEAR                   R#DATA
208900210122     C                   CLEAR                   R#DEFN
209000210122     C                   CLEAR                   #@RDE
209100210122     C                   MOVEL     'ORIGCDAT'    #@RDE
209200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
209300210122     C                   MOVEL     ##OCDT        ##DATA
209400210122     C                   MOVEL     'Date  '      ##RDEC
209500210122     C                   MOVEL     R#DATA        ##D(R1)
209600210122     C                   MOVEL     R#DEFN        ##R(R1)
209700210122      *                                                                                       CLE143
209800210122      ** Effective Annual Interest Rate                                                       CLE143
209900210122      *                                                                                       CLE143
210000210122     C                   ADD       1             R1
210100210122     C                   CLEAR                   R#DATA
210200210122     C                   CLEAR                   R#DEFN
210300210122     C                   CLEAR                   #@RDE
210400210122     C                   MOVEL     'EFFAINTR'    #@RDE
210500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
210600210122     C                   MOVEL     ##EAIR        ##DATA
210700210122     C                   MOVEL     'Rate  '      ##RDEC
210800210122     C                   MOVEL     'L'           ##RDET
210900210122     C**********           MOVEL'7'       ##DCPA                                     CLE143 AR822053
211000210122     C                   MOVEL     '8'           ##DCPA
211100210122     C                   MOVEL     R#DATA        ##D(R1)
211200210122     C                   MOVEL     R#DEFN        ##R(R1)
211300210122      *                                                                                       CLE143
211400210122      ** CLE143 Switchable Feature status RDE                                                 CLE143
211500210122      *                                                                                       CLE143
211600210122     C                   ADD       1             R1
211700210122     C                   CLEAR                   R#DATA
211800210122     C                   CLEAR                   R#DEFN
211900210122     C                   CLEAR                   #@RDE
212000210122     C                   MOVEL     'CLE143F '    #@RDE
212100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
212200210122     C                   MOVEL     CLE143        ##DATA
212300210122     C                   MOVEL     R#DATA        ##D(R1)
212400210122     C                   MOVEL     R#DEFN        ##R(R1)
212500210122     C                   ENDIF
212600210122      *                                                                                       CLE143
212700210122      ** Contractual Spread                                                                   CRE073
212800210122      *                                                                                       CRE073
212900210122     C     CRE073        IFEQ      'Y'
213000210122     C                   ADD       1             R1
213100210122     C                   CLEAR                   R#DATA
213200210122     C                   CLEAR                   R#DEFN
213300210122     C                   CLEAR                   #@RDE
213400210122     C                   MOVEL     'CONTSPR'     #@RDE
213500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
213600210122     C                   MOVEL     ##CNSP        ##DATA
213700210122     C                   MOVEL     'Rate  '      ##RDEC
213800210122     C                   MOVEL     'L'           ##RDET
213900210122     C                   MOVEL     '7'           ##DCPA
214000210122     C                   MOVEL     R#DATA        ##D(R1)
214100210122     C                   MOVEL     R#DEFN        ##R(R1)
214200210122      *                                                                                       CRE073
214300210122      ** Contractual Spread Sign                                                              CRE073
214400210122      *                                                                                       CRE073
214500210122     C                   ADD       1             R1
214600210122     C                   CLEAR                   R#DATA
214700210122     C                   CLEAR                   R#DEFN
214800210122     C                   CLEAR                   #@RDE
214900210122     C                   MOVEL     'CONTSSG'     #@RDE
215000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
215100210122     C                   MOVEL     ##CNSG        ##DATA
215200210122     C                   MOVEL     R#DATA        ##D(R1)
215300210122     C                   MOVEL     R#DEFN        ##R(R1)
215400210122      *                                                                                       CRE073
215500210122      ** Rounding Method                                                                      CRE073
215600210122      *                                                                                       CRE073
215700210122     C                   ADD       1             R1
215800210122     C                   CLEAR                   R#DATA
215900210122     C                   CLEAR                   R#DEFN
216000210122     C                   CLEAR                   #@RDE
216100210122     C                   MOVEL     'RNDMTD'      #@RDE
216200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
216300210122     C                   MOVEL     ##RDMT        ##DATA
216400210122     C                   MOVEL     R#DATA        ##D(R1)
216500210122     C                   MOVEL     R#DEFN        ##R(R1)
216600210122      *                                                                                       CRE073
216700210122      ** Rounding Fraction/Decimal                                                            CRE073
216800210122      *                                                                                       CRE073
216900210122     C                   ADD       1             R1
217000210122     C                   CLEAR                   R#DATA
217100210122     C                   CLEAR                   R#DEFN
217200210122     C                   CLEAR                   #@RDE
217300210122     C                   MOVEL     'RNDFRCD'     #@RDE
217400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
217500210122     C                   MOVEL     ##RDFD        ##DATA
217600210122     C                   MOVEL     R#DATA        ##D(R1)
217700210122     C                   MOVEL     R#DEFN        ##R(R1)
217800210122      *                                                                                       CRE073
217900210122      ** CRE073 Switchable Feature                                                            CRE073
218000210122      *                                                                                       CRE073
218100210122     C                   ADD       1             R1
218200210122     C                   CLEAR                   R#DATA
218300210122     C                   CLEAR                   R#DEFN
218400210122     C                   CLEAR                   #@RDE
218500210122     C                   MOVEL     'CRE073F'     #@RDE
218600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
218700210122     C                   MOVEL     CRE073        ##DATA
218800210122     C                   MOVEL     R#DATA        ##D(R1)
218900210122     C                   MOVEL     R#DEFN        ##R(R1)
219000210122      *                                                                                       CRE073
219100210122     C                   ENDIF
219200210122      *                                                                                       CRE073
219300210122      ** CLE141 Switchable Feature status RDE                                                 CLE141
219400210122      *                                                                                       CLE141
219500210122     C                   ADD       1             R1
219600210122     C                   CLEAR                   R#DATA
219700210122     C                   CLEAR                   R#DEFN
219800210122     C                   CLEAR                   #@RDE
219900210122     C                   MOVEL     'CLE141F '    #@RDE
220000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
220100210122     C                   MOVEL     CLE141        ##DATA
220200210122     C                   MOVEL     R#DATA        ##D(R1)
220300210122     C                   MOVEL     R#DEFN        ##R(R1)
220400210122     C*                                                                                       CLE141
220500210122     C** DETERMINE THE BUSINESS DAY CONVENTION FOR INTEREST AND PRIN. SETTLEMENT              CLE141
220600210122     C*                                                                                       CLE141
220700210122     C     CLE141        IFEQ      'Y'
220800210122      *                                                                                       CLE141
220900210122      ** Interest and Principal Currency 1                                                    CLE141
221000210122      *                                                                                       CLE141
221100210122     C                   ADD       1             R1
221200210122     C                   CLEAR                   R#DATA
221300210122     C                   CLEAR                   R#DEFN
221400210122     C                   CLEAR                   #@RDE
221500210122     C                   MOVEL     'CUR1INTP'    #@RDE
221600210122     C                   MOVE      'AY'          #@RDE
221700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
221800210122     C                   MOVEL     R#DEFN        ##R(R1)
221900210122      *                                                                                       CLE141
222000210122     C     C1PI          IFNE      *BLANKS
222100210122     C                   MOVEL     C1PI          ##DATA
222200210122     C                   MOVEL     R#DATA        ##D(R1)
222300210122     C                   ENDIF
222400210122      *                                                                                       CLE141
222500210122      ** Interest and Principal Currency 2                                                    CLE141
222600210122      *                                                                                       CLE141
222700210122     C                   ADD       1             R1
222800210122     C                   CLEAR                   R#DATA
222900210122     C                   CLEAR                   R#DEFN
223000210122     C                   CLEAR                   #@RDE
223100210122     C                   MOVEL     'CUR2INTP'    #@RDE
223200210122     C                   MOVE      'AY'          #@RDE
223300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
223400210122     C                   MOVEL     R#DEFN        ##R(R1)
223500210122      *                                                                                       CLE141
223600210122     C     C2PI          IFNE      *BLANKS
223700210122     C                   MOVEL     C2PI          ##DATA
223800210122     C                   MOVEL     R#DATA        ##D(R1)
223900210122     C                   ENDIF
224000210122      *                                                                                       CLE141
224100210122      ** Interest and Principal Currency 3                                                    CLE141
224200210122      *                                                                                       CLE141
224300210122     C                   ADD       1             R1
224400210122     C                   CLEAR                   R#DATA
224500210122     C                   CLEAR                   R#DEFN
224600210122     C                   CLEAR                   #@RDE
224700210122     C                   MOVEL     'CUR3INTP'    #@RDE
224800210122     C                   MOVE      'AY'          #@RDE
224900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
225000210122     C                   MOVEL     R#DEFN        ##R(R1)
225100210122      *                                                                                       CLE141
225200210122     C     C3PI          IFNE      *BLANKS
225300210122     C                   MOVEL     C3PI          ##DATA
225400210122     C                   MOVEL     R#DATA        ##D(R1)
225500210122     C                   ENDIF
225600210122      *                                                                                       CLE141
225700210122      ** Interest and Principal Currency 4                                                    CLE141
225800210122      *                                                                                       CLE141
225900210122     C                   ADD       1             R1
226000210122     C                   CLEAR                   R#DATA
226100210122     C                   CLEAR                   R#DEFN
226200210122     C                   CLEAR                   #@RDE
226300210122     C                   MOVEL     'CUR4INTP'    #@RDE
226400210122     C                   MOVE      'AY'          #@RDE
226500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
226600210122     C                   MOVEL     R#DEFN        ##R(R1)
226700210122      *                                                                                       CLE141
226800210122     C     C4PI          IFNE      *BLANKS
226900210122     C                   MOVEL     C4PI          ##DATA
227000210122     C                   MOVEL     R#DATA        ##D(R1)
227100210122     C                   ENDIF
227200210122      *                                                                                       CLE141
227300210122      ** Interest and Principal Currency 5                                                    CLE141
227400210122      *                                                                                       CLE141
227500210122     C                   ADD       1             R1
227600210122     C                   CLEAR                   R#DATA
227700210122     C                   CLEAR                   R#DEFN
227800210122     C                   CLEAR                   #@RDE
227900210122     C                   MOVEL     'CUR5INTP'    #@RDE
228000210122     C                   MOVE      'AY'          #@RDE
228100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
228200210122     C                   MOVEL     R#DEFN        ##R(R1)
228300210122      *                                                                                       CLE141
228400210122     C     C5PI          IFNE      *BLANKS
228500210122     C                   MOVEL     C5PI          ##DATA
228600210122     C                   MOVEL     R#DATA        ##D(R1)
228700210122     C                   ENDIF
228800210122      *                                                                                       CLE141
228900210122      ** Interest and Principal Currency 6                                                    CLE141
229000210122      *                                                                                       CLE141
229100210122     C                   ADD       1             R1
229200210122     C                   CLEAR                   R#DATA
229300210122     C                   CLEAR                   R#DEFN
229400210122     C                   CLEAR                   #@RDE
229500210122     C                   MOVEL     'CUR6INTP'    #@RDE
229600210122     C                   MOVE      'AY'          #@RDE
229700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
229800210122     C                   MOVEL     R#DEFN        ##R(R1)
229900210122      *                                                                                       CLE141
230000210122     C     C6PI          IFNE      *BLANKS
230100210122     C                   MOVEL     C6PI          ##DATA
230200210122     C                   MOVEL     R#DATA        ##D(R1)
230300210122     C                   ENDIF
230400210122      *                                                                                       CLE141
230500210122      ** Interest and Principal Currency 7                                                    CLE141
230600210122      *                                                                                       CLE141
230700210122     C                   ADD       1             R1
230800210122     C                   CLEAR                   R#DATA
230900210122     C                   CLEAR                   R#DEFN
231000210122     C                   CLEAR                   #@RDE
231100210122     C                   MOVEL     'CUR7INTP'    #@RDE
231200210122     C                   MOVE      'AY'          #@RDE
231300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
231400210122     C                   MOVEL     R#DEFN        ##R(R1)
231500210122      *                                                                                       CLE141
231600210122     C     C7PI          IFNE      *BLANKS
231700210122     C                   MOVEL     C7PI          ##DATA
231800210122     C                   MOVEL     R#DATA        ##D(R1)
231900210122     C                   ENDIF
232000210122     C*                                                                                       CLE141
232100210122     C**  20 RDEs extracted for this group set so accumulate them and                         CLE141
232200210122     C**  the associated data.                                                                CLE141
232300210122     C*                                                                                       CLE141
232400210122     C                   EXSR      SRADTA
232500210122     C                   Z-ADD     0             R1
232600210122      *                                                                                       CLE141
232700210122      ** Interest and Principal Currency 8                                                    CLE141
232800210122      *                                                                                       CLE141
232900210122     C                   ADD       1             R1
233000210122     C                   CLEAR                   R#DATA
233100210122     C                   CLEAR                   R#DEFN
233200210122     C                   CLEAR                   #@RDE
233300210122     C                   MOVEL     'CUR8INTP'    #@RDE
233400210122     C                   MOVE      'AY'          #@RDE
233500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
233600210122     C                   MOVEL     R#DEFN        ##R(R1)
233700210122      *                                                                                       CLE141
233800210122     C     C8PI          IFNE      *BLANKS
233900210122     C                   MOVEL     C8PI          ##DATA
234000210122     C                   MOVEL     R#DATA        ##D(R1)
234100210122     C                   ENDIF
234200210122      *                                                                                       CLE141
234300210122      ** Interest and Principal Currency 9                                                    CLE141
234400210122      *                                                                                       CLE141
234500210122     C                   ADD       1             R1
234600210122     C                   CLEAR                   R#DATA
234700210122     C                   CLEAR                   R#DEFN
234800210122     C                   CLEAR                   #@RDE
234900210122     C                   MOVEL     'CUR9INTP'    #@RDE
235000210122     C                   MOVE      'AY'          #@RDE
235100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
235200210122     C                   MOVEL     R#DEFN        ##R(R1)
235300210122      *                                                                                       CLE141
235400210122     C     C9PI          IFNE      *BLANKS
235500210122     C                   MOVEL     C9PI          ##DATA
235600210122     C                   MOVEL     R#DATA        ##D(R1)
235700210122     C                   ENDIF
235800210122      *                                                                                       CLE141
235900210122      ** Interest and Principal Currency 10                                                   CLE141
236000210122      *                                                                                       CLE141
236100210122     C                   ADD       1             R1
236200210122     C                   CLEAR                   R#DATA
236300210122     C                   CLEAR                   R#DEFN
236400210122     C                   CLEAR                   #@RDE
236500210122     C                   MOVEL     'CUR0INTP'    #@RDE
236600210122     C                   MOVE      'AY'          #@RDE
236700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
236800210122     C                   MOVEL     R#DEFN        ##R(R1)
236900210122      *                                                                                       CLE141
237000210122     C     C0PI          IFNE      *BLANKS
237100210122     C                   MOVEL     C0PI          ##DATA
237200210122     C                   MOVEL     R#DATA        ##D(R1)
237300210122     C                   ENDIF
237400210122      *                                                                                       CLE141
237500210122      ** Interest and Principal Location 1                                                    CLE141
237600210122      *                                                                                       CLE141
237700210122     C                   ADD       1             R1
237800210122     C                   CLEAR                   R#DATA
237900210122     C                   CLEAR                   R#DEFN
238000210122     C                   CLEAR                   #@RDE
238100210122     C                   MOVEL     'LOC1INTP'    #@RDE
238200210122     C                   MOVE      'AY'          #@RDE
238300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
238400210122     C                   MOVEL     R#DEFN        ##R(R1)
238500210122      *                                                                                       CLE141
238600210122     C     L1PI          IFNE      *BLANKS
238700210122     C                   MOVEL     L1PI          ##DATA
238800210122     C                   MOVEL     R#DATA        ##D(R1)
238900210122      *                                                                                       CLE141
239000210122      ** Retrieve Location Name 1                                                             CLE141
239100210122      *                                                                                       CLE141
239200210122     C                   CALL      'AOLOCNR0'
239300210122     C                   PARM      *BLANKS       UFRTCD            7
239400210122     C                   PARM      '*KEY    '    UFOPTN            7
239500210122     C                   PARM      L1PI          UFLOCN            3
239600210122     C     SDLOCN        PARM      SDLOCN        DSFDY
239700210122      *                                                                                       CLE141
239800210122     C                   ADD       1             R1
239900210122     C                   CLEAR                   R#DATA
240000210122     C                   CLEAR                   R#DEFN
240100210122     C                   CLEAR                   #@RDE
240200210122     C                   MOVEL     'LON1INTP'    #@RDE
240300210122     C                   MOVE      'AY'          #@RDE
240400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
240500210122     C                   MOVEL     R#DEFN        ##R(R1)
240600210122     C                   MOVEL     DVLCNM        ##DATA
240700210122     C                   MOVEL     R#DATA        ##D(R1)
240800210122     C                   ENDIF
240900210122      *                                                                                       CLE141
241000210122      ** Interest and Principal Location 2                                                    CLE141
241100210122      *                                                                                       CLE141
241200210122     C                   ADD       1             R1
241300210122     C                   CLEAR                   R#DATA
241400210122     C                   CLEAR                   R#DEFN
241500210122     C                   CLEAR                   #@RDE
241600210122     C                   MOVEL     'LOC2INTP'    #@RDE
241700210122     C                   MOVE      'AY'          #@RDE
241800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
241900210122     C                   MOVEL     R#DEFN        ##R(R1)
242000210122      *                                                                                       CLE141
242100210122     C     L2PI          IFNE      *BLANKS
242200210122     C                   MOVEL     L2PI          ##DATA
242300210122     C                   MOVEL     R#DATA        ##D(R1)
242400210122      *                                                                                       CLE141
242500210122      ** Retrieve Location Name 2                                                             CLE141
242600210122      *                                                                                       CLE141
242700210122     C                   CALL      'AOLOCNR0'
242800210122     C                   PARM      *BLANKS       UFRTCD
242900210122     C                   PARM      '*KEY    '    UFOPTN
243000210122     C                   PARM      L2PI          UFLOCN
243100210122     C     SDLOCN        PARM      SDLOCN        DSFDY
243200210122      *                                                                                       CLE141
243300210122     C                   ADD       1             R1
243400210122     C                   CLEAR                   R#DATA
243500210122     C                   CLEAR                   R#DEFN
243600210122     C                   CLEAR                   #@RDE
243700210122     C                   MOVEL     'LON2INTP'    #@RDE
243800210122     C                   MOVE      'AY'          #@RDE
243900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
244000210122     C                   MOVEL     R#DEFN        ##R(R1)
244100210122     C                   MOVEL     DVLCNM        ##DATA
244200210122     C                   MOVEL     R#DATA        ##D(R1)
244300210122     C                   ENDIF
244400210122      *                                                                                       CLE141
244500210122      ** Interest and Principal Location 3                                                    CLE141
244600210122      *                                                                                       CLE141
244700210122     C                   ADD       1             R1
244800210122     C                   CLEAR                   R#DATA
244900210122     C                   CLEAR                   R#DEFN
245000210122     C                   CLEAR                   #@RDE
245100210122     C                   MOVEL     'LOC3INTP'    #@RDE
245200210122     C                   MOVE      'AY'          #@RDE
245300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
245400210122     C                   MOVEL     R#DEFN        ##R(R1)
245500210122      *                                                                                       CLE141
245600210122     C     L3PI          IFNE      *BLANKS
245700210122     C                   MOVEL     L3PI          ##DATA
245800210122     C                   MOVEL     R#DATA        ##D(R1)
245900210122      *                                                                                       CLE141
246000210122      ** Retrieve Location Name 3                                                             CLE141
246100210122      *                                                                                       CLE141
246200210122     C                   CALL      'AOLOCNR0'
246300210122     C                   PARM      *BLANKS       UFRTCD
246400210122     C                   PARM      '*KEY    '    UFOPTN
246500210122     C                   PARM      L3PI          UFLOCN
246600210122     C     SDLOCN        PARM      SDLOCN        DSFDY
246700210122      *                                                                                       CLE141
246800210122     C                   ADD       1             R1
246900210122     C                   CLEAR                   R#DATA
247000210122     C                   CLEAR                   R#DEFN
247100210122     C                   CLEAR                   #@RDE
247200210122     C                   MOVEL     'LON3INTP'    #@RDE
247300210122     C                   MOVE      'AY'          #@RDE
247400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
247500210122     C                   MOVEL     R#DEFN        ##R(R1)
247600210122     C                   MOVEL     DVLCNM        ##DATA
247700210122     C                   MOVEL     R#DATA        ##D(R1)
247800210122     C                   ENDIF
247900210122      *                                                                                       CLE141
248000210122      ** Interest and Principal Location 4                                                    CLE141
248100210122      *                                                                                       CLE141
248200210122     C                   ADD       1             R1
248300210122     C                   CLEAR                   R#DATA
248400210122     C                   CLEAR                   R#DEFN
248500210122     C                   CLEAR                   #@RDE
248600210122     C                   MOVEL     'LOC4INTP'    #@RDE
248700210122     C                   MOVE      'AY'          #@RDE
248800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
248900210122     C                   MOVEL     R#DEFN        ##R(R1)
249000210122      *                                                                                       CLE141
249100210122     C     L4PI          IFNE      *BLANKS
249200210122     C                   MOVEL     L4PI          ##DATA
249300210122     C                   MOVEL     R#DATA        ##D(R1)
249400210122      *                                                                                       CLE141
249500210122      ** Retrieve Location Name 4                                                             CLE141
249600210122      *                                                                                       CLE141
249700210122     C                   CALL      'AOLOCNR0'
249800210122     C                   PARM      *BLANKS       UFRTCD
249900210122     C                   PARM      '*KEY    '    UFOPTN
250000210122     C                   PARM      L4PI          UFLOCN
250100210122     C     SDLOCN        PARM      SDLOCN        DSFDY
250200210122      *                                                                                       CLE141
250300210122     C                   ADD       1             R1
250400210122     C                   CLEAR                   R#DATA
250500210122     C                   CLEAR                   R#DEFN
250600210122     C                   CLEAR                   #@RDE
250700210122     C                   MOVEL     'LON4INTP'    #@RDE
250800210122     C                   MOVE      'AY'          #@RDE
250900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
251000210122     C                   MOVEL     R#DEFN        ##R(R1)
251100210122     C                   MOVEL     DVLCNM        ##DATA
251200210122     C                   MOVEL     R#DATA        ##D(R1)
251300210122     C                   ENDIF
251400210122      *                                                                                       CLE141
251500210122      ** Interest and Principal Location 5                                                    CLE141
251600210122      *                                                                                       CLE141
251700210122     C                   ADD       1             R1
251800210122     C                   CLEAR                   R#DATA
251900210122     C                   CLEAR                   R#DEFN
252000210122     C                   CLEAR                   #@RDE
252100210122     C                   MOVEL     'LOC5INTP'    #@RDE
252200210122     C                   MOVE      'AY'          #@RDE
252300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
252400210122     C                   MOVEL     R#DEFN        ##R(R1)
252500210122      *                                                                                       CLE141
252600210122     C     L5PI          IFNE      *BLANKS
252700210122     C                   MOVEL     L5PI          ##DATA
252800210122     C                   MOVEL     R#DATA        ##D(R1)
252900210122      *                                                                                       CLE141
253000210122      ** Retrieve Location Name 5                                                             CLE141
253100210122      *                                                                                       CLE141
253200210122     C                   CALL      'AOLOCNR0'
253300210122     C                   PARM      *BLANKS       UFRTCD
253400210122     C                   PARM      '*KEY    '    UFOPTN
253500210122     C                   PARM      L5PI          UFLOCN
253600210122     C     SDLOCN        PARM      SDLOCN        DSFDY
253700210122      *                                                                                       CLE141
253800210122     C                   ADD       1             R1
253900210122     C                   CLEAR                   R#DATA
254000210122     C                   CLEAR                   R#DEFN
254100210122     C                   CLEAR                   #@RDE
254200210122     C                   MOVEL     'LON5INTP'    #@RDE
254300210122     C                   MOVE      'AY'          #@RDE
254400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
254500210122     C                   MOVEL     R#DEFN        ##R(R1)
254600210122     C                   MOVEL     DVLCNM        ##DATA
254700210122     C                   MOVEL     R#DATA        ##D(R1)
254800210122     C                   ENDIF
254900210122      *                                                                                       CLE141
255000210122      ** Interest and Principal Location 6                                                    CLE141
255100210122      *                                                                                       CLE141
255200210122     C                   ADD       1             R1
255300210122     C                   CLEAR                   R#DATA
255400210122     C                   CLEAR                   R#DEFN
255500210122     C                   CLEAR                   #@RDE
255600210122     C                   MOVEL     'LOC6INTP'    #@RDE
255700210122     C                   MOVE      'AY'          #@RDE
255800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
255900210122     C                   MOVEL     R#DEFN        ##R(R1)
256000210122      *                                                                                       CLE141
256100210122     C     L6PI          IFNE      *BLANKS
256200210122     C                   MOVEL     L6PI          ##DATA
256300210122     C                   MOVEL     R#DATA        ##D(R1)
256400210122      *                                                                                       CLE141
256500210122      ** Retrieve Location Name 6                                                             CLE141
256600210122      *                                                                                       CLE141
256700210122     C                   CALL      'AOLOCNR0'
256800210122     C                   PARM      *BLANKS       UFRTCD
256900210122     C                   PARM      '*KEY    '    UFOPTN
257000210122     C                   PARM      L6PI          UFLOCN
257100210122     C     SDLOCN        PARM      SDLOCN        DSFDY
257200210122      *                                                                                       CLE141
257300210122     C                   ADD       1             R1
257400210122     C                   CLEAR                   R#DATA
257500210122     C                   CLEAR                   R#DEFN
257600210122     C                   CLEAR                   #@RDE
257700210122     C                   MOVEL     'LON6INTP'    #@RDE
257800210122     C                   MOVE      'AY'          #@RDE
257900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
258000210122     C                   MOVEL     R#DEFN        ##R(R1)
258100210122     C                   MOVEL     DVLCNM        ##DATA
258200210122     C                   MOVEL     R#DATA        ##D(R1)
258300210122     C                   ENDIF
258400210122      *                                                                                       CLE141
258500210122      ** Interest and Principal Location 7                                                    CLE141
258600210122      *                                                                                       CLE141
258700210122     C                   ADD       1             R1
258800210122     C                   CLEAR                   R#DATA
258900210122     C                   CLEAR                   R#DEFN
259000210122     C                   CLEAR                   #@RDE
259100210122     C                   MOVEL     'LOC7INTP'    #@RDE
259200210122     C                   MOVE      'AY'          #@RDE
259300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
259400210122     C                   MOVEL     R#DEFN        ##R(R1)
259500210122      *                                                                                       CLE141
259600210122     C     L7PI          IFNE      *BLANKS
259700210122     C                   MOVEL     L7PI          ##DATA
259800210122     C                   MOVEL     R#DATA        ##D(R1)
259900210122      *                                                                                       CLE141
260000210122      ** Retrieve Location Name 7                                                             CLE141
260100210122      *                                                                                       CLE141
260200210122     C                   CALL      'AOLOCNR0'
260300210122     C                   PARM      *BLANKS       UFRTCD
260400210122     C                   PARM      '*KEY    '    UFOPTN
260500210122     C                   PARM      L7PI          UFLOCN
260600210122     C     SDLOCN        PARM      SDLOCN        DSFDY
260700210122      *                                                                                       CLE141
260800210122     C                   ADD       1             R1
260900210122     C                   CLEAR                   R#DATA
261000210122     C                   CLEAR                   R#DEFN
261100210122     C                   CLEAR                   #@RDE
261200210122     C                   MOVEL     'LON7INTP'    #@RDE
261300210122     C                   MOVE      'AY'          #@RDE
261400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
261500210122     C                   MOVEL     R#DEFN        ##R(R1)
261600210122     C                   MOVEL     DVLCNM        ##DATA
261700210122     C                   MOVEL     R#DATA        ##D(R1)
261800210122     C                   ENDIF
261900210122      *                                                                                       CLE141
262000210122      ** Interest and Principal Location 8                                                    CLE141
262100210122      *                                                                                       CLE141
262200210122     C                   ADD       1             R1
262300210122     C                   CLEAR                   R#DATA
262400210122     C                   CLEAR                   R#DEFN
262500210122     C                   CLEAR                   #@RDE
262600210122     C                   MOVEL     'LOC8INTP'    #@RDE
262700210122     C                   MOVE      'AY'          #@RDE
262800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
262900210122     C                   MOVEL     R#DEFN        ##R(R1)
263000210122      *                                                                                       CLE141
263100210122     C     L8PI          IFNE      *BLANKS
263200210122     C                   MOVEL     L8PI          ##DATA
263300210122     C                   MOVEL     R#DATA        ##D(R1)
263400210122      *                                                                                       CLE141
263500210122      ** Retrieve Location Name 8                                                             CLE141
263600210122      *                                                                                       CLE141
263700210122     C                   CALL      'AOLOCNR0'
263800210122     C                   PARM      *BLANKS       UFRTCD
263900210122     C                   PARM      '*KEY    '    UFOPTN
264000210122     C                   PARM      L8PI          UFLOCN
264100210122     C     SDLOCN        PARM      SDLOCN        DSFDY
264200210122      *                                                                                       CLE141
264300210122     C                   ADD       1             R1
264400210122     C                   CLEAR                   R#DATA
264500210122     C                   CLEAR                   R#DEFN
264600210122     C                   CLEAR                   #@RDE
264700210122     C                   MOVEL     'LON8INTP'    #@RDE
264800210122     C                   MOVE      'AY'          #@RDE
264900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
265000210122     C                   MOVEL     R#DEFN        ##R(R1)
265100210122     C                   MOVEL     DVLCNM        ##DATA
265200210122     C                   MOVEL     R#DATA        ##D(R1)
265300210122     C                   ENDIF
265400210122     C*                                                                                       CLE141
265500210122     C**  20 RDEs extracted for this group set so accumulate them and                         CLE141
265600210122     C**  the associated data.                                                                CLE141
265700210122     C*                                                                                       CLE141
265800210122     C                   EXSR      SRADTA
265900210122     C                   Z-ADD     0             R1
266000210122      *                                                                                       CLE141
266100210122      ** Interest and Principal Location 9                                                    CLE141
266200210122      *                                                                                       CLE141
266300210122     C                   ADD       1             R1
266400210122     C                   CLEAR                   R#DATA
266500210122     C                   CLEAR                   R#DEFN
266600210122     C                   CLEAR                   #@RDE
266700210122     C                   MOVEL     'LOC9INTP'    #@RDE
266800210122     C                   MOVE      'AY'          #@RDE
266900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
267000210122     C                   MOVEL     R#DEFN        ##R(R1)
267100210122      *                                                                                       CLE141
267200210122     C     L9PI          IFNE      *BLANKS
267300210122     C                   MOVEL     L9PI          ##DATA
267400210122     C                   MOVEL     R#DATA        ##D(R1)
267500210122      *                                                                                       CLE141
267600210122      ** Retrieve Location Name 9                                                             CLE141
267700210122      *                                                                                       CLE141
267800210122     C                   CALL      'AOLOCNR0'
267900210122     C                   PARM      *BLANKS       UFRTCD
268000210122     C                   PARM      '*KEY    '    UFOPTN
268100210122     C                   PARM      L9PI          UFLOCN
268200210122     C     SDLOCN        PARM      SDLOCN        DSFDY
268300210122      *                                                                                       CLE141
268400210122     C                   ADD       1             R1
268500210122     C                   CLEAR                   R#DATA
268600210122     C                   CLEAR                   R#DEFN
268700210122     C                   CLEAR                   #@RDE
268800210122     C                   MOVEL     'LON9INTP'    #@RDE
268900210122     C                   MOVE      'AY'          #@RDE
269000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
269100210122     C                   MOVEL     R#DEFN        ##R(R1)
269200210122     C                   MOVEL     DVLCNM        ##DATA
269300210122     C                   MOVEL     R#DATA        ##D(R1)
269400210122     C                   ENDIF
269500210122      *                                                                                       CLE141
269600210122      ** Interest and Principal Location 10                                                   CLE141
269700210122      *                                                                                       CLE141
269800210122     C                   ADD       1             R1
269900210122     C                   CLEAR                   R#DATA
270000210122     C                   CLEAR                   R#DEFN
270100210122     C                   CLEAR                   #@RDE
270200210122     C                   MOVEL     'LOC0INTP'    #@RDE
270300210122     C                   MOVE      'AY'          #@RDE
270400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
270500210122     C                   MOVEL     R#DEFN        ##R(R1)
270600210122      *                                                                                       CLE141
270700210122     C     L0PI          IFNE      *BLANKS
270800210122     C                   MOVEL     L0PI          ##DATA
270900210122     C                   MOVEL     R#DATA        ##D(R1)
271000210122      *                                                                                       CLE141
271100210122      ** Retrieve Location Name 10                                                            CLE141
271200210122      *                                                                                       CLE141
271300210122     C                   CALL      'AOLOCNR0'
271400210122     C                   PARM      *BLANKS       UFRTCD
271500210122     C                   PARM      '*KEY    '    UFOPTN
271600210122     C                   PARM      L0PI          UFLOCN
271700210122     C     SDLOCN        PARM      SDLOCN        DSFDY
271800210122      *                                                                                       CLE141
271900210122     C                   ADD       1             R1
272000210122     C                   CLEAR                   R#DATA
272100210122     C                   CLEAR                   R#DEFN
272200210122     C                   CLEAR                   #@RDE
272300210122     C                   MOVEL     'LON0INTP'    #@RDE
272400210122     C                   MOVE      'AY'          #@RDE
272500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
272600210122     C                   MOVEL     R#DEFN        ##R(R1)
272700210122     C                   MOVEL     DVLCNM        ##DATA
272800210122     C                   MOVEL     R#DATA        ##D(R1)
272900210122     C                   ENDIF
273000210122      *                                                                                       CLE141
273100210122      ** Rollover and Rate Fixing Currency 1                                                  CLE141
273200210122      *                                                                                       CLE141
273300210122     C                   ADD       1             R1
273400210122     C                   CLEAR                   R#DATA
273500210122     C                   CLEAR                   R#DEFN
273600210122     C                   CLEAR                   #@RDE
273700210122     C                   MOVEL     'CUR1ROLL'    #@RDE
273800210122     C                   MOVE      'RT'          #@RDE
273900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
274000210122     C                   MOVEL     R#DEFN        ##R(R1)
274100210122      *                                                                                       CLE141
274200210122     C     C1PR          IFNE      *BLANKS
274300210122     C                   MOVEL     C1PR          ##DATA
274400210122     C                   MOVEL     R#DATA        ##D(R1)
274500210122     C                   ENDIF
274600210122      *                                                                                       CLE141
274700210122      ** Rollover and Rate Fixing Currency 2                                                  CLE141
274800210122      *                                                                                       CLE141
274900210122     C                   ADD       1             R1
275000210122     C                   CLEAR                   R#DATA
275100210122     C                   CLEAR                   R#DEFN
275200210122     C                   CLEAR                   #@RDE
275300210122     C                   MOVEL     'CUR2ROLL'    #@RDE
275400210122     C                   MOVE      'RT'          #@RDE
275500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
275600210122     C                   MOVEL     R#DEFN        ##R(R1)
275700210122      *                                                                                       CLE141
275800210122     C     C2PR          IFNE      *BLANKS
275900210122     C                   MOVEL     C2PR          ##DATA
276000210122     C                   MOVEL     R#DATA        ##D(R1)
276100210122     C                   ENDIF
276200210122      *                                                                                       CLE141
276300210122      ** Rollover and Rate Fixing Currency 3                                                  CLE141
276400210122      *                                                                                       CLE141
276500210122     C                   ADD       1             R1
276600210122     C                   CLEAR                   R#DATA
276700210122     C                   CLEAR                   R#DEFN
276800210122     C                   CLEAR                   #@RDE
276900210122     C                   MOVEL     'CUR3ROLL'    #@RDE
277000210122     C                   MOVE      'RT'          #@RDE
277100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
277200210122     C                   MOVEL     R#DEFN        ##R(R1)
277300210122      *                                                                                       CLE141
277400210122     C     C3PR          IFNE      *BLANKS
277500210122     C                   MOVEL     C3PR          ##DATA
277600210122     C                   MOVEL     R#DATA        ##D(R1)
277700210122     C                   ENDIF
277800210122      *                                                                                       CLE141
277900210122      ** Rollover and Rate Fixing Currency 4                                                  CLE141
278000210122      *                                                                                       CLE141
278100210122     C                   ADD       1             R1
278200210122     C                   CLEAR                   R#DATA
278300210122     C                   CLEAR                   R#DEFN
278400210122     C                   CLEAR                   #@RDE
278500210122     C                   MOVEL     'CUR4ROLL'    #@RDE
278600210122     C                   MOVE      'RT'          #@RDE
278700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
278800210122     C                   MOVEL     R#DEFN        ##R(R1)
278900210122      *                                                                                       CLE141
279000210122     C     C4PR          IFNE      *BLANKS
279100210122     C                   MOVEL     C4PR          ##DATA
279200210122     C                   MOVEL     R#DATA        ##D(R1)
279300210122     C                   ENDIF
279400210122      *                                                                                       CLE141
279500210122      ** Rollover and Rate Fixing Currency 5                                                  CLE141
279600210122      *                                                                                       CLE141
279700210122     C                   ADD       1             R1
279800210122     C                   CLEAR                   R#DATA
279900210122     C                   CLEAR                   R#DEFN
280000210122     C                   CLEAR                   #@RDE
280100210122     C                   MOVEL     'CUR5ROLL'    #@RDE
280200210122     C                   MOVE      'RT'          #@RDE
280300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
280400210122     C                   MOVEL     R#DEFN        ##R(R1)
280500210122      *                                                                                       CLE141
280600210122     C     C5PR          IFNE      *BLANKS
280700210122     C                   MOVEL     C5PR          ##DATA
280800210122     C                   MOVEL     R#DATA        ##D(R1)
280900210122     C                   ENDIF
281000210122      *                                                                                       CLE141
281100210122      ** Rollover and Rate Fixing Currency 6                                                  CLE141
281200210122      *                                                                                       CLE141
281300210122     C                   ADD       1             R1
281400210122     C                   CLEAR                   R#DATA
281500210122     C                   CLEAR                   R#DEFN
281600210122     C                   CLEAR                   #@RDE
281700210122     C                   MOVEL     'CUR6ROLL'    #@RDE
281800210122     C                   MOVE      'RT'          #@RDE
281900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
282000210122     C                   MOVEL     R#DEFN        ##R(R1)
282100210122      *                                                                                       CLE141
282200210122     C     C6PR          IFNE      *BLANKS
282300210122     C                   MOVEL     C6PR          ##DATA
282400210122     C                   MOVEL     R#DATA        ##D(R1)
282500210122     C                   ENDIF
282600210122      *                                                                                       CLE141
282700210122      ** Rollover and Rate Fixing Currency 7                                                  CLE141
282800210122      *                                                                                       CLE141
282900210122     C                   ADD       1             R1
283000210122     C                   CLEAR                   R#DATA
283100210122     C                   CLEAR                   R#DEFN
283200210122     C                   CLEAR                   #@RDE
283300210122     C                   MOVEL     'CUR7ROLL'    #@RDE
283400210122     C                   MOVE      'RT'          #@RDE
283500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
283600210122     C                   MOVEL     R#DEFN        ##R(R1)
283700210122      *                                                                                       CLE141
283800210122     C     C7PR          IFNE      *BLANKS
283900210122     C                   MOVEL     C7PR          ##DATA
284000210122     C                   MOVEL     R#DATA        ##D(R1)
284100210122     C                   ENDIF
284200210122      *                                                                                       CLE141
284300210122      ** Rollover and Rate Fixing Currency 8                                                  CLE141
284400210122      *                                                                                       CLE141
284500210122     C                   ADD       1             R1
284600210122     C                   CLEAR                   R#DATA
284700210122     C                   CLEAR                   R#DEFN
284800210122     C                   CLEAR                   #@RDE
284900210122     C                   MOVEL     'CUR8ROLL'    #@RDE
285000210122     C                   MOVE      'RT'          #@RDE
285100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
285200210122     C                   MOVEL     R#DEFN        ##R(R1)
285300210122      *                                                                                       CLE141
285400210122     C     C8PR          IFNE      *BLANKS
285500210122     C                   MOVEL     C8PR          ##DATA
285600210122     C                   MOVEL     R#DATA        ##D(R1)
285700210122     C                   ENDIF
285800210122      *                                                                                       CLE141
285900210122      ** Rollover and Rate Fixing Currency 9                                                  CLE141
286000210122      *                                                                                       CLE141
286100210122     C                   ADD       1             R1
286200210122     C                   CLEAR                   R#DATA
286300210122     C                   CLEAR                   R#DEFN
286400210122     C                   CLEAR                   #@RDE
286500210122     C                   MOVEL     'CUR9ROLL'    #@RDE
286600210122     C                   MOVE      'RT'          #@RDE
286700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
286800210122     C                   MOVEL     R#DEFN        ##R(R1)
286900210122      *                                                                                       CLE141
287000210122     C     C9PR          IFNE      *BLANKS
287100210122     C                   MOVEL     C9PR          ##DATA
287200210122     C                   MOVEL     R#DATA        ##D(R1)
287300210122     C                   ENDIF
287400210122      *                                                                                       CLE141
287500210122      ** Rollover and Rate Fixing Currency 10                                                 CLE141
287600210122      *                                                                                       CLE141
287700210122     C                   ADD       1             R1
287800210122     C                   CLEAR                   R#DATA
287900210122     C                   CLEAR                   R#DEFN
288000210122     C                   CLEAR                   #@RDE
288100210122     C                   MOVEL     'CUR0ROLL'    #@RDE
288200210122     C                   MOVE      'RT'          #@RDE
288300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
288400210122     C                   MOVEL     R#DEFN        ##R(R1)
288500210122      *                                                                                       CLE141
288600210122     C     C0PR          IFNE      *BLANKS
288700210122     C                   MOVEL     C0PR          ##DATA
288800210122     C                   MOVEL     R#DATA        ##D(R1)
288900210122     C                   ENDIF
289000210122      *                                                                                       CLE141
289100210122      ** Rollover and Rate Fixing Location 1                                                  CLE141
289200210122      *                                                                                       CLE141
289300210122     C                   ADD       1             R1
289400210122     C                   CLEAR                   R#DATA
289500210122     C                   CLEAR                   R#DEFN
289600210122     C                   CLEAR                   #@RDE
289700210122     C                   MOVEL     'LOC1ROLL'    #@RDE
289800210122     C                   MOVE      'RT'          #@RDE
289900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
290000210122     C                   MOVEL     R#DEFN        ##R(R1)
290100210122      *                                                                                       CLE141
290200210122     C     L1PR          IFNE      *BLANKS
290300210122     C                   MOVEL     L1PR          ##DATA
290400210122     C                   MOVEL     R#DATA        ##D(R1)
290500210122      *                                                                                       CLE141
290600210122      ** Retrieve Location Name 1                                                             CLE141
290700210122      *                                                                                       CLE141
290800210122     C                   CALL      'AOLOCNR0'
290900210122     C                   PARM      *BLANKS       UFRTCD
291000210122     C                   PARM      '*KEY    '    UFOPTN
291100210122     C                   PARM      L1PR          UFLOCN
291200210122     C     SDLOCN        PARM      SDLOCN        DSFDY
291300210122      *                                                                                       CLE141
291400210122     C                   ADD       1             R1
291500210122     C                   CLEAR                   R#DATA
291600210122     C                   CLEAR                   R#DEFN
291700210122     C                   CLEAR                   #@RDE
291800210122     C                   MOVEL     'LON1ROLL'    #@RDE
291900210122     C                   MOVE      'RT'          #@RDE
292000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
292100210122     C                   MOVEL     R#DEFN        ##R(R1)
292200210122     C                   MOVEL     DVLCNM        ##DATA
292300210122     C                   MOVEL     R#DATA        ##D(R1)
292400210122     C                   ENDIF
292500210122      *                                                                                       CLE141
292600210122      ** Rollover and Rate Fixing Location 2                                                  CLE141
292700210122      *                                                                                       CLE141
292800210122     C                   ADD       1             R1
292900210122     C                   CLEAR                   R#DATA
293000210122     C                   CLEAR                   R#DEFN
293100210122     C                   CLEAR                   #@RDE
293200210122     C                   MOVEL     'LOC2ROLL'    #@RDE
293300210122     C                   MOVE      'RT'          #@RDE
293400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
293500210122     C                   MOVEL     R#DEFN        ##R(R1)
293600210122      *                                                                                       CLE141
293700210122     C     L2PR          IFNE      *BLANKS
293800210122     C                   MOVEL     L2PR          ##DATA
293900210122     C                   MOVEL     R#DATA        ##D(R1)
294000210122      *                                                                                       CLE141
294100210122      ** Retrieve Location Name 1                                                             CLE141
294200210122      *                                                                                       CLE141
294300210122     C                   CALL      'AOLOCNR0'
294400210122     C                   PARM      *BLANKS       UFRTCD
294500210122     C                   PARM      '*KEY    '    UFOPTN
294600210122     C                   PARM      L2PR          UFLOCN
294700210122     C     SDLOCN        PARM      SDLOCN        DSFDY
294800210122      *                                                                                       CLE141
294900210122     C                   ADD       1             R1
295000210122     C                   CLEAR                   R#DATA
295100210122     C                   CLEAR                   R#DEFN
295200210122     C                   CLEAR                   #@RDE
295300210122     C                   MOVEL     'LON2ROLL'    #@RDE
295400210122     C                   MOVE      'RT'          #@RDE
295500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
295600210122     C                   MOVEL     R#DEFN        ##R(R1)
295700210122     C                   MOVEL     DVLCNM        ##DATA
295800210122     C                   MOVEL     R#DATA        ##D(R1)
295900210122     C                   ENDIF
296000210122      *                                                                                       CLE141
296100210122      ** Rollover and Rate Fixing Location 3                                                  CLE141
296200210122      *                                                                                       CLE141
296300210122     C                   ADD       1             R1
296400210122     C                   CLEAR                   R#DATA
296500210122     C                   CLEAR                   R#DEFN
296600210122     C                   CLEAR                   #@RDE
296700210122     C                   MOVEL     'LOC3ROLL'    #@RDE
296800210122     C                   MOVE      'RT'          #@RDE
296900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
297000210122     C                   MOVEL     R#DEFN        ##R(R1)
297100210122      *                                                                                       CLE141
297200210122     C     L3PR          IFNE      *BLANKS
297300210122     C                   MOVEL     L3PR          ##DATA
297400210122     C                   MOVEL     R#DATA        ##D(R1)
297500210122      *                                                                                       CLE141
297600210122      ** Retrieve Location Name 3                                                             CLE141
297700210122      *                                                                                       CLE141
297800210122     C                   CALL      'AOLOCNR0'
297900210122     C                   PARM      *BLANKS       UFRTCD
298000210122     C                   PARM      '*KEY    '    UFOPTN
298100210122     C                   PARM      L3PR          UFLOCN
298200210122     C     SDLOCN        PARM      SDLOCN        DSFDY
298300210122      *                                                                                       CLE141
298400210122     C                   ADD       1             R1
298500210122     C                   CLEAR                   R#DATA
298600210122     C                   CLEAR                   R#DEFN
298700210122     C                   CLEAR                   #@RDE
298800210122     C                   MOVEL     'LON3ROLL'    #@RDE
298900210122     C                   MOVE      'RT'          #@RDE
299000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
299100210122     C                   MOVEL     R#DEFN        ##R(R1)
299200210122     C                   MOVEL     DVLCNM        ##DATA
299300210122     C                   MOVEL     R#DATA        ##D(R1)
299400210122     C                   ENDIF
299500210122     C*                                                                                       CLE141
299600210122     C**  20 RDEs extracted for this group set so accumulate them and                         CLE141
299700210122     C**  the associated data.                                                                CLE141
299800210122     C*                                                                                       CLE141
299900210122     C                   EXSR      SRADTA
300000210122     C                   Z-ADD     0             R1
300100210122      *                                                                                       CLE141
300200210122      ** Rollover and Rate Fixing Location 4                                                  CLE141
300300210122      *                                                                                       CLE141
300400210122     C                   ADD       1             R1
300500210122     C                   CLEAR                   R#DATA
300600210122     C                   CLEAR                   R#DEFN
300700210122     C                   CLEAR                   #@RDE
300800210122     C                   MOVEL     'LOC4ROLL'    #@RDE
300900210122     C                   MOVE      'RT'          #@RDE
301000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
301100210122     C                   MOVEL     R#DEFN        ##R(R1)
301200210122      *                                                                                       CLE141
301300210122     C     L4PR          IFNE      *BLANKS
301400210122     C                   MOVEL     L4PR          ##DATA
301500210122     C                   MOVEL     R#DATA        ##D(R1)
301600210122      *                                                                                       CLE141
301700210122      ** Retrieve Location Name 4                                                             CLE141
301800210122      *                                                                                       CLE141
301900210122     C                   CALL      'AOLOCNR0'
302000210122     C                   PARM      *BLANKS       UFRTCD
302100210122     C                   PARM      '*KEY    '    UFOPTN
302200210122     C                   PARM      L4PR          UFLOCN
302300210122     C     SDLOCN        PARM      SDLOCN        DSFDY
302400210122      *                                                                                       CLE141
302500210122     C                   ADD       1             R1
302600210122     C                   CLEAR                   R#DATA
302700210122     C                   CLEAR                   R#DEFN
302800210122     C                   CLEAR                   #@RDE
302900210122     C                   MOVEL     'LON4ROLL'    #@RDE
303000210122     C                   MOVE      'RT'          #@RDE
303100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
303200210122     C                   MOVEL     R#DEFN        ##R(R1)
303300210122     C                   MOVEL     DVLCNM        ##DATA
303400210122     C                   MOVEL     R#DATA        ##D(R1)
303500210122     C                   ENDIF
303600210122      *                                                                                       CLE141
303700210122      ** Rollover and Rate Fixing Location 5                                                  CLE141
303800210122      *                                                                                       CLE141
303900210122     C                   ADD       1             R1
304000210122     C                   CLEAR                   R#DATA
304100210122     C                   CLEAR                   R#DEFN
304200210122     C                   CLEAR                   #@RDE
304300210122     C                   MOVEL     'LOC5ROLL'    #@RDE
304400210122     C                   MOVE      'RT'          #@RDE
304500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
304600210122     C                   MOVEL     R#DEFN        ##R(R1)
304700210122      *                                                                                       CLE141
304800210122     C     L5PR          IFNE      *BLANKS
304900210122     C                   MOVEL     L5PR          ##DATA
305000210122     C                   MOVEL     R#DATA        ##D(R1)
305100210122      *                                                                                       CLE141
305200210122      ** Retrieve Location Name 5                                                             CLE141
305300210122      *                                                                                       CLE141
305400210122     C                   CALL      'AOLOCNR0'
305500210122     C                   PARM      *BLANKS       UFRTCD
305600210122     C                   PARM      '*KEY    '    UFOPTN
305700210122     C                   PARM      L5PR          UFLOCN
305800210122     C     SDLOCN        PARM      SDLOCN        DSFDY
305900210122      *                                                                                       CLE141
306000210122     C                   ADD       1             R1
306100210122     C                   CLEAR                   R#DATA
306200210122     C                   CLEAR                   R#DEFN
306300210122     C                   CLEAR                   #@RDE
306400210122     C                   MOVEL     'LON5ROLL'    #@RDE
306500210122     C                   MOVE      'RT'          #@RDE
306600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
306700210122     C                   MOVEL     R#DEFN        ##R(R1)
306800210122     C                   MOVEL     DVLCNM        ##DATA
306900210122     C                   MOVEL     R#DATA        ##D(R1)
307000210122     C                   ENDIF
307100210122      *                                                                                       CLE141
307200210122      ** Rollover and Rate Fixing Location 6                                                  CLE141
307300210122      *                                                                                       CLE141
307400210122     C                   ADD       1             R1
307500210122     C                   CLEAR                   R#DATA
307600210122     C                   CLEAR                   R#DEFN
307700210122     C                   CLEAR                   #@RDE
307800210122     C                   MOVEL     'LOC6ROLL'    #@RDE
307900210122     C                   MOVE      'RT'          #@RDE
308000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
308100210122     C                   MOVEL     R#DEFN        ##R(R1)
308200210122      *                                                                                       CLE141
308300210122     C     L6PR          IFNE      *BLANKS
308400210122     C                   MOVEL     L6PR          ##DATA
308500210122     C                   MOVEL     R#DATA        ##D(R1)
308600210122      *                                                                                       CLE141
308700210122      ** Retrieve Location Name 6                                                             CLE141
308800210122      *                                                                                       CLE141
308900210122     C                   CALL      'AOLOCNR0'
309000210122     C                   PARM      *BLANKS       UFRTCD
309100210122     C                   PARM      '*KEY    '    UFOPTN
309200210122     C                   PARM      L6PR          UFLOCN
309300210122     C     SDLOCN        PARM      SDLOCN        DSFDY
309400210122      *                                                                                       CLE141
309500210122     C                   ADD       1             R1
309600210122     C                   CLEAR                   R#DATA
309700210122     C                   CLEAR                   R#DEFN
309800210122     C                   CLEAR                   #@RDE
309900210122     C                   MOVEL     'LON6ROLL'    #@RDE
310000210122     C                   MOVE      'RT'          #@RDE
310100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
310200210122     C                   MOVEL     R#DEFN        ##R(R1)
310300210122     C                   MOVEL     DVLCNM        ##DATA
310400210122     C                   MOVEL     R#DATA        ##D(R1)
310500210122     C                   ENDIF
310600210122      *                                                                                       CLE141
310700210122      ** Rollover and Rate Fixing Location 7                                                  CLE141
310800210122      *                                                                                       CLE141
310900210122     C                   ADD       1             R1
311000210122     C                   CLEAR                   R#DATA
311100210122     C                   CLEAR                   R#DEFN
311200210122     C                   CLEAR                   #@RDE
311300210122     C                   MOVEL     'LOC7ROLL'    #@RDE
311400210122     C                   MOVE      'RT'          #@RDE
311500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
311600210122     C                   MOVEL     R#DEFN        ##R(R1)
311700210122      *                                                                                       CLE141
311800210122     C     L7PR          IFNE      *BLANKS
311900210122     C                   MOVEL     L7PR          ##DATA
312000210122     C                   MOVEL     R#DATA        ##D(R1)
312100210122      *                                                                                       CLE141
312200210122      ** Retrieve Location Name 7                                                             CLE141
312300210122      *                                                                                       CLE141
312400210122     C                   CALL      'AOLOCNR0'
312500210122     C                   PARM      *BLANKS       UFRTCD
312600210122     C                   PARM      '*KEY    '    UFOPTN
312700210122     C                   PARM      L7PR          UFLOCN
312800210122     C     SDLOCN        PARM      SDLOCN        DSFDY
312900210122      *                                                                                       CLE141
313000210122     C                   ADD       1             R1
313100210122     C                   CLEAR                   R#DATA
313200210122     C                   CLEAR                   R#DEFN
313300210122     C                   CLEAR                   #@RDE
313400210122     C                   MOVEL     'LON7ROLL'    #@RDE
313500210122     C                   MOVE      'RT'          #@RDE
313600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
313700210122     C                   MOVEL     R#DEFN        ##R(R1)
313800210122     C                   MOVEL     DVLCNM        ##DATA
313900210122     C                   MOVEL     R#DATA        ##D(R1)
314000210122     C                   ENDIF
314100210122      *                                                                                       CLE141
314200210122      ** Rollover and Rate Fixing Location 8                                                  CLE141
314300210122      *                                                                                       CLE141
314400210122     C                   ADD       1             R1
314500210122     C                   CLEAR                   R#DATA
314600210122     C                   CLEAR                   R#DEFN
314700210122     C                   CLEAR                   #@RDE
314800210122     C                   MOVEL     'LOC8ROLL'    #@RDE
314900210122     C                   MOVE      'RT'          #@RDE
315000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
315100210122     C                   MOVEL     R#DEFN        ##R(R1)
315200210122      *                                                                                       CLE141
315300210122     C     L8PR          IFNE      *BLANKS
315400210122     C                   MOVEL     L8PR          ##DATA
315500210122     C                   MOVEL     R#DATA        ##D(R1)
315600210122      *                                                                                       CLE141
315700210122      ** Retrieve Location Name 8                                                             CLE141
315800210122      *                                                                                       CLE141
315900210122     C                   CALL      'AOLOCNR0'
316000210122     C                   PARM      *BLANKS       UFRTCD
316100210122     C                   PARM      '*KEY    '    UFOPTN
316200210122     C                   PARM      L8PR          UFLOCN
316300210122     C     SDLOCN        PARM      SDLOCN        DSFDY
316400210122      *                                                                                       CLE141
316500210122     C                   ADD       1             R1
316600210122     C                   CLEAR                   R#DATA
316700210122     C                   CLEAR                   R#DEFN
316800210122     C                   CLEAR                   #@RDE
316900210122     C                   MOVEL     'LON8ROLL'    #@RDE
317000210122     C                   MOVE      'RT'          #@RDE
317100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
317200210122     C                   MOVEL     R#DEFN        ##R(R1)
317300210122     C                   MOVEL     DVLCNM        ##DATA
317400210122     C                   MOVEL     R#DATA        ##D(R1)
317500210122     C                   ENDIF
317600210122      *                                                                                       CLE141
317700210122      ** Rollover and Rate Fixing Location 9                                                  CLE141
317800210122      *                                                                                       CLE141
317900210122     C                   ADD       1             R1
318000210122     C                   CLEAR                   R#DATA
318100210122     C                   CLEAR                   R#DEFN
318200210122     C                   CLEAR                   #@RDE
318300210122     C                   MOVEL     'LOC9ROLL'    #@RDE
318400210122     C                   MOVE      'RT'          #@RDE
318500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
318600210122     C                   MOVEL     R#DEFN        ##R(R1)
318700210122      *                                                                                       CLE141
318800210122     C     L9PR          IFNE      *BLANKS
318900210122     C                   MOVEL     L9PR          ##DATA
319000210122     C                   MOVEL     R#DATA        ##D(R1)
319100210122      *                                                                                       CLE141
319200210122      ** Retrieve Location Name 9                                                             CLE141
319300210122      *                                                                                       CLE141
319400210122     C                   CALL      'AOLOCNR0'
319500210122     C                   PARM      *BLANKS       UFRTCD
319600210122     C                   PARM      '*KEY    '    UFOPTN
319700210122     C                   PARM      L9PR          UFLOCN
319800210122     C     SDLOCN        PARM      SDLOCN        DSFDY
319900210122      *                                                                                       CLE141
320000210122     C                   ADD       1             R1
320100210122     C                   CLEAR                   R#DATA
320200210122     C                   CLEAR                   R#DEFN
320300210122     C                   CLEAR                   #@RDE
320400210122     C                   MOVEL     'LON9ROLL'    #@RDE
320500210122     C                   MOVE      'RT'          #@RDE
320600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
320700210122     C                   MOVEL     R#DEFN        ##R(R1)
320800210122     C                   MOVEL     DVLCNM        ##DATA
320900210122     C                   MOVEL     R#DATA        ##D(R1)
321000210122     C                   ENDIF
321100210122      *                                                                                       CLE141
321200210122      ** Rollover and Rate Fixing Location 10                                                 CLE141
321300210122      *                                                                                       CLE141
321400210122     C                   ADD       1             R1
321500210122     C                   CLEAR                   R#DATA
321600210122     C                   CLEAR                   R#DEFN
321700210122     C                   CLEAR                   #@RDE
321800210122     C                   MOVEL     'LOC0ROLL'    #@RDE
321900210122     C                   MOVE      'RT'          #@RDE
322000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
322100210122     C                   MOVEL     R#DEFN        ##R(R1)
322200210122      *                                                                                       CLE141
322300210122     C     L0PR          IFNE      *BLANKS
322400210122     C                   MOVEL     L0PR          ##DATA
322500210122     C                   MOVEL     R#DATA        ##D(R1)
322600210122      *                                                                                       CLE141
322700210122      ** Retrieve Location Name 10                                                            CLE141
322800210122      *                                                                                       CLE141
322900210122     C                   CALL      'AOLOCNR0'
323000210122     C                   PARM      *BLANKS       UFRTCD
323100210122     C                   PARM      '*KEY    '    UFOPTN
323200210122     C                   PARM      L0PR          UFLOCN
323300210122     C     SDLOCN        PARM      SDLOCN        DSFDY
323400210122      *                                                                                       CLE141
323500210122     C                   ADD       1             R1
323600210122     C                   CLEAR                   R#DATA
323700210122     C                   CLEAR                   R#DEFN
323800210122     C                   CLEAR                   #@RDE
323900210122     C                   MOVEL     'LON0ROLL'    #@RDE
324000210122     C                   MOVE      'RT'          #@RDE
324100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
324200210122     C                   MOVEL     R#DEFN        ##R(R1)
324300210122     C                   MOVEL     DVLCNM        ##DATA
324400210122     C                   MOVEL     R#DATA        ##D(R1)
324500210122     C                   ENDIF
324600210122      *                                                                                       CLE141
324700210122     C                   ENDIF
324800210122     C*                                                                                       CLE141
324900210122     C/COPY WNCPYSRC,CG6005C006
325000210122      *                                                                                       CER050
325100210122     C     CER050        IFEQ      'Y'
325200210122     C                   EXSR      ZI@APR
325300210122     C                   ENDIF
325400210122      *                                                                                       CLE172
325500210122      ** LIBOR Deregulation BACKWARD-LOOKING RATE                                             CLE172
325600210122      *                                                                                       CLE172
325700210122     C                   ADD       1             R1                                           CLE172
325800210122     C                   CLEAR                   R#DATA                                       CLE172
325900210122     C                   CLEAR                   R#DEFN                                       CLE172
326000210122     C                   CLEAR                   #@RDE                                        CLE172
326100210122     C                   MOVE      'TE'          #@RDE                                        CLE172
326200210122     C                   MOVEL     'BCKLOKRA'    #@RDE                                        CLE172
326300210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
326400210122     C                   MOVEL     BLRT          R#DATA                                       CLE172
326500210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
326600210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
326700210122      *                                                                                       CLE172
326800210122      ** Averaging Option                                                                     CLE172
326900210122      *                                                                                       CLE172
327000210122     C                   ADD       1             R1                                           CLE172
327100210122     C                   CLEAR                   R#DATA                                       CLE172
327200210122     C                   CLEAR                   R#DEFN                                       CLE172
327300210122     C                   CLEAR                   #@RDE                                        CLE172
327400210122     C                   MOVE      'N'           #@RDE                                        CLE172
327500210122     C                   MOVEL     'AVGOPTIO'    #@RDE                                        CLE172
327600210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
327700210122     C                   MOVEL     AVOP          R#DATA                                       CLE172
327800210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
327900210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
328000210122      *                                                                                       CLE172
328100210122      ** Compounded/Average Rate                                                              CLE172
328200210122      *                                                                                       CLE172
328300210122     C                   ADD       1             R1                                           CLE172
328400210122     C                   CLEAR                   R#DATA                                       CLE172
328500210122     C                   CLEAR                   R#DEFN                                       CLE172
328600210122     C                   CLEAR                   #@RDE                                        CLE172
328700210122     C                   MOVE      'AR'          #@RDE                                        CLE172
328800210122     C                   MOVEL     'COMPOUND'    #@RDE                                        CLE172
328900210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
329000210122     C                   MOVEL     CART          R#DATA                                       CLE172
329100210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
329200210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
329300210122      *                                                                                       CLE172
329400210122      ** Lookback Days                                                                        CLE172
329500210122      *                                                                                       CLE172
329600210122     C                   ADD       1             R1                                           CLE172
329700210122     C                   CLEAR                   R#DATA                                       CLE172
329800210122     C                   CLEAR                   R#DEFN                                       CLE172
329900210122     C                   CLEAR                   #@RDE                                        CLE172
330000210122     C                   MOVE      'AY'          #@RDE                                        CLE172
330100210122     C                   MOVEL     'LOOKBCKD'    #@RDE                                        CLE172
330200210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
330300210122     C                   MOVEL     LBDY          R#DATA                                       CLE172
330400210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
330500210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
330600210122      *                                                                                       CLE172
330700210122      ** Lockout Days                                                                         CLE172
330800210122      *                                                                                       CLE172
330900210122     C                   ADD       1             R1                                           CLE172
331000210122     C                   CLEAR                   R#DATA                                       CLE172
331100210122     C                   CLEAR                   R#DEFN                                       CLE172
331200210122     C                   CLEAR                   #@RDE                                        CLE172
331300210122     C                   MOVE      'AY'          #@RDE                                        CLE172
331400210122     C                   MOVEL     'LOCKOUTD'    #@RDE                                        CLE172
331500210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
331600210122     C                   MOVEL     LODY          R#DATA                                       CLE172
331700210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
331800210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
331900210122      *                                                                                       CLE172
332000210122      ** Delayed Payment Days                                                                 CLE172
332100210122      *                                                                                       CLE172
332200210122     C                   ADD       1             R1                                           CLE172
332300210122     C                   CLEAR                   R#DATA                                       CLE172
332400210122     C                   CLEAR                   R#DEFN                                       CLE172
332500210122     C                   CLEAR                   #@RDE                                        CLE172
332600210122     C                   MOVE      'YS'          #@RDE                                        CLE172
332700210122     C                   MOVEL     'DLYPAYDA'    #@RDE                                        CLE172
332800210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
332900210122     C                   MOVEL     PDLY          R#DATA                                       CLE172
333000210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
333100210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
333200210122      *                                                                                       CLE172
333300210122      ** Benchmark Adjustment Days                                                            CLE172
333400210122      *                                                                                       CLE172
333500210122     C                   ADD       1             R1                                           CLE172
333600210122     C                   CLEAR                   R#DATA                                       CLE172
333700210122     C                   CLEAR                   R#DEFN                                       CLE172
333800210122     C                   CLEAR                   #@RDE                                        CLE172
333900210122     C                   MOVE      'OD'          #@RDE                                        CLE172
334000210122     C                   MOVEL     'BMRKADJC'    #@RDE                                        CLE172
334100210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
334200210122     C                   MOVEL     BADJ          R#DATA                                       CLE172
334300210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
334400210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
334500210122      *                                                                                       CLE172
334600210122      ** Weight Convention                                                                    CLE172
334700210122      *                                                                                       CLE172
334800210122     C                   ADD       1             R1                                           CLE172
334900210122     C                   CLEAR                   R#DATA                                       CLE172
335000210122     C                   CLEAR                   R#DEFN                                       CLE172
335100210122     C                   CLEAR                   #@RDE                                        CLE172
335200210122     C                   MOVE      'TN'          #@RDE                                        CLE172
335300210122     C                   MOVEL     'WGHTCONV'    #@RDE                                        CLE172
335400210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
335500210122     C                   MOVEL     WGHT          R#DATA                                       CLE172
335600210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
335700210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
335800210122      *                                                                                       CLE172
335900210122      ** Base Rate Code for Accrual                                                           CLE172
336000210122      *                                                                                       CLE172
336100210122     C                   ADD       1             R1                                           CLE172
336200210122     C                   CLEAR                   R#DATA                                       CLE172
336300210122     C                   CLEAR                   R#DEFN                                       CLE172
336400210122     C                   CLEAR                   #@RDE                                        CLE172
336500210122     C                   MOVE      'CR'          #@RDE                                        CLE172
336600210122     C                   MOVEL     'BSRTCDAC'    #@RDE                                        CLE172
336700210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
336800210122     C                   MOVEL     BRAC          R#DATA                                       CLE172
336900210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
337000210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
337100210122      *                                                                                       CLE172
337200210122      ** Lookback Days for Accrual                                                            CLE172
337300210122      *                                                                                       CLE172
337400210122     C                   ADD       1             R1                                           CLE172
337500210122     C                   CLEAR                   R#DATA                                       CLE172
337600210122     C                   CLEAR                   R#DEFN                                       CLE172
337700210122     C                   CLEAR                   #@RDE                                        CLE172
337800210122     C                   MOVE      'CR'          #@RDE                                        CLE172
337900210122     C                   MOVEL     'LBACDYAC'    #@RDE                                        CLE172
338000210122     C     ##RDE         CAT       #@RDE:1       ##RDE                                        CLE172
338100210122     C                   MOVEL     LBAC          R#DATA                                       CLE172
338200210122     C                   MOVEL     R#DATA        ##D(R1)                                      CLE172
338300210122     C                   MOVEL     R#DEFN        ##R(R1)                                      CLE172
338400210122      *
338500210122     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
338600210122     C*
338700210122     C                   EXSR      SRADTA
338800210122     C                   EXSR      SRODTA
338900210122     C*
339000210122     C**  Decrement Path DS index.
339100210122     C*
339200210122     C     P1            OCCUR     ##PATH
339300210122     C                   CLEAR                   ##GRPS
339400210122     C                   SUB       1             P1
339500210122     C                   EXSR      POPGRS
339600210122     C*
339700210122     C**  Unwind subroutine stack name.
339800210122     C*
339900210122     C                   MOVEA     *BLANKS       @STK(Q)
340000210122     C                   SUB       1             Q
340100210122     C*
340200210122     C     LOAN9         ENDSR                                                  ** LOAN9  **
340300210122     C*
340400210122     C*****************************************************************
340500210122     C*                                                                   S01408
340600210122     C/COPY WNCPYSRC,CG6005CCP2                                           S01408
340700210122     C*                                                                   S01408
340800210122     C/EJECT
340900210122     C*****************************************************************
341000210122     C*                                                               *
341100210122     C*  Subroutine  :  L@ROL                                         *
341200210122     C*  Function    :  Process Rollover Details                      *
341300210122     C*                                                               *
341400210122     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
341500210122     C*  Calls       :  SRPATH - Generate Path String                 *
341600210122     C*                 SRADTA - Accumulate RDEs and Associated Data  *
341700210122     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
341800210122     C*                 AOBSRTRO - Retrive Base Rate Code Details     *
341900210122     C*                                                               *
342000210122     C*****************************************************************
342100210122     C*
342200210122     C     L@ROL         BEGSR                                                  ** L@ROL  **
342300210122     C*
342400210122     C**  Set up subroutine stack name.
342500210122     C*
342600210122     C                   ADD       1             Q
342700210122     C                   MOVEL     'L@ROL '      @STK(Q)
342800210122     C*
342900210122     C                   ADD       1             P1
343000210122     C*
343100210122     C     P1            OCCUR     ##PATH
343200210122     C                   MOVEL(P)  'L_ROL '      ##GRPS
343300210122     C                   EXSR      SRPATH
343400210122     C                   EXSR      PSHGRS
343500210122     C*
343600210122     C                   Z-ADD     0             R1                3 0
343700210122     C*
343800210122     C**  Next Base Rate Name.
343900210122     C*
344000210122     C********* ##NBRA        IFEQ      *ZERO                                                 CSD103
344100210122     C     ##NBRA        IFEQ      *BLANKS                                                    CSD103
344200210122     C                   MOVEL     *BLANKS       ##NBRN           30
344300210122     C                   ELSE
344400210122     C*
344500210122     C                   MOVEL     ##NBRA        ##BSRC
344600210122     C                   CALL      'AOBSRTR0'
344700210122     C                   PARM      *BLANKS       ##RTCD
344800210122     C                   PARM      '*KEY   '     ##OPTN
344900210122     C                   PARM      ##CCY1        ##CYCD            3
345000210122     C                   PARM                    ##BSRC            2
345100210122     C********** SDBSRT    PARM SDBSRT    DSFDY                                 CSD006
345200210122     C     SDBSRT        PARM      SDBSRT        DSSDY
345300210122     C*
345400210122     C     ##RTCD        IFNE      *BLANK
345500210122     C                   MOVEL     'SDBSRTPD'    W0FILE
345600210122     C     ##CYCD        CAT       ##BSRC        W0KEY                          ************
345700210122     C                   Z-ADD     6             W0ERNB                         * DBERR 06 *
345800210122     C                   MOVEL     'MEM5004'     W0MSGD                         ************
345900210122     C                   MOVEL     'MIDAS  '     W0MSGF
346000210122     C                   EXSR      SRERR
346100210122     C                   END
346200210122     C*
346300210122     C                   MOVEL     BABSRN        ##NBRN
346400210122     C*
346500210122     C                   END
346600210122     C*
346700210122     C                   ADD       1             R1
346800210122     C                   CLEAR                   R#DATA
346900210122     C                   CLEAR                   R#DEFN
347000210122     C                   CLEAR                   #@RDE
347100210122     C                   MOVEL     'NXT BSRN'    #@RDE
347200210122     C                   MOVE      'AM'          #@RDE
347300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
347400210122     C                   MOVEL     ##NBRN        R#DATA
347500210122     C                   MOVEL     R#DATA        ##D(R1)
347600210122     C                   MOVEL     R#DEFN        ##R(R1)
347700210122      *                                                                                       CLE036
347800210122      ** If CLE036 is installed, process next base rate.                                      CLE036
347900210122      *                                                                                       CLE036
348000210122     C     CLE036        IFEQ      'Y'
348100210122      *                                                                                       CLE036
348200210122     C                   ADD       1             R1
348300210122     C                   CLEAR                   R#DATA
348400210122     C                   CLEAR                   R#DEFN
348500210122     C                   CLEAR                   #@RDE
348600210122     C                   MOVEL     'NXT BSRA'    #@RDE
348700210122     C                   MOVE      'TE'          #@RDE
348800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
348900210122     C                   MOVEL     ##NBSR        R#DATA
349000210122     C                   MOVEL     R#DATA        ##D(R1)
349100210122     C                   MOVEL     R#DEFN        ##R(R1)
349200210122     C                   ENDIF
349300210122     C*
349400210122     C**  Next Base Rate Type.
349500210122     C*
349600210122     C                   ADD       1             R1
349700210122     C                   CLEAR                   R#DATA
349800210122     C                   CLEAR                   R#DEFN
349900210122     C                   CLEAR                   #@RDE
350000210122     C                   MOVEL     'NXT BSRT'    #@RDE
350100210122     C                   MOVE      'YP'          #@RDE
350200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
350300210122     C                   MOVEL     ##NBRA        R#DATA
350400210122     C                   MOVEL     R#DATA        ##D(R1)
350500210122     C                   MOVEL     R#DEFN        ##R(R1)
350600210122     C*
350700210122     C** Next Interest Calculation Basis.
350800210122     C*
350900210122     C                   ADD       1             R1
351000210122     C                   CLEAR                   R#DATA
351100210122     C                   CLEAR                   R#DEFN
351200210122     C                   CLEAR                   #@RDE
351300210122     C                   MOVEL     'NXT INTC'    #@RDE
351400210122     C                   MOVE      'LB'          #@RDE
351500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
351600210122     C                   MOVEL     ##NCAS        R#DATA
351700210122     C                   MOVEL     R#DATA        ##D(R1)
351800210122     C                   MOVEL     R#DEFN        ##R(R1)
351900210122     C*
352000210122     C**  Next Rollover Date.
352100210122     C*
352200210122     C                   ADD       1             R1
352300210122     C                   CLEAR                   R#DATA
352400210122     C                   CLEAR                   R#DEFN
352500210122     C                   CLEAR                   #@RDE
352600210122     C                   MOVEL     'NXT RLDA'    #@RDE
352700210122     C                   MOVE      'TE'          #@RDE
352800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
352900210122     C                   MOVEL     ##NROD        ##DATA
353000210122     C                   MOVEL     'Date  '      ##RDEC
353100210122     C                   MOVEL     R#DATA        ##D(R1)
353200210122     C                   MOVEL     R#DEFN        ##R(R1)
353300210122     C*
353400210122     C**  Next Spread.
353500210122     C*
353600210122     C     ##NSIN        IFEQ      'A'
353700210122     C                   Z-ADD     ##NRTS        ##NSPR           11 7
353800210122     C                   ELSE
353900210122     C                   Z-SUB     ##NRTS        ##NSPR
354000210122     C                   END
354100210122     C*
354200210122     C                   ADD       1             R1
354300210122     C                   CLEAR                   R#DATA
354400210122     C                   CLEAR                   R#DEFN
354500210122     C                   CLEAR                   #@RDE
354600210122     C                   MOVEL     'NXT SPRE'    #@RDE
354700210122     C                   MOVE      'AD'          #@RDE
354800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
354900210122     C                   MOVEL     ##NSPR        ##DATA
355000210122     C                   MOVEL     'Rate  '      ##RDEC
355100210122     C                   MOVEL     'L'           ##RDET
355200210122     C                   MOVEL     '7'           ##DCPA
355300210122     C                   MOVEL     R#DATA        ##D(R1)
355400210122     C                   MOVEL     R#DEFN        ##R(R1)
355500210122     C*
355600210122     C**  Rollover Date.
355700210122     C*
355800210122     C                   ADD       1             R1
355900210122     C                   CLEAR                   R#DATA
356000210122     C                   CLEAR                   R#DEFN
356100210122     C                   CLEAR                   #@RDE
356200210122     C                   MOVEL     'ROLL DAT'    #@RDE
356300210122     C                   MOVE      'E '          #@RDE
356400210122     C     ##RDE         CAT       #@RDE:1       ##RDE
356500210122     C                   MOVEL     ##RLDT        ##DATA
356600210122     C                   MOVEL     'Date  '      ##RDEC
356700210122     C                   MOVEL     R#DATA        ##D(R1)
356800210122     C                   MOVEL     R#DEFN        ##R(R1)
356900210122     C*
357000210122     C**  Rollover Day in Month.
357100210122     C*
357200210122     C                   ADD       1             R1
357300210122     C                   CLEAR                   R#DATA
357400210122     C                   CLEAR                   R#DEFN
357500210122     C                   CLEAR                   #@RDE
357600210122     C                   MOVEL     'ROLL DAY'    #@RDE
357700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
357800210122     C                   MOVEL     ##RLDY        ##DATA
357900210122     C                   MOVEL     'Day   '      ##RDEC
358000210122     C                   MOVEL     R#DATA        ##D(R1)
358100210122     C                   MOVEL     R#DEFN        ##R(R1)
358200210122     C*
358300210122     C**  Rollover Frequency.
358400210122     C*
358500210122     C                   ADD       1             R1
358600210122     C                   CLEAR                   R#DATA
358700210122     C                   CLEAR                   R#DEFN
358800210122     C                   CLEAR                   #@RDE
358900210122     C                   MOVEL     'ROLL FRE'    #@RDE
359000210122     C                   MOVE      'Q '          #@RDE
359100210122     C     ##RDE         CAT       #@RDE:1       ##RDE
359200210122     C                   MOVEL     ##RLFQ        R#DATA
359300210122     C                   MOVEL     R#DATA        ##D(R1)
359400210122     C                   MOVEL     R#DEFN        ##R(R1)
359500210122     C*
359600210122     C**  Rollover Indicator.
359700210122     C*
359800210122     C     ##RCD1        IFEQ      'R'
359900210122     C                   MOVE      'Y'           ##ROIN            1
360000210122     C                   ELSE
360100210122     C                   MOVE      ' '           ##ROIN
360200210122     C                   END
360300210122     C*
360400210122     C                   ADD       1             R1
360500210122     C                   CLEAR                   R#DATA
360600210122     C                   CLEAR                   R#DEFN
360700210122     C                   CLEAR                   #@RDE
360800210122     C                   MOVEL     'ROLLIND '    #@RDE
360900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
361000210122     C                   MOVEL     ##ROIN        R#DATA
361100210122     C                   MOVEL     R#DATA        ##D(R1)
361200210122     C                   MOVEL     R#DEFN        ##R(R1)
361300210122     C*
361400210122     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
361500210122     C*
361600210122     C                   EXSR      SRADTA
361700210122     C                   EXSR      SRODTA
361800210122     C*
361900210122     C**  Decrement Path DS index.
362000210122     C*
362100210122     C     P1            OCCUR     ##PATH
362200210122     C                   CLEAR                   ##GRPS
362300210122     C                   SUB       1             P1
362400210122     C                   EXSR      POPGRS
362500210122     C*
362600210122     C**  Unwind subroutine stack name.
362700210122     C*
362800210122     C                   MOVEA     *BLANKS       @STK(Q)
362900210122     C                   SUB       1             Q
363000210122     C*
363100210122     C     L@ROL9        ENDSR                                                  ** L@ROL9 **
363200210122     C*
363300210122     C*****************************************************************
363400210122     C/EJECT
363500210122     C*****************************************************************
363600210122     C*                                                               *
363700210122     C*  Subroutine  :  L@REP                                         *
363800210122     C*  Function    :  Process Repayment Details                     *
363900210122     C*                                                               *
364000210122     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
364100210122     C*  Calls       :  SRPATH - Generate Path String                 *
364200210122     C*                 SRDCDT - Determine Currency Details           *
364300210122     C*                 SRADTA - Accumulate RDEs and Associated Data  *
364400210122     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
364500210122     C*                                                               *
364600210122     C*****************************************************************
364700210122     C*
364800210122     C     L@REP         BEGSR                                                  ** L@REP  **
364900210122     C*
365000210122     C**  Set up subroutine stack name.
365100210122     C*
365200210122     C                   ADD       1             Q
365300210122     C                   MOVEL     'L@REP '      @STK(Q)
365400210122     C*
365500210122     C                   ADD       1             P1
365600210122     C*
365700210122     C     P1            OCCUR     ##PATH
365800210122     C                   MOVEL(P)  'L_REP '      ##GRPS
365900210122     C                   EXSR      SRPATH
366000210122     C                   EXSR      PSHGRS
366100210122     C*
366200210122     C                   Z-ADD     0             R1                3 0
366300210122     C*
366400210122     C**  Next Repayment Date.
366500210122     C*
366600210122     C                   ADD       1             R1
366700210122     C                   CLEAR                   R#DATA
366800210122     C                   CLEAR                   R#DEFN
366900210122     C                   CLEAR                   #@RDE
367000210122     C                   MOVEL     'NXT RPDA'    #@RDE
367100210122     C                   MOVE      'TE'          #@RDE
367200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
367300210122     C                   MOVEL     ##NRPD        ##DATA
367400210122     C                   MOVEL     'Date  '      ##RDEC
367500210122     C                   MOVEL     R#DATA        ##D(R1)
367600210122     C                   MOVEL     R#DEFN        ##R(R1)
367700210122     C*
367800210122     C**  Repayment Amount.
367900210122     C*
368000210122     C                   ADD       1             R1
368100210122     C                   CLEAR                   R#DATA
368200210122     C                   CLEAR                   R#DEFN
368300210122     C                   CLEAR                   #@RDE
368400210122     C                   MOVEL     'REPAY AM'    #@RDE
368500210122     C                   MOVE      'NT'          #@RDE
368600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
368700210122     C                   MOVEL     ##RAMT        ##DATA
368800210122     C                   MOVEL     'Amount'      ##RDEC
368900210122     C                   MOVEL     'L'           ##RDET
369000210122     C                   MOVEL     ##CCY1        ##CCY
369100210122     C                   EXSR      SRDCDT
369200210122     C/COPY WNCPYSRC,CG6005C019
369300210122     C                   MOVEL     A6NBDP        ##DCPA
369400210122     C                   MOVEL     R#DATA        ##D(R1)
369500210122     C                   MOVEL     R#DEFN        ##R(R1)
369600210122     C*
369700210122     C**  Repayment Day in Month.
369800210122     C*
369900210122     C                   ADD       1             R1
370000210122     C                   CLEAR                   R#DATA
370100210122     C                   CLEAR                   R#DEFN
370200210122     C                   CLEAR                   #@RDE
370300210122     C                   MOVEL     'REPAY DA'    #@RDE
370400210122     C                   MOVE      'Y '          #@RDE
370500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
370600210122     C                   MOVEL     ##RDYN        ##DATA
370700210122     C                   MOVEL     'Day   '      ##RDEC
370800210122     C                   MOVEL     R#DATA        ##D(R1)
370900210122     C                   MOVEL     R#DEFN        ##R(R1)
371000210122     C*
371100210122     C**  Repayment Frequency.
371200210122     C*
371300210122     C                   ADD       1             R1
371400210122     C                   CLEAR                   R#DATA
371500210122     C                   CLEAR                   R#DEFN
371600210122     C                   CLEAR                   #@RDE
371700210122     C                   MOVEL     'REPAY FR'    #@RDE
371800210122     C                   MOVE      'EQ'          #@RDE
371900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
372000210122     C                   MOVEL     ##RFRQ        R#DATA
372100210122     C                   MOVEL     R#DATA        ##D(R1)
372200210122     C                   MOVEL     R#DEFN        ##R(R1)
372300210122     C*
372400210122     C**  Repayment Type.
372500210122     C*
372600210122     C                   ADD       1             R1
372700210122     C                   CLEAR                   R#DATA
372800210122     C                   CLEAR                   R#DEFN
372900210122     C                   CLEAR                   #@RDE
373000210122     C                   MOVEL     'REPAY TY'    #@RDE
373100210122     C                   MOVE      'PE'          #@RDE
373200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
373300210122     C                   MOVEL     ##REPT        R#DATA
373400210122     C                   MOVEL     R#DATA        ##D(R1)
373500210122     C                   MOVEL     R#DEFN        ##R(R1)
373600210122     C*
373700210122     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
373800210122     C*
373900210122     C                   EXSR      SRADTA
374000210122     C                   EXSR      SRODTA
374100210122     C*
374200210122     C**  Decrement Path DS index.
374300210122     C*
374400210122     C     P1            OCCUR     ##PATH
374500210122     C                   CLEAR                   ##GRPS
374600210122     C                   SUB       1             P1
374700210122     C                   EXSR      POPGRS
374800210122     C*
374900210122     C**  Unwind subroutine stack name.
375000210122     C*
375100210122     C                   MOVEA     *BLANKS       @STK(Q)
375200210122     C                   SUB       1             Q
375300210122     C*
375400210122     C     L@REP9        ENDSR                                                  ** L@REP9 **
375500210122     C*
375600210122     C*****************************************************************
375700210122     C/EJECT
375800210122     C*****************************************************************
375900210122     C*                                                               *
376000210122     C*  Subroutine  :  L@IPY                                         *
376100210122     C*  Function    :  Process Interest Payment details              *
376200210122     C*                                                               *
376300210122     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
376400210122     C*  Calls       :  SRPATH - Generate Path String                 *
376500210122     C*                 SRADTA - Accumulate RDEs and Associated Data  *
376600210122     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
376700210122     C*                                                               *
376800210122     C*****************************************************************
376900210122     C*
377000210122     C     L@IPY         BEGSR                                                  ** L@IPY  **
377100210122     C*
377200210122     C**  Set up subroutine stack name.
377300210122     C*
377400210122     C                   ADD       1             Q
377500210122     C                   MOVEL     'L@IPY '      @STK(Q)
377600210122     C*
377700210122     C                   ADD       1             P1
377800210122     C*
377900210122     C     P1            OCCUR     ##PATH
378000210122     C                   MOVEL(P)  'L_IPY '      ##GRPS
378100210122     C                   EXSR      SRPATH
378200210122     C                   EXSR      PSHGRS
378300210122     C*
378400210122     C                   Z-ADD     0             R1                3 0
378500210122     C*
378600210122     C**  Interest Payment Day.
378700210122     C*
378800210122     C                   ADD       1             R1
378900210122     C                   CLEAR                   R#DATA
379000210122     C                   CLEAR                   R#DEFN
379100210122     C                   CLEAR                   #@RDE
379200210122     C                   MOVEL     'INT DAY '    #@RDE
379300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
379400210122     C                   MOVEL     ##IFDY        ##DATA
379500210122     C                   MOVEL     'Day   '      ##RDEC
379600210122     C                   MOVEL     R#DATA        ##D(R1)
379700210122     C                   MOVEL     R#DEFN        ##R(R1)
379800210122     C*
379900210122     C**  Interest Payment Frequency.
380000210122     C*
380100210122     C                   ADD       1             R1
380200210122     C                   CLEAR                   R#DATA
380300210122     C                   CLEAR                   R#DEFN
380400210122     C                   CLEAR                   #@RDE
380500210122     C                   MOVEL     'INT FREQ'    #@RDE
380600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
380700210122     C                   MOVEL     ##IPFR        R#DATA
380800210122     C                   MOVEL     R#DATA        ##D(R1)
380900210122     C                   MOVEL     R#DEFN        ##R(R1)
381000210122     C*
381100210122     C**  Next Interest Payment Date.
381200210122     C*
381300210122     C                   ADD       1             R1
381400210122     C                   CLEAR                   R#DATA
381500210122     C                   CLEAR                   R#DEFN
381600210122     C                   CLEAR                   #@RDE
381700210122     C                   MOVEL     'NXT IPDA'    #@RDE
381800210122     C                   MOVE      'TE'          #@RDE
381900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
382000210122     C                   MOVEL     ##NIDT        ##DATA
382100210122     C                   MOVEL     'Date  '      ##RDEC
382200210122     C                   MOVEL     R#DATA        ##D(R1)
382300210122     C                   MOVEL     R#DEFN        ##R(R1)
382400210122     C/COPY WNCPYSRC,CG6005C014
382500210122     C*
382600210122     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
382700210122     C*
382800210122     C                   EXSR      SRADTA
382900210122     C                   EXSR      SRODTA
383000210122     C*
383100210122     C**  Decrement Path DS index.
383200210122     C*
383300210122     C     P1            OCCUR     ##PATH
383400210122     C                   CLEAR                   ##GRPS
383500210122     C                   SUB       1             P1
383600210122     C                   EXSR      POPGRS
383700210122     C*
383800210122     C**  Unwind subroutine stack name.
383900210122     C*
384000210122     C                   MOVEA     *BLANKS       @STK(Q)
384100210122     C                   SUB       1             Q
384200210122     C*
384300210122     C     L@IPY9        ENDSR                                                  ** L@IPY9 **
384400210122     C*
384500210122     C*****************************************************************
384600210122     C/EJECT
384700210122     C*****************************************************************
384800210122     C*                                                               *
384900210122     C*  Subroutine  :  L@GUAR                                        *
385000210122     C*  Function    :  Process Guarantee details                     *
385100210122     C*                                                               *
385200210122     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
385300210122     C*  Calls       :  SRPATH - Generate Path String                 *
385400210122     C*                 SRADTA - Accumulate RDEs and Associated Data  *
385500210122     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
385600210122     C*                 AOCUSTR0 - Retrieve Customer Details          *
385700210122     C*                                                               *
385800210122     C*****************************************************************
385900210122     C*
386000210122     C     L@GUAR        BEGSR                                                  ** L@GUAR **
386100210122     C*
386200210122     C**  Set up subroutine stack name.
386300210122     C*
386400210122     C                   ADD       1             Q
386500210122     C                   MOVEL     'L@GUAR'      @STK(Q)
386600210122     C*
386700210122     C                   ADD       1             P1
386800210122     C*
386900210122     C     P1            OCCUR     ##PATH
387000210122     C                   MOVEL(P)  'L_GUAR'      ##GRPS
387100210122     C                   EXSR      SRPATH
387200210122     C                   EXSR      PSHGRS
387300210122     C*
387400210122     C                   Z-ADD     0             R1                3 0
387500210122     C*
387600210122     C********** ##RECE    IFEQ 0                                                             CSD027
387700210122     C     ##RECE        IFEQ      *BLANKS
387800210122     C                   MOVEL     *BLANKS       ##GRNM           20
387900210122     C                   MOVEL     *BLANKS       ##GRTN           10
388000210122     C                   ELSE
388100210122     C*
388200210122     C                   MOVEL     ##RECE        ##KEY1
388300210122     C                   CALL      'AOCUSTR0'
388400210122     C                   PARM      *BLANKS       ##RTCD
388500210122     C                   PARM      '*KEY   '     ##OPTN
388600210122     C                   PARM                    ##KEY1           10
388700210122     C                   PARM      *BLANKS       ##KYST            7
388800210122     C     SDCUST        PARM      SDCUST        DSSDY
388900210122     C*
389000210122     C     ##RTCD        IFNE      *BLANK
389100210122     C                   MOVEL     'SDCUSTPD'    W0FILE
389200210122     C                   MOVEL     ##RECE        W0KEY                          ************
389300210122     C                   Z-ADD     7             W0ERNB                         * DBERR 07 *
389400210122     C                   MOVEL     'MEM5004'     W0MSGD                         ************
389500210122     C                   MOVEL     'MIDAS  '     W0MSGF
389600210122     C                   EXSR      SRERR
389700210122     C                   END
389800210122     C*
389900210122     C                   MOVEL     BBCRNM        ##GRNM
390000210122     C                   MOVEL     BBCRTN        ##GRTN
390100210122     C*
390200210122     C                   END
390300210122     C*
390400210122     C**  Receiver of Guarantee Name.
390500210122     C*
390600210122     C                   ADD       1             R1
390700210122     C                   CLEAR                   R#DATA
390800210122     C                   CLEAR                   R#DEFN
390900210122     C                   CLEAR                   #@RDE
391000210122     C                   MOVEL     'RECGUANA'    #@RDE
391100210122     C                   MOVE      'M '          #@RDE
391200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
391300210122     C                   MOVEL     ##GRNM        R#DATA
391400210122     C                   MOVEL     R#DATA        ##D(R1)
391500210122     C                   MOVEL     R#DEFN        ##R(R1)
391600210122     C*
391700210122     C**  Receiver of Guarantee Town.
391800210122     C*
391900210122     C                   ADD       1             R1
392000210122     C                   CLEAR                   R#DATA
392100210122     C                   CLEAR                   R#DEFN
392200210122     C                   CLEAR                   #@RDE
392300210122     C                   MOVE      'N '          #@RDE
392400210122     C                   MOVEL     'RECGUATW'    #@RDE
392500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
392600210122     C                   MOVEL     ##GRTN        R#DATA
392700210122     C                   MOVEL     R#DATA        ##D(R1)
392800210122     C                   MOVEL     R#DEFN        ##R(R1)
392900210122     C/COPY WNCPYSRC,CG6005C007
393000210122     C*
393100210122     C**  Accumulate RDEs and associated data and output to PF/CGUDTPD.
393200210122     C*
393300210122     C                   EXSR      SRADTA
393400210122     C                   EXSR      SRODTA
393500210122     C*
393600210122     C**  Decrement Path DS index.
393700210122     C*
393800210122     C     P1            OCCUR     ##PATH
393900210122     C                   CLEAR                   ##GRPS
394000210122     C                   SUB       1             P1
394100210122     C                   EXSR      POPGRS
394200210122     C*
394300210122     C**  Unwind subroutine stack name.
394400210122     C*
394500210122     C                   MOVEA     *BLANKS       @STK(Q)
394600210122     C                   SUB       1             Q
394700210122     C*
394800210122     C     L@GUA9        ENDSR                                                  ** L@GUA9 **
394900210122     C*
395000210122     C*****************************************************************
395100210122      /EJECT                                                                                  CER049
395200210122      *****************************************************************                       CER049
395300210122      *                                                               *                       CER049
395400210122      *  Subroutine  :  LNSTAX                                        *                       CER049
395500210122      *  Function    :  Process Stamp Tax information                 *                       CER049
395600210122      *                                                               *                       CER049
395700210122      *  Called by   :  L01CC  - Lending Commencement Confirmations   *                       CER049
395800210122      *  Calls       :  SRPATH - Generate Path String                 *                       CER049
395900210122      *                 SRADTA - Accumulate RDEs and Associated Data  *                       CER049
396000210122      *                 SRODTA - Output Accumulated Data to CGUDTAPD  *                       CER049
396100210122      *                                                               *                       CER049
396200210122      *****************************************************************                       CER049
396300210122      *                                                                                       CER049
396400210122     C     LNSTAX        BEGSR                                                  ** LNSTAX **
396500210122      *                                                                                       CER049
396600210122      ** Set up subroutine stack name.                                                        CER049
396700210122      *                                                                                       CER049
396800210122     C                   ADD       1             Q
396900210122     C                   MOVEL     'LNSTAX'      @STK(Q)
397000210122      *                                                                                       CER049
397100210122     C                   ADD       1             P1
397200210122      *                                                                                       CER049
397300210122     C     P1            OCCUR     ##PATH
397400210122     C                   MOVEL(P)  'LNSTAX'      ##GRPS
397500210122     C                   EXSR      SRPATH
397600210122     C                   EXSR      PSHGRS
397700210122      *                                                                                       CER049
397800210122     C                   Z-ADD     0             R1                3 0
397900210122      *                                                                                       CER049
398000210122      ** Set Loan number key                                                                  CER049
398100210122      *                                                                                       CER049
398200210122     C**********           Z-ADDLNRF      K1LNRF  60                                   CER049 CLE148
398300210122     C                   MOVEL     LNRF          K1LNRF            6
398400210122      *                                                                                       CER049
398500210122      ** Retrieve the stamp tax record for the loan                                           CER049
398600210122      *                                                                                       CER049
398700210122     C     K1LNRF        CHAIN     CLONCLL1                           98
398800210122      *                                                                                       CER049
398900210122      ** If record found, extract stamp tax data                                              CER049
399000210122      *                                                                                       CER049
399100210122     C     *IN98         IFEQ      *OFF
399200210122      *                                                                                       CER049
399300210122      ** Stamp Tax Liable Flag                                                                CER049
399400210122      *                                                                                       CER049
399500210122     C                   ADD       1             R1
399600210122     C                   CLEAR                   R#DATA
399700210122     C                   CLEAR                   R#DEFN
399800210122     C                   CLEAR                   #@RDE
399900210122     C                   MOVEL     'ZSTAXFLG'    #@RDE
400000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
400100210122     C                   MOVEL     LQTAX         R#DATA
400200210122     C                   MOVEL     R#DATA        ##D(R1)
400300210122     C                   MOVEL     R#DEFN        ##R(R1)
400400210122      *                                                                                       CER049
400500210122      ** Principal Tax flag                                                                   CER049
400600210122      *                                                                                       CER049
400700210122     C                   ADD       1             R1
400800210122     C                   CLEAR                   R#DATA
400900210122     C                   CLEAR                   R#DEFN
401000210122     C                   CLEAR                   #@RDE
401100210122     C                   MOVEL     'ZTAXPRFL'    #@RDE
401200210122     C                   MOVE      'G '          #@RDE
401300210122     C     ##RDE         CAT       #@RDE:1       ##RDE
401400210122     C                   MOVEL     LQPRIN        R#DATA
401500210122     C                   MOVEL     R#DATA        ##D(R1)
401600210122     C                   MOVEL     R#DEFN        ##R(R1)
401700210122      *                                                                                       CER049
401800210122      ** Start Date for Principal Tax                                                         CER049
401900210122      *                                                                                       CER049
402000210122     C                   ADD       1             R1
402100210122     C                   CLEAR                   R#DATA
402200210122     C                   CLEAR                   R#DEFN
402300210122     C                   CLEAR                   #@RDE
402400210122     C                   MOVEL     'ZTAXPRDT'    #@RDE
402500210122     C                   MOVE      'E '          #@RDE
402600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
402700210122     C                   MOVEL     LQPDTE        R#DATA
402800210122     C                   MOVEL     R#DATA        ##D(R1)
402900210122     C                   MOVEL     R#DEFN        ##R(R1)
403000210122      *                                                                                       CER049
403100210122      ** Average Balance Flag                                                                 CER049
403200210122      *                                                                                       CER049
403300210122     C                   ADD       1             R1
403400210122     C                   CLEAR                   R#DATA
403500210122     C                   CLEAR                   R#DEFN
403600210122     C                   CLEAR                   #@RDE
403700210122     C                   MOVEL     'ZTAXAVFL'    #@RDE
403800210122     C                   MOVE      'G '          #@RDE
403900210122     C     ##RDE         CAT       #@RDE:1       ##RDE
404000210122     C                   MOVEL     LQAVBL        R#DATA
404100210122     C                   MOVEL     R#DATA        ##D(R1)
404200210122     C                   MOVEL     R#DEFN        ##R(R1)
404300210122      *                                                                                       CER049
404400210122      ** Start Date for Average Balance                                                       CER049
404500210122      *                                                                                       CER049
404600210122     C                   ADD       1             R1
404700210122     C                   CLEAR                   R#DATA
404800210122     C                   CLEAR                   R#DEFN
404900210122     C                   CLEAR                   #@RDE
405000210122     C                   MOVEL     'ZTAXAVDT'    #@RDE
405100210122     C                   MOVE      'E '          #@RDE
405200210122     C     ##RDE         CAT       #@RDE:1       ##RDE
405300210122     C                   MOVEL     LQADTE        R#DATA
405400210122     C                   MOVEL     R#DATA        ##D(R1)
405500210122     C                   MOVEL     R#DEFN        ##R(R1)
405600210122      *                                                                                       CER049
405700210122      ** Interest Tax Flag                                                                    CER049
405800210122      *                                                                                       CER049
405900210122     C                   ADD       1             R1
406000210122     C                   CLEAR                   R#DATA
406100210122     C                   CLEAR                   R#DEFN
406200210122     C                   CLEAR                   #@RDE
406300210122     C                   MOVEL     'ZTAXINFL'    #@RDE
406400210122     C                   MOVE      'G '          #@RDE
406500210122     C     ##RDE         CAT       #@RDE:1       ##RDE
406600210122     C                   MOVEL     LQSINT        R#DATA
406700210122     C                   MOVEL     R#DATA        ##D(R1)
406800210122     C                   MOVEL     R#DEFN        ##R(R1)
406900210122      *                                                                                       CER049
407000210122      ** Start Date for Interest Tax                                                          CER049
407100210122      *                                                                                       CER049
407200210122     C                   ADD       1             R1
407300210122     C                   CLEAR                   R#DATA
407400210122     C                   CLEAR                   R#DEFN
407500210122     C                   CLEAR                   #@RDE
407600210122     C                   MOVEL     'ZTAXINDT'    #@RDE
407700210122     C                   MOVE      'E '          #@RDE
407800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
407900210122     C                   MOVEL     LQIDTE        R#DATA
408000210122     C                   MOVEL     R#DATA        ##D(R1)
408100210122     C                   MOVEL     R#DEFN        ##R(R1)
408200210122      *                                                                                       CER049
408300210122      ** Debit Account Reference                                                              CER049
408400210122      *                                                                                       CER049
408500210122     C     LQDCST        CAT       LQDCCY        WDRAC1            9
408600210122     C                   MOVEL     WDRAC1        WDRAC2           19
408700210122     C                   MOVE      LQDACD        WDRAC2
408800210122     C                   MOVEL     WDRAC2        WDRAC3           21
408900210122     C                   MOVE      LQDASC        WDRAC3
409000210122     C     WDRAC3        CAT       LQDBRC        WDRACC           24
409100210122      *                                                                                       CER049
409200210122     C                   ADD       1             R1
409300210122     C                   CLEAR                   R#DATA
409400210122     C                   CLEAR                   R#DEFN
409500210122     C                   CLEAR                   #@RDE
409600210122     C                   MOVEL     'ACCOUNT'     #@RDE
409700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
409800210122     C                   MOVEL     WDRACC        R#DATA
409900210122     C                   MOVEL     R#DATA        ##D(R1)
410000210122     C                   MOVEL     R#DEFN        ##R(R1)
410100210122      *                                                                                       CER049
410200210122      ** Stamp Tax amount                                                                     CER049
410300210122      *                                                                                       CER049
410400210122     C                   ADD       1             R1
410500210122     C                   CLEAR                   R#DATA
410600210122     C                   CLEAR                   R#DEFN
410700210122     C                   CLEAR                   #@RDE
410800210122     C                   MOVEL     'Z_TAX_AM'    #@RDE
410900210122     C                   MOVE      'T '          #@RDE
411000210122     C     ##RDE         CAT       #@RDE:1       ##RDE
411100210122     C                   MOVEL     LQSTAB        ##DATA
411200210122     C                   MOVEL     'Amount'      ##RDEC
411300210122     C                   MOVEL     'L'           ##RDET
411400210122     C                   MOVEL     LQDCCY        ##CCY
411500210122     C                   EXSR      SRDCDT
411600210122     C                   MOVEL     A6NBDP        ##DCPA
411700210122     C                   MOVEL     R#DATA        ##D(R1)
411800210122     C                   MOVEL     R#DEFN        ##R(R1)
411900210122      *                                                                                       CER049
412000210122      ** Stamp Tax On Interest                                                                CER049
412100210122      *                                                                                       CER049
412200210122     C                   ADD       1             R1
412300210122     C                   CLEAR                   R#DATA
412400210122     C                   CLEAR                   R#DEFN
412500210122     C                   CLEAR                   #@RDE
412600210122     C                   MOVEL     'ZTAXINAM'    #@RDE
412700210122     C                   MOVE      'T '          #@RDE
412800210122     C     ##RDE         CAT       #@RDE:1       ##RDE
412900210122     C                   MOVEL     LQSTAI        ##DATA
413000210122     C                   MOVEL     'Amount'      ##RDEC
413100210122     C                   MOVEL     'L'           ##RDET
413200210122     C                   MOVEL     LQDCCY        ##CCY
413300210122     C                   EXSR      SRDCDT
413400210122     C                   MOVEL     A6NBDP        ##DCPA
413500210122     C                   MOVEL     R#DATA        ##D(R1)
413600210122     C                   MOVEL     R#DEFN        ##R(R1)
413700210122      *                                                                                       CER049
413800210122      ** Stamp Tax on Average This Month                                                      CER049
413900210122      *                                                                                       CER049
414000210122     C                   ADD       1             R1
414100210122     C                   CLEAR                   R#DATA
414200210122     C                   CLEAR                   R#DEFN
414300210122     C                   CLEAR                   #@RDE
414400210122     C                   MOVEL     'ZTAXAVAM'    #@RDE
414500210122     C                   MOVE      'T '          #@RDE
414600210122     C     ##RDE         CAT       #@RDE:1       ##RDE
414700210122     C                   MOVEL     LQTAXE        ##DATA
414800210122     C                   MOVEL     'Amount'      ##RDEC
414900210122     C                   MOVEL     'L'           ##RDET
415000210122     C                   MOVEL     LQDCCY        ##CCY
415100210122     C                   EXSR      SRDCDT
415200210122     C                   MOVEL     A6NBDP        ##DCPA
415300210122     C                   MOVEL     R#DATA        ##D(R1)
415400210122     C                   MOVEL     R#DEFN        ##R(R1)
415500210122      *                                                                                       CER049
415600210122     C                   ENDIF
415700210122      *                                                                                       CER049
415800210122      ** Accumulate RDEs and associated data and output to PF/CGUDTPD.                        CER049
415900210122      *                                                                                       CER049
416000210122     C                   EXSR      SRADTA
416100210122     C                   EXSR      SRODTA
416200210122      *                                                                                       CER049
416300210122      ** Decrement Path DS index.                                                             CER049
416400210122      *                                                                                       CER049
416500210122     C     P1            OCCUR     ##PATH
416600210122     C                   CLEAR                   ##GRPS
416700210122     C                   SUB       1             P1
416800210122     C                   EXSR      POPGRS
416900210122      *                                                                                       CER049
417000210122      ** Unwind subroutine stack name.                                                        CER049
417100210122      *                                                                                       CER049
417200210122     C                   MOVEA     *BLANKS       @STK(Q)
417300210122     C                   SUB       1             Q
417400210122      *                                                                                       CER049
417500210122     C     LNSTA9        ENDSR                                                  ** LNSTA9 **
417600210122      *                                                                                       CER049
417700210122      *****************************************************************                       CER049
417800210122      * Subroutine  :  ZI@APR                                         *                       CER050
417900210122      * Function    :  Extract - Annualised Percentage Rate (APR)     *                       CER050
418000210122      *                                                               *                       CER050
418100210122      * Called by   :                                                 *                       CER050
418200210122      * Calls       :                                                 *                       CER050
418300210122      *****************************************************************                       CER050
418400210122     C     ZI@APR        BEGSR
418500210122      *                                                                                       CER050
418600210122      **  Only if processing type is 61, 62 or 63                                             CER050
418700210122     C     ##PTYP        IFEQ      61
418800210122     C     ##PTYP        OREQ      62
418900210122     C     ##PTYP        OREQ      63
419000210122      *                                                                                       CER050
419100210122      * Run this process only if Do not print APR is set to Blank                             CER050
419200210122      *                                                                                       CER050
419300210122     C     APRC          IFEQ      'Y'
419400210122     C     LNRF          CHAIN     LEAPRHI0                           89
419500210122      *                                                                                       CER050
419600210122      * Look for the first element in blank in series                                         CER050
419700210122     C                   Z-ADD     1             R1
419800210122     C     ##R(R1)       DOUEQ     *BLANKS
419900210122     C     R1            OREQ      20
420000210122     C                   ADD       1             R1
420100210122     C                   ENDDO
420200210122     C*                                                                                       CER050
420300210122     C                   CLEAR                   R#DATA
420400210122     C                   CLEAR                   R#DEFN
420500210122     C                   CLEAR                   #@RDE
420600210122     C                   MOVEL     'ZI_AAPR '    #@RDE            10
420700210122     C     ##RDE         CAT       #@RDE:1       ##RDE
420800210122     C                   MOVEL     IAPRR         R#DATA
420900210122     C                   MOVEL     IAPRR         ##DATA
421000210122     C                   MOVEL     'Rate  '      ##RDEC
421100210122     C                   MOVEL     'L'           ##RDET
421200210122     C                   MOVEL     '2'           ##DCPA
421300210122     C                   MOVEL     R#DATA        ##D(R1)
421400210122     C                   MOVEL     R#DEFN        ##R(R1)
421500210122     C*                                                                                       CER050
421600210122     C                   END
421700210122     C                   ENDIF
421800210122      *                                                                                       CER050
421900210122     C                   ENDSR
422000210122      *                                                                                       CER050
422100210122      *****************************************************************                       CER050
422200210122     C/EJECT
422300210122     C*****************************************************************
422400210122     C*                                                               *
422500210122     C*  Subroutine  :  LOANA                                         *
422600210122     C*  Function    :  Loan Associated Details                       *
422700210122     C*                                                               *
422800210122     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
422900210122     C*  Calls       :  SRPATH - Generate Path String                 *
423000210122     C*                 CG6001 - General Loan Details                 *
423100210122     C*****************************************************************
423200210122     C*
423300210122     C     LOANA         BEGSR                                                  ** LOANA  **
423400210122     C*
423500210122     C**  Set up subroutine stack name.
423600210122     C*
423700210122     C                   ADD       1             Q
423800210122     C                   MOVEL     'LOANA '      @STK(Q)
423900210122     C*
424000210122     C                   EXSR      SRPATH
424100210122     C*
424200210122     C                   MOVEL     S#PATH        P2PARM
424300210122     C                   Z-ADD     ##OSEQ        P1OSEQ
424400210122     C                   Z-ADD     ##ITEM        P1ITEM
424500210122     C                   Z-ADD     ##TBIN        P1TBIN
424600210122     C                   Z-ADD     ##PBIN        P1PBIN
424700210122     C*
424800210122     C**  Set up data.
424900210122     C*
425000210122     C                   CLEAR                   P4PARM
425100210122     C                   MOVE      *BLANKS       P@CNAM
425200210122     C     ##CHT1        IFEQ      'R'
425300210122     C     ##CHT1        OREQ      'A'
425400210122     C                   MOVEL     ##CHT1        P@CNAM
425500210122     C                   END
425600210122     C*
425700210122     C                   MOVE      LNRF          P@LNRF
425800210122     C                   CALL      'CG6001'
425900210122     C                   PARM      *BLANKS       W0RTN             7
426000210122     C                   PARM                    W0CMT             3
426100210122     C                   PARM                    P1PARM                         UDC Details
426200210122     C                   PARM                    P2PARM          140            Path Details
426300210122     C                   PARM                    P@PARM                         Loan Details
426400210122     C                   PARM                    P4PARM                         Facility Details
426500210122     C                   PARM                    ##AUTO
426600210122     C                   PARM                    ##REFR
426700210122     C                   PARM                    P@ICR
426800210122     C                   PARM      'N'           ##MAST
426900210122     C*
427000210122     C**  Reset Sequence number.
427100210122     C*
427200210122     C                   Z-ADD     P1OSEQ        ##OSEQ
427300210122     C*
427400210122     C     EXXPAY        TAG
427500210122     C*
427600210122     C**  Unwind subroutine stack name.
427700210122     C*
427800210122     C                   MOVEA     *BLANKS       @STK(Q)
427900210122     C                   SUB       1             Q
428000210122     C*
428100210122     C     LOANA9        ENDSR                                                  ** LOANA9 **
428200210122     C*
428300210122     C*****************************************************************
428400210122     C/EJECT
428500210122     C*****************************************************************
428600210122     C*                                                               *
428700210122     C*  Subroutine  :  SRSDET                                        *
428800210122     C*  Function    :  Set-up settlement details                     *
428900210122     C*                                                               *
429000210122     C*  Called by   :  L01CC - Lending Commencement Confirmations    *
429100210122     C*  Calls       :  SRPATH - Generate Path String                 *
429200210122     C*                 CG99LSET - To set-up settlement details       *
429300210122     C*                                                               *
429400210122     C*****************************************************************
429500210122     C*
429600210122     C     SRSDET        BEGSR                                                  ** SRSDET **
429700210122     C*
429800210122     C**  Set up subroutine stack name.
429900210122     C*
430000210122     C                   ADD       1             Q
430100210122     C                   MOVEL     'SRSDET'      @STK(Q)
430200210122     C*
430300210122     C                   ADD       1             P1
430400210122     C*                                                                                       CCG015
430500210122     C     P1            OCCUR     ##PATH
430600210122     C                   MOVEL(P)  'L_SETL'      ##GRPS
430700210122     C                   EXSR      SRPATH
430800210122     C                   EXSR      PSHGRS
430900210122     C*
431000210122     C                   MOVEL     S#PATH        P2PARM
431100210122     C*
431200210122     C**  Setup the parameters for CG99LSET.
431300210122     C*
431400210122     C                   CLEAR                   P0PARM
431500210122     C                   MOVEL     ##OSDB        P0POBR
431600210122     C                   MOVEL     ##OMDB        P0ROBR
431700210122     C                   Z-ADD     ##RSTM        P0RSTM
431800210122     C                   MOVEL     ##RONS        P0RONS
431900210122     C                   MOVEL     ##RIBN        P0RIBN
432000210122     C                   MOVEL     ##RIBA        P0RIBA
432100210122     C**********           Z-ADD##ROBN    P0ROBN                                              CSD027
432200210122     C**********           Z-ADD##ROCN    P0ROCN                                              CSD027
432300210122     C                   MOVE      ##ROBN        P0ROBN
432400210122     C                   MOVE      ##ROCN        P0ROCN
432500210122     C                   Z-ADD     ##PSTM        P0PSTM
432600210122     C                   MOVEL     ##PONS        P0PONS
432700210122     C                   MOVEL     ##PIBN        P0PIBN
432800210122     C                   MOVEL     ##PIBA        P0PIBA
432900210122     C**********           Z-ADD##POBN    P0POBN                                              CSD027
433000210122     C**********           Z-ADD##POCN    P0POCN                                              CSD027
433100210122     C                   MOVE      ##POBN        P0POBN
433200210122     C                   MOVE      ##POCN        P0POCN
433300210122     C                   MOVEL     ##RCRN        P0RCRN
433400210122     C                   MOVEL     ##RCRA        P0RCRA
433500210122     C                   MOVEL     ##RVNO        P0RVNO
433600210122     C                   MOVEL     ##AWBN        P0AWBN
433700210122     C                   MOVEL     ##AWBA        P0AWBA
433800210122     C                   MOVEL     ##BENN        P0BENN
433900210122     C                   MOVEL     ##BENA        P0BENA
434000210122     C                   MOVEL     ##DTP1        P0DTP1
434100210122     C                   MOVEL     ##DTP2        P0DTP2
434200210122     C                   MOVEL     ##DTP3        P0DTP3
434300210122     C                   MOVEL     ##DTP4        P0DTP4
434400210122     C                   MOVEL     ##DCHG        P0DCHG
434500210122     C                   MOVEL     ##BTB1        P0BTB1
434600210122     C                   MOVEL     ##BTB2        P0BTB2
434700210122     C                   MOVEL     ##BTB3        P0BTB3
434800210122     C                   MOVEL     ##BTB4        P0BTB4
434900210122     C                   MOVEL     ##BTB5        P0BTB5
435000210122     C                   MOVEL     ##BTB6        P0BTB6
435100210122     C                   MOVEL     ##SPI1        P0SPI1
435200210122     C                   MOVEL     ##SPI2        P0SPI2
435300210122     C                   MOVEL     ##SPI3        P0SPI3
435400210122     C     CEU014        IFEQ      'Y'                                                         CEU01
435500210122     C     CLE031        OREQ      'Y'
435600210122     C                   MOVEL     ##STCY        P0STCY                                        CEU01
435700210122     C                   ENDIF                                                                 CEU01
435800210122      *                                                                                       CLE031
435900210122     C     CLE031        IFEQ      'Y'
436000210122     C                   MOVEL     ##PSCY        P0PSCY
436100210122     C                   ENDIF
436200210122     C*
436300210122     C                   Z-ADD     ##OSEQ        P1OSEQ
436400210122     C                   Z-ADD     ##ITEM        P1ITEM
436500210122     C                   Z-ADD     ##TBIN        P1TBIN
436600210122     C                   Z-ADD     ##PBIN        P1PBIN
436700210122      *                                                                                       130998
436800210122      * If settlement method set in old fields and not in new then use                        130998
436900210122      *                                                                                       130998
437000210122     C     ##MDST        IFNE      0
437100210122     C     P0RSTM        ANDEQ     0
437200210122     C                   MOVEL     ##MDST        P0RSTM                         *Settlemt type
437300210122     C                   MOVEL     ##OMDB        P0ROBR                         *Settlemt branch
437400210122     C                   MOVEL     ##OMDA        P0RONS                         *Our nostro/ A/C
437500210122     C                   MOVEL     ##TMAN        P0RIBN                         *Their nostro
437600210122     C                   ENDIF
437700210122     C*                                                                                       130998
437800210122     C     ##SDST        IFNE      0
437900210122     C     P0PSTM        ANDEQ     0
438000210122     C                   MOVEL     ##SDST        P0PSTM                         *Settlemt type
438100210122     C                   MOVEL     ##OSDB        P0POBR                         *Settlemt branch
438200210122     C                   MOVEL     ##OSDA        P0PONS                         *Our nostro/ A/C
438300210122     C                   MOVEL     ##TSTN        P0AWBN                         *Their nostro
438400210122     C                   MOVEL     ##FACO        P0BENN                         *For account of
438500210122     C                   ENDIF
438600210122     C*
438700210122     C                   CALL      'CG99LSET'
438800210122     C                   PARM      *BLANKS       W0RTN             7
438900210122     C                   PARM                    W0CMT             3
439000210122     C                   PARM                    ##COPD
439100210122     C                   PARM                    P1PARM
439200210122     C                   PARM                    P2PARM          140
439300210122     C                   PARM                    PDETLS
439400210122     C                   PARM                    P0PARM
439500210122     C                   PARM                    ##REFR
439600210122     C                   PARM                    P@ICR
439700210122     C                   PARM      'N'           ##MAST
439800210122     C*
439900210122     C     W0RTN         IFNE      *BLANK
440000210122     C                   MOVEL     'CG99LSET'    W0FILE
440100210122     C                   MOVEL     'W0RTN'       W0KEY                          ************
440200210122     C                   Z-ADD     8             W0ERNB                         * DBERR 08 *
440300210122     C                   MOVEL     'MEM5003'     W0MSGD                         ************
440400210122     C                   MOVEL     'MIDAS  '     W0MSGF
440500210122     C                   EXSR      SRERR
440600210122     C                   END
440700210122     C*
440800210122     C**  Reset Sequence number.
440900210122     C*
441000210122     C                   Z-ADD     P1OSEQ        ##OSEQ
441100210122     C*                                                                                       CCG015
441200210122     C**  Decrement Path DS index                                                             CCG015
441300210122     C*                                                                                       CCG015
441400210122     C     P1            OCCUR     ##PATH
441500210122     C                   CLEAR                   ##GRPS
441600210122     C                   SUB       1             P1
441700210122      *                                                                                       CCG015
441800210122     C                   EXSR      POPGRS
441900210122     C*
442000210122     C**  Unwind subroutine stack name.
442100210122     C*
442200210122     C                   MOVEA     *BLANKS       @STK(Q)
442300210122     C                   SUB       1             Q
442400210122     C*
442500210122     C     SRSDE9        ENDSR                                                  ** SRSDE9 **
442600210122     C*
442700210122     C*****************************************************************
442800210122     C/EJECT
442900210122     C*****************************************************************
443000210122     C*                                                               *
443100210122     C*  Subroutine  :  SRINZF                                        *
443200210122     C*  Function    :  Initialise Fields on Each Invocation          *
443300210122     C*                                                               *
443400210122     C*  Called by   :  MAINLINE - Mainline Processing                *
443500210122     C*  Calls       :  None                                          *
443600210122     C*                                                               *
443700210122     C*****************************************************************
443800210122     C*
443900210122     C     SRINZF        BEGSR                                                  ** SRINZF **
444000210122     C*
444100210122     C**  Set up subroutine stack name.
444200210122     C*
444300210122     C                   ADD       1             Q
444400210122     C                   MOVEL     'SRINZF'      @STK(Q)
444500210122     C*
444600210122     C**  Initialise work fields.
444700210122     C*
444800210122     C                   Z-ADD     *ZEROS        ##W050            5 0
444900210122     C                   Z-ADD     *ZEROS        ##W150           15 0
445000210122     C                   Z-ADD     *ZEROS        ##W157           15 7
445100210122     C                   Z-ADD     *ZEROS        #1                6 0
445200210122     C                   Z-ADD     *ZEROS        #2                6 0
445300210122     C                   Z-ADD     *ZEROS        #3                6 0
445400210122     C                   MOVE      *BLANKS       S#PATH          256
445500210122     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
445600210122     C*
445700210122     C**  Initialise output sequence (to CGUDTAPD).
445800210122     C*
445900210122     C                   Z-ADD     *ZEROS        ##OSEQ
446000210122     C*
446100210122     C**  DJU Additions for CG4999 1st version.
446200210122     C*
446300210122     C                   MOVE      *BLANKS       #@RDE            10
446400210122     C     *LIKE         DEFINE    ##TBIN        #@TBIN
446500210122     C*
446600210122     C     1             OCCUR     ##BIND
446700210122     C                   RESET                   ##BIND
446800210122     C                   RESET                   #@BIND
446900210122     C                   RESET                   #PDS
447000210122      *                                                                                       CCG015
447100210122      ** Initialise XML increment                                                             CCG015
447200210122      *                                                                                       CCG015
447300210122     C                   EXSR      INIXML
447400210122     C*
447500210122     C     EXINZ         TAG
447600210122     C*
447700210122     C**  Unwind subroutine stack name.
447800210122     C*
447900210122     C                   MOVEA     *BLANKS       @STK(Q)
448000210122     C                   SUB       1             Q
448100210122     C*
448200210122     C     SRINZ9        ENDSR                                                  ** SRINZ9 **
448300210122     C*
448400210122     C*****************************************************************
448500210122     C/EJECT
448600210122     C*****************************************************************
448700210122     C*                                                               *
448800210122     C*  Subroutine  :  SRINIT                                        *
448900210122     C*  Function    :  Initial processing - On First Call            *
449000210122     C*                                                               *
449100210122     C*  Called by   :  MAINLINE - Mainline Processing                *
449200210122     C*  Calls       :  AOBANKR0 - Retrive Bank Details               *
449300210122     C*                 SRDCDT   - Determine Currency Details         *
449400210122     C*                                                               *
449500210122     C*****************************************************************
449600210122     C*
449700210122     C     SRINIT        BEGSR                                                  ** SRINIT **
449800210122     C*
449900210122     C**  Set up subroutine stack name.
450000210122     C*
450100210122     C                   ADD       1             Q
450200210122     C                   MOVEL     'SRINIT'      @STK(Q)
450300210122     C/COPY WNCPYSRC,CG6005C003
450400210122     C*
450500210122     C**  Retrieve Bank details.
450600210122     C*
450700210122     C                   CALL      'AOBANKR0'
450800210122     C                   PARM      *BLANKS       ##RTCD            7
450900210122     C                   PARM      '*FIRST  '    ##OPTN            7
451000210122     C     SDBANK        PARM      SDBANK        DSSDY
451100210122     C*
451200210122     C     ##RTCD        IFNE      *BLANK
451300210122     C                   MOVEL     'SDBANKPD'    W0FILE
451400210122     C                   MOVEL     '*FIRST'      W0KEY                          ************
451500210122     C                   Z-ADD     9             W0ERNB                         * DBERR 09 *
451600210122     C                   MOVEL     'MEM5003'     W0MSGD                         ************
451700210122     C                   MOVEL     'MIDAS  '     W0MSGF
451800210122     C                   EXSR      SRERR
451900210122     C                   END
452000210122     C*
452100210122     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
452200210122     C*
452300210122     C**  Determine Number of decimal places - Base currency.
452400210122     C*
452500210122     C                   MOVEL     BJCYCD        ##CCY
452600210122     C                   EXSR      SRDCDT
452700210122     C                   Z-ADD     A6NBDP        BASCDP            1 0
452800210122      *                                                                   CEU014
452900210122      ** Access GL ICD for Euro currency code                             CEU014
453000210122      *                                                                   CEU014
453100210122     C**********           CALL 'AOGELRR0'                                             CEU014 CGL029
453200210122     C                   CALL      'AOGELRR1'
453300210122     C                   PARM      *BLANKS       ##RTCD                                        CEU01
453400210122     C                   PARM      '*FIRST '     ##OPTN                                        CEU01
453500210122     C********** SDGELR    PARM SDGELR    DSFDY                                        CEU014 CGL029
453600210122     C     SDGELR        PARM      SDGELR        DSSDY
453700210122      *                                                                   CEU014
453800210122      ** DATABASE ERROR                                                   CEU014
453900210122      *                                                                   CEU014
454000210122     C     ##RTCD        IFNE      *BLANKS                                                     CEU01
454100210122     C                   MOVEL     'SDGELRPD'    W0FILE                                        CEU01
454200210122     C                   MOVEL     ##OPTN        W0KEY                          ***************CEU01
454300210122     C                   Z-ADD     17            W0ERNB                         * DB ERROR 17 *CEU01
454400210122     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
454500210122     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
454600210122     C                   EXSR      SRERR                                                       CEU01
454700210122     C                   ENDIF                                                                 CEU01
454800210122      *                                                                   CLE005
454900210122      ** Check if CLE005 is ON                                            CLE005
455000210122      *                                                                   CLE005
455100210122     C                   CALL      'AOSARDR0'                                                  CLE00
455200210122     C                   PARM      *BLANKS       ##RTCD            7                           CLE00
455300210122     C                   PARM      '*KEY    '    ##OPTN            7                           CLE00
455400210122     C                   PARM      'CLE005'      PSARD             6                           CLE00
455500210122     C     SCSARD        PARM      SCSARD        DSFDY                                         CLE00
455600210122     C*                                                                   CLE005
455700210122     C     ##RTCD        IFEQ      *BLANK                                                      CLE00
455800210122     C                   MOVE      'Y'           CLE005            1                           CLE00
455900210122     C                   ELSE                                                                  CLE00
456000210122     C                   MOVE      'N'           CLE005                                        CLE00
456100210122     C     ##RTCD        IFNE      '*NRF    '                                                  CLE00
456200210122     C                   MOVEL     'SCSARDPD'    W0FILE                                        CLE00
456300210122     C                   MOVEL     'CLE005'      W0KEY                          ************   CLE00
456400210122     C                   Z-ADD     15            W0ERNB                         * DBERR 15 *   CLE00
456500210122     C                   MOVEL     'MEM5003'     W0MSGD                         ************   CLE00
456600210122     C                   MOVEL     'MIDAS  '     W0MSGF                                        CLE00
456700210122     C                   EXSR      SRERR                                                       CLE00
456800210122     C                   ENDIF                                                                 CLE00
456900210122     C                   ENDIF                                                                 CLE00
457000210122     C*
457100210122      ** Check if CEU014 is switched on                                   CEU014
457200210122      *                                                                   CEU014
457300210122     C                   CALL      'AOSARDR0'                                                  CEU01
457400210122     C                   PARM      *BLANKS       ##RTCD            7                           CEU01
457500210122     C                   PARM      '*KEY    '    ##OPTN            7                           CEU01
457600210122     C                   PARM      'CEU014'      PSARD             6                           CEU01
457700210122     C     SCSARD        PARM      SCSARD        DSFDY                                         CEU01
457800210122     C*                                                                   CEU014
457900210122     C     ##RTCD        IFEQ      *BLANK                                                      CEU01
458000210122     C                   MOVE      'Y'           CEU014            1                           CEU01
458100210122     C                   ELSE                                                                  CEU01
458200210122     C                   MOVE      'N'           CEU014                                        CEU01
458300210122     C     ##RTCD        IFNE      '*NRF    '                                                  CEU01
458400210122     C                   MOVEL     'SCSARDPD'    W0FILE                                        CEU01
458500210122     C                   MOVEL     'CEU014'      W0KEY                          ************   CEU01
458600210122     C                   Z-ADD     16            W0ERNB                         * DBERR 16 *   CEU01
458700210122     C                   MOVEL     'MEM5003'     W0MSGD                         ************   CEU01
458800210122     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
458900210122     C                   EXSR      SRERR                                                       CEU01
459000210122     C                   ENDIF                                                                 CEU01
459100210122     C                   ENDIF                                                                 CEU01
459200210122      *                                                                                       CCG015
459300210122      ** Access Switchable Features file and check if CCG015 is                               CCG015
459400210122      ** installed                                                                            CCG015
459500210122      *                                                                                       CCG015
459600210122     C                   CALL      'AOSARDR0'
459700210122     C                   PARM      *BLANKS       ##RTCD
459800210122     C                   PARM      '*VERIFY'     ##OPTN
459900210122     C                   PARM      'CCG015'      PSARD
460000210122     C     SCSARD        PARM      SCSARD        DSFDY
460100210122      *                                                                                       CCG015
460200210122     C     ##RTCD        IFEQ      *BLANK
460300210122     C                   MOVE      'Y'           CCG015            1
460400210122     C                   ELSE
460500210122     C                   MOVE      'N'           CCG015
460600210122      *                                                                                       CCG015
460700210122     C     ##RTCD        IFNE      '*NRF    '
460800210122     C                   MOVEL     'SCSARDPD'    W0FILE
460900210122     C                   MOVEL     '*CALL   '    W0KEY
461000210122     C                   Z-ADD     19            W0ERNB
461100210122     C                   MOVEL     'MEM5003'     W0MSGD
461200210122     C                   MOVEL     'MIDAS  '     W0MSGF
461300210122     C                   EXSR      SRERR
461400210122     C                   ENDIF
461500210122      *                                                                                       CCG015
461600210122     C                   ENDIF
461700210122      *                                                                                       CLE028
461800210122      ** Check if Flat Rate Personal Loans (Rule of 78s) is installed.                        CLE028
461900210122      *                                                                                       CLE028
462000210122     C                   CALL      'AOSARDR0'
462100210122     C                   PARM      *BLANKS       ##RTCD
462200210122     C                   PARM      '*KEY    '    ##OPTN
462300210122     C                   PARM      'CLE028'      PSARD
462400210122     C     SCSARD        PARM      SCSARD        DSFDY
462500210122     C*                                                                                       CLE028
462600210122     C     ##RTCD        IFEQ      *BLANK
462700210122     C                   MOVE      'Y'           CLE028            1
462800210122     C                   ELSE
462900210122     C                   MOVE      'N'           CLE028
463000210122     C     ##RTCD        IFNE      '*NRF    '
463100210122     C                   MOVEL     'SCSARDPD'    W0FILE
463200210122     C                   MOVEL     'CLE028'      W0KEY
463300210122     C                   Z-ADD     20            W0ERNB
463400210122     C                   MOVEL     'MEM5003'     W0MSGD
463500210122     C                   MOVEL     'MIDAS  '     W0MSGF
463600210122     C                   EXSR      SRERR
463700210122     C                   ENDIF
463800210122     C                   ENDIF
463900210122      *                                                                                       CLE028
464000210122      ** Access Switchable Features file and check if CLE031 is                               CLE031
464100210122      ** installed                                                                            CLE031
464200210122      *                                                                                       CLE031
464300210122     C                   CALL      'AOSARDR0'
464400210122     C                   PARM      *BLANKS       ##RTCD
464500210122     C                   PARM      '*VERIFY'     ##OPTN
464600210122     C                   PARM      'CLE031'      PSARD
464700210122     C     SCSARD        PARM      SCSARD        DSFDY
464800210122      *                                                                                       CLE031
464900210122     C     ##RTCD        IFEQ      *BLANK
465000210122     C                   MOVE      'Y'           CLE031            1
465100210122     C                   ELSE
465200210122     C                   MOVE      'N'           CLE031
465300210122      *                                                                                       CLE031
465400210122     C     ##RTCD        IFNE      '*NRF    '
465500210122     C                   MOVEL     'SCSARDPD'    W0FILE
465600210122     C                   MOVEL     '*CALL   '    W0KEY
465700210122     C                   Z-ADD     20            W0ERNB
465800210122     C                   MOVEL     'MEM5003'     W0MSGD
465900210122     C                   MOVEL     'MIDAS  '     W0MSGF
466000210122     C                   EXSR      SRERR
466100210122     C                   ENDIF
466200210122      *                                                                                       CLE031
466300210122     C                   ENDIF
466400210122      *                                                                                       CLE036
466500210122      ** Check if CLE036 is installed.                                                        CLE036
466600210122      *                                                                                       CLE036
466700210122     C                   CALL      'AOSARDR0'
466800210122     C                   PARM      *BLANKS       PRTCD             7
466900210122     C                   PARM      '*VERIFY'     POPTN             7
467000210122     C                   PARM      'CLE036'      PSARD
467100210122     C     SCSARD        PARM      SCSARD        DSFDY
467200210122      *                                                                                       CLE036
467300210122     C     PRTCD         IFEQ      *BLANK
467400210122     C                   MOVE      'Y'           CLE036            1
467500210122     C                   ELSE
467600210122     C                   MOVE      'N'           CLE036
467700210122      *                                                                                       CLE036
467800210122     C     PRTCD         IFNE      '*NRF    '
467900210122     C                   MOVEL     'SCSARDPD'    W0FILE
468000210122     C                   MOVEL     '*CALL   '    W0KEY
468100210122     C                   Z-ADD     21            W0ERNB
468200210122     C                   MOVEL     'MEM5003'     W0MSGD
468300210122     C                   MOVEL     'MIDAS  '     W0MSGF
468400210122     C                   EXSR      SRERR
468500210122     C                   ENDIF
468600210122      *                                                                                       CLE036
468700210122     C                   ENDIF
468800210122     C*                                                                   CEU014
468900210122     C/COPY WNCPYSRC,CG6005C013
469000210122     C**  Copyright Statement.
469100210122     C*
469200210122     C                   MOVEA     CPY@          ACT@             80
469300210122     C/COPY WNCPYSRC,CG6005C002
469400210122      *                                                                                       CER038
469500210122      ** Check if CER038 is ON                                                                CER038
469600210122      *                                                                                       CER038
469700210122     C                   CALL      'AOSARDR0'
469800210122     C                   PARM      *BLANKS       ##RTCD            7
469900210122     C                   PARM      '*KEY    '    ##OPTN            7
470000210122     C                   PARM      'CER038'      PSARD             6
470100210122     C     SCSARD        PARM      SCSARD        DSFDY
470200210122      *                                                                                       CER038
470300210122     C     ##RTCD        IFEQ      *BLANKS
470400210122     C                   MOVE      'Y'           CER038            1
470500210122     C                   ELSE
470600210122     C                   MOVE      'N'           CER038
470700210122     C                   ENDIF
470800210122      *                                                                                       CER038
470900210122      ** Check if CLE143 is ON                                                                CLE143
471000210122      *                                                                                       CLE143
471100210122     C                   CALL      'AOSARDR0'
471200210122     C                   PARM      *BLANKS       ##RTCD
471300210122     C                   PARM      '*VERIFY '    ##OPTN
471400210122     C                   PARM      'CLE143'      PSARD
471500210122     C     SCSARD        PARM      SCSARD        DSFDY
471600210122      *                                                                                       CLE143
471700210122     C     ##RTCD        IFEQ      *BLANKS
471800210122     C                   MOVE      'Y'           CLE143            1
471900210122     C                   ELSE
472000210122     C                   MOVE      'N'           CLE143
472100210122     C                   ENDIF
472200210122     C/COPY WNCPYSRC,CGH00020
472300210122      *                                                                                       CLE143
472400210122     C                   CALL      'AOMMODR0'
472500210122     C                   PARM      *BLANKS       ##RTCD
472600210122     C                   PARM      '*FIRST  '    ##OPTN
472700210122     C     SDMMOD        PARM      SDMMOD        DSFDY
472800210122      *                                                                                     BUG23004
472900210122     C     ##RTCD        IFNE      *BLANKS
473000210122      *                                                                                     BUG23004
473100210122      ** Database error                                                                     BUG23004
473200210122      *                                                                                     BUG23004
473300210122     C                   MOVEL     'AOMMODR0'    W0FILE
473400210122     C                   MOVEL     '*CALL'       W0KEY                          ************
473500210122     C                   Z-ADD     20            W0ERNB                         * DB ERROR 2
473600210122     C                   MOVEL     'MEM5003'     W0MSGD                         ************
473700210122     C                   MOVEL     'MIDAS  '     W0MSGF
473800210122     C                   EXSR      SRERR
473900210122     C                   ENDIF
474000210122      *                                                                                     BUG23004
474100210122      ** Call access program for message details                                            BUG23004
474200210122      *                                                                                     BUG23004
474300210122     C     BGSWCL        IFEQ      'Y'
474400210122     C                   CALL      'AOMGMER0'
474500210122     C                   PARM      *BLANKS       ##RTCD
474600210122     C                   PARM      '*FIRST  '    ##OPTN
474700210122     C     SDMGME        PARM      SDMGME        DSFDY
474800210122      *                                                                                     BUG23004
474900210122     C     ##RTCD        IFNE      *BLANKS
475000210122      *                                                                                     BUG23004
475100210122      ** Database error                                                                     BUG23004
475200210122      *                                                                                     BUG23004
475300210122     C                   MOVEL     'AOMGMER0'    W0FILE
475400210122     C                   MOVEL     '*CALL'       W0KEY                          ************
475500210122     C                   Z-ADD     24            W0ERNB                         * DB ERROR 2
475600210122     C                   MOVEL     'MEM5003'     W0MSGD                         ************
475700210122     C                   MOVEL     'MIDAS  '     W0MSGF
475800210122     C                   EXSR      SRERR
475900210122     C                   ENDIF
476000210122     C                   ENDIF
476100210122      *                                                                                     BUG23004
476200210122      ** Call access program for trading data details                                       BUG23004
476300210122      *                                                                                     BUG23004
476400210122     C                   CALL      'AOTRADR0'
476500210122     C                   PARM      *BLANKS       ##RTCD
476600210122     C                   PARM      '*FIRST  '    ##OPTN
476700210122     C     SDTRAD        PARM      SDTRAD        DSFDY
476800210122      *                                                                                     BUG23004
476900210122     C     ##RTCD        IFNE      *BLANKS
477000210122      *                                                                                     BUG23004
477100210122      ** Database error                                                                     BUG23004
477200210122      *                                                                                     BUG23004
477300210122     C                   MOVEL     'AOTRADR0'    W0FILE
477400210122     C                   MOVEL     '*CALL'       W0KEY                          ************
477500210122     C                   Z-ADD     22            W0ERNB                         * DB ERROR 2
477600210122     C                   MOVEL     'MEM5003'     W0MSGD                         ************
477700210122     C                   MOVEL     'MIDAS  '     W0MSGF
477800210122     C                   EXSR      SRERR
477900210122     C                   ENDIF
478000210122      *                                                                                       CRE073
478100210122      ** Check if CRE073 is ON                                                                CRE073
478200210122      *                                                                                       CRE073
478300210122     C                   CALL      'AOSARDR0'
478400210122     C                   PARM      *BLANKS       ##RTCD
478500210122     C                   PARM      '*VERIFY '    ##OPTN
478600210122     C                   PARM      'CRE073'      PSARD
478700210122     C     SCSARD        PARM      SCSARD        DSFDY
478800210122      *                                                                                       CRE073
478900210122     C     ##RTCD        IFEQ      *BLANKS
479000210122     C                   MOVE      'Y'           CRE073            1
479100210122     C                   ELSE
479200210122     C                   MOVE      'N'           CRE073
479300210122     C                   ENDIF
479400210122      *                                                                                       CRE073
479500210122      ** Check if CER049 is installed.                                                        CER049
479600210122      *                                                                                       CER049
479700210122     C                   CALL      'AOSARDR0'
479800210122     C                   PARM      *BLANKS       PRTCD             7
479900210122     C                   PARM      '*VERIFY'     POPTN             7
480000210122     C                   PARM      'CER049'      PSARD
480100210122     C     SCSARD        PARM      SCSARD        DSFDY
480200210122      *                                                                                       CER049
480300210122     C     PRTCD         IFEQ      *BLANK
480400210122     C                   MOVE      'Y'           CER049            1
480500210122     C                   ELSE
480600210122     C                   MOVE      'N'           CER049
480700210122      *                                                                                       CER049
480800210122     C     PRTCD         IFNE      '*NRF    '
480900210122     C                   MOVEL     'SCSARDPD'    W0FILE
481000210122     C                   MOVEL     '*CALL   '    W0KEY
481100210122     C                   Z-ADD     31            W0ERNB
481200210122     C                   MOVEL     'MEM5003'     W0MSGD
481300210122     C                   MOVEL     'MIDAS  '     W0MSGF
481400210122     C                   EXSR      SRERR
481500210122     C                   ENDIF
481600210122      *                                                                                       CER049
481700210122     C                   ENDIF
481800210122      *                                                                                     MD029242
481900210122      ** If CER038 is switched on, check if Suppress Correspondence for                     MD029242
482000210122      ** Customer with Swift ID is 'Y/N'                                                    MD029242
482100210122      *                                                                                     MD029242
482200210122     C     CER038        IFEQ      'Y'
482300210122     C                   MOVEL     *BLANKS       SUPCON            1
482400210122     C                   CALL      'AOSVALR0'
482500210122     C                   PARM                    P@RTCD            7
482600210122     C                   PARM      #SUPRS        P@OP01           20
482700210122     C     SVAL1         PARM                    P@VL01          200
482800210122     C                   PARM      *BLANK        P@OP02           20
482900210122     C                   PARM                    P@VL02          200
483000210122     C                   PARM      *BLANK        P@OP03           20
483100210122     C                   PARM                    P@VL03          200
483200210122     C                   PARM      *BLANK        P@OP04           20
483300210122     C                   PARM                    P@VL04          200
483400210122     C                   PARM      *BLANK        P@OP05           20
483500210122     C                   PARM                    P@VL05          200
483600210122     C                   PARM      *BLANK        P@OP06           20
483700210122     C                   PARM                    P@VL06          200
483800210122     C                   PARM      *BLANK        P@OP07           20
483900210122     C                   PARM                    P@VL07          200
484000210122     C                   PARM      *BLANK        P@OP08           20
484100210122     C                   PARM                    P@VL08          200
484200210122     C                   PARM      *BLANK        P@OP09           20
484300210122     C                   PARM                    P@VL09          200
484400210122     C                   PARM      *BLANK        P@OP10           20
484500210122     C                   PARM                    P@VL10          200
484600210122      *                                                                                     MD029242
484700210122     C     P@RTCD        IFNE      *BLANKS
484800210122     C     P@RTCD        ANDNE     '*NRF   '
484900210122     C                   MOVEL     'SDSVALPD'    W0FILE                         ***************
485000210122     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 50 *
485100210122     C                   Z-ADD     50            W0ERNB                         ***************
485200210122     C                   MOVEL     'MEM5003'     W0MSGD
485300210122     C                   MOVEL     'MIDAS  '     W0MSGF
485400210122     C                   EXSR      SRERR
485500210122     C                   ENDIF
485600210122      *                                                                                     MD029242
485700210122     C     P@RTCD        IFEQ      *BLANKS
485800210122     C                   MOVEL     SVAL11        SUPCON
485900210122     C                   ENDIF
486000210122      *                                                                                     MD029242
486100210122     C                   ENDIF
486200210122      *                                                                                       CER049
486300210122      ** Access SAR details file to determine if CER050 is installed.                         CER050
486400210122      *                                                                                       CER050
486500210122     C                   CALL      'AOSARDR0'
486600210122     C                   PARM      '       '     ##RTCD
486700210122     C                   PARM      '*VERIFY'     ##OPTN
486800210122     C                   PARM      'CER050'      ##SARD            6
486900210122      *                                                                                       CER050
487000210122     C     ##RTCD        IFEQ      *BLANK
487100210122     C                   MOVEL     'Y'           CER050            1
487200210122     C                   ELSE
487300210122     C                   MOVEL     'N'           CER050
487400210122     C                   END
487500210122      *                                                                                       CER050
487600210122      ** Check if CLE141 is installed.                                                        CLE141
487700210122      *                                                                                       CLE141
487800210122     C                   CALL      'AOSARDR0'
487900210122     C                   PARM      *BLANKS       PRTCD
488000210122     C                   PARM      '*VERIFY'     POPTN
488100210122     C                   PARM      'CLE141'      PSARD
488200210122     C     SCSARD        PARM      SCSARD        DSFDY
488300210122      *                                                                                       CLE141
488400210122     C     PRTCD         IFEQ      *BLANK
488500210122     C                   MOVE      'Y'           CLE141            1
488600210122     C                   ELSE
488700210122     C                   MOVE      'N'           CLE141
488800210122     C                   ENDIF
488900210122     C*
489000210122      *                                                                                     MD035545
489100210122      ** Retrieve system value setting                                                      MD035545
489200210122      *                                                                                     MD035545
489300210122     C                   MOVEL     WPARML        P@OP01
489400210122     C                   CALL      'AOSVALR0'
489500210122     C                   PARM      *BLANKS       W0RTCD            7
489600210122     C                   PARM                    P@OP01           20
489700210122     C                   PARM                    P@VL01          200
489800210122     C                   PARM                    P@OP02           20
489900210122     C                   PARM                    P@VL02          200
490000210122     C                   PARM                    P@OP03           20
490100210122     C                   PARM                    P@VL03          200
490200210122     C                   PARM                    P@OP04           20
490300210122     C                   PARM                    P@VL04          200
490400210122     C                   PARM                    P@OP05           20
490500210122     C                   PARM                    P@VL05          200
490600210122     C                   PARM                    P@OP06           20
490700210122     C                   PARM                    P@VL06          200
490800210122     C                   PARM                    P@OP07           20
490900210122     C                   PARM                    P@VL07          200
491000210122     C                   PARM                    P@OP08           20
491100210122     C                   PARM                    P@VL08          200
491200210122     C                   PARM                    P@OP09           20
491300210122     C                   PARM                    P@VL09          200
491400210122     C                   PARM                    P@OP10           20
491500210122     C                   PARM                    P@VL10          200
491600210122      *                                                                                     MD035545
491700210122      ** If system value is not found then default value to 'N'                             MD035545
491800210122      *                                                                                     MD035545
491900210122     C     W0RTCD        IFNE      '       '
492000210122     C                   MOVE      'N'           WCALC6
492100210122     C                   ELSE
492200210122     C                   MOVEL     P@VL01        WCALC6
492300210122     C********** WCALC6    IFEQ 'Y'                                                MD035545 MD047993
492400210122     C********** BKALDI    ANDEQ'Y'                                                MD035545 MD047993
492500210122     C**********           MOVE 'Y'       WCALC6                                   MD035545 MD047993
492600210122     C**********           ELSE                                                    MD035545 MD047993
492700210122     C**********           MOVE 'N'       WCALC6                                   MD035545 MD047993
492800210122     C**********           ENDIF                                                   MD035545 MD047993
492900210122     C                   ENDIF
493000210122     C     EXINIT        TAG
493100210122     C*
493200210122     C**  Unwind subroutine stack name.
493300210122     C*
493400210122     C                   MOVEA     *BLANKS       @STK(Q)
493500210122     C                   SUB       1             Q
493600210122     C*
493700210122     C     SRINI9        ENDSR                                                  ** SRINI9 **
493800210122     C*
493900210122     C*****************************************************************
494000210122     C/EJECT
494100210122     C*****************************************************************
494200210122     C*                                                               *
494300210122     C*  Subroutine  :  SRADTA                                        *
494400210122     C*  Function    :  Accumulate RDEs and Associated Data           *
494500210122     C*                                                               *
494600210122     C*  Called by   :  LOAN   - Process Loan Details                 *
494700210122     C*                 L@ROL  - Process Rollover Details             *
494800210122     C*                 L@REP  - Process Repayment Details            *
494900210122     C*                 L@IPY  - Process Interest Payment Details     *
495000210122     C*                 L@GUAR - Process Guarantee Details            *
495100210122     C*  Calls       :  CG3999 - Pack/Unpack Extracted Data           *
495200210122     C*                 SRRFMN - Reformat RDE Data                    *
495300210122     C*                                                               *
495400210122     C*****************************************************************
495500210122     C*
495600210122     C     SRADTA        BEGSR                                                  ** SRADTA **
495700210122     C*
495800210122     C**  Set up subroutine stack name.
495900210122     C*
496000210122     C                   ADD       1             Q
496100210122     C                   MOVEL     'SRADTA'      @STK(Q)
496200210122     C*
496300210122     C**  Reformat RDE data.
496400210122     C*
496500210122     C                   EXSR      SRRFMN
496600210122     C*
496700210122     C**  Pack RDEs and associated data into data string.
496800210122     C*
496900210122     C                   CLEAR                   ##SDS
497000210122      *                                                                                       CCG015
497100210122      ** If CCG015 is installed, value of W0ACT is '*NEWARR'                                  CCG015
497200210122      *                                                                                       CCG015
497300210122     C     CCG015        IFEQ      'Y'
497400210122     C                   MOVEL     '*NEWARR '    W0ACT
497500210122     C                   MOVEL     S#PATH        W0SPAT
497600210122     C                   ELSE
497700210122     C                   MOVEL     '*PACK   '    W0ACT
497800210122     C                   MOVEL     *BLANK        W0SPAT
497900210122     C                   ENDIF
498000210122      *                                                                                       CCG015
498100210122     C                   CALL      'CG3999'
498200210122     C                   PARM      *BLANK        ##RTCD
498300210122     C**********           PARM '*PACK   'W0ACT                                               CCG015
498400210122     C                   PARM                    W0ACT
498500210122     C                   PARM                    ##R
498600210122     C                   PARM                    ##D
498700210122     C                   PARM                    ##S
498800210122     C                   PARM                    W0SPAT           70
498900210122     C                   PARM                    ##RN
499000210122     C                   PARM                    ##DN
499100210122     C                   PARM                    ##FM
499200210122     C*
499300210122     C     ##RTCD        IFNE      *BLANK
499400210122     C                   MOVEL     'CG3999  '    W0FILE                         ************
499500210122     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 10 *
499600210122     C                   Z-ADD     10            W0ERNB                         ************
499700210122     C                   MOVEL     'MEM5003'     W0MSGD
499800210122     C                   MOVEL     'MIDAS  '     W0MSGF
499900210122     C                   EXSR      SRERR
500000210122     C                   ENDIF
500100210122     C                   EXSR      WRTRDE
500200210122     C*
500300210122     C**  Append Data from pack routine.
500400210122     C*
500500210122     C     #@SDS         CAT       ##SDS:0       #@SDS
500600210122     C                   MOVEL     *BLANK        ##R
500700210122     C                   MOVEL     *BLANK        ##D
500800210122     C                   MOVEL     *BLANK        ##S
500900210122     C*
501000210122     C     EXADTA        TAG
501100210122     C*
501200210122     C**  Unwind subroutine stack name.
501300210122     C*
501400210122     C                   MOVEA     *BLANKS       @STK(Q)
501500210122     C                   SUB       1             Q
501600210122     C*
501700210122     C     SRADT9        ENDSR                                                  ** SRADT9 **
501800210122     C*
501900210122     C*****************************************************************
502000210122     C/EJECT
502100210122     C*****************************************************************
502200210122     C*                                                               *
502300210122     C*  Subroutine  :  SRODTA                                        *
502400210122     C*  Function    :  Output Accumulated Data to CGUDTAPD           *
502500210122     C*                                                               *
502600210122     C*  Called by   :  LOAN   - Process Loan Details                 *
502700210122     C*                 L@ROL  - Process Rollover Details             *
502800210122     C*                 L@REP  - Process Repayment Details            *
502900210122     C*                 L@IPY  - Process Interest Payment Details     *
503000210122     C*                 L@GUAR - Process Guarantee Details            *
503100210122     C*  Calls       :  CG9020 - Write Data to UDC Extract Files      *
503200210122     C*                                                               *
503300210122     C*****************************************************************
503400210122     C*
503500210122     C     SRODTA        BEGSR                                                  ** SRODTA **
503600210122     C*
503700210122     C**  Set up subroutine stack name.
503800210122     C*
503900210122     C                   ADD       1             Q
504000210122     C                   MOVEL     'SRODTA'      @STK(Q)
504100210122     C*
504200210122     C**  Initialise Write Format Parameter.
504300210122     C*
504400210122     C                   CLEAR                   W0FMT
504500210122     C*
504600210122     C**  Set up Control Information.
504700210122     C*
504800210122     C                   Z-ADD     ##ITEM        DEITEM
504900210122     C                   ADD       1             ##OSEQ
505000210122     C                   Z-ADD     ##OSEQ        DEOSEQ
505100210122     C                   Z-ADD     ##PBIN        DEPBIN
505200210122     C                   Z-ADD     ##TBIN        DETBIN
505300210122     C                   MOVE      'FR'          DEFSLI
505400210122     C/COPY WNCPYSRC,CG6005C008
505500210122     C                   MOVE      *BLANKS       W0PATH
505600210122     C/COPY WNCPYSRC,CG6005C009
505700210122     C                   MOVEL     S#PATH        W0PATH
505800210122     C*
505900210122     C**  Append Data from pack routine.
506000210122     C*
506100210122     C     W0FMT         CAT       #@SDS:0       W0FMT
506200210122     C*
506300210122     C**  Output PF/CGUDTAPD Record.
506400210122     C*
506500210122     C     CCG015        IFEQ      'N'
506600210122     C                   CALL      'CG9020'
506700210122     C                   PARM      *BLANK        ##RTCD
506800210122     C                   PARM      '*WRITE  '    W0ACT
506900210122     C                   PARM                    W0PATH          256
507000210122     C                   PARM                    W0FMT
507100210122     C                   PARM      *BLANK        W0TITL            7
507200210122     C                   PARM      *BLANK        W0ULIN            7
507300210122     C                   PARM                    W0CMT
507400210122     C*
507500210122     C     ##RTCD        IFNE      *BLANK
507600210122     C                   MOVEL     'CG9020  '    W0FILE                         ************
507700210122     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 11 *
507800210122     C                   Z-ADD     11            W0ERNB                         ************
507900210122     C                   MOVEL     'MEM5003'     W0MSGD
508000210122     C                   MOVEL     'MIDAS  '     W0MSGF
508100210122     C                   EXSR      SRERR
508200210122     C                   ENDIF
508300210122     C                   ENDIF
508400210122     C*
508500210122     C                   CLEAR                   #@SDS
508600210122     C*
508700210122     C     EXODTA        TAG
508800210122     C*
508900210122     C**  Unwind subroutine stack name.
509000210122     C*
509100210122     C                   MOVEA     *BLANKS       @STK(Q)
509200210122     C                   SUB       1             Q
509300210122     C*
509400210122     C     SRODT9        ENDSR                                                  ** SRODT9 **
509500210122     C*
509600210122     C*****************************************************************
509700210122     C/EJECT
509800210122     C*****************************************************************
509900210122     C*                                                               *
510000210122     C*  Subroutine  :  SRBIND                                        *
510100210122     C*  Function    :  Generate Binding Numbers                      *
510200210122     C*                                                               *
510300210122     C*  Called by   :  All Repeating Group Set Subroutines           *
510400210122     C*  Calls       :  None                                          *
510500210122     C*                                                               *
510600210122     C*****************************************************************
510700210122     C*
510800210122     C     SRBIND        BEGSR                                                  ** SRBIND **
510900210122     C*
511000210122     C**  Set up subroutine stack name.
511100210122     C*
511200210122     C                   ADD       1             Q
511300210122     C                   MOVEL     'SRBIND'      @STK(Q)
511400210122     C*
511500210122     C     P1            SUB       1             P2
511600210122     C*
511700210122     C     P2            OCCUR     ##BIND
511800210122     C                   Z-ADD     ##TBIN        #@TBIN
511900210122     C*
512000210122     C     P1            OCCUR     ##BIND
512100210122     C                   Z-ADD     #@TBIN        ##PBIN
512200210122     C                   ADD       1             #@BIND
512300210122     C                   Z-ADD     #@BIND        ##TBIN
512400210122     C*
512500210122     C**  Unwind subroutine stack name.
512600210122     C*
512700210122     C                   MOVEA     *BLANKS       @STK(Q)
512800210122     C                   SUB       1             Q
512900210122     C*
513000210122     C     SRBIN9        ENDSR                                                  ** SRBIN9 **
513100210122     C*
513200210122     C*****************************************************************
513300210122     C/EJECT
513400210122     C*****************************************************************
513500210122     C*                                                               *
513600210122     C*  Subroutine  :  SRPATH                                        *
513700210122     C*  Function    :  Generate Path String                          *
513800210122     C*                                                               *
513900210122     C*  Called by   :  L01CC  - Lending Commencement Confirmations   *
514000210122     C*                 LOAN   - Process Loan Details                 *
514100210122     C*                 L@ROL  - Process Rollover Details             *
514200210122     C*                 L@REP  - Process Repayment Details            *
514300210122     C*                 L@IPY  - Process Interest Payment Details     *
514400210122     C*                 L@GUAR - Process Guarantee Details            *
514500210122     C*                 LOANA  - Loan Associated Details              *
514600210122     C*  Calls       :  None                                          *
514700210122     C*                                                               *
514800210122     C*****************************************************************
514900210122     C*
515000210122     C     SRPATH        BEGSR                                                  ** SRPATH **
515100210122     C*
515200210122     C**  Set up subroutine stack name.
515300210122     C*
515400210122     C                   ADD       1             Q
515500210122     C                   MOVEL     'SRPATH'      @STK(Q)
515600210122     C*
515700210122     C                   CLEAR                   S#PATH
515800210122     C*
515900210122     C**  Set up Path.
516000210122     C*
516100210122     C                   DO        P1            P2
516200210122     C     P2            OCCUR     ##PATH
516300210122     C     S#PATH        CAT       '\':0         S#PATH
516400210122     C     S#PATH        CAT       ##GRPS:0      S#PATH
516500210122     C                   END
516600210122     C*
516700210122     C**  Unwind subroutine stack name.
516800210122     C*
516900210122     C                   MOVEA     *BLANKS       @STK(Q)
517000210122     C                   SUB       1             Q
517100210122     C*
517200210122     C     SRPAT9        ENDSR                                                  ** SRPAT9 **
517300210122     C*
517400210122     C*****************************************************************
517500210122     C/EJECT
517600210122     C*****************************************************************
517700210122     C*                                                               *
517800210122     C*  Subroutine  :  SRRFMN                                        *
517900210122     C*  Function    :  Reformat RDE Data                             *
518000210122     C*                                                               *
518100210122     C*  Called by   :  SRADTA - Accumulate RDEs and Associated Data  *
518200210122     C*  Calls       :  None                                          *
518300210122     C*                                                               *
518400210122     C*****************************************************************
518500210122     C*
518600210122     C     SRRFMN        BEGSR                                                  ** SRRFMN **
518700210122     C*
518800210122     C**  Set up subroutine stack name.
518900210122     C*
519000210122     C                   ADD       1             Q
519100210122     C                   MOVEL     'SRRFMN'      @STK(Q)
519200210122     C*
519300210122     C                   Z-ADD     0             #1
519400210122     C*
519500210122     C**  Loop through RDE's and data.
519600210122     C*
519700210122     C     #1            DOUEQ     20
519800210122     C*
519900210122     C                   ADD       1             #1
520000210122     C                   MOVEL     ##R(#1)       R#DEFN
520100210122     C                   MOVEL     ##D(#1)       R#DATA
520200210122     C*
520300210122     C**  If data present and RDE is edited.
520400210122     C*
520500210122     C     R#DATA        IFNE      *BLANK
520600210122     C     ##RDEC        ANDNE     *BLANK
520700210122     C*
520800210122     C**  Reformat Amount.
520900210122     C*
521000210122     C                   Z-ADD     1             #2
521100210122     C     *BLANK        LOOKUP    ##NUMA(#2)                             99    *
521200210122     C                   Z-ADD     20            #3
521300210122     C                   Z-ADD     0             ##WNUM
521400210122     C*
521500210122     C     #2            DOWGT     1
521600210122     C     #2            ANDLE     20
521700210122     C     #3            ANDGT     1
521800210122     C                   SUB       1             #2
521900210122     C                   MOVEL     ##NUMA(#2)    ##W(#3)
522000210122     C                   SUB       1             #3
522100210122     C                   ENDDO
522200210122     C*
522300210122     C**  Sign the amount.
522400210122     C*
522500210122     C     ##SIGN        IFEQ      '-'
522600210122     C                   Z-SUB     ##WNUM        ##NUMB
522700210122     C                   ELSE
522800210122     C                   Z-ADD     ##WNUM        ##NUMB
522900210122     C                   END
523000210122     C*
523100210122     C**  Default Edit Type.
523200210122     C*
523300210122     C     ##EDTT        IFEQ      *BLANK
523400210122     C                   MOVEL     ##RDET        ##EDTT
523500210122     C                   END
523600210122     C*
523700210122     C**  Default Decimal Places.
523800210122     C*
523900210122     C     ##DCPA        IFEQ      *BLANK
524000210122     C                   MOVEL     ##RDED        ##DCPA
524100210122     C                   END
524200210122     C*
524300210122     C**  New RDE data.
524400210122     C*
524500210122     C                   MOVEL     R#DATA        ##D(#1)
524600210122     C*
524700210122     C                   ENDIF
524800210122     C*
524900210122     C                   ENDDO
525000210122     C*
525100210122     C     EXRFMN        TAG
525200210122     C*
525300210122     C**  Unwind subroutine stack name.
525400210122     C*
525500210122     C                   MOVEA     *BLANKS       @STK(Q)
525600210122     C                   SUB       1             Q
525700210122     C*
525800210122     C     SRRFM9        ENDSR                                                  ** SRRFM9 **
525900210122     C*
526000210122     C*****************************************************************
526100210122     C/EJECT
526200210122     C*****************************************************************
526300210122     C*                                                               *
526400210122     C*  Subroutine  :  SRDCDT                                        *
526500210122     C*  Function    :  Determine Currency Details                    *
526600210122     C*                                                               *
526700210122     C*  Called by   :  LOAN   - Process Loan Details                 *
526800210122     C*                 L@REP  - Process Repayment Details            *
526900210122     C*                 SRINIT - Initial Processing - On First Call   *
527000210122     C*  Calls       :  AOCURRRO - Retrive Currency Details           *
527100210122     C*                                                               *
527200210122     C*****************************************************************
527300210122     C*
527400210122     C     SRDCDT        BEGSR                                                  ** SRDCDT **
527500210122     C*
527600210122     C**  Set up subroutine stack name.
527700210122     C*
527800210122     C                   ADD       1             Q
527900210122     C                   MOVEL     'SRDCDT'      @STK(Q)
528000210122     C*
528100210122     C**  Access array of Currency Details already loaded.
528200210122     C*
528300210122     C                   Z-ADD     1             C                 3 0
528400210122     C     ##CCY         LOOKUP    ##CY(C)                                99
528500210122     C*
528600210122     C**  If no match is found determine the next free space in the
528700210122     C**  loaded currency array.
528800210122     C*
528900210122     C     *IN99         IFEQ      *OFF
529000210122     C*
529100210122     C                   Z-ADD     1             C
529200210122     C     *BLANK        LOOKUP    ##CY(C)                                99
529300210122     C*
529400210122     C**  If no space is left, set the Currency Data data structure to
529500210122     C**  the 101st occurrence so that when the new details are
529600210122     C**  retrieved no existing details are overwritten.
529700210122     C*
529800210122     C     *IN99         IFEQ      *OFF
529900210122     C     101           OCCUR     SDCURR
530000210122     C*
530100210122     C**  If a space is found, set up the new currency into the array
530200210122     C**  and position the Currency Data data structure on the
530300210122     C**  occurrence matching the array index.
530400210122     C*
530500210122     C                   ELSE
530600210122     C                   MOVE      ##CCY         ##CY(C)
530700210122     C     C             OCCUR     SDCURR
530800210122     C                   ENDIF
530900210122     C*
531000210122     C**  Retrieve the currency details.
531100210122     C*
531200210122     C                   CALL      'AOCURRR0'
531300210122     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
531400210122     C                   PARM      '*KEY'        ##OPTN                         I:Option
531500210122     C                   PARM      ##CCY         ##CCYP            3            I:Currency Code
531600210122     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format
531700210122     C*
531800210122     C     ##RTCD        IFNE      *BLANK
531900210122     C                   MOVEL     'SDCURRPD'    W0FILE
532000210122     C                   MOVEL     ##CCY         W0KEY                          ************
532100210122     C                   Z-ADD     12            W0ERNB                         * DBERR 12 *
532200210122     C                   MOVEL     'MEM5004'     W0MSGD                         ************
532300210122     C                   MOVEL     'MIDAS  '     W0MSGF
532400210122     C                   EXSR      SRERR
532500210122     C                   ENDIF
532600210122     C*
532700210122     C**  If the currency has been retrieved earlier, position the
532800210122     C**  Currency Data data structure on the relevant occurrence.
532900210122     C*
533000210122     C                   ELSE
533100210122     C     C             OCCUR     SDCURR
533200210122     C                   ENDIF
533300210122     C/COPY WNCPYSRC,CG6005C004
533400210122     C*
533500210122     C     EXDCDT        TAG
533600210122     C*
533700210122     C**  Unwind subroutine stack name.
533800210122     C*
533900210122     C                   MOVEA     *BLANKS       @STK(Q)
534000210122     C                   SUB       1             Q
534100210122     C*
534200210122     C     SRDCD9        ENDSR                                                  ** SRDCD9 **
534300210122     C*
534400210122     C*****************************************************************
534500210122     C/EJECT
534600210122     C*****************************************************************
534700210122     C*                                                               *
534800210122     C*  Subroutine  :  SRICAL                                        *
534900210122     C*  Function    :  Calculate Interest                            *
535000210122     C*                                                               *
535100210122     C*  Called by   :  LOAN   - Process Loan Details                 *
535200210122     C*  Calls       :  ZFLAC  - Calculate End Date                   *
535300210122     C*                 GLINTC - Calculate Interest Between any 2     *
535400210122     C*                          day numbers                          *
535500210122     C*                                                               *
535600210122     C*****************************************************************
535700210122     C*
535800210122     C     SRICAL        BEGSR                                                  ** SRICAL **
535900210122     C*
536000210122     C**  Set up subroutine stack name.
536100210122     C*
536200210122     C                   ADD       1             Q
536300210122     C                   MOVEL     'SRICAL'      @STK(Q)
536400210122      *                                                                                       CLE028
536500210122      ** If Flat Rate Personal Loans (Rule of 78s) is installed,                              CLE028
536600210122      ** Gross Interest of flat rate personal loans is computed as per                        CLE028
536700210122      ** the Rule of 78s.  GROSS INTEREST is equal to Total Flat Interest                     CLE028
536800210122      *                                                                                       CLE028
536900210122     C     CLE028        IFEQ      'Y'
537000210122     C     ##PTYP        ANDEQ     80
537100210122      *                                                                                       CLE028
537200210122     C                   Z-ADD     ##FLTI        ZINTR
537300210122      *                                                                                       CLE028
537400210122     C                   ELSE
537500210122      *                                                                                       CLE028
537600210122     C*
537700210122     C                   Z-ADD     ##VDAT        ZIBEG
537800210122     C                   Z-ADD     ##ICBS        ZICALC
537900210122     C                   Z-ADD     ##CPAM        ZIAMT
538000210122     C                   Z-ADD     ##INTR        ZIRATE
538100210122     C**********           Z-ADD##VDAT    ZVDAT                                               245082
538200210122     C                   Z-ADD     ##MDAT        ZMDAT
538300210122     C                   Z-ADD     0             ZIEND
538400210122     C*
538500210122     C     ##REPT        IFNE      1
538600210122     C     ##REPT        ANDNE     3
538700210122      *                                                                                       245914
538800210122     C**  If repayment schedule exists for the loan, use the repayment
538900210122     C**  value date.
539000210122     C*
539100210122     C     ##RPDT        IFGT      0
539200210122     C                   Z-ADD     ##RPDT        ZIEND
539300210122     C                   Z-ADD     0             ##RPDT
539400210122     C**********           ELSE                                                               245914
539500210122     C                   END
539600210122     C*
539700210122     C**  else, if repayment date is not zero, use repayment date.                            245914
539800210122     C*                                                                                       245914
539900210122     C     ##NRPD        IFGT      0
540000210122     C     ##NRPD        IFLT      ZIEND
540100210122     C     ZIEND         OREQ      0
540200210122     C                   Z-ADD     ##NRPD        ZIEND
540300210122     C                   END
540400210122     C                   END
540500210122     C*                                                                                       245914
540600210122     C**  else, if rollover date is not zero, use rollover date.
540700210122     C*
540800210122     C     ##RLDT        IFGT      0
540900210122     C     ##RLDT        IFLT      ZIEND
541000210122     C     ZIEND         OREQ      0
541100210122     C                   Z-ADD     ##RLDT        ZIEND
541200210122     C**********           ELSE                                                               245914
541300210122     C                   END
541400210122     C                   END
541500210122     C*
541600210122     C**  else,if interest pay date is not zero, use interest pay date.
541700210122     C*
541800210122     C     ##NIDT        IFGT      0
541900210122     C                   Z-ADD     ##NIDT        ZIEND
542000210122     C**********           ELSE                                                               245914
542100210122     C                   END
542200210122     C*
542300210122     C**  else, use maturity date.
542400210122     C*
542500210122     C     ZIEND         IFEQ      0
542600210122     C                   Z-ADD     ##MDAT        ZIEND
542700210122     C                   END
542800210122     C**********           END                                                                245914
542900210122     C**********           END                                                                245914
543000210122     C*                                                                                       245914
543100210122     C                   ELSE
543200210122     C*                                                                                       245914
543300210122     C** If repayment type 1 or 3                                                             245914
543400210122     C*                                                                                       245914
543500210122     C**  If repayment schedule exists for the loan, use the repayment                        245914
543600210122     C**  value date.                                                                         245914
543700210122     C*                                                                                       245914
543800210122     C     ##RPDT        IFGT      0
543900210122     C                   Z-ADD     ##RPDT        ZIEND
544000210122     C                   Z-ADD     0             ##RPDT
544100210122     C                   END
544200210122     C*                                                                                       245914
544300210122     C**  else, if repayment date is not zero, use repayment date.                            245914
544400210122     C*                                                                                       245914
544500210122     C     ##NRPD        IFGT      0
544600210122     C     ##NRPD        IFLT      ZIEND
544700210122     C     ZIEND         OREQ      0
544800210122     C                   Z-ADD     ##NRPD        ZIEND
544900210122     C                   END
545000210122     C                   END
545100210122     C*                                                                                       245914
545200210122     C**  else, if rollover date is not zero, use rollover date.                              245914
545300210122     C*                                                                                       245914
545400210122     C     ##RLDT        IFGT      0
545500210122     C     ##RLDT        IFLT      ZIEND
545600210122     C     ZIEND         OREQ      0
545700210122     C                   Z-ADD     ##RLDT        ZIEND
545800210122     C                   END
545900210122     C                   END
546000210122     C*                                                                                       245914
546100210122     C**  else,if interest pay date is not zero, use interest pay date.                       245914
546200210122     C*                                                                                       245914
546300210122     C     ##NIDT        IFGT      0
546400210122     C                   Z-ADD     ##NIDT        ZIEND
546500210122     C                   END
546600210122     C*                                                                                       245914
546700210122     C**  else, use maturity date.                                                            245914
546800210122     C*                                                                                       245914
546900210122     C     ZIEND         IFEQ      0
547000210122     C                   Z-ADD     ##MDAT        ZIEND
547100210122     C                   END
547200210122     C                   ENDIF
547300210122     C*
547400210122     C                   MOVE      ##ADDI        ADDI              1
547500210122      *                                                                                       245914
547600210122     C     ZIEND         IFNE      0
547700210122      *                                                                                       245914
547800210122     C                   EXSR      ZFLAC
547900210122     C/COPY WNCPYSRC,CG6005C010
548000210122     C                   EXSR      GLINTC
548100210122     C/COPY WNCPYSRC,CG6005C011
548200210122     C                   ELSE
548300210122     C                   Z-ADD     0             ZINTR
548400210122     C                   ENDIF
548500210122     C                   ENDIF
548600210122     C*
548700210122     C** Round down interest if required
548800210122     C*
548900210122     C     ##RDFC        IFEQ      'Y'
549000210122     C     ##PTYP        ANDNE     80
549100210122     C                   Z-ADD     ZINTR         ##TINT           13 0
549200210122     C                   ELSE
549300210122     C                   Z-ADD(H)  ZINTR         ##TINT
549400210122     C                   END
549500210122     C/COPY WNCPYSRC,CGH00027
549600210122     C*
549700210122     C**  Unwind subroutine stack name.
549800210122     C*
549900210122     C                   MOVEA     *BLANKS       @STK(Q)
550000210122     C                   SUB       1             Q
550100210122     C*
550200210122     C     SRICA9        ENDSR                                                  ** SRICA9 **
550300210122     C*
550400210122     C*****************************************************************
550500210122     C/SPACE 5                                                            CEU014
550600210122      *****************************************************************   CEU014
550700210122      * Subroutine  :  D@EURO                                         *   CEU014
550800210122      * Function    :  EURO Currency Conversion:                      *   CEU014
550900210122      *                Converts P@FRAM in P@FRCY to ##OUTA in P@TOCY. *   CEU014
551000210122      * Called by   :  LOAN                                           *   CEU014
551100210122      *                                                               *   CEU014
551200210122      * Calls       :  EU0200                                         *   CEU014
551300210122      *                SRERR                                          *   CEU014
551400210122      *****************************************************************   CEU014
551500210122     C     D@EURO        BEGSR                                                                 CEU01
551600210122      *                                                                   CEU014
551700210122     C                   Z-ADD     0             ##OUTA           13 0                         CEU01
551800210122     C                   CALL      'EU0200'                                                    CEU01
551900210122     C                   PARM      *BLANKS       P@RTCD            7            Return Code    CEU01
552000210122     C                   PARM                    P@FRAM           18 3          FROM Ccy AmountCEU01
552100210122     C                   PARM                    P@FRCY            3            FROM Currency  CEU01
552200210122     C                   PARM                    P@TOCY            3            TO Currency    CEU01
552300210122     C                   PARM      0             P@OUTA           15 0          Outright AmountCEU01
552400210122     C                   PARM      0             P@INTA           18 3          Interim Amount CEU01
552500210122     C                   PARM      0             P@EXRT           15 9          Exchange Rate  CEU01
552600210122     C                   PARM      *BLANK        P@MDIN            1            Mult/Div Ind.  CEU01
552700210122      *                                                                   CEU014
552800210122      ** Database error handling:                                         CEU014
552900210122      *                                                                   CEU014
553000210122     C     P@RTCD        IFEQ      '*ERROR*'                                                   CEU01
553100210122     C                   MOVEL     'EU0200  '    W0FILE                                        CEU01
553200210122     C                   MOVEL     '*CALL   '    W0KEY                          ***************CEU01
553300210122     C                   Z-ADD     17            W0ERNB                         * DB ERROR 17 *CEU01
553400210122     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
553500210122     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
553600210122     C                   EXSR      SRERR                                                       CEU01
553700210122      *                                                                   CEU014
553800210122      ** Otherwise, store amount in settlement currency as ##OUTA         CEU014
553900210122      *                                                                   CEU014
554000210122     C                   ELSE                                                                  CEU01
554100210122     C                   MOVE      P@OUTA        ##OUTA                                        CEU01
554200210122     C                   ENDIF                                                                 CEU01
554300210122      *                                                                   CEU014
554400210122     C                   ENDSR                                                                 CEU01
554500210122      *****************************************************************   CEU014
554600210122     C/EJECT
554700210122      *****************************************************************                       CER038
554800210122      *  Subroutine  -  SRAUTO                                        *                       CER038
554900210122      *  Function    -  Auto transmission processing                  *                       CER038
555000210122      *                                                               *                       CER038
555100210122      *  Called by   -                                                *                       CER038
555200210122      *  Calls       -                                                *                       CER038
555300210122      *****************************************************************                       CER038
555400210122     C     SRAUTO        BEGSR
555500210122      *                                                                                       CER038
555600210122      ** Set up subroutine stack name                                                         CER038
555700210122      *                                                                                       CER038
555800210122     C                   ADD       1             Q
555900210122     C                   MOVEL     'SRAUTO'      @STK(Q)
556000210122      *                                                                                       CER038
556100210122      ** Get Branch Details                                                                   CER038
556200210122      *                                                                                       CER038
556300210122     C     BRCA          IFNE      ##BRCD
556400210122     C                   CALL      'AOBRCHR0'
556500210122     C                   PARM      '*MSG    '    ##RTCD
556600210122     C                   PARM      '*KEY    '    ##OPTN
556700210122     C                   PARM      BRCA          ##BRCD            3
556800210122     C     SDBRCH        PARM      SDBRCH        DSFDY
556900210122      *                                                                                       CER038
557000210122      ** Database error                                                                       CER038
557100210122      *                                                                                       CER038
557200210122     C     ##RTCD        IFNE      *BLANKS
557300210122     C                   MOVEL     'SDBRCHPD'    W0FILE
557400210122     C                   MOVEL     BRCA          W0KEY                          ***************
557500210122     C                   Z-ADD     27            W0ERNB                         * DB ERROR 27 *
557600210122     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
557700210122     C                   MOVEL     'MIDAS  '     W0MSGF
557800210122     C                   EXSR      SRERR
557900210122     C                   END
558000210122     C                   END
558100210122      *                                                                                       CER038
558200210122      ** Get Customer Details for Loan customer number                                        CER038
558300210122      ** Get Customer Details for Branch Internal Customer (Sender)                           CER038
558400210122      *                                                                                       CER038
558500210122     C                   CALL      'AOCUSTR0'
558600210122     C                   PARM      *BLANKS       ##RTCD
558700210122     C                   PARM      '*KEY   '     ##OPTN
558800210122     C                   PARM      A8BICN        ##KEY1           10
558900210122     C                   PARM      *BLANKS       ##KYST            7
559000210122     C     SDCUST        PARM      SDCUST        DSSDY
559100210122      *                                                                                       CER038
559200210122      ** Database error                                                                       CER038
559300210122      *                                                                                       CER038
559400210122     C     ##RTCD        IFNE      *BLANKS
559500210122     C                   MOVEL     'SDCUSTPD'    W0FILE
559600210122     C                   MOVEL     A8BICN        W0KEY                          ***************
559700210122     C                   Z-ADD     28            W0ERNB                          DB ERROR 28 *
559800210122     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
559900210122     C                   MOVEL     'MIDAS  '     W0MSGF
560000210122     C                   EXSR      SRERR
560100210122     C                   END
560200210122      *                                                                                       CER038
560300210122      ** Store Booking Branch, Branch Internal Customer Number and Name                       CER038
560400210122      *                                                                                       CER038
560500210122     C     *LIKE         DEFINE    BRCA          BBBRCA
560600210122     C                   MOVEL     BRCA          BBBRCA
560700210122     C     *LIKE         DEFINE    BBCUST        BBBICN
560800210122     C                   MOVEL     BBCUST        BBBICN
560900210122     C     *LIKE         DEFINE    BBCRNM        BICRNM
561000210122     C                   MOVEL     BBCRNM        BICRNM
561100210122      *                                                                                       CER038
561200210122      ** Store : Sender's (i.e. Branch)                                                       CER038
561300210122      **             SWIFT TID Address,                                                       CER038
561400210122      **             STTX Address                                                             CER038
561500210122      **             Telex Address                                                            CER038
561600210122      ** (All used in message routing)                                                        CER038
561700210122      *                                                                                       CER038
561800210122     C                   MOVEL     A8BTID        ##SCSD
561900210122     C                   MOVEL     BBSTAD        ##SSTD
562000210122     C                   MOVEL     BBTXA1        ##STXA
562100210122      *                                                                                       CER038
562200210122      ** Get Customer Details for loan customer (Receiver)                                    CER038
562300210122      *                                                                                       CER038
562400210122     C                   MOVE      *BLANKS       ##KEY1
562500210122     C                   MOVEL     ##CNUM        ##KEY1
562600210122     C                   CALL      'AOCUSTR0'
562700210122     C                   PARM      *BLANKS       ##RTCD
562800210122     C                   PARM      '*KEY   '     ##OPTN
562900210122     C                   PARM                    ##KEY1           10
563000210122     C                   PARM      *BLANKS       ##KYST            7
563100210122     C     SDCUST        PARM      SDCUST        DSSDY
563200210122      *                                                                                       CER038
563300210122      ** Database error                                                                       CER038
563400210122      *                                                                                       CER038
563500210122     C     ##RTCD        IFNE      *BLANKS
563600210122     C                   MOVEL     'SDCUSTPD'    W0FILE
563700210122     C                   MOVEL     ##CNUM        W0KEY                          **************
563800210122     C                   Z-ADD     29            W0ERNB                         * DB ERROR 29*
563900210122     C                   MOVEL     'MEM5004'     W0MSGD                         **************
564000210122     C                   MOVEL     'MIDAS  '     W0MSGF
564100210122     C                   EXSR      SRERR
564200210122     C                   END
564300210122      *                                                                                       CER038
564400210122      ** Store Customer Name                                                                  CER038
564500210122      *                                                                                       CER038
564600210122     C     *LIKE         DEFINE    BBCRNM        CPCRNM
564700210122     C                   MOVEL     BBCRNM        CPCRNM
564800210122      *                                                                                       CER038
564900210122      ** Store : Destination Customer's (i.e. Counterparty)                                   CER038
565000210122      **             SWIFT TID Address,                                                       CER038
565100210122      **             STTX Address                                                             CER038
565200210122      **             Telex Address                                                            CER038
565300210122      **             Default Network for MTnnn messages                                       CER038
565400210122      ** (All used in message routing)                                                        CER038
565500210122      *                                                                                       CER038
565600210122     C                   MOVEL     BBCSID        ##DCSD
565700210122     C                   MOVEL     BBSTAD        ##DSTD
565800210122     C                   MOVEL     BBTXA1        ##DTXA
565900210122     C                   MOVEL     BBDNW3        ##DDNW                         *MT300 messages
566000210122      *                                                                                       CER038
566100210122      ** Determine Message Routing                                                            CER038
566200210122      *                                                                                       CER038
566300210122     C                   CALL      'CG99DTMR'                           99
566400210122     C                   PARM                    ##SCSD           12
566500210122     C                   PARM                    ##SSTD           12
566600210122     C                   PARM                    ##STXA           10
566700210122     C                   PARM                    ##DCSD           12
566800210122     C                   PARM                    ##DSTD           12
566900210122     C                   PARM                    ##DTXA           10
567000210122     C                   PARM                    ##DDNW            6
567100210122     C                   PARM      BGMSDL        ##MSDL            1
567200210122     C                   PARM      BGMTMI        ##MTMI            1
567300210122     C                   PARM      BLSWPY        ##SWPY            1 0
567400210122     C                   PARM      BLTXPY        ##TXPY            1 0
567500210122     C                   PARM      *BLANKS       ##NETW            6
567600210122     C                   PARM      *BLANKS       ##RTCD            7
567700210122      *                                                                                       CER038
567800210122     C     *IN99         IFEQ      '1'
567900210122     C     ##RTCD        ORNE      *BLANKS
568000210122      *                                                                                       CER038
568100210122      ** Database error                                                                       CER038
568200210122      *                                                                                       CER038
568300210122     C                   MOVEL     'CG99DTMR'    W0FILE                         ***************
568400210122     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 30 *
568500210122     C                   Z-ADD     30            W0ERNB                         ***************
568600210122     C                   MOVEL     'MEM5003'     W0MSGD
568700210122     C                   MOVEL     'MIDAS  '     W0MSGF
568800210122     C                   EXSR      SRERR
568900210122     C                   ENDIF
569000210122      *                                                                                       CER038
569100210122     C                   EXSR      SRDAUT
569200210122     C                   MOVEL     'N'           ##SPPS
569300210122     C                   MOVEL     ##AUTO        DRATRM
569400210122      *                                                                                       CER038
569500210122      ** if auto transmission                                                                 CER038
569600210122      *                                                                                       CER038
569700210122     C     ##AUTO        IFEQ      'Y'
569800210122     C     CER038        ANDEQ     'Y'
569900210122     C     SUPCON        ANDEQ     'Y'
570000210122      *                                                                                       CER038
570100210122      ** set suppress indicator                                                               CER038
570200210122      *                                                                                       CER038
570300210122     C                   MOVE      'Y'           ##SPPS
570400210122      *                                                                                       CER038
570500210122     C                   ENDIF
570600210122      *                                                                                       CER038
570700210122     C     EXAUTO        TAG
570800210122      *                                                                                       CER038
570900210122      ** Unwind subroutine stack name                                                         CER038
571000210122      *                                                                                       CER038
571100210122     C                   MOVEA     *BLANKS       @STK(Q)
571200210122     C                   SUB       1             Q
571300210122      *                                                                                       CER038
571400210122     C                   ENDSR
571500210122      *****************************************************************                       CER038
571600210122     C/EJECT                                                                                  CER038
571700210122      *****************************************************************                       CER038
571800210122      *  Subroutine  -  SRDAUT                                        *                       CER038
571900210122      *  Function    -  Determine if Auto-Transmission of             *                       CER038
572000210122      *                 Confirmation                                  *                       CER038
572100210122      *                                                               *                       CER038
572200210122      *  Called by   -                                                *                       CER038
572300210122      *  Calls       -                                                *                       CER038
572400210122      *****************************************************************                       CER038
572500210122     C     SRDAUT        BEGSR
572600210122      *                                                                                       CER038
572700210122      ** Set up subroutine stack name                                                         CER038
572800210122      *                                                                                       CER038
572900210122     C                   ADD       1             Q
573000210122     C                   MOVEL     'SRDAUT'      @STK(Q)
573100210122      *                                                                                       CER038
573200210122      **********                                                                     CER038 BUG23004
573300210122      ***Call*access*program*for*midas*modules*details                               CER038 BUG23004
573400210122      **********                                                                     CER038 BUG23004
573500210122     C**********           CALL 'AOMMODR0'                                           CER038 BUG23004
573600210122     C**********           PARM *BLANKS   ##RTCD                                     CER038 BUG23004
573700210122     C**********           PARM '*FIRST  '##OPTN                                     CER038 BUG23004
573800210122     C********** SDMMOD    PARM SDMMOD    DSFDY                                      CER038 BUG23004
573900210122      **********                                                                     CER038 BUG23004
574000210122     C********** ##RTCD    IFNE *BLANKS                                              CER038 BUG23004
574100210122      **********                                                                     CER038 BUG23004
574200210122      ***Database*error                                                              CER038 BUG23004
574300210122      **********                                                                     CER038 BUG23004
574400210122     C**********           MOVEL'AOMMODR0'W0FILE                                     CER038 BUG23004
574500210122     C**********           MOVEL'*CALL'   W0KEY            ************              CER038 BUG23004
574600210122     C**********           Z-ADD20        W0ERNB           * DB ERROR 2              CER038 BUG23004
574700210122     C**********           MOVEL'MEM5003' W0MSGD           ************              CER038 BUG23004
574800210122     C**********           MOVEL'MIDAS  ' W0MSGF                                     CER038 BUG23004
574900210122     C**********           EXSR SRERR                                                CER038 BUG23004
575000210122     C**********           END                                                       CER038 BUG23004
575100210122      **********                                                                     CER038 BUG23004
575200210122      ***Call*access program for message details                                     CER038 BUG23004
575300210122      **********                                                                     CER038 BUG23004
575400210122     C********** BGSWCL    IFEQ 'Y'                                                  CER038 BUG23004
575500210122     C**********           CALL 'AOMGMER0'                                           CER038 BUG23004
575600210122     C**********           PARM *BLANKS   ##RTCD                                     CER038 BUG23004
575700210122     C**********           PARM '*FIRST  '##OPTN                                     CER038 BUG23004
575800210122     C********** SDMGME    PARM SDMGME    DSFDY                                      CER038 BUG23004
575900210122      **********                                                                     CER038 BUG23004
576000210122     C********** ##RTCD    IFNE *BLANKS                                              CER038 BUG23004
576100210122      **********                                                                     CER038 BUG23004
576200210122      ***Database error                                                              CER038 BUG23004
576300210122      **********                                                                     CER038 BUG23004
576400210122     C**********           MOVEL'AOMGMER0'W0FILE                                     CER038 BUG23004
576500210122     C**********           MOVEL'*CALL'   W0KEY            ************              CER038 BUG23004
576600210122     C**********           Z-ADD24        W0ERNB           * DB ERROR 2              CER038 BUG23004
576700210122     C**********           MOVEL'MEM5003' W0MSGD           ************              CER038 BUG23004
576800210122     C**********           MOVEL'MIDAS  ' W0MSGF                                     CER038 BUG23004
576900210122     C**********           EXSR SRERR                                                CER038 BUG23004
577000210122     C**********           END                                                       CER038 BUG23004
577100210122     C**********           END                                                       CER038 BUG23004
577200210122      **********                                                                     CER038 BUG23004
577300210122      ***Call*access program for trading data details                                CER038 BUG23004
577400210122      **********                                                                     CER038 BUG23004
577500210122     C**********           CALL 'AOTRADR0'                                           CER038 BUG23004
577600210122     C**********           PARM *BLANKS   ##RTCD                                     CER038 BUG23004
577700210122     C**********           PARM '*FIRST  '##OPTN                                     CER038 BUG23004
577800210122     C********** SDTRAD    PARM SDTRAD    DSFDY                                      CER038 BUG23004
577900210122      **********                                                                     CER038 BUG23004
578000210122     C********** ##RTCD    IFNE *BLANKS                                              CER038 BUG23004
578100210122      **********                                                                     CER038 BUG23004
578200210122      ***Database error                                                              CER038 BUG23004
578300210122      **********                                                                     CER038 BUG23004
578400210122     C**********           MOVEL'AOTRADR0'W0FILE                                     CER038 BUG23004
578500210122     C**********           MOVEL'*CALL'   W0KEY            ************              CER038 BUG23004
578600210122     C**********           Z-ADD22        W0ERNB           * DB ERROR 2              CER038 BUG23004
578700210122     C**********           MOVEL'MEM5003' W0MSGD           ************              CER038 BUG23004
578800210122     C**********           MOVEL'MIDAS  ' W0MSGF                                     CER038 BUG23004
578900210122     C**********           EXSR SRERR                                                CER038 BUG23004
579000210122     C**********           END                                                       CER038 BUG23004
579100210122     C                   MOVEL     'N'           ##AUTO            1
579200210122      *                                                                                       CER038
579300210122     C     BGSWCL        IFEQ      'Y'
579400210122     C     BGMTCL        OREQ      'Y'
579500210122      *                                                                                       CER038
579600210122     C     ##NETW        IFNE      'PAPER '
579700210122     C     ##NETW        OREQ      'PAPER '
579800210122     C     ENFFCR        ANDNE     'Y'
579900210122     C                   MOVEL     'Y'           ##AUTO
580000210122     C                   END
580100210122     C                   END
580200210122      *                                                                                       CER038
580300210122      **  Unwind subroutine stack name                                                        CER038
580400210122      *                                                                                       CER038
580500210122     C                   MOVEA     *BLANKS       @STK(Q)
580600210122     C                   SUB       1             Q
580700210122      *                                                                                       CER038
580800210122     C                   ENDSR
580900210122      *                                                                                       CER038
581000210122      *****************************************************************                       CER038
581100210122     C/EJECT                                                                                  CER038
581200210122      *****************************************************************                       CER038
581300210122     C/COPY ZSRSRC,ZFLACZ2ILE
581400210122     C/EJECT
581500210122     C/COPY ZSRSRC,GLINTCZ1LE
581600210122     C/EJECT
581700210122     C/COPY ZSRSRC,ZDAT10Z2LE                                               126017
581800210122     C/EJECT                                                              126017
581900210122     C/COPY ZSRSRC,ZINTDYZ2LE
582000210122     C/EJECT
582100210122     C/COPY ZSRSRC,ZDATE9Z3LE
582200210122     C/EJECT
582300210122     C/COPY CGCPYSRC,SRERRPSSRL
582400210122     C/EJECT
582500210122     C/COPY CGCPYSRC,SRERRCLE
582600210122     C/EJECT
582700210122     C/COPY CGCPYSRC,CGNWEXILE                                                               CCG015
582800210122     C/EJECT                                                                                  CCG015
582900210122     C/COPY ZSRSRC,ZCONVZ1ILE                                                                CLE031
583000210122     C/EJECT                                                                                  CLE031
583100210122
583200210122** ##CPY  **      OBJECT COPYRIGHT
583300210122(c) Finastra International Limited 2001
583400210122** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
58350021012200366007310109601461
583600210122** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
58370021012200000000310005900090001200015100181002120024300273003040033400365
583800210122**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION                                           CLE031
5839002101220000001                                                                                       CLE031
5840002101220000010                                                                                       CLE031
5841002101220000100                                                                                       CLE031
5842002101220001000                                                                                       CLE031
5843002101220010000                                                                                       CLE031
5844002101220100000                                                                                       CLE031
5845002101221000000                                                                                       CLE031
