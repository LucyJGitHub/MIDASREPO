     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Yield calculation routine')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Processing                                  *
      *                                                               *
      *  ZYIELD - Yield Calculation Routine                           *
      *                                                               *
      *  Function:  This module is called whenever a yield/price      *
      *             is required. It calculates the yield/price        *
      *             using the data from the parameter list that is    *
      *             passed to it.                                     *
      *             This is the PLI program ZYIELD converted to RPG.  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054863           Date 18Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 215269             Date 25Feb03               *
      *                 211422             Date 13Feb03               *
      *                 CSE035             Date 22Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015  *CREATE    Date 17Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054863 - Calculate negative yield.                         *
      *             Applied partial fix of 258499.                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  215269 - Trade Price not defaulting correctly                *
      *  211422 - Correct the IF THEN logic for PCumEXFormula checking*
      *           in subroutine SrCalcAU                              *
      *  CSE035 - NX/NNX Coupon Payment Processing                    *
      *         - Code changes for New Zealand Bond Form.             *
      *  CPK015 - Conversion of ZYIELD from PLI to RPG                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrCalc        - Calculations for those Yield Types that      *
      *                  Require an Iterative Process to Obtain a     *
      *                  Value for a Yield                            *
      *  SrCalcAU      - Calculation for Australian Reserve Bank Yld  *
      *  SrCalcC       - Calculation for Long Term C.D.               *
      *  SrCalcPrice   - Calculate Price from a Given Field           *
      *  SrCalcS       - Calculation for Schuldschein Yield           *
      *  SrCalcYield   - Yield Calculation                            *
      *  SrInit        - Initialise Variables                         *
      *  SrPMethAU     - Price Calculation for Method  AU             *
      *  SrPMethC      - Price Calculation for Method  C              *
      *  SrPMethDADMDY - Price Calculation for Methods DA, DM, DY     *
      *  SrPMethJ      - Price Calculation for Method  J              *
      *  SrPMethR      - Price Calculation for Method  R              *
      *  SrPMethWASUY  - Price Calculation for Methods W, A, S, U, Y  *
      *  SrYMethAU     - Yield Calculation for Method  AU             *
      *  SrYMethC      - Yield Calculation for Method  C              *
      *  SrYMethDA     - Yield Calculation for Method  DA             *
      *  SrYMethDMDY   - Yield Calculation for Methods DM, DY         *
      *  SrYMethJ      - Yield Calculation for Method  J              *
      *  SrYMethR      - Yield Calculation for Method  R              *
      *  SrYMethWASUY  - Yield Calculation for Methods W, A, S, U, Y  *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D MAXVAL          S             15P13 DIM(12) CTDATA PERRCD(1)
     D MINVAL          S             15P13 DIM(12) CTDATA PERRCD(1)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** PARAMETERS
      ** ==========
      ** No. of Dp's required
     D PAccuracy       S              1P 0
      ** Compounding frequency
     D PComFreq        S              2P 0
      ** Coupon rate
     D PCoupRate       S             11P 7
      ** Coupons per year
     D PCoupYear       S              3P 0
      ** Coupons to maturity
     D PCpToMat        S              3P 0
      ** Use Cum/Ex formula
     D PCumExFormula   S              1A
      ** Days since last coupon
     D PDaysLstCoup    S              3P 0
      ** Days from penultimate coupon to maturity
     D PDaysShtCpn     S              3P 0
      ** Theoretical days in full last coupon
     D PDaysToNxtCpn   S              3P 0
      ** Discount basis
     D PDscBasis       S              1A
      ** Discount last coupon
     D PDscLstCoup     S              1A
      ** Error indicator
     D PErrInd         S              1A
      ** Fract years to maturity
     D PFracYMat       S             11P 9
      ** Whole years to maturity
     D PIntYMat        S              3P 0
      ** Maturity date
     D PMatDate        S              5P 0
      ** Yield calc method
     D PMethod         S              2A
      ** Next coupon date
     D PNxtCpDte       S              5P 0
      ** Days until payment
     D PPayDays        S              5P 0
      ** Life to maturity
     D PPayYears       S             13P 9
      ** Days between coupons
     D PPeriod         S              3P 0
      ** Price
     D PPrice          S             15P 9
      ** Calc price/yield P/Y
     D PPriceYield     S              1A
      ** Purchased interest
     D PPurchInt       S             15P 9
      ** Redemption price
     D PRedPrice       S             15P 9
      ** Semi-annual Y/N
     D PSemiAnn        S              1A
      ** Valuation date
     D PValueDate      S              5P 0
      ** Yield to maturity
     D PYield          S             15P 9
      ** Years issue to val
     D PYrsIssVal      S             13P 9
      ** Issue Date                                                                           CSE035
     D PIssDate        S              5P 0                                                    CSE035
      ** Would be Next Date                                                                   CSE035
     D PWBeNxtDate     S              5P 0                                                    CSE035

      ** WORK VARIABLES
      ** ==============
     D WAbsVal1        S              8F
     D WAbsVal2        S              8F
     D WCalcResult     S              8F
     D Wk_Fixed9DP     S             15P 9
     D Wk_Price        S              8F
     D Wk_Yield        S              8F
     D WNumDP          S              8F
     D WNum15P8        S             15P 8
     D WNum15P9        S             15P 9
     D WNum30P8        S             30P 8
     D WResult1        S              8F
     D WResult2        S              8F
     D WResult3        S              8F
     D WResult4        S              8F
     D WResult5        S              8F
     D WResult6        S              8F
     D WResult7        S              8F
     D WResult8        S              8F
     D WResult9        S              8F
     D WResult10       S              8F
     D WResult11       S              8F
     D WResult12       S              8F
     D WResult13       S              8F
     D WResult14       S              8F
     D WResult51       S              8F
     D WResult52       S              8F
     D WRounded        S              8F
     D WTruncate       S              7P 0 INZ(*ZERO)

     D DTIME           S             15P 9
     D I               S              3P 0
     D MAXPRI          S              8F
     D MINPRI          S              8F
     D MAXYLD          S              8F
     D MINYLD          S              8F
     D POS             S              3S 0

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialise variables

     C                   EXSR      SrInit

     C                   SELECT

      ** Yield calculation required

     C                   WHEN      PPriceYield = 'Y'
     C                   EXSR      SrCalcYield

      ** Calculate price from a given field

     C                   WHEN      PPriceYield = 'P'
     C                   EXSR      SrCalcPrice

      ** Error: invalid price/yield indicator passed

     C                   OTHER
     C                   EVAL      PErrInd = 'P'
     C                   EVAL      PYield = *ZERO
     C                   EVAL      PPrice = *ZERO
     C                   ENDSL

      ** Cash price of 9DP Australian (future) is left at full result

     C                   IF        PPriceYield = 'P' AND
     C                             PAccuracy = 9 AND PMethod = 'AU'
     C                   GOTO      EndProgram
     C                   ENDIF

      ** Default/catch all result (cash price or yield) is rounded at
      ** 8 decimal places

     C                   IF        PPriceYield = 'Y'
     C                   Z-ADD(H)  PYield        WNum15P8
     C                   Z-ADD     WNum15P8      PYield
     C                   Z-ADD(H)  PPrice        WNum15P8
     C                   Z-ADD     WNum15P8      PPrice
     C                   ENDIF

      ** End of program

     C     EndProgram    TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalcYield - Yield Calculation                              *
      *****************************************************************
     C     SrCalcYield   BEGSR

     C                   IF        PPayYears = *ZERO OR PPrice = *ZERO
     C                   EVAL      PYield = *ZERO

     C                   ELSE

      ** Calculate number of decimal places for accuracy of yield
      ** calculation. Default is 4.

     C                   IF        PAccuracy > *ZERO AND PAccuracy < 10
     C     1             DO        PAccuracy
     C                   EVAL      WNumDP = WNumDP * 0.1
     C                   ENDDO
     C                   ELSE
     C                   EVAL      WNumDP = 0.0001
     C                   ENDIF

     C                   EVAL      DTIME = PFracYMat + PIntYMat

      ** Process according to type of yield calculation required

     C                   SELECT

     C                   WHEN      PMethod = 'W ' OR PMethod = 'A ' OR
     C                             PMethod = 'S ' OR PMethod = 'U ' OR
     C                             PMethod = 'Y '
     C                   EXSR      SrYMethWASUY

     C                   WHEN      PMethod = 'C '
     C                   EXSR      SrYMethC

     C                   WHEN      PMethod = 'R '
     C                   EXSR      SrYMethR

     C                   WHEN      PMethod = 'J '
     C                   EXSR      SrYMethJ

     C                   WHEN      PMethod = 'DA'
     C                   EXSR      SrYMethDA

     C                   WHEN      PMethod = 'DM' OR PMethod = 'DY'
     C                   EXSR      SrYMethDMDY

     C                   WHEN      PMethod = 'AU'
     C                   EXSR      SrYMethAU

      ** Error: invalid yield calculation method passed

     C                   OTHER
     C                   EVAL      PErrInd = 'P'
     C                   EVAL      PYield = *ZERO
     C                   EVAL      PPrice = *ZERO
     C                   ENDSL

     C                   ENDIF

      ** Error: yield value out of range

     C                   IF        PYield > 999.9
     C                   EVAL      PErrInd = 'R'
     C                   EVAL      PYield = *ZERO
     C                   ENDIF

     C     ESrCalcYield  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalcPrice - Calculate Price from a Given Field             *
      *****************************************************************
     C     SrCalcPrice   BEGSR

     C                   IF        PPayYears = *ZERO OR PYield = *ZERO
     C                   EVAL      PPrice = 100

     C                   ELSE
     C                   EVAL      DTIME = PFracYMat + PIntYMat

      ** Process according to type of price calculation required

     C                   SELECT

     C                   WHEN      PMethod = 'W ' OR PMethod = 'A ' OR
     C                             PMethod = 'S ' OR PMethod = 'U ' OR
     C                             PMethod = 'Y '
     C                   EXSR      SrPMethWASUY

     C                   WHEN      PMethod = 'C '
     C                   EXSR      SrPMethC

     C                   WHEN      PMethod = 'R '
     C                   EXSR      SrPMethR

     C                   WHEN      PMethod = 'J '
     C                   EXSR      SrPMethJ

     C                   WHEN      PMethod = 'DA' OR PMethod = 'DM' OR
     C                             PMethod = 'DY'
     C                   EXSR      SrPMethDADMDY

     C                   WHEN      PMethod = 'AU'
     C                   EXSR      SrPMethAU

      ** Error: invalid yield calculation method passed

     C                   OTHER
     C                   EVAL      PErrInd = 'P'
     C                   EVAL      PYield = *ZERO
     C                   EVAL      PPrice = *ZERO
     C                   ENDSL

     C                   ENDIF

     C     ESrCalcPrice  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrYMethWASUY - Yield Calculation for Methods:                *
      *                 'W ' - Warrant Bond                           *
      *                 'A ' - A.I.B.D. (now I.S.M.A)                 *
      *                 'S ' - Schuldschein                           *
      *                 'U ' - U.S. Treasury                          *
      *                 'Y ' - Yankee                                 *
      *****************************************************************
     C     SrYMethWASUY  BEGSR

     C                   IF        PMethod = 'W '
     C                   EVAL      Wk_Price = (PPrice * 0.1) + PRedPrice
     C                   ELSE
     C                   EVAL      Wk_Price = PPrice
     C                   ENDIF

     C                   IF        Wk_Price <= WNumDP
     C                   EVAL      PPrice = *ZERO
     C                   EVAL      PYield = 1000.0 * WNumDP

     C                   ELSE

     C                   SELECT
     C                   WHEN      (PMethod = 'U ' OR PMethod = 'Y ') AND
     C                             PNxtCpDte = PMatDate

      ** US Treasury short formula used for Last coupon period

     C                   EVAL      WResult1 = PCoupRate * PDaysLstCoup
     C                   EVAL      WResult2 = PCoupYear * PPeriod
     C                   EVAL      POS = 1
     C                   EVAL      WResult3 = WResult1 / WResult2
     C                   EVAL      WResult3 = WResult3 + PPrice
     C                   EVAL      POS = 2
     C                   EVAL      WResult4 = PRedPrice + (PCoupRate/PCoupYear)
     C                   IF        PMethod = 'Y ' AND PCoupYear <> *ZERO
     C                   EVAL      WResult4 = WResult4 * PCoupYear
     C                   ENDIF
     C                   EVAL      POS = 3
     C                   EVAL      WResult5 = WResult2 / PPayDays
     C                   EVAL      POS = 4
     C                   EVAL      PYield = 100 * ((WResult4/WResult3) - 1.0) *
     C                             WResult5

     C                   OTHER

     C                   IF        PSemiAnn = 'Y'
     C                   EVAL      PCoupRate = PCoupRate * 0.5
     C                   EVAL      PFracYMat = PFracYMat * 2.0
     C                   EVAL      PIntYMat = PIntYMat * 2.0
     C                   EVAL      PPayYears = PPayYears * 2.0
     C                   IF        PFracYMat >= 1.0
     C                   EVAL      PFracYMat = PFracYMat - 1.0
     C                   EVAL      PIntYMat = PIntYMat + 1.0
     C                   ENDIF
     C                   EVAL      DTIME = PFracYMat + PIntYMat
     C                   ENDIF

     C                   EVAL      POS = 5
     C                   EVAL      Wk_Yield = ((PCoupRate * 100) / Wk_Price) +
     C                             ((PRedPrice - Wk_Price) / PPayYears)

     C     1             DO        12            I

     C                   IF        Wk_Yield < *ZERO
     C                   EVAL      WAbsVal1 = Wk_Yield * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = Wk_Yield
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      MINYLD = MINVAL(I) * Wk_Yield
     C                   EVAL      MAXYLD = MAXVAL(I) * Wk_Yield

     C                   EVAL      Wk_Yield = MINYLD
     C                   EXSR      SrCalc
     C                   EVAL      MINPRI = WCalcResult

     C                   IF        (MINPRI - Wk_Price) < *ZERO
     C                   EVAL      WAbsVal1 = (MINPRI - Wk_Price) * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = MINPRI - Wk_Price
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      Wk_Yield = MAXYLD
     C                   EXSR      SrCalc
     C                   EVAL      MAXPRI = WCalcResult

     C                   IF        (MAXPRI - Wk_Price) < *ZERO
     C                   EVAL      WAbsVal1 = (MAXPRI - Wk_Price) * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = MAXPRI - Wk_Price
     C                   ENDIF
     C                   IF        (MAXPRI - MINPRI) < *ZERO
     C                   EVAL      WAbsVal2 = (MAXPRI - MINPRI) * -1
     C                   ELSE
     C                   EVAL      WAbsVal2 = MAXPRI - MINPRI
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP OR WAbsVal2 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      POS = 6
     C                   EVAL      Wk_Yield = MINYLD + (MAXYLD - MINYLD) *
     C                             ((MINPRI - Wk_Price) / (MINPRI - MAXPRI))

     C                   ENDDO

      ** Where the LEAVE opcode (above) will transfer control

     C                   IF        PSemiAnn = 'Y'
     C                   IF        PMethod = 'Y '
     C                   EVAL      Wk_Yield = Wk_Yield * 2
     C                   ELSE
     C                   EVAL      Wk_Yield = Wk_Yield * 0.01
     C                   EVAL      Wk_Yield = Wk_Yield + 1
     C                   EVAL      POS = 7
     C                   EVAL      Wk_Yield = Wk_Yield ** 2
     C                   EVAL      Wk_Yield = (Wk_Yield - 1) * 100
     C                   ENDIF
     C                   ENDIF

      ** Accept negative yield                                                              MD054863
                                                                                            MD054863
     C**********         IF        Wk_Yield < WNumDP                                        MD054863
     C**********         EVAL      PYield = *ZERO                                           MD054863
     C**********         ELSE                                                               MD054863
     C                   IF        Wk_Yield > (1000.0 - WNumDP)
     C                   EVAL      PYield =  1000.0 - WNumDP
     C                   ELSE
     C                   EVAL      PYield = Wk_Yield
     C                   ENDIF
     C**********         ENDIF                                                              MD054863

     C                   ENDSL

     C                   ENDIF

     C     ESrYMethWASUY ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrYMethC - Yield Calculation for Method                      *
      *             'C ' - Certificate of Deposit                     *
      *****************************************************************
     C     SrYMethC      BEGSR

     C                   IF        PPrice = *ZERO
     C                   EVAL      PYield = *ZERO

      ** Normal C.D.

     C                   ELSE

     C                   EVAL      WResult1 = PPayYears + PYrsIssVal
     C                   EVAL      WResult1 = WResult1 * PCoupRate
     C                   EVAL      WResult1 = WResult1 + PRedPrice
     C                   EVAL      WResult2 = PCoupRate
     C                   EVAL      WResult2 = WResult2 * PYrsIssVal
     C                   EVAL      WResult2 = WResult2 + PPrice
     C                   EVAL      POS = 8
     C                   EVAL      WResult3 = WResult1 / WResult2
     C                   EVAL      POS = 9
     C                   EVAL      PYield = ((WResult3 - 1.0) * 100) / PPayYears

      ** Long term C.D. more than 1 year to run

     C                   IF        PIntYMat > *ZERO
     C                   EVAL      Wk_Yield = PYield

     C     1             DO        12            I
     C                   IF        Wk_Yield < *ZERO
     C                   EVAL      WAbsVal1 = Wk_Yield * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = Wk_Yield
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      MINYLD = MINVAL(I) * Wk_Yield
     C                   EVAL      MAXYLD = MAXVAL(I) * Wk_Yield

     C                   EVAL      Wk_Yield = MINYLD
     C                   EXSR      SrCalc
     C                   EVAL      MINPRI = WCalcResult

     C                   IF        (MINPRI - PPrice) < *ZERO
     C                   EVAL      WAbsVal1 = MINPRI - PPrice * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = MINPRI - PPrice
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      Wk_Yield = MAXYLD
     C                   EXSR      SrCalc
     C                   EVAL      MAXPRI = WCalcResult

     C                   IF        (MAXPRI - PPrice) < *ZERO
     C                   EVAL      WAbsVal1 = (MAXPRI - PPrice) * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = MAXPRI - PPrice
     C                   ENDIF
     C                   IF        (MAXPRI - MINPRI) < *ZERO
     C                   EVAL      WAbsVal2 = (MAXPRI - MINPRI) * -1
     C                   ELSE
     C                   EVAL      WAbsVal2 = MAXPRI - MINPRI
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP OR WAbsVal2 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      POS = 10
     C                   EVAL      Wk_Yield = MINYLD + (MAXYLD - MINYLD) *
     C                             ((MINPRI - PPrice) / (MINPRI - MAXPRI))

     C                   ENDDO

      ** Where the LEAVE opcode (above) will transfer control

     C                   IF        Wk_Yield < WNumDP
     C                   EVAL      PYield = *ZERO
     C                   ELSE
     C                   IF        Wk_Yield > (1000.0 - WNumDP)
     C                   EVAL      PYield = 1000.0 - WNumDP
     C                   ELSE
     C                   EVAL      PYield = Wk_Yield
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C     ESrYMethC     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrYMethR - Yield Calculation for Method                      *
      *             'R ' - Running Yield Including Capital Gain       *
      *****************************************************************
     C     SrYMethR      BEGSR

     C                   IF        PPrice = *ZERO
     C                   EVAL      PYield = *ZERO
     C                   ELSE

     C                   EVAL      WResult1 = PPayYears + PYrsIssVal
     C                   EVAL      WResult1 = WResult1 * PCoupRate
     C                   EVAL      WResult1 = WResult1 + PRedPrice
     C                   EVAL      WResult2 = PCoupRate
     C                   EVAL      WResult2 = WResult2 * PYrsIssVal
     C                   EVAL      WResult2 = WResult2 + PPrice
     C                   EVAL      POS = 11
     C                   EVAL      WResult3 = WResult1 / WResult2
     C                   EVAL      POS = 12
     C                   EVAL      PYield = ((WResult3 - 1.0) * 100) / PPayYears
     C                   ENDIF

     C     ESrYMethR     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrYMethJ - Yield Calculation for Method                      *
      *             'J ' - Japanese Yield                             *
      *****************************************************************
     C     SrYMethJ      BEGSR

     C                   EVAL      WResult1 = 100 * PCoupRate
     C                   EVAL      WResult2 = 100 * (PRedPrice - PPrice)
     C                   EVAL      POS = 13
     C                   EVAL      WResult2 = WResult2 / PPayYears
     C                   EVAL      POS = 14
     C                   EVAL      PYield = (WResult1 + WResult2) / PPrice

     C     ESrYMethJ     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrYMethDA - Yield Calculation for Method                     *
      *              'DA' - Yield on Average Discount                 *
      *****************************************************************
     C     SrYMethDA     BEGSR

     C                   IF        PPrice = *ZERO
     C                   EVAL      PYield = 1000.0 - WNumDP
     C                   ELSE

     C                   IF        PPrice >= 100
     C                   EVAL      PYield = *ZERO
     C                   ELSE

     C                   EVAL      POS = 15
     C                   EVAL      WResult3 = 100
     C                   EVAL      WResult3 = WResult3 / PPrice - 1
     C                   EVAL      WResult4 = 100
     C                   EVAL      WResult4 = WResult4 / PPayYears
     C                   EVAL      WResult3 = WResult3 * WResult4
     C                   IF        WResult3 > (1000.0 - WNumDP)
     C                   EVAL      PYield = 1000.0 - WNumDP
     C                   ELSE
     C                   EVAL      PYield = WResult3
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C     ESrYMethDA    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrYMethDMDY - Yield Calculation for Methods:                 *
      *                'DM' - Yield on Market Discount except Yen     *
      *                       Treasury Bills                          *
      *                'DY' - Yield on Market Discount for Yen        *
      *                       Treasury Bills                          *
      *****************************************************************
     C     SrYMethDMDY   BEGSR

     C                   EVAL      Wk_Price = PPrice
     C                   EVAL      WResult3 = Wk_Price * DTIME
     C                   EVAL      WResult3 = 100 - WResult3

     C                   IF        WResult3 <= *ZERO
     C                   EVAL      PYield = *ZERO

     C                   ELSE
     C                   EVAL      Wk_Price = PPrice
     C                   EVAL      WResult1 = Wk_Price * DTIME
     C                   EVAL      WResult1 = WResult1 * 10000.0

     C                   IF        PMethod = 'DY'
     C                   EVAL      WTruncate = WResult1
     C                   EVAL      WResult2 = WResult1 - WTruncate
     C                   IF        WResult2 < 0.5
     C                   EVAL      WRounded = WTruncate
     C                   ELSE
     C                   EVAL      WRounded = WTruncate + 1
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WRounded = WResult1
     C                   ENDIF

     C                   EVAL      POS = 16
     C                   EVAL      PYield = WRounded / (100 * WResult3)
     C                   EVAL      POS = 17
     C                   EVAL      PYield = PYield / PPayYears

     C                   ENDIF

     C     ESrYMethDMDY  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrYMethAU - Yield Calculation for Method                     *
      *              'AU' - Australian Reserve Bank Yield             *
      *****************************************************************
     C     SrYMethAU     BEGSR

     C                   EVAL      POS = 81
     C                   EVAL      Wk_Price = PPrice

     C                   IF        Wk_Price <= WNumDP
     C                   EVAL      PPrice = *ZERO
     C                   EVAL      PYield = 1000.0 * WNumDP
     C                   EVAL      POS = 82

     C                   ELSE

      ** Adjust for purchased interest - P.I. is negative in the EX period

     C                   EVAL      Wk_Price= Wk_Price + PPurchInt

     C                   IF        PNxtCpDte = PMatDate AND PDscLstCoup = 'Y'
     C                   EVAL      POS = 84

      ** Use 6 month formula for final coupon period

     C                   EVAL      WResult1 = 100 - Wk_Price                                  CSE035
     C                   IF        PCumExFormula = 'C'                                        CSE035
     C                   IF        PCoupRate = 0                                              CSE035
     C                   EVAL      WResult1 = 100 - Wk_Price                                  CSE035
     C                   ELSE                                                                 CSE035
     C                   EVAL      WResult1 = 100 + (PCoupRate / PCoupYear) -
     C                             Wk_Price
     C                   ENDIF                                                                CSE035
     C                   ENDIF                                                                CSE035
                                                                                              CSE035
     C                   IF        PDscBasis = '2'
     C                   EVAL      WResult2 = 365 * WResult1
     C                   ELSE
     C**********         EVAL      WResult2 = PPeriod * WResult1                              CSE035
     C                   EVAL      WResult2 = PPeriod * PCoupYear * WResult1                  CSE035
     C                   ENDIF

     C                   EVAL      WResult3 = (PMatDate - PValueDate) * Wk_Price
     C                   EVAL      POS = 86
     C                   EVAL      Wk_Yield = 100 * (WResult2 / WResult3)
     C                   EVAL      POS = 87

     C                   ELSE

     C                   EVAL      POS = 88
     C                   EVAL      Wk_Yield = ((PCoupRate * 100) / Wk_Price) +
     C                             ((PRedPrice - Wk_Price) / PPayYears)

     C     1             DO        12            I

     C                   EVAL      POS = 89
     C                   IF        Wk_Yield < *ZERO
     C                   EVAL      WAbsVal1 = Wk_Yield * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = Wk_Yield
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      MINYLD = MINVAL(I) * Wk_Yield
     C                   EVAL      MAXYLD = MAXVAL(I) * Wk_Yield
     C                   EVAL      POS = 90
     C                   EVAL      Wk_Yield = MINYLD
     C                   EXSR      SrCalc
     C                   EVAL      MINPRI = WCalcResult

     C                   EVAL      POS = 91
     C                   IF        (MINPRI - Wk_Price) < *ZERO
     C                   EVAL      WAbsVal1 = (MINPRI - Wk_Price) * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = MINPRI - Wk_Price
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      POS = 92
     C                   EVAL      Wk_Yield = MAXYLD
     C                   EXSR      SrCalc
     C                   EVAL      MAXPRI = WCalcResult
     C                   EVAL      POS = 93
     C                   IF        (MAXPRI - Wk_Price) < *ZERO
     C                   EVAL      WAbsVal1 = (MAXPRI - Wk_Price) * -1
     C                   ELSE
     C                   EVAL      WAbsVal1 = MAXPRI - Wk_Price
     C                   ENDIF
     C                   IF        (MAXPRI - MINPRI) < *ZERO
     C                   EVAL      WAbsVal2 = (MAXPRI - MINPRI) * -1
     C                   ELSE
     C                   EVAL      WAbsVal2 = MAXPRI - MINPRI
     C                   ENDIF
     C                   IF        WAbsVal1 < WNumDP OR WAbsVal2 < WNumDP
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      POS = 94
     C                   EVAL      Wk_Yield = MINYLD + (MAXYLD - MINYLD) *
     C                             ((MINPRI - Wk_Price) / (MINPRI - MAXPRI))

     C                   ENDDO

     C                   ENDIF

     C                   EVAL      POS = 95
     C                   IF        Wk_Yield < WNumDP
     C                   EVAL      PYield = *ZERO
     C                   ELSE
     C                   IF        Wk_Yield > (1000.0 - WNumDP)
     C                   EVAL      PYield = 1000.0 - WNumDP
     C                   ELSE
     C                   EVAL      PYield = Wk_Yield
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      POS = 96

     C                   ENDIF

     C     ESrYMethAU    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPMethWASUY - Price Calculation for Methods:                *
      *                 'W ' - Warrant Bond                           *
      *                 'A ' - A.I.B.D. (now I.S.M.A)                 *
      *                 'S ' - Schuldschein                           *
      *                 'U ' - U.S. Treasury                          *
      *                 'Y ' - Yankee                                 *
      *****************************************************************
     C     SrPMethWASUY  BEGSR

     C                   IF        ((PMethod = 'U ') OR (PMethod = 'Y ')) AND
     C                             PNxtCpDte = PMatDate

      ** US Treasury short formula used for Last coupon period

     C                   EVAL      POS = 18
     C                   EVAL      WResult1 = PCoupRate / PCoupYear
     C                   EVAL      WResult1 = WResult1 + PRedPrice

     C                   IF        PMethod = 'Y ' AND PCoupYear <> *ZERO
     C                   EVAL      PYield = PYield / PCoupYear
     C                   ENDIF

     C                   EVAL      WResult2 = PYield * PPayDays
     C                   EVAL      WResult3 = PPeriod * PCoupYear
     C                   EVAL      POS = 19
     C                   EVAL      WResult4 = WResult2 / WResult3
     C                   EVAL      WResult4 = WResult4 + 100
     C                   EVAL      WResult5 = PDaysLstCoup * PCoupRate
     C                   EVAL      POS = 20
     C                   EVAL      WResult6 = WResult5 / WResult3
     C                   EVAL      POS = 21
     C                   EVAL      Wk_Price = ((100 * WResult1) / WResult4) -
     C                                        WResult6

      ** Otherwise

     C                   ELSE

      ** If Semi-annual

     C                   IF        PSemiAnn = 'Y'
     C                   EVAL      PCoupRate = PCoupRate * 0.5
     C                   EVAL      PFracYMat = PFracYMat * 2.0
     C                   EVAL      PIntYMat = PIntYMat * 2.0
     C                   EVAL      PPayYears = PPayYears * 2.0

     C                   IF        PFracYMat >= 1.0
     C                   EVAL      PFracYMat = PFracYMat - 1.0
     C                   EVAL      PIntYMat = PIntYMat + 1.0
     C                   ENDIF

     C                   EVAL      DTIME = PFracYMat + PIntYMat
     C                   IF        PMethod = 'Y '
     C                   EVAL      Wk_Yield = PYield * 0.5
     C                   ELSE
     C                   EVAL      WResult1 = (PYield * 0.01) + 1.0
     C                   EVAL      POS = 22
     C                   EVAL      Wk_Yield = ((WResult1 ** 0.5) - 1.0) * 100
     C                   ENDIF

      ** Else, if not Semi-annual

     C                   ELSE
     C                   EVAL      Wk_Yield = PYield
     C                   ENDIF

     C                   EXSR      SrCalc
     C                   EVAL      Wk_Price = WCalcResult
     C                   ENDIF

     C                   IF        PMethod = 'W '
     C                   EVAL      Wk_Price = (Wk_Price - PRedPrice) * 10
     C                   ENDIF

     C                   Z-ADD(H)  Wk_Price      WNum30P8
     C                   EVAL      PPrice = WNum30P8

     C     ESrPMethWASUY ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPMethC - Price Calculation for Method                      *
      *             'C ' - Certificate of Deposit                     *
      *****************************************************************
     C     SrPMethC      BEGSR

      ** Long term C.D.

     C                   IF        PIntYMat > *ZERO
     C                   EVAL      Wk_Yield = PYield
     C                   EXSR      SrCalc
     C                   EVAL      Wk_Price = WCalcResult

      ** Normal C.D.

     C                   ELSE
     C                   EVAL      WResult1 = PPayYears + PYrsIssVal
     C                   EVAL      WResult1 = WResult1 * PCoupRate
     C                   EVAL      WResult1 = WResult1 + PRedPrice
     C                   EVAL      WResult2 = PYield
     C                   EVAL      WResult2 = WResult2 * PPayYears
     C                   EVAL      WResult2 = (WResult2 * 0.01) + 1.0
     C                   EVAL      POS = 23
     C                   EVAL      Wk_Price = WResult1 / WResult2
     C                   EVAL      WResult3 = PCoupRate
     C                   EVAL      WResult3 = WResult3 * PYrsIssVal
     C                   EVAL      Wk_Price = Wk_Price - WResult3
     C                   ENDIF

     C                   Z-ADD(H)  Wk_Price      WNum30P8
     C                   EVAL      PPrice = WNum30P8

     C     ESrPMethC     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPMethR - Price Calculation for Method                      *
      *             'R ' - Running Yield Including Capital Gain       *
      *****************************************************************
     C     SrPMethR      BEGSR

     C                   EVAL      WResult1 = PPayYears + PYrsIssVal
     C                   EVAL      WResult1 = WResult1 * PCoupRate
     C                   EVAL      WResult1 = WResult1 + PRedPrice
     C                   EVAL      WResult2 = PYield
     C                   EVAL      WResult2 = WResult2 * PPayYears
     C                   EVAL      WResult2 = (WResult2 * 0.01) + 1.0
     C                   EVAL      POS = 24
     C                   EVAL      WResult3 = PCoupRate
     C                   EVAL      WResult3 = WResult3 * PYrsIssVal
     C                   EVAL      Wk_Price = (WResult1 / WResult2) - WResult3
     C                   Z-ADD(H)  Wk_Price      WNum30P8
     C                   EVAL      PPrice = WNum30P8

     C     ESrPMethR     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPMethJ - Price Calculation for Method                      *
      *             'J ' - Japanese Yield                             *
      *****************************************************************
     C     SrPMethJ      BEGSR

     C                   EVAL      POS = 25
     C                   EVAL      WNum15P9 = PRedPrice / PPayYears
     C                   EVAL      WResult1 = PCoupRate + WNum15P9
     C                   EVAL      WResult2 = PYield * 0.01
     C                   EVAL      POS = 26
     C                   EVAL      WResult3 = 1 / PPayYears
     C                   EVAL      POS = 27
     C                   EVAL      Wk_Price = WResult1 / (WResult2 + WResult3)
     C                   Z-ADD(H)  Wk_Price      WNum30P8
     C                   EVAL      PPrice = WNum30P8

     C     ESrPMethJ     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPMethDADMDY - Price Calculation for Methods:               *
      *                  'DA' - Yield on Average Discount             *
      *                  'DM' - Yield on Market Discount except Yen   *
      *                         Treasury Bills                        *
      *                  'DY' - Yield on Market Discount for Yen      *
      *                         Treasury Bills                        *
      *****************************************************************
     C     SrPMethDADMDY BEGSR

     C                   IF        PMethod = 'DA'
  141C                   EVAL      WResult4 = PYield
  141C                   EVAL      WResult4 = WResult4 * PPayYears
  141C                   EVAL      Wk_Price = 100 / ((WResult4 / 100) +1)

     C                   ELSE
     C                   EVAL      WResult1 = PYield
     C                   EVAL      WResult1 = WResult1 * PPayYears
     C                   EVAL      WResult2 = WResult1 * 100
     C                   EVAL      WResult3 = WResult1 + 100
     C                   EVAL      WResult3 = WResult3 * PPayYears
     C                   EVAL      POS = 28
     C                   EVAL      Wk_Price = WResult2 / WResult3
     C                   ENDIF

     C                   Z-ADD(H)  Wk_Price      WNum30P8
     C                   EVAL      PPrice = WNum30P8

     C     ESrPMethDADMDYENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrPMethAU - Price Calculation for Method                     *
      *              'AU' - Australian Reserve Bank Yield             *
      *****************************************************************
     C     SrPMethAU     BEGSR

     C                   EVAL      Wk_Yield = PYield

      ** Use bonds within 6 months formula

     C                   IF        PNxtCpDte = PMatDate AND PDscLstCoup = 'Y'
     C                   EVAL      WResult1 = 100                                             CSE035
     C                   IF        PCumExFormula = 'C'                                        CSE035
     C                   IF        PCoupRate = 0                                              CSE035
     C                   EVAL      WResult1 = 100                                             CSE035
     C                   ELSE                                                                 CSE035
     C                   EVAL      WResult1 = 100 + (PCoupRate / PCoupYear)
     C                   ENDIF                                                                CSE035
     C                   ENDIF                                                                CSE035
     C                   EVAL      POS = 71
     C**********         IF        PDscBasis = '2'                                            CSE035
     C                   IF        PDscBasis = '2' OR                                         CSE035
     C                             PCoupRate = 0                                              CSE035
     C                   EVAL      WResult2 = (PMatDate - PValueDate) / 365
     C                   ELSE
     C**********         EVAL      WResult2 = (PMatDate - PValueDate) /PPeriod                CSE035
     C                   EVAL      WResult2 = (PMatDate - PValueDate) /                       CSE035
     C                             (PPeriod * PCoupYear)                                      CSE035
     C                   ENDIF

     C                   EVAL      POS = 72
     C                   EVAL      WResult3 = Wk_Yield * 0.01
     C                   EVAL      POS = 73
     C                   EVAL      WResult4 = (WResult2 * WResult3) + 1
     C                   EVAL      POS = 74
     C                   EVAL      Wk_Price = WResult1 / WResult4
     C                   EVAL      POS = 75

      ** Otherwise

     C                   ELSE
     C                   EXSR      SrCalc
     C                   EVAL      Wk_Price = WCalcResult
     C                   EVAL      POS = 76
     C                   ENDIF

      ** Adjust for purchased interest

     C                   EVAL      PPrice = Wk_Price - PPurchInt
     C                   EVAL      POS = 77

     C     ESrPMethAU    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalc - Calculations for those Yield Types that Require an  *
      *           Iterative Process to Obtain a Value for a Yield     *
      *****************************************************************
     C     SrCalc        BEGSR

     C                   SELECT
     C                   WHEN      PMethod = 'C '
     C                   EXSR      SrCalcC

     C                   WHEN      PMethod = 'S '
     C                   EXSR      SrCalcS

     C                   WHEN      PMethod = 'AU'
     C                   EXSR      SrCalcAU

     C                   OTHER
     C                   EVAL      WResult1 = Wk_Yield * 0.01 + 1
     C                   EVAL      POS = 39
     C                   EVAL      WTruncate = DTIME                                        MD054863
     C                   IF        WResult1 < *ZERO AND                                     MD054863
     C                             (DTIME - WTruncate) <> *ZERO                             MD054863
     C                   EVAL      WResult2 = 0                                             MD054863
     C                   EVAL      WResult6 = 0                                             MD054863
     C                   ELSE                                                               MD054863
     C                   EVAL      WResult2 = WResult1 ** DTIME
     C                   EVAL      WResult6 = 1 / WResult2                                  MD054863
     C                   ENDIF                                                              MD054863
     C                   EVAL      POS = 40
     C                   EVAL      WTruncate = PPayYears                                    MD054863
     C                   IF        WResult1 < *ZERO AND                                     MD054863
     C                             (PPayYears - WTruncate) <> *ZERO                         MD054863
     C                   EVAL      WResult3 = 0                                             MD054863
     C                   ELSE                                                               MD054863
     C                   EVAL      WResult3 = WResult1 ** PPayYears
     C                   EVAL      POS = 41
     C                   EVAL      WResult3 = PRedPrice / WResult3
     C                   ENDIF                                                              MD054863
     C                   EVAL      POS = 42
     C                   EVAL      WResult4 = (PCoupRate * 100) / Wk_Yield
     C                   EVAL      POS = 43
     C                   EVAL      WTruncate = PFracYMat                                    MD054863
     C                   IF        WResult1 < *ZERO AND                                     MD054863
     C                             (PFracYMat - WTruncate) <> *ZERO                         MD054863
     C                   EVAL      WResult5 = 0                                             MD054863
     C                   ELSE                                                               MD054863
     C                   EVAL      WResult5 = WResult1 ** (1 - PFracYMat)
     C                   ENDIF                                                              MD054863
     C                   EVAL      POS = 44
     C**********         EVAL      WResult6 = 1 / WResult2                                  MD054863
     C                   EVAL      WResult7 = PCoupRate * 100
     C                   EVAL      WResult7 = WResult7 * (1 - PFracYMat)
     C                   EVAL      WResult7 = WResult7 * 0.01
     C                   EVAL      WCalcResult = WResult3 + WResult4 *
     C                             (WResult5 - WResult6) - WResult7
     C                   ENDSL

     C     ESrCalc       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalcC - Calculation for Long Term Certificate of Deposit   *
      *****************************************************************
     C     SrCalcC       BEGSR

     C                   EVAL      WResult1 = PPayYears * PCoupYear
     C                   EVAL      WTruncate = WResult1
     C                   EVAL      WResult1 = 1.0 + (Wk_Yield * 0.01 *
     C                             PPeriod / 360)
     C                   EVAL      WResult2 = WResult1 ** WTruncate
     C                   EVAL      POS = 29
     C                   EVAL      WResult3 = (PCoupRate * 0.01 * PPeriod) / 360
     C                   EVAL      WResult4 = (WResult2 - 1.0) /
     C                             (WResult1 - 1.0)
     C                   EVAL      WResult4 = (WResult4 * WResult3 + 1.0) /
     C                             WResult2
     C                   EVAL      WResult5 = PPeriod * PCoupRate
     C                   EVAL      WResult5 = WResult5 * 0.01 / 360
     C                   EVAL      WResult6 = (PPeriod - PDaysLstCoup) *
     C                             Wk_Yield
     C                   EVAL      WResult6 = WResult6 * 0.01 / 360
     C                   EVAL      WResult7 = WResult4 + WResult5
     C                   EVAL      POS = 30
     C                   EVAL      WResult8 = 100 * WResult7 / (1.0 + WResult6)

     C                   IF        PCumExFormula = 'X'
     C                   EVAL      WResult8 = WResult8 + PPurchInt
     C                   ELSE
     C                   EVAL      WResult8 = WResult8 - PPurchInt
     C                   ENDIF

     C                   EVAL      POS = 31
     C                   EVAL      WCalcResult = WResult8

     C     ESrCalcC      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalcS - Calculation for Schuldschein Yield                 *
      *****************************************************************
     C     SrCalcS       BEGSR

     C                   EVAL      WResult1 = Wk_Yield * 0.01 + 1
     C                   EVAL      POS = 32
     C                   EVAL      WTruncate = DTIME                                        MD054863
     C                   IF        WResult1 < *ZERO AND                                     MD054863
     C                             (DTIME - WTruncate) <> *ZERO                             MD054863
     C                   EVAL      WResult2 = 0                                             MD054863
     C                   EVAL      WResult6 = 0                                             MD054863
     C                   ELSE                                                               MD054863
     C                   EVAL      WResult2 = WResult1 ** DTIME
     C                   EVAL      WResult6 = 1 / WResult2                                  MD054863
     C                   ENDIF                                                              MD054863
     C                   EVAL      POS = 33
     C                   EVAL      WTruncate = PPayYears                                    MD054863
     C                   IF        WResult1 < *ZERO AND                                     MD054863
     C                             (PPayYears - WTruncate) <> *ZERO                         MD054863
     C                   EVAL      WResult3 = 0                                             MD054863
     C                   ELSE                                                               MD054863
     C                   EVAL      WResult3 = PRedPrice /
     C                             (WResult1 ** PPayYears)
     C                   ENDIF                                                              MD054863
     C                   EVAL      POS = 34
     C                   EVAL      WResult4 = (PCoupRate * 100) / Wk_Yield
     C                   EVAL      POS = 35
     C                   EVAL      WTruncate = PFracYMat                                    MD054863
     C                   IF        WResult1 < *ZERO AND                                     MD054863
     C                             (PFracYMat - WTruncate) <> *ZERO                         MD054863
     C                   EVAL      WResult5 = 0                                             MD054863
     C                   ELSE                                                               MD054863
     C                   EVAL      WResult5 = WResult1 ** (1 - PFracYMat)
     C                   ENDIF                                                              MD054863
     C                   EVAL      POS = 36
     C**********         EVAL      WResult6 = 1 / WResult2                                  MD054863
     C                   EVAL      POS = 37
     C                   EVAL      WResult7 = PFracYMat
     C                   EVAL      WResult7 = (WResult7 * (PCoupRate * 100) *
     C                                       WResult5) / (100 * WResult1)
     C                   EVAL      POS = 38
     C                   EVAL      WCalcResult = WResult3 + WResult4 *
     C                             ((WResult5 / WResult1) - WResult6) + WResult7

     C     ESrCalcS      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalcAU - Calculation for Australian Reserve Bank Yield     *
      *****************************************************************
     C     SrCalcAU      BEGSR

      ** This section applies to both bonds and futures, however,
      ** rounding constraints are required for futures as follows...

      ** The SFECH contract formula (for futures) is expressed using:
      ** A = Wk_Yield      (ie quoted yield = (100 - quoted "price"))
      ** B = A/200         (200 is conversion of quoted yield from percent
      **                    per year to actual yield per coupon period)
      ** C = 1 / (1 + B)
      ** D = C ** total_nbr_of_coupons  (remaining to maturity)
      ** E = 1 - D
      ** F = 6 * E         (6 is yearly coupon rate / coupons per year)
      ** G = F/B
      ** H = 100 * D
      ** I = G + H
      ** J & K = not considered here

      ** Each step (A to K) must be rounded to 8 dp, so this is
      ** undertaken for the internal result fields as follows:
      ** A = Wk_Yield
      ** B = WResult5
      ** C = WResult1
      ** D = WResult6 and WResult4/100
      ** E = not applicable since calc (1-D) leaves 9th dp as 0
      ** F = not applicable since calc (6*E) leaves 9th dp as 0
      ** G = WResult8
      ** H = not applicable since calc (100*D) leaves 9th dp as 0
      ** I = not applicable since calc (G+H) leaves 9th dp as 0

     C                   IF        PAccuracy = 8
     C                   EVAL      Wk_Fixed9DP = Wk_Yield
     C                   Z-ADD(H)  Wk_Fixed9DP   WNum15P8
     C                   Z-ADD     WNum15P8      Wk_Yield
     C                   ENDIF

     C                   IF        PComFreq = *ZERO
     C                   EVAL      WResult51 = *ZERO
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'DIVISION BY ZERO'
     C                   EVAL      DBFILE = '*ZERO'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrCalcAU'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C**********         EVAL      WResult51 = (Wk_Yield / PComFreq) + 1                      CSE035
     C                   EVAL      WResult51 = (Wk_Yield / (PComFreq *                        CSE035
     C                             100)) + 1                                                  CSE035
     C                   ENDIF
     C**********         EVAL      WResult52 = (WResult51 ** (PComFreq /                      CSE035
     C**********                   PCoupYear)) - 1                                            CSE035
     C**********         EVAL      WResult5 = WResult52 / (100 * PCoupYear)                   CSE035
     C                   IF        PCoupYear = 0                                              CSE035
     C                   EVAL      WResult5 = WResult51 - 1                                   CSE035
     C                   ELSE                                                                 CSE035
     C                   EVAL      WResult5 = (WResult51 ** (PComFreq /                       CSE035
     C                             PCoupYear)) - 1                                            CSE035
     C                   ENDIF                                                                CSE035

     C                   IF        PAccuracy = 8
     C                   EVAL      Wk_Fixed9DP = WResult5
     C                   Z-ADD(H)  Wk_Fixed9DP   WNum15P8
     C                   Z-ADD     WNum15P8      WResult5
     C                   ENDIF

     C                   EVAL      POS = 55
     C                   EVAL      WResult1 = 1 / (1+ WResult5)

     C                   IF        PAccuracy = 8
     C                   EVAL      Wk_Fixed9DP = WResult1
     C                   Z-ADD(H)  Wk_Fixed9DP   WNum15P8
     C                   Z-ADD     WNum15P8      WResult1
     C                   ENDIF

     C                   EVAL      POS = 51
     C                   EVAL      WResult2 = (PNxtCpDte - PValueDate) / PPeriod
     C                   EVAL      POS = 52
                                                                                              CSE035
     C                   IF        PCumExFormula = 'D'                                        CSE035
     C                   IF        PValueDate < PWBeNxtDate                                   CSE035
     C                   EVAL      WResult2 = (PWBeNxtDate - PValueDate) /                    CSE035
     C                             PPeriod                                                    CSE035
     C                   EVAL      WResult3 = WResult1 ** (1 + WResult2)                      CSE035
     C                   ELSE                                                                 215269
     C                   EVAL      WResult3 = WResult1 ** WResult2                            215269
     C                   ENDIF                                                                CSE035
     C                   ELSE                                                                 CSE035
     C                   EVAL      WResult3 = WResult1 ** WResult2
     C*******************EVAL      POS = 53                                            CSE035 215269
     C                   ENDIF                                                                CSE035
     C                   EVAL      POS = 53                                                   215269

     C                   IF        PDaysShtCpn = *ZERO
     C                   EVAL      WResult4 = 100 * (WResult1 ** PCpToMat)

      ** Short last interest period

     C                   ELSE
     C                   EVAL      WResult11= PDaysShtCpn / PDaysToNxtCpn
     C                   EVAL      WResult12= PCpToMat + WResult11
     C                   EVAL      WResult13= WResult1 ** WResult12
     C                   IF        PCoupYear = 0                                              CSE035
     C                   EVAL      WResult14 = 0                                              CSE035
     C                   ELSE                                                                 CSE035
     C                   EVAL      WResult14= 100 + ((PCoupRate * WResult11) /
     C                             PCoupYear)
     C                   ENDIF                                                                CSE035
     C                   EVAL      WResult4 = WResult13 * WResult14
     C                   ENDIF

     C                   IF        PAccuracy = 8
     C                   EVAL      Wk_Fixed9DP = WResult4 / 100
     C                   Z-ADD(H)  Wk_Fixed9DP   WNum15P8
     C                   EVAL      WResult4 = WNum15P8 * 100
     C                   ENDIF

     C                   EVAL      POS = 54

     C                   IF        PMatDate = 99999
     C                   EVAL      WResult6 = *ZERO
     C                   ELSE
     C                   EVAL      WResult6 = WResult1 ** PCpToMat
     C                   ENDIF

     C                   IF        PAccuracy = 8
     C                   EVAL      Wk_Fixed9DP = WResult6
     C                   Z-ADD(H)  Wk_Fixed9DP   WNum15P8
     C                   Z-ADD     WNum15P8      WResult6
     C                   ENDIF

     C                   EVAL      POS = 56
     C                   IF        PCumExFormula = 'X'
     C                   EVAL      WResult7 = (1 - WResult6) / WResult5
     C                   ELSE                                                                 211422
     C                   EVAL      WResult7 = 1 + ((1 - WResult6) / WResult5)                 211422
     C                   ENDIF                                                                CSE035
     C                   IF        PCumExFormula = 'N'                                        CSE035
     C                   EVAL      WResult7 = ((PNxtCpDte - PIssDate) /                       CSE035
     C                             182.5) + ((1 - WResult6) / WResult5)                       CSE035
     C                   ENDIF                                                                CSE035
     C                   IF        PCumExFormula = 'D'                                        CSE035
     C                   EVAL      WResult7 = (1 + ((PWBeNxtDate - PIssDate) /                CSE035
     C                             182.5)) + ((1 - WResult6) / WResult5)                      CSE035
     C                                                                                        CSE035
     C**********         ELSE                                                                 211422
     C**********         EVAL      WResult7 = 1 + ((1 - WResult6) / WResult5)                 211422
     C                   ENDIF

     C                   EVAL      POS = 57
                                                                                              CSE035
     C                   IF        PCoupYear = 0                                              CSE035
     C                   EVAL      WResult8 = 0                                               CSE035
     C                   ELSE                                                                 CSE035
     C                   EVAL      WResult8 = (PCoupRate * WResult7) / PCoupYear
     C                   ENDIF                                                                CSE035

     C                   IF        PAccuracy = 8
     C                   EVAL      Wk_Fixed9DP = WResult8
     C                   Z-ADD(H)  Wk_Fixed9DP   WNum15P8
     C                   Z-ADD     WNum15P8      WResult8
     C                   ENDIF

     C                   EVAL      POS = 58
     C                   EVAL      WCalcResult = WResult3 *
     C                             (WResult4 + WResult8)

     C     ESrCalcAU     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrInit - Initialise Variables                                *
      *****************************************************************
     C     SrInit        BEGSR

     C                   EVAL      WResult1 = *ZERO
     C                   EVAL      WResult2 = *ZERO
     C                   EVAL      WResult3 = *ZERO
     C                   EVAL      WResult4 = *ZERO
     C                   EVAL      WResult5 = *ZERO
     C                   EVAL      WResult6 = *ZERO
     C                   EVAL      WResult7 = *ZERO
     C                   EVAL      WResult8 = *ZERO
     C                   EVAL      WResult9 = *ZERO
     C                   EVAL      WResult10 = *ZERO
     C                   EVAL      WResult11 = *ZERO
     C                   EVAL      WRounded = *ZERO
     C                   EVAL      DTIME = *ZERO
     C                   EVAL      MAXPRI = *ZERO
     C                   EVAL      MAXPRI = *ZERO
     C                   EVAL      MAXYLD = *ZERO
     C                   EVAL      MINYLD = *ZERO
     C                   EVAL      WNumDP = 1

     C                   EVAL      MINVAL(1)  = 0.9
     C                   EVAL      MINVAL(2)  = 0.99
     C                   EVAL      MINVAL(3)  = 0.999
     C                   EVAL      MINVAL(4)  = 0.9999
     C                   EVAL      MINVAL(5)  = 0.99999
     C                   EVAL      MINVAL(6)  = 0.999999
     C                   EVAL      MINVAL(7)  = 0.9999999
     C                   EVAL      MINVAL(8)  = 0.99999999
     C                   EVAL      MINVAL(9)  = 0.999999999
     C                   EVAL      MINVAL(10) = 0.9999999999
     C                   EVAL      MINVAL(11) = 0.99999999999
     C                   EVAL      MINVAL(12) = 0.999999999999

     C                   EVAL      MAXVAL(1)  = 1.1
     C                   EVAL      MAXVAL(2)  = 1.01
     C                   EVAL      MAXVAL(3)  = 1.001
     C                   EVAL      MAXVAL(4)  = 1.0001
     C                   EVAL      MAXVAL(5)  = 1.00001
     C                   EVAL      MAXVAL(6)  = 1.000001
     C                   EVAL      MAXVAL(7)  = 1.0000001
     C                   EVAL      MAXVAL(8)  = 1.00000001
     C                   EVAL      MAXVAL(9)  = 1.000000001
     C                   EVAL      MAXVAL(10) = 1.0000000001
     C                   EVAL      MAXVAL(11) = 1.00000000001
     C                   EVAL      MAXVAL(12) = 1.000000000001

     C     ESrInit       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PPriceYield
     C                   PARM                    PMethod
     C                   PARM                    PSemiAnn
     C                   PARM                    PErrInd
     C                   PARM                    PPrice
     C                   PARM                    PYield
     C                   PARM                    PCoupRate
     C                   PARM                    PIntYMat
     C                   PARM                    PFracYMat
     C                   PARM                    PRedPrice
     C                   PARM                    PYrsIssVal
     C                   PARM                    PAccuracy
     C                   PARM                    PCoupYear
     C                   PARM                    PDaysLstCoup
     C                   PARM                    PPeriod
     C                   PARM                    PPayYears
     C                   PARM                    PPayDays
     C                   PARM                    PValueDate
     C                   PARM                    PNxtCpDte
     C                   PARM                    PMatDate
     C                   PARM                    PCpToMat
     C                   PARM                    PPurchInt
     C                   PARM                    PDaysShtCpn
     C                   PARM                    PDaysToNxtCpn
     C                   PARM                    PCumExFormula
     C                   PARM                    PComFreq
     C                   PARM                    PDscBasis
     C                   PARM                    PDscLstCoup
     C                   PARM                    PIssDate                                     CSE035
     C                   PARM                    PWBeNxtDate                                  CSE035

     C                   EVAL      DBPGM = PSProcPgm

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        RunBefore = *BLANKS
     C                   EVAL      RunBefore = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
