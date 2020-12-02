
***********************************************************
BASEBND                                                   *
T('Midas CG Lending interest advices')                    *
***********************************************************
                                                          *
as - User Defined Correspondence                          *
                                                          *
036LE - Lending Interest Advices (ILE)                    *
                                                          *
ction:  This program extracts data for Interest Advices.  *
                                                          *
led By: CG6030 - Lending Advices Driver                   *
                                                          *
ls :    CG3999 - Pack/Unpack Extracted Data               *
        CG6001 - General Loan Details                     *
        CG9010 - Create Item Reference Records            *
        CG9020 - Write Data to UDC Extract Files          *
                                                          *
 Finastra International Limited 2001                      *
                                                          *
t Amend No. CLE172             Date 23Oct20               *
v Amend No. CER050             Date 16Jun19               *
            MD046248           Date 27Oct17               *
            CLE134             Date 01Aug12               *
            CLE148             Date 23Jul12               *
            AR822053           Date 29Aug11               *
            CER049             Date 06Dec10               *
            CLE143             Date 06Dec10               *
 Fusion Midas 1.4 Base -----------------------------------*
s Plus 1.4 Base 04 ---------------------------------------*
s Plus 1.4 Base ------------------------------------------*
s Plus 1.3 ----------- Base ------------------------------*
            CPK025             Date 29Aug06               *
            240327             Date 16Jun06               *
          . CSD031             Date 10Apr06               *
            CSD027A            Date 06May06               *
            CSD027             Date 09Dec05               *
            CLE042             Date 06Sep05               *
            BUG9646            Date 20Dec05               *
            BUG7960            Date 25Jul05               *
            CSW037A            Date 02May05               *
            CSD025             Date 11Jan05               *
            CSW037             Date 15Dec04               *
            CSW036             Date 15Dec04               *
            CLE025             Date 20Oct03               *
            CSC022             Date 24Feb04               *
            CGL029             Date 01Sep03               *
            CLE031             Date 03Feb03               *
            CLE028             Date 27Jun02               *
s Release 4.01 -------------------------------------------*
            CCG015             Date 09Aug01               *
            193393             Date 28Aug01               *
s Release 4 --------------- Base -------------------------*
s DBA 3.05 -----------------------------------------------*
            CSD006             Date 15May01               *
            CLE011             Date 07Nov00               *
            172049             Date 01Feb01               *
s DBA 3.03 -----------------------------------------------*
            156795             Date 07Jul00               *
s DBA 3.00 ---------------- Base -------------------------*
            137658             Date 24Jun98               *
            CEU014             Date 22Jun98               *
            CEU003             Date 09Jan98               *
            CLE004             Date 01May97               *
            102468             Date 25Apr96               *
            CCG008 *CREATE     Date 30Oct95               *
                                                          *
----------------------------------------------------------*
NDMENT HISTORY                                            *
                                                          *
172 - Libor Deregulation - Lending                        *
050 - Annualised Percentage Rate                          *
46248 - Finastra Rebranding                               *
134 - Past Due Call Loan Processing (Recompile)           *
148 - Alpha Loan Reference                                *
22053 - Incorrect value of Effective Annual Interest Rate *
        in CGUXMLPD                                       *
049 - Stamp Tax (Portuguese Features Upgrade)             *
143 - Original Loan Contract Date & Effective Interest    *
      Rate                                                *
025 - MidasPlus 1.3 packaging.  Fix merging clashes       *
      caused by 240327.                                   *
327 - UDC dump. Fix is to avoid subtype being blank.      *
      Applied fixes 197869 and 224773.                    *
031 - Enhanced Centralised Static Data (Recompile)        *
027A - Conversion Of Customer Number to Alpha             *
027 - Conversion Of Customer Number to Alpha              *
042 - Extended Loan Sub Type (Recompile)                  *
9646- Changes in CGPACKE causes programs not to compile   *
7960- Missing processing for other loan types.            *
      Applied fixes 197869 and 224773.                    *
037A- Additional Field extended to 40 chars (recompile)   *
025 - Customer De-Activation                              *
037 - Additional Field Data on MT300/MT320                *
036 - Dual SWIFT BIC held on Client Details               *
025 - Credit Lines (Recompile)                            *
022 - Commitment Control Changes for MidasPlus            *
      (Recompile)                                         *
029 - Increase Account Code to 10 digits                  *
031 - Lending Enhancements.                               *
028 - Flat Rate Personal Loans (Rule of 78s)              *
015 - Correspondence Manager Phase 1                      *
393 - UDC advice type 'LOAN INTER' generated a subtype of *
      'CALL LOAN' when subtype should be 'TERM LOAN'.     *
      Condition the subtype to be dependent on the        *
      processing type (PTYP).                             *
006 - Recompiled over changed SDCURRPD.                   *
011 - Rate Fixing Days for Lending Rollover Processing    *
      Recompile                                           *
049 - Correct binds for carried forward data              *
      Carried forward details have binds of repeating     *
      data.                                               *
795 - Erroneous Interest and Principal Amounts due. Add   *
      conditions on update of ##PRAM and ##INTA.          *
658 - Extract Settl. ccy from CUTX1HP rather than CLOANCL *
014 - EMU User Defined Correspondence Changes             *
003 - EMU DL/LE Settlement Currency Conversion            *
      Added new RDEs to group set LOANIS (l05IN).         *
004 - Syndications & Authorisations                       *
468 - UDC Lending alpha site fix.  Protect the key fields *
      to the logical files used by the calling program,   *
      so that update is still possible.  Note that LNRF   *
      (loan reference) is NOT protected in this way, as   *
      it is used (though not changed) by this program to  *
      access CLOAN.                                       *
008 - User Defined Correspondence - Lending               *
                                                          *
***********************************************************

    IF   E           K DISK
                               IGNORE(CLOANHHF)
                               IGNORE(CLOANZ1F)
                               INFSR(SRFILE)

L0  UF   E           K DISK    INFSR(SRFILE)
                               COMMIT

                                                                                  CER049
mp Tax file                                                                       CER049
                                                                                  CER049
L1  IF   E           K DISK
                                                                                  CER049
I0  IF   E           K DISK
                                                                                  CER050
WNCPYSRC,CG6036F001
 FUNCTION OF INDICATORS
***********************************************************
                                                          *
 N  C T I O N    O F    I N D I C A T O R S               *
                                                          *
  -    A record has been selected for extract.            *
  -    At least one movement passes the selection         *
       criteria.                                          *
  -    EOF for LECUTXL0 - SRTEST                          *
  -    EOF for LECUTXL0 - LOANID                          *
  -    Poffered for READE LOOPS                           *
  -    General error indicator                            *
                                                          *
***********************************************************
 SUBROUTINE INDEX
***********************************************************
                                                          *
 B R O U T I N E    I N D E X                             *
                                                          *
n routine                                                 *
AIN  -  Main Processing                                   *
ETL  -  Obtain Detail Information                         *
IN   -  Lending Interest Advices                          *
NA   -  Loan Associated Details                           *
NIS  -  Process Loan Interest Summary                     *
NID  -  Process Loan Interest Details                     *
NER  -  Process Loan Events                               *
NEV  -  Process Loan Event Details                        *
NCF  -  Porcess Loan C/F Details                          *
NBF  -  Process Loan B/F Details                          *
MOV  -  Set-up Movement Details                           *
DET  -  Set-up Settlement Details                         *
NZF  -  Initialise Fields on Each Invocation              *
NIT  -  Initial Processing - On First Call                *
DTA  -  Accumulate RDEs and Associated Data               *
DTA  -  Output Accumulated Data to CGUDTAPD               *
IND  -  Generate Binding Numbers                          *
ATH  -  Generate Path String                              *
FMN  -  Reformat RDE Data                                 *
CDT  -  Determine Currency Details                        *
ENR  -  Generate Reference Number                         *
ANKR0 - Retrive Bank Details                              *
URRRO - Retrive Currency Details                          *
                                                          *
***********************************************************


pyright array.
           S             80    DIM(1) CTDATA PERRCD(1)

CGCPYSRC,CGPACKDLE
CGCPYSRC,SRERRDLE

ray of Currencies accessed by program
           S              3    DIM(100)

           DS
ta Structure for Compilation - Copyright Insertion
Y                  1     80

           DS
ok-up string for RDE definition Array
****                              15120 ##S                                      BUG9646
           DS
cked data string.
                5120   5120

           DS
mber Field
                   1     20
                               DIM(20)
UM                 1     20  0
           DS
d to convert item reference from character to numeric
MA                 1      8
EM                 1      8  0

           DS
IT                 1      6
                   1      3
                   4      6
           DS
CC                 1      5
Y                  1      3
D                  4      5

an details parameter for call to CG99LSET.

S          DS           256
ency
Y1                 1      3
omer Number
****                              4   90##CNUM                                    CSD027
UM                 4      9
ch
CA                10     12
 Processing Type
YP                13     14  0

ttlement Instructions Parameter for call to CG99LSET.

M          DS           768
y - Branch
BR                 1      3
ceipt - Branch
BR                 4      6
ceipt - Settlement Method
TM                 7      8  0
ceipt - Our Nostro
****                              9  20 P0RONS                                    CGL029
NS                 9     20
ceipt - Intermediary Bank
BN                21     28
ceipt - Intermediary Bank a/c
BA                29     63
ceipt - Ordering Bank No.
****                             64  690P0ROBN                                    CSD027
BN                64     69
ceipt - Ordering Customer
****                             70  750P0ROCN                                    CSD027
CN                70     75
y - Settlement Method
TM                76     77  0
y - Our Nostro
****                             78  89 P0PONS                                    CGL029
NS                78     89
y - Intermediary Bank
BN                90     97
y - Intermediary Bank a/c
BA                98    132
y - Ordering Bank No.
****                            133 1380P0POBN                                    CSD027
BN               133    138
y - Ordering Customer No.
****                            139 1440P0POCN                                    CSD027
CN               139    144
ceiver Correspondent No.
RN               145    152
ceiver Correspondent A/C 1
RA               153    187
ceiver Number
NO               188    195
C with Bank No.
BN               196    203
C with Bank A/C Line
BA               204    238
neficiary No.
NN               239    246
neficiary A/C Line
NA               247    281
tails of Pay 1
P1               282    316
tails of Pay 2
P2               317    351
tails of Pay 3
P3               352    386
tails of Pay 4
P4               387    421
tails of Charges
HG               422    424
nk to Bank Info 1
B1               425    459
nk to Bank Info 2
B2               460    494
nk to Bank Info 3
B3               495    529
nk to Bank Info 4
B4               530    564
nk to Bank Info 5
B5               565    599
nk to Bank Info 6
B6               600    634
ecial Instruction 1
I1               635    664
ecial Instruction 2
I2               665    694
ecial Instruction 3
I3               695    724
ttlement Currency                                             CEU003
CY               725    727                                         CEU003
y Settlement Currency                                                             CLE031
CY               728    730
NS               731    748
NS               749    766

C Details

M          DS           256
tput Sequence
EQ                 1      9  0
C item number
EM                10     17  0
is bind level
IN                18     25  0
evious bind level
IN                26     33  0

an details Parameters for call to CG6001.

M          DS           256
an Reference
RF                 1      6
ncel/Amend Field
AM                 7      7

cility details Parameter for call to CG6001

M          DS           256
cility customer
****                              1   60P4FCUS                                    CSD027
US                 1      6
cility type
YP                 7      9  0
cility Seq
EQ                10     11  0

r error reporting

med constants

P          C                   CONST('LOAN INTER')
1          C                   CONST('CALL LOAN ')
2          C                   CONST('TERM LOAN ')
3          C                   CONST('TERM PA PU')
4          C                   CONST('TERM PA SL')
5          C                   CONST('FLAT LOAN')
6          C                   CONST('GUAR ISSUE')                                     B
7          C                   CONST('DISC LOAN ')                                     B
8          C                   CONST('DISC PA PU')                                     B
9          C                   CONST('DISC PA SL')                                     B
A          C                   CONST('CALL PA PU')                                     B
B          C                   CONST('CALL PA SL')                                     B
C          C                   CONST('RISK PA PU')                                     B
D          C                   CONST('RISK P SL1')                                     B
E          C                   CONST('RISK P SL2')                                     B
****    'DISC LOAN '          C         W#PST6                             240327 CPK025
****    'DISC PA PU'          C         W#PST7                             240327 CPK025
****    'DISC PA SL'          C         W#PST8                             240327 CPK025
****    'CALL PA PU'          C         W#PST9                             240327 CPK025
F          C                   CONST('DISC LOAN ')
G          C                   CONST('DISC PA PU')
H          C                   CONST('DISC PA SL')
I          C                   CONST('CALL PA PU')
0          C                   CONST('CALL PA SL')
1          C                   CONST('RISK PA PU')
2          C                   CONST('RISK P SL1')
3          C                   CONST('RISK P SL2')
4          C                   CONST('GUAR ISSUE')

M        E DS                  EXTNAME(CUTX1HN)
ernal DS for parameter passed from CG6030
C2       E                     EXTFLD(BRCA)                         102468
U2       E                     EXTFLD(CNUM)                         102468
D2       E                     EXTFLD(RCDT)                         102468
A2       E                     EXTFLD(VDAT)
S2       E                     EXTFLD(PRSQ)                         102468
S2       E                     EXTFLD(LASN)                         102468
Y2       E                     EXTFLD(FTYP)                         102468
E2       E                     EXTFLD(FSEQ)                         102468
T2       E                     EXTFLD(AMTP)                         102468
A2       E                     EXTFLD(PRAM)
T2       E                     EXTFLD(BRTE)
S2       E                     EXTFLD(RTSP)
N2       E                     EXTFLD(SPIN)
T2       E                     EXTFLD(INTA)
C2       E                     EXTFLD(INTC)
P2       E                     EXTFLD(TIPD)
I2       E                     EXTFLD(WTIN)

R        E DS                  EXTNAME(CGUDCRPD)
ternal DS for incomplete reference

K        E DS                  EXTNAME(SDBANKPD)
ternal DS for Bank details
WNCPYSRC,CG6036I001

R        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
ternal DS for currency details

T        E DS                  EXTNAME(SDCUSTPD)                    CEU014
ternal DS for customer details                                CEU014
WNCPYSRC,CG6036I002
                                                              CEU014
R        E DS                  EXTNAME(SDGELRPD)                    CEU014
ternal DS for General Ledger details                          CEU014
                                                              CEU014
         E DS                  EXTNAME(DSFDY)
rst DS for access programs, short data structure

         E DS                  EXTNAME(DSSDY)
cond DS for access programs, long data structure

         E DS                  EXTNAME(CGUDTAPD)
cord format of PF/CGUDTAPD for use as a parameter


 to store subroutine specific data.
Saved Path

H          DS                  OCCURS(20)
PS                 1      6

D          DS                  OCCURS(20)
IN                 1      6  0 INZ(1)
IN                 7     12  0 INZ(1)

           DS
ND                 1      6  0 INZ(1)

           DS
                   1      3  0 INZ(0)
                   4      6  0
                   7      9  0
                  10     12  0
                  13     15  0

           DS
                   1      7P 0
UP                 1      7P 2

D        E DS                  EXTNAME(SCSARDPD)



LF
ame fields of CLOANCL
        RECI                        ##RECI
        LNRF                        ##LNRF
        RCDT                        ##RCDT
        MRIN                        ##MRIN
        PTYP                        ##PTYP
        CNUM                        ##CNUM
        BRCA                        ##BRCA
        LTYP                        ##LTYP
        SUTP                        ##SUTP
        DDAT                        ##DDAT
        VDAT                        ##VDAT
        MDAT                        ##MDAT
        LASQ                        ##LASQ
        FCUS                        ##FCUS
        FTYP                        ##FTYP
        FSEQ                        ##FSEQ
        CCY                         ##CCY1
        CPAM                        ##CPAM
        INTC                        ##INTC
        INTR                        ##INTR
        BRTT                        ##BRTT
        BRTE                        ##BRTE
        RTSP                        ##RTSP
        MARG                        ##MARG
        SPIN                        ##SPIN
        CHIN                        ##CHIN
        WTRT                        ##WTRT
        WTIN                        ##WTIN
        REPT                        ##REPT
        RAMT                        ##RAMT
        NRPD                        ##NRPD
        RFRQ                        ##RFRQ
        RDYN                        ##RDYN
        FCCY                        ##FCCY
        LIND                        ##LIND
        CRSK                        ##CRSK
        ACOF                        ##ACOF
        NACD                        ##NACD
        RELI                        ##RELI
        AUTO                        ##AUT1
        PSAM                        ##PSAM
        BCXR                        ##BCXR
        FCXR                        ##FCXR
        SDST                        ##SDST
        OSDA                        ##OSDA
        TSTN                        ##TSTN
        MDST                        ##MDST
        OMDA                        ##OMDA
        TMAN                        ##TMAN
        FACO                        ##FACO
        RLDT                        ##RLDT
        NROD                        ##NROD
        RLFQ                        ##RLFQ
        RLDY                        ##RLDY
        RDFC                        ##RDFC
        NBRA                        ##NBRA
        NRTS                        ##NRTS
        NSIN                        ##NSIN
        NCAS                        ##NCAS
        AWTP                        ##AWTP
        WTRD                        ##WTRD
        WTWD                        ##WTWD
        IWOD                        ##IWOD
        PWOD                        ##PWOD
        BMDI                        ##BMDI
        FMDI                        ##FMDI
        PDIN                        ##PDIN
        LSWC                        ##LSWC
        LSWS                        ##LSWS
        OSDB                        ##OSDB
        OMDB                        ##OMDB
        ORBR                        ##ORBR
        PRFC                        ##PRFC
        FCLB                        ##FCLB
        MLNR                        ##MLNR
        BTIN                        ##BTIN
        BLDY                        ##BLDY
        OLNO                        ##OLNO
        RCSI                        ##RCSI
        ICBS                        ##ICBS
        IPFR                        ##IPFR
        TOTI                        ##TOTI
        NIDT                        ##NIDT
        IBDT                        ##IBDT
        SLID                        ##SLID
        AIPD                        ##AIPD
        DLRC                        ##DLRC
        IACD                        ##IACD
        AITC                        ##AITC
        TFEP                        ##TFEP
        AIAP                        ##AIAP
        IPRD                        ##IPRD
        IPRM                        ##IPRM
        ICTD                        ##ICTD
        AIMN                        ##AIMN
        RBDT                        ##RBDT
        NOPS                        ##NOPS
        NCHI                        ##NCHI
        IFDY                        ##IFDY
        LONI                        ##LONI
        CNFI                        ##CNFI
        ACEI                        ##ACEI
        TLXI                        ##TLXI
        CBLI                        ##CBLI
        ORED                        ##ORED
        LCD                         ##LCD
        CHTP                        ##CHTP
        TNLU                        ##TNLU
        ADDI                        ##ADDI
        ORMD                        ##ORMD
        ORTI                        ##ORTI
        BOKC                        ##BOKC
        COCU                        ##COCU
        RECE                        ##RECE
        OMDT                        ##OMDT
        NIPD                        ##NIPD
        NMDT                        ##NMDT
        APMI                        ##APMI
        RSTM                        ##RSTM
        RONS                        ##RONS
        RIBN                        ##RIBN
        RIBA                        ##RIBA
        ROBN                        ##ROBN
        ROCN                        ##ROCN
        PSTM                        ##PSTM
        PONS                        ##PONS
        PIBN                        ##PIBN
        PIBA                        ##PIBA
        POBN                        ##POBN
        POCN                        ##POCN
        RCRN                        ##RCRN
        RCRA                        ##RCRA
        RVNO                        ##RVNO
        AWBN                        ##AWBN
        AWBA                        ##AWBA
        BENN                        ##BENN
        BENA                        ##BENA
        DTP1                        ##DTP1
        DTP2                        ##DTP2
        DTP3                        ##DTP3
        DTP4                        ##DTP4
        DCHG                        ##DCHG
        BTB1                        ##BTB1
        BTB2                        ##BTB2
        BTB3                        ##BTB3
        BTB4                        ##BTB4
        BTB5                        ##BTB5
        BTB6                        ##BTB6
        CVMR                        ##CVMR
        PTFR                        ##PTFR
        SCCY                        ##STCY                          CEU003
        OCDT                        ##OCDT
        EAIR                        ##EAIR

KF
ame fields of CLOANCK
        RECI                        ##RECI
        LNRF                        ##LNRF
        RCDT                        ##RCDT
        MRIN                        ##MRIN
        NAR1                        ##NAR1
        NAR2                        ##NAR2
        NAR3                        ##NAR3
        NAR4                        ##NAR4
        OPAM                        ##OPAM
        FRBC                        ##FRBC
        YPLN                        ##YPLN
        YFLN                        ##YFLN
        YWLN                        ##YWLN
        ABLN                        ##ABLN
        YPLC                        ##YPLC
        YFLC                        ##YFLC
        YWLC                        ##YWLC
        ABLC                        ##ABLC
        WWLN                        ##WWLN
        IWLN                        ##IWLN
        PWLN                        ##PWLN
        RDST                        ##RDST
        SPI1                        ##SPI1
        SPI2                        ##SPI2
        SPI3                        ##SPI3
        YILN                        ##YILN
        F57U                        ##F57U
        ORVD                        ##ORVD
        THRN                        ##THRN
        NPRAM                       ##NPAM
        NDAM                        ##NDAM
        RLBR                        ##RLBR
        ORED                        ##ORED
        LCD                         ##LCD
        CHTP                        ##CHTP
        TNLU                        ##TNLU

PF
ame fields of CUTX1HP
        ACUP0                       ACUP
                                                                                  CCG015
ta structure for SAR data.                                                        CCG015

***********************************************************
                                                          *
cess     :  MAINLINE                                      *
ction    :  Mainline Processing                           *
                                                          *
led by   :  None                                          *
ls       :  SRINIT - Initial Processing - On First Call   *
            SRINZF - Initialise Fields on Each Invocation *
            SRMAIN - Main Processing                      *
                                                          *
***********************************************************

rameter list for current program invocation.

ENTRY        PLIST
             PARM                    W0RTN             7
             PARM                    W0CMT             3
             PARM                    ##COPD            1
             PARM                    DSPARM

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'MAIN'        @STK(Q)

itial processing - Once Only.

#INIT        IFEQ      *BLANK
             EXSR      SRINIT
             MOVE      'Y'           ##INIT            1
             ENDIF

itialisation processing.

             EXSR      SRINZF

in processing.

             EXSR      SRMAIN

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

rminate program.

             RETURN

***********************************************************

***********************************************************
                                                          *
routine  :  SRMAIN                                        *
ction    :  Main Processing                               *
                                                          *
led by   :  MAINLINE - Mainline Processing                *
ls       :  SRDETL - Obtain Detail Information            *
            SRGENR - Generate Reference Number            *
            L05IN  - Lending Interest Advices             *
                                                          *
***********************************************************

RMAIN        BEGSR                                                  ** SRMAIN **

t up subroutine stack name.

             ADD       1             Q                 5 0
             MOVEL     'SRMAIN'      @STK(Q)

tain Detail Information.

             EXSR      SRDETL

termine if any movement is to be extracted for the loan.
 none, return to calling program
             EXSR      SRTEST
IN40         CABEQ     *OFF          EXMAIN


nerate reference number by writing to PF/CGUDCRPD.
 no confirmation to be produced, then bypass.

             MOVE      'N'           ##COPD
WNCPYSRC,CG6036C016
             EXSR      SRGENR
#COPD        CABEQ     'N'           EXMAIN

tract.

             EXSR      L05IN

XMAIN        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RMAI9        ENDSR                                                  ** SRMAI9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRDETL                                        *
ction    :  Obtain Detail Information                     *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  None                                          *
                                                          *
***********************************************************

RDETL        BEGSR                                                  ** SRDETL **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'DETAIL'      @STK(Q)

CLOAN        KLIST
             KFLD                    LNRF
             KFLD                    RCDT

             MOVEL     'A'           RCDT
CLOAN        CHAIN     CLOAN                              88
IN88         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE                         ************
             MOVEL     LNRF          W0KEY                          * DBERR 01 *
             Z-ADD     1             W0ERNB                         ************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END
                                                                                 BUG7960
             MOVE      *BLANK        WOLN70            1
#PTYP        IFEQ      72
****           Z-ADDLNRF      WOLNRF  60                                  BUG7960 CLE148
             MOVEL     LNRF          WOLNRF            6
****           Z-ADD##OLNO    LNRF                                       BUG7960 CSD027A
             MOVE      ##OLNO        LNRF
             MOVEL     'A'           RCDT              1
                                                                                 BUG7960
CLOAN        CHAIN     CLOAN                              88
IN88         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE
             MOVEL     LNRF          W0KEY
             Z-ADD     17            W0ERNB
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                 BUG7960
#PTYP        IFEQ      70
             MOVE      'Y'           WOLN70
             ENDIF
                                                                                 BUG7960
chain to get original loan details                                               BUG7960
****           Z-ADDWOLNRF    LNRF                                        BUG7960 CLE148
             MOVEL     WOLNRF        LNRF
             MOVEL     'A'           RCDT              1
                                                                                 BUG7960
CLOAN        CHAIN     CLOAN                              88
IN88         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE
             MOVEL     LNRF          W0KEY
             Z-ADD     18            W0ERNB
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                 BUG7960
             ENDIF
                                                                                  240327
             MOVE      *BLANK        WOLN70            1
#PTYP        IFEQ      72
****           Z-ADDLNRF      WOLNRF  60                                   240327 CLE148
             MOVEL     LNRF          WOLNRF            6
****           Z-ADD##OLNO    LNRF                                         240327 CPK025
             MOVE      ##OLNO        LNRF
             MOVEL     'A'           RCDT              1
                                                                                  240327
CLOAN        CHAIN     CLOAN                              88
IN88         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE                         ************
             MOVEL     LNRF          W0KEY                          * DBERR 14 *
             Z-ADD     14            W0ERNB                         ************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  240327
#PTYP        IFEQ      70
             MOVE      'Y'           WOLN70
             ENDIF
                                                                                  240327
hain CLOANCL to get original loan details                                         240327
                                                                                  240327
****           Z-ADDWOLNRF    LNRF                                         240327 CLE148
             MOVEL     WOLNRF        LNRF
             MOVEL     'A'           RCDT              1
                                                                                  240327
CLOAN        CHAIN     CLOAN                              88
IN88         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE                         ************
             MOVEL     LNRF          W0KEY                          * DBERR 15 *
             Z-ADD     15            W0ERNB                         ************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  240327
             ENDIF

             MOVEL     'B'           RCDT
CLOAN        CHAIN     CLOAN                              88
IN88         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE                         ************
             MOVEL     LNRF          W0KEY                          * DBERR 02 *
             Z-ADD     2             W0ERNB                         ************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RDET9        ENDSR                                                  ** SRDET9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRGENR                                        *
ction    :  Generate reference number by writing to       *
            PF/CGUDCRPD                                   *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  CG9010 - Create Item Reference Records        *
                                                          *
***********************************************************

RGENR        BEGSR                                                  ** SRGENR **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRGENR'      @STK(Q)

nerate reference number and check if further processing
quired. Set up all available information in the record
rmat before calling.

             CLEAR                   ##UDCR

oking/Main Branch (Mandatory).

             MOVEL     BRCA          DRBRCA

iginating Branch (Optional).

             MOVEL     ##ORBR        DRORBR

dule identifier (Mandatory).

             MOVEL     'LE'          DRMODI

das Transaction Number (Mandatory).

             MOVEL     LNRF          DRMTRN

das GL Account Reference CNUMCCYACODACSQBRCA  (Optional).

             MOVEL     *BLANKS       DRMACT

int Type.

             MOVEL     W#PTYP        DRPTYP

int Sub-type.

             SELECT
#PTYP        WHENEQ    61
             MOVEL     W#PST1        DRPSTP
#PTYP        WHENEQ    62
             MOVEL     W#PST2        DRPSTP
#PTYP        WHENEQ    64
             MOVEL     W#PST3        DRPSTP
#PTYP        WHENEQ    66
             MOVEL     W#PST4        DRPSTP
#PTYP        WHENEQ    70
             MOVEL     W#PST6        DRPSTP
#PTYP        WHENEQ    63
             MOVEL     W#PST7        DRPSTP
#PTYP        WHENEQ    65
             MOVEL     W#PST8        DRPSTP
#PTYP        WHENEQ    67
             MOVEL     W#PST9        DRPSTP
#PTYP        WHENEQ    68
             MOVEL     W#PSTA        DRPSTP
#PTYP        WHENEQ    69
             MOVEL     W#PSTB        DRPSTP
#PTYP        WHENEQ    71
             MOVEL     W#PSTC        DRPSTP
#PTYP        WHENEQ    72
OLN70        IFEQ      'Y'
             MOVEL     W#PSTD        DRPSTP
             ELSE
             MOVEL     W#PSTE        DRPSTP
             ENDIF
#PTYP        WHENEQ    80
LE028        ANDEQ     'Y'
             MOVEL     W#PST5        DRPSTP
#PTYP        WHENEQ    70
             MOVEL     W#PS14        DRPSTP
#PTYP        WHENEQ    63
****           MOVELW#PST6    DRPSTP                                       240327 CPK025
             MOVEL     W#PSTF        DRPSTP
#PTYP        WHENEQ    65
****           MOVELW#PST7    DRPSTP                                       240327 CPK025
             MOVEL     W#PSTG        DRPSTP
#PTYP        WHENEQ    67
****           MOVELW#PST8    DRPSTP                                       240327 CPK025
             MOVEL     W#PSTH        DRPSTP
#PTYP        WHENEQ    68
****           MOVELW#PST9    DRPSTP                                       240327 CPK025
             MOVEL     W#PSTI        DRPSTP
#PTYP        WHENEQ    69
             MOVEL     W#PS10        DRPSTP
#PTYP        WHENEQ    71
             MOVEL     W#PS11        DRPSTP
#PTYP        WHENEQ    72
OLN70        IFEQ      'Y'
             MOVEL     W#PS12        DRPSTP
             ELSE
             MOVEL     W#PS13        DRPSTP
             ENDIF
             ENDSL

to Transmission indicator.

             MOVEL     'N'           DRATRM

eque Reference (Optional).

             MOVEL     *BLANKS       DRCHQR

rther Reference (Optional).

             MOVEL     *BLANKS       DRFREF

stomer Number (Mandatory).

             MOVEL     CNUM          ##CUST

             CALL      'CG9010'
             PARM                    ##RTCD            7
             PARM      '*GEN'        ##MODE           10
             PARM      W0CMT         ##CMT             3
             PARM                    ##CUST            6
             PARM                    ##UDCR
             PARM                    ##ITMA            8

ank return code implies generate correspondence.
D1270 => no error, but suppress output for this transaction.

#RTCD        IFEQ      *BLANK

             MOVE      'Y'           ##COPD
                                                                                  CCG015
return code is blank, generate the 'begin' and 'end'                              CCG015
 Extraction Records                                                               CCG015
                                                                                  CCG015
RPTYP        CAT(P)    ':':0         COLON            11
OLON         CAT(P)    DRPSTP:0      ##REFR
             EXSR      WRAPRF

             ELSE

#RTCD        IFNE      'CGD1270'
             MOVEL     'CG9010  '    W0FILE
             MOVEL     ##RTCD        W0KEY                          ************
             Z-ADD     3             W0ERNB                         * DBERR 03 *
             MOVEL     'CGD1286'     W0MSGD                         ************
             MOVEL     'CGUSRMSG'    W0MSGF
             EXSR      SRERR
             ENDIF

             ENDIF

XGENR        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RGEN9        ENDSR                                                  ** SRGEN9 **

***********************************************************

***********************************************************
                                                          *
routine  :  L05IN                                         *
ction    :  Lending Interest Advices                      *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  SRPATH - Generate Path String                 *
            SRSDET - Set-up Settlement Details            *
            LOANA  - Loan Associated Details              *
            LOANIS - Process Loan Interest Summary        *
            LOANID - Process Loan Interest Details        *
                                                          *
***********************************************************

05IN         BEGSR                                                  ** L05IN  **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'L05IN '      @STK(Q)

             ADD       1             P1

1            OCCUR     ##PATH
             MOVEL(P)  'l05IN '      ##GRPS
             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
                                                                                  CCG015
             EXSR      PSHGRS
                                                                                  CCG015
             EXSR      LOANA
             EXSR      SRSDET
             Z-ADD     ##OSEQ        ##WSEQ
             Z-ADD     ##PBIN        ##WPBN
             Z-ADD     ##TBIN        ##WTBN
             ADD       1             ##OSEQ
             EXSR      LOANID
             Z-ADD     ##WSEQ        ##OSEQ
             Z-ADD     ##WPBN        ##PBIN
             Z-ADD     ##WTBN        ##TBIN
             EXSR      LOANIS
                                                                                  CER049
mp Tax details                                                                    CER049
                                                                                  CER049
ER049        IFEQ      'Y'
             EXSR      LNSTAX
             ENDIF

crement Path DS index.

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

05IN9        ENDSR                                                  ** L05IN9 **

***********************************************************

***********************************************************
                                                          *
routine  :  LOANIS                                        *
ction    :  Process Loan Interest Summary                 *
                                                          *
led by   :  L05IN  - Lending Interest Advices             *
ls       :  SRPATH - Generate Path String                 *
            SRDCDT - Determine Currency Details           *
            SRADTA - Accumulate RDEs and Associated Data  *
            SRODTA - Output Accumulated Data to CGUDTAPD  *
                                                          *
***********************************************************

OANIS        BEGSR                                                  ** LOANIS **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'LOANIS'      @STK(Q)

             ADD       1             P1

1            OCCUR     ##PATH
             MOVEL(P)  'LOANIS'      ##GRPS
             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
                                                                                  CCG015
             EXSR      PSHGRS

             Z-ADD     0             R1                3 0

rrency Description.

             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
             MOVEL     A6CYNM        ##WRK            14

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CCY_DESC'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##WRK         R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

rrency.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CURRENCY'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     CCY           R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

oss Interest.

#INC2        IFEQ      'Y'
             Z-ADD     0             ##WGRS           13 0
             ELSE
             Z-ADD     ##INTA        ##WGRS
             END

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'GRS INTR'    #@RDE
             MOVE      'ST'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##WGRS        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C005
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

an Reference.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'LOAN REF'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LNRF          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

t Interest.


#INC2        IFEQ      'Y'
             Z-ADD     0             ##WNET           13 0
             ELSE
#PRAM        ADD       ##INTA        ##WNET
#WTI2        IFEQ      'R'
#WNET        ADD       ##WTXA        ##WNET
             END
             END

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'NET INTR'    #@RDE
             MOVE      'ST'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##WNET        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C006
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ncipal

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'L '          #@RDE
             MOVEL     'PRINCIPA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##PRAM        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C007
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

n date; production time.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'RUNDAT  '    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     BJRDNB        ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

x.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'TAX     '    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##WTXA        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C008
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

x Indicator.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'TAXI    '    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##WTI2        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CLE031
ck for Correct Currency to be used in conversion                                  CLE031
                                                                                  CLE031
LIKE         DEFINE    ##PRAM        WCVAMT
             Z-ADD     ##PRAM        WCVAMT
             EXSR      SRCCHK
                                                                                  CLE031
                                                              CEU003
ncipal in Settlement Currency; calculate using EU0200.        CEU003
                                                              CEU003
             ADD       1             R1                                            CEU00
             CLEAR                   R#DATA                                        CEU00
             CLEAR                   R#DEFN                                        CEU00
             CLEAR                   #@RDE                                         CEU00
             MOVEL     'PRNC_SC '    #@RDE                                         CEU00
#RDE         CAT       #@RDE:1       ##RDE                                         CEU00
             MOVEL     'Amount'      ##RDEC                                        CEU00
             MOVEL     'L'           ##RDET                                        CEU00
             MOVEL     R#DEFN        ##R(R1)                                       CEU00
                                                              CEU003
CCY          IFNE      *BLANKS                                                     CEU00
LE031        ANDEQ     'N'
LE031        OREQ      'Y'
EURUN        ANDEQ     'Y'
CCY          ANDNE     *BLANKS
                                                              CEU003
LIKE         DEFINE    ##PRAM        ##PRSC                                        CEU00
             CALL      'EU0200'                                                    CEU00
             PARM      *BLANKS       P@RTCD            7            Return Code    CEU00
             PARM      ##PRAM        P@FRAM           18 3          FROM Ccy AmountCEU00
             PARM      CCY           P@FRCY            3            FROM Currency  CEU00
             PARM      SCCY          P@TOCY            3            TO Currency    CEU00
#PRSC        PARM                    P@OUTA           15 0          Outright AmountCEU00
             PARM                    P@INTA           18 3          Interim Amount CEU00
             PARM                    P@EXRT           15 9          Exchange Rate  CEU00
             PARM                    P@MDIN            1            Mult/Div Ind.  CEU00
                                                              CEU003
  Database error handling:                                    CEU003
                                                              CEU003
@RTCD        IFEQ      '*ERROR*'                                                   CEU00
             MOVEL     'EU0200  '    W0FILE                                        CEU00
             MOVEL     ##RTCD        W0KEY                          ************   CEU00
             Z-ADD     9             W0ERNB                         * DBERR 09 *   CEU00
             MOVEL     'MEM5003'     W0MSGD                         ************   CEU00
             MOVEL     'MIDAS   '    W0MSGF                                        CEU00
             EXSR      SRERR                                                       CEU00
                                                              CEU003
             ELSE                                                                  CEU00
             MOVEL     ##PRSC        ##DATA                                        CEU00
             ENDIF                                                                 CEU00
                                                              CEU003
  Calculate number of decimal places using SRDCDT             CEU003
                                                              CEU003
             MOVEL     SCCY          ##CCY                                         CEU00
             EXSR      SRDCDT                                                      CEU00
             MOVEL     A6NBDP        ##DCPA                                        CEU00
             MOVEL     R#DATA        ##D(R1)                                       CEU00
                                                              CEU003
             ENDIF                                                                 CEU00
                                                                                  CLE031
ck for Correct Currency to be used in conversion                                  CLE031
                                                                                  CLE031
             Z-ADD     ##WNET        WCVAMT
             EXSR      SRCCHK
                                                                                  CLE031
                                                              CEU003
t Interest in Settlement Currency; calculate using EU0200.    CEU003
                                                              CEU003
             ADD       1             R1                                            CEU00
             CLEAR                   R#DATA                                        CEU00
             CLEAR                   R#DEFN                                        CEU00
             CLEAR                   #@RDE                                         CEU00
             MOVEL     'NI_SC   '    #@RDE                                         CEU00
#RDE         CAT       #@RDE:1       ##RDE                                         CEU00
             MOVEL     'Amount'      ##RDEC                                        CEU00
             MOVEL     'L'           ##RDET                                        CEU00
             MOVEL     R#DEFN        ##R(R1)                                       CEU00
                                                              CEU003
CCY          IFNE      *BLANKS                                                     CEU00
LE031        ANDEQ     'N'
LE031        OREQ      'Y'
EURUN        ANDEQ     'Y'
CCY          ANDNE     *BLANKS
                                                              CEU003
LIKE         DEFINE    ##WNET        ##NISC                                        CEU00
             CALL      'EU0200'                                                    CEU00
             PARM      *BLANKS       P@RTCD            7            Return Code    CEU00
             PARM      ##WNET        P@FRAM           18 3          FROM Ccy AmountCEU00
             PARM      CCY           P@FRCY            3            FROM Currency  CEU00
             PARM      SCCY          P@TOCY            3            TO Currency    CEU00
#NISC        PARM                    P@OUTA           15 0          Outright AmountCEU00
             PARM                    P@INTA           18 3          Interim Amount CEU00
             PARM                    P@EXRT           15 9          Exchange Rate  CEU00
             PARM                    P@MDIN            1            Mult/Div Ind.  CEU00
                                                              CEU003
  Database error handling:                                    CEU003
                                                              CEU003
@RTCD        IFEQ      '*ERROR*'                                                   CEU00
             MOVEL     'EU0200  '    W0FILE                                        CEU00
             MOVEL     ##RTCD        W0KEY                          ************   CEU00
             Z-ADD     10            W0ERNB                         * DBERR 10 *   CEU00
             MOVEL     'MEM5003'     W0MSGD                         ************   CEU00
             MOVEL     'MIDAS   '    W0MSGF                                        CEU00
             EXSR      SRERR                                                       CEU00
                                                              CEU003
             ELSE                                                                  CEU00
             MOVEL     ##NISC        ##DATA                                        CEU00
             ENDIF                                                                 CEU00
                                                              CEU003
  Calculate number of decimal places using SRDCDT             CEU003
                                                              CEU003
             MOVEL     SCCY          ##CCY                                         CEU00
             EXSR      SRDCDT                                                      CEU00
             MOVEL     A6NBDP        ##DCPA                                        CEU00
             MOVEL     R#DATA        ##D(R1)                                       CEU00
                                                              CEU003
             ENDIF                                                                 CEU00
                                                              CEU014
014 Changes.                                                  CEU014
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
             MOVE      *BLANKS       EQCY                                          CEU01
             MOVE      CCY           ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
6INCY        IFEQ      'Y'                                                         CEU01
             MOVE      BKEURO        EQCY                                          CEU01
             ENDIF                                                                 CEU01
CY           IFEQ      BKEURO                                                      CEU01
                                                              CEU014
 Customer Details                                             CEU014
                                                              CEU014
             MOVEL     CNUM          ##KEY1                                        CEU01
             CALL      'AOCUSTR0'                                                  CEU01
             PARM      *BLANKS       ##RTCD                                        CEU01
             PARM      '*KEY   '     ##OPTN                                        CEU01
             PARM                    ##KEY1           10                           CEU01
             PARM      *BLANKS       ##KYST            7                           CEU01
DCUST        PARM      SDCUST        DSSDY                                         CEU01
                                                              CEU014
abase Error                                                   CEU014
                                                              CEU014
#RTCD        IFNE      *BLANK                                                      CEU01
             MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
             MOVEL     CNUM          W0KEY                          ***************CEU01
             Z-ADD     11            W0ERNB                         * DB ERROR 11 *CEU01
             MOVEL     'MEM5004'     W0MSGD                         ***************CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             END                                                                   CEU01
             MOVE      BBDINC        EQCY                                          CEU01
             ENDIF                                                                 CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ract Principal in Equivalent Currency                         CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVE      'Y '          #@RDE                                         CEU01
             MOVEL     'PRNC_EQC'    #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     EQCY          ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             Z-ADD     ##PRAM        P@FRAM                                        CEU01
             MOVE      CCY           P@FRCY                                        CEU01
             MOVE      EQCY          P@TOCY                                        CEU01
             EXSR      D@EURO                                                      CEU01
             MOVEL     ##OUTA        ##DATA                                        CEU01
             MOVEL     A6NBDP        ##DCPA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ract Net interest amount in equivalent ccy.                   CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVE      'CY'          #@RDE                                         CEU01
             MOVEL     'N_INT_EQ'    #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     EQCY          ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             Z-ADD     ##WNET        P@FRAM                                        CEU01
             MOVE      CCY           P@FRCY                                        CEU01
             MOVE      EQCY          P@TOCY                                        CEU01
             EXSR      D@EURO                                                      CEU01
             MOVEL     ##OUTA        ##DATA                                        CEU01
             MOVEL     A6NBDP        ##DCPA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ract Equivalent Currency                                      CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVE      'Y '          #@RDE                                         CEU01
             MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     EQCY          ##DATA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ract Equivalent Currency Description                          CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVE      'YD'          #@RDE                                         CEU01
             MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     A6CYNM        ##DATA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
WNCPYSRC,CG6036C004

cumulate RDEs and associated data and output to PF/CGUDTPD.

             EXSR      SRADTA
             EXSR      SRODTA

crement Path DS index.

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

OANI9        ENDSR                                                  ** LOANI9 **

***********************************************************   CEU014
                                                                                  CER049
***********************************************************                       CER049
                                                          *                       CER049
routine  :  LNSTAX                                        *                       CER049
ction    :  Process Stamp Tax Information                 *                       CER049
                                                          *                       CER049
led by   :  L05IN  - Lending Interest Advices             *                       CER049
ls       :  SRPATH - Generate Path String                 *                       CER049
            SRDCDT - Determine Currency Details           *                       CER049
            SRADTA - Accumulate RDEs and Associated Data  *                       CER049
            SRODTA - Output Accumulated Data to CGUDTAPD  *                       CER049
                                                          *                       CER049
***********************************************************                       CER049
                                                                                  CER049
NSTAX        BEGSR                                                  ** LNSTAX **
                                                                                  CER049
t up subroutine stack name.                                                       CER049
                                                                                  CER049
             ADD       1             Q
             MOVEL     'LNSTAX'      @STK(Q)
                                                                                  CER049
             ADD       1             P1
                                                                                  CER049
1            OCCUR     ##PATH
             MOVEL(P)  'LNSTAX'      ##GRPS
             EXSR      SRPATH
                                                                                  CER049
h Order (PF/CGUXMGPD)                                                             CER049
                                                                                  CER049
             EXSR      PSHGRS
                                                                                  CER049
             Z-ADD     0             R1                3 0

t New Fields LIBOR

             MOVEL     *BLANKS       BLRT              1
             MOVEL     *BLANKS       LBDY              2 0
             MOVEL     *BLANKS       LODY              2 0
             MOVEL     *BLANKS       PDLY              2 0
             MOVEL     *BLANKS       BADJ             13 8
             MOVEL     *BLANKS       WGHT              1
             MOVEL     *BLANKS       BRAC              1 0
             MOVEL     *BLANKS       LBAC              2 0
             MOVEL     *BLANKS       PRPL             22 0
             MOVEL     *BLANKS       AVOP              1
             MOVEL     *BLANKS       CART             2015
                                                                                  CER049
t Loan number key                                                                 CER049
                                                                                  CER049
****           Z-ADDLNRF      K1LNRF  60                                   CER049 CLE148
             MOVEL     LNRF          K1LNRF            6
                                                                                  CER049
rieve the stamp tax record for the loan                                           CER049
                                                                                  CER049
1LNRF        CHAIN     CLONCLL1                           98
                                                                                  CER049
record found, extract stamp tax data                                              CER049
                                                                                  CER049
IN98         IFEQ      *OFF
                                                                                  CER049
mp Tax Liable Flag                                                                CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZSTAXFLG'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQTAX         R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
ncipal Tax flag                                                                   CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXPRFL'    #@RDE
             MOVE      'G '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQPRIN        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
rt Date for Principal Tax                                                         CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXPRDT'    #@RDE
             MOVE      'E '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQPDTE        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
rage Balance Flag                                                                 CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXAVFL'    #@RDE
             MOVE      'G '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQAVBL        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
rt Date for Average Balance                                                       CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXAVDT'    #@RDE
             MOVE      'E '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQADTE        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
erest Tax Flag                                                                    CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXINFL'    #@RDE
             MOVE      'G '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQSINT        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
rt Date for Interest Tax                                                          CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXINDT'    #@RDE
             MOVE      'E '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQIDTE        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
it Account Reference                                                              CER049
                                                                                  CER049
QDCST        CAT       LQDCCY        WDRAC1            9
             MOVEL     WDRAC1        WDRAC2           19
             MOVE      LQDACD        WDRAC2
             MOVEL     WDRAC2        WDRAC3           21
             MOVE      LQDASC        WDRAC3
DRAC3        CAT       LQDBRC        WDRACC           24
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ACCOUNT'     #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     WDRACC        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
mp Tax amount                                                                     CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'Z_TAX_AM'    #@RDE
             MOVE      'T '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQSTAB        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     LQDCCY        ##CCY
             EXSR      SRDCDT
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
mp Tax On Interest                                                                CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXINAM'    #@RDE
             MOVE      'T '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQSTAI        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     LQDCCY        ##CCY
             EXSR      SRDCDT
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
mp Tax on Average This Month                                                      CER049
                                                                                  CER049
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZTAXAVAM'    #@RDE
             MOVE      'T '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LQTAXE        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     LQDCCY        ##CCY
             EXSR      SRDCDT
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER049
             ENDIF
                                                                                  CER049
umulate RDEs and associated data and output to PF/CGUDTPD.                        CER049
                                                                                  CER049
             EXSR      SRADTA
             EXSR      SRODTA
                                                                                  CER049
crement Path DS index.                                                            CER049
                                                                                  CER049
1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
             EXSR      POPGRS
                                                                                  CER049
ind subroutine stack name.                                                        CER049
                                                                                  CER049
             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q
                                                                                  CER049
             ENDSR                                                  ** LNSTAX **
                                                                                  CER049
***********************************************************                       CER049
                                                              CEU014
***********************************************************   CEU014
outine  :  D@EURO                                         *   CEU014
tion    :  EURO Currency Conversion:                      *   CEU014
           Converts amount P@FRAM in ccy P@FRCY to amount *   CEU014
           ##OUTA in ccy P@TOCY.                          *   CEU014
ed by   :  LOANIS                                         *   CEU014
                                                          *   CEU014
s       :  EU0200                                         *   CEU014
           SRERR                                          *   CEU014
***********************************************************   CEU014
@EURO        BEGSR                                                                 CEU01
                                                              CEU014
             Z-ADD     0             ##OUTA           13 0                         CEU01
             CALL      'EU0200'                                                    CEU01
             PARM      *BLANKS       P@RTCD            7            Return Code    CEU01
             PARM                    P@FRAM           18 3          FROM Ccy AmountCEU01
             PARM                    P@FRCY            3            FROM Currency  CEU01
             PARM                    P@TOCY            3            TO Currency    CEU01
             PARM                    P@OUTA           15 0          Outright AmountCEU01
             PARM                    P@INTA           18 3          Interim Amount CEU01
             PARM                    P@EXRT           15 9          Exchange Rate  CEU01
             PARM                    P@MDIN            1            Mult/Div Ind.  CEU01
                                                              CEU014
abase error handling:                                         CEU014
                                                              CEU014
@RTCD        IFEQ      '*ERROR*'                                                   CEU01
             MOVEL     'EU0200  '    W0FILE                                        CEU01
             MOVEL     '*CALL   '    W0KEY                          ***************CEU01
             Z-ADD     12            W0ERNB                         * DB ERROR 12 *CEU01
             MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
                                                              CEU014
erwise, store amount in settlement currency as ##OUTA         CEU014
                                                              CEU014
             ELSE                                                                  CEU01
             MOVE      P@OUTA        ##OUTA                                        CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
             ENDSR                                                                 CEU01
WNCPYSRC,CG6036C017
***********************************************************
                                                                                  CLE031
***********************************************************                       CLE031
outine  :  SRCCHK                                         *                       CLE031
tion    :  Ensure that the correct currency code is       *                       CLE031
           used when converting the Principal and         *                       CLE031
           Net Interest                                   *                       CLE031
ed by   :  LOANIS                                         *                       CLE031
                                                          *                       CLE031
s       :  SRCONV                                         *                       CLE031
***********************************************************                       CLE031
RCCHK        BEGSR
                                                                                  CLE031
up Flags                                                                          CLE031
ermine if Loan Currency is an In currency                                         CLE031
                                                                                  CLE031
             MOVE      CCY           ##CCY
             EXSR      SRDCDT
             MOVE      A6INCY        WINCCY            1
             MOVE      A6NBDP        WCCYDP            1
                                                                                  CLE031
INCCY        IFEQ      'N'
                                                                                  CLE031
ermine if Settlement Currency is an In Currency                                   CLE031
                                                                                  CLE031
             MOVE      SCCY          ##CCY
             EXSR      SRDCDT
             MOVE      A6INCY        WINSCY            1
             MOVE      A6NBDP        WSCYDP            1
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
             MOVE      'Y'           WEURUN            1
                                                                                  CLE031
CLE031 in on, Check for In Currencies or convert using ZCONV                      CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
             MOVE      'N'           WEURUN
                                                                                  CLE031
Either Currency is an In Currency, set Flag to run EU0200                         CLE031
                                                                                  CLE031
INCCY        IFEQ      'Y'
INSCY        OREQ      'Y'
             MOVE      'Y'           WEURUN
             ELSE
             MOVE      WCVAMT        PAMT
             MOVE      SEXR          PEXC
             MOVE      SEXI          PMDI
             MOVE      CCY           PFCY
             MOVE      SCCY          PTCY
             MOVE      WCCYDP        PFDP
             MOVE      WSCYDP        PTDP
             EXSR      SRCONV
             MOVE      POUT          ##DATA
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
             ENDSR
***********************************************************                       CLE031
                                                                                  CLE031
***********************************************************                       CLE031
outine  :  SRCONV                                         *                       CLE031
tion    :  Converts from one currency to another          *                       CLE031
           using the ZCONV Module                         *                       CLE031
ed by   :  SRCCHK                                         *                       CLE031
                                                          *                       CLE031
s       :  ZCONV                                          *                       CLE031
***********************************************************                       CLE031
RCONV        BEGSR
                                                                                  CLE031
             CALL      'ZCONVZ1'
             PARM                    PAMT             15 0
             PARM                    PEXC             13 8
             PARM                    PMDI              1
             PARM                    PFCY              3
             PARM                    PTCY              3
             PARM                    PFDP              1 0
             PARM                    PTDP              1 0
             PARM                    POUT             15 0
                                                                                  CLE031
             ENDSR
***********************************************************                       CLE031

***********************************************************
                                                          *
routine  :  LOANID                                        *
ction    :  Process Loan Interest Details                 *
                                                          *
led by   :  L05IN  - Lending Interest Advice              *
ls       :  SRPATH - Generate Path String                 *
            LOANBF - Process Loan B/F Events              *
            SRSMOV - Setup Movement Details               *
            LOANER - Process Loan Events                  *
            LOANCF - Process Loan C/F Events              *
            SRBIND - Generate Binding Numbers             *
                                                          *
***********************************************************

OANID        BEGSR                                                  ** LOANID **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'LOANID'      @STK(Q)

             ADD       1             P1

             MOVE      'Y'           ##WHDR            1

1            OCCUR     ##PATH
             MOVEL(P)  'LOANID'      ##GRPS
             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
                                                                                  CCG015
             EXSR      PSHGRS
                                                                                  CCG015
             EXSR      SRBIND
             EXSR      LOANBF

CUTX0        KLIST
               KFLD           BRCA                            CLE004
               KFLD           CNUM                            CLE004
               KFLD           FTYP                            CLE004
               KFLD           FSEQ                            CLE004
             KFLD                    ##BRCA                                        CLE00
             KFLD                    ##CNUM                                        CLE00
             KFLD                    ##FTYP                                        CLE00
             KFLD                    ##FSEQ                                        CLE00
             KFLD                    LNRF

                                                              156795
tialize amounts                                               156795
                                                              156795
             Z-ADD     0             INTA                                          15679
             Z-ADD     0             PRAM                                          15679
             Z-ADD     0             WTXA                                          15679
                                                              156795
CUTX0        CHAIN     LECUTXL0                           51
IN51         DOWEQ     '0'

MTP          IFEQ      'IN'
TRQ          ANDEQ     'Y'
MTP          OREQ      'RE'
TRQ          ANDEQ     'Y'
MTP          OREQ      'MA'
TRQ          ANDEQ     'Y'

DAT          IFLE      LIPD
             EXSR      SRSMOV

DAT          IFLT      LIPD
DAT          OREQ      LIPD
EPT          ANDEQ     1
DAT          OREQ      LIPD
EPT          ANDEQ     3
DAT          OREQ      LIPD
MTP          ANDEQ     'IN'
DAT          OREQ      LIPD
MTP          ANDEQ     'MA'
DAT          OREQ      LIPD
#VDA2        ANDLT     LIPD
MTP          ANDEQ     'RE'
EPT          ANDEQ     2
             EXSR      LOANER
             END

             END

             ELSE

DAT          IFLT      LIPD
DAT          OREQ      LIPD
#VDA2        ANDLT     LIPD
             EXSR      SRSMOV
             EXSR      LOANER
             END

             END



 CUTX1HP  record, update ZZ006 to allow Repayment Notice
gram to re-process this record and also to allow LE0540
recorgnise that this has already been processed by UDC.

IN30         IFEQ      *ON

             Z-ADD     VDAT          ##VADT            5 0

CDT          IFEQ      'D'
             MOVEL     'Y'           ZZ006
             UPDATE    CUTX1HPF
             ELSE
             MOVE      *BLANKS       BTIN
             UPDATE    CUTX1HQF
             ENDIF

             COMMIT

             ELSE
ock record
             UNLOCK    LECUTXL0

             ENDIF

             MOVE      *OFF          *IN30
                                                              156795
tialize amounts                                               156795
                                                              156795
             Z-ADD     0             INTA                                          15679
             Z-ADD     0             PRAM                                          15679
             Z-ADD     0             WTXA                                          15679
                                                              156795

CUTX0        READE     LECUTXL0                               51

             END
                                                              172049
crement Path DS index AND recreate path                       172049
                                                              172049
1            OCCUR     ##PATH                                                      17204
             CLEAR                   ##GRPS                                        17204
                                                              172049
             MOVEL(P)  'LOANID'      ##GRPS                                        17204
             EXSR      SRPATH                                                      17204
                                                              172049
set Binding information                                       172049
                                                              172049
1            OCCUR     ##BIND                                                      17204

             EXSR      LOANCF

crement Path DS index.

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

OAND9        ENDSR                                                  ** LOAND9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRSMOV                                        *
ction    :  Setup Movement Details                        *
                                                          *
led by   :  LOANID - Process Loan Interest Details        *
ls       :  None                                          *
                                                          *
***********************************************************

RSMOV        BEGSR                                                  ** SRSMOV **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRSMOV'      @STK(Q)

             Z-ADD     0             ##MAMT           13 0

MTP          IFEQ      'PI'
MTP          OREQ      'PT'                                                        CLE00
#LBAL        ADD       PRAM          ##LBAL
             Z-ADD     PRAM          ##MAMT
             END

MTP          IFEQ      'IN'
#INC2        IFEQ      'Y'
#LBAL        ADD       PRAM          ##LBAL
             END
#TIP2        ADD       INTA          ##TIP2
             Z-ADD     INTA          ##MAMT
             END

MTP          IFEQ      'MA'
MTP          OREQ      'RE'
MTP          OREQ      'MR'
MTP          OREQ      'PF'                                                        CLE00
#LBAL        SUB       PRAM          ##LBAL
#TIP2        ADD       INTA          ##TIP2
RAM          ADD       INTA          ##MAMT
             END

MTP          IFEQ      'MI'
             Z-ADD     INTA          ##MAMT
             END

MTP          IFEQ      'SC'
             Z-ADD     RTSP          ##RTS2
             END

MTP          IFEQ      'BC'
MTP          OREQ      'BR'
             Z-ADD     BRTE          ##BRT2
             END

MTP          IFEQ      'RO'
             Z-ADD     RTSP          ##RTS2
             Z-ADD     BRTE          ##BRT2
             MOVEL     SPIN          ##SPN2
             END

#SPN2        IFEQ      'A'
#BRT2        ADD       ##RTS2        ##IRAT           11 7
             ELSE
#SPN2        IFEQ      'S'
#BRT2        SUB       ##RTS2        ##IRAT
             ELSE
#SPN2        IFEQ      'P'
#RTS2        DIV       100           ##WWRK           13 9
#BRT2        MULT      ##WWRK        ##IRAT
             END
             END
             END

             Z-ADD     0             ##MRAT           11 7

MTP          IFEQ      'SC'
MTP          OREQ      'BC'
MTP          OREQ      'BR'
MTP          OREQ      'RO'
             Z-ADD     ##IRAT        ##MRAT
             END

#WCUP        SUB(H)    ##TIP2        ##INTO           13 0

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RSMO9        ENDSR                                                  ** SRSMO9 **

***********************************************************

***********************************************************
                                                          *
routine  :  LOANER                                        *
ction    :  Process Loan Events                           *
                                                          *
led by   :  LOANID - Process Loan Interest Details        *
ls       :  SRPATH - Generate Path String                 *
            LOANEV - Process Loan Event Details           *
            SRBIND - Generate Binding Numbers             *
                                                          *
***********************************************************

OANER        BEGSR                                                  ** LOANER **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'LOANER'      @STK(Q)

             ADD       1             P1

1            OCCUR     ##PATH
             MOVEL(P)  'LOANER'      ##GRPS
             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
                                                                                  CCG015
             EXSR      PSHGRS
                                                                                  CCG015
             EXSR      SRBIND
             EXSR      LOANEV

ore summary details in work fields for later use in
terest summary details extract.

*****          Z-ADDINTA      ##INTA                          156795
*****          Z-ADDPRAM      ##PRAM                          156795
*****          Z-ADDWTXA      ##WTXA                          156795
                                                              156795
rement ##INTA if Amendment Type is Interest Payment (IN),     156795
ayment (RE) or  Maturity Payment (MA).                        156795
                                                              156795
MTP          IFEQ      'IN'                                                        15679
MTP          OREQ      'RE'                                                        15679
MTP          OREQ      'MA'                                                        15679
             ADD       INTA          ##INTA                                        15679
             ENDIF                                                                 15679
                                                              156795
rement ##PRAM if Amendment Type is Repayment (RE) or          156795
urity Payment (MA).                                           156795
                                                              156795
MTP          IFEQ      'RE'                                                        15679
MTP          OREQ      'MA'                                                        15679
             ADD       PRAM          ##PRAM                                        15679
             ENDIF                                                                 15679
             ADD       WTXA          ##WTXA                                        15679

t on *IN30 to signify this record has been processed
ccessfully.

             MOVE      *ON           *IN30

crement Path DS index.

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

OANE9        ENDSR                                                  ** LOANE9 **

***********************************************************

***********************************************************
                                                          *
routine  :  LOANEV                                        *
ction    :  Process Loan Event Details                    *
                                                          *
led by   :  LOANER - Process Loan Events                  *
ls       :  SRPATH - Generate Path String                 *
            SRDCDT - Determine Currency Details           *
            SRADTA - Accumulate RDEs and Associated Data  *
            SRODTA - Output Accumulated Data to CGUDTAPD  *
                                                          *
***********************************************************

OANEV        BEGSR                                                  ** LOANEV **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'LOANEV'      @STK(Q)

             ADD       1             P1

1            OCCUR     ##PATH
             MOVEL(P)  'LOANEV'      ##GRPS
             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
                                                                                  CCG015
             EXSR      PSHGRS

             Z-ADD     0             R1                3 0

endment Type.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'AMEND TY'    #@RDE
             MOVE      'PE'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     AMTP          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

mber of Days Interest.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'DAYS INT'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     DAYS          ##DATA
             MOVEL     'Number'      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

terest Rate.

#WHDR        IFEQ      'Y'
             Z-ADD     ##IRAT        ##INTE           11 7
             MOVE      ' '           ##WHDR
             ELSE
             Z-ADD     ##IRA2        ##INTE
             END

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'INT RATE'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##INTE        ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

             Z-ADD     ##IRAT        ##IRA2           11 7

terest Outstanding.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'INTOUTS '    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##INTO        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C009
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

an Balance.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'LOAN BAL'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##LBAL        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C010
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

vement Amount.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'MOVE AMN'    #@RDE
             MOVE      'T '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##MAMT        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C011
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

vement Rate.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'MOVE RAT'    #@RDE
             MOVE      'E '          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##MRAT        ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

lue Date.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'VALUE DA'    #@RDE
             MOVE      'TE'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     VDAT          ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

OR Deregulation BACKWARD-LOOKING RATE

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'BCKLOKRA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     BLRT          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

raging Option

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'N'           #@RDE
             MOVEL     'AVGOPTIO'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     AVOP          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

pounded/Average Rate

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'AR'          #@RDE
             MOVEL     'COMPOUND'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     CART          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

kback Days

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'AY'          #@RDE
             MOVEL     'LOOKBCKD'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LBDY          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

kout Days

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'AY'          #@RDE
             MOVEL     'LOCKOUTD'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LODY          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ayed Payment Days

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'YS'          #@RDE
             MOVEL     'DLYPAYDA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     PDLY          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

chmark Adjustment Days

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'OD'          #@RDE
             MOVEL     'BMRKADJC'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     BADJ          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ght Convention

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'OD'          #@RDE
             MOVEL     'BMRKADJC'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     WGHT          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

e Rate Code for Accrual

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'BRACCRRA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     BRAC          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

kback Days for Accrual

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'BRACCRRA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LBAC          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ncipal

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'L'           #@RDE
             MOVEL     'PRINCIPA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     PRPL          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

WNCPYSRC,CG6036C003
                                                                                  CLE143
LE143        IFEQ      'Y'
                                                                                  CLE143
ective Annual Interest Rate                                                       CLE143
                                                                                  CLE143
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'EFFAINTR'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##EAIR        ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
****           MOVEL'7'       ##DCPA                                     CLE143 AR822053
             MOVEL     '8'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CLE143
143 Switchable Feature status RDE                                                 CLE143
                                                                                  CLE143
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CLE143F '    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     CLE143        ##DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CLE143
             ENDIF
                                                                                  CER050
ER050        IFEQ      'Y'
             EXSR      ZI@APR
             ENDIF

cumulate RDEs and associated data and output to PF/CGUDTPD.

             EXSR      SRADTA
             EXSR      SRODTA

crement Path DS index.

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

OANV9        ENDSR                                                  ** LOANV9 **
                                                                                  CER050
***********************************************************                       CER050
outine  :  ZI@APR                                         *                       CER050
tion    :  Extract - Annualised Percentage Rate (APR)     *                       CER050
                                                          *                       CER050
ed by   :                                                 *                       CER050
s       :                                                 *                       CER050
***********************************************************                       CER050
I@APR        BEGSR
                                                                                  CER050
ly if processing type is 61, 62 or 63                                             CER050
#PTYP        IFEQ      61
#PTYP        OREQ      62
#PTYP        OREQ      63
                                                                                  CER050
this process only if Do not print APR is set to Blank                             CER050
                                                                                  CER050
PRC          IFEQ      'Y'
NRF          CHAIN     LEAPRHI0                           89
                                                                                  CER050
 FOR THE FIRST ELEMENT IN BLANK IN SERIE                                          CER050
             Z-ADD     1             R1
#R(R1)       DOUEQ     *BLANKS
1            OREQ      20
             ADD       1             R1
             ENDDO
                                                                                  CER050
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ZI_AAPR '    #@RDE            10
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     IAPRR         R#DATA
             MOVEL     IAPRR         ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '2'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CER050
             END
             ENDIF
                                                                                  CER050
             ENDSR

***********************************************************

***********************************************************
                                                          *
routine  :  LOANCF                                        *
ction    :  Process Loan C/F Events                       *
                                                          *
led by   :  LOANID - Process Loan Interest Details        *
ls       :  SRPATH - Generate Path String                 *
            SRDCDT - Determine Currency Details           *
            SRADTA - Accumulate RDEs and Associated Data  *
            SRODTA - Output Accumulated Data to CGUDTAPD  *
                                                          *
***********************************************************

OANCF        BEGSR                                                  ** LOANCF **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'LOANCF'      @STK(Q)

             ADD       1             P1

1            OCCUR     ##PATH
             MOVEL(P)  'LOANCF'      ##GRPS
             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
                                                                                  CCG015
             EXSR      PSHGRS

             Z-ADD     0             R1                3 0

F Date.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CF DATE '    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##VADT        ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

F Interest Outstanding.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CF INTOU'    #@RDE
             MOVE      'TS'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##INTO        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C012
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

F Loan Balance.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CF LOANB'    #@RDE
             MOVE      'AL'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##LBAL        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C013
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

cumulate RDEs and associated data and output to PF/CGUDTPD.

             EXSR      SRADTA
             EXSR      SRODTA

crement Path DS index.

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

OANC9        ENDSR                                                  ** LOANC9 **

***********************************************************

***********************************************************
                                                          *
routine  :  LOANBF                                        *
ction    :  Process Loan B/F Events                       *
                                                          *
led by   :  LOANID - Process Loan Interest Details        *
ls       :  SRPATH - Generate Path String                 *
            SRDCDT - Determine Currency Details           *
            SRADTA - Accumulate RDEs and Associated Data  *
            SRODTA - Output Accumulated Data to CGUDTAPD  *
                                                          *
***********************************************************

OANBF        BEGSR                                                  ** LOANBF **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'LOANBF'      @STK(Q)

             ADD       1             P1

1            OCCUR     ##PATH
             MOVEL(P)  'LOANBF'      ##GRPS
             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
                                                                                  CCG015
             EXSR      PSHGRS

             Z-ADD     0             R1                3 0

F Interest Outstanding.

#INT2        SUB       ##TIP2        ##BFIN           13 0

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'BF INTOU'    #@RDE
             MOVE      'TS'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##BFIN        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C014
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

F Loan Balance.

             Z-ADD     ##PRA2        ##LBAL           13 0

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'BF LOANB'    #@RDE
             MOVE      'AL'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##PRA2        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6036C015
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ought Forward Date.

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'BR_FWD_D'    #@RDE
             MOVE      'AT'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##VDA2        ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

cumulate RDEs and associated data and output to PF/CGUDTPD.

             EXSR      SRADTA
             EXSR      SRODTA

crement Path DS index.

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

OANB9        ENDSR                                                  ** LOANB9 **

***********************************************************

***********************************************************
                                                          *
routine  :  LOANA                                         *
ction    :  Loan Associated Details                       *
                                                          *
led by   :  L05IN  - Lending Interest Advices             *
ls       :  SRPATH - Generate Path String                 *
            CG6001 - General Loan Details                 *
***********************************************************

OANA         BEGSR                                                  ** LOANA  **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'LOANA '      @STK(Q)

             EXSR      SRPATH

             MOVEL     S#PATH        P2PARM
             Z-ADD     ##OSEQ        P1OSEQ
             Z-ADD     ##ITEM        P1ITEM
             Z-ADD     ##TBIN        P1TBIN
             Z-ADD     ##PBIN        P1PBIN

t up data.

             CLEAR                   P4PARM
             MOVE      *BLANKS       P@CNAM
             MOVE      LNRF          P@LNRF
             CALL      'CG6001'
             PARM      *BLANKS       W0RTN             7
             PARM                    W0CMT             3
             PARM                    P1PARM                         UDC Details
             PARM                    P2PARM          140            Path Details
             PARM                    P@PARM                         Loan Details
             PARM                    P4PARM                         Facility Details
             PARM                    ##AUTO            1
             PARM                    ##REFR
             PARM                    P@ICR
             PARM      'N'           ##MAST

set Sequence number.

             Z-ADD     P1OSEQ        ##OSEQ

XXPAY        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

OANA9        ENDSR                                                  ** LOANA9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRSDET                                        *
ction    :  Set-up settlement details                     *
                                                          *
led by   :  L05IN - Lending Interest Advices              *
ls       :  SRPATH - Generate Path String                 *
            CG99LSET - To set-up settlement details       *
                                                          *
***********************************************************

RSDET        BEGSR                                                  ** SRSDET **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRSDET'      @STK(Q)

             ADD       1             P1
                                                                                  CCG015
1            OCCUR     ##PATH
             MOVEL(P)  'L_SETL'      ##GRPS
             EXSR      SRPATH
             EXSR      PSHGRS

             MOVEL     S#PATH        P2PARM

tup the parameters for CG99LSET.

             CLEAR                   P0PARM
             MOVEL     ##OSDB        P0POBR
             MOVEL     ##OMDB        P0ROBR
             Z-ADD     ##RSTM        P0RSTM
             MOVEL     ##RONS        P0RONS
             MOVEL     ##RIBN        P0RIBN
             MOVEL     ##RIBA        P0RIBA
****           Z-ADD##ROBN    P0ROBN                                              CSD027
****           Z-ADD##ROCN    P0ROCN                                              CSD027
             MOVE      ##ROBN        P0ROBN
             MOVE      ##ROCN        P0ROCN
             Z-ADD     ##PSTM        P0PSTM
             MOVEL     ##PONS        P0PONS
             MOVEL     ##PIBN        P0PIBN
             MOVEL     ##PIBA        P0PIBA
****           Z-ADD##POBN    P0POBN                                              CSD027
****           Z-ADD##POCN    P0POCN                                              CSD027
             MOVE      ##POBN        P0POBN
             MOVE      ##POCN        P0POCN
             MOVEL     ##RCRN        P0RCRN
             MOVEL     ##RCRA        P0RCRA
             MOVEL     ##RVNO        P0RVNO
             MOVEL     ##AWBN        P0AWBN
             MOVEL     ##AWBA        P0AWBA
             MOVEL     ##BENN        P0BENN
             MOVEL     ##BENA        P0BENA
             MOVEL     ##DTP1        P0DTP1
             MOVEL     ##DTP2        P0DTP2
             MOVEL     ##DTP3        P0DTP3
             MOVEL     ##DTP4        P0DTP4
             MOVEL     ##DCHG        P0DCHG
             MOVEL     ##BTB1        P0BTB1
             MOVEL     ##BTB2        P0BTB2
             MOVEL     ##BTB3        P0BTB3
             MOVEL     ##BTB4        P0BTB4
             MOVEL     ##BTB5        P0BTB5
             MOVEL     ##BTB6        P0BTB6
             MOVEL     ##SPI1        P0SPI1
             MOVEL     ##SPI2        P0SPI2
             MOVEL     ##SPI3        P0SPI3
****           MOVEL##STCY    P0STCY                    CEU003137658
             MOVEL     SCCY          P0STCY                                        13765
             MOVEL     SCCY          P0PSCY

             Z-ADD     ##OSEQ        P1OSEQ
             Z-ADD     ##ITEM        P1ITEM
             Z-ADD     ##TBIN        P1TBIN
             Z-ADD     ##PBIN        P1PBIN

             CALL      'CG99LSET'
             PARM      *BLANKS       W0RTN             7
             PARM                    W0CMT             3
             PARM                    ##COPD
             PARM                    P1PARM
             PARM                    P2PARM          140
             PARM                    PDETLS
             PARM                    P0PARM
             PARM                    ##REFR
             PARM                    P@ICR
             PARM      'N'           ##MAST

0RTN         IFNE      *BLANK
             MOVEL     'CG99LSET'    W0FILE
             MOVEL     'W0RTN'       W0KEY                          ************
             Z-ADD     4             W0ERNB                         * DBERR 04 *
             MOVEL     'MEM5003'     W0MSGD                         ************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

set Sequence number.

             Z-ADD     P1OSEQ        ##OSEQ
                                                                                  CCG015
crement Path DS index                                                             CCG015
                                                                                  CCG015
1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RSDE9        ENDSR                                                  ** SRSDE9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRTEST                                        *
ction    :  Determine if a movement will be extracted     *
                                                          *
led by   :  MAINLINE - Mainline Processing                *
ls       :  None                                          *
                                                          *
***********************************************************

RTEST        BEGSR                                                  ** SRTEST **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRTEST'      @STK(Q)

             MOVE      *OFF          *IN40

                                                              156795
tialize amounts                                               156795
                                                              156795
             Z-ADD     0             INTA                                          15679
             Z-ADD     0             PRAM                                          15679
             Z-ADD     0             WTXA                                          15679
                                                              156795
CUTX0        CHAIN     LECUTXL0                           50

 least one record must pass the selection criteria

IN50         DOWEQ     *OFF
IN40         ANDEQ     *OFF

endment type must be IN/MA/RE and Bill/Telex Req = Y

MTP          IFEQ      'IN'
TRQ          ANDEQ     'Y'
MTP          OREQ      'RE'
TRQ          ANDEQ     'Y'
MTP          OREQ      'MA'
TRQ          ANDEQ     'Y'

DAT          IFLE      LIPD

DAT          IFLT      LIPD
DAT          OREQ      LIPD
EPT          ANDEQ     1
DAT          OREQ      LIPD
EPT          ANDEQ     3
DAT          OREQ      LIPD
MTP          ANDEQ     'IN'
DAT          OREQ      LIPD
MTP          ANDEQ     'MA'
DAT          OREQ      LIPD
#VDA2        ANDLT     LIPD
MTP          ANDEQ     'RE'
EPT          ANDEQ     2
             MOVE      *ON           *IN40
             END

             END

her than MA/IN/RE and BTRQ=Y......

             ELSE

DAT          IFLT      LIPD
DAT          OREQ      LIPD
#VDA2        ANDLT     LIPD
             MOVE      *ON           *IN40
             END

             END

                                                              156795
tialize amounts                                               156795
                                                              156795
             Z-ADD     0             INTA                                          15679
             Z-ADD     0             PRAM                                          15679
             Z-ADD     0             WTXA                                          15679
                                                              156795
CUTX0        READE     LECUTXL0                               50

             ENDDO

ock file
             UNLOCK    LECUTXL0

XTES         TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RTES9        ENDSR                                                  ** SRTES9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRINZF                                        *
ction    :  Initialise Fields on Each Invocation          *
                                                          *
led by   :  MAINLINE - Mainline Processing                *
ls       :  None                                          *
                                                          *
***********************************************************

RINZF        BEGSR                                                  ** SRINZF **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRINZF'      @STK(Q)

itialise work fields.

             Z-ADD     *ZEROS        ##W050            5 0
             Z-ADD     *ZEROS        ##W150           15 0
             Z-ADD     *ZEROS        ##W157           15 7
             Z-ADD     *ZEROS        #1                6 0
             Z-ADD     *ZEROS        #2                6 0
             Z-ADD     *ZEROS        #3                6 0
             MOVE      *BLANKS       S#PATH          256
LIKE         DEFINE    DEOSEQ        ##OSEQ
LIKE         DEFINE    DEOSEQ        ##WSEQ
LIKE         DEFINE    DEPBIN        ##WPBN
LIKE         DEFINE    DETBIN        ##WTBN
LIKE         DEFINE    INTA          ##INTA
LIKE         DEFINE    PRAM          ##PRAM
LIKE         DEFINE    WTXA          ##WTXA
                                                              CEU014
fine Equivalent Currency                                      CEU014
LIKE         DEFINE    CCY           EQCY                                          CEU01

             Z-ADD     0             ##INTA
             Z-ADD     0             ##PRAM
             Z-ADD     0             ##WTXA
             MOVE      *OFF          *IN40

itialise output sequence (to CGUDTAPD).

             Z-ADD     *ZEROS        ##OSEQ

U Additions for CG4999 1st version.

             MOVE      *BLANKS       #@RDE            10
LIKE         DEFINE    ##TBIN        #@TBIN

             OCCUR     ##BIND
             RESET                   ##BIND
             RESET                   #@BIND
             RESET                   #PDS
                                                                                  CCG015
tialise XML increment                                                             CCG015
                                                                                  CCG015
             EXSR      INIXML

XINZ         TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RINZ9        ENDSR                                                  ** SRINZ9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRINIT                                        *
ction    :  Initial processing - On First Call            *
                                                          *
led by   :  MAINLINE - Mainline Processing                *
ls       :  AOBANKR0 - Retrive Bank Details               *
            SRDCDT   - Determine Currency Details         *
                                                          *
***********************************************************

RINIT        BEGSR                                                  ** SRINIT **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRINIT'      @STK(Q)
WNCPYSRC,CG6036C001
                                                              CEU014
ess SAR details file to determine if CEU014 is installed.     CEU014
                                                              CEU014
             MOVEL     'N'           CEU014            1                           CEU01
                                                              CEU014
             CALL      'AOSARDR0'                                                  CEU01
             PARM      '       '     ##RTCD                                        CEU01
             PARM      '*VERIFY'     ##OPTN                                        CEU01
             PARM      'CEU014'      ##SARD            6                           CEU01
                                                              CEU014
#RTCD        IFEQ      *BLANK                                                      CEU01
             MOVEL     'Y'           CEU014                                        CEU01
             END                                                                   CEU01
                                                              CEU014
abase Error                                                   CEU014
                                                              CEU014
#RTCD        IFNE      *BLANK                                                      CEU01
#RTCD        ANDNE     '*NRF   '                                                   CEU01
             MOVEL     'SCSARDPD'    W0FILE                         ***************CEU01
             MOVEL     '*CALL'       W0KEY                          * DB ERROR 13 *CEU01
             Z-ADD     13            W0ERNB                         ***************CEU01
             MOVEL     'MEM5003'     W0MSGD                                        CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             END                                                                   CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
                                                              CEU014
ll access program for General Ledger details                  CEU014
****           CALL 'AOGELRR0'                                             CEU014 CGL029
             CALL      'AOGELRR1'
             PARM      '*MSG   '     ##RTCD                                        CEU01
             PARM      '*FIRST '     ##OPTN                                        CEU01
**** SDGELR    PARM SDGELR    DSFDY                                        CEU014 CGL029
DGELR        PARM      SDGELR        DSSDY
                                                              CEU014
tabase error                                                  CEU014
#RTCD        IFNE      *BLANK                                                      CEU01
                                                              CEU014
             MOVEL     'AOGELRR0'    W0FILE                                        CEU01
             MOVEL     '*CALL'       W0KEY                          ***************CEU01
             Z-ADD     14            W0ERNB                         * DB ERROR 14 *CEU01
             MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             ENDIF                                                                 CEU01
             ENDIF                                                                 CEU01
                                                                                  CLE028
ck if Flat Rate Personal Loans (Rule of 78s) is installed.                        CLE028
                                                                                  CLE028
             MOVEL     'N'           CLE028            1
                                                                                  CLE028
             CALL      'AOSARDR0'
             PARM      '       '     ##RTCD
             PARM      '*VERIFY'     ##OPTN
             PARM      'CLE028'      ##SARD
                                                                                  CLE028
#RTCD        IFEQ      *BLANK
             MOVEL     'Y'           CLE028
             ENDIF
                                                                                  CLE028
#RTCD        IFNE      *BLANK
#RTCD        ANDNE     '*NRF   '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     'CLE028'      W0KEY
             Z-ADD     16            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF

trieve Bank details.

             CALL      'AOBANKR0'
             PARM      *BLANKS       ##RTCD            7
             PARM      '*FIRST  '    ##OPTN            7
DBANK        PARM      SDBANK        DSSDY

#RTCD        IFNE      *BLANK
             MOVEL     'SDBANKPD'    W0FILE
             MOVEL     '*FIRST'      W0KEY                          ************
             Z-ADD     5             W0ERNB                         * DBERR 05 *
             MOVEL     'MEM5003'     W0MSGD                         ************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END
                                                                                  CCG015
ermine if Correspondence Manager Phase 1 Development                              CCG015
iSeries is installed                                                              CCG015
                                                                                  CCG015
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD             7
             PARM      '*VERIFY'     POPTN             7
             PARM      'CCG015'      PSARD             6
CSARD        PARM      SCSARD        DSFDY
                                                                                  CCG015
RTCD         IFEQ      *BLANKS
             MOVE      'Y'           CCG015            1
             ELSE
             MOVE      'N'           CCG015
                                                                                  CCG015
RTCD         IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL(P)  '*CALL'       W0KEY
             Z-ADD     15            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CCG015
             ENDIF
                                                                                  CLE031
ermine if CLE031 is Installed                                                     CLE031
                                                                                  CLE031
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD
             PARM      '*VERIFY'     POPTN
             PARM      'CLE031'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE031
RTCD         IFEQ      *BLANKS
             MOVE      'Y'           CLE031            1
             ELSE
             MOVE      'N'           CLE031
                                                                                  CLE031
RTCD         IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL(P)  '*CALL'       W0KEY
             Z-ADD     15            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE143
ck if CLE143 is ON                                                                CLE143
                                                                                  CLE143
             CALL      'AOSARDR0'
             PARM      *BLANKS       ##RTCD
             PARM      '*VERIFY '    ##OPTN
             PARM      'CLE143'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE143
#RTCD        IFEQ      *BLANKS
             MOVE      'Y'           CLE143            1
             ELSE
             MOVE      'N'           CLE143
             ENDIF
                                                                                  CER049
ck if CER049 is ON                                                                CER049
                                                                                  CER049
             CALL      'AOSARDR0'
             PARM      *BLANKS       ##RTCD
             PARM      '*KEY    '    ##OPTN
             PARM      'CER049'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CER049
#RTCD        IFEQ      *BLANK
             MOVE      'Y'           CER049            1
             ELSE
             MOVE      'N'           CER049
                                                                                  CER049
#RTCD        IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     'CER049'      W0KEY                          ***************
             Z-ADD     19            W0ERNB                         * DB ERROR 17 *
             MOVEL     'MEM5003'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CER049
             ENDIF
                                                                                  CER049
ess SAR details file to determine if CER050 is installed.                         CER050
                                                                                  CER050
             CALL      'AOSARDR0'
             PARM      '       '     ##RTCD
             PARM      '*VERIFY'     ##OPTN
             PARM      'CER050'      ##SARD
                                                                                  CER050
#RTCD        IFEQ      *BLANK
             MOVEL     'Y'           CER050            1
             ELSE
             MOVEL     'N'           CER050
             END

JDFIN        COMP      'M'                                    98    MMDDYY, 98 ON

termine Number of decimal places - Base currency.

             MOVEL     BJCYCD        ##CCY
             EXSR      SRDCDT
             Z-ADD     A6NBDP        BASCDP            1 0
WNCPYSRC,CG6036C018

pyright Statement.

             MOVEA     CPY@          ACT@             80

XINIT        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RINI9        ENDSR                                                  ** SRINI9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRADTA                                        *
ction    :  Accumulate RDEs and Associated Data           *
                                                          *
led by   :  LOANIS - Process Loan Interest Summary        *
            LOANEV - Process Loan Event Details           *
            LOANCF - Process Loan C/F Events              *
            LOANBF - Process Loan B/F Events              *
            LOAN   - Process Loan Details                 *
ls       :  CG3999 - Pack/Unpack Extracted Data           *
            SRRFMN - Reformat RDE Data                    *
                                                          *
***********************************************************

RADTA        BEGSR                                                  ** SRADTA **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRADTA'      @STK(Q)

format RDE data.

             EXSR      SRRFMN
                                                                                  CCG015
CCG015 is installed move '*NEWARR' to W0ACT                                       CCG015
e move '*PACK'.                                                                   CCG015
                                                                                  CCG015
CG015        IFEQ      'Y'
             MOVEL     '*NEWARR '    W0ACT
             MOVEL     S#PATH        W0SPAT
             ELSE
             MOVEL     '*PACK   '    W0ACT
             MOVEL     *BLANK        W0SPAT
             ENDIF

ck RDEs and associated data into data string.

             CLEAR                   ##SDS
             CALL      'CG3999'
             PARM      *BLANK        ##RTCD
****           PARM '*PACK   'W0ACT                                               CCG015
             PARM                    W0ACT
             PARM                    ##R
             PARM                    ##D
             PARM                    ##S
             PARM                    W0SPAT           70
             PARM                    ##RN
             PARM                    ##DN
             PARM                    ##FM

#RTCD        IFNE      *BLANK
             MOVEL     'CG3999  '    W0FILE                         ************
             MOVEL     ##RTCD        W0KEY                          * DBERR 06 *
             Z-ADD     6             W0ERNB                         ************
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CCG015
             EXSR      WRTRDE

pend Data from pack routine.

@SDS         CAT       ##SDS:0       #@SDS
             MOVEL     *BLANK        ##R
             MOVEL     *BLANK        ##D
             MOVEL     *BLANK        ##S

XADTA        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RADT9        ENDSR                                                  ** SRADT9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRODTA                                        *
ction    :  Output Accumulated Data to CGUDTAPD           *
                                                          *
led by   :  LOANIS - Process Loan Interest Summary        *
            LOANEV - Process Loan Event Details           *
            LOANCF - Process Loan C/F Events              *
            LOANBF - Process Loan B/F Events              *
            LOAN   - Process Loan Details                 *
ls       :  CG9020 - Write Data to UDC Extract Files      *
                                                          *
***********************************************************

RODTA        BEGSR                                                  ** SRODTA **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRODTA'      @STK(Q)

itialise Write Format Parameter.

             CLEAR                   W0FMT

t up Control Information.

             Z-ADD     ##ITEM        DEITEM
             ADD       1             ##OSEQ
             Z-ADD     ##OSEQ        DEOSEQ
             Z-ADD     ##PBIN        DEPBIN
             Z-ADD     ##TBIN        DETBIN
             MOVE      'FR'          DEFSLI
             MOVE      *BLANKS       W0PATH
             MOVEL     S#PATH        W0PATH

pend Data from pack routine.

0FMT         CAT       #@SDS:0       W0FMT
                                                                                  CCG015
CG015        IFEQ      'N'

tput PF/CGUDTAPD Record.

             CALL      'CG9020'
             PARM      *BLANK        ##RTCD
             PARM      '*WRITE  '    W0ACT
             PARM                    W0PATH          256
             PARM                    W0FMT
             PARM      *BLANK        W0TITL            7
             PARM      *BLANK        W0ULIN            7
             PARM                    W0CMT

#RTCD        IFNE      *BLANK
             MOVEL     'CG9020  '    W0FILE                         ************
             MOVEL     ##RTCD        W0KEY                          * DBERR 07 *
             Z-ADD     7             W0ERNB                         ************
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CCG015
             ENDIF

             CLEAR                   #@SDS

XODTA        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RODT9        ENDSR                                                  ** SRODT9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRBIND                                        *
ction    :  Generate Binding Numbers                      *
                                                          *
led by   :  All Repeating Group Set Subroutines           *
ls       :  None                                          *
                                                          *
***********************************************************

RBIND        BEGSR                                                  ** SRBIND **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRBIND'      @STK(Q)

1            SUB       1             P2

2            OCCUR     ##BIND
             Z-ADD     ##TBIN        #@TBIN

1            OCCUR     ##BIND
             Z-ADD     #@TBIN        ##PBIN
             ADD       1             #@BIND
             Z-ADD     #@BIND        ##TBIN

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RBIN9        ENDSR                                                  ** SRBIN9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRPATH                                        *
ction    :  Generate Path String                          *
                                                          *
led by   :  L05IN  - Lending Interest Advices             *
            LOANIS - Process Loan Interest Summary        *
            LOANID - Process Loan Interest Details        *
            LOANER - Process Loan Events                  *
            LOANEV - Process Loan Event Details           *
            LOANCF - Process Loan C/F Events              *
            LOANBF - Process Loan B/F Events              *
            LOANA  - Loan Associated Details              *
ls       :  None                                          *
                                                          *
***********************************************************

RPATH        BEGSR                                                  ** SRPATH **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRPATH'      @STK(Q)

             CLEAR                   S#PATH

t up Path.

             DO        P1            P2
2            OCCUR     ##PATH
#PATH        CAT       '\':0         S#PATH
#PATH        CAT       ##GRPS:0      S#PATH
             END

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RPAT9        ENDSR                                                  ** SRPAT9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRRFMN                                        *
ction    :  Reformat RDE Data                             *
                                                          *
led by   :  SRADTA - Accumulate RDEs and Associated Data  *
ls       :  None                                          *
                                                          *
***********************************************************

RRFMN        BEGSR                                                  ** SRRFMN **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRRFMN'      @STK(Q)

             Z-ADD     0             #1

op through RDE's and data.

1            DOUEQ     20

             ADD       1             #1
             MOVEL     ##R(#1)       R#DEFN
             MOVEL     ##D(#1)       R#DATA

 data present and RDE is edited.

#DATA        IFNE      *BLANK
#RDEC        ANDNE     *BLANK

format Amount.

             Z-ADD     1             #2
BLANK        LOOKUP    ##NUMA(#2)                             99    *
             Z-ADD     20            #3
             Z-ADD     0             ##WNUM

2            DOWGT     1
2            ANDLE     20
3            ANDGT     1
             SUB       1             #2
             MOVEL     ##NUMA(#2)    ##W(#3)
             SUB       1             #3
             ENDDO

gn the amount.

#SIGN        IFEQ      '-'
             Z-SUB     ##WNUM        ##NUMB
             ELSE
             Z-ADD     ##WNUM        ##NUMB
             END

fault Edit Type.

#EDTT        IFEQ      *BLANK
             MOVEL     ##RDET        ##EDTT
             END

fault Decimal Places.

#DCPA        IFEQ      *BLANK
             MOVEL     ##RDED        ##DCPA
             END

w RDE data.

             MOVEL     R#DATA        ##D(#1)

             ENDIF

             ENDDO

XRFMN        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RRFM9        ENDSR                                                  ** SRRFM9 **

***********************************************************

***********************************************************
                                                          *
routine  :  SRDCDT                                        *
ction    :  Determine Currency Details                    *
                                                          *
led by   :  LOANIS - Process Loan Interest Summary        *
            LOANEV - Process Loan Event Details           *
            LOANCF - Process Loan C/F Events              *
            LOANBF - Process Loan B/F Events              *
            SRINIT - Initial Processing - On First Call   *
ls       :  AOCURRRO - Retrive Currency Details           *
                                                          *
***********************************************************

RDCDT        BEGSR                                                  ** SRDCDT **

t up subroutine stack name.

             ADD       1             Q
             MOVEL     'SRDCDT'      @STK(Q)

cess array of Currency Details already loaded.

             Z-ADD     1             C                 3 0
#CCY         LOOKUP    ##CY(C)                                99

 no match is found determine the next free space in the
aded currency array.

IN99         IFEQ      *OFF

             Z-ADD     1             C
BLANK        LOOKUP    ##CY(C)                                99

 no space is left, set the Currency Data data structure to
e 101st occurrence so that when the new details are
trieved no existing details are overwritten.

IN99         IFEQ      *OFF
01           OCCUR     SDCURR

 a space is found, set up the new currency into the array
d position the Currency Data data structure on the
currence matching the array index.

             ELSE
             MOVE      ##CCY         ##CY(C)
             OCCUR     SDCURR
             ENDIF

trieve the currency details.

             CALL      'AOCURRR0'
             PARM      *BLANKS       ##RTCD                         B:Return Cd
             PARM      '*KEY'        ##OPTN                         I:Option
             PARM      ##CCY         ##CCYP            3            I:Currency Code
DCURR        PARM      *BLANK        DSSDY                          O:Format

#RTCD        IFNE      *BLANK
             MOVEL     'SDCURRPD'    W0FILE
             MOVEL     ##CCY         W0KEY                          ************
             Z-ADD     8             W0ERNB                         * DBERR 08 *
             MOVEL     'MEM5004'     W0MSGD                         ************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF

 the currency has been retrieved earlier, position the
rrency Data data structure on the relevant occurrence.

             ELSE
             OCCUR     SDCURR
             ENDIF
WNCPYSRC,CG6036C002

XDCDT        TAG

wind subroutine stack name.

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

RDCD9        ENDSR                                                  ** SRDCD9 **

***********************************************************

CGCPYSRC,SRERRPSSRL

CGCPYSRC,SRERRCLE

CGCPYSRC,CGNWEXILE
                                                                                  CCG015
      OBJECT COPYRIGHT
 International Limited 2001
