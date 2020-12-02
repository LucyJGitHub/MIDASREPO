
***********************************************************
BASEBND                                                   *
T('Midas CG Lending past due notices')                    *
***********************************************************
                                                          *
as - User Defined Correspondence                          *
                                                          *
055 - Lending Past Due Notices                            *
                                                          *
ction:  This program extracts data for Past Due Notices   *
OB )                                                      *
                                                          *
led By: CG6050 - Lending Past Due Notices Driver          *
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
            CSW037A            Date 02May05               *
            CSD025             Date 11Jan05               *
            CSW037             Date 15Dec04               *
            CSW036             Date 15Dec04               *
            CLE025             Date 20Oct03               *
            CSC022             Date 24Feb04               *
            CGL029             Date 01Sep03               *
s Release 4.01 -------------------------------------------*
            CCG015             Date 09Aug01               *
s Release 4 --------------- Base -------------------------*
s DBA 3.05 -----------------------------------------------*
            CSD006             Date 15May01               *
            CLE011             Date 07Nov00               *
s DBA 3.03 -----------------------------------------------*
s DBA 3.00 ---------------- Base -------------------------*
            CEU014             Date 26Jun98               *
            CCG008  *CREATE    Date 30Oct95               *
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
037A- Additional Field extended to 40 chars (recompile)   *
025 - Customer De-Activation                              *
037 - Additional Field Data on MT300/MT320                *
036 - Dual SWIFT BIC held on Client Details               *
025 - Credit Lines (Recompile)                            *
022 - Commitment Control Changes for MidasPlus            *
      (Recompile)                                         *
029 - Increase Account Code to 10 digits                  *
015 - Correspondence Manager Phase 1                      *
006 - Recompiled over changed SDCURRPD.                   *
011 - Rate Fixing Days for Lending Rollover Processing    *
      Recompile                                           *
014 - EMU User Defined Correspondence Enhancement.        *
008 - User Defined Correspondence - Lending               *
                                                          *
***********************************************************
    IF   E           K DISK    INFSR(SRFILE)
 FUNCTION OF INDICATORS
***********************************************************
                                                          *
 N C T I O N    O F    I N D I C A T O R S                *
                                                          *
  -    Past Due Bit Setting is ON                         *
  -    Failed CHAIN on LF/CLOAN                           *
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
PD   -  Process Lending Past Due Notices                  *
NPD  -  Process Loan Payment Past Due Details             *
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

P          C                   CONST('LOAN PSTDU')
Y          C                   CONST('BASIC     ')
-----------------------------------------------------------

M        E DS                  EXTNAME(PDUEDU)
ernal DS for parameter passed from CG6055

R        E DS                  EXTNAME(CGUDCRPD)
ernal DS for incomplete reference

K        E DS                  EXTNAME(SDBANKPD)
ternal DS for Bank details

R        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
ternal DS for currency details

T        E DS                  EXTNAME(SDCUSTPD)                    CEU014
or Customer Details                                           CEU014
WNCPYSRC,CG6055I001
                                                              CEU014
R        E DS                  EXTNAME(SDGELRPD)                    CEU014
or GL ICD Details                                             CEU014
                                                              CEU014
D        E DS                  EXTNAME(SCSARDPD)                    CEU014
tchable Feature details                                       CEU014
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
                                                              CEU014
KF                                                                  CEU014
ame fields of CLOANCK                                         CEU014
        NLRA                        CKNLRA                          CEU014

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
           L09PD  - Process Lending Past Due Notices      *
***********************************************************
RMAIN        BEGSR

t up subroutine stack name

             ADD       1             Q                 5 0
             MOVEL     'SRMAIN'      @STK(Q)

             EXSR      SRDETL

nerate reference number by writing to PF/CGUDCRPD
 no confirmation to be produced, then bypass

             MOVE      'N'           ##COPD
WNCPYSRC,CG6055C007
             EXSR      SRGENR
#COPD        CABEQ     'N'           EXMAIN

ract

             EXSR      L09PD

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
 5
***********************************************************
outine  :  L09PD                                          *
tion    :  Process: Lending Past Due Notices              *
                                                          *
ed by   :  SRMAIN - Main Processing                       *
s       :  SRPATH - Generate Path String                  *
           LOANPD - Process Loan Payment Past Due Details *
           LOANA  - Process Loan Associated Details       *
***********************************************************
09PD         BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'L09PD '      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'l09PD '      ##GRPS

             EXSR      SRPATH
                                                                                  CCG015
             EXSR      PSHGRS

             EXSR      LOANPD

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
outine  :  LOANPD                                         *
tion    :  Process: Loan Payment Past Due details         *
                                                          *
ed by   :  L09PD - Process Lending Past Due Notices       *
s       :  SRPATH - Generate Path String                  *
           SRDCDT - Determine Currency Details            *
           SRADTA - Accumulate RDEs and Associated Data   *
           SRODTA - Output Accumulated Data to            *
                     PF/CGUDTAPD                          *
***********************************************************
OANPD        BEGSR

t up subroutine stack name

             ADD       1             Q
             MOVEL     'LOANPD'      @STK(Q)

             ADD       1             P1
1            OCCUR     ##PATH
             MOVEL(P)  'LOANPD'      ##GRPS

             EXSR      SRPATH
                                                                                  CCG015
h Order (PF/CGUXMGPD)                                                             CCG015
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

rency Description

             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
             MOVEL     SDCURR        ##WRK             3
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CCY_DESC'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     ##WRK         R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

rency

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVEL     'CURRENCY'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     CCY           R#DATA
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

t Due Interest

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'NT'          #@RDE
             MOVEL     'PSTDUE I'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     INPD          ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6055C004
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

t Due Number

             Z-ADD     0             WPDNO             3 0

             TESTB     '0'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             TESTB     '1'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             TESTB     '2'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             TESTB     '3'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             TESTB     '4'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             TESTB     '5'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             TESTB     '6'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             TESTB     '7'           PDBI                     30
IN30         IFEQ      '1'
             ADD       1             WPDNO
             END

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'UM'          #@RDE
             MOVEL     'PSTDUE N'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
               MOVELWPDNO     R#DATA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

t Due Principal

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'RN'          #@RDE
             MOVEL     'PSTDUE P'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     PPDU          ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6055C005
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

t Due Total

PDU          ADD       INPD          TPD              13 0
             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'OT'          #@RDE
             MOVEL     'PSTDUE T'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     TPD           ##DATA
             MOVEL     'Amount'      ##RDEC
             MOVEL     'L'           ##RDET
             MOVEL     CCY           ##CCY
             EXSR      SRDCDT
WNCPYSRC,CG6055C006
             MOVEL     A6NBDP        ##DCPA
             MOVEL     R#DATA        ##D(R1)
             MOVEL     R#DEFN        ##R(R1)

ayment Type

             ADD       1             R1
             CLEAR                   R#DATA
             CLEAR                   R#DEFN
             CLEAR                   #@RDE
             MOVE      'PE'          #@RDE
             MOVEL     'REPAY TY'    #@RDE
#RDE         CAT       #@RDE:1       ##RDE
             MOVEL     REPT          R#DATA
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

EU014        IFEQ      'Y'                                                         CEU01
                                                              CEU014
ermine the Equivalent Currency                                CEU014
                                                              CEU014
             MOVE      *BLANKS       EQCY              3                           CEU01
             MOVE      CCY           ##CCY                                         CEU01
             EXSR      SRDCDT                                                      CEU01
6INCY        IFEQ      'Y'                                                         CEU01
             MOVE      BKEURO        EQCY                                          CEU01
             ENDIF                                                                 CEU01
CY           IFEQ      BKEURO                                                      CEU01
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
             Z-ADD     4             W0ERNB                         * DBERR 4  *   CEU01
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
t Due Total in Equivalent Currency                            CEU014
                                                              CEU014
             ADD       1             R1                                            CEU01
             CLEAR                   R#DATA                                        CEU01
             CLEAR                   R#DEFN                                        CEU01
             CLEAR                   #@RDE                                         CEU01
             MOVEL     'P_DUE_EQ'    #@RDE                                         CEU01
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
             Z-ADD     TPD           P@FRAM                                        CEU01
             MOVE      CCY           P@FRCY                                        CEU01
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

EU014        IFEQ      'Y'                                                         CEU01
QCY          ANDNE     *BLANKS                                                     CEU01
             MOVEL     A6CYNM        ##DATA                                        CEU01
             MOVEL     R#DATA        ##D(R1)                                       CEU01
             ENDIF                                                                 CEU01
WNCPYSRC,CG6055C003
                                                              CEU014
             EXSR      SRADTA
             EXSR      SRODTA

crement Path DS index

1            OCCUR     ##PATH
             CLEAR                   ##GRPS
             SUB       1             P1
                                                                                  CCG015
 Order (PF/CGUXMGPD)                                                              CCG015
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
led by   :  L09PD  - Process Lending Past Due Notices     *
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
WNCPYSRC,CG6055C008
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
WNCPYSRC,CG6055C001

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

ess GL ICD for Euro currency code                             CEU014
                                                              CEU014
****           CALL 'AOGELRR0'                                CEU014              CGL029
             CALL      'AOGELRR1'
             PARM      *BLANKS       ##RTCD                                        CEU01
             PARM      '*FIRST '     ##OPTN                                        CEU01
**** SDGELR    PARM SDGELR    DSFDY                           CEU014              CGL029
DGELR        PARM      SDGELR        DSSDY
                                                              CEU014
abase Error                                                   CEU014
                                                              CEU014
#RTCD        IFNE      *BLANKS                                                     CEU01
             MOVEL     'SDGELRPD'    W0FILE                                        CEU01
             MOVEL     ##OPTN        W0KEY                          ***************CEU01
             Z-ADD     2             W0ERNB                         * DB ERROR 2  *CEU01
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
             Z-ADD     3             W0ERNB                         * DBERR 3  *   CEU01
             MOVEL     'MEM5003'     W0MSGD                         ************   CEU01
             MOVEL     'MIDAS  '     W0MSGF                                        CEU01
             EXSR      SRERR                                                       CEU01
             ENDIF                                                                 CEU01
             ENDIF                                                                 CEU01
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
                                                              CEU014
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
ed by   :  LOANPD - Process Loan Past Due Details         *
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

ck RDEs and associated data into data string

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
ed by   :  LOANPD - Process Loan Past Due Details         *
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

tabase error

#RTCD        IFNE      *BLANK

             MOVEL     'CG9020  '    W0FILE                         ***************
             MOVEL     ##RTCD        W0KEY                          * DB ERROR 11 *
             Z-ADD     11            W0ERNB                         ***************
             MOVEL     'MEM5003'     W0MSGD
             MOVEL     'MIDAS  '     W0MSGF
             EXSR      SRERR
             ENDIF
                                                                                  CCG015
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
ed by   :  L09PD  - Process Lending Past Due Notices      *
           LOANPD - Process Loan Payment Past Due Details *
           LOANA  - Process Loan Associated Details       *
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
ed by   :  LOANPD - Process Loan Payment Past Due Details *
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
WNCPYSRC,CG6055C002

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
return code is blank, generate the 'begin' and 'end'                              CCG015
 Extraction Records                                                               CCG015
                                                                                  CCG015
RPTYP        CAT(P)    ':':0         COLON            11
OLON         CAT(P)    DRPSTP:0      ##REFR
             EXSR      WRAPRF

             ELSE

#RTCD        IFNE      'CGD1270'
             MOVEL     'CG9010  '    W0FILE
             MOVEL     ##RTCD        W0KEY                          ***************
             Z-ADD     09            W0ERNB                         * DB ERROR 09 *
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
 5                                                            CEU014
***********************************************************   CEU014
outine  :  D@EURO                                         *   CEU014
tion    :  EURO Currency Conversion:                      *   CEU014
erts amount P@FRAM in P@FRCY to ##OUTA in P@TOCY.         *   CEU014
ed by   :  LOANPD                                         *   CEU014
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
             Z-ADD     5             W0ERNB                         * DB ERROR 5  *CEU01
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
 5
CGCPYSRC,SRERRPSSRL
 5
CGCPYSRC,SRERRCLE
 5
CGCPYSRC,CGNWEXILE
 5                                                                                CCG015
PY
 International Limited 2001
