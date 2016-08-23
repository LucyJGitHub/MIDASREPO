     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract of NAs purchased')          *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTNASP - Projected Extract for Money Market NAs Purchased *
      *                                                               *
      *  Function:  This module is called by DEPXCNASP. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 21Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185976             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *           On take on date, do not flag any events as processed*
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  185976 - Add parameter ZFRZBD to include interest payment    *
      *           base date in the calculation.                       *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
     FMMDENSL0  IF   E           K DISK    INFSR(*PSSR)
 
     FDEPTRANPD O    E           K DISK    INFSR(*PSSR)
     FDEPPOSNPD O    E           K DISK    INFSR(*PSSR)
     FDEPEVNTPD O    E           K DISK    INFSR(*PSSR)
     FDEPCASHPD O    E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      * E X T R A C T   F I L E S
     D/COPY DECPYSRC,DEXTFILS
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXTPERDD
 
      *
      **  Deal types
     D TABCDE          S              2    DIM(7) CTDATA PERRCD(1)
     D TABTYP          S             20    DIM(7) ALT(TABCDE)
 
 
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D DEALDD        E DS                  EXTNAME(DEALSDD)
     D  QQRON1       E                     EXTFLD(RONSQQ)                                     CGL029
     D  QQPON1       E                     EXTFLD(PONSQQ)                                     CGL029
 
 
     D W#PAYD          DS
     D  W#PAYM                 1      2
     D***W#PAYA*                3     14                                                      CGL029
     D***W#PAYB*               15     17                                                      CGL029
     D***W#PSCY*               18     20                                                      CGL029
     D  W#PAYA                 3     20                                                       CGL029
     D  W#PAYB                21     23                                                       CGL029
     D  W#PSCY                24     26                                                       CGL029
     D W#RECD          DS
     D  W#RECM                 1      2
     D***W#RECA*                3     14                                                      CGL029
     D***W#RECB*               15     17                                                      CGL029
     D***W#RSCY*               18     20                                                      CGL029
     D  W#RECA                 3     20                                                       CGL029
     D  W#RECB                21     23                                                       CGL029
     D  W#RSCY                24     26                                                       CGL029
     D W#TABT          DS
     D  W#TDES                 1     20
 
 
      ** DEFINE FIELDS FOR ZDATE10
     D                 DS
     D ZWDTIN                  1      8S 0
     D  ZWYYYY                 1      4S 0
     D  ZWMTH                  5      6S 0
     D  ZWDAY                  7      8S 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for GENERAL LEDGER details
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)                                  208221
      ** Extract Control Data                                                                 208221
                                                                                              208221
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#ACTN            1            * ACTION CODE
     C                   PARM                    I#EXTT            4            * EXTRACT TYPE
     C                   PARM                    I#PH              1            * PROJ/HIST
     C                   PARM                    I#EOB             1            * END OF BOOK
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#HCOD            5 0          * HIST CUT-OFF DATE
     C                   PARM                    I#EXTD            5 0          * EXTRACT DATE
     C                   PARM                    I#EVCD            5 0          * EVENT CTL DATE
     C                   PARM                    I#PCOD            5 0          * PROJECTION DATE
     C                   PARM                    PeriodEDT                      * PERIOD END DATES
     C                   PARM                    MMDENB
     C                   PARM                    DEALDD
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      ** INITIAL PROCESSING FOR DEAL
      *
     C                   MOVEL     Dataarea      DEEXTCTL                                     208221
     C                   EXSR      INIT
      *
      ** MAIN PROCESSING
      *
     C     I#ACTN        IFNE      'D'
     C                   EXSR      MAIN
     C                   ENDIF
      *
      * COMMITMENT PROCESSING FOR DEAL
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR DEAL
      *****************************************************************
     C     INIT          BEGSR
      *
      * Clear Transaction Details
      *
     C                   CLEAR                   T#TRAN
      *
      * Module
     C                   MOVEL     'DL'          T#MOD
      *
      * Transaction Reference
     C                   MOVEL     HLDN38        T#TREF
      *
      * Transaction Type
     C                   MOVEL     HLMTYP        T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     HLSTYP        T#TRST
      *
      * Transaction Description
      *
     C     HLMTYP        LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#TDES        T#TDES
      *
      * Deal Date
     C                   Z-ADD     HLDDYY        ZWYYYY                         ¦
     C                   Z-ADD     HLDDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     HLDDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#DDAT            5 0            Midas day no.
     C                   Z-ADD     ZZMDNO        T#DDAT                           Midas day no.
      *
      * Value Date
     C                   Z-ADD     HLVDYY        ZWYYYY                         ¦
     C                   Z-ADD     HLVDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     HLVDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#VDAT            5 0            Midas day no.
     C                   Z-ADD     ZZMDNO        T#VDAT                           Midas day no.
      *
      * Maturity Date
     C                   Z-ADD     HLMDYY        ZWYYYY                         ¦
     C                   Z-ADD     HLMDMM        ZWMTH                          ¦ maturity date
     C                   Z-ADD     HLMDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#MDAT            5 0            Midas day no.
     C                   Z-ADD     ZZMDNO        T#MDAT                           Midas day no.
      *
      * Booking Branch
     C                   MOVEL     HLBRCA        T#BRCA
      *
      * Book
     C                   MOVEL     HLBOKC        T#BOOK
      *
      * Counterparty
     C                   MOVEL     HLCNUM        T#CPTY
      *
      * Risk Customer = issuer
     C                   MOVEL     HLISCN        T#RCST
      *
      * Issuer Exposure
     C                   MOVEL     'Y'           T#ISEI
      *
      * Action code
     C                   MOVEL     I#ACTN        T#ACTN
      *                                                                                       CDE005
      * Reservation ID                                                                        CDE005
      *                                                                                       CDE005
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   MOVEL     I#RSRV        T#RSRV           10                          CDE005
     C                   ENDIF                                                                CDE005
      *
      * Import transaction details
      *
     C     I#ACTN        IFNE      'D'
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      **  Store pay and receive settlement methods, accounts & branches
      *
     C                   MOVEL     HLMOPM        W#PAYM                         * pay method
     C                   MOVEL     HLMOPI        W#PAYA                         * pay account
     C                   MOVEL     HLPOBR        W#PAYB                         * pay branch
     C                   MOVEL     HLSTCY        W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     HLORCM        W#RECM                         * rec method
     C                   MOVEL     HLMORI        W#RECA                         * rec account
     C                   MOVEL     HLROBR        W#RECB                         * rec branch
     C                   MOVEL     HLSTCY        W#RSCY                         * rec settle ccy
      *
      * RESET EXPORT INDICATORS
      *
     C                   MOVEL     *BLANK        POSN_Exp          1
     C                   MOVEL     *BLANK        EVNT_Exp          1
     C                   MOVEL     *BLANK        CASH_Exp          1
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING POSITION AND EVENTS
      *****************************************************************
     C     IMPORT        BEGSR
      *
      * IMPORT OPENING BALANCE
      *
     C                   EXSR      IMP_OPBL
      *
      * IMPORT DEAL DATE EVENT
      *
     C                   EXSR      IMP_DD
      *
      * IMPORT VALUE DATE EVENT
      *
     C                   EXSR      IMP_VD
      *
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST/COST OF FUNDS
      *
     C     AIAN          IFNE      *ZERO
     C     ACAN          ORNE      *ZERO
     C                   EXSR      IMP_MI
     C                   ENDIF
      *
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *
     C     HLMTYP        IFEQ      'C1'
     C     HLMTYP        OREQ      'C2'
     C     HLMTYP        OREQ      'BP'
     C     HLMTYP        OREQ      'BD'
     C                   EXSR      IMP_IP
     C                   ENDIF
      *
      * IMPORT MATURITY DATE EVENT
      *
     C                   EXSR      IMP_MT
      *
      * IMPORT DEAL AMENDMENT EVENTS
      *
     C                   EXSR      IMP_DEAM
      *
      * IMPORT NA'S SOLD
      *
     C                   EXSR      IMP_NASS
      *
      * IMPORT PERIOD END DATES
      *
     C                   EXSR      IMP_PE
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING BALANCE
      *****************************************************************
     C     IMP_OPBL      BEGSR
      *
      * CLEAR POSITION
      *
     C                   CLEAR                   P#POSN
      *
      * Module, Transaction Reference
      *
     C                   MOVEL     T#TKEY        P#TKEY
      *
      * Asset/Liability
     C                   MOVEL     'A'           P#ASLI
      *
      * Interest Accrl Ctl Date
     C                   Z-ADD     HLIAYY        ZWYYYY                         ¦ interest
     C                   Z-ADD     HLIAMM        ZWMTH                          ¦ accrual
     C                   Z-ADD     HLIADD        ZWDAY                          ¦ control date
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        P#IACD                           Midas day no.
      *
      * Accrued Int To Date
     C                   Z-ADD     AITC          P#AITC
      *
      * Int Paid To Date
     C                   Z-ADD     IPRD          P#IPRD
      *
      * Accrued Int Adjustments
     C*****AIAN*         ADD       AIAP          P#AIAD                                       CDE002
     C                   Z-ADD     AIAP          P#AIAD                                       CDE002
      *
      * Accrued COF Adjustments
     C*****ACAN*         ADD       ACAP          P#ACAD                                       CDE002
     C                   Z-ADD     ACAP          P#ACAD                                       CDE002
      *
      * Discount/Premium
     C                   Z-ADD     HLDCAM        P#DIPR
      *
      * Nominal/Principal
     C                   Z-ADD     HLFVAL        P#NOML                 99      *
     C   99              Z-SUB     HLFVAL        P#NOML
     C     I#PH          IFEQ      'P'                                                        CDE002
     C     I#EOB         ANDEQ     'N'                                                        CDE002
     C                   Z-ADD     P#NOML        P#DIFN                                       CDE002
     C                   ENDIF                                                                CDE002
      *
      * Currency
     C                   MOVEL     HLCCY         P#CCY
     C                   MOVEL     HLCCY         @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P#NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P#NMDP
      *
      * Nominal Ccy Spot Days
     C                   Z-ADD     A6SPDY        P#SPDY
      *
      * Purchased interest
     C                   Z-ADD     PINT1         P#PINT
      *
      * If interest bearing
      * Rate/Spread   = face rate
      * Interest Rate = face rate
      *
     C     HLMTYP        IFEQ      'C1'
     C     HLMTYP        OREQ      'C2'
     C     HLMTYP        OREQ      'BP'
     C     HLMTYP        OREQ      'BD'
     C                   Z-ADD     HLFRAT        P#RTSP
     C                   Z-ADD     HLFRAT        P#IRAT
     C                   ENDIF
      *
      * Funding Rate/Spread
     C                   Z-ADD     HLFSRP        P#FSRP
      *
      * Funding Sign
     C                   MOVE      HLFSGN        P#FSGN
      *
      * Cost of Funds Rate
     C                   SELECT
      *
     C     P#FSGN        WHENEQ    ' '
     C                   Z-ADD     P#FSRP        P#CRAT
      *
     C     P#FSGN        WHENEQ    '+'
     C     P#IRAT        ADD       P#FSRP        P#CRAT
      *
     C     P#FSGN        WHENEQ    '-'
     C     P#IRAT        SUB       P#FSRP        P#CRAT
      *
     C                   ENDSL
      *
      * Int Calc Method
     C                   MOVEL     HLICMT        W#ICBS            1 0
     C                   CALLB     'DECVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM                    W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        P#ICMT
      *
      * Round Down
     C                   MOVEL     HLRDFC        P#RDFC
      *
      * Accrue interest
     C                   MOVE      'Y'           P#ACIN
      *
      * Accrue cost of funds
     C                   MOVE      'Y'           P#ACCF
      *
      * Accrue discount/premium
     C                   MOVE      'Y'           P#ACDP
      *
      * Security
     C                   MOVE      'Y'           P#SECU
      *
      * Accuracy
     C                   Z-ADD     9             P#ACUR
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT DEAL DATE EVENT
      *****************************************************************
     C     IMP_DD        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     W#DDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E#EVTP
      *
      * Processed?
      *
     C                   TESTB     '0'           ACEI                     99    *
     C   99              MOVE      'Y'           E#PRCD
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
      *
      * Import deal date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT VALUE DATE EVENT
      *****************************************************************
     C     IMP_VD        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     W#VDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'VD'          E#EVTP
      *
      * Total amount (countervalue)
     C                   Z-ADD     HLAMNP        E#TAMT                 99      *
     C   99              Z-SUB     HLAMNP        E#TAMT
      *
      * Nominal
     C                   Z-ADD     HLFVAL        E#NOML                         *
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E#PRCD
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E#SSET
      *
      * Import value date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST/COST OF FUNDS
      *****************************************************************
     C     IMP_MI        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     I#EVCD        E#PRDT
      *
      * Event Type
     C                   MOVEL     'MI'          E#EVTP
      *
      * Interest
     C                   Z-ADD     AIAN          E#INTA
      *
      * Cost of funds
     C                   Z-ADD     ACAN          E#COFA
      *
      * Import manual adjustment to accrued interest event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_IP        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
      *
     C                   Z-ADD     HLNIYY        ZWYYYY                         ¦
     C                   Z-ADD     HLNIMM        ZWMTH                          ¦ next int date
     C                   Z-ADD     HLNIDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E#PRDT                           Midas day no.
      *
      ** If no date present use maturity date
      *
     C     E#PRDT        IFEQ      *ZERO
     C                   Z-ADD     W#MDAT        E#PRDT                           Midas day no.
     C                   END
      *
      * Event Type
     C                   MOVEL     'IP'          E#EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#RECD        E#SETD
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If no interest payment frequency is present
      ** or if interest payment date is at maturity date
      ** exit this routine
      *
     C     HLIPFQ        IFEQ      *BLANK
     C     E#PRDT        OREQ      W#MDAT
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E#PRDT        ZFRDAT                         *DATE
     C                   MOVEL     HLIPFQ        ZFRFRQ                         *FREQUENCY
     C                   Z-ADD     HLIPDM        ZFRBAS                         *BASE DAY
     C                   MOVEL     E#SETM        ZFRSET                         *SETT.METH
     C     E#SETC        IFNE      *BLANK
     C                   MOVEL     E#SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     HLCCY         ZFRCCY                         *CURRENCY
     C                   ENDIF
     C                   MOVEL     E#SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     W#MDAT        ZFRMDT                         *MAT DATE
      *
      * Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E#PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all interest payments prior to maturity date
      *
     C     E#PRDT        DOWLT     W#MDAT
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E#PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
      ** Import last interest payment date event (at maturity date)
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C     EIMP_IP       ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MATURITY DATE EVENT
      *****************************************************************
     C     IMP_MT        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     W#MDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E#EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
      *
      ** Import maturity date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT DEAL AMENDMENT EVENTS
      *****************************************************************
     C     IMP_DEAM      BEGSR
      *
     C     HLDN38        SETLL     MMDEAMP0
     C     *IN99         DOUEQ     '1'
     C     HNDDLT        OREQ      *BLANK
     C     HLDN38        READE     MMDEAMP0                               99    *
     C                   ENDDO
      *
      * Whilst live deal amendments can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     HNVDYY        ZWYYYY                         ¦
     C                   Z-ADD     HNVDMM        ZWMTH                          ¦ value date of
     C                   Z-ADD     HNVDDD        ZWDAY                          ¦ deal amendment
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E#PRDT
      *
      * If the deal amendment is settle interest
      *
     C     HNMTYP        IFEQ      'SI'
     C                   MOVEL     'IP'          E#EVTP
     C                   END
      *
      **  Store pay and receive settlement method, account & branch
      *
     C                   MOVEL     HNORCM        E#SETM
     C                   MOVEL     HNMORI        E#SETA
     C                   MOVEL     HNOSBR        E#SETB
     C                   MOVEL     HNSTCY        E#SETC
      *
      * Import deal amendment event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Read next live record
      *
     C     *IN99         DOUEQ     '1'
     C     HNDDLT        OREQ      *BLANK
     C     HLDN38        READE     MMDEAMP0                               99    *
     C                   ENDDO
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT NA'S SOLD
      *****************************************************************
     C     IMP_NASS      BEGSR
      *
     C                   MOVEL     HLDN38        HMDADN
     C     HMDADN        SETLL     MMDENSP0
     C     *IN99         DOUEQ     '1'
     C     HMDDLT        OREQ      *BLANK
     C     HMDSTS        ANDNE     'M'
     C     HMDADN        READE     MMDENSP0                               99    *
     C                   ENDDO
      *
      * Whilst live NAs sold can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     HMVDYY        ZWYYYY                         ¦
     C                   Z-ADD     HMVDMM        ZWMTH                          ¦ value date of
     C                   Z-ADD     HMVDDD        ZWDAY                          ¦ deal amendment
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E#PRDT
      *
      * Event Type
     C                   MOVEL     'PD'          E#EVTP
      *
      * Event reference
     C                   MOVEL     HMDN38        E#EVRF
      *
      * Nominal
     C                   Z-ADD     HMFVAL        E#PRAM                         *
      *
      * Total amount (countervalue)
     C                   Z-ADD     HMAMNP        E#TAMT                 99      *
     C   99              Z-SUB     HMAMNP        E#TAMT
      *
      **  Store receive settlement method, account & branch
     C                   MOVEL     HMORCM        E#SETM
     C                   MOVEL     HMMORI        E#SETA
     C                   MOVEL     HMROBR        E#SETB
     C                   MOVEL     HMSTCY        E#SETC
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E#SSET
      *
      * Import NA sold event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Read next live record
      *
     C     *IN99         DOUEQ     '1'
     C     HMDDLT        OREQ      *BLANK
     C     HMDSTS        ANDNE     'M'
     C     HMDADN        READE     MMDENSP0                               99    *
     C                   ENDDO
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE NEXT DAY
      ********************************************************************
     C     DETNXD        BEGSR
      *
     C                   CALL      'DLZFRQ'
     C                   PARM      *BLANK        ZFRRTC            5
     C                   PARM                    ZFRDAT            5 0          * DATE
     C                   PARM                    ZFRFRQ            1            * FREQUENCY
     C                   PARM                    ZFRBAS            2 0          * BASE DAY
     C                   PARM                    ZFRSET            2 0          * SETT.METH.
     C                   PARM                    ZFRCCY            3            * CURRENCY
     C                   PARM      *BLANK        ZSTCY             3
     C                   PARM      'P'           ZRCIP             1
     C                   PARM                    ZFRNOS            2            * NOSTRO
     C                   PARM                    ZFRMDT            5 0          * MAT.DATE
     C                   PARM                    BKAPDT            5 0
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJLCCY            3
     C                   PARM      *ZERO         ZFRZBD            5 0          * BASE DATE   185976
     C                   PARM      *ZERO         ZFRNXD            5 0          * NEXT DATE
      *
     C     ZFRRTC        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DLZFRQ'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'PNASP'                                           208221
      *
      ** Determine if Data Export - Reservation ID is active                                  CDE005
     C                   CALL      'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD             7                          CDE005
     C                   PARM      '*VERIFY'     @OPTN             7                          CDE005
     C                   PARM      'CDE005'      @SARD             6                          CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANK                                                     CDE005
     C                   MOVEL     'Y'           CDE005            1                          CDE005
     C                   ELSE                                                                 CDE005
     C                   MOVEL     'N'           CDE005                                       CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE005
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ZDATE10
      ********************************************************************
     C     ZDATE10       BEGSR
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN            8 0
     C                   PARM                    ZZMDNO            5 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * M A I N   P R O C E S S I N G
      /COPY DECPYSRC,DEXTMAINO
      *****************************************************************
      * C O M M I T M E N T   P R O C E S S I N G
      /COPY DECPYSRC,DEXTCOMMO
      *********************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY DECPYSRC,DEXTPERDI
      ********************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      *****************************************************************
      /COPY DECPYSRC,DEXTWEDTA
      *********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *********************************************************************
      /SPACE 5
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TABCDE/TABTYP. DEAL TYPES
C1PRIMARY CD
C2SECONDARY CD
BPBOND
BDBILL
DABANK ACCEPTANCE
TATRADE ACCEPTANCE
TBTREASURY BILL
