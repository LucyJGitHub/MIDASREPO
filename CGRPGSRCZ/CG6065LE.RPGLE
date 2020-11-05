     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Lending consolidated confirmation extract')   *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6065LE - Lending Consolidated Confirmation Extract (ILE)   *
     F*                                                               *
     F*  Function:  This program extracts data for Consolidated       *
     F*  (COB)      Confirmations                                     *
     F*                                                               *
     F*  Called By: CG6061 - Lending Consolidated Confirmations       *
     F*                      Driver                                   *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CLE174             Date 23Oct20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 02Aug12               *
      *                 CLE141             Date 08Feb16               *
      *                 AR858383           Date 29Oct15               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CAS009             Date 16May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP074             Date 08Aug03               *
      *                 CLE031             Date 05Feb03               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU014             Date 26Jun98               *
      *                 CLE004             Date 02May97               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  CLE174 - Libor Deregulation - Lending                        *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement                 *
      *           (Amendable Payment Type)                            *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR858383 - Field PDDI and PTDI of PF/CLOANCL was overwritten *
      *             due to chain on PF/LOAMSDK before write to        *
      *             PF/CLOANCL. Rename the common fields between the  *
      *             two PF                                            *
      *           - Applied for MD35868 (CHILD: AR858384)             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.                               *
      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2 - Specific Base Rate*
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CLE031 - Lending Enhancements.                               *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CCG015 - Correspondence Manager Phase 1.                     *
      *  CSD006 - Recompiled over changed SDBSRTPD.                   *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
     F*  CEU014 - EMU User Defined Correspondence Enhancement         *
     F*  CLE004 - Syndications & Authorisations                       *
     F*                                                               *
     F*****************************************************************
     FLELOANL4  IF   E           K DISK    INFSR(SRFILE)
     F*                                                               *
     FCLOAN     UF   E           K DISK    INFSR(SRFILE)
     F                                     COMMIT
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     F*
     FLOAMS     IF   E           K DISK    INFSR(SRFILE)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
     F*
      /TITLE FUNCTION OF INDICATORS
     F*****************************************************************
     F*                                                               *
     F*  F U N  C T I O N    O F    I N D I C A T O R S               *
     F*                                                               *
     F*  88   -    No record found indicator for CLOAN file.          *
     F*  90   -    General work indicator.                            *
     F*  98   -    MMDDYY date format.                                *
     F*                                                               *
     F*****************************************************************
      /TITLE SUBROUTINE INDEX
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E    I N D E X                             *
     F*                                                               *
     F*  Main routine                                                 *
     F*  SRMAIN  -  Main Processing                                   *
     F*  VALCUS  -  Validate loans for the customer                   *
     F*  SRINIT  -  Initial Processing                                *
     F*  SRINZF  -  Initialise Fields on Each Invocation              *
     F*  SRDETL  -  Obtain Detail Information                         *
     F*  SELECT  -  Select values depending on rec type               *
     F*  ROLINT  -  Rollover Interest Rate                            *
     F*  L12CO   -  Lending Consolidated Confirmation                 *
     F*  LOANCO  -  Loan Action for Consolidated Confirmation         *
     F*  LOANC0  -  Loan                                              *
     F*  LOANA   -  Process Loan Associated Details                   *
     F*  SRSDET  -  Set-up Settlement Details                         *
     F*  SRADTA  -  Accumulate RDEs and Associated Data               *
     F*  SRODTA  -  Output Accumulated Data to PF/CGUDTAPD            *
     F*  SRBIND  -  Generate Binding Numbers                          *
     F*  SRPATH  -  Generate Path String                              *
     F*  SRRFMN  -  Reformat RDE Data                                 *
     F*  SRDCDT  -  Determine Currency Details                        *
     F*  SRGENR  -  Generate Reference Number                         *
     F*                                                               *
     F*****************************************************************
     D/EJECT
     D*****************************************************************
     D*
     D** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *                                                                                       CLE031
      ** Powers of Ten                                                                        CLE031
      *                                                                                       CLE031
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
     D*
     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
     D*
     D*   DS to for parameter PRPAR
     D                 DS
     D  WPARM                  1    100
     D  WRUN                   1      1
     D  WCUS                   2      7
     D**********                              8  130WFLN                                      CLE148
     D  WFLN                   8     13
     D**********                             14  190WTLN                                      CLE148
     D  WTLN                  14     19
     D*
     D**  Look-up string for RDE definition Array
     D*
     D ##SDS           DS
     D**********                              15120 ##S                                       CLE036
     D*
     D #@SDS           DS
     D**********                           51205120 #@S                                       CLE036
     D  #@S                 5632   5632
     D**  Packed data string.
     D*
     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
     D**  Number Field
     D*
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
     D** Used to convert item reference from character to numeric
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
     D** Loan details parameter for call to CG99LSET
     D*
     D PDETLS          DS           256
     D* Currency
     D  CCY                    1      3
     D* Customer Number
     D**********                              4   90CNUM                                      CSD027
     D  CNUM                   4      9
     D* Branch
     D  BRCA                  10     12
     D* Loan Processing Type
     D  PTYP                  13     14  0
     D*
     D** Settlement Instructions Parameter for call to CG99LSET
     D*
     D P0PARM          DS           768
     D* Pay - Branch
     D  P0POBR                 1      3
     D* Receipt - Branch
     D  P0ROBR                 4      6
     D* Receipt - Settlement Method
     D  P0RSTM                 7      8  0
     D* Receipt - Our Nostro
     D**********                              9  20 P0RONS                                    CGL029
     D  QQRONS                 9     20
     D* Receipt - Intermediary Bank
     D  P0RIBN                21     28
     D* Receipt - Intermediary Bank a/c
     D  P0RIBA                29     63
     D* Receipt - Ordering Bank No.
     D**********                             64  690P0ROBN                                    CSD027
     D  P0ROBN                64     69
     D* Receipt - Ordering Customer
     D**********                             70  750P0ROCN                                    CSD027
     D  P0ROCN                70     75
     D* Pay - Settlement Method
     D  P0PSTM                76     77  0
     D* Pay - Our Nostro
     D**********                             78  89 P0PONS                                    CGL029
     D  QQPONS                78     89
     D* Pay - Intermediary Bank
     D  P0PIBN                90     97
     D* Pay - Intermediary Bank a/c
     D  P0PIBA                98    132
     D* Pay - Ordering Bank No.
     D**********                            133 1380P0POBN                                    CSD027
     D  P0POBN               133    138
     D* Pay - Ordering Customer No.
     D**********                            139 1440P0POCN                                    CSD027
     D  P0POCN               139    144
     D* Receiver Correspondent No.
     D  P0RCRN               145    152
     D* Receiver Correspondent A/C 1
     D  P0RCRA               153    187
     D* Receiver Number
     D  P0RVNO               188    195
     D* A/C with Bank No.
     D  P0AWBN               196    203
     D* A/C with Bank A/C Line
     D  P0AWBA               204    238
     D* Beneficiary No.
     D  P0BENN               239    246
     D* Beneficiary A/C Line
     D  P0BENA               247    281
     D* Details of Pay 1
     D  P0DTP1               282    316
     D* Details of Pay 2
     D  P0DTP2               317    351
     D* Details of Pay 3
     D  P0DTP3               352    386
     D* Details of Pay 4
     D  P0DTP4               387    421
     D* Details of Charges
     D  P0DCHG               422    424
     D* Bank to Bank Info 1
     D  P0BTB1               425    459
     D* Bank to Bank Info 2
     D  P0BTB2               460    494
     D* Bank to Bank Info 3
     D  P0BTB3               495    529
     D* Bank to Bank Info 4
     D  P0BTB4               530    564
     D* Bank to Bank Info 5
     D  P0BTB5               565    599
     D* Bank to Bank Info 6
     D  P0BTB6               600    634
     D* Special Instruction 1
     D  P0SPI1               635    664
     D* Special Instruction 2
     D  P0SPI2               665    694
     D* Special Instruction 3
     D  P0SPI3               695    724
     D* Settlement Currency                                               CEU014
     D  P0STCY               725    727                                         CEU014
     D  P0PSCY               728    730
     D  P0RONS               731    748
     D  P0PONS               749    766
     D*
     D**  UDC Details for call to CG6001
     D*
     D P1PARM          DS           256
     D* Output Sequence
     D  P1OSEQ                 1      9  0
     D* UDC item number
     D  P1ITEM                10     17  0
     D* This bind level
     D  P1TBIN                18     25  0
     D* Previous bind level
     D  P1PBIN                26     33  0
     D*
     D**  Loan details Parameters for call to CG6001
     D*
     D P3PARM          DS           256
     D**  Loan Reference
     D  P3LNRF                 1      6
     D**  Cancel/Amend Field
     D  P3CNAM                 7      7
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
     D**  Named constants
     D*
     D W#PTYP          C                   CONST('LOAN CONF')
     D W#PST1          C                   CONST('CONSOLIDAT')
     D*
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
     D** External DS for incomplete reference
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  External DS for Bank details
     D*
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
     D**  External DS for currency details
     D*
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D**  External DS for base rate details
     D*
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    CEU014
     D* DS for GL ICD Details                                             CEU014
     D*                                                                   CEU014
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CEU014
     D**  External DS for customer details                                CEU014
     D*                                                                   CEU014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CEU014
     D** Switchable Feature details                                       CEU014
     D*                                                                   CEU014
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
     I*
     I*****************************************************************
     I/EJECT
     I*****************************************************************
     I*
     ICLOANCLF
     I** Rename fields on CLOANCL
     I              RECI                        LORECI
     I              RCDT                        LORCDT
     I              CNUM                        LOCNUM
     I              BRCA                        LOBRCA
     I              VDAT                        LOVDAT
     I              CHTP                        LOCHTP
     I              TNLU                        LOTNLU
     I              PDDI                        LOPDDI                                            AR
     I              PTDI                        LOPTDI                                            AR
     I              LNRF                        LOLNRF                                            AR
     I              ICCY                        LOICCY                                            AR
     I              RELI                        LORELI                                            AR
     I              REPI                        LOREPI                                            AR
     I*
     ICLOANCKF
     I** Rename fields on CLOANCK
     I              RECI                        L2RECI
     I              RCDT                        L2RCDT
     I              MRIN                        L2MRIN
     I              ORED                        L2ORED
     I              ZZ004                       L2ZZ04
     I              LCD                         L2LCD
     I              CHTP                        L2CHTP
     I              TNLU                        L2TNLU
     I*
     ILOAMSDKF
     I** Rename fields on LOAMS
     I              RECI                        LARECI
     I              VDAT                        LAVDAT
     I              LASN                        LALASN
     I              MRIN                        LAMRIN
     I              LTYP                        LALTYP
     I              SUTP                        LASUTP
     I              PTYP                        LAPTYP
     I              BRTT                        LABRTT
     I              RTSP                        LARTSP
     I              CCY                         LACCY
     I              BRCA                        LABRCA
     I              CNUM                        LACNUM
     I              REPT                        LAREPT
     I              AUTO                        LAAUTO
     I              FACO                        LAFACO
     I              BRTE                        LABRTE
     I              SPIN                        LASPIN
     I              WTIN                        LAWTIN
     I              FCUS                        LAFCUS
     I              FTYP                        LAFTYP
     I              FSEQ                        LAFSEQ
     I              INTC                        LAINTC
     I              NACD                        LANACD
     I              FCLB                        LAFCLB
     I              ORED                        LAORED
     I              LCD                         LALCD
     I              CHTP                        LACHTP
     I              TNLU                        LATNLU
     I              RSTM                        LARSTM
     I              RONS                        LAROSN
     I              RIBN                        LARIBN
     I              RIBA                        LARIBA
     I              ROBN                        LAROBN
     I              ROCN                        LAROCN
     I              PSTM                        LAPSTM
     I              PONS                        LAPONS
     I              PIBN                        LAPIBN
     I              PIBA                        LAPIBA
     I              POBN                        LAPOBN
     I              POCN                        LAPOCN
     I              RCRN                        LARCRN
     I              RCRA                        LARCRA
     I              RVNO                        LARVNO
     I              AWBN                        LAAWBN
     I              AWBA                        LAAWBA
     I              BENN                        LABENN
     I              BENA                        LABENA
     I              DTP1                        LADTP1
     I              DTP2                        LADTP2
     I              DTP3                        LADTP3
     I              DTP4                        LADTP4
     I              DCHG                        LADCHG
     I              BTB1                        LABTB1
     I              BTB2                        LABTB2
     I              BTB3                        LABTB3
     I              BTB4                        LABTB4
     I              BTB5                        LABTB5
     I              BTB6                        LABTB6
     I              CVMR                        LACVMR
     I              FSRP                        LAFSRP
     I              FSGN                        LAFSGN
     I              FPRC                        LAFPRC
     I              DFTP                        LADFTP
     I              DFST                        LADFST
     I              MNSG                        LAMNSG
     I              GASS                        LAGASS
     I              GPRT                        LAGPRT
     I              IUSR                        LAIUSR
     I              AUSR                        LAAUSR
     I              XUSR                        LAXUSR
     I              PCRF                        LAPCRF
     I              PCOB                        LAPCOB
     I              SPI1                        LASPI1
     I              SPI2                        LASPI2
     I              SPI3                        LASPI3
     I              SCCY                        LASCCY                          CEU014
     I              REXR                        LAREXR
     I              REXI                        LAREXI
     I              PSCY                        LAPSCY
     I              PEXR                        LAPEXR
     I              PEXI                        LAPEXI
     I              BASR                        LABASR
     I              SLTP                        LASLTP
     I              SLST                        LASLST
     I*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Process     :  MAINLINE                                      *
     C*  Function    :  Mainline processing                           *
     C*                                                               *
     C*  Called by   :  None                                          *
     C*  Calls       :  SRINIT - Initial Processing - On First Call   *
     C*                 SRINZF - Initialise Fields on Each Invocation *
     C*                 SRMAIN - Main Processing                      *
     C*****************************************************************
     C*
     C**  Parameter list for current program invocation.
     C*
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT             3
     C                   PARM                    PRENT             3
     C                   PARM                    PRPAR           100
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
     C*
     C**  Initial processing - Once Only
     C*
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
     C*
     C** Initialisation processing
     C*
     C                   EXSR      SRINZF
     C*
     C** Main processing
     C*
     C                   EXSR      SRMAIN
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C**  Terminate program
     C*
     C                   RETURN
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRMAIN                                        *
     C*  Function    :  Main processing                               *
     C*                                                               *
     C*  Called by   :  Mainline                                      *
     C*  Calls       :  VALCUS - Validate loans for the customer      *
     C*                 SRGENR - Generate reference number by writing *
     C*                          to PF/CGUDCRPD                       *
     C*                 L12CO  - Lending Consolidated Confirmation    *
     C*****************************************************************
     C     SRMAIN        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
     C*
     C*   If there are no valid loans, either no records on LELOANL4
     C*   file or all loans have Consolidated Confirmation flag set
     C*   to 'Y', then exit
     C                   MOVE      'N'           ##COPD
     C                   EXSR      VALCUS
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C**  Generate reference number by writing to PF/CGUDCRPD
     C**  If no confirmation to be produced, then bypass
     C*
     C                   MOVE      'N'           ##COPD
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C** Extract
     C*
     C                   EXSR      L12CO
     C*
     C     EXMAIN        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRDETL                                        *
     C*  Function    :  Process: Obtain detail information            *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SELECT - Select values depending on rec type  *
     C*              :  SRERR  - Database Error                       *
     C*****************************************************************
     C     SRDETL        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRDETL'      @STK(Q)
     C*
     C**   Access LOAMS file if this is an amendment
     C     RCDT          IFEQ      'A'
     C     CLOAMS        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    VDAT
     C                   KFLD                    LASN
     C*
     C     CLOAMS        CHAIN     LOAMS                              88
     C*
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'LOAMS   '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 08 *
     C                   Z-ADD     08            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
     C*
     C**   Access CLOANCK file if this is a rollover
     C     RCDT          IFEQ      'L'
     C     VDAT          ANDEQ     0
     C*
     C     LOANCK        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    L2RCDT
     C*
     C                   MOVEL     'B'           L2RCDT
     C     LOANCK        CHAIN     CLOAN                              88
     C*
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOANCK '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 11 *
     C                   Z-ADD     11            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        ACTCDE            2
     C*
     C                   EXSR      SELECT
     C*
     C     EXDETL        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SELECT                                        *
     C*  Function    :  Select values depending on record type        *
     C*                                                               *
     C*  Called by   :  SRDETL - Obtain Loan Details                  *
     C*  Calls       :  ROLINT -  Rollover Interest Rate              *
     C*****************************************************************
     C     SELECT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SELECT'      @STK(Q)
     C*
     C     RCDT          IFEQ      'L'
     C     VDAT          IFNE      0                                            LOAN
     C                   MOVE      VDAT          @@VDAT
     C                   MOVE      INTR          @@INTR
     C                   MOVE      CPAM          @@CPAM
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** save into work fields the settlement currency, exchange rate                         CLE031
      ** and indicator to be used for later conversion of Principal                           CLE031
      ** amount.                                                                              CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WPRFLG            1
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     72
     C                   MOVE      SCCY          WSETCY            3
     C                   Z-ADD     REXR          WEXCH            13 8
     C                   MOVE      REXI          WMD               1
     C                   MOVE      'R'           WPRFLG
     C                   ELSE
     C                   MOVE      PSCY          WSETCY
     C                   Z-ADD     PEXR          WEXCH
     C                   MOVE      PEXI          WMD
     C                   MOVE      'P'           WPRFLG
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C     CHTP          IFNE      'R'
     C                   MOVE      '01'          ACTCDE                         Start of Loan
     C                   ADD       CPAM          @@LBAL
     C                   ELSE
     C                   MOVE      '07'          ACTCDE                         Reverse Loann
     C                   SUB       CPAM          @@LBAL
     C                   ENDIF
     C     RLDT          IFNE      *ZERO
     C                   MOVE      RLDT          @@MDAT
     C                   ELSE
     C                   MOVE      MDAT          @@MDAT
     C                   ENDIF
     C*                                                    LOAN
     C                   ELSE
     C*                                                    ROLLOVER
     C                   MOVE      '06'          ACTCDE                         Rollover    n
     C                   MOVE      RLDT          @@VDAT
     C                   MOVE      NPRAM         @@CPAM
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** save into work fields the settlement currency, exchange rate                         CLE031
      ** and indicator to be used for later conversion of Principal                           CLE031
      ** amount.                                                                              CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WPRFLG
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     72
     C                   MOVE      RRSC          WSETCY
     C                   Z-ADD     RRSR          WEXCH
     C                   MOVE      RRSI          WMD
     C                   MOVE      'R'           WPRFLG
     C                   ELSE
     C                   MOVE      RPSC          WSETCY
     C                   Z-ADD     RPSR          WEXCH
     C                   MOVE      RPSI          WMD
     C                   MOVE      'P'           WPRFLG
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C                   EXSR      ROLINT
     C     NROD          IFNE      *ZERO
     C                   MOVE      NROD          @@MDAT
     C                   ELSE
     C                   MOVE      MDAT          @@MDAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  ROLLOVER
     C*
     C     RCDT          IFEQ      'A'                                          AMENDMENT
     C                   MOVE      VDAT          @@VDAT
     C                   Z-ADD     0             @@INTR
     C*
     C                   SELECT
     C     AMTP          WHENEQ    'PF'
     C                   MOVE      PRAM          @@CPAM
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** save into work fields the settlement currency, exchange rate                         CLE031
      ** and indicator to be used for later conversion of Principal                           CLE031
      ** amount.                                                                              CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WPRFLG
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     72
     C                   MOVE      LAPSCY        WSETCY
     C                   Z-ADD     LAPEXR        WEXCH
     C                   MOVE      LAPEXI        WMD
     C                   MOVE      'P'           WPRFLG
     C                   ELSE
     C                   MOVE      LASCCY        WSETCY
     C                   Z-ADD     LAREXR        WEXCH
     C                   MOVE      LAREXI        WMD
     C                   MOVE      'R'           WPRFLG
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C     CHTP          IFNE      'R'
     C                   MOVE      '02'          ACTCDE                         Prin Tr Fromn
     C                   SUB       PRAM          @@LBAL
     C                   ELSE
     C                   MOVE      '10'          ACTCDE                         Rvrs PT Fromn
     C                   ADD       PRAM          @@LBAL
     C                   ENDIF
     C*
     C     AMTP          WHENEQ    'PT'
     C                   MOVE      PRAM          @@CPAM
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** save into work fields the settlement currency, exchange rate                         CLE031
      ** and indicator to be used for later conversion of Principal                           CLE031
      ** amount.                                                                              CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WPRFLG
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     72
     C                   MOVE      LASCCY        WSETCY
     C                   Z-ADD     LAREXR        WEXCH
     C                   MOVE      LAREXI        WMD
     C                   MOVE      'R'           WPRFLG
     C                   ELSE
     C                   MOVE      LAPSCY        WSETCY
     C                   Z-ADD     LAPEXR        WEXCH
     C                   MOVE      LAPEXI        WMD
     C                   MOVE      'P'           WPRFLG
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C     CHTP          IFNE      'R'
     C                   MOVE      '03'          ACTCDE                         Prin Tr To  n
     C                   ADD       PRAM          @@LBAL
     C                   ELSE
     C                   MOVE      '09'          ACTCDE                         Rvrs PT To  n
     C                   SUB       PRAM          @@LBAL
     C                   ENDIF
     C*
     C     AMTP          WHENEQ    'RE'
     C                   MOVE      '04'          ACTCDE                         Repay Sched n
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** save into work fields the settlement currency, exchange rate                         CLE031
      ** and indicator to be used for later conversion of Principal                           CLE031
      ** amount.                                                                              CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WPRFLG
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     72
     C                   MOVE      LAPSCY        WSETCY
     C                   Z-ADD     LAPEXR        WEXCH
     C                   MOVE      LAPEXI        WMD
     C                   MOVE      'P'           WPRFLG
     C                   ELSE
     C                   MOVE      LASCCY        WSETCY
     C                   Z-ADD     LAREXR        WEXCH
     C                   MOVE      LAREXI        WMD
     C                   MOVE      'R'           WPRFLG
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C     CLE154        IFEQ      'N'
     C     REPT          IFEQ      1
     C                   MOVE      PRAM          @@CPAM
     C                   SUB       PRAM          @@LBAL
     C                   ELSE
     C                   MOVE      TAMT          @@CPAM
     C                   SUB       TAMT          @@LBAL
     C                   ENDIF
     C                   ELSE
     C     LAREPT        IFEQ      1
     C                   MOVE      PRAM          @@CPAM
     C                   SUB       PRAM          @@LBAL
     C                   ELSE
     C                   MOVE      TAMT          @@CPAM
     C                   SUB       TAMT          @@LBAL
     C                   ENDIF
     C                   END
     C*
     C     AMTP          WHENEQ    'PI'
     C                   MOVE      PRAM          @@CPAM
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** save into work fields the settlement currency, exchange rate                         CLE031
      ** and indicator to be used for later conversion of Principal                           CLE031
      ** amount.                                                                              CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WPRFLG
      *                                                                                       CLE031
      ** For parts sold loans.                                                                CLE031
      *                                                                                       CLE031
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     72
     C                   MOVE      LASCCY        WSETCY
     C                   Z-ADD     LAREXR        WEXCH
     C                   MOVE      LAREXI        WMD
     C                   MOVE      'R'           WPRFLG
     C                   ELSE
     C                   MOVE      LAPSCY        WSETCY
     C                   Z-ADD     LAPEXR        WEXCH
     C                   MOVE      LAPEXI        WMD
     C                   MOVE      'P'           WPRFLG
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C     CHTP          IFNE      'R'
     C                   MOVE      '05'          ACTCDE                         Prin Increase
     C                   ADD       PRAM          @@LBAL
     C                   ELSE
     C                   MOVE      '08'          ACTCDE                         Rvrs Pr Incre
     C                   SUB       PRAM          @@LBAL
     C                   ENDIF
     C                   ENDSL
     C*
     C                   ENDIF                                                  AMENDMENT
     C*
     C     SLTEND        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  ROLINT                                        *
     C*  Function    :  Calculate Rollover Interest Rate              *
     C*                                                               *
     C*  Called by   :  SELECT - Select values depending on rec type  *
     C*  Calls       :  AOBSRTR0 - Midas AP: Base Rate Codes          *
     C*****************************************************************
     C     ROLINT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'ROLINT'      @STK(Q)
     C*
     C     NBRA          IFEQ      *ZERO
     C     CLE036        ANDEQ     'N'
     C     NBRA          OREQ      *ZERO
     C     NBSR          ANDEQ     *ZERO
     C     CLE036        ANDEQ     'Y'
     C                   MOVE      NRTS          @@INTR
     C*
     C                   ELSE
     C     NBRA          IFNE      *ZERO
     C                   MOVE      NBRA          ##NBRA            2
     C*  Access SDBSRTPD file for Interest Base Rate table
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      CCY           ##CCY
     C                   PARM                    ##NBRA
     C     SDBSRT        PARM      SDBSRT        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C** Database error
     C                   MOVEL     'AOBSRTR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     12            W0ERNB                         * DB ERROR 12 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
      *                                                                                       CLE036
     C     NBSR          IFNE      *ZERO
     C     CLE036        ANDEQ     'Y'
     C                   Z-ADD     NBSR          BACBSR
     C                   ENDIF
     C*
     C                   SELECT
     C     NSIN          WHENEQ    'A'
     C     BACBSR        ADD       NRTS          @@INTR
     C     NSIN          WHENEQ    'S'
     C     BACBSR        SUB       NRTS          @@INTR
     C     NSIN          WHENEQ    'P'
     C     NRTS          DIV       100           @@INTR
     C                   MULT      BACBSR        @@INTR
     C                   OTHER
     C                   MOVE      BACBSR        @@INTR
     C                   ENDSL
     C*
     C                   ENDIF
     C*
     C     RINEND        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  VALCUS                                        *
     C*  Function    :  Check if there are valid loans for this       *
     C*                 customer                                      *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  None                                          *
     C*****************************************************************
     C     VALCUS        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'VALCUS'      @STK(Q)
     C*
     C*  Read through LELOANL4 file restricting on the branch and
     C*  customer.
     C*
     C     LEKEY         KLIST
     C                   KFLD                    PRENT
     C                   KFLD                    ##WCUS
     C*
     C     LEKEY         SETLL     LELOANL4
     C     LEKEY         READE     LELOANL4                               60
     C*
     C     *IN60         DOWEQ     '0'
     C*
     C*  Bypass record if loan number is the same as on the previous
     C*  record
     C     LNRF          IFEQ      ##LNRF
     C     LEKEY         READE     LELOANL4                               60
     C                   ITER
     C                   ELSE
     C                   MOVE      LNRF          ##LNRF
     C                   ENDIF
     C*
     C     LNRF          IFGE      WFLN
     C     LNRF          ANDLE     WTLN
     C*
     C     LOANCL        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    LORCDT
     C*
     C                   MOVEL     'A'           LORCDT
     C     LOANCL        CHAIN     CLOAN                              88
     C*
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOANCL '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 06 *
     C                   Z-ADD     06            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C*  If at least one loan with Consolidated Confirmation flag equal
     C*  'N' found, leave the loop and continue confirmation processing
     C*
     C     CNCF          IFEQ      'N'
     C                   MOVE      'Y'           ##COPD
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDIF
     C     LEKEY         READE     LELOANL4                               60
     C                   ENDDO
     C*
     C     EXVALC        TAG
     C**********           Z-ADD*ZEROS    ##LNRF                                              CLE148
     C                   MOVEL     *BLANKS       ##LNRF
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRGENR                                        *
     C*  Function    :  Generate reference number by writing to       *
     C*                 PF/CGUDCRPD                                   *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  CG9010 - Create reference record              *
     C*****************************************************************
     C     SRGENR        BEGSR
     C*
     C**  Set up subroutine stack name
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
     C** Booking/Main Branch (Mandatory)
     C*
     C                   MOVEL     PRENT         DRBRCA
     C*
     C** Originating Branch (Optional)
     C*
     C                   MOVEL     *BLANK        DRORBR
     C*
     C** Module identifier (Mandatory)
     C*
     C                   MOVEL     'LE'          DRMODI
     C*
     C** Midas Transaction Number (Mandatory)
     C*
     C                   MOVEL     *BLANK        DRMTRN
     C*
     C                   MOVEL     W#PTYP        DRPTYP                         * print type
     C*
     C                   MOVEL     W#PST1        DRPSTP                         * print s/type
     C*
     C** Auto Transmission indicator
     C*
     C                   MOVEL     'N'           DRATRM
     C*
     C** Customer Number (Mandatory)
     C*
     C                   MOVEL     WCUS          ##CUST
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
      ** Pass reference as printtype:subtype                                                  CCG015
      *                                                                                       CCG015
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C*
     C                   ELSE
     C*
     C     ##RTCD        IFNE      'CGD1270'
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          ***************
     C                   Z-ADD     05            W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1286'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXGENR        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  L12CO                                         *
     C*  Function    :  Process: Lending Consolidated Confirmation    *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRSDET - Set-up Settlement Details            *
     C*                 LOANCO - Loan Action for Consolidated         *
     C*                          Confirmation                         *
     C*                 LOANA  - Process Loan Associated Details      *
     C*****************************************************************
     C     L12CO         BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L12CO '      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'l12CO '      ##GRPS
     C*
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   EXSR      LOANCO
     C*
     C                   EXSR      SRSDET
     C*
     C                   EXSR      LOANA
     C*
     C**  Decrement Path DS index
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  LOANCO                                        *
     C*  Function    :  Process: Loan                                 *
     C*                                                               *
     C*  Called by   :  L12CO  - Loan Consolidated Confirmation       *
     C*  Calls       :  SRDETL - Obtain detail information            *
     C*                 LOANC0 - Process: Loan                        *
     C*                 SRPATH - Generate path string                 *
     C*                 SRBIND - Generate binding numbers             *
     C*****************************************************************
     C     LOANCO        BEGSR
     C*
     C**  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'LOANCO'      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANCO'      ##GRPS
     C*
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C*  Read through LELOANL4 file restricting on the branch and
     C*  customer. For each valid loan produce a UDC extract.
     C*
     C     LEKEY         SETLL     LELOANL4
     C     LEKEY         READE     LELOANL4                               60
     C*
     C     *IN60         DOWEQ     '0'
     C*
     C     LNRF          IFEQ      ##LNRF
     C*  If this record is the same as the previous one
     C*  or if this loan doesn't satisfy the selection criteria
     C*  bypass this record
     C     RCDT          IFEQ      ##RCDT
     C     VDAT          ANDEQ     ##VDAT
     C     LASN          ANDEQ     ##LASN
     C     CHTP          ANDEQ     ##CHTP
     C     ##CNCF        OREQ      'Y'
     C     LEKEY         READE     LELOANL4                               60
     C                   ITER
     C                   ELSE
     C*  If the loan number is the same as on the previous record
     C*  don't access CLOANCL file, but produce confirmation
     C                   EXSR      SRDETL
     C                   EXSR      SRBIND
     C                   EXSR      LOANC0
     C                   ENDIF
     C*  New loan
     C                   ELSE
     C*
     C                   MOVE      RCDT          ##RCDT
     C                   MOVE      LNRF          ##LNRF
     C                   MOVE      VDAT          ##VDAT
     C                   MOVE      LASN          ##LASN
     C                   MOVE      CHTP          ##CHTP
     C                   MOVE      'Y'           ##CNCF
     C*
     C*  Check if the loan reference is in the specified range
     C     LNRF          IFGE      WFLN
     C     LNRF          ANDLE     WTLN
     C*
     C*  Access CLOANCL file for Consolidated Confirmations flag
     C*
     C     LOANCL        CHAIN     CLOAN                              88
     C*
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOANCL '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 06 *
     C                   Z-ADD     06            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     CNCF          IFEQ      'N'
     C                   MOVE      'N'           ##CNCF
     C                   MOVE      CCY           @@CCY             3
     C                   Z-ADD     0             @@CPAM           13 0
     C                   Z-ADD     0             @@LBAL           13 0
     C                   Z-ADD     0             @@MDAT            5 0
     C                   Z-ADD     0             @@INTR           11 7
     C                   Z-ADD     0             @@VDAT            5 0
     C                   EXSR      SRDETL
     C                   EXSR      SRBIND
     C                   EXSR      LOANC0
     C*
     C*  Read CLOANCL format if CLOANCK was read for rollover
     C     RCDT          IFEQ      'L'
     C     VDAT          ANDEQ     0
     C     LOANCL        CHAIN     CLOAN                              88
     C                   ENDIF
     C* Update Consolidated Confirmation flag on CLOANCLF
     C                   MOVE      'Y'           CNCF
     C                   UPDATE    CLOANCLF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     LEKEY         READE     LELOANL4                               60
     C                   ENDDO
     C*
     C**  Decrement Path DS index
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  LOANC0                                         *
     C* Function    :  Process: Loan                                  *
     C*                                                               *
     C* Called by   :  LOANCO - Loan Action for Consolidated Conf     *
     C* Calls       :  SRPATH - Generate Path String                  *
     C*                SRDCDT - Determine Currency Details            *
     C*                SRADTA - Accumulate RDEs and Associated Data   *
     C*                SRODTA - Output Accumulated Data to            *
     C*                         PF/CGUDTAPD                           *
     C*****************************************************************
     C     LOANC0        BEGSR
     C*
     C**  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'LOANC0'      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANC0'      ##GRPS
     C*
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
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
     C*
     C* Action Decription
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'C '          #@RDE
     C                   MOVEL     'ACTN DES'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ACTCDE        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Current Principal (Amount)
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'CL'          #@RDE
     C                   MOVEL     'CUR PRIN'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     @@CPAM        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     @@CCY         ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Currency
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CURRENCY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     @@CCY         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Interest Rate
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     @@INTR        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Loan Balance
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOAN BAL'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     @@LBAL        ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     @@CCY         ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Loan Reference
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
     C* Maturity Date
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'MATUR DA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     @@MDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Value Date
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'VALUE DA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     @@VDAT        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*                                                                   CEU014
     C** The settlement currency ##SETL will be taken from the loan.      CEU014
     C** So loan amendments and rollovers will have the settlement        CEU014
     C** equivalent amounts calculated in the settlement currency of      CEU014
     C** the loan, rather than that of the loan rollover or amendment.    CEU014
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C                   MOVEL     SCCY          ##SETL            3                           CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
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
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** instead of using ##SETL, which has data from loan regardless                         CLE031
      ** if processing a loan amendment or rollover, use the saved                            CLE031
      ** currency from SRSDET.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
      ** Retrieve the currency details of Loan Currency                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WLINCY            1
     C     @@CCY         IFNE      *BLANKS
     C                   MOVEL     @@CCY         ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6INCY        WLINCY
     C                   Z-ADD     A6NBDP        WLNBDP            1 0
     C                   ENDIF
      *                                                                                       CLE031
      ** Conversion is done only if Derived Settlement currency is                            CLE031
      ** non-blank.                                                                           CLE031
      *                                                                                       CLE031
     C     WSETCY        IFNE      *BLANKS
      *                                                                                       CLE031
      ** Retrieve the currency details of Derived Settlement Currency                         CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WSINCY            1
     C                   MOVEL     WSETCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6INCY        WSINCY
     C                   Z-ADD     A6NBDP        WSNBDP            1 0
      *                                                                                       CLE031
      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
      ** is satisfied:                                                                        CLE031
      ** 1. Loan currency is 'In' currency                                                    CLE031
      ** 2. Derived settlement currency is 'In' currency                                      CLE031
      *                                                                                       CLE031
     C     WLINCY        IFEQ      'Y'
     C     WSINCY        OREQ      'Y'
      *                                                                                       CLE031
     C                   Z-ADD     @@CPAM        P@FRAM
     C                   MOVE      @@CCY         P@FRCY
     C                   MOVE      WSETCY        P@TOCY
     C                   EXSR      D@EURO
     C                   MOVEL     ##OUTA        ##DATA
     C                   MOVEL     WSNBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ELSE
      *                                                                                       CLE031
      ** If the above condition is not satisfied, convert the Current Principal               CLE031
      ** using ZCONV and the saved settlement exchange rate and indicator in                  CLE031
      ** subroutine SELECT.                                                                   CLE031
     C                   Z-ADD     WEXCH         ZEXCH
     C                   MOVE      WMD           ZMD
     C                   Z-ADD     @@CPAM        ZAMTCI
     C                   MOVE      @@CCY         ZCCYI
     C                   MOVE      WSETCY        ZCCYO
     C                   Z-ADD     WLNBDP        ZCDPI
     C                   Z-ADD     WSNBDP        ZCDPO
      *                                                                                       CLE031
     C                   EXSR      ZCONV
      *                                                                                       CLE031
     C                   MOVEL     ZAMTCO        ##DATA
     C                   MOVEL     WSNBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     ##SETL        ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     ##SETL        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     @@CPAM        P@FRAM                                        CEU01
     C                   MOVE      @@CCY         P@FRCY                                        CEU01
     C                   MOVE      ##SETL        P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C                   ENDIF
     C*                                                                   CEU014
     C** Loan Balance in Settlement Currency                              CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'L_BAL_SC'    #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
      *                                                                                       CLE031
      ** If Lending Enhancements is installed                                                 CLE031
      ** Loan Balance will be converted to Settlement Currency.                               CLE031
      ** Settlement Currency may be the Receipt Settlement Currency                           CLE031
      ** or the Pay Settlement Currency from CLOANCL.                                         CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C     WPRFLG        IFEQ      'R'
      *                                                                                       CLE031
      ** Retrieve the currency details of Receipt Settlement Currency                         CLE031
      ** from CLOANCL.                                                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      SCCY          WSETCY
     C                   Z-ADD     REXR          WEXCH
     C                   MOVE      REXI          WMD
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** Retrieve the currency details of Pay Settlement Currency                             CLE031
      ** from CLOANCL.                                                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      PSCY          WSETCY
     C                   Z-ADD     PEXR          WEXCH
     C                   MOVE      PEXI          WMD
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
      ** Conversion is done only if Settlement Currency from CLOANCL is                       CLE031
      ** non-blank.                                                                           CLE031
      *                                                                                       CLE031
     C     WSETCY        IFNE      *BLANKS
      *                                                                                       CLE031
      ** Retrieve the currency details of Settlement Currency                                 CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       WSINCY
     C                   MOVEL     WSETCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6INCY        WSINCY
     C                   Z-ADD     A6NBDP        WSNBDP            1 0
      *                                                                                       CLE031
      ** Convert by calling EU0200 if either of the two following conditions                  CLE031
      ** is satisfied:                                                                        CLE031
      ** 1. Loan currency is 'In' currency                                                    CLE031
      ** 2. Derived settlement currency is 'In' currency                                      CLE031
      *                                                                                       CLE031
     C     WLINCY        IFEQ      'Y'
     C     WSINCY        OREQ      'Y'
      *                                                                                       CLE031
     C                   Z-ADD     @@LBAL        P@FRAM
     C                   MOVE      @@CCY         P@FRCY
     C                   MOVE      WSETCY        P@TOCY
     C                   EXSR      D@EURO
     C                   MOVEL     ##OUTA        ##DATA
     C                   MOVEL     WSNBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      ** If the above condition is not satisfied, convert the Loan Balance                    CLE031
      ** using ZCONV and the settlement exchange rate and indicator from                      CLE031
      ** CLOANCL.                                                                             CLE031
     C                   Z-ADD     WEXCH         ZEXCH
     C                   MOVE      WMD           ZMD
     C                   Z-ADD     @@LBAL        ZAMTCI
     C                   MOVE      @@CCY         ZCCYI
     C                   MOVE      WSETCY        ZCCYO
     C                   Z-ADD     WLNBDP        ZCDPI
     C                   Z-ADD     WSNBDP        ZCDPO
      *                                                                                       CLE031
     C                   EXSR      ZCONV
      *                                                                                       CLE031
     C                   MOVEL     ZAMTCO        ##DATA
     C                   MOVEL     WSNBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     ##SETL        ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     ##SETL        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     @@LBAL        P@FRAM                                        CEU01
     C                   MOVE      @@CCY         P@FRCY                                        CEU01
     C                   MOVE      ##SETL        P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C                   ENDIF
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C*                                                                   CEU014
     C** determine the Equivalent Currency                                CEU014
     C*                                                                   CEU014
     C                   MOVE      *BLANKS       EQCY              3                           CEU01
     C                   MOVE      @@CCY         ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C     A6INCY        IFEQ      'Y'                                                         CEU01
     C                   MOVE      BKEURO        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C     @@CCY         IFEQ      BKEURO                                                      CEU01
     C                   MOVEL     CNUM          ##KEY                                         CEU01
     C                   CALL      'AOCUSTR0'                                                  CEU01
     C                   PARM      *BLANKS       ##RTCD                                        CEU01
     C                   PARM      '*KEY   '     ##OPTN                                        CEU01
     C                   PARM                    ##KEY            10                           CEU01
     C                   PARM      *BLANKS       ##KYST            7                           CEU01
     C     SDCUST        PARM      SDCUST        DSSDY                                         CEU01
     C*                                                                   CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
     C                   MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
     C                   MOVEL     CNUM          W0KEY                          ************   CEU01
     C                   Z-ADD     16            W0ERNB                         * DBERR 16 *   CEU01
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
     C                   Z-ADD     @@CPAM        P@FRAM                                        CEU01
     C                   MOVE      @@CCY         P@FRCY                                        CEU01
     C                   MOVE      EQCY          P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C** Loan Balance in Equivalent Currency                              CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'L_BAL_EQ'    #@RDE                                         CEU01
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
     C                   Z-ADD     @@LBAL        P@FRAM                                        CEU01
     C                   MOVE      @@CCY         P@FRCY                                        CEU01
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
     C/COPY WNCPYSRC,CG6065C001
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     A6CYNM        ##DATA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*
     C/COPY WNCPYSRC,CG6065C002
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
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      **  Decrement Path DS index
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
     C                   EXSR      POPGRS
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
     C*****************************************************************
     C*  Subroutine  :  LOANA                                         *
     C*  Function    :  Process: Loan Associated Details              *
     C*                                                               *
     C*  Called by   :  L12CO  - Loan Consolidated Confirmation       *
     C*                          Confirmation                         *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 CG6001 - General Loan Details                 *
     C*****************************************************************
     C     LOANA         BEGSR
     C*
     C**  Set up subroutine stack name
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
     C                   CLEAR                   P3PARM
     C                   CLEAR                   P4PARM
     C                   MOVE      LNRF          P3LNRF
     C                   CALL      'CG6001'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    P1PARM                         UDC Details
     C                   PARM                    P2PARM          140            Path Details
     C                   PARM                    P3PARM                         Loan Details
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
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRSDET                                        *
     C*  Function    :  Set-up settlement details.                    *
     C*                                                               *
     C*  Called by   :  L12CO  - Loan Consolidated Confirmation       *
     C*  Calls       :  CG99LSET - To set-up settlement details       *
     C*****************************************************************
     C     SRSDET        BEGSR
     C*
     C**  Set up subroutine stack name
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
     C** Setup the parameters for CG99LSET
     C*
     C                   CLEAR                   P0PARM
     C                   MOVEL     OSDB          P0POBR
     C                   MOVEL     OMDB          P0ROBR
     C                   Z-ADD     RSTM          P0RSTM
     C                   MOVEL     RONS          P0RONS
     C                   MOVEL     RIBN          P0RIBN
     C                   MOVEL     RIBA          P0RIBA
     C**********           Z-ADDROBN      P0ROBN                                              CSD027
     C**********           Z-ADDROCN      P0ROCN                                              CSD027
     C                   MOVE      ROBN          P0ROBN
     C                   MOVE      ROCN          P0ROCN
     C                   Z-ADD     PSTM          P0PSTM
     C                   MOVEL     PONS          P0PONS
     C                   MOVEL     PIBN          P0PIBN
     C                   MOVEL     PIBA          P0PIBA
     C**********           Z-ADDPOBN      P0POBN                                              CSD027
     C**********           Z-ADDPOCN      P0POCN                                              CSD027
     C                   MOVE      POBN          P0POBN
     C                   MOVE      POCN          P0POCN
     C                   MOVEL     RCRN          P0RCRN
     C                   MOVEL     RCRA          P0RCRA
     C                   MOVEL     RVNO          P0RVNO
     C                   MOVEL     AWBN          P0AWBN
     C                   MOVEL     AWBA          P0AWBA
     C                   MOVEL     BENN          P0BENN
     C                   MOVEL     BENA          P0BENA
     C                   MOVEL     DTP1          P0DTP1
     C                   MOVEL     DTP2          P0DTP2
     C                   MOVEL     DTP3          P0DTP3
     C                   MOVEL     DTP4          P0DTP4
     C                   MOVEL     DCHG          P0DCHG
     C                   MOVEL     BTB1          P0BTB1
     C                   MOVEL     BTB2          P0BTB2
     C                   MOVEL     BTB3          P0BTB3
     C                   MOVEL     BTB4          P0BTB4
     C                   MOVEL     BTB5          P0BTB5
     C                   MOVEL     BTB6          P0BTB6
     C                   MOVEL     SPI1          P0SPI1
     C                   MOVEL     SPI2          P0SPI2
     C                   MOVEL     SPI3          P0SPI3
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     CLE031        OREQ      'Y'
     C                   MOVEL     SCCY          P0STCY                                        CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
     C                   MOVEL     PSCY          P0PSCY
     C                   ENDIF
     C*
     C** Set-up UDC Details
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
     C*
     C** Database error
     C*
     C                   MOVEL     'CG99LSET'    W0FILE
     C                   MOVEL     'W0RTN'       W0KEY                          ***************
     C                   Z-ADD     07            W0ERNB                         * DB ERROR 07 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
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
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRINZF                                        *
     C*  Function    :  Initialise Fields on Program Invocation       *
     C*                                                               *
     C*  Called by   :  Mainline                                      *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRINZF        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINZF'      @STK(Q)
     C*
     C**  Initialise work fields
     C*
     C                   MOVE      PRPAR         WPARM
     C**********           MOVE WCUS      ##WCUS  60                                          CSD027
     C                   MOVE      WCUS          ##WCUS            6
     C*
     C                   MOVE      'Y'           ##CNCF            1
     C                   MOVE      *BLANKS       ##RCDT            1
     C**********           Z-ADD*ZEROS    ##LNRF  60                                          CLE148
     C                   MOVEL     *BLANKS       ##LNRF            6
     C                   Z-ADD     *ZEROS        ##VDAT            5 0
     C                   Z-ADD     *ZEROS        ##LASN            3 0
     C                   MOVE      *BLANKS       ##CHTP            1
     C                   MOVE      *BLANKS       ##COPD            1
     C                   MOVE      *BLANKS       ##AUTO            1
     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        ##W157           15 7
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
     C*
     C**  Initialise output sequence (to CGUDTAPD)
     C*
     C                   Z-ADD     *ZEROS        ##OSEQ
     C*
     C** DJU Additions for CG4999 1st version **
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
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRINIT                                        *
     C*  Function    :  Initial processing - First Call Only          *
     C*                                                               *
     C*  Called by   :  Mainline                                      *
     C*  Calls       :  SRERR  - Report Error and Close Down Program  *
     C*                 SRDCDT - Determine Currency Details           *
     C*****************************************************************
     C     SRINIT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
     C*
     C** Call access program for Bank details
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C*
     C** Database error
     C*
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     01            W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
     C*
     C**   Determine Number of decimal places - Base currency
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
     C                   Z-ADD     13            W0ERNB                         * DB ERROR 13 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU014
      ** Check if CEU014 - EMU UDC Enhancement - is switched on           CEU014
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
     C                   Z-ADD     14            W0ERNB                         * DBERR 14 *   CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ************   CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CCG015
      ** Check if CCG015 is ON                                                                CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CCG015'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CCG015
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     17            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
      ** Check if CLE005 (Lending Enhancements - Tranche 3)                                   CLE031
      ** is on.                                                                               CLE031
      *                                                                                       CLE031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE005'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE031
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     18            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
      ** Check if CLE031 (Lending Enhancements)                                               CLE031
      ** is on.                                                                               CLE031
      *                                                                                       CLE031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE031
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE031            1
     C                   ELSE
     C                   MOVE      'N'           CLE031
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     19            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE036
      ** Check if CLE036 is installed.                                                        CLE036
      *                                                                                       CLE036
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE036'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE036
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE036            1
     C                   ELSE
     C                   MOVE      'N'           CLE036
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     20            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE154
      ** Check if CLE154 is installed.                                                        CLE154
      *                                                                                       CLE154
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE154'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE154
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CLE154            1
     C                   ELSE
     C                   MOVE      'N'           CLE154
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     20            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C*
     C**  Copyright
     C                   MOVEA     CPY@          ACT@             80
     C*
     C     EXINIT        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRADTA                                        *
     C*  Function    :  Accumulate RDEs and associated data for output*
     C*                                                               *
     C*  Called by   :  LOANC0 - Process Loan                         *
     C*  Calls       :  CG3999 - Format and Pack Data                 *
     C*                 SRRFMN - Reformat RDE Data                    *
     C*                 SRERR  - Database Error                       *
     C*****************************************************************
     C     SRADTA        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRADTA'      @STK(Q)
     C*
     C**  Reformat RDE data
     C*
     C                   EXSR      SRRFMN
     C*
     C**  Pack RDEs and associated data into data string
     C*
     C                   CLEAR                   ##SDS
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    W0ACT
     C                   MOVEL     *BLANK        W0SPAT
     C                   ENDIF
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
     C**  Database error
     C*
     C     ##RTCD        IFNE      *BLANK
     C*
     C                   MOVEL     'CG3999  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     02            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   EXSR      WRTRDE
     C*
     C**  Append Data from pack routine.
     C*
     C     #@SDS         CAT       ##SDS:0       #@SDS
     C*
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
     C*
     C     EXADTA        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRODTA                                        *
     C*  Function    :  Output Accumulated data to PF/CGUDTAPD        *
     C*                                                               *
     C*  Called by   :  LOANC0 - Process Loan                         *
     C*  Calls       :  CG9020 - Output Data to CGUDTAPD              *
     C*                 SRERR  - Database Error                       *
     C*****************************************************************
     C     SRODTA        BEGSR
     C*
     C**  Set up subroutine stack name
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
     C**  Database error
     C*
     C     ##RTCD        IFNE      *BLANK
     C*
     C                   MOVEL     'CG9020  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     03            W0ERNB                         ***************
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
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRBIND                                        *
     C*  Function    :  Generate Binding numbers                      *
     C*                                                               *
     C*  Called by   :  All Repeating Group Set Subroutines           *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRBIND        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRBIND'      @STK(Q)
     C*
     C     P1            SUB       1             P2
     C     P2            OCCUR     ##BIND
     C*
     C                   Z-ADD     ##TBIN        #@TBIN
     C     P1            OCCUR     ##BIND
     C                   Z-ADD     #@TBIN        ##PBIN
     C*
     C                   ADD       1             #@BIND
     C                   Z-ADD     #@BIND        ##TBIN
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRPATH                                        *
     C*  Function    :  Generate Path String /GS1/GS2...              *
     C*                                                               *
     C*  Called by   :  L12CO  - Loan Consolidated Confirmation       *
     C*                 LOANCO - Loan Action Consolidated Conf        *
     C*                 LOANC0 - Process Loan                         *
     C*                 LOANA  - Process Loan Associated Details      *
     C*                 SRSDET - Set-up settlement details            *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRPATH        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)
     C*
     C                   CLEAR                   S#PATH
     C*
     C                   DO        P1            P2
     C     P2            OCCUR     ##PATH
     C     S#PATH        CAT       '\':0         S#PATH
     C     S#PATH        CAT       ##GRPS:0      S#PATH
     C                   END
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRRFMN                                        *
     C*  Function    :  Reformat RDE data                             *
     C*                                                               *
     C*  Called by   :  SRADTA - Accumulate RDEs and associated       *
     C*                          data for outout                      *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRRFMN        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRRFMN'      @STK(Q)
     C*
     C** Loop through RDE's and data
     C*
     C                   Z-ADD     0             #1
     C     #1            DOUEQ     20
     C                   ADD       1             #1
     C                   MOVEL     ##R(#1)       R#DEFN
     C                   MOVEL     ##D(#1)       R#DATA
     C*
     C** If data present and RDE is edited
     C*
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
     C*
     C** Reformat Amount
     C*
     C                   Z-ADD     1             #2
     C     *BLANK        LOOKUP    ##NUMA(#2)                             99    *
     C                   Z-ADD     20            #3
     C                   Z-ADD     0             ##WNUM
     C     #2            DOWGT     1
     C     #2            ANDLE     20
     C     #3            ANDGT     1
     C                   SUB       1             #2
     C                   MOVEL     ##NUMA(#2)    ##W(#3)
     C                   SUB       1             #3
     C                   ENDDO
     C*
     C** Sign the amount
     C*
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     ##WNUM        ##NUMB
     C                   ELSE
     C                   Z-ADD     ##WNUM        ##NUMB
     C                   END
     C*
     C** Default Edit Type
     C*
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   END
     C*
     C** Default Decimal Places
     C*
     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   END
     C*
     C** New RDE data
     C*
     C                   MOVEL     R#DATA        ##D(#1)
     C                   ENDIF
     C                   ENDDO
     C*
     C     EXRFMN        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRDCDT                                        *
     C*  Function    :  Determine Currency Details                    *
     C*                                                               *
     C*  Called by   :  LOANC0 - Loan Details                         *
     C*                 SRINIT - Initial Processing - On First Call   *
     C*  Calls       :  SRERR  - Database Error                       *
     C*****************************************************************
     C     SRDCDT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
     C*
     C**  Access array of Currency Details already loaded
     C*
     C                   Z-ADD     1             C                 3 0
     C     ##CCY         LOOKUP    ##CY(C)                                99
     C*
     C**  If no match is found determine the next free space in the
     C**  loaded currency array.
     C*
     C     *IN99         IFEQ      *OFF
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
     C**  Database Error
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY                          ***************
     C                   Z-ADD     04            W0ERNB                         * DB ERROR 04 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
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
     C*
     C     EXDCDT        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5                                                            CEU014
      *****************************************************************   CEU014
      * Subroutine  :  D@EURO                                         *   CEU014
      * Function    :  EURO Currency Conversion:                      *   CEU014
      * Converts amount P@FRAM in P@FRCY to ##OUTA in P@TOCY          *   CEU014
      * Called by   :  LOANC0                                         *   CEU014
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
     C                   Z-ADD     15            W0ERNB                         * DB ERROR 15 *CEU01
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
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT
     C/COPY CGCPYSRC,CGNWEXILE
     C/EJECT                                                                                  CCG015
     C/COPY ZSRSRC,ZCONVZ1ILE
     C/EJECT                                                                                  CLE031
** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION                                           CLE031
0000001                                                                                       CLE031
0000010                                                                                       CLE031
0000100                                                                                       CLE031
0001000                                                                                       CLE031
0010000                                                                                       CLE031
0100000                                                                                       CLE031
1000000                                                                                       CLE031
