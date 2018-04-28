     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP settlement ccy/amount')           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVISMCA - Validate Settlement Currency and Amount           *
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
      *  240689 - Parameters missings.  Applied fix 210654.           *
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
     C                   EVAL      PSetInCy = *Blanks
     C                   EVAL      PSetTPSD = 0
     C                   EVAL      PSetNumDP = 0
     C                   EVAL      PSetSpotRat = 0
     C                   EVAL      PSetMDIn = 0
     C                   EVAL      PSetBRat = 0
      *
      ** Initialise variables for update of Valid File fields.
     C                   Z-ADD     *Zeros        WSMAM            13 0
     C                   Z-ADD     *Zero         WMDIN             1 0
     C                   Z-ADD     *Zeros        WSRTE            13 8
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
      *
      ** Validate Settlement Currency and Amount
      *
     C                   EXSR      SRValScyAm
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKSMCY = 'N' or
     C                             OKSMAM = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKSMCY <> 'N'
     C                   MOVE      DDSMCY        IPSMCY
     C                   Z-ADD     WSRTE         IPSRTE
     C                   ENDIF
      *
     C                   IF        OKSMAM <> 'N' and
     C                             OKSMCY <> 'N'
     C                   Z-ADD     WSMAM         IPSMAM
      *
      ** Calculate base currency equivalent
     C     PSetNumDp     SUB       PBCDP         N                 1 0
     C                   ADD       4             N
     C                   IF        PSetMDIN = 0
     C     PSetSpotRat   MULT(H)   POWER(N)      WK159
     C     IPSMAM        DIV(H)    WK159         IPSBCQ
     C                   ELSE
     C     PSetSpotRat   DIV(H)    POWER(N)      WK159            15 9
     C     IPSMAM        MULT(H)   WK159         IPSBCQ
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSCYAM - Settlement Currency and Amount Validation       *
      *                                                               *
      *****************************************************************
     C     SRValScyAm    BEGSR
      *
      ** Entry for for this field is mandatory and must exist in
      ** currency table.
      *
     C                   IF        DDSMCY = *Blanks
      *
     C                   MOVE      'N'           OKSMCY
     C                   ADD       1             IDx
     C                   MOVEL     'DDSMCY'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0055'     MsgIdXAr(IDx)
      *
     C                   ELSE
      *
     C                   EXSR      SRValScy
      *
     C                   ENDIF
      *
      ** Validate Settlement Amount
      *
     C                   IF        OKSMCY = 'Y'
      *
     C                   EXSR      SRValSam
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSCY - Settlement Currency Validation                    *
      *                                                               *
      *****************************************************************
      *
     C     SRValScy      BEGSR
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C                   IF        PMODE = '*FRONT'
     C     '?'           SCAN      DDSMCY                                 01
     C                   If        *IN01 = *On
     C                   MOVE      'N'           OKSMCY
     C                   ADD       1             IDx
     C                   MOVEL     'DDSMCY'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0056'     MsgIdXAr(IDx)
     C**********         MOVEL     DDSMCY        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDSMCY))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDSMCY)                   MD000091
      *
     C                   goto      ESRValScy
     C                   EndIf
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDSMCY        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
      ** Entry for for this field is mandatory and must exist in
      ** currency table.
     C                   IF        PRTCD = '*NOSEL '
     C                   MOVE      *BLANKS       DDSMCY
     C                   MOVE      'N'           OKSMCY
     C                   MOVE      'N'           OKSMAM
     C                   ADD       1             IDx
     C                   MOVEL     'DDSMCY'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0055'     MsgIdXAr(IDx)
     C                   goto      ESRValScy
     C                   ELSE
      *
      ** Entry must be a valid currency code.
      *
     C                   MOVE      'N'           OKSMCY
     C                   MOVE      'N'           OKSMAM
     C                   ADD       1             IDx
     C                   MOVEL     'DDSMCY'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0057'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      DDSMCY = PCCY
      *
      ** Move new SYNON field names in SDCURRPD back into old fields
      *
     C                   IF        A6MDIN = 'M'
     C                   Z-ADD     1             WMDIN
     C                   ELSE
     C                   Z-ADD     0             WMDIN
     C                   ENDIF
      *
      ** Setup output parameters
      *
     C                   MOVE      A6INCY        PSetInCy
     C                   MOVE      A6TPSD        PSetTPSD
     C                   Z-ADD     A6NBDP        PSetNumDP
     C                   Z-ADD     A6SPRT        PSetSpotRat
     C                   Z-ADD     WMDIN         PSetMDIn
      *
      ** Change Spot Rate by Buy Spread
      *
     C                   IF        A6BYSS = '+'
     C     A6SPRT        ADD       A6BYSR        PSetBRat
     C                   ELSE
     C     A6SPRT        SUB       A6BYSR        PSetBRat
     C                   ENDIF
      *
      ** Save SPOT + SPREAD rate in valids file for future update.
      *
     C                   IF        DDSMCY = BJCYCD
     C                   Z-ADD     1             WSRTE
     C                   ELSE
     C                   Z-ADD     PSetBRat      WSRTE
     C                   ENDIF
      *
      ** Change Spot Rate by Sell Spread
      *
     C                   IF        A6SLSS = '+'
     C     A6SPRT        ADD       A6SLSR        SSRat            13 8
     C                   ELSE
     C     A6SPRT        SUB       A6SLSR        SSRat
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRValScy     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSAM - Settlement Amount Validation                      *
      *                                                               *
      *****************************************************************
      *
     C     SRValSAm      BEGSR
      *
      ** Settlement Amount field must be 13-long numeric with number of
      ** D.P.S. dependent on the pay currency
      *
     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDSMAM        ZField
     C                   EVAL      ZADec = PSetNumDP
     C                   EVAL      ZADig = 13 - PSetNumDP
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
      ** The entry must be a valid amount
      *
     C                   MOVE      'N'           OKSMAM
     C                   ADD       1             IDx
     C                   MOVEL     'DDSMAM'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0058'     MsgIdXAr(IDx)
      *
     C                   ELSE
      *
     C                   MOVE      ZField        WSMAM
      *
     C                   ENDIF
      *
     C                   ENDSR
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
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
     C                   PARM                    MsgIdXAr
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
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy          1
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD          5 0
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
      ** Settlement Spot by Buy Spread
     C                   PARM                    PSetBRat         13 8
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
