     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP notified delivery ccy/amount')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVINDCA - Validate Notified Delivery Currency and Amount    *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 07May12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
      ** Initialise output parameters.
     C                   EVAL      PNotInCy = *Blank
     C                   EVAL      PNotTPSD = 0
     C                   EVAL      PNotNumDP = 0
      *
      ** Initialise variables for update of Valid File fields.
     C                   Z-ADD     *Zeros        WNDAM            13 0
      *
      ** Initialise work variables.
     C                   EVAL      Idx = 0
      *
      ** Validate Notified Delivery Currency and Amount
      *
     C                   EXSR      SRValNcyAm
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKNDCY = 'N' or
     C                             OKNDAM = 'N' or
     C                             OKSMAM = 'N' or
     C                             OKPYAM = 'N'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ENDIF
      *
     C                   IF        OKNDCY <> 'N'
     C                   MOVE      DDNDCY        IPNDCY
     C                   Z-ADD     WNDAM         IPNDAM
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALNCYAM - Notified Delivery Currency and Amount           *
      *               Validation                                      *
      *                                                               *
      *****************************************************************
     C     SRValNcyAm    BEGSR
      *
      ** Validate Notified Delivery Currency
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
      *                                                                         CFT014
     C                   EXSR      SRVALNCY2                                    CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *
      ** If feature CEU006 is installed
      *
     C                   IF        CEU006 = 'Y'
      *
     C                   EXSR      SRValNcy
      *
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Validate Notified Delivery Amount
      *
      ** If no error in currency
      *
     C                   IF        OKNDCY = 'Y'
      *
     C                   EXSR      SRValNam
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALNCY - Notified Delivery Currency Validation             *
      *                                                               *
      *****************************************************************
      *
     C     SRValNcy      BEGSR
      *
     C                   IF        DDNDCY <> *Blanks
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C                   IF        PMODE = '*FRONT'
     C     '?'           SCAN      DDNDCY                                 01
     C                   If        *IN01 = *On
     C                   MOVE      'N'           OKNDCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0024'     MsgIdXAr(Idx)
     C**********         MOVEL     DDNDCY        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDNDCY))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDNDCY)                   MD000091
      *
     C                   goto      ESRValNcy
     C                   EndIf
     C                   ENDIF
      *
      ** Entry is not allowed when settlement currency is not an
      ** "IN" currency and not Euro currency
      *
     C                   If        PSetInCy <> 'Y' and
     C                             DDSMCY <> BKEURO
     C                   MOVE      'N'           OKNDCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2585'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3150'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      DDNDCY        PCcy              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Currency is found in table file
      *
     C                   IF        PRtCd = *Blanks
     C                   EVAL      DDNDCY = PCcy
      *
      ** Notified Delivery Currency must be an 'IN' Currency
      ** or Euro Currency
      *
     C                   If        A6INCY <> 'Y' and
     C                             A6CYCD <> BKEURO
     C                   MOVE      'N'           OKNDCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2556'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3151'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf
      *
      ** If Settle Currency is Euro then entry must be an 'IN' Currency
      *
     C                   IF        DDSMCY = BKEURO and
      *
     C                             A6INCY <> 'Y'
     C                   MOVE      'N'           OKNDCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2557'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3152'     MsgIdXAr(Idx)                  CFT014
     C                   ELSE
      *
      ** If Settle Currency is 'IN' Currency then Notified Delivery
      ** Currency must be in Euro
      *
     C                   If        PSetInCy = 'Y' and
     C                             DDNDCY <> BKEURO
     C                   MOVE      'N'           OKNDCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2558'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3153'     MsgIdXAr(Idx)                  CFT014
     C                   Else
     C                   MOVE      A6INCY        PNotInCy
     C                   MOVE      A6TPSD        PNotTPSD
     C                   Z-ADD     A6NBDP        PNotNumDP
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      DDNDCY = *BLANKS
     C                   ELSE
      *
      ** Currency is not found in table file
      *
     C                   MOVE      'N'           OKNDCY
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2555'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3154'     MsgIdXAr(Idx)                  CFT014
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRValNcy     ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRVALNCY2- Notified Delivery Currency Validation if CFT014   *         CFT014
      *             is on whick allows non-Euro currency for its      *         CFT014
      *             value.                                            *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRValNcy2     BEGSR                                                  CFT014
      *                                                                         CFT014
     C                   IF        DDNDCY <> *Blanks                            CFT014
      *                                                                         CFT014
      ** Question mark is valid only on repair and i/c screens input.           CFT014
      *                                                                         CFT014
     C                   IF        PMODE = '*FRONT'                             CFT014
     C     '?'           SCAN      DDNDCY                                 01    CFT014
     C                   If        *IN01 = *On                                  CFT014
     C                   MOVE      'N'           OKNDCY                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0024'     MsgIdXAr(Idx)                  CFT014
     C**********         MOVEL     DDNDCY        MsgDtaXAr(Idx)                      CFT014 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDNDCY))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDNDCY)                   MD000091
      *                                                                         CFT014
     C                   goto      ESRValNcy2                                   CFT014
     C                   EndIf                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   CALLB     'AOCURRR0'                                   CFT014
     C                   PARM      *Blanks       PRtCd                          CFT014
     C                   PARM      '*KEY   '     POptn                          CFT014
     C                   PARM      DDNDCY        PCcy                           CFT014
     C     SDCURR        PARM      SDCURR        DSSDY                          CFT014
      *                                                                         CFT014
     C                   IF        PRtCd = *Blanks                              CFT014
      *                                                                         CFT014
     C                   EVAL      PNotInCy =  A6INCY                           CFT014
     C                   EVAL      PNotTPSD =  A6TPSD                           CFT014
     C                   EVAL      PNotNumDP=  A6NBDP                           CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C                   IF        PRtCd = '*NOSEL '                            CFT014
     C                   EVAL      DDNDCY = *BLANKS                             CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** Currency is not found in table file                                    CFT014
      *                                                                         CFT014
     C                   MOVE      'N'           OKNDCY                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDNDCY'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3154'     MsgIdXAr(Idx)                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     ESRValNcy2    ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALNAM - Notifed Delivery Amount Validation                *
      *                                                               *
      *****************************************************************
      *
     C     SRValNAm      BEGSR
      *
      ** Notified delivery amount must be 13-long numeric with number
      ** of D.P.S dependent on the notified delivery currency
      *
     C                   IF        CEU006 = 'Y'
     C                             OR (CFT014 = 'Y')                            CFT014
      *
      ** Notified Delivery Amount cannot be entered without a
      ** Notified Delivery Currency
      *
     C                   If        DDNDAM <> *Blanks and
     C                             DDNDCY = *Blanks
     C                   MOVE      'N'           OKNDAM
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDAM'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2586'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3155'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf
      *
     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDNDAM        ZField
     C                   EVAL      ZADEC = PNotNumDP
     C                   EVAL      ZADig = 13 - PNotNumDP
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
      ** The entry is in invalid format
      *
     C                   MOVE      'N'           OKNDAM
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDAM'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2559'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3157'     MsgIdXAr(Idx)                  CFT014
      *
     C                   ELSE
      *
     C                   MOVE      ZField        WNDAM
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if neither amount entered, Otherwise invalid
      *
     C                   IF        CEU006 <> 'Y'
     C                             AND (CFT014 <> 'Y')                          CFT014
      *
     C                   If        DDSMAM = *Blanks and
     C                             DDPYAM = *Blanks and
     C                             OKSMAM = 'Y' and
     C                             OKPYAM = 'Y'
     C                   MOVE      'N'           OKSMAM
     C                   ADD       1             Idx
     C                   MOVEL     'DDSMAM'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0025'     MsgIdXAr(Idx)
     C                   MOVE      'N'           OKSMAM
     C                   MOVE      'N'           OKPYAM
     C                   EndIf
      *
     C                   ELSE
      *
      ** Either Pay amount, Settle amount or Notified Delivery
      ** amount must be entered
      *
     C                   If        DDSMAM = *Blanks and
     C                             DDPYAM = *Blanks and
     C                             DDNDAM = *Blanks and
     C                             OKSMAM = 'Y' and
     C                             OKPYAM = 'Y' and
     C                             OKNDAM = 'Y'
     C                   MOVE      'N'           OKNDAM
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDAM'      FldNamXAr(Idx)
     C*****              MOVEL     'FTM2583'     MsgIdXAr(Idx)                  CFT014
     C                   MOVEL     'FTM3156'     MsgIdXAr(Idx)                  CFT014
     C                   MOVE      'N'           OKSMAM
     C                   MOVE      'N'           OKPYAM
     C                   EndIf
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
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy          1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO            3
      *
      ** SDBANK - Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Notified Delivery In Currency Indicator
     C                   PARM                    PNotInCy          1
      *
      ** Notified EMU Transition Period Start Date
     C                   PARM                    PNotTPSD          5 0
      *
      ** Notified Delivery Number of Decimal Places
     C                   PARM                    PNotNumDP         1 0
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
(c) Finastra International Limited 2001
