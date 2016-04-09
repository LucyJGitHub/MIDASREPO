     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Calc. FX Spread for a spread set code')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000982  - FEES AND CHARGES: Calculate FX Spread for a      *
      *              single FX Spread Code.                           *
      *                                                               *
      *  Function:  This module shall calculate the foreign exchange  *
      *             spread that is to be applied to FT Transactions   *
      *             for a default customer FX Spread Code.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 246723             Date 16Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 02Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 29Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246723 - If no Spread Set for the currency, Spot Rate was    *
      *           used instead of the Sell Rate (spot rate + spread   *
      *           rate as defined within SDCURRPD).                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTXTRHPD                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * FT Exchange Rate Spread Parent.  Key = FX Spread Code
     FFTXTRHL0  IF   E           K DISK    INFSR(*PSSR)
 
      * FT Exchange Rate Spread Child.  Key = FX Spread Code + CCY
     FFTXTRDL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *  96 : General Lookup indicator                                *
      *  97 : General Chain Indicator                                 *
      *                                                               *
      *                                                               *
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
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      * External DS for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      *  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     **  Currency details from SDGELRPD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Entry parameters
     D P_SpreadCde     S                   Like(SPRDCD)
     D P_PayCcy        S                   Like(BJCYCD)
     D P_SettCcy       S                   Like(BJCYCD)
     D P_ExRate        S                   Like(A6SPRT)
     D P_STP           S              1A
 
      * Variables for Child Key List
     D K_SpreadCde     S                   Like(SPRDCD)
     D K_PayCcy        S                   Like(P_PayCcy)
 
      * Store base currency
     D BaseCcy         S                   Like(BJCYCD)
     D BaseIn          S                   Like(A6INCY)
 
      * Store euro currency code
     D Euro            S                   Like(BkEuro)
 
      * Settlement currency spot rate, 'IN' indicator and Mult / Div
     D SettIn          S                   Like(A6INCY)
     D SettSpot        S                   Like(A6SPRT)
     D SettMD          S                   Like(A6MDIN)
 
      * Pay currency spot rate, 'IN' indicator and Mult / Div
     D PayIn           S                   Like(A6INCY)
     D PaySpot         S                   Like(A6SPRT)
     D PayMD           S                   Like(A6MDIN)
 
      * Add Buy or sell spreads.  Used in cross currency calc only
     D AddBuy          S              1
     D AddSell         S                   Like(AddBuy)
 
      * Flags for pay / settle records read.
     D Got_Pay         S              1
     D Got_Sett        S              1
 
      * Work variables
     D PayBuySpread    S                   Like(MANBPC)
     D PayBuyPoints    S                   Like(MANBSP)
     D PayBuySign      S                   Like(MANBSN)
     D PaySellSpread   S                   Like(MANSPC)
     D PaySellPoints   S                   Like(MANSSP)
     D PaySellSign     S                   Like(MANSSN)
     D PaySprRate      S                   Like(MANSSP)                                       246723
     D PaySprSign      S                   Like(MANSSN)                                       246723
 
     D SettBuySpread   S                   Like(MANBPC)
     D SettBuyPoints   S                   Like(MANBSP)
     D SettBuySign     S                   Like(MANBSN)
     D SettSellSpread  S                   Like(MANSPC)
     D SettSellPoints  S                   Like(MANSSP)
     D SettSellSign    S                   Like(MANSSN)
     D SettSprRate     S                   Like(MANSSP)                                       246723
     D SettSprSign     S                   Like(MANSSN)                                       246723
 
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
 
      * Call initialisation routine (Not *Inzsr)
     C                   Exsr      @Init
 
      * Get header details for FX Spread Code
     C     P_SpreadCde   Chain     FTXTRHL0                           97
     C                   If        *In97
     C                   Eval      DbFile = 'FTXTRHPD'
     C                   Eval      DBase = 5
     C                   Eval      DBkey = P_SpreadCde
     C                   Exsr      *PSSR
     C                   Endif
 
      * Is the record valid for FX Spread Child.  If not, check parent code.
     C                   Eval      K_SpreadCde = P_SpreadCde
     C                   Eval      K_PayCcy    = P_PayCcy
     C     ChildKey      Chain     FTXTRDL0                           96
     C                   If        Not *In96                                    Exists
     C                   Eval      Got_Pay = 'Y'
     C                   Exsr      MovePay
     C                   Endif
 
     C                   Eval      K_PayCcy    = P_SettCcy
     C     ChildKey      Chain     FTXTRDL0                           96
     C                   If        Not *In96                                    Exists
     C                   Eval      Got_Sett = 'Y'
     C                   Exsr      MoveSett
     C                   Endif
 
     C                   If        Got_Pay = 'N'
     C                   Eval      K_PayCcy    = P_PayCcy
     C                   Eval      K_SpreadCde = PNTDCD                         Parent
     C     ChildKey      Chain     FTXTRDL0                           96
     C                   If        Not *In96
     C                   Eval      Got_Pay = 'Y'
     C                   Exsr      MovePay
     C                   Endif
     C                   Endif
 
     C                   If        Got_Sett = 'N'
     C                   Eval      K_PayCcy    = P_SettCcy
     C                   Eval      K_SpreadCde = PNTDCD                         Parent
     C     ChildKey      Chain     FTXTRDL0                           96
     C                   If        Not *In96
     C                   Eval      Got_Sett = 'Y'
     C                   Exsr      MoveSett
     C                   Endif
     C                   Endif
 
      *                                                                                       246723
      * If no Spread Set defined for the Settle Ccy, use Buy Spread Rate                      246723
      * from SDCURRPD as SettBuyPoints (and its associated sign).                             246723
      *                                                                                       246723
     C                   If        Got_Sett = 'N'                                             246723
     C                   Eval      SettBuyPoints = SettSprRate                                246723
     C                   Eval      SettBuySign   = SettSprSign                                246723
     C                   Endif                                                                246723
      *                                                                                       246723
      * If no Spread Set defined for the Pay Ccy, use Sell Spread Rate                        246723
      * from SDCURRPD as PayBuyPoints (and its associated sign).                              246723
      *                                                                                       246723
     C                   If        Got_Pay = 'N'                                              246723
     C                   Eval      PaySellPoints = PaySprRate                                 246723
     C                   Eval      PaySellSign   = PaySprSign                                 246723
     C                   Endif                                                                246723
      *                                                                                       246723
     C                   If        Got_Pay   = 'N' AND
     C                             Got_Sett  = 'N'
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
     C                   Endif
 
      *
      * Have got at least one record for either pay, settle or both.
      *
     C                   Eval      RetCodeIn = '*CALC'
 
     C                   Select
     C                   When      P_SettCcy = BaseCcy and
     C                             P_PayCcy <> BaseCcy
 
     C                   Exsr      SettBase
 
     C                   When      P_SettCcy <> BaseCcy and
     C                             P_PayCcy = BaseCcy
 
     C                   Exsr      PayBase
 
     C                   When      P_SettCcy <> BaseCcy and
     C                             P_PayCcy <> BaseCcy
 
     C                   Exsr      CrossRate
 
     C                   Endsl
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine MovPay.
      *  Move details of payment currency into work variables
      *****************************************************************
     C     MovePay       Begsr
 
     C                   Select
 
      * Manual rates
     C                   When      P_STP = 'M'
     C                   Eval      PayBuySpread  = MANBPC
     C                   Eval      PayBuyPoints  = MANBSP
     C                   Eval      PayBuySign    = MANBSN
     C                   Eval      PaySellSpread = MANSPC
     C                   Eval      PaySellPoints = MANSSP
     C                   Eval      PaySellSign   = MANSSN
 
      * STP Rates
     C                   When      P_STP = 'S'
 
      * If no STP rates, use manual
     C                   If        STPBPC = *Zeros  AND
     C                             STPBSP = *Zeros  AND
     C                             STPBSN = *Blank  AND
     C                             STPSPC = *Zeros  AND
     C                             STPSSP = *Zeros  AND
     C                             STPSSN = *Blank
 
     C                   Eval      PayBuySpread  = MANBPC
     C                   Eval      PayBuyPoints  = MANBSP
     C                   Eval      PayBuySign    = MANBSN
     C                   Eval      PaySellSpread = MANSPC
     C                   Eval      PaySellPoints = MANSSP
     C                   Eval      PaySellSign   = MANSSN
 
     C                   Else
 
     C                   Eval      PayBuySpread  = STPBPC
     C                   Eval      PayBuyPoints  = STPBSP
     C                   Eval      PayBuySign    = STPBSN
     C                   Eval      PaySellSpread = STPSPC
     C                   Eval      PaySellPoints = STPSSP
     C                   Eval      PaySellSign   = STPSSN
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine MovSett.
      *  Move details of settlement currency into work variables
      *****************************************************************
     C     MoveSett      Begsr
 
     C                   Select
 
      * Manual rates
     C                   When      P_STP = 'M'
     C                   Eval      SettBuySpread  = MANBPC
     C                   Eval      SettBuyPoints  = MANBSP
     C                   Eval      SettBuySign    = MANBSN
     C                   Eval      SettSellSpread = MANSPC
     C                   Eval      SettSellPoints = MANSSP
     C                   Eval      SettSellSign   = MANSSN
 
      * STP Rates
     C                   When      P_STP = 'S'
 
      * If no STP rates, use manual
     C                   If        STPBPC = *Zeros  AND
     C                             STPBSP = *Zeros  AND
     C                             STPBSN = *Blank  AND
     C                             STPSPC = *Zeros  AND
     C                             STPSSP = *Zeros  AND
     C                             STPSSN = *Blank
 
     C                   Eval      SettBuySpread  = MANBPC
     C                   Eval      SettBuyPoints  = MANBSP
     C                   Eval      SettBuySign    = MANBSN
     C                   Eval      SettSellSpread = MANSPC
     C                   Eval      SettSellPoints = MANSSP
     C                   Eval      SettSellSign   = MANSSN
 
     C                   Else
     C                   Eval      SettBuySpread  = STPBPC
     C                   Eval      SettBuyPoints  = STPBSP
     C                   Eval      SettBuySign    = STPBSN
     C                   Eval      SettSellSpread = STPSPC
     C                   Eval      SettSellPoints = STPSSP
     C                   Eval      SettSellSign   = STPSSN
 
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      /EJECT
      *****************************************************************
      * SettBase -                                                    *
      * If the settlement currency is base and the pay currency is    *
      *  not base then the pay currency sell spread will be added     *
      *  to the pay currency spot rate.  If the pay currency has not  *
      *  been defined within the exchange rate spread table, the      *
      *  current method of calculating the FX spread shall be used.   *
      *                                                               *
      *  Note that the percentage or points shall be added or         *
      *  subtracted from the rate according to the sell sign entered  *
      *  for the exchange rate spread code.                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SettBase      Begsr
 
     C                   If        BaseCcy  = Euro    or
     C                             BaseIn   = 'Y'
     C                   If        P_PayCcy = Euro    or
     C                             PayIn    = 'Y'
 
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
 
     C                   Endif
     C                   Else
 
      * Ensure that pay currency is defined
     C                   If        Got_Pay = 'N'       OR
     C                             PaySellSpread = 0   AND
     C                             PaySellPoints = 0
 
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
     C                   Endif
 
     C                   Select
     C                   When      PaySellSpread > 0                            Sell spread %
     C                   If        PaySellSign = '+'
     C                   Eval      P_ExRate = PaySpot +
     C                                        (Payspot * PaySellSpread)
     C                   Else
     C                   Eval      P_ExRate = PaySpot -
     C                                        (Payspot * PaySellSpread)
     C                   Endif
 
     C                   When      PaySellPoints > 0                            Sell points
     C                   If        PaySellSign = '+'
     C                   Eval      P_ExRate = PaySpot + PaySellPoints
     C                   Else
     C                   Eval      P_ExRate = PaySpot - PaySellPoints
     C                   Endif
 
     C                   Endsl
 
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      * PayBase -                                                     *
      *                                                               *
      * If the settlement currency is not base and the pay currency   *
      *  is base, then the settlement currency buy spread will be     *
      *  added to the settlement currency spot rate.  If the          *
      *  settlement currency does not exist within the exchange rate  *
      *  spread table, the current method of calculating FX spread    *
      *  shall be used.                                               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PayBase       Begsr
 
     C                   If        BaseCcy   = Euro    or
     C                             BaseIn    = 'Y'
     C                   If        P_SettCcy = Euro    or
     C                             SettIn    = 'Y'
 
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
 
     C                   Endif
 
     C                   Else
 
      * Ensure that settle currency is defined in child table
 
     C                   If        Got_Sett = 'N'     OR
     C                             SettBuySpread = 0  AND
     C                             SettBuyPoints = 0
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
     C                   Endif
 
     C                   Select
     C                   When      SettBuySpread > 0                            Buy spread %
     C                   If        SettBuySign = '+'
     C                   Eval      P_ExRate = SettSpot +
     C                                        (SettSpot * SettBuySpread)
     C                   Else
     C                   Eval      P_ExRate = SettSpot -
     C                                        (SettSpot * SettBuySpread)
     C                   Endif
 
     C                   When      SettBuyPoints > 0                            Buy points
     C                   If        SettBuySign = '+'
     C                   Eval      P_ExRate = SettSpot + SettBuyPoints
     C                   Else
     C                   Eval      P_ExRate = SettSpot - SettBuyPoints
     C                   Endif
 
     C                   Endsl
 
     C                   Endif
 
     C                   Endsr
      /EJECT
 
      *****************************************************************
      * CrossRate -                                                   *
      *                                                               *
      * If neither currency is base then a cross rate will be derived.*
      *  If the 'foreign currency spread indicator' is 'B ' then the  *
      *  cross rate will be calculated from the settlement currency   *
      *  spot rate plus the buy spread and the pay currency spot rate.*
      *  If the settlement currency is not defined within the exchange*
      *  rate spread table, the current method of calculating the FX  *
      *  spread shall be used.                                        *
      *                                                               *
      * If the 'foreign currency spread indicator' is 'S ' then the   *
      *  cross rate will be calculated from the settlement currency   *
      *  spot rate and the pay currency spot rate plus the sell       *
      *  spread.  If the pay currency is not defined within the       *
      *  exchange rate spread table, the current method of calculating*
      *  the FX spread shall be used.                                 *
      *                                                               *
      * If the 'foreign currency spread indicator' is 'BS' then the   *
      *  cross rate will be calculated from the settlement currency   *
      *  spot rate plus the buy spread and the pay currency spot rate *
      *  plus the sell spread.  If both the pay currency are not      *
      *  defined within the exchange rate spread table or the         *
      *  settlement currency is not defined within the exchange       *
      *  rate spread table, the current spot rate shall be used.      *
      *                                                               *
      *                                                               *
      * If the base currency is an 'IN' currency or Euro and the pay  *
      *  currency is Euro or an 'IN' currency then no sell spread will*
      *  be applied.                                                  *
      *                                                               *
      * If the base currency is an 'IN' currency or Euro and the      *
      *  settlement currency is Euro or an 'IN' currency then no buy  *
      *  spread will be applied.                                      *
      *                                                               *
      * If the base currency is an 'IN' currency or Euro and the pay  *
      *  currency is Euro or an 'IN' currency then no sell spread     *
      *  will be applied. If the base currency is an 'IN' currency or *
      *  Euro and the settlement currency is Euro or an 'IN' currency *
      *  then no buy spread will be applied. If both the pay and      *
      *  settlement currencies are either 'IN' currencies or Euro,    *
      *  then the Euro rates will be used for the conversion.         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     CrossRate     Begsr
 
      * If both pay and settle currencies are IN currencies, return
      *  with no calculation.
     C                   If        P_PayCcy  = Euro    AND
     C                             P_SettCcy = Euro    OR
     C                             P_PayCcy  = Euro    AND
     C                             SettIn    = 'Y'     OR
     C                             P_SettCcy = Euro    AND
     C                             PayIn     = 'Y'     OR
     C                             PayIn     = 'Y'     AND
     C                             SettIn    = 'Y'
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
     C                   Endif
 
     C                   Select
     C                   When      FXCCYI = 'B '
 
      * Ensure that settlement currency defined in child table
     C                   If        Got_Sett = 'N'
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
     C                   Endif
 
      * Calculate the cross rate as settlement currency spot rate plus the buy
      *  spread and the pay currency spot rate.
 
     C                   Select
 
     C                   When      SettBuySpread > 0
 
     C                   If        SettBuySign = '+'
     C                   Eval      SettSpot = SettSpot +
     C                                        (SettSpot * SettBuySpread)
     C                   Else
     C                   Eval      SettSpot = SettSpot -
     C                                        (SettSpot * SettBuySpread)
     C                   Endif
 
     C                   If        SettMD = PayMD
     C     SettSpot      Div (H)   PaySpot       P_ExRate
     C                   Else
     C     SettSpot      Mult (H)  PaySpot       P_Exrate
     C                   Endif
 
     C                   When      SettBuyPoints > 0
 
     C                   If        SettBuySign = '+'
     C                   Eval      SettSpot = SettSpot + SettBuyPoints
     C                   Else
     C                   Eval      SettSpot = SettSpot - SettBuyPoints
     C                   Endif
 
     C                   If        SettMD = PayMD
     C     SettSpot      Div (H)   PaySpot       P_ExRate
     C                   Else
     C     SettSpot      Mult (H)  PaySpot       P_Exrate
     C                   Endif
 
     C                   Endsl
 
      * ===============================================================================
      * Calculate the cross rate as Settle Spot + Pay Spot + Sell Spread
     C                   When      FXCCYI = 'S '
      * Ensure that pay currency defined in child table (already done but just make sure)
     C                   If        Got_Pay = 'N'
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
     C                   Endif
 
      * The cross rate will be calculated from the settlement currency spot
      *  and the pay currency spot rate plus the sell spread.
     C                   Select
 
     C                   When      PaySellSpread > 0
 
     C                   If        PaySellSign = '+'
     C                   Eval      PaySpot = PaySpot + (PaySpot * PaySellSpread)
     C                   Else
     C                   Eval      PaySpot = PaySpot - (PaySpot * PaySellSpread)
     C                   Endif
 
     C                   If        SettMD = PayMD
     C     SettSpot      Div (H)   PaySpot       P_Exrate
     C                   Else
     C     SettSpot      Mult (H)  PaySpot       P_ExRate
     C                   Endif
 
     C                   When      PaySellPoints > 0
 
     C                   If        PaySellSign = '+'
     C                   Eval      PaySpot = PaySpot + PaySellPoints
     C                   Else
     C                   Eval      PaySpot = PaySpot - PaySellPoints
     C                   Endif
 
     C                   If        SettMD = PayMD
     C     SettSpot      Div (H)   PaySpot       P_exrate
     C                   Else
     C     SettSpot      Mult (H)  PaySpot       P_ExRate
     C                   Endif
 
     C                   Endsl
 
      * ======================================================================
     C                   When      FXCCYI = 'BS'
      * Ensure that both pay and settle currencies are defined in child table
     C                   If        Got_Pay   = 'N'  AND
     C                             Got_Sett  = 'N'
     C                   Eval      RetCodeIn = '*NOCALC'
     C                   Return
     C                   Endif
 
      * The cross rate will be calculated from the settlement currency spot rate
      *  plus the buy spread and the pay currency spot rate plus the sell spread.
 
      * Pay currency
 
     C                   Eval      AddSell = 'Y'
 
     C                   If        BaseCcy  = Euro   or
     C                             BaseIn   = 'Y'
     C                   If        P_PayCcy = Euro  or
     C                             PayIn    = 'Y'
     C                   Eval      AddSell = 'N'
     C                   Endif
     C                   Endif
 
      * Settlement currency
 
     C                   Eval      AddBuy = 'Y'
 
     C                   If        BaseCcy   = Euro   or
     C                             BaseIn    = 'Y'
     C                   If        P_SettCcy = Euro  or
     C                             SettIn    = 'Y'
     C                   Eval      AddBuy = 'N'
     C                   Endif
     C                   Endif
 
     C                   Select
 
     C                   When      SettBuySpread > 0
 
     C                   If        SettBuySign = '+' and AddBuy = 'Y'
     C                   Eval      SettSpot = SettSpot +
     C                                        (SettSpot * SettBuySpread)
     C                   Endif
 
     C                   If        SettBuySign = '-' and AddBuy = 'Y'
     C                   Eval      SettSpot = SettSpot -
     C                                        (SettSpot * SettBuySpread)
     C                   Endif
 
     C                   When      SettBuyPoints > 0
 
     C                   If        SettBuySign = '+' and AddBuy = 'Y'
     C                   Eval      SettSpot = SettSpot + SettBuyPoints
     C                   Endif
 
     C                   If        SettBuySign = '-' and AddBuy = 'Y'
     C                   Eval      SettSpot = SettSpot - SettBuyPoints
     C                   Endif
 
     C                   Endsl
 
     C                   Select
 
     C                   When      PaySellSpread > 0
 
     C                   If        PaySellSign = '+' and AddSell = 'Y'
     C                   Eval      PaySpot = PaySpot + (PaySpot * PaySellSpread)
     C                   Endif
 
     C                   If        PaySellSign = '-' and AddSell = 'Y'
     C                   Eval      PaySpot = PaySpot - (PaySpot * PaySellSpread)
     C                   Endif
 
     C                   When      PaySellPoints > 0
 
     C                   If        PaySellSign = '+' and AddSell = 'Y'
     C                   Eval      PaySpot = PaySpot + PaySellPoints
     C                   Endif
 
     C                   If        PaySellSign = '-' and AddSell = 'Y'
     C                   Eval      PaySpot = PaySpot - PaySellPoints
     C                   Endif
 
     C                   Endsl
 
     C                   If        SettMD = PayMD
     C     SettSpot      Div (H)   PaySpot       P_exrate
     C                   Else
     C     SettSpot      Mult (H)  PaySpot       P_ExRate
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      *****************************************************************
      * @Init  - INITIAL PROCESSING not in *Inzsr                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     @Init         BEGSR
 
      *
      * Ensure that pay and settlement currencies are different, else
      *  return 1.00000
     C                   If        P_PayCcy = P_SettCcy
     C                   Eval      P_ExRate = 1
     C                   Return
     C                   Endif
      *
      * Reset all variables
      *
     C                   Eval      PayBuySpread   = 0
     C                   Eval      PayBuyPoints   = 0
     C                   Eval      PayBuySign     = *Blank
     C                   Eval      PaySellSpread  = 0
     C                   Eval      PaySellPoints  = 0
     C                   Eval      PaySellSign    = *Blank
      *
     C                   Eval      SettBuySpread  = 0
     C                   Eval      SettBuyPoints  = 0
     C                   Eval      SettBuySign    = *Blank
     C                   Eval      SettSellSpread = 0
     C                   Eval      SettSellPoints = 0
     C                   Eval      SettSellSign   = *Blank
      *
      * Get details for Pay Currency
      *
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    P_PayCcy
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      * Database error
     C                   If        @Rtcd  <> *Blanks
     C                   Eval      DbFile = 'SDCURRPD'
     C                   Eval      DBase  = 6
     C                   Eval      DBkey  = P_PayCcy
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Eval      PaySpot = A6SPRT
     C                   Eval      PayIn   = A6INCY
     C                   Eval      PayMD   = A6MDIN
      *                                                                                       246723
      * Store Sell Spread Rate to a work variable                                             246723
      *                                                                                       246723
     C                   Eval      PaySprRate = A6SLSR                                        246723
     C                   Eval      PaySprSign = A6SLSS                                        246723
 
      *
      * Get details for Settlement Currency
      *
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    P_SettCcy
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      * Database error
     C                   If        @Rtcd  <> *Blanks
     C                   Eval      DbFile = 'SDCURRPD'
     C                   Eval      DBase  = 7
     C                   Eval      DBkey  = P_PayCcy
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Eval      SettSpot = A6SPRT
     C                   Eval      SettIn   = A6INCY
     C                   Eval      SettMD   = A6MDIN
      *                                                                                       246723
      * Store Buy Spread Rate to a work variable                                              246723
      *                                                                                       246723
     C                   Eval      SettSprRate = A6BYSR                                       246723
     C                   Eval      SettSprSign = A6BYSS                                       246723
 
      *
      * Reset flags for records found
      *
     C                   Eval      Got_Pay  = 'N'
     C                   Eval      Got_Sett = 'N'
 
     C                   Endsr
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Entry parameters:
     C     *Entry        Plist
      *
      ** Return Code (10A)
     C                   Parm                    RetCodeIn
      ** FX Spread Code (5A)
     C                   Parm                    P_SpreadCde
      ** Payment Currency (3A)
     C                   Parm                    P_PayCcy
      ** Settlement Currency (3A)
     C                   PARM                    P_SettCcy
      ** Calculated Exchange Rate (Returned)
     C                   Parm                    P_ExRate
      ** Manual or STP 1A
     C                   Parm                    P_STP
 
      * Define FX Spread Child Key List
     C     ChildKey      Klist
     C                   Kfld                    K_SpreadCde
     C                   Kfld                    K_PayCcy
 
      * Initialise program name
     C                   Eval      DBPGM = PsProcPgm
 
      *
      * Access Bank details
      *
     C                   CallB     'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSSDY
      *
      * Database error
     C                   If        @Rtcd <> *Blanks
     C                   Eval      DbFile = 'SDBANKPD'
     C                   Eval      DBase = 1
     C                   Eval      DBkey = @Optn
     C                   Exsr      *PSSR
     C                   Endif
 
      *
      * Get details for Base Currency
      *
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    BJCYCD
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      * Database error
     C                   If        @Rtcd <> *Blanks
     C                   Eval      DbFile = 'SDCURRPD'
     C                   Eval      DBase = 2
     C                   Eval      DBkey = BJCYCD
     C                   Exsr      *PSSR
     C                   Endif
      *
      * Save Base Currency and 'In' indicator
     C                   Eval      BaseCcy = BJCYCD
     C                   Eval      BaseIn = A6INCY
 
      *
      * Get Funds Transfer ICD
      *
     C                   CallB     'AOFTFRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDFTFR        Parm      SDFTFR        DSSDY
      *
      * Database error
     C                   If        @RTCD <> *Blanks
     C                   Eval      DbFile = 'SDFTFRPD'
     C                   Eval      DBase = 3
     C                   Exsr      *PSSR
     C                   Endif
 
      *
      * Get GL Details for EURO currency code
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDGELR        Parm      SDGELR        DSSDY
      * Database error
     C                   If        @RTCD <> *Blanks
     C                   Eval      DbFile = 'SDGELRPD'
     C                   Eval      DBase = 4
     C                   Exsr      *PSSR
     C                   Endif
      *
      * Save Euro Currency code
      *
     C                   Eval      Euro = BkEuro
 
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
