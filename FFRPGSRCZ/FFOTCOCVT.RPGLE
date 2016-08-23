     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC cvt file to screen fmt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCOCVT - Over-the-counter conversion: file to screen      *
      *              format (Non-currency format)                     *
      *                                                               *
      *  Function:  This module converts the fields of an O.T.C       *
      *             from their format on file to a screen format.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 215528             Date 21Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  215528 - System is associating a wrong premium amount.       *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Transaction in File Format
     D TranFilFmt    E DS                  EXTNAME(TRANSD)
 
      ** Transaction in Screen Format
     D TranScnFmt    E DS                  EXTNAME(FFOTCOPD)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR DEALING DETAILS
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** EXTERNAL DS FOR Portfolio Management DETAILS
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** EXTERNAL DS FOR CURRENCY DETAILS
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Price (File Format)
     D FFPRIC          S             15P 8
 
      * Ticks Denominator
     D FFTKDM          S              3P 0
 
      * Minimum Price Fluctuation
     D FFMNPF          S             15P 8
 
      * Price (Screen Format)
     D FFSPRC          S             16A
 
      ** Contract type
     D FFCNTT          S              1S 0
 
      ** Number of contracts
     D FFNOC           S              5P 0
 
      ** Tick value
     D FFTKVL          S             14P 5
 
      ** Premium
     D FFPREM          S             13P 0
                                                                                              215528
      ** Strike Price                                                                         215528
     D FFSTRP          S                   LIKE(STRP)                                         215528
 
      ** Work field used to change sign of Quotation convention from
      ** positive to negative or vice versa
     D ChgSign         S              1P 0
 
      ** ZSEDIT fields
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
      ** Number of decimal places for currency
     D CDP             S              1P 0
     D DCDP            S                   LIKE(CDP)
     D PCDP            S                   LIKE(CDP)
     D CCDP            S                   LIKE(CDP)
 
      ** Parameters for ZEDIT
     D PZField         S             16A
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
 
      ** Parameters for ZDATE2
     D PZDayNo         S              5P 0
     D PZDate          S              6P 0
     D PZADate         S              7A
 
      ** Message ID for 'DELETED' text
     D DeletedMsg      S              7A   INZ('ZZM1614')
 
      ** Message file for above message ID
     D MessageFil      S             10A   INZ('ZZGBMSGF')
 
      ** Message text from above message ID
     D MessageTxt      S             80A
 
     D #1ACTN          S              1A
     D NPREM           S             15A
     D FFSTS           S             24A
     D PCurrency       S              3A
     D Wk152           S             15S 2
 
      ** Flag for Enhanced OTCs feature and FF enhancement
     D CFF001          S              1A
     D CFF007          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Iinitialisation
 
     C                   EXSR      INIT
 
      ** Set output screen fields
 
     C                   EXSR      SETFLD
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set output screen fields
      *****************************************************************
     C     SETFLD        BEGSR
 
      ** Instrument processing type
      ** ==========================
 
     C                   MOVE      ITISPT        NISPT
 
      ** Transaction number
      ** ==================
 
     C                   MOVE      TNBR          NTNBR
 
      ** Purchase or Sale.
      ** =================
 
     C                   MOVE      TRTY          NTRTY
 
      ** Number of Contracts
      ** ===================
 
     C                   Z-ADD     0             PZADEC
     C                   Z-ADD     5             PZADIG
     C                   MOVEL     *BLANK        PZField
     C                   MOVE      NUCO          PZField
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADEC
 
     C                   MOVE      PZField       NNUCO
 
      ** OTC Type
      ** ========
 
     C                   MOVE      ISTT          NISTT
 
      ** Put/Call indicator
      ** ==================
 
     C                   MOVE      PCAL          NPCAL
 
      ** Strike Price
      ** ============
 
     C                   IF        STRP <> 0
 
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
 
     C                   Z-ADD     STRP          FFPRIC
 
      ** - format price
 
     C                   CALLB     'FFPRCS'
 
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Screen version of price (16A)
 
     C                   PARM                    NSTRP
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
      ** Tick denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
 
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
 
     C                   ELSE
 
     C                   EVAL      NSTRP = *BLANKS
 
     C                   ENDIF
 
      ** Style (American/ European Option indicator)
      ** ===========================================
 
     C                   EVAL      NAEIN = ITAEIN
 
      ** Portfolio Reference
      ** ===================
 
     C                   IF        BGPFMG = 'Y' and FCPORS <> 'B' and
     C                             PTFR <> *BLANKS or BGN4ST = 'Y' and
     C                             PTFR <> *BLANKS
 
     C                   IF        PTFR <> '9997' or BGN4ST = 'Y'
     C                   EVAL      NPTFR = PTFR
     C                   ELSE
     C                   EVAL      NPTFR = FCR997
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      NPTFR = *BLANKS
     C                   ENDIF
 
      ** Delivery Currency & Amount
      ** ==========================
 
     C                   EVAL      NDCCY = ITOTHC
 
      ** Delivery Currency Decimal Places
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      NDCCY         PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Z-ADD     A6NBDP        DCDP
 
      ** Delivery (Contingent) Amount
 
     C                   Z-ADD     DCDP          PZADEC
     C     13            SUB       DCDP          PZADIG
     C                   MOVEL     *BLANK        PZField
     C                   MOVE      ITCTAM        PZField
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADEC
 
     C                   MOVE      PZField       NCTAM
 
      ** Contract Price
      ** ==============
 
     C                   IF        COPR <> 0
 
     C                   Z-ADD     COPR          FFPRIC
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
 
      **   - format price
 
     C                   CALLB     'FFPRCS'
 
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Screen version of price (16A)
 
     C                   PARM                    FFSPRC
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
      ** Tick denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
 
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
 
     C                   MOVE      FFSPRC        NCOPR
 
     C                   ELSE
 
     C                   EVAL      NCOPR = *BLANKS
 
     C                   ENDIF
 
      ** Premium Currency
      ** ================
 
     C                   EVAL      NISCY = ISCY
 
      ** Premium Currency Decimal Places
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      NISCY         PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Z-ADD     A6NBDP        PCDP
 
      ** Premium up Front
      ** ================
 
     C                   EVAL      NPUPF = ITPUPF
 
      ** Trade Date
      ** ==========
 
     C                   IF        TRSD <> 0
 
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   MOVE      TRSD          PZDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayno
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   MOVE      PZDate        NTRSD
 
     C                   ELSE
 
     C                   EVAL      NTRSD = *BLANKS
 
     C                   ENDIF
 
      ** Value Date
      ** ==========
 
     C                   IF        VALD <> 0
 
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   MOVE      VALD          PZDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   MOVE      PZDate        NVALD
 
     C                   ELSE
 
     C                   EVAL      NVALD = *BLANKS
 
     C                   ENDIF
 
      ** Expiry (Final Transaction) Date
      ** ===============================
 
     C                   IF        ITFTDT <> 0
 
     C                   MOVE      ITFTDT        PZDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   MOVE      PZDate        NFTDT
 
     C                   ELSE
 
     C                   EVAL      NFTDT = *BLANKS
 
     C                   ENDIF
 
      ** Expiry (Final Transaction) Time
      ** ===============================
 
     C                   EVAL      NFTTM = ITFTTM
 
      ** Customer
      ** ========
 
     C**********         IF        CUSC = 0                                                   CSD027
     C                   IF        CUSC = *BLANKS                                             CSD027
     C                   EVAL      NCUSC = *BLANKS
     C                   ELSE
     C                   MOVEL     CUSC          NCUSC
     C                   ENDIF
 
      ** Book Code
      ** =========
 
     C                   EVAL      NBOKC = BOKC
 
      ** Booking Branch
      ** ==============
 
     C                   EVAL      NBRCD = BRCA
 
      ** Originating Branch
      ** ==================
 
     C                   EVAL      NORBR = ORBR
 
      ** Settlement Date
      ** ===============
 
     C                   IF        ITSETD <> 0
 
     C                   MOVE      ITSETD        PZDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   MOVE      PZDate        NSETD
 
     C                   ELSE
 
     C                   EVAL      NSETD = *BLANKS
 
     C                   ENDIF
 
      ** Narrative
      ** =========
 
     C                   EVAL      NTNAR = TNAR
 
      ** Commodity Ref
      ** =============
 
     C                   EVAL      NCMRF = ITCMRF
 
      ** To Be Left Open
      ** ===============
 
     C                   EVAL      NTBLO = TBLO
 
      ** Linked Reference Number
      ** =======================
 
     C                   IF        LNKR = *ZERO
     C                   EVAL      NLNKR = *BLANK
     C                   ELSE
     C                   MOVE      LNKR          NLNKR
     C                   ENDIF
 
      ** Tick Value
      ** ==========
 
     C                   IF        ITTKVL <> 0
 
     C                   Z-ADD(H)  ITTKVL        Wk152
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      Wk152         PZField
     C                   EVAL      PZADEC = PCDP + 2
     C                   EVAL      PZADIG = 10 - PZADEC
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADEC
 
     C                   MOVE      PZField       NTKVL
 
     C                   ELSE
 
     C                   EVAL      NTKVL = *BLANKS
 
     C                   ENDIF
 
      ** Minimum Price Fluctuation
      ** =========================
 
     C                   IF        ITMNPF <> 0
 
     C                   Z-ADD     8             PZADEC
     C                   Z-ADD     7             PZADIG
     C                   MOVEL     *BLANK        PZField
     C                   MOVE      ITMNPF        PZField
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADEC
 
     C                   MOVE      PZField       NMNPF
 
     C                   ELSE
 
     C                   EVAL      NMNPF = *BLANKS
 
     C                   ENDIF
 
      ** Profit Centre
      ** =============
 
     C                   EVAL      NPRFC = PRFC
 
      ** PM Instrument Type
      ** ==================
 
     C                   MOVE      ITINNR        NINNR
 
      ** Book position profit centre
      ** ===========================
 
     C                   EVAL      NBPRC = BPRC
 
      ** Transaction position profit centre
      ** ==================================
 
     C                   EVAL      NTPRC = TPRC
 
      ** Calculate Premium For Display
      ** =============================
 
     C                   Z-ADD     NUCO          FFNOC
     C                   Z-ADD     COPR          FFPRIC
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
     C                   Z-ADD     ITTKVL        FFTKVL
     C                   Z-ADD     ITCNTT        FFCNTT
 
     C                   CALLB     'FFPMCL'
 
      ** Premium (13,0P)
 
     C                   PARM                    FFPREM
 
      ** Number of contracts (5,0P)
      ** Price (15,8P)
      ** Ticks denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
      ** Tick Value (14,5P)
      ** Instrument type (1,0S)
      ** Contract type (1,0S, from INTYPD)
      ** Contingent amount (13,0P), from INTYPD)
 
     C                   PARM                    FFNOC
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
     C                   PARM                    FFTKVL
     C                   PARM                    ITISPT
     C                   PARM                    FFCNTT
     C                   PARM                    ITCTAM
     C                   PARM      STRP          FFSTRP                                       215528
 
 
     C                   Z-ADD     FFPREM        ZFLD15
     C                   Z-ADD     PCDP          ZDECS
     C                   MOVE      'J'           ZECODE
 
     C                   CALLB     'ZSEDIT'
 
      ** Field to edit
      ** Decimal places
      ** Edit code ('J', 'L' or ' ')
 
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
 
      ** Output
 
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        NPREM
 
      ** If trade is deleted, set up the screen text
      ** ===========================================
 
     C                   IF        CHTP = 'D'
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    DeletedMsg
     C                   PARM                    MessageFil
     C                   PARM                    MessageTxt
 
     C                   EVAL      FFSTS = %subst(MessageTxt : 1 : 24)
 
     C                   ENDIF
 
      ** If Plato interface present, setup second screen
      ** ===============================================
 
     C                   IF        BGN2ST = 'Y'
     C                   EXSR      SR2ndScn
     C                   ENDIF
 
      ** If PB module and CFF007 are installed
      ** =====================================
 
     C                   IF        CFF007 = 'Y' and BGN4ST = 'Y'
     C                   EXSR      SRPBScn
     C                   ELSE
     C                   EVAL      NCOVE = *BLANKS
     C                   EVAL      NHETR = *BLANKS
     C                   EVAL      NBLUP = *BLANKS
     C                   EVAL      NUNSE = *BLANKS
     C                   EVAL      NTECO = *BLANKS
     C                   EVAL      NTNAT = *BLANKS
     C                   EVAL      NCRIK = *BLANKS
     C                   EVAL      NCCYR = *BLANKS
     C                   EVAL      NTWEI = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SR2ndScn - Set output screen fields for Plato Screen
      *****************************************************************
     C     SR2ndScn      BEGSR
 
      ** Instrument Type
      ** ===============
 
     C                   EVAL      NMIIT = ITPLMIIT
 
      ** Term to Maturity
      ** ================
 
     C                   EVAL      NMITM = ITPLMITM
 
      ** Maturity Date
      ** =============
 
     C                   IF        ITPLMIMD <> 0
 
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   MOVE      ITPLMIMD      PZDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   MOVE      PZDate        NMITD
 
     C                   ELSE
 
     C                   EVAL      NMITD = *BLANKS
 
     C                   ENDIF
 
      ** Coupon Rate
      ** ===========
 
     C                   IF        ITPLMICP <> 0
 
     C                   Z-ADD     7             PZADEC
     C                   Z-ADD     4             PZADIG
     C                   MOVEL     *BLANK        PZField
     C                   MOVE      ITPLMICP      PZField
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADEC
 
     C                   MOVE      PZField       NMICP
 
     C                   ELSE
 
     C                   EVAL      NMICP = *BLANKS
 
     C                   ENDIF
 
      ** Coupon Frequency
      ** ================
 
     C                   EVAL      NMICF = ITPLMICF
 
      ** Pricing Convention
      ** ==================
 
     C                   EVAL      NMIPC = ITPLMIPC
 
      ** Spot Price
      ** ==========
 
     C                   IF        PLSPTP <> 0
 
     C                   Z-ADD     PLSPTP        FFPRIC
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
 
      **   - format price
 
     C                   CALLB     'FFPRCS'
 
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Screen version of price (16A)
 
     C                   PARM                    FFSPRC
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
      ** Tick denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
 
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
 
     C                   MOVE      FFSPRC        NMSPT
 
     C                   ELSE
 
     C                   EVAL      NMSPT = *BLANKS
 
     C                   ENDIF
 
      ** Volatility Type
      ** ===============
 
     C                   EVAL      NMIVT = ITPLMIVT
 
      ** Pricing Method
      ** ==============
 
     C                   EVAL      NMIPM = ITPLMIPM
 
      ** Pricing Group Code
      ** ==================
 
     C                   EVAL      NMIPG = ITPLMIPG
 
      ** Report Group Code
      ** =================
 
     C                   EVAL      NMIRG = ITPLMIRG
 
      ** Credit Rating Code
      ** ==================
 
     C                   EVAL      NMICR = ITPLMICR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRPBScn - Set output screen fields for Private Banking screen
      *****************************************************************
     C     SRPBScn       BEGSR
 
     C                   EVAL      NCOVE = COVE
     C                   EVAL      NHETR = HETR
     C                   EVAL      NBLUP = BLUP
     C                   EVAL      NUNSE = ITUNSE
     C                   EVAL      NTECO = ITTECO
     C                   EVAL      NTNAT = ITTNAT
     C                   EVAL      NCRIK = ITCRIK
     C                   EVAL      NCCYR = ITCCYR
 
     C                   IF        ITTWEI <> 0
     C                   MOVE      ITTWEI        NTWEI
     C                   ELSE
     C                   EVAL      NTWEI = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
 
     C     INIT          BEGSR
 
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN TRANSACTION FORMAT)
 
     C                   MOVEL     NACTN         #1ACTN
     C                   MOVEL     *BLANK        TranScnFmt
     C                   MOVEL     #1ACTN        NACTN
     C                   MOVEL     *BLANK        NPREM
     C                   MOVEL     *BLANK        FFSTS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameter
      ** ===============
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Transaction in file format
      ** Instrument types
 
     C                   PARM                    TranFilFmt
     C                   PARM                    InstTypes
 
      ** Standing Data
      ** =============
 
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Output Parameters
      ** =================
 
      ** Transaction in screen format
 
     C                   PARM                    TranScnFmt
 
      ** Premium
      ** Transaction Status
 
     C                   PARM                    NPREM
     C                   PARM                    FFSTS
 
      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
