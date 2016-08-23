     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Funds Transfer FX Profit/Loss')        *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSFTFX - Access Funds Transfer FX Profit/Loss             *                       CPK022
      ***MXACSFXPL*-*Access*Funds*Transfer*FX*Profit/Loss**************                       CPK022
      *                                                               *
      *  Function:  This module derives the profit/loss in base       *
      *             currency of funds transfer FX transactions        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 241970             Data 05Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CPK022             Data 22Jul05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX002  *CREATE    Data 26Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CPK022 - Correct the module name in header box               *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *                                                               *
      *****************************************************************
 
     FSDCUHSL2  IF   E           K DISK    INFSR(*PSSR)
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)
     FINPAY     IF   E           K DISK    INFSR(*PSSR)
     FCQCOD     IF   E           K DISK    INFSR(*PSSR)
     FCQPAC     IF   E           K DISK    INFSR(*PSSR)
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * Maximum number of historic spot rates
     D MaxNoHsSR       C                   CONST(1000)
 
 
      * Key to historic spot ratea
     D #_CUHS          S              8    DIM(MaxNoHsSR)
      * Historic spot rates
     D #_CUHSDT        S             14    DIM(MaxNoHsSR)
 
 
      * Historic spot rates
     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)
 
 
      * Funds Transfer FX Profit/Loss
     D FTFX          E DS                  EXTNAME(MXFTFXPD)
 
 
     D                 DS
     D  Ccy_Date               1      8
     D  Currency               1      3
     D  HistDate               4      8S 0
 
     D                 DS
     D  A_PREF                 1     15
     D  A_PYTP                12     13
 
 
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      ** External DS for FT details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_PREF           15
     C                   MOVEL     I#LFD2        A_SEQ             2
 
      * Error if no payment reference is supplied
 
     C     A_PREF        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK PAYMENT REFERENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no payment sequence is supplied
      * and the payment type is not 'OUTGOING' or 'INCOMING'
 
     C     A_SEQ         IFEQ      *BLANK
     C     A_PYTP        ANDNE     'OP'
     C     A_PYTP        ANDNE     'IN'
     C     A_SEQ         OREQ      '00'
     C     A_PYTP        ANDNE     'OP'
     C     A_PYTP        ANDNE     'IN'
     C                   EVAL      I#ERMS = 'INVALID PAY SEQUENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access the payment details
 
     C                   MOVEL     A_PREF        PREF
 
     C                   SELECT
     C     A_PYTP        WHENEQ    'OP'
     C     PREF          CHAIN     OTPAYDDF                           99        *
 
     C     A_PYTP        WHENEQ    'IN'
     C     PREF          CHAIN     INPAYDDF                           99        *
 
     C     A_PYTP        WHENEQ    'CC'
     C                   MOVEL     A_SEQ         SEQ
     C     PREF          CHAIN     CQCODDDF                           99        *
     C  N99CQK           CHAIN     CQCOCDDF                           99        *
 
     C     A_PYTP        WHENEQ    'CP'
     C                   MOVEL     A_SEQ         SEQ
     C     PREF          CHAIN     CQPACDDF                           99        *
     C  N99CQK           CHAIN     CQPADDDF                           99        *
 
     C                   ENDSL
 
      * Error if no record was found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID PAYMENT REFERENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Clear output format
 
     C                   CLEAR                   FTFX
 
      * Set base currency and base currency decimal places
      * on output format
 
     C                   MOVEL     BJCYCD        FTBCCY
     C                   Z-ADD     BasCcyDec     FTBCDP
 
      * Calculate the FX Profit/Loss
 
     C                   SELECT
     C     A_PYTP        WHENEQ    'OP'
     C                   EXSR      CALFX_OP                                     *
 
     C     A_PYTP        WHENEQ    'IN'
     C                   EXSR      CALFX_IN                                     *
 
     C     A_PYTP        WHENEQ    'CC'
     C                   EXSR      CALFX_CC                                     *
 
     C     A_PYTP        WHENEQ    'CP'
     C                   EXSR      CALFX_CP                                     *
 
     C                   ENDSL
 
 
      * Set up output data
 
     C                   EVAL      InData = FTFX
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Calculate the FX Profit/Loss - OTPAYDD
      ********************************************************************
     C     CALFX_OP      BEGSR
 
      * If payment currency = settlement currency
      * then there is no FX transaction
 
     C     PCCY          IFEQ      SMCY
     C                   GOTO      ECALFXOP
     C                   ENDIF
 
      * Calculate our PAYMENT amount in base currency
      * ---------------------------------------------
 
     C     PCCY          IFEQ      BJCYCD
     C                   Z-ADD     PYAM          PAY_In_Bas       13 0
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     PCCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the payment amount
      * as at the original entry date of the transaction
      * then using this rate, convert the payment amount into base
 
     C                   MOVEL     PCCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     PYAM          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        PAY_In_Bas
     C                   ENDIF
 
      * Calculate our RECEIPT amount in base currency
      * ---------------------------------------------
 
     C     SMCY          IFEQ      BJCYCD
     C                   Z-ADD     SMAM          REC_In_Bas       13 0
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     SMCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the receipt amount
      * as at the original entry date of the transaction
      * then using this rate, convert the receipt amount into base
 
     C                   MOVEL     SMCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     SMAM          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        REC_In_Bas
     C                   ENDIF
 
      * FX profit is our receive amount - our payment amount
 
     C     REC_In_Bas    SUB       PAY_In_Bas    FTFXPL
 
     C     ECALFXOP      ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Calculate the FX Profit/Loss - INPAYDD
      ********************************************************************
     C     CALFX_IN      BEGSR
 
      * If payment currency = settlement currency
      * then there is no FX transaction
 
     C     PCCY          IFEQ      SMCY
     C                   GOTO      ECALFXIN
     C                   ENDIF
 
      * Calculate our PAYMENT amount in base currency
      * ---------------------------------------------
 
     C     PCCY          IFEQ      BJCYCD
     C                   Z-ADD     PYAM          PAY_In_Bas
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     PCCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the payment amount
      * as at the original entry date of the transaction
      * then using this rate, convert the payment amount into base
 
     C                   MOVEL     PCCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     PYAM          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        PAY_In_Bas
     C                   ENDIF
 
      * Calculate our RECEIPT amount in base currency
      * ---------------------------------------------
 
     C     SMCY          IFEQ      BJCYCD
     C                   Z-ADD     SMAM          REC_In_Bas
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     SMCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the receipt amount
      * as at the original entry date of the transaction
      * then using this rate, convert the receipt amount into base
 
     C                   MOVEL     SMCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     SMAM          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        REC_In_Bas
     C                   ENDIF
 
      * FX profit is our receive amount - our payment amount
 
     C     REC_In_Bas    SUB       PAY_In_Bas    FTFXPL
 
     C     ECALFXIN      ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Calculate the FX Profit/Loss - CQCOCDD
      ********************************************************************
     C     CALFX_CC      BEGSR
 
      * If credit currency = settlement currency
      * then there is no FX transaction
 
     C     CRCY          IFEQ      SMCY
     C                   GOTO      ECALFXCC
     C                   ENDIF
 
      * Calculate our PAYMENT amount in base currency
      * ---------------------------------------------
 
     C     CRCY          IFEQ      BJCYCD
     C                   Z-ADD     CCYAM         PAY_In_Bas
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     CRCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the payment amount
      * as at the original entry date of the transaction
      * then using this rate, convert the payment amount into base
 
     C                   MOVEL     CRCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     CCYAM         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        PAY_In_Bas
     C                   ENDIF
 
      * Calculate our RECEIPT amount in base currency
      * ---------------------------------------------
 
     C     SMCY          IFEQ      BJCYCD
     C                   Z-ADD     CQAM          REC_In_Bas
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     SMCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the receipt amount
      * as at the original entry date of the transaction
      * then using this rate, convert the receipt amount into base
 
     C                   MOVEL     SMCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        REC_In_Bas
     C                   ENDIF
 
      * FX profit is our receive amount - our payment amount
 
     C     REC_In_Bas    SUB       PAY_In_Bas    FTFXPL
 
 
     C     ECALFXCC      ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Calculate the FX Profit/Loss - CQPADDD
      ********************************************************************
     C     CALFX_CP      BEGSR
 
      * If debit currency = payment currency
      * then there is no FX transaction
 
     C     DRCY          IFEQ      PCCY
     C                   GOTO      ECALFXCP
     C                   ENDIF
 
      * Calculate our PAYMENT amount in base currency
      * ---------------------------------------------
 
     C     PCCY          IFEQ      BJCYCD
     C                   Z-ADD     CQAM          PAY_In_Bas
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     PCCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the payment amount
      * as at the original entry date of the transaction
      * then using this rate, convert the payment amount into base
 
     C                   MOVEL     PCCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     CQAM          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        PAY_In_Bas
     C                   ENDIF
 
      * Calculate our RECEIPT amount in base currency
      * ---------------------------------------------
 
     C     DRCY          IFEQ      BJCYCD
     C                   Z-ADD     PDDRAM        REC_In_Bas
     C                   ELSE
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     DRCY          I#LFD1
     C                   EXSR      GET_CCYD
 
      * Calculate the historic spot rate for the receipt amount
      * as at the original entry date of the transaction
      * then using this rate, convert the receipt amount into base
 
     C                   MOVEL     DRCY          Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     PDDRAM        ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        REC_In_Bas
     C                   ENDIF
 
      * FX profit is our receive amount - our payment amount
 
     C     REC_In_Bas    SUB       PAY_In_Bas    FTFXPL
 
     C     ECALFXCP      ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Calculate Base Currency Equivalent Amount
      ********************************************************************
     C     CAL_BCEQ      BEGSR
 
      * Convert the amount into base currency
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM      G2SPRT        ZEXCH            13 8
     C                   PARM      G2MDIN        ZMD               1
     C                   PARM      Currency      ZCCYI             3
     C                   PARM      BJCYCD        ZCCYO             3
     C                   PARM      A6NBDP        ZCDPI             1 0
     C                   PARM      BasCcyDec     ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Get the currency details
      ********************************************************************
     C     GET_CCYD      BEGSR
 
     C                   CALLB     'MXACSCURR'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the currency was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CURRENCY:'
     C                             + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDCURR = InData
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine the historic spot rate of a currency
      ********************************************************************
     C     DET_HSPOT     BEGSR
 
      * Look for a historic rate for the currency and date
 
     C                   Z-ADD     1             @IX               6 0
     C     Ccy_Date      LOOKUP    #_CUHS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CUHSDT(@IX) SDCUHS
     C                   ELSE
 
      * Access the historic spot rate
 
     C                   CLEAR                   SDCUHS
     C     SDCUHSKF      CHAIN     SDCUHSD0                           99        *
 
      * If the rate was not found for the supplied date
      * get the rate prior to this date
 
     C     *in99         IFEQ      '1'
     C     SDCUHSKF      SETLL     SDCUHSD0                                     *
     C     SDCUHSKP      READPE    SDCUHSD0                               99    *
     C                   ENDIF
 
      * If a rate prior to the supplied date was not found
      * use the first rate after the supplied date
 
     C     *in99         IFEQ      '1'
     C     SDCUHSKF      SETLL     SDCUHSD0                                     *
     C     SDCUHSKP      READE     SDCUHSD0                               99    *
     C                   ENDIF
 
      * Save the historic spot rate details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CUHS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     Ccy_Date      #_CUHS(@IX)
     C                   MOVEL     SDCUHS        #_CUHSDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     Ccy_Date      #_CUHS(@CIX)
     C                   MOVEL     SDCUHS        #_CUHSDT(@CIX)
     C     @CIX          IFEQ      MaxNoHsSR
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      **  Access FT Details
 
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDFTFR        PARM      SDFTFR        DSFDY
 
      *  Access Base Currency Decimal Places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6NBDP        BasCcyDec         1 0
 
 
     C                   Z-ADD     *ZERO         @CIX              6 0
 
      * Key lists
 
     C     SDCUHSKF      KLIST
     C                   KFLD                    Currency
     C                   KFLD                    HistDate
     C     SDCUHSKP      KLIST
     C                   KFLD                    Currency
     C     CQK           KLIST
     C                   KFLD                    PREF             15
     C                   KFLD                    SEQ               2 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
