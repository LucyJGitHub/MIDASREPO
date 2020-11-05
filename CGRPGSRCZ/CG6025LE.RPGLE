     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Lending rollover confirmations')              *
      *****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6025LE - Lending Rollover Confirmations (ILE)              *
     F*                                                               *
     F*  Function:  This program extracts data for Rollover Confirma- *
     F*  ( COB )    tions.                                            *
     F*                                                               *
     F*  Called By: CG6020 - Lending Rollover Confirmations Driver    *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CLE174             Date 23Oct20               *
      *  Prev Amend No. MD054660           Date 19Nov19               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 06Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR873925           Date 09Dec11               *
      *                 AR823507           Date 01Sep11               *
      *                 AR822053           Date 29Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240327             Date 16Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 06May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9646            Date 20Dec05               *
      *                 BUG7960            Date 25Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3858            Date 02Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP075             Date 08Aug02               *
      *                 CLE031             Date 21Feb03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CLE011             Date 07Nov00               *
      *                 186892             Date 20Dec00               *
     F* Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 163486             Date 13Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CEU014             Date 19JUN98               *
     F*                 CLE005             Date 22May97               *
     F*                 S01408             Date 04SEP96               *
     F*                 S01408             Date 10JUL96               *
     F*                 CCG008 *CREATE     Date 30OCT95               *
     F*                                                               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  CLE174 - Libor Deregulation - Lending                        *
      *  MD054660 - Incorrect Next Interest Repayment Date for loans  *
      *             with repayment type 1 or 3.                       *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR873925 - Rolllover confirmation did not capture the        *
      *             rounding details when base rate was amended       *
      *  AR823507 - Component CGC2050 00017 failed                    *
      *  AR822053 - Incorrect value of Effective Annual Interest Rate *
      *             in CGUXMLPD                                       *
      *  CER049 - Stamp Tax (Portuguese Features Upgrade)             *
      *  CRE073 - Portuguese Feature - Interest Rate Rounding         *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  240327 - UDC dumps. Fix is to avoid subtype being blank.     *
      *           Applied fix 224773. Applied as BUG7960.             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9646- Changes in CGPACKE causes programs not to compile   *
      *  BUG7960- Missing processing for other loan types.            *
      *           Applied fix 224773.                                 *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3858 - DB error in EU0200, called from CG6025.            *
      *            Applied gems fix 228649 (allow blank sett. ccy)    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP075 - Lending API enhancements - Loan Amendment.          *
      *           (amendment in common with CAP079)                   *
      *  CLE031 - Lending Enhancements.                               *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CCG015 - Correspondence Manager Phase 1.                     *
      *  CSD006 - Recompiled over changed SDCURRPD.                   *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
     F*  186892 - Extract RDE for Maturity Date.                      *
     F*         - Partially apply fix 178756.                         *
     F*  163486 - Recompile due to changes in LVENTEL.                *
     F*  CEU014 - EMU User Defined Correspondence Enhancement.        *
     F*  CLE005 - Customer Lending Enhancements - Others (T3)         *
     F*  S01408 - Core hook CG6025CCP5 added.                         *
     F*           Core hook CG6025CCP4 added.                         *
     F*           Core hook CG6025CCP3 added.                         *
     F*  S01408 - Core hook CG6025IIP1 added.                         *
     F*           Core hook CG6025CCP1 added.                         *
     F*           Core hook CG6025CCP2 added.                         *
     F*  CCG008 - User Defined Correspondence - Lending               *
     F*                                                               *
     F*****************************************************************
     FCLOAN     IF   E           K DISK    INFSR(SRFILE)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     FLVNTROL   IF   E           K DISK
      *                                                                                       CER049
      ** Stamp Tax file                                                                       CER049
      *                                                                                       CER049
     FCLONCLL1  IF   E           K DISK
      *                                                                                       CER049
     FLEAPRHI0  IF   E           K DISK
      *                                                                                       CER050
     F/COPY WNCPYSRC,CG6025F001
     F/TITLE FUNCTION OF INDICATORS
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N    O F    I N D I C A T O R S                *
     F*                                                               *
     F*  90   -    Record not foung on LF/CLOAN                       *
     F*  91   -    End of LF/LVNTROL                                  *
     F*  99   -    General error indicator                            *
     F*                                                               *
     F*****************************************************************
     F/TITLE SUBROUTINE INDEX
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E    I N D E X                             *
     F*                                                               *
     F*  Main routine                                                 *
     F*  SRINIT  -  Initial Processing - On First Call                *
     F*  SRINZ   -  Initialise Fields on Each Invocation              *
     F*  SRMAIN  -  Main Processing                                   *
     F*  SRDETL  -  Obtain Detail Information                         *
     F*  L03RO   -  Process Lending Rollover Confirmations            *
     F*  LOANRO  -  Process Loan Rollover Details                     *
     F*  LOANA   -  Process Loan Associated Details                   *
     F*  SRSDET  -  Set-up Settlement Details                         *
     F*  SRADTA  -  Accumulate RDEs and Associated Data for output    *
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
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
     D**  Number Arrays
     D*
     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
     D*
     D/COPY ZSRSRC,ZPOWERZ1IL
     D**  Copyright array.
     D**  Look-up string for RDE definition Array
     D*
     D ##SDS           DS
     D*
     D #@SDS           DS
     D  #@S                 5120   5120
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
     D**  For error reporting
     D*
     D*
     D** Loan details parameter for call to CG99LSET
     D*
     D PDETLS          DS           256
     D* Currency
     D  #CCY1                  1      3
     D* Customer Number
     D**********                              4   90##CNUM                                    CSD027
     D  ##CNUM                 4      9
     D* Branch
     D  ##BRCA                10     12
     D* Processing Type
     D  ##PTYP                13     14  0
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
     D  P0RONS               730    748
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
     D P4PARM          DS           256
     D**  Facility Customer Number
     D**********                              1   60P4CNUM                                    CSD027
     D  P4CNUM                 1      6
     D**  Facility Type
     D  P4CNAM                 7      9  0
     D**  Facility Number
     D  P4FCNO                10     11  0
     D*
     D*----------------------------------------------------------------
     D*Named constants
     D*
     D W#PTYP          C                   CONST('LOAN ROLLO')
     D W#PST1          C                   CONST('CALL LOAN ')
     D W#PST2          C                   CONST('TERM LOAN ')
     D W#PST3          C                   CONST('DISC LOAN ')
     D W#PST4          C                   CONST('TERM PA PU')
     D W#PST5          C                   CONST('TERM PA SL')
     D W#PST6          C                   CONST('DISC PA PU')                                     B
     D W#PST7          C                   CONST('DISC PA SL')                                     B
     D W#PST8          C                   CONST('GUAR ISSUE')                                     B
     D W#PST9          C                   CONST('CALL PA PU')                                     B
     D W#PS10          C                   CONST('CALL PA SL')                                     B
     D W#PS11          C                   CONST('RISK PA PU')                                     B
     D W#PS12          C                   CONST('RISK P SL1')                                     B
     D W#PS13          C                   CONST('RISK P SL2')                                     B
     D*----------------------------------------------------------------
     D*
     D DSPARM        E DS                  EXTNAME(LOAMSDK)
     D** External DS for parameter passed from CG6020
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CEU014
     D**  External DS for customer details                                CEU014
     D/COPY WNCPYSRC,CG6025I002
     D*                                                                   CEU014
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    CEU014
     D* DS for GL ICD Details                                             CEU014
     D*                                                                   CEU014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CLE005
     D** Switchable Feature details                                       CLE005
     D  XLCD         E                     EXTFLD(LCD)                          CLE005
     D*                                                                   CLE005
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CLE005
     D**  First DS for access programs, short data structure              CLE005
     D*                                                                   CLE005
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Second DS for access programs, long data structure
     D*
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
     D**  Record format of PF/CGUDTAPD for use as a parameter
     D*
     D*
     D CPYR            DS
     D**  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
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
     I/COPY WNCPYSRC,CG6025E001
     I/EJECT
     I*
     ICLOANCLF
     I** Rename fields of CLOANCL
     I              RECI                        ##RECI
     I              LNRF                        ##LNRF
     I              MRIN                        ##MRIN
     I              PTYP                        ##PTYP
     I              CNUM                        ##CNUM
     I              BRCA                        ##BRCA
     I              LTYP                        ##LTYP
     I              SUTP                        ##SUTP
     I              VDAT                        ##VDAT
     I              FCUS                        ##FCUS
     I              FTYP                        ##FTYP
     I              FSEQ                        ##FSEQ
     I              CCY                         ##CCY1
     I              INTC                        ##INTC
     I              BRTT                        ##BRTT
     I              BRTE                        ##BRTE
     I              SPIN                        ##SPIN
     I              WTIN                        ##WTIN
     I              REPT                        ##REPT
     I              NACD                        ##NACD
     I              AUTO                        ##AUT1
     I              FACO                        ##FACO
     I              FCLB                        ##FCLB
     I              ORED                        ##ORED
     I              LCD                         ##LCD
     I              CHTP                        ##CHTP
     I              TNLU                        ##TNLU
     I              CVMR                        ##CVMR
     I              SCCY                        ##STCY                          CEU014
     I              CNSP                        ##CNSP
     I              CNSG                        ##CNSG
     I              RDMT                        ##RDMT
     I              RDFD                        ##RDFD
     I              NNSP                        ##NNSP                                            AR
     I              NNSG                        ##NNSG                                            AR
     I              NDMT                        ##NDMT                                            AR
     I              NDFD                        ##NDFD                                            AR
     I*                                                                   S01408
     I/COPY WNCPYSRC,CG6025IIP1                                           S01408
     I*                                                                   S01408
     I*
     ICLOANCKF
     I** Rename fields of CLOANCK
     I              RECI                        ##RECI
     I              LNRF                        ##LNRF
     I              MRIN                        ##MRIN
     I              SPI1                        ##SPI1
     I              SPI2                        ##SPI2
     I              SPI3                        ##SPI3
     I*
     ILVENTELF
     I** Rename fields of LVENTEL
     I              RECI                        LVRECI
     I              LNRF                        LVLNRF
     I              INTR                        LVINTR
     I              CPAM                        LVCPAM
     I              BRCA                        LVBRCA
     I/COPY WNCPYSRC,CG6025I001
     C/EJECT
     C*****************************************************************
     C* Process     :  MAINLINE                                       *
     C* Function    :  Mainline processing                            *
     C*                                                               *
     C* Called by   :  None                                           *
     C* Calls       :  SRINIT - Initial Processing - On First Call    *
     C*                SRINZ  - Initialise Fields on Each Invocation  *
     C*                SRMAIN - Main Processing                       *
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
     C                   END
     C*
     C** Initialisation processing
     C*
     C                   EXSR      SRINZ
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRMAIN                                         *
     C* Function    :  Main processing                                *
     C*                                                               *
     C* Called by   :  Mainline                                       *
     C* Calls       :  SRDETL - Obtain Detail Information             *
     C*                SRGENR - Generate reference number by writing  *
     C*                         to PF/CGUDCRPD                        *
     C*                L03RO  - Process Lending Rollover Confirmation *
     C*****************************************************************
     C     SRMAIN        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
     C*
     C                   EXSR      SRDETL
     C*
     C**  Generate reference number by writing to PF/CGUDCRPD
     C**  If no confirmation to be produced, then bypass
     C*
     C                   MOVE      'N'           ##COPD
     C/COPY WNCPYSRC,CG6025C007
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C** Extract
     C*
     C                   EXSR      L03RO
     C*
     C     EXMAIN        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRDETL                                        *
     C*  Function    :  Process: Obtain detail information            *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SRERR  - Database Error                       *
     C*****************************************************************
     C     SRDETL        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRDETL'      @STK(Q)
     C*
     C     CLOANK        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RCDT
     C*
     C                   MOVEL     'A'           RCDT
     C*
     C     CLOANK        CHAIN     CLOAN                              90
     C*
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     01            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *                                                                                      BUG7960
     C                   MOVE      *BLANK        WOLN70            1
     C     ##PTYP        IFEQ      72
     C**********           Z-ADDLNRF      WOLNRF  60                                  BUG7960 CLE148
     C                   MOVEL     LNRF          WOLNRF            6
     C**********           Z-ADDOLNO      LNRF                                       BUG7960 CSD027A
     C                   MOVE      OLNO          LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                      BUG7960
     C     CLOANK        CHAIN     CLOAN                              90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE
     C                   MOVEL     LNRF          W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                      BUG7960
     C     ##PTYP        IFEQ      70
     C                   MOVE      'Y'           WOLN70
     C                   ENDIF
      *                                                                                      BUG7960
      ** Re-chain to get the original loan details                                           BUG7960
     C**********           Z-ADDWOLNRF    LNRF                                        BUG7960 CLE148
     C                   MOVEL     WOLNRF        LNRF
     C                   MOVEL     'A'           RCDT              1
      *                                                                                      BUG7960
     C     CLOANK        CHAIN     CLOAN                              90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE
     C                   MOVEL     LNRF          W0KEY
     C                   Z-ADD     16            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                      BUG7960
     C                   ENDIF
     C*
     C                   MOVEL     'B'           RCDT
     C*
     C     CLOANK        CHAIN     CLOAN                              90
     C*
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     02            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C                   Z-ADD     0             WEAMT            13 0
     C*
     C** Access the events file to get the interest record for this
     C** loan in order to output the correct info to the confirmation
     C*
     C     LNRF          SETLL     LVNTROL
     C                   READ      LVNTROL                                91
     C*
     C** If type is not ROLLOVER CHECK - read next record which is the
     C** ROLLOVER - If not reset file to above record.
     C*
     C     ETYP          IFNE      'R5'
     C     LNRF          ANDEQ     LVLNRF
     C     *IN91         ANDEQ     '0'
     C     EDAT          ANDEQ     VDAT
     C*
     C** Read file again to pick up ROLLOVER details.
     C*
     C                   READ      LVNTROL                                91
     C*
     C** If End of File or Record for another loan, or not ROLLOVER
     C** or different Action Date, reset file to previous read.
     C*
     C     *IN91         IFEQ      '1'
     C     LNRF          ORNE      LVLNRF
     C     ETYP          ORNE      'R5'
     C     EDAT          ORNE      VDAT
     C*
     C     LNRF          SETLL     LVNTROL
     C                   READ      LVNTROL                                91
     C*
     C                   END
     C                   END
     C*
     C     *IN91         IFEQ      '0'
     C     LNRF          ANDEQ     LVLNRF
     C                   Z-ADD     EAMT          WEAMT
     C*
     C**  Use LVNTROL event date to output next interest payment date
     C**  whether it is actually an interest payment date or maturity
     C**  date.
     C*
     C     ETYP2         IFNE      'R2'
     C     ETYP2         OREQ      'R2'
     C     ##REPT        ANDEQ     1
     C     ETYP2         OREQ      'R2'
     C     ##REPT        ANDEQ     3
     C                   MOVE      EDAT          NIDT
     C                   END
     C                   END
     C*
     C     EXDETL        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  L03RO                                          *
     C* Function    :  Process: Lending Rollover Confirmations        *
     C*                                                               *
     C* Called by   :  SRMAIN - Main Processing                       *
     C* Calls       :  SRPATH - Generate Path String                  *
     C*                LOANRO - Process Loan Rollover details         *
     C*                SRSDET - Set-up Settlement Details             *
     C*                LOANA  - Process Loan Associated Details       *
     C*****************************************************************
     C     L03RO         BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L03RO '      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'l03RO '      ##GRPS
     C*
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG6025CCP3                                           S01408
     C*                                                                   S01408
     C                   EXSR      LOANRO
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG6025CCP1                                           S01408
     C*                                                                   S01408
     C*
     C                   EXSR      SRSDET
     C*
     C                   EXSR      LOANA
      *                                                                                       CER049
      ** Stamp Tax                                                                            CER049
      *                                                                                       CER049
     C     CER049        IFEQ      'Y'
     C                   EXSR      LNSTAX
     C                   ENDIF
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  LOANRO                                         *
     C* Function    :  Process: Loan Rollover details                 *
     C*                                                               *
     C* Called by   :  L03RO - Process Lending Rollover Confirmations *
     C* Calls       :  SRPATH - Generate Path String                  *
     C*                SRDCDT - Determine Currency Details            *
     C*                SRADTA - Accumulate RDEs and Associated Data   *
     C*                SRODTA - Output Accumulated Data to            *
     C*                          PF/CGUDTAPD                          *
     C*****************************************************************
     C     LOANRO        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANRO'      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANRO'      ##GRPS
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
     C** Currency Description
     C*
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6CYNM        ##WRK            14
     C                   MOVEL     A6INCY        LINCY             1
     C                   MOVEL     A6NBDP        LNBDP             1 0
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
     C** Current Principal (Amount)
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'CL'          #@RDE
     C                   MOVEL     'CUR PRIN'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CPAM          ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6025C005
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Currency
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
     C** Gross Interest
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'ST'          #@RDE
     C                   MOVEL     'GRS INTR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG6025CCP4                                           S01408
     C*                                                                   S01408
     C                   MOVEL     WEAMT         ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C/COPY WNCPYSRC,CG6025C006
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Interest Rate
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     INTR          ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Loan Reference
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
     C** Next Interest Payment Date
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'NXT IPDA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     NIDT          ##DATA
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG6025CCP5                                           S01408
     C*                                                                   S01408
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Next Rollover Date
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'NXT RLDA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     NROD          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Rollover Date
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'E '          #@RDE
     C                   MOVEL     'ROLL DAT'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     VDAT          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Run date; production time
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
     C*                                                                   CEU014
     C** Determine the settlement currency ##SETL                         CEU014
     C*                                                                   CEU014
     C                   SELECT                                                                CEU01
     C     PTYP          WHENLE    65                                                          CEU01
     C                   MOVE      RPSC          ##SETL            3                           CEU01
     C                   MOVE      RPSR          FCXR             13 8
     C                   MOVE      RPSI          FMDI              1
     C     PTYP          WHENEQ    66                                                          CEU01
     C     PTYP          OREQ      67                                                          CEU01
     C                   MOVE      RRSC          ##SETL                                        CEU01
     C                   MOVE      RRSR          FCXR
     C                   MOVE      RRSI          FMDI
     C                   ENDSL                                                                 CEU01
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
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     ##SETL        ANDNE     *BLANKS                                                     CEU01
     C     CLE031        OREQ      'Y'
     C     ##SETL        ANDNE     *BLANKS
     C                   MOVEL     ##SETL        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   MOVE      A6INCY        SINCY             1
     C                   MOVE      A6NBDP        SNBDP             1 0
     C                   Z-ADD     CPAM          P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
     C                   MOVE      ##SETL        P@TOCY                                        CEU01
      *                                                                                       CLE031
     C     LINCY         IFEQ      'Y'
     C     SINCY         OREQ      'Y'
     C                   EXSR      D@EURO                                                      CEU01
     C                   ELSE
      *                                                                                       CLE031
     C     CCY           IFNE      ##SETL
     C     ##SETL        ANDNE     *BLANKS
     C                   Z-ADD     FCXR          ZEXCH            13 8
     C                   MOVE      FMDI          ZMD               1
     C                   Z-ADD     CPAM          ZAMTCI           15 0
     C                   MOVE      CCY           ZCCYI             3
     C                   MOVE      P@TOCY        ZCCYO             3
     C                   Z-ADD     LNBDP         ZCDPI             1 0
     C                   Z-ADD     SNBDP         ZCDPO             1 0
     C                   EXSR      ZCONV
     C                   Z-ADD     ZAMTCO        ##OUTA
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C** Gross Interest in Settlement Currency                            CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'G_INT_SC'    #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     ##SETL        ANDNE     *BLANKS                                                     CEU01
     C     CLE031        OREQ      'Y'
     C     ##SETL        ANDNE     *BLANKS
     C                   MOVEL     ##SETL        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   MOVE      A6INCY        SINCY             1
     C                   MOVE      A6NBDP        SNBDP             1 0
     C                   Z-ADD     WEAMT         P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
     C                   MOVE      ##SETL        P@TOCY                                        CEU01
      *                                                                                       CLE031
     C     LINCY         IFEQ      'Y'
     C     SINCY         OREQ      'Y'
     C                   EXSR      D@EURO                                                      CEU01
     C                   ELSE
      *                                                                                       CLE031
     C     CCY           IFNE      ##SETL
     C     ##SETL        ANDNE     *BLANKS
     C                   Z-ADD     FCXR          ZEXCH            13 8
     C                   MOVE      FMDI          ZMD               1
     C                   Z-ADD     WEAMT         ZAMTCI           15 0
     C                   MOVE      CCY           ZCCYI             3
     C                   MOVE      P@TOCY        ZCCYO             3
     C                   Z-ADD     LNBDP         ZCDPI             1 0
     C                   Z-ADD     SNBDP         ZCDPO             1 0
     C                   EXSR      ZCONV
     C                   Z-ADD     ZAMTCO        ##OUTA
     C                   ENDIF
      *                                                                                       CLE031
     C                   ENDIF
      *                                                                                       CLE031
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C*                                                                   CEU014
     C** determine the Equivalent Currency                                CEU014
     C*                                                                   CEU014
     C                   MOVE      *BLANKS       EQCY              3                           CEU01
     C                   MOVE      CCY           ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C     A6INCY        IFEQ      'Y'                                                         CEU01
     C                   MOVE      BKEURO        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C     CCY           IFEQ      BKEURO                                                      CEU01
     C                   MOVEL     CNUM          ##KEY2                                        CEU01
     C                   CALL      'AOCUSTR0'                                                  CEU01
     C                   PARM      *BLANKS       ##RTCD                                        CEU01
     C                   PARM      '*KEY   '     ##OPTN                                        CEU01
     C                   PARM                    ##KEY2           10                           CEU01
     C                   PARM      *BLANKS       ##KYST            7                           CEU01
     C     SDCUST        PARM      SDCUST        DSSDY                                         CEU01
     C*                                                                   CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
     C                   MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
     C                   MOVEL     CNUM          W0KEY                          ************   CEU01
     C                   Z-ADD     12            W0ERNB                         * DBERR 12 *   CEU01
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
     C                   Z-ADD     CPAM          P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
     C                   MOVE      EQCY          P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C** Gross Interest in Equivalent Currency                            CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'G_INT_EQ'    #@RDE                                         CEU01
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
     C                   Z-ADD     WEAMT         P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
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
     C/COPY WNCPYSRC,CG6025C003
      *                                                                                       CER050
     C     CER050        IFEQ      'Y'
     C                   EXSR      ZI@APR
     C                   ENDIF
     C*
      ** Old maturity date (CLOAN)                                        186892
     C                   ADD       1             R1                                            18689
     C                   CLEAR                   R#DATA                                        18689
     C                   CLEAR                   R#DEFN                                        18689
     C                   CLEAR                   #@RDE                                         18689
     C                   MOVE      'TE'          #@RDE                                         18689
     C                   MOVEL     'MATUR DA'    #@RDE                                         18689
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         18689
     C                   MOVEL     MDAT          ##DATA                                        18689
     C                   MOVEL     'Date  '      ##RDEC                                        18689
     C                   MOVEL     R#DATA        ##D(R1)                                       18689
     C                   MOVEL     R#DEFN        ##R(R1)                                       18689
     C*                                                                   186892
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
     C                   MOVEL     EAIR          ##DATA
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
     C     ##CNSP        IFNE      0
     C                   MOVEL     ##CNSP        ##DATA
     C                   ELSE
     C                   MOVEL     ##NNSP        ##DATA
     C                   ENDIF
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*                                                                                     AR823507
     C                   EXSR      SRADTA
     C                   Z-ADD     0             R1
      *                                                                                       CRE073
      ** Contractual Spread Sign                                                              CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CONTSSG'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C     ##CNSG        IFNE      *BLANKS
     C                   MOVEL     ##CNSG        ##DATA
     C                   ELSE
     C                   MOVEL     ##NNSG        ##DATA
     C                   ENDIF
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
     C     ##RDMT        IFNE      *BLANKS
     C                   MOVEL     ##RDMT        ##DATA
     C                   ELSE
     C                   MOVEL     ##NDMT        ##DATA
     C                   ENDIF
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
     C     ##RDFD        IFNE      *BLANKS
     C                   MOVEL     ##RDFD        ##DATA
     C                   ELSE
     C                   MOVEL     ##NDFD        ##DATA
     C                   ENDIF
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
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG6025CCP2                                           S01408
     C*                                                                   S01408
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  LOANA                                         *
     C*  Function    :  Process: Loan Associated Details              *
     C*                                                               *
     C*  Called by   :  L02RO  - Process Lending Rollover Confirmation*
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
     C                   CLEAR                   P4PARM
     C                   MOVE      LNRF          P3LNRF
     C                   MOVE      *BLANKS       P3CNAM
     C                   CALL      'CG6001'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    P1PARM                         UDC Details
     C                   PARM                    P2PARM          140            Path Details
     C                   PARM                    P3PARM                         Loan Details
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
      *                                                                                       CCG015
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
      /EJECT                                                                                  CER049
      *****************************************************************                       CER049
      *                                                               *                       CER049
      *  Subroutine  :  LNSTAX                                        *                       CER049
      *  Function    :  Process Stamp Tax information                 *                       CER049
      *                                                               *                       CER049
      *  Called by   :  L03RO  - Lending Rollover Confirmation        *                       CER049
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
      * Subroutine  :  ZI@APR                                         *                       CER050
      * Function    :  Extract - Annualised Percentage Rate (APR)     *                       CER050
      *                                                               *                       CER050
      *  Called by   :                                                *                       CER050
      *  Calls       :                                                *                       CER050
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
      *****************************************************************                       CER050
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRSDET                                        *
     C*  Function    :  Set-up settlement details.                    *
     C*                                                               *
     C*  Called by   :  L03RO - Process Lending Rollover Confirmation *
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
     C                   MOVEL     ##SPI1        P0SPI1
     C                   MOVEL     ##SPI2        P0SPI2
     C                   MOVEL     ##SPI3        P0SPI3
     C*
     C** Set-up UDC Details
     C*
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C                   SELECT                                                                CEU01
     C     PTYP          WHENLE    65                                                          CEU01
     C                   MOVE      RPSC          P0STCY                                        CEU01
     C     PTYP          WHENEQ    66                                                          CEU01
     C     PTYP          OREQ      67                                                          CEU01
     C                   MOVE      RRSC          P0STCY                                        CEU01
     C                   ENDSL                                                                 CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
     C                   SELECT
     C     PTYP          WHENLE    65
     C                   MOVE      RPSC          P0STCY
     C                   MOVE      *BLANKS       P0PSCY
     C     PTYP          WHENEQ    66
     C     PTYP          OREQ      67
     C                   MOVE      RRSC          P0PSCY
     C                   MOVE      *BLANKS       P0STCY
     C                   ENDSL
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
     C*
     C** Database error
     C*
     C                   MOVEL     'CG99LSET'    W0FILE
     C                   MOVEL     'W0RTN'       W0KEY                          ***************
     C                   Z-ADD     03            W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C** Reset Sequence number
     C*
     C                   Z-ADD     P1OSEQ        ##OSEQ
     C*                                                                   CCG015
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRINZ                                          *
     C* Function    :  Initialise Fields on Program Invocation        *
     C*                                                               *
     C* Called by   :  Mainline                                       *
     C* Calls       :  None                                           *
     C*****************************************************************
     C     SRINZ         BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
     C*
     C**  Initialise work fields
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRINIT                                         *
     C* Function    :  Initial processing - First Call Only           *
     C*                                                               *
     C* Called by   :  Mainline                                       *
     C* Calls       :  SRERR  - Report Error and Close Down Program   *
     C*                SRDCDT - Determine Currency Details            *
     C*****************************************************************
     C     SRINIT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
     C/COPY WNCPYSRC,CG6025C001
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
     C                   Z-ADD     04            W0ERNB                         * DB ERROR 04 *
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
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CLE005
      ** Check if CLE005 is ON                                            CLE005
      *                                                                   CLE005
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CLE031'      ##SARD            6
      *                                                                                       CLE031
      ** DATABASE ERROR                                                                       CLE031
      *                                                                                       CLE031
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 14 *
     C                   Z-ADD     14            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*                                                                                       CLE031
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE031            1
     C                   ELSE
     C                   MOVEL     'N'           CLE031
     C                   END
      *                                                                                       CLE031
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
     C                   MOVEL     'CLE005'      W0KEY                          ***************CLE00
     C                   Z-ADD     09            W0ERNB                         * DB ERROR 09 *CLE00
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CLE00
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CLE00
     C                   EXSR      SRERR                                                       CLE00
     C                   ENDIF                                                                 CLE00
     C                   ENDIF                                                                 CLE00
     C*
      ** Check if CEU014 is ON                                            CEU014
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
     C                   MOVEL     'CEU014'      W0KEY                          ***************CEU01
     C                   Z-ADD     10            W0ERNB                         * DB ERROR 10 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
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
     C*                                                                                       CCG015
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     13            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
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
     C                   Z-ADD     17            W0ERNB                         * DB ERROR 17 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CER049
     C                   ENDIF
      *                                                                                       CLE143
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
      *                                                                                       CER050
     C/COPY WNCPYSRC,CG6025C004
     C*                                                                   CEU014
     C     EXINIT        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRADTA                                         *
     C* Function    :  Accumulate RDEs and associated data for output *
     C*                                                               *
     C* Called by   :  LOANRO - Process Loan Rollover Details         *
     C* Calls       :  CG3999 - Format and Pack Data                  *
     C*                SRRFMN - Reformat RDE Data                     *
     C*                SRERR  - Database Error                        *
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
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     05            W0ERNB                         ***************
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRODTA                                         *
     C* Function    :  Output Accumulated data to PF/CGUDTAPD         *
     C*                                                               *
     C* Called by   :  LOANRO - Process Loan Rollover Details         *
     C* Calls       :  CG9020 - Output Data to CGUDTAPD               *
     C*                SRERR  - Database Error                        *
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
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 06 *
     C                   Z-ADD     06            W0ERNB                         ***************
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRBIND                                         *
     C* Function    :  Generate Binding numbers                       *
     C*                                                               *
     C* Called by   :  All Repeating Group Set Subroutines            *
     C* Calls       :  None                                           *
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRPATH                                         *
     C* Function    :  Generate Path String /GS1/GS2...               *
     C*                                                               *
     C* Called by   :  L02RO  - Process Lending Rollover Confirmation *
     C*                LOANRO - Process Loan Rollover Details         *
     C*                LOANA  - Process Loan Associated Details       *
     C*                SRSDET - Set-up settlement details             *
     C* Calls       :  None                                           *
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRRFMN                                         *
     C* Function    :  Reformat RDE data                              *
     C*                                                               *
     C* Called by   :  SRADTA - Accumulate RDEs and associated        *
     C*                         data for output                       *
     C* Calls       :  None                                           *
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  SRDCDT                                         *
     C* Function    :  Determine Currency Details                     *
     C*                                                               *
     C* Called by   :  LOANRO - Process Loan Rollover Details         *
     C*                SRINIT - Initial Processing - On First Call    *
     C* Calls       :  SRERR  - Database Error                        *
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
     C                   Z-ADD     07            W0ERNB                         * DB ERROR 07 *
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
     C/COPY WNCPYSRC,CG6025C002
     C*
     C     EXDCDT        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
      *****************************************************************   CEU014
     C/SPACE 5                                                            CEU014
      *****************************************************************   CEU014
      * Subroutine  :  D@EURO                                         *   CEU014
      * Function    :  EURO Currency Conversion:                      *   CEU014
      *                Converts P@FRAM in P@FRCY to ##OUTA in P@TOCY. *   CEU014
      * Called by   :  LOANRO                                         *   CEU014
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
     C                   Z-ADD     13            W0ERNB                         * DB ERROR 13 *CEU01
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
     C*****************************************************************
     C* Subroutine  :  SRGENR                                         *
     C* Function    :  Generate reference number                      *
     C*                by writing to PF/CGUDCRPD                      *
     C*                                                               *
     C* Called by   :  SRMAIN - Main Processing                       *
     C* Calls       :  CG9010 - Create reference record               *
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
     C                   MOVEL     BRCA          DRBRCA
     C*
     C** Originating Branch (Optional)
     C*
     C                   MOVEL     ORBR          DRORBR
     C*
     C** Module identifier (Mandatory)
     C*
     C                   MOVEL     'LE'          DRMODI
     C*
     C** Midas Transaction Number (Mandatory)
     C*
     C                   MOVEL     LNRF          DRMTRN
     C*
     C                   MOVEL     W#PTYP        DRPTYP                         * print type
     C*
     C                   SELECT
     C********** PTYP      WHEQ 61                                                           BUG7960
     C     ##PTYP        WHENEQ    61
     C                   MOVEL     W#PST1        DRPSTP                         * print s/type
     C********** PTYP      WHEQ 62                                                           BUG7960
     C     ##PTYP        WHENEQ    62
     C                   MOVEL     W#PST2        DRPSTP                         * print s/type
     C********** PTYP      WHEQ 63                                                           BUG7960
     C     ##PTYP        WHENEQ    63
     C                   MOVEL     W#PST3        DRPSTP                         * print s/type
     C********** PTYP      WHEQ 64                                                           BUG7960
     C********** PTYP      OREQ 68                                                    CLE005 BUG7960
     C********** CLE005    ANDEQ'Y'                                                   CLE005 BUG7960
     C     ##PTYP        WHENEQ    64
     C                   MOVEL     W#PST4        DRPSTP                         * print s/type
     C     ##PTYP        WHENEQ    65
     C                   MOVEL     W#PST6        DRPSTP
     C********** PTYP      WHEQ 66                                                           BUG7960
     C********** PTYP      OREQ 69                                                    CLE005 BUG7960
     C********** CLE005    ANDEQ'Y'                                                   CLE005 BUG7960
     C     ##PTYP        WHENEQ    66
     C                   MOVEL     W#PST5        DRPSTP                         * print s/type
     C     ##PTYP        WHENEQ    67
     C                   MOVEL     W#PST7        DRPSTP
     C     ##PTYP        WHENEQ    70
     C                   MOVEL     W#PST8        DRPSTP
     C     ##PTYP        WHENEQ    68
     C                   MOVEL     W#PST9        DRPSTP
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
      *                                                                                      BUG7960
     C                   ENDSL
     C*
     C** Auto Transmission indicator
     C*
     C                   MOVEL     'N'           DRATRM
     C*
     C** Customer Number (Mandatory)
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
     C                   Z-ADD     08            W0ERNB                         * DB ERROR 08 *
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
     C/COPY ZSRSRC,ZCONVZ1ILE
     C/EJECT                                                                                  CLE031
     C/COPY WNCPYSRC,CG6025C008
     C/EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT
     C/COPY CGCPYSRC,CGNWEXILE
     C/EJECT                                                                                  CCG015
     C********************************************************************
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION                                           CLE031
0000001                                                                                       CLE031
0000010                                                                                       CLE031
0000100                                                                                       CLE031
0001000                                                                                       CLE031
0010000                                                                                       CLE031
0100000                                                                                       CLE031
1000000                                                                                       CLE031
** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
