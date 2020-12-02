
***********************************************************
BASEBND                                                   *
T('Midas CG Lending consolidated confirmation extract')   *
***********************************************************
                                                          *
as - User Defined Correspondence                          *
                                                          *
065LE - Lending Consolidated Confirmation Extract (ILE)   *
                                                          *
ction:  This program extracts data for Consolidated       *
B)      Confirmations                                     *
                                                          *
led By: CG6061 - Lending Consolidated Confirmations       *
                 Driver                                   *
                                                          *
 Finastra International Limited 2001                      *
                                                          *
t Amend No. CLE172             Date 23Oct20               *
v Amend No. CER050             Date 16Jun19               *
            MD046248           Date 27Oct17               *
            CLE154             Date 02Aug12               *
            CLE141             Date 08Feb16               *
            AR858383           Date 29Oct15               *
            CLE134             Date 01Aug12               *
            CLE148             Date 23Jul12               *
            CRE073             Date 06Dec10               *
            CLE143             Date 06Dec10               *
 Fusion Midas 1.4 Base -----------------------------------*
s Plus 1.4 Base 04 ---------------------------------------*
s Plus 1.4 Base ------------------------------------------*
s Plus 1.3 ----------- Base ------------------------------*
            CSD031             Date 10Apr06               *
            CSD027             Date 09Dec05               *
            CLE042             Date 06Sep05               *
            CLE106             Date 01Aug04               *
            CLE036             Date 22Sep03               *
            CAS009             Date 16May05               *
            CSW037A            Date 02May05               *
            CSD025             Date 11Jan05               *
            CSW037             Date 15Dec04               *
            CSW036             Date 15Dec04               *
            CLE025             Date 20Oct03               *
            CSC022             Date 24Feb04               *
            CGL029             Date 01Sep03               *
            CAP074             Date 08Aug03               *
            CLE031             Date 05Feb03               *
            CAS005             Date 16Dec02               *
            CLE028             Date 27Jun02               *
            CAS004             Date 26Jun02               *
s Release 4.01 -------------------------------------------*
            CCG015             Date 09Aug01               *
s Release 4 --------------- Base -------------------------*
s DBA 3.05 -----------------------------------------------*
            CSD006             Date 15May01               *
            CLE011             Date 07Nov00               *
s DBA 3.03 -----------------------------------------------*
s DBA 3.00 ---------------- Base -------------------------*
            CEU014             Date 26Jun98               *
            CLE004             Date 02May97               *
                                                          *
----------------------------------------------------------*
                                                          *
172 - Libor Deregulation - Lending                        *
050 - Annualised Percentage Rate (Recompile)              *
46248 - Finastra Rebranding                               *
154 - Loan Repayment Schedule Enhancement                 *
      (Amendable Payment Type)                            *
141 - Currency and Location Business Day Convention       *
      (Recompile)                                         *
58383 - Field PDDI and PTDI of PF/CLOANCL was overwritten *
        due to chain on PF/LOAMSDK before write to        *
        PF/CLOANCL. Rename the common fields between the  *
        two PF                                            *
      - Applied for MD35868 (CHILD: AR858384)             *
134 - Past Due Call Loan Processing (Recompile)           *
148 - Alpha Loan Reference                                *
073 - Interest Rate Rounding (Recompile)                  *
143 - Original Loan Contract Date & Effective Interest    *
      Rate (Recompile)                                    *
031 - Enhanced Centralised Static Data (Recompile)        *
027 - Conversion Of Customer Number to Alpha              *
042 - Extended Loan Sub Type (Recompile)                  *
106 - Syndications Manager.                               *
036 - LE Enh for Nordea Phase 1 Pty 2 - Specific Base Rate*
009 - EIR/AC Accounting (Recompile)                       *
037A- Additional Field extended to 40 chars (recompile)   *
025 - Customer De-Activation                              *
037 - Additional Field Data on MT300/MT320                *
036 - Dual SWIFT BIC held on Client Details               *
025 - Credit Lines (Recompile)                            *
022 - Commitment Control Changes for MidasPlus            *
      (Recompile)                                         *
029 - Increase Account Code to 10 digits                  *
074 - Lending API enhancements - Loans input.             *
031 - Lending Enhancements.                               *
005 - Enhancements to CAS001, CAS002 and CAS004           *
      (Recompile)                                         *
028 - Flat Rate Personal Loans (Rule of 78s)              *
      (Recompile)                                         *
004 - Hedge Accounting Phase A (Recompile)                *
015 - Correspondence Manager Phase 1.                     *
006 - Recompiled over changed SDBSRTPD.                   *
011 - Rate Fixing Days for Lending Rollover Processing    *
      Recompile                                           *
014 - EMU User Defined Correspondence Enhancement         *
004 - Syndications & Authorisations                       *
                                                          *
***********************************************************
L4  IF   E           K DISK    INFSR(SRFILE)
                                                          *
    UF   E           K DISK    INFSR(SRFILE)
                               COMMIT
                               IGNORE(CLOANHHF)
                               IGNORE(CLOANZ1F)

    IF   E           K DISK    INFSR(SRFILE)
                               IGNORE(LOAMSDHF)
                               IGNORE(LOAMSZ1F)

 FUNCTION OF INDICATORS
***********************************************************
                                                          *
 N  C T I O N    O F    I N D I C A T O R S               *
                                                          *
  -    No record found indicator for CLOAN file.          *
  -    General work indicator.                            *
  -    MMDDYY date format.                                *
                                                          *
***********************************************************
 SUBROUTINE INDEX
***********************************************************
                                                          *
 B R O U T I N E    I N D E X                             *
                                                          *
n routine                                                 *
AIN  -  Main Processing                                   *
CUS  -  Validate loans for the customer                   *
NIT  -  Initial Processing                                *
NZF  -  Initialise Fields on Each Invocation              *
ETL  -  Obtain Detail Information                         *
ECT  -  Select values depending on rec type               *
INT  -  Rollover Interest Rate                            *
CO   -  Lending Consolidated Confirmation                 *
NCO  -  Loan Action for Consolidated Confirmation         *
NC0  -  Loan                                              *
NA   -  Process Loan Associated Details                   *
DET  -  Set-up Settlement Details                         *
DTA  -  Accumulate RDEs and Associated Data               *
DTA  -  Output Accumulated Data to PF/CGUDTAPD            *
IND  -  Generate Binding Numbers                          *
ATH  -  Generate Path String                              *
FMN  -  Reformat RDE Data                                 *
CDT  -  Determine Currency Details                        *
ENR  -  Generate Reference Number                         *
                                                          *
***********************************************************

***********************************************************

ay containing Copyright statement
           S             80    DIM(1) CTDATA PERRCD(1)
                                                                                  CLE031
ers of Ten                                                                        CLE031
                                                                                  CLE031
           S              7  3 DIM(7) CTDATA PERRCD(1)
CGCPYSRC,CGPACKDLE
CGCPYSRC,SRERRDLE

ray of Currencies accessed by program
           S              3    DIM(100)

 to for parameter PRPAR
           DS
M                  1    100
                   1      1
                   2      7
****                              8  130WFLN                                      CLE148
                   8     13
****                             14  190WTLN                                      CLE148
                  14     19

ok-up string for RDE definition Array

           DS
****                              15120 ##S                                       CLE036

           DS
****                           51205120 #@S                                       CLE036
                5632   5632
cked data string.

           DS
                   1     20
                               DIM(20)
UM                 1     20  0
mber Field

           DS
MA                 1      8
EM                 1      8  0
d to convert item reference from character to numeric

           DS
IT                 1      6
                   1      3
                   4      6
           DS
CC                 1      5
Y                  1      3
D                  4      5

n details parameter for call to CG99LSET

S          DS           256
ency
                   1      3
omer Number
****                              4   90CNUM                                      CSD027
                   4      9
ch
                  10     12
 Processing Type
                  13     14  0

tlement Instructions Parameter for call to CG99LSET

M          DS           768
- Branch
BR                 1      3
ipt - Branch
BR                 4      6
ipt - Settlement Method
TM                 7      8  0
ipt - Our Nostro
****                              9  20 P0RONS                                    CGL029
NS                 9     20
ipt - Intermediary Bank
BN                21     28
ipt - Intermediary Bank a/c
BA                29     63
ipt - Ordering Bank No.
****                             64  690P0ROBN                                    CSD027
BN                64     69
ipt - Ordering Customer
****                             70  750P0ROCN                                    CSD027
CN                70     75
- Settlement Method
TM                76     77  0
- Our Nostro
****                             78  89 P0PONS                                    CGL029
NS                78     89
- Intermediary Bank
BN                90     97
- Intermediary Bank a/c
BA                98    132
- Ordering Bank No.
****                            133 1380P0POBN                                    CSD027
BN               133    138
- Ordering Customer No.
****                            139 1440P0POCN                                    CSD027
CN               139    144
iver Correspondent No.
RN               145    152
iver Correspondent A/C 1
RA               153    187
iver Number
NO               188    195
with Bank No.
BN               196    203
with Bank A/C Line
BA               204    238
ficiary No.
NN               239    246
ficiary A/C Line
NA               247    281
ils of Pay 1
P1               282    316
ils of Pay 2
P2               317    351
ils of Pay 3
P3               352    386
ils of Pay 4
P4               387    421
ils of Charges
HG               422    424
 to Bank Info 1
B1               425    459
 to Bank Info 2
B2               460    494
 to Bank Info 3
B3               495    529
 to Bank Info 4
B4               530    564
 to Bank Info 5
B5               565    599
 to Bank Info 6
B6               600    634
ial Instruction 1
I1               635    664
ial Instruction 2
I2               665    694
ial Instruction 3
I3               695    724
lement Currency                                               CEU014
CY               725    727                                         CEU014
CY               728    730
NS               731    748
NS               749    766

C Details for call to CG6001

M          DS           256
ut Sequence
EQ                 1      9  0
item number
EM                10     17  0
 bind level
IN                18     25  0
ious bind level
IN                26     33  0

an details Parameters for call to CG6001

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

med constants

P          C                   CONST('LOAN CONF')
1          C                   CONST('CONSOLIDAT')

R        E DS                  EXTNAME(CGUDCRPD)
ernal DS for incomplete reference

K        E DS                  EXTNAME(SDBANKPD)
ternal DS for Bank details

R        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
ternal DS for currency details

T        E DS                  EXTNAME(SDBSRTPD)
ternal DS for base rate details

R        E DS                  EXTNAME(SDGELRPD)                    CEU014
or GL ICD Details                                             CEU014
                                                              CEU014
T        E DS                  EXTNAME(SDCUSTPD)                    CEU014
ternal DS for customer details                                CEU014
                                                              CEU014
D        E DS                  EXTNAME(SCSARDPD)                    CEU014
tchable Feature details                                       CEU014
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

***********************************************************

***********************************************************

LF
ame fields on CLOANCL
        RECI                        LORECI
        RCDT                        LORCDT
        CNUM                        LOCNUM
        BRCA                        LOBRCA
        VDAT                        LOVDAT
        CHTP                        LOCHTP
        TNLU                        LOTNLU
        PDDI                        LOPDDI                                            AR
        PTDI                        LOPTDI                                            AR
        LNRF                        LOLNRF                                            AR
        ICCY                        LOICCY                                            AR
        RELI                        LORELI                                            AR
        REPI                        LOREPI                                            AR

KF
ame fields on CLOANCK
        RECI                        L2RECI
        RCDT                        L2RCDT
        MRIN                        L2MRIN
        ORED                        L2ORED
        ZZ004                       L2ZZ04
        LCD                         L2LCD
        CHTP                        L2CHTP
        TNLU                        L2TNLU

KF
ame fields on LOAMS
        RECI                        LARECI
        VDAT                        LAVDAT
        LASN                        LALASN
        MRIN                        LAMRIN
        LTYP                        LALTYP
        SUTP                        LASUTP
        PTYP                        LAPTYP
        BRTT                        LABRTT
        RTSP                        LARTSP
        CCY                         LACCY
        BRCA                        LABRCA
        CNUM                        LACNUM
        REPT                        LAREPT
        AUTO                        LAAUTO
        FACO                        LAFACO
        BRTE                        LABRTE
        SPIN                        LASPIN
        WTIN                        LAWTIN
        FCUS                        LAFCUS
        FTYP                        LAFTYP
        FSEQ                        LAFSEQ
        INTC                        LAINTC
        NACD                        LANACD
        FCLB                        LAFCLB
        ORED                        LAORED
        LCD                         LALCD
        CHTP                        LACHTP
        TNLU                        LATNLU
        RSTM                        LARSTM
        RONS                        LAROSN
        RIBN                        LARIBN
        RIBA                        LARIBA
        ROBN                        LAROBN
        ROCN                        LAROCN
        PSTM                        LAPSTM
        PONS                        LAPONS
        PIBN                        LAPIBN
        PIBA                        LAPIBA
        POBN                        LAPOBN
        POCN                        LAPOCN
        RCRN                        LARCRN
        RCRA                        LARCRA
        RVNO                        LARVNO
        AWBN                        LAAWBN
        AWBA                        LAAWBA
        BENN                        LABENN
        BENA                        LABENA
        DTP1                        LADTP1
        DTP2                        LADTP2
        DTP3                        LADTP3
        DTP4                        LADTP4
        DCHG                        LADCHG
        BTB1                        LABTB1
        BTB2                        LABTB2
        BTB3                        LABTB3
        BTB4                        LABTB4
        BTB5                        LABTB5
        BTB6                        LABTB6
        CVMR                        LACVMR
        FSRP                        LAFSRP
        FSGN                        LAFSGN
        FPRC                        LAFPRC
        DFTP                        LADFTP
        DFST                        LADFST
        MNSG                        LAMNSG
        GASS                        LAGASS
        GPRT                        LAGPRT
        IUSR                        LAIUSR
        AUSR                        LAAUSR
        XUSR                        LAXUSR
        PCRF                        LAPCRF
        PCOB                        LAPCOB
        SPI1                        LASPI1
        SPI2                        LASPI2
        SPI3                        LASPI3
        SCCY                        LASCCY                          CEU014
        REXR                        LAREXR
        REXI                        LAREXI
        PSCY                        LAPSCY
        PEXR                        LAPEXR
        PEXI                        LAPEXI
        BASR                        LABASR
        SLTP                        LASLTP
        SLST                        LASLST
***********************************************************

***********************************************************
cess     :  MAINLINE                                      *
ction    :  Mainline processing                           *
                                                          *
led by   :  None                                          *
ls       :  SRINIT - Initial Processing - On First Call   *
            SRINZF - Initialise Fields on Each Invocation *
            SRMAIN - Main Processing                      *
***********************************************************

rameter list for current program invocation.

ENTRY        PLIST
             PARM                    W0RTN
             PARM                    W0CMT             3
             PARM                    PRENT             3
             PARM                    PRPAR           100

t up subroutine stack name

             ADD       1             Q
             MOVEL     'MAIN'        @STK(Q)

itial processing - Once Only

#INIT        IFEQ      *BLANK
             EXSR      SRINIT
             MOVE      'Y'           ##INIT            1
             ENDIF

tialisation processing

             EXSR      SRINZF

n processing

             EXSR      SRMAIN

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

rminate program

             RETURN
***********************************************************

***********************************************************
routine  :  SRMAIN                                        *
ction    :  Main processing                               *
                                                          *
led by   :  Mainline                                      *
ls       :  VALCUS - Validate loans for the customer      *
            SRGENR - Generate reference number by writing *
                     to PF/CGUDCRPD                       *
            L12CO  - Lending Consolidated Confirmation    *
***********************************************************
RMAIN        BEGSR

t up subroutine stack name

             ADD       1             Q                 5 0
             MOVEL     'SRMAIN'      @STK(Q)

 there are no valid loans, either no records on LELOANL4
le or all loans have Consolidated Confirmation flag set
 'Y', then exit
             MOVE      'N'           ##COPD
             EXSR      VALCUS
#COPD        CABEQ     'N'           EXMAIN

nerate reference number by writing to PF/CGUDCRPD
 no confirmation to be produced, then bypass

             MOVE      'N'           ##COPD
             EXSR      SRGENR
#COPD        CABEQ     'N'           EXMAIN

ract

             EXSR      L12CO

XMAIN        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRDETL                                        *
ction    :  Process: Obtain detail information            *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  SELECT - Select values depending on rec type  *
         :  SRERR  - Database Error                       *
***********************************************************
RDETL        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRDETL'      @STK(Q)

ccess LOAMS file if this is an amendment
CDT          IFEQ      'A'
LOAMS        KLIST
             KFLD                    LNRF
             KFLD                    VDAT
             KFLD                    LASN

LOAMS        CHAIN     LOAMS                              88

IN88         IFEQ      '1'
             MOVEL     'LOAMS   '    W0FILE                         ***************
             MOVEL     LNRF          W0KEY                          * DB ERROR 08 *
             Z-ADD     08            W0ERNB                         ***************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END
             ENDIF

ccess CLOANCK file if this is a rollover
CDT          IFEQ      'L'
DAT          ANDEQ     0

OANCK        KLIST
             KFLD                    LNRF
             KFLD                    L2RCDT

             MOVEL     'B'           L2RCDT
OANCK        CHAIN     CLOAN                              88

IN88         IFEQ      '1'
             MOVEL     'CLOANCK '    W0FILE                         ***************
             MOVEL     LNRF          W0KEY                          * DB ERROR 11 *
             Z-ADD     11            W0ERNB                         ***************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END
             ENDIF

             MOVE      *BLANK        ACTCDE            2

             EXSR      SELECT

XDETL        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SELECT                                        *
ction    :  Select values depending on record type        *
                                                          *
led by   :  SRDETL - Obtain Loan Details                  *
ls       :  ROLINT -  Rollover Interest Rate              *
***********************************************************
ELECT        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SELECT'      @STK(Q)

CDT          IFEQ      'L'
DAT          IFNE      0                                            LOAN
             MOVE      VDAT          @@VDAT
             MOVE      INTR          @@INTR
             MOVE      CPAM          @@CPAM
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
e into work fields the settlement currency, exchange rate                         CLE031
 indicator to be used for later conversion of Principal                           CLE031
unt.                                                                              CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
             MOVE      *BLANKS       WPRFLG            1
                                                                                  CLE031
 parts sold loans.                                                                CLE031
                                                                                  CLE031
TYP          IFEQ      66
TYP          OREQ      67
LE005        OREQ      'Y'
TYP          ANDEQ     69
LE005        OREQ      'Y'
TYP          ANDEQ     72
             MOVE      SCCY          WSETCY            3
             Z-ADD     REXR          WEXCH            13 8
             MOVE      REXI          WMD               1
             MOVE      'R'           WPRFLG
             ELSE
             MOVE      PSCY          WSETCY
             Z-ADD     PEXR          WEXCH
             MOVE      PEXI          WMD
             MOVE      'P'           WPRFLG
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
HTP          IFNE      'R'
             MOVE      '01'          ACTCDE                         Start of Loan
             ADD       CPAM          @@LBAL
             ELSE
             MOVE      '07'          ACTCDE                         Reverse Loann
             SUB       CPAM          @@LBAL
             ENDIF
LDT          IFNE      *ZERO
             MOVE      RLDT          @@MDAT
             ELSE
             MOVE      MDAT          @@MDAT
             ENDIF
                                               LOAN
             ELSE
                                               ROLLOVER
             MOVE      '06'          ACTCDE                         Rollover    n
             MOVE      RLDT          @@VDAT
             MOVE      NPRAM         @@CPAM
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
e into work fields the settlement currency, exchange rate                         CLE031
 indicator to be used for later conversion of Principal                           CLE031
unt.                                                                              CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
             MOVE      *BLANKS       WPRFLG
                                                                                  CLE031
 parts sold loans.                                                                CLE031
                                                                                  CLE031
TYP          IFEQ      66
TYP          OREQ      67
LE005        OREQ      'Y'
TYP          ANDEQ     69
LE005        OREQ      'Y'
TYP          ANDEQ     72
             MOVE      RRSC          WSETCY
             Z-ADD     RRSR          WEXCH
             MOVE      RRSI          WMD
             MOVE      'R'           WPRFLG
             ELSE
             MOVE      RPSC          WSETCY
             Z-ADD     RPSR          WEXCH
             MOVE      RPSI          WMD
             MOVE      'P'           WPRFLG
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
             EXSR      ROLINT
ROD          IFNE      *ZERO
             MOVE      NROD          @@MDAT
             ELSE
             MOVE      MDAT          @@MDAT
             ENDIF
             ENDIF
             ENDIF                                                  ROLLOVER

CDT          IFEQ      'A'                                          AMENDMENT
             MOVE      VDAT          @@VDAT
             Z-ADD     0             @@INTR

             SELECT
MTP          WHENEQ    'PF'
             MOVE      PRAM          @@CPAM
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
e into work fields the settlement currency, exchange rate                         CLE031
 indicator to be used for later conversion of Principal                           CLE031
unt.                                                                              CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
             MOVE      *BLANKS       WPRFLG
                                                                                  CLE031
 parts sold loans.                                                                CLE031
                                                                                  CLE031
TYP          IFEQ      66
TYP          OREQ      67
LE005        OREQ      'Y'
TYP          ANDEQ     69
LE005        OREQ      'Y'
TYP          ANDEQ     72
             MOVE      LAPSCY        WSETCY
             Z-ADD     LAPEXR        WEXCH
             MOVE      LAPEXI        WMD
             MOVE      'P'           WPRFLG
             ELSE
             MOVE      LASCCY        WSETCY
             Z-ADD     LAREXR        WEXCH
             MOVE      LAREXI        WMD
             MOVE      'R'           WPRFLG
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
HTP          IFNE      'R'
             MOVE      '02'          ACTCDE                         Prin Tr Fromn
             SUB       PRAM          @@LBAL
             ELSE
             MOVE      '10'          ACTCDE                         Rvrs PT Fromn
             ADD       PRAM          @@LBAL
             ENDIF

MTP          WHENEQ    'PT'
             MOVE      PRAM          @@CPAM
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
e into work fields the settlement currency, exchange rate                         CLE031
 indicator to be used for later conversion of Principal                           CLE031
unt.                                                                              CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
             MOVE      *BLANKS       WPRFLG
                                                                                  CLE031
 parts sold loans.                                                                CLE031
                                                                                  CLE031
TYP          IFEQ      66
TYP          OREQ      67
LE005        OREQ      'Y'
TYP          ANDEQ     69
LE005        OREQ      'Y'
TYP          ANDEQ     72
             MOVE      LASCCY        WSETCY
             Z-ADD     LAREXR        WEXCH
             MOVE      LAREXI        WMD
             MOVE      'R'           WPRFLG
             ELSE
             MOVE      LAPSCY        WSETCY
             Z-ADD     LAPEXR        WEXCH
             MOVE      LAPEXI        WMD
             MOVE      'P'           WPRFLG
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
HTP          IFNE      'R'
             MOVE      '03'          ACTCDE                         Prin Tr To  n
             ADD       PRAM          @@LBAL
             ELSE
             MOVE      '09'          ACTCDE                         Rvrs PT To  n
             SUB       PRAM          @@LBAL
             ENDIF

MTP          WHENEQ    'RE'
             MOVE      '04'          ACTCDE                         Repay Sched n
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
e into work fields the settlement currency, exchange rate                         CLE031
 indicator to be used for later conversion of Principal                           CLE031
unt.                                                                              CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
             MOVE      *BLANKS       WPRFLG
                                                                                  CLE031
 parts sold loans.                                                                CLE031
                                                                                  CLE031
TYP          IFEQ      66
TYP          OREQ      67
LE005        OREQ      'Y'
TYP          ANDEQ     69
LE005        OREQ      'Y'
TYP          ANDEQ     72
             MOVE      LAPSCY        WSETCY
             Z-ADD     LAPEXR        WEXCH
             MOVE      LAPEXI        WMD
             MOVE      'P'           WPRFLG
             ELSE
             MOVE      LASCCY        WSETCY
             Z-ADD     LAREXR        WEXCH
             MOVE      LAREXI        WMD
             MOVE      'R'           WPRFLG
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
LE154        IFEQ      'N'
EPT          IFEQ      1
             MOVE      PRAM          @@CPAM
             SUB       PRAM          @@LBAL
             ELSE
             MOVE      TAMT          @@CPAM
             SUB       TAMT          @@LBAL
             ENDIF
             ELSE
AREPT        IFEQ      1
             MOVE      PRAM          @@CPAM
             SUB       PRAM          @@LBAL
             ELSE
             MOVE      TAMT          @@CPAM
             SUB       TAMT          @@LBAL
             ENDIF
             END

MTP          WHENEQ    'PI'
             MOVE      PRAM          @@CPAM
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
e into work fields the settlement currency, exchange rate                         CLE031
 indicator to be used for later conversion of Principal                           CLE031
unt.                                                                              CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
             MOVE      *BLANKS       WPRFLG
                                                                                  CLE031
 parts sold loans.                                                                CLE031
                                                                                  CLE031
TYP          IFEQ      66
TYP          OREQ      67
LE005        OREQ      'Y'
TYP          ANDEQ     69
LE005        OREQ      'Y'
TYP          ANDEQ     72
             MOVE      LASCCY        WSETCY
             Z-ADD     LAREXR        WEXCH
             MOVE      LAREXI        WMD
             MOVE      'R'           WPRFLG
             ELSE
             MOVE      LAPSCY        WSETCY
             Z-ADD     LAPEXR        WEXCH
             MOVE      LAPEXI        WMD
             MOVE      'P'           WPRFLG
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
HTP          IFNE      'R'
             MOVE      '05'          ACTCDE                         Prin Increase
             ADD       PRAM          @@LBAL
             ELSE
             MOVE      '08'          ACTCDE                         Rvrs Pr Incre
             SUB       PRAM          @@LBAL
             ENDIF
             ENDSL

             ENDIF                                                  AMENDMENT

LTEND        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  ROLINT                                        *
ction    :  Calculate Rollover Interest Rate              *
                                                          *
led by   :  SELECT - Select values depending on rec type  *
ls       :  AOBSRTR0 - Midas AP: Base Rate Codes          *
***********************************************************
OLINT        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'ROLINT'      @STK(Q)

BRA          IFEQ      *ZERO
LE036        ANDEQ     'N'
BRA          OREQ      *ZERO
BSR          ANDEQ     *ZERO
LE036        ANDEQ     'Y'
             MOVE      NRTS          @@INTR

             ELSE
BRA          IFNE      *ZERO
             MOVE      NBRA          ##NBRA            2
ess SDBSRTPD file for Interest Base Rate table
             CALL      'AOBSRTR0'
             PARM      *BLANKS       ##RTCD
             PARM      '*KEY    '    ##OPTN
             PARM      CCY           ##CCY
             PARM                    ##NBRA
DBSRT        PARM      SDBSRT        DSSDY

#RTCD        IFNE      *BLANK
abase error
             MOVEL     'AOBSRTR0'    W0FILE
             MOVEL     '*CALL'       W0KEY                          ***************
             Z-ADD     12            W0ERNB                         * DB ERROR 12 *
             MOVEL     'MEM5003'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END
             ENDIF
                                                                                  CLE036
BSR          IFNE      *ZERO
LE036        ANDEQ     'Y'
             Z-ADD     NBSR          BACBSR
             ENDIF

             SELECT
SIN          WHENEQ    'A'
ACBSR        ADD       NRTS          @@INTR
SIN          WHENEQ    'S'
ACBSR        SUB       NRTS          @@INTR
SIN          WHENEQ    'P'
RTS          DIV       100           @@INTR
             MULT      BACBSR        @@INTR
             OTHER
             MOVE      BACBSR        @@INTR
             ENDSL

             ENDIF

INEND        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  VALCUS                                        *
ction    :  Check if there are valid loans for this       *
            customer                                      *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  None                                          *
***********************************************************
ALCUS        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'VALCUS'      @STK(Q)

d through LELOANL4 file restricting on the branch and
tomer.

EKEY         KLIST
             KFLD                    PRENT
             KFLD                    ##WCUS

EKEY         SETLL     LELOANL4
EKEY         READE     LELOANL4                               60

IN60         DOWEQ     '0'

ass record if loan number is the same as on the previous
ord
NRF          IFEQ      ##LNRF
EKEY         READE     LELOANL4                               60
             ITER
             ELSE
             MOVE      LNRF          ##LNRF
             ENDIF

NRF          IFGE      WFLN
NRF          ANDLE     WTLN

OANCL        KLIST
             KFLD                    LNRF
             KFLD                    LORCDT

             MOVEL     'A'           LORCDT
OANCL        CHAIN     CLOAN                              88

IN88         IFEQ      '1'
             MOVEL     'CLOANCL '    W0FILE                         ***************
             MOVEL     LNRF          W0KEY                          * DB ERROR 06 *
             Z-ADD     06            W0ERNB                         ***************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

at least one loan with Consolidated Confirmation flag equal
 found, leave the loop and continue confirmation processing

NCF          IFEQ      'N'
             MOVE      'Y'           ##COPD
             LEAVE
             ENDIF

             ENDIF
EKEY         READE     LELOANL4                               60
             ENDDO

XVALC        TAG
****           Z-ADD*ZEROS    ##LNRF                                              CLE148
             MOVEL     *BLANKS       ##LNRF

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRGENR                                        *
ction    :  Generate reference number by writing to       *
            PF/CGUDCRPD                                   *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  CG9010 - Create reference record              *
***********************************************************
RGENR        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRGENR'      @STK(Q)

nerate reference number and check if further processing
quired. Set up all available information in the record
rmat before calling.

             CLEAR                   ##UDCR

king/Main Branch (Mandatory)

             MOVEL     PRENT         DRBRCA

ginating Branch (Optional)

             MOVEL     *BLANK        DRORBR

ule identifier (Mandatory)

             MOVEL     'LE'          DRMODI

as Transaction Number (Mandatory)

             MOVEL     *BLANK        DRMTRN

             MOVEL     W#PTYP        DRPTYP                         * print type

             MOVEL     W#PST1        DRPSTP                         * print s/type

o Transmission indicator

             MOVEL     'N'           DRATRM

tomer Number (Mandatory)

             MOVEL     WCUS          ##CUST

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
s reference as printtype:subtype                                                  CCG015
                                                                                  CCG015
RPTYP        CAT(P)    ':':0         COLON            11
OLON         CAT(P)    DRPSTP:0      ##REFR
             EXSR      WRAPRF

             ELSE

#RTCD        IFNE      'CGD1270'
             MOVEL     'CG9010  '    W0FILE
             MOVEL     ##RTCD        W0KEY                          ***************
             Z-ADD     05            W0ERNB                         * DB ERROR 05 *
             MOVEL     'CGD1286'     W0MSGD                         ***************
             MOVEL     'CGUSRMSG'    W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF

XGENR        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  L12CO                                         *
ction    :  Process: Lending Consolidated Confirmation    *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  SRPATH - Generate Path String                 *
            SRSDET - Set-up Settlement Details            *
            LOANCO - Loan Action for Consolidated         *
                     Confirmation                         *
            LOANA  - Process Loan Associated Details      *
***********************************************************
12CO         BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'L12CO '      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'l12CO '      ##GRPS

             EXSR      SRPATH
             EXSR      PSHGRS

             EXSR      LOANCO

             EXSR      SRSDET

             EXSR      LOANA

crement Path DS index

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  LOANCO                                        *
ction    :  Process: Loan                                 *
                                                          *
led by   :  L12CO  - Loan Consolidated Confirmation       *
ls       :  SRDETL - Obtain detail information            *
            LOANC0 - Process: Loan                        *
            SRPATH - Generate path string                 *
            SRBIND - Generate binding numbers             *
***********************************************************
OANCO        BEGSR

t up subroutine stack name
             ADD       1             Q
             MOVEL     'LOANCO'      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'LOANCO'      ##GRPS

             EXSR      SRPATH
             EXSR      PSHGRS

d through LELOANL4 file restricting on the branch and
tomer. For each valid loan produce a UDC extract.

EKEY         SETLL     LELOANL4
EKEY         READE     LELOANL4                               60

IN60         DOWEQ     '0'

NRF          IFEQ      ##LNRF
this record is the same as the previous one
if this loan doesn't satisfy the selection criteria
ass this record
CDT          IFEQ      ##RCDT
DAT          ANDEQ     ##VDAT
ASN          ANDEQ     ##LASN
HTP          ANDEQ     ##CHTP
#CNCF        OREQ      'Y'
EKEY         READE     LELOANL4                               60
             ITER
             ELSE
the loan number is the same as on the previous record
't access CLOANCL file, but produce confirmation
             EXSR      SRDETL
             EXSR      SRBIND
             EXSR      LOANC0
             ENDIF
 loan
             ELSE

             MOVE      RCDT          ##RCDT
             MOVE      LNRF          ##LNRF
             MOVE      VDAT          ##VDAT
             MOVE      LASN          ##LASN
             MOVE      CHTP          ##CHTP
             MOVE      'Y'           ##CNCF

ck if the loan reference is in the specified range
NRF          IFGE      WFLN
NRF          ANDLE     WTLN

ess CLOANCL file for Consolidated Confirmations flag

OANCL        CHAIN     CLOAN                              88

IN88         IFEQ      '1'
             MOVEL     'CLOANCL '    W0FILE                         ***************
             MOVEL     LNRF          W0KEY                          * DB ERROR 06 *
             Z-ADD     06            W0ERNB                         ***************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

NCF          IFEQ      'N'
             MOVE      'N'           ##CNCF
             MOVE      CCY           @@CCY             3
             Z-ADD     0             @@CPAM           13 0
             Z-ADD     0             @@LBAL           13 0
             Z-ADD     0             @@MDAT            5 0
             Z-ADD     0             @@INTR           11 7
             Z-ADD     0             @@VDAT            5 0
             EXSR      SRDETL
             EXSR      SRBIND
             EXSR      LOANC0

d CLOANCL format if CLOANCK was read for rollover
CDT          IFEQ      'L'
DAT          ANDEQ     0
OANCL        CHAIN     CLOAN                              88
             ENDIF
te Consolidated Confirmation flag on CLOANCLF
             MOVE      'Y'           CNCF
             UPDATE    CLOANCLF
             ENDIF

             ENDIF

             ENDIF

EKEY         READE     LELOANL4                               60
             ENDDO

crement Path DS index
1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name
             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
outine  :  LOANC0                                         *
tion    :  Process: Loan                                  *
                                                          *
ed by   :  LOANCO - Loan Action for Consolidated Conf     *
s       :  SRPATH - Generate Path String                  *
           SRDCDT - Determine Currency Details            *
           SRADTA - Accumulate RDEs and Associated Data   *
           SRODTA - Output Accumulated Data to            *
                    PF/CGUDTAPD                           *
***********************************************************
OANC0        BEGSR

t up subroutine stack name
             ADD       1             Q
             MOVEL     'LOANC0'      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'LOANC0'      ##GRPS

             EXSR      SRPATH
             EXSR      PSHGRS

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

on Decription
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'C '          #@RDE
             MOVEL     'ACTN DES'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ACTCDE        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ent Principal (Amount)
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'CL'          #@RDE
             MOVEL     'CUR PRIN'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     @@CPAM        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     @@CCY         ##CCY
             EXSR      SRDCDT
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ency
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CURRENCY'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     @@CCY         R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

rest Rate
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'INT RATE'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     @@INTR        ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

 Balance
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'LOAN BAL'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     @@LBAL        ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     @@CCY         ##CCY
             EXSR      SRDCDT
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

 Reference
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'LOAN REF'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LNRF          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

rity Date
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'MATUR DA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     @@MDAT        ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

e Date
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'VALUE DA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     @@VDAT        ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                              CEU014
 settlement currency ##SETL will be taken from the loan.      CEU014
loan amendments and rollovers will have the settlement        CEU014
ivalent amounts calculated in the settlement currency of      CEU014
 loan, rather than that of the loan rollover or amendment.    CEU014
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
             MOVEL     SCCY          ##SETL            3                           CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
rent Principal in Settlement Currency                         CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'C_PRN_SC'    #@RDE                                         CEU01
             MOVE      'CY'          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
tead of using ##SETL, which has data from loan regardless                         CLE031
processing a loan amendment or rollover, use the saved                            CLE031
rency from SRSDET.                                                                CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
rieve the currency details of Loan Currency                                       CLE031
                                                                                  CLE031
             MOVE      *BLANKS       WLINCY            1
@CCY         IFNE      *BLANKS
             MOVEL     @@CCY         ##CCY
             EXSR      SRDCDT
             MOVE      A6INCY        WLINCY
             Z-ADD     A6NBDP        WLNBDP            1 0
             ENDIF
                                                                                  CLE031
version is done only if Derived Settlement currency is                            CLE031
-blank.                                                                           CLE031
                                                                                  CLE031
SETCY        IFNE      *BLANKS
                                                                                  CLE031
rieve the currency details of Derived Settlement Currency                         CLE031
                                                                                  CLE031
             MOVE      *BLANKS       WSINCY            1
             MOVEL     WSETCY        ##CCY
             EXSR      SRDCDT
             MOVE      A6INCY        WSINCY
             Z-ADD     A6NBDP        WSNBDP            1 0
                                                                                  CLE031
vert by calling EU0200 if either of the two following conditions                  CLE031
satisfied:                                                                        CLE031
Loan currency is 'In' currency                                                    CLE031
Derived settlement currency is 'In' currency                                      CLE031
                                                                                  CLE031
LINCY        IFEQ      'Y'
SINCY        OREQ      'Y'
                                                                                  CLE031
             Z-ADD     @@CPAM        P@FRAM
             MOVE      @@CCY         P@FRCY
             MOVE      WSETCY        P@TOCY
             EXSR      D@EURO
             MOVEL     ##OUTA        ##DATA
             MOVEL     WSNBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             ELSE
                                                                                  CLE031
the above condition is not satisfied, convert the Current Principal               CLE031
ng ZCONV and the saved settlement exchange rate and indicator in                  CLE031
routine SELECT.                                                                   CLE031
             Z-ADD     WEXCH         ZEXCH
             MOVE      WMD           ZMD
             Z-ADD     @@CPAM        ZAMTCI
             MOVE      @@CCY         ZCCYI
             MOVE      WSETCY        ZCCYO
             Z-ADD     WLNBDP        ZCDPI
             Z-ADD     WSNBDP        ZCDPO
                                                                                  CLE031
             EXSR      ZCONV
                                                                                  CLE031
             MOVEL     ZAMTCO        ##DATA
             MOVEL     WSNBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             ENDIF
             ENDIF
                                                                                  CLE031
             ELSE
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
#SETL        ANDNE     *BLANKS                                                     CEU01
             MOVEL     ##SETL        ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             Z-ADD     @@CPAM        P@FRAM                                        CEU01
             MOVE      @@CCY         P@FRCY                                        CEU01
             MOVE      ##SETL        P@TOCY                                        CEU01
             EXSR      D@EURO                                                      CEU01
             MOVEL     ##OUTA        ##DATA                                        CEU01
             MOVEL     A6NBDP        ##DCPA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                                                  CLE031
             ENDIF
                                                              CEU014
n Balance in Settlement Currency                              CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'L_BAL_SC'    #@RDE                                         CEU01
             MOVE      'CY'          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                                                  CLE031
Lending Enhancements is installed                                                 CLE031
n Balance will be converted to Settlement Currency.                               CLE031
tlement Currency may be the Receipt Settlement Currency                           CLE031
the Pay Settlement Currency from CLOANCL.                                         CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
PRFLG        IFEQ      'R'
                                                                                  CLE031
rieve the currency details of Receipt Settlement Currency                         CLE031
m CLOANCL.                                                                        CLE031
                                                                                  CLE031
             MOVE      SCCY          WSETCY
             Z-ADD     REXR          WEXCH
             MOVE      REXI          WMD
                                                                                  CLE031
             ELSE
                                                                                  CLE031
rieve the currency details of Pay Settlement Currency                             CLE031
m CLOANCL.                                                                        CLE031
                                                                                  CLE031
             MOVE      PSCY          WSETCY
             Z-ADD     PEXR          WEXCH
             MOVE      PEXI          WMD
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
version is done only if Settlement Currency from CLOANCL is                       CLE031
-blank.                                                                           CLE031
                                                                                  CLE031
SETCY        IFNE      *BLANKS
                                                                                  CLE031
rieve the currency details of Settlement Currency                                 CLE031
                                                                                  CLE031
             MOVE      *BLANKS       WSINCY
             MOVEL     WSETCY        ##CCY
             EXSR      SRDCDT
             MOVE      A6INCY        WSINCY
             Z-ADD     A6NBDP        WSNBDP            1 0
                                                                                  CLE031
vert by calling EU0200 if either of the two following conditions                  CLE031
satisfied:                                                                        CLE031
Loan currency is 'In' currency                                                    CLE031
Derived settlement currency is 'In' currency                                      CLE031
                                                                                  CLE031
LINCY        IFEQ      'Y'
SINCY        OREQ      'Y'
                                                                                  CLE031
             Z-ADD     @@LBAL        P@FRAM
             MOVE      @@CCY         P@FRCY
             MOVE      WSETCY        P@TOCY
             EXSR      D@EURO
             MOVEL     ##OUTA        ##DATA
             MOVEL     WSNBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
                                                                                  CLE031
             ELSE
                                                                                  CLE031
the above condition is not satisfied, convert the Loan Balance                    CLE031
ng ZCONV and the settlement exchange rate and indicator from                      CLE031
ANCL.                                                                             CLE031
             Z-ADD     WEXCH         ZEXCH
             MOVE      WMD           ZMD
             Z-ADD     @@LBAL        ZAMTCI
             MOVE      @@CCY         ZCCYI
             MOVE      WSETCY        ZCCYO
             Z-ADD     WLNBDP        ZCDPI
             Z-ADD     WSNBDP        ZCDPO
                                                                                  CLE031
             EXSR      ZCONV
                                                                                  CLE031
             MOVEL     ZAMTCO        ##DATA
             MOVEL     WSNBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
             ELSE
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
#SETL        ANDNE     *BLANKS                                                     CEU01
             MOVEL     ##SETL        ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             Z-ADD     @@LBAL        P@FRAM                                        CEU01
             MOVE      @@CCY         P@FRCY                                        CEU01
             MOVE      ##SETL        P@TOCY                                        CEU01
             EXSR      D@EURO                                                      CEU01
             MOVEL     ##OUTA        ##DATA                                        CEU01
             MOVEL     A6NBDP        ##DCPA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                                                  CLE031
             ENDIF
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
                                                              CEU014
ermine the Equivalent Currency                                CEU014
                                                              CEU014
             MOVE      *BLANKS       EQCY              3                           CEU01
             MOVE      @@CCY         ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
6INCY        IFEQ      'Y'                                                         CEU01
             MOVE      BKEURO        EQCY                                          CEU01
             ENDIF                                                                 CEU01
@CCY         IFEQ      BKEURO                                                      CEU01
             MOVEL     CNUM          ##KEY                                         CEU01
             CALL      'AOCUSTR0'                                                  CEU01
             PARM      *BLANKS       ##RTCD                                        CEU01
             PARM      '*KEY   '     ##OPTN                                        CEU01
             PARM                    ##KEY            10                           CEU01
             PARM      *BLANKS       ##KYST            7                           CEU01
DCUST        PARM      SDCUST        DSSDY                                         CEU01
                                                              CEU014
#RTCD        IFNE      *BLANK                                                      CEU01
             MOVEL     'SDCUSTPD'    W0FILE                                        CEU01
             MOVEL     CNUM          W0KEY                          ************   CEU01
             Z-ADD     16            W0ERNB                         * DBERR 16 *   CEU01
             MOVEL     'MEM5004'     W0MSGD                         ************   CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
             MOVE      BBDINC        EQCY                                          CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
             ENDIF                                                                 CEU01
                                                              CEU014
rent Principal in Equivalent Currency                         CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'C_PRN_EQ'    #@RDE                                         CEU01
             MOVE      'CY'          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     EQCY          ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             Z-ADD     @@CPAM        P@FRAM                                        CEU01
             MOVE      @@CCY         P@FRCY                                        CEU01
             MOVE      EQCY          P@TOCY                                        CEU01
             EXSR      D@EURO                                                      CEU01
             MOVEL     ##OUTA        ##DATA                                        CEU01
             MOVEL     A6NBDP        ##DCPA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
n Balance in Equivalent Currency                              CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'L_BAL_EQ'    #@RDE                                         CEU01
             MOVE      'CY'          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     EQCY          ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             Z-ADD     @@LBAL        P@FRAM                                        CEU01
             MOVE      @@CCY         P@FRCY                                        CEU01
             MOVE      EQCY          P@TOCY                                        CEU01
             EXSR      D@EURO                                                      CEU01
             MOVEL     ##OUTA        ##DATA                                        CEU01
             MOVEL     A6NBDP        ##DCPA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ivalent Currency                                              CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
             MOVE      'Y '          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     EQCY          ##DATA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ivalent Currency Description                                  CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'EQUIV_CC'    #@RDE                                         CEU01
             MOVE      'YD'          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
WNCPYSRC,CG6065C001
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     A6CYNM        ##DATA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01

WNCPYSRC,CG6065C002

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

             EXSR      SRADTA
             EXSR      SRODTA

crement Path DS index
1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
             EXSR      POPGRS

wind subroutine stack name
             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************
 5
***********************************************************
routine  :  LOANA                                         *
ction    :  Process: Loan Associated Details              *
                                                          *
led by   :  L12CO  - Loan Consolidated Confirmation       *
                     Confirmation                         *
ls       :  SRPATH - Generate Path String                 *
            CG6001 - General Loan Details                 *
***********************************************************
OANA         BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'LOANA '      @STK(Q)

             EXSR      SRPATH

             MOVEL     S#PATH        P2PARM
             Z-ADD     ##OSEQ        P1OSEQ
             Z-ADD     ##ITEM        P1ITEM
             Z-ADD     ##TBIN        P1TBIN
             Z-ADD     ##PBIN        P1PBIN

t up data.

             CLEAR                   P3PARM
             CLEAR                   P4PARM
             MOVE      LNRF          P3LNRF
             CALL      'CG6001'
             PARM      *BLANKS       W0RTN             7
             PARM                    W0CMT             3
             PARM                    P1PARM                         UDC Details
             PARM                    P2PARM          140            Path Details
             PARM                    P3PARM                         Loan Details
             PARM                    P4PARM                         Facility Details
             PARM                    ##AUTO
             PARM                    ##REFR
             PARM                    P@ICR
             PARM      'N'           ##MAST

set Sequence number.

             Z-ADD     P1OSEQ        ##OSEQ

XXPAY        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRSDET                                        *
ction    :  Set-up settlement details.                    *
                                                          *
led by   :  L12CO  - Loan Consolidated Confirmation       *
ls       :  CG99LSET - To set-up settlement details       *
***********************************************************
RSDET        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRSDET'      @STK(Q)

             ADD       1             P1
                                                                                  CCG015
1            OCCUR     ##PATH
             MOVEL(P)  'L_SETL'      ##GRPS
             EXSR      SRPATH
             EXSR      PSHGRS

             MOVEL     S#PATH        P2PARM

up the parameters for CG99LSET

             CLEAR                   P0PARM
             MOVEL     OSDB          P0POBR
             MOVEL     OMDB          P0ROBR
             Z-ADD     RSTM          P0RSTM
             MOVEL     RONS          P0RONS
             MOVEL     RIBN          P0RIBN
             MOVEL     RIBA          P0RIBA
****           Z-ADDROBN      P0ROBN                                              CSD027
****           Z-ADDROCN      P0ROCN                                              CSD027
             MOVE      ROBN          P0ROBN
             MOVE      ROCN          P0ROCN
             Z-ADD     PSTM          P0PSTM
             MOVEL     PONS          P0PONS
             MOVEL     PIBN          P0PIBN
             MOVEL     PIBA          P0PIBA
****           Z-ADDPOBN      P0POBN                                              CSD027
****           Z-ADDPOCN      P0POCN                                              CSD027
             MOVE      POBN          P0POBN
             MOVE      POCN          P0POCN
             MOVEL     RCRN          P0RCRN
             MOVEL     RCRA          P0RCRA
             MOVEL     RVNO          P0RVNO
             MOVEL     AWBN          P0AWBN
             MOVEL     AWBA          P0AWBA
             MOVEL     BENN          P0BENN
             MOVEL     BENA          P0BENA
             MOVEL     DTP1          P0DTP1
             MOVEL     DTP2          P0DTP2
             MOVEL     DTP3          P0DTP3
             MOVEL     DTP4          P0DTP4
             MOVEL     DCHG          P0DCHG
             MOVEL     BTB1          P0BTB1
             MOVEL     BTB2          P0BTB2
             MOVEL     BTB3          P0BTB3
             MOVEL     BTB4          P0BTB4
             MOVEL     BTB5          P0BTB5
             MOVEL     BTB6          P0BTB6
             MOVEL     SPI1          P0SPI1
             MOVEL     SPI2          P0SPI2
             MOVEL     SPI3          P0SPI3
EU014        IFEQ      'Y'                                                         CEU01
LE031        OREQ      'Y'
             MOVEL     SCCY          P0STCY                                        CEU01
             ENDIF                                                                 CEU01
                                                                                  CLE031
LE031        IFEQ      'Y'
             MOVEL     PSCY          P0PSCY
             ENDIF

-up UDC Details

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

abase error

             MOVEL     'CG99LSET'    W0FILE
             MOVEL     'W0RTN'       W0KEY                          ***************
             Z-ADD     07            W0ERNB                         * DB ERROR 07 *
             MOVEL     'MEM5003'     W0MSGD                         ***************
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

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRINZF                                        *
ction    :  Initialise Fields on Program Invocation       *
                                                          *
led by   :  Mainline                                      *
ls       :  none                                          *
***********************************************************
RINZF        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRINZF'      @STK(Q)

itialise work fields

             MOVE      PRPAR         WPARM
****           MOVE WCUS      ##WCUS  60                                          CSD027
             MOVE      WCUS          ##WCUS            6

             MOVE      'Y'           ##CNCF            1
             MOVE      *BLANKS       ##RCDT            1
****           Z-ADD*ZEROS    ##LNRF  60                                          CLE148
             MOVEL     *BLANKS       ##LNRF            6
             Z-ADD     *ZEROS        ##VDAT            5 0
             Z-ADD     *ZEROS        ##LASN            3 0
             MOVE      *BLANKS       ##CHTP            1
             MOVE      *BLANKS       ##COPD            1
             MOVE      *BLANKS       ##AUTO            1
             Z-ADD     *ZEROS        ##W050            5 0
             Z-ADD     *ZEROS        ##W150           15 0
             Z-ADD     *ZEROS        ##W157           15 7
             Z-ADD     *ZEROS        #1                6 0
             Z-ADD     *ZEROS        #2                6 0
             Z-ADD     *ZEROS        #3                6 0
             MOVE      *BLANKS       S#PATH          256
LIKE         DEFINE    DEOSEQ        ##OSEQ

itialise output sequence (to CGUDTAPD)

             Z-ADD     *ZEROS        ##OSEQ

 Additions for CG4999 1st version **

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

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRINIT                                        *
ction    :  Initial processing - First Call Only          *
                                                          *
led by   :  Mainline                                      *
ls       :  SRERR  - Report Error and Close Down Program  *
            SRDCDT - Determine Currency Details           *
***********************************************************
RINIT        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRINIT'      @STK(Q)

l access program for Bank details

             CALL      'AOBANKR0'
             PARM      *BLANKS       ##RTCD            7
             PARM      '*FIRST  '    ##OPTN            7
DBANK        PARM      SDBANK        DSSDY

#RTCD        IFNE      *BLANK

abase error

             MOVEL     'AOBANKR0'    W0FILE
             MOVEL     '*CALL'       W0KEY                          ***************
             Z-ADD     01            W0ERNB                         * DB ERROR 01 *
             MOVEL     'MEM5003'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

JDFIN        COMP      'M'                                    98    MMDDYY, 98 ON

etermine Number of decimal places - Base currency

             MOVEL     BJCYCD        ##CCY
             EXSR      SRDCDT
             Z-ADD     A6NBDP        BASCDP            1 0
                                                              CEU014
ess GL ICD for Euro currency code                             CEU014
                                                              CEU014
****           CALL 'AOGELRR0'                                             CEU014 CGL029
             CALL      'AOGELRR1'
             PARM      *BLANKS       ##RTCD                                        CEU01
             PARM      '*FIRST '     ##OPTN                                        CEU01
**** SDGELR    PARM SDGELR    DSFDY                                        CEU014 CGL029
DGELR        PARM      SDGELR        DSSDY
                                                              CEU014
ABASE ERROR                                                   CEU014
                                                              CEU014
#RTCD        IFNE      *BLANKS                                                     CEU01
             MOVEL     'SDGELRPD'    W0FILE                                        CEU01
             MOVEL     ##OPTN        W0KEY                          ***************CEU01
             Z-ADD     13            W0ERNB                         * DB ERROR 13 *CEU01
             MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ck if CEU014 - EMU UDC Enhancement - is switched on           CEU014
                                                              CEU014
             CALL      'AOSARDR0'                                                  CEU01
             PARM      *BLANKS       ##RTCD            7                           CEU01
             PARM      '*KEY    '    ##OPTN            7                           CEU01
             PARM      'CEU014'      PSARD             6                           CEU01
CSARD        PARM      SCSARD        DSFDY                                         CEU01
                                                              CEU014
#RTCD        IFEQ      *BLANK                                                      CEU01
             MOVE      'Y'           CEU014            1                           CEU01
             ELSE                                                                  CEU01
             MOVE      'N'           CEU014                                        CEU01
#RTCD        IFNE      '*NRF    '                                                  CEU01
             MOVEL     'SCSARDPD'    W0FILE                                        CEU01
             MOVEL     'CEU014'      W0KEY                          ************   CEU01
             Z-ADD     14            W0ERNB                         * DBERR 14 *   CEU01
             MOVEL     'MEM5003'     W0MSGD                         ************   CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             ENDIF                                                                 CEU01
             ENDIF                                                                 CEU01
                                                                                  CCG015
ck if CCG015 is ON                                                                CCG015
                                                                                  CCG015
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD             7
             PARM      '*VERIFY '    POPTN             7
             PARM      'CCG015'      PSARD             6
CSARD        PARM      SCSARD        DSFDY
                                                                                  CCG015
RTCD         IFEQ      *BLANK
             MOVE      'Y'           CCG015            1
             ELSE
             MOVE      'N'           CCG015
RTCD         IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     17            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF
                                                                                  CLE031
ck if CLE005 (Lending Enhancements - Tranche 3)                                   CLE031
on.                                                                               CLE031
                                                                                  CLE031
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD
             PARM      '*VERIFY '    POPTN
             PARM      'CLE005'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE031
RTCD         IFEQ      *BLANK
             MOVE      'Y'           CLE005            1
             ELSE
             MOVE      'N'           CLE005
RTCD         IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     18            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF
                                                                                  CLE031
ck if CLE031 (Lending Enhancements)                                               CLE031
on.                                                                               CLE031
                                                                                  CLE031
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD
             PARM      '*VERIFY '    POPTN
             PARM      'CLE031'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE031
RTCD         IFEQ      *BLANK
             MOVE      'Y'           CLE031            1
             ELSE
             MOVE      'N'           CLE031
RTCD         IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     19            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF
                                                                                  CLE036
ck if CLE036 is installed.                                                        CLE036
                                                                                  CLE036
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD
             PARM      '*VERIFY '    POPTN
             PARM      'CLE036'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE036
RTCD         IFEQ      *BLANK
             MOVE      'Y'           CLE036            1
             ELSE
             MOVE      'N'           CLE036
RTCD         IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     20            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF
                                                                                  CLE154
ck if CLE154 is installed.                                                        CLE154
                                                                                  CLE154
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD
             PARM      '*VERIFY '    POPTN
             PARM      'CLE154'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE154
RTCD         IFEQ      *BLANK
             MOVE      'Y'           CLE154            1
             ELSE
             MOVE      'N'           CLE154
RTCD         IFNE      '*NRF    '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     20            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF

pyright
             MOVEA     CPY@          ACT@             80

XINIT        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRADTA                                        *
ction    :  Accumulate RDEs and associated data for output*
                                                          *
led by   :  LOANC0 - Process Loan                         *
ls       :  CG3999 - Format and Pack Data                 *
            SRRFMN - Reformat RDE Data                    *
            SRERR  - Database Error                       *
***********************************************************
RADTA        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRADTA'      @STK(Q)

format RDE data

             EXSR      SRRFMN

ck RDEs and associated data into data string

             CLEAR                   ##SDS
CG015        IFEQ      'Y'
             MOVEL     '*NEWARR '    W0ACT
             MOVEL     S#PATH        W0SPAT
             ELSE
             MOVEL     '*PACK   '    W0ACT
             MOVEL     *BLANK        W0SPAT
             ENDIF
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

tabase error

#RTCD        IFNE      *BLANK

             MOVEL     'CG3999  '    W0FILE                         ***************
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 02 *
             Z-ADD     02            W0ERNB                         ***************
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             EXSR      WRTRDE

pend Data from pack routine.

@SDS         CAT       ##SDS:0       #@SDS

             MOVEL     *BLANK        ##R
             MOVEL     *BLANK        ##D
             MOVEL     *BLANK        ##S

XADTA        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRODTA                                        *
ction    :  Output Accumulated data to PF/CGUDTAPD        *
                                                          *
led by   :  LOANC0 - Process Loan                         *
ls       :  CG9020 - Output Data to CGUDTAPD              *
            SRERR  - Database Error                       *
***********************************************************
RODTA        BEGSR

t up subroutine stack name

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

tput PF/CGUDTAPD Record.

CG015        IFEQ      'N'
             CALL      'CG9020'
             PARM      *BLANK        ##RTCD
             PARM      '*WRITE  '    W0ACT
             PARM                    W0PATH          256
             PARM                    W0FMT
             PARM      *BLANK        W0TITL            7
             PARM      *BLANK        W0ULIN            7
             PARM                    W0CMT

tabase error

#RTCD        IFNE      *BLANK

             MOVEL     'CG9020  '    W0FILE                         ***************
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 03 *
             Z-ADD     03            W0ERNB                         ***************
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF

             CLEAR                   #@SDS

XODTA        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRBIND                                        *
ction    :  Generate Binding numbers                      *
                                                          *
led by   :  All Repeating Group Set Subroutines           *
ls       :  none                                          *
***********************************************************
RBIND        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRBIND'      @STK(Q)

1            SUB       1             P2
2            OCCUR     ##BIND

             Z-ADD     ##TBIN        #@TBIN
1            OCCUR     ##BIND
             Z-ADD     #@TBIN        ##PBIN

             ADD       1             #@BIND
             Z-ADD     #@BIND        ##TBIN

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRPATH                                        *
ction    :  Generate Path String /GS1/GS2...              *
                                                          *
led by   :  L12CO  - Loan Consolidated Confirmation       *
            LOANCO - Loan Action Consolidated Conf        *
            LOANC0 - Process Loan                         *
            LOANA  - Process Loan Associated Details      *
            SRSDET - Set-up settlement details            *
ls       :  none                                          *
***********************************************************
RPATH        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRPATH'      @STK(Q)

             CLEAR                   S#PATH

             DO        P1            P2
2            OCCUR     ##PATH
#PATH        CAT       '\':0         S#PATH
#PATH        CAT       ##GRPS:0      S#PATH
             END

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRRFMN                                        *
ction    :  Reformat RDE data                             *
                                                          *
led by   :  SRADTA - Accumulate RDEs and associated       *
                     data for outout                      *
ls       :  none                                          *
***********************************************************
RRFMN        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRRFMN'      @STK(Q)

p through RDE's and data

             Z-ADD     0             #1
1            DOUEQ     20
             ADD       1             #1
             MOVEL     ##R(#1)       R#DEFN
             MOVEL     ##D(#1)       R#DATA

data present and RDE is edited

#DATA        IFNE      *BLANK
#RDEC        ANDNE     *BLANK

ormat Amount

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

n the amount

#SIGN        IFEQ      '-'
             Z-SUB     ##WNUM        ##NUMB
             ELSE
             Z-ADD     ##WNUM        ##NUMB
             END

ault Edit Type

#EDTT        IFEQ      *BLANK
             MOVEL     ##RDET        ##EDTT
             END

ault Decimal Places

#DCPA        IFEQ      *BLANK
             MOVEL     ##RDED        ##DCPA
             END

 RDE data

             MOVEL     R#DATA        ##D(#1)
             ENDIF
             ENDDO

XRFMN        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRDCDT                                        *
ction    :  Determine Currency Details                    *
                                                          *
led by   :  LOANC0 - Loan Details                         *
            SRINIT - Initial Processing - On First Call   *
ls       :  SRERR  - Database Error                       *
***********************************************************
RDCDT        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRDCDT'      @STK(Q)

cess array of Currency Details already loaded

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

tabase Error

#RTCD        IFNE      *BLANK
             MOVEL     'SDCURRPD'    W0FILE
             MOVEL     ##CCY         W0KEY                          ***************
             Z-ADD     04            W0ERNB                         * DB ERROR 04 *
             MOVEL     'MEM5004'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF

 the currency has been retrieved earlier, position the
rrency Data data structure on the relevant occurrence.

             ELSE
             OCCUR     SDCURR
             ENDIF

XDCDT        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************
 5                                                            CEU014
***********************************************************   CEU014
outine  :  D@EURO                                         *   CEU014
tion    :  EURO Currency Conversion:                      *   CEU014
erts amount P@FRAM in P@FRCY to ##OUTA in P@TOCY          *   CEU014
ed by   :  LOANC0                                         *   CEU014
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
             PARM      0             P@OUTA           15 0          Outright AmountCEU01
             PARM      0             P@INTA           18 3          Interim Amount CEU01
             PARM      0             P@EXRT           15 9          Exchange Rate  CEU01
             PARM      *BLANK        P@MDIN            1            Mult/Div Ind.  CEU01
                                                              CEU014
abase error handling:                                         CEU014
                                                              CEU014
@RTCD        IFEQ      '*ERROR*'                                                   CEU01
             MOVEL     'EU0200  '    W0FILE                                        CEU01
             MOVEL     '*CALL   '    W0KEY                          ***************CEU01
             Z-ADD     15            W0ERNB                         * DB ERROR 15 *CEU01
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
***********************************************************   CEU014

CGCPYSRC,SRERRPSSRL

CGCPYSRC,SRERRCLE

CGCPYSRC,CGNWEXILE
                                                                                  CCG015
ZSRSRC,ZCONVZ1ILE
                                                                                  CLE031
      OBJECT COPYRIGHT
 International Limited 2001
ARRAY OF POWERS FOR CURRENCY CONVERSION                                           CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
