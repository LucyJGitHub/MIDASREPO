     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate buy & sell currencies & amounts')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVBSAMTS - Validate Buy and Sell Currencies & Amounts       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL091             Date 12Dec12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23051           Date 23Feb09               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248269             Date 25Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      *                 205966             Date 10Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 148947             Date 04Dec98               *
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL091 - FX Auto Calculation (GIB016)                        *
      *         - Added hooks :                                       *
      *           CDL091_001 to CDL091_006                            *
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23051 - Defaulting of Buy or Sell Currency if left blank  *
      *             in FXDL input screen                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  205966 - Amount does not have to match that on other deal    *
      *           for broker code = 'SWAP'                            *
      *  148947 - After base currency conversion, not possible to     *
      *           amend 'FP' and 'FS' deals because deal type may     *
      *           not be amended and base currency is not involved    *
      *           in the deal anymore. Do not check action code = A.  *
      *           Also wrong message displayed for Buying currency    *
      *                                                               *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FFDCCYPLL  IF   E           K DISK    INFSR(*PSSR)
     FFXREVHLL  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
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
     D/COPY WNCPYSRC,FXH00006
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
 
     D*RelDealDts      DS           100                                                       248269
     D RelDealDts      DS           113                                                       248269
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
     D  RelCCY1                4      6
     D  RelCCY2                7      9
     D  RelDAM1               10     24  0
     D  RelDAM2               25     39  0
 
 
 
      ** External data structure for currency codes file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              CER043
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
      ** EXTERNAL DS FOR SAR DETAILS                                                          CER043
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CER043
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER043
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    CER043
 
     D/COPY OFCPYSRCZ,CDL091_001                                                              CDL091
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)
 
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CER043
     D CER043          S              1A                                                      CER043
     D PRtCd           S              7A                                                      CER043
     D POptn           S              7A                                                      CER043
     D PSard           S              6A                                                      CER043
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      * BCCYV  - BUY CURRENCY VALIDATION
      *
     C                   EXSR      BCCYV
      *
      * SCCYV  - SELL CURRENCY VALIDATION
      *
     C                   EXSR      SCCYV
      *
      * BSCCYV - BUY & SELL CURRENCY CROSS VALIDATION
      *
     C     DDBccyOK      IFEQ      'Y'
     C     DDSccyOK      ANDEQ     'Y'
     C                   EXSR      BSCCYV
     C                   END
      *
      * Check if buy currency revaluation required
      *
     C     DDBccyOK      IFEQ      'Y'
     C     BGTRMG        ANDEQ     'Y'
     C                   EXSR      CHKRVB
     C                   END
      *
      * Check if sell currency revaluation required
      *
     C     DDSccyOK      IFEQ      'Y'
     C     BGTRMG        ANDEQ     'Y'
     C                   EXSR      CHKRVS
     C                   END
      *
      * BAMTV  - BUY AMOUNT VALIDATION
      *
     C                   EXSR      BAMTV
      *
      * SAMTV  - SELL AMOUNT VALIDATION
      *
     C                   EXSR      SAMTV
      *
      * BSAMTV - BUY & SELL AMOUNT CROSS VALIDATION
      *
     C     DDBccyOK      IFEQ      'Y'
     C     DDSccyOK      ANDEQ     'Y'
     C     DDBamtOK      ANDEQ     'Y'
     C     DDSamtOK      ANDEQ     'Y'
     C                   EXSR      BSAMTV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBccyOK      IFEQ      'N'
     C     DDSccyOK      OREQ      'N'
     C     DDBamtOK      OREQ      'N'
     C     DDSamtOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BCCYV  - BUY CURRENCY VALIDATION                             *
      *****************************************************************
     C     BCCYV         BEGSR
      *                                                                                     BUG23051
      ** Default buy currency to base currency if left blank                                BUG23051
      ** and sell currency is not the base currency                                         BUG23051
      *                                                                                     BUG23051
     C     CER043        IFEQ      'Y'                                                      BUG23051
     C     DDBCCY        ANDEQ     *BLANKS                                                  BUG23051
     C     DDSCCY        ANDNE     BJCYCD                                                   BUG23051
     C                   EVAL      DDBCCY = BJCYCD                                          BUG23051
     C                   ENDIF                                                              BUG23051
     C*
     C* Buy currency must not be blank
     C*
     C     DDBCCY        IFEQ      *BLANKS
     C                   MOVE      'N'           DDBccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0141'     MsgIdXAr(Idx)
     C                   END
     C*
     C* Get buy currency details
     C*
     C     DDBccyOK      IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        ORNE      'Y'
     C                   MOVE      'N'           DDBccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0202'     MsgIdXAr(Idx)
     C                   ELSE
     C*
     C* Buy currency details
     C*
     C                   MOVEL     A6CYCD        DDBCCY
     C                   Z-ADD     A6SPRT        @SPOT1           13 8          spot rate
     C                   MOVEL     A6NBDP        @CDP1             1 0          no of dec places
     C                   MOVEL     A6RDFC        @RDCY1            1            round down
     C                   Z-ADD     A6NQDP        @@NDP1            1 0          norm quot decs
     C                   Z-ADD     A6SCEX        @@SXP1                         scaling exponent
     C                   MOVE      A6MDIN        @@MDF1            1            mult/div ind
     C                   MOVE      A6MDEX        @@MDX1            1            mult/div ind,exch
     C                   Z-ADD     A6LSPR        @@LSP1           13 8          low spot rate
     C                   Z-ADD     A6HSRT        @@HSP1           13 8          high spot rate
     C                   Z-ADD     A6FXSD        @@SPD1            8 0          FX spot date
     C                   Z-ADD     A6RETP        @NEXRT1           5 2                        CER043
     C                   END
     C                   END
      *
      * If option takedown, buy currency must be that of option
      *
     C     DDBccyOK      IFEQ      'Y'
     C     DDDLTP        ANDEQ     'OT'
     C     RelCCY1       ANDNE     DDBCCY
     C                   MOVE      'N'           DDBccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0118'     MsgIdXAr(Idx)
     C                   END
      *
      * If swap, buy currency must be other currency on other deal
      *
     C     DDBccyOK      IFEQ      'Y'
     C     DDDLTP        ANDEQ     'SW'
     C     DDSdnoOK      ANDEQ     'Y'
     C     RelCCY2       ANDNE     DDBCCY
     C     DDBccyOK      OREQ      'Y'
     C     DDBRKR        ANDEQ     'SWAP'
     C     DDSdnoOK      ANDEQ     'Y'
     C     RelCCY2       ANDNE     DDBCCY
     C                   MOVE      'N'           DDBccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0120'     MsgIdXAr(Idx)
     C                   END
     C*
     C* Buy currency must be 1 of base currencies if 'foreign ccy sale'
     C*
     C     DDBccyOK      IFEQ      'Y'
     C     DDACTN        ANDEQ     'I'                                          148947
     C     DDDLTP        ANDEQ     'FS'
     C     DDBCCY        ANDNE     BJCYCD
     C     DDBCCY        ANDNE     BNCYDL
     C                   MOVE      'N'           DDBccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCCY'      FldNamXAr(Idx)
     C*******            MOVEL     'FXM1043'     MsgIdXAr(Idx)                  148947
     C                   MOVEL     'FXM1042'     MsgIdXAr(Idx)                  148947
     C                   END
      *
      * Buy currency for output
      *
     C                   MOVEL     DDBCCY        F3CCY1
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SCCYV  - SELL CURRENCY VALIDATION                             *
      *****************************************************************
     C     SCCYV         BEGSR
      *                                                                                     BUG23051
      ** Default sell currency to base currency if left blank                               BUG23051
      ** and buy currency is not the base currency                                          BUG23051
      *                                                                                     BUG23051
     C     CER043        IFEQ      'Y'                                                      BUG23051
     C     DDSCCY        ANDEQ     *BLANKS                                                  BUG23051
     C     DDBCCY        ANDNE     BJCYCD                                                   BUG23051
     C                   EVAL      DDSCCY = BJCYCD                                          BUG23051
     C                   ENDIF                                                              BUG23051
     C*
     C* Sell currency must not be blank
     C*
     C     DDSCCY        IFEQ      *BLANKS
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0142'     MsgIdXAr(Idx)
     C                   END
     C*
     C* Get sell currency details
     C*
     C     DDSccyOK      IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDSCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        ORNE      'Y'
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0203'     MsgIdXAr(Idx)
     C                   ELSE
     C*
     C* Sell currency details
     C*
     C                   MOVEL     A6CYCD        DDSCCY
     C                   Z-ADD     A6SPRT        @SPOT2           13 8          spot rate
     C                   MOVEL     A6NBDP        @CDP2             1 0          no of dec places
     C                   MOVEL     A6RDFC        @RDCY2            1            round down
     C                   Z-ADD     A6NQDP        @@NDP2            1 0          norm quot decs
     C                   Z-ADD     A6SCEX        @@SXP2                         scaling exponent
     C                   MOVE      A6MDIN        @@MDF2            1            mult/div ind
     C                   MOVE      A6MDEX        @@MDX2            1            mult/div ind,exch
     C                   Z-ADD     A6LSPR        @@LSP2           13 8          low spot rate
     C                   Z-ADD     A6HSRT        @@HSP2           13 8          high spot rate
     C                   Z-ADD     A6FXSD        @@SPD2            8 0          FX spot date
     C                   Z-ADD     A6RETP        @NEXRT2           5 2                        CER043
     C                   END
     C                   END
      *
      * If option takedown, sell currency must be that of option
      *
     C     DDSccyOK      IFEQ      'Y'
     C     DDDLTP        ANDEQ     'OT'
     C     RelCCY2       ANDNE     DDSCCY
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0119'     MsgIdXAr(Idx)
     C                   END
      *
      * If swap, sell currency must be other currency of other deal
      *
     C     DDSccyOK      IFEQ      'Y'
     C     DDDLTP        ANDEQ     'SW'
     C     DDSdnoOK      ANDEQ     'Y'
     C     RelCCY1       ANDNE     DDSCCY
     C     DDSccyOK      OREQ      'Y'
     C     DDBRKR        ANDEQ     'SWAP'
     C     DDSdnoOK      ANDEQ     'Y'
     C     RelCCY1       ANDNE     DDSCCY
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0121'     MsgIdXAr(Idx)
     C                   END
     C*
     C* Sell currency must be 1 of base currencies if 'foreign ccy purchase'
     C*
     C     DDSccyOK      IFEQ      'Y'
     C     DDACTN        ANDEQ     'I'                                          148947
     C     DDDLTP        ANDEQ     'FP'
     C     DDSCCY        ANDNE     BJCYCD
     C     DDSCCY        ANDNE     BNCYDL
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM1043'     MsgIdXAr(Idx)
     C                   END
      *
      * Sell currency for output
      *
     C                   MOVEL     DDSCCY        F3CCY2
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BSCCYV - BUY & SELL AMOUNT CROSS VALIDATION
      *****************************************************************
     C     BSCCYV        BEGSR
     C*
     C* Buy currency must not be the same as sell currency
     C*
     C/COPY WNCPYSRC,FXH00243
     C     DDBCCY        IFEQ      DDSCCY
     C                   MOVE      'N'           DDBccyOK
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0146'     MsgIdXAr(Idx)
     C                   END
     C/COPY WNCPYSRC,FXH00244
     C*
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * CHKRVB - Check if buy currency revaluation required
      *****************************************************************
     C     CHKRVB        BEGSR
     C*
     C     @TEST         KLIST
     C                   KFLD                    DDBCCY
     C                   KFLD                    @TPRD1
     C                   KFLD                    @PRD1
     C                   MOVE      *LOVAL        @TPRD1            1
     C                   Z-ADD     *LOVAL        @PRD1             2 0
     C     @TEST         SETLL     FDCCYPLL
     C     DDBCCY        READE     FDCCYPLL                               90
     C     *IN90         IFEQ      '1'
     C     XPDLTF        OREQ      '*'
     C                   MOVE      'N'           DDBccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0434'     MsgIdXAr(Idx)
     C                   END
     C*
     C     @TEST1        KLIST
     C                   KFLD                    DDBCCY
     C                   KFLD                    @VTE1             8 0
     C                   Z-ADD     *LOVAL        @VTE1
     C     @TEST1        SETLL     FXREVHLL
     C     DDBCCY        READE     FXREVHLL                               90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           DDBccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0436'     MsgIdXAr(Idx)
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * CHKRVS - Check if sell currency revaluation required
      *****************************************************************
     C     CHKRVS        BEGSR
     C*
     C     @TEST2        KLIST
     C                   KFLD                    DDSCCY
     C                   KFLD                    @TPRD1
     C                   KFLD                    @PRD1
     C                   MOVE      *LOVAL        @TPRD1
     C                   Z-ADD     *LOVAL        @PRD1
     C     @TEST2        SETLL     FDCCYPLL
     C     DDSCCY        READE     FDCCYPLL                               90
     C     *IN90         IFEQ      '1'
     C     XPDLTF        OREQ      '*'
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0435'     MsgIdXAr(Idx)
     C                   END
     C*
     C     @TEST3        KLIST
     C                   KFLD                    DDSCCY
     C                   KFLD                    @VTE1
     C                   Z-ADD     *LOVAL        @VTE1
     C     @TEST3        SETLL     FXREVHLL
     C     DDSCCY        READE     FXREVHLL                               90
     C     *IN90         IFEQ      '1'
     C                   MOVE      'N'           DDSccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0437'     MsgIdXAr(Idx)
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BAMTV  - BUY AMOUNT VALIDATION                               *
      *****************************************************************
     C     BAMTV         BEGSR
     C*
     C/COPY OFCPYSRCZ,CDL091_002                                                              CDL091
     C/COPY WNCPYSRC,FXH00007
     C* Buy amount must be defined
     C*
     C                   IF        CER043 <> 'Y'                                              CER043
     C     DDBAMT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDBamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0149'     MsgIdXAr(Idx)
     C                   END
                                                                                              CER043
     C                   ELSEIF    DDBAMT = *BLANKS                                           CER043
     C                             AND DDSAMT = *BLANKS                                       CER043
     C                   EVAL      DDBAmtOK = 'N'                                             CER043
     C                   EVAL      Idx = Idx + 1                                              CER043
     C                   EVAL      FldNamXAr(Idx) = 'DDBAMT'                                  CER043
     C                   EVAL      MsgIdXAr(Idx) = 'FXM0149'                                  CER043
     C                   EVAL      DDSAmtOK = 'N'                                             CER043
     C                   EVAL      Idx = Idx + 1                                              CER043
     C                   EVAL      FldNamXAr(Idx) = 'DDSAMT'                                  CER043
     C                   EVAL      MsgIdXAr(Idx) = 'FXM0154'                                  CER043
     C                   ENDIF                                                                CER043
     C*
     C* If buy currency is valid and buy amount is defined
     C* Check that buy amount is valid
     C*
     C                   IF        DDBAMT <> *BLANKS                                          CER043
                                                                                              CER043
     C     DDBccyOK      IFEQ      'Y'
     C     DDBamtOK      ANDEQ     'Y'
     C                   Z-ADD     @CDP1         @@IDP
     C     13            SUB       @CDP1         @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBAMT        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C                   EXSR      ZA0840
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDBamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0143'     MsgIdXAr(Idx)
     C                   ELSE
     C*
     C* Buy amount must not be zero.
     C*
     C                   MOVE      @@ALPH        DDBAMT
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDBamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0149'     MsgIdXAr(Idx)
     C                   END
      *
      * If option takedown, buy amount can't be > than option buy amt
      *
     C     DDDLTP        IFEQ      'OT'
     C     DDACTN        ANDEQ     'I'
     C     @@AMT         ANDGT     RelDAM1
     C                   MOVE      'N'           DDBamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0145'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END
     C                   END
     C*
     C* Buy amount for output to file
     C*
     C     DDBamtOK      IFEQ      'Y'
     C     DDBccyOK      ANDEQ     'Y'
     C                   Z-ADD     @@AMT         F3DAM1
     C                   END
                                                                                              CER043
     C                   ENDIF                                                                CER043
     C*
     C/COPY OFCPYSRCZ,CDL091_003                                                              CDL091
     C/COPY WNCPYSRC,FXH00008
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SAMTV  - SELL AMOUNT VALIDATION                               *
      *****************************************************************
     C     SAMTV         BEGSR
     C/COPY OFCPYSRCZ,CDL091_004                                                              CDL091
     C/COPY WNCPYSRC,FXH00009
      *
      * Sell amount must be defined
      *
     C                   IF        CER043 <> 'Y'                                              CER043
     C     DDSAMT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDSamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0154'     MsgIdXAr(Idx)
     C                   END
     C                   ENDIF                                                                CER043
     C*
     C* If sell currency is valid and sell amount is defined
     C* Check that sell amount is valid
     C*
     C                   IF        DDSAMT <> *BLANKS                                          CER043
                                                                                              CER043
     C     DDSccyOK      IFEQ      'Y'
     C     DDSamtOK      ANDEQ     'Y'
     C                   Z-ADD     @CDP2         @@IDP
     C     13            SUB       @CDP2         @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDSAMT        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C                   EXSR      ZA0840
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDSamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0144'     MsgIdXAr(Idx)
     C                   ELSE
     C*
     C**  The amount must not be zero.
     C*
     C                   MOVE      @@ALPH        DDSAMT
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDSamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0154'     MsgIdXAr(Idx)
     C                   END
      *
      * If option takedown, sell amount can't be > than option sell amt
      * (first make related sale amount positive)
      *
     C                   Z-SUB     RelDAM2       RelDAM2R         15 0
     C     DDDLTP        IFEQ      'OT'
     C     DDACTN        ANDEQ     'I'
     C     @@AMT         ANDGT     RelDAM2R
     C                   MOVE      'N'           DDSamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0147'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END
     C                   END
     C*
     C* Sell amount for output to file
     C* (It is signed negative on file)
     C*
     C     DDSamtOK      IFEQ      'Y'
     C     DDSccyOK      ANDEQ     'Y'
     C                   Z-SUB     @@AMT         F3DAM2
     C                   END
     C/COPY WNCPYSRC,FXH00010
                                                                                              CER043
     C                   ENDIF                                                                CER043
     C*
     C/COPY OFCPYSRCZ,CDL091_005                                                              CDL091
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * BSAMTV - BUY & SELL AMOUNT CROSS VALIDATION
      *****************************************************************
     C     BSAMTV        BEGSR
      *
      * If swap one of buy or sell amounts must = other amt on other deal
      * (first make sell amounts positive)
      *
     C     DDDLTP        IFEQ      'SW'
     C     DDSdnoOK      ANDEQ     'Y'
     C*****DDBRKR        OREQ      'SWAP'                                                     205966
     C*****DDSdnoOK      ANDEQ     'Y'                                                        205966
      *
     C                   Z-SUB     RelDAM2       RelDAM2R         15 0
     C                   Z-SUB     F3DAM2        @@DAM2R          15 0
     C     F3DAM1        IFNE      RelDAM2R
     C     @@DAM2R       ANDNE     RelDAM1
     C                   MOVE      'N'           DDSamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0148'     MsgIdXAr(Idx)
     C                   END
      *
     C                   END
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0840 - VALIDATE/REFORMAT AMOUNT                             *
      *****************************************************************
     C     ZA0840        BEGSR
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16            Display field
     C                   PARM                    @@IDP             3 0          no.of dec.plcs
     C                   PARM                    @@IINT            3 0          no.of integers
     C                   PARM                    @@MTID            1            Million/Thous.
     C                   PARM      *ZERO         @@ERCD            1 0          Error code
     C                   PARM      *ZERO         @@AMT            15 0          File field
     C                   PARM                    BNDCSP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDBRKR            4            broker
      *
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
     C                   PARM                    DDBAMT           14            buy amount
     C                   PARM                    DDSAMT           14            sell amount
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** Swap/Opt Deal no OK
     C                   PARM                    DDSdnoOK          1            SW/OP deal no
      *
      * ICD
     C                   PARM                    BJCYCD            3            new dl status
     C                   PARM                    BNCYDL            3            new dl status
     C                   PARM                    BGTRMG            1            new dl status
     C                   PARM                    BNDCSP            1            new dl status
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Ccy 1 details
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @RDCY1            1            round down
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@MDF1            1            mult/div ind
     C                   PARM                    @@MDX1            1            mult/div ind,exch
     C                   PARM                    @@LSP1           13 8          low spot rate
     C                   PARM                    @@HSP1           13 8          high spot rate
     C                   PARM                    @@SPD1            8 0          FX spot date
     C                   PARM                    @NEXRT1                                      CER043
      *
      * Ccy 2 details
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @RDCY2            1            round down
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
     C                   PARM                    @@MDF2            1            mult/div ind
     C                   PARM                    @@MDX2            1            mult/div ind,exch
     C                   PARM                    @@LSP2           13 8          low spot rate
     C                   PARM                    @@HSP2           13 8          high spot rate
     C                   PARM                    @@SPD2            8 0          FX spot date
     C                   PARM                    @NEXRT2                                      CER043
      *
      ** Buy ccy - OK
      ** Sell ccy - OK
      ** Buy amt - OK
      ** Sell amt - OK
     C                   PARM                    DDBccyOK          1            Buy ccy error
     C                   PARM                    DDSccyOK          1            Sell ccy error
     C                   PARM                    DDBamtOK          1            Buy amt error
     C                   PARM                    DDSamtOK          1            Sell amt error
     C                   PARM                    DDRateOK          1                          CER043
      *
      ** Deal Buy ccy, sell ccy, buy amt, sell amt
      *
     C                   PARM                    F3CCY1            3            buy ccy
     C                   PARM                    F3CCY2            3            sell ccy
     C                   PARM                    F3DAM1           15 0          buy amount
     C                   PARM                    F3DAM2           15 0          sell amount
     C/COPY WNCPYSRC,FXH00245
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 1                                                  CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
      *
     C/COPY WNCPYSRC,FXH00011
     C/COPY OFCPYSRCZ,CDL091_006                                                              CDL091
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
