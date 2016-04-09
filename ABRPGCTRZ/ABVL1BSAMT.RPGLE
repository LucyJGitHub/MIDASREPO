     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate leg 1 buy & sell ccys & amounts')    *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVL1BSAMT - Validate Leg 1 Buy and Sell Ccys & Amounts      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 09May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156689             Date 08Mar99               *
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
      * AMOUNT EDITING FIELDS
     D                 DS
     D  @Z                     1     16
     D                                     DIM(16) ASCEND
     D  @Y                     1     17
     D                                     DIM(17) ASCEND
     D  @@AMTP                 1     16
     D  @@AMTD                 1     17
     D                 DS
     D  @@AMTW                 1      8P 0
     D  @@AMTR                 2      8P 8
 
 
      * BLRATE Spot Rates data structure
     D                 DS
     D  @@HISP                 1     13  8
     D  @@HS10                 1     13  9
     D  @@LOSP                14     26  8
     D  @@LS10                14     26  9
 
     D                 DS
      * Decimal Adjustment array/field data structure
     D  @AD                    1     72  0
     D                                     DIM(8) CTDATA PERRCD(1)
 
      * SCALING FACTORS
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
 
 
     D                 DS
      * Amount data structure for cross-validation #1 - W@115nn
     D  W@1150                 1     15  0
     D  W@1151                 1     15  1
     D  W@1152                 1     15  2
     D  W@1153                 1     15  3
     D                 DS
      * Amount data structure for cross-validation #2 - W@215nn
     D  W@2150                 1     15  0
     D  W@2151                 1     15  1
     D  W@2152                 1     15  2
     D  W@2153                 1     15  3
     D                 DS
      * Amount data structure for cross-validation #3 - W@315nn
     D  W@3150                 1     15  0
     D  W@3151                 1     15  1
     D  W@3152                 1     15  2
     D  W@3153                 1     15  3
 
     D M@MGDA          DS
      * Message data data structure
     D  M@0145                 1     45
     D  M@0115                 1     15
     D  M@0102                 1      2  0
     D  M@0101                 1      1  0
     D  M@1630                16     30
 
     D                 DS
      * BCE Low range value data structure (Subrs.BEBCE1 & BFBCE2)
     D  W@BC0L                 1     15  0
     D  W@BC1L                 1     15  1
     D  W@BC2L                 1     15  2
     D  W@BC3L                 1     15  3
     D                 DS
      * BCE High range value data structure (Subrs.BEBCE1 & BFBCE2)
     D  W@BC0H                 1     15  0
     D  W@BC1H                 1     15  1
     D  W@BC2H                 1     15  2
     D  W@BC3H                 1     15  3
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
     D JUCDPF          S              1S 0
     D JUCDPS          S              1S 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output deal fields
 
     C                   Z-ADD     *ZERO         JUNDXR
     C                   MOVE      *BLANK        JUDFCY
     C                   Z-ADD     *ZERO         JUCDPF
     C                   Z-ADD     *ZERO         JUNDA1
     C                   Z-ADD     *ZERO         JUNDBA
     C                   MOVE      *BLANK        JUDSCY
     C                   Z-ADD     *ZERO         JUCDPS
     C                   Z-ADD     *ZERO         JUNDA2
     C                   Z-ADD     *ZERO         JUNDSA
     C                   MOVE      *BLANK        JUDMD1
     C                   Z-ADD     *ZERO         JUNBCA
      *
      * L1RTV  - 1ST LEG EXCHANGE RATE VALIDATION
      *
     C                   EXSR      L1RTV
      *
      * L1CBV  - 1ST LEG BUY CURRENCY VALIDATION
      *
     C                   EXSR      L1CBV
      *
      * L1BAV  - 1ST LEG BUY AMOUNT VALIDATION
      * (if buy currency is OK)
      *
     C     DDL1CBOK      IFNE      'N'
     C                   EXSR      L1BAV
     C                   END
      *
      * L1CSV  - 1ST LEG SELL CURRENCY VALIDATION
      *
     C                   EXSR      L1CSV
      *
      * L1SAV  - 1ST LEG SELL AMOUNT VALIDATION
      * (if sell currency is OK)
      *
     C     DDL1CSOK      IFNE      'N'
     C                   EXSR      L1SAV
     C                   END
      *
      * XVALAR - CROSS VALIDATION OF AMOUNTS AND RATE
      *
     C     DDL1RTOK      IFNE      'N'
     C     DDL1CBOK      ANDNE     'N'
     C     DDL1BAOK      ANDNE     'N'
     C     DDL1CSOK      ANDNE     'N'
     C     DDL1SAOK      ANDNE     'N'
     C                   EXSR      XVALAR
     C                   END
      *
      * DETDNQP - Determine the Deal Normally-Quoted Decimal Places:
      *
     C     DDL1RTOK      IFNE      'N'
     C     DDL1CBOK      ANDNE     'N'
     C     DDL1CSOK      ANDNE     'N'
     C                   EXSR      DETDNQP
     C                   END
      *
      * L1BEV  - 1ST LEG BASE EQUIVALENT VALIDATION
      *
     C     DDL1RTOK      IFNE      'N'
     C     DDL1CBOK      ANDNE     'N'
     C     DDL1BAOK      ANDNE     'N'
     C     DDL1CSOK      ANDNE     'N'
     C     DDL1SAOK      ANDNE     'N'
     C                   EXSR      L1BEV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDL1RTOK      IFEQ      'N'
     C     DDL1CBOK      OREQ      'N'
     C     DDL1BAOK      OREQ      'N'
     C     DDL1CSOK      OREQ      'N'
     C     DDL1SAOK      OREQ      'N'
     C     DDL1BEOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
     C*********************************************************************
     C* L1RTV  - 1ST LEG EXCHANGE RATE VALIDATION
     C*********************************************************************
     C     L1RTV         BEGSR
      *
      * 1st.Leg Exchange Rate can't be blank
      *
     C     DDL1RT        IFEQ      *BLANK
     C                   MOVE      'N'           DDL1RTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1RT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0120'     MsgIdXAr(Idx)
     C                   GOTO      EL1RTV
     C                   END
      *
      * 1st. Leg Exchange Rate must be a valid rate
      *
     C                   Z-ADD     8             @@IDP
     C     13            SUB       8             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDL1RT        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C                   EXSR      ZA0840
      *
      * It is an invalid rate
      *
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDL1RTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1RT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0206'     MsgIdXAr(Idx)
     C                   GOTO      EL1RTV
     C                   END
      *
      * 1st. Leg Buy amount must not be zero.
      *
     C                   MOVE      @@ALPH        DDL1RT
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDL1RTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1RT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0206'     MsgIdXAr(Idx)
     C                   GOTO      EL1RTV
     C                   END
      *
      * 1st. Leg Exchange Rate for output to file
      *
     C                   MOVE      @@AMT         JUNDXR
      *
     C     EL1RTV        ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* L1CBV  - 1ST LEG BUY CURRENCY VALIDATION
     C*********************************************************************
     C     L1CBV         BEGSR
      *
      * 1st. Leg Buy Currency can't be blank
      *
     C     DDL1CB        IFEQ      *BLANK
     C                   MOVE      'N'           DDL1CBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1CB'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0164'     MsgIdXAr(Idx)
     C                   GOTO      EL1CBV
     C                   END
      *
      * 1st. Leg Buy Currency must exist
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      DDL1CB        @A6KEY            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDL1CBOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1CB'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0166'     MsgIdXAr(Idx)
     C                   GOTO      EL1CBV
     C                   END
      *
      * 1st. Leg Buy Currency Details
      *
     C                   MOVE      A6CYCD        DDL1CB
     C                   MOVE      A6CYCD        DDL2CS
 
     C                   MOVE      A6CYCD        JUDFCY                           Currency
     C                   Z-ADD     A6NBDP        JUCDPF                           Dec.places
 
     C                   Z-ADD     A6SPRT        W@SRT1                           Spot rate
     C                   MOVE      A6MDIN        W@MDI1                           Mult/Div.ind.
     C                   Z-ADD     A6HSRT        W@HSR1                           Hi Spot rate
     C                   Z-ADD     A6LSPR        W@LSR1                           Lo Spot rate
     C                   MOVE      A6MDEX        W@XMD1                           Xrate M/D
     C                   Z-ADD     A6NQDP        W@NQD1                           N/Quoted dec.
     C                   Z-ADD     A6SCEX        W@SXP1                           ScaleExponent
     C                   MOVE      A6DICB        W@ICM1                           Int.Calc.Mth.
     C                   Z-ADD     A6FXSD        W@FSD1                           FX Spot Date
     C                   MOVEL     A6RDFC        W@LCRD                           Rnd-down ind.
 
     C     W@NQD1        IFEQ      5
     C     W@XMD1        ANDEQ     'D'
     C     W@NQD1        OREQ      4
     C     1             ADD       JUCDPF        P1
     C                   ELSE
     C     3             ADD       JUCDPF        P1
     C                   END
      *
     C                   Z-ADD     @AD(P1)       W@TOLP           11 0
     C                   Z-SUB     W@TOLP        W@TOLN           11 0
      *
     C     EL1CBV        ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* L1BAV  - 1ST LEG BUY AMOUNT VALIDATION
     C*********************************************************************
     C     L1BAV         BEGSR
      *
      * 1st. Leg Buy amount must be a valid amount in 1st leg buy ccy
      *
     C                   Z-ADD     JUCDPF        @@IDP
     C     13            SUB       JUCDPF        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDL1BA        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C                   EXSR      ZA0840
      *
      * It is an invalid amount
      *
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDL1BAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1BA'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0152'     MsgIdXAr(Idx)
     C                   GOTO      EL1BAV
     C                   END
      *
      * 1st. Leg Buy amount must not be zero.
      *
     C                   MOVE      @@ALPH        DDL1BA
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDL1BAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1BA'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0150'     MsgIdXAr(Idx)
     C                   GOTO      EL1BAV
     C                   END
      *
      * 1st. Leg Buy amount for output to file
      *
     C                   Z-ADD     @@AMT         JUNDA1
     C                   Z-ADD     @@AMT         JUNDBA
      *
     C     EL1BAV        ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* L1CSV  - 1ST LEG SELL CURRENCY VALIDATION
     C*********************************************************************
     C     L1CSV         BEGSR
      *
      * 1st. Leg Sell Currency can't be blank
      *
     C     DDL1CS        IFEQ      *BLANK
     C                   MOVE      'N'           DDL1CSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1CS'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0165'     MsgIdXAr(Idx)
     C                   GOTO      EL1CSV
     C                   END
      *
      * 1st. Leg Sell Currency must not equal 1st Leg Buy Currency
      *
     C     DDL1CS        IFEQ      DDL1CB
     C                   MOVE      'N'           DDL1CSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1CS'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0101'     MsgIdXAr(Idx)
     C                   GOTO      EL1CSV
     C                   END
      *
      * 1st. Leg Sell Currency must exist
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      DDL1CS        @A6KEY
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDL1CSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1CS'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0167'     MsgIdXAr(Idx)
     C                   GOTO      EL1CSV
     C                   END
      *
      * 1st. Leg Sell Currency Details
      *
     C                   MOVE      A6CYCD        DDL1CS
     C                   MOVE      A6CYCD        DDL2CB
 
     C                   MOVE      A6CYCD        JUDSCY                           Currency
     C                   Z-ADD     A6NBDP        JUCDPS                           Dec.places
 
     C                   Z-ADD     A6SPRT        W@SRT2                           Spot rate
     C                   MOVE      A6MDIN        W@MDI2                           Mult/Div.ind.
     C                   Z-ADD     A6HSRT        W@HSR2                           Hi Spot rate
     C                   Z-ADD     A6LSPR        W@LSR2                           Lo Spot rate
     C                   MOVE      A6MDEX        W@XMD2                           Xrate M/D
     C                   Z-ADD     A6NQDP        W@NQD2                           N/Quoted dec.
     C                   Z-ADD     A6SCEX        W@SXP2                           ScaleExponent
     C                   MOVE      A6DICB        W@ICM2                           Int.Calc.Mth.
     C                   Z-ADD     A6FXSD        W@FSD2                           FX Spot Date
     C                   MOVEL     A6RDFC        W@DCRD                           Rnd-down ind.
      *
     C     EL1CSV        ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* L1SAV  - 1ST LEG SELL AMOUNT VALIDATION
     C*********************************************************************
     C     L1SAV         BEGSR
      *
      * 2nd. Leg sell amount must be a valid amount in 2nd leg sell ccy
      *
     C                   Z-ADD     JUCDPS        @@IDP
     C     13            SUB       JUCDPS        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDL1SA        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C                   EXSR      ZA0840
      *
      * It is an invalid amount
      *
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDL1SAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1SA'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0153'     MsgIdXAr(Idx)
     C                   GOTO      EL1SAV
     C                   END
      *
      * 2nd. Leg sell amount must not be zero.
      *
     C                   MOVE      @@ALPH        DDL1SA
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDL1SAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1SA'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0151'     MsgIdXAr(Idx)
     C                   GOTO      EL1SAV
     C                   END
      *
      * 2nd. Leg sell amount for output to file
      *
     C                   Z-ADD     @@AMT         JUNDA2
     C                   Z-ADD     @@AMT         JUNDSA
      *
     C     EL1SAV        ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* XVALAR - CROSS VALIDATION OF AMOUNTS AND RATE
     C*********************************************************************
     C     XVALAR        BEGSR
      *
      * Initialize Scaling factor and Exchange Rate
      *
     C                   Z-ADD     1             W@SFAC
     C                   MOVE      'X'           W@MDIN            1            M/D error
      *
      * If 1st Leg Buy Currency is Base Currency
      *
     C     DDL1CB        IFEQ      BNCYDL
     C                   Z-ADD     JUNDA1        @@DAM1
     C                   Z-ADD     JUCDPF        @@CDP1            1 0
     C                   Z-ADD     JUNDA2        @@DAM2
     C                   Z-ADD     JUCDPS        @@CDP2            1 0
 
     C     W@MDI2        IFEQ      'D'
     C     1             DIV(H)    W@SRT2        @@SPT2           14 9
     C                   ELSE
     C                   Z-ADD     W@SRT2        @@SPT2
     C                   END
 
     C     W@MDI1        IFEQ      'D'
     C     1             DIV(H)    W@SRT1        @@SPT1           14 9
     C                   ELSE
     C                   Z-ADD     W@SRT1        @@SPT1
     C                   END
 
     C     @@SPT2        DIV(H)    @@SPT1        @@CRSR           13 8
     C                   Z-ADD     @@CRSR        @@HISP                           I:C1 Hi Spot
     C                   Z-ADD     @@CRSR        @@LOSP                           I:C1 Lo Spot
     C                   MOVE      'M'           @@XRMD                           I:C1 XRatM/
     C                   MOVE      'B'           @@BSIN                           I:Base=Buy
     C                   ADD       W@SXP2        W@SFAC                           ScalingFactor
     C                   MOVEL     'B'           W@MDIN
     C                   EXSR      BLRATE                                         <Validate>
 
     C     W@MDIN        IFNE      'M'
     C     W@MDIN        ANDNE     'D'
 
     C                   MOVEL     'N'           EXCH_Warn         1
 
     C     1             DIV       @@CRSR        @@CRSR
     C                   Z-ADD     @@CRSR        @@HISP                           I:C1 HighSpot
     C                   Z-ADD     @@CRSR        @@LOSP                           I:C1 Low Spot
     C                   MOVEL     'X'           W@MDIN
     C                   MOVE      'D'           @@XRMD                           I:C1 XRateM/D
     C                   EXSR      BLRATE
     C                   END
 
     C                   ELSE                                                   EL CCY.1<>BASE
      *
      * If 1st Leg Sell Currency is Base Currency
      *
     C     DDL1CS        IFEQ      BNCYDL                                       IF CCY.2=BASE
     C                   Z-ADD     JUNDA2        @@DAM1                           I:C2 Amount
     C                   Z-ADD     JUCDPS        @@CDP1                           I:C2 Decimals
     C                   Z-ADD     JUNDA1        @@DAM2                           I:C1 Amount
     C                   Z-ADD     JUCDPF        @@CDP2                           I:C1 Decimals
 
     C     W@MDI2        IFEQ      'D'
     C     1             DIV(H)    W@SRT2        @@SPT2           14 9
     C                   ELSE
     C                   Z-ADD     W@SRT2        @@SPT2
     C                   END
 
     C     W@MDI1        IFEQ      'D'
     C     1             DIV(H)    W@SRT1        @@SPT1           14 9
     C                   ELSE
     C                   Z-ADD     W@SRT1        @@SPT1
     C                   END
 
     C     @@SPT1        DIV(H)    @@SPT2        @@CRSR           13 8
     C                   Z-ADD     @@CRSR        @@HISP                           I:C1 HighSpot
     C                   Z-ADD     @@CRSR        @@LOSP                           I:C1 Low Spot
     C                   MOVE      'M'           @@XRMD                           I:C1 XRateM/D
     C                   MOVE      'S'           @@BSIN            1              I:Base=Sell
     C                   ADD       W@SXP1        W@SFAC                           ScalingFactor
     C                   MOVEL     'B'           W@MDIN
     C                   EXSR      BLRATE                                         <Validate>
 
     C     W@MDIN        IFNE      'M'
     C     W@MDIN        ANDNE     'D'
 
     C                   MOVEL     'N'           EXCH_Warn
 
     C     1             DIV       @@CRSR        @@CRSR
     C                   Z-ADD     @@CRSR        @@HISP                           I:C1 HighSpot
     C                   Z-ADD     @@CRSR        @@LOSP                           I:C1 Low Spot
     C                   MOVEL     'X'           W@MDIN
     C                   MOVE      'D'           @@XRMD                           I:C1 XRateM/D
     C                   EXSR      BLRATE
     C                   END
 
     C                   ELSE                                                   EL NEITHER BASE
      *
      * If Neither 1st Leg Buy or Sell Currencies are Base Currency
      *
     C                   EXSR      BGCVAR                                         <X-Validate>
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Display exchange rate warning message
      *
     C     EXCH_Warn     IFEQ      'Y'
     C                   MOVE      'W'           DDL1RTOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1RT'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0173'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD3        WMsgDtXAr(WIx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD3))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD3)                   MD000091
     C                   MOVEL     'N'           EXCH_Warn
     C                   END
      *                                                                         FI
      * Update Deal Mult/Div First Amount Ind
      *
     C                   MOVE      W@MDIN        JUDMD1                           Mult/Div ind.
      *                                                                         FI
     C     EXVALAR       ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* BLRATE - Validate Exch.Rate against Spot for Base Ccy. Deal
     C*********************************************************************
     C     BLRATE        BEGSR
      *
      *--------------------------------------------------------------------
      * Input  : JUNDXR 13,8  Exchange Rate
      *          @@DAM1 15,0  Base Ccy.Amount
      *          @@CDP1 1,0   Base Ccy.Decimal Places
      *          @@DAM2 15,0  Non-Base Ccy.Amount
      *          @@CDP2 1,0   Non-Base Ccy.Decimal Places
      *          @@SPRT 13,8  Non-Base Ccy.Spot rate
      *          @@MDIN 1,0   Non-Base Ccy.Mult/Div.Indicator
      *          @@BSIN 1     Base Ccy.Buy/Sell Indicator
      * Output : W@MDIN 1     Multiply/Divide Indicator
      *--------------------------------------------------------------------
      *
      * Obtain +/- 10% of Spot rate :
      *
     C     @@HISP        ADD       @@HS10        @@SPHI           13 8          HiSpot + 10%
     C     @@LOSP        SUB       @@LS10        @@SPLO           13 8          LoSpot - 10%
     C     JUNDXR        DIV(H)    @SF(W@SFAC)   @@NDXR           13 8            Descale Rate
      *
      * If Exchange rate is outside spot range, send warning
      *
     C     @@NDXR        IFLT      @@SPLO                                       IF RATE<LOWEST
     C     @@NDXR        ORGT      @@SPHI                                        OR >HIGHEST
     C                   Z-ADD     *ZERO         @@AMTW                           ¦ Initialise
     C                   MOVE      *BLANK        M@MGDA                           ¦ fields
     C                   Z-ADD     8             W@DECP                           ¦
     C     @@SPLO        MULT      @SF(W@SFAC)   @@AMTR                           I:Low Rate
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     16            P1                               Set ptr.1
     C     @Z(P1)        DOWEQ     '0'                                          DO TRIM ZEROS
     C                   SUB       1             P1                               Decr.ptr.1
     C                   END                                                    OD
     C                   ADD       1             P1                               Incr.ptr.1
     C     P1            IFLT      17                                           IF PTR.IN RANGE
     C                   MOVEA     *BLANK        @Z(P1)                           Trim zeros
     C                   END                                                    FI
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             90          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C     @@SPHI        MULT      @SF(W@SFAC)   @@AMTR                           I:High Rate
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     16            P1                               Set ptr.1
     C     @Z(P1)        DOWEQ     '0'                                          DO TRIM ZEROS
     C                   SUB       1             P1                               Decr.ptr.1
     C                   END                                                    OD
     C                   ADD       1             P1                               Incr.ptr.1
     C     P1            IFLT      17                                           IF PTR.IN RANGE
     C                   MOVEA     *BLANK        @Z(P1)                           Trim zeros
     C                   END                                                    FI
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             90          Find start
     C                   MOVEA     @Z(P1)        M@1630                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD3           45              Stack Msg.Dta
     C                   MOVEL     'Y'           EXCH_Warn
     C                   END
      *
      * check amounts :
      *
     C                   MOVEA     *IN(90)       W@IN10           10              Keep 10 inds.
     C     @@CDP1        COMP      *ZERO                                  90      Dec.place=0
     C     @@CDP1        COMP      1                                      91      Dec.place=1
     C     @@CDP1        COMP      2                                      92      Dec.place=2
     C     @@CDP1        COMP      3                                      93      Dec.place=3
     C     @@CDP2        COMP      *ZERO                                  94      Dec.place=0
     C     @@CDP2        COMP      1                                      95      Dec.place=1
     C     @@CDP2        COMP      2                                      96      Dec.place=2
     C     @@CDP2        COMP      3                                      97      Dec.place=3
     C                   Z-ADD     @@DAM1        W@1150                           15,0 Base Amt
     C                   Z-ADD     @@DAM2        W@2150                           15,0 N/B Amt
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * Check Buy/Sell; if Base = Buy, apply rate to Non-Base :
      *
     C     @@BSIN        IFEQ      'B'                                          IF BASE=BUY
      * Non-Base / Rate = Base amount (or, Sell / Rate = Buy) :
     C     @@XRMD        IFEQ      'D'                                          IF DIVIDE
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   91W@2150        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   92W@2150        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   93W@2150        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   91W@2151        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   92W@2151        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   93W@2151        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   91W@2152        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   92W@2152        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   93W@2152        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   91W@2153        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   92W@2153        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   93W@2153        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * Check difference between calculated & actual, with tolerances :
      *
     C     W@1150        SUB       W@3150        W@DIFF                           Difference
     C     W@DIFF        IFLE      1                                            IF   ¦ DIFF.
     C     W@DIFF        ANDGE     -1                                            AND ¦ +/- 1
     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
     C                   ELSE                                                   EL TOLERANCE
     C     W@DIFF        IFLE      W@TOLP                                       IF   ¦ DIFF.
     C     W@DIFF        ANDGE     W@TOLN                                        AND ¦ +/- 100
     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@3150        @@AMTW                           I:Amount
     C                   Z-ADD     @@CDP1        W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             98          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD1           45              Stack Msg.Dta
     C                   MOVE      'W'           DDL1BAOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BA'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0175'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD1        WMsgDtXAr(WIx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD1))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD1)                   MD000091
     C                   END                                                    FI
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * Non-Base * Rate = Base amount (or, Sell * Rate = Buy) :
      *
     C                   ELSE                                                   EL MULTIPLY
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   91W@2150        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   92W@2150        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   93W@2150        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   91W@2151        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   92W@2151        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   93W@2151        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   91W@2152        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   92W@2152        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   93W@2152        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   91W@2153        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   92W@2153        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   93W@2153        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * Check difference between calculated & actual, with tolerances :
      *
     C     W@1150        SUB       W@3150        W@DIFF                           Difference
     C     W@DIFF        IFLE      1                                            IF   ¦ DIFF.
     C     W@DIFF        ANDGE     -1                                            AND ¦ -1/0/+1
     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind.
     C                   ELSE                                                   EL TOLERANCE
     C     W@DIFF        IFLE      W@TOLP                                       IF   ¦ DIFF.
     C     W@DIFF        ANDGE     W@TOLN                                        AND ¦ +/- 100
     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind.
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@3150        @@AMTW                           I:Amount
     C                   Z-ADD     @@CDP1        W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             98          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD1                           Stack Msg.Dta
     C                   MOVE      'W'           DDL1BAOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BA'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0175'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD1        WMsgDtXAr(WIx)                    Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD1))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD1)                   MD000091
     C                   END                                                    FI
     C                   END                                                    FI
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * If Base = Sell, apply rate to Base :
      *
     C                   ELSE                                                   EL BASE=SELL
      * Base / Rate = Non-Base amount (or, Sell / Rate = Buy) :
     C     @@XRMD        IFEQ      'M'                                          IF MULTIPLY
     C     *IN90         IFEQ      '1'                                          IF A/1 = 15,0
     C   94W@1150        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   95W@1150        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   96W@1150        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   97W@1150        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN91         IFEQ      '1'                                          IF A/1 = 15,1
     C   94W@1151        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   95W@1151        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   96W@1151        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   97W@1151        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN92         IFEQ      '1'                                          IF A/1 = 15,2
     C   94W@1152        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   95W@1152        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   96W@1152        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   97W@1152        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN93         IFEQ      '1'                                          IF A/1 = 15,3
     C   94W@1153        DIV(H)    @@NDXR        W@3150                           =A/3 15,0
     C   95W@1153        DIV(H)    @@NDXR        W@3151                           =A/3 15,1
     C   96W@1153        DIV(H)    @@NDXR        W@3152                           =A/3 15,2
     C   97W@1153        DIV(H)    @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * Check difference between calculated & actual, with tolerances :
      *
     C     W@2150        SUB       W@3150        W@DIFF                           Difference
     C     W@DIFF        IFLE      1                                            IF   ¦ DIFF.
     C     W@DIFF        ANDGE     -1                                            AND ¦ +/- 1
     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
     C                   ELSE                                                   EL TOLERANCE
     C     W@DIFF        IFLE      W@TOLP                                       IF   ¦ DIFF.
     C     W@DIFF        ANDGE     W@TOLN                                        AND ¦ +/- 100
     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@3150        @@AMTW                           I:Amount
     C                   Z-ADD     @@CDP2        W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             98          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD1                           Stack Msg.Dta
     C                   MOVE      'W'           DDL1BAOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BA'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0175'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD1        WMsgDtXAr(WIx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD1))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD1)                   MD000091
     C                   END                                                    FI
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * Base * Rate = Non-Base amount (or, Sell * Rate = Buy) :
      *
     C                   ELSE                                                   EL DIVIDE
     C     *IN90         IFEQ      '1'                                          IF A/1 = 15,0
     C   94W@1150        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   95W@1150        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   96W@1150        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   97W@1150        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN91         IFEQ      '1'                                          IF A/1 = 15,1
     C   94W@1151        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   95W@1151        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   96W@1151        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   97W@1151        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN92         IFEQ      '1'                                          IF A/1 = 15,2
     C   94W@1152        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   95W@1152        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   96W@1152        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   97W@1152        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN93         IFEQ      '1'                                          IF A/1 = 15,3
     C   94W@1153        MULT(H)   @@NDXR        W@3150                           =A/3 15,0
     C   95W@1153        MULT(H)   @@NDXR        W@3151                           =A/3 15,1
     C   96W@1153        MULT(H)   @@NDXR        W@3152                           =A/3 15,2
     C   97W@1153        MULT(H)   @@NDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * Check difference between calculated & actual, with tolerances :
      *
     C     W@2150        SUB       W@3150        W@DIFF                           Difference
     C     W@DIFF        IFLE      1                                            IF   ¦ DIFF.
     C     W@DIFF        ANDGE     -1                                            AND ¦ -1/0/+1
     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind.
     C                   ELSE                                                   EL TOLERANCE
     C     W@DIFF        IFLE      W@TOLP                                       IF   ¦ DIFF.
     C     W@DIFF        ANDGE     W@TOLN                                        AND ¦ +/- 100
     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind.
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@3150        @@AMTW                           I:Amount
     C                   Z-ADD     @@CDP2        W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             98          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD1                           Stack Msg.Dta
     C                   MOVE      'W'           DDL1BAOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BA'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0175'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD1        WMsgDtXAr(WIx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD1))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD1)                   MD000091
     C                   END                                                    FI
     C                   END                                                    FI
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * If error, send message : "Amounts & Rate do not Agree"
      *
     C                   MOVEA     W@IN10        *IN(90)                          Restore inds.
     C     W@MDIN        IFEQ      'X'                                          IF ERROR
     C                   MOVE      'N'           DDL1RTOK
     C                   MOVE      'N'           DDL1BAOK
     C                   MOVE      'N'           DDL1SAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1RT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0132'     MsgIdXAr(Idx)
     C                   END                                                    FI
      *
     C                   ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* BGCVAR - Cross-validate Amounts & Exchange rate
     C*********************************************************************
     C     BGCVAR        BEGSR
      *
      *--------------------------------------------------------------------
      * Input for this routine comes from fields in the AB Deal format
      * Output is W@MDIN (Mult/Div.Indicator) which may return:
      *              X - Error; amounts do not tally
      *              M - Rate is a multiplier
      *              D - Rate is a divisor
      *--------------------------------------------------------------------
      *
     C                   MOVEA     *IN(90)       W@IN10           10            Keep 10 inds.
     C     JUNDXR        CABEQ     *ZERO         BGEXIT                         No rate given
     C     JUCDPF        COMP      *ZERO                                  90     Dec.place=0
     C     JUCDPF        COMP      1                                      91     Dec.place=1
     C     JUCDPF        COMP      2                                      92     Dec.place=2
     C     JUCDPF        COMP      3                                      93     Dec.place=3
     C     JUCDPS        COMP      *ZERO                                  94     Dec.place=0
     C     JUCDPS        COMP      1                                      95     Dec.place=1
     C     JUCDPS        COMP      2                                      96     Dec.place=2
     C     JUCDPS        COMP      3                                      97     Dec.place=3
     C                   Z-ADD     JUNDA1        W@1150                         15,0 amount 1
     C                   Z-ADD     JUNDA2        W@2150                         15,0 amount 2
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * 1. A2 / XRATE = A1 :
      *
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        DIV(H)    JUNDXR        W@3150                           =A/3 15,0
     C   91W@2150        DIV(H)    JUNDXR        W@3151                           =A/3 15,1
     C   92W@2150        DIV(H)    JUNDXR        W@3152                           =A/3 15,2
     C   93W@2150        DIV(H)    JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        DIV(H)    JUNDXR        W@3150                           =A/3 15,0
     C   91W@2151        DIV(H)    JUNDXR        W@3151                           =A/3 15,1
     C   92W@2151        DIV(H)    JUNDXR        W@3152                           =A/3 15,2
     C   93W@2151        DIV(H)    JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        DIV(H)    JUNDXR        W@3150                           =A/3 15,0
     C   91W@2152        DIV(H)    JUNDXR        W@3151                           =A/3 15,1
     C   92W@2152        DIV(H)    JUNDXR        W@3152                           =A/3 15,2
     C   93W@2152        DIV(H)    JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        DIV(H)    JUNDXR        W@3150                           =A/3 15,0
     C   91W@2153        DIV(H)    JUNDXR        W@3151                           =A/3 15,1
     C   92W@2153        DIV(H)    JUNDXR        W@3152                           =A/3 15,2
     C   93W@2153        DIV(H)    JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     W@1150        SUB       W@3150        W@DIFF           15 0          Difference
     C     W@DIFF        IFLT      2                                            IF   ¦ DIFF.
     C     W@DIFF        ANDGT     -2                                            AND ¦ -1/0/+1
     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
     C                   GOTO      BGSKIP                                         Exit Subr.
     C                   ELSE                                                   EL TOLERANCE
     C     W@DIFF        IFLE      W@TOLP                                       IF   ¦ DIFF.
     C     W@DIFF        ANDGE     W@TOLN                                        AND ¦ +/- 100
     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@3150        @@AMTW                           I:Amount
     C                   Z-ADD     JUCDPF        W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             98          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD1                           Stack Msg.Dta
     C                   MOVE      'W'           DDL1BAOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BA'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0175'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD1        WMsgDtXAr(WIx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD1))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD1)                   MD000091
     C                   GOTO      BGSKIP                                         Exit Subr.
     C                   END                                                    FI
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *
      * 2. A2 * XRATE = A1 :
      *
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        MULT(H)   JUNDXR        W@3150                           =A/3 15,0
     C   91W@2150        MULT(H)   JUNDXR        W@3151                           =A/3 15,1
     C   92W@2150        MULT(H)   JUNDXR        W@3152                           =A/3 15,2
     C   93W@2150        MULT(H)   JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        MULT(H)   JUNDXR        W@3150                           =A/3 15,0
     C   91W@2151        MULT(H)   JUNDXR        W@3151                           =A/3 15,1
     C   92W@2151        MULT(H)   JUNDXR        W@3152                           =A/3 15,2
     C   93W@2151        MULT(H)   JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        MULT(H)   JUNDXR        W@3150                           =A/3 15,0
     C   91W@2152        MULT(H)   JUNDXR        W@3151                           =A/3 15,1
     C   92W@2152        MULT(H)   JUNDXR        W@3152                           =A/3 15,2
     C   93W@2152        MULT(H)   JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        MULT(H)   JUNDXR        W@3150                           =A/3 15,0
     C   91W@2153        MULT(H)   JUNDXR        W@3151                           =A/3 15,1
     C   92W@2153        MULT(H)   JUNDXR        W@3152                           =A/3 15,2
     C   93W@2153        MULT(H)   JUNDXR        W@3153                           =A/3 15,3
     C                   END                                                    FI
     C     W@1150        SUB       W@3150        W@DIFF                         Difference
     C     W@DIFF        IFLT      2                                            IF   ¦ DIFF.
     C     W@DIFF        ANDGT     -2                                            AND ¦ -1/0/+1
     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind.
     C                   ELSE                                                   EL TOLERANCE
     C     W@DIFF        IFLE      W@TOLP                                       IF   ¦ DIFF.
     C     W@DIFF        ANDGE     W@TOLN                                        AND ¦ +/- 100
     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind.
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@3150        @@AMTW                           I:Amount
     C                   Z-ADD     JUCDPF        W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             98          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD1                           Stack Msg.Dta
     C                   MOVE      'W'           DDL1BAOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BA'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0175'     WMsgIdXAr(WIx)
     C**********         MOVEL     M@MGD1        WMsgDtXAr(WIx)                  I:Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGD1))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(M@MGD1)                   MD000091
     C                   END                                                    FI
     C                   END                                                    FI
      *--------------------------------------------------------------------
      /EJECT
      *--------------------------------------------------------------------
      *          _____________
     C     BGSKIP        TAG                                                    +++TAG+++
      *          ~~~~~~~~~~~~~
      * If error, send message : "Amounts & Rate do not Agree"
      *
     C                   MOVEA     W@IN10        *IN(90)                        Restore inds.
     C     W@MDIN        IFEQ      'X'                                          IF ERROR
     C                   MOVE      'N'           DDL1RTOK
     C                   MOVE      'N'           DDL1BAOK
     C                   MOVE      'N'           DDL1SAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1RT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0132'     MsgIdXAr(Idx)
     C                   END                                                    FI
      *
     C     BGEXIT        ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* DETDNQP - Determine the Deal Normally-Quoted Decimal Places:
     C*********************************************************************
     C     DETDNQP       BEGSR
      *
      * If neither buy or sell currency are base currency
      *
     C     DDL1CB        IFNE      BNCYDL                                       IF    ¦ NON-
     C     DDL1CS        ANDNE     BNCYDL                                         AND ¦ BASE
 
     C     W@NQD1        IFEQ      W@NQD2                                       IF CCY1=CCY2 DP
     C     W@NQD1        ANDEQ     5                                             AND =5
     C                   Z-ADD     5             W@NQDP            1 0            Quoted=5
     C                   ELSE                                                   EL
     C     JUNDXR        IFGE      100                                          IF RATE => 100
     C                   Z-ADD     2             W@NQDP                           Quoted=2
     C                   ELSE                                                   EL
     C     JUNDXR        IFGE      20                                           IF RATE => 20
     C                   Z-ADD     3             W@NQDP                           Quoted=3
     C                   ELSE                                                   EL
     C     JUNDXR        IFGE      1                                            IF RATE => 1
     C                   Z-ADD     4             W@NQDP                           Quoted=4
     C                   ELSE                                                   EL
     C                   Z-ADD     5             W@NQDP                           Quoted=5
     C                   END                                                    FI
     C                   END                                                    FI
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * If either buy or sell currency are base currency
      *
     C                   ELSE                                                   EL BASE DEAL
     C     DDL1CB        IFEQ      BNCYDL                                       IF CCY.1=BASE
     C                   Z-ADD     W@NQD2        W@NQDP                           NQDP for Deal
     C                   ELSE                                                   EL CCY.2=BASE
     C                   Z-ADD     W@NQD1        W@NQDP                           NQDP for Deal
     C                   END                                                    FI
     C                   END                                                    FI
 
     C                   ENDSR
     C*********************************************************************
      /EJECT
     C*********************************************************************
     C* L1BEV  - 1ST LEG BASE EQUIVALENT VALIDATION
     C*********************************************************************
     C     L1BEV         BEGSR
      *
      * If defined,
      * 1st. Leg Base Equivalent must be a valid amount in base ccy
      *
     C     DDL1BE        IFNE      *BLANK
     C                   Z-ADD     BseCcyDP      @@IDP
     C     13            SUB       BseCcyDP      @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDL1BE        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C                   EXSR      ZA0840
      *
      * It is an invalid amount
      *
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDL1BEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1BE'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0204'     MsgIdXAr(Idx)
     C                   GOTO      EL1BEV
     C                   END
      *
      * 1st. Leg Base Equivalent must not be zero.
      *
     C                   MOVE      @@ALPH        DDL1BE
     C     @@AMT         IFEQ      *ZEROS
     C                   MOVE      'N'           DDL1BEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1BE'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0205'     MsgIdXAr(Idx)
     C                   GOTO      EL1BEV
     C                   END
      *
      * 1st. Leg Base Equivalent for output to file
      *
     C                   Z-ADD     @@AMT         JUNBCA                           Amount
      *                                                                           O:Amount
     C                   END
      *
      * If 1st Leg Buy Currency is Base currency, BCE is 1st Leg Buy Amt
      * (Send warning message if overridden)
      *
     C     DDL1CB        IFEQ      BJCYCD                                       IF L1/BUY=BASE
     C     JUNBCA        IFNE      *ZERO                                        IF BCE ENTERED
     C     JUNDA1        ANDNE     JUNBCA                                        AND BUY<>BCE
     C                   MOVE      'W'           DDL1BEOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BE'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0133'     WMsgIdXAr(Wix)
     C                   END                                                    FI
     C                   Z-ADD     JUNDA1        JUNBCA                           Default
     C                   GOTO      SL1BEV                                         Skip--->
     C                   END                                                    FI
      *
      * If 1st Leg Sell Currency is Base currency, BCE is 1st Leg Sell Amt
      * (Send warning message if overridden)
      *
     C     DDL1CS        IFEQ      BJCYCD                                       IF L1/SELL=BASE
     C     JUNBCA        IFNE      *ZERO                                        IF BCE ENTERED
     C     JUNDA2        ANDNE     JUNBCA                                        AND SELL<>BCE
     C                   MOVE      'W'           DDL1BEOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BE'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0134'     WMsgIdXAr(Wix)
     C                   END                                                    FI
     C                   Z-ADD     JUNDA2        JUNBCA                           Default
     C                   GOTO      SL1BEV                                         Skip--->
     C                   END                                                    FI
      *
      * Calculate BCE for 1st.Leg Buy currency
      *
     C     JUCDPF        IFGT      *ZERO                                        IF DECP>0
     C     JUNDA1        DIV(H)    @AD(JUCDPF)   W@BCE1           15 3            Adjust
     C                   ELSE                                                   EL DECP=0
     C                   Z-ADD     JUNDA1        W@BCE1                           Amount
     C                   END                                                    FI
     C     W@MDI1        IFEQ      'M'                                          IF MULTIPLY 1
     C                   MULT(H)   W@SRT1        W@BCE1                           Amount*Spot
     C                   ELSE                                                   EL DIVIDE 1
     C     W@SRT1        IFNE      *ZERO                                        IF NOT ZERO
     C                   DIV(H)    W@SRT1        W@BCE1                           Amount/Spot
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Calculate BCE for 1st.Leg Sell currency
      *
     C     JUCDPS        IFGT      *ZERO                                        IF DECP>0
     C     JUNDA2        DIV(H)    @AD(JUCDPS)   W@BCE2           15 3            Adjust
     C                   ELSE                                                   EL DECP=0
     C                   Z-ADD     JUNDA2        W@BCE2                           Amount
     C                   END                                                    FI
     C     W@MDI2        IFEQ      'M'                                          IF MULTIPLY 2
     C                   MULT(H)   W@SRT2        W@BCE2                           Amount*Spot
     C                   ELSE                                                   EL DIVIDE 2
     C     W@SRT2        IFNE      *ZERO                                        IF NOT ZERO
     C                   DIV(H)    W@SRT2        W@BCE2                           Amount/Spot
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Find the average of the BCE values calculated :
      *
     C                   ADD       W@BCE1        W@BCE2                         Sum
     C                   DIV(H)    2             W@BCE2                         Average
      *
      * Calculate lowest and highest (average +/- 20%) :
      *
     C     W@BCE2        DIV(H)    5             W@BCE1                         20%
     C     W@BCE2        SUB       W@BCE1        W@BCEL           15 3          Lowest allowed
     C     W@BCE2        ADD       W@BCE1        W@BCEH           15 3          Highest allowd
      *
      * Adjust High & Low values to Base decimal positions :
      *
     C     BseCcyDP      IFEQ      *ZERO                                        IF BASE DECP=0
     C                   Z-ADD(H)  W@BCEL        W@BC0L                           Adjust Low
     C                   Z-ADD(H)  W@BCEH        W@BC0H                           Adjust High
     C                   END                                                    FI
     C     BseCcyDP      IFEQ      1                                            IF BASE DECP=1
     C     W@BCEL        DIV(H)    1             W@BC1L                           Adjust Low
     C     W@BCEH        DIV(H)    1             W@BC1H                           Adjust High
     C                   END                                                    FI
     C     BseCcyDP      IFEQ      2                                            IF BASE DECP=2
     C     W@BCEL        DIV(H)    1             W@BC2L                           Adjust Low
     C     W@BCEH        DIV(H)    1             W@BC2H                           Adjust High
     C                   END                                                    FI
     C     BseCcyDP      IFEQ      3                                            IF BASE DECP=3
     C     W@BCEL        DIV(H)    1             W@BC3L                           Adjust Low
     C     W@BCEH        DIV(H)    1             W@BC3H                           Adjust High
     C                   END                                                    FI
      *
      * If no amount entered, use median as default :
      * (and send warning message)
      *
     C     JUNBCA        IFEQ      *ZERO                                        IF NOT ENTERED
     C     W@BC0H        ADD       W@BC0L        JUNBCA                           Sum
     C                   DIV(H)    2             JUNBCA                           Average
     C                   MOVE      'W'           DDL1BEOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDL1BE'      WFldNmXAr(WIx)
     C                   MOVEL     'ABM0160'     WMsgIdXAr(Wix)
     C                   END                                                    FI
      *
      * Check entered amount against calculated limits :
      *
     C     JUNBCA        IFLT      W@BC0L                                       IF  TOO LOW
     C     JUNBCA        ORGT      W@BC0H                                        OR TOO HIGH
     C                   MOVE      *BLANK        M@MGDA                           Message data
     C                   Z-ADD     W@BC0L        @@AMTW                           I:Amount
     C                   Z-ADD     BseCcyDP      W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             90          Find start
     C                   MOVEA     @Z(P1)        M@0115                           O:To msg.data
     C                   Z-ADD     W@BC0H        @@AMTW                           I:Amount
     C                   Z-ADD     BseCcyDP      W@DECP                           I:Dec.places
     C                   EXSR      FMTAMT                                         <Convert>
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Z(P1)                             90          Find start
     C                   MOVEA     @Z(P1)        M@1630                           O:To msg.data
     C                   MOVE      'N'           DDL1BEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1BE'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0137'     MsgIdXAr(Idx)
     C**********         MOVEL     M@MGDA        MsgDtaXAr(Idx)                   :Msg.data MD000091
     C                   EVAL      BLen = %Len(%Trim(M@MGDA))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(M@MGDA)                   MD000091
     C                   GOTO      EL1BEV
     C                   END                                                    FI
      *          _____________
     C     SL1BEV        TAG                                                    +++TAG+++
      *          ~~~~~~~~~~~~~
      * Reformat BCE amount for display
      *
     C                   Z-ADD     JUNBCA        @@AMTW                         I:Amount
     C                   Z-ADD     BseCcyDP      W@DECP                         I:Dec.places
     C                   EXSR      FMTAMT                                       <Convert>
     C                   MOVE      @@AMTP        DDL1BE                         O:To display
      *
     C     EL1BEV        ENDSR
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
     C*********************************************************************
     C* FMTAMT - FORMAT AMOUNT FOR DISPLAY
     C*********************************************************************
     C     FMTAMT        BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           15 0
     C                   PARM                    W@DECP            1 0
     C                   PARM      BNDCSP        @@DCSP            1            156689
     C                   PARM      *BLANK        @@AMTP           16
     C                   PARM      *BLANK        @@AMTD           17
 
     C                   ENDSR
     C*********************************************************************
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
      ** 1st leg exchange rate
      ** 1st leg buy currency
      ** 1st leg buy amount
      ** 1st leg sell currency
      ** 1st leg sell amount
      ** 1st leg base equivalent
     C                   PARM                    DDL1RT           13
     C                   PARM                    DDL1CB            3
     C                   PARM                    DDL1BA           16
     C                   PARM                    DDL1CS            3
     C                   PARM                    DDL1SA           16
     C                   PARM                    DDL1BE           16
      *
      ** ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BseCcyDP          1 0
     C                   PARM                    BNCYDL            3
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Currency 1 details
     C                   PARM                    W@SRT1                         Spot rate 1
     C                   PARM                    W@MDI1                         Mult/Div.ind.1
     C                   PARM                    W@HSR1                         Hi Spot rate 1
     C                   PARM                    W@LSR1                         Lo Spot rate 1
     C                   PARM                    W@XMD1                         Xrate M/D 1
     C                   PARM                    W@NQD1                         N/Quoted dec.1
     C                   PARM                    W@SXP1                         ScaleExponent1
     C                   PARM                    W@ICM1                         Int.Calc.Mth.1
     C                   PARM                    W@FSD1                         FX Spot date 1
     C                   PARM                    W@LCRD                         Ln Ccy R-dn ind
      *
      ** Currency 2 details
     C                   PARM                    W@SRT2                         Spot rate 2
     C                   PARM                    W@MDI2                         Mult/Div.ind.2
     C                   PARM                    W@HSR2                         Hi Spot rate 2
     C                   PARM                    W@LSR2                         Lo Spot rate 2
     C                   PARM                    W@XMD2                         Xrate M/D 2
     C                   PARM                    W@NQD2                         N/Quoted dec.2
     C                   PARM                    W@SXP2                         ScaleExponent2
     C                   PARM                    W@ICM2                         Int.Calc.Mth.2
     C                   PARM                    W@FSD2                         FX Spot date 2
     C                   PARM                    W@DCRD                         Dp Ccy R-dn ind
      *
      * Deal Normally-Quoted Decimal Places:
     C                   PARM                    W@NQDP            1 0            Quoted=5
      *
      ** 2nd leg buy currency
      ** 2nd leg sell currency
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2CS            3
      *
      ** 1st leg exchange rate - OK
      ** 1st leg buy currency - OK
      ** 1st leg buy amount - OK
      ** 1st leg sell currency - OK
      ** 1st leg sell amount - OK
      ** 1st leg base equivalent - OK
     C                   PARM                    ddL1RTok          1
     C                   PARM                    ddL1CBok          1
     C                   PARM                    ddL1BAok          1
     C                   PARM                    ddL1CSok          1
     C                   PARM                    ddL1SAok          1
     C                   PARM                    ddL1BEok          1
      *
      ** Near Date Exchange Rate
      ** First Currency
      ** First Currency Decimal Places
      ** First Ccy Near Date Amount
      ** Near Date Buy Amount
      ** Second Currency
      ** Second Currency Decimal Places
      ** Second Ccy Near Date Amount
      ** Near Date Sell Amount
      ** Deal Mult/Div First Amount Ind
      ** Near Date Base Ccy for Accounting Amount
      *
     C                   PARM                    JUNDXR           13 8
     C                   PARM                    JUDFCY            3              Currency
     C                   PARM                    JUCDPF                           Dec.places
     C                   PARM                    JUNDA1           15 0            Amount
     C                   PARM                    JUNDBA           15 0            Buy amount
     C                   PARM                    JUDSCY            3              Currency
     C                   PARM                    JUCDPS                           Dec.places
     C                   PARM                    JUNDA2           15 0            Amount
     C                   PARM                    JUNDSA           15 0            Sell amount
     C                   PARM                    JUDMD1            1              Mult/Div ind.
     C                   PARM                    JUNBCA           15 0            Amount
      *
      ** Work fields
      *
     C     *LIKE         DEFINE    A6SCEX        W@SFAC                         Scaling Factor
 
     C     *LIKE         DEFINE    A6SPRT        W@SRT1                         Spot rate 1
     C     *LIKE         DEFINE    A6MDIN        W@MDI1                         Mult/Div.ind.1
     C     *LIKE         DEFINE    A6HSRT        W@HSR1                         Hi Spot rate 1
     C     *LIKE         DEFINE    A6LSPR        W@LSR1                         Lo Spot rate 1
     C     *LIKE         DEFINE    A6MDEX        W@XMD1                         Xrate M/D 1
     C     *LIKE         DEFINE    A6NQDP        W@NQD1                         N/Quoted dec.1
     C     *LIKE         DEFINE    A6SCEX        W@SXP1                         ScaleExponent1
     C     *LIKE         DEFINE    A6DICB        W@ICM1                         Int.Calc.Mth.1
     C     *LIKE         DEFINE    A6FXSD        W@FSD1                         FX Spot date 1
     C     *LIKE         DEFINE    A6RDFC        W@LCRD                         Ln Ccy R-dn ind
 
     C     *LIKE         DEFINE    A6SPRT        W@SRT2                         Spot rate 2
     C     *LIKE         DEFINE    A6MDIN        W@MDI2                         Mult/Div.ind.2
     C     *LIKE         DEFINE    A6HSRT        W@HSR2                         Hi Spot rate 2
     C     *LIKE         DEFINE    A6LSPR        W@LSR2                         Lo Spot rate 2
     C     *LIKE         DEFINE    A6MDEX        W@XMD2                         Xrate M/D 2
     C     *LIKE         DEFINE    A6NQDP        W@NQD2                         N/Quoted dec.2
     C     *LIKE         DEFINE    A6SCEX        W@SXP2                         ScaleExponent2
     C     *LIKE         DEFINE    A6DICB        W@ICM2                         Int.Calc.Mth.2
     C     *LIKE         DEFINE    A6FXSD        W@FSD2                         FX Spot date 2
     C     *LIKE         DEFINE    A6RDFC        W@DCRD                         Dp Ccy R-dn ind
 
     C     *LIKE         DEFINE    A6MDEX        @@XRMD                         ¦
     C     *LIKE         DEFINE    JUNDA1        @@DAM1                         ¦
     C     *LIKE         DEFINE    JUNDA1        @@DAM2                         ¦
 
     C                   Z-ADD     1             P1                5 0          Set pointer 1
 
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @AD
000000010
000000100
000001000
000010000
000100000
001000000
010000000
100000000
** @SF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
