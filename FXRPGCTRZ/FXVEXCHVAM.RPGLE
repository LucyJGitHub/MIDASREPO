     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate exchange rate versus amounts')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVEXCHVAM - Validate Exchange Rate Versus Amounts           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 251863             Date 22May20               *
      *  Prev Amend No. 248024             Date 22May20               *
      *                 MD046248           Date 27Oct17               *
      *                 AR703547           Date 25May16               *
      *                 AR808714           Date 04Jun15               *
      *                 258321             Date 19Aug14               *
      *                 256537             Date 15Mar13               *
      *                 MD000091           Date 07May13               *
      *                 CDL091             Date 12Dec12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26662           Date 04Nov09               *
      *                 BUG25284           Date 29Jul09               *
      *                 BUG25418           Date 07Aug09               *
      *                 BUG25240A          Date 05Aug09               *
      *                 BUG25240           Date 29Jul09               *
      *                 BUG23668E          Date 25May09               *
      *                 BUG23668D          Date 25May09               *
      *                 BUG23668C          Date 22May09               *
      *                 BUG23668B          Date 04May09               *
      *                 BUG23579           Date 30Mar09               *
      *                 BUG23668A          Date 04May09               *
      *                 BUG23668           Date 01Apr09               *
      *                 BUG23050A          Date 11Mar09               *
      *                 BUG23050           Date 23Feb09               *
      *                 BUG22009           Date 25Jan09               *
      *                 BUG22005           Date 21Jan09               *
      *                 BUG21428           Date 29Oct08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13209A          Date 16Feb07               *
      *                 BUG13209           Date 07Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 235142             Date 16Oct06               *
      *                 BUG5960            Date 24Mar05               *
      *                 224474             Date 20Jan04               *
      *                 210153             Date 20Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      *                 207744             Date 24Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 195763             Date 24Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186377             Date 13Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175229             Date 10Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 143747             Date 28Sep98               *
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  248024 - Change in processing to determine 'Normally Quoted  *
      *           Decimal Places' for Forward Points. Applied fix     *
      *           242105.                                             *
      *  251863 - Applied fixes 240038 and 238023.                    *
      *  240038 - Ensure margin rate functionalities are catered.     *
      *           Enhanced fix 238023 and patterned to SR/#ZICA.      *
      *  238023 - Incorrect exchange rate written on file. Ensure     *
      *           that buy/sell currencies with different decimal     *
      *           places are catered in margin rate functionalities.  *
      *           Exchange rate and amounts do not agree is shown.    *
      *           Program was amended such that validation of margin  *
      *           follow its functionality.                           *
      *  MD046248 - Finastra Rebranding                               *
      *  AR703547 - Different validation when Buy/Sell=Deal ccy and if*
      *             buy/sell<>deal ccy. @Round ind. is being checked  *
      *             for buy/sell=deal ccy. 2 unit diff is allowed when*
      *             @Round=Y for buy/sell=deal ccy unlike when buy/   *
      *             sell <> deal ccy. (Child artifact: AR703548)      *
      *             Applied for MD-37680.                             *
      *  AR808714 - Cannot insert OT deal, exchange rate validation.  *
      *             Do not issue error FXM4003 if rate is close to 1  *
      *             and amounts are correct. Applied fix AR599429.    *
      *             (Child: AR813475) - applied for MD032227.         *
      *  258321 - Make sure that when spot rate/the inverse of the    *
      *           spot rate is too close, multiply/divide indicator   *
      *           is correct. W@MDIN would not be left blank.         *
      *  256537 - Determine @@XX before multiplying to computed work  *
      *           field @WRKT2.                                       *
      *         - Applied for AR1091926. (Child: AR1093951)           *
      *  MD000091 - Event Codes Substitution                          *
      *  CDL091 - FX Auto Calculation (GIB016)                        *
      *         - Added hooks :                                       *
      *           CDL091_007                                          *
      *           CDL091_008                                          *
      *           CDL091_009                                          *
      *           CDL091_010                                          *
      *           CDL091_011                                          *
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26662 - A serious Midas error occurs upon completion      *
      *  BUG25284 - Incorrect deviation and tolerance warning shown   *
      *  BUG25418 - Incorrect rate shown in Correspondence confir -   *
      *             mation report                                     *
      *  BUG25240A - Reciprocal Rate Indicator Function reopened      *
      *             Applied Gems fix 224375.                          *
      *  BUG25240 - Reciprocal Rate Indicator Function                *
      *  BUG23668E - Reopened due to rate entered is not equal with   *
      *             rate from file.                                   *
      *  BUG23668D - Reopened due to change in design. Overlap in     *
      *             spot rates will no longer be considered when      *
      *             determining reciprocal rate indicator default     *
      *             value. Only 'close to 1' approach will be used    *
      *             which was introduced by 23050.                    *
      *  BUG23668C- Defaulting of Reciprocal rate indicator when spot *
      *             rate is close to 1.                               *
      *  BUG23668B- Defaulting of Reciprocal rate indicator when spot *
      *             rate is close to 1.                               *
      *  BUG23579 - Exchange Rate Tolerance of 0 is incorrectly       *
      *             displayed in tolerance warning message            *
      *  BUG23668A- Defaulting of Reciprocal rate indicator when spot *
      *             rate is close to 1.                               *
      *  BUG23668 - Defaulting of Reciprocal rate indicator when spot *
      *             rate is close to 1.                               *
      *  BUG23050A- Reciprocal indicator being defaulted.             *
      *             Defaulting of Reciprocal Rate indicator(FGE002).  *
      *  BUG23050 - Reciprocal indicator being defaulted              *
      *  BUG22009 - Reciprocal rate not accepted in FXDL type Option  *
      *             Takedown.                                         *
      *  BUG22005 - Fix Midas Serious Error when Buy Amount is blank  *
      *             Number of character return not setup.             *
      *  BUG21428 - Buy/sell amount does not default                  *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13209A - (Reopen) Partially remove BUG13209. Add fix to   *
      *              change value of @@XX array index field to de-    *
      *              duct value 4 from @@XX to correctly use number   *
      *              to be multiplied to computed work field @WKRT2.  *
      *  BUG13209 - Increase size of fields @SPTE2,@HRTE2,@LRTE2      *
      *             and @WKRT2.                                       *
      *  235142 - Apply the correct decimal places for variable       *
      *           @WKRT2.                                             *
      *  BUG5960- Determine DP adjustment BEFORE checking the rate    *
      *  224474 - Use DDRAT1 instead of DDRATE                        *
      *  210153 - Correctly compare exchange rate against range       *
      *           tolerance.  Apply fix 204542.                       *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  207744 - Incorrect incorporation of 175229.                  *
      *  195763 - Forward points should be same as in TOF.            *
      *  186377 - No warning message though exchange rate outside the *
      *           tolerance specified.                                *
      *  175229 - Applied fix 171828:                                 *
      *           Error in Cross-ccy calcs after tolernace check      *
      *  143747 - Forward points conversion error                     *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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
     D/COPY WNCPYSRC,FXH00012

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

                                                                                              CER043
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
      ** EXTERNAL DS FOR SAR DETAILS                                                          CER043
                                                                                              CER043
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER043
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    CER043
     D RelDealDts      DS           113                                                       CER043
      ** Related Deal Details (when deal is option takedown or swap.                          CER043
      ** Thus related deal will be other leg of swap or option).                              CER043
     D  RelCCY1                4      6                                                       CER043
     D  RelCCY2                7      9                                                       CER043
     D  RelDAM1               10     24  0                                                    CER043
     D  RelDAM2               25     39  0                                                    CER043
     D  RelDXRT               88    100  8                                                 BUG23050A
     D  RelOSRT              101    113  8                                                 BUG23050A

     D @@AY            S             10  0 DIM(10) CTDATA PERRCD(1)
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
     D @AD             S              9  0 DIM(8) CTDATA PERRCD(1)              Adjust Decimal
     D POW             S              7  3 DIM(7) CTDATA PERRCD(1)


     D                 DS
     D  @Y                     1     16
     D                                     DIM(16) ASCEND                       #ZICC  Amt.char.
     D  W@AMTP                 1     16
     D  W@AMTD                 1     17


     D                 DS
     D  @P                     1     15  0
     D                                     DIM(15)                              #ZICC  Amt.num.
     D  W@AMNT                 1     15  0
     D  W@AMTR                 3     15  8


     D                 DS
     D  W@1150                 1     15  0
     D  W@1151                 1     15  1
     D  W@1152                 1     15  2
     D  W@1153                 1     15  3


     D                 DS
     D  W@2150                 1     15  0
     D  W@2151                 1     15  1
     D  W@2152                 1     15  2
     D  W@2153                 1     15  3


     D                 DS
     D  W@3150                 1     15  0
     D  W@3151                 1     15  1
     D  W@3152                 1     15  2
     D  W@3153                 1     15  3


     D                 DS
     D  W@4150                 1     15  0
     D  W@4151                 1     15  1
     D  W@4152                 1     15  2
     D  W@4153                 1     15  3


     D M@MGDA          DS
     D  M@0145                 1     45
     D  M@0115                 1     15
     D  M@1630                16     30

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)


      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0

     D UseRate2        S              1                                         186377
                                                                                186377
                                                                                              CER043
     D CER043          S              1A                                                      CER043
     D PRtCd           S              7A                                                      CER043
     D POptn           S              7A                                                      CER043
     D PSard           S              6A                                                      CER043
     D DDREIN          S              1A                                                      CER043
     D ZFLD15          S             15P 0                                                    CER043
     D ZDECS           S              1P 0                                                    CER043
     D ZCRET           S              2P 0                                                  BUG21428
     D BNTHSP          S              1A                                                    BUG21428
     D*ZECODE**        S              1A                                             CER043 BUG21428
     D ZOUT21          S             21A                                                      CER043
     D POutAmt         S             15P 0                                                    CER043
     D WF3DAM1         S                   LIKE(F3DAM2)                                       CER043
     D WF3DAM2         S                   LIKE(F3DAM2)                                       CER043
     D WMDIN           S              1A                                                      CER043
     D WExchrt         S             30P25                                                    CER043
     D WSysSpotrt      S             13P 8                                                  BUG23050
     D WNorExchrt      S             13P 8                                                 BUG23050A
     D*WDeviatn**      S             13P 8                                        BUG23050A BUG26662
     D WDeviatn        S             15P 8                                                  BUG26662
     D WCcy            S              3A                                                   BUG23050A
     D WRetp           S              5S 2                                                 BUG23050A
     D*WSysSpotrtN     S             13P 8                                        BUG23668 BUG23668D
     D*WSysSpotrtInv   S             13P 8                                        BUG23668 BUG23668D
     D*WSysSpotrtNU    S             13P 8                                        BUG23668 BUG23668D
     D*WSysSpotrtNL    S             13P 8                                        BUG23668 BUG23668D
     D*WSysSpotrtInvU  S             13P 8                                        BUG23668 BUG23668D
     D*WSysSpotrtInvL  S             13P 8                                        BUG23668 BUG23668D
     D*WSsr10          S             13P 8                                        BUG23668 BUG23668D
     D*WIsr10          S             13P 8                                        BUG23668 BUG23668D
     D*WOverlap        S              1                                           BUG23668 BUG23668D
     D*WRrateInv       S             13P 8                                        BUG23668 BUG23668D
     D*WRetpD          S              3P 3                                       BUG23668A BUG23668D
     D WMDIN1          S              1A                                                    BUG25240
     D @RRATE1         S             13  8                                                  BUG25240
      **                                                                                   BUG23050A
     D DSWRK           DS                                                                  BUG23050A
     D  WRK1                          3A                                                   BUG23050A
     D  WRK2                          3A                                                   BUG23050A
     D  WRK3                         15A                                                   BUG23050A
     D  WRK4                          7A                                                   BUG23050A
     D  WRK5                          3A                                                   BUG23050A
     D/COPY OFCPYSRCZ,CDL091_007                                                              CDL091
     D/COPY WNCPYSRC,FXH00013
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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

      ** Initialization

     C                   MOVE      *BLANK        RetCodeIn

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx

     C                   MOVE      *BLANK        F3DMD1                         mult/div ind
     C                   Z-ADD     *ZERO         F3DXRT                         exch rate
     C                   Z-ADD     *ZERO         @SRATE                         Descaled exch rt
     C                   Z-ADD     *ZERO         @RRATE                         Rate+mgn+fwd pts
     C                   Z-ADD     *ZERO         @XRATE                         Rate+fwd pts
      *
      * Exit if invalid inputs
      *
     C/COPY OFCPYSRCZ,CDL091_008                                                              CDL091
     C/COPY WNCPYSRC,FXH00014
     C     W@INRT        IFEQ      *ZERO
     C     @@INRT        OREQ      *ZERO
     C     F3DAM1        OREQ      *ZERO
     C     CER043        ANDEQ     'N'                                                        CER043
     C     @SPOT1        OREQ      *ZERO
     C     F3DAM2        OREQ      *ZERO
     C     CER043        ANDEQ     'N'                                                        CER043
     C     @SPOT2        OREQ      *ZERO
     C                   RETURN
     C                   END
     C/COPY OFCPYSRCZ,CDL091_009                                                              CDL091
     C/COPY WNCPYSRC,FXH00015
      * Calculate buy and sell amount                                                         CER043
      *                                                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
      *                                                                                    BUG23050A
      * Calculate for system spot rate                                                     BUG23050A
     C                   EXSR      SrSySpotRte                                             BUG23050A
      *                                                                                     BUG23668
      ** Calculate for Gross spot rate from the screen input                                BUG23668
      *                                                                                     BUG23668
     C                   EXSR      SrFwdMrgnPt                                              BUG23668
      *                                                                                     BUG23050
     **If*Reciprocal rate indicator is 'N',                                        BUG23050 BUG23668
     **Default*the correct Reciprocal Indicator                                    BUG23050 BUG23668
     C**********         IF        DDREIN = 'N'                                    BUG23050 BUG23668
     C                   EXSR      SrRepIn                                                  B0G23050
     C**********         ENDIF                                                     BUG23050 BUG23668
      **********                                                                  BUG23668 BUG23668D
      *Check*if*spot rates overlap.                                               BUG23668 BUG23668D
     C**********         EXSR      SrSpRtOverlap                                  BUG23668 BUG23668D
                                                                                           BUG23050A
     C                   EVAL      @RRATE1 = *Zeros                                         BUG25284
      *                                                                                    BUG23050A
      ** Recompute exchange and gross rate for reciprocal rate                             BUG23050A
      *                                                                                    BUG23050A
     C                   IF        DDREIN = 'Y'                                            BUG23050A
     C**********         EVAL      @@INRT = @@INRTR                               BUG23050A BUG23668
     C*****1****         DIV(H)    W@INRT        W@INRT                           BUG23050A BUG23668
     C**********         EVAL      F3OSRT = W@INRT                                BUG23050A BUG23668
     C**********         EVAL      @RRATE = WRrateInv                             BUG23668 BUG23668D
     C**********         EVAL      @RRATE = 1/@RRATE                             BUG23668D BUG23668E
     C**********         EVAL(H)   @RRATE = 1/@RRATE                              BUG23668E BUG25240
     C                   EVAL(H)   @RRATE1 = 1/@RRATE                                       BUG25240
     C                   ENDIF                                                             BUG23050A
      *********                                                                   BUG23050A BUG23668
      ***Calculate for Gross spot rate from the screen input                      BUG23050A BUG23668
      *********                                                                   BUG23050A BUG23668
     C*********          EXSR      SrFwdMrgnPt                                    BUG23050A BUG23668
      *                                                                                    BUG23050A
      ** Get System Deviation                                                              BUG23050A
      *                                                                                    BUG23050A
     C                   EXSR      SrDeviation                                             BUG23050A
      *                                                                                    BUG23050A
      ** Validate the Option Take Down                                                     BUG23050A
      *                                                                                    BUG23050A
     C                   EXSR      SrOptTake                                               BUG23050A
      *                                                                                    BUG23050A
      ** Default buy/sell amount                                                           BUG23050A
      *                                                                                    BUG23050A
     C                   EXSR      SrBSAmtCal                                                 CER043
     C                   ENDIF                                                                CER043
     C*
      * Validate exchange rate input and amounts ratio
      *
     C                   EXSR      #ZID
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      *                                                               *
      * #ZID - Validate exchange rate input and amounts ratio         *
      *                                                               *
      *****************************************************************
     C     #ZID          BEGSR
     C*
     C/COPY OFCPYSRCZ,CDL091_010                                                              CDL091
     C/COPY WNCPYSRC,FXH00016
     C                   Z-ADD     1             W@SFAC            1 0          ScalingFactor
     C*
     C* DETERMINE MULTIPLY/DIVIDE INDICATOR FOR EXCHANGE RATE SUPPLIED
     C* BY MULTIPLYING OR DIVIDING BUY AND SELL AMOUNTS.
     C*
     C* SUBROUTINES #ZICA & #ZICB ARE CALLED TO APPLY 3 METHODS OF
     C* CALCULATION (FIELD @@K): 1 2 OR 3. 1 USES EXCHANGE RATE; 2 USES
     C* EXCHANGE RATE PLUS 0.000005: 3 USES EXCHANGE RATE MINUS 0.000005
     C* METHODS 2 AND 3 ARE ONLY INVOKED IF METHOD 1 CAN'T RECONCILE THE
     C* EXACT RATE AGAINST THE BUY AND SELL AMOUNTS. A FURTHER COMBINATION
     C* OF CALCULATIONS IS INVOKED WHEN DECIDING WHETHER TO ADD OR SUBTRACT
     C* MARGIN POINTS TO THE RATE (CONTROLLED BY #ZIC1 AND #ZIC2)
     C*
     C/COPY WNCPYSRC,FXH00219
     C                   MOVE      'X'           W@MDIN            1            M/D error
     C/COPY WNCPYSRC,FXH00220
     C*
     C                   Z-ADD     F3DAM1        @AMT7            15 0          BUY AMT
     C                   Z-SUB     F3DAM2        @AMT8            15 0          SELL AMT
     C*
     C* I F  B U Y  C C Y   =  D E A L I N G   B A S E  C C Y
     C*
     C     DDBCCY        IFEQ      BNCYDL
     C                   Z-ADD     F3DAM1        @@DAM1           15 0            C1 Amount
     C                   Z-ADD     @CDP1         @@CDP1            1 0            C1 Decimals
     C                   Z-ADD     F3DAM2        @@DAM2           15 0            C2 Amount
     C                   Z-ADD     @CDP2         @@CDP2            1 0            C2 Decimals
     C                   Z-ADD     @SPOT2        @@HISP           13 8            C2 HighSpot
     C                   Z-ADD     @SPOT2        @@LOSP           13 8            C2 Low Spot
     C                   MOVE      @@MDF2        @@XRMD            1              C2 XRateM/D
     C                   Z-ADD     @@NDP2        W@NQDP            1 0            NormQuotDecPl
     C                   ADD       @@SXP2        W@SFAC                           ScalingFactor
     C                   MOVE      'B'           @@BSIN            1              Base=Buy
     C                   MOVE      'A'           W@ZIC             1
     C                   Z-ADD     1             @@K               2 0          Counter
     C                   EXSR      #ZIC1                                          <Validate>
     C     W@DFBD        IFNE      *ZERO
     C     W@DFSD        ANDNE     *ZERO
     C     W@DFBM        ANDNE     *ZERO
     C     W@DFSM        ANDNE     *ZERO
     C                   Z-ADD     @@MGPT        @SMGPT            7 2
     C                   Z-ADD     2             @@K
     C                   EXSR      #ZICA                                          <Validate>
     C                   Z-ADD     3             @@K
     C                   EXSR      #ZICA                                          <Validate>
     C     S01453        IFEQ      'Y'
     C     @@MGPT        ANDNE     0
     C                   EXSR      #ZIC2
     C                   END
     C                   END
     C*
     C                   ELSE                                                   EL CCY.1<>BASE
     C*
     C* I F  S E L L  C C Y   =  D E A L I N G   B A S E  C C Y
     C*
     C     DDSCCY        IFEQ      BNCYDL
     C                   Z-ADD     F3DAM2        @@DAM1                           C2 Amount
     C                   Z-ADD     @CDP2         @@CDP1                           C2 Decimals
     C                   Z-ADD     F3DAM1        @@DAM2                           C1 Amount
     C                   Z-ADD     @CDP1         @@CDP2                           C1 Decimals
     C                   Z-ADD     @SPOT1        @@HISP                           C1 HighSpot
     C                   Z-ADD     @SPOT1        @@LOSP                           C1 Low Spot
     C                   MOVE      @@MDF1        @@XRMD                           C1 XRateM/D
     C                   Z-ADD     @@NDP1        W@NQDP                           C1 NQuotDecPl
     C                   ADD       @@SXP1        W@SFAC                           ScalingFactor
     C                   MOVE      'S'           @@BSIN                           Base=Sell
     C                   MOVE      'A'           W@ZIC
     C                   Z-ADD     1             @@K
     C                   EXSR      #ZIC1                                          <Validate>
     C     W@DFBD        IFNE      *ZERO
     C     W@DFSD        ANDNE     *ZERO
     C     W@DFBM        ANDNE     *ZERO
     C     W@DFSM        ANDNE     *ZERO
     C                   Z-ADD     @@MGPT        @SMGPT
     C                   Z-ADD     2             @@K
     C                   EXSR      #ZICA                                          <Validate>
     C                   Z-ADD     3             @@K
     C                   EXSR      #ZICA                                          <Validate>
     C     S01453        IFEQ      'Y'
     C     @@MGPT        ANDNE     0
     C                   EXSR      #ZIC2
     C                   END
     C                   END
     C*
     C                   ELSE
     C*
     C* I F  N E I T H E R   B U Y /  S E L L  C C Y   =  D E A L  B A S E
     C*
     C                   MOVE      'B'           W@ZIC
     C                   Z-ADD     1             @@K
     C                   EXSR      #ZIC1                                        <X-Validate>
     C     W@DIFS        IFNE      *ZERO
     C     W@DIFB        ANDNE     *ZERO
     C                   Z-ADD     @@MGPT        @SMGPT
     C                   Z-ADD     2             @@K
     C                   EXSR      #ZICB                                        <X-Validate>
     C                   Z-ADD     3             @@K
     C                   EXSR      #ZICB                                        <X-Validate>
     C     S01453        IFEQ      'Y'
     C     @@MGPT        ANDNE     0
     C                   EXSR      #ZIC2
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C* IF MULTIPLY/DIVIDE INDICATOR IS STILL 'X'
     C* THEN AMOUNTS DO NOT MATCH UP WITH THE EXCHANGE RATE SUPPLIED
     C* If not valid, send error message:
     C* "EXCHANGE RATES AND AMOUNTS DO NOT AGREE"
     C*
     C     W@MDIN        IFEQ      'X'
     C                   MOVE      'N'           DDRateOK
     C                   MOVE      'N'           DDBamtOK
     C                   MOVE      'N'           DDSamtOK
     C                   ADD       1             Idx
     C**********         MOVEL     'DDRATE'      FldNamXAr(Idx)                               224474
     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                               224474
     C                   MOVEL     'FXM0152'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      W@MDIN        F3DMD1                         mult/div ind
     C                   Z-ADD     @KRATE        F3DXRT                         outright rate
     C                   END                                                    (descaled)
     C*
     C* VALIDATE RATIO OF AMOUNTS AGAINST CURRENT SPOT RATES
     C* (THEY MUST BE WITHIN TOLERANCE PERCENTAGE)
     C*
     C                   MOVE      'Y'           RATOK             1            RATE OK?
     C*
     C* DETERMINE HIGH & LOW TOLERANCE PERCENTAGES
     C*
     C     1             ADD       TOLRAN        @TOLHI            5 3
     C     1             SUB       TOLRAN        @TOLLO            5 3
      *                                                                                       210153
     C                   Z-ADD     @AMT7         WBAMT1           24 9                        210153
     C                   Z-ADD     @AMT8         WSAMT1           24 9                        210153
     C     @CDP1         IFNE      @CDP2                                                      210153
     C     @CDP1         IFGT      @CDP2                                                      210153
     C     @CDP1         SUB       @CDP2         @@WDP1            1 0                        210153
     C                   ADD       1             @@WDP1                                       210153
     C     WBAMT1        DIV(H)    @@AY(@@WDP1)  WBAMT1                                       210153
     C                   ELSE                                                                 210153
     C     @CDP2         SUB       @CDP1         @@WDP1                                       210153
     C                   ADD       1             @@WDP1                                       210153
     C     WSAMT1        DIV(H)    @@AY(@@WDP1)  WSAMT1                                       210153
     C                   ENDIF                                                                210153
     C                   ENDIF                                                                210153
     C*
     C* CALCULATE EFFECTIVE SPOT (CROSS) RATE FROM BUY AND SELL SPOT RATES
     C*
     C     @@MDF1        IFEQ      'M'
     C     @@MDF2        ANDEQ     'M'
     C     @SPOT1        DIV       @SPOT2        @SPRTE
     C                   EVAL      UseRate2 = 'N'                               186377
     C                   END
      *                                                                                       210153
     C     @SPOT1        IFEQ      1                                                          210153
     C     @SPOT2        OREQ      1                                                          210153
     C     @SPOT2        IFGT      1                                                          210153
     C     @SPOT2        ANDGT     @SPOT1                                                     210153
     C     @SPOT2        ORLT      1                                                          210153
     C     @SPOT2        ANDLT     @SPOT1                                                     210153
     C                   MOVE      'Y'           Userate2                                     210153
     C                   ENDIF                                                                210153
      *                                                                                       210153
     C                   ELSE                                                                 210153
      *                                                                                       210153
     C     WBAMT1        IFLT      WSAMT1                                                     210153
     C     @KRATE        ANDLT     1                                                          210153
     C     WBAMT1        ORGT      WSAMT1                                                     210153
     C     @KRATE        ANDGT     1                                                          210153
     C                   MOVE      'Y'           Userate2                                     210153
     C                   ENDIF                                                                210153
     C                   ENDIF                                                                210153
     C*
     C     @@MDF1        IFEQ      'M'
     C     @@MDF2        ANDEQ     'D'
     C     @SPOT1        MULT      @SPOT2        @SPRTE
     C                   EVAL      UseRate2 = 'N'                               186377
     C                   END
     C*
     C     @@MDF1        IFEQ      'D'
     C     @@MDF2        ANDEQ     'M'
     C     1             DIV       @SPOT1        @SPRTE
     C*****@SPRTE        DIV       @SPOT2        @SPRTE           13 8                        210153
     C     @SPRTE        DIV       @SPOT2        @SPRTE           2015                        210153
     C                   EVAL      UseRate2 = 'Y'                               186377
     C                   END
     C*
     C     @@MDF1        IFEQ      'D'
     C     @@MDF2        ANDEQ     'D'
     C     @SPOT2        DIV       @SPOT1        @SPRTE
     C                   EVAL      UseRate2 = 'Y'                               186377
      *                                                                                       210153
     C     @SPOT1        IFEQ      1                                                          210153
     C     @SPOT2        OREQ      1                                                          210153
     C     @SPOT2        IFGT      1                                                          210153
     C     @SPOT2        ANDGT     @SPOT1                                                     210153
     C     @SPOT2        ORLT      1                                                          210153
     C     @SPOT2        ANDLT     @SPOT1                                                     210153
     C                   MOVE      'N'           Userate2                                     210153
     C                   ENDIF                                                                210153
      *                                                                                       210153
     C                   ELSE                                                                 210153
      *                                                                                       210153
     C     WBAMT1        IFGT      WSAMT1                                                     210153
     C     @KRATE        ANDLT     1                                                          210153
     C     WBAMT1        ORLT      WSAMT1                                                     210153
     C     @KRATE        ANDGT     1                                                          210153
     C                   MOVE      'N'           Userate2                                     210153
     C                   ENDIF                                                                210153
     C                   ENDIF                                                                210153
      *                                                                                       210153
     C                   END
      *                                                                                       210153
      ** Get the inverse of the effective spot. This will be used for                         210153
      ** further checking of tolerance limit.                                                 210153
      *                                                                                       210153
     C*****1****         DIV       @SPRTE        @SPTE2           2015               210153 BUG13209
     C*****1****         DIV       @SPRTE        @SPTE2           2515            BUG13209 BUG13209A
     C     1             DIV       @SPRTE        @SPTE2           2015            BUG13209 BUG13209A
     C*
     C* CALCULATE HIGH & LOW SPOT RATE USING % TOLERANCES
     C*
     C     @SPRTE        MULT      @TOLHI        @HIRTE           13 8
     C     @SPRTE        MULT      @TOLLO        @LORTE           13 8
     C*****@SPTE2        MULT      @TOLHI        @HRTE2           13 8               210153 BUG13209
     C     @SPTE2        MULT      @TOLHI        @HRTE2           20 8               210153 BUG13209
     C*****@SPTE2        MULT      @TOLLO        @LRTE2           13 8               210153 BUG13209
     C     @SPTE2        MULT      @TOLLO        @LRTE2           20 8               210153 BUG13209
     C*
     C* CALCULATE:   SELL AMT/BUY AMT   &   BUY AMT/SELL AMT
     C*
     C     4             ADD       @CDP1         @@XX              3 0
     C                   SUB       @CDP2         @@XX
     C*
     C     @AMT8         DIV       @AMT7         @WKRTE           13 8          SELL/BUY
     C     @WKRTE        MULT      POW(@@XX)     @WKRTE
     C*
     C     4             ADD       @CDP2         @@XX                                        BUG5960
     C                   SUB       @CDP1         @@XX                                        BUG5960
     C*****@AMT7         DIV       @AMT8         @WKRT2           13 8               BUY/SELL 235142
     C*****@AMT7         DIV       @AMT8         @WKRT2           14 8               235142 BUG13209
     C     @AMT7         DIV       @AMT8         @WKRT2           20 8               235142 BUG13209
      *                                                                                       235142
      ** If BUY CCY's Decimal Places = 0                                                      235142
      *                                                                                       235142
     C                   IF        @CDP1 = 0                                                  235142
     C                   EVAL      @@XX = @@XX - 4                                         BUG13209A
     C                   IF        @@XX <> 0                                                  256537
     C     @WKRT2        MULT      @AD(@@XX)     @WKRT2                                       235142
     C                   ENDIF                                                                256537
     C                   ELSE                                                                 235142
     C                   IF        @CDP2 <> 0                                                 235142
     C     @WKRT2        MULT      POW(@@XX)     @WKRT2
     C                   ELSE                                                                 235142
     C     @WKRT2        DIV       100           @WKRT2                                       235142
     C                   ENDIF                                                                235142
     C                   ENDIF                                                                235142
      *****4*************ADD       @CDP2         @@XX                                 210153 BUG5960
      *******************SUB       @CDP1         @@XX                                 210153 BUG5960
     C*
     C* IF  SELL AMT/BUY AMT   > HIGH RATE   OR < LOW RATE
     C* IF  BUY AMT/SELL AMT   > HIGH RATE   OR < LOW RATE
     C*     IT IS A % TOLERANCE ERROR
     C*
     C                   IF        UseRate2 = 'N'                               186377
     C     @WKRTE        IFGT      @HIRTE
     C     @WKRTE        ORLT      @LORTE
     C*****@WKRT2        IFGT      @HIRTE                                       186377
     C*****@WKRT2        ORLT      @LORTE                                       186377
     C                   MOVE      'N'           RATOK                          * ERROR
     C********           END                                                    186377
     C                   END
     C*                                                                         186377
     C                   ELSE                                                   186377
     C*****@WKRT2        IFGT      @HIRTE                                              186377 210153
     C*****@WKRT2        ORLT      @LORTE                                              186377 210153
     C     @WKRT2        IFGT      @HRTE2                                                     210153
     C     @WKRT2        ORLT      @LRTE2                                                     210153
     C                   MOVE      'N'           RATOK                          186377
     C                   ENDIF                                                  186377
     C                   ENDIF                                                  186377
     C*
     C** VALIDATE THAT BUY AND SELL AMOUNTS ARE THE CORRECT WAY ROUND
     C** ACCORDING TO CURRENCY MULTIPLY/DIVIDE INDICATORS
     C** (AMOUNTS MUST BE ADJUSTED BY NO.OF CURRENCY DECIMAL PLACES)
     C*
     C                   MOVE      'Y'           AMTOK             1            AMOUNT OK?
     C*
     C                   Z-ADD     @AMT7         @AMT7R           24 9          BUY AMT
     C                   Z-ADD     @AMT8         @AMT8R           24 9          SELL AMT
     C*
     C* IF NO. OF DECIMAL PLACES OF BOTH CURRENCIES IS DIFFERENT
     C* ADJUST THE BUY AND SELL AMOUNTS TO REFLECT THE DIFFEREMNCE
     C*
     C     @CDP1         IFNE      @CDP2
     C     @CDP1         IFGT      @CDP2
     C     @CDP1         SUB       @CDP2         @@WDP             1 0
     C                   ADD       1             @@WDP
     C     @AMT7R        DIV(H)    @@AY(@@WDP)   @AMT7R                         ADJ. BUY AMT
     C                   ELSE
     C     @CDP2         SUB       @CDP1         @@WDP
     C                   ADD       1             @@WDP
     C     @AMT8R        DIV(H)    @@AY(@@WDP)   @AMT8R                         ADJ.SELL AMT
     C                   END
     C                   END
     C*
     C* VALIDATE WHEN BUY AND SELL RATES ARE BOTH MULTIPLY RATES
     C*
     C     @@MDF1        IFEQ      'M'
     C     @@MDF2        ANDEQ     'M'
     C     @SPOT1        IFLE      @SPOT2
     C     @AMT7R        ANDLT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C     @SPOT1        IFGT      @SPOT2
     C     @AMT7R        ANDGT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C                   END
     C*
     C* VALIDATE WHEN BUY AND SELL RATES ARE BOTH DIVIDE RATES
     C*
     C     @@MDF1        IFEQ      'D'
     C     @@MDF2        ANDEQ     'D'
     C     @SPOT1        IFLE      @SPOT2
     C     @AMT7R        ANDGT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C     @SPOT1        IFGT      @SPOT2
     C     @AMT7R        ANDLT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C                   END
     C*
     C* VALIDATE WHEN BUY AND SELL RATES ARE MULTIPLY AND DIVIDE
     C*
     C     @@MDF1        IFEQ      'M'
     C     @@MDF2        ANDEQ     'D'
     C     1             DIV       @SPOT2        @WKSPT           13 8
     C     @SPOT1        IFLE      @WKSPT
     C     @AMT7R        ANDLT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C     @SPOT1        IFGT      @WKSPT
     C     @AMT7R        ANDGT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C                   END
     C*
     C* VALIDATE WHEN BUY AND SELL RATES ARE DIVIDE AND MULTIPLY
     C*
     C     @@MDF1        IFEQ      'D'
     C     @@MDF2        ANDEQ     'M'
     C     1             DIV       @SPOT1        @WKSPT
     C     @WKSPT        IFLE      @SPOT2
     C     @AMT7R        ANDLT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C     @WKSPT        IFGT      @SPOT2
     C     @AMT7R        ANDGT     @AMT8R
     C                   MOVE      'N'           AMTOK
     C                   END
     C                   END
     C*
     C** If error detected, check if both spot are similar (within ICD
     C** tolerance) and allow input in the two ways
     C*
     C     AMTOK         IFNE      'Y'
     C     @@MDF1        ANDEQ     @@MDF2                                       175229
     C     @SPOT1        DIV       @SPOT2        @WKSPT
     C     BNEXRT        DIV       100           @WKEXR           13 8
     C     1             ADD       @WKEXR        @WKCHP           13 8
     C     1             SUB       @WKEXR        @WKCHM           13 8
     C     @WKSPT        IFLE      @WKCHP
     C     @WKSPT        ANDGE     @WKCHM
     C                   MOVE      'Y'           AMTOK
     C                   END
     C                   END
      *                                                                                     AR808714
     C     AMTOK         IFNE      'Y'                                                      AR808714
     C     @AMT7         MULT(H)   @RRATE        @WPROD           15 0                      AR808714
     C     @AMT7         DIV(H)    @RRATE        @WQUOT           15 0                      AR808714
     C     @WPROD        IFEQ      @AMT8                                                    AR808714
     C     @WQUOT        OREQ      @AMT8                                                    AR808714
     C                   MOVE      'Y'           AMTOK                                      AR808714
     C                   ENDIF                                                              AR808714
     C                   ENDIF                                                              AR808714
      *                                                                                     AR808714
     C     AMTOK         IFNE      'Y'                                                      AR808714
     C     @AMT8         MULT(H)   @RRATE        @WPROD           15 0                      AR808714
     C     @AMT8         DIV(H)    @RRATE        @WQUOT           15 0                      AR808714
     C     @WPROD        IFEQ      @AMT7                                                    AR808714
     C     @WQUOT        OREQ      @AMT7                                                    AR808714
     C                   MOVE      'Y'           AMTOK                                      AR808714
     C                   ENDIF                                                              AR808714
     C                   ENDIF                                                              AR808714
      *                                                                         175229
     C     AMTOK         IFNE      'Y'                                          175229
     C     @@MDF1        ANDNE     @@MDF2                                       175229
     C     @SPOT1        MULT      @SPOT2        @WKSPT                         175229
     C     BNEXRT        DIV       100           @WKEXR           13 8          175229
     C**********         ADD       @WKEXR        @WKCHP           13 8                 175229 207744
     C**********         SUB       @WKEXR        @WKCHM           13 8                 175229 207744
     C     1             ADD       @WKEXR        @WKCHP           13 8                        207744
     C     1             SUB       @WKEXR        @WKCHM           13 8                        207744
     C     @WKSPT        IFLE      @WKCHP                                       175229
     C     @WKSPT        ANDGE     @WKCHM                                       175229
     C                   MOVE      'Y'           AMTOK                          175229
     C                   END                                                    175229
     C                   END                                                    175229
      *
      *                                                                                       238023
     C     AMTOK         IFNE      'Y'                                                        238023
     C     @AMT7         MULT(H)   @KRATE        @WPROD2          15 0                        238023
     C     @AMT7         DIV(H)    @KRATE        @WQUOT2          15 0                        238023
     C     @WPROD2       IFEQ      @AMT8                                                      238023
     C     @WQUOT2       OREQ      @AMT8                                                      238023
     C                   MOVE      'Y'           AMTOK                                        238023
     C                   END                                                                  238023
     C                   END                                                                  238023
      *                                                                                       238023
     C     AMTOK         IFNE      'Y'                                                        238023
     C     @AMT7         MULT(H)   W@INRT        @WPROD           15 0                        238023
     C     @AMT7         DIV(H)    W@INRT        @WQUOT           15 0                        238023
     C     @WPROD        IFEQ      @AMT8                                                      238023
     C     @WQUOT        OREQ      @AMT8                                                      238023
     C                   MOVE      'Y'           AMTOK                                        238023
     C                   END                                                                  238023
     C                   END                                                                  238023
      * SEND MESSAGE:
      * "** WARNING ** THE RATE IS NOT WITHIN THE SPECIFIED TOLERANCE"
      *
     C     RATOK         IFNE      'Y'
     C     DDRateOK      IFNE      'N'
     C                   MOVE      'W'           DDRateOK
     C                   END
     C                   ADD       1             WIx
     C**********         MOVEL     'DDRATE'      WFldNmXAr(WIx)                               224474
     C                   MOVEL     'DDRAT1'      WFldNmXAr(WIx)                               224474
     C                   MOVEL     'FXX0420'     WMsgIdXAr(WIx)
     C                   END
      *
      * SEND MESSAGE:
      * "BUY AND SELL AMOUNTS ARE INCORRECT"
      *
     C     AMTOK         IFNE      'Y'
     C                   MOVE      'N'           DDBamtOK
     C                   MOVE      'N'           DDSamtOK
     C                   ADD       1             Idx
     C**********         MOVEL     'DDRATE'      FldNamXAr(Idx)                               224474
     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                               224474
     C                   MOVEL     'FXM4003'     MsgIdXAr(Idx)
     C                   END
     C*
     C     #ZID9         ENDSR                                                  #ZID9 TAG
      *****************************************************************
      /EJECT
      *****************************************************************
      ** #ZIC1 - VALIDATE RATES WITH -VE OR +VE MARGINS
      ** OUTPUT from this subroutine: sign of margin
      *****************************************************************
     C     #ZIC1         BEGSR
      *
      *** First try ADDING the margin to the exchange rate
      *
     C                   Z-ADD     @@MGPT        @SMGPT
     C     W@ZIC         IFEQ      'A'
     C                   EXSR      #ZICA
     C                   ELSE
     C                   EXSR      #ZICB
     C                   END
      *
      *** If SAR S01453 is not installed
      *** or if margin points is zero
      *** exit from this routine
      *
     C     S01453        IFNE      'Y'
     C     @@MGPT        OREQ      0
     C                   GOTO      #ZIC19
     C                   END
      *
      *** If invalid, force validation to continue
      *
     C     W@MDIN        IFNE      'M'
     C     W@MDIN        ANDNE     'D'
     C                   MOVE      'X'           W@MDIN
     C                   END
      *
      *** If valid then exit
      *
     C     W@MDIN        IFNE      'X'
     C                   GOTO      #ZIC19
     C                   END
      *
      *** Now try SUBTRACTING the margin from the exchange rate
      *
     C                   Z-SUB     @@MGPT        @SMGPT
     C     W@ZIC         IFEQ      'A'
     C                   EXSR      #ZICA
     C                   ELSE
     C                   EXSR      #ZICB
     C                   END
      *
      *** If invalid, force validation to continue
      *
     C     W@MDIN        IFNE      'M'
     C     W@MDIN        ANDNE     'D'
     C                   MOVE      'X'           W@MDIN
     C                   Z-ADD     1             W@DFBD
     C                   Z-ADD     1             W@DFSD
     C                   Z-ADD     1             W@DFBM
     C                   Z-ADD     1             W@DFSM
     C                   Z-ADD     1             W@DIFB
     C                   Z-ADD     1             W@DIFS
     C                   END
     C*
     C     #ZIC19        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** #ZIC2 - VALIDATE RATES WITH -VE OR +VE MARGINS
      *****************************************************************
     C     #ZIC2         BEGSR
     C*
     C* If multiply/divide indicator is 'M' or not yet calculated
     C* this process will calculate it
     C*
     C     W@MDIN        IFNE      'D'
     C     W@MDIN        ANDNE     'M'                                                        238023
     C                   MOVE      'X'           W@MDIN
     C                   END
      *
      *** If not valid, try subtracting margin
      *
     C     W@MDIN        IFEQ      'X'
     C                   Z-SUB     @@MGPT        @SMGPT
     C                   Z-ADD     2             @@K
     C     W@ZIC         IFEQ      'A'
     C                   EXSR      #ZICA
     C                   Z-ADD     3             @@K
     C                   EXSR      #ZICA
     C                   ELSE
     C                   EXSR      #ZICB
     C                   Z-ADD     3             @@K
     C                   EXSR      #ZICB
     C                   END
     C                   END
      *
      *** If invalid, force validation to continue
      *
     C     W@MDIN        IFNE      'M'
     C     W@MDIN        ANDNE     'D'                                                        238023
     C                   MOVE      'X'           W@MDIN
     C                   END
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** #ZICA - VALIDATE EXCHANGE RATE V. SPOT FOR BASE CCY DEAL
      *****************************************************************
     C     #ZICA         BEGSR
     C*
     C** Obtain Tolerance Amount of High/Low Spot Rate
     C*
     C     @@HISP        MULT      TOLRAN        @@HS10           13 8
     C     @@LOSP        MULT      TOLRAN        @@LS10           13 8
     C*
     C* Obtain +/-(Tolerance Amount) of High/Low Spot rate :
     C*
     C     @@HISP        ADD       @@HS10        @@SPHI           13 8          HiSpot + 10%
     C     @@LOSP        SUB       @@LS10        @@SPLO           13 8          LoSpot - 10%
     C*
     C** Calculate the inverse of the +/- tolerance of high/low spot rates
     C*
     C     1             DIV(H)    @@SPHI        @@ISHI           13 8
     C     1             DIV(H)    @@SPLO        @@ISLO           13 8
     C*
     C* Descale the input exchange rate
     C*
     C     W@INRT        DIV(H)    @SF(W@SFAC)   @SRATE           13 8            Descaled Rate
     C*
     C* If the normally quoted decimal places is not zero
     C* Add (adjusted) forward points to margin
     C*
     C     W@NQDP        IFNE      0
     C     @@FPNT        DIV(H)    @AD(W@NQDP)   @RRATE                         Adjust Fwd/Pts
     C     S01453        IFEQ      'Y'                                          S01453 installd
     C                   Z-ADD     @RRATE        @XRATE                         Save
     C     @SMGPT        DIV(H)    @AD(W@NQDP)   @@MADJ           13 8          Adjust margin
     C                   ADD       @@MADJ        @RRATE                         Margin+Fwd/Pts
     C                   END
     C                   END
     C*
     C* If the normally quoted decimal places is zero
     C* Add forward points to margin
     C*
     C     W@NQDP        IFEQ      0
     C                   Z-ADD     @@FPNT        @RRATE                         Fwd/Pts
     C     S01453        IFEQ      'Y'
     C                   Z-ADD     @RRATE        @XRATE                         Save
     C                   ADD       @SMGPT        @RRATE                         Margin+Fwd/Pts
     C                   END
     C                   END
     C*
     C* Descale margin + forward points
     c*
     C                   DIV       @SF(W@SFAC)   @RRATE
      *                                                                                       240038
     C                   Z-ADD     @RRATE        @RATEA           13 8                        240038
     C                   Z-ADD     @RRATE        @RATEB           13 8                        240038
     C                   Z-ADD     @RRATE        @RATEV           13 8                        240038
     C     @RATEV        IFLT      0                                                          240038
     C                   MULT      -1            @RATEV                                       240038
     C                   ENDIF                                                                240038
     C*
     C* Add descaled exchange rate to descaled margin + forward points
     C* to get the outright descaled rate
     C*
     C                   ADD       @SRATE        @RRATE           13 8
     C     @SRATE        ADD       @RATEA        @RATEC           13 8                        240038
     C     @SRATE        SUB       @RATEB        @RATED           13 8                        240038
      *                                                                                     BUG23668
     C**********         IF        CER043 = 'Y' AND DDREIN = 'Y'                   BUG23668 BUG25418
     C**********         EVAL(H)   @RRATE = 1/@RRATE                               BUG23668 BUG25418
     C**********         ENDIF                                                     BUG23668 BUG25418
      *                                                                                     BUG23668
     C*
     C* Descale forward points and add descaled exchange rate to it
     C* to obtain descaled forward rate
     C*
     C     S01453        IFEQ      'Y'                                          S01453 installd
     C                   DIV       @SF(W@SFAC)   @XRATE                         Descale Fwd/Pts
     C                   ADD       @SRATE        @XRATE           13 8          Fwd Rate
     C                   END
     C*
     C*----------------------------------------------------------------
     C*
     C** Check Exchange Rate against Spot range
     C** Allow for the input of inverse rates by using the inverse
     C** exchange rate limits. If the inverse rate is input,
     C** invert the multiply/divide indicator value.
     C*
     C                   MOVE      'N'           W@RTOK            1
     C*
     C* OK if descaled rate is GE low spot rate and LE high spot rate
     C*
     C     @SRATE        IFGE      @@SPLO
     C     @SRATE        ANDLE     @@SPHI
     C                   MOVE      'Y'           W@RTOK
     C                   END
     C*
     C* OK if descaled rate is GE low inv spot rte and LE high inv spot rte
     C*
     C     @SRATE        IFGE      @@ISHI
     C     @SRATE        ANDLE     @@ISLO
     C                   MOVE      'Y'           W@RTOK
     C     @@XRMD        IFEQ      'M'                                          invert the rate
     C                   MOVE      'D'           @@XRMD                         by flipping
     C                   ELSE                                                   the M/D ind
     C                   MOVE      'M'           @@XRMD
     C                   END
     C                   END
     C*
     C* If rate is not OK, format low & high spot rates for message
     C*
     C     W@RTOK        IFEQ      'N'
     C                   Z-ADD     *ZERO         W@AMNT                           ¦ Initialise
     C                   MOVE      *BLANK        M@MGDA                           ¦ fields
     C                   Z-ADD     8             W@DECP            1 0            ¦
     C     @@SPLO        MULT      @SF(W@SFAC)   W@AMTR                           I:Low Rate
     C                   EXSR      #ZICC                                          <Convert>
     C                   MOVEA     @Y(P1)        M@0115                           O:To msg.data
     C     @@SPHI        MULT      @SF(W@SFAC)   W@AMTR                           I:High Rate
     C                   EXSR      #ZICC                                          <Convert>
     C                   MOVEA     @Y(P1)        M@1630                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD3           45              Stack Msg.Dta
     C                   END
     C*
     C*----------------------------------------------------------------
     C*
     C* If rate is not OK
     C*
     C     W@RTOK        IFEQ      'N'
     C*
     C* If either currency is the base currency for accounting
     C*
     C     DDBCCY        IFEQ      BJCYCD
     C     DDSCCY        OREQ      BJCYCD
     C*
     C* Set spot rate to that of currency which is the base currency
     C*
     C     DDBCCY        IFEQ      BJCYCD
     C                   Z-ADD     @SPOT2        @@SPTR           13 8
     C                   ELSE
     C                   Z-ADD     @SPOT1        @@SPTR
     C                   END
     C*
     C** Obtain Tolerance Amount of Spot Rate
     C*
     C     @@SPTR        MULT      TOLRAN        @@SR10           13 8
     C*
     C* Obtain +/-(Tolerance Amount) of Spot rate
     C*
     C     @@SPTR        ADD       @@SR10        @@SPHI           13 8          Spot + 10%
     C     @@SPTR        SUB       @@SR10        @@SPLO           13 8          Spot - 10%
     C*
     C** Calculate the inverse of the +/- tolerance of high/low spot rates
     C*
     C     1             DIV(H)    @@SPHI        @@ISHI           13 8
     C     1             DIV(H)    @@SPLO        @@ISLO           13 8
     C*
     C* OK if low spot rate is LT spot rate and high spot rate GT spot rate
     C*
     C     @@SPLO        IFLT      @SRATE
     C     @@SPHI        ANDGT     @SRATE
     C                   MOVE      'Y'           W@RTOK
     C                   END
     C*
     C* OK if spt rate is GE inv high spt rte and spt rate LE inv low spt rt
     C*
     C     @SRATE        IFGE      @@ISHI
     C     @SRATE        ANDLE     @@ISLO
     C                   MOVE      'Y'           W@RTOK
     C     @@XRMD        IFEQ      'M'                                          invert the rate
     C                   MOVE      'D'           @@XRMD                         by flipping
     C                   ELSE                                                   the M/D ind
     C                   MOVE      'M'           @@XRMD
     C                   END
     C                   END
     C*
     C                   END                                                    DDBCCY = BJCYCD
     C                   END                                                    W@RTOK = N
     C*
     C*----------------------------------------------------------------
      *
      ** Set up variables used in 'difference' calculations below
      ** (difference is between actual 'other' currency amount
      **  and calculated 'other' currency amount (amount x or / rate))
      *
     C     @@CDP1        COMP      0                                      90      Dec.place=0
     C     @@CDP1        COMP      1                                      91      Dec.place=1
     C     @@CDP1        COMP      2                                      92      Dec.place=2
     C     @@CDP1        COMP      3                                      93      Dec.place=3
     C     @@CDP2        COMP      0                                      94      Dec.place=0
     C     @@CDP2        COMP      1                                      95      Dec.place=1
     C     @@CDP2        COMP      2                                      96      Dec.place=2
     C     @@CDP2        COMP      3                                      97      Dec.place=3
     C*
     C     @@DAM1        IFLT      0                                                           DT001
     C                   Z-SUB     @@DAM1        W@1150                           15,0 Base AmtDT001
     C                   ELSE                                                                  DT001
     C                   Z-ADD     @@DAM1        W@1150                           15,0 Base AmtDT001
     C                   END                                                                   DT001
     C     @@DAM2        IFLT      0                                                           DT001
     C                   Z-SUB     @@DAM2        W@2150                           15,0 Base AmtDT001
     C                   ELSE                                                                  DT001
     C                   Z-ADD     @@DAM2        W@2150                           15,0 N/B Amt DT001
     C                   END                                                                   DT001
      *                                                                                       240038
      ** If the margin buy/sell indicator is "B" and buy currency is                          240038
      ** equal to the dealing base currency.                                                  240038
      *                                                                                       240038
     C     F3MGBS        IFEQ      'B'                                                        240038
     C     DDBCCY        ANDEQ     BNCYDL                                                     240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with zero decimal place.                                               240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6150           15 0                        240038
     C     W@1151        DIV(H)    @RATEC        W@6151           15 0                        240038
     C     W@1152        DIV(H)    @RATEC        W@6152           15 0                        240038
     C     W@1153        DIV(H)    @RATEC        W@6153           15 0                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6150                                       240038
     C                   MULT      10            W@6151                                       240038
     C                   MULT      10            W@6152                                       240038
     C                   MULT      10            W@6153                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6150                                       240038
     C                   MULT      100           W@6151                                       240038
     C                   MULT      100           W@6152                                       240038
     C                   MULT      100           W@6153                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6150                                       240038
     C                   MULT      1000          W@6151                                       240038
     C                   MULT      1000          W@6152                                       240038
     C                   MULT      1000          W@6153                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with one  decimal place.                                               240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6154           15 1                        240038
     C     W@1151        DIV(H)    @RATEC        W@6155           15 1                        240038
     C     W@1152        DIV(H)    @RATEC        W@6156           15 1                        240038
     C     W@1153        DIV(H)    @RATEC        W@6157           15 1                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6154                                       240038
     C                   MULT      10            W@6155                                       240038
     C                   MULT      10            W@6156                                       240038
     C                   MULT      10            W@6157                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6154                                       240038
     C                   MULT      100           W@6155                                       240038
     C                   MULT      100           W@6156                                       240038
     C                   MULT      100           W@6157                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6154                                       240038
     C                   MULT      1000          W@6155                                       240038
     C                   MULT      1000          W@6156                                       240038
     C                   MULT      1000          W@6157                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with two  decimal place.                                               240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6158           15 2                        240038
     C     W@1151        DIV(H)    @RATEC        W@6159           15 2                        240038
     C     W@1152        DIV(H)    @RATEC        W@6160           15 2                        240038
     C     W@1153        DIV(H)    @RATEC        W@6161           15 2                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6158                                       240038
     C                   MULT      10            W@6159                                       240038
     C                   MULT      10            W@6160                                       240038
     C                   MULT      10            W@6161                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6158                                       240038
     C                   MULT      100           W@6159                                       240038
     C                   MULT      100           W@6160                                       240038
     C                   MULT      100           W@6161                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6158                                       240038
     C                   MULT      1000          W@6159                                       240038
     C                   MULT      1000          W@6160                                       240038
     C                   MULT      1000          W@6161                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with three decimal place.                                              240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6162           15 3                        240038
     C     W@1151        DIV(H)    @RATEC        W@6163           15 3                        240038
     C     W@1152        DIV(H)    @RATEC        W@6164           15 3                        240038
     C     W@1153        DIV(H)    @RATEC        W@6165           15 3                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6162                                       240038
     C                   MULT      10            W@6163                                       240038
     C                   MULT      10            W@6164                                       240038
     C                   MULT      10            W@6165                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6162                                       240038
     C                   MULT      100           W@6163                                       240038
     C                   MULT      100           W@6164                                       240038
     C                   MULT      100           W@6165                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6162                                       240038
     C                   MULT      1000          W@6163                                       240038
     C                   MULT      1000          W@6164                                       240038
     C                   MULT      1000          W@6165                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
      ** is then assign a Divide rate to W@MDIN.                                              240038
      *                                                                                       240038
     C     W@6150        IFEQ      W@2150                                                     240038
     C     W@6151        OREQ      W@2150                                                     240038
     C     W@6152        OREQ      W@2150                                                     240038
     C     W@6153        OREQ      W@2150                                                     240038
     C     W@6154        OREQ      W@2150                                                     240038
     C     W@6155        OREQ      W@2150                                                     240038
     C     W@6156        OREQ      W@2150                                                     240038
     C     W@6157        OREQ      W@2150                                                     240038
     C     W@6158        OREQ      W@2150                                                     240038
     C     W@6159        OREQ      W@2150                                                     240038
     C     W@6160        OREQ      W@2150                                                     240038
     C     W@6161        OREQ      W@2150                                                     240038
     C     W@6162        OREQ      W@2150                                                     240038
     C     W@6163        OREQ      W@2150                                                     240038
     C     W@6164        OREQ      W@2150                                                     240038
     C     W@6165        OREQ      W@2150                                                     240038
     C                   MOVE      'D'           W@MDIN                                       240038
     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
     C                   ELSE                                                                 240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with zero decimal place.                                           240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7150           15 0                        240038
     C     W@1151        MULT(H)   @RATED        W@7151           15 0                        240038
     C     W@1152        MULT(H)   @RATED        W@7152           15 0                        240038
     C     W@1153        MULT(H)   @RATED        W@7153           15 0                        240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with one decimal place.                                            240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7154           15 1                        240038
     C     W@1151        MULT(H)   @RATED        W@7155           15 1                        240038
     C     W@1152        MULT(H)   @RATED        W@7156           15 1                        240038
     C     W@1153        MULT(H)   @RATED        W@7157           15 1                        240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with two decimal place.                                            240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7158           15 2                        240038
     C     W@1151        MULT(H)   @RATED        W@7159           15 2                        240038
     C     W@1152        MULT(H)   @RATED        W@7160           15 2                        240038
     C     W@1153        MULT(H)   @RATED        W@7161           15 2                        240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with three decimal place.                                          240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7162           15 3                        240038
     C     W@1151        MULT(H)   @RATED        W@7163           15 3                        240038
     C     W@1152        MULT(H)   @RATED        W@7164           15 3                        240038
     C     W@1153        MULT(H)   @RATED        W@7165           15 3                        240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
      ** is then assign a Multiply rate to W@MDIN.                                            240038
      *                                                                                       240038
     C     W@7150        IFEQ      W@2150                                                     240038
     C     W@7151        OREQ      W@2150                                                     240038
     C     W@7152        OREQ      W@2150                                                     240038
     C     W@7153        OREQ      W@2150                                                     240038
     C     W@7154        OREQ      W@2150                                                     240038
     C     W@7155        OREQ      W@2150                                                     240038
     C     W@7156        OREQ      W@2150                                                     240038
     C     W@7157        OREQ      W@2150                                                     240038
     C     W@7158        OREQ      W@2150                                                     240038
     C     W@7159        OREQ      W@2150                                                     240038
     C     W@7160        OREQ      W@2150                                                     240038
     C     W@7161        OREQ      W@2150                                                     240038
     C     W@7162        OREQ      W@2150                                                     240038
     C     W@7163        OREQ      W@2150                                                     240038
     C     W@7164        OREQ      W@2150                                                     240038
     C     W@7165        OREQ      W@2150                                                     240038
     C                   MOVE      'M'           W@MDIN                                       240038
     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
      *                                                                                       240038
      ** If the margin buy/sell indicator is "B" and sell currency is                         240038
      ** equal to the dealing base currency.                                                  240038
      *                                                                                       240038
     C     F3MGBS        IFEQ      'B'                                                        240038
     C     DDSCCY        ANDEQ     BNCYDL                                                     240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with zero decimal place.                                               240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6150                                       240038
     C     W@2151        DIV(H)    @RATEC        W@6151                                       240038
     C     W@2152        DIV(H)    @RATEC        W@6152                                       240038
     C     W@2153        DIV(H)    @RATEC        W@6153                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6150                                       240038
     C                   MULT      10            W@6151                                       240038
     C                   MULT      10            W@6152                                       240038
     C                   MULT      10            W@6153                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6150                                       240038
     C                   MULT      100           W@6151                                       240038
     C                   MULT      100           W@6152                                       240038
     C                   MULT      100           W@6153                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6150                                       240038
     C                   MULT      1000          W@6151                                       240038
     C                   MULT      1000          W@6152                                       240038
     C                   MULT      1000          W@6153                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with one  decimal place.                                               240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6154                                       240038
     C     W@2151        DIV(H)    @RATEC        W@6155                                       240038
     C     W@2152        DIV(H)    @RATEC        W@6156                                       240038
     C     W@2153        DIV(H)    @RATEC        W@6157                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6154                                       240038
     C                   MULT      10            W@6155                                       240038
     C                   MULT      10            W@6156                                       240038
     C                   MULT      10            W@6157                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6154                                       240038
     C                   MULT      100           W@6155                                       240038
     C                   MULT      100           W@6156                                       240038
     C                   MULT      100           W@6157                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6154                                       240038
     C                   MULT      1000          W@6155                                       240038
     C                   MULT      1000          W@6156                                       240038
     C                   MULT      1000          W@6157                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with two  decimal place.                                               240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6158                                       240038
     C     W@2151        DIV(H)    @RATEC        W@6159                                       240038
     C     W@2152        DIV(H)    @RATEC        W@6160                                       240038
     C     W@2153        DIV(H)    @RATEC        W@6161                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6158                                       240038
     C                   MULT      10            W@6159                                       240038
     C                   MULT      10            W@6160                                       240038
     C                   MULT      10            W@6161                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6158                                       240038
     C                   MULT      100           W@6159                                       240038
     C                   MULT      100           W@6160                                       240038
     C                   MULT      100           W@6161                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6158                                       240038
     C                   MULT      1000          W@6159                                       240038
     C                   MULT      1000          W@6160                                       240038
     C                   MULT      1000          W@6161                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide buy amount in different decimal places against +rate and store value          240038
      ** to a variable with three decimal place.                                              240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6162                                       240038
     C     W@2151        DIV(H)    @RATEC        W@6163                                       240038
     C     W@2152        DIV(H)    @RATEC        W@6164                                       240038
     C     W@2153        DIV(H)    @RATEC        W@6165                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6162                                       240038
     C                   MULT      10            W@6163                                       240038
     C                   MULT      10            W@6164                                       240038
     C                   MULT      10            W@6165                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6162                                       240038
     C                   MULT      100           W@6163                                       240038
     C                   MULT      100           W@6164                                       240038
     C                   MULT      100           W@6165                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6162                                       240038
     C                   MULT      1000          W@6163                                       240038
     C                   MULT      1000          W@6164                                       240038
     C                   MULT      1000          W@6165                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
      ** is then assign a Divide rate to W@MDIN.                                              240038
      *                                                                                       240038
     C     W@6150        IFEQ      W@1150                                                     240038
     C     W@6151        OREQ      W@1150                                                     240038
     C     W@6152        OREQ      W@1150                                                     240038
     C     W@6153        OREQ      W@1150                                                     240038
     C     W@6154        OREQ      W@1150                                                     240038
     C     W@6155        OREQ      W@1150                                                     240038
     C     W@6156        OREQ      W@1150                                                     240038
     C     W@6157        OREQ      W@1150                                                     240038
     C     W@6158        OREQ      W@1150                                                     240038
     C     W@6159        OREQ      W@1150                                                     240038
     C     W@6160        OREQ      W@1150                                                     240038
     C     W@6161        OREQ      W@1150                                                     240038
     C     W@6162        OREQ      W@1150                                                     240038
     C     W@6163        OREQ      W@1150                                                     240038
     C     W@6164        OREQ      W@1150                                                     240038
     C     W@6165        OREQ      W@1150                                                     240038
     C                   MOVE      'D'           W@MDIN                                       240038
     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
     C                   ELSE                                                                 240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with zero decimal place.                                           240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7150                                       240038
     C     W@2151        MULT(H)   @RATED        W@7151                                       240038
     C     W@2152        MULT(H)   @RATED        W@7152                                       240038
     C     W@2153        MULT(H)   @RATED        W@7153                                       240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with one decimal place.                                            240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7154                                       240038
     C     W@2151        MULT(H)   @RATED        W@7155                                       240038
     C     W@2152        MULT(H)   @RATED        W@7156                                       240038
     C     W@2153        MULT(H)   @RATED        W@7157                                       240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with two decimal place.                                            240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7158                                       240038
     C     W@2151        MULT(H)   @RATED        W@7159                                       240038
     C     W@2152        MULT(H)   @RATED        W@7160                                       240038
     C     W@2153        MULT(H)   @RATED        W@7161                                       240038
      *                                                                                       240038
      ** Multiply the buy amount with different decimal places against -rate and store        240038
      ** value to variable with three decimal place.                                          240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7162                                       240038
     C     W@2151        MULT(H)   @RATED        W@7163                                       240038
     C     W@2152        MULT(H)   @RATED        W@7164                                       240038
     C     W@2153        MULT(H)   @RATED        W@7165                                       240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
      ** is then assign a Multiply rate to W@MDIN.                                            240038
      *                                                                                       240038
     C     W@7150        IFEQ      W@1150                                                     240038
     C     W@7151        OREQ      W@1150                                                     240038
     C     W@7152        OREQ      W@1150                                                     240038
     C     W@7153        OREQ      W@1150                                                     240038
     C     W@7154        OREQ      W@1150                                                     240038
     C     W@7155        OREQ      W@1150                                                     240038
     C     W@7156        OREQ      W@1150                                                     240038
     C     W@7157        OREQ      W@1150                                                     240038
     C     W@7158        OREQ      W@1150                                                     240038
     C     W@7159        OREQ      W@1150                                                     240038
     C     W@7160        OREQ      W@1150                                                     240038
     C     W@7161        OREQ      W@1150                                                     240038
     C     W@7162        OREQ      W@1150                                                     240038
     C     W@7163        OREQ      W@1150                                                     240038
     C     W@7164        OREQ      W@1150                                                     240038
     C     W@7165        OREQ      W@1150                                                     240038
     C                   MOVE      'M'           W@MDIN                                       240038
     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
      *                                                                                       240038
      ** If the margin buy/sell indicator used is "S" and buy currency                        240038
      ** is equal to the dealing base currency.                                               240038
      *                                                                                       240038
     C     F3MGBS        IFEQ      'S'                                                        240038
     C     DDBCCY        ANDEQ     BNCYDL                                                     240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with zero decimal place.                                               240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6250           15 0                        240038
     C     W@2151        DIV(H)    @RATEC        W@6251           15 0                        240038
     C     W@2152        DIV(H)    @RATEC        W@6252           15 0                        240038
     C     W@2153        DIV(H)    @RATEC        W@6253           15 0                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6250                                       240038
     C                   MULT      10            W@6251                                       240038
     C                   MULT      10            W@6252                                       240038
     C                   MULT      10            W@6253                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6250                                       240038
     C                   MULT      100           W@6251                                       240038
     C                   MULT      100           W@6252                                       240038
     C                   MULT      100           W@6253                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6250                                       240038
     C                   MULT      1000          W@6251                                       240038
     C                   MULT      1000          W@6252                                       240038
     C                   MULT      1000          W@6253                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with one  decimal place.                                               240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6254           15 1                        240038
     C     W@2151        DIV(H)    @RATEC        W@6255           15 1                        240038
     C     W@2152        DIV(H)    @RATEC        W@6256           15 1                        240038
     C     W@2153        DIV(H)    @RATEC        W@6257           15 1                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6254                                       240038
     C                   MULT      10            W@6255                                       240038
     C                   MULT      10            W@6256                                       240038
     C                   MULT      10            W@6257                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6254                                       240038
     C                   MULT      100           W@6255                                       240038
     C                   MULT      100           W@6256                                       240038
     C                   MULT      100           W@6257                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6254                                       240038
     C                   MULT      1000          W@6255                                       240038
     C                   MULT      1000          W@6256                                       240038
     C                   MULT      1000          W@6257                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with two  decimal place.                                               240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6258           15 2                        240038
     C     W@2151        DIV(H)    @RATEC        W@6259           15 2                        240038
     C     W@2152        DIV(H)    @RATEC        W@6260           15 2                        240038
     C     W@2153        DIV(H)    @RATEC        W@6261           15 2                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6258                                       240038
     C                   MULT      10            W@6259                                       240038
     C                   MULT      10            W@6260                                       240038
     C                   MULT      10            W@6261                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6258                                       240038
     C                   MULT      100           W@6259                                       240038
     C                   MULT      100           W@6260                                       240038
     C                   MULT      100           W@6261                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6258                                       240038
     C                   MULT      1000          W@6259                                       240038
     C                   MULT      1000          W@6260                                       240038
     C                   MULT      1000          W@6261                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with three decimal place.                                              240038
      *                                                                                       240038
     C     W@2150        DIV(H)    @RATEC        W@6262           15 3                        240038
     C     W@2151        DIV(H)    @RATEC        W@6263           15 3                        240038
     C     W@2152        DIV(H)    @RATEC        W@6264           15 3                        240038
     C     W@2153        DIV(H)    @RATEC        W@6265           15 3                        240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP1        WHENEQ    1                                                          240038
     C                   MULT      10            W@6262                                       240038
     C                   MULT      10            W@6263                                       240038
     C                   MULT      10            W@6264                                       240038
     C                   MULT      10            W@6265                                       240038
     C     @@CDP1        WHENEQ    2                                                          240038
     C                   MULT      100           W@6262                                       240038
     C                   MULT      100           W@6263                                       240038
     C                   MULT      100           W@6264                                       240038
     C                   MULT      100           W@6265                                       240038
     C     @@CDP1        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6262                                       240038
     C                   MULT      1000          W@6263                                       240038
     C                   MULT      1000          W@6264                                       240038
     C                   MULT      1000          W@6265                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
      ** is then assign a Multiply rate to W@MDIN.                                            240038
      *                                                                                       240038
     C     W@6250        IFEQ      W@1150                                                     240038
     C     W@6251        OREQ      W@1150                                                     240038
     C     W@6252        OREQ      W@1150                                                     240038
     C     W@6253        OREQ      W@1150                                                     240038
     C     W@6254        OREQ      W@1150                                                     240038
     C     W@6255        OREQ      W@1150                                                     240038
     C     W@6256        OREQ      W@1150                                                     240038
     C     W@6257        OREQ      W@1150                                                     240038
     C     W@6258        OREQ      W@1150                                                     240038
     C     W@6259        OREQ      W@1150                                                     240038
     C     W@6260        OREQ      W@1150                                                     240038
     C     W@6261        OREQ      W@1150                                                     240038
     C     W@6262        OREQ      W@1150                                                     240038
     C     W@6263        OREQ      W@1150                                                     240038
     C     W@6264        OREQ      W@1150                                                     240038
     C     W@6265        OREQ      W@1150                                                     240038
     C                   MOVE      'D'           W@MDIN                                       240038
     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
     C                   ELSE                                                                 240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with zero decimal place.                                           240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7250           15 0                        240038
     C     W@2151        MULT(H)   @RATED        W@7251           15 0                        240038
     C     W@2152        MULT(H)   @RATED        W@7252           15 0                        240038
     C     W@2153        MULT(H)   @RATED        W@7253           15 0                        240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with one decimal place.                                            240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7254           15 1                        240038
     C     W@2151        MULT(H)   @RATED        W@7255           15 1                        240038
     C     W@2152        MULT(H)   @RATED        W@7256           15 1                        240038
     C     W@2153        MULT(H)   @RATED        W@7257           15 1                        240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with two decimal place.                                            240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7258           15 2                        240038
     C     W@2151        MULT(H)   @RATED        W@7259           15 2                        240038
     C     W@2152        MULT(H)   @RATED        W@7260           15 2                        240038
     C     W@2153        MULT(H)   @RATED        W@7261           15 2                        240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with thre decimal place.                                           240038
      *                                                                                       240038
     C     W@2150        MULT(H)   @RATED        W@7262           15 3                        240038
     C     W@2151        MULT(H)   @RATED        W@7263           15 3                        240038
     C     W@2152        MULT(H)   @RATED        W@7264           15 3                        240038
     C     W@2153        MULT(H)   @RATED        W@7265           15 3                        240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
      ** is then assign a Multiply rate to W@MDIN.                                            240038
      *                                                                                       240038
     C     W@7250        IFEQ      W@1150                                                     240038
     C     W@7251        OREQ      W@1150                                                     240038
     C     W@7252        OREQ      W@1150                                                     240038
     C     W@7253        OREQ      W@1150                                                     240038
     C     W@7254        OREQ      W@1150                                                     240038
     C     W@7255        OREQ      W@1150                                                     240038
     C     W@7256        OREQ      W@1150                                                     240038
     C     W@7257        OREQ      W@1150                                                     240038
     C     W@7258        OREQ      W@1150                                                     240038
     C     W@7259        OREQ      W@1150                                                     240038
     C     W@7260        OREQ      W@1150                                                     240038
     C     W@7261        OREQ      W@1150                                                     240038
     C     W@7262        OREQ      W@1150                                                     240038
     C     W@7263        OREQ      W@1150                                                     240038
     C     W@7264        OREQ      W@1150                                                     240038
     C     W@7265        OREQ      W@1150                                                     240038
     C                   MOVE      'M'           W@MDIN                                       240038
     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
      *                                                                                       240038
      ** If the margin buy/sell indicator used is "S" sell currency is                        240038
      ** equal to the dealing base currency.                                                  240038
      *                                                                                       240038
     C     F3MGBS        IFEQ      'S'                                                        240038
     C     DDSCCY        ANDEQ     BNCYDL                                                     240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with zero decimal place.                                               240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6250                                       240038
     C     W@1151        DIV(H)    @RATEC        W@6251                                       240038
     C     W@1152        DIV(H)    @RATEC        W@6252                                       240038
     C     W@1153        DIV(H)    @RATEC        W@6253                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6250                                       240038
     C                   MULT      10            W@6251                                       240038
     C                   MULT      10            W@6252                                       240038
     C                   MULT      10            W@6253                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6250                                       240038
     C                   MULT      100           W@6251                                       240038
     C                   MULT      100           W@6252                                       240038
     C                   MULT      100           W@6253                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6250                                       240038
     C                   MULT      1000          W@6251                                       240038
     C                   MULT      1000          W@6252                                       240038
     C                   MULT      1000          W@6253                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with one  decimal place.                                               240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6254                                       240038
     C     W@1151        DIV(H)    @RATEC        W@6255                                       240038
     C     W@1152        DIV(H)    @RATEC        W@6256                                       240038
     C     W@1153        DIV(H)    @RATEC        W@6257                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6254                                       240038
     C                   MULT      10            W@6255                                       240038
     C                   MULT      10            W@6256                                       240038
     C                   MULT      10            W@6257                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6254                                       240038
     C                   MULT      100           W@6255                                       240038
     C                   MULT      100           W@6256                                       240038
     C                   MULT      100           W@6257                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6254                                       240038
     C                   MULT      1000          W@6255                                       240038
     C                   MULT      1000          W@6256                                       240038
     C                   MULT      1000          W@6257                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with two  decimal place.                                               240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6258                                       240038
     C     W@1151        DIV(H)    @RATEC        W@6259                                       240038
     C     W@1152        DIV(H)    @RATEC        W@6260                                       240038
     C     W@1153        DIV(H)    @RATEC        W@6261                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6258                                       240038
     C                   MULT      10            W@6259                                       240038
     C                   MULT      10            W@6260                                       240038
     C                   MULT      10            W@6261                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6258                                       240038
     C                   MULT      100           W@6259                                       240038
     C                   MULT      100           W@6260                                       240038
     C                   MULT      100           W@6261                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6258                                       240038
     C                   MULT      1000          W@6259                                       240038
     C                   MULT      1000          W@6260                                       240038
     C                   MULT      1000          W@6261                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Divide sell amount in different decimal places against +rate and store value         240038
      ** to a variable with three decimal place.                                              240038
      *                                                                                       240038
     C     W@1150        DIV(H)    @RATEC        W@6262                                       240038
     C     W@1151        DIV(H)    @RATEC        W@6263                                       240038
     C     W@1152        DIV(H)    @RATEC        W@6264                                       240038
     C     W@1153        DIV(H)    @RATEC        W@6265                                       240038
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @@CDP2        WHENEQ    1                                                          240038
     C                   MULT      10            W@6262                                       240038
     C                   MULT      10            W@6263                                       240038
     C                   MULT      10            W@6264                                       240038
     C                   MULT      10            W@6265                                       240038
     C     @@CDP2        WHENEQ    2                                                          240038
     C                   MULT      100           W@6262                                       240038
     C                   MULT      100           W@6263                                       240038
     C                   MULT      100           W@6264                                       240038
     C                   MULT      100           W@6265                                       240038
     C     @@CDP2        WHENEQ    3                                                          240038
     C                   MULT      1000          W@6262                                       240038
     C                   MULT      1000          W@6263                                       240038
     C                   MULT      1000          W@6264                                       240038
     C                   MULT      1000          W@6265                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
      ** is then assign a Multiply rate to W@MDIN.                                            240038
      *                                                                                       240038
     C     W@6250        IFEQ      W@2150                                                     240038
     C     W@6251        OREQ      W@2150                                                     240038
     C     W@6252        OREQ      W@2150                                                     240038
     C     W@6253        OREQ      W@2150                                                     240038
     C     W@6254        OREQ      W@2150                                                     240038
     C     W@6255        OREQ      W@2150                                                     240038
     C     W@6256        OREQ      W@2150                                                     240038
     C     W@6257        OREQ      W@2150                                                     240038
     C     W@6258        OREQ      W@2150                                                     240038
     C     W@6259        OREQ      W@2150                                                     240038
     C     W@6260        OREQ      W@2150                                                     240038
     C     W@6261        OREQ      W@2150                                                     240038
     C     W@6262        OREQ      W@2150                                                     240038
     C     W@6263        OREQ      W@2150                                                     240038
     C     W@6264        OREQ      W@2150                                                     240038
     C     W@6265        OREQ      W@2150                                                     240038
     C                   MOVE      'D'           W@MDIN                                       240038
     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
     C                   ELSE                                                                 240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with zero decimal place.                                           240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7250                                       240038
     C     W@1151        MULT(H)   @RATED        W@7251                                       240038
     C     W@1152        MULT(H)   @RATED        W@7252                                       240038
     C     W@1153        MULT(H)   @RATED        W@7253                                       240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with one decimal place.                                            240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7254                                       240038
     C     W@1151        MULT(H)   @RATED        W@7255                                       240038
     C     W@1152        MULT(H)   @RATED        W@7256                                       240038
     C     W@1153        MULT(H)   @RATED        W@7257                                       240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with two decimal place.                                            240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7258                                       240038
     C     W@1151        MULT(H)   @RATED        W@7259                                       240038
     C     W@1152        MULT(H)   @RATED        W@7260                                       240038
     C     W@1153        MULT(H)   @RATED        W@7261                                       240038
      *                                                                                       240038
      ** Multiply the sell amount with different decimal places against -rate and store       240038
      ** value to variable with thre decimal place.                                           240038
      *                                                                                       240038
     C     W@1150        MULT(H)   @RATED        W@7262                                       240038
     C     W@1151        MULT(H)   @RATED        W@7263                                       240038
     C     W@1152        MULT(H)   @RATED        W@7264                                       240038
     C     W@1153        MULT(H)   @RATED        W@7265                                       240038
      *                                                                                       240038
      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
      ** is then assign a Multiply rate to W@MDIN.                                            240038
      *                                                                                       240038
     C     W@7250        IFEQ      W@2150                                                     240038
     C     W@7251        OREQ      W@2150                                                     240038
     C     W@7252        OREQ      W@2150                                                     240038
     C     W@7253        OREQ      W@2150                                                     240038
     C     W@7254        OREQ      W@2150                                                     240038
     C     W@7255        OREQ      W@2150                                                     240038
     C     W@7256        OREQ      W@2150                                                     240038
     C     W@7257        OREQ      W@2150                                                     240038
     C     W@7258        OREQ      W@2150                                                     240038
     C     W@7259        OREQ      W@2150                                                     240038
     C     W@7260        OREQ      W@2150                                                     240038
     C     W@7261        OREQ      W@2150                                                     240038
     C     W@7262        OREQ      W@2150                                                     240038
     C     W@7263        OREQ      W@2150                                                     240038
     C     W@7264        OREQ      W@2150                                                     240038
     C     W@7265        OREQ      W@2150                                                     240038
     C                   MOVE      'M'           W@MDIN                                       240038
     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
     C                   ENDIF                                                                240038
     C*
     C*
     C** SET UP RATES TO BE VALIDATED ACCORDING TO METHOD 1, 2, OR 3
     C** (1 = OUTRIGHT RATE, 2 = RATE + 0.0000005, 3 = RATE - 0.00000005)
     C** (RATE IS DESCALED RATE)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     @RRATE        @KRATE           13 8
     C                   Z-ADD     @RRATE        @ORATE           14 9
     C                   END
     C     @@K           IFEQ      2
     C     @KRATE        ADD       .000000005    @ORATE
     C                   END
     C     @@K           IFEQ      3
     C     @KRATE        SUB       .000000005    @ORATE
     C                   END
     C*
     C* RESET DIFFERENCES (BETWEEN ACTUAL & CALCULATED BUY/SELL AMOUNTS)
     C*
     C                   Z-ADD     1             W@DFBM
     C                   Z-ADD     1             W@DFSM
     C                   Z-ADD     1             W@DFBD
     C                   Z-ADD     1             W@DFSD
     C*
     C** Initialize variable @@PAS which check if the cross-validation
     C** passes the 2 units tolerance test, for round down CCY.
     C*
     C                   MOVEL     'N'           @@PASM            1
     C                   MOVEL     'N'           @@PASD            1
      *----------------------------------------------------------------
      *
      ** If Buy Currency = Base Currency For Dealing
      ** Determine differences between actual 'other' currency amount
      ** and calculated 'other' currency amount (amount x or / rate)
      *
     C     @@BSIN        IFEQ      'B'                                          IF BASE=BUY
     C     @ORATE        ANDNE     *ZERO
     C                   Z-ADD     @@CDP1        W@DECP                           I:Dec.places
      *
      ** Calculate 'other' currency amount (amount x or / rate)
      *
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2150        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2150        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2150        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4150                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4150                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4150                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4150                           =A/4 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2151        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2151        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2151        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4151                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4151                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4151                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4151                           =A/4 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2152        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2152        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2152        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4152                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4152                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4152                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4152                           =A/4 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2153        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2153        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2153        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4153                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4153                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4153                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4153                           =A/4 15,3
     C                   END                                                    FI
     C*
     C** Determine difference between calculated and actual
     C*
     C     W@1150        SUB       W@3150        W@DFBD           15 0          actual - calcd
     C     W@2150        SUB       W@4150        W@DFSD           15 0          actual - calcd
     C*
     C** Check if difference is within 2 units of calculated amount
     C** (this tolerance will be allowed only if JSM installed, and at
     C** least one of the currencies allows round down of amount)
     C** If it is within 2 units of tolerance, set on a 'PASS' flag.
     C*
     C     W@DFBD        IFGE      -2
     C     W@DFBD        ANDLE     2
     C     W@DFSD        ORGE      -2
     C     W@DFSD        ANDLE     2
     C                   MOVEL     'Y'           @@PASD
     C                   END
     C*
     C* Store calculated amounts for each method ( 1 2 and 3)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     W@3150        BD1501           15 0
     C                   Z-ADD     W@4150        SD1501           15 0
     C                   Z-ADD     0             BD1502
     C                   Z-ADD     0             SD1502
     C                   Z-ADD     0             BD1503
     C                   Z-ADD     0             SD1503
     C                   END
     C     @@K           IFEQ      2
     C                   Z-ADD     W@3150        BD1502           15 0
     C                   Z-ADD     W@4150        SD1502           15 0
     C                   END
     C     @@K           IFEQ      3
     C                   Z-ADD     W@3150        BD1503           15 0
     C                   Z-ADD     W@4150        SD1503           15 0
     C                   END
      /EJECT
     C*
     C** Do further checking following code if :
     C** a) @ROUND indicator not on and both differences are not zero.
     C** ..if either difference amount calculated is zero, then the
     C** ..amount has passed one of the tests and no more checking
     C** ..needs to be done.
     C*
     C     W@DFBD        IFNE      0
     C     W@DFSD        ANDNE     0
     C     @ROUND        ANDNE     'Y'
     C     @@PASD        ANDNE     'Y'                                                      AR703547
     C*
     C** b) @ROUND indicator on, @@K=1 and both differences > 2 units
     C** ..allow 2 units tolerance if round down of calculated amount
     C** ..is allowed, for K = 1.
     C*
     C     @ROUND        OREQ      'Y'
     C     @@K           ANDEQ     1
     C     @@PASD        ANDNE     'Y'
     C*
     C** C) @ROUND indicator on, @KK not = 1 and both differences not zero
     C** ..The 2 unit tolerance test does not apply for @@K equal to
     C** ..2 or 3 since they had use a tolerance of +/- .00000005
     C** ..in the spot rate used, which would give combined
     C** ..tolerance greater than 1 unit.
     C*
     C     @ROUND        OREQ      'Y'
     C     @@K           ANDNE     1
     C     W@DFBD        ANDNE     0
     C     W@DFSD        ANDNE     0
      *
      ** Calculate 'other' currency amount (amount x or / rate)
      *
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2150        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2150        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2150        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4150                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4150                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4150                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4150                           =A/4 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2151        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2151        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2151        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4151                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4151                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4151                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4151                           =A/4 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2152        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2152        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2152        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4152                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4152                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4152                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4152                           =A/4 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2153        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2153        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2153        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4153                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4153                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4153                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4153                           =A/4 15,3
     C                   END                                                    FI
     C*
     C** Determine difference between calculated and actual
     C*
     C     W@1150        SUB       W@3150        W@DFBM           15 0          actual - calcd
     C     W@2150        SUB       W@4150        W@DFSM           15 0          actual - calcd
     C*
     C** Check if difference is within 2 units of calculated amount
     C** (this tolerance will be allowed only if JSM installed, and at
     C** least one of the currencies allows round down of amount)
     C*
     C     W@DFBM        IFGE      -2
     C     W@DFBM        ANDLE     2
     C     W@DFSM        ORGE      -2
     C     W@DFSM        ANDLE     2
     C                   MOVEL     'Y'           @@PASM
     C                   END
     C*
     C* Store calculated amounts for each method ( 1 2 and 3)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     W@3150        BM1501           15 0
     C                   Z-ADD     W@4150        SM1501           15 0
     C                   Z-ADD     0             BM1502
     C                   Z-ADD     0             SM1502
     C                   Z-ADD     0             BM1503
     C                   Z-ADD     0             SM1503
     C                   END
     C     @@K           IFEQ      2
     C                   Z-ADD     W@3150        BM1502           15 0
     C                   Z-ADD     W@4150        SM1502           15 0
     C                   END
     C     @@K           IFEQ      3
     C                   Z-ADD     W@3150        BM1503           15 0
     C                   Z-ADD     W@4150        SM1503           15 0
     C                   END
     C                   END
     C                   END
      *----------------------------------------------------------------
      /EJECT
      *----------------------------------------------------------------
      *
      ** If Sell Currency = Base Currency For Dealing
      ** Determine differences between actual 'other' currency amount
      ** and calculated 'other' currency amount (amount x or / rate)
      *
     C     @@BSIN        IFEQ      'S'                                          IF BASE=SELL
     C     @ORATE        ANDNE     *ZERO
      *
      ** Calculate 'other' currency amount (amount x or / rate)
      *
     C                   Z-ADD     @@CDP2        W@DECP                           I:Dec.places
     C     *IN90         IFEQ      '1'                                          IF A/1 = 15,0
     C   94W@1150        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   95W@1150        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   96W@1150        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   97W@1150        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        MULT(H)   @ORATE        W@4150                           =A/4 15,0
     C   95W@2151        MULT(H)   @ORATE        W@4150                           =A/4 15,1
     C   96W@2152        MULT(H)   @ORATE        W@4150                           =A/4 15,2
     C   97W@2153        MULT(H)   @ORATE        W@4150                           =A/4 15,3
     C                   END                                                    FI
     C     *IN91         IFEQ      '1'                                          IF A/1 = 15,1
     C   94W@1151        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   95W@1151        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   96W@1151        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   97W@1151        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        MULT(H)   @ORATE        W@4151                           =A/4 15,0
     C   95W@2151        MULT(H)   @ORATE        W@4151                           =A/4 15,1
     C   96W@2152        MULT(H)   @ORATE        W@4151                           =A/4 15,2
     C   97W@2153        MULT(H)   @ORATE        W@4151                           =A/4 15,3
     C                   END                                                    FI
     C     *IN92         IFEQ      '1'                                          IF A/1 = 15,2
     C   94W@1152        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   95W@1152        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   96W@1152        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   97W@1152        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        MULT(H)   @ORATE        W@4152                           =A/4 15,0
     C   95W@2151        MULT(H)   @ORATE        W@4152                           =A/4 15,1
     C   96W@2152        MULT(H)   @ORATE        W@4152                           =A/4 15,2
     C   97W@2153        MULT(H)   @ORATE        W@4152                           =A/4 15,3
     C                   END                                                    FI
     C     *IN93         IFEQ      '1'                                          IF A/1 = 15,3
     C   94W@1153        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   95W@1153        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   96W@1153        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   97W@1153        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        MULT(H)   @ORATE        W@4153                           =A/4 15,0
     C   95W@2151        MULT(H)   @ORATE        W@4153                           =A/4 15,1
     C   96W@2152        MULT(H)   @ORATE        W@4153                           =A/4 15,2
     C   97W@2153        MULT(H)   @ORATE        W@4153                           =A/4 15,3
     C                   END                                                    FI
     C*
     C** Determine difference between calculated and actual
     C*
     C     W@2150        SUB       W@3150        W@DFBM                         actual - calcd
     C     W@1150        SUB       W@4150        W@DFSM                         actual - calcd
     C*
     C** Check if difference is within 2 units of calculated amount
     C** (this tolerance will be allowed only if JSM installed, and at
     C** least one of the currencies allows round down of amount)
     C*
     C     W@DFBM        IFGE      -2
     C     W@DFBM        ANDLE     2
     C     W@DFSM        ORGE      -2
     C     W@DFSM        ANDLE     2
     C                   MOVEL     'Y'           @@PASM
     C                   END
     C*
     C* Store calculated amounts for each method ( 1 2 and 3)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     W@3150        BM1501           15 0
     C                   Z-ADD     W@4150        SM1501           15 0
     C                   Z-ADD     0             BM1502
     C                   Z-ADD     0             SM1502
     C                   Z-ADD     0             BM1503
     C                   Z-ADD     0             SM1503
     C                   END
     C     @@K           IFEQ      2
     C                   Z-ADD     W@3150        BM1502           15 0
     C                   Z-ADD     W@4150        SM1502           15 0
     C                   END
     C     @@K           IFEQ      3
     C                   Z-ADD     W@3150        BM1503           15 0
     C                   Z-ADD     W@4150        SM1503           15 0
     C                   END
     C*
     C** Do further checking following code if :
     C** a) @ROUND indicator not on and both differences are not zero.
     C** ..if either difference amount calculated is zero, then the
     C** ..amount has passed one of the tests and no more checking
     C** ..needs to be done.
     C     W@DFBM        IFNE      0
     C     W@DFSM        ANDNE     0
     C     @ROUND        ANDNE     'Y'
     C     @@PASM        ANDNE     'Y'                                                      AR703547
     C*
     C** b) @ROUND indicator on, @@K=1 and both differences > 2 units
     C** ..allow 2 units tolerance if round down of calculated amount
     C** ..is allowed, for K = 1.
     C*
     C     @ROUND        OREQ      'Y'
     C     @@K           ANDEQ     1
     C     @@PASM        ANDNE     'Y'
     C*
     C** C) @ROUND indicator on, @KK not = 1 and both differences not zero
     C** ..The 2 unit tolerance test does not apply for @@K equal to
     C** ..2 or 3 since they had use a tolerance of +/- .00000005
     C** ..in the spot rate used, which would give combined
     C** ..tolerance greater than 1 unit.
     C*
     C     @ROUND        OREQ      'Y'
     C     @@K           ANDNE     1
     C     W@DFBM        ANDNE     0
     C     W@DFSM        ANDNE     0
      *
      ** Calculate 'other' currency amount (amount x or / rate)
      *
     C     *IN90         IFEQ      '1'                                          IF A/1 = 15,0
     C   94W@1150        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   95W@1150        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   96W@1150        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   97W@1150        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        DIV(H)    @ORATE        W@4150                           =A/4 15,0
     C   95W@2151        DIV(H)    @ORATE        W@4150                           =A/4 15,1
     C   96W@2152        DIV(H)    @ORATE        W@4150                           =A/4 15,2
     C   97W@2153        DIV(H)    @ORATE        W@4150                           =A/4 15,3
     C                   END                                                    FI
     C     *IN91         IFEQ      '1'                                          IF A/1 = 15,1
     C   94W@1151        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   95W@1151        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   96W@1151        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   97W@1151        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        DIV(H)    @ORATE        W@4151                           =A/4 15,0
     C   95W@2151        DIV(H)    @ORATE        W@4151                           =A/4 15,1
     C   96W@2152        DIV(H)    @ORATE        W@4151                           =A/4 15,2
     C   97W@2153        DIV(H)    @ORATE        W@4151                           =A/4 15,3
     C                   END                                                    FI
     C     *IN92         IFEQ      '1'                                          IF A/1 = 15,2
     C   94W@1152        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   95W@1152        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   96W@1152        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   97W@1152        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        DIV(H)    @ORATE        W@4152                           =A/4 15,0
     C   95W@2151        DIV(H)    @ORATE        W@4152                           =A/4 15,1
     C   96W@2152        DIV(H)    @ORATE        W@4152                           =A/4 15,2
     C   97W@2153        DIV(H)    @ORATE        W@4152                           =A/4 15,3
     C                   END                                                    FI
     C     *IN93         IFEQ      '1'                                          IF A/1 = 15,3
     C   94W@1153        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   95W@1153        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   96W@1153        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   97W@1153        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   94W@2150        DIV(H)    @ORATE        W@4153                           =A/4 15,0
     C   95W@2151        DIV(H)    @ORATE        W@4153                           =A/4 15,1
     C   96W@2152        DIV(H)    @ORATE        W@4153                           =A/4 15,2
     C   97W@2153        DIV(H)    @ORATE        W@4153                           =A/4 15,3
     C                   END                                                    FI
     C*
     C** Determine difference between calculated and actual
     C*
     C     W@2150        SUB       W@3150        W@DFBD                         actual - calcd
     C     W@1150        SUB       W@4150        W@DFSD                         actual - calcd
     C*
     C** Check if difference is within 2 units of calculated amount
     C** (this tolerance will be allowed only if JSM installed, and at
     C** least one of the currencies allows round down of amount)
     C** If it is within 2 units of tolerance, set on a 'PASS' flag.
     C*
     C     W@DFBD        IFGE      -2
     C     W@DFBD        ANDLE     2
     C     W@DFSD        ORGE      -2
     C     W@DFSD        ANDLE     2
     C                   MOVEL     'Y'           @@PASD
     C                   END
     C*
     C* Store calculated amounts for each method ( 1 2 and 3)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     W@3150        BD1501           15 0
     C                   Z-ADD     W@4150        SD1501           15 0
     C                   Z-ADD     0             BD1502
     C                   Z-ADD     0             SD1502
     C                   Z-ADD     0             BD1503
     C                   Z-ADD     0             SD1503
     C                   END
     C     @@K           IFEQ      2
     C                   Z-ADD     W@3150        BD1502           15 0
     C                   Z-ADD     W@4150        SD1502           15 0
     C                   END
     C     @@K           IFEQ      3
     C                   Z-ADD     W@3150        BD1503           15 0
     C                   Z-ADD     W@4150        SD1503           15 0
     C                   END
     C                   END
     C                   END
      *----------------------------------------------------------------
      /EJECT
      *----------------------------------------------------------------
     C*
     C* DETERMINE THE MULTIPLY/DIVIDE INDICATOR
     C* BASED ON THE CALCULATIONS DONE ABOVE
     C*
     C     @ORATE        IFNE      *ZERO
     C*
     C     W@DFBD        IFEQ      0
     C     @@K           ANDEQ     1
     C     @ROUND        ANDNE     'Y'
     C     W@DFSD        OREQ      0
     C     @@K           ANDEQ     1
     C     @ROUND        ANDNE     'Y'
     C     @@PASD        OREQ      'Y'
     C     @ROUND        ANDEQ     'Y'
     C     @@K           ANDEQ     1
     C     @@PASD        OREQ      'Y'                                                      AR703547
     C     @ROUND        ANDNE     'Y'                                                      AR703547
     C     @@K           ANDEQ     1                                                        AR703547
     C     @@BSIN        IFEQ      'B'
     C                   MOVE      'M'           W@MDIN
     C                   ELSE
     C                   MOVE      'D'           W@MDIN
     C                   END
     C                   ELSE
     C     @@K           IFEQ      3
     C     @@BSIN        IFEQ      'B'
     C     W@1150        IFGE      BD1502
     C     W@1150        ANDLE     BD1503
     C     BD1501        ANDGE     BD1502
     C     BD1501        ANDLE     BD1503
     C     W@2150        ORLE      SD1502
     C     W@2150        ANDGE     SD1503
     C     SD1501        ANDLE     SD1502
     C     SD1501        ANDGE     SD1503
     C                   MOVE      'M'           W@MDIN
     C                   END
     C                   ELSE
     C     W@2150        IFLE      BD1502
     C     W@2150        ANDGE     BD1503
     C     BD1501        ANDLE     BD1502
     C     BD1501        ANDGE     BD1503
     C     W@1150        ORGE      SD1502
     C     W@1150        ANDLE     SD1503
     C     SD1501        ANDGE     SD1502
     C     SD1501        ANDLE     SD1503
     C                   MOVE      'D'           W@MDIN
     C                   END
     C                   END
     C                   END
     C                   END
     C     W@DFBM        IFEQ      0
     C     @@K           ANDEQ     1
     C     @ROUND        ANDNE     'Y'
     C     W@DFSM        OREQ      0
     C     @@K           ANDEQ     1
     C     @ROUND        ANDNE     'Y'
     C     @@PASM        OREQ      'Y'
     C     @ROUND        ANDEQ     'Y'
     C     @@K           ANDEQ     1
     C     @@PASM        OREQ      'Y'                                                      AR703547
     C     @ROUND        ANDNE     'Y'                                                      AR703547
     C     @@K           ANDEQ     1                                                        AR703547
     C     @@BSIN        IFEQ      'B'
     C                   MOVE      'D'           W@MDIN
     C                   ELSE
     C                   MOVE      'M'           W@MDIN
     C                   END
     C                   ELSE
     C     @@K           IFEQ      3
     C     @@BSIN        IFEQ      'B'
     C     W@1150        IFLE      BM1502
     C     W@1150        ANDGE     BM1503
     C     BM1501        ANDLE     BM1502
     C     BM1501        ANDGE     BM1503
     C     W@2150        ORGE      SM1502
     C     W@2150        ANDLE     SM1503
     C     SM1501        ANDGE     SM1502
     C     SM1501        ANDLE     SM1503
     C                   MOVE      'D'           W@MDIN
     C                   END
     C                   ELSE
     C     W@2150        IFGE      BM1502
     C     W@2150        ANDLE     BM1503
     C     BM1501        ANDGE     BM1502
     C     BM1501        ANDLE     BM1503
     C     W@1150        ORLE      SM1502
     C     W@1150        ANDGE     SM1503
     C     SM1501        ANDLE     SM1502
     C     SM1501        ANDGE     SM1503
     C                   MOVE      'M'           W@MDIN
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C     #ZICA9        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** #ZICB - VALIDATE EXCH.RATE V. CROSS RATES FOR NON BASE CC DEAL
      *****************************************************************
     C     #ZICB         BEGSR
     C*
     C                   MOVE      *BLANKS       @@MDIN            1
     C*
     C* If either currency is the base currency for accounting
     C*
     C     DDBCCY        IFEQ      BJCYCD
     C     DDSCCY        OREQ      BJCYCD
     C*
     C* Set spot rate to that of currency which is the base currency
     C*
     C     DDBCCY        IFEQ      BJCYCD
     C                   Z-ADD     @SPOT2        @@SPTR
     C                   MOVE      @@MDF2        @@MDIN
     C                   ELSE
     C                   Z-ADD     @SPOT1        @@SPTR
     C                   MOVE      @@MDF1        @@MDIN
     C                   END
     C*
     C** Obtain Tolerance Amount of Spot Rate
     C*
     C     @@SPTR        MULT      TOLRAN        @@SR10           13 8
     C*
     C* Obtain +/-(Tolerance Amount) of Spot rate
     C*
     C     @@SPTR        ADD       @@SR10        @@SPHI           13 8          Spot + 10%
     C     @@SPTR        SUB       @@SR10        @@SPLO           13 8          Spot - 10%
     C*
     C** Calculate the inverse of the +/- tolerance of high/low spot rates
     C*
     C     1             DIV(H)    @@SPHI        @@ISHI           13 8
     C     1             DIV(H)    @@SPLO        @@ISLO           13 8
     C*
     C                   MOVE      'N'           W@RTOK            1
     C*
     C* OK if exch rate is GE low spt rte and exch rate is LE high spt rte
     C*
     C     @@INRT        IFGE      @@SPLO
     C     @@INRT        ANDLE     @@SPHI
     C                   MOVE      'Y'           W@RTOK
      *                                                                                       258321
      ** If rate is close to par (e.g. 0.99) then multiply/divide ind                         258321
      ** might be wrong because @@INRT is close to both spot and the                          258321
      ** inverse of spot. Check the amounts to confirm.                                       258321
     C     W@RTOK        IFEQ      'Y'                                                        258321
      *                                                                                       258321
     C     @CDP1         ADD       1             @@IX              1 0                        258321
     C     F3DAM1        DIV       @@AY(@@IX)    @@AMT1           18 3                        258321
     C     @CDP2         ADD       1             @@IX                                         258321
     C     F3DAM2        DIV       @@AY(@@IX)    @@AMT2           18 3                        258321
     C                   MULT      -1            @@AMT2                                       258321
      *                                                                                       258321
     C     DDBCCY        IFEQ      BJCYCD                                                     258321
     C     @@AMT2        ANDLT     @@AMT1                                                     258321
     C     @@INRT        ANDGT     1                                                          258321
      *                                                                                       258321
     C     DDBCCY        OREQ      BJCYCD                                                     258321
     C     @@AMT2        ANDGT     @@AMT1                                                     258321
     C     @@INRT        ANDLT     1                                                          258321
      *                                                                                       258321
     C     DDSCCY        OREQ      BJCYCD                                                     258321
     C     @@AMT1        ANDLT     @@AMT2                                                     258321
     C     @@INRT        ANDGT     1                                                          258321
      *                                                                                       258321
     C     DDSCCY        OREQ      BJCYCD                                                     258321
     C     @@AMT1        ANDGT     @@AMT2                                                     258321
     C     @@INRT        ANDLT     1                                                          258321
     C                   MOVE      'M'           @@MDIN                                       258321
     C                   ELSE                                                                 258321
     C                   MOVE      'D'           @@MDIN                                       258321
     C                   ENDIF                                                                258321
     C                   ENDIF                                                                258321
     C                   ELSE
     C*
     C* OK if exchrate is GE inv high spt rte and spt rate LE inv low spt rt
     C*
     C     @@INRT        IFGE      @@ISHI
     C     @@INRT        ANDLE     @@ISLO
     C                   MOVE      'Y'           W@RTOK
     C     @@MDIN        IFEQ      'M'                                          invert the rate
     C                   MOVE      'D'           @@MDIN                         by flipping
     C                   ELSE                                                   the M/D ind
     C                   MOVE      'M'           @@MDIN
     C                   END
     C                   END
     C                   END
     C*
     C* If rate is not OK, format low & high spot rates for message
     C*
     C     W@RTOK        IFEQ      'N'
     C                   Z-ADD     *ZERO         W@AMNT                           ¦ Initialise
     C                   MOVE      *BLANK        M@MGDA                           ¦ fields
     C                   Z-ADD     8             W@DECP                           ¦
     C                   Z-ADD     @@SPLO        W@AMTR                           I:Low Rate
     C                   EXSR      #ZICC                                          <Convert>
     C                   MOVEA     @Y(P1)        M@0115                           O:To msg.data
     C                   Z-ADD     @@SPHI        W@AMTR                           I:High Rate
     C                   EXSR      #ZICC                                          <Convert>
     C                   MOVEA     @Y(P1)        M@1630                           O:To msg.data
     C                   MOVE      M@MGDA        M@MGD3                           Stack Msg.Dta
     C                   END
     C*
     C                   END                                                     DDBCCY = BYCYCD
     C*
     C*----------------------------------------------------------------
     C*
      ** Set up variables used in 'difference' calculations below
      ** (difference is between actual 'other' currency amount
      **  and calculated 'other' currency amount (amount x or / rate))
     C*
     C     @CDP1         COMP      0                                      90     Dec.place=0
     C     @CDP1         COMP      1                                      91     Dec.place=1
     C     @CDP1         COMP      2                                      92     Dec.place=2
     C     @CDP1         COMP      3                                      93     Dec.place=3
     C     @CDP2         COMP      0                                      94     Dec.place=0
     C     @CDP2         COMP      1                                      95     Dec.place=1
     C     @CDP2         COMP      2                                      96     Dec.place=2
     C     @CDP2         COMP      3                                      97     Dec.place=3
     C*
     C     F3DAM1        IFLT      0                                                           DT001
     C                   Z-SUB     F3DAM1        W@1150                         15,0 amount 1  DT001
     C                   ELSE                                                                  DT001
     C                   Z-ADD     F3DAM1        W@1150                         15,0 amount 1  DT001
     C                   END                                                                   DT001
     C     F3DAM2        IFLT      0                                                           DT001
     C                   Z-SUB     F3DAM2        W@2150                         15,0 amount 2  DT001
     C                   ELSE                                                                  DT001
     C                   Z-ADD     F3DAM2        W@2150                         15,0 amount 2  DT001
     C                   END                                                                   DT001
     C*
     C* Determine number of normally quoted decimal places
     C*
     C                   Z-ADD     @@INRT        @@IRAT           13 8          EXCH.RATE
     C                   EXSR      ZA0790
     C*
     C* If the normally quoted decimal places is not zero
     C* Add (adjusted) forward points to margin
     C*
     C     @@NDP         IFNE      0
     C     @@FPNT        DIV(H)    @AD(@@NDP)    @RRATE                         Adjust Fwd/Pts
     C     S01453        IFEQ      'Y'                                          S01453 installd
     C                   Z-ADD     @RRATE        @XRATE                         Save
     C     @SMGPT        DIV       @AD(@@NDP)    @@MADJ                         Adjust margin
     C                   ADD       @@MADJ        @RRATE                         Margin+Fwd/Pts
     C                   END
     C                   END
     C*
     C* If the normally quoted decimal places is zero
     C* Add forward points to margin
     C*
     C     @@NDP         IFEQ      0
     C                   Z-ADD     @@FPNT        @RRATE                         Fwd/Pts
     C     S01453        IFEQ      'Y'
     C                   Z-ADD     @RRATE        @XRATE                         Save
     C                   ADD       @SMGPT        @RRATE                         Margin+Fwd/Pts
     C                   END
     C                   END
      *                                                                                       238023
     C                   Z-ADD     @RRATE        @RATE1           13 8                        238023
     C                   Z-ADD     @RRATE        @RATE2           13 8                        238023
     C                   Z-ADD     @RRATE        @RATEV           13 8                        240038
     C     @RATEV        IFLT      0                                                          240038
     C                   MULT      -1            @RATEV                                       240038
     C                   ENDIF                                                                240038
     C     W@INRT        ADD       @RATE1        @RATE3           13 8                        238023
     C     W@INRT        SUB       @RATE2        @RATE4           13 8                        238023
      *                                                                                       238023
      ** If the margin buy/sell indicator is "B".                                             238023
      *                                                                                       238023
     C     F3MGBS        IFEQ      'B'                                                        238023
      *                                                                                       238023
      ** Divide buy amount in different decimal places against +rate and store value          238023
      ** to a variable with zero decimal place.                                               238023
      *                                                                                       238023
     C     W@1150        DIV(H)    @RATE3        W@8150           15 0                        238023
     C     W@1151        DIV(H)    @RATE3        W@8151           15 0                        238023
     C     W@1152        DIV(H)    @RATE3        W@8152           15 0                        238023
     C     W@1153        DIV(H)    @RATE3        W@8153           15 0                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP2         WHENEQ    1                                                          240038
     C                   MULT      10            W@8150                                       240038
     C                   MULT      10            W@8151                                       240038
     C                   MULT      10            W@8152                                       240038
     C                   MULT      10            W@8153                                       240038
     C     @CDP2         WHENEQ    2                                                          240038
     C                   MULT      100           W@8150                                       240038
     C                   MULT      100           W@8151                                       240038
     C                   MULT      100           W@8152                                       240038
     C                   MULT      100           W@8153                                       240038
     C     @CDP2         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8150                                       240038
     C                   MULT      1000          W@8151                                       240038
     C                   MULT      1000          W@8152                                       240038
     C                   MULT      1000          W@8153                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Divide buy amount in different decimal places against +rate and store value          238023
      ** to a variable with one  decimal place.                                               238023
      *                                                                                       238023
     C     W@1150        DIV(H)    @RATE3        W@8154           15 1                        238023
     C     W@1151        DIV(H)    @RATE3        W@8155           15 1                        238023
     C     W@1152        DIV(H)    @RATE3        W@8156           15 1                        238023
     C     W@1153        DIV(H)    @RATE3        W@8157           15 1                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP2         WHENEQ    1                                                          240038
     C                   MULT      10            W@8154                                       240038
     C                   MULT      10            W@8155                                       240038
     C                   MULT      10            W@8156                                       240038
     C                   MULT      10            W@8157                                       240038
     C     @CDP2         WHENEQ    2                                                          240038
     C                   MULT      100           W@8154                                       240038
     C                   MULT      100           W@8155                                       240038
     C                   MULT      100           W@8156                                       240038
     C                   MULT      100           W@8157                                       240038
     C     @CDP2         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8154                                       240038
     C                   MULT      1000          W@8155                                       240038
     C                   MULT      1000          W@8156                                       240038
     C                   MULT      1000          W@8157                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Divide buy amount in different decimal places against +rate and store value          238023
      ** to a variable with two  decimal place.                                               238023
      *                                                                                       238023
     C     W@1150        DIV(H)    @RATE3        W@8158           15 2                        238023
     C     W@1151        DIV(H)    @RATE3        W@8159           15 2                        238023
     C     W@1152        DIV(H)    @RATE3        W@8160           15 2                        238023
     C     W@1153        DIV(H)    @RATE3        W@8161           15 2                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP2         WHENEQ    1                                                          240038
     C                   MULT      10            W@8158                                       240038
     C                   MULT      10            W@8159                                       240038
     C                   MULT      10            W@8160                                       240038
     C                   MULT      10            W@8161                                       240038
     C     @CDP2         WHENEQ    2                                                          240038
     C                   MULT      100           W@8158                                       240038
     C                   MULT      100           W@8159                                       240038
     C                   MULT      100           W@8160                                       240038
     C                   MULT      100           W@8161                                       240038
     C     @CDP2         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8158                                       240038
     C                   MULT      1000          W@8159                                       240038
     C                   MULT      1000          W@8160                                       240038
     C                   MULT      1000          W@8161                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Divide buy amount in different decimal places against +rate and store value          238023
      ** to a variable with three decimal place.                                              238023
      *                                                                                       238023
     C     W@1150        DIV(H)    @RATE3        W@8162           15 3                        238023
     C     W@1151        DIV(H)    @RATE3        W@8163           15 3                        238023
     C     W@1152        DIV(H)    @RATE3        W@8164           15 3                        238023
     C     W@1153        DIV(H)    @RATE3        W@8165           15 3                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP2         WHENEQ    1                                                          240038
     C                   MULT      10            W@8162                                       240038
     C                   MULT      10            W@8163                                       240038
     C                   MULT      10            W@8164                                       240038
     C                   MULT      10            W@8165                                       240038
     C     @CDP2         WHENEQ    2                                                          240038
     C                   MULT      100           W@8162                                       240038
     C                   MULT      100           W@8163                                       240038
     C                   MULT      100           W@8164                                       240038
     C                   MULT      100           W@8165                                       240038
     C     @CDP2         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8162                                       240038
     C                   MULT      1000          W@8163                                       240038
     C                   MULT      1000          W@8164                                       240038
     C                   MULT      1000          W@8165                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Check if one of the above calculations satisfied the suppose sell amount and if it   238023
      ** is then assign a Divide rate to W@MDIN.                                              238023
      *                                                                                       238023
     C     W@8150        IFEQ      W@2150                                                     238023
     C     W@8151        OREQ      W@2150                                                     238023
     C     W@8152        OREQ      W@2150                                                     238023
     C     W@8153        OREQ      W@2150                                                     238023
     C     W@8154        OREQ      W@2150                                                     238023
     C     W@8155        OREQ      W@2150                                                     238023
     C     W@8156        OREQ      W@2150                                                     238023
     C     W@8157        OREQ      W@2150                                                     238023
     C     W@8158        OREQ      W@2150                                                     238023
     C     W@8159        OREQ      W@2150                                                     238023
     C     W@8160        OREQ      W@2150                                                     238023
     C     W@8161        OREQ      W@2150                                                     238023
     C     W@8162        OREQ      W@2150                                                     238023
     C     W@8163        OREQ      W@2150                                                     238023
     C     W@8164        OREQ      W@2150                                                     238023
     C     W@8165        OREQ      W@2150                                                     238023
     C                   MOVE      'D'           W@MDIN                                       238023
     C**********         Z-ADD     @RATE3        @RRATE                                238023 240038
     C     W@INRT        ADD       @RATEV        @RRATE                                       240038
     C                   ELSE                                                                 238023
      *                                                                                       238023
      ** Multiply the buy amount with different decimal places against -rate and store        238023
      ** value to variable with zero decimal place.                                           238023
      *                                                                                       238023
     C     W@1150        MULT(H)   @RATE4        W@9150           15 0                        238023
     C     W@1151        MULT(H)   @RATE4        W@9151           15 0                        238023
     C     W@1152        MULT(H)   @RATE4        W@9152           15 0                        238023
     C     W@1153        MULT(H)   @RATE4        W@9153           15 0                        238023
      *                                                                                       238023
      ** Multiply the buy amount with different decimal places against -rate and store        238023
      ** value to variable with one decimal place.                                            238023
      *                                                                                       238023
     C     W@1150        MULT(H)   @RATE4        W@9154           15 1                        238023
     C     W@1151        MULT(H)   @RATE4        W@9155           15 1                        238023
     C     W@1152        MULT(H)   @RATE4        W@9156           15 1                        238023
     C     W@1153        MULT(H)   @RATE4        W@9157           15 1                        238023
      *                                                                                       238023
      ** Multiply the buy amount with different decimal places against -rate and store        238023
      ** value to variable with two decimal place.                                            238023
      *                                                                                       238023
     C     W@1150        MULT(H)   @RATE4        W@9158           15 2                        238023
     C     W@1151        MULT(H)   @RATE4        W@9159           15 2                        238023
     C     W@1152        MULT(H)   @RATE4        W@9160           15 2                        238023
     C     W@1153        MULT(H)   @RATE4        W@9161           15 2                        238023
      *                                                                                       238023
      ** Multiply the buy amount with different decimal places against -rate and store        238023
      ** value to variable with three decimal place.                                          238023
      *                                                                                       238023
     C     W@1150        MULT(H)   @RATE4        W@9162           15 3                        238023
     C     W@1151        MULT(H)   @RATE4        W@9163           15 3                        238023
     C     W@1152        MULT(H)   @RATE4        W@9164           15 3                        238023
     C     W@1153        MULT(H)   @RATE4        W@9165           15 3                        238023
      *                                                                                       238023
      ** Check if one of the above calculations satisfied the suppose sell amount and if it   238023
      ** is then assign a Multiply rate to W@MDIN.                                            238023
      *                                                                                       238023
     C     W@9150        IFEQ      W@2150                                                     238023
     C     W@9151        OREQ      W@2150                                                     238023
     C     W@9152        OREQ      W@2150                                                     238023
     C     W@9153        OREQ      W@2150                                                     238023
     C     W@9154        OREQ      W@2150                                                     238023
     C     W@9155        OREQ      W@2150                                                     238023
     C     W@9156        OREQ      W@2150                                                     238023
     C     W@9157        OREQ      W@2150                                                     238023
     C     W@9158        OREQ      W@2150                                                     238023
     C     W@9159        OREQ      W@2150                                                     238023
     C     W@9160        OREQ      W@2150                                                     238023
     C     W@9161        OREQ      W@2150                                                     238023
     C     W@9162        OREQ      W@2150                                                     238023
     C     W@9163        OREQ      W@2150                                                     238023
     C     W@9164        OREQ      W@2150                                                     238023
     C     W@9165        OREQ      W@2150                                                     238023
     C                   MOVE      'M'           W@MDIN                                       238023
     C**********         Z-ADD     @RATE4        @RRATE                                238023 240038
     C     W@INRT        SUB       @RATEV        @RRATE                                       240038
     C                   ENDIF                                                                238023
     C                   ENDIF                                                                238023
     C                   ENDIF                                                                238023
      *                                                                                       238023
      ** If the margin buy/sell indicator used is "S".                                        238023
      *                                                                                       238023
     C     F3MGBS        IFEQ      'S'                                                        238023
      *                                                                                       238023
      ** Divide sell amount in different decimal places against +rate and store value         238023
      ** to a variable with zero decimal place.                                               238023
      *                                                                                       238023
     C     W@2150        DIV(H)    @RATE3        W@8250           15 0                        238023
     C     W@2151        DIV(H)    @RATE3        W@8251           15 0                        238023
     C     W@2152        DIV(H)    @RATE3        W@8252           15 0                        238023
     C     W@2153        DIV(H)    @RATE3        W@8253           15 0                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP1         WHENEQ    1                                                          240038
     C                   MULT      10            W@8250                                       240038
     C                   MULT      10            W@8251                                       240038
     C                   MULT      10            W@8252                                       240038
     C                   MULT      10            W@8253                                       240038
     C     @CDP1         WHENEQ    2                                                          240038
     C                   MULT      100           W@8250                                       240038
     C                   MULT      100           W@8251                                       240038
     C                   MULT      100           W@8252                                       240038
     C                   MULT      100           W@8253                                       240038
     C     @CDP1         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8250                                       240038
     C                   MULT      1000          W@8251                                       240038
     C                   MULT      1000          W@8252                                       240038
     C                   MULT      1000          W@8253                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Divide sell amount in different decimal places against +rate and store value         238023
      ** to a variable with one  decimal place.                                               238023
      *                                                                                       238023
     C     W@2150        DIV(H)    @RATE3        W@8254           15 1                        238023
     C     W@2151        DIV(H)    @RATE3        W@8255           15 1                        238023
     C     W@2152        DIV(H)    @RATE3        W@8256           15 1                        238023
     C     W@2153        DIV(H)    @RATE3        W@8257           15 1                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP1         WHENEQ    1                                                          240038
     C                   MULT      10            W@8254                                       240038
     C                   MULT      10            W@8255                                       240038
     C                   MULT      10            W@8256                                       240038
     C                   MULT      10            W@8257                                       240038
     C     @CDP1         WHENEQ    2                                                          240038
     C                   MULT      100           W@8254                                       240038
     C                   MULT      100           W@8255                                       240038
     C                   MULT      100           W@8256                                       240038
     C                   MULT      100           W@8257                                       240038
     C     @CDP1         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8254                                       240038
     C                   MULT      1000          W@8255                                       240038
     C                   MULT      1000          W@8256                                       240038
     C                   MULT      1000          W@8257                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Divide sell amount in different decimal places against +rate and store value         238023
      ** to a variable with two  decimal place.                                               238023
      *                                                                                       238023
     C     W@2150        DIV(H)    @RATE3        W@8258           15 2                        238023
     C     W@2151        DIV(H)    @RATE3        W@8259           15 2                        238023
     C     W@2152        DIV(H)    @RATE3        W@8260           15 2                        238023
     C     W@2153        DIV(H)    @RATE3        W@8261           15 2                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP1         WHENEQ    1                                                          240038
     C                   MULT      10            W@8258                                       240038
     C                   MULT      10            W@8259                                       240038
     C                   MULT      10            W@8260                                       240038
     C                   MULT      10            W@8261                                       240038
     C     @CDP1         WHENEQ    2                                                          240038
     C                   MULT      100           W@8258                                       240038
     C                   MULT      100           W@8259                                       240038
     C                   MULT      100           W@8260                                       240038
     C                   MULT      100           W@8261                                       240038
     C     @CDP1         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8258                                       240038
     C                   MULT      1000          W@8259                                       240038
     C                   MULT      1000          W@8260                                       240038
     C                   MULT      1000          W@8261                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Divide sell amount in different decimal places against +rate and store value         238023
      ** to a variable with three decimal place.                                              238023
      *                                                                                       238023
     C     W@2150        DIV(H)    @RATE3        W@8262           15 3                        238023
     C     W@2151        DIV(H)    @RATE3        W@8263           15 3                        238023
     C     W@2152        DIV(H)    @RATE3        W@8264           15 3                        238023
     C     W@2153        DIV(H)    @RATE3        W@8265           15 3                        238023
      *                                                                                       240038
     C                   SELECT                                                               240038
     C     @CDP1         WHENEQ    1                                                          240038
     C                   MULT      10            W@8262                                       240038
     C                   MULT      10            W@8263                                       240038
     C                   MULT      10            W@8264                                       240038
     C                   MULT      10            W@8265                                       240038
     C     @CDP1         WHENEQ    2                                                          240038
     C                   MULT      100           W@8262                                       240038
     C                   MULT      100           W@8263                                       240038
     C                   MULT      100           W@8264                                       240038
     C                   MULT      100           W@8265                                       240038
     C     @CDP1         WHENEQ    3                                                          240038
     C                   MULT      1000          W@8262                                       240038
     C                   MULT      1000          W@8263                                       240038
     C                   MULT      1000          W@8264                                       240038
     C                   MULT      1000          W@8265                                       240038
     C                   ENDSL                                                                240038
      *                                                                                       238023
      ** Check if one of the above calculations satisfied the suppose buy amount and if it    238023
      ** is then assign a Multiply rate to W@MDIN.                                            238023
      *                                                                                       238023
     C     W@8250        IFEQ      W@1150                                                     238023
     C     W@8251        OREQ      W@1150                                                     238023
     C     W@8252        OREQ      W@1150                                                     238023
     C     W@8253        OREQ      W@1150                                                     238023
     C     W@8254        OREQ      W@1150                                                     238023
     C     W@8255        OREQ      W@1150                                                     238023
     C     W@8256        OREQ      W@1150                                                     238023
     C     W@8257        OREQ      W@1150                                                     238023
     C     W@8258        OREQ      W@1150                                                     238023
     C     W@8259        OREQ      W@1150                                                     238023
     C     W@8260        OREQ      W@1150                                                     238023
     C     W@8261        OREQ      W@1150                                                     238023
     C     W@8262        OREQ      W@1150                                                     238023
     C     W@8263        OREQ      W@1150                                                     238023
     C     W@8264        OREQ      W@1150                                                     238023
     C     W@8265        OREQ      W@1150                                                     238023
     C                   MOVE      'D'           W@MDIN                                       238023
     C**********         Z-ADD     @RATE3        @RRATE                                238023 240038
     C     W@INRT        ADD       @RATEV        @RRATE                                       240038
     C                   ELSE                                                                 238023
      *                                                                                       238023
      ** Multiply the sell amount with different decimal places against -rate and store       238023
      ** value to variable with zero decimal place.                                           238023
      *                                                                                       238023
     C     W@2150        MULT(H)   @RATE4        W@9250           15 0                        238023
     C     W@2151        MULT(H)   @RATE4        W@9251           15 0                        238023
     C     W@2152        MULT(H)   @RATE4        W@9252           15 0                        238023
     C     W@2153        MULT(H)   @RATE4        W@9253           15 0                        238023
      *                                                                                       238023
      ** Multiply the sell amount with different decimal places against -rate and store       238023
      ** value to variable with one decimal place.                                            238023
      *                                                                                       238023
     C     W@2150        MULT(H)   @RATE4        W@9254           15 1                        238023
     C     W@2151        MULT(H)   @RATE4        W@9255           15 1                        238023
     C     W@2152        MULT(H)   @RATE4        W@9256           15 1                        238023
     C     W@2153        MULT(H)   @RATE4        W@9257           15 1                        238023
      *                                                                                       238023
      ** Multiply the sell amount with different decimal places against -rate and store       238023
      ** value to variable with two decimal place.                                            238023
      *                                                                                       238023
     C     W@2150        MULT(H)   @RATE4        W@9258           15 2                        238023
     C     W@2151        MULT(H)   @RATE4        W@9259           15 2                        238023
     C     W@2152        MULT(H)   @RATE4        W@9260           15 2                        238023
     C     W@2153        MULT(H)   @RATE4        W@9261           15 2                        238023
      *                                                                                       238023
      ** Multiply the sell amount with different decimal places against -rate and store       238023
      ** value to variable with thre decimal place.                                           238023
      *                                                                                       238023
     C     W@2150        MULT(H)   @RATE4        W@9262           15 3                        238023
     C     W@2151        MULT(H)   @RATE4        W@9263           15 3                        238023
     C     W@2152        MULT(H)   @RATE4        W@9264           15 3                        238023
     C     W@2153        MULT(H)   @RATE4        W@9265           15 3                        238023
      *                                                                                       238023
      ** Check if one of the above calculations satisfied the suppose buy amount and if it    238023
      ** is then assign a Multiply rate to W@MDIN.                                            238023
      *                                                                                       238023
     C     W@9250        IFEQ      W@1150                                                     238023
     C     W@9251        OREQ      W@1150                                                     238023
     C     W@9252        OREQ      W@1150                                                     238023
     C     W@9253        OREQ      W@1150                                                     238023
     C     W@9254        OREQ      W@1150                                                     238023
     C     W@9255        OREQ      W@1150                                                     238023
     C     W@9256        OREQ      W@1150                                                     238023
     C     W@9257        OREQ      W@1150                                                     238023
     C     W@9258        OREQ      W@1150                                                     238023
     C     W@9259        OREQ      W@1150                                                     238023
     C     W@9260        OREQ      W@1150                                                     238023
     C     W@9261        OREQ      W@1150                                                     238023
     C     W@9262        OREQ      W@1150                                                     238023
     C     W@9263        OREQ      W@1150                                                     238023
     C     W@9264        OREQ      W@1150                                                     238023
     C     W@9265        OREQ      W@1150                                                     238023
     C                   MOVE      'M'           W@MDIN                                       238023
     C**********         Z-ADD     @RATE4        @RRATE                                238023 240038
     C     W@INRT        SUB       @RATEV        @RRATE                                       240038
     C                   ENDIF                                                                238023
     C                   ENDIF                                                                238023
     C                   ENDIF                                                                238023
     C*
     C**Add*exchange*rate*to*margin*+*forward*points***************************************** 238023
     C**to*get*the*outright*rate************************************************************* 238023
     C*                                                                                       238023
     C     F3MGBS        IFEQ      ' '                                                        240038
     C**********         ADD       W@INRT        @RRATE           13 8          Outright Rate 238023
     C                   ADD       W@INRT        @RRATE           13 8                        240038
     C                   ENDIF                                                                240038
     C*
     C* Add exchange rate to margin + forward points
     C* to get the outright rate
     C*
     C                   ADD       W@INRT        @RRATE           13 8          Outright Rate
     C*
     C**********         IF        CER043 = 'Y' AND DDREIN = 'Y'                   BUG23668 BUG25418
     C**********         EVAL(H)   @RRATE = 1/@RRATE                               BUG23668 BUG25418
     C**********         ENDIF                                                     BUG23668 BUG25418
      *                                                                                     BUG23668
     C* Add exchange rate to forward points to obtain forward rate
     C*
     C     S01453        IFEQ      'Y'
     C                   ADD       W@INRT        @XRATE           13 8          Fwd Rate
     C                   END
     C*
     C** SET UP RATES TO BE VALIDATED ACCORDING TO METHOD 1, 2, OR 3
     C** (1 = OUTRIGHT RATE, 2 = RATE + 0.00000005, 3 = RATE - 0.00000005)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     @RRATE        @KRATE
     C                   Z-ADD     @RRATE        @ORATE           14 9
     C                   END
     C     @@K           IFEQ      2
     C     @KRATE        ADD       .000000005    @ORATE
     C                   END
     C     @@K           IFEQ      3
     C     @KRATE        SUB       .000000005    @ORATE
     C                   END
     C*
     C* RESET DIFFERENCES (BETWEEN ACTUAL & CALCULATED BUY/SELL AMOUNTS)
     C*
     C                   Z-ADD     1             W@DIFS
     C                   Z-ADD     1             W@DIFB
     C*
     C*----------------------------------------------------------------
     C*
      **  Once value of the W@MDIN field still "X", meaning that margin functionality is not  238023
      **  satisfied. Then check the tolerance unit of calculated amounts in a divide/mult rate238023
      *                                                                                       238023
     C     W@MDIN        IFEQ      'X'                                                        238023
      ** Determine differences between actual 'other' currency amount
      ** and calculated 'other' currency amount (amount x or / rate)
      ** and by so doing determine the multiply/divide indicator
     C*
     C     @@MDIN        IFNE      'D'
     C     DDBCCY        ANDNE     BJCYCD
     C     @@MDIN        OREQ      'D'
     C     DDBCCY        ANDEQ     BJCYCD
     C     W@RTOK        OREQ      'N'
      *
      ** Calculate 'other' currency amount (amount x or / rate)
      *
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2150        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2150        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2150        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4150                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4150                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4150                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4150                           =A/4 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2151        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2151        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2151        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4151                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4151                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4151                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4151                           =A/4 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2152        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2152        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2152        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4152                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4152                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4152                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4152                           =A/4 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        DIV(H)    @ORATE        W@3150                           =A/3 15,0
     C   91W@2153        DIV(H)    @ORATE        W@3151                           =A/3 15,1
     C   92W@2153        DIV(H)    @ORATE        W@3152                           =A/3 15,2
     C   93W@2153        DIV(H)    @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        MULT(H)   @ORATE        W@4153                           =A/4 15,0
     C   91W@1151        MULT(H)   @ORATE        W@4153                           =A/4 15,1
     C   92W@1152        MULT(H)   @ORATE        W@4153                           =A/4 15,2
     C   93W@1153        MULT(H)   @ORATE        W@4153                           =A/4 15,3
     C                   END                                                    FI
     C*
     C** Determine difference between calculated and actual
     C*
     C     W@1150        SUB       W@3150        W@DIFB           15 0          actual - calcd
     C     W@2150        SUB       W@4150        W@DIFS           15 0          actual - calcd
     C*
     C* Store calculated amounts for each method ( 1 2 and 3)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     W@3150        FB1501           15 0
     C                   Z-ADD     W@4150        FS1501           15 0
     C                   Z-ADD     0             FB1502
     C                   Z-ADD     0             FS1502
     C                   Z-ADD     0             FB1503
     C                   Z-ADD     0             FS1503
     C                   END
     C     @@K           IFEQ      2
     C                   Z-ADD     W@3150        FB1502           15 0
     C                   Z-ADD     W@4150        FS1502           15 0
     C                   END
     C     @@K           IFEQ      3
     C                   Z-ADD     W@3150        FB1503           15 0
     C                   Z-ADD     W@4150        FS1503           15 0
     C                   END
     C*
     C* DETERMINE THE MULTIPLY/DIVIDE INDICATOR
     C* BASED ON THE CALCULATIONS DONE ABOVE
     C*
     C     W@DIFB        IFLE      2                                            IF
     C     W@DIFB        ANDGE     -2
     C     @ROUND        ANDNE     'Y'
     C     @@K           ANDEQ     1
     C     @ROUND        OREQ      'Y'
     C     W@DIFB        ANDGE     -2
     C     W@DIFB        ANDLE     2
     C     @@K           ANDEQ     1
     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
     C                   GOTO      #ZICB8                                         Exit
     C                   ELSE                                                   ELSE
     C     W@DIFS        IFLE      2
     C     W@DIFS        ANDGE     -2
     C     @ROUND        ANDNE     'Y'
     C     @@K           ANDEQ     1
     C     @ROUND        OREQ      'Y'
     C     W@DIFS        ANDGE     -2
     C     W@DIFS        ANDLE     2
     C     @@K           ANDEQ     1
     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind
     C                   GOTO      #ZICB8                                         Exit
     C                   ELSE
     C     @@K           IFEQ      3
     C*****W@1150        IFLE      FB1502                                                  BUG25240A
     C*****W@1150        ANDGE     FB1503                                                  BUG25240A
     C*****FB1501        ANDLE     FB1502                                                  BUG25240A
     C*****FB1501        ANDGE     FB1503                                                  BUG25240A
     C     W@1150        IFGE      FB1502                                                  BUG25240A
     C     W@1150        ANDLE     FB1503                                                  BUG25240A
     C     FB1501        ANDGE     FB1502                                                  BUG25240A
     C     FB1501        ANDLE     FB1503                                                  BUG25240A
     C                   MOVE      'M'           W@MDIN
     C                   ELSE
     C*****W@2150        IFGE      FS1502                                                  BUG25240A
     C*****W@2150        ANDLE     FS1503                                                  BUG25240A
     C*****FS1501        ANDGE     FS1502                                                  BUG25240A
     C*****FS1501        ANDLE     FS1503                                                  BUG25240A
     C     W@2150        IFLE      FS1502                                                  BUG25240A
     C     W@2150        ANDGE     FS1503                                                  BUG25240A
     C     FS1501        ANDLE     FS1502                                                  BUG25240A
     C     FS1501        ANDGE     FS1503                                                  BUG25240A
     C                   MOVE      'D'           W@MDIN
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C*----------------------------------------------------------------
     C*
      ** Determine differences between actual 'other' currency amount
      ** and calculated 'other' currency amount (amount x or / rate)
      ** and by so doing determine the multiply/divide indicator
     C*
     C     @@MDIN        IFNE      'M'
     C     DDBCCY        ANDNE     BJCYCD                                       CCY1 NOT = BCA
     C     @@MDIN        OREQ      'M'
     C     DDBCCY        ANDEQ     BJCYCD                                       CCY1     = BCA
     C     W@RTOK        OREQ      'N'
      *
      ** Calculate 'other' currency amount (amount x or / rate)
      *
     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
     C   90W@2150        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2150        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2150        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2150        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4150                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4150                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4150                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4150                           =A/4 15,3
     C                   END                                                    FI
     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
     C   90W@2151        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2151        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2151        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2151        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4151                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4151                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4151                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4151                           =A/4 15,3
     C                   END                                                    FI
     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
     C   90W@2152        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2152        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2152        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2152        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4152                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4152                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4152                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4152                           =A/4 15,3
     C                   END                                                    FI
     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
     C   90W@2153        MULT(H)   @ORATE        W@3150                           =A/3 15,0
     C   91W@2153        MULT(H)   @ORATE        W@3151                           =A/3 15,1
     C   92W@2153        MULT(H)   @ORATE        W@3152                           =A/3 15,2
     C   93W@2153        MULT(H)   @ORATE        W@3153                           =A/3 15,3
     C   90W@1150        DIV(H)    @ORATE        W@4153                           =A/4 15,0
     C   91W@1151        DIV(H)    @ORATE        W@4153                           =A/4 15,1
     C   92W@1152        DIV(H)    @ORATE        W@4153                           =A/4 15,2
     C   93W@1153        DIV(H)    @ORATE        W@4153                           =A/4 15,3
     C                   END                                                    FI
     C*
     C** Determine difference between calculated and actual
     C*
     C     W@1150        SUB       W@3150        W@DIFB                         Difference
     C     W@2150        SUB       W@4150        W@DIFS                         Difference
     C*
     C* Store calculated amounts for each method ( 1 2 and 3)
     C*
     C     @@K           IFEQ      1
     C                   Z-ADD     W@3150        JB1501           15 0
     C                   Z-ADD     W@4150        JS1501           15 0
     C                   Z-ADD     0             JB1502
     C                   Z-ADD     0             JS1502
     C                   Z-ADD     0             JB1503
     C                   Z-ADD     0             JS1503
     C                   END
     C     @@K           IFEQ      2
     C                   Z-ADD     W@3150        JB1502           15 0
     C                   Z-ADD     W@4150        JS1502           15 0
     C                   END
     C     @@K           IFEQ      3
     C                   Z-ADD     W@3150        JB1503           15 0
     C                   Z-ADD     W@4150        JS1503           15 0
     C                   END
     C*
     C* DETERMINE THE MULTIPLY/DIVIDE INDICATOR
     C* BASED ON THE CALCULATIONS DONE ABOVE
     C*
     C     W@DIFB        IFLE      2
     C     W@DIFB        ANDGE     -2
     C     @ROUND        ANDNE     'Y'
     C     @@K           ANDEQ     1
     C     @ROUND        OREQ      'Y'
     C     W@DIFB        ANDGE     -2
     C     W@DIFB        ANDLE     2
     C     @@K           ANDEQ     1
     C                   MOVE      'D'           W@MDIN                         Mult/Div ind
     C                   ELSE
     C     W@DIFS        IFLE      2
     C     W@DIFS        ANDGE     -2
     C     @ROUND        ANDNE     'Y'
     C     @@K           ANDEQ     1
     C     @ROUND        OREQ      'Y'
     C     W@DIFS        ANDGE     -2
     C     W@DIFS        ANDLE     2
     C     @@K           ANDEQ     1
     C                   MOVE      'M'           W@MDIN                         Mult/Div ind
     C                   ELSE
     C     @@K           IFEQ      3
     C     W@1150        IFLE      JB1502
     C     W@1150        ANDGE     JB1503
     C     JB1501        ANDLE     JB1502
     C     JB1501        ANDGE     JB1503
     C                   MOVE      'M'           W@MDIN
     C                   ELSE
     C     W@2150        IFGE      JS1502
     C     W@2150        ANDLE     JS1503
     C     JS1501        ANDGE     JS1502
     C     JS1501        ANDLE     JS1503
     C                   MOVE      'D'           W@MDIN
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ENDIF                                                                238023
     C*
     C     #ZICB8        TAG
     C                   Z-ADD     W@INRT        @SRATE                         Descaled rate
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** #ZICC - Convert numeric amount to edited alpha
      *****************************************************************
     C     #ZICC         BEGSR
     C* INPUTS
     C                   Z-ADD     W@AMNT        W@AMNT                         Amount
     C                   Z-ADD     W@DECP        W@DECP                         Dec.Places
     C* OUTPUTS
     C                   MOVE      *BLANK        W@AMTD                         Edit amt (unsign)
     C                   MOVE      *BLANK        W@AMTP                         Edit amt (sign)
     C*
     C                   SETOFF                                         91      Init.Inds.
     C*
     C     W@DECP        IFEQ      *ZERO                                        IF NO DEC.POS.
     C                   Z-ADD     2             P1                               Start pos.
     C                   Z-ADD     *ZERO         W@QECW            3 0            Start decimal
     C                   ELSE                                                   EL DEC.PLACES
     C                   Z-ADD     1             P1                5 0            Start pos.
     C     16            SUB       W@DECP        W@QECW                           Start decimal
     C                   END                                                    FI
     C*
     C     W@AMNT        IFLT      *ZERO                                        IF NEGATIVE
     C     *ZERO         SUB       W@AMNT        W@AMNT                           Make positive
     C                   MOVE      '-'           W@AMTD                           Negative
     C                   END                                                    FI
     C*
     C     1             DO        15            P2                5 0          DO EDIT
     C     W@DECP        IFNE      *ZERO                                        IF   ¦ DECIMAL
     C     P1            ANDEQ     W@QECW                                       AND  ¦ POSITION
     C                   MOVE      BNDCSP        @Y(P1)                           Decimal point
     C                   ADD       1             P1                   91          Incr.ptr.Y
     C                   END                                                    FI
     C     *IN91         IFEQ      '0'                                          IF   ¦ LEADING
     C     @P(P2)        ANDEQ     *ZERO                                         AND ¦ ZERO
     C                   MOVE      *BLANK        @Y(P1)                           Blank
     C                   ELSE                                                   EL IN NUMBER
     C                   MOVE      @P(P2)        @Y(P1)                           Valid data
     C                   SETON                                        91          In number
     C                   END                                                    FI
     C                   ADD       1             P1                               Incr.ptr.Y
     C                   END                                                    OD
     C*
     C                   Z-ADD     16            P1                               Set ptr.1
     C     @Y(P1)        DOWEQ     '0'                                          DO TRIM ZEROS
     C                   SUB       1             P1                               Decr.ptr.1
     C                   END                                                    OD
     C                   ADD       1             P1                               Incr.ptr.1
     C     P1            IFLT      17                                           IF PTR.IN RANGE
     C                   MOVEA     *BLANK        @Y(P1)                           Trim zeros
     C                   END                                                    FI
     C                   Z-ADD     1             P1                               Set ptr.1
     C     *BLANK        LOOKUP    @Y(P1)                             90          Find start
     C*
     C     ZICC9         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0790 - DETERMINE NUMBER OF NORMALLY QUOTED DECIMAL PLACES   *
      *****************************************************************
     C     ZA0790        BEGSR
      *
     C     @@NDP1        IFEQ      @@NDP2
     C     @@NDP1        ANDEQ     5
     C                   Z-ADD     5             @@NDP             1 0
     C                   GOTO      ZA0799
     C                   END
      *                                                                                       248024
      ** Compare normally-quoted decimal places of both currencies invovled;                  248024
      ** If both are the same, use either value as NQD...                                     248024
      *                                                                                       248024
     C     @@NDP1        IFEQ      @@NDP2                                                     248024
     C                   Z-ADD     @@NDP1        @@NDP                                        248024
     C                   GOTO      ZA0799                                                     248024
     C                   ENDIF                                                                248024
      *                                                                                       248024
      ** If they are not the same, use the lesser value of the two...                         248024
      *                                                                                       248024
     C     @@NDP1        IFNE      @@NDP2                                                     248024
     C     @@NDP1        IFLT      @@NDP2                                                     248024
     C                   Z-ADD     @@NDP1        @@NDP                                        248024
     C                   ELSE                                                                 248024
     C     @@NDP2        IFLT      @@NDP1                                                     248024
     C                   Z-ADD     @@NDP2        @@NDP                                        248024
     C                   ENDIF                                                                248024
     C                   ENDIF                                                                248024
     C                   GOTO      ZA0799                                                     248024
     C                   ENDIF                                                                248024
     C*
     C     @@IRAT        IFGE      100
     C                   Z-ADD     2             @@NDP
     C                   ELSE
     C     @@IRAT        IFLT      100
     C     @@IRAT        ANDGE     20
     C*******************Z-ADD     3             @@NDP                          143747
     C**********         Z-ADD     2             @@NDP                   143747 195763
     C                   Z-ADD     3             @@NDP                          195763
     C                   ELSE
     C     @@IRAT        IFLT      20
     C     @@IRAT        ANDGE     1
     C                   Z-ADD     4             @@NDP
     C                   ELSE
     C     @@IRAT        IFLT      1
     C*******************Z-ADD     5             @@NDP                          143747
     C**********         Z-ADD     4             @@NDP                   143747 195763
     C                   Z-ADD     5             @@NDP                          195763
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C     ZA0799        ENDSR
      *                                                                                       CER043
      *****************************************************************                     BUG23050
      *                                                               *                     BUG23050
      ** SrRepIn - Process to Default the correct Reciprocal Indicator*                     BUG23050
      *                                                               *                     BUG23050
      *  Called by: Main Processing                                   *                     BUG23050
      *                                                               *                     BUG23050
      *                                                               *                     BUG23050
      *****************************************************************                     BUG23050
      *                                                                                     BUG23050
     C     SrRepIn       BEGSR                                                              BUG23050
      **********                                                                  BUG23050  BUG23668
      **Calculate*for Gross spot rate from the screen input                       BUG23050  BUG23668
     C**********         EXSR      SrFwdMrgnPt                                    BUG23050  BUG23668
      *                                                                                     BUG23050
      **Calculate for system spot rate                                            BUG23050 BUG23050A
      **Default*the correct Reciprocal indicator and compute system deviation     BUG23050 BUG23050A
     C**********         EXSR      SrSySpotRte                                    BUG23050 BUG23050A
      *                                                                                     BUG23050
      *  Compare spot rate from screen input and calculated system spot rate.               BUG23050
      *  If the spot rate and entered rate are the same side                                BUG23050
      *  of +1.0, the default for Reciprocal will be set to 'N', otherwise, 'Y'.            BUG23050
                                                                                            BUG23050
     C                   IF        WSysSpotrt <  1 AND                                      BUG23050
     C                             @RRATE     >  1 OR                                       BUG23050
     C                             WSysSpotrt >  1 AND                                      BUG23050
     C                             @RRATE     <  1                                          BUG23050
     C                   EVAL      DDREIN = 'Y'                                             BUG23050
     C                   ELSE                                                               BUG23668
     C                   EVAL      DDREIN = 'N'                                             BUG23668
     C                   ENDIF                                                              BUG23050
      **Reset*spot rate field                                                     BUG23050 BUG23050A
     C**********         Z-ADD     *Zero         @RRATE                           BUG23050 BUG23050A
      *                                                                                     BUG23050
     C                   ENDSR                                                              BUG23050
      *****************************************************************                       CER043
      *                                                               *                       CER043
      ** SrBSAmtCal - Calculate buy and sell amount                   *                       CER043
      *                                                               *                       CER043
      *  Called by: Main Processing                                   *                       CER043
      *                                                               *                       CER043
      *  Calls: FmtAmt                                                *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      *                                                                                       CER043
     C     SrBSAmtCal    BEGSR                                                                CER043
      *                                                                                       CER043
      ** Check Reciprocal rate indicator                                                      CER043
      *                                                                                       CER043
     C**********         IF        DDREIN = 'Y'                                     CER043 BUG23050A
     C*****1****         DIV(H)    W@INRT        W@INRT                             CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      *                                                                                       CER043
      ** Buy amount entered                                                                   CER043
      *                                                                                       CER043
     C                   IF        DDSAMT = *BLANKS                                           CER043
     C                   EVAL      WF3DAM1 = %ABS(F3DAM1)                                     CER043
      *                                                                                       CER043
      ***Calculate Outright Forward/Margin Rate                                     CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         EXSR      SrFwdMrgnPt                                      CER043 BUG23050A
                                                                                              CER043
     C                   IF        DDREIN = 'N'                                             BUG25240
     C                   EVAL      WMDIN1 = 'M'                                             BUG25240
     C                   ELSE                                                               BUG25240
     C                   EVAL      WMDIN1 = 'D'                                             BUG25240
     C                   ENDIF                                                              BUG25240
      *                                                                                     BUG25240
     C                   CALLB     'ZCONV'                                                    CER043
     C                   PARM                    WF3DAM1                                      CER043
     C                   PARM                    @RRATE                                       CER043
     C**********         PARM      'M'           WMDIN                               CER043 BUG25240
     C                   PARM      WMDIN1        WMDIN                                      BUG25240
     C                   PARM                    DDBCCY                                       CER043
     C                   PARM                    DDSCCY                                       CER043
     C                   PARM                    @CDP1                                        CER043
     C                   PARM                    @CDP2                                        CER043
     C                   PARM                    POutAmt                                      CER043
                                                                                              CER043
     C                   IF        POutAmt <> *ZEROS                                          CER043
     C                   EVAL      F3DAM2 = POutAmt*(-1)                                      CER043
     C                   EVAL      ZFLD15 = %DEC(%ABS(F3DAM2):15:0)                           CER043
     C                   EVAL      ZDECS =  @CDP2                                             CER043
     C                   EVAL      ZCRET =  17                                              BUG21428
     C                   EXSR      FmtAmt                                                     CER043
     C                   EVAL      DDSAMT = %TRIM(ZOUT21)                                     CER043
     C     DDDLTP        IFEQ      'OT'                                                       CER043
     C     DDACTN        ANDEQ     'I'                                                        CER043
     C*****F3DAM2        ANDGT     RelDAM2                                           CER043 BUG22009
     C     RelDAM2       ANDGT     F3DAM2                                                   BUG22009
     C                   MOVE      'N'           DDSamtOK                                     CER043
     C                   ADD       1             Idx                                          CER043
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)                               CER043
     C                   MOVEL     'FXM0147'     MsgIdXAr(Idx)                                CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      DDSAmtOK = 'Y'                                             CER043
     C                   ENDIF                                                                CER043
     C                   ENDIF                                                                CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
      ** Sell amount entered                                                                  CER043
      *                                                                                       CER043
     C                   IF        DDBAMT = *BLANKS                                           CER043
     C                   EVAL      WF3DAM2 = %ABS(F3DAM2)                                     CER043
      *                                                                                       CER043
      ***Calculate Outright Forward/Margin Rate                                     CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         EXSR      SrFwdMrgnPt                                      CER043 BUG23050A
                                                                                              CER043
     C                   IF        DDREIN = 'N'                                             BUG25240
     C                   EVAL      WMDIN1 = 'D'                                             BUG25240
     C                   ELSE                                                               BUG25240
     C                   EVAL      WMDIN1 = 'M'                                             BUG25240
     C                   ENDIF                                                              BUG25240
      *                                                                                     BUG25240
     C                   CALLB     'ZCONV'                                                    CER043
     C                   PARM                    WF3DAM2                                      CER043
     C                   PARM                    @RRATE                                       CER043
     C**********         PARM      'D'           WMDIN                               CER043 BUG25240
     C                   PARM      WMDIN1        WMDIN                                      BUG25240
     C                   PARM                    DDSCCY                                       CER043
     C                   PARM                    DDBCCY                                       CER043
     C                   PARM                    @CDP2                                        CER043
     C                   PARM                    @CDP1                                        CER043
     C                   PARM                    POutAmt                                      CER043
                                                                                              CER043
     C                   IF        POutAmt <> *ZEROS                                          CER043
     C                   EVAL      F3DAM1 = POutAmt                                           CER043
     C                   EVAL      ZFLD15 = %DEC(%ABS(F3DAM1):15:0)                           CER043
     C                   EVAL      ZDECS = @CDP1                                              CER043
     c                   EVAL      ZCRET =  17                                              BUG22005
     C                   EXSR      FmtAmt                                                     CER043
     C                   EVAL      DDBAMT = %TRIM(ZOUT21)                                     CER043
     C     DDDLTP        IFEQ      'OT'                                                       CER043
     C     DDACTN        ANDEQ     'I'                                                        CER043
     C     F3DAM1        ANDGT     RelDAM1                                                    CER043
     C                   MOVE      'N'           DDBamtOK                                     CER043
     C                   ADD       1             Idx                                          CER043
     C                   MOVEL     'DDBAMT'      FldNamXAr(Idx)                               CER043
     C                   MOVEL     'FXM0145'     MsgIdXAr(Idx)                                CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      DDBAmtOK = 'Y'                                             CER043
     C                   ENDIF                                                                CER043
     C                   ENDIF                                                                CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      ** SrFwdMrgnPt - Calculate Outright Forward/Margin Rate         *                       CER043
      *                                                               *                       CER043
      *  Called by: SrBSAmtCal                                        *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      *                                                                                       CER043
     C     SrFwdMrgnPt   BEGSR                                                                CER043
     C                   Z-ADD     1             W@SFAC                                       CER043
     C     DDBCCY        IFEQ      BNCYDL                                                     CER043
     C                   Z-ADD     @@NDP2        W@NQDP                                       CER043
     C                   ADD       @@SXP2        W@SFAC                                       CER043
     C                   ELSE                                                                 CER043
     C     DDSCCY        IFEQ      BNCYDL                                                     CER043
     C                   Z-ADD     @@NDP1        W@NQDP                                       CER043
     C                   ADD       @@SXP1        W@SFAC                                       CER043
     C                   ELSE                                                                 CER043
     C*                                                                                       CER043
     C* Determine number of normally quoted decimal places                                    CER043
     C*                                                                                       CER043
     C                   Z-ADD     @@INRT        @@IRAT                                       CER043
     C                   EXSR      ZA0790                                                     CER043
     C                   Z-ADD     @@NDP         W@NQDP                                       CER043
     C                   ENDIF                                                                CER043
     C                   ENDIF                                                                CER043
     C*                                                                                       CER043
     C* Descale the input exchange rate                                                       CER043
     C*                                                                                       CER043
     C     W@INRT        DIV(H)    @SF(W@SFAC)   @SRATE                                       CER043
     C*                                                                                       CER043
     C* If the normally quoted decimal places is not zero                                     CER043
     C* Add (adjusted) forward points to margin                                               CER043
     C*                                                                                       CER043
     C     W@NQDP        IFNE      0                                                          CER043
     C     @@FPNT        DIV(H)    @AD(W@NQDP)   @RRATE                                       CER043
     C     S01453        IFEQ      'Y'                                                        CER043
     C*                  Z-ADD     @RRATE        @XRATE                                       CER043
     C     @SMGPT        DIV(H)    @AD(W@NQDP)   @@MADJ                                       CER043
     C                   ADD       @@MADJ        @RRATE                                       CER043
     C                   END                                                                  CER043
     C                   END                                                                  CER043
     C*                                                                                       CER043
     C* If the normally quoted decimal places is zero                                         CER043
     C* Add forward points to margin                                                          CER043
     C*                                                                                       CER043
     C     W@NQDP        IFEQ      0                                                          CER043
     C                   Z-ADD     @@FPNT        @RRATE                                       CER043
     C     S01453        IFEQ      'Y'                                                        CER043
     C*                  Z-ADD     @RRATE        @XRATE                                       CER043
     C                   ADD       @SMGPT        @RRATE                                       CER043
     C                   END                                                                  CER043
     C                   END                                                                  CER043
     C*                                                                                       CER043
     C* Descale margin + forward points                                                       CER043
     c*                                                                                       CER043
     C                   DIV       @SF(W@SFAC)   @RRATE                                       CER043
     C*                                                                                       CER043
     C* Add descaled exchange rate to descaled margin + forward points                        CER043
     C* to get the outright descaled rate                                                     CER043
     C*                                                                                       CER043
     C                   ADD       @SRATE        @RRATE                                       CER043
                                                                                              CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                     BUG23050
      *                                                               *                     BUG23050
      ** SrSySpotRte - Calculate System Spot Rate                     *                     BUG23050
      *                                                               *                     BUG23050
      *  Called by: SrBSAmtCal                                        *                     BUG23050
      *                                                               *                     BUG23050
      *****************************************************************                     BUG23050
      *                                                                                     BUG23050
     C     SrSySpotRte   BEGSR                                                              BUG23050
      *                                                                                     BUG23050
      *** Get System spot rate                                                              BUG23050
     C                   EVAL      WSysSpotrt = *ZEROS                                      BUG23050
                                                                                            BUG23050
     C                   IF        @SPOT1 <> *ZEROS and @SPOT2 <> *ZEROS                    BUG23050
      *                                                                                     BUG23050
      * Mult./divide ind. the same                                                          BUG23050
     C                   IF        @@MDF1 = @@MDF2                                          BUG23050
      *                                                                                     BUG23050
      * If both multiply calc. is rate1/rate2.                                              BUG23050
      * If both divide calc. is rate2/rate1.                                                BUG23050
     C                   IF        @@MDF1 = 'M'                                             BUG23050
     C                   EVAL(H)   WSysSpotrt = @SPOT1 / @SPOT2                             BUG23050
     C                   ELSE                                                               BUG23050
     C                   EVAL(H)   WSysSpotrt = @SPOT2 / @SPOT1                             BUG23050
     C                   ENDIF                                                              BUG23050
      *                                                                                     BUG23050
      * Mult./divide ind. not the same                                                      BUG23050
     C                   ELSE                                                               BUG23050
      *                                                                                     BUG23050
      * If rate1 is mult. & rate2 is divide calc. is rate1 x rate2.                         BUG23050
      * If rate1 is divide & rate2 is mult. calc. is 1/(rate1 x rate2).                     BUG23050
      *                                                                                     BUG23050
     C                   IF        @@MDF1 = 'M'                                             BUG23050
     C                   EVAL(H)   WSysSpotrt = @SPOT1 * @SPOT2                             BUG23050
     C                   ELSE                                                               BUG23050
     C                   EVAL(H)   WSysSpotrt = 1 / (@SPOT1 * @SPOT2)                       BUG23050
     C                   ENDIF                                                              BUG23050
                                                                                            BUG23050
     C                   ENDIF                                                              BUG23050
      *                                                                                     BUG23050
     C                   ENDIF                                                              BUG23050
      *                                                                                     BUG23050
     C                   ENDSR                                                              BUG23050
      *****************************************************************           BUG23668 BUG23668D
      *                                                               *           BUG23668 BUG23668D
      ** SrSpRtOverlap - Check if spot rates are close to 1 and       *           BUG23668 BUG23668D
      *                  overlaps                                     *           BUG23668 BUG23668D
      *                                                               *           BUG23668 BUG23668D
      *****************************************************************           BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C*****SrSpRtOverlap BEGSR                                                    BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
      * If*the*spot rate and the reciprocal rate of the spot rate are both        BUG23668 BUG23668D
      **close*to 1 of the base currency, and overlap due to the exchange rate     BUG23668 BUG23668D
      **range*specified, the defaulting will be always 'N' and send warning       BUG23668 BUG23668D
      **message.                                                                  BUG23668 BUG23668D
     C**********         EVAL      WOverlap = 'N'                                 BUG23668 BUG23668D
     C**********         EVAL(H)   WSysSpotrtN = WSysSpotrt                       BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
      **Retrieve entered Exchange Rate + margin +forward points and the Inv rate  BUG23668 BUG23668D
     C**********         EVAL      WRrateInv = 1/@RRATE                           BUG23668 BUG23668B
     C**********         EVAL(H)   WRrateInv = 1/@RRATE                          BUG23668B BUG23668D
      **********                                                                  BUG23668 BUG23668D
      **Get*reciprocal rate of the spot rate                                      BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C**********         EVAL(H)   WSysSpotrtInv = 1/WSysSpotrtN                  BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
      ***Get*highest Exchange rate tolerance range from file                     BUG23668A BUG23668D
     C**********         IF        @NEXRT1 >= @NEXRT2                            BUG23668A BUG23668D
     C**********         EVAL      WRetpD = @NEXRT1/100                          BUG23668A BUG23668D
     C**********         ELSE                                                    BUG23668A BUG23668D
     C**********         EVAL      WRetpD = @NEXRT2/100                          BUG23668A BUG23668D
     C**********         ENDIF                                                   BUG23668A BUG23668D
      **********                                                                 BUG23668A BUG23668D
      **Check*which of the currencies is the base currency for Dealing.           BUG23668 BUG23668A
      **If*one*is the base ccy, use the tolerance from ICD. If none is a base     BUG23668 BUG23668A
      **ccy,*calculate the tolerance between the two non-base ccy using the toleraBUG23668 BUG23668A
      **of*each*ccy against the base ccy.                                         BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668D
     C**********         IF        DDBCCY =  BNCYDL OR                            BUG23668 BUG23668A
     C**********                   DDSCCY =  BNCYDL                               BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668D
      **Obtain*limits of Spot Rate and Inverse Spot rate by using the             BUG23668 BUG23668A
      **Exch*rate tolerance of BASE ccy.                                          BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668D
     C**********         EVAL(H)   WSsr10 = WSysSpotrtN * TOLRAN                  BUG23668 BUG23668A
     C**********         EVAL(H)   WIsr10 = WSysSpotrtInv * TOLRAN                BUG23668 BUG23668A
      **********                                                                 BUG23668A BUG23668D
      **If*one*of the ccys is base ccy,                                          BUG23668A BUG23668D
      **Obtain*limits of Spot Rate and Inverse Spot rate by using the            BUG23668A BUG23668D
      **Exch*rate tolerance of ccy which is not the base                         BUG23668A BUG23668D
      **If*none*of the ccys is base ccy, get the highest exch rate tol.          BUG23668A BUG23668D
      **********                                                                 BUG23668A BUG23668D
     C**********         EVAL(H)   WSsr10 = WSysSpotrtN * WRetpD                 BUG23668A BUG23668D
     C**********         EVAL(H)   WIsr10 = WSysSpotrtInv * WRetpD               BUG23668A BUG23668D
      **********                                                                  BUG23668 BUG23668D
      **Obtain*Upper and Lower Limits of Spot rate and Inverse Spot rate          BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C**********         EVAL(H)   WSysSpotrtNU = WSysSpotrtN + WSsr10            BUG23668 BUG23668D
     C**********         EVAL(H)   WSysSpotrtNL = WSysSpotrtN - WSsr10            BUG23668 BUG23668D
     C**********         EVAL(H)   WSysSpotrtInvU =  WSysSpotrtInv + WIsr1        BUG23668 BUG23668D
     C**********         EVAL(H)   WSysSpotrtInvL =  WSysSpotrtInv - WIsr1        BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C**********         ELSE                                                     BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668A
      **Obtain*Limits of non-base ccys against the tolerance of base ccy         BUG23668A BUG23668D
      **********                                                                  BUG23668 BUG23668A
     C**********         EVAL(H)   WSsr10 = 1 + TOLRAN                            BUG23668 BUG23668A
     C**********         EVAL(H)   WIsr10 = 1 - TOLRAN                            BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668A
     C**********         EVAL(H)   WSysSpotrtNU = WSysSpotrtN * WSsr10            BUG23668 BUG23668A
     C**********         EVAL(H)   WSysSpotrtNL = WSysSpotrtN * WIsr10            BUG23668 BUG23668A
     C**********         EVAL(H)   WSysSpotrtInvU =  WSysSpotrtInv * WSsr10       BUG23668 BUG23668A
     C**********         EVAL(H)   WSysSpotrtInvL =  WSysSpotrtInv * WIsr10       BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668A
     C**********         ENDIF                                                    BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668D
      **If*rate* is a Multiply,                                                   BUG23668 BUG23668A
      **If*Upper Limit of Spot rate is greater than the Lower limit of I         BUG23668A BUG23668D
      **spot*rate, spot rates overlapped                                          BUG23668 BUG23668A
      **If*rate* is Divide,                                                       BUG23668 BUG23668A
      **If*Upper limit of Inv. Spot Rt is greater than the Lower limit o          BUG23668 BUG23668D
      **Normal*Spot rate, spot rates overlapped                                   BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C**********         IF        WSysSpotrtNU > WSysSpotrtInvL OR               BUG23668 BUG23668A
     C**********                   WSysSpotrtInvU > WSysSpotrtNL                  BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668D
     C**********         IF        WSysSpotrtNU >= WSysSpotrtInvL AND            BUG23668C BUG23668D
     C**********                   WSysSpotrtInvU >= WSysSpotrtNL                BUG23668C BUG23668D
      **********                                                                 BUG23668B BUG23668D
     C**********         IF        WSysSpotrtNL <= WSysSpotrtInvL AND            BUG23668C BUG23668D
     C**********                   WSysSpotrtNU <= WSysSpotrtInvU                BUG23668C BUG23668D
      **********                                                                 BUG23668C BUG23668D
     C**********         IF        @RRATE >= WSysSpotrtInvL AND                  BUG23668C BUG23668D
     C**********                   @RRATE <= WSysSpotrtNU                        BUG23668C BUG23668D
     C**********         EVAL      WOverlap = 'Y'                                BUG23668C BUG23668D
     C**********         EVAL      DDREIN = 'N'                                  BUG23668C BUG23668D
     C**********         ENDIF                                                   BUG23668C BUG23668D
      **********                                                                 BUG23668C BUG23668D
     C**********         ELSE                                                    BUG23668C BUG23668D
     C**********         IF        WSysSpotrtInvL <= WSysSpotrtNL AND            BUG23668C BUG23668D
     C**********                   WSysSpotrtInvU <= WSysSpotrtNU                BUG23668C BUG23668D
      **********                                                                 BUG23668C BUG23668D
      **If*entered exch rate is within the overlapping range, tag Overlap flag    BUG23668 BUG23668D
      **and*default recip. rate indicator as 'N' and send warning msg.            BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C**********         IF        (WRrateInv  < WSysSpotrtNU AND                 BUG23668 BUG23668A
     C**********                    WRrateInv  > WSysSpotrtInvL) OR               BUG23668 BUG23668A
     C**********                   (@RRATE    < WSysSpotrtInvU AND                BUG23668 BUG23668A
     C**********                    @RRATE     > WSysSpotrtNL)                    BUG23668 BUG23668A
     C**********         IF        (@RRATE    <= WSysSpotrtInvU AND              BUG23668A BUG23668D
     C**********                    @RRATE     >= WSysSpotrtNL)                  BUG23668A BUG23668D
     C**********                    OR                                           BUG23668C BUG23668D
     C**********                   (@RRATE    <= WSysSpotrtNU   AND              BUG23668C BUG23668D
     C**********                    @RRATE    >= WSysSpotrtInvL)                 BUG23668C BUG23668D
     C**********         EVAL      WOverlap = 'Y'                                 BUG23668 BUG23668D
     C**********         EVAL      DDREIN = 'N'                                   BUG23668 BUG23668D
     C**********         ELSE                                                    BUG23668C BUG23668D
     C**********         EVAL      WOverlap = 'N'                                BUG23668C BUG23668D
     C**********         ENDIF                                                   BUG23668C BUG23668D
      **********                                                                 BUG23668C BUG23668D
     C**********         ENDIF                                                    BUG23668 BUG23668D
     C**********         ENDIF                                                   BUG23668B BUG23668D
     C**********         ENDIF                                                    BUG23668 BUG23668A
      **********                                                                  BUG23668 BUG23668D
      **Send*Message:                                                             BUG23668 BUG23668D
      **"***WARNING ** Spot Rate and Reciprocal rate of Spot Rate are both close tBUG23668 BUG23668D
      **********       and overlapped due to the exchange rate range specified....BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C**********         IF        WOverlap = 'Y'                                 BUG23668 BUG23668D
     C**********         EVAL      WIx = WIx + 1                                  BUG23668 BUG23668D
     C**********         EVAL      WFldNmXAr(WIx) = 'DDREIN'                      BUG23668 BUG23668D
     C**********         EVAL      WMsgIDXAr(WIx) = 'USR8012'                     BUG23668 BUG23668D
     C**********         ENDIF                                                    BUG23668 BUG23668D
      **********                                                                  BUG23668 BUG23668D
     C**********         ENDSR                                                    BUG23668 BUG23668D
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      ** FmtAmt - Format amount for display                           *                       CER043
      *                                                               *                       CER043
      *  Called by: SrBSAmtCal                                        *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      *                                                                                       CER043
     C     FMTAMT        BEGSR                                                                CER043
                                                                                              CER043
     C**********         CALLB     'ZSEDIT'                                          CER043 BUG21428
     C**********         PARM                    ZFLD15                              CER043 BUG21428
     C**********         PARM                    ZDECS                               CER043 BUG21428
     C**********         PARM      *BLANKS       ZECODE                              CER043 BUG21428
     C**********         PARM                    ZOUT21                              CER043 BUG21428
                                                                                              CER043
     C                   CALLB     'ZA1020'                                                 BUG21428
     C                   PARM                    ZFLD15                                     BUG21428
     C                   PARM                    ZCRET                                      BUG21428
     C                   PARM                    ZDECS                                      BUG21428
     C                   PARM                    BNDCSP                                     BUG21428
     C                   PARM                    BNTHSP                                     BUG21428
     C                   PARM                    ZOUT21                                     BUG21428
                                                                                            BUG21428
     C                   EVAL      ZFLD15 = *ZEROS                                            CER043
                                                                                              CER043
     C                   ENDSR                                                                CER043
      *****************************************************************
      /EJECT
      *****************************************************************                    BUG23050A
      * SrOptTake  - Validate option take down                                             BUG23050A
      *****************************************************************                    BUG23050A
     C     SrOptTake     BEGSR                                                             BUG23050A
                                                                                           BUG23050A
     C     DDDLTP        IFEQ      'OT'                                                    BUG23050A
     C     S01453        IFEQ      'Y'                                                     BUG23050A
     C                   Z-ADD     RelOSRT       OPDLAMT          13 8                     BUG23050A
     C                   ELSE                                                              BUG23050A
     C                   Z-ADD     RelDXRT       OPDLAMT                                   BUG23050A
     C                   ENDIF                                                             BUG23050A
      * Accept only if entered rate is exactly what is on the option deal.                 BUG23050A
                                                                                           BUG23050A
     C     @RRATE        IFNE      OPDLAMT                                                 BUG23050A
     C                   MOVE      'N'           DDRateOK                                  BUG23050A
     C                   ADD       1             Idx                                       BUG23050A
     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                            BUG23050A
     C                   MOVEL     'FXM0140'     MsgIdXAr(Idx)                             BUG23050A
     C                   ENDIF                                                             BUG23050A
     C                   ENDIF                                                             BUG23050A
                                                                                           BUG23050A
     C                   ENDSR                                                             BUG23050A
      *****************************************************************                    BUG23050A
      /EJECT                                                                               BUG23050A
      * SrDeviation - Get System Deviation                                                 BUG23050A
      *****************************************************************                    BUG23050A
     C     SrDeviation   BEGSR                                                             BUG23050A
                                                                                           BUG23050A
      *** Get  the highest Exchange rate tolerance                                         BUG23050A
      *                                                                                    BUG23050A
     C                   IF        @NEXRT1 >= @NEXRT2                                      BUG23050A
     C                   EVAL      WRetp = @NEXRT1                                         BUG23050A
     C                   EVAL      WCcy = DDBCCY                                           BUG23050A
     C                   ELSE                                                              BUG23050A
     C                   EVAL      WRetp = @NEXRT2                                         BUG23050A
     C                   EVAL      WCcy = DDSCCY                                           BUG23050A
     C                   ENDIF                                                             BUG23050A
      *                                                                                    BUG23050A
      *** Compute for system deviation                                                     BUG23050A
      *                                                                                    BUG23050A
     C**********         EVAL(H)   WDeviatn =                                     BUG23050A BUG25240
     C**********                   %ABS(WSysSpotrt-@RRATE) *100 / WSysSpotrt      BUG23050A BUG25240
      *                                                                                     BUG25284
     C                   IF        DDREIN = 'Y'                                             BUG25284
     C                   EVAL(H)   WDeviatn =                                               BUG25240
     C                             %ABS(WSysSpotrt-@RRATE1) *100 / WSysSpotrt               BUG25240
     C                   ELSE                                                               BUG25284
     C                   EVAL(H)   WDeviatn =                                               BUG25284
     C                             %ABS(WSysSpotrt-@RRATE) *100 / WSysSpotrt                BUG25284
     C                   ENDIF                                                              BUG25284
                                                                                           BUG23050A
     C                   IF        WDeviatn > WRetp                                        BUG23050A
     C                   EVAL      WIx = WIx + 1                                           BUG23050A
     C                   EVAL      WFldNmXAr(WIx) = 'DDRAT1'                               BUG23050A
     C                   EVAL      WMsgIDXAr(WIx) = 'USR8007'                              BUG23050A
     C                   EVAL      WRK1 = DDBCCY                                           BUG23050A
     C                   EVAL      WRK2 = DDSCCY                                           BUG23050A
     C                   EVAL      WRK3 = %CHAR(WDeviatn)                                  BUG23050A
     C                   IF        WRetp = *ZERO                                            BUG23579
     C                   EVAL      WRK4 = '0      '                                         BUG23579
     C                   ELSE                                                               BUG23579
     C                   EVAL      WRK4 = %CHAR(WRetp)                                     BUG23050A
     C                   ENDIF                                                              BUG23579
     C                   EVAL      WRK5 = WCcy                                             BUG23050A
     C**********         EVAL      WMsgDtXAr(WIx) = DSWRK                         BUG23050A MD000091
     C                   EVAL      BLen = %Len(%Trim(WRK1))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(WRK1)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(WRK2))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr +%TRIM(WRK2)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(WRK3))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr +%TRIM(WRK3)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(WRK4))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr +%TRIM(WRK4)                     MD000091
     C                   EVAL      BLen = %Len(%Trim(WRK5))                                 MD000091
     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
     C                                            + LenStr +%TRIM(WRK5)                     MD000091
     C                   ENDIF                                                             BUG23050A
                                                                                           BUG23050A
     C                   ENDSR                                                             BUG23050A
      *****************************************************************                    BUG23050A
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code   CER043
     C                   PARM                    DDDLTP            2            deal type     CER043
     C                   PARM                    DDBAMT           14            buy amount    CER043
     C                   PARM                    DDSAMT           14            sell amount   CER043
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch  CER043
      *
     C                   PARM                    W@INRT           13 8          scaled exch rate
     C                   PARM                    @@INRT           13 8          rate + fwd pts
     C**********         PARM                    @@INRTR          13 8            BUG23050A BUG23668
     C                   PARM                    @@FPNT            7 2          forward points
     C                   PARM                    @@MGPT            7 2          margin points
      *
     C                   PARM                    F3DAM1           15 0          amount
      *
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @RDCY1            1            round down
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@MDF1            1            mult/div ind
     C                   PARM                    @NEXRT1           5 2                     BUG23050A
      *
     C                   PARM                    F3DAM2           15 0          amount
      *
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @RDCY2            1            round down
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
     C                   PARM                    @@MDF2            1            mult/div ind
     C                   PARM                    @NEXRT2           5 2                     BUG23050A
      *                                                                                       238023
     C                   PARM                    F3MGBS            1            marg indicator238023
      *                                                                                       CER043
      ** Reciprocal rate indicator, exchange rate                                             CER043
      *                                                                                       CER043
      ** INPUT/OUTPUT                                                                       BUG23050
     C                   PARM                    DDREIN                                       CER043
      *
      ** ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BNCYDL            3
     C                   PARM                    BNEXRT            3 1
     C                   PARM                    BNDCSP            1
     C                   PARM                    S01391            1
     C                   PARM                    S01453            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Buy Amount - OK
      ** Sell Amount - OK
      ** Rate - OK
     C                   PARM                    DDBamtOK          1
     C                   PARM                    DDSamtOK          1
     C                   PARM                    DDRateOK          1
      *
      ** Multiply/Div Ind, Exchange Rate
      ** Descaled Exchange Rate, Rate+Mgn+Fwd Pts, Rate+Fwd Pts
      *
     C                   PARM                    F3DMD1            1            mult/div ind
     C                   PARM                    F3DXRT           13 8          exch rate
     C                   PARM                    @SRATE           13 8          Descaled exch rt
     C                   PARM                    @RRATE           13 8          Rate+mgn+fwd pts
     C                   PARM                    @XRATE           13 8          Rate+fwd pts
     C**********         PARM                    F3OSRT           13 8            BUG23050A BUG23668
      *
      ** WORK OUT TOLERANCE AS A PERCENTAGE
      *
     C     BNEXRT        DIV       100           TOLRAN            3 3
      *
      ** Check if any one of the CCY is round down CCY, and whether JSM
      ** had been set on.  If so, checking should use the calculated
      ** amount to test for 1 unit tolerance.
      *
     C     S01391        IFEQ      'Y'
     C     @RDCY1        ANDEQ     'Y'
     C     S01391        OREQ      'Y'
     C     @RDCY2        ANDEQ     'Y'
     C                   MOVEL     'Y'           @ROUND            1
     C                   ELSE
     C                   MOVEL     'N'           @ROUND            1
     C                   END
     C/COPY WNCPYSRC,FXH00017
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 1                                                  CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
     C/COPY OFCPYSRCZ,CDL091_011                                                              CDL091
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**   @@AY   - Array of powers of 10.
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
** Scaling factors array - @SF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
** @AD Adjust Decimals (for applying NQDP)
000000010
000000100
000001000
000010000
000100000
001000000
010000000
100000000
**   POW - POWERS OF 10
0000001
0000010
0000100
0001000
0010000
0100000
1000000
