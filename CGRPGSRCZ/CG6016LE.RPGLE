     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Transfer of principal conf - extract')        *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6016LE - Transfer of Principal Confirmations - Extract(ILE)*
     F*                                                               *
     F*  Function:  This program extracts data for Tarnsfer of        *
     F*  (COB)      Principal Confirmations                           *
     F*                                                               *
     F*  Called By: CG6011 - Transfer of Principal Confirmations      *
     F*                      - Driver                                 *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CLE174             Date 23Oct20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
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
      *                 CAP075             Date 08Aug03               *
      *                 CLE031             Date 20Feb03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU014             Date 04Jun98               *
      *                 CLE004  *CREATE    Date 29Apr97               *
     F*                                                               *
     F*---------------------------------------------------------------*
      *  CLE174 - Libor Deregulation - Lending                        *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
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
      *  CCG015 - Correspondence Manager Phase 1                      *
      *  CSD006 - Recompiled over changed SDCURRPD.                   *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
     F*  CEU014 - EMU User Defined Correspondence changes             *
     F*  CLE004 - Syndications & Authorisations                       *
     F*                                                               *
     F*****************************************************************
     FCLOAN     IF   E           K DISK
     F                                     INFSR(SRFILE)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
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
     F*  SRINIT  -  Initial Processing                                *
     F*  SRINZF  -  Initialise Fields on Each Invocation              *
     F*  SRDETL  -  Obtain Detail Information                         *
     F*  L11PT   -  Transfer of Principal Confirmation                *
     F*  LOANPT  -  Loan Principal Transfer Detail                    *
     F*  LOANA   -  Process Loan Associated Details                   *
     F*  SRSDET  -  Set-up Settlement Details                         *
     F*  SRADTA  -  Accumulate RDEs and Associated Data               *
     F*  SRODTA  -  Output Accumulated Data to PF/CGUDTAPD            *
     F*  SRBIND  -  Generate Binding Numbers                          *
     F*  SRPATH  -  Generate Path String                              *
     F*  SRRFMN  -  Reformat RDE Data                                 *
     F*  SRDCDT  -  Determine Currency Details                        *
     F*  SRGENR  -  Generate Reference Number                         *
     F*  *PSSR   -  Error Subroutine                                  *
     F*                                                               *
     F*****************************************************************
     D/EJECT
     D*****************************************************************
     D/COPY ZSRSRC,ZPOWERZ1IL
     D*
     D** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
     D*
     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
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
     D*
     D** Loan details parameter for call to CG99LSET
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
     D W#PTYP          C                   CONST('LOAN PTRAN')
     D W#PST1          C                   CONST('TERM LOAN ')
     D*
     D DSPARM        E DS                  EXTNAME(LOAMSDK)
     D** External DS for parameter passed from CG6011
     D*
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
     D** External DS for incomplete reference
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  External DS for Bank details
     D*
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
     D**  External DS for currency details
     D/COPY WNCPYSRC,CG6016I001
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CEU014
      **  External DS for customer details                                CEU014
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
     I              SCCY                        ##STCY                          CEU014
     I              PSCY                        ##PSCY
     I              REXR                        ##REXR
     I              REXI                        ##REXI
     I              PEXR                        ##PEXR
     I              PEXI                        ##PEXI
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
     C                   PARM                    ##COPD            1
     C                   PARM                    ##AUTO            1
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
     C*  Calls       :  SRDETL - Obtain Detail Information            *
     C*                 SRGENR - Generate reference number by writing *
     C*                          to PF/CGUDCRPD                       *
     C*                 L11PT  - Process Transfer of Principal        *
     C*                          Confirmation                         *
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
     C/COPY WNCPYSRC,CG6016C002
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C** Extract
     C*
     C                   EXSR      L11PT
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
     C     CLOANK        CHAIN     CLOAN                              88
     C*
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 06 *
     C                   Z-ADD     06            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
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
     C*  Subroutine  :  L11PT                                         *
     C*  Function    :  Process: Transfer of Principal  Confs         *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRSDET - Set-up Settlement Details            *
     C*                 LOANPT - Process Transfer of Principal        *
     C*                          Detail                               *
     C*                 LOANA  - Process Loan Associated Details      *
     C*****************************************************************
     C     L11PT         BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L11PT '      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'l11PT '      ##GRPS
     C*
     C                   EXSR      SRPATH
     C                   EXSR      PSHGRS
     C*
     C                   EXSR      LOANPT
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
     C*  Subroutine  :  LOANPT                                        *
     C*  Function    :  Process: Transfer of Principal detail         *
     C*                                                               *
     C*  Called by   :  L11PT  - Process Transfer of Principal        *
     C*                          Confirmation                         *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to           *
     C*                           PF/CGUDTAPD                         *
     C*****************************************************************
     C     LOANPT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANPT'      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANPT'      ##GRPS
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
     C** Value Date
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'VALUE DA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     VDAT          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** From Loan
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'N '          #@RDE
     C                   MOVEL     'FROM LOA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ROLN          R#DATA
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
     C*
     C* Transfer Amount
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'NT'          #@RDE
     C                   MOVEL     'TFR AMOU'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     PRAM          ##DATA
     C                   MOVEL     'Amount'      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6NBDP        ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                   CEU014
      ** Extract Transfer Amount in Settlement Currency                   CEU014
      *                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C                   MOVEL     'TFRAM_SC'    #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     CLE031        OREQ      'Y'
     C     SCCY          IFNE      *BLANKS                                                     CEU01
     C     PSCY          ORNE      *BLANKS
      *                                                                                       CLE031
     C     SCCY          IFNE      *BLANKS
     C                   MOVE      SCCY          ##CCY                                         CEU01
     C                   Z-ADD     REXR          FCXR
     C                   MOVE      REXI          FMDI
     C                   ELSE
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
     C     PSCY          ANDNE     *BLANKS
     C                   MOVE      PSCY          ##CCY
     C                   MOVE      PEXR          FCXR             13 8
     C                   MOVE      PEXI          FMDI              1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
     C                   EXSR      SRDCDT                                                      CEU01
     C                   MOVE      A6INCY        SINCY             1
     C                   MOVE      A6NBDP        SNBDP             1 0
     C                   Z-ADD     PRAM          P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
      *                                                                                       CLE031
     C     SCCY          IFNE      *BLANKS
     C                   MOVE      SCCY          P@TOCY                                        CEU01
     C                   ELSE
     C     CLE031        IFEQ      'Y'
     C     PSCY          ANDNE     *BLANKS
     C                   MOVE      PSCY          P@TOCY
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CLE031
     C     LINCY         IFEQ      'Y'
     C     SINCY         OREQ      'Y'
     C                   EXSR      D@EURO                                                      CEU01
     C                   ELSE
      *                                                                                       CLE031
     C     CCY           IFNE      PSCY
     C     PSCY          ANDNE     *BLANKS
     C     CCY           ORNE      SCCY
     C     SCCY          ANDNE     *BLANKS
     C                   Z-ADD     FCXR          ZEXCH            13 8
     C                   MOVE      FMDI          ZMD               1
     C                   Z-ADD     PRAM          ZAMTCI           15 0
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
      ** DATABASE ERROR                                                   CEU014
      *                                                                   CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
     C                   MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
     C                   MOVEL     CNUM          W0KEY                          ***************CEU01
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *CEU01
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
     C                   MOVE      BBDINC        EQCY                                          CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C* Extract Transfer Amount in Equivalent Currency                    CEU014
     C*                                                                   CEU014
     C                   ADD       1             R1                                            CEU01
     C                   CLEAR                   R#DATA                                        CEU01
     C                   CLEAR                   R#DEFN                                        CEU01
     C                   CLEAR                   #@RDE                                         CEU01
     C                   MOVE      'CY'          #@RDE                                         CEU01
     C                   MOVEL     'TFRAM_EQ'    #@RDE                                         CEU01
     C     ##RDE         CAT       #@RDE:1       ##RDE                                         CEU01
     C                   MOVEL     'Amount'      ##RDEC                                        CEU01
     C                   MOVEL     'L'           ##RDET                                        CEU01
     C                   MOVEL     R#DEFN        ##R(R1)                                       CEU01
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C     EQCY          ANDNE     *BLANKS                                                     CEU01
     C                   MOVEL     EQCY          ##CCY                                         CEU01
     C                   EXSR      SRDCDT                                                      CEU01
     C                   Z-ADD     PRAM          P@FRAM                                        CEU01
     C                   MOVE      CCY           P@FRCY                                        CEU01
     C                   MOVE      EQCY          P@TOCY                                        CEU01
     C                   EXSR      D@EURO                                                      CEU01
     C                   MOVEL     ##OUTA        ##DATA                                        CEU01
     C                   MOVEL     A6NBDP        ##DCPA                                        CEU01
     C                   MOVEL     R#DATA        ##D(R1)                                       CEU01
     C                   ENDIF                                                                 CEU01
     C*                                                                   CEU014
     C* Extract Equivalent Currency                                       CEU014
     C*                                                                   CEU014
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
     C*                                                                   CEU014
     C* Extract Equivalent Currency Description                           CEU014
     C*                                                                   CEU014
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
     C/COPY WNCPYSRC,CG6016C001
     C*                                                                   CEU014
     C*                                                                   CEU014
     C*
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
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
      *****************************************************************   CEU014
      * Subroutine  :  D@EURO                                         *   CEU014
      * Function    :  EURO Currency Conversion:                      *   CEU014
      *                Converts amount P@FRAM in ccy P@FRCY to amount *   CEU014
      *                ##OUTA in ccy P@TOCY.                          *   CEU014
      * Called by   :  LOANPT                                         *   CEU014
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
      *****************************************************************   CEU014
     C/EJECT                                                              CEU014
     C*****************************************************************
     C*  Subroutine  :  LOANA                                         *
     C*  Function    :  Process: Loan Associated Details              *
     C*                                                               *
     C*  Called by   :  L11PT  - Process Transfer of Principal        *
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
     C*  Called by   :  L11PT  - Process Lending Principal Increase   *
     C*                          Confirmation                         *
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
     C*
     C** Set-up UDC Details
     C*
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN
      *                                                                   CEU014
     C     CEU014        IFEQ      'Y'                                                         CEU01
     C                   MOVEL     SCCY          P0STCY                                        CEU01
     C                   ENDIF                                                                 CEU01
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'
     C                   MOVEL     SCCY          P0STCY
     C                   MOVEL     PSCY          P0PSCY
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
     C/COPY WNCPYSRC,CG6016C003
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
     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        ##W157           15 7
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
     C*                                                                   CEU014
     C**  Define Equivalent Currency                                      CEU014
     C     *LIKE         DEFINE    CCY           EQCY                                          CEU01
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
      *                                                                   CEU014
      ** Access SAR details file to determine if CEU014 is installed.     CEU014
      *                                                                   CEU014
     C                   CALL      'AOSARDR0'                                                  CEU01
     C                   PARM      '       '     ##RTCD                                        CEU01
     C                   PARM      '*VERIFY'     ##OPTN                                        CEU01
     C                   PARM      'CEU014'      ##SARD            6                           CEU01
      *                                                                   CEU014
      ** DATABASE ERROR                                                   CEU014
      *                                                                   CEU014
     C     ##RTCD        IFNE      *BLANK                                                      CEU01
     C     ##RTCD        ANDNE     '*NRF   '                                                   CEU01
     C                   MOVEL     'SCSARDPD'    W0FILE                         ***************CEU01
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 09 *CEU01
     C                   Z-ADD     09            W0ERNB                         ***************CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                                        CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   END                                                                   CEU01
     C*                                                                   CEU014
     C     ##RTCD        IFEQ      *BLANK                                                      CEU01
     C                   MOVEL     'Y'           CEU014            1                           CEU01
     C                   ELSE                                                                  CEU01
     C                   MOVEL     'N'           CEU014                                        CEU01
     C                   END                                                                   CEU01
      *                                                                   CEU014
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
     C                   Z-ADD     10            W0ERNB                         * DB ERROR 10 *CEU01
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
     C                   MOVEL     'MIDAS  '     W0MSGF                                        CEU01
     C                   EXSR      SRERR                                                       CEU01
     C                   ENDIF                                                                 CEU01
     C                   ENDIF                                                                 CEU01
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
     C/COPY WNCPYSRC,CG6016C004
      *                                                                                       CCG015
      ** Access Switchable Features file and check if CCG015 is                               CCG015
      ** installed                                                                            CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG015'      ##SARD
      *                                                                                       CCG015
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
      *                                                                                       CCG015
     C     ##RTCD        IFNE      '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY
     C                   Z-ADD     13            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
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
     C*  Called by   :  LOANPT - Loan Principal Transfer Detail       *
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
     C*  Called by   :  LOANPT - Loan Principal Transfer Detail       *
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
     C*  Called by   :  L11PT  - Process Transfer of Principal        *
     C*                          Confirmation                         *
     C*                 LOANPT - Loan Principal Transfer Detail       *
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
     C*  Called by   :  LOANPT - Loan Principal Transfer Detail       *
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
     C/EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT
     C/COPY CGCPYSRC,CGNWEXILE
     C/EJECT                                                                                  CCG015
     C/COPY ZSRSRC,ZCONVZ1ILE
     C/EJECT                                                                                  CLE031
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
