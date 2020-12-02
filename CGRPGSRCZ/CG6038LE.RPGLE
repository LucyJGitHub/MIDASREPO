
***********************************************************
BASEBND                                                   *
T('Midas CG Lending advices - amendments')                *
***********************************************************
                                                          *
as - User Defined Correspondence                          *
                                                          *
038LE - Midas Lending Advices - Amendments (ILE)          *
                                                          *
ction:  This program extracts data for amendment advices. *
OB )    This will be called  by CG6030 if the type of e-  *
        vent read from LF/SCUTX was amendment. This will  *
        extract UDC data for group set L07AM.             *
                                                          *
led By: CG6030 -  Midas Lending Advices - Driver          *
                                                          *
 Finastra International Limited 2001                      *
                                                          *
t Amend No. CLE172             Date 23Oct20               *
v Amend No. MD046248           Date 27Oct17               *
            CLE134             Date 01Aug12               *
            CLE148             Date 23Jul12               *
 Fusion Midas 1.4 Base -----------------------------------*
s Plus 1.4 Base 04 ---------------------------------------*
s Plus 1.4 Base ------------------------------------------*
s Plus 1.3 ----------- Base ------------------------------*
            CSD031             Date 10Apr06               *
            CSD027             Date 09Dec05               *
            CLE042             Date 06Sep05               *
            BUG9646            Date 20Dec05               *
            CSC022             Date 24Feb04               *
            CLE028             Date 27Jun02               *
s Release 4.01 -------------------------------------------*
            CCG015             Date 09Aug01               *
s Release 4 --------------- Base -------------------------*
s DBA 3.05 -----------------------------------------------*
            CSD006             Date 15May01               *
            CLE011             Date 07Nov00               *
s DBA 3.03 -----------------------------------------------*
s DBA 3.00 ---------------- Base -------------------------*
            122226             Date 26Aug97               *
            CCG008 *CREATE     Date 30Oct95               *
                                                          *
----------------------------------------------------------*
                                                          *
172 - Libor Deregulation - Lending                        *
46248 - Finastra Rebranding                               *
134 - Past Due Call Loan Processing (Recompile)           *
148 - Alpha Loan Reference (Recompile)                    *
031 - Enhanced Centralised Static Data (Recompile)        *
027 - Conversion Of Customer Number to Alpha              *
042 - Extended Loan Sub Type (Recompile)                  *
9646- Changes in CGPACKE causes programs not to compile   *
022 - Commitment Control Changes for MidasPlus            *
      (Recompile)                                         *
028 - Flat Rate Personal Loans (Rule of 78s)              *
      (Recompile)                                         *
015 - Correspondence Manager Phase 1                      *
006 - Recompiled over changed SDCURRPD.                   *
011 - Rate Fixing Days for Lending Rollover Processing    *
      Recompile                                           *
226 - Recompile due to changes to CUTX1HP + change length *
      of DSPARM.                                          *
008 - User Defined Correspondence - Lending               *
                                                          *
***********************************************************
    IF   E           K DISK    INFSR(SRFILE)
                               IGNORE(CLOANHHF)
                               IGNORE(CLOANZ1F)
 FUNCTION OF INDICATORS
***********************************************************
                                                          *
 N C T I O N    O F    I N D I C A T O R S                *
                                                          *
  -    Record not foung on LF/CLOAN                       *
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
AM   -  Process Lending Amendment Advices                 *
NAM  -  Process Loan Amendment Details                    *
NA   -  Process Loan Associated Details                   *
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

ray of Currencies accessed by program
           S              3    DIM(100)

pyright array.

M        E DS                  EXTNAME(CUTX1HP)
ternal DS for parameter passed from CG6030

ok-up string for RDE definition Array

           DS
****                              15120 ##S                                      BUG9646

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

P          C                   CONST('LOAN AMEND')
Y          C                   CONST('BASIC     ')
-----------------------------------------------------------
R        E DS                  EXTNAME(CGUDCRPD)
ernal DS for incomplete reference

K        E DS                  EXTNAME(SDBANKPD)
ternal DS for Bank details

R        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
ternal DS for currency details
WNCPYSRC,CG6038I001

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
        REPT                        ##REPT
 5
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
             PARM                    W0RTN
             PARM                    W0CMT             3
             PARM                    ##COPD            1
*****          PARM           DSPARM100                       122226
             PARM                    DSPARM                                        12222

t up subroutine stack name

             ADD       1             Q
             MOVEL     'MAIN'        @STK(Q)

itial processing - Once Only

#INIT        IFEQ      *BLANK
             EXSR      SRINIT
             MOVE      'Y'           ##INIT            1
             ENDIF

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
 5
***********************************************************
outine  :  SRMAIN                                         *
tion    :  Main processing                                *
                                                          *
ed by   :  Mainline                                       *
s       :  SRDETL - Obtain Detail Information             *
           SRGENR - Generate reference number by writing  *
                    to PF/CGUDCRPD                        *
           L07AM  - Process Lending Amendment Advices     *
***********************************************************
RMAIN        BEGSR

t up subroutine stack name

             ADD       1             Q                 5 0
             MOVEL     'SRMAIN'      @STK(Q)

             EXSR      SRDETL

nerate reference number by writing to PF/CGUDCRPD
 no confirmation to be produced, then bypass

             MOVE      'N'           ##COPD
WNCPYSRC,CG6038C004
             EXSR      SRGENR
#COPD        CABEQ     'N'           EXMAIN

ract

             EXSR      L07AM

XMAIN        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************
 5
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
             MOVEL     LNRF          W0KEY                          * DB ERROR 03 *
             Z-ADD     03            W0ERNB                         ***************
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
 5
***********************************************************
outine  :  L07AM                                          *
tion    :  Process: Lending Amendment Advices             *
                                                          *
ed by   :  SRMAIN - Main Processing                       *
s       :  SRPATH - Generate Path String                  *
           LOANAM - Process Loan Amendment Details        *
           LOANA  - Process Loan Associated Details       *
***********************************************************
07AM         BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'L07AM '      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'l07AM '      ##GRPS

             EXSR      SRPATH
                                                                                  CCG015
             EXSR      PSHGRS

             EXSR      LOANAM

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
 5
***********************************************************
outine  :  LOANAM                                         *
tion    :  Process: Loan Amendment details                *
                                                          *
ed by   :  L07AM - Process Lending Amendment Advices      *
s       :  SRPATH - Generate Path String                  *
           SRADTA - Accumulate RDEs and Associated Data   *
           SRODTA - Output Accumulated Data to            *
                     PF/CGUDTAPD                          *
***********************************************************
OANAM        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'LOANAM'      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'LOANAM'      ##GRPS

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

ndment Type

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'PE'          #@RDE
             MOVEL     'AMEND TY'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     AMTP          R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

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

WNCPYSRC,CG6038C003

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
routine  :  LOANA                                         *
ction    :  Process: Loan Associated Details              *
                                                          *
led by   :  L07AM  - Process Lending Amendment Advices    *
ls       :  CG6001 - General Loan Details                 *
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
WNCPYSRC,CG6038C005
***********************************************************
 5
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
 5
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
WNCPYSRC,CG6038C001

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
             Z-ADD     07            W0ERNB
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CCG015
#RTCD        IFEQ      *BLANK
             MOVEL     'Y'           CCG015
             ENDIF

XINIT        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************
 5
***********************************************************
outine  :  SRADTA                                         *
tion    :  Accumulate RDEs and associated data for output *
                                                          *
ed by   :  LOANAM - Process Loan Amendment Details        *
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
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 04 *
             Z-ADD     04            W0ERNB                         ***************
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
 5
***********************************************************
outine  :  SRODTA                                         *
tion    :  Output Accumulated data to PF/CGUDTAPD         *
                                                          *
ed by   :  LOANRO - Process Loan Amendment Details        *
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
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 05 *
             Z-ADD     05            W0ERNB                         ***************
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
 5
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
 5
***********************************************************
outine  :  SRPATH                                         *
tion    :  Generate Path String /GS1/GS2...               *
                                                          *
ed by   :  L07AM  - Process Lending Amendment Advices     *
           LOANAM - Process Loan Amendment Details        *
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
 5
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
 5
***********************************************************
outine  :  SRDCDT                                         *
tion    :  Determine Currency Details                     *
                                                          *
ed by   :  SRINIT - Initial Processing - On First Call    *
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
             Z-ADD     02            W0ERNB                         * DB ERROR 02 *
             MOVEL     'MEM5004'     W0MSGD                         ***************
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF

 the currency has been retrieved earlier, position the
rrency Data data structure on the relevant occurrence.

             ELSE
             OCCUR     SDCURR
             ENDIF
WNCPYSRC,CG6038C002

XDCDT        TAG

wind subroutine stack name

             MOVEA     *BLANKS       @STK(Q)
             SUB       1             Q

             ENDSR
***********************************************************
 5
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

iginating Branch (Optional)

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
             Z-ADD     06            W0ERNB                         * DB ERROR 06 *
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
 5
CGCPYSRC,SRERRPSSRL
 5
CGCPYSRC,SRERRCLE
 5                                                                                CCG015
CGCPYSRC,CGNWEXILE
 5
PY
 International Limited 2001
