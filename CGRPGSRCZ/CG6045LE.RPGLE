
***********************************************************
BASEBND                                                   *
T('Midas CG Lending rate change advices')                 *
***********************************************************
                                                          *
as - User Defined Correspondence                          *
                                                          *
045LE - Lending Rate Change Advices (ILE)                 *
                                                          *
ction:  This program extracts data for Rate Change        *
        Advices.                                          *
                                                          *
led By: CG6040 - Lending Rate Change Advices - Driver.    *
                                                          *
 Finastra International Limited 2001                      *
                                                          *
t Amend No. CLE172             Date 23Oct20               *
v Amend No. CER050             Date 16Jun19               *
            MD046248           Date 27Oct17               *
            CLE134             Date 01Aug12               *
            CLE148             Date 23Jul12               *
            AR872415           Date 11Feb12               *
            CRE073             Date 06Dec10               *
 Fusion Midas 1.4 Base -----------------------------------*
s Plus 1.4 Base 04 ---------------------------------------*
s Plus 1.4 Base ------------------------------------------*
s Plus 1.3 ----------- Base ------------------------------*
            CSD031             Date 10Apr06               *
            CSD027             Date 09Dec05               *
            CLE042             Date 06Sep05               *
            CLE036             Date 22Sep03               *
            CSC022             Date 24Feb04               *
s Release 4.01 -------------------------------------------*
            CCG015             Date 09Aug01               *
s Release 4 --------------- Base -------------------------*
s DBA 3.05 -----------------------------------------------*
            CSD006             Date 15May01               *
            CLE011             Date 07Nov00               *
s DBA 3.03 -----------------------------------------------*
s DBA 3.00 ---------------- Base -------------------------*
            CCG008  *CREATE    Date 30Oct95               *
                                                          *
----------------------------------------------------------*
                                                          *
172 - Libor Deregulation - Lending                        *
050 - Annualised Percentage Rate                          *
46248 - Finastra Rebranding                               *
134 - Past Due Call Loan Processing (Recompile)           *
148 - Alpha Loan Reference                                *
72415 - Rate Change advice did not capture the new        *
        value of Rounding Method and Rounding             *
073 - Portuguese Feature - Interest Rate Rounding         *
031 - Enhanced Centralised Static Data (Recompile)        *
027 - Conversion Of Customer Number to Alpha              *
042 - Extended Loan Sub Type (Recompile)                  *
036 - LE Enh for Nordea Phase 1 Pty 2- Specific Base Rate *
022 - Commitment Control Changes for MidasPlus            *
      (Recompile)                                         *
015 - Correspondence Manager Phase 1                      *
006 - Use DSSDY for the call to AOBSRTR0.                 *
011 - Rate Fixing Days for Lending Rollover Processing    *
      Recompile                                           *
008 - User Defined Correspondence - Lending               *
                                                          *
***********************************************************
    IF   E           K DISK
                               INFSR(SRFILE)
                               IGNORE(CLOANHHF)
                               IGNORE(CLOANCKF)
                               IGNORE(CLOANZ1F)
                                                                                  CER050
I0  IF   E           K DISK
                                                                                  CER050
WNCPYSRC,CG6045F001
 FUNCTION OF INDICATORS
***********************************************************
                                                          *
 N  C T I O N    O F    I N D I C A T O R S               *
                                                          *
  -    No record found in CLOAN file.                     *
  -    General error indicator.                           *
  -    MMDDYY date format.                                *
  -    LOKUP indicator.                                   *
                                                          *
***********************************************************
 SUBROUTINE INDEX
***********************************************************
                                                          *
 B R O U T I N E    I N D E X                             *
                                                          *
n routine                                                 *
AIN  -  Main Processing                                   *
NIT  -  Initial Processing                                *
NZF  -  Initialise Fields on Each Invocation              *
ETL  -  Obtain Detail Information                         *
RC   -  Process Lending Rate Change Advices               *
NRC  -  Process Loan Rate Change Details                  *
NA   -  Process Loan Associated Details                   *
INT  -  Calculate Current Interest Rate                   *
INT  -  Calculate Next Interest Rate                      *
BRA  -  Determine Next Base Rate Code                     *
DTA  -  Accumulate RDEs and Associated Data               *
DTA  -  Output Accumulated Data to PF/CGUDTAPD            *
IND  -  Generate Binding Numbers                          *
ATH  -  Generate Path String                              *
FMN  -  Reformat RDE Data                                 *
CDT  -  Determine Currency Details                        *
ENR  -  Generate Reference Number                         *
SR   -  Error Subroutine                                  *
                                                          *
***********************************************************

***********************************************************

ay containing Copyright statement
           S             80    DIM(1) CTDATA PERRCD(1)

CGCPYSRC,CGPACKDLE
CGCPYSRC,SRERRDLE

ray of Currencies accessed by program

           S              3    DIM(100)

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

r error reporting

med constants

M          DS           256
cility Customer Number
****                              1   60P4CNUM                                    CSD027
UM                 1      6
cility Type
CT                 7      9  0
cility Number
NO                10     11  0

P          C                   CONST('LOAN RATCH')
Y          C                   CONST('BASIC     ')

M        E DS                  EXTNAME(RATESRT)
ernal DS for parameter passed from CG6040

R        E DS                  EXTNAME(CGUDCRPD)
ernal DS for incomplete reference

K        E DS                  EXTNAME(SDBANKPD)
ternal DS for Bank details
WNCPYSRC,CG6045I001

R        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
ternal DS for currency details

T        E DS                  EXTNAME(SDBSRTPD)
ternal DS for base rate codes
WNCPYSRC,CG6045I002

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
ame fields of CLOANCL
        CNUM                        ##CNUM
        BRCA                        ##BRCA
        VDAT                        ##VDAT
        CCY                         ##CCY1
        BRTE                        ##BRTE
        RTSP                        ##RTSP
        SPIN                        ##SPIN
        NACD                        ##NACD
        NRTS                        ##NRTS
        NSIN                        ##NSIN
        NBRA                        ##NBRA
        BTIN                        ##BTIN
        CNSP                        ##CNSP
        CNSG                        ##CNSG
        RDMT                        ##RDMT
        RDFD                        ##RDFD
        NNSP                        ##NNSP                                            AR
        NNSG                        ##NNSG                                            AR
        NDMT                        ##NDMT                                            AR
        NDFD                        ##NDFD                                            AR
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
             PARM                    ##COPD            1
             PARM                    DSPARM

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
ls       :  SRDETL - Obtain Detail Information            *
            SRGENR - Generate reference number by writing *
                     to PF/CGUDCRPD                       *
            L08RC  - Process Lending Rate Change Advices  *
***********************************************************
RMAIN        BEGSR

t up subroutine stack name

             ADD       1             Q                 5 0
             MOVEL     'SRMAIN'      @STK(Q)

             EXSR      SRDETL

nerate reference number by writing to PF/CGUDCRPD
 no confirmation to be produced, then bypass

             MOVE      'N'           ##COPD
WNCPYSRC,CG6045C003
             EXSR      SRGENR
#COPD        CABEQ     'N'           EXMAIN

ract

             EXSR      L08RC

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
LOANK        CHAIN     CLOAN                              88

IN88         IFEQ      '1'
             MOVEL     'CLOAN   '    W0FILE                         ***************
             MOVEL     LNRF          W0KEY                          * DB ERROR 14 *
             Z-ADD     14            W0ERNB                         ***************
             MOVEL     'MEM5004'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

XDETL        TAG

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

             MOVEL     BRCA          DRBRCA

ginating Branch (Optional)

             MOVEL     ORBR          DRORBR

ule identifier (Mandatory)

             MOVEL     'LE'          DRMODI

as Transaction Number (Mandatory)

             MOVEL     LNRF          DRMTRN

             MOVEL     W#PTYP        DRPTYP                         * print type
             MOVEL     W#PSTY        DRPSTP                         * print s/type

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
             Z-ADD     13            W0ERNB                         * DB ERROR 13 *
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
routine  :  L08RC                                         *
ction    :  Process: Lending Rate Change Advices          *
                                                          *
led by   :  SRMAIN - Main Processing                      *
ls       :  SRPATH - Generate Path String                 *
            LOANRC - Process Loan Rate Change Details     *
            LOANA  - Process Loan Associated Details      *
***********************************************************
08RC         BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'L08RC '      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'l08RC '      ##GRPS

             EXSR      SRPATH
                                                                                  CCG015
             EXSR      PSHGRS

             EXSR      LOANRC

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
routine  :  LOANRC                                        *
ction    :  Process: Loan Rate Change details             *
                                                          *
led by   :  L08RC  - Process Lending Rate Change Advices  *
ls       :  SRPATH - Generate Path String                 *
            SRDCDT - Determine Currency Details           *
            SRADTA - Accumulate RDEs and Associated Data  *
            SRODTA - Output Accumulated Data to           *
                      PF/CGUDTAPD                         *
***********************************************************
OANRC        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'LOANRC'      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'LOANRC'      ##GRPS

             EXSR      SRPATH
                                                                                  CCG015
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

n Reference

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'LOAN REF'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     LNRF          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ue Date

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'TE'          #@RDE
             MOVEL     'VALUE DA'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     VDAT          ##DATA
             MOVEL     'Date  '      ##RDEC
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

culate current and next interest rate

             EXSR      SRCINT
             EXSR      SRNINT

erest Rate

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'INT RATE'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##CINT        ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

t Interest Rate

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'AT'          #@RDE
             MOVEL     'NXT INTR'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##NINT        ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ermine Next Base Rate Code

             EXSR      SRNBRA

t Base Rate Type

#BCOD        IFNE      0

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'YP'          #@RDE
             MOVEL     'NXT BSRT'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##BCOD        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

t Base Rate Name

ess Base Rate Name

             MOVE      ##BCOD        ##KEY2            2                           BHF84
             CALL      'AOBSRTR0'                                                  S0119
             PARM      '*MSG   '     ##RTCD                                        S0119
             PARM      '*KEY   '     ##OPTN                                        S0119
             PARM      CCY           ##KEY1            3                           S0119
             PARM                    ##KEY2                                        BHF84
**** SDBSRT    PARM SDBSRT    DSFDY                     S01194CSD006
DBSRT        PARM      SDBSRT        DSSDY                                         CSD00

#RTCD        IFNE      *BLANKS
             MOVEL     'AOBSRTR0'    W0FILE
             MOVEL     '*CALL'       W0KEY                          ***************
             Z-ADD     15            W0ERNB                         * DB ERROR 15 *
             MOVEL     'MEM5003'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             END

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'AM'          #@RDE
             MOVEL     'NXT BSRN'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     BABSRN        R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CLE036
t Base Rate                                                                       CLE036
                                                                                  CLE036
             ELSE
                                                                                  CLE036
LE036        IFEQ      'Y'
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'NXT BSRA'    #@RDE
             MOVE      'TE'          #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     NBRE          ##DATA
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
             ENDIF

             END

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
                                                                                  CRE073
tractual Spread                                                                   CRE073
                                                                                  CRE073
RE073        IFEQ      'Y'
                                                                                  CRE073
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CONTSPR'     #@RDE
#RDE         CAT       #@RDE:1       ##RDE
#NNSP        IFEQ      0
             MOVEL     ##CNSP        ##DATA
             ELSE
             MOVEL     ##NNSP        ##DATA
             ENDIF
             MOVEL     'Rate  '      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     '7'           ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CRE073
tractual Spread Sign                                                              CRE073
                                                                                  CRE073
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CONTSSG'     #@RDE
#RDE         CAT       #@RDE:1       ##RDE
#NNSP        IFEQ      0
             MOVEL     ##CNSG        ##DATA
             ELSE
             MOVEL     ##NNSG        ##DATA
             ENDIF
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CRE073
nding Method                                                                      CRE073
                                                                                  CRE073
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'RNDMTD'      #@RDE
#RDE         CAT       #@RDE:1       ##RDE
#NNSP        IFEQ      0
             MOVEL     ##RDMT        ##DATA
             ELSE
             MOVEL     ##NDMT        ##DATA
             ENDIF
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CRE073
nding Fraction/Decimal                                                            CRE073
                                                                                  CRE073
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'RNDFRCD'     #@RDE
#RDE         CAT       #@RDE:1       ##RDE
#NNSP        IFEQ      0
             MOVEL     ##RDFD        ##DATA
             ELSE
             MOVEL     ##NDFD        ##DATA
             ENDIF
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CRE073
073 Switchable Feature                                                            CRE073
                                                                                  CRE073
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CRE073F'     #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     CRE073        ##DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)
                                                                                  CRE073
             ENDIF
                                                                                  CRE073

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

WNCPYSRC,CG6045C001
                                                                                  CER050
ER050        IFEQ      'Y'
             EXSR      Z@NAPR
             ENDIF
                                                                                  CER050

e new fields

****           Z-ADDLNRF      ##SLNR                                              CLE148
             MOVEL     LNRF          ##SLNR
             Z-ADD     NBRE          ##SBRE
             Z-ADD     NRTS          ##SRTS
             MOVE      NSIN          ##SSIN
             Z-ADD     ##NINT        ##SINT

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

***********************************************************
routine  :  SRCINT                                        *
ction    :  Calculate Current Interest Rate               *
                                                          *
led by   :  LOANRC - Process Loan Rate Change Details     *
ls       :  none                                          *
***********************************************************
RCINT        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRCINT'      @STK(Q)

not first record for loan, use saved interest rate

NRF          IFEQ      ##SLNR
             Z-ADD     ##SINT        ##CINT

             ELSE

e, if first record for loan, compute current interest rate

             SELECT

PIN          WHENEQ    'S'
RTE          SUB       RTSP          ##CINT           11 7

PIN          WHENEQ    'P'
TSP          DIV       100           ##WORK           11 9
#WORK        MULT(H)   BRTE          ##CINT

             OTHER
RTE          ADD       RTSP          ##CINT

             ENDSL

             END

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRNINT                                        *
ction    :  Calculate Next Interest Rate                  *
                                                          *
led by   :  LOANRC - Process Loan Rate Change Details     *
ls       :  none                                          *
***********************************************************
RNINT        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRNINT'      @STK(Q)

not first record for loan:

NRF          IFEQ      ##SLNR

 BC or BR, use saved spread rate and indicator
MTP          IFEQ      'BC'
MTP          OREQ      'BR'
             Z-ADD     ##SRTS        NRTS
             MOVE      ##SSIN        NSIN
             END

 SC, use saved based rate and spread indicator
MTP          IFEQ      'SC'
             Z-ADD     ##SBRE        NBRE
             MOVE      ##SSIN        NSIN
             END

             ELSE

first record for loan:

 BC or BR, use new base rate, current spread rate and indicator
MTP          IFEQ      'BC'
MTP          OREQ      'BR'
             Z-ADD     RTSP          NRTS
             MOVE      SPIN          NSIN
             END

 SC, use new spread rate, current base rate and spread indicator
MTP          IFEQ      'SC'
             Z-ADD     BRTE          NBRE
             MOVE      SPIN          NSIN
             END

             END

culate Next Interest Rate

             SELECT

SIN          WHENEQ    'S'
BRE          SUB       NRTS          ##NINT           11 7

SIN          WHENEQ    'P'
RTS          DIV       100           ##WORK
#WORK        MULT(H)   NBRE          ##NINT

             OTHER
BRE          ADD       NRTS          ##NINT

             ENDSL

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  SRNBRA                                        *
ction    :  Determine Next Base Rate Type                 *
                                                          *
led by   :  LOANRC - Process Loan Rate Change Details     *
ls       :  none                                          *
***********************************************************
RNBRA        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'SRNBRA'      @STK(Q)

first record for loan:

NRF          IFNE      ##SLNR
             Z-ADD     NBRA          ##BCOD            2 0
             END

Base Rate Code change or Rollover, save new code

MTP          IFEQ      'BC'
MTP          OREQ      'RO'
             Z-ADD     NBRA          ##BCOD
             END

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************

***********************************************************
routine  :  LOANA                                         *
ction    :  Process: Loan Associated Details              *
                                                          *
led by   :  L08RC  - Process Lending Rate Changes Advice  *
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
             PARM                    P4PARM                         Facility Dtls
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
                                                                                  CER050
***********************************************************                       CER050
outine  :  Z@NAPR                                         *                       CER050
tion    :  Extract - Annualised Percentage Rate (APR)     *                       CER050
                                                          *                       CER050
ed by   :                                                 *                       CER050
s       :                                                 *                       CER050
***********************************************************                       CER050
@NAPR        BEGSR
                                                                                  CER050
ly if processing type is 61, 62 or 63                                             CER050
TYP          IFEQ      61
TYP          OREQ      62
TYP          OREQ      63
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
             MOVEL     'ZI_NAPR '    #@RDE            10
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
***********************************************************                       CER050
WNCPYSRC,CG6045C004
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
WNCPYSRC,CG6045C002

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
                                                                                  CCG015
ess SAR details file to determine if CCG015 is installed.                         CCG015
                                                                                  CCG015
             MOVEL     'N'           CCG015            1
                                                                                  CCG015
             CALL      'AOSARDR0'
             PARM      '       '     ##RTCD
             PARM      '*VERIFY'     ##OPTN
             PARM      'CCG015'      ##SARD            6
                                                                                  CCG015
abase Error                                                                       CCG015
                                                                                  CCG015
#RTCD        IFNE      *BLANK
#RTCD        ANDNE     '*NRF   '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     '*CALL'       W0KEY
             Z-ADD     16            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CCG015
#RTCD        IFEQ      *BLANK
             MOVEL     'Y'           CCG015
             ENDIF
                                                                                  CLE036
ess SAR details file to determine if CLE036 is installed                          CLE036
                                                                                  CLE036
             CALL      'AOSARDR0'
             PARM      *BLANKS       ##RTCD
             PARM      '*VERIFY'     ##OPTN
             PARM      'CLE036'      ##SARD
                                                                                  CLE036
abase Error                                                                       CLE036
                                                                                  CLE036
#RTCD        IFNE      *BLANK
#RTCD        ANDNE     '*NRF   '
             MOVEL     'SCSARDPD'    W0FILE
             MOVEL     'CLE036'      W0KEY
             Z-ADD     17            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CLE036
#RTCD        IFEQ      *BLANK
             MOVE      'Y'           CLE036            1
             ELSE
             MOVE      'N'           CLE036
             ENDIF
                                                                                  CRE073
ck if CRE073 is ON                                                                CRE073
                                                                                  CRE073
             CALL      'AOSARDR0'
             PARM      *BLANKS       ##RTCD
             PARM      '*VERIFY '    ##OPTN
             PARM      'CRE073'      ##SARD
                                                                                  CRE073
#RTCD        IFEQ      *BLANKS
             MOVE      'Y'           CRE073            1
             ELSE
             MOVE      'N'           CRE073
             ENDIF
                                                                                  CRE073
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

tialise save fields

****           Z-ADD0         ##SLNR  60                                          CLE148
             MOVEL     *BLANKS       ##SLNR            6
             Z-ADD     0             ##SBRE           11 7
             Z-ADD     0             ##SRTS           11 7
             MOVE      *BLANKS       ##SSIN            2
             Z-ADD     0             ##SINT           11 7
             Z-ADD     0             ##BCOD            2 0

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
led by   :  LOANRC - Process Loan Rate Change Details     *
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
                                                                                  CCG015
CG015        IFEQ      'Y'
             MOVE      '*NEWARR '    W0ACT
             MOVEL     S#PATH        W0SPAT
             ELSE
             MOVE      '*PACK   '    W0ACT
             MOVEL     *BLANKS       W0SPAT
             ENDIF
                                                                                  CCG015
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
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 10 *
             Z-ADD     10            W0ERNB                         ***************
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CCG015
te a XML record for RDE                                                           CCG015
                                                                                  CCG015
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
led by   :  LOANRC - Process Loan Rate Change Details     *
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
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 11 *
             Z-ADD     11            W0ERNB                         ***************
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
led by   :  L02PI  - Process Lending Rate Change Advices  *
            LOANRC - Process Loan Rate Change Detail      *
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
led by   :  LOANRC - Process Loan Rate Change Detail      *
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
             Z-ADD     12            W0ERNB                         * DB ERROR 12 *
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

CGCPYSRC,SRERRPSSRL

CGCPYSRC,SRERRCLE
                                                                                  CCG015
CGCPYSRC,CGNWEXILE

      OBJECT COPYRIGHT
 International Limited 2001
