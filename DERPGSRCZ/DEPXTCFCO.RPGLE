     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj ext of cap/floor/collar options')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTCFCO - Projected Extract for Caps, Floors and Collars   *
      *                                                               *
      *  Function:  This module is called by DEPXCCFCO. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
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
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185976             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  CSD006 - Use DSSDY to call AOCURRR0.                         *
      *  185976 - Add parameter ZFRZBD to include interest payment    *
      *           base date in the calculation.                       *
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
     D TABCDE          S              3    DIM(6) CTDATA PERRCD(1)
     D TABTYP          S             16    DIM(6) ALT(TABCDE)
 
 
     D CFCOS         E DS                  EXTNAME(DEALSDG)
 
 
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
      * NOTES ABOUT CAPS, FLOORS, COLLARS
      * ---------------------------------
      * Buy floor   They pay us if effective int rate < floor rate.
      *             Ceiling rate is set to 9999.9999999
      *             Deal details found in 'OUR' fields except for
      *             AITC & AIPD which is TAITC & TAIPD.
      * Sell floor  We pay them if effective int rate < floor rate.
      *             Ceiling rate is set to 9999.9999999
      *             Deal details found in 'THEIR' fields except for
      *             AITC & AIPD which is UAITC & UAIPD.
      * Buy cap     They pay us if effective int rate > ceiling rate
      *             Floor rate is set to 0.
      *             ALL deal details found in 'THEIR' fields.
      * Sell cap    We pay them if effective int rate > ceiling rate
      *             Floor rate is set to 0.
      *             ALL deal details found in 'OUR' fields.
      * Buy collar  = selling a floor and buying a cap.
      *             Deal details found in 'THEIR' fields.
      *             We pay them if effective int rate < floor rate.
      *             (our payments in UAITC & UAIPD).
      *             They pay us if effective int rate > ceiling rate
      *             (their payments in TAITC & TAIPD).
      * Sell collar = buying a floor and selling a cap.
      *             Deal details found in 'OUR' fields.
      *             We pay them if effective int rate > ceiling rate
      *             (our payments in UAITC & UAIPD).
      *             They pay us if effective int rate < floor rate.
      *             (their payments in TAITC & TAIPD).
 
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
     C                   PARM                    CFCOS
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
      ** (Asset details only if a buy or a collar)
      *
     C     BYSL          IFEQ      'B'
     C     DTYP          OREQ      'RR'
     C                   MOVE      'A'           W#ASLI            1
     C                   EXSR      MAIN
     C                   ENDIF
      *
      ** MAIN PROCESSING - 'LIABILITY' POSITION
      ** (Liability details only if a sell or a collar)
      *
     C     BYSL          IFEQ      'S'
     C     DTYP          OREQ      'RR'
     C                   MOVE      'L'           W#ASLI
     C                   EXSR      MAIN
     C                   ENDIF
 
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
      ** SET UP WORK FIELDS WITH 'OUR' OR 'THEIR' DETAILS
      ** ('our' if sell cap, buy floor, or sell collar)
      *
     C     BYSL          IFEQ      'S'
     C     DTYP          ANDEQ     'RP'
     C     BYSL          OREQ      'B'
     C     DTYP          ANDEQ     'RF'
     C     BYSL          OREQ      'S'
     C     DTYP          ANDEQ     'RR'
     C                   EXSR      OUR
     C                   ELSE
     C                   EXSR      THEIR
     C                   ENDIF
      *
      * Set up accrued interest to control date
      * and interest instructions
      * (according to whether asset - receiving - or liability - paying)
      *
     C     W#ASLI        IFEQ      'A'
     C                   Z-ADD     TAITC         W#AITC
     C                   MOVE      W#RECD        W#INTS
     C                   ELSE
     C                   Z-ADD     UAITC         W#AITC
     C                   MOVE      W#PAYD        W#INTS
     C                   ENDIF
 
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
      * IMPORT FEE PAYMENT DATE EVENT
      *
     C     UPVD          IFNE      *ZERO
 
     C     DTYP          IFNE      'RR'
 
     C     DTYP          OREQ      'RR'
     C     W#ASLI        ANDEQ     'A'
     C     UPPR          ANDEQ     'R'
 
     C     DTYP          OREQ      'RR'
     C     W#ASLI        ANDEQ     'L'
     C     UPPR          ANDEQ     'P'
 
     C                   EXSR      IMP_FE
     C                   ENDIF
     C                   ENDIF
      *
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST
      *
     C     W#AIAN        IFNE      *ZERO
     C                   EXSR      IMP_MI
     C                   ENDIF
      *
      ** IF FLOATING RATE
      ** FIRST RATE CHANGE IS ON VALUE DATE
      ** IMPORT INITIAL BASE RATE CHANGE (ON VALUE DATE)
      *
     C*****W#BRTT        IFNE      *ZERO                                                      CSD103
     C     W#BRTT        IFNE      *BLANKS                                                    CSD103
     C                   EXSR      IMP_BC_I
     C                   ENDIF
      *
      * IF FLOATING RATE
      * IMPORT BASE RATE CHANGE EVENTS
      *
     C*****W#BRTT        IFNE      *ZERO                                                      CSD103
     C     W#BRTT        IFNE      *BLANKS                                                    CSD103
     C     W#NICD        ANDNE     *ZERO
     C     W#NICD        ANDLT     MDAT
      *
      * IMPORT BASE RATE CHANGE EVENTS
      *
     C                   EXSR      IMP_BC
     C                   END
      *
      * IMPORT INTEREST PAYMENTS
      *
     C     W#IPFR        IFNE      *BLANK
     C                   EXSR      IMP_IP
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
     C                   Z-ADD     W#IACD        P#IACD
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
     C                   Z-ADD     W#PAMT        P#NOML                         *
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
      * Ceiling & Floor Rate
      *
      * If deal type is collar
     C     DTYP          IFEQ      'RR'
     C     W#ASLI        IFEQ      'A'
     C     BYSL          ANDEQ     'B'
     C     W#ASLI        OREQ      'L'
     C     BYSL          ANDEQ     'S'
     C                   Z-ADD     CLRAT         P#CLRT
     C                   Z-ADD     *ZERO         P#FLRT
     C                   ELSE
     C                   Z-ADD     9999.9999999  P#CLRT
     C                   Z-ADD     FLRAT         P#FLRT
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     CLRAT         P#CLRT
     C                   Z-ADD     FLRAT         P#FLRT
     C                   ENDIF
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
      * Accrue fee
     C                   MOVE      'Y'           P#ACFE
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
      * Event Type
     C                   MOVEL     'VD'          E#EVTP
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
      *
      * Processed?
      *
     C**********         TESTB     '1'           ACEI                     99                  CDE002
     C                   TESTB     '0'           UDNSI                    99                  CDE002
     C  N99              TESTB     '0'           TDNSI                    99                  CDE002
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
      * IMPORT FEE PAYMENT DATE EVENT
      *****************************************************************
     C     IMP_FE        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     UPVD          E#PRDT
      *
      * Event Type
     C                   MOVEL     'FE'          E#EVTP
      *
      * Fees = premium paid
      *
     C                   Z-ADD     UPFE          E#FEE
      *
      * Currency decimal places
      *
     C                   MOVEL     A6NBDP        E#NCDP
      *
      ** Set up settlement details
      *
     C     UPPR          IFEQ      'P'
     C                   MOVEL     W#PAYD        E#SETD                         * Rec details
     C                   ELSE
     C                   MOVEL     W#RECD        E#SETD                         * Rec details
     C                   ENDIF
      *
      * Processed?
      *
     C                   TESTB     '3'           ACEI                     99    *
     C   99              MOVE      'Y'           E#PRCD
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
      *
      ** Incoming/outgoing
      *
     C     UPPR          IFEQ      'P'
     C                   MOVEL     'O'           E#IO
     C                   ELSE
     C                   MOVEL     'I'           E#IO
     C                   ENDIF
      *
      * Import fee payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MANUAL ADJUSTMENT TO ACCRUED INTEREST
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
     C                   Z-ADD     W#AIAN        E#INTA
      *
      * Import manual adjustment to accrued interest event
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
      *
      * Processing Date
     C                   Z-ADD     VDAT          E#PRDT
      *
      * Event Type
     C                   MOVEL     'BC'          E#EVTP
      *
      * Base Rate Code
     C**********         Z-ADD     W#BRTT        E#BRTT                                       CSD103
     C                   MOVE      W#BRTT        E#BRTT                                       CSD103
      *
      * Rate Type
     C                   TESTB     '0'           W#DNSI                   99    *INITIAL RATE SET IN
      *
      ** IF INITIAL RATE SET USE EFFECTIVE INTEREST RATE
      *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     W#EINR        E#IRAT
     C                   MOVEL     'A'           E#IRTP                         * ACTUAL RATE
     C                   ELSE
      *
      ** IF RATE DUE FOR FIXING, GET CURRENT BASE RATE
      *
     C     W#INFD        IFLE      I#EVCD
     C                   MOVEL     W#CUCY        @CYCD
     C                   MOVEL     W#BRTT        @DWNB
     C                   EXSR      ACSBSR
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        E#BRTE
     C                   ELSE
     C                   Z-ADD     BANBRT        E#BRTE
     C                   ENDIF
     C                   MOVEL     'C'           E#IRTP                         * ACTUAL RATE
      *
      ** ELSE TAKE FUTURE RATE TO BE ZERO
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         E#IRAT
     C                   MOVEL     'A'           E#IRTP                         * FORWARD RATE
     C                   END
     C                   END
      *
      * Processed?
      *
     C**********         TESTB     '1'           ACEI                     99                  CDE002
     C                   TESTB     '0'           W#DNSI                   99                  CDE002
     C   99              MOVE      'Y'           E#PRCD
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
      *
      ** Import first base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * IMPORT BASE RATE CHANGE EVENTS
      ********************************************************************
     C     IMP_BC        BEGSR
      *
      ** Set up variables used in frequency calculation
      *
     C                   MOVEL     W#ICFR        ZFRFRQ                         *FREQUENCY
     C                   Z-ADD     W#ICFD        ZFRBAS                         *BASE DAY
     C                   MOVEL     W#INTM        ZFRSET                         *SETT.METH
     C     W#ISCY        IFNE      *BLANK
     C                   MOVEL     W#ISCY        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     W#CUCY        ZFRCCY                         *CURRENCY
     C                   ENDIF
     C                   MOVEL     W#INTA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     MDAT          ZFRMDT                         *MAT DATE
      *
      ** Set up next rate change date
      *
     C                   Z-ADD     W#NICD        ZFRDAT
      *
      ** Do all rate changes prior to maturity date
      *
     C     ZFRDAT        DOWLT     MDAT
      *
      * Clear event
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     ZFRDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'BC'          E#EVTP
      *
      * Base Rate Code
     C**********         Z-ADD     W#BRTT        E#BRTT                                       CSD103
     C                   MOVE      W#BRTT        E#BRTT                                       CSD103
      *
      * Base Rate & Rate Type
      *
      * If the next rate fix date > this rate change date
      * the rate for this rate change date has already been fixed
      *
     C     W#INFD        IFGT      E#PRDT
     C                   Z-ADD     W#BRTE        E#BRTE
     C                   MOVEL     'C'           E#IRTP                         * ACTUAL RATE
     C                   ELSE
      *
      * If this is the next rate change date
      * and this rate is due for fixing, get the current base rate
      *
     C     W#NICD        IFEQ      E#PRDT
     C     W#INFD        ANDLE     I#EVCD
     C                   MOVEL     W#CUCY        @CYCD
     C                   MOVEL     W#BRTT        @DWNB
     C                   EXSR      ACSBSR
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        E#BRTE
     C                   ELSE
     C                   Z-ADD     BANBRT        E#BRTE
     C                   ENDIF
     C                   MOVEL     'C'           E#IRTP                         * ACTUAL RATE
      *
      ** ELSE TAKE FUTURE RATE TO BE ZERO
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         E#IRAT
     C                   MOVEL     'A'           E#IRTP                         * FORWARD RATE
     C                   END
     C                   END
      *
      ** Import next base rate change date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Determine next base rate change date event
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * IMPORT INTEREST PAYMENTS
      ********************************************************************
     C     IMP_IP        BEGSR
      *
      ** Set up variables used in frequency calculation
      *
     C                   MOVEL     W#IPFR        ZFRFRQ                         *FREQUENCY
     C                   Z-ADD     W#IPFD        ZFRBAS                         *BASE DAY
     C                   MOVEL     W#INTM        ZFRSET                         *SETT.METH
     C     W#ISCY        IFNE      *BLANK
     C                   MOVEL     W#ISCY        ZFRCCY                         *CURRENCY
     C                   ELSE
     C                   MOVEL     W#CUCY        ZFRCCY                         *CURRENCY
     C                   ENDIF
     C                   MOVEL     W#INTA        ZFRNOS                         *NOSTRO
     C                   Z-ADD     MDAT          ZFRMDT                         *MAT DATE
      *
      ** Set up next interest payment date
      *
     C                   Z-ADD     W#NIPD        ZFRDAT
      *
      ** Do all interest payments prior to maturity date
      *
     C     ZFRDAT        DOWLT     MDAT
     C     ZFRDAT        ANDNE     *ZERO
      *
      * Clear event
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     ZFRDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E#EVTP
      *
      * Set up settlement details
      *
     C                   MOVEL     W#INTS        E#SETD
      *
      ** Import interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Determine next interest payment date
      *
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        ZFRDAT
      *
     C                   ENDDO
      *
      * Last interest payment is at maturity
      *
      * Clear event
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
     C                   MOVEL     'IP'          E#EVTP
      *
      * Set up settlement details
      *
     C                   MOVEL     W#INTS        E#SETD
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
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
      * MOVE 'OUR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     OUR           BEGSR
      *
     C                   MOVE      UCUCY         W#CUCY            3
     C                   Z-ADD     UPAMT         W#PAMT           13 0
     C**********         Z-ADD     UBRTT         W#BRTT            2 0                        CSD103
     C                   MOVE      UBRTT         W#BRTT            2                          CSD103
     C                   Z-ADD     UBRTE         W#BRTE           11 7
     C                   Z-ADD     URTSP         W#RTSP           11 7
     C                   Z-ADD     UEINR         W#EINR           11 7
     C                   MOVE      USPIN         W#SPIN            1
     C                   Z-ADD     UICBS         W#ICBS            1 0
     C                   Z-ADD     UINFD         W#INFD            5 0
     C                   Z-ADD     UNICD         W#NICD            5 0
     C                   Z-ADD     UICBD         W#ICBD            5 0
     C                   MOVE      UICFR         W#ICFR            1
     C                   Z-ADD     UICFD         W#ICFD            2 0
     C                   Z-ADD     UNIPD         W#NIPD            5 0
     C     W#NIPD        IFEQ      *ZERO
     C                   Z-ADD     MDAT          W#NIPD
     C                   END
     C                   Z-ADD     UIPBD         WIPBD             5 0
     C                   Z-ADD     USLIP         W#SLIP            5 0
     C                   MOVE      UIPFR         W#IPFR            1
     C                   Z-ADD     UIPFD         W#IPFD            2 0
     C                   Z-ADD     UIACD         W#IACD            5 0
     C                   Z-ADD     UAITC         W#AITC           13 0
     C                   Z-ADD     UAIAN         W#AIAN           13 0
     C                   Z-ADD     UAIAP         W#AIAP           13 0
     C                   Z-ADD     UIPRD         W#IPRD           13 0
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
     C                   MOVE      TCUCY         W#CUCY            3
     C                   Z-ADD     TPAMT         W#PAMT           13 0
     C**********         Z-ADD     TBRTT         W#BRTT            2 0                        CSD103
     C                   MOVE      TBRTT         W#BRTT            2                          CSD103
     C                   Z-ADD     TBRTE         W#BRTE           11 7
     C                   Z-ADD     TRTSP         W#RTSP           11 7
     C                   Z-ADD     TEINR         W#EINR           11 7
     C                   MOVE      TSPIN         W#SPIN            1
     C                   Z-ADD     TICBS         W#ICBS            1 0
     C                   Z-ADD     TINFD         W#INFD            5 0
     C                   Z-ADD     TNICD         W#NICD            5 0
     C                   Z-ADD     TICBD         W#ICBD            5 0
     C                   MOVE      TICFR         W#ICFR            1
     C                   Z-ADD     TICFD         W#ICFD            2 0
     C                   Z-ADD     TNIPD         W#NIPD            5 0
     C     W#NIPD        IFEQ      *ZERO
     C                   Z-ADD     MDAT          W#NIPD
     C                   END
     C                   Z-ADD     TIPBD         WIPBD             5 0
     C                   Z-ADD     TSLIP         W#SLIP            5 0
     C                   MOVE      TIPFR         W#IPFR            1
     C                   Z-ADD     TIPFD         W#IPFD            2 0
     C                   Z-ADD     TIACD         W#IACD            5 0
     C                   Z-ADD     TAITC         W#AITC           13 0
     C                   Z-ADD     TAIAN         W#AIAN           13 0
     C                   Z-ADD     TAIAP         W#AIAP           13 0
     C                   Z-ADD     TIPRD         W#IPRD           13 0
     C                   MOVE      TDNSI         W#DNSI            1
     C                   MOVE      TDSTI         W#DSTI            1
      *
     C                   ENDSR
      **************************************************************************
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
     C                   EVAL      W#TYPE = 'PCFCO'                                           208221
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
(c) Finastra International Limited 2001
** TABSEQ/TABTYP. DEAL TYPES
RPBCAP BOUGHT
RPSCAP SOLD
RFBFLOOR BOUGHT
RFSFLOOR SOLD
RRBCOLLAR BOUGHT
RRSCOLLAR SOLD
