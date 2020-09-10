     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Historic extract of customer loan')           *
/*OVR *: OVRDBF FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)               : *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEHXTLOAN - Historic Extract for Customer Lending Loans      *
      *                                                               *
      *  Function:  This module is called once for loan transaction   *
      *             by the historic extract controller.               *
      *             It writes details to the historic extract files   *
      *             in the appropriate format.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 07Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 220981             Date 03Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CAP074             Date 28Mar02               *
      *                 CDE005             Date 22Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDE003             Date 03Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212594             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  220981 - Cost of funds is set to zero.                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CDE005 - Data Export - Reservation ID (Recompile)            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Do not default funding rates for risk loans         *
      *           Enable DEWRKEDTA to get info from data area         *
      *  212594 - Turnover not correct for customer loans             *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************

     FHISTS     IF   E           K DISK
     F                                     INCLUDE(HISTSHPF: HISTSHQF)
     F                                     PREFIX(H_)
     FCLOANX    IF   E           K DISK    INCLUDE(CLOANCLF)
     F                                     PREFIX(SL_)
     FDEHTRANPD O    E           K DISK
     FDEHPOSNPD O    E           K DISK
     FDEHEVNTPD O    E           K DISK
     FDEHCASHPD O    E           K DISK

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
      **  Loan types
     D TABSEQ          S              2  0 DIM(12) CTDATA PERRCD(1)
     D TABTYP          S             18    DIM(12) ALT(TABSEQ)


      * Power array
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWERS OF 10


     D LOANCL        E DS                  EXTNAME(CLOANCL) PREFIX(CL_)

     D LOANCK        E DS                  EXTNAME(CLOANCK) PREFIX(CK_)

     D HISTHM        E DS                  EXTNAME(HISTSHM) PREFIX(HM_)

     D HISTHN        E DS                  EXTNAME(HISTSHN) PREFIX(HN_)


     D W#TABT          DS
     D  W#TYP                  1      1
     D  W#ASLI                 2      2
     D  W#TDES                 3     18


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
      ** External DS for BASE RATE HISTORY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** Extract Control Data

     D*WKLOANREF       S              6  0 INZ(*ZEROS)                                        CLE148
     D WKLOANREF       S              6    INZ(*BLANKS)                                       CLE148
     D WKLOANREFA      S              6    INZ(*BLANKS)
     D WKLOANREFB      S              6    INZ(*BLANKS)
      ** Declared Variables - Work Loan Reference

     D WKTREF          S             13    INZ(*BLANKS)
      ** Declared Variable - Work Transaction Reference
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
     C                   PARM                    LOANCL
     C                   PARM                    LOANCK
     C                   PARM                    HISTHM
     C                   PARM                    HISTHN
     C                   PARM                    Dataarea                                     208221
      *
      ** INITIAL PROCESSING FOR LOAN
      *
     C                   EXSR      INIT
      *
      ** MAIN PROCESSING
      *
     C     I#ACTN        IFNE      'D'
     C                   EXSR      MAIN
     C                   ENDIF
      *
      * COMMITMENT PROCESSING FOR LOAN
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR LOAN
      *****************************************************************
     C     INIT          BEGSR
      *
      * Clear Transaction Details
      *
     C                   CLEAR                   T#TRAN
      *
      * Module
     C                   MOVEL     'LE'          T#MOD
      *
      * Transaction Reference (Loan reference, except for parts sold where
      * it should be made up of original loan reference and part sold
      * loan reference. N.B. for parts sold against IPP's, the original loan
      * reference is the Mirror Loan Number).
      *
     C                   MOVEL     CL_LNRF       T#TREF

     C                   IF        CL_PTYP = 66 or
     C                             CL_PTYP = 67 or
     C                             CL_PTYP = 69 or
     C                             CL_PTYP = 72

      * For parts sold, CL_OLNO holds the Sale of Loan Number.
      * For parts purchased, CL_OLNO holds the Original Borrower.
      * Set CL_OLNO to always hold the Original Borrower for use later.
      *
     C**********         EVAL      WKLOANREF = CL_OLNO                                        CSD027
     C                   MOVEL     CL_OLNO       WKLOANREF                                    CSD027
     C     WKLOANREF     CHAIN     CLOANCLF                           99

     C                   IF        *IN99 = '0'

     C**********         IF        SL_MLNR <> 0                                               CLE148
     C                   IF        SL_MLNR <> *BLANKS                                         CLE148
     C                   EVAL      WKLOANREF = SL_MLNR
     C                   EVAL      CL_OLNO = SL_OLNO
     C                   ELSE
     C                   EVAL      CL_OLNO = SL_CNUM
     C                   ENDIF

     C                   MOVE      WKLOANREF     WKLOANREFA
     C                   MOVE      CL_LNRF       WKLOANREFB
     C                   EVAL      WKTREF = WKLOANREFA + '/' + WKLOANREFB
     C                   MOVEL     WKTREF        T#TREF

     C                   ENDIF

     C                   ENDIF

      * Transaction Type
     C                   MOVEL     CL_LTYP       T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     CL_SUTP       T#TRST
      *
      * Transaction Description
      *
     C     CL_PTYP       LOOKUP    TABSEQ        TABTYP                   99   *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#TDES        T#TDES
      *
      * Deal Date
     C                   Z-ADD     CL_DDAT       T#DDAT                           Midas day no.
      *
      * Value Date
     C                   Z-ADD     CL_VDAT       T#VDAT                           Midas day no.
      *
      * Maturity Date
     C                   Z-ADD     CL_MDAT       T#MDAT                           Midas day no.
      *
      * Booking Branch
     C                   MOVEL     CL_BRCA       T#BRCA
      *
      * Counterparty (normally transaction customer unless part sold
      * with recourse, then use original borrower)
      *
     C                   MOVEL     CL_CNUM       T#CPTY

     C                   IF        CL_PTYP = 66 or
     C                             CL_PTYP = 67 or
     C                             CL_PTYP = 69 or
     C                             CL_PTYP = 72

     C                   IF        CL_RCSI = 'Y' and
     C**********                   CL_OLNO <> 0                                               CSD027
     C                             CL_OLNO <> *BLANKS                                         CSD027
     C                   EVAL      T#CPTY = CL_OLNO
     C                   ENDIF

     C                   ENDIF

      * Risk Customer (normally transaction customer unless part purchased
      * or part sold without recourse, then use original borrower)
      *
     C                   MOVEL     CL_CNUM       T#RCST
      *
     C                   IF        CL_PTYP = 64 or
     C                             CL_PTYP = 65 or
     C                             CL_PTYP = 68 or
     C                             CL_PTYP = 71

     C**********         IF        CL_OLNO <> 0                                               CSD027
     C                   IF        CL_OLNO <> *BLANKS                                         CSD027
     C                   EVAL      T#RCST = CL_OLNO
     C                   ENDIF

     C                   ENDIF

     C                   IF        CL_PTYP = 66 or
     C                             CL_PTYP = 67 or
     C                             CL_PTYP = 69 or
     C                             CL_PTYP = 72

     C                   IF        CL_RCSI <> 'Y' and
     C**********                   CL_OLNO <> 0                                               CSD027
     C                             CL_OLNO <> *BLANKS                                         CSD027
     C                   EVAL      T#RCST = CL_OLNO
     C                   ENDIF

     C                   ENDIF

      * Local industry
     C                   MOVEL     CL_LIND       T#LICD
      *
      * Country
     C                   MOVEL     CL_CRSK       T#CNCD
      *
      * Recourse ind
     C                   MOVEL     CL_RCSI       T#RCSI
      *
      * Action code
     C                   MOVEL     I#ACTN        T#ACTN
      *
      * Import transaction details
      *
     C     I#ACTN        IFNE      'D'
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
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
      *                                                                         212594
      * IMPORT VALUE DATE EVENT                                                 212594
      *                                                                         212594
     C                   EXSR      IMP_VD                                       212594
      *
      * IMPORT INTEREST PAYMENT EVENT (IF DISCOUNTED LOAN)
      *
     C     W#TYP         IFEQ      'D'
     C                   EXSR      IMP_IP
     C                   ENDIF
      *
      * IMPORT HISTORY AMOUNT EVENTS (FROM HISTSHP)
      *
     C                   EXSR      IMP_HP
      *
      * IMPORT HISTORY RATE EVENTS   (FROM HISTSHQ)
      *
     C                   EXSR      IMP_HQ
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
     C                   MOVEL     W#ASLI        P#ASLI
      *
      * Interest Accrl Ctl Date
     C                   Z-ADD     HM_VDAT       P#IACD
      *
      * Accrued Int To Date
     C                   Z-ADD     *ZERO         P#AITC
      *
      * Nominal/Principal
     C                   Z-ADD     HM_PRAM       P#NOML
     C                   Z-ADD     HM_PRAM       P#DIFN
      *
      * Currency
     C                   MOVEL     HM_CCY        P#CCY
     C                   MOVEL     HM_CCY        @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P#NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P#NMDP
      *
      * Base Rate Code
     C                   MOVEL     HM_BRTT       P#BRTT
      *
      * Base Rate
     C                   Z-ADD     HM_BRTE       P#BRTE
      *
      * Rate/Spread
     C                   Z-ADD     HM_RTSP       P#RTSP
      *
      * Spread Ind
     C                   MOVEL     HM_SPIN       P#SPIN
      *
      * (Effective) Interest Rate
      *
     C                   SELECT
      *
     C     HM_SPIN       WHENEQ    ' '
     C     HM_SPIN       OREQ      'A'
     C     HM_BRTE       ADD       HM_RTSP       P#IRAT
      *
     C     HM_SPIN       WHENEQ    'S'
     C     HM_BRTE       SUB       HM_RTSP       P#IRAT
      *
     C     HM_SPIN       WHENEQ    'P'
     C     HM_RTSP       DIV       100           W#W119           11 9
     C     W#W119        MULT(H)   HM_BRTE       P#IRAT
      *
     C                   ENDSL
      *
      * Change Ind
     C                   MOVEL     CL_CHIN       P#CHIN
      *
      * Funding Rate/Spread
     C                   Z-ADD     HM_FSRP       P#FSRP
      *
      * Funding Sign
     C                   MOVE      HM_FSGN       P#FSGN
      *
      ** if rate and sign not set, refer to Historic Base Rates file
      ** only when margin has not been set                                                    208221
     C                   IF        P#FSRP = 0 and
     C                             CL_MARG = 0 and                                            208221
     C                             CL_PTYP < 70 and                                           208221
     C                             P#FSGN = *BLANK

     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN           7
     C                   PARM      '*KEY   '     @OPTION           7
     C                   PARM      P#CCY         @POSITIONCUR      3
     C                   PARM      DERDFR        @DEFFUNRT         2 0
     C                   PARM      P#IACD        @HISTDATE         5 0
     C     SDBSHS        PARM      SDBSHS        DSFDY

     C                   IF        @RETURN = *BLANKS
     C                   EVAL      P#FSRP = G0CBSR
     C                   ENDIF

     C                   ENDIF

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
      * Int Pay Method
     C     W#TYP         IFEQ      'D'
     C                   MOVEL     'D'           P#INPM
     C                   ENDIF
      *
      * Int Capitalization
     C                   MOVEL     HM_INTC       P#INTC
      *
      * Int Calc Method
     C                   CALLB     'DECVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      HM_CALC       W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        P#ICMT
      *
      * Accrue interest
     C                   MOVE      'Y'           P#ACIN
      *
      * Accrue cost of funds
     C                   MOVE      'Y'           P#ACCF
      *
      * Accuracy
     C                   Z-ADD     9             P#ACUR
      *
      * Round Down
     C                   MOVEL     CL_RDFC       P#RDFC
      *
      * Repayment Type
     C                   Z-ADD     HM_REPT       P#REPT
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5                                                                  212594
      *****************************************************************         212594
      * IMPORT VALUE DATE EVENT                                                 212594
      *****************************************************************         212594
     C     IMP_VD        BEGSR                                                  212594
      *                                                                         212594
      * CLEAR EVENT                                                             212594
     C                   CLEAR                   E#EVNT                         212594
      *                                                                         212594
      * Module, Transaction Reference, Asset/Liability                          212594
      *                                                                         212594
     C                   MOVEL     P#TKEY        E#TKEY                         212594
      *                                                                         212594
      * Processing Date                                                         212594
     C                   Z-ADD     CL_VDAT       E#PRDT                         212594
      *                                                                         212594
      * Event Type                                                              212594
     C                   MOVEL     'VD'          E#EVTP                         212594
      *                                                                         212594
      * Import value date event                                                 212594
      *                                                                         212594
     C                   MOVEL     '*IMPEVNT'    W#MODE                         212594
     C                   EXSR      WRKEDTA                                      212594
      *                                                                         212594
     C                   ENDSR                                                  212594
      *****************************************************************         212594
     C/SPACE 5
      *****************************************************************
      * IMPORT INTEREST PAYMENT DATE EVENT
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
      * (If discounted loan, start date of loan is an interest pay date)
      *
     C                   Z-ADD     HM_VDAT       E#PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E#EVTP
      *
      * Interest Amount
     C                   Z-ADD     HM_TOTI       E#INTA
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C     EIMP_IP       ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT HISTORY AMOUNT EVENTS
      *****************************************************************
     C     IMP_HP        BEGSR
      *
     C     HISTKY        SETLL     HISTSHPF
     C     HISTKP        READE     HISTSHPF                               99    *
     C     *IN99         DOWEQ     '0'
     C     H_VDAT        ANDGT     CL_MDAT
     C     CL_MDAT       ANDNE     *ZERO
     C     HISTKP        READE     HISTSHPF                               99    *
     C                   ENDDO
      *
      * Whilst history amount records can be found
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
     C                   Z-ADD     H_VDAT        E#PRDT
      *
      * Processing Seq
     C                   MOVEL     H_PRSQ        E#PRSQ
      *
      * Manual adjustment to accrued interest
      *
     C     H_AMTP        IFEQ      'MI'
     C                   MOVEL     'MI'          E#EVTP
     C                   Z-ADD     H_INTA        E#INTA
     C                   END
      *
      * Principal increase
      *
     C     H_AMTP        IFEQ      'PI'
     C     H_AMTP        OREQ      'PT'
     C                   MOVEL     'PI'          E#EVTP
     C                   Z-ADD     H_PRAM        E#PRAM
     C                   END
      *
      * Principal decrease
      *
     C     H_AMTP        IFEQ      'PF'
     C                   MOVEL     'PD'          E#EVTP
     C                   Z-ADD     H_PRAM        E#PRAM
     C                   END
      *
      * Interest payment
      *
     C     H_AMTP        IFEQ      'IN'
     C     H_INTA        IFNE      0                                            212594
     C     H_PRAM        ORNE      0                                            212594
     C                   MOVEL     'IP'          E#EVTP
     C                   Z-ADD     H_INTA        E#INTA
     C     H_PRAM        IFNE      *ZERO
     C                   MOVEL     'Y'           E#INTC
     C                   END
     C                   END                                                    212594
     C                   END
      *
      * Repayment schedule
      *
     C     H_AMTP        IFEQ      'RE'
      * convert
     C     H_CCY         IFNE      CL_CCY
     C                   EXSR      CONVLM
     C                   END
     C                   MOVEL     'RE'          E#EVTP
     C                   Z-ADD     H_PRAM        E#PRAM
     C                   Z-ADD     H_INTA        E#INTA
     C     H_PRAM        ADD       H_INTA        E#TAMT
     C                   END
      *
      * Manual repayment
      *
     C     H_AMTP        IFEQ      'MR'
      * convert
     C     H_CCY         IFNE      CL_CCY
     C                   EXSR      CONVLM
     C                   END
     C                   MOVEL     'MR'          E#EVTP
     C                   Z-ADD     H_PRAM        E#PRAM
     C                   Z-ADD     H_INTA        E#INTA
     C     H_PRAM        ADD       H_INTA        E#TAMT
     C                   END
      *
      * Maturity interest
      *
     C     H_AMTP        IFEQ      'MA'
     C                   MOVEL     'IP'          E#EVTP
     C                   Z-ADD     H_INTA        E#INTA
     C                   END
      *
      * Import history event
      *
     C     E#EVTP        IFNE      *BLANK
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      * Maturity principal
      *
     C     H_AMTP        IFEQ      'MA'
      *
      * Import history event
      *
     C                   MOVEL     'MT'          E#EVTP
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   END
      *
      * Read next record
      *
     C     HISTKP        READE     HISTSHPF                               99    *
     C     *IN99         DOWEQ     '0'
     C     H_VDAT        ANDGT     CL_MDAT
     C     CL_MDAT       ANDNE     *ZERO
     C     HISTKP        READE     HISTSHPF                               99    *
     C                   ENDDO
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT HISTORY RATE EVENTS
      *****************************************************************
     C     IMP_HQ        BEGSR
      *
     C     HISTKY        SETLL     HISTSHQF
     C     HISTKP        READE     HISTSHQF                               99    *
     C     *IN99         DOWEQ     '0'
     C     H_VDAT        ANDGT     CL_MDAT
     C     CL_MDAT       ANDNE     *ZERO
     C     HISTKP        READE     HISTSHQF                               99    *
     C                   ENDDO
      *
      * Whilst history rate records can be found
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
     C                   Z-ADD     H_VDAT        E#PRDT
      *
      * Processing Seq
     C                   MOVEL     H_PRSQ        E#PRSQ
      *
      * Stop or start accruals
      *
     C     H_AMTP        IFEQ      'SA'
     C                   MOVEL     'SA'          E#EVTP
     C                   MOVE      H_STAI        E#STAC
     C                   END
      *
      * A spread change
      *
     C     H_AMTP        IFEQ      'SC'
     C                   MOVEL     'SC'          E#EVTP
      * interest rate
     C                   Z-ADD     H_RTSP        E#RTSP
     C                   MOVE      H_IRCF        E#IRCH
      * funding rate
     C                   Z-ADD     H_FSRP        E#FSRP
     C                   MOVE      H_FRCF        E#CRCH

      * if rate and chg ind not set, refer to Historic Base Rates file
      ** only when margin has not been set                                                    208221
     C                   IF        E#FSRP = 0 AND
     C                             CL_MARG = 0 and                                            208221
     C                             CL_PTYP < 70 and                                           208221
     C                             E#CRCH = *BLANK

     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      '*KEY   '     @OPTION
     C                   PARM      P#CCY         @POSITIONCUR
     C                   PARM      DERDFR        @DEFFUNRT
     C                   PARM      E#PRDT        @HISTDATE
     C     SDBSHS        PARM      SDBSHS        DSFDY

     C                   IF        @RETURN = *BLANKS
     C                   EVAL      E#FSRP = G0CBSR
     C                   EVAL      E#CRCH = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   END
      *
      * A base rate code change
      *
     C     H_AMTP        IFEQ      'BC'
     C                   MOVEL     'BC'          E#EVTP
     C**********         Z-ADD     H_BRTT        E#BRTT                                       CSD103
     C                   MOVE      H_BRTT        E#BRTT                                       CSD103
     C                   Z-ADD     H_BRTE        E#BRTE
     C                   MOVEL     'C'           E#IRTP
      * funding rate                                                                          220981
     C                   Z-ADD     H_FSRP        E#FSRP                                       220981
     C                   MOVE      H_FRCF        E#CRCH                                       220981
                                                                                              220981
      * if rate and chg ind not set, refer to Historic Base Rates file                        220981
      ** only when margin has not been set                                                    220981
     C                   IF        E#FSRP = 0 AND                                             220981
     C                             CL_MARG = 0 and                                            220981
     C                             CL_PTYP < 70 and                                           220981
     C                             E#CRCH = *BLANK                                            220981
                                                                                              220981
     C                   CALL      'AOBSHSR0'                                                 220981
     C                   PARM      *BLANKS       @RETURN                                      220981
     C                   PARM      '*KEY   '     @OPTION                                      220981
     C                   PARM      P#CCY         @POSITIONCUR                                 220981
     C                   PARM      DERDFR        @DEFFUNRT                                    220981
     C                   PARM      E#PRDT        @HISTDATE                                    220981
     C     SDBSHS        PARM      SDBSHS        DSFDY                                        220981
                                                                                              220981
     C                   IF        @RETURN = *BLANKS                                          220981
     C                   EVAL      E#FSRP = G0CBSR                                            220981
     C                   EVAL      E#CRCH = 'Y'                                               220981
     C                   ENDIF                                                                220981
     C                   ENDIF                                                                220981
     C                   END
      *
      * A base rate change
      *
     C     H_AMTP        IFEQ      'BR'
     C                   MOVEL     'BC'          E#EVTP
     C**********         Z-ADD     H_BRTT        E#BRTT                                       CSD103
     C                   MOVE      H_BRTT        E#BRTT                                       CSD103
     C                   Z-ADD     H_BRTE        E#BRTE
     C                   MOVEL     'C'           E#IRTP
     C                   END
      *
      * A rollover
      *
     C     H_AMTP        IFEQ      'RO'
     C                   MOVEL     'RO'          E#EVTP
     C**********         Z-ADD     H_BRTT        E#BRTT                                       CSD103
     C                   MOVE      H_BRTT        E#BRTT                                       CSD103
     C                   Z-ADD     H_BRTE        E#BRTE
     C                   Z-ADD     H_RTSP        E#RTSP
     C                   MOVE      H_SPIN        E#SPIN
     C                   Z-ADD     H_FSRP        E#FSRP
     C                   MOVE      H_FSGN        E#FSGN
      *
     C                   IF        E#FSRP = 0 AND
     C                             CL_MARG = 0 and                                            208221
     C                             CL_PTYP < 70 and                                           208221
     C                             E#FSGN = *BLANK

     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      '*KEY   '     @OPTION
     C                   PARM      P#CCY         @POSITIONCUR
     C                   PARM      DERDFR        @DEFFUNRT
     C                   PARM      E#PRDT        @HISTDATE
     C     SDBSHS        PARM      SDBSHS        DSFDY

     C                   IF        @RETURN = *BLANKS
     C                   EVAL      E#FSRP = G0CBSR
     C                   EVAL      E#CRCH = 'Y'
     C                   ENDIF

     C                   ENDIF

     C     H_CALC        IFNE      0
     C                   MOVE      'Y'           E#IRCH
     C                   MOVE      'Y'           E#CRCH
     C                   END
     C     H_CALC        IFNE      0
     C                   CALLB     'DECVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      H_CALC        W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        E#ICMT
     C                   END
     C                   END
      *
      * A Multi-currency Rollover
      *
     C     H_AMTP        IFEQ      'MC'

     C                   MOVEL     'RO'          E#EVTP
     C**********         Z-ADD     H_BRTT        E#BRTT                                       CSD103
     C                   MOVE      H_BRTT        E#BRTT                                       CSD103
     C                   Z-ADD     H_BRTE        E#BRTE
     C                   Z-ADD     H_RTSP        E#RTSP
     C                   MOVE      H_SPIN        E#SPIN
     C                   Z-ADD     H_FSRP        E#FSRP
     C                   MOVE      H_FSGN        E#FSGN
     C                   EVAL      E#NOML = H_CPAM
     C                   EVAL      E#CCY = H_RLCY
     C                   EVAL      P#CCY = H_RLCY
     C                   EVAL      @CYCD = H_RLCY
     C                   EXSR      ACSCCY
     C                   EVAL      E#NCDP = A6NBDP
     C                   EVAL      E#NMDP = A6NBDP

     C                   IF        E#FSRP = 0 AND
     C                             CL_MARG = 0 and                                            208221
     C                             CL_PTYP < 70 and                                           208221
     C                             E#FSGN = *BLANK

     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN
     C                   PARM      '*KEY   '     @OPTION
     C                   PARM      E#CCY         @POSITIONCUR
     C                   PARM      DERDFR        @DEFFUNRT
     C                   PARM      E#PRDT        @HISTDATE
     C     SDBSHS        PARM      SDBSHS        DSFDY

     C                   IF        @RETURN = *BLANKS
     C                   EVAL      E#FSRP = G0CBSR
     C                   EVAL      E#CRCH = 'Y'
     C                   ENDIF

     C                   ENDIF

     C     H_CALC        IFNE      0
     C                   MOVE      'Y'           E#IRCH
     C                   MOVE      'Y'           E#CRCH

     C                   CALLB     'DECVTICDL'
     C                   PARM                    W#RTCD
     C                   PARM                    W#ERMS
     C                   PARM                    W#ICBS
     C                   PARM                    W#ICMT

     C                   IF        W#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECVTICDL'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      E#ICMT = W#ICMT

     C                   ENDIF

     C                   ENDIF

      * Import history event
      *
     C     E#EVTP        IFNE      *BLANK
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      * Read next record
      *
     C     HISTKP        READE     HISTSHQF                               99    *
     C     *IN99         DOWEQ     '0'
     C     H_VDAT        ANDGT     CL_MDAT
     C     CL_MDAT       ANDNE     *ZERO
     C     HISTKP        READE     HISTSHQF                               99    *
     C                   ENDDO
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CONVERT LOAN AMENDMENT (FACILITY) CURRENCY TO LOAN CURRENCY
      ********************************************************************
     C     CONVLM        BEGSR
      *
      **   ACCESS LOAN HISTORY CURRENCY DETAILS
      *
     C                   MOVEL     H_CCY         @CYCD
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        ZCDPI
      *
      **   ACCESS LOAN CURRENCY DETAILS
      *
     C                   MOVEL     CL_CCY        @CYCD
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        ZCDPO
      *
      ** CONVERSION DONE USING FACILITY CURRENCY EXCHANGE/M/D IND
      *
     C                   Z-ADD     CL_FCXR       ZEXCH
     C     CL_FMDI       IFEQ      'D'
     C                   MOVE      'M'           ZMD
     C                   ELSE
     C                   MOVE      'D'           ZMD
     C                   ENDIF
      * principal
     C                   Z-ADD     H_PRAM        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        H_PRAM
      * interest
     C                   Z-ADD     H_INTA        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        H_INTA
      *
     C                   ENDSR
      ********************************************************************
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
     C                   ENDSR
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
     C                   EVAL      W#TYPE = 'HLOAN'                                           208221
      *
     C     HISTKY        KLIST
     C                   KFLD                    CL_BRCA
     C                   KFLD                    CL_CNUM
     C                   KFLD                    CL_LNRF
     C                   KFLD                    HM_VDAT
      *
     C     HISTKP        KLIST
     C                   KFLD                    CL_BRCA
     C                   KFLD                    CL_CNUM
     C                   KFLD                    CL_LNRF
      *
      * Get extract control data

     C     *DTAARA       DEFINE                  DEEXTCTL
     C                   IN        DEEXTCTL

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      **********************************************************************
      **
      **   ZCONVN - SUBROUTINE TO CONVERT AN  AMOUNT FROM ONE CURRENCY
      **               TO ANOTHER
      **
      **   INPUT  - ZAMTCI (15,0) AMOUNT INPUT
      **            ZEXCH  (13,8) EXCHANGE RATE
      **            ZMD    (1)    MULTIPLY/DIVIDE INDICATOR
      **            ZCDPI  (1,0)  CURRENCY DECIMAL PLACES INPUT
      **            ZCDPO  (1,0)  CURRENCY DECIMAL PLACES TO BE CONVERTED TO
      **            POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED
      **                          IN THE PROGRAM SOURCE
      **
      **  OUTPUT -  ZAMTCO (15,0) AMOUNT OUTPUT
      **
      **********************************************************************
     C     ZCONVN        BEGSR                                                  ** ZCONVN **
      *
      * DEFINE INPUT AND OUTPUT FIELDS
      *
     C                   Z-ADD     ZAMTCI        ZAMTCI           15 0
     C                   Z-ADD     0             ZAMTCO           15 0
     C                   Z-ADD     ZCDPI         ZCDPI             1 0
     C                   Z-ADD     ZCDPO         ZCDPO             1 0
     C                   Z-ADD     ZEXCH         ZEXCH            13 8
     C                   MOVE      ZMD           ZMD               1
      *
      * IF EXCHANGE RATE IS 0 - OUTPUT CURRENCY AMOUNT AS ZERO
      *
     C     ZEXCH         IFEQ      0
     C                   Z-ADD     0             ZAMTCO
     C                   GOTO      EZCNVN
     C                   END
      *
      * IF DECIMAL PLACES ARE THE SAME FOR BOTH CURRENCIES
      *
     C     ZCDPI         IFEQ      ZCDPO
      *
      ***  CALCULATE OUTPUT CURRENCY AMOUNT BY DIVIDING EXCHANGE RATE INTO
      *** OR MULTIPLYING EXCHANGE RATE BY CURRENCY AMOUNT INPUT DEPENDING
      *** ON INDICATOR
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE
      *
      *** IF DECIMAL PLACES DIFFER -
      ***      CALCULATE DIFFERENCE IN DECIMAL PLACES TO USE AS POWER INDEX
      *
     C     ZCDPO         SUB       ZCDPI         ZPX               1 0
     C                   ADD       4             ZPX
      *
      *** CALCULATE CURRENCY AMOUNT OUTPUT BY MULTIPLYING INPUT AMOUNT BY
      ***  POWER ARRAY ENTRY AND THEN MULTIPLYING RESULT BY EXCHANGE RATE
      ***  DEPENDING ON INDICATOR
      *
     C     POWER(ZPX)    IFLT      1                                            from d.p *LT
     C     ZAMTCI        MULT      POWER(ZPX)    Z15#3            15 3           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     Z15#3         DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     Z15#3         MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   ELSE                                                   from d.p. *GT
     C     ZAMTCI        MULT      POWER(ZPX)    ZAMTCI                           to d.p.
      *
     C     ZMD           IFEQ      'D'
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO
     C                   ELSE
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO
     C                   END
      *
     C                   END
      *
      *
     C                   END
      *
     C     EZCNVN        ENDSR                                                  ** EZCNVN **
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
(c) Finastra International Limited 2001
** TABSEQ/TABTYP. LOAN PROCESSING TYPES
61CACALL LOAN
62TATERM LOAN
63DADISC LOAN
64TATERM PART PURCH
65DADISC PART PURCH
66TLTERM PART SOLD
67DLDISC PART SOLD
68CACALL PART PURCH
69CLCALL PART SOLD
70 ARISK LOAN
71 ARISK PART PURCH
72 LRISK PART SOLD
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
