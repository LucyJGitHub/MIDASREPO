     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Risk Weighted Assets - Calculation method 1')
      *****************************************************************
      *                                                               *
      *  Midas - Risk Weighted Assets                                 *
      *                                                               *
      *  ZA001240 - Risk Weighted Assets - Calculation method 1       *
      *                                                               *
      *  Function:  This module calculates the Risk Weighted balance  *
      *             for GL, DL & LE using calculation method 1.       *
      *                                                               *
      *  Component of:                                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL018  *CREATE    Date 17Sep02               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  This program receives: Asset Balance                         *
      *                         Customer Weighting                    *
      *                         Account Weighting                     *
      *                         Collateral Weighting 1-15             *
      *                         Collateral Balance 1-15               *
      *  This program returns:  Risk Weighted Balance                 *
      *                         Customer Interim RWA Balance          *
      *                         Account Interim RWA Balance           *
      *                         Collateral Interim RWA Balance 1-15   *
      *                                                               *
      *  The customer, account & collateral weighting percentages are *
      *  sorted and processed in ascending order until there are no   *
      *  more weightings or the remaining asset balance is zero.      *
      *                                                               *
      *  A customer or account weighting is applied to the whole      *
      *  of the remaining asset balance amount.                       *
      *  A collateral weighting is applied to the portion of the      *
      *  asset balance covered by the collateral amount. This amount  *
      *  is then subtracted from the asset balance to give the        *
      *  remaining asset balance.                                     *
      *                                                               *
      *  The risk weighted sub-balance is calculated as               *
      *       (remaining asset balance/100) * weighting percentage    *
      *  The Risk Weighted Balance is the total of the sub-balances.  *
      *                                                               *
      *  The customer/account/collateral interim RWA balance is the   *
      *  amount to which the associated weighting percentage was      *
      *  applied.                                                     *
      *  NB. The collateral interim RWA balances 1-15 are returned in *
      *  the same order as the weighting & balances were sent.        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         LOOKUP indicator                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * ArraySR   - Set up work weighting arrays                      *
      * CalcSR    - Calculate risk weighted balance                   *
      * CalcRemSR - Calculate remaining weightings                    *
      * LoadSR    - Load arrays with input parameter values           *
      * OutputSR  - Set up parameters for output                      *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WtArr1          S              5A   Dim(17)
     D WtArr2          S              5P 2 Dim(17)
     D WtArr3          S              5P 2 Dim(17)
     D BalArr          S             15P 0 Dim(17)
     D CalcArr         S             15P 0 Dim(17)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D AssetBal        S             15P 0
     D CustWt          S              5A
     D AccWt           S                   Like(CustWt)
     D CollWt1         S              5A
     D CollWt2         S                   Like(CollWt1)
     D CollWt3         S                   Like(CollWt1)
     D CollWt4         S                   Like(CollWt1)
     D CollWt5         S                   Like(CollWt1)
     D CollWt6         S                   Like(CollWt1)
     D CollWt7         S                   Like(CollWt1)
     D CollWt8         S                   Like(CollWt1)
     D CollWt9         S                   Like(CollWt1)
     D CollWt10        S                   Like(CollWt1)
     D CollWt11        S                   Like(CollWt1)
     D CollWt12        S                   Like(CollWt1)
     D CollWt13        S                   Like(CollWt1)
     D CollWt14        S                   Like(CollWt1)
     D CollWt15        S                   Like(CollWt1)
     D CollBal1        S                   Like(AssetBal)
     D CollBal2        S                   Like(AssetBal)
     D CollBal3        S                   Like(AssetBal)
     D CollBal4        S                   Like(AssetBal)
     D CollBal5        S                   Like(AssetBal)
     D CollBal6        S                   Like(AssetBal)
     D CollBal7        S                   Like(AssetBal)
     D CollBal8        S                   Like(AssetBal)
     D CollBal9        S                   Like(AssetBal)
     D CollBal10       S                   Like(AssetBal)
     D CollBal11       S                   Like(AssetBal)
     D CollBal12       S                   Like(AssetBal)
     D CollBal13       S                   Like(AssetBal)
     D CollBal14       S                   Like(AssetBal)
     D CollBal15       S                   Like(AssetBal)
     D RiskWtBal       S                   Like(AssetBal)
     D CustRWA         S                   Like(AssetBal)
     D AccRWA          S                   Like(AssetBal)
     D CollRWA1        S                   Like(AssetBal)
     D CollRWA2        S                   Like(AssetBal)
     D CollRWA3        S                   Like(AssetBal)
     D CollRWA4        S                   Like(AssetBal)
     D CollRWA5        S                   Like(AssetBal)
     D CollRWA6        S                   Like(AssetBal)
     D CollRWA7        S                   Like(AssetBal)
     D CollRWA8        S                   Like(AssetBal)
     D CollRWA9        S                   Like(AssetBal)
     D CollRWA10       S                   Like(AssetBal)
     D CollRWA11       S                   Like(AssetBal)
     D CollRWA12       S                   Like(AssetBal)
     D CollRWA13       S                   Like(AssetBal)
     D CollRWA14       S                   Like(AssetBal)
     D CollRWA15       S                   Like(AssetBal)
 
     D Ix1             S              2  0
     D Ix2             S                   Like(Ix1) Inz
     D Ix3             S                   Like(Ix1) Inz
     D RiskWtSub       S             19  4 Inz
     D RiskWtTot       S                   Like(RiskWtSub) Inz
     D RemBal          S                   Like(AssetBal) Inz
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      * Load weighting & balance arrays with input parameter values
 
     C                   EXSR      LoadSR
      *
      * Set up work weighting arrays.
      * WtArr2 will be the sorted array. WtArr3 will be in original order.
     C                   EXSR      ArraySR
      *
      * Calculate risk weighted balances
     C                   EXSR      CalcSR
      *
      * Output weightings and calculated balances to parameters
     C                   EXSR      OutputSR
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ArraySR - Set up work weighting arrays                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ArraySR       BEGSR
      *
      * Initialise work arrays
     C                   MOVEA     *HIVAL        WtArr2
     C                   MOVEA     *HIVAL        WtArr3
     C                   MOVEA     *zeros        CalcArr
     C                   EVAL      Ix1 = 1
      *
      * Set up work weighting arrays.
      * WtArr2 will be the sorted array. WtArr3 will be in original order.
      * A blank weighting implies there is none for that category. Once a
      * blank collateral weighting is found there will be no further
      * collateral weightings.
     C                   DOU       Ix1 = 18
     C                               or Ix1 > 2 and WtArr1(Ix1) = *blanks
     C                   IF        WtArr1(Ix1) <> *blanks
     C                   MOVEL     WtArr1(Ix1)   WtArr2(Ix1)
     C                   EVAL      WtArr3(Ix1) = WtArr2(Ix1)
     C                   ENDIF
     C                   EVAL      Ix1 = Ix1 + 1
     C                   ENDDO
 
     C                   EVAL      Ix2 = Ix1
     C                   SORTA     WtArr2
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcSR - Calculate risk weighted balances                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: CalcRemSR                                              *
      *                                                               *
      *****************************************************************
 
     C     CalcSR        BEGSR
 
     C                   EVAL      RiskWtBal = 0
     C                   EVAL      RiskWtSub = 0
     C                   EVAL      RiskWtTot = 0
     C                   EVAL      RemBal = 0
      *
      * Bypass if no weightings were sent
     C                   IF        WtArr2(1) <> *hival
      *
      * If lowest weighting is the customer or the account weighting, it
      * applies to the full asset balance.
     C                   IF        WtArr2(1) = WtArr3(1)
     C                               or WtArr2(1) = WtArr3(2)
     C                   EVAL (H)  RiskWtBal = (AssetBal / 100) * WtArr2(1)
     C                   IF        WtArr2(1) = WtArr3(1)
     C                   Eval      CalcArr(1) = AssetBal
     C                   Else
     C                   Eval      CalcArr(2) = AssetBal
     C                   ENDIF
     C                   ELSE
      *
      * If lowest weighting is a collateral weighting get collateral amount
     C                   EVAL      Ix1 = 1
     C     WtArr2(1)     LOOKUP    WtArr3(Ix1)                            50
      *
      * Set WtArr3 element to *hival once selected, in case there is more
      * than 1 with the same value.
     C                   EVAL      WtArr3(Ix1) = *hival
      *
      * If collateral amount is *GE asset balance, apply weighting to full
      * asset balance.
     C                   IF        BalArr(Ix1) >= AssetBal
     C                   EVAL (H)  RiskWtBal = (AssetBal / 100) * WtArr2(1)
     C                   EVAL      CalcArr(Ix1) = AssetBal
     C                   ELSE
      *
      * Otherwise apply weighting to portion of asset balance covered by
      * collateral amount, and continue with remaining weightings.
     C                   EVAL (H)  RiskWtSub = (BalArr(Ix1) / 100)
     C                               * WtArr2(1)
     C                   EVAL      RiskWtTot = RiskWtSub
     C                   EVAL      RemBal = AssetBal - BalArr(Ix1)
     C                   EVAL      CalcArr(Ix1) = BalArr(Ix1)
     C                   EXSR      CalcRemSR
      *
      * Set Risk Weighted Balance to the total weighted sub-balances
     C                   EVAL (H)  RiskWtBal = RiskWtTot
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcRemSR - Calculate remaining weightings                    *
      *                                                               *
      * Called by: CalcSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CalcRemSR     BEGSR
 
     C                   EVAL      Ix1 = 1
      *
      * Continue until all valid weightings processed or remaining bal is 0
     C                   DOU       Ix1 = Ix2 or RemBal = 0
 
     C                   EVAL      Ix1 = Ix1 + 1
 
     C                   IF        Ix1 < Ix2 and WtArr2(Ix1) <> *hival
     C                   EVAL      Ix3 = 1
     C     WtArr2(Ix1)   LOOKUP    WtArr3(Ix3)                            50
      *
      * Set WtArr3 element to *hival once selected, in case there is more
      * than 1 with the same value.
     C                   EVAL      WtArr3(Ix3) = *hival
      *
      * If weighting is the customer or account weighting, or if collateral
      * and amount *GE remaining balance, apply to full remaining bal.
     C                   IF        Ix3 = 1 or Ix3 = 2
     C                               or BalArr(Ix3) >= RemBal
     C                   EVAL (H)  RiskWtSub = (RemBal / 100) * WtArr2(Ix1)
     C                   EVAL      RiskWtTot = RiskWtTot + RiskWtSub
     C                   EVAL      CalcArr(Ix3) = RemBal
     C                   EVAL      RemBal = 0
     C                   ELSE
      *
      * Otherwise apply weighting to portion of asset balance covered by
      * collateral amount
     C                   EVAL (H)  RiskWtSub = (BalArr(Ix3) / 100)
     C                               * WtArr2(Ix1)
     C                   EVAL      RiskWtTot = RiskWtTot + RiskWtSub
     C                   EVAL      CalcArr(Ix3) = BalArr(Ix3)
     C                   EVAL      RemBal = RemBal - BalArr(Ix3)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LoadSR - Load arrays with input parameter values              *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     LoadSR        BEGSR
 
     C                   EVAL      WtArr1(1) = CustWt
     C                   EVAL      WtArr1(2) = AccWt
     C                   EVAL      WtArr1(3) = CollWt1
     C                   EVAL      WtArr1(4) = CollWt2
     C                   EVAL      WtArr1(5) = CollWt3
     C                   EVAL      WtArr1(6) = CollWt4
     C                   EVAL      WtArr1(7) = CollWt5
     C                   EVAL      WtArr1(8) = CollWt6
     C                   EVAL      WtArr1(9) = CollWt7
     C                   EVAL      WtArr1(10) = CollWt8
     C                   EVAL      WtArr1(11) = CollWt9
     C                   EVAL      WtArr1(12) = CollWt10
     C                   EVAL      WtArr1(13) = CollWt11
     C                   EVAL      WtArr1(14) = CollWt12
     C                   EVAL      WtArr1(15) = CollWt13
     C                   EVAL      WtArr1(16) = CollWt14
     C                   EVAL      WtArr1(17) = CollWt15
      *
     C                   EVAL      BalArr(1) = AssetBal
     C                   EVAL      BalArr(2) = AssetBal
     C                   EVAL      BalArr(3) = CollBal1
     C                   EVAL      BalArr(4) = CollBal2
     C                   EVAL      BalArr(5) = CollBal3
     C                   EVAL      BalArr(6) = CollBal4
     C                   EVAL      BalArr(7) = CollBal5
     C                   EVAL      BalArr(8) = CollBal6
     C                   EVAL      BalArr(9) = CollBal7
     C                   EVAL      BalArr(10) = CollBal8
     C                   EVAL      BalArr(11) = CollBal9
     C                   EVAL      BalArr(12) = CollBal10
     C                   EVAL      BalArr(13) = CollBal11
     C                   EVAL      BalArr(14) = CollBal12
     C                   EVAL      BalArr(15) = CollBal13
     C                   EVAL      BalArr(16) = CollBal14
     C                   EVAL      BalArr(17) = CollBal15
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OutputSR - Set up parameter values for output                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     OutputSR      BEGSR
      *
      * Return the calculated interim risk weighted balances
     C                   EVAL      CustRWA = CalcArr(1)
     C                   EVAL      AccRWA = CalcArr(2)
     C                   EVAL      CollRWA1 = CalcArr(3)
     C                   EVAL      CollRWA2 = CalcArr(4)
     C                   EVAL      CollRWA3 = CalcArr(5)
     C                   EVAL      CollRWA4 = CalcArr(6)
     C                   EVAL      CollRWA5 = CalcArr(7)
     C                   EVAL      CollRWA6 = CalcArr(8)
     C                   EVAL      CollRWA7 = CalcArr(9)
     C                   EVAL      CollRWA8 = CalcArr(10)
     C                   EVAL      CollRWA9 = CalcArr(11)
     C                   EVAL      CollRWA10 = CalcArr(12)
     C                   EVAL      CollRWA11 = CalcArr(13)
     C                   EVAL      CollRWA12 = CalcArr(14)
     C                   EVAL      CollRWA13 = CalcArr(15)
     C                   EVAL      CollRWA14 = CalcArr(16)
     C                   EVAL      CollRWA15 = CalcArr(17)
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    AssetBal
     C                   PARM                    CustWt
     C                   PARM                    AccWt
     C                   PARM                    CollWt1
     C                   PARM                    CollWt2
     C                   PARM                    CollWt3
     C                   PARM                    CollWt4
     C                   PARM                    CollWt5
     C                   PARM                    CollWt6
     C                   PARM                    CollWt7
     C                   PARM                    CollWt8
     C                   PARM                    CollWt9
     C                   PARM                    CollWt10
     C                   PARM                    CollWt11
     C                   PARM                    CollWt12
     C                   PARM                    CollWt13
     C                   PARM                    CollWt14
     C                   PARM                    CollWt15
     C                   PARM                    CollBal1
     C                   PARM                    CollBal2
     C                   PARM                    CollBal3
     C                   PARM                    CollBal4
     C                   PARM                    CollBal5
     C                   PARM                    CollBal6
     C                   PARM                    CollBal7
     C                   PARM                    CollBal8
     C                   PARM                    CollBal9
     C                   PARM                    CollBal10
     C                   PARM                    CollBal11
     C                   PARM                    CollBal12
     C                   PARM                    CollBal13
     C                   PARM                    CollBal14
     C                   PARM                    CollBal15
     C                   PARM                    RiskWtBal
     C                   PARM                    CustRWA
     C                   PARM                    AccRWA
     C                   PARM                    CollRWA1
     C                   PARM                    CollRWA2
     C                   PARM                    CollRWA3
     C                   PARM                    CollRWA4
     C                   PARM                    CollRWA5
     C                   PARM                    CollRWA6
     C                   PARM                    CollRWA7
     C                   PARM                    CollRWA8
     C                   PARM                    CollRWA9
     C                   PARM                    CollRWA10
     C                   PARM                    CollRWA11
     C                   PARM                    CollRWA12
     C                   PARM                    CollRWA13
     C                   PARM                    CollRWA14
     C                   PARM                    CollRWA15
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
