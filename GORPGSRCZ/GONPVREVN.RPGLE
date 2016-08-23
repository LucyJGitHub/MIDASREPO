     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Revaluation using Net Present Value')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GONPVREVN - Revaluation Using Net Present Value Method       *
      *                                                               *
      *  Function:  This module performs revaluation using NPV method *
      *             for FX deals for profit/loss due to currency rate *
      *             fluctuations.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE025   *CREATE   Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      **------------------------------------------------------------------------
 
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
      ** Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program parameters, keys and work variables
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D PIRevAmt        S             13  0
     D PIRate          S             13  8
     D PIPLAmt         S             13  0
     D PFRevAmt        S             13  0
     D PFRate          S             13  8
     D PFPLAmt         S             13  0
     D PBuySel         S              1
     D PYldBuy         S              5
     D PYldSel         S              5
     D WRate1          S             13  6
     D WRate2          S             13  7
     D WkRate          S             13  8
     D WkRevA          S             30  9
     D WkBasA          S             30  9
     D Wk309           S             30  9
     D Wk159           S             15  9
     D PORtCd          S              7
     D POptn           S              7
     D POErMs          S             50
     D I#ErMs          S             50
     D PNPRtC          S              5
     D PNPYld          S              5
     D PNPCcy          S              3
     D PNPInC          S              1
     D PNPFDt          S              5  0
     D PNPDF           S             13  9
     D WDsFc           S             13  9
     D WBaseDF         S             13  9
     D PIECcy          S              3
     D PIEDat          S              5  0
     D PIEAmt          S             13  0
     D I#RtCd          S              7
     D BJRDNB          S              5  0
     D BJCYCD          S              3
     D BCCDP           S              1  0
     D BCICB           S              1
     D PDBCE           S             13  0
     D K               S              1  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
0653 C                   IF        PIECcy = BJCYCD
 
      ** If currency is equal to the base currency, there is NO revaluation
      ** necessary, set output fields then RETURN to caller
     C                   Z-ADD     PIEAmt        PIRevAmt
     C                   Z-ADD     A6SPRT        PIRate
     C                   Z-ADD     *ZERO         PIPLAmt
 
      ** Else, perform revaluation
     C                   ELSE
 
0653  ** Select which NPV method is to be used
     C                   SELECT
 
     C                   WHEN      BNNPVM = 'N' OR BNNPVM = ' '
     C                   EXSR      SRRevMethN
 
     C                   WHEN      BNNPVM = 'F'
     C                   EXSR      SRRevMethF
 
     C                   WHEN      BNNPVM = 'B'
     C                   EXSR      SRRevMethB
 
     C                   WHEN      BNNPVM = 'D'
     C                   EXSR      SRRevMethD
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevMethN - Revaluation Calculation NPV Method "N"           *
      *                                                               *
      * Revaluation in this method is done by converting the amount   *
      * into base currency at forward FX rates. The system will then  *
      * compare this figure with the original dealt base currency     *
      * value to give a profit or loss figure. This actually implies  *
      * no NPV revaluation.                                           *
      *                                                               *
      *****************************************************************
     C     SRRevMethN    BEGSR
 
      ** Execute subroutine that converts the amount into base currency at
      ** forward FX rates
     C                   EXSR      SRCnvFwdR
 
     C                   EVAL      PIRevAmt = PFRevAmt
     C                   EVAL      PIRate = PFRate
     C                   EVAL      PIPLAmt = PFPLAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevMethF - Revaluation Calculation NPV Method "F"           *
      *                                                               *
      * Revaluation in this method is done by discounting the amount  *
      * using the yield curve specified for the currency on the deal  *
      * to spot date, then converting this amount to base currency    *
      * at current spot rates. The system will then compare this      *
      * figure with the original dealt base currency value to give    *
      * a profit or loss figure.                                      *
      *                                                               *
      *****************************************************************
     C     SRRevMethF    BEGSR
      *
      ** Determine difference of currency decimal place between event
      ** currency and base currency
      *
     C                   EVAL      K = (A6NBDP - BCCDP) + 4
 
      ** Convert Amount in base currency
 
     C                   Z-ADD     A6SPRT        WkRate
     C                   Z-ADD     0             WkReva
     C                   EXSR      SRConvert
 
      ** Store converted amount into base amount variable
     C                   Z-ADD     WkRevA        WkBasA
 
      ** Retrieve yield curve from master file and set up parameter
      ** for ZADSFCAL; Set first Discount factor to 1
     C                   Z-ADD     1             WDsFc
 
     C                   IF        PBuySel = 'B'
     C                   EVAL      PNPYld = PYldBuy
     C                   ELSE
     C                   EVAL      PNPYld = PYldSel
     C                   ENDIF
 
     C                   IF        PNPYld <> *BLANKS
     C                   EVAL      PNPCcy = PIECcy
     C                   EVAL      PNPInC = A6DICB
     C                   EVAL      PNPFDt = PIEDat
     C                   EXSR      SRGetDsFc
     C                   Z-ADD     PNPDF         WDsFc
     C                   ENDIF
 
     C                   Z-ADD     A6SPRT        PIRate
 
      ** Multiply the discount factor with the amount in base currency
     C     WkBasA        MULT(H)   WDsFc         PIRevAmt
 
     C                   EXSR      SRCalcPL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevMethB - Revaluation Calculation NPV Method "B"           *
      *                                                               *
      * Revaluation in this method is done by converting the amount   *
      * into base currency at forward FX rates, then discounting the  *
      * result to spot date using the yield curve specified in FX     *
      * Base Currency Yield Curve. The system will then compare this  *
      * figure with the original dealt base currency value to give a  *
      * profit or loss figure.                                        *
      *                                                               *
      *****************************************************************
     C     SRRevMethB    BEGSR
 
      ** Execute subroutine that converts the amount into base currency at
      ** forward FX rates
     C                   EXSR      SRCnvFwdR
 
      ** Execute subroutine that retrieves discount factor using base currency
      ** yield curve
     C                   EXSR      SRGetBCDF
 
     C     PFRevAmt      MULT(H)   WBaseDF       PIRevAmt
 
     C                   EXSR      SRCalcPL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRevMethD - Revaluation Calculation NPV Method "D"           *
      *                                                               *
      * Revaluation in this method is done by converting the amount   *
      * into base currency at forward FX rates. The system then com-  *
      * pares this figure with the original dealt base currency value *
      * to give a profit or loss figure. The profit or loss will then *
      * be discounted to spot date using the yield curve specified in *
      * FX Base Currency Yield Curve                                  *
      *                                                               *
      *****************************************************************
     C     SRRevMethD    BEGSR
 
      ** Execute subroutine that converts the amount into base currency at
      ** forward FX rates
     C                   EXSR      SRCnvFwdR
 
      ** Execute subroutine that retrieves discount factor using base currency
      ** yield curve
     C                   EXSR      SRGetBCDF
 
     C     PFPLAmt       MULT(H)   WBaseDF       PIPLAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetBCDF - Get Discount Factor Using Yield Curve Specified   *
      *             in FX Base Currency Yield Curve                   *
      *                                                               *
      *****************************************************************
     C     SRGetBCDF     BEGSR
 
      ** Use Base Ccy Yield Curve as the yield curve and setup parameter
      ** for ZADSFCAL; Set first Discount factor to 1
     C                   Z-ADD     1             WBaseDF
 
     C                   EVAL      PNPYld = BNBCYC
 
     C                   IF        PNPYld <> *BLANKS
     C                   EVAL      PNPCcy = BJCYCD
     C                   EVAL      PNPInC = BCICB
     C                   EVAL      PNPFDt = PIEDat
     C                   EXSR      SRGetDsFc
     C                   Z-ADD     PNPDF         WBaseDF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCnvFwdR - Convert Amount into Base Currency at Forward FX   *
      *             Rates                                             *
      *                                                               *
      *****************************************************************
     C     SRCnvFwdR     BEGSR
 
     C                   CALLB     'GOFWDREVN'
 
     C                   PARM      *BLANK        PORtCd
     C                   PARM      *BLANK        POErMs
     C                   PARM                    PBuySel
     C                   PARM                    PIECcy
     C                   PARM                    PIEDat
     C                   PARM                    PIEAmt
     C                   PARM                    PDBCE
     C                   PARM                    BJRDNB
     C                   PARM                    BJCYCD
     C                   PARM                    BCCDP
     C                   PARM                    SDCURR
      ** Outputs
     C                   PARM      *ZERO         PFRevAmt
     C                   PARM      *ZERO         PFRate
     C                   PARM      *ZERO         PFPLAmt
 
     C                   IF        PORtCd = '*ERROR '
     C                   EVAL      I#ErMs = *BLANKS
     C                   EVAL      I#ErMs = 'ERROR IN CALLING GOFWDREVN'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetDsFc - Discount Factor Calculation                      *
      *                                                               *
      *****************************************************************
     C     SRGetDsFc     BEGSR
 
      ** Call program that calculates and returns the Discount Factor
     C                   CALL      'ZADSFCAL'
     C                   PARM      *BLANKS       PORtCd
     C                   PARM                    PNPRtC
     C                   PARM                    PNPYld
     C                   PARM                    PNPCcy
     C                   PARM                    PNPInC
     C                   PARM                    PNPFDt
 
      ** Output: Discount Factor
     C                   PARM      *ZERO         PNPDF
 
     C                   IF        PORtCd <> *BLANKS
     C                   EVAL      I#ErMs = *BLANKS
     C                   EVAL      I#ErMs = 'ERROR IN CALLING ZADSFCAL'
     C                   EVAL      DBFILE = 'SDYLDRL2'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = PNPYld + PNPCcy + PNPInc
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Subroutine that Converts Amount to Amount in Base *
      *             Currency                                          *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
     C                   IF        K = 0
     C                   EVAL      K = 4
     C                   ENDIF
 
     C                   IF        A6MDIN = 'D'
 
     C                   IF        K <> 1 AND K <> 2
     C     WkRate        MULT      POWER(K)      Wk159
     C     PIEAmt        DIV(H)    Wk159         WkRevA
     C                   ENDIF
 
     C                   IF        K = 1
     C     WkRate        MULT      100           WRate1
     C     WRate1        MULT      POWER(K)      Wk159
     C     PIEAmt        DIV(H)    Wk159         Wk309
     C     Wk309         MULT(H)   100           WkRevA
     C                   ENDIF
 
     C                   IF        K = 2
     C     WkRate        MULT      10            WRate2
     C     WRate2        MULT      POWER(K)      Wk159
     C     PIEAmt        DIV(H)    WK159         Wk309
     C     Wk309         MULT(H)   10            WkRevA
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        K <> 6 AND K <> 7
     C     WkRate        DIV       POWER(K)      Wk159
     C     PIEAmt        MULT(H)   Wk159         WkRevA
     C                   ENDIF
 
     C                   IF        K = 7
     C     WkRate        MULT      100           WRate1
     C     WRate1        DIV       POWER(K)      Wk159
     C     PIEAmt        MULT(H)   Wk159         WkRevA
     C                   DIV(H)    100           WkRevA
     C                   ENDIF
 
     C                   IF        K = 6
     C     WkRate        MULT      10            WRate2
     C     WRate2        DIV       POWER(K)      Wk159
     C     PIEAmt        MULT(H)   Wk159         WkRevA
     C                   DIV(H)    10            WkRevA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcPL - Calculate Profit/Loss                              *
      *                                                               *
      *****************************************************************
     C     SRCalcPL      BEGSR
 
     C                   IF        PBuySel = 'B'
     C                   EVAL      PIPLAmt = PIRevAmt - PDBCE
     C                   ELSE
     C                   EVAL      PIPLAmt = PDBCE - PIRevAmt
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Implicitly called on program activation                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    I#RtCd
 
      ** Error Message
     C                   PARM                    I#ErMs
 
      **********
      ** Inputs:
      **********
      ** Buy/Sell
     C                   PARM                    PBuySel
 
      ** Yield Curve of the FX deal leg
     C                   PARM                    PYldBuy
 
      ** Yield Curve of the FX deal leg
     C                   PARM                    PYldSel
 
      ** Currency code of the FX deal leg
     C                   PARM                    PIECcy
 
      ** Value Date of the FX deal
     C                   PARM                    PIEDat
 
      ** Amount of the FX deal leg
     C                   PARM                    PIEAmt
 
      ** Base ccy equivalent
     C                   PARM                    PDBCE
 
      ** Run Day Number
     C                   PARM                    BJRDNB
 
      ** Base Currency Code
     C                   PARM                    BJCYCD
 
      ** Base ccy no. of decimal places
     C                   PARM                    BCCDP
 
      ** Base ccy interest calculation basis
     C                   PARM                    BCICB
 
      ** Currency details of the FX deal leg
     C                   PARM                    SDCURR
      ***********
      ** Outputs:
      ***********
 
      ** Revalued amount
     C                   PARM                    PIRevAmt
 
      ** Rate
     C                   PARM                    PIRate
 
      ** P/L amount
     C                   PARM                    PIPLAmt
 
     C                   EVAL      I#ErMs = *BLANKS
 
      ** Access Dealing ICD
     C                   CALL      'AODEALR0'
     C                   PARM      *BLANKS       PORtCd
     C                   PARM      '*FIRST '     POptn
     C     SDDEAL        PARM      SDDEAL        DSFDY
 
     C                   IF        PORtCd <> *BLANKS
     C                   EVAL      I#ErMs = *BLANKS
     C                   EVAL      I#ErMs = 'ERROR IN CALLING AODEALR0'
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * * P S S R  --- A B N O R M A L  E R R O R  C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
**   POWER - POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
