     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj Ext of Customer Exchange deals')         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTCUSX - Projected Extract for Customer Exchanges         *
      *                                                               *
      *  Function:  This module is called by DEPXCCUSX. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE041             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG2304            Date 30Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE041 - Enhancements to Customer Exchanges (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG2304 - Various file layout changes. Recompile.            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Need to set up the switchable feature being tested  *
      *           when calling AOSARDR0.                              *
      *           Also change module from 'RE' to 'GL'                *
      *           Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
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
      **  Transaction Description
     D TRANDE          S             20    DIM(1) CTDATA PERRCD(1)
 
 
     D CUSEXCH       E DS                  EXTNAME(CUSEXCE)
     D**DBAccnt               14     25                                                       CGL029
     D**CRAccnt               84     95                                                       CGL029
 
 
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
     D**W#INTA**               3     14                                                       CGL029
     D**W#INTB**              15     17                                                       CGL029
     D**W#ISCY**              18     20                                                       CGL029
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
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)
      ** External DS for Switchable Features details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)                                  208221
      ** Extract Control Data                                                                 208221
                                                                                              208221
     D WDBacct         S             18                                                       CGL029
     D WCRacct         S             18                                                       CGL029
     D Wrk16           S             16                                                       CGL029
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
     C                   PARM                    CUSEXCH
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      * INITIAL PROCESSING FOR CUSTOMER EXCHANGE
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
      * COMMITMENT PROCESSING FOR CUSTOMER EXCHANGE
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR CUSTOMER EXCHANGE
      *****************************************************************
     C     INIT          BEGSR
      *
      * Clear Transaction Details
      *
     C                   CLEAR                   T#TRAN
      *
      * Module
     C************       MOVEL     'RE'          T#MOD                                        208221
     C                   MOVEL     'GL'          T#MOD                                        208221
      *
      * Transaction Reference
     C                   MOVEL     IPDN          T#TREF
      *
      * Transaction Type
     C                   MOVEL     'CE'          T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     *BLANKS       T#TRST
      *
      * Transaction Description
      *
     C                   MOVEL     TRANDE(1)     T#TDES
      *
      * Deal Date
     C     DRVD          IFLT      BJRDNB
     C                   Z-ADD     DRVD          T#DDAT                           Midas day no.
     C                   ELSE
     C                   Z-ADD     BJRDNB        T#DDAT                           Midas day no.
     C                   ENDIF
      *
      * Value Date
     C                   Z-ADD     DRVD          T#VDAT                           Midas day no.
      *
      * Maturity Date
     C                   Z-ADD     DRVD          T#MDAT                           Midas day no.
      *
      * Booking Branch
     C                   MOVEL     BRCA          T#BRCA
      *
      * Book
     C                   MOVEL     *blanks       T#BOOK
      *
      * Counterparty
     C**********         Z-ADD     DCUS          T#CPTY                                       CSD027
     C                   EVAL      T#CPTY = DCUS                                              CSD027
      *
      * Risk Customer
     C**********         Z-ADD     DCUS          T#RCST                                       CSD027
     C                   EVAL      T#RCST = DCUS                                              CSD027
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
     C                   MOVEL     BaseCDP       T#VCDP
 
      * IF REVENUE ANALYSIS IS PRESENT
 
     C     CDE002        IFEQ      'Y'
 
      * If no margin is present on the deal,
      * then the market value (in base currency) is the margin
 
     C     MAMT          IFEQ      *ZERO
     C                   Z-ADD     T#MKVL        FXMargin
     C                   ELSE
 
      * Otherwise convert the margin on the deal to base currency
 
     C     FXIN          IFEQ      'D'
     C                   MOVEL     DRCY          @CYCD
     C                   ELSE
     C                   MOVEL     CRCY          @CYCD
     C                   ENDIF
     C                   EXSR      ACSCCY
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      MAMT          InputAmnt        15 0
     C                   PARM      A6SPRT        ExchRate         13 8
     C                   PARM      A6MDIN        MultDivInd        1
     C                   PARM      A6CYCD        FrCurrency        3
     C                   PARM      BJCYCD        ToCurrency        3
     C                   PARM      A6NBDP        FrDecPlace        1 0
     C                   PARM      BaseCDP       ToDecPlace        1 0
     C                   PARM      *Zero         FXMargin         15 0
     C                   ENDIF
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
     C     CRAN          IFNE      0
     C                   MOVEL     '14'          W#PAYM                         * pay method
     C                   MOVEL     *BLANKS       W#PAYA                         * pay account
     C                   MOVEL     CRAN          W#PAYA                         * pay account
     C                   ELSE
     C                   MOVEL     '05'          W#PAYM                         * pay method
     C**********         MOVEL     CRAccnt       W#PAYA                         * pay account CGL029
     C                   MOVEL     CCUS          Wrk16                                        CGL029
     C                   MOVE      CCOD          Wrk16                                        CGL029
     C                   MOVEL     Wrk16         WCRacct                                      CGL029
     C                   MOVE      CACS          WCRacct                                      CGL029
     C                   EVAL      W#PAYA = WCRacct                                           CGL029
     C                   END
     C
     C                   MOVEL     CBRC          W#PAYB                         * pay branch
     C                   MOVEL     CRCY          W#PSCY                         * pay settle ccy
      *
     C     DRAN          IFNE      0
     C                   MOVEL     '14'          W#RECM                         * Rec method
     C                   MOVEL     *BLANKS       W#RECA                         * Rec account
     C                   MOVEL     DRAN          W#RECA                         * Rec account
     C                   ELSE
     C                   MOVEL     '05'          W#RECM                         * Rec method
     C**********         MOVEL     DBAccnt       W#RECA                         * Rec account CGL029
     C                   MOVEL     DCUS          Wrk16                                        CGL029
     C                   MOVE      DCOD          Wrk16                                        CGL029
     C                   MOVEL     Wrk16         WCRacct                                      CGL029
     C                   MOVE      DACS          WCRacct                                      CGL029
     C                   EVAL      W#RECA = WDBacct                                           CGL029
     C                   END
     C
     C                   MOVEL     DRBR          W#RECB                         * rec branch
     C                   MOVEL     DRCY          W#RSCY                         * rec settle ccy
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
     C                   EXSR      IMP_DD
      *
      * IMPORT FEE PAYMENT DATE EVENT (CHARGES)
      *
     C     HAMT          IFNE      *ZERO
     C     HSGN          ANDEQ     '+'
     C     W#ASLI        ANDEQ     'A'
     C     HAMT          ORNE      *ZERO
     C     HSGN          ANDEQ     '-'
     C     W#ASLI        ANDEQ     'L'
     C                   EXSR      IMP_FE
     C                   ENDIF
      *
      * IMPORT FOREIGN EXCHANGE MARGIN EVENT
      *
     C     CDE002        IFEQ      'Y'
     C     W#ASLI        ANDEQ     'A'
     C                   EXSR      IMP_XM
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
     C                   Z-ADD     T#DDAT        P#IACD                         *
      *
      * Nominal/Principal
     C                   Z-ADD     W#AMT         P#NOML
     C     I#PH          IFEQ      'P'
     C     I#EOB         ANDEQ     'N'
     C                   Z-ADD     P#NOML        P#DIFN
     C                   ENDIF
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
     C                   Z-ADD     T#DDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E#EVTP
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
      * IMPORT FOREIGN EXCHANGE MARGIN EVENT
      *****************************************************************
     C     IMP_XM        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Processing Date
     C                   Z-ADD     T#DDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'XM'          E#EVTP
      *
      * FX Margin
      *
     C                   Z-ADD     FXMargin      E#FXMG
      *
      * Import Fx margin event
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT FEE PAYMENT DATE EVENT (CHARGES)
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
     C                   Z-ADD     T#DDAT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'FE'          E#EVTP
      *
      * Charge amount
     C                   Z-ADD     HAMT          E#CHRG
 
      * Currency decimal places
      *
     C                   MOVEL     A6NBDP        E#NCDP
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E#SSET
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
     C                   MOVE      DRCY          W#CCY             3
     C                   Z-ADD     DRAM          W#AMT            13 0
     C                   Z-ADD     DRVD          W#DAT             5 0
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
     C                   MOVE      CRCY          W#CCY
     C                   Z-ADD     CRAM          W#AMT
     C                   Z-ADD     CRVD          W#DAT
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      *********************************************************************
      * REVALUE CUSTOMER EXCHANGE DEAL
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
     C                   PARM      W#DAT         EDAT              5 0
     C                   PARM      W#AMT         EAMT             13 0
     C                   PARM      BCEQ          DBCE             13 0
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
      **  Confirm whether CCRM Revenue Analysis available
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C***********        PARM      '      '      @SARD             6                          208221
     C                   PARM      'CDE002'      @SARD             6                          208221
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDE002            1
     C                   ELSE
     C                   MOVEL     'N'           CDE002
     C                   END
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'PCUSX'                                           208221
 
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
** TRANDE - TRANSACTION DESCRIPTION
CUST.EXCHANGE
