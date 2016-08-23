     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Report Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLREX - BSPL Report Extract                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAS014             Date 10Aug05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS014 - IAS21 The Effects of Changes in Foreign Exchange    *
      *           Rates                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPACBLAPD IP   E             DISK    INFSR(*PSSR)
     FGPICDTL0  IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
 
     FGPACBLRPD O    E             DISK    INFSR(*PSSR)
     FGPBSPLBPD UF   E           K DISK    INFSR(*PSSR)
     FGPBSPLCPD IF A E           K DISK    INFSR(*PSSR)
                                                                                              CAS014
      ** Midas Global Average Spot Rates                                                      CAS014
     FGPAVSRL2  IF   E           K DISK    INFSR(*PSSR)                                       CAS014
                                                                                              CAS014
      ** Midas GZ Account Codes                                                               CAS014
     FGZSDACODL0IF   E           K DISK    INFSR(*PSSR)                                       CAS014
                                                                                              CAS014
      ** Midas GP Global Account Codes                                                        CAS014
     FGPACODL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS014
 
 
     D ZON             S             10A   DIM(20)
     D ZBC             S              3A   DIM(20)
 
     D POWER           S              8  0 DIM(8) CTDATA PERRCD(1)
 
     D BRC             S              3A   DIM(999)
     D CYC             S              3A   DIM(999)
 
      ** Parameters for AOSARDR0                                                              CAS014
     D PrtCd           S              7                                                       CAS014
     D Optn            S              7                                                       CAS014
     D PSARD           S              6                                                       CAS014
                                                                                              CAS014
      ** CAS014 variables                                                                     CAS014
     D CAS014          S              1                                                       CAS014
     D Wk_Cnvrt        S              9                                                       CAS014
     D Wk_Acod         S             10                                                       CAS014
     D Wk_AcSc         S              2                                                       CAS014
     D Wk_Ccy          S              3                                                       CAS014
                                                                                              CAS014
      ** Interim Average Period End                                                           CAS014
     D Wk_IntDt        DS             4                                                       CAS014
     D  Wk_IntYY               1      2                                                       CAS014
     D  Wk_IntMM               3      4                                                       CAS014
                                                                                              CAS014
      ** Reporting Average Period End                                                         CAS014
     D Wk_RptDt        DS             4                                                       CAS014
     D  Wk_RptYY               1      2                                                       CAS014
     D  Wk_RptMM               3      4                                                       CAS014
                                                                                              CAS014
      **  Midas API Message Header Format Definition                                          CAS014
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAS014
                                                                                              CAS014
      * Branch Details
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
      * Currency Details
     D GPCURR        E DS                  EXTNAME(GPCURRPD)
     D                                     PREFIX(C_)
      * Historic Rate Details
     D GPHHOX        E DS                  EXTNAME(GPHHOXPD)
      * Historic Rate Details
     D GZSDCUHS      E DS                  EXTNAME(GZSDCUHSPD)
                                                                                              CAS014
      ** Switchable Feature descriptions                                                      CAS014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS014
                                                                                              CAS014
     D LDA           E DS           256    EXTNAME(LDA)                                       CAS014
                                                                                              CAS014
      ** Local data area for database error details                                           CAS014
      ** *LOCK IN LDA immediately before and OUT LDA immediately                              CAS014
      ** after each database error handling.                                                  CAS014
      **                                                                                      CAS014
      **                                    134 141 DBFILE                                    CAS014
      **       Defines:                     142 170 DBKEY                                     CAS014
      **                                    171 180 DBPGM                                     CAS014
      **                                    181 1830DBASE                                     CAS014
                                                                                              CAS014
      * Access input branch
      * Log input branch as read
      * Load input zone
 
     C     BRCA          IFNE      P_BRCA
     C                   MOVEL     BRCA          I#BRCD
     C                   EXSR      ACS_BRCH
     C                   EXSR      LOG_BRCH
     C                   MOVEL     A8ZONE        I#ZONE
     C                   EXSR      LOAD_ZONE
     C                   MOVEL     BJCYCD        BaseCurrency      3
     C                   MOVEL     BRCA          P_BRCA            3
     C                   ENDIF
 
      * Account Currency Balance
 
     C                   Z-ADD     SEPBLAC       AccCcyBalance    21 3
 
      * Include Foreign Currency Transfer to Income & Expense
 
     C     IncForCcyTfr  IFNE      'Y'
     C                   SUB       SBSTFR        AccCcyBalance
     C                   ENDIF
 
      * Include Base Currency Transfer to Retained Earnings
 
     C     IncBasCcyTfr  IFNE      'Y'
     C                   SUB       SFCTFAC       AccCcyBalance
     C                   ENDIF
 
      * Convert Account Currency Balance to Interim Currency Balance
 
     C     Interim       IFEQ      'N'
     C                   MOVEL     CCY           IntCcy            3
     C                   Z-ADD     AccCcyBalance IntCcyBalance    21 3
     C                   ELSE
     C                   EXSR      CONVERT_IntCcy
     C                   ENDIF
 
      * Convert Interim Currency Balance to Reporting Currency
 
     C                   EXSR      CONVERT_RepCcy
 
     C     BranchConsolidIFEQ      'Y'
     C                   MOVEL     '&&&'         BRCA
     C                   ENDIF
 
     C     ZoneOrGlobal  IFEQ      'Z'
     C                   MOVEL     ACOD          ACCD
     C                   ELSE
     C                   MOVEL     A8ZONE        Zone4AccdX       10
     C                   MOVEL     ACOD          I#ACOD
     C                   EXSR      ACS_GACD
     C                   MOVEL     GlobalAcCode  ACCD
     C                   ENDIF
 
     C                   Z-ADD     RepCcyBalance REPCCYBAL
     C                   WRITE     GPACBLRD0
 
      * Accumulate branches and currencies
 
     C                   EXSR      ACCUM_BRC
     C                   EXSR      ACCUM_CYC
 
      * Output branch/currency pairs
 
     CLR                 EXSR      OUTPUT_BRCY
 
      /SPACE 5
      ********************************************************************
      * Convert To Interim Currency
      ********************************************************************
     C     CONVERT_IntCcyBEGSR
 
      * Determine interim currency
 
     C     Interim       IFEQ      'B'
     C                   MOVEL     BaseCurrency  IntCcy
     C                   ELSE
     C                   MOVEL     IntCcySpec    IntCcy
     C                   ENDIF
 
      * Convert using interim currency conversion method
 
     C                   Z-ADD     AccCcyBalance FR_Amount        21 3
     C                   Z-ADD     *ZERO         TO_Amount        21 3
 
     C                   MOVEL     CCY           FR_Ccy            3
     C                   MOVEL     CCY           I#CCY
     C                   EXSR      ACS_CURR
     C                   Z-ADD     C_GCNBDP      FR_NBDP           1 0
 
     C                   MOVEL     IntCcy        TO_Ccy            3
     C                   MOVEL     IntCcy        I#CCY
     C                   EXSR      ACS_CURR
     C                   Z-ADD     C_GCNBDP      TO_NBDP           1 0
 
     C     IntCcyConv    IFEQ      'N'
     C                   MOVEL     IntCcyZone4RtsZone4Rates       10
     C                   ELSE
     C                   MOVEL     A8ZONE        Zone4Rates
     C                   ENDIF
 
     C                   EVAL      Wk_Cnvrt = 'INTERIM  '                                     CAS014
                                                                                              CAS014
     C     IntCcyConv    IFEQ      'Z'
     C     IntCcyConv    OREQ      'N'
     C                   EXSR      CONV_ZONE
     C                   ELSE
     C                   EXSR      CONV_HEAD_OFF
     C                   ENDIF
 
     C                   Z-ADD     TO_Amount     IntCcyBalance
     C
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert To Report Currency
      ********************************************************************
     C     CONVERT_RepCcyBEGSR
 
      * Determine report currency
 
     C                   SELECT
     C     Report        WHENEQ    'A'
     C                   MOVEL     IntCcy        RepCcy
     C     Report        WHENEQ    'B'
     C                   MOVEL     BaseCurrency  RepCcy
     C     Report        WHENEQ    'H'
     C                   MOVEL     HeadOfCurrencyRepCcy
     C                   OTHER
     C                   MOVEL     RepCcySpec    RepCcy            3
     C                   ENDSL
 
      * Convert using report currency conversion method
 
     C                   Z-ADD     IntCcyBalance FR_Amount        21 3
     C                   Z-ADD     *ZERO         TO_Amount        21 3
 
     C                   MOVEL     IntCcy        FR_Ccy            3
     C                   MOVEL     IntCcy        I#CCY
     C                   EXSR      ACS_CURR
     C                   Z-ADD     C_GCNBDP      FR_NBDP           1 0
 
     C                   MOVEL     RepCcy        TO_Ccy            3
     C                   MOVEL     RepCcy        I#CCY
     C                   EXSR      ACS_CURR
     C                   Z-ADD     C_GCNBDP      TO_NBDP           1 0
 
     C     RepCcyConv    IFEQ      'N'
     C                   MOVEL     RepCcyZone4RtsZone4Rates       10
     C                   ELSE
     C                   MOVEL     A8ZONE        Zone4Rates
     C                   ENDIF
 
     C                   EVAL      Wk_Cnvrt = 'REPORTING'                                     CAS014
                                                                                              CAS014
     C     RepCcyConv    IFEQ      'Z'
     C     RepCcyConv    OREQ      'N'
     C                   EXSR      CONV_ZONE
     C                   ELSE
     C                   EXSR      CONV_HEAD_OFF
     C                   ENDIF
 
     C                   Z-ADD     TO_Amount     RepCcyBalance    21 3
     C
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Using Zone Rates
      ********************************************************************
     C     CONV_ZONE     BEGSR
 
      * Access FROM Currency Historic Rate
     C                   MOVEL     FR_CCY        I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      ACS_CUHS
     C                   Z-ADD     G2SPRT        FR_SPRT          13 8
     C                   MOVEL     G2MDIN        FR_MDIN           1
 
      * Access TO Currency Historic Rate
     C                   MOVEL     TO_CCY        I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      ACS_CUHS
     C                   Z-ADD     G2SPRT        TO_SPRT          13 8
     C                   MOVEL     G2MDIN        TO_MDIN           1
 
      ** If CAS014 is On and Interim Average Period is specified or                           CAS014
      **    Reporting Average Period is specified and                                         CAS014
      **    use Average Spot Rate instead of Current Spot Rate                                CAS014
                                                                                              CAS014
     C                   IF        CAS014 = 'Y'                                               CAS014
                                                                                              CAS014
     C                   IF        InCAv   = 'Y'           AND                                CAS014
     C                             InAvPd  <> *Blanks      AND                                CAS014
     C                             Wk_Cnvrt = 'INTERIM  '  OR                                 CAS014
     C                             RpCAv   = 'Y'           AND                                CAS014
     C                             RpAvPd  <> *Blanks      AND                                CAS014
     C                             Wk_Cnvrt = 'REPORTING'                                     CAS014
     C                   EXSR      SRAVSR                                                     CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
      * Determine Cross Rate from FROM Currency -> TO Currency
 
     C                   EXSR      DETCrossRATE
 
      * Adjust from amount for from currency decimal places
 
     C                   EVAL      CA = FR_NBDP + 1
     C                   EVAL      FR_Amount = FR_Amount * POWER(CA)
 
      * Convert
 
     C                   Z-ADD     FR_Amount     ZAMTCI
     C                   Z-ADD     CrossRATE     ZEXCH
     C                   MOVE      CrossMDIN     ZMD
     C                   MOVE      FR_CCY        ZCCYI
     C                   MOVE      TO_CCY        ZCCYO
     C                   Z-ADD     FR_NBDP       ZCDPI
     C                   Z-ADD     TO_NBDP       ZCDPO
     C                   EXSR      CONVERT
     C                   Z-ADD     ZAMTCO        TO_Amount
     C                   EVAL      CA = TO_NBDP + 1
     C                   EVAL      TO_Amount = TO_Amount / POWER(CA)
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Using Head-Office Rates
      ********************************************************************
     C     CONV_HEAD_OFF BEGSR
 
      * Access FROM Currency Historic Rate
     C                   MOVEL     FR_CCY        I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      ACS_HHOX
     C                   Z-ADD     GCSPRT        FR_SPRT          13 8
     C                   MOVEL     GCMDIN        FR_MDIN           1
 
      * Access TO Currency Historic Rate
     C                   MOVEL     TO_CCY        I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      ACS_HHOX
     C                   Z-ADD     GCSPRT        TO_SPRT          13 8
     C                   MOVEL     GCMDIN        TO_MDIN           1
 
      ** If CAS014 is On, execute Average Spot Rate sub routine                               CAS014
                                                                                              CAS014
     C                   IF        CAS014 = 'Y'                                               CAS014
                                                                                              CAS014
     C                   IF        InCAv   = 'Y'           AND                                CAS014
     C                             InAvPd  <> *Blanks      AND                                CAS014
     C                             Wk_Cnvrt = 'INTERIM  '  OR                                 CAS014
     C                             RpCAv   = 'Y'           AND                                CAS014
     C                             RpAvPd  <> *Blanks      AND                                CAS014
     C                             Wk_Cnvrt = 'REPORTING'                                     CAS014
     C                   EXSR      SRAVSR                                                     CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
      * Determine Cross Rate from FROM Currency -> TO Currency
 
     C                   EXSR      DETCrossRATE
 
      * Adjust from amount for from currency decimal places
 
     C                   EVAL      CA = FR_NBDP + 1
     C                   EVAL      FR_Amount = FR_Amount * POWER(CA)
 
      * Convert
 
     C                   Z-ADD     FR_Amount     ZAMTCI
     C                   Z-ADD     CrossRATE     ZEXCH
     C                   MOVE      CrossMDIN     ZMD
     C                   MOVE      FR_CCY        ZCCYI
     C                   MOVE      TO_CCY        ZCCYO
     C                   Z-ADD     FR_NBDP       ZCDPI
     C                   Z-ADD     TO_NBDP       ZCDPO
     C                   EXSR      CONVERT
     C                   Z-ADD     ZAMTCO        TO_Amount
     C                   EVAL      CA = TO_NBDP + 1
     C                   EVAL      TO_Amount = TO_Amount / POWER(CA)
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Determine Cross Rate from FROM Currency -> TO Currency
      **********************************************************************************
     C     DETCrossRATE  BEGSR
 
      * Determine cross rate from FROM Currency -> TO Currency
 
     C                   Z-ADD     FR_SPRT       ZRATE1
     C                   MOVE      FR_MDIN       ZMDI1
     C                   Z-ADD     TO_SPRT       ZRATE2
     C                   MOVE      TO_MDIN       ZMDI2
     C                   EXSR      CROSS_RATE
     C                   Z-ADD     ZRATEX        CrossRATE        13 8
     C                   MOVEL     ZMDIX         CrossMDIN         1
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Determine Cross Rate
      **********************************************************************************
     C     CROSS_RATE    BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Currency Conversion
      **********************************************************************************
     C     CONVERT       BEGSR
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Currency Details
      **********************************************************************************
     C     ACS_CURR      BEGSR
     C                   CALL      'GPACSCURR'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * currency
     C                   PARM                    I#CCY             3
     C                   PARM                    GPCURR
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Head-Office Rates
      **********************************************************************************
     C     ACS_HHOX      BEGSR
     C                   CALL      'GPACSHHOX'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * currency
      * year
      * period
      * date
     C                   PARM                    I#CCY             3
     C                   PARM      *ZERO         I#YR              2 0
     C                   PARM      *ZERO         I#PR              2 0
     C                   PARM                    I#DATE            5 0
     C                   PARM                    GPHHOX
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS      BEGSR
     C     Zone4Rates    CASEQ     ZON(01)       ACS_CUHS01
     C     Zone4Rates    CASEQ     ZON(02)       ACS_CUHS02
     C     Zone4Rates    CASEQ     ZON(03)       ACS_CUHS03
     C     Zone4Rates    CASEQ     ZON(04)       ACS_CUHS04
     C     Zone4Rates    CASEQ     ZON(05)       ACS_CUHS05
     C     Zone4Rates    CASEQ     ZON(06)       ACS_CUHS06
     C     Zone4Rates    CASEQ     ZON(07)       ACS_CUHS07
     C     Zone4Rates    CASEQ     ZON(08)       ACS_CUHS08
     C     Zone4Rates    CASEQ     ZON(09)       ACS_CUHS09
     C     Zone4Rates    CASEQ     ZON(10)       ACS_CUHS10
     C     Zone4Rates    CASEQ     ZON(11)       ACS_CUHS11
     C     Zone4Rates    CASEQ     ZON(12)       ACS_CUHS12
     C     Zone4Rates    CASEQ     ZON(13)       ACS_CUHS13
     C     Zone4Rates    CASEQ     ZON(14)       ACS_CUHS14
     C     Zone4Rates    CASEQ     ZON(15)       ACS_CUHS15
     C     Zone4Rates    CASEQ     ZON(16)       ACS_CUHS16
     C     Zone4Rates    CASEQ     ZON(17)       ACS_CUHS17
     C     Zone4Rates    CASEQ     ZON(18)       ACS_CUHS18
     C     Zone4Rates    CASEQ     ZON(19)       ACS_CUHS19
     C     Zone4Rates    CASEQ     ZON(20)       ACS_CUHS20
     C                   ENDCS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS01    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(01)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(01)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @01CIX            6 0
     C                   PARM                    #01#_CYDT      8000
     C                   PARM                    #01#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS02    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(02)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(02)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @02CIX            6 0
     C                   PARM                    #02#_CYDT      8000
     C                   PARM                    #02#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS03    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(03)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(03)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @03CIX            6 0
     C                   PARM                    #03#_CYDT      8000
     C                   PARM                    #03#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS04    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(04)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(04)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @04CIX            6 0
     C                   PARM                    #04#_CYDT      8000
     C                   PARM                    #04#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS05    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(05)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(05)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @05CIX            6 0
     C                   PARM                    #05#_CYDT      8000
     C                   PARM                    #05#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS06    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(06)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(06)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @06CIX            6 0
     C                   PARM                    #06#_CYDT      8000
     C                   PARM                    #06#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS07    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(07)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(07)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @07CIX            6 0
     C                   PARM                    #07#_CYDT      8000
     C                   PARM                    #07#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS08    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(08)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(08)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @08CIX            6 0
     C                   PARM                    #08#_CYDT      8000
     C                   PARM                    #08#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS09    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(09)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(09)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @09CIX            6 0
     C                   PARM                    #09#_CYDT      8000
     C                   PARM                    #09#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS10    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(10)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(10)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @10CIX            6 0
     C                   PARM                    #10#_CYDT      8000
     C                   PARM                    #10#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS11    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(11)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(11)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @11CIX            6 0
     C                   PARM                    #11#_CYDT      8000
     C                   PARM                    #11#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS12    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(12)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(12)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @12CIX            6 0
     C                   PARM                    #12#_CYDT      8000
     C                   PARM                    #12#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS13    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(13)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(13)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @13CIX            6 0
     C                   PARM                    #13#_CYDT      8000
     C                   PARM                    #13#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS14    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(14)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(14)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @14CIX            6 0
     C                   PARM                    #14#_CYDT      8000
     C                   PARM                    #14#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS15    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(15)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(15)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @15CIX            6 0
     C                   PARM                    #15#_CYDT      8000
     C                   PARM                    #15#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS16    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(16)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(16)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @16CIX            6 0
     C                   PARM                    #16#_CYDT      8000
     C                   PARM                    #16#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS17    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(17)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(17)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @17CIX            6 0
     C                   PARM                    #17#_CYDT      8000
     C                   PARM                    #17#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS18    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(18)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(18)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @18CIX            6 0
     C                   PARM                    #18#_CYDT      8000
     C                   PARM                    #18#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS19    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(19)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(19)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @19CIX            6 0
     C                   PARM                    #19#_CYDT      8000
     C                   PARM                    #19#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Historic Rates
      **********************************************************************************
     C     ACS_CUHS20    BEGSR
     C                   CALL      'GPACSCUHS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM      ZON(20)       I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM      ZBC(20)       I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @20CIX            6 0
     C                   PARM                    #20#_CYDT      8000
     C                   PARM                    #20#_RATEDT   14000
 
     C                   PARM                    GZSDCUHS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD      BEGSR
     C     Zone4AccdX    CASEQ     ZON(01)       ACS_GACD01
     C     Zone4AccdX    CASEQ     ZON(02)       ACS_GACD02
     C     Zone4AccdX    CASEQ     ZON(03)       ACS_GACD03
     C     Zone4AccdX    CASEQ     ZON(04)       ACS_GACD04
     C     Zone4AccdX    CASEQ     ZON(05)       ACS_GACD05
     C     Zone4AccdX    CASEQ     ZON(06)       ACS_GACD06
     C     Zone4AccdX    CASEQ     ZON(07)       ACS_GACD07
     C     Zone4AccdX    CASEQ     ZON(08)       ACS_GACD08
     C     Zone4AccdX    CASEQ     ZON(09)       ACS_GACD09
     C     Zone4AccdX    CASEQ     ZON(10)       ACS_GACD10
     C     Zone4AccdX    CASEQ     ZON(11)       ACS_GACD11
     C     Zone4AccdX    CASEQ     ZON(12)       ACS_GACD12
     C     Zone4AccdX    CASEQ     ZON(13)       ACS_GACD13
     C     Zone4AccdX    CASEQ     ZON(14)       ACS_GACD14
     C     Zone4AccdX    CASEQ     ZON(15)       ACS_GACD15
     C     Zone4AccdX    CASEQ     ZON(16)       ACS_GACD16
     C     Zone4AccdX    CASEQ     ZON(17)       ACS_GACD17
     C     Zone4AccdX    CASEQ     ZON(18)       ACS_GACD18
     C     Zone4AccdX    CASEQ     ZON(19)       ACS_GACD19
     C     Zone4AccdX    CASEQ     ZON(20)       ACS_GACD20
     C                   ENDCS
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD01    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(01)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @01DIX            6 0
     C                   PARM                    #01#_ZACOD    10000
     C                   PARM                    #01#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD02    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(02)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @02DIX            6 0
     C                   PARM                    #02#_ZACOD    10000
     C                   PARM                    #02#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD03    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(03)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @03DIX            6 0
     C                   PARM                    #03#_ZACOD    10000
     C                   PARM                    #03#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD04    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(04)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @04DIX            6 0
     C                   PARM                    #04#_ZACOD    10000
     C                   PARM                    #04#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD05    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(05)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @05DIX            6 0
     C                   PARM                    #05#_ZACOD    10000
     C                   PARM                    #05#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD06    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(06)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @06DIX            6 0
     C                   PARM                    #06#_ZACOD    10000
     C                   PARM                    #06#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD07    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(07)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @07DIX            6 0
     C                   PARM                    #07#_ZACOD    10000
     C                   PARM                    #07#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD08    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(08)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @08DIX            6 0
     C                   PARM                    #08#_ZACOD    10000
     C                   PARM                    #08#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD09    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(09)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @09DIX            6 0
     C                   PARM                    #09#_ZACOD    10000
     C                   PARM                    #09#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD10    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(10)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @10DIX            6 0
     C                   PARM                    #10#_ZACOD    10000
     C                   PARM                    #10#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD11    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(11)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @11DIX            6 0
     C                   PARM                    #11#_ZACOD    10000
     C                   PARM                    #11#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD12    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(12)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @12DIX            6 0
     C                   PARM                    #12#_ZACOD    10000
     C                   PARM                    #12#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD13    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(13)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @13DIX            6 0
     C                   PARM                    #13#_ZACOD    10000
     C                   PARM                    #13#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD14    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(14)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @14DIX            6 0
     C                   PARM                    #14#_ZACOD    10000
     C                   PARM                    #14#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD15    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(15)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @15DIX            6 0
     C                   PARM                    #15#_ZACOD    10000
     C                   PARM                    #15#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD16    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(16)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @16DIX            6 0
     C                   PARM                    #16#_ZACOD    10000
     C                   PARM                    #16#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD17    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(17)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @17DIX            6 0
     C                   PARM                    #17#_ZACOD    10000
     C                   PARM                    #17#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD18    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(18)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @18DIX            6 0
     C                   PARM                    #18#_ZACOD    10000
     C                   PARM                    #18#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD19    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(19)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @19DIX            6 0
     C                   PARM                    #19#_ZACOD    10000
     C                   PARM                    #19#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access Global Account Code
      **********************************************************************************
     C     ACS_GACD20    BEGSR
     C                   CALL      'GPACSGACD'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM      ZON(20)       I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @20DIX            6 0
     C                   PARM                    #20#_ZACOD    10000
     C                   PARM                    #20#_GACOD    10000
 
     C                   PARM                    GlobalAcCode     10
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Access branch details
      **********************************************************************************
     C     ACS_BRCH      BEGSR
     C                   CALL      'GPACSBRCH'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * Branch
     C                   PARM                    I#BRCD            3
     C                   PARM                    GZSDBRCH
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Log branch
      **********************************************************************************
     C     LOG_BRCH      BEGSR
     C     I#BRCD        CHAIN     GPBSPLBD0                          99
     C     *IN99         IFEQ      *OFF
     C     RunType       IFEQ      '1'
     C                   EVAL      BREXT1 = 'Y'
     C                   ELSE
     C                   EVAL      BREXT2 = 'Y'
     C                   ENDIF
     C                   UPDATE    GPBSPLBD0
     C                   ENDIF
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Load a zone
      **********************************************************************************
     C     LOAD_ZONE     BEGSR
     C                   Z-ADD     1             Z                 2 0
     C     I#ZONE        LOOKUP    ZON(Z)                                 99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    ZON(Z)                                 99
     C                   MOVEL     I#ZONE        ZON(Z)
     C     I#ZONE        CHAIN     SDBANKD0                           99
     C   99              MOVEL     *BLANK        BJCYCD
     C                   MOVEL     BJCYCD        ZBC(Z)
     C                   ENDIF
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * Accumulate Branches
      ********************************************************************
     C     ACCUM_BRC     BEGSR
     C                   Z-ADD     1             Br                3 0
     C     BRCA          LOOKUP    BRC(Br)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    BRC(Br)                                99
     C                   MOVEL     BRCA          BRC(Br)
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Accumulate Currencies
      ********************************************************************
     C     ACCUM_CYC     BEGSR
     C                   Z-ADD     1             Cy                3 0
     C     REPCCY        LOOKUP    CYC(Cy)                                99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    CYC(Cy)                                99
     C                   MOVEL     REPCCY        CYC(Cy)
     C                   ENDIF
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Output Branch and Currency Pairs
      ********************************************************************
     C     OUTPUT_BRCY   BEGSR
     C                   Z-ADD     1             Br
     C     BRC(Br)       DOWNE     *BLANK
     C                   MOVEL     BRC(Br)       A8BRCD
     C                   Z-ADD     1             Cy
     C     CYC(Cy)       DOWNE     *BLANK
     C                   MOVE      CYC(Cy)       A6CYCD
     C     GPBSPLCK      KLIST
     C                   KFLD                    A8BRCD
     C                   KFLD                    A6CYCD
     C     GPBSPLCK      CHAIN     GPBSPLCD0                          99
     C   99              WRITE     GPBSPLCD0
     C                   ADD       1             Cy
     C                   ENDDO
     C                   ADD       1             Br
     C                   ENDDO
     C                   ENDSR
      ********************************************************************                    CAS014
      * Sub Routine for Average Spot Rate                                                     CAS014
      ********************************************************************                    CAS014
     C     SRAVSR        BEGSR                                                                CAS014
                                                                                              CAS014
      ** Check if Account Code is either Income or Expense                                    CAS014
                                                                                              CAS014
     C                   EXSR      CHKACOD                                                    CAS014
                                                                                              CAS014
      ** If Income or Expense...                                                              CAS014
                                                                                              CAS014
     C                   IF        Wk_AcSc = 'IN'  OR                                         CAS014
     C                             Wk_AcSc = 'EX'                                             CAS014
                                                                                              CAS014
      ** Retrieve Average Spot Rate and Multiply Divide Indicator                             CAS014
      **   for TO Currency                                                                    CAS014
                                                                                              CAS014
     C                   EVAL      Wk_Ccy = TO_CCY                                            CAS014
     C                   EXSR      ACSAVSR                                                    CAS014
     C                   IF        %FOUND(GPAVSRL2) AND                                       CAS014
     C                             ASASTD <> *ZERO                                            CAS014
     C                   EVAL      TO_SPRT = ASASTD                                           CAS014
     C                   EVAL      TO_MDIN = ASMDIN                                           CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDSR                                                                CAS014
                                                                                              CAS014
      ********************************************************************                    CAS014
      * Check Account Code if Income or Expense                                               CAS014
      ********************************************************************                    CAS014
     C     CHKACOD       BEGSR                                                                CAS014
                                                                                              CAS014
     C                   EVAL      Wk_AcSc = *Blanks                                          CAS014
     C                   MOVEL     ACOD          Wk_Acod                                      CAS014
                                                                                              CAS014
      ** Verify existence in GZ Account Codes File                                            CAS014
                                                                                              CAS014
     C     Wk_Acod       CHAIN     GZSDACODL0                                                 CAS014
     C                   IF        %FOUND(GZSDACODL0)                                         CAS014
     C                   EVAL      Wk_AcSc = A5ACSC                                           CAS014
                                                                                              CAS014
     C                   ELSE                                                                 CAS014
                                                                                              CAS014
      ** If not found, verify existence in GP Global Account Codes File                       CAS014
                                                                                              CAS014
     C     Wk_Acod       CHAIN     GPACODL0                                                   CAS014
                                                                                              CAS014
     C                   IF        %FOUND(GPACODL0)                                           CAS014
     C                   EVAL      Wk_AcSc = ACACSC                                           CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDSR                                                                CAS014
                                                                                              CAS014
      ********************************************************************                    CAS014
      * ACSAVSR - Access Average Spot Rate Subroutine                                         CAS014
      ********************************************************************                    CAS014
     C     ACSAVSR       BEGSR                                                                CAS014
                                                                                              CAS014
     C                   EVAL      KCCYD = Wk_Ccy                                             CAS014
                                                                                              CAS014
     C                   SELECT                                                               CAS014
                                                                                              CAS014
      ** If convert to Interim Currency...                                                    CAS014
                                                                                              CAS014
     C                   WHEN      Wk_Cnvrt = 'INTERIM  '                                     CAS014
     C                   EVAL      KPDFQ = InAvPd                                             CAS014
     C                   EVAL      KPDYN = Wk_IntYY                                           CAS014
     C                   EVAL      KPDMN = Wk_IntMM                                           CAS014
                                                                                              CAS014
     C                   IF        IntCcyConv = 'Z'  OR                                       CAS014
     C                             IntCcyConv = 'N'                                           CAS014
     C                   EVAL      KZONE = Zone4Rates                                         CAS014
     C                   ELSE                                                                 CAS014
     C                   EVAL      KZONE = *Blanks                                            CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
      ** If convert to Reporting Currency...                                                  CAS014
                                                                                              CAS014
     C                   WHEN      Wk_Cnvrt = 'REPORTING'                                     CAS014
                                                                                              CAS014
     C                   EVAL      KPDFQ = RpAvPd                                             CAS014
     C                   EVAL      KPDYN = Wk_RptYY                                           CAS014
     C                   EVAL      KPDMN = Wk_RptMM                                           CAS014
                                                                                              CAS014
     C                   IF        RepCcyConv = 'Z'  OR                                       CAS014
     C                             RepCcyConv = 'N'                                           CAS014
     C                   EVAL      KZONE = Zone4Rates                                         CAS014
     C                   ELSE                                                                 CAS014
     C                   EVAL      KZONE = *Blanks                                            CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C                   ENDSL                                                                CAS014
                                                                                              CAS014
     C     KAVSRL2       CHAIN     GPAVSRL2                                                   CAS014
                                                                                              CAS014
     C                   ENDSR                                                                CAS014
                                                                                              CAS014
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
 
                                                                                              CAS014
     C     *DTAARA       DEFINE                  LDA                                          CAS014
                                                                                              CAS014
     C                   Z-add     0             CA                1 0
 
     C     *LOVAL        SETLL     GPICDTD0
     C                   READ      GPICDTD0                               99
 
      * Return in error if global ICD not present
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'NO GLOBAL ICD PRESENT IN GPICDTPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     GLHOCY        HeadOfCurrency    3
 
      * Load input zones
 
     C                   MOVEL     IntCcyZone4RtsI#ZONE
     C                   EXSR      LOAD_ZONE
 
     C                   MOVEL     RepCcyZone4RtsI#ZONE
     C                   EXSR      LOAD_ZONE
 
      ** Determine if CAS014 is switched on                                                   CAS014
                                                                                              CAS014
     C                   CALL      'AOSARDR0'                                                 CAS014
     C                   PARM      *Blanks       PrtCd                                        CAS014
     C                   PARM      '*VERIFY'     Optn                                         CAS014
     C                   PARM      'CAS014'      PSARD                                        CAS014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS014
                                                                                              CAS014
                                                                                              CAS014
     C                   EVAL      CAS014 = 'N'                                               CAS014
                                                                                              CAS014
     C                   IF        PRTCD = *BLANKS                                            CAS014
     C                   EVAL      CAS014 = 'Y'                                               CAS014
     C                   ELSE                                                                 CAS014
                                                                                              CAS014
     C                   IF        PRTCD <> '*NRF   '                                         CAS014
                                                                                              CAS014
     C     *LOCK         IN        LDA                                                        CAS014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS014
     C                   EVAL      DBASE = 67                                                 CAS014
     C                   EVAL      DBKEY = 'CAS014'                                           CAS014
     C                   OUT       LDA                                                        CAS014
                                                                                              CAS014
     C                   EXSR      *PSSR                                                      CAS014
     C                   ENDIF                                                                CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
                                                                                              CAS014
     C                   IF        CAS014 = 'Y'                                               CAS014
     C                   IF        InCAv = 'Y'  OR                                            CAS014
     C                             RpCAv = 'Y'                                                CAS014
                                                                                              CAS014
      ** Convert Interim Average Rate Period End Date from MMYY to YYMM                       CAS014
                                                                                              CAS014
     C                   MOVEL     InAvPEnd      Wk_IntMM                                     CAS014
     C                   MOVE      InAvPEnd      Wk_IntYY                                     CAS014
                                                                                              CAS014
      ** Convert Reporting Average Rate Period End Date from MMYY to YYMM                     CAS014
                                                                                              CAS014
     C                   MOVEL     PRpAvPEnd     Wk_RptMM                                     CAS014
     C                   MOVE      PRpAvPEnd     Wk_RptYY                                     CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
     C                   ENDIF                                                                CAS014
                                                                                              CAS014
     C     KAVSRL2       KLIST                                                                CAS014
     C                   KFLD                    KCCYD             3                          CAS014
     C                   KFLD                    KPDFQ             2                          CAS014
     C                   KFLD                    KPDYN             2                          CAS014
     C                   KFLD                    KPDMN             2                          CAS014
     C                   KFLD                    KZONE            10                          CAS014
                                                                                              CAS014
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
     C                   PARM                    ZoneOrGlobal      1
 
     C                   PARM                    BranchConsolid    1
 
     C                   PARM                    Interim           1
     C                   PARM                    IntCcySpec        3
     C                   PARM                    IntCcyConv        1
     C                   PARM                    IntCcyZone4Rts   10
 
     C                   PARM                    Report            1
     C                   PARM                    RepCcySpec        3
     C                   PARM                    RepCcyConv        1
     C                   PARM                    RepCcyZone4Rts   10
 
     C                   PARM                    IncForCcyTfr      1
     C                   PARM                    IncBasCcyTfr      1
 
     C                   PARM                    HistDate          5 0
 
     C                   PARM                    RunType           1
                                                                                              CAS014
      ** Interim Conversion of I/E                                                            CAS014
     C                   PARM                    InCAv             1                          CAS014
      ** Interim Average Rate Period                                                          CAS014
     C                   PARM                    InAvPd            2                          CAS014
      ** Interim Average Period End                                                           CAS014
     C                   PARM                    InAvPEnd          4                          CAS014
      ** Reporting Conversion of I/E                                                          CAS014
     C                   PARM                    RpCAv             1                          CAS014
      ** Reporting Average Rate Period                                                        CAS014
     C                   PARM                    RpAvPd            2                          CAS014
      ** Reporting Average Period End                                                         CAS014
     C                   PARM                    PRpAvPEnd         4                          CAS014
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
