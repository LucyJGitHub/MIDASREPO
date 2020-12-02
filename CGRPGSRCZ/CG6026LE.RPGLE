
***********************************************************
BASEBND                                                   *
T('Midas CG Lending multi-curr rollover confirmations')   *
***********************************************************
                                                          *
as - User Defined Correspondence                          *
                                                          *
026LE - Multi-Currency Rollover Confirmations (ILE)       *
                                                          *
ction:  This program extracts data for Multi-             *
rency Rollover Confirmations                              *
                                                          *
led By: CG6020 - Lending Rollover Confirmations Driver    *
                                                          *
 Finastra International Limited 2001                      *
                                                          *
t Amend No. CLE172             Date 23Oct20               *
v Amend No. MD054660           Date 19Nov19               *
            MD046248           Date 27Oct17               *
            CLE154             Date 07Aug12               *
            CLE134             Date 01Aug12               *
            CLE148             Date 23Jul12               *
            AR822053           Date 29Aug11               *
            CLE143             Date 06Dec10               *
 Fusion Midas 1.4 Base -----------------------------------*
s Plus 1.4 Base 04 ---------------------------------------*
s Plus 1.4 Base ------------------------------------------*
s Plus 1.3 ----------- Base ------------------------------*
            CSD031             Date 10Apr06               *
            CSD027             Date 09Dec05               *
            CLE042             Date 06Sep05               *
            BUG9646            Date 20Dec05               *
            CSW037A            Date 02May05               *
            CSD025             Date 11Jan05               *
            CSW037             Date 15Dec04               *
            CSW036             Date 15Dec04               *
            CLE025             Date 20Oct03               *
            CSC022             Date 24Feb04               *
            CGL029             Date 01Sep03               *
            CAP075             Date 08Aug02               *
            CLE031             Date 10Feb03               *
            CLE028             Date 27Jun02               *
s Release 4.01 -------------------------------------------*
            CCG015             Date 09Aug01               *
s Release 4 --------------- Base -------------------------*
s DBA 3.05 -----------------------------------------------*
            CSD006             Date 15May01               *
            CLE011             Date 07Nov00               *
s DBA 3.03 -----------------------------------------------*
s DBA 3.02 -----------------------------------------------*
            163486             Date 14Oct99               *
s DBA 3.00 ---------------- Base -------------------------*
            145995             Date 09Dec98               *
            CEU014             Date 23JUN98               *
            CLE004 *CREATE     Date 29APR97               *
                                                          *
----------------------------------------------------------*
                                                          *
172 - Libor Deregulation - Lending                        *
54660 - Incorrect Next Interest Repayment Date for loans  *
        with repayment type 1 or 3.                       *
46248 - Finastra Rebranding                               *
154 - Loan Repayment Schedule Enhancement (Recompile)     *
134 - Past Due Call Loan Processing (Recompile)           *
148 - Alpha Loan Reference                                *
22053 - Incorrect value of Effective Annual Interest Rate *
        in CGUXMLPD                                       *
143 - Original Loan Contract Date & Effective Interest    *
      Rate                                                *
031 - Enhanced Centralised Static Data (Recompile)        *
027 - Conversion Of Customer Number to Alpha              *
042 - Extended Loan Sub Type (Recompile)                  *
9646- Changes in CGPACKE causes programs not to compile   *
037A- Additional Field extended to 40 chars (recompile)   *
025 - Customer De-Activation                              *
037 - Additional Field Data on MT300/MT320                *
036 - Dual SWIFT BIC held on Client Details               *
025 - Credit Lines (Recompile)                            *
022 - Commitment Control Changes for MidasPlus            *
      (Recompile)                                         *
029 - Increase Account Code to 10 digits                  *
075 - Lending API enhancements - Loan Amendment.          *
      (amendment in common with CAP079)                   *
031 - Lending Enhancements.                               *
028 - Flat Rate Personal Loans (Rule of 78s)              *
      (Recompile)                                         *
015 - Correspondence Manager Phase 1.                     *
006 - Recompiled over changed SDCURRPD.                   *
011 - Rate Fixing Days for Lending Rollover Processing    *
      Recompile                                           *
486 - Recompile due to changes in LVENTEL.                *
995 - Incorrect value for multi-ccy rollover fields       *
      This is the same fix as 135620 in LE0426 and LE1170 *
014 - EMU User Defined Correspondence Enhancement.        *
004 - Syndications & Authorisations                       *
                                                          *
***********************************************************
    IF   E           K DISK    INFSR(SRFILE)
                               IGNORE(CLOANHHF)
                               IGNORE(CLOANZ1F)
L   IF   E           K DISK
L4  IF   E           K DISK                                         145995
 FUNCTION OF INDICATORS
***********************************************************
                                                          *
 N C T I O N    O F    I N D I C A T O R S                *
                                                          *
  -    Record not foung on LF/CLOAN                       *
  -    End of LF/LVNTROL                                  *
  -    General error indicator                            *
                                                          *
***********************************************************
 SUBROUTINE INDEX
***********************************************************
                                                          *
 B R O U T I N E    I N D E X                             *
                                                          *
n routine                                                 *
NIT  -  Initial Processing - On First Call                *
NZ   -  Initialise Fields on Each Invocation              *
AIN  -  Main Processing                                   *
ETL  -  Obtain Detail Information                         *
RM   -  Process: Rollover Confs (multi ccy)               *
NRM  -  Process: Loan Rollover Detl (multi ccy)           *
NA   -  Process Loan Associated Details                   *
DET  -  Set-up Settlement Details                         *
DTA  -  Accumulate RDEs and Associated Data for output    *
DTA  -  Output Accumulated Data to PF/CGUDTAPD            *
IND  -  Generate Binding Numbers                          *
ATH  -  Generate Path String                              *
FMN  -  Reformat RDE Data                                 *
CDT  -  Determine Currency Details                        *
ENR  -  Generate Reference Number                         *
                                                          *
***********************************************************

***********************************************************
CGCPYSRC,CGPACKDLE
CGCPYSRC,SRERRDLE
mber Arrays

ray of Currencies accessed by program
           S              3    DIM(100)

pyright array.
           S              7  3 DIM(7) CTDATA PERRCD(1)              POWER ARRAY
ok-up string for RDE definition Array

           DS

           DS
                5120   5120
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
r error reporting


n details parameter for call to CG99LSET

S          DS           256
ency
1                  1      3
omer Number
****                              4   90##CNUM                                    CSD027
UM                 4      9
ch
CA                10     12
essing Type
YP                13     14  0

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
ment Currency                                                                     CLE031
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

M          DS           256
cility Customer Number
****                              1   60P4CNUM                                    CSD027
UM                 1      6
cility Type
AM                 7      9  0
cility Number
NO                10     11  0

-----------------------------------------------------------
 constants

P          C                   CONST('LOAN ROLLO')
1          C                   CONST('MULTI CCY')
-----------------------------------------------------------

M        E DS                  EXTNAME(LOAMSDK)
ernal DS for parameter passed from CG6020

R        E DS                  EXTNAME(CGUDCRPD)
ernal DS for incomplete reference

K        E DS                  EXTNAME(SDBANKPD)
ternal DS for Bank details

R        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
ternal DS for currency details
WNCPYSRC,CG6026I001

T        E DS                  EXTNAME(SDCUSTPD)                    CEU014
ternal DS for customer details                                CEU014
                                                              CEU014
R        E DS                  EXTNAME(SDGELRPD)                    CEU014
or GL ICD Details                                             CEU014
                                                              CEU014
D        E DS                  EXTNAME(SCSARDPD)                    CEU014
D        E                     EXTFLD(LCD)                          CEU014
tchable Feature details - rename LCD field.                   CEU014
                                                              CEU014
         E DS                  EXTNAME(DSFDY)                       CEU014
rst DS for access programs, short data structure              CEU014
                                                              CEU014
         E DS                  EXTNAME(DSSDY)
cond DS for access programs, long data structure

         E DS                  EXTNAME(CGUDTAPD)
cord format of PF/CGUDTAPD for use as a parameter


           DS
ta Structure for Compilation - Copyright Insertion
Y                  1     80
                               DIM(1) CTDATA PERRCD(1)
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


LF
ame fields of CLOANCL
        RECI                        ##RECI
        LNRF                        ##LNRF
        MRIN                        ##MRIN
        PTYP                        ##PTYP
        CNUM                        ##CNUM
        BRCA                        ##BRCA
        LTYP                        ##LTYP
        SUTP                        ##SUTP
        VDAT                        ##VDAT
        FCUS                        ##FCUS
        FTYP                        ##FTYP
        FSEQ                        ##FSEQ
        CCY                         ##CCY1
        INTC                        ##INTC
        BRTT                        ##BRTT
        BRTE                        ##BRTE
        SPIN                        ##SPIN
        WTIN                        ##WTIN
        REPT                        ##REPT
        NACD                        ##NACD
        AUTO                        ##AUT1
        FACO                        ##FACO
        FCLB                        ##FCLB
        ORED                        ##ORED
        LCD                         ##LCD
        CHTP                        ##CHTP
        TNLU                        ##TNLU
        CVMR                        ##CVMR
        SCCY                        ##STCY                          CEU014
        OCDT                        ##OCDT
        EAIR                        ##EAIR

WNCPYSRC,CG6025IIP1


KF
ame fields of CLOANCK
        RECI                        ##RECI
        LNRF                        ##LNRF
        MRIN                        ##MRIN
        SPI1                        ##SPI1
        SPI2                        ##SPI2
        SPI3                        ##SPI3

LF
ame fields of LVENTEL
        RECI                        LVRECI
        LNRF                        LVLNRF
        INTR                        LVINTR
        CPAM                        LVCPAM
        BRCA                        LVBRCA
PF                                                                  145995
        BRCA                        BRCAP                           145995
        CNUM                        CNUMP                           145995
        LNRF                        LNRFP                           145995
        VDAT                        VDATP                           145995
        PTYP                        PTYPP                           145995
        CCY                         CCYP                            145995
        AMTP                        AMTPP                           145995
        PRAM                        PRAMP                           145995
        INTA                        INTAP                           145995
        LTYP                        LTYPP                           132620
        SUTP                        SUTPP                           145995
        INTR                        INTRP                           145995

***********************************************************
ess     :  MAINLINE                                       *
tion    :  Mainline processing                            *
                                                          *
ed by   :  None                                           *
s       :  SRINIT - Initial Processing - On First Call    *
           SRINZ  - Initialise Fields on Each Invocation  *
           SRMAIN - Main Processing                       *
***********************************************************

rameter list for current program invocation.

ENTRY        PLIST
             PARM                    W0RTN             7
             PARM                    W0CMT             3
             PARM                    ##COPD            1
             PARM                    DSPARM

t up subroutine stack name

             ADD       1             Q
             MOVEL     'MAIN'        @STK(Q)

itial processing - Once Only

#INIT        IFEQ      *BLANK
             EXSR      SRINIT
             MOVE      'Y'           ##INIT            1
             END

tialisation processing

             EXSR      SRINZ

n processing

             EXSR      SRMAIN

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

rminate program

             RETURN

***********************************************************
outine  :  SRMAIN                                         *
tion    :  Main processing                                *
                                                          *
ed by   :  Mainline                                       *
s       :  SRDETL - Obtain Detail Information             *
           SRGENR - Generate reference number by writing  *
                    to PF/CGUDCRPD                        *
           L10RM  - Process Lending Rollover Confirmation *
                    Multi-Currency                        *
***********************************************************
RMAIN        BEGSR

t up subroutine stack name

             ADD       1             Q                 5 0
             MOVEL     'SRMAIN'      @STK(Q)

             EXSR      SRDETL

nerate reference number by writing to PF/CGUDCRPD
 no confirmation to be produced, then bypass

             MOVE      'N'           ##COPD
WNCPYSRC,CG6026C002
             EXSR      SRGENR
#COPD        CABEQ     'N'           EXMAIN

ract

             EXSR      L10RM

XMAIN        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR

***********************************************************
routine  :  SRDETL                                        *
ction    :  Process: Obtain detail information            *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  SRERR  - Database Error                       *
***********************************************************
RDETL        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRDETL'      @STK(Q)

LOANK        KLIST
             KFLD                    LNRF
             KFLD                    RCDT

             MOVEL     'A'           RCDT

LOANK        CHAIN     CLOAN                              90

IN90         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE                         ***************
             MOVEL     LNRF          W0KEY                          * DB ERROR 01 *
             Z-ADD     01            W0ERNB                         ***************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

             MOVEL     'B'           RCDT

LOANK        CHAIN     CLOAN                              90

IN90         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE                         ***************
             MOVEL     LNRF          W0KEY                          * DB ERROR 02 *
             Z-ADD     02            W0ERNB                         ***************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

             Z-ADD     0             WEAMT            13 0
             MOVEL     *BLANKS       WECCY             3                           14599

ess the events file to get the interest record for this
n in order to output the correct info to the confirmation

NRF          SETLL     LVNTROL
             READ      LVNTROL                                91

type is not ROLLOVER CHECK - read next record which is the
LOVER - If not reset file to above record.

TYP          IFNE      'R5'
NRF          ANDEQ     LVLNRF
IN91         ANDEQ     '0'
DAT          ANDEQ     VDAT

d file again to pick up ROLLOVER details.

             READ      LVNTROL                                91

End of File or Record for another loan, or not ROLLOVER
different Action Date, reset file to previous read.

IN91         IFEQ      '1'
NRF          ORNE      LVLNRF
TYP          ORNE      'R5'
DAT          ORNE      VDAT

NRF          SETLL     LVNTROL
             READ      LVNTROL                                91

             END
             END

IN91         IFEQ      '0'
NRF          ANDEQ     LVLNRF
             Z-ADD     EAMT          WEAMT
             MOVEL     ECCY          WECCY                                         14599

e LVNTROL event date to output next interest payment date
ether it is actually an interest payment date or maturity
te.

TYP2         IFNE      'R2'
TYP2         OREQ      'R2'
#REPT        ANDEQ     1
TYP2         OREQ      'R2'
#REPT        ANDEQ     3
             MOVE      EDAT          NIDT
             END
             END
                                                              145995
ess LEHISTL4 to get original principal amount (which has      145995
n netted already of repayment amount on rollover date         145995
                                                              145995
             MOVE      BRCA          BRCAK                                         14599
****           Z-ADDCNUM      CNUMK                                        145995 CSD027
             MOVE      CNUM          CNUMK
****           Z-ADDLNRF      LNRFK                                        145995 CLE148
             MOVEL     LNRF          LNRFK
             Z-ADD     VDAT          VDATK                                         14599
OAMT         SETGT     LEHISTL4                                                    14599
OAMT         READPE    LEHISTL4                               60                   14599
                                                              145995
IN60         DOWEQ     '0'                                                         14599
MTPP         ANDNE     'RE'                                                        14599
OAMT         SETGT     LEHISTL4                                                    14599
OAMT         READPE    LEHISTL4                               60                   14599
             ENDDO                                                                 14599
                                                              145995
IN60         IFEQ      '1'                                                         14599
MTPP         ANDNE     'RE'                                                        14599
             MOVEL     'LEHISTL4'    W0FILE                         ***************14599
             MOVEL     LNRF          W0KEY                          * DB ERROR 13 *14599
             Z-ADD     13            W0ERNB                         ***************14599
             MOVEL     'MEM5004'     W0MSGD                                        14599
             MOVEL     'MIDAS  '     W0MSGF                                        14599
             EXSR      SRERR                                                       14599
             ENDIF                                                                 14599
                                                              145995

XDETL        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR

***********************************************************
outine  :  L10RM                                          *
tion    :  Process: Lending Rollover Confirmations        *
           Multi-Currency                                 *
ed by   :  SRMAIN - Main Processing                       *
s       :  SRPATH - Generate Path String                  *
           LOANRM - Process Loan Rollover details         *
                    Multi-Currency                        *
           SRSDET - Set-up Settlement Details             *
           LOANA  - Process Loan Associated Details       *
***********************************************************
10RM         BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'L10RM '      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'l10RM '      ##GRPS

             EXSR      SRPATH
             EXSR      PSHGRS

             EXSR      LOANRM

WNCPYSRC,CG6025CCP1


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
outine  :  LOANRM                                         *
tion    :  Process: Loan Rollover details Multi-Currency  *
                                                          *
ed by   :  L10RM - Process Lending Rollover Confirmations *
                   Multi-Currency                         *
s       :  SRPATH - Generate Path String                  *
           SRDCDT - Determine Currency Details            *
           SRADTA - Accumulate RDEs and Associated Data   *
           SRODTA - Output Accumulated Data to            *
                     PF/CGUDTAPD                          *
***********************************************************

OANRM        BEGSR

t up subroutine stack name
             ADD       1             Q
             MOVEL     'LOANRM'      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'LOANRM'      ##GRPS

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

ency Description

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

ent Principal (Amount)

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'CL'          #@RDE
             MOVEL     'CUR PRIN'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
*****          MOVELCPAM      ##DATA                          145995
             MOVEL     PRAMP         ##DATA                                        14599
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
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
             MOVEL     CCY           R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

s Interest

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'ST'          #@RDE
             MOVEL     'GRS INTR'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     WEAMT         ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
*****          MOVELCCY       ##CCY                           145995
             MOVEL     WECCY         ##CCY                                         14599
             EXSR      SRDCDT
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

rest Rate

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'INT RATE'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     INTR          ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
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

 Interest Payment Date

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'NXT IPDA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     NIDT          ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

 Rollover Date

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'NXT RLDA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     NROD          ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

over Currency Code

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ROLL CCY'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     NCCY          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

over Currency Description

             MOVEL     NCCY          ##CCY
             EXSR      SRDCDT
             MOVEL     A6CYNM        ##WRK            14
             MOVE      A6INCY        FCCYIN            1
             MOVE      A6NBDP        FNBDP             1 0

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      '_D'          #@RDE
             MOVEL     'ROLL CCY'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##WRK         R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

over Currency Amount

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'MT'          #@RDE
             MOVEL     'ROLL CYA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
*****          MOVELNCPA      ##DATA                          145995
             MOVEL     PRAM          ##DATA                                        14599
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     NCCY          ##CCY
             EXSR      SRDCDT
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

over Date

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'E '          #@RDE
             MOVEL     'ROLL DAT'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     VDAT          ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

date; production time

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

                                                              CEU014
ermine the settlement currency ##SETL                         CEU014
                                                              CEU014
             SELECT                                                                CEU01
TYP          WHENLE    65                                                          CEU01
             MOVE      RPSC          ##SETL            3                           CEU01
TYP          WHENEQ    66                                                          CEU01
TYP          OREQ      67                                                          CEU01
             MOVE      RRSC          ##SETL                                        CEU01
             ENDSL                                                                 CEU01
                                                              CEU014
lover currency amount in Settlement Currency                  CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'ROLL_SCC'    #@RDE                                         CEU01
             MOVE      'Y '          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
#SETL        ANDNE     *BLANKS                                                     CEU01
LE031        OREQ      'Y'
#SETL        ANDNE     *BLANKS
                                                                                  CLE031
             MOVEL     ##SETL        ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             MOVE      A6INCY        TCCYIN            1
             MOVE      A6NBDP        TNBDP             1 0
*****          Z-ADDNCPA      P@FRAM                   CEU014 145995
             Z-ADD     PRAM          P@FRAM                                        14599
             MOVE      NCCY          P@FRCY                                        CEU01
             MOVE      ##SETL        P@TOCY                                        CEU01
                                                                                  CLE031
CCYIN        IFEQ      'Y'
CCYIN        OREQ      'Y'
                                                                                  CLE031
             EXSR      D@EURO                                                      CEU01
                                                                                  CLE031
             ELSE
                                                                                  CLE031
                                                                                  CLE031
 up input fields for conversion subroutine.                                       CLE031
                                                                                  CLE031
LE031        IFEQ      'Y'
                                                                                  CLE031
             Z-ADD     PEXR          ZEXCH            13 8
             MOVE      PEXI          ZMD               1
             Z-ADD     P@FRAM        ZAMTCI           15 0
             MOVE      P@FRCY        ZCCYI             3
             MOVE      P@TOCY        ZCCYO             3
             Z-ADD     FNBDP         ZCDPI             1 0
             Z-ADD     TNBDP         ZCDPO             1 0
                                                                                  CLE031
             EXSR      ZCONV
                                                                                  CLE031
             Z-ADD     ZAMTCO        ##OUTA
             Z-ADD     TNBDP         A6NBDP
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
             ENDIF
                                                                                  CLE031
             MOVEL     ##OUTA        ##DATA                                        CEU01
             MOVEL     A6NBDP        ##DCPA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
                                                              CEU014
ermine the Equivalent Currency                                CEU014
                                                              CEU014
             MOVE      *BLANKS       EQCY              3                           CEU01
             MOVE      NCCY          ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
6INCY        IFEQ      'Y'                                                         CEU01
             MOVE      BKEURO        EQCY                                          CEU01
             ENDIF                                                                 CEU01
CCY          IFEQ      BKEURO                                                      CEU01
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
             MOVEL     ##CNUM        W0KEY                          ************   CEU01
             Z-ADD     10            W0ERNB                         * DBERR 10 *   CEU01
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
lover Currency amount in Equivalent Currency                  CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'ROLL_EQC'    #@RDE                                         CEU01
             MOVE      'Y '          #@RDE                                         CEU01
#RDE         CAT       #@RDE:1       ##RDE                                         CEU01
             MOVEL     'Amount'      ##RDEC                                        CEU01
             MOVEL     'L'           ##RDET                                        CEU01
             MOVEL     R#DEFN        ##R(R1)                                       CEU01
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     EQCY          ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
             Z-ADD     NCPA          P@FRAM                                        CEU01
             MOVE      NCCY          P@FRCY                                        CEU01
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
                                                              CEU014
EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     A6CYNM        ##DATA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
                                                              145995
erest Settlement Currency                                     145995
                                                              145995
             ADD       1             R1                                            14599
             CLEAR                   R#DATA                                        14599
             CLEAR                   R#DEFN                                        14599
             CLEAR                   #@RDE                                         14599
             MOVEL     'INTST_CC'    #@RDE                                         14599
             MOVE      'Y '          #@RDE                                         14599
#RDE         CAT       #@RDE:1       ##RDE                                         14599
             MOVEL     WECCY         R#DATA                                        14599
             MOVEL     R#DEFN        ##R(R1)                                       14599
             MOVEL     R#DATA        ##D(R1)                                       14599
                                                              145995
erest Settlement Currency Description                         145995
                                                              145995
             MOVEL     WECCY         ##CCY                                         14599
             EXSR      SRDCDT                                                      14599
             ADD       1             R1                                            14599
             CLEAR                   R#DATA                                        14599
             CLEAR                   R#DEFN                                        14599
             CLEAR                   #@RDE                                         14599
             MOVEL     'INT_CCYD'    #@RDE                                         14599
             MOVE      'ES'          #@RDE                                         14599
#RDE         CAT       #@RDE:1       ##RDE                                         14599
             MOVEL     A6CYNM        R#DATA                                        14599
             MOVEL     R#DATA        ##D(R1)                                       14599
             MOVEL     R#DEFN        ##R(R1)                                       14599
WNCPYSRC,CG6026C001

             EXSR      SRADTA
             Z-ADD     0             R1
                                                                                  CLE143
LE143        IFEQ      'Y'
                                                                                  CLE143
ginal Contract Date                                                               CLE143
                                                                                  CLE143
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'ORIGCDAT'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##OCDT        ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
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
             ENDIF
                                                                                  CLE143
cumulate RDEs and associated data and output to PF/CGUDTPD.                       CLE143
                                                                                  CLE143
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
WNCPYSRC,CG6025CCP2


***********************************************************
routine  :  LOANA                                         *
ction    :  Process: Loan Associated Details              *
                                                          *
led by   :  L10RM  - Process Lending Rollover Confirmation*
            Multi-Currency                                *
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

             CLEAR                   P4PARM
             MOVE      LNRF          P3LNRF
             MOVE      *BLANKS       P3CNAM
             CALL      'CG6001'
             PARM      *BLANKS       W0RTN             7
             PARM                    W0CMT             3
             PARM                    P1PARM                         UDC Details
             PARM                    P2PARM          140            Path Details
             PARM                    P3PARM                         Loan Details
             PARM                    P4PARM                         Facility Details
             PARM                    ##AUTO            1
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
routine  :  SRSDET                                        *
ction    :  Set-up settlement details.                    *
                                                          *
led by   :  L10RM - Process Lending Rollover Confirmation *
            Multi-Currency                                *
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
             MOVEL     ##SPI1        P0SPI1
             MOVEL     ##SPI2        P0SPI2
             MOVEL     ##SPI3        P0SPI3
EU014        IFEQ      'Y'                                                         CEU01
             SELECT                                                                CEU01
TYP          WHENLE    65                                                          CEU01
             MOVE      RPSC          P0STCY                                        CEU01
TYP          WHENEQ    66                                                          CEU01
TYP          OREQ      67                                                          CEU01
             MOVE      RRSC          P0STCY                                        CEU01
             ENDSL                                                                 CEU01
             ENDIF                                                                 CEU01
                                                                                  CLE031
LE031        IFEQ      'Y'
             MOVE      RPSC          P0PSCY
             MOVE      RRSC          P0STCY
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
             Z-ADD     03            W0ERNB                         * DB ERROR 03 *
             MOVEL     'MEM5003'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

et Sequence number

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
WNCPYSRC,CG6026C003

***********************************************************
outine  :  SRINZ                                          *
tion    :  Initialise Fields on Program Invocation        *
                                                          *
ed by   :  Mainline                                       *
s       :  None                                           *
***********************************************************
RINZ         BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRINZ '      @STK(Q)

itialise work fields

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
outine  :  SRINIT                                         *
tion    :  Initial processing - First Call Only           *
                                                          *
ed by   :  Mainline                                       *
s       :  SRERR  - Report Error and Close Down Program   *
           SRDCDT - Determine Currency Details            *
***********************************************************
RINIT        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRINIT'      @STK(Q)
                                                              145995
OAMT         KLIST                                                                 14599
             KFLD                    BRCAK             3                           14599
****           KFLD           CNUMK   60                                   145995 CSD027
             KFLD                    CNUMK             6
****           KFLD           LNRFK   60                                   145995 CLE148
             KFLD                    LNRFK             6
             KFLD                    VDATK             5 0                         14599

l access program for Bank details

             CALL      'AOBANKR0'
             PARM      *BLANKS       ##RTCD            7
             PARM      '*FIRST  '    ##OPTN            7
DBANK        PARM      SDBANK        DSSDY

#RTCD        IFNE      *BLANK

abase error

             MOVEL     'AOBANKR0'    W0FILE
             MOVEL     '*CALL'       W0KEY                          ***************
             Z-ADD     04            W0ERNB                         * DB ERROR 04 *
             MOVEL     'MEM5003'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

JDFIN        COMP      'M'                                    98    MMDDYY, 98 ON

etermine Number of decimal places - Base currency

             MOVEL     BJCYCD        ##CCY
             EXSR      SRDCDT
             Z-ADD     A6NBDP        BASCDP            1 0

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
             Z-ADD     9             W0ERNB                         * DB ERROR  9 *CEU01
             MOVEL     'MEM5003'     W0MSGD                         ***************CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             ENDIF                                                                 CEU01
                                                              CEU014
ck if CEU014 is switched on                                   CEU014
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
             Z-ADD     12            W0ERNB                         * DBERR 12 *   CEU01
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
             Z-ADD     14            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
             ENDIF
                                                                                  CLE031
ess SAR details file to determine if CLE031 is installed.                         CLE031
                                                                                  CLE031
             MOVEL     'N'           CLE031            1
                                                                                  CLE031
             CALL      'AOSARDR0'
             PARM      '       '     PRTCD
             PARM      '*VERIFY'     POPTN
             PARM      'CLE031'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE031
abase Error                                                                       CLE031
                                                                                  CLE031
RTCD         IFNE      *BLANK
RTCD         ANDNE     '*NRF   '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     15            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CLE031
RTCD         IFEQ      *BLANK
             MOVEL     'Y'           CLE031
             ENDIF
                                                                                  CLE143
ck if CLE143 is ON                                                                CLE143
                                                                                  CLE143
             CALL      'AOSARDR0'
             PARM      *BLANKS       PRTCD
             PARM      '*VERIFY '    POPTN
             PARM      'CLE143'      PSARD
CSARD        PARM      SCSARD        DSFDY
                                                                                  CLE143
abase Error                                                                       CLE143
                                                                                  CLE143
RTCD         IFNE      *BLANK
RTCD         ANDNE     '*NRF   '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     16            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CLE143
RTCD         IFEQ      *BLANKS
             MOVE      'Y'           CLE143            1
             ELSE
             MOVE      'N'           CLE143
             ENDIF
                                                                                  CLE143
WNCPYSRC,CG6026C004
                                                              CEU014
XINIT        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR

***********************************************************
outine  :  SRADTA                                         *
tion    :  Accumulate RDEs and associated data for output *
                                                          *
ed by   :  LOANRM - Process Loan Rollover Details         *
           Multi-Currency                                 *
s       :  CG3999 - Format and Pack Data                  *
           SRRFMN - Reformat RDE Data                     *
           SRERR  - Database Error                        *
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
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 05 *
             Z-ADD     05            W0ERNB                         ***************
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
outine  :  SRODTA                                         *
tion    :  Output Accumulated data to PF/CGUDTAPD         *
                                                          *
ed by   :  LOANRM - Process Loan Rollover Details         *
           Multi-Currency                                 *
s       :  CG9020 - Output Data to CGUDTAPD               *
           SRERR  - Database Error                        *
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
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 06 *
             Z-ADD     06            W0ERNB                         ***************
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
outine  :  SRBIND                                         *
tion    :  Generate Binding numbers                       *
                                                          *
ed by   :  All Repeating Group Set Subroutines            *
s       :  None                                           *
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
outine  :  SRPATH                                         *
tion    :  Generate Path String /GS1/GS2...               *
                                                          *
ed by   :  L10RM  - Process Lending Rollover Confirmation *
           Multi-Currency                                 *
           LOANRM - Process Loan Rollover Details         *
           Multi-Currency                                 *
           LOANA  - Process Loan Associated Details       *
           SRSDET - Set-up settlement details             *
s       :  None                                           *
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
outine  :  SRRFMN                                         *
tion    :  Reformat RDE data                              *
                                                          *
ed by   :  SRADTA - Accumulate RDEs and associated        *
                    data for output                       *
s       :  None                                           *
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
outine  :  SRDCDT                                         *
tion    :  Determine Currency Details                     *
                                                          *
ed by   :  LOANRM - Process Loan Rollover Details         *
           Multi-Currency                                 *
           SRINIT - Initial Processing - On First Call    *
s       :  SRERR  - Database Error                        *
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
             Z-ADD     07            W0ERNB                         * DB ERROR 07 *
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
outine  :  SRGENR                                         *
tion    :  Generate reference number                      *
           by writing to PF/CGUDCRPD                      *
                                                          *
ed by   :  SRMAIN - Main Processing                       *
s       :  CG9010 - Create reference record               *
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

             MOVEL     BRCA          DRBRCA

ginating Branch (Optional)

             MOVEL     ORBR          DRORBR

ule identifier (Mandatory)

             MOVEL     'LE'          DRMODI

as Transaction Number (Mandatory)

             MOVEL     LNRF          DRMTRN

             MOVEL     W#PTYP        DRPTYP                         * print type
             MOVEL     W#PST1        DRPSTP                         * print s/type

o Transmission indicator

             MOVEL     'N'           DRATRM

tomer Number (Mandatory)

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
s reference as printtype:subtype                                                  CCG015
                                                                                  CCG015
RPTYP        CAT(P)    ':':0         COLON            11
OLON         CAT(P)    DRPSTP:0      ##REFR
             EXSR      WRAPRF

             ELSE

#RTCD        IFNE      'CGD1270'
             MOVEL     'CG9010  '    W0FILE
             MOVEL     ##RTCD        W0KEY                          ***************
             Z-ADD     08            W0ERNB                         * DB ERROR 08 *
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
***********************************************************   CEU014
 5                                                            CEU014
***********************************************************   CEU014
outine  :  D@EURO                                         *   CEU014
tion    :  EURO Currency Conversion:                      *   CEU014
erts amount P@FRAM from P@FRCY to amount ##OUTA in P@TOCY *   CEU014
ed by   :  LOANRM                                         *   CEU014
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
             Z-ADD     11            W0ERNB                         * DB ERROR 11 *CEU01
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
 SR/ZCONV                                                                         CLE031
ZSRSRC,ZCONVZ1ILE
**************************************************************
PY
 International Limited 2001
ER
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
                                                                                  CLE031
