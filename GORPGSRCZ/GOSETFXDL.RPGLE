     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup FX Deal TRAP record')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETFXDL - Setup FX Deal TRAP record                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSW212             Date 03May12               *
      *                 AR733855           Date 14Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248035             Date 13Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12116           Date 03Oct06               *
      *                 BUG11830           Date 11Aug06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG2266             Date 09Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  AR733855 - T_MKVL will no longer be zero when deal date      *
      *             equals rundate. (Child:AR733856)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248035 - Add conditions for when FHRCID, FHCCY1, and FHCCY2  *
      *           are blank.                                          *
      *  BUG12116 - suppress revaluation for a FX deal entered today  *
      *             (DEAL DATE = RUNDATE). Market Value will be zero  *
      *             for this particular case.                         *
      *           - FX Market Value / Profit and Loss amount (i.e.    *
      *             T_MKVL in GPTRAPPD) is not calculated correctly.  *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                 )*
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  BUG3860 - (recompile)                                        *
      *  BG2266 - Market value not based on correct exchange rates    *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPUTXTL0  IF A E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D FXDEAL        E DS                  EXTNAME(FXDEALPP)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
      ** DEFINE FIELDS FOR ZDATE10
     D                 DS
     D ZWDTIN                  1      8S 0
     D  ZWYYYY                 1      4S 0
     D  ZWMTH                  5      6S 0
     D  ZWDAY                  7      8S 0
 
      * Midas Phase data area                                                               BUG12116
     D MPHAS           DS                                                                   BUG12116
     D  @PHAS                  1      1                                                     BUG12116
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDCOCC        E DS                  EXTNAME(SDCOCCPD)                                  CLE025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE025
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    FXDEAL
     C                   PARM                    OTDT              5 0
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    OptnEndDate       5 0            Midas day no.
 
      * CONVERT DATES
 
     C                   EXSR      CONVT_DATES
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * CONVERT DATES
      *****************************************************************
     C     CONVT_DATES   BEGSR
 
      * deal date
     C                   Z-ADD     FHDDYY        ZWYYYY                         ¦
     C                   Z-ADD     FHDDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     FHDDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        DealDate          5 0            Midas day no.
      * value date
     C                   Z-ADD     FHVDYY        ZWYYYY                         ¦
     C                   Z-ADD     FHVDMM        ZWMTH                          ¦ value date
     C                   Z-ADD     FHVDDD        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        ValueDate         5 0            Midas day no.
      * deal option end date
     C                   Z-ADD     FHDOEY        ZWYYYY                         ¦
     C                   Z-ADD     FHDOEM        ZWMTH                          ¦ maturity date
     C                   Z-ADD     FHDOED        ZWDAY                          ¦
     C                   EXSR      ZDATE10
     C                   Z-ADD     ZZMDNO        OptnEndDate       5 0            Midas day no.
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
 
      * Clear Transaction Index
 
     C                   CLEAR                   T_TRAP
 
      * Zone
     C                   MOVEL     O#ZONE        T_ZONE
      * Module
     C                   MOVEL     'DL'          T_MOD
      * Sub module
     C                   MOVEL     'FXDL'        T_SMOD
      * Customer
     C                   MOVEL     FHDCNO        T_CNUM
      * Portfolio reference
     C                   MOVEL     FHPTFR        T_PTFR
      * Booking Branch
     C                   MOVEL     FHMBCA        T_BRCA
      * Book
     C                   MOVEL     FHBOKC        T_BOOK
      * Transaction Reference
     C                   MOVEL     FHDN38        T_TREF
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
     C                   EVAL      T_SNAM = T_TREF
      * Transaction Type
     C                   MOVEL     FHTYPE        T_TRTP
      * Transaction Sub-Type
     C                   MOVEL     FHSTYP        T_TRST
      * Transaction Profit Centre
     C                   MOVEL     FHPRFC        T_TPFC
      * Risk Customer
     C                   MOVEL     FHDCNO        T_RCST
      * Risk Currency
     C                   MOVEL     FHCCY1        T_RCCY
      * Transaction Date
     C                   Z-ADD     DealDate      T_TDAT
      * Value Date
 
      * Start Date and End Date
     C                   SELECT
      *
      * If an OPTION
     C     FHTYPE        WHENEQ    'OP'
     C                   Z-ADD     ValueDate     T_SDAT                           Midas day no.
     C                   Z-ADD     OptnEndDate   T_EDAT                           Midas day no.
      *
      * If a SWAP
     C     FHTYPE        WHENEQ    'SW'
     C     OTDT          IFLT      ValueDate
     C     OTDT          ANDNE     *ZERO
     C                   Z-ADD     OTDT          T_SDAT                           Midas day no.
     C                   ELSE
     C                   Z-ADD     ValueDate     T_SDAT                           Midas day no.
     C                   ENDIF
     C                   Z-ADD     ValueDate     T_EDAT                           Midas day no.
      *
      * If an OUTRIGHT
     C                   OTHER
     C                   Z-ADD     ValueDate     T_SDAT                           Midas day no.
     C                   Z-ADD     ValueDate     T_EDAT                           Midas day no.
     C                   ENDSL
 
      * If deal is not a swap, do revaluation
 
     C     FHTYPE        IFNE      'SW'
                                                                                            BUG12116
      **If*FX*deal**s*newly*entered*today,*do*not*revalue*at*input cycle.          BUG12116 AR733855
      **(Allow*revaluation*for*newly*entered*deal*during*COB*as*normal)            BUG12116 AR733855
     C*****FHDDDN        IFEQ      BJRDNB                                          BUG12116 AR733855
     C*****@PHAS         ANDEQ     'A'                                             BUG12116 AR733855
     C*****FHCCY1        OREQ      *BLANKS                                           248035 AR733855
     C*****FHCCY2        ANDEQ     *BLANKS                                           248035 AR733855
     C*****FHRCID        ANDEQ     *BLANKS                                           248035 AR733855
     C**********         EVAL      T_MKVL = 0                                      BUG12116 AR733855
     C**********         MOVEL     BJCYCD        T_VCCY                            BUG12116 AR733855
     C**********         Z-ADD     BaseCDP       T_VCDP                            BUG12116 AR733855
     C**********         ELSE                                                      BUG12116 AR733855
 
      * Revalue the buy leg
     C                   EXSR      BUYCCY
     C                   MOVE      'B'           BUYSELL
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   MOVE      FHOYLC        PYldBuy                                      CLE025
     c                   ENDIF                                                                CLE025
     C                   EXSR      REVALUE
     C                   Z-ADD     PLAM          BUY_PLAM         13 0
 
      * Revalue the sell leg
     C                   EXSR      SELLCCY
     C                   MOVE      'S'           BUYSELL
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   MOVE      FHTYLC        PYldSel                                      CLE025
     c                   ENDIF                                                                CLE025
     C                   EXSR      REVALUE
     C                   Z-ADD     PLAM          SELL_PLAM        13 0
 
      * Market value
     C     BUY_PLAM      ADD       SELL_PLAM     T_MKVL
     C                   MOVEL     BJCYCD        T_VCCY
     C                   Z-ADD     BaseCDP       T_VCDP
                                                                                            BUG12116
     C**********         ENDIF                                                     BUG12116 AR733855
                                                                                            BUG12116
     C                   ENDIF
      * Matured?
     C     FHDSTS        IFEQ      'M'
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Action
     C     FHDDLT        IFEQ      'D'
     C                   MOVEL     'D'           T_ACTN
     C                   ELSE
     C                   MOVEL     'A'           T_ACTN
     C                   ENDIF
      *
      * Customer branch                                                                     BUG11830
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE BUY CURRENCY DETAILS TO WORK FIELDS
      ********************************************************************
     C     BUYCCY        BEGSR
      *
     C                   MOVE      FHCCY1        W#CCY             3
     C                   Z-ADD     FHDBUY        W#AMT            13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-ADD     FHDAM1        W#AMT
     C                   ENDIF
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
     C                   MOVE      FHCCY2        W#CCY             3
     C                   Z-ADD     FHDSEL        W#AMT            13 0
     C     FHTYPE        IFEQ      'OP'
     C                   Z-SUB     FHDAM2        W#AMT
     C                   ENDIF
      *
     C                   MOVEL     W#CCY         @CYCD
     C                   EXSR      ACSCCY
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      *********************************************************************
      * REVALUE FX DEAL
      *********************************************************************
     C     REVALUE       BEGSR
                                                                                            BUG12116
      ** Set Run Day Number parameter correctly                                             BUG12116
                                                                                            BUG12116
     C                   EVAL      I#RDNB = BJRDNB                                          BUG12116
                                                                                              CLE025
      ** If FX Valuation is by Forward Rate, call Forward Rate Revaluation Module             CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'N' OR CCFVFN = 'Y'                               CLE025
      *
      * Revalue currency amounts
      *
     C                   CALLB     'GOFWDREVN'
      * Inputs
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
 
     C                   PARM                    BUYSELL           1
     C                   PARM      W#CCY         ECCY              3
     C                   PARM      T_EDAT        EDAT              5 0
     C                   PARM      W#AMT         EAMT             13 0
     C                   PARM      FHBCAE        DBCE             13 0
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
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOFWDREVN'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ELSE                                                                 CLE025
      *                                                                                       CLE025
     C                   CALLB     'GONPVREVN'                                                CLE025
      * Inputs                                                                                CLE025
     C                   PARM      *BLANK        W#RTCD                                       CLE025
     C                   PARM      *BLANK        W#ERMS                                       CLE025
     C                   PARM                    BUYSELL                                      CLE025
     C                   PARM                    PYldBuy           5                          CLE025
     C                   PARM                    PYldSel           5                          CLE025
     C                   PARM      W#CCY         ECCY                                         CLE025
     C                   PARM      T_EDAT        EDAT                                         CLE025
     C                   PARM      W#AMT         EAMT                                         CLE025
     C                   PARM      FHBCAE        DBCE                                         CLE025
      *                                                                                       CLE025
     C                   PARM                    I#RDNB                                       CLE025
     C                   PARM                    BJCYCD                                       CLE025
     C                   PARM      BaseCDP       BCCDP                                        CLE025
     C                   PARM      BaseICB       BCICB             1                          CLE025
      * Currency details                                                                      CLE025
     C                   PARM                    SDCURR                                       CLE025
      * Outputs                                                                               CLE025
     C                   PARM      *ZERO         REVA                                         CLE025
     C                   PARM      *ZERO         RATE                                         CLE025
     C                   PARM      *ZERO         PLAM                                         CLE025
      *                                                                                       CLE025
     C     W#RTCD        IFEQ      '*ERROR'                                                   CLE025
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GONPVREVN'                      CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
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
      * ZDATE10
      ********************************************************************
     C     ZDATE10       BEGSR
     C                   CALLB     'ZDATE10'
     C                   PARM                    ZWDTIN            8 0
     C                   PARM                    ZZMDNO            5 0
     C                   ENDSR
      *****************************************************************
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
                                                                                              CLE025
      ** Access Collateral and Credit Lines ICD                                               CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD             7                          CLE025
     C                   PARM      '*VERIFY'     POPTN             7                          CLE025
     C                   PARM      'CLE025'      PSARD             6                          CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBase = 2                                                  CLE025
     C                   EVAL      DBKey = 'CLE025'                                           CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025            1                          CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVE      'N'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
 
      **  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      **  Access Base Currency Decimal Places
 
     C                   MOVEL     BJCYCD        @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        BaseCDP           1 0
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   MOVEL     A6DICB        BaseICB           1                          CLE025
                                                                                              CLE025
      ** Access Collateral and Credit Lines ICD                                               CLE025
                                                                                              CLE025
     C                   CALLB     'AOCOCCR0'                                                 CLE025
     C                   PARM      '*DBERR  '    @RTCD                                        CLE025
     C                   PARM      '*FIRST  '    @OPTN                                        CLE025
     C     SDCOCC        PARM      SDCOCC        DSFDY                                        CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
                                                                                            BUG12116
      * Retrieve MPHAS for system phase (i.e. 'A' for I/C or 'C' for COB)                   BUG12116
      * this will be required for FX revaluatio later.                                      BUG12116
                                                                                            BUG12116
     C     *DTAARA       DEFINE                  MPHAS                                      BUG12116
     C                   IN        MPHAS                                                    BUG12116
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
                                                                                              BG2266
      * Get Extract control information                                                       BG2266
                                                                                              BG2266
      /COPY GOCPYSRC,GOGETEXCT                                                                BG2266
 
 
      * key list
 
     C     GPUTXTK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_MOD
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_TREF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
