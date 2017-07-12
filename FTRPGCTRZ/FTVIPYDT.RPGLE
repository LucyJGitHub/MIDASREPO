     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP payment value date')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIPYDT - Validate Payment Value Date                       *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD036683A          Date 12Apr16               *
      *  Prev Amend No. MD036683           Date 06Jan16               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248631             Date 23Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 207211             Date 16Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036683A - Validate the settlement value date against the   *
      *              DACO even if the value date is holiday.          *
      *  MD036683 - Validate the payment value date against the       *
      *             opening date of the account (DACO) not only for   *
      *             retail accounts but for all types of accounts.    *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248631 - No warning message for outbound FT on a holiday.    *
      *           Patterned after fix 223018 which added a new        *
      *           warning message when the date for pay currency      *
      *           falls on a holiday.                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  207211 - invalid date not detected                           *
      *  CFT009 - Funds Transfer Fees and Charges                     *
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
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D NOSLOC                 29     31
      *
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Fields needed in setting default pay value date
     D PPYFLDS         DS
     D  CNUMPY                 1      6
     D  CCYPY                  7      9
     D  ACODPY                10     19                                                       CGL029
     D  ACSQPY                20     21                                                       CGL029
     D  BRCAPY                22     24                                                       CGL029
     D**ACODPY**              10     12                                                       CGL029
     D**ACSQPY**              13     15                                                       CGL029
     D**BRCAPY**              16     18                                                       CGL029
      *
     D WODATE          DS             6
     D  ODD                    1      2
     D  OMM                    3      4
     D  OYY                    5      6
      *
     D                 DS
     D WZDATE                  1      6  0
     D  ZDD                    1      2
     D  ZMM                    3      4
     D  ZYY                    5      6
     D  ZYN                    5      6  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D ZDATIN          S              6A
     D BVLD            S              5P 0
     D ZERR            S              1A
     D ZHIND           S              1A
     D PACCD           S             10A                                                      CGL029
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
      *
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
      ** Initialise output parameters.
      *
      ** Initialise variables for update of Valid File fields.
     C                   Z-ADD     *Zeros        WPYDT             5 0
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0
      *
      ** Validate Payment Value Date
      *
     C                   EXSR      SRValPayVD
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKPYDT = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKPYDT <> 'N'
     C                   Z-ADD     WPYDT         IPPVDT
      *
      ** Setup DAF Pay value date 1 and defualt date to screen field.
     C                   If        IPPVDT <> 0
     C                   Z-ADD     IPPVDT        ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   EVAL      WZDATE = ZDATE
     C                   EVAL      IPPVDTD1 = ZDATE
     C                   IF        CFT009 = 'N' OR                              CFT009
     C                             CFT009 = 'Y' AND DDPYDT <> *BLANKS           CFT009
     C                   MOVE      ZDATE         DDPYDT
     C                   ENDIF                                                  CFT009
     C                   Else
     C                   EVAL      IPPVDTD1 = *Zeros
     C                   EndIf
      *
      ** Setup DAF Pay value date 2
     C                   If        ZYN < 72
     C                   Z-ADD     20            IPPVDTD2
     C                   Else
     C                   Z-ADD     19            IPPVDTD2
     C                   EndIf
      *
      ** Setup DAF Pay value date 3
      *
     C                   If        BJDFIN <> 'M'
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZMM
     C                   EVAL      OYY = ZDD
     C                   ELSE
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZDD
     C                   EVAL      OYY = ZMM
     C                   EndIf
      *
     C                   MOVE      WODATE        IPPVDTD3
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALPayVD - Payment Value Date                              *
      *                                                               *
      *****************************************************************
     C     SRValPayVD    BEGSR
      *
      ** If date is not entered, Set to run date + 1 working day in pay
      ** currency if settle currency is base currency and to run
      ** date +2 working days in receive currency if not; Otherwise
      ** validate as being a valid date.
      *
     C                   IF        DDPYDT = *Blanks
      *
      ** Check A/c with bank or beneficiary customer being Nostro
     C                   CALLB     'AONOSTR0'
     C                   PARM      *Blanks       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      CNUMPY        PCUST             6
     C                   PARM      CCYPY         PCYCD             3
     C**********         PARM      ACODPY        PACCD             4                          CGL029
     C                   PARM      ACODPY        PACCD                                        CGL029
     C                   PARM      ACSQPY        PACSN             2
     C                   PARM      *Blanks       PNONB             2
     C                   PARM      BRCAPY        PBRCD             3
     C                   PARM      *Blanks       PCSSN            10
     C                   PARM      *Blanks       PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        PRTCD = *Blanks
     C                   MOVE      CCYPY         ZCCY
     C                   MOVE      NOSLOC        ZLOC
     C                   ELSE
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
     C                   If        ZCCY = BJCYCD
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     1             ZNRDYS
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM      *Zeros        ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
      *
     C                   Z-ADD     ZDYNBR        WPYDT
      *
     C                   Else
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     2             ZNRDYS
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM      *Zeros        ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
      *
     C                   Z-ADD     ZDYNBR        WPYDT
     C                   EndIf
      *
     C                   ELSE
      *
      ** Check if date is numeric
     C                   MOVEL     DDPYDT        DATEL             7 0
     C                   MOVEL     DATEL         DATES             6
      *
     C                   IF        DDPYDT <> DATES
      *
     C                   MOVE      'N'           OKPYDT
     C                   ADD       1             IDx
     C                   MOVEL     'DDPYDT'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0028'     MsgIdXAr(IDx)
      *
     C                   ELSE
      *
     C                   EVAL      ZDATIN = DDPYDT
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      ' '           ZERR
      *
     C                   IF        ZERR   <> 'Y'                                              207211
      *                                                                                       207211
     C                   Z-ADD     ZDAYNO        WPYDT
      *
      ** The pay value date must not be a holiday in local currency
      *
     C                   EVAL      ZCCY = BJLCCY
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM      ' '           ZHIND
      *
      ** if ZHIND = 'H' then the date is a holiday
     C                   If        ZHIND = 'H'
     C                   MOVE      'W'           OKPYDT
     C                   ADD       1             WIx
     C                   MOVEL     'DDPYDT'      WFldNmXAr(WIx)
     C**********         MOVEL     'FTA0029'     WMsgIdXAr(WIx)                               248631
     C                   MOVEL     'FTA2000'     WMsgIdXAr(WIx)                               248631
     C                   EndIf
      *                                                                                       248631
      ** Warning error if date is a holiday in pay curency - nostro loc                       248631
      *                                                                                       248631
     C                   MOVE      DDPCCY        ZCCY                                         248631
     C                   CALLB     'ZCHKH'                                                    248631
     C                   PARM                    ZDAYNO                                       248631
     C                   PARM                    ZCCY                                         248631
     C                   PARM                    ZLOC                                         248631
     C                   PARM      ' '           ZHIND                                        248631
      *                                                                                       248631
      ** if ZHIND = 'H' then the date is a holiday - send warning                             248631
      *                                                                                       248631
     C     ZHIND         IFEQ      'H'                                                        248631
     C                   MOVE      'W'           OKPydt                                       248631
     C                   ADD       1             WIx                                          248631
     C                   MOVEL     'DDPYDT'      WFldNmXAr(WIx)                               248631
     C                   MOVEL     'FTA2001'     WMsgIdXAr(WIx)                               248631
     C                   ENDIF                                                                248631
     C*                                                                                       207211
      ** ZDATE1 ended in error                                                                207211
     C                   ELSE                                                                 207211
     C                   MOVE      'N'           OKPYDT                                       207211
     C                   ADD       1             IDx                                          207211
     C                   MOVEL     'DDPYDT'      FldNamXAr(IDx)                               207211
     C                   MOVEL     'FTA0028'     MsgIdXAr(IDx)                                207211
      *                                                                                       207211
     C                   ENDIF                                                                207211
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if Pay Value Date is in the future and if the
      ** account is closing today (if pay date is valid)
      *
     C**********         IF        OKPYDT = 'Y' and                                        MD036683A
     C                   IF        OKPYDT <> 'N' and                                       MD036683A
     C                             OKBNC1 = 'Y' and
     C                             OKACBK = 'Y'
      *
     C                   If        WPYDT > BJRDNB and
     C                             PAcSt3 = 'C'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             IDx
     C                   MOVEL     'DDBNC1'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0030'     MsgIdxAr(IDx)
     C                   EndIf
      *
     C                   If        WPYDT > BJRDNB and
     C                             PAcSt4 = 'C'
     C                   MOVE      'N'           OKACBK
     C                   ADD       1             IDx
     C                   MOVEL     'DDACBK'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0031'     MsgIdXAr(IDx)
     C                   EndIf
      *
     C                   ENDIF
      *
      ** If pay value date, Beneficiary customer and account with
      ** bank are valid so far, for Retail accounts only check that
      ** the pay value date is not before the backvalue limit
      ** date nor before the date the account was opened for the
      ** account that must be in pay currency.
      *
     C**********         IF        OKPYDT = 'Y' and                                        MD036683A
     C                   IF        OKPYDT <> 'N' and                                       MD036683A
     C                             OKBNC1 = 'Y' and
     C                             OKACBK = 'Y'
      *
     C                   EVAL      BVLD = BJRDNB - BJBVPD
      *
     C                   IF        DDACBK = *Blanks
      *
      ** Use Beneficiary customer fields
     C**********         IF        PAtyp3 = 'R'                                             MD036683
     C                   IF        WPYDT < BVLD
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             IDx
     C                   MOVEL     'DDBNC1'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0032'     MsgIdXAr(IDx)
     C                   ELSE
     C                   If        WPYDT < PDAcO3
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             IDx
     C                   MOVEL     'DDBNC1'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0033'     MsgIdXAr(IDx)
     C                   EndIf
     C                   ENDIF
     C**********         ENDIF                                                              MD036683
      *
     C                   ELSE
      *
      ** Use Account with Bank Fields
     C**********         IF        PAtyp4 = 'R'                                             MD036683
     C                   IF        WPYDT < BVLD
     C                   MOVE      'N'           OKACBK
     C                   ADD       1             IDx
     C                   MOVEL     'DDACBK'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0034'     MsgIdXAr(IDx)
     C                   ELSE
     C                   If        WPYDT < PDAcO4
     C                   MOVE      'N'           OKACBK
     C                   ADD       1             IDx
     C                   MOVEL     'DDACBK'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0035'     MsgIdXAr(IDx)
     C                   EndIf
     C                   ENDIF
     C**********         ENDIF                                                              MD036683
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** Beneficiary Customer's Account Type
     C                   PARM                    PAtyp3            1
      *
      ** Beneficiary Customer's Account Status
     C                   PARM                    PAcSt3            1
      *
      ** Beneficiary Customer's Date Account Opened
     C                   PARM                    PDAcO3            5 0
      *
      ** A/c with Bank's Account Type
     C                   PARM                    PAtyp4            1
      *
      ** A/c with Bank's Account Status
     C                   PARM                    PAcSt4            1
      *
      ** A/c with Bank's Date Account Opened
     C                   PARM                    PDAcO4            5 0
      *
      ** Account needed to set payment value date
     C                   PARM                    PPYFLDS
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDBANK - Midas Local Currency
     C                   PARM                    BJLCCY            3
      *
      ** SDBANK - Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - System Location Code
     C                   PARM                    BJSLCD            3
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN            1
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
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
