     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Proj ext of securities book positions')       *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTSBPS - Projected Extract for Securities Book Positions  *
      *                                                               *
      *  Function:  This module is called by DEPXCSBPS. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of issuer exposure within CCRM.         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 28Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11164           Date 06Apr06               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
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
      *           If Long Term Indicator is set, make the maturity    *
      *           date 31/12/2071 to stop looping                     *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CSD006 - Recompiled over changed SDCURRPD.                   *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FTRDMTHT   IF   E           K DISK    RENAME(TRADSDF:TRADSDF_T)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_T)
     FTRDMTH    IF   E           K DISK    RENAME(TRADSDF:TRADSDF_V)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_V)
     FPRICM     IF   E           K DISK    INFSR(*PSSR)
     FSECET     IF   E           K DISK    INFSR(*PSSR)
 
     F*DEPTRNAPD*O** E           K DISK    USROPN                                             CDE002
     FDEPTRANPD O    E           K DISK    RENAME(DETRANP0:DEPTRANP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)
     F*DEPPOSNPD*O** E           K DISK    USROPN                                             CDE002
     FDEPPOSNPD O    E           K DISK    RENAME(DEPOSNP0:DEPPOSNP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)
     F*DEPEVNTPD*O** E           K DISK    USROPN                                             CDE002
     FDEPEVNTPD O    E           K DISK    RENAME(DEEVNTP0:DEPEVNTP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)
     F*DEPCASHPD*O** E           K DISK    USROPN                                             CDE002
     FDEPCASHPD O    E           K DISK    RENAME(DECASHP0:DEPCASHP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)
 
     FDEHTRANPD O    E           K DISK    RENAME(DETRANP0:DEHTRANP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)                                       CDE002
     FDEHPOSNPD O    E           K DISK    RENAME(DEPOSNP0:DEHPOSNP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)                                       CDE002
     FDEHEVNTPD O    E           K DISK    RENAME(DEEVNTP0:DEHEVNTP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)                                       CDE002
     FDEHCASHPD O    E           K DISK    RENAME(DECASHP0:DEHCASHP0) USROPN                  CDE002
     F                                     INFSR(*PSSR)                                       CDE002
 
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
 
 
     D BKPHD         E DS                  EXTNAME(BKPHDD)
     D BKPHD_RECI    E                     EXTFLD(RECI)
     D BKPHD_TNLU    E                     EXTFLD(TNLU)
     D BKPOS         E DS                  EXTNAME(BKPOSD)
     D BKPOS_RECI    E                     EXTFLD(RECI)
     D BKPOS_TNLU    E                     EXTFLD(TNLU)
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SECTY_RECI    E                     EXTFLD(RECI)
     D SECTY_ZZ05    E                     EXTFLD(ZZ005)
     D SECTY_TNLU    E                     EXTFLD(TNLU)
     D CDArr                 183    230
     D CRArr                 231    242
     D INVTP         E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(IN_)
 
 
     D                 DS
     D  W#POSID                1     20
     D  W#BHSC                 1     10
     D  W#BHBK                12     13
     D  W#BHBA                15     17
     D  W#BHMK                19     19
 
     D W#PAYD          DS
     D  W#PAYM                 1      2
     D  W#PAYA                 3     14
     D  W#PAYB                15     17
     D  W#PSCY                18     20
     D W#RECD          DS
     D  W#RECM                 1      2
     D  W#RECA                 3     14
     D  W#RECB                15     17
     D  W#RSCY                18     20
     D W#POSS          DS
     D  W#POSM                 1      2
     D***W#POSA*                3     14                                                      CGL029
     D***W#POSB*               15     17                                                      CGL029
     D***W#POSY*               18     20                                                      CGL029
     D  W#POSA                 3     20                                                       CGL029
     D  W#POSB                21     23                                                       CGL029
     D  W#POSY                24     26                                                       CGL029
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for SECURITIES TRADING details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      ** External DS for BOOK details
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)                                  208221
      ** Extract Control Data                                                                 208221
 
     ISEDEVDF
     I              RECI                        SEDEV_RECI
     I              NMCY                        SEDEV_NMCY
 
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
     C                   PARM                    BKPHD
     C                   PARM                    BKPOS
     C                   PARM                    SECTY
     C                   PARM                    INVTP
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      ** INITIAL PROCESSING FOR BOOK POSITION
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
      * COMMITMENT PROCESSING FOR BOOK POSITION
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR BOOK POSITION
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
     C                   MOVEL     BHSC          W#BHSC
     C                   MOVEL     BHBK          W#BHBK
     C                   MOVEL     BHBA          W#BHBA
     C                   MOVEL     BHMK          W#BHMK
     C                   MOVEL     W#POSID       T#TREF
      *
      * Transaction Type
     C                   MOVEL     SITP          T#TRTP
      *
      * Transaction Sub-Type
     C                   MOVEL     NMCY          T#TRST
      *
      * Transaction Description
      *
     C                   MOVEL     SRPN          T#TDES
      *
      * Trade Date
     C                   Z-ADD     LPSD          T#DDAT                           Midas day no.
      *
      * Value Date
     C                   Z-ADD     LPSD          T#VDAT                           Midas day no.
      *
      * Maturity Date
     C     LTMI          IFEQ      'Y'                                                        208221
     C                   Z-ADD     36525         MATY                                         208221
     C                   ENDIF                                                                208221
     C                   Z-ADD     MATY          T#MDAT                           Midas day no.
      *
      * Booking Branch
     C                   MOVEL     BHBA          T#BRCA
      *
      * Book
     C                   MOVEL     BHBK          T#BOOK
      *
      * Get book details
      *
     C     BHBK          IFNE      @BOOK
     C                   MOVEL     BHBK          @BOOK
     C                   EXSR      ACSBOK
     C                   ENDIF
      *
      * Counterparty
     C                   MOVEL     ISSR          T#CPTY
      *
      * Risk Customer
     C                   MOVEL     ISSR          T#RCST
      *
      * Local industry
     C                   MOVEL     SIDY          T#LICD
      *
      * Country
     C                   MOVEL     SCOR          T#CNCD
      *
      * Issuer Exposure
     C                   MOVEL     'Y'           T#ISEI
      *
      * Determine market price of security
      *
     C                   EXSR      MRKTPRC
      *
      * Valuation Currency
     C                   MOVEL     NMCY          T#VCCY
      *
      * Valuation Ccy Dec Places = nominal currency decimal places
     C                   MOVEL     NMCY          @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        NomCcyDec         1 0
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
     C                   MOVEL     '*IMPTRAN  '  W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      ** Set up position settlement instructions
      *
     C                   MOVE      *BLANK        W#POSM                         * settle method
     C                   MOVE      *BLANK        W#POSA                         * settle A/C
     C                   MOVE      *BLANK        W#POSB                         * settle branch
     C                   MOVE      *BLANK        W#POSY                         * settle currency
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
      * If interest bearing
      * IMPORT INTEREST PAYMENT DATE EVENTS
      *
     C     MATY          IFNE      *ZERO
     C     CRArr         ANDNE     *BLANK
     C                   EXSR      IMP_IP
     C                   ENDIF
      *
      * If interest bearing
      * IMPORT INTEREST RATE CHANGE DATE EVENTS
      *
     C     MATY          IFNE      *ZERO
     C     CRArr         ANDNE     *BLANK
     C                   EXSR      IMP_IR
     C                   ENDIF
      *
      * IMPORT PART PAYMENT DATE EVENTS
      *
     C     PPDI          IFEQ      'Y'
     C                   EXSR      IMP_PP
     C                   END
      *
      * IMPORT MORTGAGE PAYMENT DATE EVENTS
      *
     C     IN_PROT       IFEQ      '8'
     C                   EXSR      IMP_MP
     C                   END
      *
      * If date present
      * IMPORT MATURITY DATE EVENT
      *
     C     MATY          IFNE      *ZERO
     C                   EXSR      IMP_MT
     C                   ENDIF
      *
      * IMPORT TRADE EVENTS
      *
     C                   EXSR      IMP_TRAD
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
     C     NPSN          IFLT      0
     C                   MOVEL     'L'           P#ASLI
     C                   ELSE
     C                   MOVEL     'A'           P#ASLI
     C                   ENDIF
      *
      * Interest Accrl Ctl Date
     C                   Z-ADD     LPSD          P#IACD                           Midas day no.
      *
      * Nominal/Principal
     C                   Z-ADD     NPSN          W#NOML
     C                   EXSR      CNV_NOML
     C                   Z-ADD     W#NOML        P#NOML
     C     I#PH          IFEQ      'P'                                                        CDE002
     C     I#EOB         ANDEQ     'N'                                                        CDE002
     C                   Z-ADD     P#NOML        P#DIFN                                       CDE002
     C                   ENDIF                                                                CDE002
      *
      * Ex-coupon nominal
     C                   Z-ADD     ECNP          W#NOML
     C                   EXSR      CNV_NOML
     C                   Z-ADD     W#NOML        P#XNML
      *
      * Consideration
     C                   Z-ADD     APNC          P#CONS
      *
      * Discount
     C     SPBS          IFEQ      'P'
      *
      * Adjust nominal if partly-paid
     C     PPDI          IFEQ      'Y'
     C                   MOVE      'PP'          SDET
     C     SEDEVKF       SETGT     SEDEVDF
     C     SEDEVK        READPE    SEDEVDF                                99
     C                   Z-ADD     *ZERO         PP_Pric          15 0
     C     *IN99         IFEQ      '0'
     C                   MOVE      SDTP          PP_Pric
     C                   ELSE
     C                   MOVE      CPDP          PP_Pric
     C                   ENDIF
     C     SFPP          IFNE      PP_Pric
     C     SFPP          ANDNE     0
     C     PP_Pric       DIV       SFPP          PP_Percnt        10 9
     C                   ELSE
     C                   Z-ADD     1             PP_Percnt
     C                   ENDIF
     C     P#NOML        MULT      PP_Percnt     PP_Noml          15 0
     C     PP_Noml       SUB       APNC          P#DIPR
     C                   ELSE
     C     P#NOML        SUB       APNC          P#DIPR
     C                   ENDIF
 
     C                   ENDIF
      *
      * Average Price
     C                   Z-ADD     APPB          P#AVPR
      *
      * Purchased interest
     C                   Z-ADD     PILP          P#PINT
      *
      * Currency
     C                   MOVEL     NMCY          P#CCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     NomCcyDec     P#NCDP
      *
      * Nominal Dec Places
     C     IN_PROT       IFEQ      '1'
     C     IN_PROT       OREQ      '3'
     C     IN_PROT       OREQ      '5'
     C     IN_PROT       OREQ      '6'
     C     IN_PROT       OREQ      '8'
     C     IN_PROT       OREQ      '9'
     C                   MOVEL     NomCcyDec     P#NMDP
     C                   ELSE
     C                   MOVEL     NMDP          P#NMDP
     C                   ENDIF
      *
      * Nominal Ccy Spot Days
     C                   Z-ADD     A6SPDY        P#SPDY
      *
      * Int Calc Method
     C     DYBS          IFNE      ' '
     C     DYBS          ANDNE     '4'
 
     C                   MOVEL     DYBS          W#DYBS
     C                   MOVEL     DVBS          W#DVBS
     C                   CALLB     'DECVTICSE'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM                    W#DYBS            1 0          * DAY BASIS
     C                   PARM                    W#DVBS            1 0          * DIV BASIS
     C                   PARM      *BLANK        W#ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECVTICSE'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W#ICMT        P#ICMT
 
     C                   ENDIF
      *
      * Initialization for determination of next interest payment date
      *
     C                   MOVEL     '*INIT     '  W#MODE_SIP
     C                   EXSR      GETSIPD
      *
      * Int Payments/Year
     C                   Z-ADD     W#IPY         P#IPY
      *
      * Accrue Negative Balance
     C                   MOVEL     'Y'           P#ACNG
      *
      * Accrue interest
     C     DYBS          IFNE      ' '
     C     DYBS          ANDNE     '4'
     C                   MOVE      'Y'           P#ACIN
     C                   ENDIF
      *
      * Accrue discount/premium
     C     DYBS          IFNE      ' '
     C     DYBS          ANDNE     '4'
     C     BDSTAM        IFEQ      'Y'
     C     STBS          OREQ      'D'
     C     BVGDPK        ANDEQ     'Y'
     C                   MOVE      'Y'           P#ACDP
     C                   ENDIF
     C                   ENDIF
      *
      * Security
     C                   MOVEL     'Y'           P#SECU
      *
      * Security price basis
     C                   MOVEL     SPBS          P#SPBS
      *
      * Yen Bond?
     C     IN_PROT       IFEQ      '5'
     C                   MOVEL     'Y'           P#YBON
     C                   ENDIF
      *
      * Schuldschein?
     C     IN_PROT       IFEQ      '6'
     C                   MOVEL     'Y'           P#SCHU
     C                   ENDIF
      *
      * Mortgage backed bond?
     C     IN_PROT       IFEQ      '8'
     C                   MOVEL     'Y'           P#MORT
     C                   ENDIF
      *
      * Partly paid bond?
     C                   MOVEL     PPDI          P#PART
      *
      * Fully paid price
     C                   Z-ADD     SFPP          P#FUPP
      *
      * Accuracy
     C                   Z-ADD     9             P#ACUR
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL  '  W#MODE
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
      * Processing Date = previous interest payment date
     C                   Z-ADD     W#PIDT        E#PRDT
      *
      * Event Type
     C                   MOVEL     'IP'          E#EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#POSS        E#SETD
      *
      ** Import previous interest payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Do all interest payments prior to maturity date
      *
     C     W#RTCD_SIP    DOWNE     '*EOD   '
      *
      * Processing Date
     C                   Z-ADD     W#NIDT        E#PRDT
      *
      ** Import next interest payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Determine next interest payment date
      *
     C                   MOVEL     *BLANK        W#MODE_SIP
     C                   EXSR      GETSIPD
      *
     C                   ENDDO
      *
     C     EIMP_IP       ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT INTEREST RATE CHANGE DATE EVENTS
      *****************************************************************
     C     IMP_IR        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Event Type
     C                   MOVEL     'IR'          E#EVTP
 
      * Pick up interest rates from the security diary
 
     C                   MOVE      'IR'          SDET
     C     SEDEVK        SETLL     SEDEVDF
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
      * If none present, use current rate on security
 
     C     *IN99         IFEQ      '1'
      *
      * Processing Date = initial date
     C                   Z-ADD     ITLD          E#PRDT
      *
      * Interest Rate
     C                   Z-ADD     CPNR          E#IRAT
      *
      ** Import interest rate change date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C                   ENDIF
 
      * Extract all interest rate changes
 
     C     *IN99         DOWEQ     '0'
      *
      * Processing Date
     C     SDED          IFGT      0
     C                   Z-ADD     SDED          E#PRDT
     C                   ELSE
     C                   Z-ADD     ITLD          E#PRDT
     C                   ENDIF
      *
      * Interest Rate
     C                   Z-ADD     SDNC          E#IRAT
      *
      ** Import interest rate change date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT PART PAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_PP        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Event Type
     C                   MOVEL     'PP'          E#EVTP
 
      * Pick up part payments from the security diary
 
     C                   MOVE      'PP'          SDET
     C     SEDEVK        SETLL     SEDEVDF
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
      * If none present, use current partly paid price on security
 
     C     *IN99         IFEQ      '1'
      *
      * Processing Date
     C     ITLD          IFNE      *ZERO
     C                   Z-ADD     ITLD          E#PRDT
     C                   ELSE
     C                   Z-ADD     1             E#PRDT
     C                   ENDIF
      *
      * Current PP %
     C                   Z-ADD     *ZERO         E#CPDP
     C                   MOVE      CPDP          E#CPDP
      *
      ** Import part payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C                   ENDIF
 
      * Extract all part payments
 
     C     *IN99         DOWEQ     '0'
      *
      * Processing Date
     C     SDED          IFGT      0
     C                   Z-ADD     SDED          E#PRDT
     C                   ELSE
     C     ITLD          IFNE      *ZERO
     C                   Z-ADD     ITLD          E#PRDT
     C                   ELSE
     C                   Z-ADD     1             E#PRDT
     C                   ENDIF
     C                   ENDIF
      *
      * Total PP call %
     C                   Z-ADD     *ZERO         E#CPDP
     C                   MOVE      SDTP          E#CPDP
      *
      ** Import part payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MORTGAGE PAYMENT DATE EVENTS
      *****************************************************************
     C     IMP_MP        BEGSR
      *
      * CLEAR EVENT
     C                   CLEAR                   E#EVNT
      *
      * Module, Transaction Reference, Asset/Liability
      *
     C                   MOVEL     P#TKEY        E#TKEY
      *
      * Event Type
     C                   MOVEL     'MP'          E#EVTP
 
      * Pick up mortage payments from the security diary
 
     C                   MOVE      'MP'          SDET
     C     SEDEVK        SETLL     SEDEVDF
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
      * If none present, use current factor on security
 
     C     *IN99         IFEQ      '1'
      *
      * Processing Date = initial date
     C                   Z-ADD     ITLD          E#PRDT
      *
      * Current Factor
     C                   Z-ADD     CFCT          E#CFCT
      *
      ** Import mortgage payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C                   ENDIF
 
      * Extract all mortgage payments
 
     C     *IN99         DOWEQ     '0'
      *
      * Processing Date
     C     SDED          IFGT      0
     C                   Z-ADD     SDED          E#PRDT
     C                   ELSE
     C                   Z-ADD     ITLD          E#PRDT
     C                   ENDIF
      *
      * Current Factor
     C                   Z-ADD     SDCP          E#CFCT
      *
      ** Import mortgage payment date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
 
     C     *IN99         DOUEQ     '1'
     C     SEDEV_RECI    OREQ      'D'
     C     SEDEV_RECI    OREQ      'M'
     C     SEDEVK        READE     SEDEVDF                                99
     C                   ENDDO
 
     C                   ENDDO
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
     C                   Z-ADD     MATY          E#PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E#EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#POSS        E#SETD
      *
      ** Import maturity date event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT TRADE EVENTS
      *****************************************************************
     C     IMP_TRAD      BEGSR
 
     C     BHTV          IFEQ      'T'
     C     TRADKF        SETGT     TRDMTHT
     C                   ELSE
     C     TRADKF        SETGT     TRDMTH
     C                   ENDIF
 
     C     *IN99         DOUEQ     '1'
     C     RECI          ORNE      '*'
     C     RECI          ANDNE     'C'
     C     RECI          ANDNE     'R'
     C     BHTV          IFEQ      'T'
     C     TRADKP        READE     TRDMTHT                                99    *
     C                   ELSE
     C     TRADKP        READE     TRDMTH                                 99
     C                   ENDIF
     C                   ENDDO
      *
      * Whilst live trades can be found
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
     C     BHTV          IFEQ      'T'
     C                   Z-ADD     TDDT          E#PRDT
     C                   Z-ADD     TDVD          E#NXCD
     C                   ELSE
     C                   Z-ADD     TDVD          E#PRDT
     C                   ENDIF
      *
      * Trade type
     C                   MOVEL     TDTP          E#EVTP
      *
      * Trade reference
     C                   MOVEL     TDRF          E#EVRF
      *
      * principal amount (consideration)
     C                   Z-ADD     TCSR          E#PRAM
      *
      * interest amount
     C                   Z-ADD     ITRA          E#INTA
      *
      * charges
     C     TCA1          ADD       TCA2          E#CHRG
     C                   ADD       TCA3          E#CHRG
     C                   ADD       TCA4          E#CHRG
     C                   ADD       TCA5          E#CHRG
     C                   ADD       TCA6          E#CHRG
     C                   ADD       TCA7          E#CHRG
      *
      * commissions
     C     TBCA          ADD       TCCA          E#COMM
      *
      * adjust sign of charges/commmissions to reflact pay/receive
      *
     C     TDTP          IFEQ      'TP'
     C                   Z-SUB     E#CHRG        E#CHRG
     C                   Z-SUB     E#COMM        E#COMM
     C                   ENDIF
      *
      * total amount (countervalue in settlement currency)
     C     TOSV          ADD       TVSP          E#TAMT
     C                   ADD       TVSN          E#TAMT
     C                   MOVEL     SETC          @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        E#NCDP
      *
      * nominal
     C                   Z-ADD     NOML          W#NOML
     C                   EXSR      CNV_NOML
     C                   Z-ADD     W#NOML        E#NOML                         *
      *
      * accrued indicator
     C                   MOVE      ACIN          E#ACIN
      *
      * price
     C                   Z-ADD     PRIC          E#PRIC
      *
      * Suppress Settlement Y
      *
     C                   MOVEL     'Y'           E#SSET
      *
      **  Store pay or receive settlement methods, accounts & branches
      *
     C     TDTP          IFEQ      'TP'
     C                   MOVEL     SMTH          E#SETM
     C                   MOVEL     PYFM          E#SETA
     C                   MOVEL     PYFA          E#SETB
     C                   MOVEL     SETC          E#SETC
     C                   ELSE
     C                   MOVEL     SMTH          E#SETM
     C                   MOVEL     PAYT          E#SETA
     C                   MOVEL     PYTA          E#SETB
     C                   MOVEL     SETC          E#SETC
     C                   ENDIF
      *
      * Import trade event
      *
     C                   MOVEL     '*IMPEVNT  '  W#MODE
     C                   EXSR      WRKEDTA
      *
      * Read next live record
      *
     C     *IN99         DOUEQ     '1'
     C     RECI          ORNE      '*'
     C     RECI          ANDNE     'C'
     C     RECI          ANDNE     'R'
     C     BHTV          IFEQ      'T'
     C     TRADKP        READE     TRDMTHT                                99    *
     C                   ELSE
     C     TRADKP        READE     TRDMTH                                 99
     C                   ENDIF
     C                   ENDDO
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE NEXT DAY
      ********************************************************************
     C     GETSIPD       BEGSR
 
     C                   CALLB     'DEGETSIPD'
      * inputs
     C                   PARM      *BLANK        W#RTCD_SIP        7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS_SIP       30            * ERROR MESSAGE
     C                   PARM                    W#MODE_SIP       10
     C                   PARM      LPSD          W#ZECD            5 0          * SPOT DATE
     C                   PARM                    CDArr                          * INT.DAY   X12
     C                   PARM                    CRArr                          * INT.RT/PY X12
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    ISSD              5 0          * INITIAL DATE
     C                   PARM                    ITLD              5 0          * INITIAL DATE
     C                   PARM                    FCPN              5 0          * FIRST COUPON
     C                   PARM                    MATY              5 0          * MATURITY DATE
     C                   PARM                    BJDFIN            1
     C                   PARM                    NMCY                                         CDE002
     C                   PARM                    SITP                                         CDE002
     C                   PARM                    BCNV                                         CDE002
      * outputs
     C                   PARM                    W#IPY             2 0          * INT PAY PER YR
     C                   PARM                    W#PIDT            5 0          * PREC INT DATE
     C                   PARM                    W#NIDT            5 0          * PAYMENT DATES
      *
     C     W#RTCD_SIP    IFEQ      '*ERROR '
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEGETSIPD'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS BOOK DETAILS
      ********************************************************************
     C     ACSBOK        BEGSR
      *
      ** If CAC005 is on, retrieve user book from AOBKPCR0.
      *
     C     CAC005        IFEQ      'Y'                                                         CAC00
     C                   CALL      'AOBKPCR0'                                                  CAC00
     C                   PARM      *BLANK        @RTCD                                         CAC00
     C                   PARM      '*USER  '     @OPTN             7                           CAC00
     C                   PARM      *BLANKS       @BKCD             2                           CAC00
     C                   PARM      *BLANKS       @PRFC             4                           CAC00
     C                   PARM      @BOOK         @PSBK             2                           CAC00
      *
     C     @RTCD         IFNE      *BLANKS                                                     CAC00
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOBKPCR0'
     C                   EXSR      *PSSR
     C                   ELSE                                                                  CAC00
     C                   MOVEL     @BKCD         @BOOK                                         CAC00
     C                   ENDIF                                                                 CAC00
     C                   ENDIF                                                                 CAC00
     C*
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    @BOOK             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOBOOKR0'
     C                   EXSR      *PSSR
     C                   ENDIF
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
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOCURRR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CONVERT NOMINAL (TO VALUE)
      ********************************************************************
     C     CNV_NOML      BEGSR
      *
      * If interest bearing, convert nominal to face value
      *
     C     IN_PROT       IFEQ      '1'
     C     IN_PROT       OREQ      '3'
     C     IN_PROT       OREQ      '5'
     C     IN_PROT       OREQ      '6'
     C     IN_PROT       OREQ      '8'
     C     IN_PROT       OREQ      '9'
     C                   CALLB     'ZCNSD'
     C                   PARM      W#NOML        ZNOML            15 0
     C                   PARM      100           ZPRC             16 9
     C                   PARM      SPBS          W#SPBS            1
     C                   PARM      NMDP          W#NMDP            1 0
     C                   PARM      NomCcyDec     W#NCDP            1 0
     C                   PARM      *ZERO         ZCONS            15 0
     C                   Z-ADD     ZCONS         W#NOML           15 0
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE MARKET PRICE OF SECURITY
      ********************************************************************
     C     MRKTPRC       BEGSR
      *
      * Get current market price
      *
     C     BHSC          SETGT     PRICEDF
     C     BHSC          READPE    PRICEDF                                99    *
     C     *IN99         DOWEQ     '0'
     C     RECI          ANDNE     'D'
     C     BHSC          READPE    PRICEDF                                99    *
     C                   ENDDO
      *
      * If live price found, update security market price
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     PPRC          MKPR
     C                   ENDIF
      *
     C     E_MRKTPRC     ENDSR
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
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      **  Access Securities Trading details
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Determine if PCA SE Enhancement is active
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAC005            1
     C                   ENDIF
      *
      * Key lists
      *
     C     TRADKF        KLIST
     C                   KFLD                    BHBA
     C                   KFLD                    BHBK
     C                   KFLD                    BHSC
     C                   KFLD                    BHMK
     C                   KFLD                    LPSD
     C     TRADKP        KLIST
     C                   KFLD                    BHBA
     C                   KFLD                    BHBK
     C                   KFLD                    BHSC
     C                   KFLD                    BHMK
 
     C     SEDEVKF       KLIST
     C                   KFLD                    BHSC
     C                   KFLD                    SDET
     C                   KFLD                    LPSD
     C     SEDEVK        KLIST
     C                   KFLD                    BHSC
     C                   KFLD                    SDET
      *
      * If this is a projected extract, open the projection files for output
      * Otherwise open the historic files                                                     CDE002
      *
     C     I#PH          IFEQ      'P'                                                        CDE002
     C                   OPEN      DEPTRANPD
     C                   OPEN      DEPPOSNPD
     C                   OPEN      DEPEVNTPD
     C                   OPEN      DEPCASHPD
     C                   ELSE                                                                 CDE002
     C                   OPEN      DEHTRANPD                                                  CDE002
     C                   OPEN      DEHPOSNPD                                                  CDE002
     C                   OPEN      DEHEVNTPD                                                  CDE002
     C                   OPEN      DEHCASHPD                                                  CDE002
     C                   ENDIF                                                                CDE002
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
      *C*PY*DECPYSRC,DEXTMAINO*******                                                         CDE002
      /COPY DECPYSRC,DEXTMAINA                                                                CDE002
      *****************************************************************
      * C O M M I T M E N T   P R O C E S S I N G
      *C*PY*DECPYSRC,DEXTCOMMO*******                                                         CDE002
      /COPY DECPYSRC,DEXTCOMMA                                                                CDE002
      *****************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY DECPYSRC,DEXTPERDI
      *****************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A  - S E C U R I T I E S
      *****************************************************************
      /COPY DECPYSRC,DEXTWEDTS
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
