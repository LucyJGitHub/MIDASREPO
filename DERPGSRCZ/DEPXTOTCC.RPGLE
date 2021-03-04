     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected ext of (F & O) OTC options')        *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTOTCC - Projected Extract for Financial Futures OTCs     *
      *                                                               *
      *  Function:  This module is called by DEPXCOTCC. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 215528             Date 21Mar03               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID                        *
      *  215528 - System is associating a wrong premium amount.       *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *           On take on date, do not flag any events as processed*
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
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
      **  Instrument types
     D TABCDE          S              1S 0 DIM(8) CTDATA PERRCD(1)
     D TABTYP          S             16    DIM(8) ALT(TABCDE)
 
 
     D TRANS         E DS                  EXTNAME(TRANSD) PREFIX(TR_)
     D TRSET         E DS                  EXTNAME(TRSETD) PREFIX(TS_)
     D INTYP         E DS                  EXTNAME(INTYPD) PREFIX(IN_)
     D PRICS         E DS                  EXTNAME(PRICSD) PREFIX(PC_)
 
 
     D W#TABT          DS
     D  W#TDES                 1     16
 
 
     D W#SETD          DS
     D  W#SETM                 1      2
     D***W#SETA*                3     14                                                      CGL029
     D***W#SETB*               15     17                                                      CGL029
     D***W#SETC*               18     20                                                      CGL029
     D  W#SETA                 3     20                                                       CGL029
     D  W#SETB                21     23                                                       CGL029
     D  W#SETC                24     26                                                       CGL029
 
 
      ** Instrument type
     D FFISPT          S              1S 0
      ** Contract type
     D FFCNTT          S              1S 0
 
 
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
     C                   PARM                    TRANS
     C                   PARM                    TRSET
     C                   PARM                    INTYP
     C                   PARM                    PRICS
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      * INITIAL PROCESSING FOR F&O OTC OPTION
      *
     C                   MOVEL     Dataarea      DEEXTCTL                                     208221
     C                   EXSR      INIT
      *
      ** MAIN PROCESSING - DELIVERY CURRENCY
      *
     C     I#ACTN        IFNE      'D'
     C                   MOVE      'D'           W#DC              1
     C                   EXSR      MAIN
      *
      ** MAIN PROCESSING - COUNTER CURRENCY (IF FOREX OPTION)
      *
     C     IN_ISPT       IFEQ      5
     C                   MOVE      'C'           W#DC
     C                   EXSR      MAIN
     C                   ENDIF
     C                   ENDIF
      *
      * COMMITMENT PROCESSING FOR F&O OTC OPTION
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR F&O OTC OPTION
      *****************************************************************
     C     INIT          BEGSR
      *
      * Clear Transaction Details
      *
     C                   CLEAR                   T#TRAN
      *
      * Module
     C                   MOVEL     'FF'          T#MOD
      *
      * Transaction Reference
     C                   MOVEL     TR_TNBR       T#TREF
      *
      * Transaction Type
     C                   MOVEL     TR_TRTY       T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     TR_PCAL       T#TRST
      *
      * Transaction Description
      *
     C     IN_ISPT       LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        W#TABT
     C                   MOVEL     W#TDES        T#TDES
      *
      * Deal Date
     C                   Z-ADD     TR_TRSD       T#DDAT                           Midas day no.
      *
      * Value Date
     C                   Z-ADD     TR_VALD       T#VDAT                           Midas day no.
      *
      * Maturity Date (settlement date)
      *
     C                   Z-ADD     IN_SETD       T#MDAT
      *
      * Booking Branch
     C                   MOVEL     TR_BRCA       T#BRCA
      *
      * Book
     C                   MOVEL     TR_BOKC       T#BOOK
      *
      * Counterparty
     C                   MOVEL     TR_CUSC       T#CPTY
      *
      * Risk Customer
     C                   MOVEL     TR_CUSC       T#RCST
      *
      * Market value
      * If transaction value date later than extract date, set to premium,
      * else calculate market value if price defined.
      *
     C*****T#VDAT********IFGE******I#EXTD***********************************    CDE002
     C     T#VDAT        IFGE      BJRDNB                                       CDE002
 
     C                   Z-ADD     TR_COPR       FFPRIC
     C                   EXSR      FFPMCL
     C                   Z-ADD     FFPREM        T#MKVL
 
     C                   ELSE
 
     C     PC_NEWP       IFNE      *ZERO
 
     C                   Z-ADD     PC_NEWP       FFPRIC
     C                   EXSR      FFPMCL
     C                   Z-ADD     FFPREM        MktVal           13 0
 
     C                   Z-ADD     TR_COPR       FFPRIC
     C                   EXSR      FFPMCL
 
     C     TR_TRTY       IFEQ      'P'
     C     MktVal        SUB       FFPREM        T#MKVL
     C                   ELSE
     C     FFPREM        SUB       MktVal        T#MKVL
     C                   ENDIF
 
     C                   ELSE
     C                   Z-ADD     *ZERO         T#MKVL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEL     IN_ISCY       T#VCCY
     C                   MOVEL     IN_ISCY       @CYCD
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
      **  Store settlement method, account & branch
      *
     C                   MOVEL     TS_CSLT       W#SETM                         * pay method
     C                   MOVEL     TS_CSLA       W#SETA                         * pay account
     C                   MOVEL     TS_BRSC       W#SETB                         * pay branch
     C                   MOVEL     IN_ISCY       W#SETC
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
      ** SET UP WORK FIELDS WITH DELIVERY OR COUNTER CURRENCY DETAILS
      *
     C     W#DC          CASEQ     'D'           DELCCY
     C     W#DC          CASEQ     'C'           CNTCCY
     C                   ENDCS
      *
      * IMPORT OPENING BALANCE
      *
     C                   EXSR      IMP_OPBL
      *
      * IMPORT FEE PAYMENT DATE EVENT
      *
     C     W#DC          IFEQ      'D'
     C                   EXSR      IMP_FE
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
     C                   Z-ADD     TR_TRSD       P#IACD                         *
      *
      * Nominal/Principal
     C                   Z-ADD     W#AMT         P#NOML                         *
     C     I#PH          IFEQ      'P'                                                        CDE002
     C     I#EOB         ANDEQ     'N'                                                        CDE002
     C                   Z-ADD     P#NOML        P#DIFN                                       CDE002
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
      *
      * Stop Accruals
     C                   MOVEL     'Y'           P#STAC
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
     C                   Z-ADD     TR_VALD       E#PRDT
      *
      * Event Type
     C                   MOVEL     'FE'          E#EVTP
      *
      * Commissions = Customer Commission Amount
      *
     C                   Z-ADD     TS_CCMA       E#COMM
      *
      * Fees = premium paid
      *
     C                   Z-ADD     TS_PRMP       E#FEE
      *
      * Settlement currency decimal places
      *
     C                   MOVEL     T#VCDP        E#NCDP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#SETD        E#SETD                         * Rec details
      *
      * Processed?
      *
     C     TR_ECPI       IFEQ      'Y'
     C                   MOVE      'Y'           E#PRCD
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
     C                   ENDIF
      *
      ** Incoming/outgoing
      *
     C     TR_TRTY       IFEQ      'P'
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
     C                   Z-ADD     IN_SETD       E#PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E#EVTP
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E#SSET
      *
      * Processed?
      *
     C     TR_ECPI       IFEQ      'Y'
     C                   MOVE      'Y'           E#PRCD
     C     I#EOB         IFEQ      'N'                                                        208221
     C     DETKON        ANDEQ     I#RDNB                                                     208221
     C                   MOVE      *BLANKS       E#PRCD                                       208221
     C                   END                                                                  208221
     C                   ENDIF
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
      * MOVE DELIVERY CURRENCY DETAILS TO WORK FIELDS
      ********************************************************************
     C     DELCCY        BEGSR
      *
      * If FOREX option, 'other' currency is currency of delivery amount
      * (the contingent amount)
      *
     C     IN_ISPT       IFEQ      5
     C                   MOVE      IN_OTHC       W#CCY             3
     C                   ELSE
     C                   MOVE      IN_ISCY       W#CCY             3
     C                   ENDIF
 
     C     TR_NOCO       MULT      IN_CTAM       W#AMT            13 0
      *
      ** Delivery amount is incoming if bought call or sold put
      *
     C     TR_TRTY       IFEQ      'P'
     C     TR_PCAL       ANDEQ     'C'
     C     TR_TRTY       OREQ      'S'
     C     TR_PCAL       ANDEQ     'P'
     C     IN_ISPT       ORNE      5
     C                   MOVE      'A'           W#ASLI            1
     C                   ELSE
     C                   MOVE      'L'           W#ASLI
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE COUNTER CURRENCY DETAILS TO WORK FIELDS
      ********************************************************************
     C     CNTCCY        BEGSR
 
      * A FOREX option has a counter currency amount
 
     C                   MOVE      IN_CTCY       W#CCY             3
     C     TR_NOCO       MULT      IN_CCAM       W#AMT            13 0
      *
      ** Counter amount is incoming if sold call or bought put
      *
     C     TR_TRTY       IFEQ      'S'
     C     TR_PCAL       ANDEQ     'C'
     C     TR_TRTY       OREQ      'P'
     C     TR_PCAL       ANDEQ     'P'
     C                   MOVE      'A'           W#ASLI
     C                   ELSE
     C                   MOVE      'L'           W#ASLI
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * PREMIUM CALCULATION
      ********************************************************************
     C     FFPMCL        BEGSR
 
     C                   CALLB     'FFPMCL'
     C                   PARM      *ZERO         FFPREM           13 0
     C                   PARM      TR_NOCO       FFNOC             5 0
     C                   PARM                    FFPRIC           15 8
     C                   PARM      IN_TKDM       FFTKDM            3 0
     C                   PARM      IN_MNPF       FFMNPF           15 8
     C                   PARM      IN_TKVL       FFTKVL           14 5
     C                   PARM      IN_ISPT       FFISPT
     C                   PARM      IN_CNTT       FFCNTT
     C                   PARM      IN_CTAM       FFCTAM           13 0
     C                   PARM      TR_STRP       FFSTRP           15 8                        215528
 
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
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'POTCC'                                           208221
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
1INTR RATE FUTURE
2EXCH RATE FUTURE
3COMMODITY FUTURE
4INTR RATE OPTION
5EXCH RATE OPTION
6COMMODITY OPTION
7INTR RATE FUTURE
8INTR RATE OPTION
