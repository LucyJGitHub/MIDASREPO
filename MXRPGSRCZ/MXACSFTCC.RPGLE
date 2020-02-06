     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Funds Transfer Converted Charges')     *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSFTCC - Access Funds Transfer Converted Charges          *
      *                                                               *
      *  Function:  This module derives the base currency equivalent  *
      *             of funds transfer charge amounts.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                                    Date                       *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX002  *CREATE    Data 26Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
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
 
 
      * Funds Transfer Converted Charges
     D FTCC          E DS                  EXTNAME(MXFTCCPD)
 
 
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
 
 
     IOTPAYDDF
     I              OPDUM7                      DUMA7
     IINPAYDDF
     I              INDUM7                      DUMA7
 
 
 
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
 
     C                   CLEAR                   FTCC
 
      * Set base currency and base currency decimal places
      * on output format
 
     C                   MOVEL     BJCYCD        FTBCCY
     C                   Z-ADD     BasCcyDec     FTBCDP
 
      * Convert the charges
 
     C                   SELECT
     C     A_PYTP        WHENEQ    'OP'
     C                   EXSR      CONV_OP                                      *
 
     C     A_PYTP        WHENEQ    'IN'
     C                   EXSR      CONV_IN                                      *
 
     C     A_PYTP        WHENEQ    'CC'
     C                   EXSR      CONV_CC                                      *
 
     C     A_PYTP        WHENEQ    'CP'
     C                   EXSR      CONV_CP                                      *
 
     C                   ENDSL
 
 
      * Set up output data
 
     C                   EVAL      InData = FTCC
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Convert Charges to Base Currency - OTPAYDD
      ********************************************************************
     C     CONV_OP       BEGSR
 
      * If charging currency is 'BASE' or 'LOCAL'
      * or if 'charges to the debit of' account is present
      * then all charges are in base currency
 
     C     BTCHCY        IFNE      'C'
     C     CDRO          ORNE      *ZERO
     C                   Z-ADD     DUMA1         FTTRCM
     C                   Z-ADD     DUMA2         FTTXCH
     C                   Z-ADD     DUMA3         FTCQCH
     C                   Z-ADD     DUMA4         FTCSTA
     C                   Z-ADD     DUMA5         FTSPCH
     C                   Z-ADD     DUMA6         FTMSCH
     C                   Z-ADD     DUMA7         FTCHCM
     C                   MOVEL     BJCYCD        FTCCCY
     C                   Z-ADD     BasCcyDec     FTCCDP
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   GOTO      ECONVOP
     C                   ENDIF
 
      * If charging currency is 'CHARGES CURRENCY'
      * (the rate from payment to setlement currency can be used
      *  for conversions where one currency is the base currency)
 
     C     BTCHCY        IFEQ      'C'
 
      * If Add/Deduct inicator is 'ADD'
      * then all charges are in settlement currency
      * Otherwise (if 'DEDUCT') all charges are in payment currency
 
     C     ADDC          IFEQ      'A'
     C                   MOVEL     SMCY          FTCCCY
     C                   ELSE
     C                   MOVEL     PCCY          FTCCCY
     C                   ENDIF
 
      * Get charge currency details
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     FTCCCY        I#LFD1
     C                   EXSR      GET_CCYD
     C                   Z-ADD     A6NBDP        FTCCDP
 
      * If the charge currency is base
      * the conversion rate from charge currency to base currency is 1
 
     C     FTCCCY        IFEQ      BJCYCD
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   ELSE
 
      * If pay or settle currencies are base
      * Use the rate on the transaction
      * as the rate to convert to base currency
 
     C     PCCY          IFEQ      BJCYCD
     C     SMCY          OREQ      BJCYCD
     C                   Z-ADD     RATE          FTCRAT
     C                   MOVEL     A6MDIN        FTCMDI
     C                   ELSE
 
      * Otherwise calculate the historic spot rate for the charge currency
      * as at the original entry date of the transaction
 
     C                   MOVEL     FTCCCY        Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     G2SPRT        FTCRAT
     C                   MOVEL     G2MDIN        FTCMDI
     C                   ENDIF
     C                   ENDIF
 
      * Do conversions
     C                   Z-ADD     DUMA1         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTRCM
 
     C                   Z-ADD     DUMA2         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTXCH
 
     C                   Z-ADD     DUMA3         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCQCH
 
     C                   Z-ADD     DUMA4         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCSTA
 
     C                   Z-ADD     DUMA5         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTSPCH
 
     C                   Z-ADD     DUMA6         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTMSCH
 
     C                   Z-ADD     DUMA7         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCHCM
 
     C                   GOTO      ECONVOP
     C                   ENDIF
 
     C     ECONVOP       ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Convert Charges to Base Currency - INPAYDD
      ********************************************************************
     C     CONV_IN       BEGSR
 
      * If charging currency is 'BASE' or 'LOCAL'
      * or if 'charges to the debit of' account is present
      * then all charges are in base currency
 
     C     BTCHCY        IFNE      'C'
     C     CDRO          ORNE      *ZERO
     C                   Z-ADD     DUMA1         FTTRCM
     C                   Z-ADD     DUMA2         FTTXCH
     C                   Z-ADD     DUMA3         FTCQCH
     C                   Z-ADD     DUMA4         FTADCH
     C                   Z-ADD     DUMA5         FTTLCH
     C                   Z-ADD     DUMA6         FTMSCH
     C                   Z-ADD     DUMA7         FTCHCM
     C                   MOVEL     BJCYCD        FTCCCY
     C                   Z-ADD     BasCcyDec     FTCCDP
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   GOTO      ECONVIN
     C                   ENDIF
 
      * If charging currency is 'CHARGES CURRENCY'
      * (the rate from payment to setlement currency can be used
      *  for conversions where one currency is the base currency)
 
     C     BTCHCY        IFEQ      'C'
 
      * If Add/Deduct inicator is 'ADD'
      * then all charges are in settlement currency
      * Otherwise (if 'DEDUCT') all charges are in payment currency
 
     C     ADDC          IFEQ      'A'
     C                   MOVEL     SMCY          FTCCCY
     C                   ELSE
     C                   MOVEL     PCCY          FTCCCY
     C                   ENDIF
 
      * Get charge currency details
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     FTCCCY        I#LFD1
     C                   EXSR      GET_CCYD
     C                   Z-ADD     A6NBDP        FTCCDP
 
      * If the charge currency is base
      * the conversion rate from charge currency to base currency is 1
 
     C     FTCCCY        IFEQ      BJCYCD
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   ELSE
 
      * If pay or settle currencies are base
      * Use the rate on the transaction
      * as the rate to convert to base currency
 
     C     PCCY          IFEQ      BJCYCD
     C     SMCY          OREQ      BJCYCD
     C                   Z-ADD     RATE          FTCRAT
     C                   MOVEL     A6MDIN        FTCMDI
     C                   ELSE
 
      * Otherwise calculate the historic spot rate for the charge currency
      * as at the original entry date of the transaction
 
     C                   MOVEL     FTCCCY        Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     G2SPRT        FTCRAT
     C                   MOVEL     G2MDIN        FTCMDI
     C                   ENDIF
     C                   ENDIF
 
      * Do conversions
     C                   Z-ADD     DUMA1         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTRCM
 
     C                   Z-ADD     DUMA2         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTXCH
 
     C                   Z-ADD     DUMA3         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCQCH
 
     C                   Z-ADD     DUMA4         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTADCH
 
     C                   Z-ADD     DUMA5         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTLCH
 
     C                   Z-ADD     DUMA6         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTMSCH
 
     C                   Z-ADD     DUMA7         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCHCM
 
     C                   GOTO      ECONVIN
     C                   ENDIF
 
     C     ECONVIN       ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Convert Charges to Base Currency - CQCOCDD
      ********************************************************************
     C     CONV_CC       BEGSR
 
      * If charging currency is 'BASE' or 'LOCAL'
      * or if 'charges to the debit of' account is present
      * then all charges are in base currency
 
     C     BTCHCY        IFNE      'C'
     C     CDRO          ORNE      *ZERO
     C                   Z-ADD     DUMA1         FTTRCM
     C                   Z-ADD     DUMA4         FTCOLL
     C                   Z-ADD     DUMA3         FTCSTA
     C                   Z-ADD     DUMA2         FTTXCH
     C                   Z-ADD     CCDUM5        FTCHCM
     C                   MOVEL     BJCYCD        FTCCCY
     C                   Z-ADD     BasCcyDec     FTCCDP
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   GOTO      ECONVCC
     C                   ENDIF
 
      * If charging currency is 'CHARGES CURRENCY'
      * (the rate from payment to setlement currency can be used
      *  for conversions where one currency is the base currency)
 
     C     BTCHCY        IFEQ      'C'
 
      * All charges are in credit currency
 
     C                   MOVEL     CRCY          FTCCCY
 
      * Get charge currency details
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     FTCCCY        I#LFD1
     C                   EXSR      GET_CCYD
     C                   Z-ADD     A6NBDP        FTCCDP
 
      * If the charge currency is base
      * the conversion rate from charge currency to base currency is 1
 
     C     FTCCCY        IFEQ      BJCYCD
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   ELSE
 
      * If the settlement currency is base
      * Use the rate on the transaction
      * as the rate to convert to base currency
 
     C     SMCY          IFEQ      BJCYCD
     C                   Z-ADD     RATE          FTCRAT
     C                   MOVEL     A6MDIN        FTCMDI
     C                   ELSE
 
      * Otherwise calculate the historic spot rate for the charge currency
      * as at the original entry date of the transaction
 
     C                   MOVEL     FTCCCY        Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     G2SPRT        FTCRAT
     C                   MOVEL     G2MDIN        FTCMDI
     C                   ENDIF
     C                   ENDIF
 
      * Do conversions
     C                   Z-ADD     DUMA1         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTRCM
 
     C                   Z-ADD     DUMA4         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCOLL
 
     C                   Z-ADD     DUMA3         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCSTA
 
     C                   Z-ADD     DUMA2         ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTXCH
 
     C                   Z-ADD     CCDUM5        ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCHCM
 
     C                   GOTO      ECONVCC
     C                   ENDIF
 
     C     ECONVCC       ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Convert Charges to Base Currency - CQPADDD
      ********************************************************************
     C     CONV_CP       BEGSR
 
      * If charging currency is 'BASE' or 'LOCAL'
      * or if 'charges to the debit of' account is present
      * then all charges are in base currency
 
     C     BTCHCY        IFNE      'C'
     C     CDRO          ORNE      *ZERO
     C                   Z-ADD     TRCH          FTTRCM
     C                   Z-ADD     CSTH          FTCSTA
     C                   Z-ADD     COLH          FTCOLL
     C                   Z-ADD     PDCHCH        FTCHCM
     C                   MOVEL     BJCYCD        FTCCCY
     C                   Z-ADD     BasCcyDec     FTCCDP
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   GOTO      ECONVCP
     C                   ENDIF
 
      * If charging currency is 'CHARGES CURRENCY'
      * (the rate from payment to setlement currency can be used
      *  for conversions where one currency is the base currency)
 
     C     BTCHCY        IFEQ      'C'
 
      * All charges are in debit currency
 
     C                   MOVEL     DRCY          FTCCCY
 
      * Get charge currency details
 
     C                   MOVEL     *BLANK        I#LFD1
     C                   MOVEL     FTCCCY        I#LFD1
     C                   EXSR      GET_CCYD
     C                   Z-ADD     A6NBDP        FTCCDP
 
      * If the charge currency is base
      * the conversion rate from charge currency to base currency is 1
 
     C     FTCCCY        IFEQ      BJCYCD
     C                   Z-ADD     1             FTCRAT
     C                   MOVEL     'M'           FTCMDI
     C                   ELSE
 
      * If the payment currency is base
      * Use the rate on the transaction
      * as the rate to convert to base currency
 
     C     PCCY          IFEQ      BJCYCD
     C                   Z-ADD     RATE          FTCRAT
     C                   MOVEL     A6MDIN        FTCMDI
     C                   ELSE
 
      * Otherwise calculate the historic spot rate for the charge currency
      * as at the original entry date of the transaction
 
     C                   MOVEL     FTCCCY        Currency
     C                   Z-ADD     OEDT          HistDate
     C                   EXSR      DET_HSPOT
     C                   Z-ADD     G2SPRT        FTCRAT
     C                   MOVEL     G2MDIN        FTCMDI
     C                   ENDIF
     C                   ENDIF
 
      * Do conversions
     C                   Z-ADD     TRCH          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTTRCM
 
     C                   Z-ADD     CSTH          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCSTA
 
     C                   Z-ADD     COLH          ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCOLL
 
     C                   Z-ADD     PDCHCH        ZAMTCI
     C                   EXSR      CAL_BCEQ
     C                   Z-ADD     ZAMTCO        FTCHCM
 
     C                   GOTO      ECONVCP
     C                   ENDIF
 
     C     ECONVCP       ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Calculate Base Currency Equivalent Amount
      ********************************************************************
     C     CAL_BCEQ      BEGSR
 
      * Convert the amount into base currency
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM      FTCRAT        ZEXCH            13 8
     C                   PARM      FTCMDI        ZMD               1
     C                   PARM      FTCCCY        ZCCYI             3
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
(c) Finastra International Limited 2001
