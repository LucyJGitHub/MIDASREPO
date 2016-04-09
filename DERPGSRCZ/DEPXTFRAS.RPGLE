     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract of FRAs')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTFRAS - Projected Extract for Forward Rate Agreements    *
      *                                                               *
      *  Function:  This module is called by DEPXCFRAS. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompile due to change in DEPPOSNPD format.        *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *           On take on date, do not flag any events as processed*
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  CSD006 - Use DSSDY to call AOBSRTR0.                         *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
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
     D TABCDE          S              3    DIM(2) CTDATA PERRCD(1)
     D TABTYP          S             16    DIM(2) ALT(TABCDE)
 
 
     D FRAS          E DS                  EXTNAME(DEALSDG)
 
 
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
     D  W#TDES                 1     16
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** External DS for BASE RATE details
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
     C                   PARM                    FRAS
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
     C                   MOVEL     DLNO          T#TREF
      *
      * Transaction Type
     C                   MOVEL     DTYP          T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     DLST          T#TRST
      *
      * Transaction Description
      *
     C                   MOVEL     DTYP          TABC              3
     C                   MOVE      BYSL          TABC
     C     TABC          LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#TDES        T#TDES
      *
      * Deal Date
     C                   Z-ADD     DDAT          T#DDAT
      *
      * Value Date
     C                   Z-ADD     VDAT          T#VDAT
      *
      * Maturity Date
     C                   Z-ADD     MDAT          T#MDAT
      *
      * Booking Branch
     C                   MOVEL     BRCA          T#BRCA
      *
      * Book
     C                   MOVEL     BOKC          T#BOOK
      *
      * Counterparty
     C                   MOVEL     CNUM          T#CPTY
      *
      * Risk Customer
     C                   MOVEL     CNUM          T#RCST
      *
      * CHECK WHETHER FRA RATE HAS BEEN FIXED
      *
     C                   EXSR      CHKRATFIX
      *
      * Current Market Value
      *
     C     FltRateSet    IFEQ      'Y'
     C                   Z-ADD     SettleAmt     T#MKVL
     C                   ELSE
     C                   Z-ADD     UNRL          T#MKVL
     C                   ENDIF
      *
      * Valuation Currency
     C                   MOVEL     UCUCY         T#VCCY
      *
      * Valuation Ccy Dec Places
     C                   MOVEL     UCUCY         @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        T#VCDP
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
     C                   MOVEL     PSETM         W#PAYM                         * pay method
     C                   MOVEL     UPACC         W#PAYA                         * pay account
     C                   MOVEL     POBR          W#PAYB                         * pay branch
     C                   MOVEL     PSCY          W#PSCY                         * pay settle ccy
      *
     C                   MOVEL     RSETM         W#RECM                         * rec method
     C                   MOVEL     URACC         W#RECA                         * rec account
     C                   MOVEL     ROBR          W#RECB                         * rec branch
     C                   MOVEL     RSCY          W#RSCY                         * rec settle ccy
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
      ** SET UP WORK FIELDS WITH 'OUR' OR THEIR DETAILS
      *
     C     W#ASLI        CASEQ     'L'           OUR
     C     W#ASLI        CASEQ     'A'           THEIR
     C                   ENDCS
      *
      * IMPORT OPENING BALANCE
      *
     C                   EXSR      IMP_OPBL
      *
      * IMPORT DEAL DATE EVENT
      *
     C                   EXSR      IMP_DD
      *
      ** IF FLOATING RATE
      ** RATE CHANGE IS ON VALUE DATE
      ** IMPORT INITIAL BASE RATE CHANGE (ON VALUE DATE)
      *
     C     W#BRTT        IFNE      *ZERO
     C                   EXSR      IMP_BC_I
     C                   ENDIF
      *
      * IMPORT VALUE DATE EVENT
      *
     C                   EXSR      IMP_VD
      *
      * IMPORT STOP ACCRUALS EVENT (IF FLOATING RATE FIXED)
      *
     C     FltRateSet    IFEQ      'Y'
     C                   EXSR      IMP_SA
     C                   ENDIF
      *                                                                                       CDE002
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST                                          CDE002
      *                                                                                       CDE002
     C     W#AIAN        IFNE      *ZERO                                                      CDE002
     C                   EXSR      IMP_MI                                                     CDE002
     C                   ENDIF                                                                CDE002
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
     C                   Z-ADD     W#IACD        P#IACD                   99    *
     C   99              Z-ADD     VDAT          P#IACD                         *
      *
      * Accrued Int To Date
     C                   Z-ADD     W#AITC        P#AITC
      *
      * Int Paid To Date
     C                   Z-ADD     W#IPRD        P#IPRD
      *
      * Int Capitalized To Date
     C                   Z-ADD     *ZERO         P#ICTD
      *
      * Accrued Int Adjustments
     C*****W#AIAN        ADD       W#AIAP        P#AIAD                                       CDE002
     C                   Z-ADD     W#AIAP        P#AIAD                                       CDE002
      *
      * Nominal/Principal
     C                   Z-ADD     W#PAMT        P#NOML                 99      *
     C     I#PH          IFEQ      'P'                                                        CDE002
     C     I#EOB         ANDEQ     'N'                                                        CDE002
     C                   Z-ADD     P#NOML        P#DIFN                                       CDE002
     C                   ENDIF                                                                CDE002
      *
      * Currency
     C                   MOVEL     W#CUCY        P#CCY
     C                   MOVEL     W#CUCY        @CYCD
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
     C                   MOVEL     W#BRTT        P#BRTT
      *
      * Base Rate
     C                   Z-ADD     W#BRTE        P#BRTE
      *
      * Rate/Spread
     C                   Z-ADD     W#RTSP        P#RTSP
      *
      * Spread Ind
     C                   MOVEL     W#SPIN        P#SPIN
      *
      * (Effective) Interest Rate
      *
     C                   Z-ADD     W#EINR        P#IRAT
      *
      * Int Calc Method
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
      * Accrue realized p/l
     C     HEDIN         IFEQ      'Y'                                                        CDE002
     C                   MOVE      'Y'           P#ACRL
     C                   ENDIF                                                                CDE002
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
     C                   Z-ADD     DDAT          E#PRDT
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
      ********************************************************************
      * IMPORT INITIAL BASE RATE CHANGE (ON VALUE DATE)
      ********************************************************************
     C     IMP_BC_I      BEGSR
      *
      * Clear event
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      * Processing Date
      *
     C                   Z-ADD     VDAT          E#PRDT
      *
      * Processing Sequence
     C                   Z-ADD     05            E#PRSQ
      *
      * Event Type
     C                   MOVEL     'BC'          E#EVTP
      *
      * Base Rate Code
     C                   Z-ADD     W#BRTT        E#BRTT
 
      * If the floating rate has been fixed, use the appropriate rate
 
     C     FltRateSet    IFEQ      'Y'
 
     C     FltRateTyp    IFEQ      'A'
     C                   Z-ADD     FltRate       E#IRAT
     C                   MOVEL     'A'           E#IRTP                         * ACTUAL RATE
     C                   ELSE
     C                   Z-ADD     FltRate       E#BRTE
     C                   MOVEL     'C'           E#IRTP                         * ACTUAL RATE
     C                   ENDIF
 
      * else the rate will be a forward rate
 
     C                   ELSE
     C                   MOVEL     'F'           E#IRTP                         * FORWARD RATE
     C                   END
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
      ** Import initial base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
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
     C                   Z-ADD     VDAT          E#PRDT
      *
      * Processing Sequence
     C                   Z-ADD     10            E#PRSQ
      *
      * Event Type
     C                   MOVEL     'VD'          E#EVTP
 
      * If the floating rate has been fixed
      * the settlement amount is payable on value date
 
     C     FltRateSet    IFEQ      'Y'
     C     SettleAmt     ANDLT     *ZERO
     C     W#ASLI        ANDEQ     'L'
     C     FltRateSet    OREQ      'Y'
     C     SettleAmt     ANDGE     *ZERO
     C     W#ASLI        ANDEQ     'A'
 
      ** Set settlement amount, in/out indicator and settlement details
 
     C     SettleAmt     IFLT      *ZERO
     C                   Z-SUB     SettleAmt     E#INTA
     C                   MOVE      'O'           E#IO
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
     C                   ELSE
     C                   Z-ADD     SettleAmt     E#INTA
     C                   MOVE      'I'           E#IO
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   ENDIF
 
     C                   ELSE
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E#SSET
      *
      ** Set up settlement details
      *
     C     W#ASLI        IFEQ      'A'
     C                   MOVEL     W#PAYD        E#SETD                         * Pay details
     C                   ELSE
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   END
 
     C                   END
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
      * Import value date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT STOP ACCRUALS EVENT
      *****************************************************************
     C     IMP_SA        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     VDAT          E#PRDT
      *
      * Processing Sequence
     C                   Z-ADD     12            E#PRSQ
      *
      * Event Type
     C                   MOVEL     'SA'          E#EVTP
      *
      * Stop accruals ind
     C                   MOVE      'Y'           E#STAC
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
      * Import stop accruals event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5                                                                                CDE002
      *****************************************************************                       CDE002
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST                                          CDE002
      *****************************************************************                       CDE002
     C     IMP_MI        BEGSR                                                                CDE002
      *                                                                                       CDE002
      * CLEAR EVENT                                                                           CDE002
     C                   CLEAR                   E#EVNT                                       CDE002
      *                                                                                       CDE002
      * Module, Transaction Reference, Asset/Liability                                        CDE002
      *                                                                                       CDE002
     C                   MOVEL     P#TKEY        E#TKEY                                       CDE002
      *                                                                                       CDE002
      * Processing Date                                                                       CDE002
     C                   Z-ADD     I#EVCD        E#PRDT                                       CDE002
      *                                                                                       CDE002
      * Event Type                                                                            CDE002
     C                   MOVEL     'MI'          E#EVTP                                       CDE002
      *                                                                                       CDE002
      * Interest                                                                              CDE002
     C                   Z-ADD     W#AIAN        E#INTA                                       CDE002
      *                                                                                       CDE002
      * Import manual adjustment to accrued interest event                                    CDE002
      *                                                                                       CDE002
     C                   MOVEL     '*IMPEVNT'    W#MODE                                       CDE002
     C                   EXSR      WRKEDTA                                                    CDE002
      *                                                                                       CDE002
     C                   ENDSR                                                                CDE002
      *****************************************************************                       CDE002
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
     C                   Z-ADD     MDAT          E#PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E#EVTP
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E#SSET
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
      * CHECK WHETHER FRA RATE HAS BEEN FIXED
      ********************************************************************
     C     CHKRATFIX     BEGSR
 
      * Get floating side fields
 
     C     UBRTT         IFNE      *ZERO
     C                   EXSR      OUR
     C                   Z-ADD     TEINR         FixRate          11 7
     C                   ELSE
     C                   EXSR      THEIR
     C                   Z-ADD     UEINR         FixRate
     C                   ENDIF
 
      ** IF INITIAL RATE SET USE EFFECTIVE INTEREST RATE
 
     C                   TESTB     '0'           W#DNSI                   99    *INITIAL RATE SET IN
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           FltRateSet        1
     C                   MOVEL     'A'           FltRateTyp        1
     C                   Z-ADD     W#EINR        FltRate          11 7
     C                   ELSE
      *
      ** IF RATE DUE FOR FIXING, GET CURRENT BASE RATE
      *
     C     W#INFD        IFLE      I#EVCD
     C                   MOVEL     W#CUCY        @CYCD
     C                   MOVEL     W#BRTT        @DWNB
     C                   EXSR      ACSBSR
     C                   MOVEL     'Y'           FltRateSet
     C                   MOVEL     'C'           FltRateTyp
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        FltRate
     C                   ELSE
     C                   Z-ADD     BANBRT        FltRate
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'N'           FltRateSet
     C                   GOTO      ECHKRATFIX
     C                   END
     C                   END
 
      * Calculate FRA settlement amount
 
     C     UIPRD         IFNE      *ZERO
     C                   Z-SUB     UIPRD         SettleAmt
     C                   ELSE
     C     TIPRD         IFNE      *ZERO
     C                   Z-ADD     TIPRD         SettleAmt
     C                   ELSE
 
     C                   CALLB     'DECALFRST'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      BYSL          W#BYSL            1
     C                   PARM      SETF          W#SETF            1
     C                   PARM      VDAT          W#VDAT            5 0
     C                   PARM      MDAT          W#MDAT            5 0
     C                   PARM                    W#PAMT           13 0
     C                   PARM      FixRate       W#FIX            11 7
     C                   PARM      FltRate       W#FLT            11 7
     C                   PARM                    W#ICBS            1 0
     C                   PARM      *ZERO         W#IANP           13 0
     C                   PARM      *ZERO         W#RDS            13 0
     C                   PARM      *ZERO         SettleAmt        15 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALFRST'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDIF
     C                   ENDIF
 
     C     ECHKRATFIX    ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE 'OUR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     OUR           BEGSR
      *
     C                   MOVE      'U'           W#OTIN            1
      *
     C                   MOVE      UCUCY         W#CUCY            3
     C                   Z-ADD     UPAMT         W#PAMT           13 0
     C                   Z-ADD     UBRTT         W#BRTT            2 0
     C                   Z-ADD     UBRTE         W#BRTE           11 7
     C                   Z-ADD     URTSP         W#RTSP           11 7
     C                   Z-ADD     UEINR         W#EINR           11 7
     C                   MOVE      USPIN         W#SPIN            1
     C                   Z-ADD     UICBS         W#ICBS            1 0
     C                   Z-ADD     UINFD         W#INFD            5 0
      *
     C                   Z-ADD     UIACD         W#IACD            5 0
     C                   Z-ADD     UAITC         W#AITC           13 0
     C                   Z-ADD     UAIAN         W#AIAN           13 0
     C                   Z-ADD     UAIAP         W#AIAP           13 0
     C                   Z-ADD     UIPRD         W#IPRD           13 0
      *
     C                   MOVE      UDNSI         W#DNSI            1
     C                   MOVE      UDSTI         W#DSTI            1
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE 'THEIR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     THEIR         BEGSR
      *
     C                   MOVE      'T'           W#OTIN            1
      *
     C                   MOVE      TCUCY         W#CUCY            3
     C                   Z-ADD     TPAMT         W#PAMT           13 0
     C                   Z-ADD     TBRTT         W#BRTT            2 0
     C                   Z-ADD     TBRTE         W#BRTE           11 7
     C                   Z-ADD     TRTSP         W#RTSP           11 7
     C                   Z-ADD     TEINR         W#EINR           11 7
     C                   MOVE      TSPIN         W#SPIN            1
     C                   Z-ADD     TICBS         W#ICBS            1 0
     C                   Z-ADD     TINFD         W#INFD            5 0
      *
     C                   Z-ADD     TIACD         W#IACD            5 0
     C                   Z-ADD     TAITC         W#AITC           13 0
     C                   Z-ADD     TAIAN         W#AIAN           13 0
     C                   Z-ADD     TAIAP         W#AIAP           13 0
     C                   Z-ADD     TIPRD         W#IPRD           13 0
      *
     C                   MOVE      TDNSI         W#DNSI            1
     C                   MOVE      TDSTI         W#DSTI            1
      *
     C                   ENDSR
      **************************************************************************
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
      * ACCESS BASE RATE DETAILS
      ********************************************************************
     C     ACSBSR        BEGSR
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C                   PARM                    @DWNB             2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
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
     C                   EVAL      W#TYPE = 'PFRAS'                                           208221
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
FRBFRA BOUGHT
FRSFRA SOLD
