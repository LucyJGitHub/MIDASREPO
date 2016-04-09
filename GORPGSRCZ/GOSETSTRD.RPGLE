     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*XBIA*: OVRDBF FILE(PRICMXX   ) TOFILE(PRICM   ) SHARE(*NO)          *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup SE Trade TRAP record')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETSTRD - Setup SE Trade TRAP record                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG13562           Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11830           Date 11Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG3512 (reopen)    Date 04Aug04               *
      *                 BG3512 *CREATE     Date 29Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13562 - Matured FRAs and SE Trades are still linked       *
      *             to limits. Ensure Matured Indicator (T_MATI) is   *
      *             set to 'Y' if RECI=M. Fix is same as MP121        *
      *             version (246296).                                 *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3860 - (recompile)                                        *
      *  BG3512 - (reopen) Transaction type/subtype should be         *
      *           investment type and currency                        *
      *  BG3512 - Extract of SE Trades was missing                    *
      *                                                               *
      *****************************************************************
     FPRICMXX   IF   E           K DISK    INFSR(*PSSR) PREFIX(PR_) USROPN
     FGPUTXTL0  IF A E           K DISK    INFSR(*PSSR)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D TRADS         E DS                  EXTNAME(TRADSD)
     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D PRICE         E DS                  EXTNAME(PRICED) PREFIX(PR_)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     DSDSECS         E DS                  EXTNAME(SDSECSPD)
      ** SECURITY CLIENT DETAILS
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    TRADS
     C                   PARM                    SECTY
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    NomCcyDec         1 0
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
 
      * Clear Transaction Index
 
     C                   CLEAR                   T_TRAP
 
      * Zone
     C                   MOVEL     O#ZONE        T_ZONE
      * Module
     C                   MOVEL     'SE'          T_MOD
      * Sub module
     C                   MOVEL     'STRD'        T_SMOD
      * Customer
     C                   MOVEL     TCNR          T_CNUM
      * Portfolio reference
     C                   MOVEL     *BLANK        T_PTFR
      * Booking Branch
     C                   MOVEL     TDBA          T_BRCA
      * Book
     C                   MOVEL     TDBK          T_BOOK
      * Security Shortname
     C                   MOVEL     TDSS          T_SESN
      * Market Indicator
     C                   MOVEL     TDMI          T_MKTI
      * Transaction Reference
     C                   MOVEL     TDRF          T_TREF
      * Identifier
     C     GPUTXTK       CHAIN     GPUTXTD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   MOVEL     T_ZONE        XTZONE
     C                   MOVEL     T_MOD         XTMOD
     C                   MOVEL     T_SMOD        XTSMOD
     C                   MOVEL     T_TREF        XTTREF
     C                   Z-ADD     O#NTID        XTID
     C                   WRITE     GPUTXTD0
     C                   ENDIF
     C                   Z-ADD     XTID          T_ID
      * Shortname
     C                   EVAL      T_SNAM = T_BRCA+'-'+T_SESN+'-'+T_TREF
      * Transaction Type
      *************                                                                     BG3512BG3512
      **Get*trade*counterparty securities customer details                              BG3512BG3512
      *************                                                                     BG3512BG3512
     C*************      MOVEL     TCNR          @AENB                                  BG3512BG3512
     C*************      CALLB     'AOSECSR0'                                           BG3512BG3512
     C*************      PARM      *BLANKS       @RTCD             7                    BG3512BG3512
     C*************      PARM      '*KEY    '    @OPTN             7                    BG3512BG3512
     C*************      PARM                    @AENB             6                    BG3512BG3512
     C*****SDSECS**      PARM      SDSECS        DSSDY                                  BG3512BG3512
     C*************      MOVEL     BFCLAS        T_TRTP                                 BG3512BG3512
      * Transaction Type                                                                      BG3512
     C                   MOVEL     SE_SITP       T_TRTP                                       BG3512
      * Transaction Sub-Type
     C*************      MOVEL     *BLANK        T_TRST                                 BG3512BG3512
     C                   MOVEL     SE_NMCY       T_TRST                                       BG3512
      * Transaction Profit Centre
     C                   MOVEL     *BLANK        T_TPFC
      * Risk Customer
     C                   MOVEL     TCNR          T_RCST
      * Risk Currency
     C                   MOVEL     SE_NMCY       T_RCCY
      * Transaction Date
     C                   Z-ADD     TDDT          T_TDAT
      * Start Date
     C                   Z-ADD     TDDT          T_SDAT
      * End Date
     C                   Z-ADD     TDVD          T_EDAT
      * Issuer Exposure
     C                   MOVEL     *BLANKS       T_ISEI
 
      * Determine market price of security
 
     C                   EXSR      MRKTPRC
      *
      * Valuation Currency
     C                   MOVEL     SE_NMCY       T_VCCY
      * Valuation Ccy Dec Places = nominal currency decimal places
     C                   MOVEL     SE_NMCY       @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        T_VCDP
     C                   MOVEL     A6NBDP        NomCcyDec
      * Matured?
     C     RECI          IFEQ      'M'
      *                                                                                     BUG13562
      * Settled                                                                             BUG13562
     C     RECI          OREQ      'S'                                                      BUG13562
      *                                                                                     BUG13562
      * Date fully settled is today.                                                        BUG13562
     C     TDFS          OREQ      I#RDNB                                                   BUG13562
      *                                                                                     BUG13562
      * Auto-settle indicator is Y and trade's value date is                                BUG13562
      * today or in the past (either RECI D - Inserted or A - Changed).                     BUG13562
     C     RECI          OREQ      'D'                                                      BUG13562
     C     AUTS          ANDEQ     'Y'                                                      BUG13562
     C     TDVD          ANDLE     I#RDNB                                                   BUG13562
      *                                                                                     BUG13562
     C     RECI          OREQ      'A'                                                      BUG13562
     C     AUTS          ANDEQ     'Y'                                                      BUG13562
     C     TDVD          ANDLE     I#RDNB                                                   BUG13562
      *                                                                                     BUG13562
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Action
     C                   MOVEL     'A'           T_ACTN
      *
      * Customer branch                                                                     BUG11830
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * DETERMINE MARKET PRICE OF SECURITY
      ********************************************************************
     C     MRKTPRC       BEGSR
 
     C                   CLEAR                   PRICE
      *
      * Get current market price
      *
     C     TDSS          SETGT     PRICEDF
     C     TDSS          READPE    PRICEDF                                99    *
     C     *IN99         DOWEQ     '0'
     C     PR_RECI       ANDNE     'D'
     C     TDSS          READPE    PRICEDF                                99    *
     C                   ENDDO
      *
      * If live price found, update security market price
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     PR_PPRC       SE_MKPR
     C                   ENDIF
      *
     C     E_MRKTPRC     ENDSR
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
      ********************************************************************                  BUG11830
      * Access customer details                                                             BUG11830
      ********************************************************************                  BUG11830
     C     ACS_CUST      BEGSR                                                              BUG11830
     C                   CALLB     'AOCUSTR0'                                               BUG11830
     C                   PARM      *BLANKS       @RTCD             7                        BUG11830
     C                   PARM      '*KEY   '     @OPTN             7                        BUG11830
     C                   PARM                    @KEY1            10                        BUG11830
     C                   PARM      *BLANKS       @KYST             7                        BUG11830
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG11830
     C     @RTCD         IFNE      *BLANK                                                   BUG11830
     C     @KYST         OREQ      '*ERROR'                                                 BUG11830
     C                   CLEAR                   SDCUST                                     BUG11830
     C                   ENDIF                                                              BUG11830
     C                   ENDSR                                                              BUG11830
      *****************************************************************                     BUG11830
      /SPACE 5                                                                              BUG11830
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
                                                                                            BUG13562
      * Get Extract control information                                                     BUG13562
                                                                                            BUG13562
      /COPY GOCPYSRC,GOGETEXCT                                                              BUG13562
 
     C                   Z-ADD     60            MESLEN           15 5
 
      * Override/Open files
 
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   OPEN      PRICMXX
 
      * Key lists
 
     C     GPUTXTK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_MOD
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_TREF
 
      * Parameter lists
 
     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
** ##OV1
OVRDBF FILE(PRICMXX   ) TOFILE(PRICM   ) SHARE(*NO)
