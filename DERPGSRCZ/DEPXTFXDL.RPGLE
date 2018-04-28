     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract of FX deals')               *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTFXDL - Projected Extract for Foreign Exchange Deals     *
      *                                                               *
      *  Function:  This module is called by DEPXCFXDL. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW212             Date 03May12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDE003 - Data Export - MCR Limits Phase II                   *
      *  208221 - Set up sign of FX Margin                            *
      *           Enable DEWRKEDTA to get info from data area         *
      *           On take on date, do not flag any events as processed*
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  CSD006 - Recompiled over changed SDCURRPD.                   *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDEPTRANPD O    E           K DISK    INFSR(*PSSR)
     FDEPPOSNPD O    E           K DISK    INFSR(*PSSR)
     FDEPEVNTPD O    E           K DISK    INFSR(*PSSR)
     FDEPCASHPD O    E           K DISK    INFSR(*PSSR)
     FFXNETML3  IF   E           K DISK    INFSR(*PSSR)                                       208221
 
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
     D TABCDE          S              2    DIM(8) CTDATA PERRCD(1)
     D TABTYP          S             16    DIM(8) ALT(TABCDE)
                                                                                              208221
      * Power array                                                                           208221
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWERS OF 10  208221
 
 
     D FXDEAL        E DS                  EXTNAME(FXDEALPP)
     D DEALDB        E DS                  EXTNAME(DEALSDB)
 
 
     D W#PAYD          DS
     D  W#PAYM                 1      2
     D**W#PAYA**               3     14                                                       CGL029
     D**W#PAYB**              15     17                                                       CGL029
     D**W#PSCY**              18     20                                                       CGL029
     D  W#PAYA                 3     20                                                       CGL029
     D  W#PAYB                21     23                                                       CGL029
     D  W#PSCY                24     26                                                       CGL029
     D W#RECD          DS
     D  W#RECM                 1      2
     D**W#RECA**               3     14                                                       CGL029
     D**W#RECB**              15     17                                                       CGL029
     D**W#RSCY**              18     20                                                       CGL029
     D  W#RECA                 3     20                                                       CGL029
     D  W#RECB                21     23                                                       CGL029
     D  W#RSCY                24     26                                                       CGL029
     D W#INTS          DS
     D  W#INTM                 1      2
     D  W#INTA                 3     14
     D  W#INTB                15     17
     D  W#ISCY                18     20
     D W#TABT          DS
     D  W#TDES                 1     16
 
 
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
      ** External DS for CURRENCY details
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE002
      ** External DS for Switchable Features details                                          CDE002
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
     C                   PARM                    FXDEAL
     C                   PARM                    DEALDB
     C                   PARM                    OL_ACEI           1                          CDE002
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      * INITIAL PROCESSING FOR DEAL
      *
     C                   MOVEL     Dataarea      DEEXTCTL                                     208221
     C                   EXSR      INIT
 
     C     I#ACTN        IFNE      'D'
      *
      ** MAIN PROCESSING - 'ASSET' POSITION
      *
     C                   MOVE      'A'           W#ASLI            1
     C                   EXSR      MAIN
      *
      ** MAIN PROCESSING - 'LIABILITY' POSITION
      *
     C                   MOVE      'L'           W#ASLI
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
     C                   MOVEL     FHDN38        T#TREF
      *
      * Transaction Type
     C                   MOVEL     FHTYPE        T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     FHSTYP        T#TRST
      *
      * Transaction Description
      *
     C     FHTYPE        LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#TDES        T#TDES
      *
      * Deal Date
     C                   Z-ADD     FHDDYY        ZWYYYY                         ¦
     C                   Z-ADD     FHDDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     FHDDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#DDAT            5 0            Midas day no.
      *
      * Value Date
     C                   Z-ADD     FHVDYY        ZWYYYY                         ¦
     C                   Z-ADD     FHVDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     FHVDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#VDAT            5 0            Midas day no.
      *
      * Deal Date
      *
     C                   Z-ADD     W#DDAT        T#DDAT                           Midas day no.
      *
      * Value Date and Maturity Date
      *
     C                   SELECT
      *
      * If an OPTION
     C     FHTYPE        WHENEQ    'OP'
     C                   Z-ADD     W#VDAT        T#VDAT                           Midas day no.
     C                   Z-ADD     FHDOEY        ZWYYYY                         ¦
     C                   Z-ADD     FHDOEM        ZWMTH                          ¦ maturity date
     C                   Z-ADD     FHDOED        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        T#MDAT                           Midas day no.
      *
      * If a SWAP
     C     FHTYPE        WHENEQ    'SW'
     C     OTDT          IFLT      W#VDAT
     C     OTDT          ANDNE     *ZERO
     C                   Z-ADD     OTDT          T#VDAT                           Midas day no.
     C                   ELSE
     C                   Z-ADD     W#VDAT        T#VDAT                           Midas day no.
     C                   ENDIF
     C                   Z-ADD     W#VDAT        T#MDAT                           Midas day no.
      *
      * If an OUTRIGHT
     C                   OTHER
     C                   Z-ADD     W#VDAT        T#VDAT                           Midas day no.
     C                   Z-ADD     W#VDAT        T#MDAT                           Midas day no.
     C                   ENDSL
      *
      * Booking Branch
     C                   MOVEL     FHMBCA        T#BRCA
      *
      * Book
     C                   MOVEL     FHBOKC        T#BOOK
      *
      * Counterparty
     C                   MOVEL     FHDCNO        T#CPTY
      *
      * Risk Customer
     C                   MOVEL     FHDCNO        T#RCST
      *
      * If deal is not a swap, do revaluation
      *
     C     FHTYPE        IFNE      'SW'
      *
      * Revalue the buy leg
      *
     C                   EXSR      BUYCCY
     C                   MOVE      'B'           BUYSELL
     C                   EXSR      REVALUE
     C                   Z-ADD     PLAM          BUY_PLAM         13 0
      *
      * Revalue the sell leg
      *
     C                   EXSR      SELLCCY
     C                   MOVE      'S'           BUYSELL
     C                   EXSR      REVALUE
     C                   Z-ADD     PLAM          SELL_PLAM        13 0
      *
      * Market value
      *
     C     BUY_PLAM      ADD       SELL_PLAM     T#MKVL
     C                   MOVEL     BJCYCD        T#VCCY
     C                   MOVEL     BaseCDP       T#VCDP                                       CDE002
                                                                                              CDE002
     C**********         MOVEL     BJCYCD        @CYCD                                        CDE002
     C**********         EXSR      ACSCCY                                                     CDE002
     C**********         MOVEL     A6NBDP        T#VCDP                                       CDE002
                                                                                              CDE002
      * IF REVENUE ANALYSIS IS PRESENT                                                        CDE002
                                                                                              CDE002
     C     CDE002        IFEQ      'Y'                                                        CDE002
                                                                                              CDE002
      * If no margin is present on the deal,                                                  CDE002
      * then the market value (in base currency) is the margin                                CDE002
                                                                                              CDE002
     C     FHMGAM        IFEQ      *ZERO                                                      CDE002
     C                   Z-ADD     T#MKVL        FXMargin                                     CDE002
     C                   ELSE                                                                 CDE002
                                                                                              CDE002
      * Otherwise convert the margin on the deal to base currency                             CDE002
                                                                                              CDE002
     C                   MOVEL     FHMGCY        @CYCD                                        CDE002
     C                   EXSR      ACSCCY                                                     CDE002
                                                                                              CDE002
     C                   CALLB     'ZCONVZ1'                                                  CDE002
     C                   PARM      FHMGAM        InputAmnt        15 0                        CDE002
     C                   PARM      A6SPRT        ExchRate         13 8                        CDE002
     C                   PARM      A6MDIN        MultDivInd        1                          CDE002
     C                   PARM      FHMGCY        FrCurrency        3                          CDE002
     C                   PARM      BJCYCD        ToCurrency        3                          CDE002
     C                   PARM      A6NBDP        FrDecPlace        1 0                        CDE002
     C                   PARM      BaseCDP       ToDecPlace        1 0                        CDE002
     C                   PARM      *Zero         FXMargin         15 0                        CDE002
                                                                                              208221
     C     PUAM          MULT      OSRT          WKSLAM           15 0                        208221
     C                   MOVEL     PUCY          @CYCD                                        208221
     C                   EXSR      ACSCCY                                                     208221
     C                   Z-ADD     A6NBDP        WKPCDP            1 0                        208221
                                                                                              208221
     C                   MOVEL     SLCY          @CYCD                                        208221
     C                   EXSR      ACSCCY                                                     208221
     C                   Z-ADD     A6NBDP        WKSLDP            1 0                        208221
                                                                                              208221
     C     WKPCDP        IFNE      WKSLDP                                                     208221
     C     4             ADD       WKSLDP        N                 1 0                        208221
     C                   SUB       WKPCDP        N                                            208221
     C     WKSLAM        MULT      POWER(N)      WKSLAM                                       208221
     C                   ENDIF                                                                208221
     C     WKSLAM        SUB       SLAM          WKDIFF           15 0                        208221
     C     WKDIFF        IFLT      0                                                          208221
     C                   Z-SUB     FXMargin      FXMargin                                     208221
     C                   ENDIF                                                                208221
                                                                                              208221
     C                   ENDIF                                                                CDE002
     C                   ENDIF                                                                CDE002
     C                   ENDIF
      *
      * Action code
     C                   MOVEL     I#ACTN        T#ACTN
      *                                                                                       CDE005
      * Reservation ID                                                                        CDE005
      *                                                                                       CDE005
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   MOVEL     I#RSRV        T#RSRV           10                          CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE003
      * See if Midas Credit RISK Phase 2 is on                                                CDE003
     C     CDE003        IFEQ      'Y'                                                        CDE003
      *                                                                                       CDE003
      * See if Settlement is through CLS                                                      CDE003
     C     CDL008        IFEQ      'Y'                                                        CDE003
     C     FHCLSS        IFEQ      'Y'                                                        CDE003
      *                                                                                       CDE003
      * Net Buy Reference                                                                     CDE003
     C                   MOVEL     'CLS'         T#NBRF                                       CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDIF                                                                CDE003
      *                                                                                       CDE003
      * See if Buy Currency is netted                                                         CDE003
     C     CDL002        IFEQ      'Y'                                                        CDE003
     C     FHNBUY        IFEQ      'Y'                                                        CDE003
     C     FHNBRF        ANDNE     *BLANKS                                                    CDE003
     C     FHNBRF        CHAIN     FXNETML3                           80                      CDE003
     C     *IN80         IFNE      '1'                                                        CDE003
      *                                                                                       CDE003
      * Net Buy Reference                                                                     CDE003
     C                   MOVEL     FHNBRF        T#NBRF                                       CDE003
     C                   MOVEL     AMCNUM        T#NBSC                                       CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDIF                                                                CDE003
      *                                                                                       CDE003
      * See if Sell Currency is netted                                                        CDE003
     C     FHNSEL        IFEQ      'Y'                                                        CDE003
     C     FHNSRF        ANDNE     *BLANKS                                                    CDE003
     C     FHNSRF        CHAIN     FXNETML3                           80                      CDE003
     C     *IN80         IFNE      '1'                                                        CDE003
      *                                                                                       CDE003
      * Net Buy Reference                                                                     CDE003
     C                   MOVEL     FHNSRF        T#NSRF                                       CDE003
     C                   MOVEL     AMCNUM        T#NSSC                                       CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDIF                                                                CDE003
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
     C                   MOVEL     FHMOPM        W#PAYM                         * pay method
     C                   MOVEL     FHMOPI        W#PAYA                         * pay account
     C                   MOVEL     FHPOBR        W#PAYB                         * pay branch
     C                   MOVEL     FHPSCY        W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     FHORCM        W#RECM                         * rec method
     C                   MOVEL     FHMORI        W#RECA                         * rec account
     C                   MOVEL     FHROBR        W#RECB                         * rec branch
     C                   MOVEL     FHRSCY        W#RSCY                         * rec settle ccy
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
      ** SET UP WORK FIELDS WITH BUY OR SELL CURRENCY DETAILS
      *
     C     W#ASLI        CASEQ     'A'           BUYCCY
     C     W#ASLI        CASEQ     'L'           SELLCCY
     C                   ENDCS
      *
      * IMPORT OPENING BALANCE
      *
     C                   EXSR      IMP_OPBL
      *
      * IMPORT DEAL DATE EVENT
      *
     C*****FHTYPE        IFNE      'OT'                                                       CDE002
     C                   EXSR      IMP_DD
     C**********         ENDIF                                                                CDE002
      *                                                                                       CDE002
      * IMPORT VALUE DATE EVENT                                                               CDE002
      *                                                                                       CDE002
     C     FSLI          IFEQ      2                                                          CDE002
     C                   EXSR      IMP_VD                                                     CDE002
     C                   ENDIF                                                                CDE002
      *
      **IMPORT*FEE*PAYMENT*DATE*EVENT*(MARGIN)*************************                       CDE002
      * IMPORT FOREIGN EXCHANGE MARGIN EVENT                                                  CDE002
      *
     C*****FHMGAM        IFNE      *ZERO                                                      CDE002
     C*****FHMGCY        ANDEQ     W#CCY                                                      CDE002
     C**********         EXSR      IMP_FE                                                     CDE002
     C     CDE002        IFEQ      'Y'                                                        CDE002
     C     FHTYPE        ANDNE     'SW'                                                       CDE002
     C     W#ASLI        ANDEQ     'A'                                                        CDE002
     C                   EXSR      IMP_XM                                                     CDE002
     C                   ENDIF
      *
      * IMPORT MATURITY DATE EVENT
      *
     C                   EXSR      IMP_MT
      *
      * IMPORT PERIOD END DATES
      *
     C                   EXSR      IMP_PE
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * IMPORT OPENING BALANCE
      *****************************************************************
     C     IMP_OPBL      BEGSR
      *
      * Clear Position
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
     C     FSLI          IFEQ      2                                                          CDE002
     C                   Z-ADD     OTDT          P#IACD                                       CDE002
     C                   ELSE                                                                 CDE002
     C                   Z-ADD     T#DDAT        P#IACD                         *
     C                   ENDIF                                                                CDE002
      *
      * Nominal/Principal
     C                   Z-ADD     W#AMT         P#NOML                         *
     C     I#PH          IFEQ      'P'                                                        CDE002
     C     I#EOB         ANDEQ     'N'                                                        CDE002
     C                   Z-ADD     W#AMT         P#DIFN                                       CDE002
     C                   ENDIF                                                                CDE002
      *
      * Currency
     C                   MOVEL     W#CCY         P#CCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P#NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P#NMDP
      *
      * Nominal Ccy Spot Days
     C                   Z-ADD     A6SPDY        P#SPDY
      *                                                                                       CDE002
      * Set swap profit/loss                                                                  CDE002
      * and Accrue Swap P/L = Yes                                                             CDE002
      *                                                                                       CDE002
     C     SPLC          IFEQ      W#CCY                                                      CDE002
     C     FSLI          ANDEQ     2                                                          CDE002
     C                   Z-ADD     SPLA          P#SWPL                                       CDE002
     C                   MOVE      'Y'           P#ACSW                                       CDE002
     C                   ENDIF                                                                CDE002
      **********                                                                              CDE002
      **Realized*P/L*=*swap*profit/loss********************************                       CDE002
      **and*Accrue*Realized*P/L*=*Yes**********************************                       CDE002
      **********                                                                              CDE002
     C*****SPLC*         IFEQ      W#CCY                                                      CDE002
     C*****FSLI*         ANDEQ     2                                                          CDE002
     C**********         Z-ADD     SPLA          P#RLPL                                       CDE002
     C**********         MOVE      'Y'           P#ACRL                                       CDE002
     C**********         ENDIF                                                                CDE002
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
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
     C  N99ORED          COMP      BJRDNB                               99                    CDE002
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
      *****************************************************************                       CDE002
      * IMPORT VALUE DATE EVENT                                                               CDE002
      *****************************************************************                       CDE002
     C     IMP_VD        BEGSR                                                                CDE002
      *                                                                                       CDE002
      * CLEAR EVENT                                                                           CDE002
     C                   CLEAR                   E#EVNT                                       CDE002
      *                                                                                       CDE002
      * Module, Transaction Reference, Asset/Liability                                        CDE002
      *                                                                                       CDE002
     C                   MOVEL     P#TKEY        E#TKEY                                       CDE002
      *                                                                                       CDE002
      * Processing Date                                                                       CDE002
     C                   Z-ADD     OTDT          E#PRDT                                       CDE002
      *                                                                                       CDE002
      * Event Type                                                                            CDE002
     C                   MOVEL     'VD'          E#EVTP                                       CDE002
      *                                                                                       CDE002
      * Suppress Settlement Y                                                                 CDE002
      *                                                                                       CDE002
     C                   MOVEL     'Y'           E#SSET                                       CDE002
      *                                                                                       CDE002
      * Processed?                                                                            CDE002
      *                                                                                       CDE002
     C                   TESTB     '1'           OL_ACEI                  99                  CDE002
     C   99              MOVE      'Y'           E#PRCD                                       CDE002
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
      *                                                                                       CDE002
      * Import deal date event                                                                CDE002
      *                                                                                       CDE002
     C                   MOVEL     '*IMPEVNT'    W#MODE                                       CDE002
     C                   EXSR      WRKEDTA                                                    CDE002
      *                                                                                       CDE002
     C                   ENDSR                                                                CDE002
      *****************************************************************                       CDE002
     C/SPACE 5                                                                                CDE002
      *****************************************************************                       CDE002
      * IMPORT FOREIGN EXCHANGE MARGIN EVENT                                                  CDE002
      *****************************************************************                       CDE002
     C     IMP_XM        BEGSR                                                                CDE002
      *                                                                                       CDE002
      * CLEAR EVENT                                                                           CDE002
     C                   CLEAR                   E#EVNT                                       CDE002
      *                                                                                       CDE002
      * Module, Transaction Reference, Asset/Liability                                        CDE002
      *                                                                                       CDE002
     C                   MOVEL     P#TKEY        E#TKEY                                       CDE002
      *                                                                                       CDE002
      * Processing Date                                                                       CDE002
     C                   Z-ADD     W#DDAT        E#PRDT                                       CDE002
      *                                                                                       CDE002
      * Event Type                                                                            CDE002
     C                   MOVEL     'XM'          E#EVTP                                       CDE002
      *                                                                                       CDE002
      * FX Margin                                                                             CDE002
      *                                                                                       CDE002
     C                   Z-ADD     FXMargin      E#FXMG                                       CDE002
      *                                                                                       CDE002
      * Processed?                                                                            CDE002
      *                                                                                       CDE002
     C                   TESTB     '0'           ACEI                     99                  CDE002
     C  N99ORED          COMP      BJRDNB                               99                    CDE002
     C   99              MOVE      'Y'           E#PRCD                                       CDE002
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
      *                                                                                       CDE002
      * Import Fx margin event                                                                CDE002
      *                                                                                       CDE002
     C                   MOVEL     '*IMPEVNT'    W#MODE                                       CDE002
     C                   EXSR      WRKEDTA                                                    CDE002
      *                                                                                       CDE002
     C                   ENDSR                                                                CDE002
      *****************************************************************                       CDE002
     C/SPACE 5                                                                                CDE002
      *****************************************************************                       CDE002
      **IMPORT*FEE*PAYMENT*DATE EVENT*(MARGIN)*************************                       CDE002
      *****************************************************************                       CDE002
     C*****IMP_FE        BEGSR                                                                CDE002
      **********                                                                              CDE002
      **CLEAR*EVENT****************************************************                       CDE002
     C**********         CLEAR                   E#EVNT                                       CDE002
      **********                                                                              CDE002
      **Module,*Transaction*Reference,*Asset/Liability****************                        CDE002
      **********                                                                              CDE002
     C**********         MOVEL     P#TKEY        E#TKEY                                       CDE002
      **********                                                                              CDE002
      **Processing*Date************************************************                       CDE002
     C**********         Z-ADD     W#DDAT        E#PRDT                                       CDE002
      **********                                                                              CDE002
      **Event Type*****************************************************                       CDE002
     C**********         MOVEL     'FE'          E#EVTP                                       CDE002
      **********                                                                              CDE002
      **Commissions*=*margin*******************************************                       CDE002
      **********                                                                              CDE002
     C**********         Z-ADD     FHMGAM        E#COMM                                       CDE002
      **********                                                                              CDE002
      **Currency*decimal*places****************************************                       CDE002
      **********                                                                              CDE002
     C**********         MOVEL     A6NBDP        E#NCDP                                       CDE002
      **********                                                                              CDE002
      ***Incoming/outgoing*********************************************                       CDE002
      **********                                                                              CDE002
     C**********         MOVEL     'I'           E#IO                                         CDE002
      **********                                                                              CDE002
      **Suppress*Settlement*Y******************************************                       CDE002
      **********                                                                              CDE002
     C**********         MOVEL     'Y'           E#SSET                                       CDE002
      **********                                                                              CDE002
      **Processed?*****************************************************                       CDE002
      **********                                                                              CDE002
     C**********         TESTB     '0'           ACEI                     99    *             CDE002
     C***99*****         MOVE      'Y'           E#PRCD                                       CDE002
      **********                                                                              CDE002
      **Import*fee*payment*date*event**********************************                       CDE002
      **********                                                                              CDE002
     C**********         MOVEL     '*IMPEVNT'    W#MODE                                       CDE002
     C**********         EXSR      WRKEDTA                                                    CDE002
      **********                                                                              CDE002
     C**********         ENDSR                                                                CDE002
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
     C                   Z-ADD     T#MDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E#EVTP
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
     C                   END
      *
      ** Import maturity date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE BUY CURRENCY DETAILS TO WORK FIELDS
      ********************************************************************
     C     BUYCCY        BEGSR
      *
     C                   MOVE      FHCCY1        W#CCY             3
     C                   Z-ADD     FHDBUY        W#AMT            13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-ADD     FHDAM1        W#AMT
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE SELL CURRENCY DETAILS TO WORK FIELDS
      ********************************************************************
     C     SELLCCY       BEGSR
      *
     C                   MOVE      FHCCY2        W#CCY             3
     C                   Z-ADD     FHDSEL        W#AMT            13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-SUB     FHDAM2        W#AMT
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      *********************************************************************
      * REVALUE FX DEAL
      *********************************************************************
     C     REVALUE       BEGSR
      *
      * Revalue currency amounts
      *
     C                   CALLB     'DEFWDREVN'
      * Inputs
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
 
     C                   PARM                    BUYSELL           1
     C                   PARM      W#CCY         ECCY              3
     C                   PARM      T#MDAT        EDAT              5 0
     C                   PARM      W#AMT         EAMT             13 0
     C                   PARM      FHBCAE        DBCE             13 0
      *
     C                   PARM                    I#RDNB            5 0
     C                   PARM                    BJCYCD            3
     C                   PARM      BaseCDP       BCCDP             1 0
      * Currency details
     C                   PARM                    SDCURR
      * Outputs
     C                   PARM      *ZERO         REVA             13 0
     C                   PARM      *ZERO         RATE             13 8
     C                   PARM      *ZERO         PLAM             13 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEFWDREVN'
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
      **  Access Base Currency Decimal Places
      *
     C                   MOVEL     BJCYCD        @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        BaseCDP           1 0
      *
      **  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      **  Confirm whether CCRM Revenue Analysis available                                     CDE002
      *                                                                                       CDE002
     C                   CALLB     'AOSARDR0'                                                 CDE002
     C                   PARM      *BLANKS       @RTCD                                        CDE002
     C                   PARM      '*VERIFY'     @OPTN                                        CDE002
     C                   PARM      'CDE002'      @SARD             6                          CDE002
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE002
                                                                                              CDE002
     C     @RTCD         IFEQ      *BLANK                                                     CDE002
     C                   MOVEL     'Y'           CDE002            1                          CDE002
     C                   ELSE                                                                 CDE002
     C                   MOVEL     'N'           CDE002                                       CDE002
     C                   END                                                                  CDE002
      *                                                                                       CDE003
      **  Confirm whether MCR Midas Credit Risk Phase is available                            CDE003
      *                                                                                       CDE003
     C                   CALLB     'AOSARDR0'                                                 CDE003
     C                   PARM      *BLANKS       @RTCD                                        CDE003
     C                   PARM      '*VERIFY'     @OPTN                                        CDE003
     C                   PARM      'CDE003'      @SARD                                        CDE003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE003
                                                                                              CDE003
     C     @RTCD         IFEQ      *BLANK                                                     CDE003
     C                   MOVEL     'Y'           CDE003            1                          CDE003
     C                   ELSE                                                                 CDE003
     C                   MOVEL     'N'           CDE003                                       CDE003
     C                   END                                                                  CDE003
      *                                                                                       CDE003
      **  Confirm whether FX Netting is available                                             CDE003
      *                                                                                       CDE003
     C                   CALLB     'AOSARDR0'                                                 CDE003
     C                   PARM      *BLANKS       @RTCD                                        CDE003
     C                   PARM      '*VERIFY'     @OPTN                                        CDE003
     C                   PARM      'CDL002'      @SARD                                        CDE003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE003
                                                                                              CDE003
     C     @RTCD         IFEQ      *BLANK                                                     CDE003
     C                   MOVEL     'Y'           CDL002            1                          CDE003
     C                   ELSE                                                                 CDE003
     C                   MOVEL     'N'           CDL002                                       CDE003
     C                   END                                                                  CDE003
      *                                                                                       CDE003
      **  Confirm whether CLS is available                                                    CDE003
      *                                                                                       CDE003
     C                   CALLB     'AOSARDR0'                                                 CDE003
     C                   PARM      *BLANKS       @RTCD                                        CDE003
     C                   PARM      '*VERIFY'     @OPTN                                        CDE003
     C                   PARM      'CDL008'      @SARD                                        CDE003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE003
                                                                                              CDE003
     C     @RTCD         IFEQ      *BLANK                                                     CDE003
     C                   MOVEL     'Y'           CDL008            1                          CDE003
     C                   ELSE                                                                 CDE003
     C                   MOVEL     'N'           CDL008                                       CDE003
     C                   END                                                                  CDE003
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'PFXDL'                                           208221
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
                                                                                              CDE002
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
** TABSEQ/TABTYP. DEAL TYPES
FPFX FOR.CCY PURCH
FSFX FOR.CCY SOLD
CXFX CROSS CCY
PIFX PURCH INT
SIFX SOLD INT
SWFX SWAP
OPFX OPTION
OTFX OPTION TKDOWN
**   POWER - ARRAY OF POWERS OF 10 FOR CURRENCY CONVERSIONS                                   208221
0000001
0000010
0000100
0001000
0010000
0100000
1000000
