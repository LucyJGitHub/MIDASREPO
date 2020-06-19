000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas FX Validate exchange rate versus amounts')       *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Standard subprograms                                 *
000900200529      *                                                               *
001000200529      *  FXVEXCHVAM - Validate Exchange Rate Versus Amounts           *
001100200529      *                                                               *
001200200529      *  (c) Finastra International Limited 2001                      *
001300200529      *                                                               *
001400200529      *    This source is centrally supported and must ONLY be        *
001500200529      *    amended by Core Development Personnel                      *
001600200529      *                                                               *
001700200529      *    /COPY, Client or Country amendments must not be            *
001800200529      *    applied to this source.                                    *
001900200529      *                                                               *
002000200604      *  Last Amend No. 251863             Date 22May20               *
002100200604      *  Prev Amend No. 248024             Date 22May20               *
002200200604      *                 MD046248           Date 27Oct17               *
002300200529      *                 AR703547           Date 25May16               *
002400200529      *                 AR808714           Date 04Jun15               *
002500200529      *                 258321             Date 19Aug14               *
002600200529      *                 256537             Date 15Mar13               *
002700200529      *                 MD000091           Date 07May13               *
002800200529      *                 CDL091             Date 12Dec12               *
002900200529      *                 CER059             Date 19Jul10               *
003000200529      *                 BUG26662           Date 04Nov09               *
003100200529      *                 BUG25284           Date 29Jul09               *
003200200529      *                 BUG25418           Date 07Aug09               *
003300200529      *                 BUG25240A          Date 05Aug09               *
003400200529      *                 BUG25240           Date 29Jul09               *
003500200529      *                 BUG23668E          Date 25May09               *
003600200529      *                 BUG23668D          Date 25May09               *
003700200529      *                 BUG23668C          Date 22May09               *
003800200529      *                 BUG23668B          Date 04May09               *
003900200529      *                 BUG23579           Date 30Mar09               *
004000200529      *                 BUG23668A          Date 04May09               *
004100200529      *                 BUG23668           Date 01Apr09               *
004200200529      *                 BUG23050A          Date 11Mar09               *
004300200529      *                 BUG23050           Date 23Feb09               *
004400200529      *                 BUG22009           Date 25Jan09               *
004500200529      *                 BUG22005           Date 21Jan09               *
004600200529      *                 BUG21428           Date 29Oct08               *
004700200529      *                 CER043             Date 19May08               *
004800200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
004900200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
005000200529      *                 256564             Date 17Sep08               *
005100200529      *                 BUG13209A          Date 16Feb07               *
005200200529      *                 BUG13209           Date 07Feb07               *
005300200529      * Midas Plus 1.3 ----------- Base ------------------------------*
005400200529      *                 235142             Date 16Oct06               *
005500200529      *                 BUG5960            Date 24Mar05               *
005600200529      *                 224474             Date 20Jan04               *
005700200529      *                 210153             Date 20Mar03               *
005800200529      * Midas Release 4.01.02 ----------------------------------------*
005900200529      *                 209009             Date 03Sep02               *
006000200529      *                 207744             Date 24Jul02               *
006100200529      * Midas Release 4.01 -------------------------------------------*
006200200529      *                 195763             Date 24Dec01               *
006300200529      * Midas Release 4 --------------- Base -------------------------*
006400200529      * Midas DBA 3.05 -----------------------------------------------*
006500200529      *                 186377             Date 13Dec00               *
006600200529      * Midas DBA 3.03 -----------------------------------------------*
006700200529      *                 175229             Date 10Mar00               *
006800200529      * Midas DBA 3.00 ---------------- Base -------------------------*
006900200529      *                 143747             Date 28Sep98               *
007000200529      *                 CAP002  *CREATE    Date 08Sep97               *
007100200529      *                                                               *
007200200529      *---------------------------------------------------------------*
007300200529      *                                                               *
007400200529      *  248024 - Change in processing to determine 'Normally Quoted  *
007500200529      *           Decimal Places' for Forward Points. Applied fix     *
007600200529      *           242105.                                             *
007700200529      *  251863 - Applied fixes 240038 and 238023.                    *
007800200529      *  240038 - Ensure margin rate functionalities are catered.     *
007900200529      *           Enhanced fix 238023 and patterned to SR/#ZICA.      *
008000200529      *  238023 - Incorrect exchange rate written on file. Ensure     *
008100200529      *           that buy/sell currencies with different decimal     *
008200200529      *           places are catered in margin rate functionalities.  *
008300200529      *           Exchange rate and amounts do not agree is shown.    *
008400200529      *           Program was amended such that validation of margin  *
008500200529      *           follow its functionality.                           *
008600200529      *  MD046248 - Finastra Rebranding                               *
008700200529      *  AR703547 - Different validation when Buy/Sell=Deal ccy and if*
008800200529      *             buy/sell<>deal ccy. @Round ind. is being checked  *
008900200529      *             for buy/sell=deal ccy. 2 unit diff is allowed when*
009000200529      *             @Round=Y for buy/sell=deal ccy unlike when buy/   *
009100200529      *             sell <> deal ccy. (Child artifact: AR703548)      *
009200200529      *             Applied for MD-37680.                             *
009300200529      *  AR808714 - Cannot insert OT deal, exchange rate validation.  *
009400200529      *             Do not issue error FXM4003 if rate is close to 1  *
009500200529      *             and amounts are correct. Applied fix AR599429.    *
009600200529      *             (Child: AR813475) - applied for MD032227.         *
009700200529      *  258321 - Make sure that when spot rate/the inverse of the    *
009800200529      *           spot rate is too close, multiply/divide indicator   *
009900200529      *           is correct. W@MDIN would not be left blank.         *
010000200529      *  256537 - Determine @@XX before multiplying to computed work  *
010100200529      *           field @WRKT2.                                       *
010200200529      *         - Applied for AR1091926. (Child: AR1093951)           *
010300200529      *  MD000091 - Event Codes Substitution                          *
010400200529      *  CDL091 - FX Auto Calculation (GIB016)                        *
010500200529      *         - Added hooks :                                       *
010600200529      *           CDL091_007                                          *
010700200529      *           CDL091_008                                          *
010800200529      *           CDL091_009                                          *
010900200529      *           CDL091_010                                          *
011000200529      *           CDL091_011                                          *
011100200529      *                                                               *
011200200529      *  CER059 - German Feature Upgrade to Delhi                     *
011300200529      *  BUG26662 - A serious Midas error occurs upon completion      *
011400200529      *  BUG25284 - Incorrect deviation and tolerance warning shown   *
011500200529      *  BUG25418 - Incorrect rate shown in Correspondence confir -   *
011600200529      *             mation report                                     *
011700200529      *  BUG25240A - Reciprocal Rate Indicator Function reopened      *
011800200529      *             Applied Gems fix 224375.                          *
011900200529      *  BUG25240 - Reciprocal Rate Indicator Function                *
012000200529      *  BUG23668E - Reopened due to rate entered is not equal with   *
012100200529      *             rate from file.                                   *
012200200529      *  BUG23668D - Reopened due to change in design. Overlap in     *
012300200529      *             spot rates will no longer be considered when      *
012400200529      *             determining reciprocal rate indicator default     *
012500200529      *             value. Only 'close to 1' approach will be used    *
012600200529      *             which was introduced by 23050.                    *
012700200529      *  BUG23668C- Defaulting of Reciprocal rate indicator when spot *
012800200529      *             rate is close to 1.                               *
012900200529      *  BUG23668B- Defaulting of Reciprocal rate indicator when spot *
013000200529      *             rate is close to 1.                               *
013100200529      *  BUG23579 - Exchange Rate Tolerance of 0 is incorrectly       *
013200200529      *             displayed in tolerance warning message            *
013300200529      *  BUG23668A- Defaulting of Reciprocal rate indicator when spot *
013400200529      *             rate is close to 1.                               *
013500200529      *  BUG23668 - Defaulting of Reciprocal rate indicator when spot *
013600200529      *             rate is close to 1.                               *
013700200529      *  BUG23050A- Reciprocal indicator being defaulted.             *
013800200529      *             Defaulting of Reciprocal Rate indicator(FGE002).  *
013900200529      *  BUG23050 - Reciprocal indicator being defaulted              *
014000200529      *  BUG22009 - Reciprocal rate not accepted in FXDL type Option  *
014100200529      *             Takedown.                                         *
014200200529      *  BUG22005 - Fix Midas Serious Error when Buy Amount is blank  *
014300200529      *             Number of character return not setup.             *
014400200529      *  BUG21428 - Buy/sell amount does not default                  *
014500200529      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
014600200529      *  256564 - Recompile due to PF changes done by fix 256330      *
014700200529      *  BUG13209A - (Reopen) Partially remove BUG13209. Add fix to   *
014800200529      *              change value of @@XX array index field to de-    *
014900200529      *              duct value 4 from @@XX to correctly use number   *
015000200529      *              to be multiplied to computed work field @WKRT2.  *
015100200529      *  BUG13209 - Increase size of fields @SPTE2,@HRTE2,@LRTE2      *
015200200529      *             and @WKRT2.                                       *
015300200529      *  235142 - Apply the correct decimal places for variable       *
015400200529      *           @WKRT2.                                             *
015500200529      *  BUG5960- Determine DP adjustment BEFORE checking the rate    *
015600200529      *  224474 - Use DDRAT1 instead of DDRATE                        *
015700200529      *  210153 - Correctly compare exchange rate against range       *
015800200529      *           tolerance.  Apply fix 204542.                       *
015900200529      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
016000200529      *           FXCPYSRC.                                           *
016100200529      *  207744 - Incorrect incorporation of 175229.                  *
016200200529      *  195763 - Forward points should be same as in TOF.            *
016300200529      *  186377 - No warning message though exchange rate outside the *
016400200529      *           tolerance specified.                                *
016500200529      *  175229 - Applied fix 171828:                                 *
016600200529      *           Error in Cross-ccy calcs after tolernace check      *
016700200529      *  143747 - Forward points conversion error                     *
016800200529      *  CAP002 - Conversion of FX inputs into modular structure to   *
016900200529      *           use as APIs.                                        *
017000200529      *                                                               *
017100200529      *****************************************************************
017200200529
017300200529      *****************************************************************
017400200529      ** +--------------------------------------+
017500200529      ** ¦ Automatically included D-specs       ¦
017600200529      ** ¦ ==============================       ¦
017700200529      ** +--------------------------------------+
017800200529      **
017900200529      ** Standard D-specs
018000200529      ** ================
018100200529      **
018200200529      ** The following /COPY line includes the LDA layout,
018300200529      ** the copyright array definition,
018400200529      ** and the following named constants:
018500200529      **    True       logical = *on (for indcator processing)
018600200529      **    False      logical = *off (for indcator processing)
018700200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
018800200529      **                                    handler)
018900200529      ** and the following variables:
019000200529      **    RunBefore  1A (for the PSSR)
019100200529
019200200529     D/COPY ZACPYSRC,STD_D_SPEC
019300200529
019400200529      ** Include the FX standard declares
019500200529     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
019600200529     D/COPY ZACPYSRC,STDDECLARE                                                               209009
019700200529
019800200529      ** Program Status Data Structure
019900200529      ** =============================
020000200529      ** The following /COPY line includes all the defined fields in the
020100200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
020200200529
020300200529     D/COPY ZACPYSRC,PSDS
020400200529
020500200529      ** +--------------------------------------+
020600200529      ** ¦ End of automatically included D-specs¦
020700200529      ** ¦ =====================================¦
020800200529      ** +--------------------------------------+
020900200529
021000200529      *****************************************************************
021100200529      /EJECT
021200200529      *****************************************************************
021300200529
021400200529      ** +--------------------------------------+
021500200529      ** ¦ Manually included D-specs            ¦
021600200529      ** ¦ =========================            ¦
021700200529      ** +--------------------------------------+
021800200529     D/COPY WNCPYSRC,FXH00012
021900200529
022000200529      ** +--------------------------------------+
022100200529      ** ¦ Named constants                      ¦
022200200529      ** ¦ ===============                      ¦
022300200529      ** +--------------------------------------+
022400200529
022500200529      ** The maximum size of the appended error arrays
022600200529     D XArrayMax       C                   CONST(20)
022700200529
022800200529      ** +--------------------------------------+
022900200529      ** ¦ Arrays and Data Structures           ¦
023000200529      ** ¦ ==========================           ¦
023100200529      ** +--------------------------------------+
023200200529
023300200529      ** Array of Fields in error.
023400200529     D FldNamXAr       S             10A   DIM(XArrayMax)
023500200529
023600200529      ** Array of error message IDs
023700200529     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
023800200529
023900200529      ** Array of error message data.
024000200529     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
024100200529
024200200529      ** Array of Fields with warnings.
024300200529     D WFldNmXAr       S             10A   DIM(XArrayMax)
024400200529
024500200529      ** Array of warning message IDs
024600200529     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
024700200529
024800200529      ** Array of warning message data.
024900200529     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
025000200529
025100200529                                                                                              CER043
025200200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
025300200529      ** EXTERNAL DS FOR SAR DETAILS                                                          CER043
025400200529                                                                                              CER043
025500200529     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER043
025600200529      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    CER043
025700200529     D RelDealDts      DS           113                                                       CER043
025800200529      ** Related Deal Details (when deal is option takedown or swap.                          CER043
025900200529      ** Thus related deal will be other leg of swap or option).                              CER043
026000200529     D  RelCCY1                4      6                                                       CER043
026100200529     D  RelCCY2                7      9                                                       CER043
026200200529     D  RelDAM1               10     24  0                                                    CER043
026300200529     D  RelDAM2               25     39  0                                                    CER043
026400200529     D  RelDXRT               88    100  8                                                 BUG23050A
026500200529     D  RelOSRT              101    113  8                                                 BUG23050A
026600200529
026700200529     D @@AY            S             10  0 DIM(10) CTDATA PERRCD(1)
026800200529     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
026900200529     D @AD             S              9  0 DIM(8) CTDATA PERRCD(1)              Adjust Decimal
027000200529     D POW             S              7  3 DIM(7) CTDATA PERRCD(1)
027100200529
027200200529
027300200529     D                 DS
027400200529     D  @Y                     1     16
027500200529     D                                     DIM(16) ASCEND                       #ZICC  Amt.char.
027600200529     D  W@AMTP                 1     16
027700200529     D  W@AMTD                 1     17
027800200529
027900200529
028000200529     D                 DS
028100200529     D  @P                     1     15  0
028200200529     D                                     DIM(15)                              #ZICC  Amt.num.
028300200529     D  W@AMNT                 1     15  0
028400200529     D  W@AMTR                 3     15  8
028500200529
028600200529
028700200529     D                 DS
028800200529     D  W@1150                 1     15  0
028900200529     D  W@1151                 1     15  1
029000200529     D  W@1152                 1     15  2
029100200529     D  W@1153                 1     15  3
029200200529
029300200529
029400200529     D                 DS
029500200529     D  W@2150                 1     15  0
029600200529     D  W@2151                 1     15  1
029700200529     D  W@2152                 1     15  2
029800200529     D  W@2153                 1     15  3
029900200529
030000200529
030100200529     D                 DS
030200200529     D  W@3150                 1     15  0
030300200529     D  W@3151                 1     15  1
030400200529     D  W@3152                 1     15  2
030500200529     D  W@3153                 1     15  3
030600200529
030700200529
030800200529     D                 DS
030900200529     D  W@4150                 1     15  0
031000200529     D  W@4151                 1     15  1
031100200529     D  W@4152                 1     15  2
031200200529     D  W@4153                 1     15  3
031300200529
031400200529
031500200529     D M@MGDA          DS
031600200529     D  M@0145                 1     45
031700200529     D  M@0115                 1     15
031800200529     D  M@1630                16     30
031900200529
032000200529      ** +--------------------------------------+
032100200529      ** ¦ Named constants                      ¦
032200200529      ** ¦ ===============                      ¦
032300200529      ** +--------------------------------------+
032400200529
032500200529      ** +--------------------------------------+
032600200529      ** ¦ Declared variables                   ¦
032700200529      ** ¦ ==================                   ¦
032800200529      ** +--------------------------------------+
032900200529
033000200529      **   First scaling exponent
033100200529     D     @@SXP1      S              1S 0
033200200529      **   Second scaling exponent
033300200529     D     @@SXP2      S                   LIKE(@@SXP1)
033400200529
033500200529
033600200529      ** Index for arrays of error message ids etc
033700200529     D Idx             S              3P 0
033800200529
033900200529      ** Index for arrays of warning message ids etc
034000200529     D WIx             S              3P 0
034100200529
034200200529     D UseRate2        S              1                                         186377
034300200529                                                                                186377
034400200529                                                                                              CER043
034500200529     D CER043          S              1A                                                      CER043
034600200529     D PRtCd           S              7A                                                      CER043
034700200529     D POptn           S              7A                                                      CER043
034800200529     D PSard           S              6A                                                      CER043
034900200529     D DDREIN          S              1A                                                      CER043
035000200529     D ZFLD15          S             15P 0                                                    CER043
035100200529     D ZDECS           S              1P 0                                                    CER043
035200200529     D ZCRET           S              2P 0                                                  BUG21428
035300200529     D BNTHSP          S              1A                                                    BUG21428
035400200529     D*ZECODE**        S              1A                                             CER043 BUG21428
035500200529     D ZOUT21          S             21A                                                      CER043
035600200529     D POutAmt         S             15P 0                                                    CER043
035700200529     D WF3DAM1         S                   LIKE(F3DAM2)                                       CER043
035800200529     D WF3DAM2         S                   LIKE(F3DAM2)                                       CER043
035900200529     D WMDIN           S              1A                                                      CER043
036000200529     D WExchrt         S             30P25                                                    CER043
036100200529     D WSysSpotrt      S             13P 8                                                  BUG23050
036200200529     D WNorExchrt      S             13P 8                                                 BUG23050A
036300200529     D*WDeviatn**      S             13P 8                                        BUG23050A BUG26662
036400200529     D WDeviatn        S             15P 8                                                  BUG26662
036500200529     D WCcy            S              3A                                                   BUG23050A
036600200529     D WRetp           S              5S 2                                                 BUG23050A
036700200529     D*WSysSpotrtN     S             13P 8                                        BUG23668 BUG23668D
036800200529     D*WSysSpotrtInv   S             13P 8                                        BUG23668 BUG23668D
036900200529     D*WSysSpotrtNU    S             13P 8                                        BUG23668 BUG23668D
037000200529     D*WSysSpotrtNL    S             13P 8                                        BUG23668 BUG23668D
037100200529     D*WSysSpotrtInvU  S             13P 8                                        BUG23668 BUG23668D
037200200529     D*WSysSpotrtInvL  S             13P 8                                        BUG23668 BUG23668D
037300200529     D*WSsr10          S             13P 8                                        BUG23668 BUG23668D
037400200529     D*WIsr10          S             13P 8                                        BUG23668 BUG23668D
037500200529     D*WOverlap        S              1                                           BUG23668 BUG23668D
037600200529     D*WRrateInv       S             13P 8                                        BUG23668 BUG23668D
037700200529     D*WRetpD          S              3P 3                                       BUG23668A BUG23668D
037800200529     D WMDIN1          S              1A                                                    BUG25240
037900200529     D @RRATE1         S             13  8                                                  BUG25240
038000200529      **                                                                                   BUG23050A
038100200529     D DSWRK           DS                                                                  BUG23050A
038200200529     D  WRK1                          3A                                                   BUG23050A
038300200529     D  WRK2                          3A                                                   BUG23050A
038400200529     D  WRK3                         15A                                                   BUG23050A
038500200529     D  WRK4                          7A                                                   BUG23050A
038600200529     D  WRK5                          3A                                                   BUG23050A
038700200529     D/COPY OFCPYSRCZ,CDL091_007                                                              CDL091
038800200529     D/COPY WNCPYSRC,FXH00013
038900200529                                                                                            MD000091
039000200529      **                                                                                    MD000091
039100200529     D BChar           DS                                                                   MD000091
039200200529     D   BLen                  1      2B 0                                                  MD000091
039300200529     D   LenStr                1      2                                                     MD000091
039400200529                                                                                            MD000091
039500200529      ** +--------------------------------------+
039600200529      ** ¦ End of D-specs                       ¦
039700200529      ** ¦ ==============                       ¦
039800200529      ** +--------------------------------------+
039900200529      *****************************************************************
040000200529      /EJECT
040100200529      *****************************************************************
040200200529     C
040300200529      ** +--- Start of Main processing -----------------------------------+
040400200529      ** ¦                                                                ¦
040500200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
040600200529      ** ¦ executed at program activation.                                ¦
040700200529      ** ¦                                                                ¦
040800200529      ** +----------------------------------------------------------------+
040900200529
041000200529      ** Initialization
041100200529
041200200529     C                   MOVE      *BLANK        RetCodeIn
041300200529
041400200529     C                   MOVE      *BLANK        FldNamXAr
041500200529     C                   MOVE      *BLANK        MsgIDXAr
041600200529     C                   MOVE      *BLANK        MsgDtaXAr
041700200529     C                   Z-ADD     0             Idx
041800200529     C                   MOVE      *BLANK        WFldNmXAr
041900200529     C                   MOVE      *BLANK        WMsgIDXAr
042000200529     C                   MOVE      *BLANK        WMsgDtXAr
042100200529     C                   Z-ADD     0             WIx
042200200529
042300200529     C                   MOVE      *BLANK        F3DMD1                         mult/div ind
042400200529     C                   Z-ADD     *ZERO         F3DXRT                         exch rate
042500200529     C                   Z-ADD     *ZERO         @SRATE                         Descaled exch rt
042600200529     C                   Z-ADD     *ZERO         @RRATE                         Rate+mgn+fwd pts
042700200529     C                   Z-ADD     *ZERO         @XRATE                         Rate+fwd pts
042800200529      *
042900200529      * Exit if invalid inputs
043000200529      *
043100200529     C/COPY OFCPYSRCZ,CDL091_008                                                              CDL091
043200200529     C/COPY WNCPYSRC,FXH00014
043300200529     C     W@INRT        IFEQ      *ZERO
043400200529     C     @@INRT        OREQ      *ZERO
043500200529     C     F3DAM1        OREQ      *ZERO
043600200529     C     CER043        ANDEQ     'N'                                                        CER043
043700200529     C     @SPOT1        OREQ      *ZERO
043800200529     C     F3DAM2        OREQ      *ZERO
043900200529     C     CER043        ANDEQ     'N'                                                        CER043
044000200529     C     @SPOT2        OREQ      *ZERO
044100200529     C                   RETURN
044200200529     C                   END
044300200529     C/COPY OFCPYSRCZ,CDL091_009                                                              CDL091
044400200529     C/COPY WNCPYSRC,FXH00015
044500200529      * Calculate buy and sell amount                                                         CER043
044600200529      *                                                                                       CER043
044700200529     C                   IF        CER043 = 'Y'                                               CER043
044800200529      *                                                                                    BUG23050A
044900200529      * Calculate for system spot rate                                                     BUG23050A
045000200529     C                   EXSR      SrSySpotRte                                             BUG23050A
045100200529      *                                                                                     BUG23668
045200200529      ** Calculate for Gross spot rate from the screen input                                BUG23668
045300200529      *                                                                                     BUG23668
045400200529     C                   EXSR      SrFwdMrgnPt                                              BUG23668
045500200529      *                                                                                     BUG23050
045600200529     **If*Reciprocal rate indicator is 'N',                                        BUG23050 BUG23668
045700200529     **Default*the correct Reciprocal Indicator                                    BUG23050 BUG23668
045800200529     C**********         IF        DDREIN = 'N'                                    BUG23050 BUG23668
045900200529     C                   EXSR      SrRepIn                                                  B0G23050
046000200529     C**********         ENDIF                                                     BUG23050 BUG23668
046100200529      **********                                                                  BUG23668 BUG23668D
046200200529      *Check*if*spot rates overlap.                                               BUG23668 BUG23668D
046300200529     C**********         EXSR      SrSpRtOverlap                                  BUG23668 BUG23668D
046400200529                                                                                           BUG23050A
046500200529     C                   EVAL      @RRATE1 = *Zeros                                         BUG25284
046600200529      *                                                                                    BUG23050A
046700200529      ** Recompute exchange and gross rate for reciprocal rate                             BUG23050A
046800200529      *                                                                                    BUG23050A
046900200529     C                   IF        DDREIN = 'Y'                                            BUG23050A
047000200529     C**********         EVAL      @@INRT = @@INRTR                               BUG23050A BUG23668
047100200529     C*****1****         DIV(H)    W@INRT        W@INRT                           BUG23050A BUG23668
047200200529     C**********         EVAL      F3OSRT = W@INRT                                BUG23050A BUG23668
047300200529     C**********         EVAL      @RRATE = WRrateInv                             BUG23668 BUG23668D
047400200529     C**********         EVAL      @RRATE = 1/@RRATE                             BUG23668D BUG23668E
047500200529     C**********         EVAL(H)   @RRATE = 1/@RRATE                              BUG23668E BUG25240
047600200529     C                   EVAL(H)   @RRATE1 = 1/@RRATE                                       BUG25240
047700200529     C                   ENDIF                                                             BUG23050A
047800200529      *********                                                                   BUG23050A BUG23668
047900200529      ***Calculate for Gross spot rate from the screen input                      BUG23050A BUG23668
048000200529      *********                                                                   BUG23050A BUG23668
048100200529     C*********          EXSR      SrFwdMrgnPt                                    BUG23050A BUG23668
048200200529      *                                                                                    BUG23050A
048300200529      ** Get System Deviation                                                              BUG23050A
048400200529      *                                                                                    BUG23050A
048500200529     C                   EXSR      SrDeviation                                             BUG23050A
048600200529      *                                                                                    BUG23050A
048700200529      ** Validate the Option Take Down                                                     BUG23050A
048800200529      *                                                                                    BUG23050A
048900200529     C                   EXSR      SrOptTake                                               BUG23050A
049000200529      *                                                                                    BUG23050A
049100200529      ** Default buy/sell amount                                                           BUG23050A
049200200529      *                                                                                    BUG23050A
049300200529     C                   EXSR      SrBSAmtCal                                                 CER043
049400200529     C                   ENDIF                                                                CER043
049500200529     C*
049600200529      * Validate exchange rate input and amounts ratio
049700200529      *
049800200529     C                   EXSR      #ZID
049900200529      *
050000200529      ** Return
050100200529      *
050200200529     C                   RETURN
050300200529      *****************************************************************
050400200529      *                                                               *
050500200529      * #ZID - Validate exchange rate input and amounts ratio         *
050600200529      *                                                               *
050700200529      *****************************************************************
050800200529     C     #ZID          BEGSR
050900200529     C*
051000200529     C/COPY OFCPYSRCZ,CDL091_010                                                              CDL091
051100200529     C/COPY WNCPYSRC,FXH00016
051200200529     C                   Z-ADD     1             W@SFAC            1 0          ScalingFactor
051300200529     C*
051400200529     C* DETERMINE MULTIPLY/DIVIDE INDICATOR FOR EXCHANGE RATE SUPPLIED
051500200529     C* BY MULTIPLYING OR DIVIDING BUY AND SELL AMOUNTS.
051600200529     C*
051700200529     C* SUBROUTINES #ZICA & #ZICB ARE CALLED TO APPLY 3 METHODS OF
051800200529     C* CALCULATION (FIELD @@K): 1 2 OR 3. 1 USES EXCHANGE RATE; 2 USES
051900200529     C* EXCHANGE RATE PLUS 0.000005: 3 USES EXCHANGE RATE MINUS 0.000005
052000200529     C* METHODS 2 AND 3 ARE ONLY INVOKED IF METHOD 1 CAN'T RECONCILE THE
052100200529     C* EXACT RATE AGAINST THE BUY AND SELL AMOUNTS. A FURTHER COMBINATION
052200200529     C* OF CALCULATIONS IS INVOKED WHEN DECIDING WHETHER TO ADD OR SUBTRACT
052300200529     C* MARGIN POINTS TO THE RATE (CONTROLLED BY #ZIC1 AND #ZIC2)
052400200529     C*
052500200529     C/COPY WNCPYSRC,FXH00219
052600200529     C                   MOVE      'X'           W@MDIN            1            M/D error
052700200529     C/COPY WNCPYSRC,FXH00220
052800200529     C*
052900200529     C                   Z-ADD     F3DAM1        @AMT7            15 0          BUY AMT
053000200529     C                   Z-SUB     F3DAM2        @AMT8            15 0          SELL AMT
053100200529     C*
053200200529     C* I F  B U Y  C C Y   =  D E A L I N G   B A S E  C C Y
053300200529     C*
053400200529     C     DDBCCY        IFEQ      BNCYDL
053500200529     C                   Z-ADD     F3DAM1        @@DAM1           15 0            C1 Amount
053600200529     C                   Z-ADD     @CDP1         @@CDP1            1 0            C1 Decimals
053700200529     C                   Z-ADD     F3DAM2        @@DAM2           15 0            C2 Amount
053800200529     C                   Z-ADD     @CDP2         @@CDP2            1 0            C2 Decimals
053900200529     C                   Z-ADD     @SPOT2        @@HISP           13 8            C2 HighSpot
054000200529     C                   Z-ADD     @SPOT2        @@LOSP           13 8            C2 Low Spot
054100200529     C                   MOVE      @@MDF2        @@XRMD            1              C2 XRateM/D
054200200529     C                   Z-ADD     @@NDP2        W@NQDP            1 0            NormQuotDecPl
054300200529     C                   ADD       @@SXP2        W@SFAC                           ScalingFactor
054400200529     C                   MOVE      'B'           @@BSIN            1              Base=Buy
054500200529     C                   MOVE      'A'           W@ZIC             1
054600200529     C                   Z-ADD     1             @@K               2 0          Counter
054700200529     C                   EXSR      #ZIC1                                          <Validate>
054800200529     C     W@DFBD        IFNE      *ZERO
054900200529     C     W@DFSD        ANDNE     *ZERO
055000200529     C     W@DFBM        ANDNE     *ZERO
055100200529     C     W@DFSM        ANDNE     *ZERO
055200200529     C                   Z-ADD     @@MGPT        @SMGPT            7 2
055300200529     C                   Z-ADD     2             @@K
055400200529     C                   EXSR      #ZICA                                          <Validate>
055500200529     C                   Z-ADD     3             @@K
055600200529     C                   EXSR      #ZICA                                          <Validate>
055700200529     C     S01453        IFEQ      'Y'
055800200529     C     @@MGPT        ANDNE     0
055900200529     C                   EXSR      #ZIC2
056000200529     C                   END
056100200529     C                   END
056200200529     C*
056300200529     C                   ELSE                                                   EL CCY.1<>BASE
056400200529     C*
056500200529     C* I F  S E L L  C C Y   =  D E A L I N G   B A S E  C C Y
056600200529     C*
056700200529     C     DDSCCY        IFEQ      BNCYDL
056800200529     C                   Z-ADD     F3DAM2        @@DAM1                           C2 Amount
056900200529     C                   Z-ADD     @CDP2         @@CDP1                           C2 Decimals
057000200529     C                   Z-ADD     F3DAM1        @@DAM2                           C1 Amount
057100200529     C                   Z-ADD     @CDP1         @@CDP2                           C1 Decimals
057200200529     C                   Z-ADD     @SPOT1        @@HISP                           C1 HighSpot
057300200529     C                   Z-ADD     @SPOT1        @@LOSP                           C1 Low Spot
057400200529     C                   MOVE      @@MDF1        @@XRMD                           C1 XRateM/D
057500200529     C                   Z-ADD     @@NDP1        W@NQDP                           C1 NQuotDecPl
057600200529     C                   ADD       @@SXP1        W@SFAC                           ScalingFactor
057700200529     C                   MOVE      'S'           @@BSIN                           Base=Sell
057800200529     C                   MOVE      'A'           W@ZIC
057900200529     C                   Z-ADD     1             @@K
058000200529     C                   EXSR      #ZIC1                                          <Validate>
058100200529     C     W@DFBD        IFNE      *ZERO
058200200529     C     W@DFSD        ANDNE     *ZERO
058300200529     C     W@DFBM        ANDNE     *ZERO
058400200529     C     W@DFSM        ANDNE     *ZERO
058500200529     C                   Z-ADD     @@MGPT        @SMGPT
058600200529     C                   Z-ADD     2             @@K
058700200529     C                   EXSR      #ZICA                                          <Validate>
058800200529     C                   Z-ADD     3             @@K
058900200529     C                   EXSR      #ZICA                                          <Validate>
059000200529     C     S01453        IFEQ      'Y'
059100200529     C     @@MGPT        ANDNE     0
059200200529     C                   EXSR      #ZIC2
059300200529     C                   END
059400200529     C                   END
059500200529     C*
059600200529     C                   ELSE
059700200529     C*
059800200529     C* I F  N E I T H E R   B U Y /  S E L L  C C Y   =  D E A L  B A S E
059900200529     C*
060000200529     C                   MOVE      'B'           W@ZIC
060100200529     C                   Z-ADD     1             @@K
060200200529     C                   EXSR      #ZIC1                                        <X-Validate>
060300200529     C     W@DIFS        IFNE      *ZERO
060400200529     C     W@DIFB        ANDNE     *ZERO
060500200529     C                   Z-ADD     @@MGPT        @SMGPT
060600200529     C                   Z-ADD     2             @@K
060700200529     C                   EXSR      #ZICB                                        <X-Validate>
060800200529     C                   Z-ADD     3             @@K
060900200529     C                   EXSR      #ZICB                                        <X-Validate>
061000200529     C     S01453        IFEQ      'Y'
061100200529     C     @@MGPT        ANDNE     0
061200200529     C                   EXSR      #ZIC2
061300200529     C                   END
061400200529     C                   END
061500200529     C                   END
061600200529     C                   END
061700200529     C*
061800200529     C* IF MULTIPLY/DIVIDE INDICATOR IS STILL 'X'
061900200529     C* THEN AMOUNTS DO NOT MATCH UP WITH THE EXCHANGE RATE SUPPLIED
062000200529     C* If not valid, send error message:
062100200529     C* "EXCHANGE RATES AND AMOUNTS DO NOT AGREE"
062200200529     C*
062300200529     C     W@MDIN        IFEQ      'X'
062400200529     C                   MOVE      'N'           DDRateOK
062500200529     C                   MOVE      'N'           DDBamtOK
062600200529     C                   MOVE      'N'           DDSamtOK
062700200529     C                   ADD       1             Idx
062800200529     C**********         MOVEL     'DDRATE'      FldNamXAr(Idx)                               224474
062900200529     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                               224474
063000200529     C                   MOVEL     'FXM0152'     MsgIdXAr(Idx)
063100200529     C                   ELSE
063200200529     C                   MOVE      W@MDIN        F3DMD1                         mult/div ind
063300200529     C                   Z-ADD     @KRATE        F3DXRT                         outright rate
063400200529     C                   END                                                    (descaled)
063500200529     C*
063600200529     C* VALIDATE RATIO OF AMOUNTS AGAINST CURRENT SPOT RATES
063700200529     C* (THEY MUST BE WITHIN TOLERANCE PERCENTAGE)
063800200529     C*
063900200529     C                   MOVE      'Y'           RATOK             1            RATE OK?
064000200529     C*
064100200529     C* DETERMINE HIGH & LOW TOLERANCE PERCENTAGES
064200200529     C*
064300200529     C     1             ADD       TOLRAN        @TOLHI            5 3
064400200529     C     1             SUB       TOLRAN        @TOLLO            5 3
064500200529      *                                                                                       210153
064600200529     C                   Z-ADD     @AMT7         WBAMT1           24 9                        210153
064700200529     C                   Z-ADD     @AMT8         WSAMT1           24 9                        210153
064800200529     C     @CDP1         IFNE      @CDP2                                                      210153
064900200529     C     @CDP1         IFGT      @CDP2                                                      210153
065000200529     C     @CDP1         SUB       @CDP2         @@WDP1            1 0                        210153
065100200529     C                   ADD       1             @@WDP1                                       210153
065200200529     C     WBAMT1        DIV(H)    @@AY(@@WDP1)  WBAMT1                                       210153
065300200529     C                   ELSE                                                                 210153
065400200529     C     @CDP2         SUB       @CDP1         @@WDP1                                       210153
065500200529     C                   ADD       1             @@WDP1                                       210153
065600200529     C     WSAMT1        DIV(H)    @@AY(@@WDP1)  WSAMT1                                       210153
065700200529     C                   ENDIF                                                                210153
065800200529     C                   ENDIF                                                                210153
065900200529     C*
066000200529     C* CALCULATE EFFECTIVE SPOT (CROSS) RATE FROM BUY AND SELL SPOT RATES
066100200529     C*
066200200529     C     @@MDF1        IFEQ      'M'
066300200529     C     @@MDF2        ANDEQ     'M'
066400200529     C     @SPOT1        DIV       @SPOT2        @SPRTE
066500200529     C                   EVAL      UseRate2 = 'N'                               186377
066600200529     C                   END
066700200529      *                                                                                       210153
066800200529     C     @SPOT1        IFEQ      1                                                          210153
066900200529     C     @SPOT2        OREQ      1                                                          210153
067000200529     C     @SPOT2        IFGT      1                                                          210153
067100200529     C     @SPOT2        ANDGT     @SPOT1                                                     210153
067200200529     C     @SPOT2        ORLT      1                                                          210153
067300200529     C     @SPOT2        ANDLT     @SPOT1                                                     210153
067400200529     C                   MOVE      'Y'           Userate2                                     210153
067500200529     C                   ENDIF                                                                210153
067600200529      *                                                                                       210153
067700200529     C                   ELSE                                                                 210153
067800200529      *                                                                                       210153
067900200529     C     WBAMT1        IFLT      WSAMT1                                                     210153
068000200529     C     @KRATE        ANDLT     1                                                          210153
068100200529     C     WBAMT1        ORGT      WSAMT1                                                     210153
068200200529     C     @KRATE        ANDGT     1                                                          210153
068300200529     C                   MOVE      'Y'           Userate2                                     210153
068400200529     C                   ENDIF                                                                210153
068500200529     C                   ENDIF                                                                210153
068600200529     C*
068700200529     C     @@MDF1        IFEQ      'M'
068800200529     C     @@MDF2        ANDEQ     'D'
068900200529     C     @SPOT1        MULT      @SPOT2        @SPRTE
069000200529     C                   EVAL      UseRate2 = 'N'                               186377
069100200529     C                   END
069200200529     C*
069300200529     C     @@MDF1        IFEQ      'D'
069400200529     C     @@MDF2        ANDEQ     'M'
069500200529     C     1             DIV       @SPOT1        @SPRTE
069600200529     C*****@SPRTE        DIV       @SPOT2        @SPRTE           13 8                        210153
069700200529     C     @SPRTE        DIV       @SPOT2        @SPRTE           2015                        210153
069800200529     C                   EVAL      UseRate2 = 'Y'                               186377
069900200529     C                   END
070000200529     C*
070100200529     C     @@MDF1        IFEQ      'D'
070200200529     C     @@MDF2        ANDEQ     'D'
070300200529     C     @SPOT2        DIV       @SPOT1        @SPRTE
070400200529     C                   EVAL      UseRate2 = 'Y'                               186377
070500200529      *                                                                                       210153
070600200529     C     @SPOT1        IFEQ      1                                                          210153
070700200529     C     @SPOT2        OREQ      1                                                          210153
070800200529     C     @SPOT2        IFGT      1                                                          210153
070900200529     C     @SPOT2        ANDGT     @SPOT1                                                     210153
071000200529     C     @SPOT2        ORLT      1                                                          210153
071100200529     C     @SPOT2        ANDLT     @SPOT1                                                     210153
071200200529     C                   MOVE      'N'           Userate2                                     210153
071300200529     C                   ENDIF                                                                210153
071400200529      *                                                                                       210153
071500200529     C                   ELSE                                                                 210153
071600200529      *                                                                                       210153
071700200529     C     WBAMT1        IFGT      WSAMT1                                                     210153
071800200529     C     @KRATE        ANDLT     1                                                          210153
071900200529     C     WBAMT1        ORLT      WSAMT1                                                     210153
072000200529     C     @KRATE        ANDGT     1                                                          210153
072100200529     C                   MOVE      'N'           Userate2                                     210153
072200200529     C                   ENDIF                                                                210153
072300200529     C                   ENDIF                                                                210153
072400200529      *                                                                                       210153
072500200529     C                   END
072600200529      *                                                                                       210153
072700200529      ** Get the inverse of the effective spot. This will be used for                         210153
072800200529      ** further checking of tolerance limit.                                                 210153
072900200529      *                                                                                       210153
073000200529     C*****1****         DIV       @SPRTE        @SPTE2           2015               210153 BUG13209
073100200529     C*****1****         DIV       @SPRTE        @SPTE2           2515            BUG13209 BUG13209A
073200200529     C     1             DIV       @SPRTE        @SPTE2           2015            BUG13209 BUG13209A
073300200529     C*
073400200529     C* CALCULATE HIGH & LOW SPOT RATE USING % TOLERANCES
073500200529     C*
073600200529     C     @SPRTE        MULT      @TOLHI        @HIRTE           13 8
073700200529     C     @SPRTE        MULT      @TOLLO        @LORTE           13 8
073800200529     C*****@SPTE2        MULT      @TOLHI        @HRTE2           13 8               210153 BUG13209
073900200529     C     @SPTE2        MULT      @TOLHI        @HRTE2           20 8               210153 BUG13209
074000200529     C*****@SPTE2        MULT      @TOLLO        @LRTE2           13 8               210153 BUG13209
074100200529     C     @SPTE2        MULT      @TOLLO        @LRTE2           20 8               210153 BUG13209
074200200529     C*
074300200529     C* CALCULATE:   SELL AMT/BUY AMT   &   BUY AMT/SELL AMT
074400200529     C*
074500200529     C     4             ADD       @CDP1         @@XX              3 0
074600200529     C                   SUB       @CDP2         @@XX
074700200529     C*
074800200529     C     @AMT8         DIV       @AMT7         @WKRTE           13 8          SELL/BUY
074900200529     C     @WKRTE        MULT      POW(@@XX)     @WKRTE
075000200529     C*
075100200529     C     4             ADD       @CDP2         @@XX                                        BUG5960
075200200529     C                   SUB       @CDP1         @@XX                                        BUG5960
075300200529     C*****@AMT7         DIV       @AMT8         @WKRT2           13 8               BUY/SELL 235142
075400200529     C*****@AMT7         DIV       @AMT8         @WKRT2           14 8               235142 BUG13209
075500200529     C     @AMT7         DIV       @AMT8         @WKRT2           20 8               235142 BUG13209
075600200529      *                                                                                       235142
075700200529      ** If BUY CCY's Decimal Places = 0                                                      235142
075800200529      *                                                                                       235142
075900200529     C                   IF        @CDP1 = 0                                                  235142
076000200529     C                   EVAL      @@XX = @@XX - 4                                         BUG13209A
076100200529     C                   IF        @@XX <> 0                                                  256537
076200200529     C     @WKRT2        MULT      @AD(@@XX)     @WKRT2                                       235142
076300200529     C                   ENDIF                                                                256537
076400200529     C                   ELSE                                                                 235142
076500200529     C                   IF        @CDP2 <> 0                                                 235142
076600200529     C     @WKRT2        MULT      POW(@@XX)     @WKRT2
076700200529     C                   ELSE                                                                 235142
076800200529     C     @WKRT2        DIV       100           @WKRT2                                       235142
076900200529     C                   ENDIF                                                                235142
077000200529     C                   ENDIF                                                                235142
077100200529      *****4*************ADD       @CDP2         @@XX                                 210153 BUG5960
077200200529      *******************SUB       @CDP1         @@XX                                 210153 BUG5960
077300200529     C*
077400200529     C* IF  SELL AMT/BUY AMT   > HIGH RATE   OR < LOW RATE
077500200529     C* IF  BUY AMT/SELL AMT   > HIGH RATE   OR < LOW RATE
077600200529     C*     IT IS A % TOLERANCE ERROR
077700200529     C*
077800200529     C                   IF        UseRate2 = 'N'                               186377
077900200529     C     @WKRTE        IFGT      @HIRTE
078000200529     C     @WKRTE        ORLT      @LORTE
078100200529     C*****@WKRT2        IFGT      @HIRTE                                       186377
078200200529     C*****@WKRT2        ORLT      @LORTE                                       186377
078300200529     C                   MOVE      'N'           RATOK                          * ERROR
078400200529     C********           END                                                    186377
078500200529     C                   END
078600200529     C*                                                                         186377
078700200529     C                   ELSE                                                   186377
078800200529     C*****@WKRT2        IFGT      @HIRTE                                              186377 210153
078900200529     C*****@WKRT2        ORLT      @LORTE                                              186377 210153
079000200529     C     @WKRT2        IFGT      @HRTE2                                                     210153
079100200529     C     @WKRT2        ORLT      @LRTE2                                                     210153
079200200529     C                   MOVE      'N'           RATOK                          186377
079300200529     C                   ENDIF                                                  186377
079400200529     C                   ENDIF                                                  186377
079500200529     C*
079600200529     C** VALIDATE THAT BUY AND SELL AMOUNTS ARE THE CORRECT WAY ROUND
079700200529     C** ACCORDING TO CURRENCY MULTIPLY/DIVIDE INDICATORS
079800200529     C** (AMOUNTS MUST BE ADJUSTED BY NO.OF CURRENCY DECIMAL PLACES)
079900200529     C*
080000200529     C                   MOVE      'Y'           AMTOK             1            AMOUNT OK?
080100200529     C*
080200200529     C                   Z-ADD     @AMT7         @AMT7R           24 9          BUY AMT
080300200529     C                   Z-ADD     @AMT8         @AMT8R           24 9          SELL AMT
080400200529     C*
080500200529     C* IF NO. OF DECIMAL PLACES OF BOTH CURRENCIES IS DIFFERENT
080600200529     C* ADJUST THE BUY AND SELL AMOUNTS TO REFLECT THE DIFFEREMNCE
080700200529     C*
080800200529     C     @CDP1         IFNE      @CDP2
080900200529     C     @CDP1         IFGT      @CDP2
081000200529     C     @CDP1         SUB       @CDP2         @@WDP             1 0
081100200529     C                   ADD       1             @@WDP
081200200529     C     @AMT7R        DIV(H)    @@AY(@@WDP)   @AMT7R                         ADJ. BUY AMT
081300200529     C                   ELSE
081400200529     C     @CDP2         SUB       @CDP1         @@WDP
081500200529     C                   ADD       1             @@WDP
081600200529     C     @AMT8R        DIV(H)    @@AY(@@WDP)   @AMT8R                         ADJ.SELL AMT
081700200529     C                   END
081800200529     C                   END
081900200529     C*
082000200529     C* VALIDATE WHEN BUY AND SELL RATES ARE BOTH MULTIPLY RATES
082100200529     C*
082200200529     C     @@MDF1        IFEQ      'M'
082300200529     C     @@MDF2        ANDEQ     'M'
082400200529     C     @SPOT1        IFLE      @SPOT2
082500200529     C     @AMT7R        ANDLT     @AMT8R
082600200529     C                   MOVE      'N'           AMTOK
082700200529     C                   END
082800200529     C     @SPOT1        IFGT      @SPOT2
082900200529     C     @AMT7R        ANDGT     @AMT8R
083000200529     C                   MOVE      'N'           AMTOK
083100200529     C                   END
083200200529     C                   END
083300200529     C*
083400200529     C* VALIDATE WHEN BUY AND SELL RATES ARE BOTH DIVIDE RATES
083500200529     C*
083600200529     C     @@MDF1        IFEQ      'D'
083700200529     C     @@MDF2        ANDEQ     'D'
083800200529     C     @SPOT1        IFLE      @SPOT2
083900200529     C     @AMT7R        ANDGT     @AMT8R
084000200529     C                   MOVE      'N'           AMTOK
084100200529     C                   END
084200200529     C     @SPOT1        IFGT      @SPOT2
084300200529     C     @AMT7R        ANDLT     @AMT8R
084400200529     C                   MOVE      'N'           AMTOK
084500200529     C                   END
084600200529     C                   END
084700200529     C*
084800200529     C* VALIDATE WHEN BUY AND SELL RATES ARE MULTIPLY AND DIVIDE
084900200529     C*
085000200529     C     @@MDF1        IFEQ      'M'
085100200529     C     @@MDF2        ANDEQ     'D'
085200200529     C     1             DIV       @SPOT2        @WKSPT           13 8
085300200529     C     @SPOT1        IFLE      @WKSPT
085400200529     C     @AMT7R        ANDLT     @AMT8R
085500200529     C                   MOVE      'N'           AMTOK
085600200529     C                   END
085700200529     C     @SPOT1        IFGT      @WKSPT
085800200529     C     @AMT7R        ANDGT     @AMT8R
085900200529     C                   MOVE      'N'           AMTOK
086000200529     C                   END
086100200529     C                   END
086200200529     C*
086300200529     C* VALIDATE WHEN BUY AND SELL RATES ARE DIVIDE AND MULTIPLY
086400200529     C*
086500200529     C     @@MDF1        IFEQ      'D'
086600200529     C     @@MDF2        ANDEQ     'M'
086700200529     C     1             DIV       @SPOT1        @WKSPT
086800200529     C     @WKSPT        IFLE      @SPOT2
086900200529     C     @AMT7R        ANDLT     @AMT8R
087000200529     C                   MOVE      'N'           AMTOK
087100200529     C                   END
087200200529     C     @WKSPT        IFGT      @SPOT2
087300200529     C     @AMT7R        ANDGT     @AMT8R
087400200529     C                   MOVE      'N'           AMTOK
087500200529     C                   END
087600200529     C                   END
087700200529     C*
087800200529     C** If error detected, check if both spot are similar (within ICD
087900200529     C** tolerance) and allow input in the two ways
088000200529     C*
088100200529     C     AMTOK         IFNE      'Y'
088200200529     C     @@MDF1        ANDEQ     @@MDF2                                       175229
088300200529     C     @SPOT1        DIV       @SPOT2        @WKSPT
088400200529     C     BNEXRT        DIV       100           @WKEXR           13 8
088500200529     C     1             ADD       @WKEXR        @WKCHP           13 8
088600200529     C     1             SUB       @WKEXR        @WKCHM           13 8
088700200529     C     @WKSPT        IFLE      @WKCHP
088800200529     C     @WKSPT        ANDGE     @WKCHM
088900200529     C                   MOVE      'Y'           AMTOK
089000200529     C                   END
089100200529     C                   END
089200200529      *                                                                                     AR808714
089300200529     C     AMTOK         IFNE      'Y'                                                      AR808714
089400200529     C     @AMT7         MULT(H)   @RRATE        @WPROD           15 0                      AR808714
089500200529     C     @AMT7         DIV(H)    @RRATE        @WQUOT           15 0                      AR808714
089600200529     C     @WPROD        IFEQ      @AMT8                                                    AR808714
089700200529     C     @WQUOT        OREQ      @AMT8                                                    AR808714
089800200529     C                   MOVE      'Y'           AMTOK                                      AR808714
089900200529     C                   ENDIF                                                              AR808714
090000200529     C                   ENDIF                                                              AR808714
090100200529      *                                                                                     AR808714
090200200529     C     AMTOK         IFNE      'Y'                                                      AR808714
090300200529     C     @AMT8         MULT(H)   @RRATE        @WPROD           15 0                      AR808714
090400200529     C     @AMT8         DIV(H)    @RRATE        @WQUOT           15 0                      AR808714
090500200529     C     @WPROD        IFEQ      @AMT7                                                    AR808714
090600200529     C     @WQUOT        OREQ      @AMT7                                                    AR808714
090700200529     C                   MOVE      'Y'           AMTOK                                      AR808714
090800200529     C                   ENDIF                                                              AR808714
090900200529     C                   ENDIF                                                              AR808714
091000200529      *                                                                         175229
091100200529     C     AMTOK         IFNE      'Y'                                          175229
091200200529     C     @@MDF1        ANDNE     @@MDF2                                       175229
091300200529     C     @SPOT1        MULT      @SPOT2        @WKSPT                         175229
091400200529     C     BNEXRT        DIV       100           @WKEXR           13 8          175229
091500200529     C**********         ADD       @WKEXR        @WKCHP           13 8                 175229 207744
091600200529     C**********         SUB       @WKEXR        @WKCHM           13 8                 175229 207744
091700200529     C     1             ADD       @WKEXR        @WKCHP           13 8                        207744
091800200529     C     1             SUB       @WKEXR        @WKCHM           13 8                        207744
091900200529     C     @WKSPT        IFLE      @WKCHP                                       175229
092000200529     C     @WKSPT        ANDGE     @WKCHM                                       175229
092100200529     C                   MOVE      'Y'           AMTOK                          175229
092200200529     C                   END                                                    175229
092300200529     C                   END                                                    175229
092400200529      *
092500200529      *                                                                                       238023
092600200529     C     AMTOK         IFNE      'Y'                                                        238023
092700200529     C     @AMT7         MULT(H)   @KRATE        @WPROD2          15 0                        238023
092800200529     C     @AMT7         DIV(H)    @KRATE        @WQUOT2          15 0                        238023
092900200529     C     @WPROD2       IFEQ      @AMT8                                                      238023
093000200529     C     @WQUOT2       OREQ      @AMT8                                                      238023
093100200529     C                   MOVE      'Y'           AMTOK                                        238023
093200200529     C                   END                                                                  238023
093300200529     C                   END                                                                  238023
093400200529      *                                                                                       238023
093500200529     C     AMTOK         IFNE      'Y'                                                        238023
093600200529     C     @AMT7         MULT(H)   W@INRT        @WPROD           15 0                        238023
093700200529     C     @AMT7         DIV(H)    W@INRT        @WQUOT           15 0                        238023
093800200529     C     @WPROD        IFEQ      @AMT8                                                      238023
093900200529     C     @WQUOT        OREQ      @AMT8                                                      238023
094000200529     C                   MOVE      'Y'           AMTOK                                        238023
094100200529     C                   END                                                                  238023
094200200529     C                   END                                                                  238023
094300200529      * SEND MESSAGE:
094400200529      * "** WARNING ** THE RATE IS NOT WITHIN THE SPECIFIED TOLERANCE"
094500200529      *
094600200529     C     RATOK         IFNE      'Y'
094700200529     C     DDRateOK      IFNE      'N'
094800200529     C                   MOVE      'W'           DDRateOK
094900200529     C                   END
095000200529     C                   ADD       1             WIx
095100200529     C**********         MOVEL     'DDRATE'      WFldNmXAr(WIx)                               224474
095200200529     C                   MOVEL     'DDRAT1'      WFldNmXAr(WIx)                               224474
095300200529     C                   MOVEL     'FXX0420'     WMsgIdXAr(WIx)
095400200529     C                   END
095500200529      *
095600200529      * SEND MESSAGE:
095700200529      * "BUY AND SELL AMOUNTS ARE INCORRECT"
095800200529      *
095900200529     C     AMTOK         IFNE      'Y'
096000200529     C                   MOVE      'N'           DDBamtOK
096100200529     C                   MOVE      'N'           DDSamtOK
096200200529     C                   ADD       1             Idx
096300200529     C**********         MOVEL     'DDRATE'      FldNamXAr(Idx)                               224474
096400200529     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                               224474
096500200529     C                   MOVEL     'FXM4003'     MsgIdXAr(Idx)
096600200529     C                   END
096700200529     C*
096800200529     C     #ZID9         ENDSR                                                  #ZID9 TAG
096900200529      *****************************************************************
097000200529      /EJECT
097100200529      *****************************************************************
097200200529      ** #ZIC1 - VALIDATE RATES WITH -VE OR +VE MARGINS
097300200529      ** OUTPUT from this subroutine: sign of margin
097400200529      *****************************************************************
097500200529     C     #ZIC1         BEGSR
097600200529      *
097700200529      *** First try ADDING the margin to the exchange rate
097800200529      *
097900200529     C                   Z-ADD     @@MGPT        @SMGPT
098000200529     C     W@ZIC         IFEQ      'A'
098100200529     C                   EXSR      #ZICA
098200200529     C                   ELSE
098300200529     C                   EXSR      #ZICB
098400200529     C                   END
098500200529      *
098600200529      *** If SAR S01453 is not installed
098700200529      *** or if margin points is zero
098800200529      *** exit from this routine
098900200529      *
099000200529     C     S01453        IFNE      'Y'
099100200529     C     @@MGPT        OREQ      0
099200200529     C                   GOTO      #ZIC19
099300200529     C                   END
099400200529      *
099500200529      *** If invalid, force validation to continue
099600200529      *
099700200529     C     W@MDIN        IFNE      'M'
099800200529     C     W@MDIN        ANDNE     'D'
099900200529     C                   MOVE      'X'           W@MDIN
100000200529     C                   END
100100200529      *
100200200529      *** If valid then exit
100300200529      *
100400200529     C     W@MDIN        IFNE      'X'
100500200529     C                   GOTO      #ZIC19
100600200529     C                   END
100700200529      *
100800200529      *** Now try SUBTRACTING the margin from the exchange rate
100900200529      *
101000200529     C                   Z-SUB     @@MGPT        @SMGPT
101100200529     C     W@ZIC         IFEQ      'A'
101200200529     C                   EXSR      #ZICA
101300200529     C                   ELSE
101400200529     C                   EXSR      #ZICB
101500200529     C                   END
101600200529      *
101700200529      *** If invalid, force validation to continue
101800200529      *
101900200529     C     W@MDIN        IFNE      'M'
102000200529     C     W@MDIN        ANDNE     'D'
102100200529     C                   MOVE      'X'           W@MDIN
102200200529     C                   Z-ADD     1             W@DFBD
102300200529     C                   Z-ADD     1             W@DFSD
102400200529     C                   Z-ADD     1             W@DFBM
102500200529     C                   Z-ADD     1             W@DFSM
102600200529     C                   Z-ADD     1             W@DIFB
102700200529     C                   Z-ADD     1             W@DIFS
102800200529     C                   END
102900200529     C*
103000200529     C     #ZIC19        ENDSR
103100200529      *****************************************************************
103200200529      /EJECT
103300200529      *****************************************************************
103400200529      ** #ZIC2 - VALIDATE RATES WITH -VE OR +VE MARGINS
103500200529      *****************************************************************
103600200529     C     #ZIC2         BEGSR
103700200529     C*
103800200529     C* If multiply/divide indicator is 'M' or not yet calculated
103900200529     C* this process will calculate it
104000200529     C*
104100200529     C     W@MDIN        IFNE      'D'
104200200529     C     W@MDIN        ANDNE     'M'                                                        238023
104300200529     C                   MOVE      'X'           W@MDIN
104400200529     C                   END
104500200529      *
104600200529      *** If not valid, try subtracting margin
104700200529      *
104800200529     C     W@MDIN        IFEQ      'X'
104900200529     C                   Z-SUB     @@MGPT        @SMGPT
105000200529     C                   Z-ADD     2             @@K
105100200529     C     W@ZIC         IFEQ      'A'
105200200529     C                   EXSR      #ZICA
105300200529     C                   Z-ADD     3             @@K
105400200529     C                   EXSR      #ZICA
105500200529     C                   ELSE
105600200529     C                   EXSR      #ZICB
105700200529     C                   Z-ADD     3             @@K
105800200529     C                   EXSR      #ZICB
105900200529     C                   END
106000200529     C                   END
106100200529      *
106200200529      *** If invalid, force validation to continue
106300200529      *
106400200529     C     W@MDIN        IFNE      'M'
106500200529     C     W@MDIN        ANDNE     'D'                                                        238023
106600200529     C                   MOVE      'X'           W@MDIN
106700200529     C                   END
106800200529     C                   ENDSR
106900200529      *****************************************************************
107000200529      /EJECT
107100200529      *****************************************************************
107200200529      ** #ZICA - VALIDATE EXCHANGE RATE V. SPOT FOR BASE CCY DEAL
107300200529      *****************************************************************
107400200529     C     #ZICA         BEGSR
107500200529     C*
107600200529     C** Obtain Tolerance Amount of High/Low Spot Rate
107700200529     C*
107800200529     C     @@HISP        MULT      TOLRAN        @@HS10           13 8
107900200529     C     @@LOSP        MULT      TOLRAN        @@LS10           13 8
108000200529     C*
108100200529     C* Obtain +/-(Tolerance Amount) of High/Low Spot rate :
108200200529     C*
108300200529     C     @@HISP        ADD       @@HS10        @@SPHI           13 8          HiSpot + 10%
108400200529     C     @@LOSP        SUB       @@LS10        @@SPLO           13 8          LoSpot - 10%
108500200529     C*
108600200529     C** Calculate the inverse of the +/- tolerance of high/low spot rates
108700200529     C*
108800200529     C     1             DIV(H)    @@SPHI        @@ISHI           13 8
108900200529     C     1             DIV(H)    @@SPLO        @@ISLO           13 8
109000200529     C*
109100200529     C* Descale the input exchange rate
109200200529     C*
109300200529     C     W@INRT        DIV(H)    @SF(W@SFAC)   @SRATE           13 8            Descaled Rate
109400200529     C*
109500200529     C* If the normally quoted decimal places is not zero
109600200529     C* Add (adjusted) forward points to margin
109700200529     C*
109800200529     C     W@NQDP        IFNE      0
109900200529     C     @@FPNT        DIV(H)    @AD(W@NQDP)   @RRATE                         Adjust Fwd/Pts
110000200529     C     S01453        IFEQ      'Y'                                          S01453 installd
110100200529     C                   Z-ADD     @RRATE        @XRATE                         Save
110200200529     C     @SMGPT        DIV(H)    @AD(W@NQDP)   @@MADJ           13 8          Adjust margin
110300200529     C                   ADD       @@MADJ        @RRATE                         Margin+Fwd/Pts
110400200529     C                   END
110500200529     C                   END
110600200529     C*
110700200529     C* If the normally quoted decimal places is zero
110800200529     C* Add forward points to margin
110900200529     C*
111000200529     C     W@NQDP        IFEQ      0
111100200529     C                   Z-ADD     @@FPNT        @RRATE                         Fwd/Pts
111200200529     C     S01453        IFEQ      'Y'
111300200529     C                   Z-ADD     @RRATE        @XRATE                         Save
111400200529     C                   ADD       @SMGPT        @RRATE                         Margin+Fwd/Pts
111500200529     C                   END
111600200529     C                   END
111700200529     C*
111800200529     C* Descale margin + forward points
111900200529     c*
112000200529     C                   DIV       @SF(W@SFAC)   @RRATE
112100200529      *                                                                                       240038
112200200529     C                   Z-ADD     @RRATE        @RATEA           13 8                        240038
112300200529     C                   Z-ADD     @RRATE        @RATEB           13 8                        240038
112400200529     C                   Z-ADD     @RRATE        @RATEV           13 8                        240038
112500200529     C     @RATEV        IFLT      0                                                          240038
112600200529     C                   MULT      -1            @RATEV                                       240038
112700200529     C                   ENDIF                                                                240038
112800200529     C*
112900200529     C* Add descaled exchange rate to descaled margin + forward points
113000200529     C* to get the outright descaled rate
113100200529     C*
113200200529     C                   ADD       @SRATE        @RRATE           13 8
113300200529     C     @SRATE        ADD       @RATEA        @RATEC           13 8                        240038
113400200529     C     @SRATE        SUB       @RATEB        @RATED           13 8                        240038
113500200529      *                                                                                     BUG23668
113600200529     C**********         IF        CER043 = 'Y' AND DDREIN = 'Y'                   BUG23668 BUG25418
113700200529     C**********         EVAL(H)   @RRATE = 1/@RRATE                               BUG23668 BUG25418
113800200529     C**********         ENDIF                                                     BUG23668 BUG25418
113900200529      *                                                                                     BUG23668
114000200529     C*
114100200529     C* Descale forward points and add descaled exchange rate to it
114200200529     C* to obtain descaled forward rate
114300200529     C*
114400200529     C     S01453        IFEQ      'Y'                                          S01453 installd
114500200529     C                   DIV       @SF(W@SFAC)   @XRATE                         Descale Fwd/Pts
114600200529     C                   ADD       @SRATE        @XRATE           13 8          Fwd Rate
114700200529     C                   END
114800200529     C*
114900200529     C*----------------------------------------------------------------
115000200529     C*
115100200529     C** Check Exchange Rate against Spot range
115200200529     C** Allow for the input of inverse rates by using the inverse
115300200529     C** exchange rate limits. If the inverse rate is input,
115400200529     C** invert the multiply/divide indicator value.
115500200529     C*
115600200529     C                   MOVE      'N'           W@RTOK            1
115700200529     C*
115800200529     C* OK if descaled rate is GE low spot rate and LE high spot rate
115900200529     C*
116000200529     C     @SRATE        IFGE      @@SPLO
116100200529     C     @SRATE        ANDLE     @@SPHI
116200200529     C                   MOVE      'Y'           W@RTOK
116300200529     C                   END
116400200529     C*
116500200529     C* OK if descaled rate is GE low inv spot rte and LE high inv spot rte
116600200529     C*
116700200529     C     @SRATE        IFGE      @@ISHI
116800200529     C     @SRATE        ANDLE     @@ISLO
116900200529     C                   MOVE      'Y'           W@RTOK
117000200529     C     @@XRMD        IFEQ      'M'                                          invert the rate
117100200529     C                   MOVE      'D'           @@XRMD                         by flipping
117200200529     C                   ELSE                                                   the M/D ind
117300200529     C                   MOVE      'M'           @@XRMD
117400200529     C                   END
117500200529     C                   END
117600200529     C*
117700200529     C* If rate is not OK, format low & high spot rates for message
117800200529     C*
117900200529     C     W@RTOK        IFEQ      'N'
118000200529     C                   Z-ADD     *ZERO         W@AMNT                           ¦ Initialise
118100200529     C                   MOVE      *BLANK        M@MGDA                           ¦ fields
118200200529     C                   Z-ADD     8             W@DECP            1 0            ¦
118300200529     C     @@SPLO        MULT      @SF(W@SFAC)   W@AMTR                           I:Low Rate
118400200529     C                   EXSR      #ZICC                                          <Convert>
118500200529     C                   MOVEA     @Y(P1)        M@0115                           O:To msg.data
118600200529     C     @@SPHI        MULT      @SF(W@SFAC)   W@AMTR                           I:High Rate
118700200529     C                   EXSR      #ZICC                                          <Convert>
118800200529     C                   MOVEA     @Y(P1)        M@1630                           O:To msg.data
118900200529     C                   MOVE      M@MGDA        M@MGD3           45              Stack Msg.Dta
119000200529     C                   END
119100200529     C*
119200200529     C*----------------------------------------------------------------
119300200529     C*
119400200529     C* If rate is not OK
119500200529     C*
119600200529     C     W@RTOK        IFEQ      'N'
119700200529     C*
119800200529     C* If either currency is the base currency for accounting
119900200529     C*
120000200529     C     DDBCCY        IFEQ      BJCYCD
120100200529     C     DDSCCY        OREQ      BJCYCD
120200200529     C*
120300200529     C* Set spot rate to that of currency which is the base currency
120400200529     C*
120500200529     C     DDBCCY        IFEQ      BJCYCD
120600200529     C                   Z-ADD     @SPOT2        @@SPTR           13 8
120700200529     C                   ELSE
120800200529     C                   Z-ADD     @SPOT1        @@SPTR
120900200529     C                   END
121000200529     C*
121100200529     C** Obtain Tolerance Amount of Spot Rate
121200200529     C*
121300200529     C     @@SPTR        MULT      TOLRAN        @@SR10           13 8
121400200529     C*
121500200529     C* Obtain +/-(Tolerance Amount) of Spot rate
121600200529     C*
121700200529     C     @@SPTR        ADD       @@SR10        @@SPHI           13 8          Spot + 10%
121800200529     C     @@SPTR        SUB       @@SR10        @@SPLO           13 8          Spot - 10%
121900200529     C*
122000200529     C** Calculate the inverse of the +/- tolerance of high/low spot rates
122100200529     C*
122200200529     C     1             DIV(H)    @@SPHI        @@ISHI           13 8
122300200529     C     1             DIV(H)    @@SPLO        @@ISLO           13 8
122400200529     C*
122500200529     C* OK if low spot rate is LT spot rate and high spot rate GT spot rate
122600200529     C*
122700200529     C     @@SPLO        IFLT      @SRATE
122800200529     C     @@SPHI        ANDGT     @SRATE
122900200529     C                   MOVE      'Y'           W@RTOK
123000200529     C                   END
123100200529     C*
123200200529     C* OK if spt rate is GE inv high spt rte and spt rate LE inv low spt rt
123300200529     C*
123400200529     C     @SRATE        IFGE      @@ISHI
123500200529     C     @SRATE        ANDLE     @@ISLO
123600200529     C                   MOVE      'Y'           W@RTOK
123700200529     C     @@XRMD        IFEQ      'M'                                          invert the rate
123800200529     C                   MOVE      'D'           @@XRMD                         by flipping
123900200529     C                   ELSE                                                   the M/D ind
124000200529     C                   MOVE      'M'           @@XRMD
124100200529     C                   END
124200200529     C                   END
124300200529     C*
124400200529     C                   END                                                    DDBCCY = BJCYCD
124500200529     C                   END                                                    W@RTOK = N
124600200529     C*
124700200529     C*----------------------------------------------------------------
124800200529      *
124900200529      ** Set up variables used in 'difference' calculations below
125000200529      ** (difference is between actual 'other' currency amount
125100200529      **  and calculated 'other' currency amount (amount x or / rate))
125200200529      *
125300200529     C     @@CDP1        COMP      0                                      90      Dec.place=0
125400200529     C     @@CDP1        COMP      1                                      91      Dec.place=1
125500200529     C     @@CDP1        COMP      2                                      92      Dec.place=2
125600200529     C     @@CDP1        COMP      3                                      93      Dec.place=3
125700200529     C     @@CDP2        COMP      0                                      94      Dec.place=0
125800200529     C     @@CDP2        COMP      1                                      95      Dec.place=1
125900200529     C     @@CDP2        COMP      2                                      96      Dec.place=2
126000200529     C     @@CDP2        COMP      3                                      97      Dec.place=3
126100200529     C*
126200200529     C     @@DAM1        IFLT      0                                                           DT001
126300200529     C                   Z-SUB     @@DAM1        W@1150                           15,0 Base AmtDT001
126400200529     C                   ELSE                                                                  DT001
126500200529     C                   Z-ADD     @@DAM1        W@1150                           15,0 Base AmtDT001
126600200529     C                   END                                                                   DT001
126700200529     C     @@DAM2        IFLT      0                                                           DT001
126800200529     C                   Z-SUB     @@DAM2        W@2150                           15,0 Base AmtDT001
126900200529     C                   ELSE                                                                  DT001
127000200529     C                   Z-ADD     @@DAM2        W@2150                           15,0 N/B Amt DT001
127100200529     C                   END                                                                   DT001
127200200529      *                                                                                       240038
127300200529      ** If the margin buy/sell indicator is "B" and buy currency is                          240038
127400200529      ** equal to the dealing base currency.                                                  240038
127500200529      *                                                                                       240038
127600200529     C     F3MGBS        IFEQ      'B'                                                        240038
127700200529     C     DDBCCY        ANDEQ     BNCYDL                                                     240038
127800200529      *                                                                                       240038
127900200529      ** Divide buy amount in different decimal places against +rate and store value          240038
128000200529      ** to a variable with zero decimal place.                                               240038
128100200529      *                                                                                       240038
128200200529     C     W@1150        DIV(H)    @RATEC        W@6150           15 0                        240038
128300200529     C     W@1151        DIV(H)    @RATEC        W@6151           15 0                        240038
128400200529     C     W@1152        DIV(H)    @RATEC        W@6152           15 0                        240038
128500200529     C     W@1153        DIV(H)    @RATEC        W@6153           15 0                        240038
128600200529      *                                                                                       240038
128700200529     C                   SELECT                                                               240038
128800200529     C     @@CDP2        WHENEQ    1                                                          240038
128900200529     C                   MULT      10            W@6150                                       240038
129000200529     C                   MULT      10            W@6151                                       240038
129100200529     C                   MULT      10            W@6152                                       240038
129200200529     C                   MULT      10            W@6153                                       240038
129300200529     C     @@CDP2        WHENEQ    2                                                          240038
129400200529     C                   MULT      100           W@6150                                       240038
129500200529     C                   MULT      100           W@6151                                       240038
129600200529     C                   MULT      100           W@6152                                       240038
129700200529     C                   MULT      100           W@6153                                       240038
129800200529     C     @@CDP2        WHENEQ    3                                                          240038
129900200529     C                   MULT      1000          W@6150                                       240038
130000200529     C                   MULT      1000          W@6151                                       240038
130100200529     C                   MULT      1000          W@6152                                       240038
130200200529     C                   MULT      1000          W@6153                                       240038
130300200529     C                   ENDSL                                                                240038
130400200529      *                                                                                       240038
130500200529      ** Divide buy amount in different decimal places against +rate and store value          240038
130600200529      ** to a variable with one  decimal place.                                               240038
130700200529      *                                                                                       240038
130800200529     C     W@1150        DIV(H)    @RATEC        W@6154           15 1                        240038
130900200529     C     W@1151        DIV(H)    @RATEC        W@6155           15 1                        240038
131000200529     C     W@1152        DIV(H)    @RATEC        W@6156           15 1                        240038
131100200529     C     W@1153        DIV(H)    @RATEC        W@6157           15 1                        240038
131200200529      *                                                                                       240038
131300200529     C                   SELECT                                                               240038
131400200529     C     @@CDP2        WHENEQ    1                                                          240038
131500200529     C                   MULT      10            W@6154                                       240038
131600200529     C                   MULT      10            W@6155                                       240038
131700200529     C                   MULT      10            W@6156                                       240038
131800200529     C                   MULT      10            W@6157                                       240038
131900200529     C     @@CDP2        WHENEQ    2                                                          240038
132000200529     C                   MULT      100           W@6154                                       240038
132100200529     C                   MULT      100           W@6155                                       240038
132200200529     C                   MULT      100           W@6156                                       240038
132300200529     C                   MULT      100           W@6157                                       240038
132400200529     C     @@CDP2        WHENEQ    3                                                          240038
132500200529     C                   MULT      1000          W@6154                                       240038
132600200529     C                   MULT      1000          W@6155                                       240038
132700200529     C                   MULT      1000          W@6156                                       240038
132800200529     C                   MULT      1000          W@6157                                       240038
132900200529     C                   ENDSL                                                                240038
133000200529      *                                                                                       240038
133100200529      ** Divide buy amount in different decimal places against +rate and store value          240038
133200200529      ** to a variable with two  decimal place.                                               240038
133300200529      *                                                                                       240038
133400200529     C     W@1150        DIV(H)    @RATEC        W@6158           15 2                        240038
133500200529     C     W@1151        DIV(H)    @RATEC        W@6159           15 2                        240038
133600200529     C     W@1152        DIV(H)    @RATEC        W@6160           15 2                        240038
133700200529     C     W@1153        DIV(H)    @RATEC        W@6161           15 2                        240038
133800200529      *                                                                                       240038
133900200529     C                   SELECT                                                               240038
134000200529     C     @@CDP2        WHENEQ    1                                                          240038
134100200529     C                   MULT      10            W@6158                                       240038
134200200529     C                   MULT      10            W@6159                                       240038
134300200529     C                   MULT      10            W@6160                                       240038
134400200529     C                   MULT      10            W@6161                                       240038
134500200529     C     @@CDP2        WHENEQ    2                                                          240038
134600200529     C                   MULT      100           W@6158                                       240038
134700200529     C                   MULT      100           W@6159                                       240038
134800200529     C                   MULT      100           W@6160                                       240038
134900200529     C                   MULT      100           W@6161                                       240038
135000200529     C     @@CDP2        WHENEQ    3                                                          240038
135100200529     C                   MULT      1000          W@6158                                       240038
135200200529     C                   MULT      1000          W@6159                                       240038
135300200529     C                   MULT      1000          W@6160                                       240038
135400200529     C                   MULT      1000          W@6161                                       240038
135500200529     C                   ENDSL                                                                240038
135600200529      *                                                                                       240038
135700200529      ** Divide buy amount in different decimal places against +rate and store value          240038
135800200529      ** to a variable with three decimal place.                                              240038
135900200529      *                                                                                       240038
136000200529     C     W@1150        DIV(H)    @RATEC        W@6162           15 3                        240038
136100200529     C     W@1151        DIV(H)    @RATEC        W@6163           15 3                        240038
136200200529     C     W@1152        DIV(H)    @RATEC        W@6164           15 3                        240038
136300200529     C     W@1153        DIV(H)    @RATEC        W@6165           15 3                        240038
136400200529      *                                                                                       240038
136500200529     C                   SELECT                                                               240038
136600200529     C     @@CDP2        WHENEQ    1                                                          240038
136700200529     C                   MULT      10            W@6162                                       240038
136800200529     C                   MULT      10            W@6163                                       240038
136900200529     C                   MULT      10            W@6164                                       240038
137000200529     C                   MULT      10            W@6165                                       240038
137100200529     C     @@CDP2        WHENEQ    2                                                          240038
137200200529     C                   MULT      100           W@6162                                       240038
137300200529     C                   MULT      100           W@6163                                       240038
137400200529     C                   MULT      100           W@6164                                       240038
137500200529     C                   MULT      100           W@6165                                       240038
137600200529     C     @@CDP2        WHENEQ    3                                                          240038
137700200529     C                   MULT      1000          W@6162                                       240038
137800200529     C                   MULT      1000          W@6163                                       240038
137900200529     C                   MULT      1000          W@6164                                       240038
138000200529     C                   MULT      1000          W@6165                                       240038
138100200529     C                   ENDSL                                                                240038
138200200529      *                                                                                       240038
138300200529      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
138400200529      ** is then assign a Divide rate to W@MDIN.                                              240038
138500200529      *                                                                                       240038
138600200529     C     W@6150        IFEQ      W@2150                                                     240038
138700200529     C     W@6151        OREQ      W@2150                                                     240038
138800200529     C     W@6152        OREQ      W@2150                                                     240038
138900200529     C     W@6153        OREQ      W@2150                                                     240038
139000200529     C     W@6154        OREQ      W@2150                                                     240038
139100200529     C     W@6155        OREQ      W@2150                                                     240038
139200200529     C     W@6156        OREQ      W@2150                                                     240038
139300200529     C     W@6157        OREQ      W@2150                                                     240038
139400200529     C     W@6158        OREQ      W@2150                                                     240038
139500200529     C     W@6159        OREQ      W@2150                                                     240038
139600200529     C     W@6160        OREQ      W@2150                                                     240038
139700200529     C     W@6161        OREQ      W@2150                                                     240038
139800200529     C     W@6162        OREQ      W@2150                                                     240038
139900200529     C     W@6163        OREQ      W@2150                                                     240038
140000200529     C     W@6164        OREQ      W@2150                                                     240038
140100200529     C     W@6165        OREQ      W@2150                                                     240038
140200200529     C                   MOVE      'D'           W@MDIN                                       240038
140300200529     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
140400200529     C                   ELSE                                                                 240038
140500200529      *                                                                                       240038
140600200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
140700200529      ** value to variable with zero decimal place.                                           240038
140800200529      *                                                                                       240038
140900200529     C     W@1150        MULT(H)   @RATED        W@7150           15 0                        240038
141000200529     C     W@1151        MULT(H)   @RATED        W@7151           15 0                        240038
141100200529     C     W@1152        MULT(H)   @RATED        W@7152           15 0                        240038
141200200529     C     W@1153        MULT(H)   @RATED        W@7153           15 0                        240038
141300200529      *                                                                                       240038
141400200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
141500200529      ** value to variable with one decimal place.                                            240038
141600200529      *                                                                                       240038
141700200529     C     W@1150        MULT(H)   @RATED        W@7154           15 1                        240038
141800200529     C     W@1151        MULT(H)   @RATED        W@7155           15 1                        240038
141900200529     C     W@1152        MULT(H)   @RATED        W@7156           15 1                        240038
142000200529     C     W@1153        MULT(H)   @RATED        W@7157           15 1                        240038
142100200529      *                                                                                       240038
142200200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
142300200529      ** value to variable with two decimal place.                                            240038
142400200529      *                                                                                       240038
142500200529     C     W@1150        MULT(H)   @RATED        W@7158           15 2                        240038
142600200529     C     W@1151        MULT(H)   @RATED        W@7159           15 2                        240038
142700200529     C     W@1152        MULT(H)   @RATED        W@7160           15 2                        240038
142800200529     C     W@1153        MULT(H)   @RATED        W@7161           15 2                        240038
142900200529      *                                                                                       240038
143000200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
143100200529      ** value to variable with three decimal place.                                          240038
143200200529      *                                                                                       240038
143300200529     C     W@1150        MULT(H)   @RATED        W@7162           15 3                        240038
143400200529     C     W@1151        MULT(H)   @RATED        W@7163           15 3                        240038
143500200529     C     W@1152        MULT(H)   @RATED        W@7164           15 3                        240038
143600200529     C     W@1153        MULT(H)   @RATED        W@7165           15 3                        240038
143700200529      *                                                                                       240038
143800200529      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
143900200529      ** is then assign a Multiply rate to W@MDIN.                                            240038
144000200529      *                                                                                       240038
144100200529     C     W@7150        IFEQ      W@2150                                                     240038
144200200529     C     W@7151        OREQ      W@2150                                                     240038
144300200529     C     W@7152        OREQ      W@2150                                                     240038
144400200529     C     W@7153        OREQ      W@2150                                                     240038
144500200529     C     W@7154        OREQ      W@2150                                                     240038
144600200529     C     W@7155        OREQ      W@2150                                                     240038
144700200529     C     W@7156        OREQ      W@2150                                                     240038
144800200529     C     W@7157        OREQ      W@2150                                                     240038
144900200529     C     W@7158        OREQ      W@2150                                                     240038
145000200529     C     W@7159        OREQ      W@2150                                                     240038
145100200529     C     W@7160        OREQ      W@2150                                                     240038
145200200529     C     W@7161        OREQ      W@2150                                                     240038
145300200529     C     W@7162        OREQ      W@2150                                                     240038
145400200529     C     W@7163        OREQ      W@2150                                                     240038
145500200529     C     W@7164        OREQ      W@2150                                                     240038
145600200529     C     W@7165        OREQ      W@2150                                                     240038
145700200529     C                   MOVE      'M'           W@MDIN                                       240038
145800200529     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
145900200529     C                   ENDIF                                                                240038
146000200529     C                   ENDIF                                                                240038
146100200529     C                   ENDIF                                                                240038
146200200529      *                                                                                       240038
146300200529      ** If the margin buy/sell indicator is "B" and sell currency is                         240038
146400200529      ** equal to the dealing base currency.                                                  240038
146500200529      *                                                                                       240038
146600200529     C     F3MGBS        IFEQ      'B'                                                        240038
146700200529     C     DDSCCY        ANDEQ     BNCYDL                                                     240038
146800200529      *                                                                                       240038
146900200529      ** Divide buy amount in different decimal places against +rate and store value          240038
147000200529      ** to a variable with zero decimal place.                                               240038
147100200529      *                                                                                       240038
147200200529     C     W@2150        DIV(H)    @RATEC        W@6150                                       240038
147300200529     C     W@2151        DIV(H)    @RATEC        W@6151                                       240038
147400200529     C     W@2152        DIV(H)    @RATEC        W@6152                                       240038
147500200529     C     W@2153        DIV(H)    @RATEC        W@6153                                       240038
147600200529      *                                                                                       240038
147700200529     C                   SELECT                                                               240038
147800200529     C     @@CDP1        WHENEQ    1                                                          240038
147900200529     C                   MULT      10            W@6150                                       240038
148000200529     C                   MULT      10            W@6151                                       240038
148100200529     C                   MULT      10            W@6152                                       240038
148200200529     C                   MULT      10            W@6153                                       240038
148300200529     C     @@CDP1        WHENEQ    2                                                          240038
148400200529     C                   MULT      100           W@6150                                       240038
148500200529     C                   MULT      100           W@6151                                       240038
148600200529     C                   MULT      100           W@6152                                       240038
148700200529     C                   MULT      100           W@6153                                       240038
148800200529     C     @@CDP1        WHENEQ    3                                                          240038
148900200529     C                   MULT      1000          W@6150                                       240038
149000200529     C                   MULT      1000          W@6151                                       240038
149100200529     C                   MULT      1000          W@6152                                       240038
149200200529     C                   MULT      1000          W@6153                                       240038
149300200529     C                   ENDSL                                                                240038
149400200529      *                                                                                       240038
149500200529      ** Divide buy amount in different decimal places against +rate and store value          240038
149600200529      ** to a variable with one  decimal place.                                               240038
149700200529      *                                                                                       240038
149800200529     C     W@2150        DIV(H)    @RATEC        W@6154                                       240038
149900200529     C     W@2151        DIV(H)    @RATEC        W@6155                                       240038
150000200529     C     W@2152        DIV(H)    @RATEC        W@6156                                       240038
150100200529     C     W@2153        DIV(H)    @RATEC        W@6157                                       240038
150200200529      *                                                                                       240038
150300200529     C                   SELECT                                                               240038
150400200529     C     @@CDP1        WHENEQ    1                                                          240038
150500200529     C                   MULT      10            W@6154                                       240038
150600200529     C                   MULT      10            W@6155                                       240038
150700200529     C                   MULT      10            W@6156                                       240038
150800200529     C                   MULT      10            W@6157                                       240038
150900200529     C     @@CDP1        WHENEQ    2                                                          240038
151000200529     C                   MULT      100           W@6154                                       240038
151100200529     C                   MULT      100           W@6155                                       240038
151200200529     C                   MULT      100           W@6156                                       240038
151300200529     C                   MULT      100           W@6157                                       240038
151400200529     C     @@CDP1        WHENEQ    3                                                          240038
151500200529     C                   MULT      1000          W@6154                                       240038
151600200529     C                   MULT      1000          W@6155                                       240038
151700200529     C                   MULT      1000          W@6156                                       240038
151800200529     C                   MULT      1000          W@6157                                       240038
151900200529     C                   ENDSL                                                                240038
152000200529      *                                                                                       240038
152100200529      ** Divide buy amount in different decimal places against +rate and store value          240038
152200200529      ** to a variable with two  decimal place.                                               240038
152300200529      *                                                                                       240038
152400200529     C     W@2150        DIV(H)    @RATEC        W@6158                                       240038
152500200529     C     W@2151        DIV(H)    @RATEC        W@6159                                       240038
152600200529     C     W@2152        DIV(H)    @RATEC        W@6160                                       240038
152700200529     C     W@2153        DIV(H)    @RATEC        W@6161                                       240038
152800200529      *                                                                                       240038
152900200529     C                   SELECT                                                               240038
153000200529     C     @@CDP1        WHENEQ    1                                                          240038
153100200529     C                   MULT      10            W@6158                                       240038
153200200529     C                   MULT      10            W@6159                                       240038
153300200529     C                   MULT      10            W@6160                                       240038
153400200529     C                   MULT      10            W@6161                                       240038
153500200529     C     @@CDP1        WHENEQ    2                                                          240038
153600200529     C                   MULT      100           W@6158                                       240038
153700200529     C                   MULT      100           W@6159                                       240038
153800200529     C                   MULT      100           W@6160                                       240038
153900200529     C                   MULT      100           W@6161                                       240038
154000200529     C     @@CDP1        WHENEQ    3                                                          240038
154100200529     C                   MULT      1000          W@6158                                       240038
154200200529     C                   MULT      1000          W@6159                                       240038
154300200529     C                   MULT      1000          W@6160                                       240038
154400200529     C                   MULT      1000          W@6161                                       240038
154500200529     C                   ENDSL                                                                240038
154600200529      *                                                                                       240038
154700200529      ** Divide buy amount in different decimal places against +rate and store value          240038
154800200529      ** to a variable with three decimal place.                                              240038
154900200529      *                                                                                       240038
155000200529     C     W@2150        DIV(H)    @RATEC        W@6162                                       240038
155100200529     C     W@2151        DIV(H)    @RATEC        W@6163                                       240038
155200200529     C     W@2152        DIV(H)    @RATEC        W@6164                                       240038
155300200529     C     W@2153        DIV(H)    @RATEC        W@6165                                       240038
155400200529      *                                                                                       240038
155500200529     C                   SELECT                                                               240038
155600200529     C     @@CDP1        WHENEQ    1                                                          240038
155700200529     C                   MULT      10            W@6162                                       240038
155800200529     C                   MULT      10            W@6163                                       240038
155900200529     C                   MULT      10            W@6164                                       240038
156000200529     C                   MULT      10            W@6165                                       240038
156100200529     C     @@CDP1        WHENEQ    2                                                          240038
156200200529     C                   MULT      100           W@6162                                       240038
156300200529     C                   MULT      100           W@6163                                       240038
156400200529     C                   MULT      100           W@6164                                       240038
156500200529     C                   MULT      100           W@6165                                       240038
156600200529     C     @@CDP1        WHENEQ    3                                                          240038
156700200529     C                   MULT      1000          W@6162                                       240038
156800200529     C                   MULT      1000          W@6163                                       240038
156900200529     C                   MULT      1000          W@6164                                       240038
157000200529     C                   MULT      1000          W@6165                                       240038
157100200529     C                   ENDSL                                                                240038
157200200529      *                                                                                       240038
157300200529      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
157400200529      ** is then assign a Divide rate to W@MDIN.                                              240038
157500200529      *                                                                                       240038
157600200529     C     W@6150        IFEQ      W@1150                                                     240038
157700200529     C     W@6151        OREQ      W@1150                                                     240038
157800200529     C     W@6152        OREQ      W@1150                                                     240038
157900200529     C     W@6153        OREQ      W@1150                                                     240038
158000200529     C     W@6154        OREQ      W@1150                                                     240038
158100200529     C     W@6155        OREQ      W@1150                                                     240038
158200200529     C     W@6156        OREQ      W@1150                                                     240038
158300200529     C     W@6157        OREQ      W@1150                                                     240038
158400200529     C     W@6158        OREQ      W@1150                                                     240038
158500200529     C     W@6159        OREQ      W@1150                                                     240038
158600200529     C     W@6160        OREQ      W@1150                                                     240038
158700200529     C     W@6161        OREQ      W@1150                                                     240038
158800200529     C     W@6162        OREQ      W@1150                                                     240038
158900200529     C     W@6163        OREQ      W@1150                                                     240038
159000200529     C     W@6164        OREQ      W@1150                                                     240038
159100200529     C     W@6165        OREQ      W@1150                                                     240038
159200200529     C                   MOVE      'D'           W@MDIN                                       240038
159300200529     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
159400200529     C                   ELSE                                                                 240038
159500200529      *                                                                                       240038
159600200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
159700200529      ** value to variable with zero decimal place.                                           240038
159800200529      *                                                                                       240038
159900200529     C     W@2150        MULT(H)   @RATED        W@7150                                       240038
160000200529     C     W@2151        MULT(H)   @RATED        W@7151                                       240038
160100200529     C     W@2152        MULT(H)   @RATED        W@7152                                       240038
160200200529     C     W@2153        MULT(H)   @RATED        W@7153                                       240038
160300200529      *                                                                                       240038
160400200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
160500200529      ** value to variable with one decimal place.                                            240038
160600200529      *                                                                                       240038
160700200529     C     W@2150        MULT(H)   @RATED        W@7154                                       240038
160800200529     C     W@2151        MULT(H)   @RATED        W@7155                                       240038
160900200529     C     W@2152        MULT(H)   @RATED        W@7156                                       240038
161000200529     C     W@2153        MULT(H)   @RATED        W@7157                                       240038
161100200529      *                                                                                       240038
161200200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
161300200529      ** value to variable with two decimal place.                                            240038
161400200529      *                                                                                       240038
161500200529     C     W@2150        MULT(H)   @RATED        W@7158                                       240038
161600200529     C     W@2151        MULT(H)   @RATED        W@7159                                       240038
161700200529     C     W@2152        MULT(H)   @RATED        W@7160                                       240038
161800200529     C     W@2153        MULT(H)   @RATED        W@7161                                       240038
161900200529      *                                                                                       240038
162000200529      ** Multiply the buy amount with different decimal places against -rate and store        240038
162100200529      ** value to variable with three decimal place.                                          240038
162200200529      *                                                                                       240038
162300200529     C     W@2150        MULT(H)   @RATED        W@7162                                       240038
162400200529     C     W@2151        MULT(H)   @RATED        W@7163                                       240038
162500200529     C     W@2152        MULT(H)   @RATED        W@7164                                       240038
162600200529     C     W@2153        MULT(H)   @RATED        W@7165                                       240038
162700200529      *                                                                                       240038
162800200529      ** Check if one of the above calculations satisfied the suppose sell amount and if it   240038
162900200529      ** is then assign a Multiply rate to W@MDIN.                                            240038
163000200529      *                                                                                       240038
163100200529     C     W@7150        IFEQ      W@1150                                                     240038
163200200529     C     W@7151        OREQ      W@1150                                                     240038
163300200529     C     W@7152        OREQ      W@1150                                                     240038
163400200529     C     W@7153        OREQ      W@1150                                                     240038
163500200529     C     W@7154        OREQ      W@1150                                                     240038
163600200529     C     W@7155        OREQ      W@1150                                                     240038
163700200529     C     W@7156        OREQ      W@1150                                                     240038
163800200529     C     W@7157        OREQ      W@1150                                                     240038
163900200529     C     W@7158        OREQ      W@1150                                                     240038
164000200529     C     W@7159        OREQ      W@1150                                                     240038
164100200529     C     W@7160        OREQ      W@1150                                                     240038
164200200529     C     W@7161        OREQ      W@1150                                                     240038
164300200529     C     W@7162        OREQ      W@1150                                                     240038
164400200529     C     W@7163        OREQ      W@1150                                                     240038
164500200529     C     W@7164        OREQ      W@1150                                                     240038
164600200529     C     W@7165        OREQ      W@1150                                                     240038
164700200529     C                   MOVE      'M'           W@MDIN                                       240038
164800200529     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
164900200529     C                   ENDIF                                                                240038
165000200529     C                   ENDIF                                                                240038
165100200529     C                   ENDIF                                                                240038
165200200529      *                                                                                       240038
165300200529      ** If the margin buy/sell indicator used is "S" and buy currency                        240038
165400200529      ** is equal to the dealing base currency.                                               240038
165500200529      *                                                                                       240038
165600200529     C     F3MGBS        IFEQ      'S'                                                        240038
165700200529     C     DDBCCY        ANDEQ     BNCYDL                                                     240038
165800200529      *                                                                                       240038
165900200529      ** Divide sell amount in different decimal places against +rate and store value         240038
166000200529      ** to a variable with zero decimal place.                                               240038
166100200529      *                                                                                       240038
166200200529     C     W@2150        DIV(H)    @RATEC        W@6250           15 0                        240038
166300200529     C     W@2151        DIV(H)    @RATEC        W@6251           15 0                        240038
166400200529     C     W@2152        DIV(H)    @RATEC        W@6252           15 0                        240038
166500200529     C     W@2153        DIV(H)    @RATEC        W@6253           15 0                        240038
166600200529      *                                                                                       240038
166700200529     C                   SELECT                                                               240038
166800200529     C     @@CDP1        WHENEQ    1                                                          240038
166900200529     C                   MULT      10            W@6250                                       240038
167000200529     C                   MULT      10            W@6251                                       240038
167100200529     C                   MULT      10            W@6252                                       240038
167200200529     C                   MULT      10            W@6253                                       240038
167300200529     C     @@CDP1        WHENEQ    2                                                          240038
167400200529     C                   MULT      100           W@6250                                       240038
167500200529     C                   MULT      100           W@6251                                       240038
167600200529     C                   MULT      100           W@6252                                       240038
167700200529     C                   MULT      100           W@6253                                       240038
167800200529     C     @@CDP1        WHENEQ    3                                                          240038
167900200529     C                   MULT      1000          W@6250                                       240038
168000200529     C                   MULT      1000          W@6251                                       240038
168100200529     C                   MULT      1000          W@6252                                       240038
168200200529     C                   MULT      1000          W@6253                                       240038
168300200529     C                   ENDSL                                                                240038
168400200529      *                                                                                       240038
168500200529      ** Divide sell amount in different decimal places against +rate and store value         240038
168600200529      ** to a variable with one  decimal place.                                               240038
168700200529      *                                                                                       240038
168800200529     C     W@2150        DIV(H)    @RATEC        W@6254           15 1                        240038
168900200529     C     W@2151        DIV(H)    @RATEC        W@6255           15 1                        240038
169000200529     C     W@2152        DIV(H)    @RATEC        W@6256           15 1                        240038
169100200529     C     W@2153        DIV(H)    @RATEC        W@6257           15 1                        240038
169200200529      *                                                                                       240038
169300200529     C                   SELECT                                                               240038
169400200529     C     @@CDP1        WHENEQ    1                                                          240038
169500200529     C                   MULT      10            W@6254                                       240038
169600200529     C                   MULT      10            W@6255                                       240038
169700200529     C                   MULT      10            W@6256                                       240038
169800200529     C                   MULT      10            W@6257                                       240038
169900200529     C     @@CDP1        WHENEQ    2                                                          240038
170000200529     C                   MULT      100           W@6254                                       240038
170100200529     C                   MULT      100           W@6255                                       240038
170200200529     C                   MULT      100           W@6256                                       240038
170300200529     C                   MULT      100           W@6257                                       240038
170400200529     C     @@CDP1        WHENEQ    3                                                          240038
170500200529     C                   MULT      1000          W@6254                                       240038
170600200529     C                   MULT      1000          W@6255                                       240038
170700200529     C                   MULT      1000          W@6256                                       240038
170800200529     C                   MULT      1000          W@6257                                       240038
170900200529     C                   ENDSL                                                                240038
171000200529      *                                                                                       240038
171100200529      ** Divide sell amount in different decimal places against +rate and store value         240038
171200200529      ** to a variable with two  decimal place.                                               240038
171300200529      *                                                                                       240038
171400200529     C     W@2150        DIV(H)    @RATEC        W@6258           15 2                        240038
171500200529     C     W@2151        DIV(H)    @RATEC        W@6259           15 2                        240038
171600200529     C     W@2152        DIV(H)    @RATEC        W@6260           15 2                        240038
171700200529     C     W@2153        DIV(H)    @RATEC        W@6261           15 2                        240038
171800200529      *                                                                                       240038
171900200529     C                   SELECT                                                               240038
172000200529     C     @@CDP1        WHENEQ    1                                                          240038
172100200529     C                   MULT      10            W@6258                                       240038
172200200529     C                   MULT      10            W@6259                                       240038
172300200529     C                   MULT      10            W@6260                                       240038
172400200529     C                   MULT      10            W@6261                                       240038
172500200529     C     @@CDP1        WHENEQ    2                                                          240038
172600200529     C                   MULT      100           W@6258                                       240038
172700200529     C                   MULT      100           W@6259                                       240038
172800200529     C                   MULT      100           W@6260                                       240038
172900200529     C                   MULT      100           W@6261                                       240038
173000200529     C     @@CDP1        WHENEQ    3                                                          240038
173100200529     C                   MULT      1000          W@6258                                       240038
173200200529     C                   MULT      1000          W@6259                                       240038
173300200529     C                   MULT      1000          W@6260                                       240038
173400200529     C                   MULT      1000          W@6261                                       240038
173500200529     C                   ENDSL                                                                240038
173600200529      *                                                                                       240038
173700200529      ** Divide sell amount in different decimal places against +rate and store value         240038
173800200529      ** to a variable with three decimal place.                                              240038
173900200529      *                                                                                       240038
174000200529     C     W@2150        DIV(H)    @RATEC        W@6262           15 3                        240038
174100200529     C     W@2151        DIV(H)    @RATEC        W@6263           15 3                        240038
174200200529     C     W@2152        DIV(H)    @RATEC        W@6264           15 3                        240038
174300200529     C     W@2153        DIV(H)    @RATEC        W@6265           15 3                        240038
174400200529      *                                                                                       240038
174500200529     C                   SELECT                                                               240038
174600200529     C     @@CDP1        WHENEQ    1                                                          240038
174700200529     C                   MULT      10            W@6262                                       240038
174800200529     C                   MULT      10            W@6263                                       240038
174900200529     C                   MULT      10            W@6264                                       240038
175000200529     C                   MULT      10            W@6265                                       240038
175100200529     C     @@CDP1        WHENEQ    2                                                          240038
175200200529     C                   MULT      100           W@6262                                       240038
175300200529     C                   MULT      100           W@6263                                       240038
175400200529     C                   MULT      100           W@6264                                       240038
175500200529     C                   MULT      100           W@6265                                       240038
175600200529     C     @@CDP1        WHENEQ    3                                                          240038
175700200529     C                   MULT      1000          W@6262                                       240038
175800200529     C                   MULT      1000          W@6263                                       240038
175900200529     C                   MULT      1000          W@6264                                       240038
176000200529     C                   MULT      1000          W@6265                                       240038
176100200529     C                   ENDSL                                                                240038
176200200529      *                                                                                       240038
176300200529      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
176400200529      ** is then assign a Multiply rate to W@MDIN.                                            240038
176500200529      *                                                                                       240038
176600200529     C     W@6250        IFEQ      W@1150                                                     240038
176700200529     C     W@6251        OREQ      W@1150                                                     240038
176800200529     C     W@6252        OREQ      W@1150                                                     240038
176900200529     C     W@6253        OREQ      W@1150                                                     240038
177000200529     C     W@6254        OREQ      W@1150                                                     240038
177100200529     C     W@6255        OREQ      W@1150                                                     240038
177200200529     C     W@6256        OREQ      W@1150                                                     240038
177300200529     C     W@6257        OREQ      W@1150                                                     240038
177400200529     C     W@6258        OREQ      W@1150                                                     240038
177500200529     C     W@6259        OREQ      W@1150                                                     240038
177600200529     C     W@6260        OREQ      W@1150                                                     240038
177700200529     C     W@6261        OREQ      W@1150                                                     240038
177800200529     C     W@6262        OREQ      W@1150                                                     240038
177900200529     C     W@6263        OREQ      W@1150                                                     240038
178000200529     C     W@6264        OREQ      W@1150                                                     240038
178100200529     C     W@6265        OREQ      W@1150                                                     240038
178200200529     C                   MOVE      'D'           W@MDIN                                       240038
178300200529     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
178400200529     C                   ELSE                                                                 240038
178500200529      *                                                                                       240038
178600200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
178700200529      ** value to variable with zero decimal place.                                           240038
178800200529      *                                                                                       240038
178900200529     C     W@2150        MULT(H)   @RATED        W@7250           15 0                        240038
179000200529     C     W@2151        MULT(H)   @RATED        W@7251           15 0                        240038
179100200529     C     W@2152        MULT(H)   @RATED        W@7252           15 0                        240038
179200200529     C     W@2153        MULT(H)   @RATED        W@7253           15 0                        240038
179300200529      *                                                                                       240038
179400200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
179500200529      ** value to variable with one decimal place.                                            240038
179600200529      *                                                                                       240038
179700200529     C     W@2150        MULT(H)   @RATED        W@7254           15 1                        240038
179800200529     C     W@2151        MULT(H)   @RATED        W@7255           15 1                        240038
179900200529     C     W@2152        MULT(H)   @RATED        W@7256           15 1                        240038
180000200529     C     W@2153        MULT(H)   @RATED        W@7257           15 1                        240038
180100200529      *                                                                                       240038
180200200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
180300200529      ** value to variable with two decimal place.                                            240038
180400200529      *                                                                                       240038
180500200529     C     W@2150        MULT(H)   @RATED        W@7258           15 2                        240038
180600200529     C     W@2151        MULT(H)   @RATED        W@7259           15 2                        240038
180700200529     C     W@2152        MULT(H)   @RATED        W@7260           15 2                        240038
180800200529     C     W@2153        MULT(H)   @RATED        W@7261           15 2                        240038
180900200529      *                                                                                       240038
181000200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
181100200529      ** value to variable with thre decimal place.                                           240038
181200200529      *                                                                                       240038
181300200529     C     W@2150        MULT(H)   @RATED        W@7262           15 3                        240038
181400200529     C     W@2151        MULT(H)   @RATED        W@7263           15 3                        240038
181500200529     C     W@2152        MULT(H)   @RATED        W@7264           15 3                        240038
181600200529     C     W@2153        MULT(H)   @RATED        W@7265           15 3                        240038
181700200529      *                                                                                       240038
181800200529      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
181900200529      ** is then assign a Multiply rate to W@MDIN.                                            240038
182000200529      *                                                                                       240038
182100200529     C     W@7250        IFEQ      W@1150                                                     240038
182200200529     C     W@7251        OREQ      W@1150                                                     240038
182300200529     C     W@7252        OREQ      W@1150                                                     240038
182400200529     C     W@7253        OREQ      W@1150                                                     240038
182500200529     C     W@7254        OREQ      W@1150                                                     240038
182600200529     C     W@7255        OREQ      W@1150                                                     240038
182700200529     C     W@7256        OREQ      W@1150                                                     240038
182800200529     C     W@7257        OREQ      W@1150                                                     240038
182900200529     C     W@7258        OREQ      W@1150                                                     240038
183000200529     C     W@7259        OREQ      W@1150                                                     240038
183100200529     C     W@7260        OREQ      W@1150                                                     240038
183200200529     C     W@7261        OREQ      W@1150                                                     240038
183300200529     C     W@7262        OREQ      W@1150                                                     240038
183400200529     C     W@7263        OREQ      W@1150                                                     240038
183500200529     C     W@7264        OREQ      W@1150                                                     240038
183600200529     C     W@7265        OREQ      W@1150                                                     240038
183700200529     C                   MOVE      'M'           W@MDIN                                       240038
183800200529     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
183900200529     C                   ENDIF                                                                240038
184000200529     C                   ENDIF                                                                240038
184100200529     C                   ENDIF                                                                240038
184200200529      *                                                                                       240038
184300200529      ** If the margin buy/sell indicator used is "S" sell currency is                        240038
184400200529      ** equal to the dealing base currency.                                                  240038
184500200529      *                                                                                       240038
184600200529     C     F3MGBS        IFEQ      'S'                                                        240038
184700200529     C     DDSCCY        ANDEQ     BNCYDL                                                     240038
184800200529      *                                                                                       240038
184900200529      ** Divide sell amount in different decimal places against +rate and store value         240038
185000200529      ** to a variable with zero decimal place.                                               240038
185100200529      *                                                                                       240038
185200200529     C     W@1150        DIV(H)    @RATEC        W@6250                                       240038
185300200529     C     W@1151        DIV(H)    @RATEC        W@6251                                       240038
185400200529     C     W@1152        DIV(H)    @RATEC        W@6252                                       240038
185500200529     C     W@1153        DIV(H)    @RATEC        W@6253                                       240038
185600200529      *                                                                                       240038
185700200529     C                   SELECT                                                               240038
185800200529     C     @@CDP2        WHENEQ    1                                                          240038
185900200529     C                   MULT      10            W@6250                                       240038
186000200529     C                   MULT      10            W@6251                                       240038
186100200529     C                   MULT      10            W@6252                                       240038
186200200529     C                   MULT      10            W@6253                                       240038
186300200529     C     @@CDP2        WHENEQ    2                                                          240038
186400200529     C                   MULT      100           W@6250                                       240038
186500200529     C                   MULT      100           W@6251                                       240038
186600200529     C                   MULT      100           W@6252                                       240038
186700200529     C                   MULT      100           W@6253                                       240038
186800200529     C     @@CDP2        WHENEQ    3                                                          240038
186900200529     C                   MULT      1000          W@6250                                       240038
187000200529     C                   MULT      1000          W@6251                                       240038
187100200529     C                   MULT      1000          W@6252                                       240038
187200200529     C                   MULT      1000          W@6253                                       240038
187300200529     C                   ENDSL                                                                240038
187400200529      *                                                                                       240038
187500200529      ** Divide sell amount in different decimal places against +rate and store value         240038
187600200529      ** to a variable with one  decimal place.                                               240038
187700200529      *                                                                                       240038
187800200529     C     W@1150        DIV(H)    @RATEC        W@6254                                       240038
187900200529     C     W@1151        DIV(H)    @RATEC        W@6255                                       240038
188000200529     C     W@1152        DIV(H)    @RATEC        W@6256                                       240038
188100200529     C     W@1153        DIV(H)    @RATEC        W@6257                                       240038
188200200529      *                                                                                       240038
188300200529     C                   SELECT                                                               240038
188400200529     C     @@CDP2        WHENEQ    1                                                          240038
188500200529     C                   MULT      10            W@6254                                       240038
188600200529     C                   MULT      10            W@6255                                       240038
188700200529     C                   MULT      10            W@6256                                       240038
188800200529     C                   MULT      10            W@6257                                       240038
188900200529     C     @@CDP2        WHENEQ    2                                                          240038
189000200529     C                   MULT      100           W@6254                                       240038
189100200529     C                   MULT      100           W@6255                                       240038
189200200529     C                   MULT      100           W@6256                                       240038
189300200529     C                   MULT      100           W@6257                                       240038
189400200529     C     @@CDP2        WHENEQ    3                                                          240038
189500200529     C                   MULT      1000          W@6254                                       240038
189600200529     C                   MULT      1000          W@6255                                       240038
189700200529     C                   MULT      1000          W@6256                                       240038
189800200529     C                   MULT      1000          W@6257                                       240038
189900200529     C                   ENDSL                                                                240038
190000200529      *                                                                                       240038
190100200529      ** Divide sell amount in different decimal places against +rate and store value         240038
190200200529      ** to a variable with two  decimal place.                                               240038
190300200529      *                                                                                       240038
190400200529     C     W@1150        DIV(H)    @RATEC        W@6258                                       240038
190500200529     C     W@1151        DIV(H)    @RATEC        W@6259                                       240038
190600200529     C     W@1152        DIV(H)    @RATEC        W@6260                                       240038
190700200529     C     W@1153        DIV(H)    @RATEC        W@6261                                       240038
190800200529      *                                                                                       240038
190900200529     C                   SELECT                                                               240038
191000200529     C     @@CDP2        WHENEQ    1                                                          240038
191100200529     C                   MULT      10            W@6258                                       240038
191200200529     C                   MULT      10            W@6259                                       240038
191300200529     C                   MULT      10            W@6260                                       240038
191400200529     C                   MULT      10            W@6261                                       240038
191500200529     C     @@CDP2        WHENEQ    2                                                          240038
191600200529     C                   MULT      100           W@6258                                       240038
191700200529     C                   MULT      100           W@6259                                       240038
191800200529     C                   MULT      100           W@6260                                       240038
191900200529     C                   MULT      100           W@6261                                       240038
192000200529     C     @@CDP2        WHENEQ    3                                                          240038
192100200529     C                   MULT      1000          W@6258                                       240038
192200200529     C                   MULT      1000          W@6259                                       240038
192300200529     C                   MULT      1000          W@6260                                       240038
192400200529     C                   MULT      1000          W@6261                                       240038
192500200529     C                   ENDSL                                                                240038
192600200529      *                                                                                       240038
192700200529      ** Divide sell amount in different decimal places against +rate and store value         240038
192800200529      ** to a variable with three decimal place.                                              240038
192900200529      *                                                                                       240038
193000200529     C     W@1150        DIV(H)    @RATEC        W@6262                                       240038
193100200529     C     W@1151        DIV(H)    @RATEC        W@6263                                       240038
193200200529     C     W@1152        DIV(H)    @RATEC        W@6264                                       240038
193300200529     C     W@1153        DIV(H)    @RATEC        W@6265                                       240038
193400200529      *                                                                                       240038
193500200529     C                   SELECT                                                               240038
193600200529     C     @@CDP2        WHENEQ    1                                                          240038
193700200529     C                   MULT      10            W@6262                                       240038
193800200529     C                   MULT      10            W@6263                                       240038
193900200529     C                   MULT      10            W@6264                                       240038
194000200529     C                   MULT      10            W@6265                                       240038
194100200529     C     @@CDP2        WHENEQ    2                                                          240038
194200200529     C                   MULT      100           W@6262                                       240038
194300200529     C                   MULT      100           W@6263                                       240038
194400200529     C                   MULT      100           W@6264                                       240038
194500200529     C                   MULT      100           W@6265                                       240038
194600200529     C     @@CDP2        WHENEQ    3                                                          240038
194700200529     C                   MULT      1000          W@6262                                       240038
194800200529     C                   MULT      1000          W@6263                                       240038
194900200529     C                   MULT      1000          W@6264                                       240038
195000200529     C                   MULT      1000          W@6265                                       240038
195100200529     C                   ENDSL                                                                240038
195200200529      *                                                                                       240038
195300200529      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
195400200529      ** is then assign a Multiply rate to W@MDIN.                                            240038
195500200529      *                                                                                       240038
195600200529     C     W@6250        IFEQ      W@2150                                                     240038
195700200529     C     W@6251        OREQ      W@2150                                                     240038
195800200529     C     W@6252        OREQ      W@2150                                                     240038
195900200529     C     W@6253        OREQ      W@2150                                                     240038
196000200529     C     W@6254        OREQ      W@2150                                                     240038
196100200529     C     W@6255        OREQ      W@2150                                                     240038
196200200529     C     W@6256        OREQ      W@2150                                                     240038
196300200529     C     W@6257        OREQ      W@2150                                                     240038
196400200529     C     W@6258        OREQ      W@2150                                                     240038
196500200529     C     W@6259        OREQ      W@2150                                                     240038
196600200529     C     W@6260        OREQ      W@2150                                                     240038
196700200529     C     W@6261        OREQ      W@2150                                                     240038
196800200529     C     W@6262        OREQ      W@2150                                                     240038
196900200529     C     W@6263        OREQ      W@2150                                                     240038
197000200529     C     W@6264        OREQ      W@2150                                                     240038
197100200529     C     W@6265        OREQ      W@2150                                                     240038
197200200529     C                   MOVE      'D'           W@MDIN                                       240038
197300200529     C     @SRATE        ADD       @RATEV        @RRATE                                       240038
197400200529     C                   ELSE                                                                 240038
197500200529      *                                                                                       240038
197600200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
197700200529      ** value to variable with zero decimal place.                                           240038
197800200529      *                                                                                       240038
197900200529     C     W@1150        MULT(H)   @RATED        W@7250                                       240038
198000200529     C     W@1151        MULT(H)   @RATED        W@7251                                       240038
198100200529     C     W@1152        MULT(H)   @RATED        W@7252                                       240038
198200200529     C     W@1153        MULT(H)   @RATED        W@7253                                       240038
198300200529      *                                                                                       240038
198400200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
198500200529      ** value to variable with one decimal place.                                            240038
198600200529      *                                                                                       240038
198700200529     C     W@1150        MULT(H)   @RATED        W@7254                                       240038
198800200529     C     W@1151        MULT(H)   @RATED        W@7255                                       240038
198900200529     C     W@1152        MULT(H)   @RATED        W@7256                                       240038
199000200529     C     W@1153        MULT(H)   @RATED        W@7257                                       240038
199100200529      *                                                                                       240038
199200200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
199300200529      ** value to variable with two decimal place.                                            240038
199400200529      *                                                                                       240038
199500200529     C     W@1150        MULT(H)   @RATED        W@7258                                       240038
199600200529     C     W@1151        MULT(H)   @RATED        W@7259                                       240038
199700200529     C     W@1152        MULT(H)   @RATED        W@7260                                       240038
199800200529     C     W@1153        MULT(H)   @RATED        W@7261                                       240038
199900200529      *                                                                                       240038
200000200529      ** Multiply the sell amount with different decimal places against -rate and store       240038
200100200529      ** value to variable with thre decimal place.                                           240038
200200200529      *                                                                                       240038
200300200529     C     W@1150        MULT(H)   @RATED        W@7262                                       240038
200400200529     C     W@1151        MULT(H)   @RATED        W@7263                                       240038
200500200529     C     W@1152        MULT(H)   @RATED        W@7264                                       240038
200600200529     C     W@1153        MULT(H)   @RATED        W@7265                                       240038
200700200529      *                                                                                       240038
200800200529      ** Check if one of the above calculations satisfied the suppose buy amount and if it    240038
200900200529      ** is then assign a Multiply rate to W@MDIN.                                            240038
201000200529      *                                                                                       240038
201100200529     C     W@7250        IFEQ      W@2150                                                     240038
201200200529     C     W@7251        OREQ      W@2150                                                     240038
201300200529     C     W@7252        OREQ      W@2150                                                     240038
201400200529     C     W@7253        OREQ      W@2150                                                     240038
201500200529     C     W@7254        OREQ      W@2150                                                     240038
201600200529     C     W@7255        OREQ      W@2150                                                     240038
201700200529     C     W@7256        OREQ      W@2150                                                     240038
201800200529     C     W@7257        OREQ      W@2150                                                     240038
201900200529     C     W@7258        OREQ      W@2150                                                     240038
202000200529     C     W@7259        OREQ      W@2150                                                     240038
202100200529     C     W@7260        OREQ      W@2150                                                     240038
202200200529     C     W@7261        OREQ      W@2150                                                     240038
202300200529     C     W@7262        OREQ      W@2150                                                     240038
202400200529     C     W@7263        OREQ      W@2150                                                     240038
202500200529     C     W@7264        OREQ      W@2150                                                     240038
202600200529     C     W@7265        OREQ      W@2150                                                     240038
202700200529     C                   MOVE      'M'           W@MDIN                                       240038
202800200529     C     @SRATE        SUB       @RATEV        @RRATE                                       240038
202900200529     C                   ENDIF                                                                240038
203000200529     C                   ENDIF                                                                240038
203100200529     C                   ENDIF                                                                240038
203200200529     C*
203300200529     C*
203400200529     C** SET UP RATES TO BE VALIDATED ACCORDING TO METHOD 1, 2, OR 3
203500200529     C** (1 = OUTRIGHT RATE, 2 = RATE + 0.0000005, 3 = RATE - 0.00000005)
203600200529     C** (RATE IS DESCALED RATE)
203700200529     C*
203800200529     C     @@K           IFEQ      1
203900200529     C                   Z-ADD     @RRATE        @KRATE           13 8
204000200529     C                   Z-ADD     @RRATE        @ORATE           14 9
204100200529     C                   END
204200200529     C     @@K           IFEQ      2
204300200529     C     @KRATE        ADD       .000000005    @ORATE
204400200529     C                   END
204500200529     C     @@K           IFEQ      3
204600200529     C     @KRATE        SUB       .000000005    @ORATE
204700200529     C                   END
204800200529     C*
204900200529     C* RESET DIFFERENCES (BETWEEN ACTUAL & CALCULATED BUY/SELL AMOUNTS)
205000200529     C*
205100200529     C                   Z-ADD     1             W@DFBM
205200200529     C                   Z-ADD     1             W@DFSM
205300200529     C                   Z-ADD     1             W@DFBD
205400200529     C                   Z-ADD     1             W@DFSD
205500200529     C*
205600200529     C** Initialize variable @@PAS which check if the cross-validation
205700200529     C** passes the 2 units tolerance test, for round down CCY.
205800200529     C*
205900200529     C                   MOVEL     'N'           @@PASM            1
206000200529     C                   MOVEL     'N'           @@PASD            1
206100200529      *----------------------------------------------------------------
206200200529      *
206300200529      ** If Buy Currency = Base Currency For Dealing
206400200529      ** Determine differences between actual 'other' currency amount
206500200529      ** and calculated 'other' currency amount (amount x or / rate)
206600200529      *
206700200529     C     @@BSIN        IFEQ      'B'                                          IF BASE=BUY
206800200529     C     @ORATE        ANDNE     *ZERO
206900200529     C                   Z-ADD     @@CDP1        W@DECP                           I:Dec.places
207000200529      *
207100200529      ** Calculate 'other' currency amount (amount x or / rate)
207200200529      *
207300200529     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
207400200529     C   90W@2150        DIV(H)    @ORATE        W@3150                           =A/3 15,0
207500200529     C   91W@2150        DIV(H)    @ORATE        W@3151                           =A/3 15,1
207600200529     C   92W@2150        DIV(H)    @ORATE        W@3152                           =A/3 15,2
207700200529     C   93W@2150        DIV(H)    @ORATE        W@3153                           =A/3 15,3
207800200529     C   90W@1150        MULT(H)   @ORATE        W@4150                           =A/4 15,0
207900200529     C   91W@1151        MULT(H)   @ORATE        W@4150                           =A/4 15,1
208000200529     C   92W@1152        MULT(H)   @ORATE        W@4150                           =A/4 15,2
208100200529     C   93W@1153        MULT(H)   @ORATE        W@4150                           =A/4 15,3
208200200529     C                   END                                                    FI
208300200529     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
208400200529     C   90W@2151        DIV(H)    @ORATE        W@3150                           =A/3 15,0
208500200529     C   91W@2151        DIV(H)    @ORATE        W@3151                           =A/3 15,1
208600200529     C   92W@2151        DIV(H)    @ORATE        W@3152                           =A/3 15,2
208700200529     C   93W@2151        DIV(H)    @ORATE        W@3153                           =A/3 15,3
208800200529     C   90W@1150        MULT(H)   @ORATE        W@4151                           =A/4 15,0
208900200529     C   91W@1151        MULT(H)   @ORATE        W@4151                           =A/4 15,1
209000200529     C   92W@1152        MULT(H)   @ORATE        W@4151                           =A/4 15,2
209100200529     C   93W@1153        MULT(H)   @ORATE        W@4151                           =A/4 15,3
209200200529     C                   END                                                    FI
209300200529     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
209400200529     C   90W@2152        DIV(H)    @ORATE        W@3150                           =A/3 15,0
209500200529     C   91W@2152        DIV(H)    @ORATE        W@3151                           =A/3 15,1
209600200529     C   92W@2152        DIV(H)    @ORATE        W@3152                           =A/3 15,2
209700200529     C   93W@2152        DIV(H)    @ORATE        W@3153                           =A/3 15,3
209800200529     C   90W@1150        MULT(H)   @ORATE        W@4152                           =A/4 15,0
209900200529     C   91W@1151        MULT(H)   @ORATE        W@4152                           =A/4 15,1
210000200529     C   92W@1152        MULT(H)   @ORATE        W@4152                           =A/4 15,2
210100200529     C   93W@1153        MULT(H)   @ORATE        W@4152                           =A/4 15,3
210200200529     C                   END                                                    FI
210300200529     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
210400200529     C   90W@2153        DIV(H)    @ORATE        W@3150                           =A/3 15,0
210500200529     C   91W@2153        DIV(H)    @ORATE        W@3151                           =A/3 15,1
210600200529     C   92W@2153        DIV(H)    @ORATE        W@3152                           =A/3 15,2
210700200529     C   93W@2153        DIV(H)    @ORATE        W@3153                           =A/3 15,3
210800200529     C   90W@1150        MULT(H)   @ORATE        W@4153                           =A/4 15,0
210900200529     C   91W@1151        MULT(H)   @ORATE        W@4153                           =A/4 15,1
211000200529     C   92W@1152        MULT(H)   @ORATE        W@4153                           =A/4 15,2
211100200529     C   93W@1153        MULT(H)   @ORATE        W@4153                           =A/4 15,3
211200200529     C                   END                                                    FI
211300200529     C*
211400200529     C** Determine difference between calculated and actual
211500200529     C*
211600200529     C     W@1150        SUB       W@3150        W@DFBD           15 0          actual - calcd
211700200529     C     W@2150        SUB       W@4150        W@DFSD           15 0          actual - calcd
211800200529     C*
211900200529     C** Check if difference is within 2 units of calculated amount
212000200529     C** (this tolerance will be allowed only if JSM installed, and at
212100200529     C** least one of the currencies allows round down of amount)
212200200529     C** If it is within 2 units of tolerance, set on a 'PASS' flag.
212300200529     C*
212400200529     C     W@DFBD        IFGE      -2
212500200529     C     W@DFBD        ANDLE     2
212600200529     C     W@DFSD        ORGE      -2
212700200529     C     W@DFSD        ANDLE     2
212800200529     C                   MOVEL     'Y'           @@PASD
212900200529     C                   END
213000200529     C*
213100200529     C* Store calculated amounts for each method ( 1 2 and 3)
213200200529     C*
213300200529     C     @@K           IFEQ      1
213400200529     C                   Z-ADD     W@3150        BD1501           15 0
213500200529     C                   Z-ADD     W@4150        SD1501           15 0
213600200529     C                   Z-ADD     0             BD1502
213700200529     C                   Z-ADD     0             SD1502
213800200529     C                   Z-ADD     0             BD1503
213900200529     C                   Z-ADD     0             SD1503
214000200529     C                   END
214100200529     C     @@K           IFEQ      2
214200200529     C                   Z-ADD     W@3150        BD1502           15 0
214300200529     C                   Z-ADD     W@4150        SD1502           15 0
214400200529     C                   END
214500200529     C     @@K           IFEQ      3
214600200529     C                   Z-ADD     W@3150        BD1503           15 0
214700200529     C                   Z-ADD     W@4150        SD1503           15 0
214800200529     C                   END
214900200529      /EJECT
215000200529     C*
215100200529     C** Do further checking following code if :
215200200529     C** a) @ROUND indicator not on and both differences are not zero.
215300200529     C** ..if either difference amount calculated is zero, then the
215400200529     C** ..amount has passed one of the tests and no more checking
215500200529     C** ..needs to be done.
215600200529     C*
215700200529     C     W@DFBD        IFNE      0
215800200529     C     W@DFSD        ANDNE     0
215900200529     C     @ROUND        ANDNE     'Y'
216000200529     C     @@PASD        ANDNE     'Y'                                                      AR703547
216100200529     C*
216200200529     C** b) @ROUND indicator on, @@K=1 and both differences > 2 units
216300200529     C** ..allow 2 units tolerance if round down of calculated amount
216400200529     C** ..is allowed, for K = 1.
216500200529     C*
216600200529     C     @ROUND        OREQ      'Y'
216700200529     C     @@K           ANDEQ     1
216800200529     C     @@PASD        ANDNE     'Y'
216900200529     C*
217000200529     C** C) @ROUND indicator on, @KK not = 1 and both differences not zero
217100200529     C** ..The 2 unit tolerance test does not apply for @@K equal to
217200200529     C** ..2 or 3 since they had use a tolerance of +/- .00000005
217300200529     C** ..in the spot rate used, which would give combined
217400200529     C** ..tolerance greater than 1 unit.
217500200529     C*
217600200529     C     @ROUND        OREQ      'Y'
217700200529     C     @@K           ANDNE     1
217800200529     C     W@DFBD        ANDNE     0
217900200529     C     W@DFSD        ANDNE     0
218000200529      *
218100200529      ** Calculate 'other' currency amount (amount x or / rate)
218200200529      *
218300200529     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
218400200529     C   90W@2150        MULT(H)   @ORATE        W@3150                           =A/3 15,0
218500200529     C   91W@2150        MULT(H)   @ORATE        W@3151                           =A/3 15,1
218600200529     C   92W@2150        MULT(H)   @ORATE        W@3152                           =A/3 15,2
218700200529     C   93W@2150        MULT(H)   @ORATE        W@3153                           =A/3 15,3
218800200529     C   90W@1150        DIV(H)    @ORATE        W@4150                           =A/4 15,0
218900200529     C   91W@1151        DIV(H)    @ORATE        W@4150                           =A/4 15,1
219000200529     C   92W@1152        DIV(H)    @ORATE        W@4150                           =A/4 15,2
219100200529     C   93W@1153        DIV(H)    @ORATE        W@4150                           =A/4 15,3
219200200529     C                   END                                                    FI
219300200529     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
219400200529     C   90W@2151        MULT(H)   @ORATE        W@3150                           =A/3 15,0
219500200529     C   91W@2151        MULT(H)   @ORATE        W@3151                           =A/3 15,1
219600200529     C   92W@2151        MULT(H)   @ORATE        W@3152                           =A/3 15,2
219700200529     C   93W@2151        MULT(H)   @ORATE        W@3153                           =A/3 15,3
219800200529     C   90W@1150        DIV(H)    @ORATE        W@4151                           =A/4 15,0
219900200529     C   91W@1151        DIV(H)    @ORATE        W@4151                           =A/4 15,1
220000200529     C   92W@1152        DIV(H)    @ORATE        W@4151                           =A/4 15,2
220100200529     C   93W@1153        DIV(H)    @ORATE        W@4151                           =A/4 15,3
220200200529     C                   END                                                    FI
220300200529     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
220400200529     C   90W@2152        MULT(H)   @ORATE        W@3150                           =A/3 15,0
220500200529     C   91W@2152        MULT(H)   @ORATE        W@3151                           =A/3 15,1
220600200529     C   92W@2152        MULT(H)   @ORATE        W@3152                           =A/3 15,2
220700200529     C   93W@2152        MULT(H)   @ORATE        W@3153                           =A/3 15,3
220800200529     C   90W@1150        DIV(H)    @ORATE        W@4152                           =A/4 15,0
220900200529     C   91W@1151        DIV(H)    @ORATE        W@4152                           =A/4 15,1
221000200529     C   92W@1152        DIV(H)    @ORATE        W@4152                           =A/4 15,2
221100200529     C   93W@1153        DIV(H)    @ORATE        W@4152                           =A/4 15,3
221200200529     C                   END                                                    FI
221300200529     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
221400200529     C   90W@2153        MULT(H)   @ORATE        W@3150                           =A/3 15,0
221500200529     C   91W@2153        MULT(H)   @ORATE        W@3151                           =A/3 15,1
221600200529     C   92W@2153        MULT(H)   @ORATE        W@3152                           =A/3 15,2
221700200529     C   93W@2153        MULT(H)   @ORATE        W@3153                           =A/3 15,3
221800200529     C   90W@1150        DIV(H)    @ORATE        W@4153                           =A/4 15,0
221900200529     C   91W@1151        DIV(H)    @ORATE        W@4153                           =A/4 15,1
222000200529     C   92W@1152        DIV(H)    @ORATE        W@4153                           =A/4 15,2
222100200529     C   93W@1153        DIV(H)    @ORATE        W@4153                           =A/4 15,3
222200200529     C                   END                                                    FI
222300200529     C*
222400200529     C** Determine difference between calculated and actual
222500200529     C*
222600200529     C     W@1150        SUB       W@3150        W@DFBM           15 0          actual - calcd
222700200529     C     W@2150        SUB       W@4150        W@DFSM           15 0          actual - calcd
222800200529     C*
222900200529     C** Check if difference is within 2 units of calculated amount
223000200529     C** (this tolerance will be allowed only if JSM installed, and at
223100200529     C** least one of the currencies allows round down of amount)
223200200529     C*
223300200529     C     W@DFBM        IFGE      -2
223400200529     C     W@DFBM        ANDLE     2
223500200529     C     W@DFSM        ORGE      -2
223600200529     C     W@DFSM        ANDLE     2
223700200529     C                   MOVEL     'Y'           @@PASM
223800200529     C                   END
223900200529     C*
224000200529     C* Store calculated amounts for each method ( 1 2 and 3)
224100200529     C*
224200200529     C     @@K           IFEQ      1
224300200529     C                   Z-ADD     W@3150        BM1501           15 0
224400200529     C                   Z-ADD     W@4150        SM1501           15 0
224500200529     C                   Z-ADD     0             BM1502
224600200529     C                   Z-ADD     0             SM1502
224700200529     C                   Z-ADD     0             BM1503
224800200529     C                   Z-ADD     0             SM1503
224900200529     C                   END
225000200529     C     @@K           IFEQ      2
225100200529     C                   Z-ADD     W@3150        BM1502           15 0
225200200529     C                   Z-ADD     W@4150        SM1502           15 0
225300200529     C                   END
225400200529     C     @@K           IFEQ      3
225500200529     C                   Z-ADD     W@3150        BM1503           15 0
225600200529     C                   Z-ADD     W@4150        SM1503           15 0
225700200529     C                   END
225800200529     C                   END
225900200529     C                   END
226000200529      *----------------------------------------------------------------
226100200529      /EJECT
226200200529      *----------------------------------------------------------------
226300200529      *
226400200529      ** If Sell Currency = Base Currency For Dealing
226500200529      ** Determine differences between actual 'other' currency amount
226600200529      ** and calculated 'other' currency amount (amount x or / rate)
226700200529      *
226800200529     C     @@BSIN        IFEQ      'S'                                          IF BASE=SELL
226900200529     C     @ORATE        ANDNE     *ZERO
227000200529      *
227100200529      ** Calculate 'other' currency amount (amount x or / rate)
227200200529      *
227300200529     C                   Z-ADD     @@CDP2        W@DECP                           I:Dec.places
227400200529     C     *IN90         IFEQ      '1'                                          IF A/1 = 15,0
227500200529     C   94W@1150        DIV(H)    @ORATE        W@3150                           =A/3 15,0
227600200529     C   95W@1150        DIV(H)    @ORATE        W@3151                           =A/3 15,1
227700200529     C   96W@1150        DIV(H)    @ORATE        W@3152                           =A/3 15,2
227800200529     C   97W@1150        DIV(H)    @ORATE        W@3153                           =A/3 15,3
227900200529     C   94W@2150        MULT(H)   @ORATE        W@4150                           =A/4 15,0
228000200529     C   95W@2151        MULT(H)   @ORATE        W@4150                           =A/4 15,1
228100200529     C   96W@2152        MULT(H)   @ORATE        W@4150                           =A/4 15,2
228200200529     C   97W@2153        MULT(H)   @ORATE        W@4150                           =A/4 15,3
228300200529     C                   END                                                    FI
228400200529     C     *IN91         IFEQ      '1'                                          IF A/1 = 15,1
228500200529     C   94W@1151        DIV(H)    @ORATE        W@3150                           =A/3 15,0
228600200529     C   95W@1151        DIV(H)    @ORATE        W@3151                           =A/3 15,1
228700200529     C   96W@1151        DIV(H)    @ORATE        W@3152                           =A/3 15,2
228800200529     C   97W@1151        DIV(H)    @ORATE        W@3153                           =A/3 15,3
228900200529     C   94W@2150        MULT(H)   @ORATE        W@4151                           =A/4 15,0
229000200529     C   95W@2151        MULT(H)   @ORATE        W@4151                           =A/4 15,1
229100200529     C   96W@2152        MULT(H)   @ORATE        W@4151                           =A/4 15,2
229200200529     C   97W@2153        MULT(H)   @ORATE        W@4151                           =A/4 15,3
229300200529     C                   END                                                    FI
229400200529     C     *IN92         IFEQ      '1'                                          IF A/1 = 15,2
229500200529     C   94W@1152        DIV(H)    @ORATE        W@3150                           =A/3 15,0
229600200529     C   95W@1152        DIV(H)    @ORATE        W@3151                           =A/3 15,1
229700200529     C   96W@1152        DIV(H)    @ORATE        W@3152                           =A/3 15,2
229800200529     C   97W@1152        DIV(H)    @ORATE        W@3153                           =A/3 15,3
229900200529     C   94W@2150        MULT(H)   @ORATE        W@4152                           =A/4 15,0
230000200529     C   95W@2151        MULT(H)   @ORATE        W@4152                           =A/4 15,1
230100200529     C   96W@2152        MULT(H)   @ORATE        W@4152                           =A/4 15,2
230200200529     C   97W@2153        MULT(H)   @ORATE        W@4152                           =A/4 15,3
230300200529     C                   END                                                    FI
230400200529     C     *IN93         IFEQ      '1'                                          IF A/1 = 15,3
230500200529     C   94W@1153        DIV(H)    @ORATE        W@3150                           =A/3 15,0
230600200529     C   95W@1153        DIV(H)    @ORATE        W@3151                           =A/3 15,1
230700200529     C   96W@1153        DIV(H)    @ORATE        W@3152                           =A/3 15,2
230800200529     C   97W@1153        DIV(H)    @ORATE        W@3153                           =A/3 15,3
230900200529     C   94W@2150        MULT(H)   @ORATE        W@4153                           =A/4 15,0
231000200529     C   95W@2151        MULT(H)   @ORATE        W@4153                           =A/4 15,1
231100200529     C   96W@2152        MULT(H)   @ORATE        W@4153                           =A/4 15,2
231200200529     C   97W@2153        MULT(H)   @ORATE        W@4153                           =A/4 15,3
231300200529     C                   END                                                    FI
231400200529     C*
231500200529     C** Determine difference between calculated and actual
231600200529     C*
231700200529     C     W@2150        SUB       W@3150        W@DFBM                         actual - calcd
231800200529     C     W@1150        SUB       W@4150        W@DFSM                         actual - calcd
231900200529     C*
232000200529     C** Check if difference is within 2 units of calculated amount
232100200529     C** (this tolerance will be allowed only if JSM installed, and at
232200200529     C** least one of the currencies allows round down of amount)
232300200529     C*
232400200529     C     W@DFBM        IFGE      -2
232500200529     C     W@DFBM        ANDLE     2
232600200529     C     W@DFSM        ORGE      -2
232700200529     C     W@DFSM        ANDLE     2
232800200529     C                   MOVEL     'Y'           @@PASM
232900200529     C                   END
233000200529     C*
233100200529     C* Store calculated amounts for each method ( 1 2 and 3)
233200200529     C*
233300200529     C     @@K           IFEQ      1
233400200529     C                   Z-ADD     W@3150        BM1501           15 0
233500200529     C                   Z-ADD     W@4150        SM1501           15 0
233600200529     C                   Z-ADD     0             BM1502
233700200529     C                   Z-ADD     0             SM1502
233800200529     C                   Z-ADD     0             BM1503
233900200529     C                   Z-ADD     0             SM1503
234000200529     C                   END
234100200529     C     @@K           IFEQ      2
234200200529     C                   Z-ADD     W@3150        BM1502           15 0
234300200529     C                   Z-ADD     W@4150        SM1502           15 0
234400200529     C                   END
234500200529     C     @@K           IFEQ      3
234600200529     C                   Z-ADD     W@3150        BM1503           15 0
234700200529     C                   Z-ADD     W@4150        SM1503           15 0
234800200529     C                   END
234900200529     C*
235000200529     C** Do further checking following code if :
235100200529     C** a) @ROUND indicator not on and both differences are not zero.
235200200529     C** ..if either difference amount calculated is zero, then the
235300200529     C** ..amount has passed one of the tests and no more checking
235400200529     C** ..needs to be done.
235500200529     C     W@DFBM        IFNE      0
235600200529     C     W@DFSM        ANDNE     0
235700200529     C     @ROUND        ANDNE     'Y'
235800200529     C     @@PASM        ANDNE     'Y'                                                      AR703547
235900200529     C*
236000200529     C** b) @ROUND indicator on, @@K=1 and both differences > 2 units
236100200529     C** ..allow 2 units tolerance if round down of calculated amount
236200200529     C** ..is allowed, for K = 1.
236300200529     C*
236400200529     C     @ROUND        OREQ      'Y'
236500200529     C     @@K           ANDEQ     1
236600200529     C     @@PASM        ANDNE     'Y'
236700200529     C*
236800200529     C** C) @ROUND indicator on, @KK not = 1 and both differences not zero
236900200529     C** ..The 2 unit tolerance test does not apply for @@K equal to
237000200529     C** ..2 or 3 since they had use a tolerance of +/- .00000005
237100200529     C** ..in the spot rate used, which would give combined
237200200529     C** ..tolerance greater than 1 unit.
237300200529     C*
237400200529     C     @ROUND        OREQ      'Y'
237500200529     C     @@K           ANDNE     1
237600200529     C     W@DFBM        ANDNE     0
237700200529     C     W@DFSM        ANDNE     0
237800200529      *
237900200529      ** Calculate 'other' currency amount (amount x or / rate)
238000200529      *
238100200529     C     *IN90         IFEQ      '1'                                          IF A/1 = 15,0
238200200529     C   94W@1150        MULT(H)   @ORATE        W@3150                           =A/3 15,0
238300200529     C   95W@1150        MULT(H)   @ORATE        W@3151                           =A/3 15,1
238400200529     C   96W@1150        MULT(H)   @ORATE        W@3152                           =A/3 15,2
238500200529     C   97W@1150        MULT(H)   @ORATE        W@3153                           =A/3 15,3
238600200529     C   94W@2150        DIV(H)    @ORATE        W@4150                           =A/4 15,0
238700200529     C   95W@2151        DIV(H)    @ORATE        W@4150                           =A/4 15,1
238800200529     C   96W@2152        DIV(H)    @ORATE        W@4150                           =A/4 15,2
238900200529     C   97W@2153        DIV(H)    @ORATE        W@4150                           =A/4 15,3
239000200529     C                   END                                                    FI
239100200529     C     *IN91         IFEQ      '1'                                          IF A/1 = 15,1
239200200529     C   94W@1151        MULT(H)   @ORATE        W@3150                           =A/3 15,0
239300200529     C   95W@1151        MULT(H)   @ORATE        W@3151                           =A/3 15,1
239400200529     C   96W@1151        MULT(H)   @ORATE        W@3152                           =A/3 15,2
239500200529     C   97W@1151        MULT(H)   @ORATE        W@3153                           =A/3 15,3
239600200529     C   94W@2150        DIV(H)    @ORATE        W@4151                           =A/4 15,0
239700200529     C   95W@2151        DIV(H)    @ORATE        W@4151                           =A/4 15,1
239800200529     C   96W@2152        DIV(H)    @ORATE        W@4151                           =A/4 15,2
239900200529     C   97W@2153        DIV(H)    @ORATE        W@4151                           =A/4 15,3
240000200529     C                   END                                                    FI
240100200529     C     *IN92         IFEQ      '1'                                          IF A/1 = 15,2
240200200529     C   94W@1152        MULT(H)   @ORATE        W@3150                           =A/3 15,0
240300200529     C   95W@1152        MULT(H)   @ORATE        W@3151                           =A/3 15,1
240400200529     C   96W@1152        MULT(H)   @ORATE        W@3152                           =A/3 15,2
240500200529     C   97W@1152        MULT(H)   @ORATE        W@3153                           =A/3 15,3
240600200529     C   94W@2150        DIV(H)    @ORATE        W@4152                           =A/4 15,0
240700200529     C   95W@2151        DIV(H)    @ORATE        W@4152                           =A/4 15,1
240800200529     C   96W@2152        DIV(H)    @ORATE        W@4152                           =A/4 15,2
240900200529     C   97W@2153        DIV(H)    @ORATE        W@4152                           =A/4 15,3
241000200529     C                   END                                                    FI
241100200529     C     *IN93         IFEQ      '1'                                          IF A/1 = 15,3
241200200529     C   94W@1153        MULT(H)   @ORATE        W@3150                           =A/3 15,0
241300200529     C   95W@1153        MULT(H)   @ORATE        W@3151                           =A/3 15,1
241400200529     C   96W@1153        MULT(H)   @ORATE        W@3152                           =A/3 15,2
241500200529     C   97W@1153        MULT(H)   @ORATE        W@3153                           =A/3 15,3
241600200529     C   94W@2150        DIV(H)    @ORATE        W@4153                           =A/4 15,0
241700200529     C   95W@2151        DIV(H)    @ORATE        W@4153                           =A/4 15,1
241800200529     C   96W@2152        DIV(H)    @ORATE        W@4153                           =A/4 15,2
241900200529     C   97W@2153        DIV(H)    @ORATE        W@4153                           =A/4 15,3
242000200529     C                   END                                                    FI
242100200529     C*
242200200529     C** Determine difference between calculated and actual
242300200529     C*
242400200529     C     W@2150        SUB       W@3150        W@DFBD                         actual - calcd
242500200529     C     W@1150        SUB       W@4150        W@DFSD                         actual - calcd
242600200529     C*
242700200529     C** Check if difference is within 2 units of calculated amount
242800200529     C** (this tolerance will be allowed only if JSM installed, and at
242900200529     C** least one of the currencies allows round down of amount)
243000200529     C** If it is within 2 units of tolerance, set on a 'PASS' flag.
243100200529     C*
243200200529     C     W@DFBD        IFGE      -2
243300200529     C     W@DFBD        ANDLE     2
243400200529     C     W@DFSD        ORGE      -2
243500200529     C     W@DFSD        ANDLE     2
243600200529     C                   MOVEL     'Y'           @@PASD
243700200529     C                   END
243800200529     C*
243900200529     C* Store calculated amounts for each method ( 1 2 and 3)
244000200529     C*
244100200529     C     @@K           IFEQ      1
244200200529     C                   Z-ADD     W@3150        BD1501           15 0
244300200529     C                   Z-ADD     W@4150        SD1501           15 0
244400200529     C                   Z-ADD     0             BD1502
244500200529     C                   Z-ADD     0             SD1502
244600200529     C                   Z-ADD     0             BD1503
244700200529     C                   Z-ADD     0             SD1503
244800200529     C                   END
244900200529     C     @@K           IFEQ      2
245000200529     C                   Z-ADD     W@3150        BD1502           15 0
245100200529     C                   Z-ADD     W@4150        SD1502           15 0
245200200529     C                   END
245300200529     C     @@K           IFEQ      3
245400200529     C                   Z-ADD     W@3150        BD1503           15 0
245500200529     C                   Z-ADD     W@4150        SD1503           15 0
245600200529     C                   END
245700200529     C                   END
245800200529     C                   END
245900200529      *----------------------------------------------------------------
246000200529      /EJECT
246100200529      *----------------------------------------------------------------
246200200529     C*
246300200529     C* DETERMINE THE MULTIPLY/DIVIDE INDICATOR
246400200529     C* BASED ON THE CALCULATIONS DONE ABOVE
246500200529     C*
246600200529     C     @ORATE        IFNE      *ZERO
246700200529     C*
246800200529     C     W@DFBD        IFEQ      0
246900200529     C     @@K           ANDEQ     1
247000200529     C     @ROUND        ANDNE     'Y'
247100200529     C     W@DFSD        OREQ      0
247200200529     C     @@K           ANDEQ     1
247300200529     C     @ROUND        ANDNE     'Y'
247400200529     C     @@PASD        OREQ      'Y'
247500200529     C     @ROUND        ANDEQ     'Y'
247600200529     C     @@K           ANDEQ     1
247700200529     C     @@PASD        OREQ      'Y'                                                      AR703547
247800200529     C     @ROUND        ANDNE     'Y'                                                      AR703547
247900200529     C     @@K           ANDEQ     1                                                        AR703547
248000200529     C     @@BSIN        IFEQ      'B'
248100200529     C                   MOVE      'M'           W@MDIN
248200200529     C                   ELSE
248300200529     C                   MOVE      'D'           W@MDIN
248400200529     C                   END
248500200529     C                   ELSE
248600200529     C     @@K           IFEQ      3
248700200529     C     @@BSIN        IFEQ      'B'
248800200529     C     W@1150        IFGE      BD1502
248900200529     C     W@1150        ANDLE     BD1503
249000200529     C     BD1501        ANDGE     BD1502
249100200529     C     BD1501        ANDLE     BD1503
249200200529     C     W@2150        ORLE      SD1502
249300200529     C     W@2150        ANDGE     SD1503
249400200529     C     SD1501        ANDLE     SD1502
249500200529     C     SD1501        ANDGE     SD1503
249600200529     C                   MOVE      'M'           W@MDIN
249700200529     C                   END
249800200529     C                   ELSE
249900200529     C     W@2150        IFLE      BD1502
250000200529     C     W@2150        ANDGE     BD1503
250100200529     C     BD1501        ANDLE     BD1502
250200200529     C     BD1501        ANDGE     BD1503
250300200529     C     W@1150        ORGE      SD1502
250400200529     C     W@1150        ANDLE     SD1503
250500200529     C     SD1501        ANDGE     SD1502
250600200529     C     SD1501        ANDLE     SD1503
250700200529     C                   MOVE      'D'           W@MDIN
250800200529     C                   END
250900200529     C                   END
251000200529     C                   END
251100200529     C                   END
251200200529     C     W@DFBM        IFEQ      0
251300200529     C     @@K           ANDEQ     1
251400200529     C     @ROUND        ANDNE     'Y'
251500200529     C     W@DFSM        OREQ      0
251600200529     C     @@K           ANDEQ     1
251700200529     C     @ROUND        ANDNE     'Y'
251800200529     C     @@PASM        OREQ      'Y'
251900200529     C     @ROUND        ANDEQ     'Y'
252000200529     C     @@K           ANDEQ     1
252100200529     C     @@PASM        OREQ      'Y'                                                      AR703547
252200200529     C     @ROUND        ANDNE     'Y'                                                      AR703547
252300200529     C     @@K           ANDEQ     1                                                        AR703547
252400200529     C     @@BSIN        IFEQ      'B'
252500200529     C                   MOVE      'D'           W@MDIN
252600200529     C                   ELSE
252700200529     C                   MOVE      'M'           W@MDIN
252800200529     C                   END
252900200529     C                   ELSE
253000200529     C     @@K           IFEQ      3
253100200529     C     @@BSIN        IFEQ      'B'
253200200529     C     W@1150        IFLE      BM1502
253300200529     C     W@1150        ANDGE     BM1503
253400200529     C     BM1501        ANDLE     BM1502
253500200529     C     BM1501        ANDGE     BM1503
253600200529     C     W@2150        ORGE      SM1502
253700200529     C     W@2150        ANDLE     SM1503
253800200529     C     SM1501        ANDGE     SM1502
253900200529     C     SM1501        ANDLE     SM1503
254000200529     C                   MOVE      'D'           W@MDIN
254100200529     C                   END
254200200529     C                   ELSE
254300200529     C     W@2150        IFGE      BM1502
254400200529     C     W@2150        ANDLE     BM1503
254500200529     C     BM1501        ANDGE     BM1502
254600200529     C     BM1501        ANDLE     BM1503
254700200529     C     W@1150        ORLE      SM1502
254800200529     C     W@1150        ANDGE     SM1503
254900200529     C     SM1501        ANDLE     SM1502
255000200529     C     SM1501        ANDGE     SM1503
255100200529     C                   MOVE      'M'           W@MDIN
255200200529     C                   END
255300200529     C                   END
255400200529     C                   END
255500200529     C                   END
255600200529     C                   END
255700200529     C*
255800200529     C     #ZICA9        ENDSR
255900200529      *****************************************************************
256000200529      /EJECT
256100200529      *****************************************************************
256200200529      ** #ZICB - VALIDATE EXCH.RATE V. CROSS RATES FOR NON BASE CC DEAL
256300200529      *****************************************************************
256400200529     C     #ZICB         BEGSR
256500200529     C*
256600200529     C                   MOVE      *BLANKS       @@MDIN            1
256700200529     C*
256800200529     C* If either currency is the base currency for accounting
256900200529     C*
257000200529     C     DDBCCY        IFEQ      BJCYCD
257100200529     C     DDSCCY        OREQ      BJCYCD
257200200529     C*
257300200529     C* Set spot rate to that of currency which is the base currency
257400200529     C*
257500200529     C     DDBCCY        IFEQ      BJCYCD
257600200529     C                   Z-ADD     @SPOT2        @@SPTR
257700200529     C                   MOVE      @@MDF2        @@MDIN
257800200529     C                   ELSE
257900200529     C                   Z-ADD     @SPOT1        @@SPTR
258000200529     C                   MOVE      @@MDF1        @@MDIN
258100200529     C                   END
258200200529     C*
258300200529     C** Obtain Tolerance Amount of Spot Rate
258400200529     C*
258500200529     C     @@SPTR        MULT      TOLRAN        @@SR10           13 8
258600200529     C*
258700200529     C* Obtain +/-(Tolerance Amount) of Spot rate
258800200529     C*
258900200529     C     @@SPTR        ADD       @@SR10        @@SPHI           13 8          Spot + 10%
259000200529     C     @@SPTR        SUB       @@SR10        @@SPLO           13 8          Spot - 10%
259100200529     C*
259200200529     C** Calculate the inverse of the +/- tolerance of high/low spot rates
259300200529     C*
259400200529     C     1             DIV(H)    @@SPHI        @@ISHI           13 8
259500200529     C     1             DIV(H)    @@SPLO        @@ISLO           13 8
259600200529     C*
259700200529     C                   MOVE      'N'           W@RTOK            1
259800200529     C*
259900200529     C* OK if exch rate is GE low spt rte and exch rate is LE high spt rte
260000200529     C*
260100200529     C     @@INRT        IFGE      @@SPLO
260200200529     C     @@INRT        ANDLE     @@SPHI
260300200529     C                   MOVE      'Y'           W@RTOK
260400200529      *                                                                                       258321
260500200529      ** If rate is close to par (e.g. 0.99) then multiply/divide ind                         258321
260600200529      ** might be wrong because @@INRT is close to both spot and the                          258321
260700200529      ** inverse of spot. Check the amounts to confirm.                                       258321
260800200529     C     W@RTOK        IFEQ      'Y'                                                        258321
260900200529      *                                                                                       258321
261000200529     C     @CDP1         ADD       1             @@IX              1 0                        258321
261100200529     C     F3DAM1        DIV       @@AY(@@IX)    @@AMT1           18 3                        258321
261200200529     C     @CDP2         ADD       1             @@IX                                         258321
261300200529     C     F3DAM2        DIV       @@AY(@@IX)    @@AMT2           18 3                        258321
261400200529     C                   MULT      -1            @@AMT2                                       258321
261500200529      *                                                                                       258321
261600200529     C     DDBCCY        IFEQ      BJCYCD                                                     258321
261700200529     C     @@AMT2        ANDLT     @@AMT1                                                     258321
261800200529     C     @@INRT        ANDGT     1                                                          258321
261900200529      *                                                                                       258321
262000200529     C     DDBCCY        OREQ      BJCYCD                                                     258321
262100200529     C     @@AMT2        ANDGT     @@AMT1                                                     258321
262200200529     C     @@INRT        ANDLT     1                                                          258321
262300200529      *                                                                                       258321
262400200529     C     DDSCCY        OREQ      BJCYCD                                                     258321
262500200529     C     @@AMT1        ANDLT     @@AMT2                                                     258321
262600200529     C     @@INRT        ANDGT     1                                                          258321
262700200529      *                                                                                       258321
262800200529     C     DDSCCY        OREQ      BJCYCD                                                     258321
262900200529     C     @@AMT1        ANDGT     @@AMT2                                                     258321
263000200529     C     @@INRT        ANDLT     1                                                          258321
263100200529     C                   MOVE      'M'           @@MDIN                                       258321
263200200529     C                   ELSE                                                                 258321
263300200529     C                   MOVE      'D'           @@MDIN                                       258321
263400200529     C                   ENDIF                                                                258321
263500200529     C                   ENDIF                                                                258321
263600200529     C                   ELSE
263700200529     C*
263800200529     C* OK if exchrate is GE inv high spt rte and spt rate LE inv low spt rt
263900200529     C*
264000200529     C     @@INRT        IFGE      @@ISHI
264100200529     C     @@INRT        ANDLE     @@ISLO
264200200529     C                   MOVE      'Y'           W@RTOK
264300200529     C     @@MDIN        IFEQ      'M'                                          invert the rate
264400200529     C                   MOVE      'D'           @@MDIN                         by flipping
264500200529     C                   ELSE                                                   the M/D ind
264600200529     C                   MOVE      'M'           @@MDIN
264700200529     C                   END
264800200529     C                   END
264900200529     C                   END
265000200529     C*
265100200529     C* If rate is not OK, format low & high spot rates for message
265200200529     C*
265300200529     C     W@RTOK        IFEQ      'N'
265400200529     C                   Z-ADD     *ZERO         W@AMNT                           ¦ Initialise
265500200529     C                   MOVE      *BLANK        M@MGDA                           ¦ fields
265600200529     C                   Z-ADD     8             W@DECP                           ¦
265700200529     C                   Z-ADD     @@SPLO        W@AMTR                           I:Low Rate
265800200529     C                   EXSR      #ZICC                                          <Convert>
265900200529     C                   MOVEA     @Y(P1)        M@0115                           O:To msg.data
266000200529     C                   Z-ADD     @@SPHI        W@AMTR                           I:High Rate
266100200529     C                   EXSR      #ZICC                                          <Convert>
266200200529     C                   MOVEA     @Y(P1)        M@1630                           O:To msg.data
266300200529     C                   MOVE      M@MGDA        M@MGD3                           Stack Msg.Dta
266400200529     C                   END
266500200529     C*
266600200529     C                   END                                                     DDBCCY = BYCYCD
266700200529     C*
266800200529     C*----------------------------------------------------------------
266900200529     C*
267000200529      ** Set up variables used in 'difference' calculations below
267100200529      ** (difference is between actual 'other' currency amount
267200200529      **  and calculated 'other' currency amount (amount x or / rate))
267300200529     C*
267400200529     C     @CDP1         COMP      0                                      90     Dec.place=0
267500200529     C     @CDP1         COMP      1                                      91     Dec.place=1
267600200529     C     @CDP1         COMP      2                                      92     Dec.place=2
267700200529     C     @CDP1         COMP      3                                      93     Dec.place=3
267800200529     C     @CDP2         COMP      0                                      94     Dec.place=0
267900200529     C     @CDP2         COMP      1                                      95     Dec.place=1
268000200529     C     @CDP2         COMP      2                                      96     Dec.place=2
268100200529     C     @CDP2         COMP      3                                      97     Dec.place=3
268200200529     C*
268300200529     C     F3DAM1        IFLT      0                                                           DT001
268400200529     C                   Z-SUB     F3DAM1        W@1150                         15,0 amount 1  DT001
268500200529     C                   ELSE                                                                  DT001
268600200529     C                   Z-ADD     F3DAM1        W@1150                         15,0 amount 1  DT001
268700200529     C                   END                                                                   DT001
268800200529     C     F3DAM2        IFLT      0                                                           DT001
268900200529     C                   Z-SUB     F3DAM2        W@2150                         15,0 amount 2  DT001
269000200529     C                   ELSE                                                                  DT001
269100200529     C                   Z-ADD     F3DAM2        W@2150                         15,0 amount 2  DT001
269200200529     C                   END                                                                   DT001
269300200529     C*
269400200529     C* Determine number of normally quoted decimal places
269500200529     C*
269600200529     C                   Z-ADD     @@INRT        @@IRAT           13 8          EXCH.RATE
269700200529     C                   EXSR      ZA0790
269800200529     C*
269900200529     C* If the normally quoted decimal places is not zero
270000200529     C* Add (adjusted) forward points to margin
270100200529     C*
270200200529     C     @@NDP         IFNE      0
270300200529     C     @@FPNT        DIV(H)    @AD(@@NDP)    @RRATE                         Adjust Fwd/Pts
270400200529     C     S01453        IFEQ      'Y'                                          S01453 installd
270500200529     C                   Z-ADD     @RRATE        @XRATE                         Save
270600200529     C     @SMGPT        DIV       @AD(@@NDP)    @@MADJ                         Adjust margin
270700200529     C                   ADD       @@MADJ        @RRATE                         Margin+Fwd/Pts
270800200529     C                   END
270900200529     C                   END
271000200529     C*
271100200529     C* If the normally quoted decimal places is zero
271200200529     C* Add forward points to margin
271300200529     C*
271400200529     C     @@NDP         IFEQ      0
271500200529     C                   Z-ADD     @@FPNT        @RRATE                         Fwd/Pts
271600200529     C     S01453        IFEQ      'Y'
271700200529     C                   Z-ADD     @RRATE        @XRATE                         Save
271800200529     C                   ADD       @SMGPT        @RRATE                         Margin+Fwd/Pts
271900200529     C                   END
272000200529     C                   END
272100200529      *                                                                                       238023
272200200529     C                   Z-ADD     @RRATE        @RATE1           13 8                        238023
272300200529     C                   Z-ADD     @RRATE        @RATE2           13 8                        238023
272400200529     C                   Z-ADD     @RRATE        @RATEV           13 8                        240038
272500200529     C     @RATEV        IFLT      0                                                          240038
272600200529     C                   MULT      -1            @RATEV                                       240038
272700200529     C                   ENDIF                                                                240038
272800200529     C     W@INRT        ADD       @RATE1        @RATE3           13 8                        238023
272900200529     C     W@INRT        SUB       @RATE2        @RATE4           13 8                        238023
273000200529      *                                                                                       238023
273100200529      ** If the margin buy/sell indicator is "B".                                             238023
273200200529      *                                                                                       238023
273300200529     C     F3MGBS        IFEQ      'B'                                                        238023
273400200529      *                                                                                       238023
273500200529      ** Divide buy amount in different decimal places against +rate and store value          238023
273600200529      ** to a variable with zero decimal place.                                               238023
273700200529      *                                                                                       238023
273800200529     C     W@1150        DIV(H)    @RATE3        W@8150           15 0                        238023
273900200529     C     W@1151        DIV(H)    @RATE3        W@8151           15 0                        238023
274000200529     C     W@1152        DIV(H)    @RATE3        W@8152           15 0                        238023
274100200529     C     W@1153        DIV(H)    @RATE3        W@8153           15 0                        238023
274200200529      *                                                                                       240038
274300200529     C                   SELECT                                                               240038
274400200529     C     @CDP2         WHENEQ    1                                                          240038
274500200529     C                   MULT      10            W@8150                                       240038
274600200529     C                   MULT      10            W@8151                                       240038
274700200529     C                   MULT      10            W@8152                                       240038
274800200529     C                   MULT      10            W@8153                                       240038
274900200529     C     @CDP2         WHENEQ    2                                                          240038
275000200529     C                   MULT      100           W@8150                                       240038
275100200529     C                   MULT      100           W@8151                                       240038
275200200529     C                   MULT      100           W@8152                                       240038
275300200529     C                   MULT      100           W@8153                                       240038
275400200529     C     @CDP2         WHENEQ    3                                                          240038
275500200529     C                   MULT      1000          W@8150                                       240038
275600200529     C                   MULT      1000          W@8151                                       240038
275700200529     C                   MULT      1000          W@8152                                       240038
275800200529     C                   MULT      1000          W@8153                                       240038
275900200529     C                   ENDSL                                                                240038
276000200529      *                                                                                       238023
276100200529      ** Divide buy amount in different decimal places against +rate and store value          238023
276200200529      ** to a variable with one  decimal place.                                               238023
276300200529      *                                                                                       238023
276400200529     C     W@1150        DIV(H)    @RATE3        W@8154           15 1                        238023
276500200529     C     W@1151        DIV(H)    @RATE3        W@8155           15 1                        238023
276600200529     C     W@1152        DIV(H)    @RATE3        W@8156           15 1                        238023
276700200529     C     W@1153        DIV(H)    @RATE3        W@8157           15 1                        238023
276800200529      *                                                                                       240038
276900200529     C                   SELECT                                                               240038
277000200529     C     @CDP2         WHENEQ    1                                                          240038
277100200529     C                   MULT      10            W@8154                                       240038
277200200529     C                   MULT      10            W@8155                                       240038
277300200529     C                   MULT      10            W@8156                                       240038
277400200529     C                   MULT      10            W@8157                                       240038
277500200529     C     @CDP2         WHENEQ    2                                                          240038
277600200529     C                   MULT      100           W@8154                                       240038
277700200529     C                   MULT      100           W@8155                                       240038
277800200529     C                   MULT      100           W@8156                                       240038
277900200529     C                   MULT      100           W@8157                                       240038
278000200529     C     @CDP2         WHENEQ    3                                                          240038
278100200529     C                   MULT      1000          W@8154                                       240038
278200200529     C                   MULT      1000          W@8155                                       240038
278300200529     C                   MULT      1000          W@8156                                       240038
278400200529     C                   MULT      1000          W@8157                                       240038
278500200529     C                   ENDSL                                                                240038
278600200529      *                                                                                       238023
278700200529      ** Divide buy amount in different decimal places against +rate and store value          238023
278800200529      ** to a variable with two  decimal place.                                               238023
278900200529      *                                                                                       238023
279000200529     C     W@1150        DIV(H)    @RATE3        W@8158           15 2                        238023
279100200529     C     W@1151        DIV(H)    @RATE3        W@8159           15 2                        238023
279200200529     C     W@1152        DIV(H)    @RATE3        W@8160           15 2                        238023
279300200529     C     W@1153        DIV(H)    @RATE3        W@8161           15 2                        238023
279400200529      *                                                                                       240038
279500200529     C                   SELECT                                                               240038
279600200529     C     @CDP2         WHENEQ    1                                                          240038
279700200529     C                   MULT      10            W@8158                                       240038
279800200529     C                   MULT      10            W@8159                                       240038
279900200529     C                   MULT      10            W@8160                                       240038
280000200529     C                   MULT      10            W@8161                                       240038
280100200529     C     @CDP2         WHENEQ    2                                                          240038
280200200529     C                   MULT      100           W@8158                                       240038
280300200529     C                   MULT      100           W@8159                                       240038
280400200529     C                   MULT      100           W@8160                                       240038
280500200529     C                   MULT      100           W@8161                                       240038
280600200529     C     @CDP2         WHENEQ    3                                                          240038
280700200529     C                   MULT      1000          W@8158                                       240038
280800200529     C                   MULT      1000          W@8159                                       240038
280900200529     C                   MULT      1000          W@8160                                       240038
281000200529     C                   MULT      1000          W@8161                                       240038
281100200529     C                   ENDSL                                                                240038
281200200529      *                                                                                       238023
281300200529      ** Divide buy amount in different decimal places against +rate and store value          238023
281400200529      ** to a variable with three decimal place.                                              238023
281500200529      *                                                                                       238023
281600200529     C     W@1150        DIV(H)    @RATE3        W@8162           15 3                        238023
281700200529     C     W@1151        DIV(H)    @RATE3        W@8163           15 3                        238023
281800200529     C     W@1152        DIV(H)    @RATE3        W@8164           15 3                        238023
281900200529     C     W@1153        DIV(H)    @RATE3        W@8165           15 3                        238023
282000200529      *                                                                                       240038
282100200529     C                   SELECT                                                               240038
282200200529     C     @CDP2         WHENEQ    1                                                          240038
282300200529     C                   MULT      10            W@8162                                       240038
282400200529     C                   MULT      10            W@8163                                       240038
282500200529     C                   MULT      10            W@8164                                       240038
282600200529     C                   MULT      10            W@8165                                       240038
282700200529     C     @CDP2         WHENEQ    2                                                          240038
282800200529     C                   MULT      100           W@8162                                       240038
282900200529     C                   MULT      100           W@8163                                       240038
283000200529     C                   MULT      100           W@8164                                       240038
283100200529     C                   MULT      100           W@8165                                       240038
283200200529     C     @CDP2         WHENEQ    3                                                          240038
283300200529     C                   MULT      1000          W@8162                                       240038
283400200529     C                   MULT      1000          W@8163                                       240038
283500200529     C                   MULT      1000          W@8164                                       240038
283600200529     C                   MULT      1000          W@8165                                       240038
283700200529     C                   ENDSL                                                                240038
283800200529      *                                                                                       238023
283900200529      ** Check if one of the above calculations satisfied the suppose sell amount and if it   238023
284000200529      ** is then assign a Divide rate to W@MDIN.                                              238023
284100200529      *                                                                                       238023
284200200529     C     W@8150        IFEQ      W@2150                                                     238023
284300200529     C     W@8151        OREQ      W@2150                                                     238023
284400200529     C     W@8152        OREQ      W@2150                                                     238023
284500200529     C     W@8153        OREQ      W@2150                                                     238023
284600200529     C     W@8154        OREQ      W@2150                                                     238023
284700200529     C     W@8155        OREQ      W@2150                                                     238023
284800200529     C     W@8156        OREQ      W@2150                                                     238023
284900200529     C     W@8157        OREQ      W@2150                                                     238023
285000200529     C     W@8158        OREQ      W@2150                                                     238023
285100200529     C     W@8159        OREQ      W@2150                                                     238023
285200200529     C     W@8160        OREQ      W@2150                                                     238023
285300200529     C     W@8161        OREQ      W@2150                                                     238023
285400200529     C     W@8162        OREQ      W@2150                                                     238023
285500200529     C     W@8163        OREQ      W@2150                                                     238023
285600200529     C     W@8164        OREQ      W@2150                                                     238023
285700200529     C     W@8165        OREQ      W@2150                                                     238023
285800200529     C                   MOVE      'D'           W@MDIN                                       238023
285900200529     C**********         Z-ADD     @RATE3        @RRATE                                238023 240038
286000200529     C     W@INRT        ADD       @RATEV        @RRATE                                       240038
286100200529     C                   ELSE                                                                 238023
286200200529      *                                                                                       238023
286300200529      ** Multiply the buy amount with different decimal places against -rate and store        238023
286400200529      ** value to variable with zero decimal place.                                           238023
286500200529      *                                                                                       238023
286600200529     C     W@1150        MULT(H)   @RATE4        W@9150           15 0                        238023
286700200529     C     W@1151        MULT(H)   @RATE4        W@9151           15 0                        238023
286800200529     C     W@1152        MULT(H)   @RATE4        W@9152           15 0                        238023
286900200529     C     W@1153        MULT(H)   @RATE4        W@9153           15 0                        238023
287000200529      *                                                                                       238023
287100200529      ** Multiply the buy amount with different decimal places against -rate and store        238023
287200200529      ** value to variable with one decimal place.                                            238023
287300200529      *                                                                                       238023
287400200529     C     W@1150        MULT(H)   @RATE4        W@9154           15 1                        238023
287500200529     C     W@1151        MULT(H)   @RATE4        W@9155           15 1                        238023
287600200529     C     W@1152        MULT(H)   @RATE4        W@9156           15 1                        238023
287700200529     C     W@1153        MULT(H)   @RATE4        W@9157           15 1                        238023
287800200529      *                                                                                       238023
287900200529      ** Multiply the buy amount with different decimal places against -rate and store        238023
288000200529      ** value to variable with two decimal place.                                            238023
288100200529      *                                                                                       238023
288200200529     C     W@1150        MULT(H)   @RATE4        W@9158           15 2                        238023
288300200529     C     W@1151        MULT(H)   @RATE4        W@9159           15 2                        238023
288400200529     C     W@1152        MULT(H)   @RATE4        W@9160           15 2                        238023
288500200529     C     W@1153        MULT(H)   @RATE4        W@9161           15 2                        238023
288600200529      *                                                                                       238023
288700200529      ** Multiply the buy amount with different decimal places against -rate and store        238023
288800200529      ** value to variable with three decimal place.                                          238023
288900200529      *                                                                                       238023
289000200529     C     W@1150        MULT(H)   @RATE4        W@9162           15 3                        238023
289100200529     C     W@1151        MULT(H)   @RATE4        W@9163           15 3                        238023
289200200529     C     W@1152        MULT(H)   @RATE4        W@9164           15 3                        238023
289300200529     C     W@1153        MULT(H)   @RATE4        W@9165           15 3                        238023
289400200529      *                                                                                       238023
289500200529      ** Check if one of the above calculations satisfied the suppose sell amount and if it   238023
289600200529      ** is then assign a Multiply rate to W@MDIN.                                            238023
289700200529      *                                                                                       238023
289800200529     C     W@9150        IFEQ      W@2150                                                     238023
289900200529     C     W@9151        OREQ      W@2150                                                     238023
290000200529     C     W@9152        OREQ      W@2150                                                     238023
290100200529     C     W@9153        OREQ      W@2150                                                     238023
290200200529     C     W@9154        OREQ      W@2150                                                     238023
290300200529     C     W@9155        OREQ      W@2150                                                     238023
290400200529     C     W@9156        OREQ      W@2150                                                     238023
290500200529     C     W@9157        OREQ      W@2150                                                     238023
290600200529     C     W@9158        OREQ      W@2150                                                     238023
290700200529     C     W@9159        OREQ      W@2150                                                     238023
290800200529     C     W@9160        OREQ      W@2150                                                     238023
290900200529     C     W@9161        OREQ      W@2150                                                     238023
291000200529     C     W@9162        OREQ      W@2150                                                     238023
291100200529     C     W@9163        OREQ      W@2150                                                     238023
291200200529     C     W@9164        OREQ      W@2150                                                     238023
291300200529     C     W@9165        OREQ      W@2150                                                     238023
291400200529     C                   MOVE      'M'           W@MDIN                                       238023
291500200529     C**********         Z-ADD     @RATE4        @RRATE                                238023 240038
291600200529     C     W@INRT        SUB       @RATEV        @RRATE                                       240038
291700200529     C                   ENDIF                                                                238023
291800200529     C                   ENDIF                                                                238023
291900200529     C                   ENDIF                                                                238023
292000200529      *                                                                                       238023
292100200529      ** If the margin buy/sell indicator used is "S".                                        238023
292200200529      *                                                                                       238023
292300200529     C     F3MGBS        IFEQ      'S'                                                        238023
292400200529      *                                                                                       238023
292500200529      ** Divide sell amount in different decimal places against +rate and store value         238023
292600200529      ** to a variable with zero decimal place.                                               238023
292700200529      *                                                                                       238023
292800200529     C     W@2150        DIV(H)    @RATE3        W@8250           15 0                        238023
292900200529     C     W@2151        DIV(H)    @RATE3        W@8251           15 0                        238023
293000200529     C     W@2152        DIV(H)    @RATE3        W@8252           15 0                        238023
293100200529     C     W@2153        DIV(H)    @RATE3        W@8253           15 0                        238023
293200200529      *                                                                                       240038
293300200529     C                   SELECT                                                               240038
293400200529     C     @CDP1         WHENEQ    1                                                          240038
293500200529     C                   MULT      10            W@8250                                       240038
293600200529     C                   MULT      10            W@8251                                       240038
293700200529     C                   MULT      10            W@8252                                       240038
293800200529     C                   MULT      10            W@8253                                       240038
293900200529     C     @CDP1         WHENEQ    2                                                          240038
294000200529     C                   MULT      100           W@8250                                       240038
294100200529     C                   MULT      100           W@8251                                       240038
294200200529     C                   MULT      100           W@8252                                       240038
294300200529     C                   MULT      100           W@8253                                       240038
294400200529     C     @CDP1         WHENEQ    3                                                          240038
294500200529     C                   MULT      1000          W@8250                                       240038
294600200529     C                   MULT      1000          W@8251                                       240038
294700200529     C                   MULT      1000          W@8252                                       240038
294800200529     C                   MULT      1000          W@8253                                       240038
294900200529     C                   ENDSL                                                                240038
295000200529      *                                                                                       238023
295100200529      ** Divide sell amount in different decimal places against +rate and store value         238023
295200200529      ** to a variable with one  decimal place.                                               238023
295300200529      *                                                                                       238023
295400200529     C     W@2150        DIV(H)    @RATE3        W@8254           15 1                        238023
295500200529     C     W@2151        DIV(H)    @RATE3        W@8255           15 1                        238023
295600200529     C     W@2152        DIV(H)    @RATE3        W@8256           15 1                        238023
295700200529     C     W@2153        DIV(H)    @RATE3        W@8257           15 1                        238023
295800200529      *                                                                                       240038
295900200529     C                   SELECT                                                               240038
296000200529     C     @CDP1         WHENEQ    1                                                          240038
296100200529     C                   MULT      10            W@8254                                       240038
296200200529     C                   MULT      10            W@8255                                       240038
296300200529     C                   MULT      10            W@8256                                       240038
296400200529     C                   MULT      10            W@8257                                       240038
296500200529     C     @CDP1         WHENEQ    2                                                          240038
296600200529     C                   MULT      100           W@8254                                       240038
296700200529     C                   MULT      100           W@8255                                       240038
296800200529     C                   MULT      100           W@8256                                       240038
296900200529     C                   MULT      100           W@8257                                       240038
297000200529     C     @CDP1         WHENEQ    3                                                          240038
297100200529     C                   MULT      1000          W@8254                                       240038
297200200529     C                   MULT      1000          W@8255                                       240038
297300200529     C                   MULT      1000          W@8256                                       240038
297400200529     C                   MULT      1000          W@8257                                       240038
297500200529     C                   ENDSL                                                                240038
297600200529      *                                                                                       238023
297700200529      ** Divide sell amount in different decimal places against +rate and store value         238023
297800200529      ** to a variable with two  decimal place.                                               238023
297900200529      *                                                                                       238023
298000200529     C     W@2150        DIV(H)    @RATE3        W@8258           15 2                        238023
298100200529     C     W@2151        DIV(H)    @RATE3        W@8259           15 2                        238023
298200200529     C     W@2152        DIV(H)    @RATE3        W@8260           15 2                        238023
298300200529     C     W@2153        DIV(H)    @RATE3        W@8261           15 2                        238023
298400200529      *                                                                                       240038
298500200529     C                   SELECT                                                               240038
298600200529     C     @CDP1         WHENEQ    1                                                          240038
298700200529     C                   MULT      10            W@8258                                       240038
298800200529     C                   MULT      10            W@8259                                       240038
298900200529     C                   MULT      10            W@8260                                       240038
299000200529     C                   MULT      10            W@8261                                       240038
299100200529     C     @CDP1         WHENEQ    2                                                          240038
299200200529     C                   MULT      100           W@8258                                       240038
299300200529     C                   MULT      100           W@8259                                       240038
299400200529     C                   MULT      100           W@8260                                       240038
299500200529     C                   MULT      100           W@8261                                       240038
299600200529     C     @CDP1         WHENEQ    3                                                          240038
299700200529     C                   MULT      1000          W@8258                                       240038
299800200529     C                   MULT      1000          W@8259                                       240038
299900200529     C                   MULT      1000          W@8260                                       240038
300000200529     C                   MULT      1000          W@8261                                       240038
300100200529     C                   ENDSL                                                                240038
300200200529      *                                                                                       238023
300300200529      ** Divide sell amount in different decimal places against +rate and store value         238023
300400200529      ** to a variable with three decimal place.                                              238023
300500200529      *                                                                                       238023
300600200529     C     W@2150        DIV(H)    @RATE3        W@8262           15 3                        238023
300700200529     C     W@2151        DIV(H)    @RATE3        W@8263           15 3                        238023
300800200529     C     W@2152        DIV(H)    @RATE3        W@8264           15 3                        238023
300900200529     C     W@2153        DIV(H)    @RATE3        W@8265           15 3                        238023
301000200529      *                                                                                       240038
301100200529     C                   SELECT                                                               240038
301200200529     C     @CDP1         WHENEQ    1                                                          240038
301300200529     C                   MULT      10            W@8262                                       240038
301400200529     C                   MULT      10            W@8263                                       240038
301500200529     C                   MULT      10            W@8264                                       240038
301600200529     C                   MULT      10            W@8265                                       240038
301700200529     C     @CDP1         WHENEQ    2                                                          240038
301800200529     C                   MULT      100           W@8262                                       240038
301900200529     C                   MULT      100           W@8263                                       240038
302000200529     C                   MULT      100           W@8264                                       240038
302100200529     C                   MULT      100           W@8265                                       240038
302200200529     C     @CDP1         WHENEQ    3                                                          240038
302300200529     C                   MULT      1000          W@8262                                       240038
302400200529     C                   MULT      1000          W@8263                                       240038
302500200529     C                   MULT      1000          W@8264                                       240038
302600200529     C                   MULT      1000          W@8265                                       240038
302700200529     C                   ENDSL                                                                240038
302800200529      *                                                                                       238023
302900200529      ** Check if one of the above calculations satisfied the suppose buy amount and if it    238023
303000200529      ** is then assign a Multiply rate to W@MDIN.                                            238023
303100200529      *                                                                                       238023
303200200529     C     W@8250        IFEQ      W@1150                                                     238023
303300200529     C     W@8251        OREQ      W@1150                                                     238023
303400200529     C     W@8252        OREQ      W@1150                                                     238023
303500200529     C     W@8253        OREQ      W@1150                                                     238023
303600200529     C     W@8254        OREQ      W@1150                                                     238023
303700200529     C     W@8255        OREQ      W@1150                                                     238023
303800200529     C     W@8256        OREQ      W@1150                                                     238023
303900200529     C     W@8257        OREQ      W@1150                                                     238023
304000200529     C     W@8258        OREQ      W@1150                                                     238023
304100200529     C     W@8259        OREQ      W@1150                                                     238023
304200200529     C     W@8260        OREQ      W@1150                                                     238023
304300200529     C     W@8261        OREQ      W@1150                                                     238023
304400200529     C     W@8262        OREQ      W@1150                                                     238023
304500200529     C     W@8263        OREQ      W@1150                                                     238023
304600200529     C     W@8264        OREQ      W@1150                                                     238023
304700200529     C     W@8265        OREQ      W@1150                                                     238023
304800200529     C                   MOVE      'D'           W@MDIN                                       238023
304900200529     C**********         Z-ADD     @RATE3        @RRATE                                238023 240038
305000200529     C     W@INRT        ADD       @RATEV        @RRATE                                       240038
305100200529     C                   ELSE                                                                 238023
305200200529      *                                                                                       238023
305300200529      ** Multiply the sell amount with different decimal places against -rate and store       238023
305400200529      ** value to variable with zero decimal place.                                           238023
305500200529      *                                                                                       238023
305600200529     C     W@2150        MULT(H)   @RATE4        W@9250           15 0                        238023
305700200529     C     W@2151        MULT(H)   @RATE4        W@9251           15 0                        238023
305800200529     C     W@2152        MULT(H)   @RATE4        W@9252           15 0                        238023
305900200529     C     W@2153        MULT(H)   @RATE4        W@9253           15 0                        238023
306000200529      *                                                                                       238023
306100200529      ** Multiply the sell amount with different decimal places against -rate and store       238023
306200200529      ** value to variable with one decimal place.                                            238023
306300200529      *                                                                                       238023
306400200529     C     W@2150        MULT(H)   @RATE4        W@9254           15 1                        238023
306500200529     C     W@2151        MULT(H)   @RATE4        W@9255           15 1                        238023
306600200529     C     W@2152        MULT(H)   @RATE4        W@9256           15 1                        238023
306700200529     C     W@2153        MULT(H)   @RATE4        W@9257           15 1                        238023
306800200529      *                                                                                       238023
306900200529      ** Multiply the sell amount with different decimal places against -rate and store       238023
307000200529      ** value to variable with two decimal place.                                            238023
307100200529      *                                                                                       238023
307200200529     C     W@2150        MULT(H)   @RATE4        W@9258           15 2                        238023
307300200529     C     W@2151        MULT(H)   @RATE4        W@9259           15 2                        238023
307400200529     C     W@2152        MULT(H)   @RATE4        W@9260           15 2                        238023
307500200529     C     W@2153        MULT(H)   @RATE4        W@9261           15 2                        238023
307600200529      *                                                                                       238023
307700200529      ** Multiply the sell amount with different decimal places against -rate and store       238023
307800200529      ** value to variable with thre decimal place.                                           238023
307900200529      *                                                                                       238023
308000200529     C     W@2150        MULT(H)   @RATE4        W@9262           15 3                        238023
308100200529     C     W@2151        MULT(H)   @RATE4        W@9263           15 3                        238023
308200200529     C     W@2152        MULT(H)   @RATE4        W@9264           15 3                        238023
308300200529     C     W@2153        MULT(H)   @RATE4        W@9265           15 3                        238023
308400200529      *                                                                                       238023
308500200529      ** Check if one of the above calculations satisfied the suppose buy amount and if it    238023
308600200529      ** is then assign a Multiply rate to W@MDIN.                                            238023
308700200529      *                                                                                       238023
308800200529     C     W@9250        IFEQ      W@1150                                                     238023
308900200529     C     W@9251        OREQ      W@1150                                                     238023
309000200529     C     W@9252        OREQ      W@1150                                                     238023
309100200529     C     W@9253        OREQ      W@1150                                                     238023
309200200529     C     W@9254        OREQ      W@1150                                                     238023
309300200529     C     W@9255        OREQ      W@1150                                                     238023
309400200529     C     W@9256        OREQ      W@1150                                                     238023
309500200529     C     W@9257        OREQ      W@1150                                                     238023
309600200529     C     W@9258        OREQ      W@1150                                                     238023
309700200529     C     W@9259        OREQ      W@1150                                                     238023
309800200529     C     W@9260        OREQ      W@1150                                                     238023
309900200529     C     W@9261        OREQ      W@1150                                                     238023
310000200529     C     W@9262        OREQ      W@1150                                                     238023
310100200529     C     W@9263        OREQ      W@1150                                                     238023
310200200529     C     W@9264        OREQ      W@1150                                                     238023
310300200529     C     W@9265        OREQ      W@1150                                                     238023
310400200529     C                   MOVE      'M'           W@MDIN                                       238023
310500200529     C**********         Z-ADD     @RATE4        @RRATE                                238023 240038
310600200529     C     W@INRT        SUB       @RATEV        @RRATE                                       240038
310700200529     C                   ENDIF                                                                238023
310800200529     C                   ENDIF                                                                238023
310900200529     C                   ENDIF                                                                238023
311000200529     C*
311100200529     C**Add*exchange*rate*to*margin*+*forward*points***************************************** 238023
311200200529     C**to*get*the*outright*rate************************************************************* 238023
311300200529     C*                                                                                       238023
311400200529     C     F3MGBS        IFEQ      ' '                                                        240038
311500200529     C**********         ADD       W@INRT        @RRATE           13 8          Outright Rate 238023
311600200529     C                   ADD       W@INRT        @RRATE           13 8                        240038
311700200529     C                   ENDIF                                                                240038
311800200529     C*
311900200529     C* Add exchange rate to margin + forward points
312000200529     C* to get the outright rate
312100200529     C*
312200200529     C                   ADD       W@INRT        @RRATE           13 8          Outright Rate
312300200529     C*
312400200529     C**********         IF        CER043 = 'Y' AND DDREIN = 'Y'                   BUG23668 BUG25418
312500200529     C**********         EVAL(H)   @RRATE = 1/@RRATE                               BUG23668 BUG25418
312600200529     C**********         ENDIF                                                     BUG23668 BUG25418
312700200529      *                                                                                     BUG23668
312800200529     C* Add exchange rate to forward points to obtain forward rate
312900200529     C*
313000200529     C     S01453        IFEQ      'Y'
313100200529     C                   ADD       W@INRT        @XRATE           13 8          Fwd Rate
313200200529     C                   END
313300200529     C*
313400200529     C** SET UP RATES TO BE VALIDATED ACCORDING TO METHOD 1, 2, OR 3
313500200529     C** (1 = OUTRIGHT RATE, 2 = RATE + 0.00000005, 3 = RATE - 0.00000005)
313600200529     C*
313700200529     C     @@K           IFEQ      1
313800200529     C                   Z-ADD     @RRATE        @KRATE
313900200529     C                   Z-ADD     @RRATE        @ORATE           14 9
314000200529     C                   END
314100200529     C     @@K           IFEQ      2
314200200529     C     @KRATE        ADD       .000000005    @ORATE
314300200529     C                   END
314400200529     C     @@K           IFEQ      3
314500200529     C     @KRATE        SUB       .000000005    @ORATE
314600200529     C                   END
314700200529     C*
314800200529     C* RESET DIFFERENCES (BETWEEN ACTUAL & CALCULATED BUY/SELL AMOUNTS)
314900200529     C*
315000200529     C                   Z-ADD     1             W@DIFS
315100200529     C                   Z-ADD     1             W@DIFB
315200200529     C*
315300200529     C*----------------------------------------------------------------
315400200529     C*
315500200529      **  Once value of the W@MDIN field still "X", meaning that margin functionality is not  238023
315600200529      **  satisfied. Then check the tolerance unit of calculated amounts in a divide/mult rate238023
315700200529      *                                                                                       238023
315800200529     C     W@MDIN        IFEQ      'X'                                                        238023
315900200529      ** Determine differences between actual 'other' currency amount
316000200529      ** and calculated 'other' currency amount (amount x or / rate)
316100200529      ** and by so doing determine the multiply/divide indicator
316200200529     C*
316300200529     C     @@MDIN        IFNE      'D'
316400200529     C     DDBCCY        ANDNE     BJCYCD
316500200529     C     @@MDIN        OREQ      'D'
316600200529     C     DDBCCY        ANDEQ     BJCYCD
316700200529     C     W@RTOK        OREQ      'N'
316800200529      *
316900200529      ** Calculate 'other' currency amount (amount x or / rate)
317000200529      *
317100200529     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
317200200529     C   90W@2150        DIV(H)    @ORATE        W@3150                           =A/3 15,0
317300200529     C   91W@2150        DIV(H)    @ORATE        W@3151                           =A/3 15,1
317400200529     C   92W@2150        DIV(H)    @ORATE        W@3152                           =A/3 15,2
317500200529     C   93W@2150        DIV(H)    @ORATE        W@3153                           =A/3 15,3
317600200529     C   90W@1150        MULT(H)   @ORATE        W@4150                           =A/4 15,0
317700200529     C   91W@1151        MULT(H)   @ORATE        W@4150                           =A/4 15,1
317800200529     C   92W@1152        MULT(H)   @ORATE        W@4150                           =A/4 15,2
317900200529     C   93W@1153        MULT(H)   @ORATE        W@4150                           =A/4 15,3
318000200529     C                   END                                                    FI
318100200529     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
318200200529     C   90W@2151        DIV(H)    @ORATE        W@3150                           =A/3 15,0
318300200529     C   91W@2151        DIV(H)    @ORATE        W@3151                           =A/3 15,1
318400200529     C   92W@2151        DIV(H)    @ORATE        W@3152                           =A/3 15,2
318500200529     C   93W@2151        DIV(H)    @ORATE        W@3153                           =A/3 15,3
318600200529     C   90W@1150        MULT(H)   @ORATE        W@4151                           =A/4 15,0
318700200529     C   91W@1151        MULT(H)   @ORATE        W@4151                           =A/4 15,1
318800200529     C   92W@1152        MULT(H)   @ORATE        W@4151                           =A/4 15,2
318900200529     C   93W@1153        MULT(H)   @ORATE        W@4151                           =A/4 15,3
319000200529     C                   END                                                    FI
319100200529     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
319200200529     C   90W@2152        DIV(H)    @ORATE        W@3150                           =A/3 15,0
319300200529     C   91W@2152        DIV(H)    @ORATE        W@3151                           =A/3 15,1
319400200529     C   92W@2152        DIV(H)    @ORATE        W@3152                           =A/3 15,2
319500200529     C   93W@2152        DIV(H)    @ORATE        W@3153                           =A/3 15,3
319600200529     C   90W@1150        MULT(H)   @ORATE        W@4152                           =A/4 15,0
319700200529     C   91W@1151        MULT(H)   @ORATE        W@4152                           =A/4 15,1
319800200529     C   92W@1152        MULT(H)   @ORATE        W@4152                           =A/4 15,2
319900200529     C   93W@1153        MULT(H)   @ORATE        W@4152                           =A/4 15,3
320000200529     C                   END                                                    FI
320100200529     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
320200200529     C   90W@2153        DIV(H)    @ORATE        W@3150                           =A/3 15,0
320300200529     C   91W@2153        DIV(H)    @ORATE        W@3151                           =A/3 15,1
320400200529     C   92W@2153        DIV(H)    @ORATE        W@3152                           =A/3 15,2
320500200529     C   93W@2153        DIV(H)    @ORATE        W@3153                           =A/3 15,3
320600200529     C   90W@1150        MULT(H)   @ORATE        W@4153                           =A/4 15,0
320700200529     C   91W@1151        MULT(H)   @ORATE        W@4153                           =A/4 15,1
320800200529     C   92W@1152        MULT(H)   @ORATE        W@4153                           =A/4 15,2
320900200529     C   93W@1153        MULT(H)   @ORATE        W@4153                           =A/4 15,3
321000200529     C                   END                                                    FI
321100200529     C*
321200200529     C** Determine difference between calculated and actual
321300200529     C*
321400200529     C     W@1150        SUB       W@3150        W@DIFB           15 0          actual - calcd
321500200529     C     W@2150        SUB       W@4150        W@DIFS           15 0          actual - calcd
321600200529     C*
321700200529     C* Store calculated amounts for each method ( 1 2 and 3)
321800200529     C*
321900200529     C     @@K           IFEQ      1
322000200529     C                   Z-ADD     W@3150        FB1501           15 0
322100200529     C                   Z-ADD     W@4150        FS1501           15 0
322200200529     C                   Z-ADD     0             FB1502
322300200529     C                   Z-ADD     0             FS1502
322400200529     C                   Z-ADD     0             FB1503
322500200529     C                   Z-ADD     0             FS1503
322600200529     C                   END
322700200529     C     @@K           IFEQ      2
322800200529     C                   Z-ADD     W@3150        FB1502           15 0
322900200529     C                   Z-ADD     W@4150        FS1502           15 0
323000200529     C                   END
323100200529     C     @@K           IFEQ      3
323200200529     C                   Z-ADD     W@3150        FB1503           15 0
323300200529     C                   Z-ADD     W@4150        FS1503           15 0
323400200529     C                   END
323500200529     C*
323600200529     C* DETERMINE THE MULTIPLY/DIVIDE INDICATOR
323700200529     C* BASED ON THE CALCULATIONS DONE ABOVE
323800200529     C*
323900200529     C     W@DIFB        IFLE      2                                            IF
324000200529     C     W@DIFB        ANDGE     -2
324100200529     C     @ROUND        ANDNE     'Y'
324200200529     C     @@K           ANDEQ     1
324300200529     C     @ROUND        OREQ      'Y'
324400200529     C     W@DIFB        ANDGE     -2
324500200529     C     W@DIFB        ANDLE     2
324600200529     C     @@K           ANDEQ     1
324700200529     C                   MOVE      'M'           W@MDIN                           Mult/Div.ind.
324800200529     C                   GOTO      #ZICB8                                         Exit
324900200529     C                   ELSE                                                   ELSE
325000200529     C     W@DIFS        IFLE      2
325100200529     C     W@DIFS        ANDGE     -2
325200200529     C     @ROUND        ANDNE     'Y'
325300200529     C     @@K           ANDEQ     1
325400200529     C     @ROUND        OREQ      'Y'
325500200529     C     W@DIFS        ANDGE     -2
325600200529     C     W@DIFS        ANDLE     2
325700200529     C     @@K           ANDEQ     1
325800200529     C                   MOVE      'D'           W@MDIN                           Mult/Div.ind
325900200529     C                   GOTO      #ZICB8                                         Exit
326000200529     C                   ELSE
326100200529     C     @@K           IFEQ      3
326200200529     C*****W@1150        IFLE      FB1502                                                  BUG25240A
326300200529     C*****W@1150        ANDGE     FB1503                                                  BUG25240A
326400200529     C*****FB1501        ANDLE     FB1502                                                  BUG25240A
326500200529     C*****FB1501        ANDGE     FB1503                                                  BUG25240A
326600200529     C     W@1150        IFGE      FB1502                                                  BUG25240A
326700200529     C     W@1150        ANDLE     FB1503                                                  BUG25240A
326800200529     C     FB1501        ANDGE     FB1502                                                  BUG25240A
326900200529     C     FB1501        ANDLE     FB1503                                                  BUG25240A
327000200529     C                   MOVE      'M'           W@MDIN
327100200529     C                   ELSE
327200200529     C*****W@2150        IFGE      FS1502                                                  BUG25240A
327300200529     C*****W@2150        ANDLE     FS1503                                                  BUG25240A
327400200529     C*****FS1501        ANDGE     FS1502                                                  BUG25240A
327500200529     C*****FS1501        ANDLE     FS1503                                                  BUG25240A
327600200529     C     W@2150        IFLE      FS1502                                                  BUG25240A
327700200529     C     W@2150        ANDGE     FS1503                                                  BUG25240A
327800200529     C     FS1501        ANDLE     FS1502                                                  BUG25240A
327900200529     C     FS1501        ANDGE     FS1503                                                  BUG25240A
328000200529     C                   MOVE      'D'           W@MDIN
328100200529     C                   END
328200200529     C                   END
328300200529     C                   END
328400200529     C                   END
328500200529     C                   END
328600200529     C                   END
328700200529     C*
328800200529     C*----------------------------------------------------------------
328900200529     C*
329000200529      ** Determine differences between actual 'other' currency amount
329100200529      ** and calculated 'other' currency amount (amount x or / rate)
329200200529      ** and by so doing determine the multiply/divide indicator
329300200529     C*
329400200529     C     @@MDIN        IFNE      'M'
329500200529     C     DDBCCY        ANDNE     BJCYCD                                       CCY1 NOT = BCA
329600200529     C     @@MDIN        OREQ      'M'
329700200529     C     DDBCCY        ANDEQ     BJCYCD                                       CCY1     = BCA
329800200529     C     W@RTOK        OREQ      'N'
329900200529      *
330000200529      ** Calculate 'other' currency amount (amount x or / rate)
330100200529      *
330200200529     C     *IN94         IFEQ      '1'                                          IF A/2 = 15,0
330300200529     C   90W@2150        MULT(H)   @ORATE        W@3150                           =A/3 15,0
330400200529     C   91W@2150        MULT(H)   @ORATE        W@3151                           =A/3 15,1
330500200529     C   92W@2150        MULT(H)   @ORATE        W@3152                           =A/3 15,2
330600200529     C   93W@2150        MULT(H)   @ORATE        W@3153                           =A/3 15,3
330700200529     C   90W@1150        DIV(H)    @ORATE        W@4150                           =A/4 15,0
330800200529     C   91W@1151        DIV(H)    @ORATE        W@4150                           =A/4 15,1
330900200529     C   92W@1152        DIV(H)    @ORATE        W@4150                           =A/4 15,2
331000200529     C   93W@1153        DIV(H)    @ORATE        W@4150                           =A/4 15,3
331100200529     C                   END                                                    FI
331200200529     C     *IN95         IFEQ      '1'                                          IF A/2 = 15,1
331300200529     C   90W@2151        MULT(H)   @ORATE        W@3150                           =A/3 15,0
331400200529     C   91W@2151        MULT(H)   @ORATE        W@3151                           =A/3 15,1
331500200529     C   92W@2151        MULT(H)   @ORATE        W@3152                           =A/3 15,2
331600200529     C   93W@2151        MULT(H)   @ORATE        W@3153                           =A/3 15,3
331700200529     C   90W@1150        DIV(H)    @ORATE        W@4151                           =A/4 15,0
331800200529     C   91W@1151        DIV(H)    @ORATE        W@4151                           =A/4 15,1
331900200529     C   92W@1152        DIV(H)    @ORATE        W@4151                           =A/4 15,2
332000200529     C   93W@1153        DIV(H)    @ORATE        W@4151                           =A/4 15,3
332100200529     C                   END                                                    FI
332200200529     C     *IN96         IFEQ      '1'                                          IF A/2 = 15,2
332300200529     C   90W@2152        MULT(H)   @ORATE        W@3150                           =A/3 15,0
332400200529     C   91W@2152        MULT(H)   @ORATE        W@3151                           =A/3 15,1
332500200529     C   92W@2152        MULT(H)   @ORATE        W@3152                           =A/3 15,2
332600200529     C   93W@2152        MULT(H)   @ORATE        W@3153                           =A/3 15,3
332700200529     C   90W@1150        DIV(H)    @ORATE        W@4152                           =A/4 15,0
332800200529     C   91W@1151        DIV(H)    @ORATE        W@4152                           =A/4 15,1
332900200529     C   92W@1152        DIV(H)    @ORATE        W@4152                           =A/4 15,2
333000200529     C   93W@1153        DIV(H)    @ORATE        W@4152                           =A/4 15,3
333100200529     C                   END                                                    FI
333200200529     C     *IN97         IFEQ      '1'                                          IF A/2 = 15,3
333300200529     C   90W@2153        MULT(H)   @ORATE        W@3150                           =A/3 15,0
333400200529     C   91W@2153        MULT(H)   @ORATE        W@3151                           =A/3 15,1
333500200529     C   92W@2153        MULT(H)   @ORATE        W@3152                           =A/3 15,2
333600200529     C   93W@2153        MULT(H)   @ORATE        W@3153                           =A/3 15,3
333700200529     C   90W@1150        DIV(H)    @ORATE        W@4153                           =A/4 15,0
333800200529     C   91W@1151        DIV(H)    @ORATE        W@4153                           =A/4 15,1
333900200529     C   92W@1152        DIV(H)    @ORATE        W@4153                           =A/4 15,2
334000200529     C   93W@1153        DIV(H)    @ORATE        W@4153                           =A/4 15,3
334100200529     C                   END                                                    FI
334200200529     C*
334300200529     C** Determine difference between calculated and actual
334400200529     C*
334500200529     C     W@1150        SUB       W@3150        W@DIFB                         Difference
334600200529     C     W@2150        SUB       W@4150        W@DIFS                         Difference
334700200529     C*
334800200529     C* Store calculated amounts for each method ( 1 2 and 3)
334900200529     C*
335000200529     C     @@K           IFEQ      1
335100200529     C                   Z-ADD     W@3150        JB1501           15 0
335200200529     C                   Z-ADD     W@4150        JS1501           15 0
335300200529     C                   Z-ADD     0             JB1502
335400200529     C                   Z-ADD     0             JS1502
335500200529     C                   Z-ADD     0             JB1503
335600200529     C                   Z-ADD     0             JS1503
335700200529     C                   END
335800200529     C     @@K           IFEQ      2
335900200529     C                   Z-ADD     W@3150        JB1502           15 0
336000200529     C                   Z-ADD     W@4150        JS1502           15 0
336100200529     C                   END
336200200529     C     @@K           IFEQ      3
336300200529     C                   Z-ADD     W@3150        JB1503           15 0
336400200529     C                   Z-ADD     W@4150        JS1503           15 0
336500200529     C                   END
336600200529     C*
336700200529     C* DETERMINE THE MULTIPLY/DIVIDE INDICATOR
336800200529     C* BASED ON THE CALCULATIONS DONE ABOVE
336900200529     C*
337000200529     C     W@DIFB        IFLE      2
337100200529     C     W@DIFB        ANDGE     -2
337200200529     C     @ROUND        ANDNE     'Y'
337300200529     C     @@K           ANDEQ     1
337400200529     C     @ROUND        OREQ      'Y'
337500200529     C     W@DIFB        ANDGE     -2
337600200529     C     W@DIFB        ANDLE     2
337700200529     C     @@K           ANDEQ     1
337800200529     C                   MOVE      'D'           W@MDIN                         Mult/Div ind
337900200529     C                   ELSE
338000200529     C     W@DIFS        IFLE      2
338100200529     C     W@DIFS        ANDGE     -2
338200200529     C     @ROUND        ANDNE     'Y'
338300200529     C     @@K           ANDEQ     1
338400200529     C     @ROUND        OREQ      'Y'
338500200529     C     W@DIFS        ANDGE     -2
338600200529     C     W@DIFS        ANDLE     2
338700200529     C     @@K           ANDEQ     1
338800200529     C                   MOVE      'M'           W@MDIN                         Mult/Div ind
338900200529     C                   ELSE
339000200529     C     @@K           IFEQ      3
339100200529     C     W@1150        IFLE      JB1502
339200200529     C     W@1150        ANDGE     JB1503
339300200529     C     JB1501        ANDLE     JB1502
339400200529     C     JB1501        ANDGE     JB1503
339500200529     C                   MOVE      'M'           W@MDIN
339600200529     C                   ELSE
339700200529     C     W@2150        IFGE      JS1502
339800200529     C     W@2150        ANDLE     JS1503
339900200529     C     JS1501        ANDGE     JS1502
340000200529     C     JS1501        ANDLE     JS1503
340100200529     C                   MOVE      'D'           W@MDIN
340200200529     C                   END
340300200529     C                   END
340400200529     C                   END
340500200529     C                   END
340600200529     C                   END
340700200529     C                   END
340800200529     C                   ENDIF                                                                238023
340900200529     C*
341000200529     C     #ZICB8        TAG
341100200529     C                   Z-ADD     W@INRT        @SRATE                         Descaled rate
341200200529     C                   ENDSR
341300200529     C*****************************************************************
341400200529      /EJECT
341500200529      *****************************************************************
341600200529      ** #ZICC - Convert numeric amount to edited alpha
341700200529      *****************************************************************
341800200529     C     #ZICC         BEGSR
341900200529     C* INPUTS
342000200529     C                   Z-ADD     W@AMNT        W@AMNT                         Amount
342100200529     C                   Z-ADD     W@DECP        W@DECP                         Dec.Places
342200200529     C* OUTPUTS
342300200529     C                   MOVE      *BLANK        W@AMTD                         Edit amt (unsign)
342400200529     C                   MOVE      *BLANK        W@AMTP                         Edit amt (sign)
342500200529     C*
342600200529     C                   SETOFF                                         91      Init.Inds.
342700200529     C*
342800200529     C     W@DECP        IFEQ      *ZERO                                        IF NO DEC.POS.
342900200529     C                   Z-ADD     2             P1                               Start pos.
343000200529     C                   Z-ADD     *ZERO         W@QECW            3 0            Start decimal
343100200529     C                   ELSE                                                   EL DEC.PLACES
343200200529     C                   Z-ADD     1             P1                5 0            Start pos.
343300200529     C     16            SUB       W@DECP        W@QECW                           Start decimal
343400200529     C                   END                                                    FI
343500200529     C*
343600200529     C     W@AMNT        IFLT      *ZERO                                        IF NEGATIVE
343700200529     C     *ZERO         SUB       W@AMNT        W@AMNT                           Make positive
343800200529     C                   MOVE      '-'           W@AMTD                           Negative
343900200529     C                   END                                                    FI
344000200529     C*
344100200529     C     1             DO        15            P2                5 0          DO EDIT
344200200529     C     W@DECP        IFNE      *ZERO                                        IF   ¦ DECIMAL
344300200529     C     P1            ANDEQ     W@QECW                                       AND  ¦ POSITION
344400200529     C                   MOVE      BNDCSP        @Y(P1)                           Decimal point
344500200529     C                   ADD       1             P1                   91          Incr.ptr.Y
344600200529     C                   END                                                    FI
344700200529     C     *IN91         IFEQ      '0'                                          IF   ¦ LEADING
344800200529     C     @P(P2)        ANDEQ     *ZERO                                         AND ¦ ZERO
344900200529     C                   MOVE      *BLANK        @Y(P1)                           Blank
345000200529     C                   ELSE                                                   EL IN NUMBER
345100200529     C                   MOVE      @P(P2)        @Y(P1)                           Valid data
345200200529     C                   SETON                                        91          In number
345300200529     C                   END                                                    FI
345400200529     C                   ADD       1             P1                               Incr.ptr.Y
345500200529     C                   END                                                    OD
345600200529     C*
345700200529     C                   Z-ADD     16            P1                               Set ptr.1
345800200529     C     @Y(P1)        DOWEQ     '0'                                          DO TRIM ZEROS
345900200529     C                   SUB       1             P1                               Decr.ptr.1
346000200529     C                   END                                                    OD
346100200529     C                   ADD       1             P1                               Incr.ptr.1
346200200529     C     P1            IFLT      17                                           IF PTR.IN RANGE
346300200529     C                   MOVEA     *BLANK        @Y(P1)                           Trim zeros
346400200529     C                   END                                                    FI
346500200529     C                   Z-ADD     1             P1                               Set ptr.1
346600200529     C     *BLANK        LOOKUP    @Y(P1)                             90          Find start
346700200529     C*
346800200529     C     ZICC9         ENDSR
346900200529      *****************************************************************
347000200529      /EJECT
347100200529      *****************************************************************
347200200529      * ZA0790 - DETERMINE NUMBER OF NORMALLY QUOTED DECIMAL PLACES   *
347300200529      *****************************************************************
347400200529     C     ZA0790        BEGSR
347500200529      *
347600200529     C     @@NDP1        IFEQ      @@NDP2
347700200529     C     @@NDP1        ANDEQ     5
347800200529     C                   Z-ADD     5             @@NDP             1 0
347900200529     C                   GOTO      ZA0799
348000200529     C                   END
348100200529      *                                                                                       248024
348200200529      ** Compare normally-quoted decimal places of both currencies invovled;                  248024
348300200529      ** If both are the same, use either value as NQD...                                     248024
348400200529      *                                                                                       248024
348500200529     C     @@NDP1        IFEQ      @@NDP2                                                     248024
348600200529     C                   Z-ADD     @@NDP1        @@NDP                                        248024
348700200529     C                   GOTO      ZA0799                                                     248024
348800200529     C                   ENDIF                                                                248024
348900200529      *                                                                                       248024
349000200529      ** If they are not the same, use the lesser value of the two...                         248024
349100200529      *                                                                                       248024
349200200529     C     @@NDP1        IFNE      @@NDP2                                                     248024
349300200529     C     @@NDP1        IFLT      @@NDP2                                                     248024
349400200529     C                   Z-ADD     @@NDP1        @@NDP                                        248024
349500200529     C                   ELSE                                                                 248024
349600200529     C     @@NDP2        IFLT      @@NDP1                                                     248024
349700200529     C                   Z-ADD     @@NDP2        @@NDP                                        248024
349800200529     C                   ENDIF                                                                248024
349900200529     C                   ENDIF                                                                248024
350000200529     C                   GOTO      ZA0799                                                     248024
350100200529     C                   ENDIF                                                                248024
350200200529     C*
350300200529     C     @@IRAT        IFGE      100
350400200529     C                   Z-ADD     2             @@NDP
350500200529     C                   ELSE
350600200529     C     @@IRAT        IFLT      100
350700200529     C     @@IRAT        ANDGE     20
350800200529     C*******************Z-ADD     3             @@NDP                          143747
350900200529     C**********         Z-ADD     2             @@NDP                   143747 195763
351000200529     C                   Z-ADD     3             @@NDP                          195763
351100200529     C                   ELSE
351200200529     C     @@IRAT        IFLT      20
351300200529     C     @@IRAT        ANDGE     1
351400200529     C                   Z-ADD     4             @@NDP
351500200529     C                   ELSE
351600200529     C     @@IRAT        IFLT      1
351700200529     C*******************Z-ADD     5             @@NDP                          143747
351800200529     C**********         Z-ADD     4             @@NDP                   143747 195763
351900200529     C                   Z-ADD     5             @@NDP                          195763
352000200529     C                   END
352100200529     C                   END
352200200529     C                   END
352300200529     C                   END
352400200529      *
352500200529     C     ZA0799        ENDSR
352600200529      *                                                                                       CER043
352700200529      *****************************************************************                     BUG23050
352800200529      *                                                               *                     BUG23050
352900200529      ** SrRepIn - Process to Default the correct Reciprocal Indicator*                     BUG23050
353000200529      *                                                               *                     BUG23050
353100200529      *  Called by: Main Processing                                   *                     BUG23050
353200200529      *                                                               *                     BUG23050
353300200529      *                                                               *                     BUG23050
353400200529      *****************************************************************                     BUG23050
353500200529      *                                                                                     BUG23050
353600200529     C     SrRepIn       BEGSR                                                              BUG23050
353700200529      **********                                                                  BUG23050  BUG23668
353800200529      **Calculate*for Gross spot rate from the screen input                       BUG23050  BUG23668
353900200529     C**********         EXSR      SrFwdMrgnPt                                    BUG23050  BUG23668
354000200529      *                                                                                     BUG23050
354100200529      **Calculate for system spot rate                                            BUG23050 BUG23050A
354200200529      **Default*the correct Reciprocal indicator and compute system deviation     BUG23050 BUG23050A
354300200529     C**********         EXSR      SrSySpotRte                                    BUG23050 BUG23050A
354400200529      *                                                                                     BUG23050
354500200529      *  Compare spot rate from screen input and calculated system spot rate.               BUG23050
354600200529      *  If the spot rate and entered rate are the same side                                BUG23050
354700200529      *  of +1.0, the default for Reciprocal will be set to 'N', otherwise, 'Y'.            BUG23050
354800200529                                                                                            BUG23050
354900200529     C                   IF        WSysSpotrt <  1 AND                                      BUG23050
355000200529     C                             @RRATE     >  1 OR                                       BUG23050
355100200529     C                             WSysSpotrt >  1 AND                                      BUG23050
355200200529     C                             @RRATE     <  1                                          BUG23050
355300200529     C                   EVAL      DDREIN = 'Y'                                             BUG23050
355400200529     C                   ELSE                                                               BUG23668
355500200529     C                   EVAL      DDREIN = 'N'                                             BUG23668
355600200529     C                   ENDIF                                                              BUG23050
355700200529      **Reset*spot rate field                                                     BUG23050 BUG23050A
355800200529     C**********         Z-ADD     *Zero         @RRATE                           BUG23050 BUG23050A
355900200529      *                                                                                     BUG23050
356000200529     C                   ENDSR                                                              BUG23050
356100200529      *****************************************************************                       CER043
356200200529      *                                                               *                       CER043
356300200529      ** SrBSAmtCal - Calculate buy and sell amount                   *                       CER043
356400200529      *                                                               *                       CER043
356500200529      *  Called by: Main Processing                                   *                       CER043
356600200529      *                                                               *                       CER043
356700200529      *  Calls: FmtAmt                                                *                       CER043
356800200529      *                                                               *                       CER043
356900200529      *****************************************************************                       CER043
357000200529      *                                                                                       CER043
357100200529     C     SrBSAmtCal    BEGSR                                                                CER043
357200200529      *                                                                                       CER043
357300200529      ** Check Reciprocal rate indicator                                                      CER043
357400200529      *                                                                                       CER043
357500200529     C**********         IF        DDREIN = 'Y'                                     CER043 BUG23050A
357600200529     C*****1****         DIV(H)    W@INRT        W@INRT                             CER043 BUG23050A
357700200529     C**********         ENDIF                                                      CER043 BUG23050A
357800200529      *                                                                                       CER043
357900200529      ** Buy amount entered                                                                   CER043
358000200529      *                                                                                       CER043
358100200529     C                   IF        DDSAMT = *BLANKS                                           CER043
358200200529     C                   EVAL      WF3DAM1 = %ABS(F3DAM1)                                     CER043
358300200529      *                                                                                       CER043
358400200529      ***Calculate Outright Forward/Margin Rate                                     CER043 BUG23050A
358500200529      **********                                                                    CER043 BUG23050A
358600200529     C**********         EXSR      SrFwdMrgnPt                                      CER043 BUG23050A
358700200529                                                                                              CER043
358800200529     C                   IF        DDREIN = 'N'                                             BUG25240
358900200529     C                   EVAL      WMDIN1 = 'M'                                             BUG25240
359000200529     C                   ELSE                                                               BUG25240
359100200529     C                   EVAL      WMDIN1 = 'D'                                             BUG25240
359200200529     C                   ENDIF                                                              BUG25240
359300200529      *                                                                                     BUG25240
359400200529     C                   CALLB     'ZCONV'                                                    CER043
359500200529     C                   PARM                    WF3DAM1                                      CER043
359600200529     C                   PARM                    @RRATE                                       CER043
359700200529     C**********         PARM      'M'           WMDIN                               CER043 BUG25240
359800200529     C                   PARM      WMDIN1        WMDIN                                      BUG25240
359900200529     C                   PARM                    DDBCCY                                       CER043
360000200529     C                   PARM                    DDSCCY                                       CER043
360100200529     C                   PARM                    @CDP1                                        CER043
360200200529     C                   PARM                    @CDP2                                        CER043
360300200529     C                   PARM                    POutAmt                                      CER043
360400200529                                                                                              CER043
360500200529     C                   IF        POutAmt <> *ZEROS                                          CER043
360600200529     C                   EVAL      F3DAM2 = POutAmt*(-1)                                      CER043
360700200529     C                   EVAL      ZFLD15 = %DEC(%ABS(F3DAM2):15:0)                           CER043
360800200529     C                   EVAL      ZDECS =  @CDP2                                             CER043
360900200529     C                   EVAL      ZCRET =  17                                              BUG21428
361000200529     C                   EXSR      FmtAmt                                                     CER043
361100200529     C                   EVAL      DDSAMT = %TRIM(ZOUT21)                                     CER043
361200200529     C     DDDLTP        IFEQ      'OT'                                                       CER043
361300200529     C     DDACTN        ANDEQ     'I'                                                        CER043
361400200529     C*****F3DAM2        ANDGT     RelDAM2                                           CER043 BUG22009
361500200529     C     RelDAM2       ANDGT     F3DAM2                                                   BUG22009
361600200529     C                   MOVE      'N'           DDSamtOK                                     CER043
361700200529     C                   ADD       1             Idx                                          CER043
361800200529     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)                               CER043
361900200529     C                   MOVEL     'FXM0147'     MsgIdXAr(Idx)                                CER043
362000200529     C                   ELSE                                                                 CER043
362100200529     C                   EVAL      DDSAmtOK = 'Y'                                             CER043
362200200529     C                   ENDIF                                                                CER043
362300200529     C                   ENDIF                                                                CER043
362400200529     C                   ENDIF                                                                CER043
362500200529      *                                                                                       CER043
362600200529      ** Sell amount entered                                                                  CER043
362700200529      *                                                                                       CER043
362800200529     C                   IF        DDBAMT = *BLANKS                                           CER043
362900200529     C                   EVAL      WF3DAM2 = %ABS(F3DAM2)                                     CER043
363000200529      *                                                                                       CER043
363100200529      ***Calculate Outright Forward/Margin Rate                                     CER043 BUG23050A
363200200529      **********                                                                    CER043 BUG23050A
363300200529     C**********         EXSR      SrFwdMrgnPt                                      CER043 BUG23050A
363400200529                                                                                              CER043
363500200529     C                   IF        DDREIN = 'N'                                             BUG25240
363600200529     C                   EVAL      WMDIN1 = 'D'                                             BUG25240
363700200529     C                   ELSE                                                               BUG25240
363800200529     C                   EVAL      WMDIN1 = 'M'                                             BUG25240
363900200529     C                   ENDIF                                                              BUG25240
364000200529      *                                                                                     BUG25240
364100200529     C                   CALLB     'ZCONV'                                                    CER043
364200200529     C                   PARM                    WF3DAM2                                      CER043
364300200529     C                   PARM                    @RRATE                                       CER043
364400200529     C**********         PARM      'D'           WMDIN                               CER043 BUG25240
364500200529     C                   PARM      WMDIN1        WMDIN                                      BUG25240
364600200529     C                   PARM                    DDSCCY                                       CER043
364700200529     C                   PARM                    DDBCCY                                       CER043
364800200529     C                   PARM                    @CDP2                                        CER043
364900200529     C                   PARM                    @CDP1                                        CER043
365000200529     C                   PARM                    POutAmt                                      CER043
365100200529                                                                                              CER043
365200200529     C                   IF        POutAmt <> *ZEROS                                          CER043
365300200529     C                   EVAL      F3DAM1 = POutAmt                                           CER043
365400200529     C                   EVAL      ZFLD15 = %DEC(%ABS(F3DAM1):15:0)                           CER043
365500200529     C                   EVAL      ZDECS = @CDP1                                              CER043
365600200529     c                   EVAL      ZCRET =  17                                              BUG22005
365700200529     C                   EXSR      FmtAmt                                                     CER043
365800200529     C                   EVAL      DDBAMT = %TRIM(ZOUT21)                                     CER043
365900200529     C     DDDLTP        IFEQ      'OT'                                                       CER043
366000200529     C     DDACTN        ANDEQ     'I'                                                        CER043
366100200529     C     F3DAM1        ANDGT     RelDAM1                                                    CER043
366200200529     C                   MOVE      'N'           DDBamtOK                                     CER043
366300200529     C                   ADD       1             Idx                                          CER043
366400200529     C                   MOVEL     'DDBAMT'      FldNamXAr(Idx)                               CER043
366500200529     C                   MOVEL     'FXM0145'     MsgIdXAr(Idx)                                CER043
366600200529     C                   ELSE                                                                 CER043
366700200529     C                   EVAL      DDBAmtOK = 'Y'                                             CER043
366800200529     C                   ENDIF                                                                CER043
366900200529     C                   ENDIF                                                                CER043
367000200529     C                   ENDIF                                                                CER043
367100200529                                                                                              CER043
367200200529     C                   ENDSR                                                                CER043
367300200529      *****************************************************************                       CER043
367400200529      *                                                               *                       CER043
367500200529      ** SrFwdMrgnPt - Calculate Outright Forward/Margin Rate         *                       CER043
367600200529      *                                                               *                       CER043
367700200529      *  Called by: SrBSAmtCal                                        *                       CER043
367800200529      *                                                               *                       CER043
367900200529      *****************************************************************                       CER043
368000200529      *                                                                                       CER043
368100200529     C     SrFwdMrgnPt   BEGSR                                                                CER043
368200200529     C                   Z-ADD     1             W@SFAC                                       CER043
368300200529     C     DDBCCY        IFEQ      BNCYDL                                                     CER043
368400200529     C                   Z-ADD     @@NDP2        W@NQDP                                       CER043
368500200529     C                   ADD       @@SXP2        W@SFAC                                       CER043
368600200529     C                   ELSE                                                                 CER043
368700200529     C     DDSCCY        IFEQ      BNCYDL                                                     CER043
368800200529     C                   Z-ADD     @@NDP1        W@NQDP                                       CER043
368900200529     C                   ADD       @@SXP1        W@SFAC                                       CER043
369000200529     C                   ELSE                                                                 CER043
369100200529     C*                                                                                       CER043
369200200529     C* Determine number of normally quoted decimal places                                    CER043
369300200529     C*                                                                                       CER043
369400200529     C                   Z-ADD     @@INRT        @@IRAT                                       CER043
369500200529     C                   EXSR      ZA0790                                                     CER043
369600200529     C                   Z-ADD     @@NDP         W@NQDP                                       CER043
369700200529     C                   ENDIF                                                                CER043
369800200529     C                   ENDIF                                                                CER043
369900200529     C*                                                                                       CER043
370000200529     C* Descale the input exchange rate                                                       CER043
370100200529     C*                                                                                       CER043
370200200529     C     W@INRT        DIV(H)    @SF(W@SFAC)   @SRATE                                       CER043
370300200529     C*                                                                                       CER043
370400200529     C* If the normally quoted decimal places is not zero                                     CER043
370500200529     C* Add (adjusted) forward points to margin                                               CER043
370600200529     C*                                                                                       CER043
370700200529     C     W@NQDP        IFNE      0                                                          CER043
370800200529     C     @@FPNT        DIV(H)    @AD(W@NQDP)   @RRATE                                       CER043
370900200529     C     S01453        IFEQ      'Y'                                                        CER043
371000200529     C*                  Z-ADD     @RRATE        @XRATE                                       CER043
371100200529     C     @SMGPT        DIV(H)    @AD(W@NQDP)   @@MADJ                                       CER043
371200200529     C                   ADD       @@MADJ        @RRATE                                       CER043
371300200529     C                   END                                                                  CER043
371400200529     C                   END                                                                  CER043
371500200529     C*                                                                                       CER043
371600200529     C* If the normally quoted decimal places is zero                                         CER043
371700200529     C* Add forward points to margin                                                          CER043
371800200529     C*                                                                                       CER043
371900200529     C     W@NQDP        IFEQ      0                                                          CER043
372000200529     C                   Z-ADD     @@FPNT        @RRATE                                       CER043
372100200529     C     S01453        IFEQ      'Y'                                                        CER043
372200200529     C*                  Z-ADD     @RRATE        @XRATE                                       CER043
372300200529     C                   ADD       @SMGPT        @RRATE                                       CER043
372400200529     C                   END                                                                  CER043
372500200529     C                   END                                                                  CER043
372600200529     C*                                                                                       CER043
372700200529     C* Descale margin + forward points                                                       CER043
372800200529     c*                                                                                       CER043
372900200529     C                   DIV       @SF(W@SFAC)   @RRATE                                       CER043
373000200529     C*                                                                                       CER043
373100200529     C* Add descaled exchange rate to descaled margin + forward points                        CER043
373200200529     C* to get the outright descaled rate                                                     CER043
373300200529     C*                                                                                       CER043
373400200529     C                   ADD       @SRATE        @RRATE                                       CER043
373500200529                                                                                              CER043
373600200529     C                   ENDSR                                                                CER043
373700200529      *****************************************************************                     BUG23050
373800200529      *                                                               *                     BUG23050
373900200529      ** SrSySpotRte - Calculate System Spot Rate                     *                     BUG23050
374000200529      *                                                               *                     BUG23050
374100200529      *  Called by: SrBSAmtCal                                        *                     BUG23050
374200200529      *                                                               *                     BUG23050
374300200529      *****************************************************************                     BUG23050
374400200529      *                                                                                     BUG23050
374500200529     C     SrSySpotRte   BEGSR                                                              BUG23050
374600200529      *                                                                                     BUG23050
374700200529      *** Get System spot rate                                                              BUG23050
374800200529     C                   EVAL      WSysSpotrt = *ZEROS                                      BUG23050
374900200529                                                                                            BUG23050
375000200529     C                   IF        @SPOT1 <> *ZEROS and @SPOT2 <> *ZEROS                    BUG23050
375100200529      *                                                                                     BUG23050
375200200529      * Mult./divide ind. the same                                                          BUG23050
375300200529     C                   IF        @@MDF1 = @@MDF2                                          BUG23050
375400200529      *                                                                                     BUG23050
375500200529      * If both multiply calc. is rate1/rate2.                                              BUG23050
375600200529      * If both divide calc. is rate2/rate1.                                                BUG23050
375700200529     C                   IF        @@MDF1 = 'M'                                             BUG23050
375800200529     C                   EVAL(H)   WSysSpotrt = @SPOT1 / @SPOT2                             BUG23050
375900200529     C                   ELSE                                                               BUG23050
376000200529     C                   EVAL(H)   WSysSpotrt = @SPOT2 / @SPOT1                             BUG23050
376100200529     C                   ENDIF                                                              BUG23050
376200200529      *                                                                                     BUG23050
376300200529      * Mult./divide ind. not the same                                                      BUG23050
376400200529     C                   ELSE                                                               BUG23050
376500200529      *                                                                                     BUG23050
376600200529      * If rate1 is mult. & rate2 is divide calc. is rate1 x rate2.                         BUG23050
376700200529      * If rate1 is divide & rate2 is mult. calc. is 1/(rate1 x rate2).                     BUG23050
376800200529      *                                                                                     BUG23050
376900200529     C                   IF        @@MDF1 = 'M'                                             BUG23050
377000200529     C                   EVAL(H)   WSysSpotrt = @SPOT1 * @SPOT2                             BUG23050
377100200529     C                   ELSE                                                               BUG23050
377200200529     C                   EVAL(H)   WSysSpotrt = 1 / (@SPOT1 * @SPOT2)                       BUG23050
377300200529     C                   ENDIF                                                              BUG23050
377400200529                                                                                            BUG23050
377500200529     C                   ENDIF                                                              BUG23050
377600200529      *                                                                                     BUG23050
377700200529     C                   ENDIF                                                              BUG23050
377800200529      *                                                                                     BUG23050
377900200529     C                   ENDSR                                                              BUG23050
378000200529      *****************************************************************           BUG23668 BUG23668D
378100200529      *                                                               *           BUG23668 BUG23668D
378200200529      ** SrSpRtOverlap - Check if spot rates are close to 1 and       *           BUG23668 BUG23668D
378300200529      *                  overlaps                                     *           BUG23668 BUG23668D
378400200529      *                                                               *           BUG23668 BUG23668D
378500200529      *****************************************************************           BUG23668 BUG23668D
378600200529      **********                                                                  BUG23668 BUG23668D
378700200529     C*****SrSpRtOverlap BEGSR                                                    BUG23668 BUG23668D
378800200529      **********                                                                  BUG23668 BUG23668D
378900200529      * If*the*spot rate and the reciprocal rate of the spot rate are both        BUG23668 BUG23668D
379000200529      **close*to 1 of the base currency, and overlap due to the exchange rate     BUG23668 BUG23668D
379100200529      **range*specified, the defaulting will be always 'N' and send warning       BUG23668 BUG23668D
379200200529      **message.                                                                  BUG23668 BUG23668D
379300200529     C**********         EVAL      WOverlap = 'N'                                 BUG23668 BUG23668D
379400200529     C**********         EVAL(H)   WSysSpotrtN = WSysSpotrt                       BUG23668 BUG23668D
379500200529      **********                                                                  BUG23668 BUG23668D
379600200529      **Retrieve entered Exchange Rate + margin +forward points and the Inv rate  BUG23668 BUG23668D
379700200529     C**********         EVAL      WRrateInv = 1/@RRATE                           BUG23668 BUG23668B
379800200529     C**********         EVAL(H)   WRrateInv = 1/@RRATE                          BUG23668B BUG23668D
379900200529      **********                                                                  BUG23668 BUG23668D
380000200529      **Get*reciprocal rate of the spot rate                                      BUG23668 BUG23668D
380100200529      **********                                                                  BUG23668 BUG23668D
380200200529     C**********         EVAL(H)   WSysSpotrtInv = 1/WSysSpotrtN                  BUG23668 BUG23668D
380300200529      **********                                                                  BUG23668 BUG23668D
380400200529      ***Get*highest Exchange rate tolerance range from file                     BUG23668A BUG23668D
380500200529     C**********         IF        @NEXRT1 >= @NEXRT2                            BUG23668A BUG23668D
380600200529     C**********         EVAL      WRetpD = @NEXRT1/100                          BUG23668A BUG23668D
380700200529     C**********         ELSE                                                    BUG23668A BUG23668D
380800200529     C**********         EVAL      WRetpD = @NEXRT2/100                          BUG23668A BUG23668D
380900200529     C**********         ENDIF                                                   BUG23668A BUG23668D
381000200529      **********                                                                 BUG23668A BUG23668D
381100200529      **Check*which of the currencies is the base currency for Dealing.           BUG23668 BUG23668A
381200200529      **If*one*is the base ccy, use the tolerance from ICD. If none is a base     BUG23668 BUG23668A
381300200529      **ccy,*calculate the tolerance between the two non-base ccy using the toleraBUG23668 BUG23668A
381400200529      **of*each*ccy against the base ccy.                                         BUG23668 BUG23668A
381500200529      **********                                                                  BUG23668 BUG23668D
381600200529     C**********         IF        DDBCCY =  BNCYDL OR                            BUG23668 BUG23668A
381700200529     C**********                   DDSCCY =  BNCYDL                               BUG23668 BUG23668A
381800200529      **********                                                                  BUG23668 BUG23668D
381900200529      **Obtain*limits of Spot Rate and Inverse Spot rate by using the             BUG23668 BUG23668A
382000200529      **Exch*rate tolerance of BASE ccy.                                          BUG23668 BUG23668A
382100200529      **********                                                                  BUG23668 BUG23668D
382200200529     C**********         EVAL(H)   WSsr10 = WSysSpotrtN * TOLRAN                  BUG23668 BUG23668A
382300200529     C**********         EVAL(H)   WIsr10 = WSysSpotrtInv * TOLRAN                BUG23668 BUG23668A
382400200529      **********                                                                 BUG23668A BUG23668D
382500200529      **If*one*of the ccys is base ccy,                                          BUG23668A BUG23668D
382600200529      **Obtain*limits of Spot Rate and Inverse Spot rate by using the            BUG23668A BUG23668D
382700200529      **Exch*rate tolerance of ccy which is not the base                         BUG23668A BUG23668D
382800200529      **If*none*of the ccys is base ccy, get the highest exch rate tol.          BUG23668A BUG23668D
382900200529      **********                                                                 BUG23668A BUG23668D
383000200529     C**********         EVAL(H)   WSsr10 = WSysSpotrtN * WRetpD                 BUG23668A BUG23668D
383100200529     C**********         EVAL(H)   WIsr10 = WSysSpotrtInv * WRetpD               BUG23668A BUG23668D
383200200529      **********                                                                  BUG23668 BUG23668D
383300200529      **Obtain*Upper and Lower Limits of Spot rate and Inverse Spot rate          BUG23668 BUG23668D
383400200529      **********                                                                  BUG23668 BUG23668D
383500200529     C**********         EVAL(H)   WSysSpotrtNU = WSysSpotrtN + WSsr10            BUG23668 BUG23668D
383600200529     C**********         EVAL(H)   WSysSpotrtNL = WSysSpotrtN - WSsr10            BUG23668 BUG23668D
383700200529     C**********         EVAL(H)   WSysSpotrtInvU =  WSysSpotrtInv + WIsr1        BUG23668 BUG23668D
383800200529     C**********         EVAL(H)   WSysSpotrtInvL =  WSysSpotrtInv - WIsr1        BUG23668 BUG23668D
383900200529      **********                                                                  BUG23668 BUG23668D
384000200529     C**********         ELSE                                                     BUG23668 BUG23668A
384100200529      **********                                                                  BUG23668 BUG23668A
384200200529      **Obtain*Limits of non-base ccys against the tolerance of base ccy         BUG23668A BUG23668D
384300200529      **********                                                                  BUG23668 BUG23668A
384400200529     C**********         EVAL(H)   WSsr10 = 1 + TOLRAN                            BUG23668 BUG23668A
384500200529     C**********         EVAL(H)   WIsr10 = 1 - TOLRAN                            BUG23668 BUG23668A
384600200529      **********                                                                  BUG23668 BUG23668A
384700200529     C**********         EVAL(H)   WSysSpotrtNU = WSysSpotrtN * WSsr10            BUG23668 BUG23668A
384800200529     C**********         EVAL(H)   WSysSpotrtNL = WSysSpotrtN * WIsr10            BUG23668 BUG23668A
384900200529     C**********         EVAL(H)   WSysSpotrtInvU =  WSysSpotrtInv * WSsr10       BUG23668 BUG23668A
385000200529     C**********         EVAL(H)   WSysSpotrtInvL =  WSysSpotrtInv * WIsr10       BUG23668 BUG23668A
385100200529      **********                                                                  BUG23668 BUG23668A
385200200529     C**********         ENDIF                                                    BUG23668 BUG23668A
385300200529      **********                                                                  BUG23668 BUG23668D
385400200529      **If*rate* is a Multiply,                                                   BUG23668 BUG23668A
385500200529      **If*Upper Limit of Spot rate is greater than the Lower limit of I         BUG23668A BUG23668D
385600200529      **spot*rate, spot rates overlapped                                          BUG23668 BUG23668A
385700200529      **If*rate* is Divide,                                                       BUG23668 BUG23668A
385800200529      **If*Upper limit of Inv. Spot Rt is greater than the Lower limit o          BUG23668 BUG23668D
385900200529      **Normal*Spot rate, spot rates overlapped                                   BUG23668 BUG23668D
386000200529      **********                                                                  BUG23668 BUG23668D
386100200529     C**********         IF        WSysSpotrtNU > WSysSpotrtInvL OR               BUG23668 BUG23668A
386200200529     C**********                   WSysSpotrtInvU > WSysSpotrtNL                  BUG23668 BUG23668A
386300200529      **********                                                                  BUG23668 BUG23668D
386400200529     C**********         IF        WSysSpotrtNU >= WSysSpotrtInvL AND            BUG23668C BUG23668D
386500200529     C**********                   WSysSpotrtInvU >= WSysSpotrtNL                BUG23668C BUG23668D
386600200529      **********                                                                 BUG23668B BUG23668D
386700200529     C**********         IF        WSysSpotrtNL <= WSysSpotrtInvL AND            BUG23668C BUG23668D
386800200529     C**********                   WSysSpotrtNU <= WSysSpotrtInvU                BUG23668C BUG23668D
386900200529      **********                                                                 BUG23668C BUG23668D
387000200529     C**********         IF        @RRATE >= WSysSpotrtInvL AND                  BUG23668C BUG23668D
387100200529     C**********                   @RRATE <= WSysSpotrtNU                        BUG23668C BUG23668D
387200200529     C**********         EVAL      WOverlap = 'Y'                                BUG23668C BUG23668D
387300200529     C**********         EVAL      DDREIN = 'N'                                  BUG23668C BUG23668D
387400200529     C**********         ENDIF                                                   BUG23668C BUG23668D
387500200529      **********                                                                 BUG23668C BUG23668D
387600200529     C**********         ELSE                                                    BUG23668C BUG23668D
387700200529     C**********         IF        WSysSpotrtInvL <= WSysSpotrtNL AND            BUG23668C BUG23668D
387800200529     C**********                   WSysSpotrtInvU <= WSysSpotrtNU                BUG23668C BUG23668D
387900200529      **********                                                                 BUG23668C BUG23668D
388000200529      **If*entered exch rate is within the overlapping range, tag Overlap flag    BUG23668 BUG23668D
388100200529      **and*default recip. rate indicator as 'N' and send warning msg.            BUG23668 BUG23668D
388200200529      **********                                                                  BUG23668 BUG23668D
388300200529     C**********         IF        (WRrateInv  < WSysSpotrtNU AND                 BUG23668 BUG23668A
388400200529     C**********                    WRrateInv  > WSysSpotrtInvL) OR               BUG23668 BUG23668A
388500200529     C**********                   (@RRATE    < WSysSpotrtInvU AND                BUG23668 BUG23668A
388600200529     C**********                    @RRATE     > WSysSpotrtNL)                    BUG23668 BUG23668A
388700200529     C**********         IF        (@RRATE    <= WSysSpotrtInvU AND              BUG23668A BUG23668D
388800200529     C**********                    @RRATE     >= WSysSpotrtNL)                  BUG23668A BUG23668D
388900200529     C**********                    OR                                           BUG23668C BUG23668D
389000200529     C**********                   (@RRATE    <= WSysSpotrtNU   AND              BUG23668C BUG23668D
389100200529     C**********                    @RRATE    >= WSysSpotrtInvL)                 BUG23668C BUG23668D
389200200529     C**********         EVAL      WOverlap = 'Y'                                 BUG23668 BUG23668D
389300200529     C**********         EVAL      DDREIN = 'N'                                   BUG23668 BUG23668D
389400200529     C**********         ELSE                                                    BUG23668C BUG23668D
389500200529     C**********         EVAL      WOverlap = 'N'                                BUG23668C BUG23668D
389600200529     C**********         ENDIF                                                   BUG23668C BUG23668D
389700200529      **********                                                                 BUG23668C BUG23668D
389800200529     C**********         ENDIF                                                    BUG23668 BUG23668D
389900200529     C**********         ENDIF                                                   BUG23668B BUG23668D
390000200529     C**********         ENDIF                                                    BUG23668 BUG23668A
390100200529      **********                                                                  BUG23668 BUG23668D
390200200529      **Send*Message:                                                             BUG23668 BUG23668D
390300200529      **"***WARNING ** Spot Rate and Reciprocal rate of Spot Rate are both close tBUG23668 BUG23668D
390400200529      **********       and overlapped due to the exchange rate range specified....BUG23668 BUG23668D
390500200529      **********                                                                  BUG23668 BUG23668D
390600200529     C**********         IF        WOverlap = 'Y'                                 BUG23668 BUG23668D
390700200529     C**********         EVAL      WIx = WIx + 1                                  BUG23668 BUG23668D
390800200529     C**********         EVAL      WFldNmXAr(WIx) = 'DDREIN'                      BUG23668 BUG23668D
390900200529     C**********         EVAL      WMsgIDXAr(WIx) = 'USR8012'                     BUG23668 BUG23668D
391000200529     C**********         ENDIF                                                    BUG23668 BUG23668D
391100200529      **********                                                                  BUG23668 BUG23668D
391200200529     C**********         ENDSR                                                    BUG23668 BUG23668D
391300200529      *****************************************************************                       CER043
391400200529      /EJECT                                                                                  CER043
391500200529      *****************************************************************                       CER043
391600200529      *                                                               *                       CER043
391700200529      ** FmtAmt - Format amount for display                           *                       CER043
391800200529      *                                                               *                       CER043
391900200529      *  Called by: SrBSAmtCal                                        *                       CER043
392000200529      *                                                               *                       CER043
392100200529      *  Calls: None                                                  *                       CER043
392200200529      *                                                               *                       CER043
392300200529      *****************************************************************                       CER043
392400200529      *                                                                                       CER043
392500200529     C     FMTAMT        BEGSR                                                                CER043
392600200529                                                                                              CER043
392700200529     C**********         CALLB     'ZSEDIT'                                          CER043 BUG21428
392800200529     C**********         PARM                    ZFLD15                              CER043 BUG21428
392900200529     C**********         PARM                    ZDECS                               CER043 BUG21428
393000200529     C**********         PARM      *BLANKS       ZECODE                              CER043 BUG21428
393100200529     C**********         PARM                    ZOUT21                              CER043 BUG21428
393200200529                                                                                              CER043
393300200529     C                   CALLB     'ZA1020'                                                 BUG21428
393400200529     C                   PARM                    ZFLD15                                     BUG21428
393500200529     C                   PARM                    ZCRET                                      BUG21428
393600200529     C                   PARM                    ZDECS                                      BUG21428
393700200529     C                   PARM                    BNDCSP                                     BUG21428
393800200529     C                   PARM                    BNTHSP                                     BUG21428
393900200529     C                   PARM                    ZOUT21                                     BUG21428
394000200529                                                                                            BUG21428
394100200529     C                   EVAL      ZFLD15 = *ZEROS                                            CER043
394200200529                                                                                              CER043
394300200529     C                   ENDSR                                                                CER043
394400200529      *****************************************************************
394500200529      /EJECT
394600200529      *****************************************************************                    BUG23050A
394700200529      * SrOptTake  - Validate option take down                                             BUG23050A
394800200529      *****************************************************************                    BUG23050A
394900200529     C     SrOptTake     BEGSR                                                             BUG23050A
395000200529                                                                                           BUG23050A
395100200529     C     DDDLTP        IFEQ      'OT'                                                    BUG23050A
395200200529     C     S01453        IFEQ      'Y'                                                     BUG23050A
395300200529     C                   Z-ADD     RelOSRT       OPDLAMT          13 8                     BUG23050A
395400200529     C                   ELSE                                                              BUG23050A
395500200529     C                   Z-ADD     RelDXRT       OPDLAMT                                   BUG23050A
395600200529     C                   ENDIF                                                             BUG23050A
395700200529      * Accept only if entered rate is exactly what is on the option deal.                 BUG23050A
395800200529                                                                                           BUG23050A
395900200529     C     @RRATE        IFNE      OPDLAMT                                                 BUG23050A
396000200529     C                   MOVE      'N'           DDRateOK                                  BUG23050A
396100200529     C                   ADD       1             Idx                                       BUG23050A
396200200529     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                            BUG23050A
396300200529     C                   MOVEL     'FXM0140'     MsgIdXAr(Idx)                             BUG23050A
396400200529     C                   ENDIF                                                             BUG23050A
396500200529     C                   ENDIF                                                             BUG23050A
396600200529                                                                                           BUG23050A
396700200529     C                   ENDSR                                                             BUG23050A
396800200529      *****************************************************************                    BUG23050A
396900200529      /EJECT                                                                               BUG23050A
397000200529      * SrDeviation - Get System Deviation                                                 BUG23050A
397100200529      *****************************************************************                    BUG23050A
397200200529     C     SrDeviation   BEGSR                                                             BUG23050A
397300200529                                                                                           BUG23050A
397400200529      *** Get  the highest Exchange rate tolerance                                         BUG23050A
397500200529      *                                                                                    BUG23050A
397600200529     C                   IF        @NEXRT1 >= @NEXRT2                                      BUG23050A
397700200529     C                   EVAL      WRetp = @NEXRT1                                         BUG23050A
397800200529     C                   EVAL      WCcy = DDBCCY                                           BUG23050A
397900200529     C                   ELSE                                                              BUG23050A
398000200529     C                   EVAL      WRetp = @NEXRT2                                         BUG23050A
398100200529     C                   EVAL      WCcy = DDSCCY                                           BUG23050A
398200200529     C                   ENDIF                                                             BUG23050A
398300200529      *                                                                                    BUG23050A
398400200529      *** Compute for system deviation                                                     BUG23050A
398500200529      *                                                                                    BUG23050A
398600200529     C**********         EVAL(H)   WDeviatn =                                     BUG23050A BUG25240
398700200529     C**********                   %ABS(WSysSpotrt-@RRATE) *100 / WSysSpotrt      BUG23050A BUG25240
398800200529      *                                                                                     BUG25284
398900200529     C                   IF        DDREIN = 'Y'                                             BUG25284
399000200529     C                   EVAL(H)   WDeviatn =                                               BUG25240
399100200529     C                             %ABS(WSysSpotrt-@RRATE1) *100 / WSysSpotrt               BUG25240
399200200529     C                   ELSE                                                               BUG25284
399300200529     C                   EVAL(H)   WDeviatn =                                               BUG25284
399400200529     C                             %ABS(WSysSpotrt-@RRATE) *100 / WSysSpotrt                BUG25284
399500200529     C                   ENDIF                                                              BUG25284
399600200529                                                                                           BUG23050A
399700200529     C                   IF        WDeviatn > WRetp                                        BUG23050A
399800200529     C                   EVAL      WIx = WIx + 1                                           BUG23050A
399900200529     C                   EVAL      WFldNmXAr(WIx) = 'DDRAT1'                               BUG23050A
400000200529     C                   EVAL      WMsgIDXAr(WIx) = 'USR8007'                              BUG23050A
400100200529     C                   EVAL      WRK1 = DDBCCY                                           BUG23050A
400200200529     C                   EVAL      WRK2 = DDSCCY                                           BUG23050A
400300200529     C                   EVAL      WRK3 = %CHAR(WDeviatn)                                  BUG23050A
400400200529     C                   IF        WRetp = *ZERO                                            BUG23579
400500200529     C                   EVAL      WRK4 = '0      '                                         BUG23579
400600200529     C                   ELSE                                                               BUG23579
400700200529     C                   EVAL      WRK4 = %CHAR(WRetp)                                     BUG23050A
400800200529     C                   ENDIF                                                              BUG23579
400900200529     C                   EVAL      WRK5 = WCcy                                             BUG23050A
401000200529     C**********         EVAL      WMsgDtXAr(WIx) = DSWRK                         BUG23050A MD000091
401100200529     C                   EVAL      BLen = %Len(%Trim(WRK1))                                 MD000091
401200200529     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(WRK1)                     MD000091
401300200529     C                   EVAL      BLen = %Len(%Trim(WRK2))                                 MD000091
401400200529     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
401500200529     C                                            + LenStr +%TRIM(WRK2)                     MD000091
401600200529     C                   EVAL      BLen = %Len(%Trim(WRK3))                                 MD000091
401700200529     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
401800200529     C                                            + LenStr +%TRIM(WRK3)                     MD000091
401900200529     C                   EVAL      BLen = %Len(%Trim(WRK4))                                 MD000091
402000200529     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
402100200529     C                                            + LenStr +%TRIM(WRK4)                     MD000091
402200200529     C                   EVAL      BLen = %Len(%Trim(WRK5))                                 MD000091
402300200529     C                   EVAL      WMsgDtXAr(WIx) = %TRIM(WMsgDtXAr(WIx))                   MD000091
402400200529     C                                            + LenStr +%TRIM(WRK5)                     MD000091
402500200529     C                   ENDIF                                                             BUG23050A
402600200529                                                                                           BUG23050A
402700200529     C                   ENDSR                                                             BUG23050A
402800200529      *****************************************************************                    BUG23050A
402900200529      *****************************************************************
403000200529      * *INZSR - Program Initialisation routine                       *
403100200529      *****************************************************************
403200200529     C     *INZSR        BEGSR
403300200529
403400200529     C     *ENTRY        PLIST
403500200529      *
403600200529      * INPUTS
403700200529      *
403800200529      ** Return Code
403900200529     C                   PARM                    RetCodeIn
404000200529      *
404100200529      ** Deal Screen fields
404200200529     C                   PARM                    DDACTN            1            action code   CER043
404300200529     C                   PARM                    DDDLTP            2            deal type     CER043
404400200529     C                   PARM                    DDBAMT           14            buy amount    CER043
404500200529     C                   PARM                    DDSAMT           14            sell amount   CER043
404600200529     C                   PARM                    DDBCCY            3            buy ccy
404700200529     C                   PARM                    DDSCCY            3            sell ccy
404800200529      *
404900200529      ** Related deal details
405000200529     C                   PARM                    RelDealDts                     SW/OP branch  CER043
405100200529      *
405200200529     C                   PARM                    W@INRT           13 8          scaled exch rate
405300200529     C                   PARM                    @@INRT           13 8          rate + fwd pts
405400200529     C**********         PARM                    @@INRTR          13 8            BUG23050A BUG23668
405500200529     C                   PARM                    @@FPNT            7 2          forward points
405600200529     C                   PARM                    @@MGPT            7 2          margin points
405700200529      *
405800200529     C                   PARM                    F3DAM1           15 0          amount
405900200529      *
406000200529     C                   PARM                    @SPOT1           13 8          spot rate
406100200529     C                   PARM                    @CDP1             1 0          no of dec places
406200200529     C                   PARM                    @RDCY1            1            round down
406300200529     C                   PARM                    @@NDP1            1 0          norm quot decs
406400200529     C                   PARM                    @@SXP1                         scaling exponent
406500200529     C                   PARM                    @@MDF1            1            mult/div ind
406600200529     C                   PARM                    @NEXRT1           5 2                     BUG23050A
406700200529      *
406800200529     C                   PARM                    F3DAM2           15 0          amount
406900200529      *
407000200529     C                   PARM                    @SPOT2           13 8          spot rate
407100200529     C                   PARM                    @CDP2             1 0          no of dec places
407200200529     C                   PARM                    @RDCY2            1            round down
407300200529     C                   PARM                    @@NDP2            1 0          norm quot decs
407400200529     C                   PARM                    @@SXP2                         scaling exponent
407500200529     C                   PARM                    @@MDF2            1            mult/div ind
407600200529     C                   PARM                    @NEXRT2           5 2                     BUG23050A
407700200529      *                                                                                       238023
407800200529     C                   PARM                    F3MGBS            1            marg indicator238023
407900200529      *                                                                                       CER043
408000200529      ** Reciprocal rate indicator, exchange rate                                             CER043
408100200529      *                                                                                       CER043
408200200529      ** INPUT/OUTPUT                                                                       BUG23050
408300200529     C                   PARM                    DDREIN                                       CER043
408400200529      *
408500200529      ** ICD
408600200529     C                   PARM                    BJCYCD            3
408700200529     C                   PARM                    BNCYDL            3
408800200529     C                   PARM                    BNEXRT            3 1
408900200529     C                   PARM                    BNDCSP            1
409000200529     C                   PARM                    S01391            1
409100200529     C                   PARM                    S01453            1
409200200529      *
409300200529      * OUTPUTS
409400200529      *
409500200529      * Error fields/message IDs/message data (arrays) from/to caller
409600200529     C                   PARM                    FldNamXAr
409700200529     C                   PARM                    MsgIDXAr
409800200529     C                   PARM                    MsgDtaXAr
409900200529     C                   PARM                    WFldNmXAr
410000200529     C                   PARM                    WMsgIDXAr
410100200529     C                   PARM                    WMsgDtXAr
410200200529      *
410300200529      ** Buy Amount - OK
410400200529      ** Sell Amount - OK
410500200529      ** Rate - OK
410600200529     C                   PARM                    DDBamtOK          1
410700200529     C                   PARM                    DDSamtOK          1
410800200529     C                   PARM                    DDRateOK          1
410900200529      *
411000200529      ** Multiply/Div Ind, Exchange Rate
411100200529      ** Descaled Exchange Rate, Rate+Mgn+Fwd Pts, Rate+Fwd Pts
411200200529      *
411300200529     C                   PARM                    F3DMD1            1            mult/div ind
411400200529     C                   PARM                    F3DXRT           13 8          exch rate
411500200529     C                   PARM                    @SRATE           13 8          Descaled exch rt
411600200529     C                   PARM                    @RRATE           13 8          Rate+mgn+fwd pts
411700200529     C                   PARM                    @XRATE           13 8          Rate+fwd pts
411800200529     C**********         PARM                    F3OSRT           13 8            BUG23050A BUG23668
411900200529      *
412000200529      ** WORK OUT TOLERANCE AS A PERCENTAGE
412100200529      *
412200200529     C     BNEXRT        DIV       100           TOLRAN            3 3
412300200529      *
412400200529      ** Check if any one of the CCY is round down CCY, and whether JSM
412500200529      ** had been set on.  If so, checking should use the calculated
412600200529      ** amount to test for 1 unit tolerance.
412700200529      *
412800200529     C     S01391        IFEQ      'Y'
412900200529     C     @RDCY1        ANDEQ     'Y'
413000200529     C     S01391        OREQ      'Y'
413100200529     C     @RDCY2        ANDEQ     'Y'
413200200529     C                   MOVEL     'Y'           @ROUND            1
413300200529     C                   ELSE
413400200529     C                   MOVEL     'N'           @ROUND            1
413500200529     C                   END
413600200529     C/COPY WNCPYSRC,FXH00017
413700200529      *                                                                                       CER043
413800200529      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
413900200529      *                                                                                       CER043
414000200529     C                   EVAL      CER043 = 'N'                                               CER043
414100200529     C                   CALLB     'AOSARDR0'                                                 CER043
414200200529     C                   PARM      *BLANKS       PRTCD                                        CER043
414300200529     C                   PARM      '*VERIFY'     POPTN                                        CER043
414400200529     C                   PARM      'CER043'      PSARD                                        CER043
414500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
414600200529                                                                                              CER043
414700200529     C                   IF        PRTCD <> *BLANKS AND                                       CER043
414800200529     C                             PRTCD <> '*NRF   '                                         CER043
414900200529     C     *LOCK         IN        LDA                                                        CER043
415000200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
415100200529     C                   EVAL      DBASE = 1                                                  CER043
415200200529     C                   EVAL      DBKEY = 'CER043'                                           CER043
415300200529     C                   OUT       LDA                                                        CER043
415400200529     C                   EXSR      *PSSR                                                      CER043
415500200529     C                   ENDIF                                                                CER043
415600200529                                                                                              CER043
415700200529     C                   IF        PRTCD = *BLANKS                                            CER043
415800200529     C                   EVAL      CER043 = 'Y'                                               CER043
415900200529     C                   ENDIF                                                                CER043
416000200529     C/COPY OFCPYSRCZ,CDL091_011                                                              CDL091
416100200529      *
416200200529      ** Program, module and procedure names for database error processing.
416300200529      ** =================================================================
416400200529      ** The following /COPY sets these values, and also defines LDA as
416500200529      ** an external data area
416600200529
416700200529     C/COPY ZACPYSRC,DBFIELDS
416800200529
416900200529     C                   ENDSR
417000200529      *****************************************************************
417100200529      /EJECT
417200200529      ********************************************************************
417300200529     C/COPY ZACPYSRC,PSSR_ILE
417400200529      ********************************************************************
417500200529**  CPY@
417600200529(c) Finastra International Limited 2001
417700200529**   @@AY   - Array of powers of 10.
4178002005290000000001
4179002005290000000010
4180002005290000000100
4181002005290000001000
4182002005290000010000
4183002005290000100000
4184002005290001000000
4185002005290010000000
4186002005290100000000
4187002005291000000000
418800200529** Scaling factors array - @SF
4189002005290000000001
4190002005290000000010
4191002005290000000100
4192002005290000001000
4193002005290000010000
4194002005290000100000
4195002005290001000000
4196002005290010000000
4197002005290100000000
4198002005291000000000
419900200529** @AD Adjust Decimals (for applying NQDP)
420000200529000000010
420100200529000000100
420200200529000001000
420300200529000010000
420400200529000100000
420500200529001000000
420600200529010000000
420700200529100000000
420800200529**   POW - POWERS OF 10
4209002005290000001
4210002005290000010
4211002005290000100
4212002005290001000
4213002005290010000
4214002005290100000
4215002005291000000
