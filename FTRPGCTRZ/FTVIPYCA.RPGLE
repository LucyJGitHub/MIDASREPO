     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP payment ccy/amount')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIPYCA - Validate Payment Currency and Amount              *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 06May13               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240689 - Parameters missing.  Applied fix 210654.            *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** External DS for Bank details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise output parameters
     C                   EVAL      PPayInCy = *Blanks
     C                   EVAL      PPayTPSD = 0
     C                   EVAL      PPayNumDP = 0
     C                   EVAL      PPaySpotRat = 0
     C                   EVAL      PPayMDIn = 0
     C                   EVAL      PPaySRat = 0
      *
      ** Initialise variables for update of Valid File fields.
     C                   Z-ADD     *Zeros        WPYAM            13 0
     C                   Z-ADD     *Zero         WMDIN             1 0
     C                   Z-ADD     *Zeros        WPRTE            13 8
      *
      ** Initialise work variables.
     C                   EVAL      Idx = 0
      *
      ** Validate Payment Currency and Amount
      *
     C                   EXSR      SRValPcyAm
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKPCCY = 'N' or
     C                             OKPYAM = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKPCCY <> 'N'
     C                   MOVE      DDPCCY        IPPCCY
     C                   Z-ADD     WPRTE         IPPRTE
     C                   ENDIF
      *
     C                   IF        OKPYAM <> 'N'
      *
     C                   Z-ADD     WPYAM         IPPYAM
      *
      ** Calculate base currency equivalent
     C     PPayNumDp     SUB       PBCDP         N                 1 0
     C                   ADD       4             N
 
     C                   IF        PPayMDIN  = 0
 
     C     IPPYAM        IFNE      *ZERO
     C     PPaySpotRat   MULT(H)   POWER(N)      WK159
     C     IPPYAM        DIV(H)    WK159         IPPBCQ
     C                   ENDIF
     C                   ELSE
 
     C     PPaySpotRat   IFNE      *ZERO
     C     PPaySpotRat   DIV(H)    POWER(N)      WK159            15 9
     C     IPPYAM        MULT(H)   WK159         IPPBCQ
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     IPPCCY        IFEQ      BJCYCD
     C                   Z-ADD     IPPBCQ        IPSBCQ
     C                   ELSE
     C                   Z-ADD     IPSBCQ        IPPBCQ
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALPCYAM - Payment Currency and Amount Validation          *
      *                                                               *
      *****************************************************************
      *
     C     SRValPcyAm    BEGSR
      *
      ** Validate Payment Currency and Amount
      *
     C                   EXSR      SRValPcy
      *
      ** Validate Payment Amount
      *
     C                   IF        OKPCCY = 'Y'
      *
     C                   EXSR      SRValPAm
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALPCY - Payment Currency Validation                       *
      *                                                               *
      *****************************************************************
      *
     C     SRValPcy      BEGSR
      *
      ** If entered, It must exist on currency table
      *
     C                   IF        DDPCCY <> *Blanks
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C                   IF        PMODE = '*FRONT'
     C     '?'           SCAN      DDPCCY                                 01
     C                   If        *IN01 = *On
     C                   MOVE      'N'           OKPCCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDPCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0036'     MsgIdXAr(Idx)
     C**********         MOVEL     DDPCCY        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDPCCY))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDPCCY)                   MD000091
      *
     C                   goto      ESRValPcy
     C                   EndIf
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      DDPCCY        PCcy              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtCd <> *Blanks
      *
     C                   IF        PRtCd = '*NOSEL '
     C                   MOVE      *BLANKS       DDPCCY
     C                   ELSE
      *
      ** Entry is not a valid currency code.
      *
     C                   MOVE      'N'           OKPCCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDPCCY'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0037'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      DDPCCY = PCcy
      *
      ** Move new SYNON field names in SDCURRPD back into old fields
      *
     C                   IF        A6MDIN = 'M'
     C                   Z-ADD     1             WMDIN
     C                   ELSE
     C                   Z-ADD     0             WMDIN
     C                   ENDIF
      *
     C                   MOVE      A6INCY        PPayInCy
     C                   MOVE      A6TPSD        PPayTPSD
     C                   Z-ADD     A6NBDP        PPayNumDP
     C                   Z-ADD     A6SPRT        PPaySpotRat
     C                   Z-ADD     WMDIN         PPayMDIn
      *
      ** Change Spot Rate by Buy Spread
      *
     C                   IF        A6BYSS = '+'
     C     A6SPRT        ADD       A6BYSR        PBRat            13 8
     C                   ELSE
     C     A6SPRT        SUB       A6BYSR        PBRat
     C                   ENDIF
      *
      ** Change Spot Rate by Sell Spread
      *
     C                   IF        A6SLSS = '+'
     C     A6SPRT        ADD       A6SLSR        PPaySRat
     C                   ELSE
     C     A6SPRT        SUB       A6SLSR        PPaySRat
     C                   ENDIF
      *
      ** Save Spot + Spread Rate in valids file for update
      *
     C                   IF        DDPCCY = BJCYCD
     C                   Z-ADD     1             WPRTE
     C                   ELSE
     C                   Z-ADD     PPaySRat      WPRTE
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If "Pay Currency" not entered and valid "Settlement Currency"
      ** was entered, Set Pay Currency and No. of decimal placed
      ** equal to Settlement values (also Spot Rate & Mult/Div
      ** indicator).
      *
     C                   IF        DDPCCY = *Blanks and
     C                             OKSMCY = 'Y'
      *
     C                   MOVEL     DDSMCY        DDPCCY
     C                   Z-ADD     PSetNumDP     PPayNumDP
     C                   Z-ADD     PSetSpotRat   PPaySpotRat
     C                   Z-ADD     PSetMDIn      PPayMDIn
     C                   Z-ADD     IPSRTE        WPRTE
      *
     C                   ENDIF
      *
     C     ESRValPcy     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALPAM - Payment Amount Validation                         *
      *                                                               *
      *****************************************************************
      *
     C     SRValPAm      BEGSR
      *
      ** Pay Amount field must be 13-long numeric with number of D.P.S
      ** dependent on the pay currency.
      *
     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDPYAM        ZField
     C                   EVAL      ZADec = PPayNumDP
     C                   EVAL      ZADig = 13 - PPayNumDP
      *
      ** Validate Amount as numeric with correct d.p.
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk          1
     C                   PARM                    ZField           16
     C                   PARM                    ZADec             1 0
     C                   PARM                    ZADig             2 0
      *
     C                   IF        ZalignOk <> 'Y'
      *
      ** The entry is not a valid amount
      *
     C                   MOVE      'N'           OKPYAM
     C                   ADD       1             Idx
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0038'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
     C                   MOVE      ZField        WPYAM
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP             1 0
      *
      ** Settlement Number of Decimal Places
     C                   PARM                    PSetNumDP         1 0
      *
      ** Settlement Spot Rate
     C                   PARM                    PSetSpotRat      13 8
      *
      ** Settlement Multiply/Divide indicator
     C                   PARM                    PSetMDIn          1 0
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy          1
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD          5 0
      *
      ** Payment Number of Decimal Places
     C                   PARM                    PPayNumDP         1 0
      *
      ** Payment Spot Rate
     C                   PARM                    PPaySpotRat      13 8
      *
      ** Payment Multiply/Divide Indicator
     C                   PARM                    PPayMDIn          1 0
      *
      ** Payment Spot Rate by Sell Spread
     C                   PARM                    PPaySRat         13 8
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
