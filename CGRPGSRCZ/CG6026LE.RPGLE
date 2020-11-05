     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Lending multi-curr rollover confirmations')   *
      *****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6026LE - Multi-Currency Rollover Confirmations (ILE)       *
     F*                                                               *
     F*  Function:  This program extracts data for Multi-             *
     F*  Currency Rollover Confirmations                              *
     F*                                                               *
     F*  Called By: CG6020 - Lending Rollover Confirmations Driver    *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CLE174             Date 23Oct20               *
      *  Prev Amend No. MD054660           Date 19Nov19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 07Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR822053           Date 29Aug11               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9646            Date 20Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP075             Date 08Aug02               *
      *                 CLE031             Date 10Feb03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 163486             Date 14Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 145995             Date 09Dec98               *
     F*                 CEU014             Date 23JUN98               *
     F*                 CLE004 *CREATE     Date 29APR97               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  CLE174 - Libor Deregulation - Lending                        *
      *  MD054660 - Incorrect Next Interest Repayment Date for loans  *
      *             with repayment type 1 or 3.                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR822053 - Incorrect value of Effective Annual Interest Rate *
      *             in CGUXMLPD                                       *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9646- Changes in CGPACKE causes programs not to compile   *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
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
     F*  163486 - Recompile due to changes in LVENTEL.                *
     F*  145995 - Incorrect value for multi-ccy rollover fields       *
     F*           This is the same fix as 135620 in LE0426 and LE1170 *
     F*  CEU014 - EMU User Defined Correspondence Enhancement.        *
     F*  CLE004 - Syndications & Authorisations                       *
     F*                                                               *
     F*****************************************************************
     FCLOAN     IF   E           K DISK    INFSR(SRFILE)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     FLVNTROL   IF   E           K DISK
     FLEHISTL4  IF   E           K DISK                                         145995
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
     F*  L10RM   -  Process: Rollover Confs (multi ccy)               *
     F*  LOANRM  -  Process: Loan Rollover Detl (multi ccy)           *
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
     D**  Copyright array.
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWER ARRAY
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
      ** Payment Currency                                                                     CLE031
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
     D W#PST1          C                   CONST('MULTI CCY')
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
     D/COPY WNCPYSRC,CG6026I001
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CEU014
     D**  External DS for customer details                                CEU014
     D*                                                                   CEU014
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    CEU014
     D* DS for GL ICD Details                                             CEU014
     D*                                                                   CEU014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CEU014
     D  SCLCD        E                     EXTFLD(LCD)                          CEU014
     D** Switchable Feature details - rename LCD field.                   CEU014
     D*                                                                   CEU014
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CEU014
     D**  First DS for access programs, short data structure              CEU014
     D*                                                                   CEU014
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
     I              OCDT                        ##OCDT
     I              EAIR                        ##EAIR
     I*
     I/COPY WNCPYSRC,CG6025IIP1
     I*
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
     IHISTSHPF                                                                  145995
     I              BRCA                        BRCAP                           145995
     I              CNUM                        CNUMP                           145995
     I              LNRF                        LNRFP                           145995
     I              VDAT                        VDATP                           145995
     I              PTYP                        PTYPP                           145995
     I              CCY                         CCYP                            145995
     I              AMTP                        AMTPP                           145995
     I              PRAM                        PRAMP                           145995
     I              INTA                        INTAP                           145995
     I              LTYP                        LTYPP                           132620
     I              SUTP                        SUTPP                           145995
     I              INTR                        INTRP                           145995
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
     C*                L10RM  - Process Lending Rollover Confirmation *
     C*                         Multi-Currency                        *
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
     C/COPY WNCPYSRC,CG6026C002
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C** Extract
     C*
     C                   EXSR      L10RM
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
     C                   MOVEL     *BLANKS       WECCY             3                           14599
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
     C                   MOVEL     ECCY          WECCY                                         14599
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
     C*                                                                   145995
     C** Access LEHISTL4 to get original principal amount (which has      145995
     C** been netted already of repayment amount on rollover date         145995
     C*                                                                   145995
     C                   MOVE      BRCA          BRCAK                                         14599
     C**********           Z-ADDCNUM      CNUMK                                        145995 CSD027
     C                   MOVE      CNUM          CNUMK
     C**********           Z-ADDLNRF      LNRFK                                        145995 CLE148
     C                   MOVEL     LNRF          LNRFK
     C                   Z-ADD     VDAT          VDATK                                         14599
     C     KOAMT         SETGT     LEHISTL4                                                    14599
     C     KOAMT         READPE    LEHISTL4                               60                   14599
      *                                                                   145995
     C     *IN60         DOWEQ     '0'                                                         14599
     C     AMTPP         ANDNE     'RE'                                                        14599
     C     KOAMT         SETGT     LEHISTL4                                                    14599
     C     KOAMT         READPE    LEHISTL4                               60                   14599
     C                   ENDDO                                                                 14599
      *                                                                   145995
     C     *IN60         IFEQ      '1'                                                         14599
     C     AMTPP         ANDNE     'RE'                                                        14599
     C                   MOVEL     'LEHISTL4'    W0FILE                         ***************14599
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 13 *14599
     C                   Z-ADD     13            W0ERNB                         ***************14599
     C                   MOVEL     'MEM5004'     W0MSGD                                        14599
     C                   MOVEL     'MIDAS  '     W0MSGF                                        14599
     C                   EXSR      SRERR                                                       14599
     C                   ENDIF                                                                 14599
      *                                                                   145995
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
     C* Subroutine  :  L10RM                                          *
     C* Function    :  Process: Lending Rollover Confirmations        *
     C*                Multi-Currency                                 *
     C* Called by   :  SRMAIN - Main Processing                       *
     C* Calls       :  SRPATH - Generate Path String                  *
     C*                LOANRM - Process Loan Rollover details         *
     C*                         Multi-Currency                        *
     C*                SRSDET - Set-up Settlement Details             *
     C*                LOANA  - Process Loan Associated Details       *
     C*****************************************************************
     C     L10RM         BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L10RM '      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'l10RM '      ##GRPS
     C*
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   EXSR      LOANRM
     C*
     C/COPY WNCPYSRC,CG6025CCP1
     C*
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
     C/EJECT
     C*****************************************************************
     C* Subroutine  :  LOANRM                                         *
     C* Function    :  Process: Loan Rollover details Multi-Currency  *
     C*                                                               *
     C* Called by   :  L10RM - Process Lending Rollover Confirmations *
     C*                        Multi-Currency                         *
     C* Calls       :  SRPATH - Generate Path String                  *
     C*                SRDCDT - Determine Currency Details            *
     C*                SRADTA - Accumulate RDEs and Associated Data   *
     C*                SRODTA - Output Accumulated Data to            *
     C*                          PF/CGUDTAPD                          *
     C*****************************************************************
     C*
     C     LOANRM        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'LOANRM'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANRM'      ##GRPS
      *
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
      *
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
     C* Currency Description
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
     C* Current Principal (Amount)
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'CL'          #@RDE
     C                   MOVEL     'CUR PRIN'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C***********          MOVELCPAM      ##DATA                          145995
     C                   MOVEL     PRAMP         ##DATA                                        14599
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Currency
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
     C* Gross Interest
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'ST'          #@RDE
     C                   MOVEL     'GRS INTR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     WEAMT         ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C***********          MOVELCCY       ##CCY                           145995
     C                   MOVEL     WECCY         ##CCY                                         14599
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Interest Rate
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
     C* Loan Reference
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
     C* Next Interest Payment Date
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'NXT IPDA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     NIDT          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Next Rollover Date
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
     C* Rollover Currency Code
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ROLL CCY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     NCCY          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Rollover Currency Description
     C*
     C                   MOVEL     NCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6CYNM        ##WRK            14
     C                   MOVE      A6INCY        FCCYIN            1
     C                   MOVE      A6NBDP        FNBDP             1 0
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '_D'          #@RDE
     C                   MOVEL     'ROLL CCY'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##WRK         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Rollover Currency Amount
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'MT'          #@RDE
     C                   MOVEL     'ROLL CYA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C***********          MOVELNCPA      ##DATA                          145995
     C                   MOVEL     PRAM          ##DATA                                        14599
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     NCCY          ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C* Rollover Date
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
     C* Run date; production time
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
     C*                                                                   CEU014
     C** Determine the settlement currency ##SETL                         CEU014
     C*                                                                   CEU014
     C                   SELECT                                                                CEU01
     C     PTYP          WHENLE    65                                                          CEU01
     C                   MOVE      RPSC          ##SETL            3                           CEU01
     C     PTYP          WHENEQ    66                                                          CEU01
     C     PTYP          OREQ      67                                                          CEU01
     C                   MOVE      RRSC          ##SETL                                        CEU01
     C                   ENDSL                                                                 CEU01
     C*                                                                   CEU014
     C** Rollover currency amount in Settlement Currency                  CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'ROLL_SCC'    #@RDE                                         CEU01
     C                   MOVE      'Y '          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     ##SETL        ANDNE     *BLANKS                                                     CEU01
     C     CLE031        OREQ      'Y'
     C     ##SETL        ANDNE     *BLANKS
      *                                                                                       CLE031
     C                   MOVEL     ##SETL        ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   MOVE      A6INCY        TCCYIN            1
     C                   MOVE      A6NBDP        TNBDP             1 0
     C***********          Z-ADDNCPA      P@FRAM                   CEU014 145995
     C                   Z-ADD     PRAM          P@FRAM                                        14599
     C                   MOVE      NCCY          P@FRCY                                        CEU01
     C                   MOVE      ##SETL        P@TOCY                                        CEU01
      *                                                                                       CLE031
     C     FCCYIN        IFEQ      'Y'
     C     TCCYIN        OREQ      'Y'
      *                                                                                       CLE031
     C                   EXSR      D@EURO                                                      CEU01
      *                                                                                       CLE031
     C                   ELSE
      *                                                                                       CLE031
      *                                                                                       CLE031
      ** Set up input fields for conversion subroutine.                                       CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
      *                                                                                       CLE031
     C                   Z-ADD     PEXR          ZEXCH            13 8
     C                   MOVE      PEXI          ZMD               1
     C                   Z-ADD     P@FRAM        ZAMTCI           15 0
     C                   MOVE      P@FRCY        ZCCYI             3
     C                   MOVE      P@TOCY        ZCCYO             3
     C                   Z-ADD     FNBDP         ZCDPI             1 0
     C                   Z-ADD     TNBDP         ZCDPO             1 0
      *                                                                                       CLE031
     C                   EXSR      ZCONV
      *                                                                                       CLE031
     C                   Z-ADD     ZAMTCO        ##OUTA
     C                   Z-ADD     TNBDP         A6NBDP
      *                                                                                       CLE031
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
     C                   MOVE      NCCY          ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C     A6INCY        IFEQ      'Y'                                                         CEU01
     C                   MOVE      BKEURO        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C     NCCY          IFEQ      BKEURO                                                      CEU01
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
     C                   MOVEL     ##CNUM        W0KEY                          ************   CEU01
     C                   Z-ADD     10            W0ERNB                         * DBERR 10 *   CEU01
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
     C** Rollover Currency amount in Equivalent Currency                  CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVEL     'ROLL_EQC'    #@RDE                                         CEU01
     C                   MOVE      'Y '          #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C*                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     NCPA          P@FRAM                                        CEU01
     C                   MOVE      NCCY          P@FRCY                                        CEU01
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
     C*                                                                   145995
     C** Interest Settlement Currency                                     145995
     C*                                                                   145995
     C                   ADD       1             R1                                            14599
     C                   CLEAR                   R#DATA                                        14599
     C                   CLEAR                   R#DEFN                                        14599
     C                   CLEAR                   #@RDE                                         14599
     C                   MOVEL     'INTST_CC'    #@RDE                                         14599
     C                   MOVE      'Y '          #@RDE                                         14599
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         14599
     C                   MOVEL     WECCY         R#DATA                                        14599
     C                   MOVEL     R#DEFN        ##R(R1)                                       14599
     C                   MOVEL     R#DATA        ##D(R1)                                       14599
     C*                                                                   145995
     C** Interest Settlement Currency Description                         145995
     C*                                                                   145995
     C                   MOVEL     WECCY         ##CCY                                         14599
     C                   EXSR      SRDCDT                                                      14599
     C                   ADD       1             R1                                            14599
     C                   CLEAR                   R#DATA                                        14599
     C                   CLEAR                   R#DEFN                                        14599
     C                   CLEAR                   #@RDE                                         14599
     C                   MOVEL     'INT_CCYD'    #@RDE                                         14599
     C                   MOVE      'ES'          #@RDE                                         14599
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         14599
     C                   MOVEL     A6CYNM        R#DATA                                        14599
     C                   MOVEL     R#DATA        ##D(R1)                                       14599
     C                   MOVEL     R#DEFN        ##R(R1)                                       14599
     C/COPY WNCPYSRC,CG6026C001
     C*
     C                   EXSR      SRADTA
     C                   Z-ADD     0             R1
      *                                                                                       CLE143
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
      **  Accumulate RDEs and associated data and output to PF/CGUDTPD.                       CLE143
      *                                                                                       CLE143
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
     C/COPY WNCPYSRC,CG6025CCP2
     C*
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  LOANA                                         *
     C*  Function    :  Process: Loan Associated Details              *
     C*                                                               *
     C*  Called by   :  L10RM  - Process Lending Rollover Confirmation*
     C*                 Multi-Currency                                *
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
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRSDET                                        *
     C*  Function    :  Set-up settlement details.                    *
     C*                                                               *
     C*  Called by   :  L10RM - Process Lending Rollover Confirmation *
     C*                 Multi-Currency                                *
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
     C                   MOVE      RPSC          P0PSCY
     C                   MOVE      RRSC          P0STCY
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
     C                   Z-ADD     03            W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C** Reset Sequence number
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
     C/COPY WNCPYSRC,CG6026C003
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
      *                                                                   145995
     C     KOAMT         KLIST                                                                 14599
     C                   KFLD                    BRCAK             3                           14599
     C**********           KFLD           CNUMK   60                                   145995 CSD027
     C                   KFLD                    CNUMK             6
     C**********           KFLD           LNRFK   60                                   145995 CLE148
     C                   KFLD                    LNRFK             6
     C                   KFLD                    VDATK             5 0                         14599
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
     C*
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
     C                   Z-ADD     9             W0ERNB                         * DB ERROR  9 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                   CEU014
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
     C                   Z-ADD     12            W0ERNB                         * DBERR 12 *   CEU01
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
     C*                                                                                       CCG015
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
     C     PRTCD         IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     14            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
      ** Access SAR details file to determine if CLE031 is installed.                         CLE031
      *                                                                                       CLE031
     C                   MOVEL     'N'           CLE031            1
      *                                                                                       CLE031
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE031
      ** Database Error                                                                       CLE031
      *                                                                                       CLE031
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     15            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CLE031
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE031
     C                   ENDIF
      *                                                                                       CLE143
      ** Check if CLE143 is ON                                                                CLE143
      *                                                                                       CLE143
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CLE143'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE143
      ** Database Error                                                                       CLE143
      *                                                                                       CLE143
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     16            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CLE143
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE143            1
     C                   ELSE
     C                   MOVE      'N'           CLE143
     C                   ENDIF
      *                                                                                       CLE143
     C/COPY WNCPYSRC,CG6026C004
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
     C* Called by   :  LOANRM - Process Loan Rollover Details         *
     C*                Multi-Currency                                 *
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
     C* Called by   :  LOANRM - Process Loan Rollover Details         *
     C*                Multi-Currency                                 *
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
     C* Called by   :  L10RM  - Process Lending Rollover Confirmation *
     C*                Multi-Currency                                 *
     C*                LOANRM - Process Loan Rollover Details         *
     C*                Multi-Currency                                 *
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
     C* Called by   :  LOANRM - Process Loan Rollover Details         *
     C*                Multi-Currency                                 *
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
     C*
     C     EXDCDT        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
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
     C                   MOVEL     W#PST1        DRPSTP                         * print s/type
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
      *****************************************************************   CEU014
     C/SPACE 5                                                            CEU014
      *****************************************************************   CEU014
      * Subroutine  :  D@EURO                                         *   CEU014
      * Function    :  EURO Currency Conversion:                      *   CEU014
      * Converts amount P@FRAM from P@FRCY to amount ##OUTA in P@TOCY *   CEU014
      * Called by   :  LOANRM                                         *   CEU014
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
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *CEU01
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
     C/TITLE SR/ZCONV                                                                         CLE031
     C/COPY ZSRSRC,ZCONVZ1ILE
     C********************************************************************
**CTDATA ##CPY
(c) Finastra International Limited 2001
**CTDATA POWER
0000001                                                                                       CLE031
0000010                                                                                       CLE031
0000100                                                                                       CLE031
0001000                                                                                       CLE031
0010000                                                                                       CLE031
0100000                                                                                       CLE031
1000000                                                                                       CLE031
