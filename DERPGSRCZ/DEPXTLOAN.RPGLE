     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract of customer loans')         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTLOAN - Projected Extract for Customer Lending Loans     *
      *                                                               *
      *  Function:  This module is called by DEPXCLOAN. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
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
      *                 CLE031             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CAP074             Date 28Mar02               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185976             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
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
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A.       *
      *           Settlement allocation flag needs to be set up from  *
      *           the loan or loan amendment as approprite.           *
      *  CLE031 - Lending Enhancements.  Pay Settlement Currency set  *
      *           up separately to Receive Ensure New Principal       *
      *           Amount for rollovers is processed. DEWRKEDTA        *
      *           assumes that there will be a currency set up which  *
      *           was only happening for multi-currency rollovers.    *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompile due to change in DEPPOSNPD format.        *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
      *  185976 - Add parameter ZFRZBD to include interest payment    *
      *           base date in the calculation.                       *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF)
     F                                     PREFIX(SL_)
 
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
      **  Loan types
     D TABSEQ          S              2  0 DIM(12) CTDATA PERRCD(1)
     D TABTYP          S             18    DIM(12) ALT(TABSEQ)
 
 
      * Power array
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWERS OF 10
 
 
     D LOANCL        E DS                  EXTNAME(CLOANCL) PREFIX(CL_)
     D LOANCK        E DS                  EXTNAME(CLOANCK) PREFIX(CK_)
 
 
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
     D  W#INTA                 3     14
     D  W#INTB                15     17
     D  W#ISCY                18     20
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
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     ILOAMSDKF
     I              RECI                        LARECI
     I              VDAT                        LAVDAT
     I              PTYP                        LAPTYP
     I              AMTP                        LAAMTP
     I              PRSQ                        LAPRSQ
     I              BRTT                        LABRTT
     I              RTSP                        LARTSP
     I              CCY                         LACCY
     I              PRAM                        LAPRAM
     I              INTA                        LAINTA
     I              TAMT                        LATAMT
     I              SETP                        LASETP
     I              OSAC                        LAOSAC
     I              OSBR                        LAOSBR
     I              SCCY                        LASCCY
     I              FSRP                        LAFSRP
     I              IRCF                        LAIRCF
     I              FRCF                        LAFRCF
     I              PSCY                        LAPSCY                                        CLE031
     I              STAL                        LASTAL                                        CLE034
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
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
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
      *
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
      *
      * For parts sold, CL_OLNO holds the Sale of Loan Number.
      * For parts purchased, CL_OLNO holds the Original Borrower.
      * Set CL_OLNO to always hold the Original Borrower for use later.
      *
     C**********         MOVEL     CL_OLNO       W#LNRF            6 0                        CLE148
     C                   MOVEL     CL_OLNO       W#LNRF            6                          CLE148
     C     W#LNRF        CHAIN     CLOANCLF                           99        *
      *
     C     *IN99         IFEQ      '0'
      *
     C*****SL_MLNR       IFNE      0                                            *             CLE148
     C     SL_MLNR       IFNE      *BLANKS                                                    CLE148
     C                   MOVEL     SL_MLNR       W#LNRF
     C                   MOVEL     SL_OLNO       CL_OLNO
     C                   ELSE                                                   *
     C                   MOVEL     SL_CNUM       CL_OLNO
     C                   ENDIF                                                  *
     C                   ENDIF                                                  *
      *
     C                   MOVEL     W#LNRF        W#LNRF7           7
     C                   MOVE      '/'           W#LNRF7
     C                   MOVEL     W#LNRF7       W#LNRF13         13
     C                   MOVE      CL_LNRF       W#LNRF13
     C                   MOVEL     W#LNRF13      T#TREF
     C                   ENDIF                                                  *
      *
      * Transaction Type
     C                   MOVEL     CL_LTYP       T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     CL_SUTP       T#TRST
      *
      * Transaction Description
      *
     C     CL_PTYP       LOOKUP    TABSEQ        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#TDES        T#TDES
      *
      * Deal Date
     C                   Z-ADD     CL_DDAT       T#DDAT                           Midas day no.
      *
      * Value Date
     C                   Z-ADD     CL_VDAT       T#VDAT                             Midas day no.
      *
      * Maturity Date
     C                   Z-ADD     CL_MDAT       T#MDAT                             Midas day no.
      *
      * Booking Branch
     C                   MOVEL     CL_BRCA       T#BRCA
      *
      * Book
     C                   MOVEL     CL_BOKC       T#BOOK
      *
      * Counterparty (normally transaction customer unless part sold
      * with recourse, then use original borrower)
      *
     C                   MOVEL     CL_CNUM       T#CPTY
      *
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
      *
     C     CL_RCSI       IFEQ      'Y'                                          *
     C*****CL_OLNO       ANDNE     0                                            *             CSD027
     C     CL_OLNO       ANDNE     *BLANKS                                      *             CSD027
     C                   MOVEL     CL_OLNO       T#CPTY
     C                   ENDIF
     C                   ENDIF
      *
      * Risk Customer (normally transaction customer unless part purchased
      * or part sold without recourse, then use original borrower)
      *
     C                   MOVEL     CL_CNUM       T#RCST
      *
     C     CL_PTYP       IFEQ      64                                           *
     C     CL_PTYP       OREQ      65                                           *
     C     CL_PTYP       OREQ      68                                           *
     C     CL_PTYP       OREQ      71                                           *
      *
     C*****CL_OLNO       IFNE      0                                            *             CSD027
     C     CL_OLNO       IFNE      *BLANKS                                      *             CSD027
     C                   MOVEL     CL_OLNO       T#RCST
     C                   ENDIF
     C                   ENDIF
      *
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
      *
     C     CL_RCSI       IFNE      'Y'                                          *
     C*****CL_OLNO       ANDNE     0                                            *             CSD027
     C     CL_OLNO       ANDNE     *BLANKS                                      *             CSD027
     C                   MOVEL     CL_OLNO       T#RCST
     C                   ENDIF
     C                   ENDIF
      *
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
     C     W#ASLI        IFEQ      'A'
      *
     C                   MOVEL     CL_SDST       W#PAYM                           * pay method
     C                   MOVEL     CL_OSDA       W#PAYA                           * pay account
     C                   MOVEL     CL_OSDB       W#PAYB                           * pay branch
     C                   MOVEL     CL_SCCY       W#PSCY                           * pay settle ccy
      *
     C                   MOVEL     CL_MDST       W#RECM                           * rec method
     C                   MOVEL     CL_OMDA       W#RECA                           * rec account
     C                   MOVEL     CL_OMDB       W#RECB                           * rec branch
     C                   MOVEL     CL_SCCY       W#RSCY                           * rec settle ccy
      *
     C                   ENDIF
      *
     C     W#ASLI        IFEQ      'L'
      *
     C                   MOVEL     CL_SDST       W#RECM                           * rec method
     C                   MOVEL     CL_OSDA       W#RECA                           * rec account
     C                   MOVEL     CL_OSDB       W#RECB                           * rec branch
     C                   MOVEL     CL_SCCY       W#RSCY                           * rec settle ccy
      *
     C                   MOVEL     CL_MDST       W#PAYM                           * pay method
     C                   MOVEL     CL_OMDA       W#PAYA                           * pay account
     C                   MOVEL     CL_OMDB       W#PAYB                           * pay branch
     C                   MOVEL     CL_SCCY       W#PSCY                           * pay settle ccy
      *
     C                   ENDIF
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVEL     CL_PSCY       W#PSCY                                       CLE031
     C                   ENDIF                                                                CLE031
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
     C     CL_AIMN       IFNE      *ZERO
     C     CL_ACAJ       ORNE      *ZERO
     C                   EXSR      IMP_MI
     C                   ENDIF
      *
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *
     C                   EXSR      IMP_IP
      *
      * IMPORT REPAYMENT DATE EVENTS
      *
     C     CL_NRPD       IFNE      *ZERO
     C                   EXSR      IMP_RE
     C                   ENDIF
      *
      * IMPORT NEXT ROLLOVER DATE EVENT
      *
     C     CL_RLDT       IFNE      *ZERO
     C                   EXSR      IMP_RO
     C                   ENDIF
      *
      * If date present (ie not a call/notice loan)
      * IMPORT MATURITY DATE EVENT
      *
     C     CL_MDAT       IFNE      *ZERO
     C                   EXSR      IMP_MT
     C                   ENDIF
      *
      * IMPORT LOAN AMENDMENT EVENTS
      *
     C                   EXSR      IMP_LOAM
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
     C                   Z-ADD     CL_IACD       P#IACD
      *
      * Accrued Int To Date
     C                   Z-ADD     CL_AITC       P#AITC
      *
      * Int Paid To Date
     C                   Z-ADD     CL_IPRD       P#IPRD
      *
      * Int Capitalized To Date
     C                   Z-ADD     CL_ICTD       P#ICTD
      *
      * Int Written Off To Date
     C                   Z-ADD     CL_IWOD       P#IWOD
      *
      * Accrued Int Adjustments
     C*****CL_AIMN       ADD       CL_AIAP       P#AIAD                                       CDE002
     C                   Z-ADD     CL_AIAP       P#AIAD                                       CDE002
      *
      * Total Int
     C     W#TYP         IFEQ      'D'
     C                   Z-ADD     CL_TOTI       P#TOTI
     C                   ENDIF
      *
      * Accrued COF Adjustments
     C*****CL_ACAJ       ADD       CL_ACAP       P#ACAD                                       CDE002
     C                   Z-ADD     CL_ACAP       P#ACAD                                       CDE002
      *
      * Total COF
     C     W#TYP         IFEQ      'D'
     C                   Z-ADD     CL_TCOF       P#TOTC
     C                   ENDIF
      *
      * Nominal/Principal
     C                   Z-ADD     CL_CPAM       P#NOML
      *
      * Currency
     C                   MOVEL     CL_CCY        P#CCY
     C                   MOVEL     CL_CCY        @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P#NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P#NMDP
      *
      * Base Rate Code
     C                   MOVEL     CL_BRTT       P#BRTT
      *
      * Base Rate
     C                   Z-ADD     CL_BRTE       P#BRTE
      *
      * Rate/Spread
     C                   Z-ADD     CL_RTSP       P#RTSP
      *
      * Spread Ind
     C                   MOVEL     CL_SPIN       P#SPIN
      *
      * (Effective) Interest Rate
      *
     C                   Z-ADD     CL_INTR       P#IRAT
      *
      * Change Ind
     C                   MOVEL     CL_CHIN       P#CHIN
      *
      * Funding Rate/Spread
     C                   Z-ADD     CL_FSRP       P#FSRP
      *
      * Funding Sign
     C                   MOVE      CL_FSGN       P#FSGN
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
      * Int Pay Method
     C     W#TYP         IFEQ      'D'
     C                   MOVEL     'D'           P#INPM
     C                   ENDIF
      *
      * Int Capitalization
     C                   MOVEL     CL_INTC       P#INTC
      *
      * Int Calc Method
     C                   CALLB     'DECVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      CL_ICBS       W#ICBS            1 0          * INT CAL BASIS
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
     C                   Z-ADD     CL_REPT       P#REPT
      *
      * Stop Accruals
     C                   TESTB     '3'           CL_LONI                  99
     C   99              MOVEL     'Y'           P#STAC
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
     C                   Z-ADD     CL_DDAT       E#PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E#EVTP
      *
      * Processed?
      *
     C                   TESTB     '0'           CL_ACEI                  99      *
     C   99              MOVE      'Y'           E#PRCD
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
     C                   Z-ADD     CL_VDAT       E#PRDT
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
     C                   TESTB     '1'           CL_ACEI                  99      *
     C   99              MOVE      'Y'           E#PRCD
     C*                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   MOVEL     CL_STAL       E#STAL                                       CLE034
     C                   ENDIF                                                                CLE034
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
     C                   Z-ADD     CL_AIMN       E#INTA
      *
      * Cost of funds
     C                   Z-ADD     CL_ACAJ       E#COFA
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
      * If discounted loan, value date is an interest pay date
      *
     C     W#TYP         IFEQ      'D'
     C                   Z-ADD     CL_VDAT       E#PRDT
      *
      * Interest Amount
     C                   Z-ADD     CL_TOTI       E#INTA
      *
      * Processed?
      *
     C                   TESTB     '1'           CL_ACEI                  99      *
     C   99              MOVE      'Y'           E#PRCD
     C                   ELSE
     C                   Z-ADD     CL_NIDT       E#PRDT
      *
      ** If no date present use maturity date (which may be zero if call)
      *
     C     E#PRDT        IFEQ      *ZERO
     C                   Z-ADD     CL_MDAT       E#PRDT
     C                   END
     C                   END
      *
      * Event Type
     C                   MOVEL     'IP'          E#EVTP
      *
      *  Int Capitalization Ind
      *
     C                   MOVEL     CL_INTC       E#INTC
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
     C                   END
     C*                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   MOVEL     CL_STAL       E#STAL                                       CLE034
     C                   ENDIF                                                                CLE034
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
      ** If interest is discounted
      *
     C     W#TYP         IFEQ      'D'
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** If no interest payment frequency is present
      ** or if interest payment date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     CL_IPFR       IFEQ      *BLANK
     C     E#PRDT        OREQ      CL_MDAT
     C     *ZERO         OREQ      CL_MDAT
     C                   GOTO      EIMP_IP
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E#PRDT        ZFRDAT                         *DATE
     C                   MOVEL     CL_IPFR       ZFRFRQ                           *FREQUENCY
     C                   Z-ADD     CL_IFDY       ZFRBAS                           *BASE DAY
     C                   MOVEL     E#SETM        ZFRSET                         *SETT.METH
     C     E#SETC        IFNE      *BLANK
     C                   MOVEL     E#SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     CL_CCY        ZFRCCY                           *CURRENCY
     C                   ENDIF
     C                   MOVEL     E#SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     CL_MDAT       ZFRMDT                           *MAT DATE
      *
      * Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E#PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all interest payments prior to maturity date
      *
     C     E#PRDT        DOWLT     CL_MDAT
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
      * IMPORT REPAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_RE        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     CL_NRPD       E#PRDT
      *
      * Principal Amount
     C                   Z-ADD     CL_RAMT       E#PRAM
      *
      * Total Amount
     C                   Z-ADD     CL_RAMT       E#TAMT
      *
      * Event Type
     C                   MOVEL     'RE'          E#EVTP
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
     C                   END
     C*                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   MOVEL     CL_STAL       E#STAL                                       CLE034
     C                   ENDIF                                                                CLE034
      *
      ** Import next repayment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If no repayment frequency is present
      ** or if next repayment date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     CL_RFRQ       IFEQ      *BLANK
     C     E#PRDT        OREQ      CL_MDAT
     C     *ZERO         OREQ      CL_MDAT
     C                   GOTO      EIMP_RE
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E#PRDT        ZFRDAT                         *DATE
     C                   MOVEL     CL_RFRQ       ZFRFRQ                           *FREQUENCY
     C                   Z-ADD     CL_RDYN       ZFRBAS                           *BASE DAY
     C                   MOVEL     E#SETM        ZFRSET                         *SETT.METH
     C     E#SETC        IFNE      *BLANK
     C                   MOVEL     E#SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     CL_CCY        ZFRCCY                           *CURRENCY
     C                   ENDIF
     C                   MOVEL     E#SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     CL_MDAT       ZFRMDT                           *MAT DATE
      *
      * Determine next repayment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E#PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all repayments prior to maturity date
      *
     C     E#PRDT        DOWLT     CL_MDAT
      *
      ** Import next repayment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Determine next repayment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E#PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
      ** Import last repayment date event (at maturity date)
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C     EIMP_RE       ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT ROLLOVER DATE EVENTS
      *****************************************************************
     C     IMP_RO        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     CL_RLDT       E#PRDT
      *
      * Event Type
     C                   MOVEL     'RO'          E#EVTP
      *
      * (New) Base Rate Code
     C                   Z-ADD     CL_NBRA       E#BRTT
      *
      * (New) Rate/Spread
     C                   Z-ADD     CL_NRTS       E#RTSP
      *
      * (New) Spread Ind
     C                   MOVEL     CL_NSIN       E#SPIN
      *
      * (New) Funding Spread/Rate
     C                   Z-ADD     CL_NFRS       E#FSRP
      *
      * (New) Funding Sign
     C                   MOVE      CL_NFSN       E#FSGN
      *
      * Interest Rate Change
      * Cost of Funds Rate Change
     C     CL_NCAS       IFNE      0
     C                   MOVE      'Y'           E#IRCH
     C                   MOVE      'Y'           E#CRCH
     C                   END
      *
      * (New) Int Calculation Method
     C     CL_NCAS       IFNE      0
     C                   CALLB     'DECVTICDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      CL_NCAS       W#ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        E#ICMT
     C                   ENDIF
      *
      * New Nominal
     C                   Z-ADD     CK_NCPA       E#NOML
      *
      * New Currency
     C                   MOVEL     CK_NCCY       E#CCY
     C*                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     CK_NCCY       IFEQ      *BLANKS                                                    CLE031
     C     CK_NCPA       ANDNE     *ZEROS                                                     CLE031
     C                   MOVEL     CL_CCY        E#CCY                                        CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
      * New Ccy Dec Places
     C     CK_NCCY       IFNE      *BLANK
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        E#NCDP
      *
      * New Nom Dec Places
     C                   Z-ADD     A6NBDP        E#NMDP
     C                   ENDIF
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
     C                   END
     C*                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   MOVEL     CL_STAL       E#STAL                                       CLE034
     C                   ENDIF                                                                CLE034
      *
      ** Import next rollover date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** If no rollover frequency is present
      ** or if next rollover date is at maturity date
      ** or if maturity date is not present
      ** exit this routine
      *
     C     CL_RLFQ       IFEQ      *BLANK
     C     E#PRDT        OREQ      CL_MDAT
     C     *ZERO         OREQ      CL_MDAT
     C                   GOTO      EIMP_RO
     C                   ENDIF
      *
      ** Set up variables used in frequency calculation
      *
     C                   Z-ADD     E#PRDT        ZFRDAT                         *DATE
     C                   MOVEL     CL_RLFQ       ZFRFRQ                           *FREQUENCY
     C                   Z-ADD     CL_RLDY       ZFRBAS                           *BASE DAY
     C                   MOVEL     E#SETM        ZFRSET                         *SETT.METH
     C     E#SETC        IFNE      *BLANK
     C                   MOVEL     E#SETC        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     CL_CCY        ZFRCCY                           *CURRENCY
     C                   ENDIF
     C                   MOVEL     E#SETA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     CL_MDAT       ZFRMDT                           *MAT DATE
      *
      * Determine next rollover date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E#PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
      ** Do all rollovers prior to maturity date
      *
     C     E#PRDT        DOWLT     CL_MDAT
      *
      ** Import next rollover date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Determine next rollover date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        E#PRDT
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
     C     EIMP_RO       ENDSR
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
     C                   Z-ADD     CL_MDAT       E#PRDT
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
     C*                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   MOVEL     CL_STAL       E#STAL                                       CLE034
     C                   ENDIF                                                                CLE034
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
      * IMPORT LOAN AMENDMENT EVENTS
      *****************************************************************
     C     IMP_LOAM      BEGSR
      *
     C     CL_LNRF       SETLL     LOAMSDKF
     C     *IN99         DOUEQ     '1'
     C     LARECI        OREQ      'D'
     C     CL_LNRF       READE     LOAMSDKF                               99      *
     C                   ENDDO
      *
      * Whilst loan amendments can be found
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
     C                   Z-ADD     LAVDAT        E#PRDT
      *
      * Processing Seq
     C                   MOVEL     LAPRSQ        E#PRSQ
      *
      * If the loan amendment is a base rate change
      *
     C     LAAMTP        IFEQ      'BC'
     C                   MOVEL     'BC'          E#EVTP
     C                   Z-ADD     LABRTT        E#BRTT
     C                   END
      *
      * If the loan amendment is a spread change
      *
     C     LAAMTP        IFEQ      'SC'
     C                   MOVEL     'SC'          E#EVTP
      * interest rate
     C                   Z-ADD     LARTSP        E#RTSP
     C                   MOVE      LAIRCF        E#IRCH
      * funding rate
     C                   Z-ADD     LAFSRP        E#FSRP
     C                   MOVE      LAFRCF        E#CRCH
     C                   END
      *
      * Principal increase
      *
     C     LAAMTP        IFEQ      'PI'
     C     LAAMTP        OREQ      'PT'
     C                   MOVEL     'PI'          E#EVTP
     C                   Z-ADD     LAPRAM        E#PRAM
     C                   END
      *
      * Principal decrease
      *
     C     LAAMTP        IFEQ      'PF'
     C                   MOVEL     'PD'          E#EVTP
     C                   Z-ADD     LAPRAM        E#PRAM
     C                   END
      *
      * Repayment schedule
      *
     C     LAAMTP        IFEQ      'RE'
      * convert
     C     LACCY         IFNE      CL_CCY
     C                   EXSR      CONVLM
     C                   END
     C                   MOVEL     'RE'          E#EVTP
     C                   Z-ADD     LAPRAM        E#PRAM
     C                   Z-ADD     LAINTA        E#INTA
     C                   Z-ADD     LATAMT        E#TAMT
     C                   END
      *
      * Manual repayment
      *
     C     LAAMTP        IFEQ      'MR'
      * convert
     C     LACCY         IFNE      CL_CCY
     C                   EXSR      CONVLM
     C                   END
     C                   MOVEL     'MR'          E#EVTP
     C                   Z-ADD     LAPRAM        E#PRAM
     C                   Z-ADD     LAINTA        E#INTA
     C                   Z-ADD     LATAMT        E#TAMT
     C                   END
      *
      * Past Due Payment
      *
     C     LAAMTP        IFEQ      'PD'
     C                   MOVEL     'OD'          E#EVTP
     C                   Z-ADD     LAPRAM        E#PRAM
     C                   Z-ADD     LAINTA        E#INTA
     C                   Z-ADD     LATAMT        E#TAMT
     C                   END
      *
      **  Store settlement method, account & branch
      *
     C                   MOVEL     LASETP        E#SETM
     C                   MOVEL     LAOSAC        E#SETA
     C                   MOVEL     LAOSBR        E#SETB
     C                   MOVEL     LASCCY        E#SETC
     C*                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     W#ASLI        IFEQ      'A'                                                        CLE031
     C     LAAMTP        IFEQ      'PI'                                                       CLE031
     C     LAAMTP        OREQ      'PT'                                                       CLE031
     C                   MOVEL     LAPSCY        E#SETC                                       CLE031
     C                   ENDIF                                                                CLE031
     C*                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C     LAAMTP        IFNE      'PI'                                                       CLE031
     C     LAAMTP        ANDNE     'PT'                                                       CLE031
     C                   MOVEL     LAPSCY        E#SETC                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C*                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C     LASTAL        IFEQ      'Y'                                                        CLE034
     C                   MOVEL     LASTAL        E#STAL                                       CLE034
     C                   Z-ADD     LASN          E#LASN                                       CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
      *
      * Import loan amendment event
      *
     C     E#EVTP        IFNE      *BLANK
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      * Read next record
      *
     C     *IN99         DOUEQ     '1'
     C     LARECI        OREQ      'D'
     C     CL_LNRF       READE     LOAMSDKF                               99      *
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
      * CONVERT LOAN AMENDMENT (FACILITY) CURRENCY TO LOAN CURRENCY
      ********************************************************************
     C     CONVLM        BEGSR
      *
      **   ACCESS LOAN AMENDMENT CURRENCY DETAILS
      *
     C                   MOVEL     LACCY         @CYCD
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
     C                   Z-ADD     LAPRAM        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        LAPRAM
      * interest
     C                   Z-ADD     LAINTA        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        LAINTA
      * total
     C                   Z-ADD     LATAMT        ZAMTCI
     C                   EXSR      ZCONVN
     C                   Z-ADD     ZAMTCO        LATAMT
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
      *                                                                                       CLE031
      **  Access Switchable Feature details for CLE031                                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY '    @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD             6                          CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
     C*                                                                                       CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVEL     'Y'           CLE031            1                          CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE034
      **  Access Switchable Feature details for CLE034                                        CLE034
      *                                                                                       CLE034
     C                   CALLB     'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY '    @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
     C*                                                                                       CLE034
     C     @RTCD         IFEQ      *BLANKS                                                    CLE034
     C                   MOVEL     'Y'           CLE034            1                          CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'PLOAN'                                           208221
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
