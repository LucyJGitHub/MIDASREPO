     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract of loans/deposits')         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTLDNI - Projected Extract for Money Market Loans,        *
      *              Deposits and NA's Issued                         *
      *                                                               *
      *  Function:  This module is called by DEPXCLDNI. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 216251             Date 28Mar03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      *                 198289             Date 26Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185976             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216919 - Recompiled due to change in DEPPOSNPD format.       *
      *  216251 - Set cost of funds rate and funding rate to be the   *
      *           same as the interest rate on the transaction for    *
      *           internal deal types IL and ID.                      *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *           Ensure call deals have zero accruals at take-on date*
      *           Call deals have to be made to start on takeon date  *
      *           On take on date, do not flag any events as processed*
      *  198289 - Internal deposits and loans extracted with bad A/L ind
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  185976 - Add parameter ZFRZBD to include interest payment    *
      *           base date in the calculation.                       *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************

     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)

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
     D*TABCDE**********S              2    DIM(15) CTDATA PERRCD(1)                 198289
     D*TABTYP**********S             17    DIM(15) ALT(TABCDE)                      198289
     D TABCDE          S              2    DIM(17) CTDATA PERRCD(1)                 198289
     D TABTYP          S             17    DIM(17) ALT(TABCDE)                      198289


     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D DEALDC        E DS                  EXTNAME(DEALSDC)


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
     D W#INTS          DS
     D  W#INTM                 1      2
     D***W#INTA*                3     14                                                      CGL029
     D***W#INTB*               15     17                                                      CGL029
     D***W#ISCY*               18     20                                                      CGL029
     D  W#INTA                 3     20                                                       CGL029
     D  W#INTB                21     23                                                       CGL029
     D  W#ISCY                24     26                                                       CGL029
     D W#TABT          DS
     D  W#ASLI                 1      1
     D  W#TDES                 2     17


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
     C                   PARM                    MMDELD
     C                   PARM                    DEALDC
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
     C                   MOVEL     HKDN38        T#TREF
      *
      * Transaction Type
     C                   MOVEL     HKMTYP        T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     HKSTYP        T#TRST
      *
      * Transaction Description
      *
     C     HKMTYP        LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#TDES        T#TDES
      *
      * Deal Date
     C                   Z-ADD     HKDDYY        ZWYYYY                         ¦
     C                   Z-ADD     HKDDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     HKDDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#DDAT            5 0            Midas day no.
     C                   Z-ADD     ZZMDNO        T#DDAT                           Midas day no.
      *                                                                                       208221
     C     I#PH          IFEQ      'P'                                                        208221
     C     I#EOB         ANDEQ     'N'                                                        208221
     C     HKMTYP        IFEQ      'CD'                                                       208221
     C     HKMTYP        OREQ      'CL'                                                       208221
     C     ZZMDNO        IFLT      DETKON                                                     208221
     C                   Z-ADD     DETKON        W#DDAT                                       208221
     C                   Z-ADD     DETKON        T#DDAT                                       208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *
      * Value Date
     C                   Z-ADD     HKVDYY        ZWYYYY                         ¦
     C                   Z-ADD     HKVDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     HKVDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#VDAT            5 0            Midas day no.
     C                   Z-ADD     ZZMDNO        T#VDAT                           Midas day no.
      *                                                                                       208221
     C     I#PH          IFEQ      'P'                                                        208221
     C     I#EOB         ANDEQ     'N'                                                        208221
     C     HKMTYP        IFEQ      'CD'                                                       208221
     C     HKMTYP        OREQ      'CL'                                                       208221
     C     ZZMDNO        IFLT      DETKON                                                     208221
     C                   Z-ADD     DETKON        W#VDAT                                       208221
     C                   Z-ADD     DETKON        T#VDAT                                       208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *
      * Maturity Date
     C                   Z-ADD     HKMDYY        ZWYYYY                         ¦
     C                   Z-ADD     HKMDMM        ZWMTH                          ¦ maturity date
     C                   Z-ADD     HKMDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        W#MDAT            5 0            Midas day no.
     C                   Z-ADD     ZZMDNO        T#MDAT                           Midas day no.
      *
      * Booking Branch
     C                   MOVEL     HKBRCA        T#BRCA
      *
      * Book
     C                   MOVEL     HKBOKC        T#BOOK
      *
      * Counterparty
     C                   MOVEL     HKCNUM        T#CPTY
      *
      * Risk Customer
     C                   MOVEL     HKCNUM        T#RCST
      * Rolled Over
     C     HKROBY        IFNE      *BLANK
     C                   MOVE      'Y'           T#RLDO
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
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'PLDNI'                                           208221
     C     T#TRTP        IFEQ      'CD'                                                       208221
     C     T#TRTP        OREQ      'CL'                                                       208221
     C     T#TRTP        OREQ      'DL'                                                       208221
     C     T#TRTP        OREQ      'IL'                                                       208221
     C     T#TRTP        OREQ      'ID'                                                       208221
     C                   EVAL      W#TYPE = 'PLDCL'                                           208221
     C                   ENDIF                                                                208221
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
     C                   MOVEL     HKMOPM        W#PAYM                         * pay method
     C                   MOVEL     HKMOPI        W#PAYA                         * pay account
     C                   MOVEL     HKPOBR        W#PAYB                         * pay branch
     C                   MOVEL     HKSTCY        W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     HKORCM        W#RECM                         * rec method
     C                   MOVEL     HKMORI        W#RECA                         * rec account
     C                   MOVEL     HKROBR        W#RECB                         * rec branch
     C                   MOVEL     HKSTCY        W#RSCY                         * rec settle ccy
      *
      ** If interest is paid separately set up interest instructions
      *
     C     HKIPDS        IFEQ      'Y'
     C                   MOVE      HKIMET        W#INTM                         * settle method
     C                   MOVEL     HKINSA        W#INTA                         * settle A/C
     C                   MOVE      HKINSA        W#INTB                         * settle branch
     C                   MOVEL     HKISCY        W#ISCY                         * settle currency
      *
     C                   ELSE
      *
      ** If interest is not paid separately use maturity details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        W#INTS                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        W#INTS                         * Pay details
     C                   END
     C                   END
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
     C                   EXSR      IMP_IP
      *
      * If date present (ie not a call/notice deal)
      * IMPORT MATURITY DATE EVENT
      *
     C     W#MDAT        IFNE      *ZERO
     C                   EXSR      IMP_MT
     C                   ENDIF
      *
      * IMPORT DEAL AMENDMENT EVENTS
      *
     C                   EXSR      IMP_DEAM
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
     C                   Z-ADD     HKIAYY        ZWYYYY                         ¦ interest
     C                   Z-ADD     HKIAMM        ZWMTH                          ¦ accrual
     C                   Z-ADD     HKIADD        ZWDAY                          ¦ control date
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        P#IACD                           Midas day no.
      *
      * Accrued Int To Date
     C                   Z-ADD     AITC          P#AITC
      *
      * Int Paid To Date
     C                   Z-ADD     IPRD          P#IPRD
      *
      * Int Capitalized To Date
     C                   Z-ADD     ICTD          P#ICTD
      *
      * Accrued Int Adjustments
     C*****AIAN**********ADD*******AIAP**********P#AIAD*********************                  CDE002
     C                   Z-ADD     AIAP          P#AIAD                                       CDE002
      *
      * Total Int
     C     HKFUID        IFEQ      'Y'
     C                   Z-ADD     TOTI          P#TOTI
     C                   ENDIF
      *
      * Accrued COF Adjustments
     C*****ACAN**********ADD*******ACAP**********P#ACAD*********************                  CDE002
     C                   Z-ADD     ACAP          P#ACAD                                       CDE002
      *
      * Total COF
     C     HKFUID        IFEQ      'Y'
     C                   Z-ADD     TCOF          P#TOTC
     C                   ENDIF
      *                                                                                       208221
     C     I#PH          IFEQ      'P'                                                        208221
     C     I#EOB         ANDEQ     'N'                                                        208221
     C     HKMTYP        IFEQ      'CD'                                                       208221
     C     HKMTYP        OREQ      'CL'                                                       208221
     C     T#VDAT        IFLE      DETKON                                                     208221
     C                   Z-ADD     DETKON        P#IACD                                       208221
     C                   Z-ADD     0             P#AITC                                       208221
     C                   Z-ADD     0             P#IPRD                                       208221
     C                   Z-ADD     0             P#ICTD                                       208221
     C                   Z-ADD     0             P#AIAD                                       208221
     C                   Z-ADD     0             P#ACAD                                       208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *
      * Nominal/Principal
     C                   Z-ADD     HKAMNP        P#NOML                 99      *
     C   99              Z-SUB     HKAMNP        P#NOML
     C     I#PH          IFEQ      'P'                                                        CDE002
     C     I#EOB         ANDEQ     'N'                                                        CDE002
     C                   Z-ADD     P#NOML        P#DIFN                                       CDE002
     C                   ENDIF                                                                CDE002
      *
      * Currency
     C                   MOVEL     HKCCY         P#CCY
     C                   MOVEL     HKCCY         @CYCD
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
      * Base Rate Code
     C                   MOVEL     HKBSRC        P#BRTT
      *
      * Base Rate
      * Rate/Spread
      *
     C     P#BRTT        IFNE      *ZERO
     C     HKINTR        SUB       HKSPRD        P#BRTE
     C                   Z-ADD     HKSPRD        P#RTSP
     C                   ELSE
     C                   Z-ADD     *ZERO         P#BRTE
     C                   Z-ADD     HKINTR        P#RTSP
     C                   ENDIF
      *
      * Spread Ind
     C                   MOVEL     'A'           P#SPIN
      *
      * (Effective) Interest Rate
      *
     C                   Z-ADD     HKINTR        P#IRAT
      *
      * Funding Rate/Spread
     C                   Z-ADD     HKFSRP        P#FSRP
      *
      * Funding Sign
     C                   MOVE      HKFSGN        P#FSGN
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
      ** If deal type is IL or ID then set funding rate/spread to be                          216251
      ** the same as rate/spread on transaction                                               216251
      *                                                                                       216251
     C     HKTYPE        IFEQ      'IL'                                                       216251
     C     HKTYPE        OREQ      'ID'                                                       216251
     C                   Z-ADD     P#RTSP        P#FSRP                                       216251
     C                   Z-ADD     P#RTSP        P#CRAT                                       216251
     C                   ENDIF                                                                216251
      * Int Pay Method
     C     HKFUID        IFEQ      'Y'
     C                   MOVEL     'D'           P#INPM
     C                   ENDIF
      *
      * Int Capitalization
     C                   MOVEL     HKCPTI        P#INTC
      *
      * Int Calc Method
     C                   MOVEL     HKICMT        W#ICBS            1 0
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
     C                   MOVEL     HKRDFC        P#RDFC
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
     C     I#PH          IFEQ      'P'                                                        208221
     C     I#EOB         ANDEQ     'N'                                                        208221
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
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
     C                   ELSE
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   END
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E#PRCD
     C     I#PH          IFEQ      'P'                                                        208221
     C     I#EOB         ANDEQ     'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
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
      * If Front-Up interest = 'Y', value date is an interest pay date
      *
     C     HKFUID        IFEQ      'Y'
     C                   Z-ADD     W#VDAT        E#PRDT                           Midas day no.
      *
      * Interest Amount
     C                   Z-ADD     TOTI          E#INTA
      *
      * Processed?
      *
     C                   TESTB     '1'           ACEI                     99    *
     C   99              MOVE      'Y'           E#PRCD
     C     I#PH          IFEQ      'P'                                                        208221
     C     I#EOB         ANDEQ     'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
     C                   ELSE
      *
     C                   Z-ADD     HKNIYY        ZWYYYY                         ¦
     C                   Z-ADD     HKNIMM        ZWMTH                          ¦ next int date
     C                   Z-ADD     HKNIDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        E#PRDT                           Midas day no.
      *
      ** If no date present use maturity date (which may be zero if call)
      *
     C     E#PRDT        IFEQ      *ZERO
     C                   Z-ADD     W#MDAT        E#PRDT                           Midas day no.
     C                   END
     C                   END
      *
      * Event Type
     C                   MOVEL     'IP'          E#EVTP
      *
      *  Int Capitalization Ind
      *
     C                   MOVEL     HKCPTI        E#INTC
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#INTS        E#SETD
      *
      ** If no next interest payment date present
      ** exit this routine
      *
     C     E#PRDT        IFEQ      *ZERO
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If Front-Up interest = 'Y'
      ** or if no interest payment frequency is present
      ** or if interest payment date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     HKFUID        IFEQ      'Y'
     C     HKIPFQ        OREQ      *BLANK
     C     E#PRDT        OREQ      W#MDAT
     C     *ZERO         OREQ      W#MDAT
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E#PRDT        ZFRDAT                         *DATE
     C                   MOVEL     HKIPFQ        ZFRFRQ                         *FREQUENCY
     C                   Z-ADD     HKIPDM        ZFRBAS                         *BASE DAY
     C                   MOVEL     E#SETM        ZFRSET                         *SETT.METH
     C     E#SETC        IFNE      *BLANK
     C                   MOVEL     E#SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     HKCCY         ZFRCCY                         *CURRENCY
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
     C/SPACE 5
      *****************************************************************
      * IMPORT DEAL AMENDMENT EVENTS
      *****************************************************************
     C     IMP_DEAM      BEGSR
      *
     C     HKDN38        SETLL     MMDEAMP0
     C     *IN99         DOUEQ     '1'
     C     HNDDLT        OREQ      *BLANK
     C     HKDN38        READE     MMDEAMP0                               99    *
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
     C                   Z-ADD     HNAMNP        HNAMNP                 99      *
     C   99              Z-SUB     HNAMNP        HNAMNP
      *
      * If the deal amendment is a spread change
      *
     C     HNMTYP        IFEQ      'SC'
     C                   MOVEL     'SC'          E#EVTP
      * interest rate
     C                   Z-ADD     HNINTR        E#RTSP
     C                   MOVE      HNIRCF        E#IRCH
      * funding rate
     C                   Z-ADD     HNFSRP        E#FSRP
     C                   MOVE      HNFRCF        E#CRCH
     C                   END
      *
      * Principal increase
      *
     C     HNMTYP        IFEQ      'PI'
     C                   MOVEL     'PI'          E#EVTP
     C                   Z-ADD     HNAMNP        E#PRAM
     C                   END
      *
      * Principal decrease
      *
     C     HNMTYP        IFEQ      'PD'
     C                   MOVEL     'PD'          E#EVTP
     C                   Z-ADD     HNAMNP        E#PRAM
     C                   END
      *
      * If the deal amendment is settle interest
      *
     C     HNMTYP        IFEQ      'SI'
     C                   MOVEL     'IP'          E#EVTP
     C                   END
      *
      * If the deal amendment is capitalize interest
      * Set Int Capitalization Ind
      *
     C     HNMTYP        IFEQ      'CI'
     C                   MOVEL     'IP'          E#EVTP
     C                   MOVEL     'Y'           E#INTC
     C                   END
      *
      **  Store pay and receive settlement methods, accounts & branches
      *
     C     W#ASLI        IFEQ      'A'                                          * asset
     C     HNMTYP        ANDEQ     'PI'                                         * + princl inc.
     C     W#ASLI        OREQ      'L'                                          * liability
     C     HNMTYP        ANDEQ     'PD'                                         * + princl dec.
     C     W#ASLI        OREQ      'L'                                          * liability
     C     HNMTYP        ANDEQ     'SI'                                         * + settle int.
     C                   MOVEL     HNMOPM        E#SETM
     C                   MOVEL     HNMOPI        E#SETA
     C                   MOVEL     HNOSBR        E#SETB
     C                   MOVEL     HNSTCY        E#SETC
     C                   ELSE
     C                   MOVEL     HNORCM        E#SETM
     C                   MOVEL     HNMORI        E#SETA
     C                   MOVEL     HNOSBR        E#SETB
     C                   MOVEL     HNSTCY        E#SETC
     C                   ENDIF
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
     C     HKDN38        READE     MMDEAMP0                               99    *
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
(c) Finastra International Limited 2001
** TABCDE/TABTYP. DEAL TYPES
IPAINTERBNK LOAN
TIACUSTOMER LOAN
CLACALL     LOAN
LNACOMMERCL LOAN
DLADEMAND   LOAN
FLAFD TERM PLACING
LPAFL CALL PLACING
DPAFD CALL PLACING
ILAINTERNAL LOAN                                                                    198289
ITLINTERBNK DEPOSIT
TDLCUSTOMER DEPOSIT
CDLCALL     DEPOSIT
CILCD ISSUED
FTLFD TERM TAKING
DTLFD CALL TAKING
LTLFL CALL TAKING
IDLINTERNAL DEPOSIT                                                                 198289
