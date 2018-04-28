     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities amend checking for screen 1')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS1MD - Securities Amend Checking for Screen 1           *
      *                                                               *
      *  Function: This module compares the fields of an amended      *
      *            security details against those currently on        *
      *            file.  This program also checks whether all fields *
      *            amended are amendable, and if not, an error        *
      *            message will be sent to calling module.            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 20May13               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192054             Date 28Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  192054 - ISIN code must be available if Private banking is on*
      *  CSD006 - Market Data Feed (recompile)                        *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(A)
      *
      ** Securities Screen 1 details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities Screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IDx             S              3P 0
      *
      ** Entry parameter fields
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D BGN2ST          S              1A
     D CEU018          S              1A
     D S01401          S              1A
     D CSE007          S              1A
     D CEU017          S              1A
     D PPROT           S              1A
     D BGN4ST          S              1A                                                      192054
      *
      ** Parameters for ZALIGN
     D ZalignOk        S              1A
     D ZField          S             16A
     D ZADec           S              1P 0
     D ZADig           S              2P 0
      *
      ** Parameter list for ZA0921
     D PAmountIn       S             15P 0
     D PNDCP           S              1P 0
     D PDCSP           S              1A
     D PAmountOutP     S             16A
     D PAmountOutD     S             17A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
      ** Check if non-amendable fields were amended.
      *
     C                   EXSR      SRCompare
      *
      ** If any errors were found, set Amendments OK Indicator to 'N'.
      *
     C                   IF        IDx > 0
     C                   EVAL      PAmendOK = 'N'
     C                   ELSE
     C                   EVAL      PAmendOK = 'Y'
     C                   ENDIF
      *
      ** If any errors were found and Reset of Fields in Error
      ** required, do this:
      *
     C                   IF        IDx > 0 AND PResetFld = 'Y'
     C                   EXSR      SRResetFlds
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCompare - Routine to compare fields from file and the      *
      *              amended screen fields                            *
      *                                                               *
      *****************************************************************
     C     SRCompare     BEGSR
      *
      ** Incomplete indicator is not amendable.
      *
     C                   IF        INCS = 'C' AND
     C                             ADDINCS <> DDINCS
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDINCS'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Incomplete Indicator'                  MD000091
     C                   EVAL      MsgDtaTmp = 'Incomplete Indicator'                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKINCS = 'N'
     C                   ENDIF
      *
      ** Partly Paid is not amendable.
      *
     C                   IF        PPDI = 'N' AND
     C                             ADDPPDI <> DDPPDI
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDPPDI'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Partly Paid'                           MD000091
     C                   EVAL      MsgDtaTmp = 'Partly Paid'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPPDI = 'N'
     C                   ENDIF
      *
      ** Investment type is not amendable.
      *
     C                   IF        ADDSITP <> DDSITP
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSITP'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Investment type'                       MD000091
     C                   EVAL      MsgDtaTmp = 'Investment type'                            MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSITP = 'N'
     C                   ENDIF
      *
      ** Trade basis override is not amendable.
      *
     C                   IF        ADDTBOR <> DDTBOR
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDTBOR'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Trade basis override'                  MD000091
     C                   EVAL      MsgDtaTmp = 'Trade basis override'                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKTBOR = 'N'
     C                   ENDIF
 
     C                   IF        INCS = 'C' AND CSE007 = 'N' AND
     C                             CEU017 = 'N'
      *
      ** Convert incoming trade donomination field to correct numeric format
      ** for comparing.
     C                   IF        ADDSDNM <> *BLANKS
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      ADDSDNM       ZField
     C                   Z-ADD     7             ZADig
     C                   Z-ADD     *ZERO         ZADec
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   PARM                    ZADig
 
     C                   MOVE      ZField        PAmountIn
     C                   EVAL      PNDCP = 0
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmountOutP   ADDSDNM
 
     C                   ENDIF
      *
      ** Trade Denomination is not amendable.
     C                   IF        ADDSDNM <> DDSDNM
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSDNM'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Trade Denomination'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Trade Denomination'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSDNM = 'N'
     C                   ENDIF
      *
      ** Value Currency is not amendable.
     C                   IF        ADDVLCY <> DDVLCY
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDVLCY'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Value Currency'                        MD000091
     C                   EVAL      MsgDtaTmp = 'Value Currency'                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKVLCY = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Nominal currency is not amendable.
     C                   IF        ADDNMCY <> DDNMCY
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDTBOR'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Nominal currency'                      MD000091
     C                   EVAL      MsgDtaTmp = 'Nominal currency'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKNMCY = 'N'
     C                   ENDIF
      *
      ** ISIN/COMMON Code is not amendable.
     C                   IF        S01401 = 'N' AND ADDISIN <> DDISIN
     C                             AND BGN4ST = 'N'                                           192054
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDISIN'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'ISIN/COMMON Code'                      MD000091
     C                   EVAL      MsgDtaTmp = 'ISIN/COMMON Code'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKISIN = 'N'
     C                   ENDIF
      *
      ** SWIFT Security Type Code is not amendable.
     C                   IF        S01401 = 'N' AND ADDSWTP <> DDSWTP
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSWTP'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'SWIFT Security Type Code'              MD000091
     C                   EVAL      MsgDtaTmp = 'SWIFT Security Type Code'                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSWTP = 'N'
     C                   ENDIF
      *
      ** Nominal decimal places is not amendable.
     C                   IF        INCS = 'C' OR CEU018 = 'N' OR
     C                             PPROT = '7' OR PPROT = '8'
     C                   IF        ADDNMDP <> DDNMDP
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDNMDP'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Nominal Decimal places'                MD000091
     C                   EVAL      MsgDtaTmp = 'Nominal Decimal places'                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKNMDP = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if the following fields are amended when Midas Plato
      ** Interface is off.
      *
     C                   IF        BGN2ST <> 'Y'
      *
      ** Plato: Instrument Class Code is not amendable.
     C                   IF        ADDICCD <> DDICCD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDICCD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Instrument Class Code'                 MD000091
     C                   EVAL      MsgDtaTmp = 'Instrument Class Code'                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKICCD = 'N'
     C                   ENDIF
      *
      ** Debt Instrument Name is not amendable.
     C                   IF        ADDDINM <> DDDINM
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDINM'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Debt Instrument Name'                  MD000091
     C                   EVAL      MsgDtaTmp = 'Debt Instrument Name'                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDINM = 'N'
     C                   ENDIF
      *
      ** Reporting Group is not amendable.
     C                   IF        ADDRGCD <> DDRGCD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDRGCD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Reporting Group'                       MD000091
     C                   EVAL      MsgDtaTmp = 'Reporting Group'                            MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKRGCD = 'N'
     C                   ENDIF
      *
      ** Pricing Group is not amendable.
     C                   IF        ADDPGCD <> DDPGCD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDPGCD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Pricing Group'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Pricing Group'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPGCD = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFlds - Reset Fields in Error with their values on     *
      *                file                                           *
      *                                                               *
      *****************************************************************
     C     SRResetFlds   BEGSR
      *
      ** Incomplete indicator
      *
     C                   IF        OKINCS = 'N'
     C                   EVAL      ADDINCS = DDINCS
     C                   ENDIF
      *
      ** Partly Paid
      *
     C                   IF        OKPPDI = 'N'
     C                   EVAL      ADDPPDI = DDPPDI
     C                   ENDIF
      *
      ** Investment type
      *
     C                   IF        OKSITP = 'N'
     C                   EVAL      ADDSITP = DDSITP
     C                   ENDIF
      *
      ** Trade basis override
      *
     C                   IF        OKTBOR = 'N'
     C                   EVAL      ADDTBOR = DDTBOR
     C                   ENDIF
      *
      ** Trade Denomination
      *
     C                   IF        OKSDNM = 'N'
     C                   EVAL      ADDSDNM = DDSDNM
     C                   ENDIF
      *
      ** Value Currency
      *
     C                   IF        OKVLCY = 'N'
     C                   EVAL      ADDVLCY = DDVLCY
     C                   ENDIF
      *
      ** Nominal cyrrency
      *
     C                   IF        OKNMCY = 'N'
     C                   EVAL      ADDNMCY = DDNMCY
     C                   ENDIF
      *
      ** ISIN/COMMON Code
      *
     C                   IF        OKISIN = 'N'
     C                   EVAL      ADDISIN = DDISIN
     C                   ENDIF
      *
      ** SWIFT Security Type Code
      *
     C                   IF        OKSWTP = 'N'
     C                   EVAL      ADDSWTP = DDSWTP
     C                   ENDIF
      *
      ** Nominal decimal places
      *
     C                   IF        OKNMDP = 'N'
     C                   EVAL      ADDNMDP = DDNMDP
     C                   ENDIF
      *
      ** Instrument Class Code
      *
     C                   IF        OKICCD = 'N'
     C                   EVAL      ADDICCD = DDICCD
     C                   ENDIF
      *
      ** Debt Instrument Name
      *
     C                   IF        OKDINM = 'N'
     C                   EVAL      ADDDINM = DDDINM
     C                   ENDIF
      *
      ** Reporting Group is not amendable.
      *
     C                   IF        OKRGCD = 'N'
     C                   EVAL      ADDRGCD = DDRGCD
     C                   ENDIF
      *
      ** Pricing Group
      *
     C                   IF        OKPGCD = 'N'
     C                   EVAL      ADDPGCD = DDPGCD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format amount for display                         *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    PAmountIn
     C                   PARM                    PNDCP
     C                   PARM      '.'           PDCSP
     C                   PARM      *BLANK        PAmountOutP
     C                   PARM      *BLANK        PAmountOutD
 
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
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities Screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
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
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
