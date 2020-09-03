     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of securities trades')                *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTSTRD - Projected Extract for Securities Trades           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3512 (reopen)   Date 24Sep04               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG3512 *CREATE     Date 29Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3512 - (reopen) Asset/Liability flag needs to be set up   *
      *  BUG3860 - (recompile)                                        *
      *  BG3512 - Extract of SE Trades was missing                    *
      *                                                               *
      *****************************************************************
 
     FPRICM     IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GOWPOSNPD)
      ** E V E N T    D E T A I L S
     D E_EVNT        E DS                  EXTNAME(GOWEVNTPD)
     D  E_SETD               185    210
 
     D TRADS         E DS                  EXTNAME(TRADSD) PREFIX(TR_)
     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D INVTP         E DS                  EXTNAME(INVTPD) PREFIX(IN_)
 
 
     D W#SETI          DS
     D  W#SETM                 1      2
     D  W#SETA                 3     20                                                       CGL029
     D  W#SETB                21     23                                                       CGL029
     D  W#SETY                24     26                                                       CGL029
 
 
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
 
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#PCOD            5 0          * PROJECTION DATE
     C                   PARM                    I#TVDI            1
     C                   PARM                    TRADS
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * NO VALUE DATE POSITION EXTRACT IS REQUIRED IF MATURED
 
     C     I#TVDI        IFEQ      'V'
     C     T_MATI        ANDEQ     'Y'
     C                   RETURN
     C                   ENDIF
 
      * SETUP SETTLEMENT INSTRUCTIONS
 
     C                   EXSR      SETUP_SETI
 
      * IMPORT OPENING POSITION AND EVENTS
 
     C                   EXSR      IMPORT
 
      * PROCESS IMPORTED EVENTS
 
     C                   MOVEL     '*PROCSIM'    W#MODE
     C                   EXSR      WRKEDTA
 
      * WRITE TRANSACTION INDEX RECORD
 
     C     I#TVDI        IFEQ      'T'
      * Commitment Cycle ID
     C                   Z-ADD     I#CCID        T_CCID
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
      *
     C                   CALLB     'GOSETSTRD'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    TRADS
     C                   PARM                    SECTY
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    NomCcyDec         1 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETSTRD'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WRITE TRANSACTION INDEX RECORD
      *****************************************************************
     C     WRITE_TRAP    BEGSR
 
     C                   MOVEL     'Y'           I#CUSTDEFLT
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SETUP SETTLEMENT INSTRUCTIONS
      *****************************************************************
     C     SETUP_SETI    BEGSR
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
      * IMPORT PERIOD END DATES
      *
     C                   EXSR      IMP_PE
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
     C                   CLEAR                   P_POSN
      *                                                                                       BG3512
      * Asset/Liability                                                                       BG3512
     C                   MOVEL     'A'           P_ASLI                                       BG3512
      *
      * Interest Accrl Ctl Date
     C                   Z-ADD     TR_TDDT       P_PDAT                           Midas day no.
      *
      * Nominal/Principal
      * = outstanding (i.e unsettled) value in settlement currency
      *
     C                   Z-ADD     TR_TOSV       P_NOML
      *
      * Currency
     C                   MOVEL     TR_SETC       P_CCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     TR_SETC       @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        SetCcyDec         1 0
     C                   MOVEL     SetCcyDec     P_NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     SetCcyDec     P_NMDP
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
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     TR_TDDT       E_PRDT
      *
      * Event Type
     C                   MOVEL     'DD'          E_EVTP
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
     C                   CLEAR                   E_EVNT
      *
      * Processing Date
     C                   Z-ADD     TR_TDVD       E_PRDT
      *
      * Event Type
     C                   MOVEL     'MT'          E_EVTP
      *
      ** Set up settlement details
      *
     C                   MOVEL     W#SETI        E_SETD                         * Rec details
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
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY GOCPYSRC,GOXTIMPPE
      *****************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      *****************************************************************
      /COPY GOCPYSRC,GOXTWRKEDA
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
