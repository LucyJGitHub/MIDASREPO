     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Sec Diary Events amend checking for scn 1')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDE1MD - Security Diary Events amend checking for         *
      *              screen 1                                         *
      *                                                               *
      *  Function: This module will check if the non amendable        *
      *            fields for screen 1 were amended.  If yes, an      *
      *            error message will be sent to the calling module.  *
      *            If this module is called from repair or screen     *
      *            input functions, the values of the non-amendable   *
      *            fields will be reset with their values on file.    *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                SESEDECTL                                      *
      *                SESEDERPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 17May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL031             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE074 - Constant Yield Amortisation Upgrade to MidasPlus    *
      *           (Recompile)                                         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRCompare - Routine to compare fields from file and the      *
      *              amended screen fields                            *
      *  SRResetFlds - Reset fields in error with their values on     *
      *                file.                                          *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(A)
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     D CrDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
      *
      ** SE Diary events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IDx             S              3P 0
      *
      ** Work parameters
     D PAmendOk        S              1A
     D PResetFld       S              1A
     D RMFL            S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CAS006          S              1A                                                      CAS006
     D PPayCcy         S              3A
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Check if non-amendable fields were modified.
      *
     C                   EXSR      SRCompare
      *
      ** If any errors was found, set amendments OK indicator to 'N'.
      *
     C                   IF        IDx > 0
     C                   EVAL      PAmendOK = 'N'
     C                   ELSE
     C                   EVAL      PAmendOK = 'Y'
     C                   ENDIF
      *
      ** If any errors were found and reset of fields in error
      ** is required, reset amended fields.
      *
     C                   IF        IDx > 0 AND PResetFld = 'Y'
     C                   EXSR      SRResetFlds
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
      *
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
      ** If action is Insert and event type is Exchange Rate, check if
      ** payment currency has been changed.
      *
     C                   IF        ADDACTN = 'I'
      *
     C                   IF        ADDSDET = 'XR' AND S01509 = 'Y' AND
     C                             ADDPAYC <> PPayCcy
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDPAYC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Pay currency'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Pay currency'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPAYC = 'N'
     C                   ENDIF
 
     C                   GOTO      ESrCompare
 
     C                   ENDIF
      *
      ** Exchange Rates.
      *
     C                   IF        ADDSDET = 'XR' AND S01509 = 'Y'
      *
      ** Payment Currency.
     C                   IF        ADDPAYC <> DDPAYC
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDPAYC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Pay currency'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Pay currency'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKPAYC = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redemption Calls.
      *
     C                   IF        ADDSDET = 'RC'
      *
      ** Risk Management is not on.
     C
     C                   IF        RMFL <> 'Y'
      *
      ** Risk Analysis Cashflow Indicator.
     C                   IF        ADDRCIC <> DDRCIC
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDRCIC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Include in Risk +                      MD000091
     C**********                                     Anal. Cashflow'                        MD000091
     C                   EVAL      MsgDtaTmp = 'Include in Risk +                           MD000091
     C                                               Anal. Cashflow'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKRCIC = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If feature S01509 and S01510 are not installed, processing
      ** below are considered to check disabled fields which are
      ** amended on the front office.
      *
     C                   IF        S01509 <> 'Y'
      *
      ** Redemption currency.
     C                   IF        ADDRCCY <> DDRCCY
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDRCCY'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Redemption currency'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Redemption currency'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKRCCY = 'N'
     C                   ENDIF
      *
      ** Exchange rate.
     C                   IF        ADDXRAT <> DDXRAT
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDXRAT'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Exchange rate'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Exchange rate'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKXRAT = 'N'
     C                   ENDIF
      *
      ** Multiply / Divide indicator.
     C                   IF        ADDSDMD <> DDSDMD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSDMD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Mult/Div Indicator'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Mult/Div Indicator'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSDMD = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Dividend declared.
      *
     C                   IF        ADDSDET = 'DV' AND S01510 <> 'Y'
      *
      ** Extension date.
     C                   IF        ADDSDXD <> DDSDXD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSDXD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Extension date'                        MD000091
     C                   EVAL      MsgDtaTmp = 'Extension date'                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSDXD = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Interest rate changes.                                                               CAS006
                                                                                              CAS006
     C                   IF        ADDSDET = 'IR'                                             CAS006
     C                             AND CAS006 <> 'Y'                                          CAS006
                                                                                              CAS006
      ** Credit Risk Spread                                                                   CAS006
     C                   IF        ADDSCRS <> DDSCRS                                          CAS006
     C                   EVAL      IDx = IDx + 1                                              CAS006
     C                   EVAL      FldNameArr(IDx) = 'DDSCRS'                                 CAS006
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'                                 CAS006
     C**********         EVAL      MsgDtaArr(IDx) = 'Credit Risk Spread'             CAS006 MD000091
     C                   EVAL      MsgDtaTmp = 'Credit Risk Spread'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSCRS = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Liquidity Premium                                                                    CAS006
     C                   IF        ADDSLQP <> DDSLQP                                          CAS006
     C                   EVAL      IDx = IDx + 1                                              CAS006
     C                   EVAL      FldNameArr(IDx) = 'DDSLQP'                                 CAS006
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'                                 CAS006
     C**********         EVAL      MsgDtaArr(IDx) = 'Liquidity Premium'              CAS006 MD000091
     C                   EVAL      MsgDtaTmp = 'Liquidity Premium'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSLQP = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     ESrCompare    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFlds - Reset fields in error with their values on     *
      *                file.                                          *
      *                                                               *
      *****************************************************************
     C     SRResetFlds   BEGSR
      *
      ** If Action is Insert, only reset pay currency field in
      ** error.
      *
     C                   IF        ADDACTN = 'I'
 
     C                   IF        OKPAYC = 'N'
     C                   EVAL      ADDPAYC = PPayCcy
     C                   ENDIF
 
     C                   GOTO      ESrResetFlds
     C                   ENDIF
      *
      ** Pay currency.
      *
     C                   IF        OKPAYC = 'N'
     C                   EVAL      ADDPAYC = DDPAYC
     C                   ENDIF
      *
      ** Analysis cashflow.
      *
     C                   IF        OKRCIC = 'N'
     C                   EVAL      ADDRCIC = DDRCIC
     C                   ENDIF
      *
      ** Redemption currency.
      *
     C                   IF        OKRCCY = 'N'
     C                   EVAL      ADDRCCY = DDRCCY
     C                   ENDIF
      *
      ** Exchange rate.
      *
     C                   IF        OKXRAT = 'N'
     C                   EVAL      ADDXRAT = DDXRAT
     C                   ENDIF
      *
      ** Multiply/divide indicator.
      *
     C                   IF        OKSDMD = 'N'
     C                   EVAL      ADDSDMD = DDSDMD
     C                   ENDIF
      *
      ** Extension date.
      *
     C                   IF        OKSDXD = 'N'
     C                   EVAL      ADDSDXD = DDSDXD
     C                   ENDIF
                                                                                              CAS006
      ** Credit Risk Spread                                                                   CAS006
                                                                                              CAS006
     C                   IF        OKSCRS = 'N'                                               CAS006
     C                   EVAL      ADDSCRS = DDSCRS                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Liquidity Premium                                                                    CAS006
                                                                                              CAS006
     C                   IF        OKSLQP = 'N'                                               CAS006
     C                   EVAL      ADDSLQP = DDSLQP                                           CAS006
     C                   ENDIF                                                                CAS006
 
     C     ESrResetFlds  ENDSR
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
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM                    PResetFld
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** STANDING DATA
      ** =============
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
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
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
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
