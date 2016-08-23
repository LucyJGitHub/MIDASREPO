     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract of securities trades')      *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTSTRD - Projected Extract for Securities Trades          *
      *                                                               *
      *  Function:  This module is called by DEPXCSTRD. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of counterparty exposure within CCRM.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSE075             Date 17Nov05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS006             Date 21Jan03               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *           (Re-compile)                                        *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FPRICM     IF   E           K DISK    INFSR(*PSSR)
 
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
      **  Trade types
     D TABCDE          S              2    DIM(2) CTDATA PERRCD(1)
     D TABTYP          S             16    DIM(2) ALT(TABCDE)
 
 
     D TRADS         E DS                  EXTNAME(TRADSD) PREFIX(TR_)
     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D INVTP         E DS                  EXTNAME(INVTPD) PREFIX(IN_)
 
 
     D W#SETI          DS
     D  W#SETM                 1      2
     D***W#SETA*                3     14                                                      CGL029
     D***W#SETB*               15     17                                                      CGL029
     D***W#SETY*               18     20                                                      CGL029
     D  W#SETA                 3     20                                                       CGL029
     D  W#SETB                21     23                                                       CGL029
     D  W#SETY                24     26                                                       CGL029
 
 
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
     C                   PARM                    TRADS
     C                   PARM                    SECTY
     C                   PARM                    INVTP
     C                   PARM                    BFCLAS            1
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      ** INITIAL PROCESSING FOR SECURITIES TRADE
      *
     C                   EXSR      INIT
      *
      ** MAIN PROCESSING
      *
     C     I#ACTN        IFNE      'D'
     C                   EXSR      MAIN
     C                   ENDIF
      *
      * COMMITMENT PROCESSING FOR SECURITIES TRADE
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR SECURITIES TRADE
      *****************************************************************
     C     INIT          BEGSR
      *
      * Clear Transaction Details
      *
     C                   CLEAR                   T#TRAN
      *
      * Module
     C                   MOVEL     'SE'          T#MOD
      *
      * Transaction Reference
     C                   EVAL      T#TREF = TR_TDSS + '-' + TR_TDRF
      *
      * Transaction Type
     C                   MOVEL     BFCLAS        T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     *BLANK        T#TRST
      *
      * Transaction Description
      *
     C     TR_TDTP       LOOKUP    TABCDE        TABTYP                   99    *
     C                   MOVEL     TABTYP        T#TDES
      *
      * Deal Date
     C                   Z-ADD     TR_TDDT       T#DDAT                           Midas day no.
      *
      * Value Date
     C                   Z-ADD     TR_TDVD       T#VDAT                           Midas day no.
      *
      * Maturity Date
     C                   Z-ADD     TR_TDVD       T#MDAT                           Midas day no.
      *
      * Booking Branch
     C                   MOVEL     TR_TDBA       T#BRCA
      *
      * Book
     C                   MOVEL     TR_TDBK       T#BOOK
      *
      * Counterparty
     C                   MOVEL     TR_TCNR       T#CPTY
      *
      * Risk Customer
     C                   MOVEL     TR_TCNR       T#RCST
      *
      * Get nominal & settlement currency decimal places
      *
     C                   MOVEL     SE_NMCY       @CYCD
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        NomCcyDec         1 0
      *
     C                   MOVEL     TR_SETC       @CYCD
     C                   EXSR      ACSCCY
     C                   Z-ADD     A6NBDP        SetCcyDec         1 0
     C                   Z-ADD     A6SPDY        SetCcySPD         3 0
      *
      * Determine market value of countervalue
      * (as long as no settlement has occurred yet)
      *
     C     TR_NOML       IFEQ      TR_TOSN
     C                   EXSR      MRKTVAL
     C                   Z-ADD     CvalSetc      T#MKVL
     C                   MOVEL     TR_SETC       T#VCCY
     C                   Z-ADD     SetCcyDec     T#VCDP
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
      **  Store trade settlement method, account, branch and currency
      *
     C     TR_TDTP       IFEQ      'TP'
     C                   MOVE      TR_SMTH       W#SETM                         * settle method
     C                   MOVE      TR_PYFM       W#SETA                         * settle A/C
     C                   MOVE      TR_PYFA       W#SETB                         * settle branch
     C                   MOVE      TR_SETC       W#SETY                         * settle currency
     C                   ELSE
     C                   MOVE      TR_SMTH       W#SETM                         * settle method
     C                   MOVE      TR_PAYT       W#SETA                         * settle A/C
     C                   MOVE      TR_PYTA       W#SETB                         * settle branch
     C                   MOVE      TR_SETC       W#SETY                         * settle currency
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
      *
      * IMPORT DEAL DATE EVENT
      * (trade's trade date)
      *
     C                   EXSR      IMP_DD
      *
      * IMPORT MATURITY DATE EVENT
      * (trade's value date)
      *
     C                   EXSR      IMP_MT
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
     C                   Z-ADD     TR_TDDT       P#IACD                           Midas day no.
      *
      * Nominal/Principal
      * = outstanding (i.e unsettled) value in settlement currency
      *
     C                   Z-ADD     TR_TOSV       P#NOML
      *
      * Currency
     C                   MOVEL     TR_SETC       P#CCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     SetCcyDec     P#NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     SetCcyDec     P#NMDP
      *
      * Nominal Ccy Spot Days
     C                   Z-ADD     SetCcySPD     P#SPDY
      *
      * Security
     C                   MOVEL     'Y'           P#SECU
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
     C                   Z-ADD     TR_TDDT       E#PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E#EVTP
      *
      * Processed?
      *
     C                   TESTB     '0'           TR_TACI                  99    *
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
     C                   Z-ADD     TR_TDVD       E#PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E#EVTP
      *
      * Total amount (countervalue)
     C                   Z-ADD     TR_TOSV       E#TAMT
      *
      * Incoming/outgoing indicator
     C     TR_TDTP       IFEQ      'TP'
     C                   MOVEL     'O'           E#IO
     C                   ELSE
     C                   MOVEL     'I'           E#IO
     C                   ENDIF
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#SETI        E#SETD                         * Rec details
      *
      * Processed?
      *
     C                   TESTB     '1'           TR_TACI                  99    *
     C   99              MOVE      'Y'           E#PRCD
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
      * DETERMINE 'MARKET VALUE' OF COUNTERVALUE
      ********************************************************************
     C     MRKTVAL       BEGSR
      *
      * Initialize output countervalue in settlement currency
      *
     C                   Z-ADD     *ZERO         CvalSetc
      *
      * Get current market price
      *
     C     TR_TDSS       SETGT     PRICEDF
     C     TR_TDSS       READPE    PRICEDF                                99    *
     C     *IN99         DOWEQ     '0'
     C     RECI          ANDNE     'D'
     C     TR_TDSS       READPE    PRICEDF                                99    *
     C                   ENDDO
      *
      * If no market price, use security market price
      *
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     SE_MKPR       PPRC
     C                   ENDIF
      *
      * If market price is zero, bypass
      *
     C     PPRC          IFEQ      *ZERO
     C                   GOTO      E_MRKTVAL
     C                   ENDIF
      *
      * If this is a price traded security, the market price is as defined
      *
     C     SE_STBS       IFEQ      'P'
     C                   Z-ADD     PPRC          Mkt_Price        15 8
      *
      * Otherwise, if this is a yield or discount traded security
      *
     C                   ELSE
      *
      ** Calculate PI as a fraction of Nominal
      *
     C     TR_NOML       IFNE      0
     C     TR_ITRA       DIV       TR_NOML       WRKPI
     C                   ELSE
     C                   Z-ADD     0             WRKPI
     C                   END
      *
      ** Calculate % price from yield/discount
      *
     C                   CALLB     'ZPRCI'
     C                   PARM      PPRC          ZPRCIN           15 8
     C                   PARM      I#RDNB        ZFDATE            5 0
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
     C                   PARM      IN_PROT       ZPROT             1
     C                   PARM      TR_NOML       ZNOML            15 0
     C                   PARM                    WRKPI            15 9
     C                   PARM      TR_ACIN       SCUMEX            1
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ZYLDOk            1
     C                   PARM      *ZERO         ZPRCOT           15 8
 
     C                   Z-ADD     ZPRCOT        Mkt_Price
 
     C                   ENDIF
 
      * Calculate trade countervalue (in nominal currency)
 
     C                   CALLB     'ZCOTR'
     C                   PARM                    TR_NOML
     C                   PARM                    Mkt_Price
     C                   PARM                    TR_RALL
     C                   PARM                    TR_ITRA
     C                   PARM                    TR_TBCA
     C                   PARM                    TR_TCCA
     C                   PARM                    TR_TCA1
     C                   PARM                    TR_TCA2
     C                   PARM                    TR_TCA3
     C                   PARM                    TR_TCA4
     C                   PARM                    TR_TCA5
     C                   PARM                    TR_TCA6
     C                   PARM                    TR_TCA7
     C                   PARM                    TR_TAXA
     C                   PARM                    IN_PROT
     C                   PARM                    SE_SPBS
     C                   PARM                    SE_CFCT
     C                   PARM                    SE_NMCY
     C                   PARM                    SE_NMDP
     C                   PARM      NomCcyDec     ZCDP              1 0
     C                   PARM      *ZERO         ZCONS            15 0
     C                   PARM      *ZERO         ZCTRVL           15 0
 
      * Exit if countervalue is zero
 
     C     ZCTRVL        CABEQ     *ZEROS        E_MRKTVAL
 
      *  Convert countervalue to settlement currency
 
     C                   CALLB     'ZCONV'
     C                   PARM      ZCTRVL        ZAMTCI           15 0
     C                   PARM      TR_TDER       ZEXCH            13 8
     C                   PARM      TR_TDMI       ZMD               1
     C                   PARM      SE_NMCY       ZCCYI             3
     C                   PARM      TR_SETC       ZCCYO             3
     C                   PARM      NomCcyDec     ZCDPI             1 0
     C                   PARM      SetCcyDec     ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
     C                   Z-ADD     ZAMTCO        CvalSetc         15 0
      *
     C     E_MRKTVAL     ENDSR
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
     C                   EVAL      W#TYPE = 'PSTRD'                                           208221
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
      *****************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY DECPYSRC,DEXTPERDI
      *****************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      *****************************************************************
      /COPY DECPYSRC,DEXTWEDTA
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TABSEQ/TABTYP. TRADE TYPES
TPTRADE PURCHASE
TSTRADE SALE
