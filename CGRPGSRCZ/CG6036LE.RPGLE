     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Lending interest advices')                    *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6036LE - Lending Interest Advices (ILE)                    *
     F*                                                               *
     F*  Function:  This program extracts data for Interest Advices.  *
     F*                                                               *
     F*  Called By: CG6030 - Lending Advices Driver                   *
     F*                                                               *
     F*  Calls :    CG3999 - Pack/Unpack Extracted Data               *
     F*             CG6001 - General Loan Details                     *
     F*             CG9010 - Create Item Reference Records            *
     F*             CG9020 - Write Data to UDC Extract Files          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CLE174             Date 23Oct20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR822053           Date 29Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 29Aug06               *
      *                 240327             Date 16Jun06               *
      *               . CSD031             Date 10Apr06               *
      *                 CSD027A            Date 06May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9646            Date 20Dec05               *
      *                 BUG7960            Date 25Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE031             Date 03Feb03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      *                 193393             Date 28Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CLE011             Date 07Nov00               *
      *                 172049             Date 01Feb01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 156795             Date 07Jul00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 137658             Date 24Jun98               *
     F*                 CEU014             Date 22Jun98               *
     F*                 CEU003             Date 09Jan98               *
     F*                 CLE004             Date 01May97               *
     F*                 102468             Date 25Apr96               *
     F*                 CCG008 *CREATE     Date 30Oct95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*  AMENDMENT HISTORY                                            *
     F*                                                               *
      *  CLE174 - Libor Deregulation - Lending                        *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR822053 - Incorrect value of Effective Annual Interest Rate *
      *             in CGUXMLPD                                       *
      *  CER049 - Stamp Tax (Portuguese Features Upgrade)             *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  CPK025 - MidasPlus 1.3 packaging.  Fix merging clashes       *
      *           caused by 240327.                                   *
      *  240327 - UDC dump. Fix is to avoid subtype being blank.      *
      *           Applied fixes 197869 and 224773.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9646- Changes in CGPACKE causes programs not to compile   *
      *  BUG7960- Missing processing for other loan types.            *
      *           Applied fixes 197869 and 224773.                    *
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
      *  193393 - UDC advice type 'LOAN INTER' generated a subtype of *
      *           'CALL LOAN' when subtype should be 'TERM LOAN'.     *
      *           Condition the subtype to be dependent on the        *
      *           processing type (PTYP).                             *
      *  CSD006 - Recompiled over changed SDCURRPD.                   *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
     F*  172049 - Correct binds for carried forward data              *
     F*           Carried forward details have binds of repeating     *
     F*           data.                                               *
     F*  156795 - Erroneous Interest and Principal Amounts due. Add   *
     F*           conditions on update of ##PRAM and ##INTA.          *
     F*  137658 - Extract Settl. ccy from CUTX1HP rather than CLOANCL *
     F*  CEU014 - EMU User Defined Correspondence Changes             *
     F*  CEU003 - EMU DL/LE Settlement Currency Conversion            *
     F*           Added new RDEs to group set LOANIS (l05IN).         *
     F*  CLE004 - Syndications & Authorisations                       *
     F*  102468 - UDC Lending alpha site fix.  Protect the key fields *
     F*           to the logical files used by the calling program,   *
     F*           so that update is still possible.  Note that LNRF   *
     F*           (loan reference) is NOT protected in this way, as   *
     F*           it is used (though not changed) by this program to  *
     F*           access CLOAN.                                       *
     F*  CCG008 - User Defined Correspondence - Lending               *
     F*                                                               *
     F*****************************************************************
     F*
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F                                     INFSR(SRFILE)
     F*
     FLECUTXL0  UF   E           K DISK    INFSR(SRFILE)
     F                                     COMMIT
     F*
      *                                                                                       CER049
      ** Stamp Tax file                                                                       CER049
      *                                                                                       CER049
     FCLONCLL1  IF   E           K DISK
      *                                                                                       CER049
     FLEAPRHI0  IF   E           K DISK
      *                                                                                       CER050
     F/COPY WNCPYSRC,CG6036F001
      /TITLE FUNCTION OF INDICATORS
     F*****************************************************************
     F*                                                               *
     F*  F U N  C T I O N    O F    I N D I C A T O R S               *
     F*                                                               *
     F*  30   -    A record has been selected for extract.            *
     F*  40   -    At least one movement passes the selection         *
     F*            criteria.                                          *
     F*  50   -    EOF for LECUTXL0 - SRTEST                          *
     F*  51   -    EOF for LECUTXL0 - LOANID                          *
     F*  90   -    Poffered for READE LOOPS                           *
     F*  99   -    General error indicator                            *
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
     F*  L05IN   -  Lending Interest Advices                          *
     F*  LOANA   -  Loan Associated Details                           *
     F*  LOANIS  -  Process Loan Interest Summary                     *
     F*  LOANID  -  Process Loan Interest Details                     *
     F*  LOANER  -  Process Loan Events                               *
     F*  LOANEV  -  Process Loan Event Details                        *
     F*  LOANCF  -  Porcess Loan C/F Details                          *
     F*  LOANBF  -  Process Loan B/F Details                          *
     F*  SRSMOV  -  Set-up Movement Details                           *
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
     F*  AOBANKR0 - Retrive Bank Details                              *
     F*  AOCURRRO - Retrive Currency Details                          *
     F*                                                               *
     F*****************************************************************
     D/EJECT
     D*
     D**  Copyright array.
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
     D*
     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
     D*
     D CPYR            DS
     D**  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D*
     D ##SDS           DS
     D**  Look-up string for RDE definition Array
     D**********                              15120 ##S                                      BUG9646
     D #@SDS           DS
     D**  Packed data string.
     D  #@S                 5120   5120
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
     D**********                              4   90##CNUM                                    CSD027
     D  ##CNUM                 4      9
     D* Branch
     D  ##BRCA                10     12
     D* Loan Processing Type
     D  ##PTYP                13     14  0
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
     D**********                              9  20 P0RONS                                    CGL029
     D  QQRONS                 9     20
     D**  Receipt - Intermediary Bank
     D  P0RIBN                21     28
     D**  Receipt - Intermediary Bank a/c
     D  P0RIBA                29     63
     D**  Receipt - Ordering Bank No.
     D**********                             64  690P0ROBN                                    CSD027
     D  P0ROBN                64     69
     D**  Receipt - Ordering Customer
     D**********                             70  750P0ROCN                                    CSD027
     D  P0ROCN                70     75
     D**  Pay - Settlement Method
     D  P0PSTM                76     77  0
     D**  Pay - Our Nostro
     D**********                             78  89 P0PONS                                    CGL029
     D  QQPONS                78     89
     D**  Pay - Intermediary Bank
     D  P0PIBN                90     97
     D**  Pay - Intermediary Bank a/c
     D  P0PIBA                98    132
     D**  Pay - Ordering Bank No.
     D**********                            133 1380P0POBN                                    CSD027
     D  P0POBN               133    138
     D**  Pay - Ordering Customer No.
     D**********                            139 1440P0POCN                                    CSD027
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
     D**  Settlement Currency                                             CEU003
     D  P0STCY               725    727                                         CEU003
     D**  Pay Settlement Currency                                                             CLE031
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
     D**********                              1   60P4FCUS                                    CSD027
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
     D W#PTYP          C                   CONST('LOAN INTER')
     D W#PST1          C                   CONST('CALL LOAN ')
     D W#PST2          C                   CONST('TERM LOAN ')
     D W#PST3          C                   CONST('TERM PA PU')
     D W#PST4          C                   CONST('TERM PA SL')
     D W#PST5          C                   CONST('FLAT LOAN')
     D W#PST6          C                   CONST('GUAR ISSUE')                                     B
     D W#PST7          C                   CONST('DISC LOAN ')                                     B
     D W#PST8          C                   CONST('DISC PA PU')                                     B
     D W#PST9          C                   CONST('DISC PA SL')                                     B
     D W#PSTA          C                   CONST('CALL PA PU')                                     B
     D W#PSTB          C                   CONST('CALL PA SL')                                     B
     D W#PSTC          C                   CONST('RISK PA PU')                                     B
     D W#PSTD          C                   CONST('RISK P SL1')                                     B
     D W#PSTE          C                   CONST('RISK P SL2')                                     B
     D**********    'DISC LOAN '          C         W#PST6                             240327 CPK025
     D**********    'DISC PA PU'          C         W#PST7                             240327 CPK025
     D**********    'DISC PA SL'          C         W#PST8                             240327 CPK025
     D**********    'CALL PA PU'          C         W#PST9                             240327 CPK025
     D W#PSTF          C                   CONST('DISC LOAN ')
     D W#PSTG          C                   CONST('DISC PA PU')
     D W#PSTH          C                   CONST('DISC PA SL')
     D W#PSTI          C                   CONST('CALL PA PU')
     D W#PS10          C                   CONST('CALL PA SL')
     D W#PS11          C                   CONST('RISK PA PU')
     D W#PS12          C                   CONST('RISK P SL1')
     D W#PS13          C                   CONST('RISK P SL2')
     D W#PS14          C                   CONST('GUAR ISSUE')
     D*
     D DSPARM        E DS                  EXTNAME(CUTX1HN)
     D** External DS for parameter passed from CG6030
     D  ##BRC2       E                     EXTFLD(BRCA)                         102468
     D  ##CNU2       E                     EXTFLD(CNUM)                         102468
     D  ##RCD2       E                     EXTFLD(RCDT)                         102468
     D  ##VDA2       E                     EXTFLD(VDAT)
     D  ##PRS2       E                     EXTFLD(PRSQ)                         102468
     D  ##LAS2       E                     EXTFLD(LASN)                         102468
     D  ##FTY2       E                     EXTFLD(FTYP)                         102468
     D  ##FSE2       E                     EXTFLD(FSEQ)                         102468
     D  ##AMT2       E                     EXTFLD(AMTP)                         102468
     D  ##PRA2       E                     EXTFLD(PRAM)
     D  ##BRT2       E                     EXTFLD(BRTE)
     D  ##RTS2       E                     EXTFLD(RTSP)
     D  ##SPN2       E                     EXTFLD(SPIN)
     D  ##INT2       E                     EXTFLD(INTA)
     D  ##INC2       E                     EXTFLD(INTC)
     D  ##TIP2       E                     EXTFLD(TIPD)
     D  ##WTI2       E                     EXTFLD(WTIN)
     D*
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
     D**  External DS for incomplete reference
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  External DS for Bank details
     D/COPY WNCPYSRC,CG6036I001
     D*
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
     D**  External DS for currency details
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CEU014
      **  External DS for customer details                                CEU014
     D/COPY WNCPYSRC,CG6036I002
      *                                                                   CEU014
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    CEU014
      **  External DS for General Ledger details                          CEU014
      *                                                                   CEU014
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  First DS for access programs, short data structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Second DS for access programs, long data structure
     D*
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
     D**  Record format of PF/CGUDTAPD for use as a parameter
     D*
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
     D                 DS
     D  ACUP                   1      7P 0
     D  ##WCUP                 1      7P 2
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     I*
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
     I              SCCY                        ##STCY                          CEU003
     I              OCDT                        ##OCDT
     I              EAIR                        ##EAIR
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
     ICUTX1HPF
     I** Rename fields of CUTX1HP
     I              ACUP0                       ACUP
      *                                                                                       CCG015
      **  Data structure for SAR data.                                                        CCG015
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
     C*                 L05IN  - Lending Interest Advices             *
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
     C**  Determine if any movement is to be extracted for the loan.
     C**  If none, return to calling program
     C                   EXSR      SRTEST
     C     *IN40         CABEQ     *OFF          EXMAIN
     C*
     C*
     C**  Generate reference number by writing to PF/CGUDCRPD.
     C**  If no confirmation to be produced, then bypass.
     C*
     C                   MOVE      'N'           ##COPD
     C/COPY WNCPYSRC,CG6036C016
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C**  Extract.
     C*
     C                   EXSR      L05IN
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
     C                   MOVEL     'A'           RCDT
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 01 *
     C                   Z-ADD     1             W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                      BUG7960
     C                   MOVE      *BLANK        WOLN70            1
     C     ##PTYP        IFEQ      72
     C**********           Z-ADDLNRF      WOLNRF  60                                  BUG7960 CLE148
     C                   MOVEL     LNRF          WOLNRF            6
     C**********           Z-ADD##OLNO    LNRF                                       BUG7960 CSD027A
     C                   MOVE      ##OLNO        LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                      BUG7960
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE
     C                   MOVEL     LNRF          W0KEY
     C                   Z-ADD     17            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                      BUG7960
     C     ##PTYP        IFEQ      70
     C                   MOVE      'Y'           WOLN70
     C                   ENDIF
      *                                                                                      BUG7960
      ** Re-chain to get original loan details                                               BUG7960
     C**********           Z-ADDWOLNRF    LNRF                                        BUG7960 CLE148
     C                   MOVEL     WOLNRF        LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                      BUG7960
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE
     C                   MOVEL     LNRF          W0KEY
     C                   Z-ADD     18            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                      BUG7960
     C                   ENDIF
      *                                                                                       240327
     C                   MOVE      *BLANK        WOLN70            1
     C     ##PTYP        IFEQ      72
     C**********           Z-ADDLNRF      WOLNRF  60                                   240327 CLE148
     C                   MOVEL     LNRF          WOLNRF            6
     C**********           Z-ADD##OLNO    LNRF                                         240327 CPK025
     C                   MOVE      ##OLNO        LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                       240327
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 14 *
     C                   Z-ADD     14            W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       240327
     C     ##PTYP        IFEQ      70
     C                   MOVE      'Y'           WOLN70
     C                   ENDIF
      *                                                                                       240327
      ** Rechain CLOANCL to get original loan details                                         240327
      *                                                                                       240327
     C**********           Z-ADDWOLNRF    LNRF                                         240327 CLE148
     C                   MOVEL     WOLNRF        LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                       240327
     C     KCLOAN        CHAIN     CLOAN                              88
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ************
     C                   MOVEL     LNRF          W0KEY                          * DBERR 15 *
     C                   Z-ADD     15            W0ERNB                         ************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       240327
     C                   ENDIF
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
     C*
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
     C                   MOVEL     BRCA          DRBRCA
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
     C     ##PTYP        WHENEQ    64
     C                   MOVEL     W#PST3        DRPSTP
     C     ##PTYP        WHENEQ    66
     C                   MOVEL     W#PST4        DRPSTP
     C     ##PTYP        WHENEQ    70
     C                   MOVEL     W#PST6        DRPSTP
     C     ##PTYP        WHENEQ    63
     C                   MOVEL     W#PST7        DRPSTP
     C     ##PTYP        WHENEQ    65
     C                   MOVEL     W#PST8        DRPSTP
     C     ##PTYP        WHENEQ    67
     C                   MOVEL     W#PST9        DRPSTP
     C     ##PTYP        WHENEQ    68
     C                   MOVEL     W#PSTA        DRPSTP
     C     ##PTYP        WHENEQ    69
     C                   MOVEL     W#PSTB        DRPSTP
     C     ##PTYP        WHENEQ    71
     C                   MOVEL     W#PSTC        DRPSTP
     C     ##PTYP        WHENEQ    72
     C     WOLN70        IFEQ      'Y'
     C                   MOVEL     W#PSTD        DRPSTP
     C                   ELSE
     C                   MOVEL     W#PSTE        DRPSTP
     C                   ENDIF
     C     ##PTYP        WHENEQ    80
     C     CLE028        ANDEQ     'Y'
     C                   MOVEL     W#PST5        DRPSTP
     C     ##PTYP        WHENEQ    70
     C                   MOVEL     W#PS14        DRPSTP
     C     ##PTYP        WHENEQ    63
     C**********           MOVELW#PST6    DRPSTP                                       240327 CPK025
     C                   MOVEL     W#PSTF        DRPSTP
     C     ##PTYP        WHENEQ    65
     C**********           MOVELW#PST7    DRPSTP                                       240327 CPK025
     C                   MOVEL     W#PSTG        DRPSTP
     C     ##PTYP        WHENEQ    67
     C**********           MOVELW#PST8    DRPSTP                                       240327 CPK025
     C                   MOVEL     W#PSTH        DRPSTP
     C     ##PTYP        WHENEQ    68
     C**********           MOVELW#PST9    DRPSTP                                       240327 CPK025
     C                   MOVEL     W#PSTI        DRPSTP
     C     ##PTYP        WHENEQ    69
     C                   MOVEL     W#PS10        DRPSTP
     C     ##PTYP        WHENEQ    71
     C                   MOVEL     W#PS11        DRPSTP
     C     ##PTYP        WHENEQ    72
     C     WOLN70        IFEQ      'Y'
     C                   MOVEL     W#PS12        DRPSTP
     C                   ELSE
     C                   MOVEL     W#PS13        DRPSTP
     C                   ENDIF
     C                   ENDSL
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
     C                   MOVEL     CNUM          ##CUST
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
     C*
     C                   MOVE      'Y'           ##COPD
      *                                                                                       CCG015
      ** If return code is blank, generate the 'begin' and 'end'                              CCG015
      ** New Extraction Records                                                               CCG015
      *                                                                                       CCG015
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
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
     C     SRGEN9        ENDSR                                                  ** SRGEN9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  L05IN                                         *
     C*  Function    :  Lending Interest Advices                      *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRSDET - Set-up Settlement Details            *
     C*                 LOANA  - Loan Associated Details              *
     C*                 LOANIS - Process Loan Interest Summary        *
     C*                 LOANID - Process Loan Interest Details        *
     C*                                                               *
     C*****************************************************************
     C*
     C     L05IN         BEGSR                                                  ** L05IN  **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L05IN '      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'l05IN '      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CCG015
      ** Push Order (PF/CGUXMGPD)                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
      *                                                                                       CCG015
     C                   EXSR      LOANA
     C                   EXSR      SRSDET
     C                   Z-ADD     ##OSEQ        ##WSEQ
     C                   Z-ADD     ##PBIN        ##WPBN
     C                   Z-ADD     ##TBIN        ##WTBN
     C                   ADD       1             ##OSEQ
     C                   EXSR      LOANID
     C                   Z-ADD     ##WSEQ        ##OSEQ
     C                   Z-ADD     ##WPBN        ##PBIN
     C                   Z-ADD     ##WTBN        ##TBIN
     C                   EXSR      LOANIS
      *                                                                                       CER049
      ** Stamp Tax details                                                                    CER049
      *                                                                                       CER049
     C     CER049        IFEQ      'Y'
     C                   EXSR      LNSTAX
     C                   ENDIF
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
      ** Pop Order (PF/CGUXMGPD)                                                              CCG015
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     L05IN9        ENDSR                                                  ** L05IN9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANIS                                        *
     C*  Function    :  Process Loan Interest Summary                 *
     C*                                                               *
     C*  Called by   :  L05IN  - Lending Interest Advices             *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                                                               *
     C*****************************************************************
     C*
     C     LOANIS        BEGSR                                                  ** LOANIS **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANIS'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANIS'      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CCG015
      ** Push Order (PF/CGUXMGPD)                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C**  Currency Description.
     C*
     C                   MOVEL     CCY           ##CCY
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
     C**  Currency.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CURRENCY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CCY           R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Gross Interest.
     C*
     C     ##INC2        IFEQ      'Y'
     C                   Z-ADD     0             ##WGRS           13 0
     C                   ELSE
     C                   Z-ADD     ##INTA        ##WGRS
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'GRS INTR'    #@RDE
     C                   MOVE      'ST'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##WGRS        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C005
     C                   MOVEL     A6NBDP        ##DCPA
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
     C**  Net Interest.
     C*
     C*
     C     ##INC2        IFEQ      'Y'
     C                   Z-ADD     0             ##WNET           13 0
     C                   ELSE
     C     ##PRAM        ADD       ##INTA        ##WNET
     C     ##WTI2        IFEQ      'R'
     C     ##WNET        ADD       ##WTXA        ##WNET
     C                   END
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NET INTR'    #@RDE
     C                   MOVE      'ST'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##WNET        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C006
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Principal
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'L '          #@RDE
     C                   MOVEL     'PRINCIPA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##PRAM        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C007
     C                   MOVEL     A6NBDP        ##DCPA
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
     C**  Tax.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'TAX     '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##WTXA        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C008
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Tax Indicator.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'TAXI    '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##WTI2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE031
      ** Check for Correct Currency to be used in conversion                                  CLE031
      *                                                                                       CLE031
     C     *LIKE         DEFINE    ##PRAM        WCVAMT
     C                   Z-ADD     ##PRAM        WCVAMT
     C                   EXSR      SRCCHK
      *                                                                                       CLE031
     C*                                                                   CEU003
     C** Principal in Settlement Currency; calculate using EU0200.        CEU003
     C*                                                                   CEU003
     C                   ADD       1             R1                                            CEU00
     C                   CLEAR                   R#DATA                                        CEU00
     C                   CLEAR                   R#DEFN                                        CEU00
     C                   CLEAR                   #@RDE                                         CEU00
     C                   MOVEL     'PRNC_SC '    #@RDE                                         CEU00
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU00
     C                   MOVEL     'Amount'      ##RDEC                                        CEU00
     C                   MOVEL     'L'           ##RDET                                        CEU00
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU00
     C*                                                                   CEU003
     C     SCCY          IFNE      *BLANKS                                                     CEU00
     C     CLE031        ANDEQ     'N'
     C     CLE031        OREQ      'Y'
     C     WEURUN        ANDEQ     'Y'
     C     SCCY          ANDNE     *BLANKS
     C*                                                                   CEU003
     C     *LIKE         DEFINE    ##PRAM        ##PRSC                                        CEU00
     C                   CALL      'EU0200'                                                    CEU00
     C                   PARM      *BLANKS       P@RTCD            7            Return Code    CEU00
     C                   PARM      ##PRAM        P@FRAM           18 3          FROM Ccy AmountCEU00
     C                   PARM      CCY           P@FRCY            3            FROM Currency  CEU00
     C                   PARM      SCCY          P@TOCY            3            TO Currency    CEU00
     C     ##PRSC        PARM                    P@OUTA           15 0          Outright AmountCEU00
     C                   PARM                    P@INTA           18 3          Interim Amount CEU00
     C                   PARM                    P@EXRT           15 9          Exchange Rate  CEU00
     C                   PARM                    P@MDIN            1            Mult/Div Ind.  CEU00
     C*                                                                   CEU003
     C**      Database error handling:                                    CEU003
     C*                                                                   CEU003
     C     P@RTCD        IFEQ      '*ERROR*'                                                   CEU00
     C                   MOVEL     'EU0200  '    W0FILE                                        CEU00
     C                   MOVEL     ##RTCD        W0KEY                          ************   CEU00
     C                   Z-ADD     9             W0ERNB                         * DBERR 09 *   CEU00
     C                   MOVEL     'MEM5003'     W0MSGD                         ************   CEU00
     C                   MOVEL     'MIDAS   '    W0MSGF                                        CEU00
     C                   EXSR      SRERR                                                       CEU00
     C*                                                                   CEU003
     C                   ELSE                                                                  CEU00
     C                   MOVEL     ##PRSC        ##DATA                                        CEU00
     C                   ENDIF                                                                 CEU00
     C*                                                                   CEU003
     C*       Calculate number of decimal places using SRDCDT             CEU003
     C*                                                                   CEU003
     C                   MOVEL     SCCY          ##CCY                                         CEU00
     C                   EXSR      SRDCDT                                                      CEU00
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU00
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU00
     C*                                                                   CEU003
     C                   ENDIF                                                                 CEU00
      *                                                                                       CLE031
      ** Check for Correct Currency to be used in conversion                                  CLE031
      *                                                                                       CLE031
     C                   Z-ADD     ##WNET        WCVAMT
     C                   EXSR      SRCCHK
      *                                                                                       CLE031
     C*                                                                   CEU003
     C**  Net Interest in Settlement Currency; calculate using EU0200.    CEU003
     C*                                                                   CEU003
     C                   ADD       1             R1                                            CEU00
     C                   CLEAR                   R#DATA                                        CEU00
     C                   CLEAR                   R#DEFN                                        CEU00
     C                   CLEAR                   #@RDE                                         CEU00
     C                   MOVEL     'NI_SC   '    #@RDE                                         CEU00
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU00
     C                   MOVEL     'Amount'      ##RDEC                                        CEU00
     C                   MOVEL     'L'           ##RDET                                        CEU00
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU00
     C*                                                                   CEU003
     C     SCCY          IFNE      *BLANKS                                                     CEU00
     C     CLE031        ANDEQ     'N'
     C     CLE031        OREQ      'Y'
     C     WEURUN        ANDEQ     'Y'
     C     SCCY          ANDNE     *BLANKS
     C*                                                                   CEU003
     C     *LIKE         DEFINE    ##WNET        ##NISC                                        CEU00
     C                   CALL      'EU0200'                                                    CEU00
     C                   PARM      *BLANKS       P@RTCD            7            Return Code    CEU00
     C                   PARM      ##WNET        P@FRAM           18 3          FROM Ccy AmountCEU00
     C                   PARM      CCY           P@FRCY            3            FROM Currency  CEU00
     C                   PARM      SCCY          P@TOCY            3            TO Currency    CEU00
     C     ##NISC        PARM                    P@OUTA           15 0          Outright AmountCEU00
     C                   PARM                    P@INTA           18 3          Interim Amount CEU00
     C                   PARM                    P@EXRT           15 9          Exchange Rate  CEU00
     C                   PARM                    P@MDIN            1            Mult/Div Ind.  CEU00
     C*                                                                   CEU003
     C**      Database error handling:                                    CEU003
     C*                                                                   CEU003
     C     P@RTCD        IFEQ      '*ERROR*'                                                   CEU00
     C                   MOVEL     'EU0200  '    W0FILE                                        CEU00
     C                   MOVEL     ##RTCD        W0KEY                          ************   CEU00
     C                   Z-ADD     10            W0ERNB                         * DBERR 10 *   CEU00
     C                   MOVEL     'MEM5003'     W0MSGD                         ************   CEU00
     C                   MOVEL     'MIDAS   '    W0MSGF                                        CEU00
     C                   EXSR      SRERR                                                       CEU00
     C*                                                                   CEU003
     C                   ELSE                                                                  CEU00
     C                   MOVEL     ##NISC        ##DATA                                        CEU00
     C                   ENDIF                                                                 CEU00
     C*                                                                   CEU003
     C*       Calculate number of decimal places using SRDCDT             CEU003
     C*                                                                   CEU003
     C                   MOVEL     SCCY          ##CCY                                         CEU00
     C                   EXSR      SRDCDT                                                      CEU00
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU00
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU00
     C*                                                                   CEU003
     C                   ENDIF                                                                 CEU00
      *                                                                   CEU014
      ** CEU014 Changes.                                                  CEU014
      *                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C                   MOVE      *BLANKS       EQCY                                          CEU01
     C                   MOVE      CCY           ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C     A6INCY        IFEQ      'Y'                                                         CEU01
     C                   MOVE      BKEURO        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C     CCY           IFEQ      BKEURO                                                      CEU01
      *                                                                   CEU014
      ** Get Customer Details                                             CEU014
      *                                                                   CEU014
     C                   MOVEL     CNUM          ##KEY1                                        CEU01
     C                   CALL      'AOCUSTR0'                                                  CEU01
     C                   PARM      *BLANKS       ##RTCD                                        CEU01
     C                   PARM      '*KEY   '     ##OPTN                                        CEU01
     C                   PARM                    ##KEY1           10                           CEU01
     C                   PARM      *BLANKS       ##KYST            7                           CEU01
     C     SDCUST        PARM      SDCUST        DSSDY                                         CEU01
      *                                                                   CEU014
      ** Database Error                                                   CEU014
      *                                                                   CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
     C                   MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
     C                   MOVEL     CNUM          W0KEY                          ***************CEU01
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *CEU01
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   END                                                                   CEU01
     C                   MOVE      BBDINC        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU014
      ** Extract Principal in Equivalent Currency                         CEU014
      *                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVE      'Y '          #@RDE                                         CEU01
     C                   MOVEL     'PRNC_EQC'    #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     ##PRAM        P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
     C                   MOVE      EQCY          P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU014
      ** Extract Net interest amount in equivalent ccy.                   CEU014
      *                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C                   MOVEL     'N_INT_EQ'    #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
      *                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     ##WNET        P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
     C                   MOVE      EQCY          P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU014
      ** Extract Equivalent Currency                                      CEU014
      *                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVE      'Y '          #@RDE                                         CEU01
     C                   MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##DATA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU014
      ** Extract Equivalent Currency Description                          CEU014
      *                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVE      'YD'          #@RDE                                         CEU01
     C                   MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     A6CYNM        ##DATA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C/COPY WNCPYSRC,CG6036C004
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
      *                                                                                       CCG015
      ** Pop Order (PF/CGUXMGPD)                                                              CCG015
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOANI9        ENDSR                                                  ** LOANI9 **
     C*
     C*****************************************************************   CEU014
      /EJECT                                                                                  CER049
      *****************************************************************                       CER049
      *                                                               *                       CER049
      *  Subroutine  :  LNSTAX                                        *                       CER049
      *  Function    :  Process Stamp Tax Information                 *                       CER049
      *                                                               *                       CER049
      *  Called by   :  L05IN  - Lending Interest Advices             *                       CER049
      *  Calls       :  SRPATH - Generate Path String                 *                       CER049
      *                 SRDCDT - Determine Currency Details           *                       CER049
      *                 SRADTA - Accumulate RDEs and Associated Data  *                       CER049
      *                 SRODTA - Output Accumulated Data to CGUDTAPD  *                       CER049
      *                                                               *                       CER049
      *****************************************************************                       CER049
      *                                                                                       CER049
     C     LNSTAX        BEGSR                                                  ** LNSTAX **
      *                                                                                       CER049
      **  Set up subroutine stack name.                                                       CER049
      *                                                                                       CER049
     C                   ADD       1             Q
     C                   MOVEL     'LNSTAX'      @STK(Q)
      *                                                                                       CER049
     C                   ADD       1             P1
      *                                                                                       CER049
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LNSTAX'      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CER049
      ** Push Order (PF/CGUXMGPD)                                                             CER049
      *                                                                                       CER049
     C                   EXSR      PSHGRS
      *                                                                                       CER049
     C                   Z-ADD     0             R1                3 0
      *
      ** Init New Fields LIBOR
      *
     C                   MOVEL     *BLANKS       BLRT              1
     C                   MOVEL     *BLANKS       LBDY              2 0
     C                   MOVEL     *BLANKS       LODY              2 0
     C                   MOVEL     *BLANKS       PDLY              2 0
     C                   MOVEL     *BLANKS       BADJ             13 8
     C                   MOVEL     *BLANKS       WGHT              1
     C                   MOVEL     *BLANKS       BRAC              1 0
     C                   MOVEL     *BLANKS       LBAC              2 0
     C                   MOVEL     *BLANKS       PRPL             22 0
     C                   MOVEL     *BLANKS       AVOP              1
     C                   MOVEL     *BLANKS       CART             2015
      *                                                                                       CER049
      **  Set Loan number key                                                                 CER049
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
      **  Decrement Path DS index.                                                            CER049
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
     C                   ENDSR                                                  ** LNSTAX **
      *                                                                                       CER049
      *****************************************************************                       CER049
     C/EJECT                                                              CEU014
      *****************************************************************   CEU014
      * Subroutine  :  D@EURO                                         *   CEU014
      * Function    :  EURO Currency Conversion:                      *   CEU014
      *                Converts amount P@FRAM in ccy P@FRCY to amount *   CEU014
      *                ##OUTA in ccy P@TOCY.                          *   CEU014
      * Called by   :  LOANIS                                         *   CEU014
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
     C                   PARM                    P@OUTA           15 0          Outright AmountCEU01
     C                   PARM                    P@INTA           18 3          Interim Amount CEU01
     C                   PARM                    P@EXRT           15 9          Exchange Rate  CEU01
     C                   PARM                    P@MDIN            1            Mult/Div Ind.  CEU01
      *                                                                   CEU014
      ** Database error handling:                                         CEU014
      *                                                                   CEU014
     C     P@RTCD        IFEQ      '*ERROR*'                                                   CEU01
     C                   MOVEL     'EU0200  '    W0FILE                                        CEU01
     C                   MOVEL     '*CALL   '    W0KEY                          ***************CEU01
     C                   Z-ADD     12            W0ERNB                         * DB ERROR 12 *CEU01
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
     C/COPY WNCPYSRC,CG6036C017
     C*****************************************************************
     C/EJECT                                                                                  CLE031
      *****************************************************************                       CLE031
      * Subroutine  :  SRCCHK                                         *                       CLE031
      * Function    :  Ensure that the correct currency code is       *                       CLE031
      *                used when converting the Principal and         *                       CLE031
      *                Net Interest                                   *                       CLE031
      * Called by   :  LOANIS                                         *                       CLE031
      *                                                               *                       CLE031
      * Calls       :  SRCONV                                         *                       CLE031
      *****************************************************************                       CLE031
     C     SRCCHK        BEGSR
      *                                                                                       CLE031
      ** Setup Flags                                                                          CLE031
      ** Determine if Loan Currency is an In currency                                         CLE031
      *                                                                                       CLE031
     C                   MOVE      CCY           ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6INCY        WINCCY            1
     C                   MOVE      A6NBDP        WCCYDP            1
      *                                                                                       CLE031
     C     WINCCY        IFEQ      'N'
      *                                                                                       CLE031
      ** Determine if Settlement Currency is an In Currency                                   CLE031
      *                                                                                       CLE031
     C                   MOVE      SCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6INCY        WINSCY            1
     C                   MOVE      A6NBDP        WSCYDP            1
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C                   MOVE      'Y'           WEURUN            1
      *                                                                                       CLE031
      ** If CLE031 in on, Check for In Currencies or convert using ZCONV                      CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
     C                   MOVE      'N'           WEURUN
      *                                                                                       CLE031
      ** If Either Currency is an In Currency, set Flag to run EU0200                         CLE031
      *                                                                                       CLE031
     C     WINCCY        IFEQ      'Y'
     C     WINSCY        OREQ      'Y'
     C                   MOVE      'Y'           WEURUN
     C                   ELSE
     C                   MOVE      WCVAMT        PAMT
     C                   MOVE      SEXR          PEXC
     C                   MOVE      SEXI          PMDI
     C                   MOVE      CCY           PFCY
     C                   MOVE      SCCY          PTCY
     C                   MOVE      WCCYDP        PFDP
     C                   MOVE      WSCYDP        PTDP
     C                   EXSR      SRCONV
     C                   MOVE      POUT          ##DATA
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDSR
      *****************************************************************                       CLE031
     C/EJECT                                                                                  CLE031
      *****************************************************************                       CLE031
      * Subroutine  :  SRCONV                                         *                       CLE031
      * Function    :  Converts from one currency to another          *                       CLE031
      *                using the ZCONV Module                         *                       CLE031
      * Called by   :  SRCCHK                                         *                       CLE031
      *                                                               *                       CLE031
      * Calls       :  ZCONV                                          *                       CLE031
      *****************************************************************                       CLE031
     C     SRCONV        BEGSR
      *                                                                                       CLE031
     C                   CALL      'ZCONVZ1'
     C                   PARM                    PAMT             15 0
     C                   PARM                    PEXC             13 8
     C                   PARM                    PMDI              1
     C                   PARM                    PFCY              3
     C                   PARM                    PTCY              3
     C                   PARM                    PFDP              1 0
     C                   PARM                    PTDP              1 0
     C                   PARM                    POUT             15 0
      *                                                                                       CLE031
     C                   ENDSR
      *****************************************************************                       CLE031
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANID                                        *
     C*  Function    :  Process Loan Interest Details                 *
     C*                                                               *
     C*  Called by   :  L05IN  - Lending Interest Advice              *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 LOANBF - Process Loan B/F Events              *
     C*                 SRSMOV - Setup Movement Details               *
     C*                 LOANER - Process Loan Events                  *
     C*                 LOANCF - Process Loan C/F Events              *
     C*                 SRBIND - Generate Binding Numbers             *
     C*                                                               *
     C*****************************************************************
     C*
     C     LOANID        BEGSR                                                  ** LOANID **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANID'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C                   MOVE      'Y'           ##WHDR            1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANID'      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CCG015
      ** Push Order (PF/CGUXMGPD)                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
      *                                                                                       CCG015
     C                   EXSR      SRBIND
     C                   EXSR      LOANBF
     C*
     C     KCUTX0        KLIST
     C******               KFLD           BRCA                            CLE004
     C******               KFLD           CNUM                            CLE004
     C******               KFLD           FTYP                            CLE004
     C******               KFLD           FSEQ                            CLE004
     C                   KFLD                    ##BRCA                                        CLE00
     C                   KFLD                    ##CNUM                                        CLE00
     C                   KFLD                    ##FTYP                                        CLE00
     C                   KFLD                    ##FSEQ                                        CLE00
     C                   KFLD                    LNRF
     C*
      *                                                                   156795
      ** Initialize amounts                                               156795
      *                                                                   156795
     C                   Z-ADD     0             INTA                                          15679
     C                   Z-ADD     0             PRAM                                          15679
     C                   Z-ADD     0             WTXA                                          15679
      *                                                                   156795
     C     KCUTX0        CHAIN     LECUTXL0                           51
     C     *IN51         DOWEQ     '0'
     C*
     C     AMTP          IFEQ      'IN'
     C     BTRQ          ANDEQ     'Y'
     C     AMTP          OREQ      'RE'
     C     BTRQ          ANDEQ     'Y'
     C     AMTP          OREQ      'MA'
     C     BTRQ          ANDEQ     'Y'
     C*
     C     VDAT          IFLE      LIPD
     C                   EXSR      SRSMOV
     C*
     C     VDAT          IFLT      LIPD
     C     VDAT          OREQ      LIPD
     C     REPT          ANDEQ     1
     C     VDAT          OREQ      LIPD
     C     REPT          ANDEQ     3
     C     VDAT          OREQ      LIPD
     C     AMTP          ANDEQ     'IN'
     C     VDAT          OREQ      LIPD
     C     AMTP          ANDEQ     'MA'
     C     VDAT          OREQ      LIPD
     C     ##VDA2        ANDLT     LIPD
     C     AMTP          ANDEQ     'RE'
     C     REPT          ANDEQ     2
     C                   EXSR      LOANER
     C                   END
     C*
     C                   END
     C*
     C                   ELSE
     C*
     C     VDAT          IFLT      LIPD
     C     VDAT          OREQ      LIPD
     C     ##VDA2        ANDLT     LIPD
     C                   EXSR      SRSMOV
     C                   EXSR      LOANER
     C                   END
     C*
     C                   END
     C*
     C*
     C*
     C** For CUTX1HP  record, update ZZ006 to allow Repayment Notice
     C** program to re-process this record and also to allow LE0540
     C** to recorgnise that this has already been processed by UDC.
     C*
     C     *IN30         IFEQ      *ON
     C*
     C                   Z-ADD     VDAT          ##VADT            5 0
     C*
     C     RCDT          IFEQ      'D'
     C                   MOVEL     'Y'           ZZ006
     C                   UPDATE    CUTX1HPF
     C                   ELSE
     C                   MOVE      *BLANKS       BTIN
     C                   UPDATE    CUTX1HQF
     C                   ENDIF
     C*
     C                   COMMIT
     C*
     C                   ELSE
     C*  Unlock record
     C                   UNLOCK    LECUTXL0
     C*
     C                   ENDIF
     C*
     C                   MOVE      *OFF          *IN30
      *                                                                   156795
      ** Initialize amounts                                               156795
      *                                                                   156795
     C                   Z-ADD     0             INTA                                          15679
     C                   Z-ADD     0             PRAM                                          15679
     C                   Z-ADD     0             WTXA                                          15679
      *                                                                   156795
     C*
     C     KCUTX0        READE     LECUTXL0                               51
     C*
     C                   END
      *                                                                   172049
      **  Decrement Path DS index AND recreate path                       172049
      *                                                                   172049
     C     P1            OCCUR     ##PATH                                                      17204
     C                   CLEAR                   ##GRPS                                        17204
      *                                                                   172049
     C                   MOVEL(P)  'LOANID'      ##GRPS                                        17204
     C                   EXSR      SRPATH                                                      17204
      *                                                                   172049
      **  Reset Binding information                                       172049
      *                                                                   172049
     C     P1            OCCUR     ##BIND                                                      17204
     C*
     C                   EXSR      LOANCF
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
      ** Pop Order (PF/CGUXMGPD)                                                              CCG015
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOAND9        ENDSR                                                  ** LOAND9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  SRSMOV                                        *
     C*  Function    :  Setup Movement Details                        *
     C*                                                               *
     C*  Called by   :  LOANID - Process Loan Interest Details        *
     C*  Calls       :  None                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRSMOV        BEGSR                                                  ** SRSMOV **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRSMOV'      @STK(Q)
     C*
     C                   Z-ADD     0             ##MAMT           13 0
     C*
     C     AMTP          IFEQ      'PI'
     C     AMTP          OREQ      'PT'                                                        CLE00
     C     ##LBAL        ADD       PRAM          ##LBAL
     C                   Z-ADD     PRAM          ##MAMT
     C                   END
     C*
     C     AMTP          IFEQ      'IN'
     C     ##INC2        IFEQ      'Y'
     C     ##LBAL        ADD       PRAM          ##LBAL
     C                   END
     C     ##TIP2        ADD       INTA          ##TIP2
     C                   Z-ADD     INTA          ##MAMT
     C                   END
     C*
     C     AMTP          IFEQ      'MA'
     C     AMTP          OREQ      'RE'
     C     AMTP          OREQ      'MR'
     C     AMTP          OREQ      'PF'                                                        CLE00
     C     ##LBAL        SUB       PRAM          ##LBAL
     C     ##TIP2        ADD       INTA          ##TIP2
     C     PRAM          ADD       INTA          ##MAMT
     C                   END
     C*
     C     AMTP          IFEQ      'MI'
     C                   Z-ADD     INTA          ##MAMT
     C                   END
     C*
     C     AMTP          IFEQ      'SC'
     C                   Z-ADD     RTSP          ##RTS2
     C                   END
     C*
     C     AMTP          IFEQ      'BC'
     C     AMTP          OREQ      'BR'
     C                   Z-ADD     BRTE          ##BRT2
     C                   END
     C*
     C     AMTP          IFEQ      'RO'
     C                   Z-ADD     RTSP          ##RTS2
     C                   Z-ADD     BRTE          ##BRT2
     C                   MOVEL     SPIN          ##SPN2
     C                   END
     C*
     C     ##SPN2        IFEQ      'A'
     C     ##BRT2        ADD       ##RTS2        ##IRAT           11 7
     C                   ELSE
     C     ##SPN2        IFEQ      'S'
     C     ##BRT2        SUB       ##RTS2        ##IRAT
     C                   ELSE
     C     ##SPN2        IFEQ      'P'
     C     ##RTS2        DIV       100           ##WWRK           13 9
     C     ##BRT2        MULT      ##WWRK        ##IRAT
     C                   END
     C                   END
     C                   END
     C*
     C                   Z-ADD     0             ##MRAT           11 7
     C*
     C     AMTP          IFEQ      'SC'
     C     AMTP          OREQ      'BC'
     C     AMTP          OREQ      'BR'
     C     AMTP          OREQ      'RO'
     C                   Z-ADD     ##IRAT        ##MRAT
     C                   END
     C*
     C     ##WCUP        SUB(H)    ##TIP2        ##INTO           13 0
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRSMO9        ENDSR                                                  ** SRSMO9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANER                                        *
     C*  Function    :  Process Loan Events                           *
     C*                                                               *
     C*  Called by   :  LOANID - Process Loan Interest Details        *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 LOANEV - Process Loan Event Details           *
     C*                 SRBIND - Generate Binding Numbers             *
     C*                                                               *
     C*****************************************************************
     C*
     C     LOANER        BEGSR                                                  ** LOANER **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANER'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANER'      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CCG015
      ** Push Order (PF/CGUXMGPD)                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
      *                                                                                       CCG015
     C                   EXSR      SRBIND
     C                   EXSR      LOANEV
     C*
     C**  Store summary details in work fields for later use in
     C**  Interest summary details extract.
     C*
     C***********          Z-ADDINTA      ##INTA                          156795
     C***********          Z-ADDPRAM      ##PRAM                          156795
     C***********          Z-ADDWTXA      ##WTXA                          156795
      *                                                                   156795
      ** Increment ##INTA if Amendment Type is Interest Payment (IN),     156795
      ** Repayment (RE) or  Maturity Payment (MA).                        156795
      *                                                                   156795
     C     AMTP          IFEQ      'IN'                                                        15679
     C     AMTP          OREQ      'RE'                                                        15679
     C     AMTP          OREQ      'MA'                                                        15679
     C                   ADD       INTA          ##INTA                                        15679
     C                   ENDIF                                                                 15679
      *                                                                   156795
      ** Increment ##PRAM if Amendment Type is Repayment (RE) or          156795
      ** Maturity Payment (MA).                                           156795
      *                                                                   156795
     C     AMTP          IFEQ      'RE'                                                        15679
     C     AMTP          OREQ      'MA'                                                        15679
     C                   ADD       PRAM          ##PRAM                                        15679
     C                   ENDIF                                                                 15679
     C                   ADD       WTXA          ##WTXA                                        15679
     C*
     C**  Set on *IN30 to signify this record has been processed
     C**  successfully.
     C*
     C                   MOVE      *ON           *IN30
     C*
     C**  Decrement Path DS index.
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
      ** Pop Order (PF/CGUXMGPD)                                                              CCG015
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOANE9        ENDSR                                                  ** LOANE9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANEV                                        *
     C*  Function    :  Process Loan Event Details                    *
     C*                                                               *
     C*  Called by   :  LOANER - Process Loan Events                  *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                                                               *
     C*****************************************************************
     C*
     C     LOANEV        BEGSR                                                  ** LOANEV **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANEV'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANEV'      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CCG015
      ** Push Order (PF/CGUXMGPD)                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C**  Amendment Type.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'AMEND TY'    #@RDE
     C                   MOVE      'PE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AMTP          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Number of Days Interest.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'DAYS INT'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DAYS          ##DATA
     C                   MOVEL     'Number'      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Interest Rate.
     C*
     C     ##WHDR        IFEQ      'Y'
     C                   Z-ADD     ##IRAT        ##INTE           11 7
     C                   MOVE      ' '           ##WHDR
     C                   ELSE
     C                   Z-ADD     ##IRA2        ##INTE
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##INTE        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C                   Z-ADD     ##IRAT        ##IRA2           11 7
     C*
     C**  Interest Outstanding.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INTOUTS '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##INTO        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C009
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Loan Balance.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOAN BAL'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##LBAL        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C010
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Movement Amount.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'MOVE AMN'    #@RDE
     C                   MOVE      'T '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##MAMT        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C011
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Movement Rate.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'MOVE RAT'    #@RDE
     C                   MOVE      'E '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##MRAT        ##DATA
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
     C                   MOVEL     VDAT          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** LIBOR Deregulation BACKWARD-LOOKING RATE
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'BCKLOKRA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BLRT          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Averaging Option
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'N'           #@RDE
     C                   MOVEL     'AVGOPTIO'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AVOP          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Compounded/Average Rate
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AR'          #@RDE
     C                   MOVEL     'COMPOUND'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CART          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Lookback Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AY'          #@RDE
     C                   MOVEL     'LOOKBCKD'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LBDY          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Lockout Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AY'          #@RDE
     C                   MOVEL     'LOCKOUTD'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LODY          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Delayed Payment Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'YS'          #@RDE
     C                   MOVEL     'DLYPAYDA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     PDLY          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Benchmark Adjustment Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'OD'          #@RDE
     C                   MOVEL     'BMRKADJC'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BADJ          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Weight Convention
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'OD'          #@RDE
     C                   MOVEL     'BMRKADJC'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     WGHT          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Base Rate Code for Accrual
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'BRACCRRA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BRAC          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Lookback Days for Accrual
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'BRACCRRA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LBAC          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Principal
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'L'           #@RDE
     C                   MOVEL     'PRINCIPA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     PRPL          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C/COPY WNCPYSRC,CG6036C003
      *                                                                                       CLE143
     C     CLE143        IFEQ      'Y'
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
      *                                                                                       CLE143
     C                   ENDIF
      *                                                                                       CER050
     C     CER050        IFEQ      'Y'
     C                   EXSR      ZI@APR
     C                   ENDIF
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
      *                                                                                       CCG015
      ** Pop Order (PF/CGUXMGPD)                                                              CCG015
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOANV9        ENDSR                                                  ** LOANV9 **
      *                                                                                       CER050
      *****************************************************************                       CER050
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
      * LOOK FOR THE FIRST ELEMENT IN BLANK IN SERIE                                          CER050
     C                   Z-ADD     1             R1
     C     ##R(R1)       DOUEQ     *BLANKS
     C     R1            OREQ      20
     C                   ADD       1             R1
     C                   ENDDO
      *                                                                                       CER050
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
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANCF                                        *
     C*  Function    :  Process Loan C/F Events                       *
     C*                                                               *
     C*  Called by   :  LOANID - Process Loan Interest Details        *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                                                               *
     C*****************************************************************
     C*
     C     LOANCF        BEGSR                                                  ** LOANCF **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANCF'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANCF'      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CCG015
      ** Push Order (PF/CGUXMGPD)                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C**  C/F Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CF DATE '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##VADT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  C/F Interest Outstanding.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CF INTOU'    #@RDE
     C                   MOVE      'TS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##INTO        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C012
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  C/F Loan Balance.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CF LOANB'    #@RDE
     C                   MOVE      'AL'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##LBAL        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C013
     C                   MOVEL     A6NBDP        ##DCPA
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
      *                                                                                       CCG015
      ** Pop Order (PF/CGUXMGPD)                                                              CCG015
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOANC9        ENDSR                                                  ** LOANC9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANBF                                        *
     C*  Function    :  Process Loan B/F Events                       *
     C*                                                               *
     C*  Called by   :  LOANID - Process Loan Interest Details        *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to CGUDTAPD  *
     C*                                                               *
     C*****************************************************************
     C*
     C     LOANBF        BEGSR                                                  ** LOANBF **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANBF'      @STK(Q)
     C*
     C                   ADD       1             P1
     C*
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANBF'      ##GRPS
     C                   EXSR      SRPATH
      *                                                                                       CCG015
      ** Push Order (PF/CGUXMGPD)                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
     C*
     C**  B/F Interest Outstanding.
     C*
     C     ##INT2        SUB       ##TIP2        ##BFIN           13 0
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BF INTOU'    #@RDE
     C                   MOVE      'TS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##BFIN        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C014
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  B/F Loan Balance.
     C*
     C                   Z-ADD     ##PRA2        ##LBAL           13 0
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BF LOANB'    #@RDE
     C                   MOVE      'AL'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##PRA2        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6036C015
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C**  Brought Forward Date.
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BR_FWD_D'    #@RDE
     C                   MOVE      'AT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##VDA2        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
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
      *                                                                                       CCG015
      ** Pop Order (PF/CGUXMGPD)                                                              CCG015
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     LOANB9        ENDSR                                                  ** LOANB9 **
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*  Subroutine  :  LOANA                                         *
     C*  Function    :  Loan Associated Details                       *
     C*                                                               *
     C*  Called by   :  L05IN  - Lending Interest Advices             *
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
     C                   MOVE      LNRF          P@LNRF
     C                   CALL      'CG6001'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    P1PARM                         UDC Details
     C                   PARM                    P2PARM          140            Path Details
     C                   PARM                    P@PARM                         Loan Details
     C                   PARM                    P4PARM                         Facility Details
     C                   PARM                    ##AUTO            1
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
     C*  Called by   :  L05IN - Lending Interest Advices              *
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
     C**********           MOVEL##STCY    P0STCY                    CEU003137658
     C                   MOVEL     SCCY          P0STCY                                        13765
     C                   MOVEL     SCCY          P0PSCY
     C*
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN
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
     C                   Z-ADD     4             W0ERNB                         * DBERR 04 *
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
     C*  Subroutine  :  SRTEST                                        *
     C*  Function    :  Determine if a movement will be extracted     *
     C*                                                               *
     C*  Called by   :  MAINLINE - Mainline Processing                *
     C*  Calls       :  None                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRTEST        BEGSR                                                  ** SRTEST **
     C*
     C**  Set up subroutine stack name.
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRTEST'      @STK(Q)
     C*
     C                   MOVE      *OFF          *IN40
     C*
      *                                                                   156795
      ** Initialize amounts                                               156795
      *                                                                   156795
     C                   Z-ADD     0             INTA                                          15679
     C                   Z-ADD     0             PRAM                                          15679
     C                   Z-ADD     0             WTXA                                          15679
      *                                                                   156795
     C     KCUTX0        CHAIN     LECUTXL0                           50
     C*
     C**  At least one record must pass the selection criteria
     C*
     C     *IN50         DOWEQ     *OFF
     C     *IN40         ANDEQ     *OFF
     C*
     C**  Amendment type must be IN/MA/RE and Bill/Telex Req = Y
     C*
     C     AMTP          IFEQ      'IN'
     C     BTRQ          ANDEQ     'Y'
     C     AMTP          OREQ      'RE'
     C     BTRQ          ANDEQ     'Y'
     C     AMTP          OREQ      'MA'
     C     BTRQ          ANDEQ     'Y'
     C*
     C     VDAT          IFLE      LIPD
     C*
     C     VDAT          IFLT      LIPD
     C     VDAT          OREQ      LIPD
     C     REPT          ANDEQ     1
     C     VDAT          OREQ      LIPD
     C     REPT          ANDEQ     3
     C     VDAT          OREQ      LIPD
     C     AMTP          ANDEQ     'IN'
     C     VDAT          OREQ      LIPD
     C     AMTP          ANDEQ     'MA'
     C     VDAT          OREQ      LIPD
     C     ##VDA2        ANDLT     LIPD
     C     AMTP          ANDEQ     'RE'
     C     REPT          ANDEQ     2
     C                   MOVE      *ON           *IN40
     C                   END
     C*
     C                   END
     C*
     C**  Other than MA/IN/RE and BTRQ=Y......
     C*
     C                   ELSE
     C*
     C     VDAT          IFLT      LIPD
     C     VDAT          OREQ      LIPD
     C     ##VDA2        ANDLT     LIPD
     C                   MOVE      *ON           *IN40
     C                   END
     C*
     C                   END
     C*
      *                                                                   156795
      ** Initialize amounts                                               156795
      *                                                                   156795
     C                   Z-ADD     0             INTA                                          15679
     C                   Z-ADD     0             PRAM                                          15679
     C                   Z-ADD     0             WTXA                                          15679
      *                                                                   156795
     C     KCUTX0        READE     LECUTXL0                               50
     C*
     C                   ENDDO
     C*
     C** Unlock file
     C                   UNLOCK    LECUTXL0
     C*
     C     EXTES         TAG
     C*
     C**  Unwind subroutine stack name.
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C     SRTES9        ENDSR                                                  ** SRTES9 **
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
     C     *LIKE         DEFINE    DEOSEQ        ##WSEQ
     C     *LIKE         DEFINE    DEPBIN        ##WPBN
     C     *LIKE         DEFINE    DETBIN        ##WTBN
     C     *LIKE         DEFINE    INTA          ##INTA
     C     *LIKE         DEFINE    PRAM          ##PRAM
     C     *LIKE         DEFINE    WTXA          ##WTXA
      *                                                                   CEU014
      **  Define Equivalent Currency                                      CEU014
     C     *LIKE         DEFINE    CCY           EQCY                                          CEU01
     C*
     C                   Z-ADD     0             ##INTA
     C                   Z-ADD     0             ##PRAM
     C                   Z-ADD     0             ##WTXA
     C                   MOVE      *OFF          *IN40
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
     C/COPY WNCPYSRC,CG6036C001
      *                                                                   CEU014
      ** Access SAR details file to determine if CEU014 is installed.     CEU014
      *                                                                   CEU014
     C                   MOVEL     'N'           CEU014            1                           CEU01
      *                                                                   CEU014
     C                   CALL      'AOSARDR0'                                                  CEU01
     C                   PARM      '       '     ##RTCD                                        CEU01
     C                   PARM      '*VERIFY'     ##OPTN                                        CEU01
     C                   PARM      'CEU014'      ##SARD            6                           CEU01
      *                                                                   CEU014
     C     ##RTCD        IFEQ      *BLANK                                                      CEU01
     C                   MOVEL     'Y'           CEU014                                        CEU01
     C                   END                                                                   CEU01
      *                                                                   CEU014
      ** Database Error                                                   CEU014
      *                                                                   CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
     C     ##RTCD        ANDNE     '*NRF   '                                                   CEU01
     C                   MOVEL     'SCSARDPD'    W0FILE                         ***************CEU01
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 13 *CEU01
     C                   Z-ADD     13            W0ERNB                         ***************CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                                        CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   END                                                                   CEU01
      *                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
      *                                                                   CEU014
      **  Call access program for General Ledger details                  CEU014
     C**********           CALL 'AOGELRR0'                                             CEU014 CGL029
     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     ##RTCD                                        CEU01
     C                   PARM      '*FIRST '     ##OPTN                                        CEU01
     C********** SDGELR    PARM SDGELR    DSFDY                                        CEU014 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY
      *                                                                   CEU014
      **  Database error                                                  CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
      *                                                                   CEU014
     C                   MOVEL     'AOGELRR0'    W0FILE                                        CEU01
     C                   MOVEL     '*CALL'       W0KEY                          ***************CEU01
     C                   Z-ADD     14            W0ERNB                         * DB ERROR 14 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE028
      ** Check if Flat Rate Personal Loans (Rule of 78s) is installed.                        CLE028
      *                                                                                       CLE028
     C                   MOVEL     'N'           CLE028            1
      *                                                                                       CLE028
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CLE028'      ##SARD
      *                                                                                       CLE028
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE028
     C                   ENDIF
      *                                                                                       CLE028
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CLE028'      W0KEY
     C                   Z-ADD     16            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
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
     C                   Z-ADD     5             W0ERNB                         * DBERR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                       CCG015
      ** Determine if Correspondence Manager Phase 1 Development                              CCG015
      ** on iSeries is installed                                                              CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CCG015'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CCG015
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
      *                                                                                       CCG015
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL(P)  '*CALL'       W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
     C                   ENDIF
      *                                                                                       CLE031
      ** Determine if CLE031 is Installed                                                     CLE031
      *                                                                                       CLE031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE031
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE031            1
     C                   ELSE
     C                   MOVE      'N'           CLE031
      *                                                                                       CLE031
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL(P)  '*CALL'       W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE143
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
      *                                                                                       CER049
      ** Check if CER049 is ON                                                                CER049
      *                                                                                       CER049
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      'CER049'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER049
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CER049            1
     C                   ELSE
     C                   MOVE      'N'           CER049
      *                                                                                       CER049
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CER049'      W0KEY                          ***************
     C                   Z-ADD     19            W0ERNB                         * DB ERROR 17 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CER049
     C                   ENDIF
      *                                                                                       CER049
      ** Access SAR details file to determine if CER050 is installed.                         CER050
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CER050'      ##SARD
      *                                                                                       CER050
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CER050            1
     C                   ELSE
     C                   MOVEL     'N'           CER050
     C                   END
     C*
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
     C*
     C**  Determine Number of decimal places - Base currency.
     C*
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0
     C/COPY WNCPYSRC,CG6036C018
     C*
     C**  Copyright Statement.
     C*
     C                   MOVEA     CPY@          ACT@             80
     C*
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
     C*  Called by   :  LOANIS - Process Loan Interest Summary        *
     C*                 LOANEV - Process Loan Event Details           *
     C*                 LOANCF - Process Loan C/F Events              *
     C*                 LOANBF - Process Loan B/F Events              *
     C*                 LOAN   - Process Loan Details                 *
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
      *                                                                                       CCG015
      ** If CCG015 is installed move '*NEWARR' to W0ACT                                       CCG015
      ** else move '*PACK'.                                                                   CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    W0ACT
     C                   MOVEL     *BLANK        W0SPAT
     C                   ENDIF
     C*
     C**  Pack RDEs and associated data into data string.
     C*
     C                   CLEAR                   ##SDS
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
     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 06 *
     C                   Z-ADD     6             W0ERNB                         ************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
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
     C*  Called by   :  LOANIS - Process Loan Interest Summary        *
     C*                 LOANEV - Process Loan Event Details           *
     C*                 LOANCF - Process Loan C/F Events              *
     C*                 LOANBF - Process Loan B/F Events              *
     C*                 LOAN   - Process Loan Details                 *
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
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     S#PATH        W0PATH
     C*
     C**  Append Data from pack routine.
     C*
     C     W0FMT         CAT       #@SDS:0       W0FMT
      *                                                                                       CCG015
     C     CCG015        IFEQ      'N'
     C*
     C**  Output PF/CGUDTAPD Record.
     C*
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
     C                   MOVEL     ##RTCD        W0KEY                          * DBERR 07 *
     C                   Z-ADD     7             W0ERNB                         ************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
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
     C*  Called by   :  L05IN  - Lending Interest Advices             *
     C*                 LOANIS - Process Loan Interest Summary        *
     C*                 LOANID - Process Loan Interest Details        *
     C*                 LOANER - Process Loan Events                  *
     C*                 LOANEV - Process Loan Event Details           *
     C*                 LOANCF - Process Loan C/F Events              *
     C*                 LOANBF - Process Loan B/F Events              *
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
     C*  Called by   :  LOANIS - Process Loan Interest Summary        *
     C*                 LOANEV - Process Loan Event Details           *
     C*                 LOANCF - Process Loan C/F Events              *
     C*                 LOANBF - Process Loan B/F Events              *
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
     C                   Z-ADD     8             W0ERNB                         * DBERR 08 *
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
     C/COPY WNCPYSRC,CG6036C002
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
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT
     C/COPY CGCPYSRC,CGNWEXILE
     C/EJECT                                                                                  CCG015
** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
