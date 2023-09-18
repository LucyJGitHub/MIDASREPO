000100230913     H DEBUG
000200230913     H COPYRIGHT('(c) Finastra International Limited 2002')
000300230913      *****************************************************************
000400230913/*XBIA*  OVRDBF FILE(OTPAYOVR) TOFILE(OTPAY) SHARE(*NO)               *                       CAP211
000500230913/*XBIB*  OVRDBF FILE(OTXL0) TOFILE(OTPAYXL0) SHARE(*NO)               *                       CAP211
000600230913/*STD *  RPGBASEMOD                                                   *
000700230913/*EXI *  TEXT('Midas FT Incoming payments database update')           *
000800230913      *****************************************************************
000900230913      *                                                               *
001000230913      *  Midas - Funds Transfer Module                                *
001100230913      *                                                               *
001200230913      *  FTIPAYUPD - Incoming Payments Database Update                *
001300230913      *                                                               *
001400230913      *  Function: This module performs the update of Midas database. *
001500230913      *                                                               *
001600230913      *  Component of: FTIPAYSIN                                      *
001700230913      *                FTIPAYRPR                                      *
001800230913      *                FTIPAYUPP                                      *
001900230913      *                                                               *
002000230913      *  (c) Finastra International Limited 2001                      *
002100230913      *                                                               *
002101230913      *  Last Amend No. BA5021             Date 15Aug23               *
002200230913      *  Prev Amend No. MD060066           Date 30Jun22               *
002300230913      *                 MD059420           Date 28Apr22               *
002400230913      *                 MD058914           Date 06Oct21               *
002500230913      *                 CSD103             Date 10Aug20               *
002600230913      *                 MD048586           Date 11Jan21               *
002700230913      *                 AR1088819          Date 03Jun20               *
002800230913      *                 MD020135           Date 03Jun20               *
002900230913      *                 CSW220             Date 09Mar20               *
003000230913      *                 MD054037           Date 23Sep19               *
003100230913      *                 CSD102             Date 08Jan19               *
003200230913      *                 MD046248           Date 27Oct17               *
003300230913      *                 MD037804           Date 25May16               *
003400230913      *                 AR924677           Date 03Nov14               *
003500230913      *                 MD030940           Date 08Oct14               *
003600230913      *                 CFT157             Date 29Aug14               *
003700230913      *                 MD029681           Date 12Aug14               *
003800230913      *                 CFT151             Date 21Mar14               *
003900230913      *                 AR1084524          Date 13Feb13               *
004000230913      *                 CFT120             Date 28Sep12               *
004100230913      *                 BUG12944A          Date 28Sep12               *
004200230913      *                 CAP211             Date 28Sep12               *
004300230913      *                 261468             Date 10Aug12               *
004400230913      *                 CLE134             Date 01Aug12               *
004500230913      *                 AR787620           Date 10Jun11               *
004600230913      *                 CRE075             Date 06Dec10               *
004700230913      *                 BUG23088           Date 26Feb09               *
004800230913      *                 CER030             Date 09Jul08               *
004900230913      * Bank Fusion Midas 1.4 Base -----------------------------------*
005000230913      *                 CAP205             Date 03Mar10               *
005100230913      *                 CAP204             Date 09Feb10               *
005200230913      *                 260326             Date 18Jun09               *
005300230913      *                 CSW209             Date 01Apr09               *
005400230913      * Midas Plus 1.4 Base 04 ---------------------------------------*
005500230913      *                 257487             Date 04Nov08               *
005600230913      *                 256564             Date 17Sep08               *
005700230913      *                 238060             Date 25Sep07               *
005800230913      *                 BUG14585           Date 15Aug07               *
005900230913      *                 247277             Date 24May07               *
006000230913      *                 BUG13159           Date 29Jan07               *
006100230913      * Midas Plus 1.3 ----------- Base ------------------------------*
006200230913      *                 241810A            Date 04Sep06               *
006300230913      *                 241810             Date 29Aug06               *
006400230913      *                 CFT032             Date 11Sep06               *
006500230913      *                 CSD031             Date 10Apr06               *
006600230913      *                 219734             Date 06Jun06               *
006700230913      *                 CDL049             Date 06Jul06               *
006800230913      *                 240663             Date 29Jun06               *
006900230913      *                 240008             Date 23May06               *
007000230913      *                 208944             Date 18Sep01               *
007100230913      *                 237564             Date 21Jun06               *
007200230913      *                 CSD027             Date 09Dec05               *
007300230913      *                 CSW037A            Date 02May05               *
007400230913      *                 CSD025             Date 11Jan05               *
007500230913      *                 CSW037             Date 15Dec04               *
007600230913      *                 CSW036             Date 15Dec04               *
007700230913      *                 BUG4776            Date 15Nov04               *
007800230913      *                 BUG4556            Date 19Oct04               *
007900230913      *                 CFT115             Date 01Jul04               *
008000230913      *                 BUG3854            Date 27Jul04               *
008100230913      *                 BUG3821            Date 27Jul04               *
008200230913      *                 CLE025             Date 20Oct03               *
008300230913      *                 CRE020             Date 20Jan04               *
008400230913      *                 CGL029             Date 01Sep03               *
008500230913      *                 CGP001             Date 09Dec03               *
008600230913      *                 CAP084             Date 25Aug03               *
008700230913      *                 223687             Date 16Dec03               *
008800230913      *                 CSD015             Date 14Oct02               *
008900230913      * Midas Release 4.01.03 ----------------------------------------*
009000230913      * Midas Release 4.01 -------------------------------------------*
009100230913      *                 CSC011             Date 18Sep01               *
009200230913      *                 193883             Date 20Nov01               *
009300230913      * Midas Release 4 --------------- Base -------------------------*
009400230913      * Midas DBA 3.05 -----------------------------------------------*
009500230913      *                 CFT009             Date 13Nov00               *
009600230913      * Midas DBA 3.04 -----------------------------------------------*
009700230913      *                 185764             Date 01Nov00               *
009800230913      *                 CFT014             Date 25May99               *
009900230913      * Midas DBA 3.03 -----------------------------------------------*
010000230913      *                 CAP136  *CREATE    Date 15Nov99               *
010100230913      *                                                               *
010200230913      *---------------------------------------------------------------*
010300230913      *                                                               *
010301230913      *  BA5021 - Suppress Settlement Shadow Postings Generation      *
010302230913      *           Upgrade GLW021.                                     *
010400230913      *  MD060066 - MT202 message not generated for MT103 transactions*
010500230913      *             Add reversal of FTM199 for Stop of Incoming Pay-  *
010600230913      *             ment transaction.                                 *
010700230913      *  MD059420 - Input user is not set on insertion through        *
010800230913      *             the API with AUTH='N'                             *
010900230913      *  MD058914 - FT payments customer information on listviews     *
011000230913      *             is blank. Amend to add routine to retrieve        *
011100230913      *             Customer and Branch for INPAYDQD/OTPAYDQD.        *
011200230913      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
011300230913      *           (Recompile)                                         *
011400230913      *  MD048586 - Remove conditions for executing SRCLR             *
011500230913      *           - Applied for MD-57430.                             *
011600230913      *  AR1088819 - Issue on job names during SSL enabling of JDBC   *
011700230913      *              calls                                            *
011800230913      *            - Applied for MD050405                             *
011900230913      *  MD020135 - Duplicate records in INPAYDQD. Write to INPAYDQD  *
012000230913      *             file only if not from Java screen.                *
012100230913      *            - Applied for MD050405                             *
012200230913      *  CSW220 - SWIFT Changes 2020                                  *
012300230913      *  MD054037 - Outward payment routing from incoming (OPIN = Y)  *
012400230913      *             via API                                           *
012500230913      *  CSD102 - Password Length Extension (Recompile)               *
012600230913      *  MD046248 - Finastra Rebranding                               *
012700230913      *  MD037804 - Unnecessary DUMP produced by FTIPAYUPD module     *
012800230913      *  AR924677 - Amend of an authorized payment should return it   *
012900230913      *             to an unauthorized state. (Child: AR924679)       *
013000230913      *  MD030940 - (CFT157) Error when inserting new payment.        *
013100230913      *  CFT157 - Stop FT Transaction after Authorisation.            *
013200230913      *  MD029681 - Serious Midas Error occurreddue to *LDA lock      *
013300230913      *             being not granted                                 *
013400230913      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
013500230913      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
013600230913      *              (Recompile)                                      *
013700230913      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
013800230913      *  BUG12944A - FTC0510 00001 Failed                             *
013900230913      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
014000230913      *  261468 - Multiple access of the same payment should not be   *
014100230913      *           allowed                                             *
014200230913      *  CLE134 - Past Due Call Loan Processing                       *
014300230913      *  AR787620 - Hooks Incorporation                               *
014400230913      *             WNCPYSRC,FTH00104                                 *
014500230913      *             WNCPYSRC,FTH00102                                 *
014600230913      *             WNCPYSRC,FTH00108                                 *
014700230913      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
014800230913      *  BUG23088- Transactions using non-retail A/C format did not   *
014900230913      *           appear in the postings                              *
015000230913      *  CER030 - Multicash German Feature (Recompile)                *
015100230913      *  CAP205 - Teller Related APIs - Account Balance Check         *
015200230913      *  CAP204 - Teller Related APIs - Account Transfer              *
015300230913      *  260326 - Incorrect restoration of canceled ref seq number.   *
015400230913      *  CSW209 - SWIFT 2009 Changes                                  *
015500230913      *  257487 - Write to Incoming Payments extension file INPAYDQD  *
015600230913      *  256564 - Recompile due to PF changes done by fix 256330      *
015700230913      *  238060 - Update the timestamp field for extension file       *
015800230913      *           INPAYXPD with the correct value                     *
015900230913      * BUG14585 - Data for Auto is missing in Awaiting for           *
016000230913      *            Authorisation Enquiry                              *
016100230913      *  247277 - Allow for native JDBC driver as well as toolbox.    *
016200230913      * BUG13159 - After a successful update, the latest timestamp    *
016300230913      *            is not being passed back to the Java side. This    *
016400230913      *            later causes the WIP entry becoming impossible     *
016500230913      *            to authorise due to discrepancy between the        *
016600230913      *            timestamp initially stored in the WIP (which is    *
016700230913      *            incorrect) and the latest timestamp retreived from *
016800230913      *            INPAYDD when the amendment is being authorised.    *
016900230913      *            The timestamp in INPAYXPD is also not being        *
017000230913      *            updated properly.                                  *
017100230913      *            This actually is a lacking aspect of the fix done  *
017200230913      *            for BUG4196.                                       *
017300230913      *  241810A- Reverse fix 241810.                                 *
017400230913      *  241810 - Authorise indicator and authorising user are not    *
017500230913      *           updated when transaction has been authorised.       *
017600230913      *  CFT032 - Account Line in Field 50X in MT103                  *
017700230913      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
017800230913      *           Include conversion of customer number to alpha.     *
017900230913      *  219734 - Authorising User profile should be reset when a     *
018000230913      *           payment is amended.                                 *
018100230913      *           Applied fix 208944, annotated as 208944.            *
018200230913      *  CDL049 - Addition of a Reference Rate field (recompile)      *
018300230913      *  240663 - Applied fix 229560.                                 *
018400230913      *  229560 - Dbase error when Beneficiary = IBAN and Add/Deduct. *
018500230913      *  240008 - Proj Ac update for partial a/c nos still wrong      *
018600230913      *         - Set-up parameter before calling AOSPOSU0. Patterned *
018700230913      *           from BUG3194.                                       *
018800230913      *  208944 - Reset authorizing profile on amend.                 *
018900230913      *  237564 - Shadow posting is incorrect when IBAN is used as    *
019000230913      *           Beneficiary input.                                  *
019100230913      *  CSD027 - Conversion Of Customer Number to Alpha              *
019200230913      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
019300230913      *  CSD025 - Customer De-Activation                              *
019400230913      *  CSW037 - Additional Field Data on MT300/MT320                *
019500230913      *  CSW036 - Dual SWIFT BIC held on Client Details               *
019600230913      *  BUG4776- Correct skipping of transaction reference.          *
019700230913      *  BUG4556- CWLCHECK job fails due to incorrect XML end tag     *
019800230913      *           for <A/C with Bank> tag.  Changed tag from          *
019900230913      *           </A/C with Bank > to </A/C with Bank>.              *
020000230913      *  CFT115 - Core changes for GBO015.                            *
020100230913      *           Incoming Payments Beneficiary Validation            *
020200230913      *                  - Upgrade to Midasplus                       *
020300230913      *           Core hooks amended:FTIPAYDC05,FTIPAYDF02,FTIPAYDC03,*
020400230913      *                              FTIPAYDD01,                      *
020500230913      *           Core hooks added:FTIPAYDC22,FTIPAYDC23,FTIPAYDC24   *
020600230913      *  BUG3854 - Shadow postings to partial accounts incorrect      *
020700230913      *  BUG3821 - Shadow postings incorrect due to 10 digit a/c code *
020800230913      *  CLE025 - Credit Lines (Recompile)                            *
020900230913      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
021000230913      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
021100230913      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
021200230913      *  CAP084 - Thin Client API Wrappers                            *
021300230913      *           Bypass setting of PModeX to '*FRONT' if module      *
021400230913      *           is called from Midas Plus interface.                *
021500230913      *  223687 - FTIPAYUPD ends in DBERR in a system without         *
021600230913      *           Compliance Watch feature. Ensure CSD015 is ON prior *
021700230913      *           to calling Compliance Watch programs.               *
021800230913      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
021900230913      *  CSC011 - 24x7 Midas Availability                             *
022000230913      *  193883 - To avoid DBerr set-up Front ID correctly.           *
022100230913      *  CFT009 - Funds Transfer Fees and Charges                     *
022200230913      *  185764 - Shadow posting for charges are not updated.         *
022300230913      *  CFT014 - Straight-through Processing Phase 2 MT103           *
022400230913      *           Messages Generation for FT.                         *
022500230913      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
022600230913      *           modular structure to use as APIs.                   *
022700230913      *                                                               *
022800230913      *****************************************************************
022900230913      *
023000230913      ** +--------------------------------------+
023100230913      ** ¦ F-specs                              ¦
023200230913      ** ¦ =======                              ¦
023300230913      ** +--------------------------------------+
023400230913      *
023500230913      ** Incoming Payments file
023600230913     FINPAY     UF A E           K DISK    COMMIT
023700230913      *
023800230913      ** Incoming Payments trailer file
023900230913     FINPAYZZ   UF   E             DISK    COMMIT
024000230913      *
024100230913      ** Incoming Payments extension file
024200230913     FINPAYXL0  UF A E           K DISK    COMMIT
024300230913     FINPAYDQD  O    E             DISK    COMMIT                                             257487
024400230913      *                                                                                       CAP211
024500230913      ** Outgoing Payments file                                                               CAP211
024600230913      *                                                                                       CAP211
024700230913     FOTPAYOVR  UF A E           K DISK    COMMIT                                             CAP211
024800230913      *                                                                                       CAP211
024900230913      ** Outgoing Payments trailer file                                                       CAP211
025000230913      *                                                                                       CAP211
025100230913     FOTPAYZZ   UF   E             DISK    COMMIT PREFIX(O)                                   CAP211
025200230913      *                                                                                       CAP211
025300230913      ** Outgoing Payments extension file                                                     CAP211
025400230913      *                                                                                       CAP211
025500230913     FOTXL0     UF A E           K DISK    COMMIT                                             CAP211
025600230913      *                                                                                       CAP211
025700230913     FOTPAYDQD  O    E             DISK    COMMIT                                             CAP211
025800230913      *                                                                                       CAP211
025900230913     F/COPY WNCPYSRC,FTIPAYDF01
026000230913      *
026100230913      ** Accounts file
026200230913     FACCNT     IF   E           K DISK    INFSR(*PSSR)
026300230913     F                                     IGNORE(ACCNTAAF)
026400230913     F                                     IGNORE(ACCNTACF)
026500230913     F                                     PREFIX(AC)
026600230913      *
026700230913      ** Retail Accounts file
026800230913     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
026900230913     F                                     RENAME(ACCNTABF:ACNUMABF)
027000230913     F                                     PREFIX(AC)
027100230913                                                                                              CSD015
027200230913      ** Compliance Watch Hit List File                                                       CSD015
027300230913     FSDCWHTL1  IF   E           K DISK    COMMIT                                             CSD015
027400230913      *
027500230913     F*FTPREFL0**UF*A*E*************DISK*** COMMIT                                    BUG4776 260326
027600230913      *****************************************************************               BUG4776 260326
027700230913     F/COPY WNCPYSRC,FTIPAYDF02
027800230913      *****************************************************************
027900230913      /EJECT
028000230913      *****************************************************************
028100230913      *
028200230913      ** +--------------------------------------+
028300230913      ** ¦ Automatically included D-specs       ¦
028400230913      ** ¦ ==============================       ¦
028500230913      ** +--------------------------------------+
028600230913      *
028700230913      ** Standard D-specs
028800230913      ** ================
028900230913      **
029000230913      ** The following /COPY line includes the LDA layout,
029100230913      ** the copyright array definition,
029200230913      ** and the following named constants:
029300230913      **    True       logical = *on (for indicator processing)
029400230913      **    False      logical = *off (for indicator processing)
029500230913      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
029600230913      **                                    handler)
029700230913      ** and the following variables:
029800230913      **    RunBefore  1A (for the PSSR)
029900230913      *
030000230913      /COPY ZACPYSRC,STD_D_SPEC
030100230913      *
030200230913      ** Program Status Data Structure
030300230913      ** =============================
030400230913      ** The following /COPY line includes all the defined fields in the
030500230913      ** PSDS.  They have meaningful names, Prefixed by 'PS'.
030600230913      *
030700230913      /COPY ZACPYSRC,PSDS
030800230913      *
030900230913      ** The following /COPY line includes all the definitions of the
031000230913      ** appended error arrays, including the named constant giving the size
031100230913      ** of the arrays.
031200230913      *
031300230913      /COPY ZACPYSRC,ERR_ARRAYS
031400230913      *
031500230913      ** +--------------------------------------+
031600230913      ** ¦ End of automatically included D-specs¦
031700230913      ** ¦ =====================================¦
031800230913      ** +--------------------------------------+
031900230913      *
032000230913      *****************************************************************
032100230913      /EJECT
032200230913      *****************************************************************
032300230913      *
032400230913      ** +--------------------------------------+
032500230913      ** ¦ Manually included D-specs            ¦
032600230913      ** ¦ =========================            ¦
032700230913      ** +--------------------------------------+
032800230913      *
032900230913      ** +--------------------------------------+
033000230913      ** ¦ Named constants                      ¦
033100230913      ** ¦ ===============                      ¦
033200230913      ** +--------------------------------------+
033300230913      *                                                                                       CAP211
033400230913      ** System value of flag for Auto-Generation of Outgoing Payment                         CAP211
033500230913      *                                                                                       CAP211
033600230913     D SysValGOP       C                   CONST('CAP211GenerateOP')                          CAP211
033700230913      *
033800230913      ** +--------------------------------------+
033900230913      ** ¦ Arrays and Data Structures           ¦
034000230913      ** ¦ ==========================           ¦
034100230913      ** +--------------------------------------+
034200230913      *
034300230913      ** Incoming Payments for file update - Valid file format
034400230913     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
034500230913      *                                                                         CFT014
034600230913      ** Incoming Payments Extension for file update - file format              CFT014
034700230913     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
034800230913     D/COPY WNCPYSRC,FTH00164
034900230913      *
035000230913      ** Incoming Payments for file update - Midas file format
035100230913     D InPayUpdF     E DS                  EXTNAME(INPAYDD)
035200230913      *
035300230913      ** Incoming Payments retrieved from file - file format
035400230913     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
035500230913     D                                     PREFIX(CH)
035600230913      *                                                                         CFT014
035700230913      ** Incoming Payments Extension for file update - file format              CFT014
035800230913     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD)                    CFT014
035900230913      *
036000230913      ** Incoming Message FT data
036100230913     D PINFT         E DS                  EXTNAME(MEINFTPD)
036200230913     D/COPY WNCPYSRC,FTIPAYDD02
036300230913      *
036400230913      ** Incoming Message Log data
036500230913     D PINLF         E DS                  EXTNAME(MEINLFPD)
036600230913      *
036700230913      ** Externally described DS for Nostro details
036800230913     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
036900230913      *                                                                                       CRE020
037000230913     D/COPY WNCPYSRC,FTH00104
037100230913      ** Midas Switchable features file accessed via access program                           CRE020
037200230913     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
037300230913     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
037400230913      *                                                                                       CAP211
037500230913      ** Externally described DS for Bank details                                             CAP211
037600230913      *                                                                                       CAP211
037700230913     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CAP211
037800230913      *                                                                                       CAP211
037900230913      ** Externally described DS for Currency details                                         CAP211
038000230913      *                                                                                       CAP211
038100230913     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CAP211
038200230913      *                                                                                       CAP211
038300230913      ** Externally described DS for Branch details                                           CAP211
038400230913      *                                                                                       CAP211
038500230913     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CAP211
038600230913     D  A8QQDFAC     E                     EXTFLD(QQDFAC)                                     CAP211
038700230913      *                                                                                       CAP211
038800230913      ** Externally described DS for FT ICD details                                           CAP211
038900230913      *                                                                                       CAP211
039000230913     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                                  CAP211
039100230913      *                                                                                       CAP211
039200230913      ** Data area                                                                            CAP211
039300230913      *                                                                                       CAP211
039400230913     D*OTPAYD***     E DS                  EXTNAME(OTPAYDA)                            CAP211 CFT151
039500230913     D OTPAYD          DS             4                                                       CFT151
039600230913     D  WOTSQ                  1      4  0                                                    CFT151
039700230913                                                                                              CFT151
039800230913      *                                                                         CFT014
039900230913      ** Externally described DS for Nostro details                             CFT014
040000230913     D P@ACCN        E DS                  EXTNAME(ACCNTAB)                     CFT014
040100230913     D  IBNRECI      E                     EXTFLD(RECI)                         CFT014
040200230913     D  IBNBRCA      E                     EXTFLD(BRCA)                         CFT014
040300230913     D  IBNPRFC      E                     EXTFLD(PRFC)                         CFT014
040400230913     D  IBNLCD       E                     EXTFLD(LCD)                          CFT014
040500230913     D  IBNCHTP      E                     EXTFLD(CHTP)                         CFT014
040600230913     D  IBNFRNT      E                     EXTFLD(FRNT)                         CFT014
040700230913     D  IBNAFRT      E                     EXTFLD(AFRT)                         CFT014
040800230913     D  IBNREPA      E                     EXTFLD(REPA)                         CFT014
040900230913     D  IBNTMST      E                     EXTFLD(TMST)                         CFT014
041000230913     D  IBNREPI      E                     EXTFLD(REPI)                         CFT014
041100230913      ** DS for access programs - Short data structure
041200230913     D DSFDY         E DS                  EXTNAME(DSFDY)
041300230913      *                                                                         CFT014
041400230913      ** DS for access programs - Second data structure                         CFT014
041500230913     D DSSDY         E DS                  EXTNAME(DSSDY)                       CFT014
041600230913                                                                                              CSC011
041700230913      ** Message Header Data Layout                                                           CSC011
041800230913     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
041900230913                                                                                              CSC011
042000230913      ** 24X7 Status DataArea Layout                                                          CSC011
042100230913     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
042200230913                                                                                              CSC011
042300230913      ** SD Status DataArea Layout                                                            CSC011
042400230913     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
042500230913      *
042600230913     D/COPY WNCPYSRC,FTIPAYDD01
042700230913      ** FT Control Data
042800230913     D PCNTRL          DS           256
042900230913     D  WPDTI                  1      1
043000230913     D  WCCYI                  2      3
043100230913     D  WGLUI                  4      4
043200230913     D  WTPCI                  5      5
043300230913      *
043400230913      ** Calling parameter data structure for AOSPOSU0
043500230913     D C_DTA           DS           256
043600230913     D  C_ATYP                 1      1
043700230913     D**C_ACCT**               2     19                                                       CGL029
043800230913     D**C_CNU1**               2      7  0                                                    CSD027
043900230913     D  C_CNU1                 2      7A                                                      CSD027
044000230913     D  C_CCY1                 8     10
044100230913     D**C_ACO1**              11     14  0                                                    CGL029
044200230913     D  C_ACS1                15     16  0
044300230913     D  C_BRC1                17     19
044400230913     D  C_NOSN                 2      3  0
044500230913     D  C_NOS                  2      6
044600230913     D  C_ACNO                 2     11  0
044700230913     D**C_CNUM**               2      7  0                                                    CSD027
044800230913     D  C_CNUM                 2      7A                                                      CSD027
044900230913     D**C_ACOD**               8     11  0                                                    CGL029
045000230913     D  C_ACSQ                12     13  0
045100230913     D  C_BRCA                14     16
045200230913     D  C_IO                  24     24
045300230913     D  C_CCY                 25     27
045400230913     D  C_TRYP                28     29
045500230913     D  C_NARR                30     59
045600230913     D  C_CHQN                60     67  0
045700230913     D  C_PRef                68     82
045800230913     D  C_TRN                 83     88
045900230913     D  C_AMT                 89     96P 0
046000230913     D  C_PRON                97     97
046100230913     D  C_OLPS                98     98
046200230913     D  C_MEMS                99     99
046300230913     D  C_RSAC               100    100
046400230913     D  C_MOD                101    102
046500230913     D  C_OLRC               103    104
046600230913     D  C_FTOV               105    105
046700230913     D  C_VDAT               106    108P 0
046800230913     D  C_PSTD               109    111P 0
046900230913     D  C_PSTO               112    112
047000230913     D  C_RPST               113    113
047100230913     D  C_RPNB               114    116  0
047200230913     D  C_RTYP               117    117
047300230913     D  C_BBRN               118    120  0                                                    CGL029
047400230913     D  C_ACO1               121    130  0                                                    CGL029
047500230913     D  C_ACOD               131    140  0                                                    CGL029
047600230913     D  C_OTR1               141    160                                                       CAP204
047700230913     D  C_MTYP               161    161                                                       CAP205
047800230913      *                                                                                       CLE134
047900230913      ** Exception Reference Id/Number                                                        CLE134
048000230913      *                                                                                       CLE134
048100230913     D  C_XRFI               162    164                                                       CLE134
048200230913     D  C_XRFN               165    174  0                                                    CLE134
048300230913                                                                                              CGL029
048400230913      ** Full General Ledger - CNUM/CCY/ACOD/ACSQ                                             CGL029
048500230913     D                 DS                                                                     CGL029
048600230913     D C_ACCT                  1     24                                                       CGL029
048700230913     D W_ACNO                  1     10  0                                                   BUG3821
048800230913     D W_NOS                   1      5                                                      BUG3821
048900230913     D W_NOSN                  1      2  0                                                   BUG3821
049000230913     D*W_CNU1***               1      6  0                                             CGL029 CSD027
049100230913     D W_CNU1                  1      6A                                                      CSD027
049200230913     D W_CCY1                  7      9                                                       CGL029
049300230913     D W_ACOD                  7     16  0                                                   BUG3854
049400230913     D W_ACSQ                 17     18  0                                                   BUG3854
049500230913     D W_ACO1                 10     19  0                                                    CGL029
049600230913     D W_ACS1                 20     21  0                                                    CGL029
049700230913     D W_BRC1                 22     24                                                       CGL029
049800230913      * Partial Account - CNUM/ACOD/ACSQ/BRCA                                                 240008
049900230913     D**P#CNUM**               1      6  0                                             240008 CSD031
050000230913     D  P#CNUM                 1      6A                                                      CSD031
050100230913     D  P#ACOD                 7     16  0                                                    240008
050200230913     D  P#ACSQ                17     18  0                                                    240008
050300230913     D  P#BRCA                19     21                                                       240008
050400230913                                                                                              CGL029
050500230913      *
050600230913      ** Define full account to be passed for FT IMM update
050700230913     D*WIACNT***       DS            18                                                       CGL029
050800230913     D WIACNT          DS            24                                                       CGL029
050900230913     D**WICNUM**               1      6  0                                                    CSD027
051000230913     D  WICNUM                 1      6A                                                      CSD027
051100230913     D  WICCY                  7      9
051200230913     D**WIACOD**              10     13  0                                                    CGL029
051300230913     D**WIACSQ**              14     15  0                                                    CGL029
051400230913     D**WIBRCA**              16     18                                                       CGL029
051500230913     D  WIACOD                10     19  0                                                    CGL029
051600230913     D  WIACSQ                20     21  0                                                    CGL029
051700230913     D  WIBRCA                22     24                                                       CGL029
051800230913      *
051900230913      ** Full account details
052000230913     D                 DS
052100230913     D**WSNDDS**               1     18                                                       CGL029
052200230913     D**WRCCDS**              19     36                                                       CGL029
052300230913     D**WBNCDS**              37     54                                                       CGL029
052400230913     D**WACBDS**              55     72                                                       CGL029
052500230913     D  WSNDDS                 1     24                                                       CGL029
052600230913     D  WRCCDS                25     48                                                       CGL029
052700230913     D  WBNCDS                49     72                                                       CGL029
052800230913     D  WACBDS                73     96                                                       CGL029
052900230913      *
053000230913      ** DS for full account
053100230913     D WACCNT          DS
053200230913     D**WACNUM**               1      6  0                                                    CSD027
053300230913     D  WACNUM                 1      6A                                                      CSD027
053400230913     D  WACCCY                 7      9
053500230913     D**WACCD***              10     13  0                                                    CGL029
053600230913     D**WACSQ***              14     15  0                                                    CGL029
053700230913     D**WBRCA***              16     18                                                       CGL029
053800230913     D  WACCD                 10     19  0                                                    CGL029
053900230913     D  WACSQ                 20     21  0                                                    CGL029
054000230913     D  WBRCA                 22     24                                                       CGL029
054100230913     D/COPY WNCPYSRC,FTH00484
054200230913      *
054300230913      ** DS for IBANs full account
054400230913     D PIBANAcc        DS
054500230913     D**IBCNUM**               1      6  0                                                    CSD027
054600230913     D  IBCNUM                 1      6A                                                      CSD027
054700230913     D  IBCCY                  7      9
054800230913     D**IBACOD**              10     13  0                                                    CGL029
054900230913     D**IBACSQ**              14     15  0                                                    CGL029
055000230913     D**IBBRCA**              16     18                                                       CGL029
055100230913     D  IBACOD                10     19  0                                                    CGL029
055200230913     D  IBACSQ                20     21  0                                                    CGL029
055300230913     D  IBBRCA                22     24                                                       CGL029
055400230913      *                                                                                       CAP211
055500230913      ** DS for PREF                                                                          CAP211
055600230913      *                                                                                       CAP211
055700230913     D                 DS                                                                     CAP211
055800230913     D  IPREF                  1     15                                                       CAP211
055900230913     D  P                      1      1    INZ('P')                                           CAP211
056000230913     D  RUNDYY                 2      3  0                                                    CAP211
056100230913     D  RUNDMD                 4      7  0                                                    CAP211
056200230913     D**PRNUM                  8     11  0                                             CAP211 CFT151
056300230913     D  PRNUM                  8     11                                                       CFT151
056400230913     D  PmntType              12     13                                                       CAP211
056500230913     D  StmtType              14     15  0                                                    CAP211
056600230913      *                                                                                       CAP211
056700230913     D FTDFAC          DS            18                                                       CAP211
056800230913     D  OBCNUM                 1      6                                                       CAP211
056900230913     D  OBACOD                 7     16  0                                                    CAP211
057000230913     D  OBACSQ                17     18  0                                                    CAP211
057100230913     D  OBFTAC                 1     18                                                       CAP211
057200230913      *                                                                                       CAP211
057300230913      ** Data structure used for FT0010                                                       CAP211
057400230913      *                                                                                       CAP211
057500230913     D P#0010          DS           256                                                       CAP211
057600230913     D  P#NDCY                 1      3                                                       CAP211
057700230913     D  P#NDAM                 4     10P 0                                                    CAP211
057800230913     D  P#DBCY                11     13                                                       CAP211
057900230913     D  P#DBAM                14     20P 0                                                    CAP211
058000230913     D  P#DBDT                21     23P 0                                                    CAP211
058100230913     D  P#CRCY                24     26                                                       CAP211
058200230913     D  P#CRAM                27     33P 0                                                    CAP211
058300230913     D  P#PDCY                34     36                                                       CAP211
058400230913     D  P#PDAM                37     43P 0                                                    CAP211
058500230913     D  P#CRDT                44     46P 0                                                    CAP211
058600230913     D  P#RATE                47     53P 8                                                    CAP211
058700230913     D  P#MDIN                54     54  0                                                    CAP211
058800230913     D  P#OVRT                55     55                                                       CAP211
058900230913     D  P#SDIN                56     56                                                       CAP211
059000230913     D  P#RTDS                57     59P 4                                                    CAP211
059100230913      *                                                                                       CAP211
059200230913     D  P#FRCY                11     13                                                       CAP211
059300230913     D  P#FRAM                14     20P 0                                                    CAP211
059400230913     D  P#FRDT                21     23P 0                                                    CAP211
059500230913     D  P#TOCY                24     26                                                       CAP211
059600230913     D  P#TOAM                27     33P 0                                                    CAP211
059700230913     D  P#TODT                44     46P 0                                                    CAP211
059800230913      *                                                                                       CAP211
059900230913     D  P#PMSQ                60     69                                                       CAP211
060000230913     D  P#INDC                70     74                                                       CAP211
060100230913     D  P#RTCD                75     81                                                       CAP211
060200230913     D  P#INTC                82     99  3                                                    CAP211
060300230913     D  P#INTD               100    117  3                                                    CAP211
060400230913     D/COPY WNCPYSRC,FTH00404
060500230913      *
060600230913      ** Midas Functions for Watch List Checking Details File                                 CSD015
060700230913     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
060800230913                                                                                              CSD015
060900230913      ** Data Structure for Accessing SDCUSTPD                                                CSD015
061000230913     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
061100230913                                                                                              CSD015
061200230913      ** Data structure for 1st parameter of Watchlist Engine (SDCWLCHK)                      CSD015
061300230913     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
061400230913                                                                                              CSD015
061500230913      ** External DS for Compliance Watch Configuration Data File                             CSD015
061600230913     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
061700230913                                                                                              CSD015
061800230913      ***DS*for*ZMUSER*details*****************************************               241810 241810A
061900230913     D*ZMUSER***       DS            17                                               241810 241810A
062000230913     D**PUSRID**               1     10                                               241810 241810A
062100230913     D/COPY WNCPYSRC,FTH00405
062200230913                                                                                      241810 241810A
062300230913      ** +--------------------------------------+
062400230913      ** ¦ Declared variables                   ¦
062500230913      ** ¦ ==================                   ¦
062600230913      ** +--------------------------------------+
062700230913      *
062800230913      ** Index for arrays of error message ids, etc.
062900230913     D Idx             S              3P 0
063000230913      *
063100230913      ** Timestamp for the transaction
063200230913     D PTimestamp      S               Z
063300230913      *
063400230913      ** Dummy message ID and message file fields for use on the calls to
063500230913      ** ZAMSGTOOPR
063600230913     D PDummyMsgID     S                   LIKE(#MsgID)
063700230913     D PDummyMsgF      S             10A
063800230913      *
063900230913      ** Work variable for accesing full details of account
064000230913     D WAXSBY          S              6
064100230913                                                                                              CSC011
064200230913      ** 24X7 Midas Availability switchable field                                             CSC011
064300230913     D CSC011          S              1A                                                      CSC011
064400230913                                                                                              CSC011
064500230913      ** Transaction Detail Field                                                             CSC011
064600230913     D TRANSDTL        S           5800A                                                      CSC011
064700230913                                                                                              CSC011
064800230913      ** Payment Reference                                                                    CSC011
064900230913     D*PREFERENCE      S             18A                                               CSC011 CGL029
065000230913     D*PAREFERENCE     S             18A                                               CSC011 CGL029
065100230913     D PREFERENCE      S             24A                                                      CGL029
065200230913     D PAREFERENCE     S             24A                                                      CGL029
065300230913                                                                                              CSC011
065400230913      ** Action Code Indicator                                                                CSC011
065500230913     D PACTN           S              1A                                                      CSC011
065600230913                                                                                              CSC011
065700230913      ** Log Time Stamp field                                                                 CSC011
065800230913     D PTIMESTMP       S             26A                                                      CSC011
065900230913                                                                                              CSC011
066000230913      ** Data structure for 2nd parameter of SDCWLCHK                                         CSD015
066100230913     D PString         DS         30000                                                       CSD015
066200230913                                                                                              CSD015
066300230913      ** Switchable features - Watch List Checking                                            CSD015
066400230913     D CSD015          S              1A                                                      CSD015
066500230913                                                                                              CSD015
066600230913      ** Concorde Interface Development feature                                               CSD015
066700230913     D CCF001          S              1A                                                      CSD015
066800230913                                                                                              CSD015
066900230913      ** ZACVTDATE Parameters                                                                 CSD015
067000230913     D PZADayNo        S              5                                                       CSD015
067100230913     D PZADDT          S               D                                                      CSD015
067200230913     D PZACvtDt        S             10                                                       CSD015
067300230913                                                                                              CSD015
067400230913      ** ZACVTAMT Parameters                                                                  CSD015
067500230913     D PZARtCd         S             10                                                       CSD015
067600230913     D PZACcy          S              3                                                       CSD015
067700230913     D PZAAmt          S             15                                                       CSD015
067800230913     D PZOutAmt        S             18  3                                                    CSD015
067900230913     D PZCvtAmt        S             16                                                       CSD015
068000230913                                                                                              CSD015
068100230913      ** SRConvert Parameters                                                                 CSD015
068200230913     D PInput          S             35                                                       CSD015
068300230913     D PInput1         S             35                                                       CSD015
068400230913     D PInput2         S             35                                                       CSD015
068500230913     D PInput3         S             35                                                       CSD015
068600230913     D PInput4         S             35                                                       CSD015
068700230913     D PInput5         S             35                                                       CSD015
068800230913     D PInCcy          S              3                                                       CSD015
068900230913     D OutFmt          S            216                                                       CSD015
069000230913     D OutFmt2         S              6                                                       CSD015
069100230913                                                                                              CSD015
069200230913      ** Work Variables                                                                       CSD015
069300230913     D WDDT            S               D                                                      CSD015
069400230913     D WFPDT           S              8F                                                      CSD015
069500230913     D Fld1            S             35                                                       CSD015
069600230913     D Fld2            S             35                                                       CSD015
069700230913     D Fld3            S             35                                                       CSD015
069800230913     D Fld4            S             35                                                       CSD015
069900230913     D Fld5            S             35                                                       CSD015
070000230913     D Fld6            S             35                                                       CSD015
070100230913     D WCustomer       S             30                                                       CSD015
070200230913     D WUNCFL          S              1                                                       CSC011
070300230913     D WFUNT           S              8                                                       CSC011
070400230913     D WIDEN           S             30                                                       CSC011
070500230913     D PFunc           S              8                                                       CSD015
070600230913     D WCtrpRpt        S             30                                                       CSD015
070700230913     D WCtrpTyp        S              1                                                       CSD015
070800230913     D PCustNo         S             10A                                                      CSD015
070900230913     D PErrInf         S              7A                                                      CSD015
071000230913     D U               S              2  0                                                    CSD015
071100230913     D PRtCd           S              7A                                                      CSC011
071200230913     D POptn           S              7A                                                      CSC011
071300230913     D PSard           S              6A                                                      CSC011
071400230913     D KIDEN           S             40                                                       CSC011
071500230913     D WRevAst         S              1                                                       CRE020
071600230913     D CRE020          S              1                                                       CRE020
071601230913     D BA5021          S              1                                                       BA5021
071700230913     D PNAccN          S             10A                                                      CGL029
071800230913     D WFRWR           S             24A                                                      CGL029
071900230913     D WTOWR           S             24A                                                      CGL029
072000230913     D CSW209          S              1A                                                      CSW209
072100230913     D CAP205          S              1A                                                      CAP205
072200230913     D P@Rtcd          S              7A                                                    MD058914
072300230913     D P@INOT          S              1A                                                    MD058914
072400230913     D P@BNC1          S             35A                                                    MD058914
072500230913     D P@BNC2          S             35A                                                    MD058914
072600230913     D P@ORC1          S             35A                                                    MD058914
072700230913     D P@ORC2          S             35A                                                    MD058914
072800230913     D P@ORC3          S             35A                                                    MD058914
072900230913     D P@BRCA          S              3A                                                    MD058914
073000230913     D P@PCCY          S              3A                                                    MD058914
073100230913     D P@SMCY          S              3A                                                    MD058914
073200230913     D WCustNumb       S              6A                                                    MD058914
073300230913     D WCustBrch       S              3A                                                    MD058914
073400230913      *                                                                                     MD058914
073500230913     D/COPY WNCPYSRC,FTH00556
073600230913                                                                                              CSD015
073700230913      ** Watch List Description Array                                                         CSD015
073800230913     D***WLARR***         S             35    DIM(24) CTDATA PERRCD(1)                 CSD015 CSW209
073900230913     DWLARR            S             35    DIM(36) CTDATA PERRCD(1)                           CSW209
074000230913      *                                                                                       CAP211
074100230913     D POWERS          S              7  3 DIM(7) CTDATA PERRCD(1)                            CAP211
074200230913     D @DFT            S             35    DIM(1) CTDATA PERRCD(1)                            CAP211
074300230913      *                                                                                       CFT120
074400230913      ** CFT120 switchable field                                                              CFT120
074500230913      *                                                                                       CFT120
074600230913     D CFT120          S              1A                                                      CFT120
074700230913      *                                                                                       CFT151
074800230913      ** CFT151 switchable field                                                              CFT151
074900230913      *                                                                                       CFT151
075000230913     D CFT151          S              1A                                                      CFT151
075100230913      *                                                                                       CSW220
075200230913      ** CSW220 switchable field                                                              CSW220
075300230913      *                                                                                       CSW220
075400230913     D CSW220          S              1A                                                      CSW220
075500230913     D PSWIFT          S              6A                                                      CSW220
075600230913     D PRTNCD          S              7A                                                      CSW220
075700230913
075800230913     D/COPY WNCPYSRC,FTH00165
075900230913      *
076000230913      ** +--------------------------------------+
076100230913      ** ¦ End of D-specs                       ¦
076200230913      ** ¦ ==============                       ¦
076300230913      ** +--------------------------------------+
076400230913      *
076500230913      *****************************************************************
076600230913      /EJECT
076700230913      *****************************************************************
076800230913      *
076900230913      ** +--- Start of Main processing -------------------------------+
077000230913      ** ¦                                                            ¦
077100230913      ** ¦ *INZSR is executed at program activation.                  ¦
077200230913      ** ¦                                                            ¦
077300230913      ** +------------------------------------------------------------+
077400230913      *
077500230913      ** Check for update by another workstation.
077600230913      *
077700230913     C                   EXSR      SRChkOthUpd
077800230913      *
077900230913      ** Continue processing if no errors found.
078000230913      *
078100230913     C                   IF        RetCodeIn = *BLANKS
078200230913      *
078300230913      ** Clear all positions in store.
078400230913      *
078500230913     C/COPY WNCPYSRC,FTH00450
078600230913      *                                                                                       CFT157
078700230913     C*****@CFT157       IFEQ      'Y'                                               CFT157 MD048586
078800230913     C*****IPCHTP        ANDEQ     'S'                                               CFT157 MD048586
078900230913     C**********         ELSE                                                        CFT157 MD048586
079000230913      *                                                                                       CFT157
079100230913     C                   EXSR      SRClr
079200230913     C/COPY WNCPYSRC,FTH00451
079300230913     C**********         ENDIF                                                       CFT157 MD048586
079400230913      *
079500230913      ** Blank out temporary variable for Change Type.
079600230913      *
079700230913     C                   MOVE      *BLANK        WCHTP             1
079800230913     C                   EVAL      PACTN = IPCHTP                                             CSC011
079900230913     ******************************************************************               241810 241810A
080000230913     ***Update*authorising*user*and*authorising*indicator**************               241810 241810A
080100230913     ******************************************************************               241810 241810A
080200230913     C**********         IF        IPAUP1 = *Blanks                                   241810 241810A
080300230913     C**********         EVAL      IPAUP1 = PUSRID                                    241810 241810A
080400230913     C**********         EVAL      IPAUIN = 'Y'                                       241810 241810A
080500230913     C**********         ELSE                                                         241810 241810A
080600230913     C**********         EVAL      IPAUP2 = PUSRID                                    241810 241810A
080700230913     C**********         EVAL      IPAUIN = 'Y'                                       241810 241810A
080800230913     C**********         ENDIF                                                        241810 241810A
080900230913      *
081000230913      ** Perform corresponding processing for Insert, Amend and Delete.
081100230913      *
081200230913     C     IPCHTP        CASEQ     'I'           SRInsert
081300230913     C     IPCHTP        CASEQ     'A'           SRAmend
081400230913     C     IPCHTP        CASEQ     'D'           SRDelete
081500230913     C/COPY WNCPYSRC,FTH00452
081600230913     C     IPCHTP        CASEQ     'S'           SRStop                                       CFT157
081700230913     C                   ENDCS
081800230913                                                                                              CSC011
081900230913      ** Log transaction by calling the LOG module                                            CSC011
082000230913                                                                                              CSC011
082100230913     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
082200230913     C                   IF        (PACTN = 'I') OR (PACTN = 'A') OR                          CSC011
082300230913     C                             (PACTN = 'D')                                              CSC011
082400230913     C                             OR (PACTN = 'S') AND (@CFT157 = 'Y')                       CFT157
082500230913     C/COPY WNCPYSRC,FTH00455
082600230913     C                   EXSR      SRLOGTRAN                                                  CSC011
082700230913     C                   ENDIF                                                                CSC011
082800230913     C                   ENDIF                                                                CSC011
082900230913     C/COPY WNCPYSRC,FTIPAYDC04
083000230913      *
083100230913     C*****@CFT157       IFEQ      'Y'                                               CFT157 MD048586
083200230913     C*****IPCHTP        ANDEQ     'S'                                               CFT157 MD048586
083300230913     C**********         ELSE                                                        CFT157 MD048586
083400230913      *                                                                                       CFT157
083500230913      ** Clear all positions in store.
083600230913      *
083700230913     C                   EXSR      SRClr
083800230913     C/COPY WNCPYSRC,FTH00453
083900230913     C**********         Endif                                                       CFT157 MD048586
084000230913      *
084100230913      ** Call CL program to deallocate this reference to a dataarea                           261468
084200230913      *                                                                                       261468
084300230913     C                   EVAL      C#RTCD = *Blanks                                           261468
084400230913     C                   EVAL      @MODLE = 'FT'                                              261468
084500230913     C                   EVAL      @TREF  = *Blanks                                           261468
084600230913     C                   EVAL      @RTINF = *Blanks                                           261468
084700230913      *                                                                                       261468
084800230913     C                   CALL      'AOC8000'                                                  261468
084900230913     C                   PARM                    C#RTCD            7                          261468
085000230913     C                   PARM                    @MODLE            2                          261468
085100230913     C                   PARM                    @TREF            15                          261468
085200230913     C                   PARM                    @RTINF           80                          261468
085300230913      *                                                                                       261468
085400230913     C                   ENDIF
085500230913      *
085600230913     C                   RETURN
085700230913      *
085800230913      *****************************************************************
085900230913      /EJECT
086000230913      *****************************************************************
086100230913      *                                                               *
086200230913      *  SRChkOthUpd - Check for update by another workstation        *
086300230913      *                                                               *
086400230913      *****************************************************************
086500230913      *
086600230913     C     SRChkOthUpd   BEGSR
086700230913      *
086800230913      ** Determine whether program is running interactively or in batch
086900230913      **  ( 0 = batch   1 = interactive).
087000230913      *
087100230913     C                   CALLB     'ZARTVJOBA'
087200230913     C                   PARM                    PReturn           6
087300230913     C                   PARM                    Ptype             1
087400230913      *
087500230913      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
087600230913      ** Id).  Otherwise, set retrieve mode to blank  (Access using Midas
087700230913      ** transaction Id).
087800230913      *
087900230913     C                   MOVE      PType         WType             1
088000230913     C*****IPCHTP        IFNE      'I'                                          193883
088100230913     C**********         MOVEL     '1'           WType                          193883
088200230913     C**********         ENDIF                                                  193883
088300230913      *
088400230913     C                   IF        WType = '0'
088500230913      *                                                                         193883
088600230913      ** If Insert, only set up to '*FRONT' if not called from Midas Plus                     CAP084
088700230913      ** API wrapper.                                                                         CAP084
088800230913                                                                                              CAP084
088900230913     C     IPCHTP        IFEQ      'I'                                          193883
089000230913     C     PSJobName     ANDNE     'QZDASOINIT'                                               CAP084
089100230913     C     PSJobName     ANDNE     'QSQSRVR'                                                  247277
089200230913     C     PSJobName     ANDNE     'QZDASSINIT'                                            AR1088819
089300230913     C                   MOVE      '*FRONT'      PModeX
089400230913     C                   ELSE
089500230913     C                   MOVE      *BLANKS       PModeX
089600230913     C                   END                                                    193883
089700230913     C                   ELSE                                                   193883
089800230913     C                   MOVE      *BLANKS       PModeX                         193883
089900230913      *                                                                         193883
090000230913     C                   ENDIF
090100230913      *
090200230913      ** Set up Action Code.
090300230913      *
090400230913     C                   IF        POrigACTN = 'I'
090500230913     C                   EVAL      PACTN = POrigACTN
090600230913     C                   ELSE
090700230913     C                   EVAL      PACTN = IPCHTP
090800230913     C                   ENDIF
090900230913      *
091000230913     C                   CALLB     'FTIPAYRTV'
091100230913      *                             =========
091200230913      *
091300230913      ** INPUT
091400230913      ** =====
091500230913      *
091600230913      ** Return Code
091700230913     C                   PARM                    RetCodeIn
091800230913      *
091900230913      ** Mode = '*FRONT' (Front Office Transaction Interface)
092000230913      ** Mode = '      ' (Not Front Office Transaction Interface)
092100230913      ** Mode = '*RPR  ' (Repair Function)
092200230913      ** Mode = '*SIN  ' (Screen Input Function)
092300230913     C                   PARM                    PModeX            6
092400230913      *
092500230913      ** Response Mode
092600230913     C                   PARM      *BLANK        PResponse         1
092700230913      *
092800230913      ** Action Code
092900230913     C                   PARM                    PACTN             1
093000230913      *
093100230913      ** Front Office Transaction Id
093200230913     C                   PARM      IPFRNT        PFRNT            20
093300230913      *
093400230913      ** Payment Reference
093500230913     C                   PARM      IPPREF        PPREF            15
093600230913      *
093700230913      ** Booking Branch
093800230913     C                   PARM      IPBRCA        PBRCH             3
093900230913      *
094000230913      ** SWIFT Reference
094100230913     C                   PARM      *BLANKS       PSWTN            28
094200230913      *
094300230913      ** Entry Point
094400230913     C                   PARM                    PParmLevel
094500230913      *
094600230913      ** Linked Program
094700230913     C                   PARM      *BLANKS       PLinkPgm         10
094800230913      *
094900230913      ** Validate Payment Reference for Insert
095000230913     C                   PARM      *BLANK        PPrefInsert       1
095100230913      *
095200230913      ** STANDING DATA
095300230913      ** =============
095400230913      *
095500230913      ** SDBANK - Single Branch Code
095600230913     C                   PARM                    BJSBRC
095700230913      *
095800230913      ** SDGELR - Originating Branch/User Vald Req.
095900230913     C                   PARM                    BKOBUV
096000230913      *
096100230913      ** ZMUSER - Default Branch
096200230913     C                   PARM                    PDBRN
096300230913      *
096400230913      ** SWITCHABLE FEATURES
096500230913      ** ===================
096600230913      *
096700230913      ** BLI FT Enhancements Feature
096800230913     C                   PARM                    S01494
096900230913      *
097000230913      ** BLI VAT Processing Feature
097100230913     C                   PARM                    S01499
097200230913      *                                                                         CFT014
097300230913      ** FT Batch Auth and Credit Advices                                       CFT014
097400230913     C                   PARM                    CFT003            1            CFT014
097500230913      *                                                                         CFT014
097600230913      ** STP Phase 2 MT103                                                      CFT014
097700230913     C                   PARM                    CFT014            1            CFT014
097800230913      *                                                                         CFT009
097900230913      ** Fees & Charges                                                         CFT009
098000230913     C                   PARM                    CFT009            1            CFT009
098100230913      *
098200230913      ** OUTPUT
098300230913      ** ======
098400230913      *
098500230913      ** Error fields/message IDs/message data (arrays) from/to caller
098600230913     C                   PARM                    FldNameArr
098700230913     C                   PARM                    MsgIdArr
098800230913     C                   PARM                    MsgDtaArr
098900230913      *
099000230913      ** Array index (3P0) from/to caller
099100230913     C                   PARM                    IDx
099200230913      *
099300230913      ** OK Action Code
099400230913     C                   PARM                    OKACTN            1
099500230913      *
099600230913      ** OK Payment Reference
099700230913     C                   PARM                    OKPREF            1
099800230913      *
099900230913      ** OK Booking Branch
100000230913     C                   PARM                    OKBRCA            1
100100230913      *
100200230913      ** Incoming Payments retrieved from file - file format
100300230913     C                   PARM                    CrIPFilFmt
100400230913     C                   PARM                    CrIP2FilFmt                    CFT014
100500230913      *
100600230913      ** Error if Timestamp is not the same (record has been changed
100700230913      ** by another workstation).
100800230913      *
100900230913      ** Processing varies according to mode program is running in.
101000230913      ** In interacive mode, simply check whether the Timestamp field
101100230913      ** has been updated since the original Incoming Payment was
101200230913      ** fetched by this program.  In batch (API input), check return
101300230913      ** parameters from retrieve module for errors, and send
101400230913      ** message to system operator.
101500230913      *
101600230913      ** Interactive mode:
101700230913      *
101800230913     C**********         DUMP                                                        TEMPPL MD037804
101900230913     C                   IF        PType = '1'
102000230913      *
102100230913     C                   IF        CHTMST <> IPTMST
102200230913     C                   MOVEL     '*RECUPD'     RetCodeIn
102300230913     C                   ENDIF
102400230913      *
102500230913      ** Batch mode:
102600230913      *
102700230913     C                   ELSE
102800230913      *
102900230913     C                   IF        OKActn = 'N' OR OKPRef = 'N'
103000230913     C                   MOVEL     '*RECUPD'     RetCodeIn
103100230913     C                   Z-ADD     1             Wc                2 0
103200230913      *
103300230913     C     Wc            DOWLE     ArrayMax
103400230913     C     FldNameArr(Wc)ANDNE     *BLANKS
103500230913     C                   MOVEL     *BLANKS       PDBError         28
103600230913     C                   MOVEL     MsgIDArr(Wc)  PDBError
103700230913      *
103800230913     C                   CALLB     'ZAMSGTOOPR'
103900230913     C                   PARM                    PMsgSndRtn       10
104000230913     C                   PARM                    PDBError
104100230913     C                   PARM                    PDummyMsgID
104200230913     C                   PARM                    PDummyMsgF
104300230913     C                   ADD       1             Wc
104400230913     C                   ENDDO
104500230913      *
104600230913     C                   ENDIF
104700230913      *
104800230913     C                   ENDIF
104900230913      *
105000230913     C                   ENDSR
105100230913      *
105200230913      *****************************************************************
105300230913      /EJECT
105400230913      *****************************************************************
105500230913      *                                                               *
105600230913      *  SRInsert - Insert Incoming Payment record                    *
105700230913      *                                                               *
105800230913      *****************************************************************
105900230913      *
106000230913     C     SRInsert      BEGSR
106100230913      *
106200230913      ** Check if record already exists in Incoming Payments file.
106300230913      ** Error if it already exists.
106400230913      *
106500230913     C     IPPRef        CHAIN     INPAY                              99
106600230913      *
106700230913     C                   IF        *IN99 = *Off
106800230913     C                   MOVEL     IPPRef        DBKey
106900230913     C                   MOVEL     'INPAYDD'     DBFile
107000230913     C                   Z-ADD     001           DBase
107100230913     C                   EXSR      SRERR
107200230913     C                   ENDIF
107300230913      *                                                                         CFT014
107400230913      ** Generate Timestamp.                                                    CFT014
107500230913      *                                                                         CFT014
107600230913     C                   CALLB     'ZAGENTMSTM'                                 CFT014
107700230913     C                   PARM                    PTimestamp                     CFT014
107800230913     C/COPY WNCPYSRC,FTIPAYDC01
107900230913      *
108000230913      ** If Batch Authorisation is installed, update/add record.
108100230913      ** Or if STP Phase 2 MT103 for FT is installed.                           CFT014
108200230913      *
108300230913     C***********        IF        CFT003 = 'Y'                                 CFT014
108400230913     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
108500230913     C                             OR CFT009 = 'Y'                              CFT009
108600230913      *
108700230913     C     IPPRef        CHAIN     INPAYXL0                           99
108800230913     C/COPY WNCPYSRC,FTIPAYDC02
108900230913      *
109000230913     C                   IF        *IN99 = *ON
109100230913      *
109200230913      ** If extension record is not existing, add record.
109300230913      *
109400230913     C                   EVAL      I2INTMST = PTimestamp                                    BUG13159
109500230913     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
109600230913     C**********         EVAL      I2INTMST = PTimestamp                             CFT014 BUG13159
109700230913     C                   EVAL      INTMST = PTimestamp                                        238060
109800230913     C                   EVAL      INReci = 'D'
109900230913     C                   EVAL      INPRef = IPPRef
110000230913     C                   EVAL      INAuto = 'N'
110100230913     C/COPY WNCPYSRC,FTH00166
110200230913                                                                                              CSC011
110300230913      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
110400230913      ** transaction even if it originated from SIN module.                                   CSC011
110500230913                                                                                              CSC011
110600230913     C                   IF        CSC011 = 'Y'                                               CSC011
110700230913     C                   IF        INFRNT = *BLANKS                                           CSC011
110800230913     C                   EVAL      INFRNT = 'MD' + INPREF                                     CSC011
110900230913     C                   ENDIF                                                                CSC011
111000230913     C                   ENDIF                                                                CSC011
111100230913      *
111200230913     C***********        WRITE     INPAYXDF                                     CFT014
111300230913     C                   WRITE     INPAYXDF                             89      CFT014
111400230913      *                                                                         CFT014
111500230913      ** If record already exist on file or file error.                         CFT014
111600230913     C                   IF        *IN89                                        CFT014
111700230913     C                   EVAL      DBKey = INPREF                               CFT014
111800230913     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
111900230913     C                   Z-ADD     020           DBase                          CFT014
112000230913     C                   EXSR      SRERR                                        CFT014
112100230913     C                   ENDIF                                                  CFT014
112200230913      *
112300230913     C                   ELSE
112400230913      *
112500230913      ** If extension record is existing, update record.
112600230913      *
112700230913     C                   EVAL      I2INTMST = PTimestamp                                    BUG13159
112800230913     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
112900230913     C**********         EVAL      I2INTMST = PTimestamp                             CFT014 BUG13159
113000230913     C                   EVAL      INTMST = PTimestamp                                        238060
113100230913     C/COPY WNCPYSRC,FTH00406
113200230913     C                   EVAL      INAuto = 'N'
113300230913     C/COPY WNCPYSRC,FTH00167
113400230913     C***********        UPDATE    INPAYXDF                                     CFT014
113500230913     C                   UPDATE    INPAYXDF                             89      CFT014
113600230913      *                                                                         CFT014
113700230913      ** If record already exist on file or file error.                         CFT014
113800230913     C                   IF        *IN89                                        CFT014
113900230913     C                   EVAL      DBKey = INPREF                               CFT014
114000230913     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
114100230913     C                   Z-ADD     021           DBase                          CFT014
114200230913     C                   EXSR      SRERR                                        CFT014
114300230913     C                   ENDIF                                                  CFT014
114400230913      *
114500230913     C                   ENDIF
114600230913      *
114700230913     C                   ENDIF
114800230913      ***********                                                               CFT014
114900230913      ***Generate*Timestamp.*******************************************         CFT014
115000230913      ***********                                                               CFT014
115100230913     C***********        CALLB     'ZAGENTMSTM'                                 CFT014
115200230913     C***********        PARM                    PTimestamp                     CFT014
115300230913      *
115400230913     C                   EVAL      IPTMST = PTimestamp
115500230913      *
115600230913      ** Save Change Type.
115700230913      *
115800230913     C                   EVAL      WCHTP = IPCHTP
115900230913      *
116000230913     C                   MOVE      NwIpFilFmt    InPayUpdF
116100230913                                                                                              CSC011
116200230913      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
116300230913      ** transaction even if it originated from SIN module.                                   CSC011
116400230913                                                                                              CSC011
116500230913     C                   IF        CSC011 = 'Y'                                               CSC011
116600230913     C                   IF        FRNT = *BLANKS                                             CSC011
116700230913     C                   EVAL      FRNT = 'MD' + PREF                                         CSC011
116800230913     C                   ENDIF                                                                CSC011
116900230913     C                   ENDIF                                                                CSC011
117000230913                                                                                              CSD015
117100230913      ** If compliance watch is installed, and entry watch list checking                      CSD015
117200230913      ** is being applied, perform compliance watch processing                                CSD015
117300230913                                                                                              CSD015
117400230913     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
117500230913                                                                                              CSD015
117600230913     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
117700230913     C                             OR CSC011 = 'N'                                            CSD015
117800230913     C                   EVAL      WUNCFL = ' '                                               CSD015
117900230913     C                   EXSR      SRWTCH                                                     CSD015
118000230913                                                                                              CSD015
118100230913     C                   ENDIF                                                                CSD015
118200230913     C                   ENDIF                                                                CSD015
118300230913                                                                                              CSD015
118400230913     C                   EVAL      INLVL1 = 'Y'                                             BUG14585
118500230913                                                                                            MD059420
118600230913      * Ensure input user is set on insertion                                               MD059420
118700230913                                                                                            MD059420
118800230913     C                   IF        INUSR1 = *Blanks                                         MD059420
118900230913     C                   EVAL      INUSR1 = PUser                                           MD059420
119000230913     C                   ENDIF                                                              MD059420
119100230913      *
119200230913      ** Move valid file details to update file details.
119300230913      *
119400230913     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
119500230913      *                                                                                       CAP211
119600230913      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CAP211
119700230913      ** if CAP211 is ON and PAuth is 'Y'.                                                    CAP211
119800230913      *                                                                                       CAP211
119900230913     C                   IF        PUser = *Blanks                                            CAP211
120000230913     C                   EVAL      AUP1 = INUSR1                                              CAP211
120100230913     C                   ELSE                                                                 CAP211
120200230913     C                   EVAL      AUP1 = PUser                                               CAP211
120300230913     C                   ENDIF                                                                CAP211
120400230913     C                   EVAL      AUIN = 'Y'                                                 CAP211
120500230913      *                                                                                       CAP211
120600230913     C                   ENDIF                                                                CAP211
120700230913      *                                                                                     MD030940
120800230913     C                   EVAL      DATE = 0                                                 MD030940
120900230913      *                                                                                       CAP211
121000230913     C/COPY WNCPYSRC,FTH00431
121100230913     C                   WRITE     INPAYDDF                             99
121200230913      *
121300230913     C                   IF        *IN99 = *ON
121400230913     C                   MOVEL     IPPRef        DBKey
121500230913     C                   MOVEL     'INPAYDD'     DBFile
121600230913     C                   Z-ADD     002           DBase
121700230913     C                   EXSR      *PSSR
121800230913     C                   ENDIF
121900230913     C/COPY WNCPYSRC,FTH00407
122000230913      *                                                                                       257487
122100230913      ** Move valid file details to extension file details                                    257487
122200230913      *                                                                                       257487
122300230913     C                   IF        PSJobName <> 'QZDASOINIT' AND                            MD020135
122400230913     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
122500230913     C                             PSJobName <> 'QSQSRVR'                                   MD020135
122600230913     C                   EVAL      IPFRID = IPFRNT                                            257487
122700230913     C                   EXSR      SRSetINPAYDQD                                            MD058914
122800230913     C                   WRITE     INPAYQD0                             99                    257487
122900230913      *                                                                                       257487
123000230913     C                   IF        *IN99 = *ON                                                257487
123100230913     C                   MOVEL     IPPRef        DBKey                                        257487
123200230913     C                   MOVEL     'INPAYDQD'    DBFile                                       257487
123300230913     C                   Z-ADD     031           DBase                                        257487
123400230913     C                   EXSR      *PSSR                                                      257487
123500230913     C                   ENDIF                                                                257487
123600230913     C                   ENDIF                                                              MD020135
123700230913      *****************************************************************               BUG4776 260326
123800230913      ****If*new*record*was*successfully*writen*to*INPAYDD,*add*new*record*to         BUG4776 260326
123900230913      ****FT*Payment*Reference*Control*file*-*FTPREFPD*****************               BUG4776 260326
124000230913      *****************************************************************               BUG4776 260326
124100230913     C**********         If        *IN99 = *OFF                                       BUG4776 260326
124200230913     C**********         EVAL      MLRECI = INRECI                                    BUG4776 260326
124300230913     C**********         MOVEL     IPPREF        MLPREF                               BUG4776 260326
124400230913     C**********         EVAL      MLPYTP = IPPYTP                                    BUG4776 260326
124500230913     C**********         Write     FTPREFDF                             70            BUG4776 260326
124600230913     C**********         If        *IN70 = *ON                                        BUG4776 260326
124700230913     C**********         Movel     'FTPREFL0'    DBFILE                               BUG4776 260326
124800230913     C**********         Z-add     7             DBASE                                BUG4776 260326
124900230913     C**********         Movel     MLPREF        DBKEY                                BUG4776 260326
125000230913     C**********         Exsr      *PSSR                                              BUG4776 260326
125100230913     C**********         Endif                                                        BUG4776 260326
125200230913     C**********         Endif                                                        BUG4776 260326
125300230913      *
125400230913     C/COPY WNCPYSRC,FTIPAYDC05
125500230913      ** Process shadow post.
125600230913      *
125700230913     C                   EVAL      WVSMAM = SMAM
125800230913     C                   EVAL      WVPYAM = PYAM
125900230913      *
126000230913     C                   EXSR      SRAdd
126100230913      *
126200230913      ** Add Charges (Charge Amount is always debit) if
126300230913      ** Level 2 details have been entered.
126400230913      *
126500230913     C                   IF        INLVL2 = 'Y'
126600230913      *
126700230913     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
126800230913     C                                    + TLCH + MSCH + TRCM
126900230913      *
127000230913     C     S01494        IFEQ      'Y'
127100230913     C                   ADD       INCHCM        WVCHGS
127200230913     C                   ENDIF
127300230913      *
127400230913     C     S01499        IFEQ      'Y'
127500230913     C     CFT009        ANDEQ     'N'                                          CFT009
127600230913     C     CFT010        OREQ      'Y'                                          CFT009
127700230913     C                   ADD       INVATT        WVCHGS
127800230913     C                   ENDIF
127900230913      *                                                                         CFT009
128000230913      ** Extra charges                                                          CFT009
128100230913      *                                                                         CFT009
128200230913     C     CFT009        IFEQ      'Y'                                          CFT009
128300230913     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
128400230913     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
128500230913     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
128600230913     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
128700230913     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
128800230913     C                   ADD       MSC01         WVCHGS                                       CFT120
128900230913     C                   ADD       MSC02         WVCHGS                                       CFT120
129000230913     C                   ADD       MSC03         WVCHGS                                       CFT120
129100230913     C                   ADD       MSC04         WVCHGS                                       CFT120
129200230913     C                   ADD       MSC05         WVCHGS                                       CFT120
129300230913     C                   ENDIF                                                  CFT009
129400230913      *
129500230913     C     WVCHGS        IFNE      0
129600230913     C                   EXSR      SRSChg
129700230913     C                   ENDIF
129800230913      *
129900230913     C                   ENDIF
130000230913      *
130100230913      ** Perform shadow post update.
130200230913      *
130300230913     C                   EXSR      SRSHadow
130400230913      *
130500230913      ** Process Message Unique Reference if not equal to zero.
130600230913      *
130700230913     C                   IF        INMSGR <> 0
130800230913      *
130900230913      ** Remove the electronic message from the Outstanding Reserved
131000230913      ** Messages file.
131100230913      *
131200230913     C                   EXSR      SRMsgDel
131300230913      *
131400230913      ** Update Incoming Message FT Transaction Status File record.
131500230913      *
131600230913     C/COPY WNCPYSRC,FTH00168
131700230913     C                   MOVEL     'MIN0030'     W0Flag            7
131800230913     C/COPY WNCPYSRC,FTH00169
131900230913     C                   MOVEL     'MIN0027'     W0LMSG            7
132000230913      *
132100230913     C                   EXSR      SRInFT
132200230913      *
132300230913      ** If Level 2 details have been entered, update Incoming
132400230913      ** Message Log file.
132500230913      *
132600230913     C                   IF        INLVL2 = 'Y'
132700230913     C                   MOVEL     'MIN0034'     W0LMSG
132800230913     C                   EXSR      SRLOG
132900230913     C                   ENDIF
133000230913     C/COPY WNCPYSRC,FTH00396
133100230913      *
133200230913     C                   ENDIF
133300230913      *
133400230913      ** Update Incoming Payments trailer with Payment Amount.
133500230913      *
133600230913     C                   MOVE      SMAM          ZZAMT
133700230913     C                   EXSR      SRTrailer
133800230913      *
133900230913     C                   IF        CAP211 = 'Y' AND PAuth = 'Y' AND                           CAP211
134000230913     C                             SVGOP = 'Y' AND OPIN = 'Y'                                 CAP211
134100230913      *                                                                                       CAP211
134200230913      ** Generate Outgoing Payment if CAP211 is ON, PAuth is 'Y', CAP211GenerateOP system     CAP211
134300230913      ** value is 'Y' and OPIN (Outgoing payment generated from incoming payemnt) flag is 'Y' CAP211
134400230913      *                                                                                       CAP211
134500230913     C                   EXSR      WOTPAY                                                     CAP211
134600230913     C                   ENDIF                                                                CAP211
134700230913      *                                                                                       CAP211
134800230913     C                   ENDSR
134900230913      *
135000230913      *****************************************************************
135100230913      /EJECT
135200230913      *****************************************************************
135300230913      *                                                               *
135400230913      *  SRAmend - Amend Incoming Payment record                      *
135500230913      *                                                               *
135600230913      *****************************************************************
135700230913      *
135800230913     C     SRAmend       BEGSR
135900230913      *
136000230913      ** Check if record already exists in Incoming Payments file.
136100230913      ** Error if it does not exist.
136200230913      *
136300230913     C     IPPRef        CHAIN     INPAY                              99
136400230913      *
136500230913     C                   IF        *IN99 = *On
136600230913     C                   MOVEL     IPPRef        DBKey
136700230913     C                   MOVEL     'INPAYDD'     DBFile
136800230913     C                   MOVEL     003           DBase
136900230913     C                   EXSR      SRERR
137000230913     C                   ENDIF
137100230913      *
137200230913     C                   MOVE      InPayUpdF     CrIPFilFmt
137300230913      *                                                                         CFT014
137400230913      ** Generate Timestamp.                                                    CFT014
137500230913      *                                                                         CFT014
137600230913     C                   CALLB     'ZAGENTMSTM'                                 CFT014
137700230913     C                   PARM                    PTimestamp                     CFT014
137800230913      *
137900230913      ** Process shadow post (reverse out original entries).
138000230913      *
138100230913     C                   Z-SUB     SMAM          WVSMAM
138200230913     C                   Z-SUB     PYAM          WVPYAM
138300230913      *
138400230913      ** Process shadow post if Level 1 maintenance, or Level 2
138500230913      ** maintenance, Account with Bank entered and OPIN has
138600230913      ** changed from N to Y.
138700230913      *
138800230913     C     PParmLevel    IFEQ      '1'
138900230913     C     PParmLevel    OREQ      '2'
139000230913     C     ACBT          ANDNE     *BLANKS
139100230913     C     OPIN          ANDNE     'Y'
139200230913     C     IPOPIN        ANDEQ     'Y'
139300230913     C                   IF        CRE020 = 'Y'                                               CRE020
139400230913     C                   EVAL      WRevAst = 'Y'                                              CRE020
139500230913     C                   ENDIF                                                                CRE020
139600230913     C                   EXSR      SRAdd
139700230913     C                   ENDIF
139800230913      *                                                                         CFT009
139900230913      ** Check if record already exists in Incoming Payments extension file     CFT009
140000230913      ** Error if it does not exist.                                            CFT009
140100230913      *                                                                         CFT009
140200230913     C                   IF        CFT009 = 'Y'                                 CFT009
140300230913                                                                                CFT009
140400230913     C     IPPREF        CHAIN     INPAYXL0                           99        CFT009
140500230913      *                                                                         CFT009
140600230913     C                   IF        *IN99 = *ON                                  CFT009
140700230913     C                   MOVEL     IPPREF        DBKEY                          CFT009
140800230913     C                   MOVEL     'INPAYXPD'    DBFILE                         CFT009
140900230913     C                   MOVEL     028           DBASE                          CFT009
141000230913     C                   EXSR      SRERR                                        CFT009
141100230913     C                   ENDIF                                                  CFT009
141200230913                                                                                CFT009
141300230913     C                   ENDIF                                                  CFT009
141400230913      *
141500230913      ** Reverse Charges (Charge Amount is always debit).
141600230913      *
141700230913     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
141800230913     C                                    + TLCH + MSCH + TRCM
141900230913      *
142000230913     C     S01494        IFEQ      'Y'
142100230913     C                   ADD       INCHCM        WVCHGS
142200230913     C                   ENDIF
142300230913      *
142400230913     C     S01499        IFEQ      'Y'
142500230913     C     CFT009        ANDEQ     'N'                                          CFT009
142600230913     C     CFT010        OREQ      'Y'                                          CFT009
142700230913     C                   ADD       INVATT        WVCHGS
142800230913     C                   ENDIF
142900230913      *                                                                         CFT009
143000230913      ** Extra charges                                                          CFT009
143100230913      *                                                                         CFT009
143200230913     C     CFT009        IFEQ      'Y'                                          CFT009
143300230913     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
143400230913     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
143500230913     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
143600230913     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
143700230913     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
143800230913     C                   ADD       MSC01         WVCHGS                                       CFT120
143900230913     C                   ADD       MSC02         WVCHGS                                       CFT120
144000230913     C                   ADD       MSC03         WVCHGS                                       CFT120
144100230913     C                   ADD       MSC04         WVCHGS                                       CFT120
144200230913     C                   ADD       MSC05         WVCHGS                                       CFT120
144300230913     C                   ENDIF                                                  CFT009
144400230913      *
144500230913     C     WVCHGS        IFNE      0
144600230913     C                   Z-SUB     WVCHGS        WVCHGS
144700230913     C                   IF        CRE020 = 'Y'                                               CRE020
144800230913     C                   EVAL      WRevAst = 'Y'                                              CRE020
144900230913     C                   ENDIF                                                                CRE020
145000230913     C                   EXSR      SRSChg
145100230913     C                   ENDIF
145200230913     C/COPY WNCPYSRC,FTIPAYDC06
145300230913      *
145400230913      ***If*Batch*Authorisation*is*installed,*update*extension*********         CFT014
145500230913      ***record*to*include*the*Auto-generated*indicator.***************         CFT014
145600230913      ** If Batch Authorisation is installed or STP Phase 2 MT103               CFT014
145700230913      ** for FT is installed, update extension record to include the            CFT014
145800230913      ** Auto-generated indicator and other new fields.                         CFT014
145900230913      *
146000230913     C***********        IF        CFT003 = 'Y' and                             CFT014
146100230913     C*****************  IF        (CFT003 = 'Y' or CFT014 = 'Y') and    CFT014 CFT009
146200230913     C                   IF        (CFT003 = 'Y' or CFT014 = 'Y'                CFT009
146300230913     C                             OR CFT009 = 'Y') AND                         CFT009
146400230913     C                             PParmLevel = '1'
146500230913      *
146600230913     C     PRef          CHAIN     INPAYXL0                           99
146700230913      *
146800230913     C                   IF        *IN99 = *ON
146900230913      *
147000230913      ** If extension record is not existing, add record.
147100230913      *
147200230913     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
147300230913     C                   EVAL      I2INTMST = PTimestamp                        CFT014
147400230913     C                   EVAL      INTMST = PTimestamp                                        238060
147500230913     C                   EVAL      INReci = 'D'
147600230913     C                   EVAL      INPRef = IPPRef
147700230913     C                   EVAL      INAuto = 'N'
147800230913     C/COPY WNCPYSRC,FTH00170
147900230913                                                                                              CSC011
148000230913      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
148100230913      ** transaction even if it originated from SIN module.                                   CSC011
148200230913                                                                                              CSC011
148300230913     C                   IF        CSC011 = 'Y'                                               CSC011
148400230913     C                   IF        INFRNT = *BLANKS                                           CSC011
148500230913     C                   EVAL      INFRNT = 'MD' + INPREF                                     CSC011
148600230913     C                   ENDIF                                                                CSC011
148700230913     C                   ENDIF                                                                CSC011
148800230913      *
148900230913     C***********        WRITE     INPAYXDF                                     CFT014
149000230913     C                   WRITE     INPAYXDF                             89      CFT014
149100230913      *                                                                         CFT014
149200230913      ** If record already exist on file or file error.                         CFT014
149300230913     C                   IF        *IN89                                        CFT014
149400230913     C                   EVAL      DBKey = INPREF                               CFT014
149500230913     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
149600230913     C                   Z-ADD     022           DBase                          CFT014
149700230913     C                   EXSR      SRERR                                        CFT014
149800230913     C                   ENDIF                                                  CFT014
149900230913      *
150000230913     C                   ELSE
150100230913      *
150200230913      ** If extension record is existing, update record.
150300230913      *
150400230913     C                   MOVE      NwIP2FilFmt   CrIP2FilFmt                    CFT014
150500230913     C                   EVAL      I2INTMST = PTimestamp                        CFT014
150600230913     C                   EVAL      INTMST = PTimestamp                                        238060
150700230913     C/COPY WNCPYSRC,FTH00408
150800230913     C                   MOVEL     'N'           INAUTO
150900230913     C/COPY WNCPYSRC,FTH00171
151000230913     C***********        UPDATE    INPAYXDF                                     CFT014
151100230913     C                   UPDATE    INPAYXDF                             89      CFT014
151200230913      *                                                                         CFT014
151300230913      ** If record already exist on file or file error.                         CFT014
151400230913     C                   IF        *IN89                                        CFT014
151500230913     C                   EVAL      DBKey = INPREF                               CFT014
151600230913     C                   EVAL      DBFile = 'INPAYXPD'                          CFT014
151700230913     C                   Z-ADD     023           DBase                          CFT014
151800230913     C                   EXSR      SRERR                                        CFT014
151900230913     C                   ENDIF                                                  CFT014
152000230913      *
152100230913     C                   ENDIF
152200230913      *
152300230913     C                   ENDIF
152400230913      *                                                                                     AR924677
152500230913      ** On amend, clear AUTHORISE PROF 1                                                   AR924677
152600230913      *                                                                                     AR924677
152700230913     C                   MOVE      *BLANK        IPAUP1                                     AR924677
152800230913      *
152900230913      ** Save Change Type.
153000230913      *
153100230913     C                   EVAL      WCHTP = IPCHTP
153200230913      *
153300230913      ** Retain original Last Change Type if original value is 'I'
153400230913      ** and original Last Change Date is equal to rundate.
153500230913      *
153600230913     C     CHTP          IFEQ      'I'
153700230913     C     LCD           ANDEQ     BJRDNB
153800230913     C                   EVAL      IPCHTP = CHTP
153900230913     C                   ENDIF
154000230913      *
154100230913      ** If Level 2 is newly entered, reset Original Entry
154200230913      ** Date to rundate and Last Change Type to 'I'.
154300230913      *
154400230913     C                   IF        INLVL2 <> 'Y' and
154500230913     C                             IPINLVL2 = 'Y'
154600230913     C                   EVAL      IPOEDT = BJRDNB
154700230913     C                   EVAL      IPCHTP = 'I'
154800230913     C                   ENDIF
154900230913      ***********                                                               CFT014
155000230913      ***Generate*Timestamp.*******************************************         CFT014
155100230913      ***********                                                               CFT014
155200230913     C***********        CALLB     'ZAGENTMSTM'                                 CFT014
155300230913     C***********        PARM                    PTimestamp                     CFT014
155400230913      *
155500230913     C                   EVAL      IPTMST = PTimestamp
155600230913      *
155700230913      ** Move valid file details to update file details.
155800230913      *
155900230913     C                   MOVEL     NwIpFilFmt    InPayUpdF
156000230913      *                                                                                       208944
156100230913      ** Reset authorizing profile.                                                           208944
156200230913      *                                                                                       208944
156300230913     C/COPY WNCPYSRC,FTH00557
156400230913     C                   MOVE      *Blanks       AUP1                                         208944
156500230913     C/COPY WNCPYSRC,FTH00558
156600230913      *
156700230913      ** If compliance watch is installed, and entry watch list checking                      CSD015
156800230913      ** is being applied, perform compliance watch processing for amend mode                 CSD015
156900230913                                                                                              CSD015
157000230913     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
157100230913                                                                                              CSD015
157200230913     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
157300230913     C                             OR CSC011 = 'N'                                            CSD015
157400230913                                                                                              CSD015
157500230913     C                   EVAL      WUNCFL = ' '                                               CSD015
157600230913     C                   EVAL      WFUNT = 'INPAYDD'                                          CSD015
157700230913     C                   EVAL      KIDEN = PREF                                               CSD015
157800230913     C     KWHTKY        CHAIN     SDCWHTL1                                                   CSD015
157900230913     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
158000230913     C                   EVAL      WUNCFL = 'Y'                                               CSD015
158100230913     C                   ENDIF                                                                CSD015
158200230913                                                                                              CSD015
158300230913     C                   EXSR      SRWTCH                                                     CSD015
158400230913                                                                                              CSD015
158500230913     C                   ENDIF                                                                CSD015
158600230913     C                   ENDIF                                                                CSD015
158700230913                                                                                              CSD015
158800230913     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
158900230913      *                                                                                       CAP211
159000230913      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CAP211
159100230913      ** if CAP211 is ON and PAuth is 'Y'.                                                    CAP211
159200230913      *                                                                                       CAP211
159300230913     C                   IF        PUser = *Blanks                                            CAP211
159400230913     C                   EVAL      AUP1 = INUSR1                                              CAP211
159500230913     C                   ELSE                                                                 CAP211
159600230913     C                   EVAL      AUP1 = PUser                                               CAP211
159700230913     C                   ENDIF                                                                CAP211
159800230913     C                   EVAL      AUIN = 'Y'                                                 CAP211
159900230913      *                                                                                       CAP211
160000230913     C                   ENDIF                                                                CAP211
160100230913      *                                                                                     MD030940
160200230913     C                   EVAL      DATE = 0                                                 MD030940
160300230913      *                                                                                       CAP211
160400230913     C/COPY WNCPYSRC,FTH00432
160500230913     C                   UPDATE    INPAYDDF                             99
160600230913     C/COPY WNCPYSRC,FTIPAYDC22
160700230913      *
160800230913     C                   IF        *IN99 = *ON
160900230913     C                   MOVEL     IPPREF        DBKey
161000230913     C                   MOVEL     'INPAYDD'     DBFile
161100230913     C                   MOVEL     004           DBase
161200230913     C                   EXSR      *PSSR
161300230913     C                   ENDIF
161400230913     C/COPY WNCPYSRC,FTIPAYDC23
161500230913      *
161600230913      ** Process shadow post.
161700230913      *
161800230913     C                   EVAL      WVSMAM = SMAM
161900230913     C                   EVAL      WVPYAM = PYAM
162000230913      *
162100230913      ** Process shadow post if Level 1 maintenance, or Level 2
162200230913      ** maintenance, Account with Bank entered and OPIN has
162300230913      ** changed from Y to N.
162400230913      *
162500230913     C     PParmLevel    IFEQ      '1'
162600230913     C     PParmLevel    OREQ      '2'
162700230913     C     ACBT          ANDNE     *BLANKS
162800230913     C     OPIN          ANDNE     'Y'
162900230913     C     CHOPIN        ANDEQ     'Y'
163000230913     C                   EXSR      SRAdd
163100230913     C                   ENDIF
163200230913      *
163300230913      ** Add Charges (Charge Amount is always debit).
163400230913      *
163500230913     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
163600230913     C                                    + TLCH + MSCH + TRCM
163700230913      *
163800230913     C     S01494        IFEQ      'Y'
163900230913     C                   ADD       INCHCM        WVCHGS
164000230913     C                   ENDIF
164100230913      *
164200230913     C     S01499        IFEQ      'Y'
164300230913     C     CFT009        ANDEQ     'N'                                          CFT009
164400230913     C     CFT010        OREQ      'Y'                                          CFT009
164500230913     C                   ADD       INVATT        WVCHGS
164600230913     C                   ENDIF
164700230913      *                                                                         CFT009
164800230913      ** Extra charges                                                          CFT009
164900230913      *                                                                         CFT009
165000230913     C     CFT009        IFEQ      'Y'                                          CFT009
165100230913     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
165200230913     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
165300230913     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
165400230913     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
165500230913     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
165600230913     C                   ADD       MSC01         WVCHGS                                       CFT120
165700230913     C                   ADD       MSC02         WVCHGS                                       CFT120
165800230913     C                   ADD       MSC03         WVCHGS                                       CFT120
165900230913     C                   ADD       MSC04         WVCHGS                                       CFT120
166000230913     C                   ADD       MSC05         WVCHGS                                       CFT120
166100230913     C                   ENDIF                                                  CFT009
166200230913      *
166300230913     C     WVCHGS        IFNE      0
166400230913     C                   EXSR      SRSChg
166500230913     C                   ENDIF
166600230913      *
166700230913      ** Perform shadow post update.
166800230913      *
166900230913     C                   EXSR      SRSHadow
167000230913      *
167100230913      ** Update Incoming Message FT Transaction Status File record.
167200230913      *
167300230913     C                   IF        INMSGR <> 0
167400230913      *
167500230913     C                   IF        PParmLevel = '1'
167600230913     C/COPY WNCPYSRC,FTH00172
167700230913     C                   MOVEL     'MIN0030'     W0Flag
167800230913     C/COPY WNCPYSRC,FTH00173
167900230913     C                   MOVEL     'MIN0028'     W0LMSG
168000230913     C                   MOVEL     *BLANKS       PNWRK
168100230913     C                   EXSR      SRInFT
168200230913     C                   ENDIF
168300230913      *
168400230913      ** If Level 2 is newly entered, update Incoming
168500230913      ** Message Log file.
168600230913      *
168700230913     C                   IF        INLVL2 = 'Y' and
168800230913     C                             CHINLVL2 <> 'Y'
168900230913     C                   MOVEL     'MIN0034'     W0LMSG
169000230913     C                   EXSR      SRLOG
169100230913     C                   ENDIF
169200230913      *
169300230913     C                   ENDIF
169400230913      *
169500230913      ** Update Incoming Payments trailer with new Payment
169600230913      ** Amount minus original Payment Amount if Level 1
169700230913      ** maintenance.
169800230913      *
169900230913     C     PParmLevel    IFEQ      '1'
170000230913     C     SMAM          SUB       CHSMAM        WN13             13 0
170100230913     C                   MOVE      WN13          ZZAMT
170200230913     C                   EXSR      SRTrailer
170300230913     C                   ENDIF
170400230913      *
170500230913     C                   ENDSR
170600230913      *
170700230913      *****************************************************************
170800230913      /EJECT
170900230913      *****************************************************************
171000230913      *                                                               *
171100230913      *  SRDelete - Delete Incoming Payment record                    *
171200230913      *                                                               *
171300230913      *****************************************************************
171400230913      *
171500230913     C     SRDelete      BEGSR
171600230913      *
171700230913      ** Check if record already exists in Incoming Payments file.
171800230913      ** Error if it does not exist.
171900230913      *
172000230913     C     IPPRef        CHAIN     INPAY                              99
172100230913      *
172200230913     C                   IF        *IN99 = *On
172300230913     C                   MOVEL     IPPRef        DBKey
172400230913     C                   MOVEL     'INPAYDD'     DBFile
172500230913     C                   MOVEL     005           DBase
172600230913     C                   EXSR      SRERR
172700230913     C                   ENDIF
172800230913      *
172900230913     C                   MOVE      InPayUpdF     CrIPFilFmt
173000230913      *
173100230913      ** Process shadow post (reverse out original entries).
173200230913      *
173300230913     C                   Z-SUB     SMAM          WVSMAM
173400230913     C                   Z-SUB     PYAM          WVPYAM
173500230913      *                                                                                       CRE020
173600230913     C                   IF        CRE020 = 'Y'                                               CRE020
173700230913     C                   EVAL      WRevAst = 'Y'                                              CRE020
173800230913     C                   ENDIF                                                                CRE020
173900230913      *
174000230913     C                   EXSR      SRAdd
174100230913      *                                                                         CFT009
174200230913      ** Check if record already exists in Incoming Payments extension file     CFT009
174300230913      ** Error if it does not exist.                                            CFT009
174400230913      *                                                                         CFT009
174500230913     C                   IF        CFT009 = 'Y'                                 CFT009
174600230913                                                                                CFT009
174700230913     C     IPPREF        CHAIN     INPAYXL0                           99        CFT009
174800230913      *                                                                         CFT009
174900230913     C                   IF        *IN99 = *ON                                  CFT009
175000230913     C                   MOVEL     PREF          DBKEY                          CFT009
175100230913     C                   MOVEL     'INPAYXPD'    DBFILE                         CFT009
175200230913     C                   MOVEL     029           DBASE                          CFT009
175300230913     C                   EXSR      SRERR                                        CFT009
175400230913     C                   ENDIF                                                  CFT009
175500230913                                                                                CFT009
175600230913     C                   ENDIF                                                  CFT009
175700230913      *
175800230913      ** Reverse Charges (Charge Amount is always debit).
175900230913      *
176000230913     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH
176100230913     C                                    + TLCH + MSCH + TRCM
176200230913      *
176300230913     C     S01494        IFEQ      'Y'
176400230913     C                   ADD       INCHCM        WVCHGS
176500230913     C                   ENDIF
176600230913      *
176700230913     C     S01499        IFEQ      'Y'
176800230913     C     CFT009        ANDEQ     'N'                                          CFT009
176900230913     C     CFT010        OREQ      'Y'                                          CFT009
177000230913     C                   ADD       INVATT        WVCHGS
177100230913     C                   ENDIF
177200230913      *                                                                         CFT009
177300230913      ** Extra charges                                                          CFT009
177400230913      *                                                                         CFT009
177500230913     C     CFT009        IFEQ      'Y'                                          CFT009
177600230913     C**********         ADD       CMSC01        WVCHGS                                CFT009 CFT120
177700230913     C**********         ADD       CMSC02        WVCHGS                                CFT009 CFT120
177800230913     C**********         ADD       CMSC03        WVCHGS                                CFT009 CFT120
177900230913     C**********         ADD       CMSC04        WVCHGS                                CFT009 CFT120
178000230913     C**********         ADD       CMSC05        WVCHGS                                CFT009 CFT120
178100230913     C                   ADD       MSC01         WVCHGS                                       CFT120
178200230913     C                   ADD       MSC02         WVCHGS                                       CFT120
178300230913     C                   ADD       MSC03         WVCHGS                                       CFT120
178400230913     C                   ADD       MSC04         WVCHGS                                       CFT120
178500230913     C                   ADD       MSC05         WVCHGS                                       CFT120
178600230913     C                   ENDIF                                                  CFT009
178700230913      *
178800230913     C     WVCHGS        IFNE      0
178900230913     C                   Z-SUB     WVCHGS        WVCHGS
179000230913     C                   IF        CRE020 = 'Y'                                               CRE020
179100230913     C                   EVAL      WRevAst = 'Y'                                              CRE020
179200230913     C                   ENDIF                                                                CRE020
179300230913     C                   EXSR      SRSChg
179400230913     C                   ENDIF
179500230913      *
179600230913      ** Generate Timestamp.
179700230913      *
179800230913     C                   CALLB     'ZAGENTMSTM'
179900230913     C                   PARM                    PTimestamp
180000230913      *
180100230913     C                   EVAL      IPTMST = PTimestamp
180200230913      *
180300230913      ** Move valid file details to update file details.
180400230913      *
180500230913     C                   MOVEL     NwIpFilFmt    InPayUpdF
180600230913      *
180700230913     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
180800230913      *                                                                                       CAP211
180900230913      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CAP211
181000230913      ** if CAP211 is ON and PAuth is 'Y'.                                                    CAP211
181100230913      *                                                                                       CAP211
181200230913     C                   IF        PUser = *Blanks                                            CAP211
181300230913     C                   EVAL      AUP1 = INUSR1                                              CAP211
181400230913     C                   ELSE                                                                 CAP211
181500230913     C                   EVAL      AUP1 = PUser                                               CAP211
181600230913     C                   ENDIF                                                                CAP211
181700230913     C                   EVAL      AUIN = 'Y'                                                 CAP211
181800230913      *                                                                                       CAP211
181900230913     C                   ENDIF                                                                CAP211
182000230913      *                                                                                     MD030940
182100230913     C                   EVAL      DATE = 0                                                 MD030940
182200230913     C/COPY WNCPYSRC,FTH00433
182300230913     C                   UPDATE    INPAYDDF                             99
182400230913      *
182500230913     C                   IF        *IN99 = *ON
182600230913     C                   MOVEL     IPPREF        DBKey
182700230913     C                   MOVEL     'INPAYDD'     DBFile
182800230913     C                   MOVEL     006           DBase
182900230913     C                   EXSR      *PSSR
183000230913     C                   ENDIF
183100230913     C/COPY WNCPYSRC,FTIPAYDC24
183200230913      *
183300230913      ** Perform shadow post update.
183400230913      *
183500230913     C                   EXSR      SRSHadow
183600230913      *
183700230913      ** Update Incoming Message FT Transaction Status File record.
183800230913      *
183900230913     C                   IF        INMSGR <> 0
184000230913      *
184100230913     C                   MOVEL     'MIN0031'     W0Flag
184200230913     C                   MOVEL     'MIN0029'     W0LMSG
184300230913     C                   MOVEL     *BLANKS       PNWRK
184400230913      *
184500230913     C                   EXSR      SRInFT
184600230913      *
184700230913     C                   ENDIF
184800230913     C/COPY WNCPYSRC,FTH00102
184900230913      *
185000230913     C                   ENDSR
185100230913      *
185200230913     C/COPY WNCPYSRC,FTH00454
185300230913      *****************************************************************                       CFT157
185400230913      *                                                               *                       CFT157
185500230913      *  SRStop   - Stop Incoming Payment transaction                 *                       CFT157
185600230913      *                                                               *                       CFT157
185700230913      *****************************************************************                       CFT157
185800230913      *                                                                                       CFT157
185900230913     C     SRStop        BEGSR                                                                CFT157
186000230913      *                                                                                       CFT157
186100230913      ** Check if record already exists in Incoming Payments file.                            CFT157
186200230913      ** Error if it does not exist.                                                          CFT157
186300230913      *                                                                                       CFT157
186400230913     C     IPPRef        CHAIN     INPAY                              99                      CFT157
186500230913      *                                                                                       CFT157
186600230913     C                   IF        *IN99 = *On                                                CFT157
186700230913     C                   MOVEL     IPPRef        DBKey                                        CFT157
186800230913     C                   MOVEL     'INPAYDD'     DBFile                                       CFT157
186900230913     C                   MOVEL     435           DBase                                        CFT157
187000230913     C                   EXSR      SRERR                                                      CFT157
187100230913     C                   ENDIF                                                                CFT157
187200230913      *                                                                                       CFT157
187300230913     C                   MOVE      InPayUpdF     CrIPFilFmt                                   CFT157
187400230913      *                                                                                       CFT157
187500230913      ** Process shadow post (reverse out original entries).                                  CFT157
187600230913      *                                                                                       CFT157
187700230913     C                   Z-SUB     SMAM          WVSMAM                                       CFT157
187800230913     C                   Z-SUB     PYAM          WVPYAM                                       CFT157
187900230913      *                                                                                       CFT157
188000230913     C                   IF        CRE020 = 'Y'                                               CFT157
188100230913     C                   EVAL      WRevAst = 'Y'                                              CFT157
188200230913     C                   ENDIF                                                                CFT157
188300230913      *                                                                                       CFT157
188400230913     C                   EXSR      SRAdd                                                      CFT157
188500230913      *                                                                                       CFT157
188600230913      ** Check if record already exists in Incoming Payments extension file                   CFT157
188700230913      ** Error if it does not exist.                                                          CFT157
188800230913      *                                                                                       CFT157
188900230913     C                   IF        CFT009 = 'Y'                                               CFT157
189000230913                                                                                              CFT157
189100230913     C     IPPREF        CHAIN     INPAYXL0                           99                      CFT157
189200230913      *                                                                                       CFT157
189300230913     C                   IF        *IN99 = *ON                                                CFT157
189400230913     C                   MOVEL     PREF          DBKEY                                        CFT157
189500230913     C                   MOVEL     'INPAYXPD'    DBFILE                                       CFT157
189600230913     C                   MOVEL     429           DBASE                                        CFT157
189700230913     C                   EXSR      SRERR                                                      CFT157
189800230913     C                   ENDIF                                                                CFT157
189900230913                                                                                              CFT157
190000230913     C                   ENDIF                                                                CFT157
190100230913      *                                                                                       CFT157
190200230913      ** Reverse Charges (Charge Amount is always debit).                                     CFT157
190300230913      *                                                                                       CFT157
190400230913     C                   EVAL      WVCHGS = TXCH + CQCH + ADCH                                CFT157
190500230913     C                                    + TLCH + MSCH + TRCM                                CFT157
190600230913      *                                                                                       CFT157
190700230913     C     S01494        IFEQ      'Y'                                                        CFT157
190800230913     C                   ADD       INCHCM        WVCHGS                                       CFT157
190900230913     C                   ENDIF                                                                CFT157
191000230913      *                                                                                       CFT157
191100230913     C     S01499        IFEQ      'Y'                                                        CFT157
191200230913     C     CFT009        ANDEQ     'N'                                                        CFT157
191300230913     C     CFT010        OREQ      'Y'                                                        CFT157
191400230913     C                   ADD       INVATT        WVCHGS                                       CFT157
191500230913     C                   ENDIF                                                                CFT157
191600230913      *                                                                                       CFT157
191700230913      ** Extra charges                                                                        CFT157
191800230913      *                                                                                       CFT157
191900230913     C     CFT009        IFEQ      'Y'                                                        CFT157
192000230913     C                   ADD       MSC01         WVCHGS                                       CFT157
192100230913     C                   ADD       MSC02         WVCHGS                                       CFT157
192200230913     C                   ADD       MSC03         WVCHGS                                       CFT157
192300230913     C                   ADD       MSC04         WVCHGS                                       CFT157
192400230913     C                   ADD       MSC05         WVCHGS                                       CFT157
192500230913     C                   ENDIF                                                                CFT157
192600230913      *                                                                                       CFT157
192700230913     C     WVCHGS        IFNE      0                                                          CFT157
192800230913     C                   Z-SUB     WVCHGS        WVCHGS                                       CFT157
192900230913     C                   IF        CRE020 = 'Y'                                               CFT157
193000230913     C                   EVAL      WRevAst = 'Y'                                              CFT157
193100230913     C                   ENDIF                                                                CFT157
193200230913     C                   EXSR      SRSChg                                                     CFT157
193300230913     C                   ENDIF                                                                CFT157
193400230913      *                                                                                       CFT157
193500230913      ** Generate Timestamp.                                                                  CFT157
193600230913      *                                                                                       CFT157
193700230913     C                   CALLB     'ZAGENTMSTM'                                               CFT157
193800230913     C                   PARM                    PTimestamp                                   CFT157
193900230913      *                                                                                       CFT157
194000230913     C                   EVAL      IPTMST = PTimestamp                                        CFT157
194100230913      *                                                                                       CFT157
194200230913      ** Move valid file details to update file details.                                      CFT157
194300230913      *                                                                                       CFT157
194400230913     C                   MOVEL     NwIpFilFmt    InPayUpdF                                    CFT157
194500230913      *                                                                                       CFT157
194600230913     C                   MOVE      'C'           RECI                                         CFT157
194700230913     C                   Z-ADD     BJRDNB        DATE                                         CFT157
194800230913      *                                                                                       CFT157
194900230913     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CFT157
195000230913      *                                                                                       CFT157
195100230913      ** Set the value of Authorised flag ('Y') and the Authorising profile                   CFT157
195200230913      ** if CAP211 is ON and PAuth is 'Y'.                                                    CFT157
195300230913      *                                                                                       CFT157
195400230913     C                   IF        PUser = *Blanks                                            CFT157
195500230913     C                   EVAL      SAUS = SUSR                                                CFT157
195600230913     C                   ELSE                                                                 CFT157
195700230913     C                   EVAL      SAUS = PUser                                               CFT157
195800230913     C                   ENDIF                                                                CFT157
195900230913     C                   EVAL      AUIN = 'Y'                                                 CFT157
196000230913      *                                                                                       CFT157
196100230913     C                   ELSE                                                                 CFT157
196200230913     C                   EVAL      AUIN = 'Y'                                                 CFT157
196300230913     C                   ENDIF                                                                CFT157
196400230913      *                                                                                       CFT157
196500230913     C                   UPDATE    INPAYDDF                             99                    CFT157
196600230913      *                                                                                       CFT157
196700230913     C                   IF        *IN99 = *ON                                                CFT157
196800230913     C                   MOVEL     IPPREF        DBKey                                        CFT157
196900230913     C                   MOVEL     'INPAYDD'     DBFile                                       CFT157
197000230913     C                   MOVEL     438           DBase                                        CFT157
197100230913     C                   EXSR      *PSSR                                                      CFT157
197200230913     C                   ENDIF                                                                CFT157
197300230913      *                                                                                       CFT157
197400230913      ** Perform shadow post update.                                                          CFT157
197500230913      *                                                                                       CFT157
197600230913     C                   EXSR      SRSHadow                                                   CFT157
197700230913      *                                                                                       CFT157
197800230913      ** Update Incoming Message FT Transaction Status File record.                           CFT157
197900230913      *                                                                                       CFT157
198000230913     C                   IF        INMSGR <> 0                                                CFT157
198100230913      *                                                                                       CFT157
198200230913     C                   MOVEL     'MIN0031'     W0Flag                                       CFT157
198300230913     C                   MOVEL     'MIN0029'     W0LMSG                                       CFT157
198400230913     C                   MOVEL     *BLANKS       PNWRK                                        CFT157
198500230913      *                                                                                       CFT157
198600230913     C                   EXSR      SRInFT                                                     CFT157
198700230913      *                                                                                       CFT157
198800230913     C                   ENDIF                                                                CFT157
198900230913      *                                                                                       CFT157
199000230913     C                   ENDSR                                                                CFT157
199100230913      *                                                                                       CFT157
199200230913      *****************************************************************
199300230913      /Title SR/SRLOGTRAN                                                                     CSC011
199400230913      *****************************************************************                       CSC011
199500230913      *                                                               *                       CSC011
199600230913      * SRLOGTRAN  - Write Transaction to Log file.                   *                       CSC011
199700230913      *                                                               *                       CSC011
199800230913      * Called By: Main Routine                                       *                       CSC011
199900230913      *                                                               *                       CSC011
200000230913      * Calls:                                                        *                       CSC011
200100230913      * FTIPAYLOG   - Incoming Payment Log Module                     *                       CSC011
200200230913      * APLOGTRAN   - AP Log Transactions from the Support Database   *                       CSC011
200300230913      *                                                               *                       CSC011
200400230913      *****************************************************************                       CSC011
200500230913                                                                                              CSC011
200600230913     C     SRLOGTRAN     BEGSR                                                                CSC011
200700230913                                                                                              CSC011
200800230913      ** Call log module.                                                                     CSC011
200900230913                                                                                              CSC011
201000230913     C                   CALLB     'FTIPAYLOG'                                                CSC011
201100230913     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
201200230913     C                   PARM                    InPayUpdF                                    CSC011
201300230913     C                   PARM                    CrIP2FilFmt                                  CSC011
201400230913     C                   PARM                    PACTN                                        CSC011
201500230913     C                   PARM                    S01494                                       CSC011
201600230913     C                   PARM                    S01499                                       CSC011
201700230913     C                   PARM                    CFT014                                       CSC011
201800230913     C                   PARM                    CFT009                                       CSC011
201900230913     C                   PARM                    CFT010                                       CSC011
202000230913     C                   PARM      *BLANKS       TRANSDTL                                     CSC011
202100230913                                                                                              CSC011
202200230913      ** No error, write the transaction via APLOGTRAN module.                                CSC011
202300230913                                                                                              CSC011
202400230913     C                   IF        RetCodeOut = *BLANKS                                       CSC011
202500230913     C                   EVAL      APTGTTYPE = 'FTIPAY'                                       CSC011
202600230913     C                   EVAL      APFOTRANID = IPFRNT                                        CSC011
202700230913     C                   EVAL      APRPRLOCN = IPREPA                                         CSC011
202800230913     C                   EVAL      APUSERID   = PSUser                                        CSC011
202900230913     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
203000230913                                                                                              CSC011
203100230913     C                   CALLB     'APLOGTRAN'                                                CSC011
203200230913     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
203300230913     C                   PARM                    APHEAD                                       CSC011
203400230913     C                   PARM                    TRANSDTL                                     CSC011
203500230913     C                   PARM      *BLANKS       PTIMESTMP                                    CSC011
203600230913     C                   PARM      IPPREF        PREFERENCE                                   CSC011
203700230913     C                   PARM      *BLANKS       PAREFERENCE                                  CSC011
203800230913     C                   ENDIF                                                                CSC011
203900230913                                                                                              CSC011
204000230913      ** Error encountered.                                                                   CSC011
204100230913                                                                                              CSC011
204200230913     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
204300230913     C                   EVAL      RetCodeIn = '*ERROR'                                       CSC011
204400230913     C                   ENDIF                                                                CSC011
204500230913                                                                                              CSC011
204600230913     C                   ENDSR                                                                CSC011
204700230913      *****************************************************************                       CSC011
204800230913      /EJECT
204900230913      *****************************************************************
205000230913      *                                                               *
205100230913      *  SRClr - Clear all positions in store                         *
205200230913      *                                                               *
205300230913      *****************************************************************
205400230913      *
205500230913     C     SRClr         BEGSR
205600230913      *
205700230913      ** Clear arrays in AOSPOSU0.
205800230913      *
205900230913     C                   CLEAR                   C_DTA
206000230913      *
206100230913     C                   CALLB     'AOSPOSU0'                           9090
206200230913     C                   PARM      *BLANKS       PRtcd
206300230913     C                   PARM      '*CLEAR  '    PACT
206400230913     C                   PARM      C_DTA         PDTA
206500230913      *
206600230913     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
206700230913     C                   MOVEL     '*CALL'       DBKey
206800230913     C                   MOVEL     'AOSPOSU0'    DBFile
206900230913     C                   MOVEL     007           DBase
207000230913     C                   EXSR      *PSSR
207100230913     C                   ENDIF
207200230913      *
207300230913     C/COPY WNCPYSRC,FTH00409
207400230913     C                   ENDSR
207500230913      *
207600230913      *****************************************************************
207700230913      /EJECT
207800230913      *****************************************************************
207900230913      *                                                               *
208000230913      *  SRAdd - Add shadow positions to store                        *
208100230913      *                                                               *
208200230913      *****************************************************************
208300230913      *
208400230913     C     SRAdd         BEGSR
208500230913      *
208600230913      ** Define Settle and Pay Amounts.
208700230913      *
208800230913     C     *LIKE         DEFINE    SMAM          WVSMAM
208900230913     C     *LIKE         DEFINE    PYAM          WVPYAM
208901230913      *                                                                                       BA5021
208902230913      *  If BA5021 is present, execute addition of shadow postings for                        BA5021
208903230913      *  settlement and payment instructions only if the                                      BA5021
208904230913      *  settlement currency = payment currency.                                              BA5021
208905230913      *                                                                                       BA5021
208906230913     C                   If        (BA5021 = 'Y' and SMCY = PCCY)                             BA5021
208907230913     C                             or (BA5021 <> 'Y')                                         BA5021
209000230913      *
209100230913      ** Execute addition of shadow positions for settlement
209200230913      ** instruction only if maintenance was called from Level 1.
209300230913      *
209400230913     C                   IF        PParmLevel = '1'
209500230913      *
209600230913      ** SETTLEMENT INSTRUCTIONS.
209700230913      *
209800230913     C                   CLEAR                   C_DTA
209900230913      *
210000230913      ** Move fields to C_DTA structure.
210100230913      *
210200230913     C***********        IF        RCRT <> *BLANKS                              CFT014
210300230913     C***********        MOVEL     RCRT          C_ATYP                         CFT014
210400230913     C***********        MOVEL     RCCO          C_ACCT                         CFT014
210500230913      *                                                                         CFT014
210600230913     C                   IF        INTRIT <> *BLANKS and CFT014 = 'Y'           CFT014
210700230913     C                   MOVEL     INTRIT        C_ATYP                         CFT014
210800230913      *                                                                         CFT014
210900230913      ** Determine corresponding Midas account of IBAN account                  CFT014
211000230913      ** for Third Reimbursement Institution.                                   CFT014
211100230913      *                                                                         CFT014
211200230913     C                   IF        INTRIT = 'I' and CFT004 = 'Y'                CFT014
211300230913     C                   MOVEL     INTRIB        PIBAN                          CFT014
211400230913     C                   MOVE      *BLANKS       DSSDY                          CFT014
211500230913     C                   CALLB     'AOIBANR4'                                   CFT014
211600230913     C                   PARM      *BLANKS       PNRTCD                         CFT014
211700230913     C                   PARM      '*KEY   '     PNOPTN                         CFT014
211800230913     C                   PARM                    PIBAN                          CFT014
211900230913     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
212000230913      *                                                                         CFT014
212100230913     C                   IF        PNRTCD <> *BLANKS                            CFT014
212200230913     C                   EVAL      DBKey = PIBAN                                CFT014
212300230913     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
212400230913     C                   Z-ADD     024           DBase                          CFT014
212500230913     C                   EXSR      SRERR                                        CFT014
212600230913     C                   ENDIF                                                  CFT014
212700230913      *                                                                         CFT014
212800230913     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
212900230913     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
213000230913     C                   MOVE      CCY           WICCY                          CFT014
213100230913     C                   Z-ADD     ACOD          WIACOD                         CFT014
213200230913     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
213300230913     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
213400230913     C                   MOVEL     WIACNT        C_ACCT                         CFT014
213500230913     C                   EXSR      SRFLGL                                                     CGL029
213600230913      *                                                                         CFT014
213700230913     C                   ELSE                                                   CFT014
213800230913     C                   MOVEL     INTRIB        C_ACCT                         CFT014
213900230913     C                   EXSR      SRFLGL                                                     CGL029
214000230913     C                   ENDIF                                                  CFT014
214100230913      *                                                                         CFT014
214200230913     C                   ELSE                                                   CFT014
214300230913      *                                                                         CFT014
214400230913     C                   IF        INRCRT <> *BLANKS                            CFT014
214500230913     C                   MOVEL     INRCRT        C_ATYP                         CFT014
214600230913      *                                                                         CFT014
214700230913      ** Determine corresponding Midas account of IBAN account                  CFT014
214800230913      ** for Receiver's Correspondent.                                          CFT014
214900230913      *                                                                         CFT014
215000230913     C                   IF        INRCRT = 'I' and CFT004 = 'Y'                CFT014
215100230913     C                   EVAL      PIBAN = %SUBST(INRCO1:2:34)                  CFT014
215200230913     C                   CALLB     'AOIBANR4'                                   CFT014
215300230913     C                   PARM      *BLANKS       PNRTCD                         CFT014
215400230913     C                   PARM      '*KEY   '     PNOPTN                         CFT014
215500230913     C                   PARM                    PIBAN                          CFT014
215600230913     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
215700230913      *                                                                         CFT014
215800230913     C                   IF        PNRTCD <> *BLANKS                            CFT014
215900230913     C                   EVAL      DBKey = PIBAN                                CFT014
216000230913     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
216100230913     C                   Z-ADD     025           DBase                          CFT014
216200230913     C                   EXSR      SRERR                                        CFT014
216300230913     C                   ENDIF                                                  CFT014
216400230913      *                                                                         CFT014
216500230913     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
216600230913     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
216700230913     C                   MOVE      CCY           WICCY                          CFT014
216800230913     C                   Z-ADD     ACOD          WIACOD                         CFT014
216900230913     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
217000230913     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
217100230913     C                   MOVEL     WIACNT        C_ACCT                         CFT014
217200230913     C                   EXSR      SRFLGL                                                     CGL029
217300230913      *                                                                         CFT014
217400230913     C                   ELSE                                                   CFT014
217500230913     C                   MOVEL     INRCO1        C_ACCT                         CFT014
217600230913     C                   EXSR      SRFLGL                                                     CGL029
217700230913     C                   ENDIF                                                  CFT014
217800230913      *                                                                         CFT014
217900230913     C                   ELSE
218000230913     C                   MOVEL     SNTP          C_ATYP
218100230913     C                   MOVEL     SND1          C_ACCT
218200230913     C                   EXSR      SRFLGL                                                     CGL029
218300230913     C                   ENDIF
218400230913      *                                                                         CFT014
218500230913     C                   ENDIF                                                  CFT014
218600230913      *
218700230913     C                   Z-ADD     SLDT          C_VDAT
218800230913      *
218900230913      ** Set Posting Date according to FT Control Data.
219000230913      *
219100230913     C                   IF        WPDTI  = 'I'
219200230913     C                   Z-ADD     BJRDNB        C_PSTD
219300230913     C                   ELSE
219400230913      *
219500230913     C                   IF        WPDTI  = 'E'
219600230913     C                   Z-ADD     SLDT          C_PSTD
219700230913     C                   ELSE
219800230913      *
219900230913     C                   IF        SLDT < PVDT
220000230913     C                   Z-ADD     SLDT          C_PSTD
220100230913     C                   ELSE
220200230913     C                   Z-ADD     PVDT          C_PSTD
220300230913     C                   ENDIF
220400230913      *
220500230913     C                   ENDIF
220600230913      *
220700230913     C                   ENDIF
220800230913      *
220900230913     C                   MOVEL     'I'           C_IO
221000230913     C                   MOVEL     SMCY          C_CCY
221100230913     C                   MOVEL     PYTP          C_TRYP
221200230913     C                   MOVEL     PREF          C_PRef
221300230913     C                   IF        CRE020 = 'Y'                                               CRE020
221400230913     C                   MOVEL     PREF          C_NARR                                       CRE020
221500230913     C                   Z-ADD     1             C_CHQN                                       CRE020
221600230913     C                   IF        WRevAst = 'Y'                                              CRE020
221700230913     C                   EVAL      %SUBST(C_NARR:30:1) = '*'                                  CRE020
221800230913     C                   ENDIF                                                                CRE020
221900230913     C                   ENDIF                                                                CRE020
222000230913     C                   Z-ADD     WVSMAM        C_AMT
222100230913     C                   MOVEL     'FT'          C_MOD
222200230913     C                   MOVEL     '01'          C_OLRC
222300230913     C                   MOVEL     PFTOV         C_FTOV
222400230913     C                   MOVEL     'Y'           C_RPST
222500230913     C                   Z-ADD     10            C_RPNB
222600230913     C                   MOVEL     'D'           C_RTYP
222700230913     C                   IF        CAP205 = 'Y'                                               CAP205
222800230913     C                   MOVEL     'F'           C_MTYP                                       CAP205
222900230913     C                   ENDIF                                                                CAP205
223000230913     C/COPY WNCPYSRC,FTH00391
223100230913      *
223200230913      ** Call AOSPOSU0.
223300230913      *
223400230913     C                   CALLB     'AOSPOSU0'                           9090
223500230913     C                   PARM      *BLANKS       PRtcd
223600230913     C                   PARM      '*ADD    '    PACT
223700230913     C                   PARM      C_DTA         PDTA
223800230913      *
223900230913     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
224000230913     C                   MOVEL     '*CALL'       DBKey
224100230913     C                   MOVEL     'AOSPOSU0'    DBFile
224200230913     C                   MOVEL     008           DBase
224300230913     C                   EXSR      *PSSR
224400230913     C                   ENDIF
224500230913      *
224600230913     C/COPY WNCPYSRC,FTH00410
224700230913     C                   ENDIF
224800230913      *
224900230913      ** PAYMENT INSTRUCTIONS.
225000230913      *
225100230913     C                   IF        ACBT = *BLANK OR
225200230913     C                             OPIN <> 'Y'
225300230913      *
225400230913      ** Only execute if Outgoing Payment not to be generated.
225500230913      *
225600230913     C                   CLEAR                   C_DTA
225700230913     C/COPY WNCPYSRC,FTH00485
225800230913      *
225900230913      ** Move fields to C_DTA structure.
226000230913      *
226100230913     C                   IF        ACBT <> *BLANKS
226200230913     C                   MOVEL     ACBT          C_ATYP
226300230913     C                   MOVEL     ACBK          C_ACCT
226400230913     C                   EXSR      SRFLGL                                                     CGL029
226500230913     C                   MOVEL     ACBB          C_BRCA
226600230913     C                   ELSE
226700230913     C                   MOVEL     BNCT          C_ATYP
226800230913      *
226900230913      ** If not IBAN
227000230913     C                   IF        BNCT <> 'I' AND CFT004 = 'Y' OR
227100230913     C                             CFT004 <> 'Y'
227200230913     C                   MOVEL     BNC1          C_ACCT
227300230913     C                   EXSR      SRFLGL                                                     CGL029
227400230913     C                   ELSE
227500230913      *                                                                         CFT014
227600230913     C                   EVAL      PIBAN = %SUBST(BNC1:2:34)                    CFT014
227700230913     C                   CALLB     'AOIBANR4'                                   CFT014
227800230913     C                   PARM      *BLANKS       PNRTCD                         CFT014
227900230913     C                   PARM      '*KEY   '     PNOPTN                         CFT014
228000230913     C                   PARM                    PIBAN                          CFT014
228100230913     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
228200230913      *                                                                         CFT014
228300230913     C                   IF        PNRTCD <> *BLANKS                            CFT014
228400230913     C                   EVAL      DBKey = PIBAN                                CFT014
228500230913     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
228600230913     C                   Z-ADD     026           DBase                          CFT014
228700230913     C                   EXSR      SRERR                                        CFT014
228800230913     C                   ENDIF                                                  CFT014
228900230913      *                                                                         CFT014
229000230913     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
229100230913     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
229200230913     C                   MOVE      CCY           WICCY                          CFT014
229300230913     C                   Z-ADD     ACOD          WIACOD                         CFT014
229400230913     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
229500230913     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
229600230913     C                   MOVEL     WIACNT        C_ACCT                         CFT014
229700230913     C                   EXSR      SRFLGL                                                     CGL029
229800230913     C***********        Z-ADD     IBCNUM        C_CNU1                         CFT014
229900230913     C***********        MOVE      IBCCY         C_CCY1                         CFT014
230000230913     C***********        Z-ADD     IBACOD        C_ACO1                         CFT014
230100230913     C***********        Z-ADD     IBACSQ        C_ACS1                         CFT014
230200230913     C***********        MOVE      IBBRCA        C_BRC1                         CFT014
230300230913      *                                                                         CFT014
230400230913     C                   ENDIF
230500230913     C                   ENDIF
230600230913      *
230700230913     C                   Z-ADD     PVDT          C_VDAT
230800230913      *
230900230913      ** Set Posting Date according to FT Control Data.
231000230913      *
231100230913     C                   IF        WPDTI  = 'I'
231200230913     C                   Z-ADD     BJRDNB        C_PSTD
231300230913     C                   ELSE
231400230913      *
231500230913     C                   IF        WPDTI  = 'E'
231600230913     C                   Z-ADD     PVDT          C_PSTD
231700230913     C                   ELSE
231800230913      *
231900230913     C                   IF        SLDT < PVDT
232000230913     C                   Z-ADD     SLDT          C_PSTD
232100230913     C                   ELSE
232200230913     C                   Z-ADD     PVDT          C_PSTD
232300230913     C                   ENDIF
232400230913      *
232500230913     C                   ENDIF
232600230913      *
232700230913     C                   ENDIF
232800230913      *
232900230913     C                   MOVEL     'O'           C_IO
233000230913     C                   MOVEL     PCCY          C_CCY
233100230913     C                   MOVEL     PYTP          C_TRYP
233200230913     C                   MOVEL     PREF          C_PRef
233300230913     C                   IF        CRE020 = 'Y'                                               CRE020
233400230913     C                   MOVEL     PREF          C_NARR                                       CRE020
233500230913     C                   Z-ADD     2             C_CHQN                                       CRE020
233600230913     C                   IF        WRevAst = 'Y'                                              CRE020
233700230913     C                   EVAL      WRevAst = ' '                                              CRE020
233800230913     C                   EVAL      %SUBST(C_NARR:30:1) = '*'                                  CRE020
233900230913     C                   ENDIF                                                                CRE020
234000230913     C                   ENDIF                                                                CRE020
234100230913     C                   Z-SUB     WVPYAM        C_AMT
234200230913     C                   MOVEL     'FT'          C_MOD
234300230913     C                   MOVEL     '01'          C_OLRC
234400230913     C                   MOVEL     PFTOV         C_FTOV
234500230913     C                   MOVEL     'Y'           C_RPST
234600230913     C                   Z-ADD     20            C_RPNB
234700230913     C                   MOVEL     'C'           C_RTYP
234800230913     C                   IF        CAP205 = 'Y'                                               CAP205
234900230913     C                   MOVEL     'F'           C_MTYP                                       CAP205
235000230913     C                   ENDIF                                                                CAP205
235100230913     C/COPY WNCPYSRC,FTH00507
235200230913      *
235300230913      ** Call AOSPOSU0.
235400230913      *
235500230913     C                   CALLB     'AOSPOSU0'                           9090
235600230913     C                   PARM      *BLANKS       PRtcd
235700230913     C                   PARM      '*ADD    '    PACT
235800230913     C                   PARM      C_DTA         PDTA
235900230913      *
236000230913     C                   IF        *IN90 = '1' OR Prtcd <> *BLANKS
236100230913     C                   MOVEL     '*CALL'       DBKey
236200230913     C                   MOVEL     'AOSPOSU0'    DBFile
236300230913     C                   MOVEL     009           DBase
236400230913     C                   EXSR      *PSSR
236500230913     C                   ENDIF
236600230913     C/COPY WNCPYSRC,FTH00486
236700230913      *
236800230913     C                   ENDIF
236900230913      *
237000230913     C/COPY WNCPYSRC,FTH00411
237001230913     C                   EndIf                                                                BA5021
237100230913     C                   ENDSR
237200230913      *
237300230913      *****************************************************************
237400230913      /EJECT
237500230913      *****************************************************************
237600230913      *                                                               *
237700230913      *  SRSChg - Amend charges from database                         *
237800230913      *                                                               *
237900230913      *****************************************************************
238000230913      *
238100230913     C     SRSChg        BEGSR
238200230913      *
238300230913     C     *LIKE         DEFINE    C_AMT         WVCHGS
238400230913      *
238500230913      ** Move fields to C_DTA structure.
238600230913      *
238700230913     C                   CLEAR                   C_DTA
238800230913      *
238900230913      ** If add, use Receiver's Correspondent and Sender.
239000230913      *
239100230913     C                   SELECT
239200230913      *
239300230913     C     CDRT          WHENNE    *BLANKS
239400230913     C                   MOVEL     CDRT          C_ATYP
239500230913     C                   MOVEL     CDRO          C_ACCT
239600230913     C                   EXSR      SRFLGL                                                     CGL029
239700230913     C                   MOVEL     CDBR          C_BRCA
239800230913      *                                                                                       CFT120
239900230913     C                   IF        CFT120 = 'N'  OR                                           CFT120
240000230913     C                             CFT120 = 'Y' AND INCDRC = *BLANKS                          CFT120
240100230913     C                   MOVEL     BJCYCD        C_CCY
240200230913     C                   ELSE                                                                 CFT120
240300230913     C                   MOVEL     INCDRC        C_CCY                                        CFT120
240400230913     C                   ENDIF                                                                CFT120
240500230913      *                                                                                       CFT120
240600230913     C                   IF        ADDC = 'A'
240700230913     C                   Z-ADD     SLDT          C_VDAT
240800230913     C                   ELSE
240900230913     C                   Z-ADD     PVDT          C_VDAT
241000230913     C                   ENDIF
241100230913      *
241200230913     C     ADDC          WHENEQ    'A'
241300230913     C                   MOVEL     SMCY          C_CCY
241400230913     C***********        IF        RCRT <> *BLANKS                              CFT014
241500230913     C***********        MOVEL     RCRT          C_ATYP                         CFT014
241600230913     C***********        MOVEL     RCCO          C_ACCT                         CFT014
241700230913      *                                                                         CFT014
241800230913     C                   IF        INTRIT <> *BLANKS and CFT014 = 'Y'           CFT014
241900230913     C                   MOVEL     INTRIT        C_ATYP                         CFT014
242000230913      *                                                                         CFT014
242100230913      ** Determine corresponding Midas account of IBAN account                  CFT014
242200230913      ** for Third Reimbursement Institution.                                   CFT014
242300230913      *                                                                         CFT014
242400230913     C                   IF        INTRIT = 'I' and CFT004 = 'Y'                CFT014
242500230913     C                   EVAL      PIBAN = INTRIB                               CFT014
242600230913     C                   CALLB     'AOIBANR4'                                   CFT014
242700230913     C                   PARM      *BLANKS       PNRTCD                         CFT014
242800230913     C                   PARM      '*KEY   '     PNOPTN                         CFT014
242900230913     C                   PARM                    PIBAN            34            CFT014
243000230913     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
243100230913      *                                                                         CFT014
243200230913     C                   IF        PNRTCD <> *BLANKS                            CFT014
243300230913     C                   EVAL      DBKey = PIBAN                                CFT014
243400230913     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
243500230913     C                   Z-ADD     026           DBase                          CFT014
243600230913     C                   EXSR      SRERR                                        CFT014
243700230913     C                   ENDIF                                                  CFT014
243800230913      *                                                                         CFT014
243900230913     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
244000230913     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
244100230913     C                   MOVE      CCY           WICCY                          CFT014
244200230913     C                   Z-ADD     ACOD          WIACOD                         CFT014
244300230913     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
244400230913     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
244500230913     C                   MOVEL     WIACNT        C_ACCT                         CFT014
244600230913     C                   EXSR      SRFLGL                                                     CGL029
244700230913      *                                                                         CFT014
244800230913     C                   ELSE                                                   CFT014
244900230913     C                   MOVEL     INTRIB        C_ACCT                         CFT014
245000230913     C                   EXSR      SRFLGL                                                     CGL029
245100230913     C                   ENDIF                                                  CFT014
245200230913      *                                                                         CFT014
245300230913     C                   ELSE                                                   CFT014
245400230913      *                                                                         CFT014
245500230913     C                   IF        INRCRT <> *BLANKS                            CFT014
245600230913     C                   MOVEL     INRCRT        C_ATYP                         CFT014
245700230913      *                                                                         CFT014
245800230913      ** Determine corresponding Midas account of IBAN account                  CFT014
245900230913      ** for Receiver's Correspondent.                                          CFT014
246000230913      *                                                                         CFT014
246100230913     C                   IF        INRCRT = 'I' and CFT004 = 'Y'                CFT014
246200230913     C                   EVAL      PIBAN = %SUBST(INRCO1:2:34)                  CFT014
246300230913     C                   CALLB     'AOIBANR4'                                   CFT014
246400230913     C                   PARM      *BLANKS       PNRTCD                         CFT014
246500230913     C                   PARM      '*KEY   '     PNOPTN                         CFT014
246600230913     C                   PARM                    PIBAN                          CFT014
246700230913     C     P@ACCN        PARM      *BLANKS       DSSDY                          CFT014
246800230913      *                                                                         CFT014
246900230913     C                   IF        PNRTCD <> *BLANKS                            CFT014
247000230913     C                   EVAL      DBKey = PIBAN                                CFT014
247100230913     C                   EVAL      DBFile = 'ACCNTAB'                           CFT014
247200230913     C                   Z-ADD     027           DBase                          CFT014
247300230913     C                   EXSR      SRERR                                        CFT014
247400230913     C                   ENDIF                                                  CFT014
247500230913      *                                                                         CFT014
247600230913     C**********         Z-ADD     CNUM          WICNUM                         CFT014        CSD027
247700230913     C                   EVAL      WICNUM = CNUM                                CFT014        CSD027
247800230913     C                   MOVE      CCY           WICCY                          CFT014
247900230913     C                   Z-ADD     ACOD          WIACOD                         CFT014
248000230913     C                   Z-ADD     ACSQ          WIACSQ                         CFT014
248100230913     C                   MOVE      IBNBRCA       WIBRCA                         CFT014
248200230913     C                   MOVEL     WIACNT        C_ACCT                         CFT014
248300230913     C                   EXSR      SRFLGL                                                     CGL029
248400230913      *                                                                         CFT014
248500230913     C                   ELSE                                                   CFT014
248600230913     C                   MOVEL     INRCO1        C_ACCT                         CFT014
248700230913     C                   EXSR      SRFLGL                                                     CGL029
248800230913     C                   ENDIF                                                  CFT014
248900230913      *                                                                         CFT014
249000230913     C                   ELSE
249100230913     C                   MOVEL     SNTP          C_ATYP
249200230913     C                   MOVEL     SND1          C_ACCT
249300230913     C                   EXSR      SRFLGL                                                     CGL029
249400230913     C                   ENDIF
249500230913      *                                                                         CFT014
249600230913     C                   ENDIF                                                  CFT014
249700230913      *                                                                         CFT014
249800230913     C                   Z-ADD     SLDT          C_VDAT
249900230913      *
250000230913      ** If deduct, use Account with Bank and Beneficiary.
250100230913      *
250200230913     C                   OTHER
250300230913     C                   MOVEL     PCCY          C_CCY
250400230913     C                   IF        ACBT <> *BLANKS
250500230913     C                   MOVEL     ACBT          C_ATYP
250600230913     C                   MOVEL     ACBK          C_ACCT
250700230913     C                   EXSR      SRFLGL                                                     CGL029
250800230913     C                   MOVEL     ACBB          C_BRCA
250900230913     C                   ELSE
251000230913     C                   MOVEL     BNCT          C_ATYP
251100230913      *                                                                                       229560
251200230913      ** Extract the a/c name if IBAN before call to AOSPOS                                   229560
251300230913b1   C                   IF        BNCT = 'I' AND CFT004 = 'Y'                                229560
251400230913      *                                                                                       229560
251500230913     C                   EVAL      PIBAN = %SUBST(BNC1:2:34)                                  229560
251600230913     C                   CALLB     'AOIBANR4'                                                 229560
251700230913     C                   PARM      *BLANKS       PNRTCD                                       229560
251800230913     C                   PARM      '*KEY   '     PNOPTN                                       229560
251900230913     C                   PARM                    PIBAN                                        229560
252000230913     C     P@ACCN        PARM      *BLANKS       DSSDY                                        229560
252100230913      *                                                                                       229560
252200230913b2   C                   IF        PNRTCD <> *BLANKS                                          229560
252300230913     C                   EVAL      DBKey = PIBAN                                              229560
252400230913     C                   EVAL      DBFile = 'ACCNTAB'                                         229560
252500230913     C                   Z-ADD     926           DBase                                        229560
252600230913     C                   EXSR      SRERR                                                      229560
252700230913e2   C                   ENDIF                                                                229560
252800230913      *                                                                                       229560
252900230913     C**********         Z-ADD     CNUM          WICNUM                                229560 CSD031
253000230913     C                   EVAL      WICNUM = CNUM                                              CSD031
253100230913     C                   MOVE      CCY           WICCY                                        229560
253200230913     C                   Z-ADD     ACOD          WIACOD                                       229560
253300230913     C                   Z-ADD     ACSQ          WIACSQ                                       229560
253400230913     C                   MOVE      IBNBRCA       WIBRCA                                       229560
253500230913     C                   MOVEL     WIACNT        C_ACCT                                       229560
253600230913x1   C                   ELSE                                                                 229560
253700230913     C                   MOVEL     BNC1          C_ACCT
253800230913e1   C                   ENDIF                                                                229560
253900230913     C                   EXSR      SRFLGL                                                     CGL029
254000230913     C                   ENDIF
254100230913     C                   Z-ADD     PVDT          C_VDAT
254200230913      *
254300230913     C                   ENDSL
254400230913      *
254500230913      ** Set Posting Date according to FT Control Data.
254600230913      *
254700230913     C                   IF        WPDTI  = 'I'
254800230913     C                   Z-ADD     BJRDNB        C_PSTD
254900230913     C                   ELSE
255000230913      *
255100230913     C                   IF        WPDTI  = 'E'
255200230913      *
255300230913     C                   IF        ADDC = 'A'
255400230913     C                   Z-ADD     SLDT          C_PSTD
255500230913     C                   ELSE
255600230913     C                   Z-ADD     PVDT          C_PSTD
255700230913     C                   ENDIF
255800230913      *
255900230913     C                   ELSE
256000230913      *
256100230913     C                   IF        SLDT < PVDT
256200230913     C                   Z-ADD     SLDT          C_PSTD
256300230913     C                   ELSE
256400230913     C                   Z-ADD     PVDT          C_PSTD
256500230913     C                   ENDIF
256600230913      *
256700230913     C                   ENDIF
256800230913      *
256900230913     C                   ENDIF
257000230913      *
257100230913     C                   MOVEL     'I'           C_IO
257200230913     C                   MOVEL     PYTP          C_TRYP
257300230913     C                   MOVEL     PREF          C_PRef
257400230913     C                   IF        CRE020 = 'Y'                                               CRE020
257500230913     C                   MOVEL     PREF          C_NARR                                       CRE020
257600230913     C                   Z-ADD     3             C_CHQN                                       CRE020
257700230913     C                   IF        WRevAst = 'Y'                                              CRE020
257800230913     C                   EVAL      WRevAst = ' '                                              CRE020
257900230913     C                   EVAL      %SUBST(C_NARR:30:1) = '*'                                  CRE020
258000230913     C                   ENDIF                                                                CRE020
258100230913     C                   ENDIF                                                                CRE020
258200230913     C                   MOVEL     'FT'          C_MOD
258300230913     C                   MOVEL     '01'          C_OLRC
258400230913     C                   MOVEL     PFTOV         C_FTOV
258500230913     C                   Z-ADD     WVCHGS        C_AMT
258600230913     C                   MOVEL     'Y'           C_RPST
258700230913     C                   Z-ADD     30            C_RPNB
258800230913     C                   MOVEL     'D'           C_RTYP
258900230913     C                   IF        CAP205 = 'Y'                                               CAP205
259000230913     C                   MOVEL     'F'           C_MTYP                                       CAP205
259100230913     C                   ENDIF                                                                CAP205
259200230913     C/COPY WNCPYSRC,FTIPAYDC07
259300230913      *
259400230913      ** Call AOSPOSU0.
259500230913      *
259600230913     C*******************CALL      'AOSPOSU0'                           9090    185764
259700230913     C                   CALLB     'AOSPOSU0'                           9090    185764
259800230913     C                   PARM      *BLANKS       PRtcd
259900230913     C                   PARM      '*ADD    '    PACT
260000230913     C                   PARM      C_DTA         PDTA
260100230913      *
260200230913     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
260300230913     C                   MOVEL     '*CALL'       DBKey
260400230913     C                   MOVEL     'AOSPOSU0'    DBFile
260500230913     C                   MOVEL     010           DBase
260600230913     C                   EXSR      *PSSR
260700230913     C                   ENDIF
260800230913      *
260900230913     C/COPY WNCPYSRC,FTH00412
261000230913     C                   ENDSR
261100230913      *
261200230913      *****************************************************************
261300230913      /EJECT
261400230913      *****************************************************************
261500230913      *                                                               *
261600230913      *  SRShadow - Update database with shadow positions             *
261700230913      *                                                               *
261800230913      *****************************************************************
261900230913      *
262000230913     C     SRShadow      BEGSR
262100230913      *
262200230913      ** Call AOSPOSU0 to update database.
262300230913      *
262400230913     C                   CALLB     'AOSPOSU0'                           9090
262500230913     C                   PARM      *BLANKS       PRtcd             7
262600230913     C                   PARM      '*UPDATE '    PACT              8
262700230913     C                   PARM      C_DTA         PDTA            256
262800230913      *
262900230913     C                   IF        *IN90 = '1' OR PRtcd <> *BLANKS
263000230913     C                   MOVEL     '*CALL'       DBKey
263100230913     C                   MOVEL     'AOSPOSU0'    DBFile
263200230913     C                   MOVEL     011           DBase
263300230913     C                   EXSR      *PSSR
263400230913     C                   ENDIF
263500230913     C/COPY WNCPYSRC,FTH00415
263600230913      *
263700230913     C                   ENDSR
263800230913     C/COPY WNCPYSRC,FTH00487
263900230913      *
264000230913      *****************************************************************
264100230913      /EJECT
264200230913      *****************************************************************
264300230913      *                                                               *
264400230913      *   SRMsgDel - Remove electronic message from the Outstanding   *
264500230913      *              Reserved Messages file after it has been         *
264600230913      *              inserted                                         *
264700230913      *                                                               *
264800230913      *****************************************************************
264900230913      *
265000230913     C     SRMsgDel      BEGSR
265100230913      *
265200230913      ** All electronic messages selected are held on the file FTINMGPD
265300230913      ** for reservation purposes.
265400230913      *
265500230913      ** The electronic message that was just inserted must be removed
265600230913      ** from the file.
265700230913      *
265800230913      ** The COMIT is done on the succesful completion of Insert
265900230913      ** processing.
266000230913      *
266100230913      ** Set up message ref. and part nbr.
266200230913      *
266300230913     C                   Z-ADD     INMSGR        PMsgr
266400230913     C                   Z-ADD     INKPRT        PKprt
266500230913      *
266600230913     C                   CALL      'ME1070'                             9090
266700230913     C                   PARM      '*DEL   '     PActC             7
266800230913     C                   PARM                    PMsgr             8 0
266900230913     C                   PARM                    PKprt             3 0
267000230913     C                   PARM                    PMor             28
267100230913     C                   PARM                    PMir             28
267200230913     C                   PARM      *BLANKS       PRtn              7
267300230913      *
267400230913      ** Error occurred.
267500230913      *
267600230913     C                   IF        *IN90 = '1' OR PRtn = '*ERROR*'
267700230913     C                   MOVEL     '*CALL'       DBKey
267800230913     C                   MOVEL     'ME1070'      DBFile
267900230913     C                   MOVEL     012           DBase
268000230913     C                   EXSR      *PSSR
268100230913     C                   ENDIF
268200230913      *
268300230913     C                   ENDSR
268400230913      *
268500230913      *****************************************************************
268600230913      /EJECT
268700230913      *****************************************************************
268800230913      *                                                               *
268900230913      *  SRInFT - Update Incoming Message FT Transaction Status       *
269000230913      *           File record                                         *
269100230913      *                                                               *
269200230913      *****************************************************************
269300230913      *
269400230913     C     SRInFT        BEGSR
269500230913      *
269600230913      ** Get full account details.
269700230913      *
269800230913     C                   EXSR      SRFulAccnt
269900230913      *
270000230913     C                   CLEAR                   PINFT
270100230913      *
270200230913      ** Fill record format data structure with available data.
270300230913      *
270400230913     C***********        IF        RCRT <> *BLANKS                              CFT014
270500230913     C                   IF        INRCRT <> *BLANKS                            CFT014
270600230913     C**********         MOVEL     WRCCDS        WFRWR            18                          CGL029
270700230913     C                   MOVEL     WRCCDS        WFRWR                                        CGL029
270800230913     C                   ELSE
270900230913     C                   MOVEL     WSNDDS        WFRWR
271000230913     C                   ENDIF
271100230913      *
271200230913     C                   IF        ACBT <> *BLANKS
271300230913     C**********         MOVEL     WACBDS        WTOWR            18                          CGL029
271400230913     C                   MOVEL     WACBDS        WTOWR                                        CGL029
271500230913     C                   ELSE
271600230913     C                   MOVEL     WBNCDS        WTOWR
271700230913     C                   ENDIF
271800230913      *
271900230913     C                   Z-ADD     INMSGR        FTMSGR
272000230913     C                   Z-ADD     INKPRT        FTKPRT
272100230913     C                   MOVEL     BRCA          FTBRCA
272200230913     C                   MOVEL     W0Flag        FTINFG
272300230913     C                   MOVEL     PREF          FTIPRF
272400230913     C                   MOVEL     WFRWR         FTFRGL
272500230913     C                   MOVEL     WTOWR         FTTOGL
272600230913      *
272700230913     C                   MOVEL     W0LMSG        PWLMSG
272800230913     C                   MOVEL     PNWRK         PWNWRK
272900230913      *                                                                                       CSW220
273000230913      ** Update MT199 Flag on reverse                                                         CSW220
273100230913      *                                                                                       CSW220
273200230913     C                   IF        CSW220 = 'Y' AND                                           CSW220
273300230913     C                             IPCHTP = 'D' AND                                           CSW220
273400230913     C                             FTM199 <> 'Z'                                              CSW220
273500230913     C                   EVAL      FTM199 = *BLANKS                                           CSW220
273600230913     C                   ENDIF                                                                CSW220
273700230913      *                                                                                     MD060066
273800230913      ** Update MT199 Flag to 'X' for Stop of Incoming Payment                              MD060066
273900230913      ** transaction where CSW220 is ON and MT199 is not 'Z'                                MD060066
274000230913      ** Note: The said field will be updated to blank in ME1050.                           MD060066
274100230913      *                                                                                     MD060066
274200230913     C                   IF        (CSW220 = 'Y' AND IPCHTP = 'S' AND                       MD060066
274300230913     C                              FTM199 <> 'Z')                                          MD060066
274400230913     C                   EVAL      FTM199 = 'X'                                             MD060066
274500230913     C                   ENDIF                                                              MD060066
274600230913      *
274700230913      ** N.B. Audit Stamp details are determined in called program.
274800230913      *
274900230913      ** Set up data to be passed using the rcd format data structure.
275000230913      *
275100230913     C                   CALL      'ME1050'                             9090
275200230913     C                   PARM      '*FT INC '    PWACT             8
275300230913     C                   PARM      PSProcPgm     PWCPGM           10
275400230913     C                   PARM                    PWNWRK            6
275500230913     C                   PARM                    PWLMSG            7
275600230913     C                   PARM                    PINFT
275700230913     C                   PARM      *BLANKS       PWRTN             7
275800230913      *
275900230913      ** Error occurred.
276000230913      *
276100230913     C                   IF        *IN90 = '1' OR PWRTN = '*ERROR*'
276200230913     C                   MOVEL     '*CALL'       DBKey
276300230913     C                   MOVEL     'ME1050'      DBFile
276400230913     C                   MOVEL     013           DBase
276500230913     C                   EXSR      *PSSR
276600230913     C                   ENDIF
276700230913      *                                                                                     MD060066
276800230913      ** After ME1050, update MT199 back to blank for Stop of Incoming                      MD060066
276900230913      ** Payment transaction where CSW220 is ON and MT199 is 'X'.                           MD060066
277000230913      *                                                                                     MD060066
277100230913     C                   IF        (CSW220 = 'Y' AND IPCHTP = 'S' AND                       MD060066
277200230913     C                              FTM199 = 'X')                                           MD060066
277300230913     C                   EVAL      FTM199 = *BLANKS                                         MD060066
277400230913     C                   ENDIF                                                              MD060066
277500230913      *
277600230913     C                   ENDSR
277700230913      *
277800230913      *****************************************************************
277900230913      /EJECT
278000230913      *****************************************************************
278100230913      *                                                               *
278200230913      *  SRFulAccnt - Get full account details                        *
278300230913      *                                                               *
278400230913      *****************************************************************
278500230913      *
278600230913     C     SRFulAccnt    BEGSR
278700230913      *
278800230913      ** Sender.
278900230913      *
279000230913     C                   CLEAR                   WSNDDS
279100230913      *
279200230913     C     SNTP          IFEQ      'F'
279300230913     C     SNTP          OREQ      'R'
279400230913     C     SNTP          OREQ      'G'
279500230913      *
279600230913      ** Setup keys for account details retrieval.
279700230913      *
279800230913     C                   IF        SNTP = 'F'
279900230913     C                   EVAL      WAXSBY = 'NOSTRO'
280000230913     C                   MOVEL     SND1          WKEYL5            5
280100230913     C                   MOVEL     WKEYL5        WNOCCY            3
280200230913     C                   MOVE      WKEYL5        WNOCOD            2
280300230913      *
280400230913     C                   ELSE
280500230913      *
280600230913     C                   IF        SNTP = 'R'
280700230913     C                   EVAL      WAXSBY = 'RETAIL'
280800230913     C                   MOVEL     SND1          WRACNO           10
280900230913      *
281000230913     C                   ELSE
281100230913      *
281200230913     C                   EVAL      WAXSBY = 'ACCNTS'
281300230913     C                   EVAL      WKEYL18 = SND1
281400230913     C                   MOVEL     WKEYL18       WACCNT
281500230913      *
281600230913     C                   ENDIF
281700230913      *
281800230913     C                   ENDIF
281900230913      *
282000230913      ** Access Account record.
282100230913      *
282200230913     C                   EXSR      SRAcnt
282300230913      *
282400230913      ** Store full account details for FT Transaction Status File
282500230913      ** record update.
282600230913      *
282700230913     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
282800230913     C                   EVAL      WICNUM = ACCNUM                                            CSD027
282900230913     C                   MOVE      ACCCY         WICCY
283000230913     C                   Z-ADD     ACACOD        WIACOD
283100230913     C                   Z-ADD     ACACSQ        WIACSQ
283200230913     C                   MOVE      ACBRCA        WIBRCA
283300230913     C                   MOVEL     WIACNT        WSNDDS
283400230913      *
283500230913     C                   ENDIF
283600230913      *
283700230913      ** Receiver's Correspondence.
283800230913      *
283900230913     C                   CLEAR                   WRCCDS
284000230913      *
284100230913     C*****RCRT**        IFEQ      'N'                                          CFT014
284200230913     C*****RCRT**        OREQ      'R'                                          CFT014
284300230913     C                   IF        INRCRT = 'N' or INRCRT = 'R'                 CFT014
284400230913      *
284500230913      ** Setup keys for account details retrieval.
284600230913      *
284700230913     C***********        IF        RCRT = 'N'                                   CFT014
284800230913     C                   IF        INRCRT = 'N'                                 CFT014
284900230913     C                   EVAL      WAXSBY = 'NOSTRO'
285000230913     C                   EVAL      WNOCCY = SMCY
285100230913     C***********        MOVEL     RCCO          WNOCOD                         CFT014
285200230913     C                   MOVEL     INRCO1        WNOCOD                         CFT014
285300230913      *
285400230913     C                   ELSE
285500230913      *
285600230913     C                   EVAL      WAXSBY = 'RETAIL'
285700230913     C***********        MOVEL     RCCO          WRACNO                         CFT014
285800230913     C                   MOVEL     INRCO1        WRACNO                         CFT014
285900230913     C                   ENDIF
286000230913      *
286100230913      ** Access Account record.
286200230913      *
286300230913     C                   EXSR      SRAcnt
286400230913      *
286500230913      ** Store full account details for FT Transaction Status File
286600230913      ** record update.
286700230913      *
286800230913     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
286900230913     C                   EVAL      WICNUM = ACCNUM                                            CSD027
287000230913     C                   MOVE      ACCCY         WICCY
287100230913     C                   Z-ADD     ACACOD        WIACOD
287200230913     C                   Z-ADD     ACACSQ        WIACSQ
287300230913     C                   MOVE      ACBRCA        WIBRCA
287400230913     C                   MOVEL     WIACNT        WRCCDS
287500230913      *
287600230913     C                   ENDIF
287700230913      *
287800230913      ** Beneficiary.
287900230913      *
288000230913     C                   CLEAR                   WBNCDS
288100230913      *
288200230913     C     BNCT          IFEQ      'R'
288300230913     C     BNCT          OREQ      'P'
288400230913      *
288500230913      ** Setup keys for account details retrieval.
288600230913      *
288700230913     C                   IF        BNCT = 'R'
288800230913     C                   EVAL      WAXSBY = 'RETAIL'
288900230913     C                   MOVEL     BNC1          WRACNO
289000230913      *
289100230913     C                   ELSE
289200230913      *
289300230913     C**********         MOVEL     BNC1          WKEYL15          15                          CGL029
289400230913     C**********         MOVE      WKEYL15       WKEYL18          18                          CGL029
289500230913     C                   MOVEL     BNC1          WKEYL15          21                          CGL029
289600230913     C                   MOVE      WKEYL15       WKEYL18          24                          CGL029
289700230913     C                   MOVEL     BNC1          WKEYL9            9
289800230913     C                   MOVE      PCCY          WKEYL9
289900230913     C**********         MOVEL     BNC1          WKEYL12          12                          CGL029
290000230913     C                   MOVEL     BNC1          WKEYL12          18                          CGL029
290100230913     C                   MOVE      WKEYL12       WKEYL15
290200230913     C                   MOVEL     WKEYL9        WKEYL15
290300230913     C                   MOVEL     WKEYL15       WKEYL18
290400230913      *
290500230913     C                   EVAL      WAXSBY = 'ACCNTS'
290600230913     C                   EVAL      WACCNT = WKEYL18
290700230913      *
290800230913     C                   ENDIF
290900230913      *
291000230913      ** Access Account record.
291100230913      *
291200230913     C                   EXSR      SRAcnt
291300230913      *
291400230913      ** Store full account details for FT Transaction Status File
291500230913      ** record update.
291600230913      *
291700230913     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
291800230913     C                   EVAL      WICNUM = ACCNUM                                            CSD027
291900230913     C                   MOVE      ACCCY         WICCY
292000230913     C                   Z-ADD     ACACOD        WIACOD
292100230913     C                   Z-ADD     ACACSQ        WIACSQ
292200230913     C                   MOVE      ACBRCA        WIBRCA
292300230913     C                   MOVEL     WIACNT        WBNCDS
292400230913      *
292500230913     C                   ENDIF
292600230913      *
292700230913      ** Account with Bank.
292800230913      *
292900230913     C                   CLEAR                   WACBDS
293000230913      *
293100230913     C     ACBT          IFEQ      'N'
293200230913     C     ACBT          OREQ      'R'
293300230913     C     ACBT          OREQ      'P'
293400230913      *
293500230913      ** Setup keys for account details retrieval.
293600230913      *
293700230913     C                   IF        ACBT = 'N'
293800230913     C                   EVAL      WAXSBY = 'NOSTRO'
293900230913     C                   EVAL      WNOCCY = PCCY
294000230913     C                   EVAL      WNOCOD = ACBK
294100230913      *
294200230913     C                   ELSE
294300230913      *
294400230913     C                   IF        ACBT = 'R'
294500230913     C                   EVAL      WAXSBY = 'RETAIL'
294600230913     C                   MOVEL     ACBK          WRACNO
294700230913      *
294800230913     C                   ELSE
294900230913      *
295000230913     C                   MOVEL     ACBK          WKEYL9
295100230913     C                   MOVE      PCCY          WKEYL9
295200230913     C                   MOVE      ACBK          WKEYL15
295300230913     C                   MOVEL     WKEYL9        WKEYL15
295400230913     C                   MOVE      ACBB          WKEYL18
295500230913     C                   MOVEL     WKEYL15       WKEYL18
295600230913      *
295700230913     C                   EVAL      WAXSBY = 'ACCNTS'
295800230913     C                   EVAL      WACCNT = WKEYL18
295900230913      *
296000230913     C                   ENDIF
296100230913      *
296200230913     C                   ENDIF
296300230913      *
296400230913      ** Access Account record.
296500230913      *
296600230913     C                   EXSR      SRAcnt
296700230913      *
296800230913      ** Store full account details for FT Transaction Status File
296900230913      ** record update.
297000230913      *
297100230913     C**********         Z-ADD     ACCNUM        WICNUM                                       CSD027
297200230913     C                   EVAL      WICNUM = ACCNUM                                            CSD027
297300230913     C                   MOVE      ACCCY         WICCY
297400230913     C                   Z-ADD     ACACOD        WIACOD
297500230913     C                   Z-ADD     ACACSQ        WIACSQ
297600230913     C                   MOVE      ACBRCA        WIBRCA
297700230913     C                   MOVEL     WIACNT        WACBDS
297800230913      *
297900230913     C                   ENDIF
298000230913      *
298100230913     C                   ENDSR
298200230913      *
298300230913      *****************************************************************
298400230913      /EJECT
298500230913      *****************************************************************
298600230913      *                                                               *
298700230913      *  SRAcnt - Retrieve account details                            *
298800230913      *                                                               *
298900230913      *****************************************************************
299000230913      *
299100230913     C     SRAcnt        BEGSR
299200230913      *
299300230913     C                   IF        WAXSBY = 'NOSTRO'
299400230913      *
299500230913     C                   CALLB     'AONOSTR0'
299600230913     C                   PARM      *Blanks       PNRtCd            7
299700230913     C                   PARM      '*KEY   '     PNOptn            7
299800230913     C                   PARM      *Blanks       PNCust            6
299900230913     C                   PARM      WNOCCY        PNCyCd            3
300000230913     C**********         PARM      *Blanks       PNAccN            4                          CGL029
300100230913     C                   PARM      *BLANKS       PNAccN                                       CGL029
300200230913     C                   PARM      *Blanks       PNAcSN            2
300300230913     C                   PARM      WNOCOD        PNNoNb            2
300400230913     C                   PARM      *Blanks       PNBrCd            3
300500230913     C                   PARM      *Blanks       PNCsSN           10
300600230913     C                   PARM      *Blanks       PNPNOI            1
300700230913     C     SDNOST        PARM      SDNOST        DSFDY
300800230913      *
300900230913     C                   IF        PNRTCD <> *BLANKS
301000230913     C                   MOVEL     WNOCCY        WNOST             5
301100230913     C                   MOVE      WNOCOD        WNOST
301200230913     C                   MOVEL     WNOST         DBKey
301300230913     C                   MOVEL     'SDNOSTPD'    DBFile
301400230913     C                   Z-ADD     014           DBase
301500230913     C                   EXSR      SRERR
301600230913     C                   ELSE
301700230913     C                   MOVE      A7CUST        ACCNUM
301800230913     C                   MOVE      A7CYCD        ACCCY
301900230913     C                   MOVE      A7ACCD        ACACOD
302000230913     C                   MOVE      A7ACSN        ACACSQ
302100230913     C                   MOVE      A7BRCD        ACBRCA
302200230913     C                   ENDIF
302300230913      *
302400230913     C                   ELSE
302500230913      *
302600230913     C                   IF        WAXSBY = 'RETAIL'
302700230913      *
302800230913     C                   MOVEL     WRACNO        WKACNO           10 0
302900230913     C     WKACNO        CHAIN     ACNUMA                             99
303000230913      *
303100230913     C                   IF        *IN99 = *On
303200230913     C                   MOVEL     WKACNO        DBKey
303300230913     C                   MOVEL     'ACNUMA'      DBFile
303400230913     C                   Z-ADD     015           DBase
303500230913     C                   EXSR      SRERR
303600230913     C                   ENDIF
303700230913      *
303800230913     C                   ELSE
303900230913      *
304000230913     C     KACCNT        CHAIN     ACCNT                              99
304100230913      *
304200230913     C                   IF        *IN99 = *On
304300230913     C                   MOVEL     WACCNT        DBKey
304400230913     C                   MOVEL     'ACCNT'       DBFile
304500230913     C                   Z-ADD     016           DBase
304600230913     C                   EXSR      SRERR
304700230913     C                   ENDIF
304800230913      *
304900230913     C                   ENDIF
305000230913      *
305100230913     C                   ENDIF
305200230913      *
305300230913     C                   ENDSR
305400230913      *
305500230913      *****************************************************************
305600230913      /EJECT
305700230913      *****************************************************************
305800230913      *                                                               *
305900230913      *  SRLOG - Add Incoming Message Log File record                 *
306000230913      *                                                               *
306100230913      *****************************************************************
306200230913      *
306300230913     C     SRLOG         BEGSR
306400230913      *
306500230913      ** Fill record format data structure with available data.
306600230913      *
306700230913     C                   CLEAR                   PINLF
306800230913      *
306900230913     C                   Z-ADD     INMSGR        LFMSGR
307000230913     C                   Z-ADD     INKPRT        LFKPRT
307100230913     C                   MOVEL     W0LMSG        LFMSID
307200230913     C                   MOVEL     PREF          LFMSDT
307300230913     C                   MOVEL     *BLANKS       LFARSM
307400230913     C                   MOVEL     *BLANKS       LFARSD
307500230913     C                   MOVEL     PSProcPgm     LFCPGM
307600230913     C                   MOVEL     PSProcPgm     LFRPGM
307700230913      *
307800230913      ** N.B. Audit Stamp details are determined in called program.
307900230913      *
308000230913      ** Set up data to be passed using the rcd format data structure.
308100230913      *
308200230913     C                   CALL      'ME1040'                             9090
308300230913     C                   PARM      '*ADD    '    PWACT
308400230913     C                   PARM                    PINLF
308500230913     C                   PARM      *BLANKS       PWRTN
308600230913      *
308700230913      ** Error occurred.
308800230913      *
308900230913     C                   IF        *IN90 = '1' OR PWRTN = '*ERROR*'
309000230913     C                   MOVEL     '*CALL'       DBKey
309100230913     C                   MOVEL     'ME1040'      DBFile
309200230913     C                   MOVEL     017           DBase
309300230913     C                   EXSR      *PSSR
309400230913     C                   ENDIF
309500230913      *
309600230913     C                   ENDSR
309700230913      *
309800230913      *****************************************************************
309900230913      /EJECT
310000230913      *****************************************************************
310100230913      *                                                               *
310200230913      *  SRTrailer - Update Incoming Payments trailer record          *
310300230913      *                                                               *
310400230913      *****************************************************************
310500230913      *
310600230913     C     SRTrailer     BEGSR
310700230913      *
310800230913      ** Read trailer record.
310900230913      *
311000230913     C     1             CHAIN     INPAYZZ                            99
311100230913      *
311200230913     C                   IF        *IN99 = '1'
311300230913     C                   MOVEL     'MISSING'     WDBKey           15
311400230913     C                   MOVE      'TRAILER'     WDBKey
311500230913     C                   MOVEL     WDBKey        DBKey
311600230913     C                   MOVEL     'INPAYZZ'     DBFile
311700230913     C                   MOVEL     018           DBase
311800230913     C                   EXSR      *PSSR
311900230913     C                   ENDIF
312000230913      *
312100230913      ** Increment record count if Change Type is 'I'.
312200230913      *
312300230913     C                   IF        WCHTP = 'I'
312400230913     C                   ADD       1             NORE1
312500230913     C                   ENDIF
312600230913      *
312700230913      ** Increment hash totals of Payment Amounts.
312800230913      *
312900230913     C                   Z-ADD     HRWN          ZZTOTI
313000230913     C                   Z-ADD     HRDC          ZZTOTD
313100230913      *
313200230913     C                   EXSR      SRGLZADD
313300230913      *
313400230913     C                   Z-ADD     ZZTOTI        HRWN
313500230913     C                   Z-ADD     ZZTOTD        HRDC
313600230913      *
313700230913      ** Update trailer record.
313800230913      *
313900230913     C                   UPDATE    INPAYZZF                             99
314000230913      *
314100230913     C                   IF        *IN99 = '1'
314200230913     C                   MOVEL     'MISSING'     WDBKey
314300230913     C                   MOVE      'TRAILER'     WDBKey
314400230913     C                   MOVEL     WDBKey        DBKey
314500230913     C                   MOVEL     'INPAYZZ'     DBFile
314600230913     C                   MOVEL     019           DBase
314700230913     C                   EXSR      *PSSR
314800230913     C                   ENDIF
314900230913      *
315000230913     C                   ENDSR
315100230913      *
315200230913      *****************************************************************
315300230913      /EJECT
315400230913      *****************************************************************
315500230913      *                                                               *
315600230913      *  SRGLZADD - Add an amount (ZZAMT) to the total (ZZTOTI,       *
315700230913      *             ZZTOTD)                                           *
315800230913      *                                                               *
315900230913      *****************************************************************
316000230913      *
316100230913     C     SRGLZADD      BEGSR
316200230913      *
316300230913     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91
316400230913     C                   IF        *IN91 = *ON
316500230913     C                   GOTO      EGLZADD
316600230913     C                   ENDIF
316700230913      *
316800230913      ** Split ZZAMT into integer and decimal fields.
316900230913      *
317000230913     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
317100230913     C                   MOVE      ZZAMT         ZZAMTD            3 0
317200230913      *
317300230913      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now.
317400230913      *
317500230913     C                   EXSR      SRGLZSUM
317600230913      *
317700230913     C     EGLZADD       ENDSR
317800230913      *
317900230913      *****************************************************************
318000230913      /EJECT
318100230913      *****************************************************************
318200230913      *                                                               *
318300230913      *  SRGLZSUM - Carry out addition                                *
318400230913      *                                                               *
318500230913      *****************************************************************
318600230913      *
318700230913     C     SRGLZSUM      BEGSR
318800230913      *
318900230913     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
319000230913     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
319100230913     C                   SETOFF                                       919293
319200230913     C                   SETOFF                                       949599
319300230913      *
319400230913      ** Determine sign of ZZAMTI/D (92 if negative).
319500230913      *
319600230913     C     ZZAMTI        COMP      0                                    9293
319700230913     C   93ZZAMTD        COMP      0                                    9293
319800230913     C   93              GOTO      ZZSEND
319900230913      *
320000230913      ** Determine sign of ZZTOTI/D (91 if negative).
320100230913      *
320200230913     C     ZZTOTI        COMP      0                                    9193
320300230913     C   93ZZTOTD        COMP      0                                    9193
320400230913      *
320500230913      **  If ZZTOTAL is zero, return ZZAmount.
320600230913      *
320700230913     C   93              Z-ADD     ZZAMTI        ZZTOTI
320800230913     C   93              Z-ADD     ZZAMTD        ZZTOTD
320900230913     C   93              GOTO      ZZSEND
321000230913      *
321100230913      ** If signs differ, bypass overflow checks.
321200230913      *
321300230913     C   91
321400230913     CANN92
321500230913     CORN91
321600230913     CAN 92              GOTO      ZZOFPS
321700230913      *
321800230913     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
321900230913     C     ZZWK2         COMP      999                                93
322000230913     C  N93ZZWK2         COMP      -999                                 93
322100230913      *
322200230913     C   93
322300230913     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
322400230913     C   93
322500230913     CAN 92ZZAMTI        SUB       1             ZZWK3
322600230913     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
322700230913     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
322800230913      *
322900230913      ** If the modulus of ZZWK3 is LT mod. ZZTOTI, then O/F has
323000230913      ** occurred.
323100230913      *
323200230913     C  N92ZZWK3         COMP      ZZTOTI                               99
323300230913     C   92ZZWK3         COMP      ZZTOTI                             99
323400230913     C  N99              Z-ADD     ZZWK2         ZZTOTD
323500230913     C  N99              Z-ADD     ZZWK3         ZZTOTI
323600230913      *
323700230913      ** If O/F, zeroise ZZAMT, indicator 99 set and ZZTOT
323800230913      ** fields left intact.
323900230913      *
324000230913     C   99              Z-ADD     0             ZZAMT            15 3
324100230913     C                   GOTO      ZZSEND
324200230913      *
324300230913      ** The 'SIGNS' are different.
324400230913      *
324500230913     C     ZZOFPS        TAG
324600230913      *
324700230913      ** If ZZAMT was negative, make it positive to compare
324800230913      ** with ZZTOT.
324900230913      *
325000230913     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
325100230913     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
325200230913      *
325300230913      ** If ZZTOT was negative, make it positive to compare
325400230913      ** with ZZAMT.
325500230913      *
325600230913     C   91              Z-SUB     ZZTOTI        ZZTOTI
325700230913     C   91              Z-SUB     ZZTOTD        ZZTOTD
325800230913      *
325900230913      ** Both ZZAMT and ZZTOT are now positive.
326000230913      *
326100230913     C     ZZTOTI        COMP      ZZAMTI                             93  95
326200230913     C   95ZZTOTD        COMP      ZZAMTD                             93  95
326300230913      *
326400230913      ** If ZZTOT EQ ZZAMT, return zero.
326500230913      *
326600230913     C   95              Z-ADD     0             ZZTOTI
326700230913     C   95              Z-ADD     0             ZZTOTD
326800230913     C   95              GOTO      ZZSEND
326900230913      *
327000230913      ** If ZZTOT GT ZZAMT.
327100230913      *
327200230913     C   93ZZAMTD        COMP      ZZTOTD                             94
327300230913     C   93
327400230913     CAN 94ZZTOTI        SUB       1             ZZTOTI
327500230913     C   93
327600230913     CAN 94ZZTOTD        ADD       1000          ZZWK2
327700230913     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
327800230913     C   93
327900230913     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
328000230913     C   93
328100230913     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
328200230913      *
328300230913      ** If ZZAMT GT ZZTOT.
328400230913      *
328500230913     C  N93ZZTOTD        COMP      ZZAMTD                             94
328600230913     C  N93
328700230913     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
328800230913     C  N93
328900230913     CAN 94ZZAMTD        ADD       1000          ZZWK2
329000230913     C  N93
329100230913     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
329200230913     C  N93
329300230913     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
329400230913     C  N93
329500230913     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
329600230913     C  N93
329700230913     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
329800230913      *
329900230913      ** Reverse sign of ZZTOT if larger I/P fields were negative.
330000230913      *
330100230913     C                   SETOFF                                       94
330200230913     C   93
330300230913     CAN 91
330400230913     CORN93
330500230913     CAN 92              SETON                                        94
330600230913     C   94              Z-SUB     ZZTOTI        ZZTOTI
330700230913     C   94              Z-SUB     ZZTOTD        ZZTOTD
330800230913      *
330900230913      ** Restore sign of ZZAMTI and ZZAMTD if it was reversed.
331000230913      *
331100230913     C   92              Z-SUB     ZZAMTI        ZZAMTI
331200230913     C   92              Z-SUB     ZZAMTD        ZZAMTD
331300230913     C     ZZSEND        TAG
331400230913      *
331500230913      ** If ZZTOTD is zero and ZZTOTI is negative, set up ZZNEGD.
331600230913      *
331700230913     C                   SETOFF                                       96
331800230913     C     ZZTOTD        COMP      0                                      91
331900230913     C   91ZZTOTI        COMP      0                                    96
332000230913     C   96              MOVE      '.000-'       ZZNEGD            5
332100230913      *
332200230913     C                   ENDSR
332300230913      *
332400230913      *****************************************************************
332500230913      /EJECT
332600230913      *****************************************************************
332700230913      *                                                               *
332800230913      *  *INZSR - Program Initialisation                              *
332900230913      *         - This subroutine runs automatically for program      *
333000230913      *           initialisation.                                     *
333100230913      *                                                               *
333200230913      *****************************************************************
333300230913      *
333400230913     C     *INZSR        BEGSR
333500230913      *
333600230913     C     *ENTRY        PLIST
333700230913      *
333800230913      ** INPUT
333900230913      ** =====
334000230913      *
334100230913      ** Return Code
334200230913     C                   PARM                    RetCodeIn
334300230913      *
334400230913      ** Incoming Payments for file update - file format
334500230913     C                   PARM                    NwIPFilFmt
334600230913     C                   PARM                    NwIP2FilFmt                    CFT014
334700230913      *
334800230913      ** IBANs full account
334900230913     C                   PARM                    PIBANAcc
335000230913      *
335100230913      ** Originally Insert from Level 2 Entry
335200230913     C                   PARM                    POrigACTN         1
335300230913      *
335400230913      ** FT Override for GL Balances
335500230913     C                   PARM                    PFTOV             1
335600230913      *
335700230913      ** FT Control Data
335800230913     C                   PARM                    PCNTRL
335900230913      *
336000230913      ** Network
336100230913     C                   PARM                    PNWRK             6
336200230913      *
336300230913      ** Entry Point
336400230913     C                   PARM                    PParmLevel        1
336500230913      *
336600230913      ** STANDING DATA
336700230913      ** =============
336800230913      *
336900230913      ** SDBANK - Base Currency Code
337000230913     C**********         PARM                    BJCYCD            3                          CAP211
337100230913     C     BJCYCD        PARM                    BJCYCDBJ          3                          CAP211
337200230913      *
337300230913      ** SDBANK - Midas Run Date
337400230913     C**********         PARM                    BJRDNB            5 0                        CAP211
337500230913     C     BJRDNB        PARM                    BJRDNBBJ          5 0                        CAP211
337600230913      *
337700230913      ** SDBANK - Single Branch Code
337800230913     C**********         PARM                    BJSBRC            3                          CAP211
337900230913     C     BJSBRC        PARM                    BJSBRCBJ          3                          CAP211
338000230913      *
338100230913      ** SDGELR - Originating Branch/User Vald Req.
338200230913     C                   PARM                    BKOBUV            1
338300230913      *
338400230913      ** ZMUSER - Default Branch
338500230913     C                   PARM                    PDBRN             3
338600230913      *
338700230913      ** SWITCHABLE FEATURES
338800230913      ** ===================
338900230913      *
339000230913      ** Batch Authorisation
339100230913     C                   PARM                    CFT003            1
339200230913      *
339300230913      ** IBAN numbers
339400230913     C                   PARM                    CFT004            1
339500230913      *
339600230913      ** BLI FT Enhancements Feature
339700230913     C                   PARM                    S01494            1
339800230913      *
339900230913      ** BLI VAT Processing Feature
340000230913     C                   PARM                    S01499            1
340100230913      *                                                                         CFT014
340200230913      ** STP Phase 2 MT103                                                      CFT014
340300230913     C                   PARM                    CFT014                         CFT014
340400230913      *                                                                         CFT009
340500230913      ** Fees & Charges                                                         CFT009
340600230913     C                   PARM                    CFT009            1            CFT009
340700230913     C                   PARM                    CFT010            1            CFT009
340800230913     C                   PARM                    CSC011                                       CSC011
340900230913     C                   PARM                    CSD015                                       CSD015
341000230913     C                   PARM                    CCF001                                       CSD015
341100230913      *                                                                                       CAP211
341200230913     C                   PARM                    PAuth             1                          CAP211
341300230913     C                   PARM                    PUser            10                          CAP211
341400230913      *                                                                                       CAP211
341500230913     C/COPY WNCPYSRC,FTIPAYDC03
341600230913      *                                                                                       CFT157
341700230913     C                   CALLB     'AOSARDR0'                                                 CFT157
341800230913     C                   Parm      *BLANKS       @RTCD             7                          CFT157
341900230913     C                   Parm      '*VERIFY'     @OPTN             7                          CFT157
342000230913     C                   Parm      'CFT157'      @SARD                                        CFT157
342100230913     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT157
342200230913                                                                                              CFT157
342300230913     C                   If        @RTCD <> *Blanks and                                       CFT157
342400230913     C                             @RTCD <> '*NRF   '                                         CFT157
342500230913     C     *LOCK         In        LDA                                                        CFT157
342600230913     C                   Movel     'SCSARDPD'    DBFILE                                       CFT157
342700230913     C                   Movel     '002'         DBASE                                        CFT157
342800230913     C                   Movel     'CFT157'      DBKEY                                        CFT157
342900230913     C                   Out       LDA                                                        CFT157
343000230913     C                   Exsr      *PSSR                                                      CFT157
343100230913     C                   End                                                                  CFT157
343200230913                                                                                              CFT157
343300230913     C                   If        @RTCD = *Blanks                                            CFT157
343400230913     C                   Movel     'Y'           @CFT157           1                          CFT157
343500230913     C                   Else                                                                 CFT157
343600230913     C                   Movel     'N'           @CFT157                                      CFT157
343700230913     C                   End                                                                  CFT157
343800230913                                                                                              CFT157
343900230913      *****************************************************************               241810 241810A
344000230913      ***Retrieve*ZMUSER*details.**************************************               241810 241810A
344100230913      *****************************************************************               241810 241810A
344200230913     C******DTAARA       DEFINE                  ZMUSER                               241810 241810A
344300230913     C**********         IN        ZMUSER                                             241810 241810A
344400230913      *
344500230913     C     KACCNT        KLIST
344600230913     C                   KFLD                    WACNUM
344700230913     C                   KFLD                    WACCCY
344800230913     C                   KFLD                    WACCD
344900230913     C                   KFLD                    WACSQ
345000230913     C                   KFLD                    WBRCA
345100230913     C/COPY WNCPYSRC,FTH00413
345200230913                                                                                              CSC011
345300230913      ** Get support system prefix and current system prefix                                  CSC011
345400230913                                                                                              CSC011
345500230913     C                   IF        CSC011 = 'Y'                                               CSC011
345600230913     C                   IN        SC24X7                                                     CSC011
345700230913     C**********         IN        SDSTAT                                              CSC011 CSD015
345800230913     C                   ENDIF                                                                CSC011
345900230913                                                                                              CSD015
346000230913     C                   IF        CSD015 = 'Y'                                               223687
346100230913     C                   IN        SDSTAT                                                     CSD015
346200230913                                                                                              CSD015
346300230913      ** Check if function code is being monitored by the compliance watch                    CSD015
346400230913                                                                                              CSD015
346500230913     C                   CALLB     'AOWLCCR0'                                                 CSD015
346600230913     C                   PARM      *Blank        PRtCd                                        CSD015
346700230913     C                   PARM      '*KEY   '     POptn                                        CSD015
346800230913     C                   PARM      'FTIPAY'      PFunc                                        CSD015
346900230913     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
347000230913                                                                                              CSD015
347100230913      ** If return code not blank, then issue database errror                                 CSD015
347200230913                                                                                              CSD015
347300230913     C                   IF        (PRtCd <> *Blank) AND                                      CSD015
347400230913     C                             (PRtCd <> '*NRF   ')                                       CSD015
347500230913     C                   EVAL      DBKey = 'FTIPAY'                                           CSD015
347600230913     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
347700230913     C                   EVAL      DBase = 017                                                CSD015
347800230913     C                   EXSR      *PSSR                                                      CSD015
347900230913     C                   ENDIF                                                                CSD015
348000230913                                                                                              CSD015
348100230913      **  Access Compliance Watch Configuration Data if necessary.                            CSD015
348200230913                                                                                              CSD015
348300230913     C                   CALL      'AOCWCDR0'                                                 CSD015
348400230913     C                   PARM      *BLANKS       PrtCd                                        CSD015
348500230913     C                   PARM      '*FIRST'      POptn                                        CSD015
348600230913     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
348700230913                                                                                              CSD015
348800230913     C                   IF        Prtcd <> *Blanks                                           CSD015
348900230913     C     *LOCK         IN        LDA                                                        CSD015
349000230913     C                   EVAL      DBKey = POptn                                              CSD015
349100230913     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
349200230913     C                   EVAL      DBase = 11                                                 CSD015
349300230913     C                   OUT       LDA                                                      MD029681
349400230913     C                   EXSR      *PSSR                                                      CSD015
349500230913     C                   ENDIF                                                                CSD015
349600230913                                                                                              CSD015
349700230913     C                   ENDIF                                                                223687
349800230913                                                                                              CRE020
349900230913      ** Check if Online Printing of Advices (GE7) is on.                                     CRE020
350000230913                                                                                              CRE020
350100230913     C                   EVAL      CRE020 = 'N'                                               CRE020
350200230913     C                   CALL      'AOSARDR0'                                                 CRE020
350300230913     C                   PARM      *BLANKS       PRTCD                                        CRE020
350400230913     C                   PARM      '*VERIFY'     POPTN                                        CRE020
350500230913     C                   PARM      'CRE020'      PSARD                                        CRE020
350600230913     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
350700230913                                                                                              CRE020
350800230913     C                   IF        PRTCD <> *Blanks  and                                      CRE020
350900230913     C                             PRTCD <> '*NRF'                                            CRE020
351000230913     C     *LOCK         IN        LDA                                                        CRE020
351100230913     C                   EVAL      DBKey = 'CRE020'                                           CRE020
351200230913     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
351300230913     C                   EVAL      DBase = 30                                                 CRE020
351400230913     C                   OUT       LDA                                                      MD029681
351500230913     C                   EXSR      *PSSR                                                      CRE020
351600230913     C                   ENDIF                                                                CRE020
351700230913                                                                                              CRE020
351800230913     C                   IF        PRTCD = *BLANKS                                            CRE020
351900230913     C                   EVAL      CRE020 = 'Y'                                               CRE020
352000230913     C                   ENDIF                                                                CRE020
352100230913     C/COPY WNCPYSRC,FTH00392
352200230913      *                                                                                       CSW209
352300230913      ** Check if CSW209 is switch on                                                         CSW209
352400230913      *                                                                                       CSW209
352500230913     C                   EVAL      CSW209 = 'N'                                               CSW209
352600230913      *                                                                                       CSW209
352700230913     C                   CALL      'SWIF2009'                                                 CSW209
352800230913     C                   PARM                    PRTCD                                        CSW209
352900230913     C     PRTCD         IFEQ      'CSW2009'                                                  CSW209
353000230913     C                   EVAL      CSW209 = 'Y'                                               CSW209
353100230913     C                   ENDIF                                                                CSW209
353101230913      *                                                                                       BA5021
353102230913     C                   EVAL      BA5021 = 'N'                                               BA5021
353103230913     C                   CALL      'AOSARDR0'                                                 BA5021
353104230913     C                   PARM      *BLANKS       PRTCD                                        BA5021
353105230913     C                   PARM      '*VERIFY'     POPTN                                        BA5021
353106230913     C                   PARM      'BA5021'      PSARD                                        BA5021
353107230913     C     SCSARD        PARM      SCSARD        DSFDY                                        BA5021
353108230913                                                                                              BA5021
353109230913     C                   IF        PRTCD <> *Blanks  and                                      BA5021
353110230913     C                             PRTCD <> '*NRF'                                            BA5021
353111230913     C     *LOCK         IN        LDA                                                        BA5021
353112230913     C                   EVAL      DBKey = 'BA5021'                                           BA5021
353113230913     C                   EVAL      DBFile = 'SCSARDPD'                                        BA5021
353114230913     C                   EVAL      DBase = 39                                                 BA5021
353115230913     C                   EXSR      *PSSR                                                      BA5021
353116230913     C                   ENDIF                                                                BA5021
353117230913                                                                                              BA5021
353118230913     C                   IF        PRTCD = *BLANKS                                            BA5021
353119230913     C                   EVAL      BA5021 = 'Y'                                               BA5021
353120230913     C                   ENDIF                                                                BA5021
353121230913      *                                                                                       BA5021
353200230913                                                                                              CAP205
353300230913      ** Determine if SAR CAP205 is installed                                                 CAP205
353400230913                                                                                              CAP205
353500230913     C                   MOVEL     'N'           CAP205                                       CAP205
353600230913     C                   CALL      'AOSARDR0'                                                 CAP205
353700230913     C                   PARM      *BLANKS       PRTCD                                        CAP205
353800230913     C                   PARM      '*VERIFY'     POPTN                                        CAP205
353900230913     C                   PARM      'CAP205'      PSARD                                        CAP205
354000230913     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
354100230913                                                                                              CAP205
354200230913     C                   IF        PRTCD <> *Blanks  AND                                      CAP205
354300230913     C                             PRTCD <> '*NRF'                                            CAP205
354400230913     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP205
354500230913     C     *LOCK         IN        LDA                                                        CAP205
354600230913     C                   EVAL      DBKey = 'CAP205'                                           CAP205
354700230913     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP205
354800230913     C                   EVAL      DBase = 32                                                 CAP205
354900230913     C                   OUT       LDA                                                      MD029681
355000230913     C                   EXSR      *PSSR                                                      CAP205
355100230913     C                   ENDIF                                                                CAP205
355200230913                                                                                              CAP205
355300230913     C                   IF        PRTCD = *BLANKS                                            CAP205
355400230913     C                   MOVEL     'Y'           CAP205                                       CAP205
355500230913     C                   ENDIF                                                                CAP205
355600230913      *                                                                                       CAP211
355700230913      ** Check if CAP211 is switched on                                                       CAP211
355800230913      *                                                                                       CAP211
355900230913     C                   MOVE      'N'           CAP211            1                          CAP211
356000230913     C                   CALL      'AOSARDR0'                                                 CAP211
356100230913     C                   PARM      *Blanks       PRTCD                                        CAP211
356200230913     C                   PARM      '*VERIFY'     POPTN                                        CAP211
356300230913     C                   PARM      'CAP211'      PSARD                                        CAP211
356400230913     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP211
356500230913      *                                                                                       CAP211
356600230913     C                   IF        PRTCD <> *Blanks  AND                                      CAP211
356700230913     C                             PRTCD <> '*NRF'                                            CAP211
356800230913     C     *LOCK         IN        LDA                                                        CAP211
356900230913     C                   EVAL      DBKey = 'CAP211'                                           CAP211
357000230913     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP211
357100230913     C                   EVAL      DBase = 33                                                 CAP211
357200230913     C                   OUT       LDA                                                      MD029681
357300230913     C                   EXSR      *PSSR                                                      CAP211
357400230913     C                   ENDIF                                                                CAP211
357500230913      *                                                                                       CAP211
357600230913     C                   IF        PRTCD = *Blanks                                            CAP211
357700230913     C                   EVAL      CAP211 = 'Y'                                               CAP211
357800230913     C                   ENDIF                                                                CAP211
357900230913      *                                                                                       CAP211
358000230913     C                   IF        CAP211 = 'Y'                                               CAP211
358100230913      *                                                                                       CAP211
358200230913      ** Access System value CAP211GenerateOP if CAP211 is ON                                 CAP211
358300230913      *                                                                                       CAP211
358400230913     C                   CALL      'AOSVALR0'                                                 CAP211
358500230913     C                   PARM      *BLANKS       PRetCode          7                          CAP211
358600230913     C                   PARM      SysValGOP     P@OP01           20                          CAP211
358700230913     C                   PARM      *BLANKS       P@VL01          200                          CAP211
358800230913     C                   PARM      *BLANKS       P@OP02           20                          CAP211
358900230913     C                   PARM      *BLANKS       P@VL02          200                          CAP211
359000230913     C                   PARM      *BLANKS       P@OP03           20                          CAP211
359100230913     C                   PARM      *BLANKS       P@VL03          200                          CAP211
359200230913     C                   PARM      *BLANKS       P@OP04           20                          CAP211
359300230913     C                   PARM      *BLANKS       P@VL04          200                          CAP211
359400230913     C                   PARM      *BLANKS       P@OP05           20                          CAP211
359500230913     C                   PARM      *BLANKS       P@VL05          200                          CAP211
359600230913     C                   PARM      *BLANKS       P@OP06           20                          CAP211
359700230913     C                   PARM      *BLANKS       P@VL06          200                          CAP211
359800230913     C                   PARM      *BLANKS       P@OP07           20                          CAP211
359900230913     C                   PARM      *BLANKS       P@VL07          200                          CAP211
360000230913     C                   PARM      *BLANKS       P@OP08           20                          CAP211
360100230913     C                   PARM      *BLANKS       P@VL08          200                          CAP211
360200230913     C                   PARM      *BLANKS       P@OP09           20                          CAP211
360300230913     C                   PARM      *BLANKS       P@VL09          200                          CAP211
360400230913     C                   PARM      *BLANKS       P@OP10           20                          CAP211
360500230913     C                   PARM      *BLANKS       P@VL10          200                          CAP211
360600230913      *                                                                                       CAP211
360700230913     C                   IF        PRetCode  <> *BLANKS                                       CAP211
360800230913     C     *LOCK         IN        LDA                                                        CAP211
360900230913     C                   EVAL      DBKey = SysValGOP                                          CAP211
361000230913     C                   EVAL      DBFile = 'SDSVALPD'                                        CAP211
361100230913     C                   EVAL      DBase = 34                                                 CAP211
361200230913     C                   OUT       LDA                                                      MD029681
361300230913     C                   EXSR      *PSSR                                                      CAP211
361400230913     C                   ELSE                                                                 CAP211
361500230913     C                   MOVEL     P@VL01        SVGOP             1                          CAP211
361600230913     C                   ENDIF                                                                CAP211
361700230913      *                                                                                       CAP211
361800230913      ** Access Midas SD Funds transfer details                                               CAP211
361900230913      *                                                                                       CAP211
362000230913     C                   CALL      'AOFTFRR0'                                                 CAP211
362100230913     C                   PARM      *BLANKS       PRTCD                                        CAP211
362200230913     C                   PARM      '*FIRST '     POPTN                                        CAP211
362300230913     C     SDFTFR        PARM      SDFTFR        DSFDY                                        CAP211
362400230913      *                                                                                       CAP211
362500230913     C                   IF        PRTCD <> *BLANKS                                           CAP211
362600230913     C     *LOCK         IN        LDA                                                        CAP211
362700230913     C                   EVAL      DBKey = POPTN                                              CAP211
362800230913     C                   EVAL      DBFile = 'SDFTFRPD'                                        CAP211
362900230913     C                   EVAL      DBase = 35                                                 CAP211
363000230913     C                   OUT       LDA                                                      MD029681
363100230913     C                   EXSR      *PSSR                                                      CAP211
363200230913     C                   ENDIF                                                                CAP211
363300230913      *                                                                                       CAP211
363400230913      ** Check if CEU006 is switched on                                                       CAP211
363500230913      *                                                                                       CAP211
363600230913     C                   MOVE      'N'           CEU006            1                          CAP211
363700230913     C                   CALL      'AOSARDR0'                                                 CAP211
363800230913     C                   PARM      *Blanks       PRTCD                                        CAP211
363900230913     C                   PARM      '*VERIFY'     POPTN                                        CAP211
364000230913     C                   PARM      'CEU006'      PSARD                                        CAP211
364100230913     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP211
364200230913      *                                                                                       CAP211
364300230913     C                   IF        PRTCD <> *Blanks  AND                                      CAP211
364400230913     C                             PRTCD <> '*NRF'                                            CAP211
364500230913     C     *LOCK         IN        LDA                                                        CAP211
364600230913     C                   EVAL      DBKey = 'CEU006'                                           CAP211
364700230913     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP211
364800230913     C                   EVAL      DBase = 36                                                 CAP211
364900230913     C                   OUT       LDA                                                      MD029681
365000230913     C                   EXSR      *PSSR                                                      CAP211
365100230913     C                   ENDIF                                                                CAP211
365200230913      *                                                                                       CAP211
365300230913     C                   IF        PRTCD = *Blanks                                            CAP211
365400230913     C                   EVAL      CEU006 = 'Y'                                               CAP211
365500230913     C                   ENDIF                                                                CAP211
365600230913      *                                                                                       CAP211
365700230913      ** Access Midas SD Bank details ICD file                                                CAP211
365800230913      *                                                                                       CAP211
365900230913     C                   CALL      'AOBANKR0'                                                 CAP211
366000230913     C                   PARM      *BLANKS       PRTCD                                        CAP211
366100230913     C                   PARM      '*FIRST '     POPTN                                        CAP211
366200230913     C     SDBANK        PARM      SDBANK        DSFDY                                        CAP211
366300230913      *                                                                                       CAP211
366400230913     C                   IF        PRTCD <> *BLANKS                                           CAP211
366500230913     C     *LOCK         IN        LDA                                                        CAP211
366600230913     C                   EVAL      DBKey = POPTN                                              CAP211
366700230913     C                   EVAL      DBFile = 'SDBANKPD'                                        CAP211
366800230913     C                   EVAL      DBase = 37                                                 CAP211
366900230913     C                   OUT       LDA                                                      MD029681
367000230913     C                   EXSR      *PSSR                                                      CAP211
367100230913     C                   ENDIF                                                                CAP211
367200230913      *                                                                                       CAP211
367300230913     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD                                       CAP211
367400230913      *                                                                                       CAP211
367500230913     C                   ENDIF                                                                CAP211
367600230913      *                                                                                       CAP211
367700230913      ** Check the switchable feature CFT120 with the corresponding                           CFT120
367800230913      ** parameters.                                                                          CFT120
367900230913      *                                                                                       CFT120
368000230913     C                   CALLB     'AOSARDR0'                                                 CFT120
368100230913     C                   PARM      *BLANKS       PRtCd                                        CFT120
368200230913     C                   PARM      '*VERIFY'     POptn                                        CFT120
368300230913     C                   PARM      'CFT120'      PSard                                        CFT120
368400230913     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
368500230913      *                                                                                       CFT120
368600230913     C                   IF        PRtcd = *BLANKS                                            CFT120
368700230913     C                   EVAL      CFT120 = 'Y'                                               CFT120
368800230913     C                   ELSE                                                                 CFT120
368900230913      *                                                                                       CFT120
369000230913     C                   IF        PRtcd <> '*NRF'                                            CFT120
369100230913     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
369200230913     C                   EVAL      DBASE = 38                                                 CFT120
369300230913     C                   EVAL      DBKEY = '*VERIFY'                                          CFT120
369400230913     C                   ELSE                                                                 CFT120
369500230913     C                   EVAL      CFT120 = 'N'                                               CFT120
369600230913     C                   ENDIF                                                                CFT120
369700230913      *                                                                                       CFT120
369800230913     C                   ENDIF                                                                CFT120
369900230913      *                                                                                       CFT120
370000230913      ** Check the switchable feature CFT151 is on                                            CFT151
370100230913      *                                                                                       CFT151
370200230913     C                   CALLB     'AOSARDR0'                                                 CFT151
370300230913     C                   PARM      *BLANKS       PRtCd                                        CFT151
370400230913     C                   PARM      '*VERIFY'     POptn                                        CFT151
370500230913     C                   PARM      'CFT151'      PSard                                        CFT151
370600230913     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
370700230913      *                                                                                       CFT151
370800230913     C                   IF        PRtcd = *BLANKS                                            CFT151
370900230913     C                   EVAL      CFT151 = 'Y'                                               CFT151
371000230913     C                   ELSE                                                                 CFT151
371100230913      *                                                                                       CFT151
371200230913     C                   IF        PRtcd <> '*NRF'                                            CFT151
371300230913     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT151
371400230913     C                   EVAL      DBASE = 38                                                 CFT151
371500230913     C                   EVAL      DBKEY = '*VERIFY'                                          CFT151
371600230913     C                   ELSE                                                                 CFT151
371700230913     C                   EVAL      CFT151 = 'N'                                               CFT151
371800230913     C                   ENDIF                                                                CFT151
371900230913      *                                                                                       CFT151
372000230913     C                   ENDIF                                                                CFT151
372100230913      *                                                                                       CFT151
372200230913      ** Determine if Swift 2020 is activated                                                 CSW220
372300230913      *                                                                                       CSW220
372400230913     C                   CALL      'SWIFTACTV'                                                CSW220
372500230913     C                   PARM      'CSW220'      PSWIFT                                       CSW220
372600230913     C                   PARM      *BLANKS       PRTNCD                                       CSW220
372700230913      *                                                                                       CSW220
372800230913     C     PRTNCD        IFEQ      'CSWACTV'                                                  CSW220
372900230913     C                   MOVE      'Y'           CSW220                                       CSW220
373000230913     C                   ELSE                                                                 CSW220
373100230913     C                   MOVE      'N'           CSW220                                       CSW220
373200230913     C                   ENDIF                                                                CSW220
373300230913     C/COPY WNCPYSRC,FTH00108
373400230913                                                                                              223687
373500230913      ** Compliance Watch Hit List Key List                                                   CSD015
373600230913                                                                                              CSD015
373700230913     C     KWHTKY        KLIST                                                                CSD015
373800230913     C                   KFLD                    WFUNT                                        CSD015
373900230913     C                   KFLD                    KIDEN                                        CSD015
374000230913     C                   KFLD                    BRCA                                         CSD015
374100230913                                                                                              CSD015
374200230913
374300230913      *
374400230913      ** Program, module and procedure names for dbase error processing
374500230913      ** ==============================================================
374600230913      ** The following /COPY sets these values.
374700230913      *
374800230913      /COPY ZACPYSRC,DBFIELDS
374900230913      *
375000230913     C                   ENDSR
375100230913      *
375200230913      *****************************************************************
375300230913      /EJECT
375400230913      *****************************************************************
375500230913      *                                                               *
375600230913      *  SRERR - Routine for Exception Errors                         *
375700230913      *                                                               *
375800230913      *****************************************************************
375900230913      *
376000230913     C     SRERR         BEGSR
376100230913      *
376200230913     C                   EVAL      RetCodeIn = '*ERROR '
376300230913     C                   EVAL      *INU7 = *ON
376400230913     C                   EVAL      *INU8 = *ON
376500230913     C                   EVAL      *INLR = *ON
376600230913      *
376700230913     C                   DUMP
376800230913      *
376900230913      ** Terminate program.
377000230913      *
377100230913     C                   RETURN
377200230913      *
377300230913     C                   ENDSR
377400230913      *
377500230913      *****************************************************************                       CAP211
377600230913      /EJECT                                                                                  CAP211
377700230913      *****************************************************************                       CAP211
377800230913      *                                                               *                       CAP211
377900230913      *  WOTPAY - Generate Outgoing Payment from Incoming Payment     *                       CAP211
378000230913      *                                                               *                       CAP211
378100230913      *****************************************************************                       CAP211
378200230913      *                                                                                       CAP211
378300230913     C     WOTPAY        BEGSR                                                                CAP211
378400230913      *                                                                                       CAP211
378500230913     C                   MOVE      BRCA          IBRCA             3                          CAP211
378600230913      *                                                                                       CAP211
378700230913s1   C     ACBT          IFNE      *Blank                                                     CAP211
378800230913      *                                                                                       CAP211
378900230913s2   C     ACBT          IFEQ      'N'                                                        CAP211
379000230913     C                   EVAL      WAXSBY = 'NOSTRO'                                          CAP211
379100230913     C                   EVAL      WNOCCY = PCCY                                              CAP211
379200230913     C                   EVAL      WNOCOD = ACBK                                              CAP211
379300230913e2   C                   ENDIF                                                                CAP211
379400230913      *                                                                                       CAP211
379500230913s2   C     ACBT          IFEQ      'R'                                                        CAP211
379600230913     C                   EVAL      WAXSBY = 'RETAIL'                                          CAP211
379700230913     C                   MOVEL     ACBK          WRACNO                                       CAP211
379800230913e2   C                   ENDIF                                                                CAP211
379900230913      *                                                                                       CAP211
380000230913s2   C     ACBT          IFEQ      'P'                                                        CAP211
380100230913     C     ACBT          OREQ      'C'                                                        CAP211
380200230913     C                   MOVE      *Blanks       WKEYL9                                       CAP211
380300230913     C                   MOVE      *Blanks       WKEYL15                                      CAP211
380400230913     C                   MOVE      *Blanks       WKEYL18                                      CAP211
380500230913     C                   MOVEL     ACBK          WKEYL9                                       CAP211
380600230913     C                   MOVE      PCCY          WKEYL9                                       CAP211
380700230913     C                   MOVE      ACBK          WKEYL15                                      CAP211
380800230913     C                   MOVEL     WKEYL9        WKEYL15                                      CAP211
380900230913     C                   MOVE      ACBB          WKEYL18                                      CAP211
381000230913     C                   MOVEL     WKEYL15       WKEYL18                                      CAP211
381100230913      *                                                                                       CAP211
381200230913     C                   EVAL      WAXSBY = 'ACCNTS'                                          CAP211
381300230913     C                   EVAL      WACCNT = WKEYL18                                           CAP211
381400230913e2   C                   ENDIF                                                                CAP211
381500230913      *                                                                                       CAP211
381600230913     C                   EXSR      SRAcnt                                                     CAP211
381700230913     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
381800230913      *                                                                                       CAP211
381900230913e1   C                   ENDIF                                                                CAP211
382000230913      *                                                                                       CAP211
382100230913s1   C     ACBT          IFNE      'S'                                                        CAP211
382200230913      *                                                                                       CAP211
382300230913     C                   CALL      'AOCUSTR0'                                                 CAP211
382400230913     C                   PARM      *BLANKS       PRTCD             7                          CAP211
382500230913     C                   PARM      '*KEY   '     POPTN             7                          CAP211
382600230913     C                   PARM      @ACCNUM       PKEY1            10                          CAP211
382700230913     C                   PARM      *BLANK        PKYST             7                          CAP211
382800230913     C     SDCUST        PARM      SDCUST        DSSDY                                        CAP211
382900230913      *                                                                                       CAP211
383000230913s2   C     PRTCD         IFNE      *BLANKS                                                    CAP211
383100230913     C     PKYST         ORNE      '*CNUM'                                                    CAP211
383200230913     C                   Z-ADD     900           DBASE                                        CAP211
383300230913     C                   MOVEL     @ACCNUM       DBKEY                                        CAP211
383400230913     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CAP211
383500230913     C                   EXSR      *PSSR                                                      CAP211
383600230913e2   C                   ENDIF                                                                CAP211
383700230913      *                                                                                       CAP211
383800230913e1   C                   ENDIF                                                                CAP211
383900230913      *                                                                                       CAP211
384000230913     C                   MOVE      IPPref        OXPREF                                       CAP211
384100230913     C                   MOVE      'D'           RECI                                         CAP211
384200230913     C                   EVAL      ZDAYNO = BJRDNB                                            CAP211
384300230913      *                                                                                       CAP211
384400230913     C                   CALLB     'ZDATE2'                                                   CAP211
384500230913     C                   PARM                    ZDAYNO            5 0                        CAP211
384600230913     C                   PARM      'M'           ZDATFM            1                          CAP211
384700230913     C                   PARM      *ZEROS        ZDATE             6 0                        CAP211
384800230913     C                   PARM      *Blanks       ZADATE            7                          CAP211
384900230913     C                   MOVE      ZDATE         RUNDYY                                       CAP211
385000230913     C                   MOVEL     ZDATE         RUNDMD                                       CAP211
385100230913     C                   MOVE      'OP'          PmntType                                     CAP211
385200230913     C                   MOVE      'OP'          PYTP                                         CAP211
385300230913     C                   Z-ADD     0             StmtType                                     CAP211
385400230913     C                   Z-ADD     0             STMT                                         CAP211
385500230913      *                                                                                       CAP211
385600230913     C                   IF        CFT151 = 'N'                                               CFT151
385700230913     C     *LOCK         IN        OTPAYD                                                     CAP211
385800230913     C**********         Z-ADD     OSQNM         PRNUM                                 CAP211 CFT151
385900230913     C**********         ADD       1             OSQNM                                 CAP211 CFT151
386000230913     C                   MOVEL     WOTSQ         PRNUM                                        CFT151
386100230913     C                   ADD       1             WOTSQ                                        CFT151
386200230913     C                   OUT       OTPAYD                                                     CAP211
386300230913     C                   ELSE                                                                 CFT151
386400230913     C                   CALL      'FT000328'                                                 CFT151
386500230913     C                   PARM                    PRTCD                                        CFT151
386600230913     C                   PARM      'OT'          W@OTIN            2                          CFT151
386700230913     C                   PARM      'A'           WCALC             1                          CFT151
386800230913     C                   PARM      'Y'           WUPD              1                          CFT151
386900230913     C                   PARM                    PRNUM                                        CFT151
387000230913     C                   PARM                    WNEWSQ            4                          CFT151
387100230913     C                   ENDIF                                                                CFT151
387200230913     C                   MOVE      IPREF         PREF                                         CAP211
387300230913      *                                                                                       CAP211
387400230913     C                   MOVE      *Blanks       PYST                                         CAP211
387500230913     C                   MOVE      *Blanks       DST1                                         CAP211
387600230913     C                   MOVE      *Blanks       DST2                                         CAP211
387700230913     C                   MOVE      *Blanks       DST3                                         CAP211
387800230913     C                   MOVE      *Blanks       DST4                                         CAP211
387900230913     C                   MOVE      *Blanks       ACB1                                         CAP211
388000230913     C                   MOVE      *Blanks       ACB2                                         CAP211
388100230913     C                   MOVE      *Blanks       ACB3                                         CAP211
388200230913     C                   MOVE      *Blanks       ACB4                                         CAP211
388300230913     C                   MOVE      *Blanks       ACB5                                         CAP211
388400230913      *                                                                                       CAP211
388500230913s1   C     INBT          IFEQ      *Blanks                                                    CAP211
388600230913      *                                                                                       CAP211
388700230913s2   C     ACBT          IFEQ      'N'                                                        CAP211
388800230913     C                   EVAL      WNOCOD = ACBK                                              CAP211
388900230913     C                   MOVEL     PCCY          WKEYL5                                       CAP211
389000230913     C                   MOVE      WNOCOD        WKEYL5                                       CAP211
389100230913     C                   MOVE      'F'           DSTT                                         CAP211
389200230913     C                   MOVEL     WKEYL5        DST1                                         CAP211
389300230913e2   C                   ENDIF                                                                CAP211
389400230913s2   C     ACBT          IFEQ      'R'                                                        CAP211
389500230913     C                   MOVEL     ACBK          WRACNO                                       CAP211
389600230913     C                   MOVE      ACBT          DSTT                                         CAP211
389700230913     C                   MOVEL     WRACNO        DST1                                         CAP211
389800230913e2   C                   ENDIF                                                                CAP211
389900230913s2   C     INACBT        IFNE      *Blanks                                                    CAP211
390000230913s3   C     INACBT        IFNE      'S'                                                        CAP211
390100230913     C                   MOVEL     'S'           DSTT                                         CAP211
390200230913x3   C                   ELSE                                                                 CAP211
390300230913     C                   MOVEl     'A'           DSTT                                         CAP211
390400230913e3   C                   ENDIF                                                                CAP211
390500230913     C                   MOVEL     INACB1        DST1                                         CAP211
390600230913     C                   MOVEL     INACB2        DST2                                         CAP211
390700230913     C                   MOVEL     INACB3        DST3                                         CAP211
390800230913     C                   MOVEL     INACB4        DST4                                         CAP211
390900230913e2   C                   ENDIF                                                                CAP211
391000230913s2   C     ACBT          IFEQ      'P'                                                        CAP211
391100230913     C                   MOVE      *Blanks       WKEYL9                                       CAP211
391200230913     C                   MOVE      *Blanks       WKEYL15                                      CAP211
391300230913     C                   MOVE      *Blanks       WKEYL18                                      CAP211
391400230913     C                   MOVEL     ACBK          WKEYL9                                       CAP211
391500230913     C                   MOVE      PCCY          WKEYL9                                       CAP211
391600230913     C                   MOVE      ACBK          WKEYL15                                      CAP211
391700230913     C                   MOVEL     WKEYL9        WKEYL15                                      CAP211
391800230913     C                   MOVE      ACBB          WKEYL18                                      CAP211
391900230913     C                   MOVEL     WKEYL15       WKEYL18                                      CAP211
392000230913     C                   MOVEL     WKEYL18       DST1                                         CAP211
392100230913     C                   MOVEL     'G'           DSTT                                         CAP211
392200230913e2   C                   ENDIF                                                                CAP211
392300230913s2   C     ACBT          IFEQ      'C'                                                        CAP211
392400230913     C                   MOVE      *Blanks       WKEYL6            6                          CAP211
392500230913     C                   MOVEL     ACBK          WKEYL6                                       CAP211
392600230913     C                   MOVEL     WKEYL6        DST1                                         CAP211
392700230913     C                   MOVEL     ACBT          DSTT                                         CAP211
392800230913e2   C                   ENDIF                                                                CAP211
392900230913s2   C     ACBT          IFEQ      'S'                                                        CAP211
393000230913     C                   MOVE      *Blanks       WKEYL12                                      CAP211
393100230913     C                   MOVEL     ACBK          WKEYL12                                      CAP211
393200230913     C                   MOVEL     WKEYL12       DST1                                         CAP211
393300230913     C                   MOVEL     ACBT          DSTT                                         CAP211
393400230913e2   C                   ENDIF                                                                CAP211
393500230913      *                                                                                       CAP211
393600230913     C                   MOVEL     *Blanks       ACBT                                         CAP211
393700230913x1   C                   ELSE                                                                 CAP211
393800230913s2   C     INBT          IFEQ      'S'                                                        CAP211
393900230913     C                   MOVEL     INB1          DST1                                         CAP211
394000230913     C                   MOVE      'S'           DSTT                                         CAP211
394100230913x2   C                   ELSE                                                                 CAP211
394200230913     C                   MOVE      INBT          DSTT                                         CAP211
394300230913     C                   MOVE      INB1          DST1                                         CAP211
394400230913     C                   MOVE      INB2          DST2                                         CAP211
394500230913     C                   MOVE      INB3          DST3                                         CAP211
394600230913     C                   MOVE      INB4          DST4                                         CAP211
394700230913e2   C                   ENDIF                                                                CAP211
394800230913      *                                                                                       CAP211
394900230913s2   C     ACBT          IFEQ      'N'                                                        CAP211
395000230913     C     ACBT          OREQ      'R'                                                        CAP211
395100230913     C     ACBT          OREQ      'P'                                                        CAP211
395200230913     C     INACBT        ANDEQ     *Blanks                                                    CAP211
395300230913s3   C     BBCSID        IFNE      *Blanks                                                    CAP211
395400230913     C                   MOVEL     BBCSID        ACB1                                         CAP211
395500230913     C                   MOVE      'S'           ACBT                                         CAP211
395600230913x3   C                   ELSE                                                                 CAP211
395700230913     C                   MOVEL     BBCNA1        ACB1                                         CAP211
395800230913     C                   MOVEL     BBCNA2        ACB2                                         CAP211
395900230913     C                   MOVEL     BBCNA3        ACB3                                         CAP211
396000230913     C                   MOVEL     BBCNA4        ACB4                                         CAP211
396100230913     C                   MOVE      'A'           ACBT                                         CAP211
396200230913e3   C                   ENDIF                                                                CAP211
396300230913      *                                                                                       CAP211
396400230913x2   C                   ELSE                                                                 CAP211
396500230913s3   C     INACBT        IFNE      *Blanks                                                    CAP211
396600230913s4   C     INACBT        IFEQ      'S'                                                        CAP211
396700230913     C                   MOVE      'S'           ACBT                                         CAP211
396800230913x4   C                   ELSE                                                                 CAP211
396900230913     C                   MOVE      'A'           ACBT                                         CAP211
397000230913e4   C                   ENDIF                                                                CAP211
397100230913     C                   MOVEL     INACB1        ACB1                                         CAP211
397200230913     C                   MOVEL     INACB2        ACB2                                         CAP211
397300230913     C                   MOVEL     INACB3        ACB3                                         CAP211
397400230913     C                   MOVEL     INACB4        ACB4                                         CAP211
397500230913     C                   MOVEL     INACB5        ACB5                                         CAP211
397600230913e3   C                   ENDIF                                                                CAP211
397700230913e2   C                   ENDIF                                                                CAP211
397800230913      *                                                                                       CAP211
397900230913e1   C                   ENDIF                                                                CAP211
398000230913      *                                                                                       CAP211
398100230913     C                   MOVE      *Blank        SNCT                                         CAP211
398200230913     C                   MOVE      *Blanks       SNCO                                         CAP211
398300230913     C                   Z-ADD     1             RATE                                         CAP211
398400230913     C                   z-ADD     1             RATED                                        CAP211
398500230913     C                   MOVE      'N'           OVRD                                         CAP211
398600230913     C                   Z-ADD     PYAM          SMAM                                         CAP211
398700230913s1   C     CDRO          IFEQ      *blanks                                                    CAP211
398800230913     C     ADDC          ANDEQ     'D'                                                        CAP211
398900230913     C                   SUB       TRCM          SMAM                                         CAP211
399000230913     C                   SUB       TXCH          SMAM                                         CAP211
399100230913     C                   SUB       CQCH          SMAM                                         CAP211
399200230913     C                   SUB       ADCH          SMAM                                         CAP211
399300230913     C                   SUB       TLCH          SMAM                                         CAP211
399400230913     C                   SUB       MSCH          SMAM                                         CAP211
399500230913s2   C     CFT009        IFEQ      'Y'                                                        CAP211
399600230913     C                   SUB       MSC01         SMAM                                         CAP211
399700230913     C                   SUB       MSC02         SMAM                                         CAP211
399800230913     C                   SUB       MSC03         SMAM                                         CAP211
399900230913     C                   SUB       MSC04         SMAM                                         CAP211
400000230913     C                   SUB       MSC05         SMAM                                         CAP211
400100230913e2   C                   ENDIF                                                                CAP211
400200230913e1   C                   ENDIF                                                                CAP211
400300230913      *                                                                                       CAP211
400400230913     C                   Z-ADD     TRCM          WCHGS            13 0                        CAP211
400500230913s1   C     S01494        IFEQ      'Y'                                                        CAP211
400600230913     C                   ADD       INCHCM        WCHGS                                        CAP211
400700230913e1   C                   ENDIF                                                                CAP211
400800230913     C                   ADD       TXCH          WCHGS                                        CAP211
400900230913     C                   ADD       CQCH          WCHGS                                        CAP211
401000230913     C                   ADD       ADCH          WCHGS                                        CAP211
401100230913     C                   ADD       TLCH          WCHGS                                        CAP211
401200230913     C                   ADD       MSCH          WCHGS                                        CAP211
401300230913s1   C     CFT009        IFEQ      'Y'                                                        CAP211
401400230913     C                   ADD       MSC01         WCHGS                                        CAP211
401500230913     C                   ADD       MSC02         WCHGS                                        CAP211
401600230913     C                   ADD       MSC03         WCHGS                                        CAP211
401700230913     C                   ADD       MSC04         WCHGS                                        CAP211
401800230913     C                   ADD       MSC05         WCHGS                                        CAP211
401900230913e1   C                   ENDIF                                                                CAP211
402000230913s1   C     S01499        IFEQ      'Y'                                                        CAP211
402100230913     C                   ADD       INVATT        WCHGS                                        CAP211
402200230913e1   C                   ENDIF                                                                CAP211
402300230913      *                                                                                       CAP211
402400230913s1   C                   SELECT                                                               CAP211
402500230913     C     CDRO          WHENNE    *blanks                                                    CAP211
402600230913     C                   MOVEL     BJCYCD        WCCCY             3                          CAP211
402700230913     C     ADDC          WHENEQ    'A'                                                        CAP211
402800230913     C                   MOVEL     SMCY          WCCCY                                        CAP211
402900230913s2   C     SND1          IFEQ      'CASHIER'                                                  CAP211
403000230913     C     PCCY          ANDEQ     BJCYCD                                                     CAP211
403100230913     C                   MOVEL     PCCY          WCCCY                                        CAP211
403200230913e2   C                   ENDIF                                                                CAP211
403300230913     C                   OTHER                                                                CAP211
403400230913     C                   MOVEL     PCCY          WCCCY                                        CAP211
403500230913e1   C                   ENDSL                                                                CAP211
403600230913      *                                                                                       CAP211
403700230913     C                   MOVE      SMCY          WSMCYX            3                          CAP211
403800230913     C                   MOVE      PCCY          SMCY                                         CAP211
403900230913     C                   Z-ADD     PVDT          SLDT                                         CAP211
404000230913     C                   Z-ADD     PVDTD1        SLDTD1                                       CAP211
404100230913     C                   Z-ADD     PVDTD2        SLDTD2                                       CAP211
404200230913     C                   Z-ADD     PVDTD3        SLDTD3                                       CAP211
404300230913      *                                                                                       CAP211
404400230913     C                   CALL      'AOCURRR0'                                                 CAP211
404500230913     C                   PARM      *BLANKS       PRTCD                                        CAP211
404600230913     C                   PARM      '*KEY   '     POPTN                                        CAP211
404700230913     C************       PARM      PCCY          PCCY                               CAP211  MD054037
404800230913     C                   PARM      SMCY          P#CCY             3                        MD054037
404900230913     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP211
405000230913      *                                                                                       CAP211
405100230913s1   C     PRTCD         IFNE      *BLANKS                                                    CAP211
405200230913     C                   MOVEL     SMCY          DBKEY                                        CAP211
405300230913     C                   MOVEL     'SDCURRPD'    DBFILE                                       CAP211
405400230913     C                   Z-ADD     901           DBASE                                        CAP211
405500230913     C                   EXSR      *PSSR                                                      CAP211
405600230913e1   C                   ENDIF                                                                CAP211
405700230913     C                   Z-ADD     A6NBDP        RCDP              1 0                        CAP211
405800230913     C                   Z-ADD     A6SPRT        RSPOT            13 8                        CAP211
405900230913s1   C     A6MDIN        IFEQ      'M'                                                        CAP211
406000230913     C                   Z-ADD     1             RMDIN             1 0                        CAP211
406100230913x1   C                   ELSE                                                                 CAP211
406200230913     C                   Z-ADD     0             RMDIN                                        CAP211
406300230913e1   C                   ENDIF                                                                CAP211
406400230913      *                                                                                       CAP211
406500230913     C     RCDP          ADD       4             N                 1 0                        CAP211
406600230913     C                   SELECT                                                               CAP211
406700230913     C                   WHEN      RCDP = 0                                                   CAP211
406800230913     C                   Z-ADD     SMAM          SMAMD                                        CAP211
406900230913     C                   WHEN      RCDP = 1                                                   CAP211
407000230913     C                   EVAL      SMAMD = SMAM / 10                                          CAP211
407100230913     C                   WHEN      RCDP = 2                                                   CAP211
407200230913     C                   EVAL      SMAMD = SMAM / 100                                         CAP211
407300230913     C                   OTHER                                                                CAP211
407400230913     C                   EVAL      SMAMD = SMAM / 1000                                        CAP211
407500230913     C                   ENDSL                                                                CAP211
407600230913      *                                                                                       CAP211
407700230913     C                   CALL      'AOCURRR0'                                                 CAP211
407800230913     C                   PARM      *BLANKS       PRTCD                                        CAP211
407900230913     C                   PARM      '*KEY   '     POPTN                                        CAP211
408000230913     C************       PARM      BJCYCD        PCCY                                CAP211 MD054037
408100230913     C                   PARM      BJCYCD        P#CCY                                      MD054037
408200230913     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP211
408300230913      *                                                                                       CAP211
408400230913s1   C     PRTCD         IFNE      *BLANKS                                                    CAP211
408500230913     C                   MOVEL     BJCYCD        DBKEY                                        CAP211
408600230913     C                   MOVEL     'SDCURRPD'    DBFILE                                       CAP211
408700230913     C                   Z-ADD     902           DBASE                                        CAP211
408800230913     C                   EXSR      *PSSR                                                      CAP211
408900230913e1   C                   ENDIF                                                                CAP211
409000230913      *                                                                                       CAP211
409100230913     C                   z-add     A6NBDP        BCDP              1 0                        CAP211
409200230913     C     RCDP          SUB       BCDP          N                                            CAP211
409300230913     C                   ADD       4             N                                            CAP211
409400230913      *                                                                                       CAP211
409500230913s1   C     RMDIN         IfEQ      0                                                          CAP211
409600230913     C     RSPOT         MULT(H)   POWERS(N)     WK159            15 9                        CAP211
409700230913     C     SMAM          DIV(H)    WK159         SBCQ                                         CAP211
409800230913x1   C                   ELSE                                                                 CAP211
409900230913     C     RSPOT         DIV(H)    POWERS(N)     WK159                                        CAP211
410000230913e1   C     SMAM          MULT(H)   WK159         SBCQ                                         CAP211
410100230913     C                   ENDIF                                                                CAP211
410200230913      *                                                                                       CAP211
410300230913     C                   Z-ADD     0             PYAM                                         CAP211
410400230913     C                   Z-ADD     0             PYAMD                                        CAP211
410500230913     C                   Z-ADD     0             PBCQ                                         CAP211
410600230913     C                   MOVE      'D'           ADDC                                         CAP211
410700230913     C                   MOVE      'N'           RPAY                                         CAP211
410800230913     C                   MOVE      *Blank        PAYF                                         CAP211
410900230913     C                   Z-ADD     0             DYIM                                         CAP211
411000230913     C                   Z-ADD     0             FDAT                                         CAP211
411100230913     C                   Z-ADD     0             FDATD1                                       CAP211
411200230913     C                   Z-ADD     0             FDATD2                                       CAP211
411300230913     C                   Z-ADD     0             FDATD3                                       CAP211
411400230913      *                                                                                       CAP211
411500230913s1   C     ACB1          IFEQ      *Blanks                                                    CAP211
411600230913     C                   MOVE      *Blanks       ACBT                                         CAP211
411700230913e1   C                   ENDIF                                                                CAP211
411800230913      *                                                                                       CAP211
411900230913     C                   MOVE      *Blanks       SNMT                                         CAP211
412000230913     C                   Z-ADD     0             STMT                                         CAP211
412100230913     C                   MOVE      *Blanks       RCRT                                         CAP211
412200230913     C                   MOVE      *Blanks       RCO1                                         CAP211
412300230913     C                   MOVE      *Blanks       RCO2                                         CAP211
412400230913     C                   MOVE      *Blanks       RCO3                                         CAP211
412500230913     C                   MOVE      *Blanks       RCO4                                         CAP211
412600230913     C                   MOVE      *Blanks       RCO5                                         CAP211
412700230913     C                   MOVE      *Blanks       BBI1                                         CAP211
412800230913     C                   MOVE      *Blanks       ORBB                                         CAP211
412900230913      *                                                                                       CAP211
413000230913      ** Ordering bank                                                                        CAP211
413100230913      *                                                                                       CAP211
413200230913     C                   MOVE      *Blanks       OPORBT                                       CAP211
413300230913     C                   MOVE      *Blanks       OPORB1                                       CAP211
413400230913     C                   MOVE      *Blanks       OPORB2                                       CAP211
413500230913     C                   MOVE      *Blanks       OPORB3                                       CAP211
413600230913     C                   MOVE      *Blanks       OPORB4                                       CAP211
413700230913     C                   MOVE      *Blanks       OPORB5                                       CAP211
413800230913      *                                                                                       CAP211
413900230913     C                   CALL      'AOBRCHR1'                                                 CAP211
414000230913     C                   PARM      *BLANKS       PRTCD                                        CAP211
414100230913     C                   PARM      '*KEY   '     POPTN                                        CAP211
414200230913     C                   PARM      BRCA          PBRCH             3                          CAP211
414300230913     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CAP211
414400230913      *                                                                                       CAP211
414500230913s1   C     PRTCD         IFNE      *BLANKS                                                    CAP211
414600230913     C                   MOVEL     BRCA          DBKEY                                        CAP211
414700230913     C                   MOVEL     'SDBRCHPD'    DBFILE                                       CAP211
414800230913     C                   Z-ADD     903           DBASE                                        CAP211
414900230913     C                   EXSR      *PSSR                                                      CAP211
415000230913e1   C                   ENDIF                                                                CAP211
415100230913     C                   MOVE      A8BICN        OBCNUM                                       CAP211
415200230913     C                   MOVE      BTIOSA        OBACOD                                       CAP211
415300230913     C                   Z-ADD     1             OBACSQ                                       CAP211
415400230913      *                                                                                       CAP211
415500230913s1   C     ORBT          IFEQ      *Blank                                                     CAP211
415600230913     C                   MOVE      *Blanks       ORBK                                         CAP211
415700230913     C                   MOVE      *Blanks       ORBT                                         CAP211
415800230913s2   C     SNTP          IFEQ      'F'                                                        CAP211
415900230913     C                   MOVEL     SND1          WKEYL5                                       CAP211
416000230913     C                   MOVEL     WKEYL5        WNOCCY                                       CAP211
416100230913     C                   MOVE      WKEYL5        WNOCOD                                       CAP211
416200230913s3   C     WNOCCY        IFEQ      PCCY                                                       CAP211
416300230913     C                   MOVEL     WNOCOD        ORBK                                         CAP211
416400230913     C                   MOVE      'N'           ORBT                                         CAP211
416500230913     C                   MOVEL     @DFT(1)       OPORB1                                       CAP211
416600230913e3   C                   ENDIF                                                                CAP211
416700230913x2   C                   ELSE                                                                 CAP211
416800230913s3   C     SNTP          IFEQ      'G'                                                        CAP211
416900230913     C                   EVAL      WKEYL18 = SND1                                             CAP211
417000230913     C                   MOVEL     WKEYL18       WACCNT                                       CAP211
417100230913s4   C     WACCCY        IFEQ      PCCY                                                       CAP211
417200230913     C                   MOVE      OBFTAC        WKEYL12                                      CAP211
417300230913     C                   MOVE      WACNUM        OBCNUM                                       CAP211
417400230913     C                   Z-ADD     WACCD         OBACOD                                       CAP211
417500230913     C                   Z-ADD     WACSQ         OBACSQ                                       CAP211
417600230913     C                   MOVEL     FTDFAC        ORBK                                         CAP211
417700230913     C                   MOVE      WKEYL12       OBFTAC                                       CAP211
417800230913     C                   MOVEL     WBRCA         ORBB                                         CAP211
417900230913     C                   MOVEL     'P'           ORBT                                         CAP211
418000230913     C                   MOVEL     @DFT(1)       OPORB1                                       CAP211
418100230913e4   C                   ENDIF                                                                CAP211
418200230913x3   C                   ELSE                                                                 CAP211
418300230913s4   C     SNTP          IFEQ      'R'                                                        CAP211
418400230913     C                   MOVEL     SND1          WRACNO           10                          CAP211
418500230913     C                   MOVEL     WRACNO        WKACNO           10 0                        CAP211
418600230913     C     WKACNO        CHAIN     ACNUMA                             99                      CAP211
418700230913s5   C     ACCCY         IFEQ      PCCY                                                       CAP211
418800230913     C     *IN99         ANDEQ     *Off                                                       CAP211
418900230913     C                   MOVE      'R'           ORBT                                         CAP211
419000230913     C                   MOVEL     SND1          ORBK                                         CAP211
419100230913     C                   MOVEL     @DFT(1)       OPORB1                                       CAP211
419200230913e5   C                   ENDIF                                                                CAP211
419300230913e4   C                   ENDIF                                                                CAP211
419400230913e3   C                   ENDIF                                                                CAP211
419500230913e2   C                   ENDIF                                                                CAP211
419600230913x1   C                   ELSE                                                                 CAP211
419700230913     C                   MOVEL     ORBT          OPORBT                                       CAP211
419800230913     C                   MOVEL     ORB1          OPORB1                                       CAP211
419900230913     C                   MOVEL     ORB2          OPORB2                                       CAP211
420000230913     C                   MOVEL     ORB3          OPORB3                                       CAP211
420100230913     C                   MOVEL     ORB4          OPORB4                                       CAP211
420200230913     C                   MOVEL     ORB5          OPORB5                                       CAP211
420300230913      *                                                                                       CAP211
420400230913     C                   MOVE      *Blanks       ORBK                                         CAP211
420500230913     C                   MOVE      OBFTAC        ORBK                                         CAP211
420600230913     C                   MOVE      'P'           ORBT                                         CAP211
420700230913     C                   MOVEL     BRCA          ORBB                                         CAP211
420800230913e1   C                   ENDIF                                                                CAP211
420900230913      *                                                                                       CAP211
421000230913      ** Map Swift message details                                                            CAP211
421100230913      *                                                                                       CAP211
421200230913s1   C     ORBT          IFEQ      *Blanks                                                    CAP211
421300230913     C                   MOVE      OBFTAC        ORBK                                         CAP211
421400230913     C                   MOVEL     'P'           ORBT                                         CAP211
421500230913     C                   MOVEL     BRCA          ORBB                                         CAP211
421600230913s2   C     SNTP          IFEQ      'G'                                                        CAP211
421700230913     C     SNTP          OREQ      'F'                                                        CAP211
421800230913     C     SNTP          OREQ      'R'                                                        CAP211
421900230913     C     SNTP          OREQ      'C'                                                        CAP211
422000230913s3   C     SNTP          IFEQ      'G'                                                        CAP211
422100230913     C     SNTP          OREQ      'C'                                                        CAP211
422200230913     C                   MOVEL     SND1          @ACCNUM                                      CAP211
422300230913e3   C                   ENDIF                                                                CAP211
422400230913s3   C     SNTP          IFEQ      'R'                                                        CAP211
422500230913     C                   EVAL      WAXSBY = 'RETAIL'                                          CAP211
422600230913     C                   MOVEL     SND1          WRACNO           10                          CAP211
422700230913     C                   EXSR      SrAcnt                                                     CAP211
422800230913     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
422900230913e3   C                   ENDIF                                                                CAP211
423000230913s3   C     SNTP          IFEQ      'F'                                                        CAP211
423100230913     C                   EVAL      WAXSBY = 'NOSTRO'                                          CAP211
423200230913     C                   MOVEL     SND1          WKEYL5            5                          CAP211
423300230913     C                   MOVEL     WKEYL5        WNOCCY            3                          CAP211
423400230913     C                   MOVE      WKEYL5        WNOCOD            2                          CAP211
423500230913     C                   EXSR      SrAcnt                                                     CAP211
423600230913     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
423700230913e3   C                   ENDIF                                                                CAP211
423800230913      *                                                                                       CAP211
423900230913     C                   CALL      'AOCUSTR0'                                                 CAP211
424000230913     C                   PARM      *BLANKS       PRTCD             7                          CAP211
424100230913     C                   PARM      '*KEY   '     POPTN             7                          CAP211
424200230913     C                   PARM      @ACCNUM       PKEY1            10                          CAP211
424300230913     C                   PARM      *BLANK        PKYST             7                          CAP211
424400230913     C     SDCUST        PARM      SDCUST        DSSDY                                        CAP211
424500230913      *                                                                                       CAP211
424600230913s3   C     PRTCD         IFNE      *BLANKS                                                    CAP211
424700230913     C     PKYST         ORNE      '*CNUM'                                                    CAP211
424800230913     C                   Z-ADD     905           DBASE                                        CAP211
424900230913     C                   MOVEL     @ACCNUM       DBKEY                                        CAP211
425000230913     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CAP211
425100230913     C                   EXSR      *PSSR                                                      CAP211
425200230913e3   C                   ENDIF                                                                CAP211
425300230913s3   C     BBCSID        IFEQ      *Blanks                                                    CAP211
425400230913     C                   MOVE      'A'           OPORBT                                       CAP211
425500230913     C                   MOVEL     BBCNA1        OPORB1                                       CAP211
425600230913     C                   MOVEL     BBCNA2        OPORB2                                       CAP211
425700230913     C                   MOVEL     BBCNA3        OPORB3                                       CAP211
425800230913     C                   MOVEL     BBCNA4        OPORB4                                       CAP211
425900230913     C                   MOVEL     *Blanks       OPORB5                                       CAP211
426000230913x3   C                   ELSE                                                                 CAP211
426100230913     C                   MOVE      'S'           OPORBT                                       CAP211
426200230913     C                   MOVEL     BBCSID        OPORB1                                       CAP211
426300230913e3   C                   ENDIF                                                                CAP211
426400230913x2   C                   ELSE                                                                 CAP211
426500230913s3   C     SNTP          IFEQ      'A'                                                        CAP211
426600230913     C     SNTP          OREQ      'S'                                                        CAP211
426700230913     C                   MOVEL     SNTP          OPORBT                                       CAP211
426800230913     C                   MOVEL     SND1          OPORB1                                       CAP211
426900230913     C                   MOVEL     SND2          OPORB2                                       CAP211
427000230913     C                   MOVEL     SND3          OPORB3                                       CAP211
427100230913     C                   MOVEL     SND4          OPORB4                                       CAP211
427200230913     C                   MOVEL     *Blanks       OPORB5                                       CAP211
427300230913e3   C                   ENDIF                                                                CAP211
427400230913e2   C                   ENDIF                                                                CAP211
427500230913e1   C                   ENDIF                                                                CAP211
427600230913      *                                                                                       CAP211
427700230913      ** Bank to bank information fields                                                      CAP211
427800230913      *                                                                                       CAP211
427900230913     C                   MOVEL     *Blanks       BBI1                                         CAP211
428000230913     C                   MOVEL     *Blanks       BBI2                                         CAP211
428100230913     C                   MOVEL     *Blanks       BBI3                                         CAP211
428200230913     C                   MOVEL     *Blanks       BBI4                                         CAP211
428300230913     C                   MOVEL     *Blanks       BBI5                                         CAP211
428400230913     C                   MOVEL     *Blanks       BBI6                                         CAP211
428500230913s1   C     INMTPY        IFEQ      '200'                                                      CAP211
428600230913     C     INMTPY        OREQ      '201'                                                      CAP211
428700230913     C     INMTPY        OREQ      '202'                                                      CAP211
428800230913     C     INMTPY        OREQ      '203'                                                      CAP211
428900230913     C     INMTPY        OREQ      '205'                                                      CAP211
429000230913s2   C     ORCT          IFEQ      *Blank                                                     CAP211
429100230913     C                   MOVE      *Blanks       ORC1                                         CAP211
429200230913     C                   MOVE      *Blanks       ORC2                                         CAP211
429300230913     C                   MOVE      *Blanks       ORC3                                         CAP211
429400230913     C                   MOVE      *Blanks       ORC4                                         CAP211
429500230913     C                   MOVEL     'MT202'       ORC1                                         CAP211
429600230913     C                   MOVE      'A'           ORCT                                         CAP211
429700230913e2   C                   ENDIF                                                                CAP211
429800230913e1   C                   ENDIF                                                                CAP211
429900230913      *                                                                                       CAP211
430000230913      ** Beneficiary                                                                          CAP211
430100230913      *                                                                                       CAP211
430200230913s1   C     BNCT          IFEQ      'R'                                                        CAP211
430300230913     C                   EVAL      WAXSBY = 'RETAIL'                                          CAP211
430400230913     C                   MOVEL     BNC1          WRACNO           10                          CAP211
430500230913     C                   EXSR      SrAcnt                                                     CAP211
430600230913     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
430700230913e1   C                   ENDIF                                                                CAP211
430800230913s1   C     BNCT          IFEQ      'P'                                                        CAP211
430900230913     C                   MOVEL     BNC1          @ACCNUM                                      CAP211
431000230913     C                   EXSR      SrAcnt                                                     CAP211
431100230913     C                   MOVE      ACCNUM        @ACCNUM           6                          CAP211
431200230913e1   C                   ENDIF                                                                CAP211
431300230913s1   C     BNCT          IFEQ      'R'                                                        CAP211
431400230913     C     BNCT          OREQ      'P'                                                        CAP211
431500230913     C                   MOVEL     *Blanks       BNC1                                         CAP211
431600230913     C                   MOVEL     @ACCNUM       BNC1                                         CAP211
431700230913     C                   MOVE      'C'           BNCT                                         CAP211
431800230913e1   C                   ENDIF                                                                CAP211
431900230913      *                                                                                       CAP211
432000230913     C                   Z-ADD     0             DNBC                                         CAP211
432100230913     C                   MOVE      *Blanks       TRCT                                         CAP211
432200230913     C                   Z-ADD     0             TRCM                                         CAP211
432300230913     C                   Z-ADD     0             TRCMD                                        CAP211
432400230913     C                   Z-ADD     0             TXCH                                         CAP211
432500230913     C                   Z-ADD     0             TXCHD                                        CAP211
432600230913     C                   Z-ADD     0             CQCH                                         CAP211
432700230913     C                   Z-ADD     0             CQCHD                                        CAP211
432800230913     C                   Z-ADD     0             CSTA                                         CAP211
432900230913     C                   Z-ADD     0             CSTAD                                        CAP211
433000230913     C                   Z-ADD     0             SPCH                                         CAP211
433100230913     C                   Z-ADD     0             SPCHD                                        CAP211
433200230913     C                   Z-ADD     0             MSCH                                         CAP211
433300230913     C                   Z-ADD     0             MSCHD                                        CAP211
433400230913     C                   MOVE      *Blank        CDRT                                         CAP211
433500230913     C                   MOVE      *blanks       CDRO                                         CAP211
433600230913     C                   MOVE      *Blank        CDBR                                         CAP211
433700230913     C                   TIME                    LCHT                                         CAP211
433800230913     C                   Z-ADD     BJRDNB        LCD                                          CAP211
433900230913     C                   MOVE      'I'           CHTP                                         CAP211
434000230913     C                   MOVE      *Blanks       AUP1                                         CAP211
434100230913     C                   MOVE      *Blanks       AUP2                                         CAP211
434200230913     C                   MOVE      *Blanks       AUIN                                         CAP211
434300230913     C                   MOVE      *Blanks       IACG                                         CAP211
434400230913     C                   MOVE      *Blanks       SACG                                         CAP211
434500230913     C                   MOVE      *Blanks       PACG                                         CAP211
434600230913     C                   MOVE      *Blanks       SMSG                                         CAP211
434700230913     C                   MOVE      *Blanks       PMSG                                         CAP211
434800230913     C                   Z-ADD     bjrdnb        OEDT                                         CAP211
434900230913     C                   MOVE      BJRDNB        ZDAYNO                                       CAP211
435000230913     C                   CALLB     'ZDATE2'                                                   CAP211
435100230913     C                   PARM                    ZDAYNO                                       CAP211
435200230913     C                   PARM                    BJDFIN                                       CAP211
435300230913     C                   PARM      *ZEROS        ZDATE                                        CAP211
435400230913     C                   PARM      *Blanks       ZADATE            7                          CAP211
435500230913     C                   MOVE      ZADATE        OEDTD1                                       CAP211
435600230913     C                   Z-ADD     0             NPDT                                         CAP211
435700230913     C                   Z-ADD     0             NPDTD1                                       CAP211
435800230913     C                   Z-ADD     0             NPDTD2                                       CAP211
435900230913     C                   Z-ADD     0             NPDTD3                                       CAP211
436000230913     C                   Z-ADD     0             PRBD                                         CAP211
436100230913     C                   Z-ADD     0             DUMA1                                        CAP211
436200230913     C                   Z-ADD     0             DUMA2                                        CAP211
436300230913     C                   Z-ADD     0             DUMA3                                        CAP211
436400230913     C                   Z-ADD     0             DUMA4                                        CAP211
436500230913     C                   Z-ADD     0             DUMA5                                        CAP211
436600230913     C                   Z-ADD     0             DUMA6                                        CAP211
436700230913     C                   MOVE      *Blanks       FAIN                                         CAP211
436800230913     C                   MOVE      *Blanks       ADIN                                         CAP211
436900230913     C                   MOVE      *Blanks       CQIN                                         CAP211
437000230913     C                   MOVE      *Blanks       PRIN                                         CAP211
437100230913     C                   MOVE      *Blanks       MT100                                        CAP211
437200230913     C                   MOVE      *Blanks       MT202                                        CAP211
437300230913     C                   MOVE      *Blanks       TXIN                                         CAP211
437400230913     C                   MOVE      *Blanks       BAIN                                         CAP211
437500230913     C                   MOVE      *Blanks       ISIN                                         CAP211
437600230913     C                   MOVE      *Blanks       MPYI                                         CAP211
437700230913     C                   MOVE      *Blanks       INBT                                         CAP211
437800230913     C                   MOVE      *Blanks       INB1                                         CAP211
437900230913     C                   MOVE      *Blanks       INB2                                         CAP211
438000230913     C                   MOVE      *Blanks       INB3                                         CAP211
438100230913     C                   MOVE      *Blanks       INB4                                         CAP211
438200230913     C                   MOVE      *Blanks       INB5                                         CAP211
438300230913     C                   MOVE      *Blanks       CHAP                                         CAP211
438400230913     C                   MOVE      'N'           LVL1                                         CAP211
438500230913     C                   MOVE      'N'           LVL2                                         CAP211
438600230913     C                   MOVE      IBRCA         BRCA                                         CAP211
438700230913      *                                                                                       CAP211
438800230913s1   C     CFT014        IFEQ      'Y'                                                        CAP211
438900230913     C                   MOVE      NDCY          WNDCY             3                          CAP211
439000230913     C                   Z-ADD     NDAM          WNDAM            13 0                        CAP211
439100230913e1   C                   ENDIF                                                                CAP211
439200230913s1   C     CEU006        IFEQ      'Y'                                                        CAP211
439300230913     C                   MOVE      *Blanks       NDCY                                         CAP211
439400230913     C                   Z-ADD     0             NDAM                                         CAP211
439500230913e1   C                   ENDIF                                                                CAP211
439600230913s1   C     CEU006        IFEQ      'Y'                                                        CAP211
439700230913     C     CFT014        OREQ      'Y'                                                        CAP211
439800230913     C                   MOVE      *Blanks       PDCY                                         CAP211
439900230913     C                   Z-ADD     0             PDAM                                         CAP211
440000230913e1   C                   Endif                                                                CAP211
440100230913s1   C     CFT014        Ifeq      'Y'                                                        CAP211
440200230913     C                   MOVE      RECI          OPRECI                                       CAP211
440300230913     C                   MOVE      PREF          OPPREF                                       CAP211
440400230913     C                   MOVE      *Blanks       OPBJPR                                       CAP211
440500230913     C                   MOVE      'N'           OPAUTO                                       CAP211
440600230913     C                   MOVE      *Blank        OPSTPI                                       CAP211
440700230913     C                   MOVE      *Blank        OPBANO                                       CAP211
440800230913     C                   MOVE      *Blank        OPRUSR                                       CAP211
440900230913     C                   MOVE      *Blank        OPWSID                                       CAP211
441000230913     C                   MOVE      *Blank        OPRDAT                                       CAP211
441100230913     C                   MOVE      STMT          OPSETM                                       CAP211
441200230913     C                   Z-ADD     0             OPOEXR                                       CAP211
441300230913     C                   MOVE      *Blanks       OPTRIT                                       CAP211
441400230913     C                   MOVE      *Blanks       OPTRI1                                       CAP211
441500230913     C                   MOVE      *Blanks       OPTRI2                                       CAP211
441600230913     C                   MOVE      *Blanks       OPTRI3                                       CAP211
441700230913     C                   MOVE      *Blanks       OPTRI4                                       CAP211
441800230913     C                   MOVE      *Blanks       OPTRI5                                       CAP211
441900230913     C                   Z-ADD     0             OPRCNW                                       CAP211
442000230913     C                   MOVE      *Blanks       OPRCCN                                       CAP211
442100230913     C                   MOVE      *Blanks       OPRCUS                                       CAP211
442200230913     C                   Z-ADD     0             OPSCLE                                       CAP211
442300230913      *                                                                                       CAP211
442400230913s2   C     INMTPY        IFEQ      '103'                                                      CAP211
442500230913     C                   MOVE      WNDCY         PDCY                                         CAP211
442600230913     C                   Z-ADD     WNDAM         PDAM                                         CAP211
442700230913     C                   Z-ADD     INOEXR        OPOEXR                                       CAP211
442800230913e2   C                   ENDIF                                                                CAP211
442900230913     C                   MOVE      INBOCD        OPBOCD                                       CAP211
443000230913     C                   MOVE      INTTCD        OPTTCD                                       CAP211
443100230913     C                   MOVE      INICD1        OPICD1                                       CAP211
443200230913     C                   MOVE      INICD2        OPICD2                                       CAP211
443300230913     C                   MOVE      INICD3        OPICD3                                       CAP211
443400230913     C                   MOVE      INICD4        OPICD4                                       CAP211
443500230913     C                   MOVE      INICD5        OPICD5                                       CAP211
443600230913     C                   MOVE      INRRP1        OPRRP1                                       CAP211
443700230913     C                   MOVE      INRRP2        OPRRP2                                       CAP211
443800230913     C                   MOVE      INRRP3        OPRRP3                                       CAP211
443900230913s2   C     WCCCY         IFNE      WSMCYX                                                     CAP211
444000230913     C                   CLEAR                   P#0010                                       CAP211
444100230913     C                   MOVEL     WCCCY         P#FRCY                                       CAP211
444200230913     C                   Z-ADD     WCHGS         P#FRAM                                       CAP211
444300230913     C                   MOVEL     WSMCYX        P#TOCY                                       CAP211
444400230913     C                   Z-ADD     0             P#TOAM                                       CAP211
444500230913     C                   CALL      'FT0010'                                                   CAP211
444600230913     C                   PARM                    P#0010                                       CAP211
444700230913s3   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
444800230913     C                   Z-ADD     906           DBASE                                        CAP211
444900230913     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
445000230913     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
445100230913     C                   EXSR      *PSSR                                                      CAP211
445200230913x3   C                   ELSE                                                                 CAP211
445300230913     C     INRCRM        SUB       P#TOAM        WRCRM            11 0                        CAP211
445400230913e3   C                   ENDIF                                                                CAP211
445500230913x2   C                   ELSE                                                                 CAP211
445600230913     C     INRCRM        SUB       WCHGS         WRCRM                                        CAP211
445700230913e2   C                   ENDIF                                                                CAP211
445800230913s2   C     WRCRM         IFLT      0                                                          CAP211
445900230913     C                   Z-ADD     0             WRCRM                                        CAP211
446000230913e2   C                   ENDIF                                                                CAP211
446100230913     C                   Z-ADD     0             OPRCRM                                       CAP211
446200230913     C                   Z-ADD     0             OPRBCQ                                       CAP211
446300230913     C                   Z-ADD     0             OPRCSC                                       CAP211
446400230913     C                   Z-ADD     0             OPRCSQ                                       CAP211
446500230913s2   C     WRCRM         IFGT      0                                                          CAP211
446600230913s3   C     WSMCYX        IFNE      PCCY                                                       CAP211
446700230913     C                   CLEAR                   P#0010                                       CAP211
446800230913     C                   MOVEL     WSMCYX        P#FRCY                                       CAP211
446900230913     C                   Z-ADD     WRCRM         P#FRAM                                       CAP211
447000230913     C                   MOVEL     PCCY          P#TOCY                                       CAP211
447100230913     C                   Z-ADD     0             P#TOAM                                       CAP211
447200230913     C                   CALL      'FT0010'                                                   CAP211
447300230913     C                   PARM                    P#0010                                       CAP211
447400230913s4   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
447500230913     C                   Z-ADD     907           DBASE                                        CAP211
447600230913     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
447700230913     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
447800230913     C                   EXSR      *PSSR                                                      CAP211
447900230913x4   C                   ELSE                                                                 CAP211
448000230913     C                   Z-ADD     P#TOAM        OPRCRM                                       CAP211
448100230913e4   C                   ENDIF                                                                CAP211
448200230913x3   C                   ELSE                                                                 CAP211
448300230913     C                   Z-ADD     WRCRM         OPRCRM                                       CAP211
448400230913e3   C                   ENDIF                                                                CAP211
448500230913     C                   CLEAR                   P#0010                                       CAP211
448600230913     C                   MOVEL     PCCY          P#FRCY                                       CAP211
448700230913     C                   Z-ADD     OPRCRM        P#FRAM                                       CAP211
448800230913     C                   MOVEL     BJCYCD        P#TOCY                                       CAP211
448900230913     C                   Z-ADD     0             P#TOAM                                       CAP211
449000230913     C                   CALL      'FT0010'                                                   CAP211
449100230913     C                   PARM                    P#0010                                       CAP211
449200230913s3   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
449300230913     C                   Z-ADD     908           DBASE                                        CAP211
449400230913     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
449500230913     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
449600230913     C                   EXSR      *PSSR                                                      CAP211
449700230913x3   C                   ElSE                                                                 CAP211
449800230913     C                   Z-ADD     P#TOAM        OPRBCQ                                       CAP211
449900230913e3   C                   ENDIF                                                                CAP211
450000230913     C                   Z-ADD     OPRCRM        OPRCSC                                       CAP211
450100230913     C                   Z-ADD     OPRBCQ        OPRCSQ                                       CAP211
450200230913e2   C                   ENDIF                                                                CAP211
450300230913      *                                                                                       CAP211
450400230913     C                   MOVE      INSCY1        OPSCC1                                       CAP211
450500230913     C                   MOVE      INSCH1        OPSCH1                                       CAP211
450600230913     C                   MOVE      INSCY2        OPSCC2                                       CAP211
450700230913     C                   MOVE      INSCH2        OPSCH2                                       CAP211
450800230913     C                   MOVE      INSCY3        OPSCC3                                       CAP211
450900230913     C                   MOVE      INSCH3        OPSCH3                                       CAP211
451000230913     C                   MOVE      INSCY4        OPSCC4                                       CAP211
451100230913     C                   MOVE      INSCH4        OPSCH4                                       CAP211
451200230913     C                   MOVE      INSCY5        OPSCC5                                       CAP211
451300230913     C                   MOVE      INSCH5        OPSCH5                                       CAP211
451400230913     C                   Z-ADD     0             WSCHG            11 0                        CAP211
451500230913s2   C     DTCH          IFEQ      'BEN'                                                      CAP211
451600230913     C     TXCH          ADD       CQCH          WCHGS                                        CAP211
451700230913     C                   ADD       MSCH          WCHGS                                        CAP211
451800230913     C                   ADD       TRCM          WCHGS                                        CAP211
451900230913s3   C     S01494        IFEQ      'Y'                                                        CAP211
452000230913     C                   ADD       OPCHCM        WCHGS                                        CAP211
452100230913e3   C                   ENDIF                                                                CAP211
452200230913s3   C     S01499        IFEQ      'Y'                                                        CAP211
452300230913     C                   ADD       OPVATT        WCHGS                                        CAP211
452400230913e3   C                   ENDIF                                                                CAP211
452500230913s3   C     WCHGS         IFNE      0                                                          CAP211
452600230913s4   C                   SELECT                                                               CAP211
452700230913     C     CDRT          WHENNE    *Blanks                                                    CAP211
452800230913     C                   MOVEL     BJCYCD        WCCCY                                        CAP211
452900230913     C     ADDC          WHENEQ    'A'                                                        CAP211
453000230913     C                   MOVEL     SMCY          WCCCY                                        CAP211
453100230913     C                   OTHER                                                                CAP211
453200230913     C                   MOVEL     PCCY          WCCCY                                        CAP211
453300230913e4   C                   ENDSL                                                                CAP211
453400230913s4   C     WCCCY         IFNE      PCCY                                                       CAP211
453500230913     C                   CLEAR                   P#0010                                       CAP211
453600230913     C                   MOVEL     WCCCY         P#FRCY                                       CAP211
453700230913     C                   Z-ADD     WCHGS         P#FRAM                                       CAP211
453800230913     C                   MOVEL     PCCY          P#TOCY                                       CAP211
453900230913     C                   Z-ADD     0             P#TOAM                                       CAP211
454000230913     C                   CALL      'FT0010'                                                   CAP211
454100230913     C                   PARM                    P#0010                                       CAP211
454200230913s5   C     P#RTCD        IFNE      *BLANKS                                                    CAP211
454300230913     C                   Z-ADD     908           DBASE                                        CAP211
454400230913     C                   MOVEL     'FT0010'      DBFILE                                       CAP211
454500230913     C                   MOVEL     '*CALL '      DBKEY                                        CAP211
454600230913     C                   EXSR      *PSSR                                                      CAP211
454700230913x5   C                   ELSE                                                                 CAP211
454800230913     C                   Z-ADD     P#TOAM        WCHGS                                        CAP211
454900230913e5   C                   ENDIF                                                                CAP211
455000230913     C                   ELSE                                                                 CAP211
455100230913     C                   Z-ADD     WCHGS         WSCHG                                        CAP211
455200230913e4   C                   ENDIF                                                                CAP211
455300230913e3   C                   ENDIF                                                                CAP211
455400230913s3   C                   SELECT                                                               CAP211
455500230913     C     OPSCC1        WHENEQ    *Blanks                                                    CAP211
455600230913     C                   MOVEL     PCCY          OPSCC1                                       CAP211
455700230913     C                   Z-ADD     WSCHG         OPSCH1                                       CAP211
455800230913     C                   Z-ADD     1             OPSCLE                                       CAP211
455900230913     C     OPSCC2        WHENEQ    *Blanks                                                    CAP211
456000230913     C                   MOVEL     PCCY          OPSCC2                                       CAP211
456100230913     C                   Z-ADD     WSCHG         OPSCH2                                       CAP211
456200230913     C                   Z-ADD     2             OPSCLE                                       CAP211
456300230913     C     OPSCC3        WHENEQ    *Blanks                                                    CAP211
456400230913     C                   MOVEL     PCCY          OPSCC3                                       CAP211
456500230913     C                   Z-ADD     WSCHG         OPSCH3                                       CAP211
456600230913     C                   Z-ADD     3             OPSCLE                                       CAP211
456700230913     C     OPSCC4        WHENEQ    *Blanks                                                    CAP211
456800230913     C                   MOVEL     PCCY          OPSCC4                                       CAP211
456900230913     C                   Z-ADD     WSCHG         OPSCH4                                       CAP211
457000230913     C                   Z-ADD     4             OPSCLE                                       CAP211
457100230913     C                   OTHER                                                                CAP211
457200230913     C                   MOVEL     PCCY          OPSCC5                                       CAP211
457300230913     C                   Z-ADD     WSCHG         OPSCH5                                       CAP211
457400230913     C                   Z-ADD     5             OPSCLE                                       CAP211
457500230913e3   C                   ENDSL                                                                CAP211
457600230913e2   C                   ENDIF                                                                CAP211
457700230913      *                                                                                    BUG12944A
457800230913     C                   SELECT                                                            BUG12944A
457900230913     C     BTCHCY        WHENEQ    'C'                                                     BUG12944A
458000230913     C     ADDC          IFEQ      'A'                                                     BUG12944A
458100230913     C                   MOVEL     SMCY          OPCHGC                                    BUG12944A
458200230913     C                   ELSE                                                              BUG12944A
458300230913     C                   MOVEL     PCCY          OPCHGC                                    BUG12944A
458400230913     C                   ENDIF                                                             BUG12944A
458500230913     C     BTCHCY        WHENEQ    'L'                                                     BUG12944A
458600230913     C                   MOVEL     BJLCCY        OPCHGC                                    BUG12944A
458700230913     C                   OTHER                                                             BUG12944A
458800230913     C                   MOVEL     BJCYCD        OPCHGC                                    BUG12944A
458900230913     C                   ENDSL                                                             BUG12944A
459000230913      *                                                                                       CAP211
459100230913     C     PREF          CHAIN     OTXL0                              80                      CAP211
459200230913s2   C     *IN80         IFEQ      *Off                                                       CAP211
459300230913     C                   Z-ADD     909           DBASE                                        CAP211
459400230913     C                   MOVEL     'OTPAYXL0'    DBFILE                                       CAP211
459500230913     C                   MOVEL     'PREF  '      DBKEY                                        CAP211
459600230913     C                   EXSR      *PSSR                                                      CAP211
459700230913x2   C                   ELSE                                                                 CAP211
459800230913     C                   MOVEL     TMST          OPTMST                                       CAP211
459900230913     C                   WRITE     OTPAYXDF                             80                    CAP211
460000230913e2   C                   ENDIF                                                                CAP211
460100230913e1   C                   ENDIF                                                                CAP211
460200230913s1   C     CFT009        IFEQ      'Y'                                                        CAP211
460300230913     C                   MOVEL     FXSPSC        FXSRSC                                       CAP211
460400230913     C                   MOVEL     INPDOF        OTPDOF                                       CAP211
460500230913     C                   MOVEL     TLCODE        TLXCDE                                       CAP211
460600230913     C                   MOVEL     CHCHCD        CHQCHC                                       CAP211
460700230913     C                   MOVEL     *Blanks       CACHCD                                       CAP211
460800230913     C                   MOVEL     *Blanks       SSTCCD                                       CAP211
460900230913     C                   MOVEL     *Blanks       SPRCCD                                       CAP211
461000230913     C                   MOVEL     MISCH         MSCHC                                        CAP211
461100230913     C                   MOVEL     MSCH1         MSCHC1                                       CAP211
461200230913     C                   MOVEL     MSCH2         MSCHC2                                       CAP211
461300230913     C                   MOVEL     MSCH3         MSCHC3                                       CAP211
461400230913     C                   MOVEL     MSCH4         MSCHC4                                       CAP211
461500230913     C                   MOVEL     MSCH5         MSCHC5                                       CAP211
461600230913     C                   MOVEL     TFCCCO        TFCCCD                                       CAP211
461700230913     C                   MOVEL     FXCHEC        FXCACC                                       CAP211
461800230913     C                   MOVEL     *Blanks       VTSWSC                                       CAP211
461900230913     C                   MOVEL     VTMIC1        VMIC1                                        CAP211
462000230913     C                   MOVEL     VTMIC2        VMIC2                                        CAP211
462100230913     C                   MOVEL     VTMIC3        VMIC3                                        CAP211
462200230913     C                   MOVEL     VTMIC4        VMIC4                                        CAP211
462300230913     C                   MOVEL     VTMIC5        VMIC5                                        CAP211
462400230913     C                   Z-ADD     MSC01         MISC01                                       CAP211
462500230913     C                   Z-ADD     MSC02         MISC02                                       CAP211
462600230913     C                   Z-ADD     MSC03         MISC03                                       CAP211
462700230913     C                   Z-ADD     MSC04         MISC04                                       CAP211
462800230913     C                   Z-ADD     MSC05         MISC05                                       CAP211
462900230913     C                   Z-ADD     0             SWSCHG                                       CAP211
463000230913     C                   Z-ADD     0             DATNED                                       CAP211
463100230913     C                   Z-ADD     0             DATNAO                                       CAP211
463200230913     C                   MOVEL     *Blanks       CUNFLA                                       CAP211
463300230913     C                   MOVEL     *Blanks       OPCHRT                                       CAP211
463400230913     C                   MOVEL     *Blanks       OPCHGC                                       CAP211
463500230913e1   C                   ENDIF                                                                CAP211
463600230913     C                   WRITE     OTPAYDDF                             80                    CAP211
463700230913      *                                                                                       CAP211
463800230913      ** Move valid file details to extension file details                                    CAP211
463900230913      *                                                                                       CAP211
464000230913     C                   EVAL      OTPREF = PREF                                              CAP211
464100230913     C                   EVAL      OTBRCA = BRCA                                              CAP211
464200230913     C                   EVAL      OTFRID = FRNT                                              CAP211
464300230913     C                   WRITE     OTPAYQD0                             99                    CAP211
464400230913      *                                                                                       CAP211
464500230913      ** Update trailer                                                                       CAP211
464600230913      *                                                                                       CAP211
464700230913     C     *IN80         IFEQ      *Off                                                       CAP211
464800230913     C     1             CHAIN     OTPAYZZF                           80                      CAP211
464900230913     C     *IN80         IFEQ      *Off                                                       CAP211
465000230913     C                   Z-ADD     OHRWN         ZZTOTI                                       CAP211
465100230913     C                   Z-ADD     OHRDC         ZZTOTD                                       CAP211
465200230913     C************       ADD       1             NORE1                               CAP211 MD054037
465300230913     C                   ADD       1             ONORE1                                     MD054037
465400230913     C     SMAM          DIV       1000          ZZAMT                                        CAP211
465500230913     C                   EXSR      SrGLZADD                                                   CAP211
465600230913     C                   Z-ADD     ZZTOTI        OHRWN                                        CAP211
465700230913     C                   Z-ADD     ZZTOTD        OHRDC                                        CAP211
465800230913     C                   UPDATE    OTPAYZZF                                                   CAP211
465900230913     C                   ENDIF                                                                CAP211
466000230913     C                   ENDIF                                                                CAP211
466100230913      *                                                                                       CAP211
466200230913     C                   ENDSR                                                                CAP211
466300230913      *                                                                                       CAP211
466400230913      *****************************************************************
466500230913      /EJECT
466600230913      *****************************************************************
466700230913      *
466800230913      ** The following /COPY contains the standard program status
466900230913      ** subroutine, including a bound call to the DBERRCTL module.
467000230913      *
467100230913      /COPY ZACPYSRC,PSSR_ILE
467200230913      *
467300230913      *****************************************************************
467400230913      /EJECT
467500230913      *****************************************************************
467600230913      *
467700230913      * SRWTCH - Set-up parameter and send transaction details to     *                       CSD015
467800230913      *          Compliance Watch by calling the Engine program       *                       CSD015
467900230913      *                                                               *                       CSD015
468000230913      * Called by: SR/INSERT, SR/AMEND                                *                       CSD015
468100230913      *                                                               *                       CSD015
468200230913      * Calls: None                                                   *                       CSD015
468300230913      *                                                               *                       CSD015
468400230913      *****************************************************************                       CSD015
468500230913     C     SRWTCH        BEGSR                                                                CSD015
468600230913                                                                                              CSD015
468700230913     C                   CLEAR                   SDWLTD                                       CSD015
468800230913     C                   CLEAR                   PString                                      CSD015
468900230913     C                   EVAL      U = *Zeros                                                 CSD015
469000230913     C                   EVAL      Fld1 = *Blanks                                             CSD015
469100230913     C                   EVAL      Fld2 = *Blanks                                             CSD015
469200230913     C                   EVAL      Fld3 = *Blanks                                             CSD015
469300230913     C                   EVAL      Fld4 = *Blanks                                             CSD015
469400230913     C                   EVAL      Fld5 = *Blanks                                             CSD015
469500230913     C                   EVAL      Fld6 = *Blanks                                             CSD015
469600230913     C                   EVAL      PInCcy  = SMCY                                             CSD015
469700230913                                                                                              CSD015
469800230913      ** Sender                                                                               CSD015
469900230913     C                   IF        IPSND1 <> *Blanks  OR IPSND2 <> *Blanks  OR                CSD015
470000230913     C                             IPSND3 <> *Blanks  OR IPSND4 <> *Blanks                    CSD015
470100230913                                                                                              CSD015
470200230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
470300230913     C                             IPCHTP = 'A'  AND IPSND1 <> CHSND1  OR                     CSD015
470400230913     C                             IPCHTP = 'A'  AND IPSND2 <> CHSND2  OR                     CSD015
470500230913     C                             IPCHTP = 'A'  AND IPSND3 <> CHSND3  OR                     CSD015
470600230913     C                             IPCHTP = 'A'  AND IPSND4 <> CHSND4                         CSD015
470700230913     C                   EVAL      Fld1 = IPSND1                                              CSD015
470800230913     C                   EVAL      Fld2 = IPSND2                                              CSD015
470900230913     C                   EVAL      Fld3 = IPSND3                                              CSD015
471000230913     C                   EVAL      Fld4 = IPSND4                                              CSD015
471100230913     C                   EVAL      U = 1                                                      CSD015
471200230913     C                   EXSR      SRConvert                                                  CSD015
471300230913     C                   ENDIF                                                                CSD015
471400230913                                                                                              CSD015
471500230913     C                   ENDIF                                                                CSD015
471600230913                                                                                              CSD015
471700230913      ** Receivers Correspondent - FT Version                                                 CSD015
471800230913     C***********        IF        IPRCCO <> *ZERO                                     CSD015 CSD027
471900230913     C                   IF        IPRCCO <> *BLANKS                                          CSD027
472000230913                                                                                              CSD015
472100230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
472200230913     C                             IPCHTP = 'A'  AND  IPRCCO <> CHRCCO                        CSD015
472300230913     C                   MOVEL     IPRCCO        WRCCO             6                          CSD015
472400230913     C                   MOVEL     WRCCO         Fld1                                         CSD015
472500230913     C                   EVAL      U = 3                                                      CSD015
472600230913     C                   EXSR      SRConvert                                                  CSD015
472700230913     C                   ENDIF                                                                CSD015
472800230913                                                                                              CSD015
472900230913     C                   ENDIF                                                                CSD015
473000230913                                                                                              CSD015
473100230913      ** Account with Bank - FT Version                                                       CSD015
473200230913     C                   IF        IPACBK <> *Blanks                                          CSD015
473300230913                                                                                              CSD015
473400230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
473500230913     C                             IPCHTP = 'A'  AND  IPACBK <> CHACBK                        CSD015
473600230913     C                   EVAL      Fld1 = IPACBK                                              CSD015
473700230913     C                   EVAL      U = 5                                                      CSD015
473800230913     C                   EXSR      SRConvert                                                  CSD015
473900230913     C                   ENDIF                                                                CSD015
474000230913                                                                                              CSD015
474100230913     C                   ENDIF                                                                CSD015
474200230913                                                                                              CSD015
474300230913      ** Beneficiary                                                                          CSD015
474400230913     C                   IF        IPBNC1 <> *Blanks  OR  IPBNC2 <> *Blanks  OR               CSD015
474500230913     C                             IPBNC3 <> *Blanks  OR  IPBNC4 <> *BLanks  OR               CSD015
474600230913     C                             IPBNC5 <> *Blanks                                          CSD015
474700230913                                                                                              CSD015
474800230913     C                   IF        IPCHTP = 'I'  OR   WUNCFL = 'Y' OR                         CSD015
474900230913     C                             IPCHTP = 'A'  AND  IPBNC1 <> CHBNC1  OR                    CSD015
475000230913     C                             IPCHTP = 'A'  AND  IPBNC2 <> CHBNC2  OR                    CSD015
475100230913     C                             IPCHTP = 'A'  AND  IPBNC3 <> CHBNC3  OR                    CSD015
475200230913     C                             IPCHTP = 'A'  AND  IPBNC4 <> CHBNC4  OR                    CSD015
475300230913     C                             IPCHTP = 'A'  AND  IPBNC5 <> CHBNC5                        CSD015
475400230913     C                   EVAL      Fld1 = IPBNC1                                              CSD015
475500230913     C                   EVAL      Fld2 = IPBNC2                                              CSD015
475600230913     C                   EVAL      Fld3 = IPBNC3                                              CSD015
475700230913     C                   EVAL      Fld4 = IPBNC4                                              CSD015
475800230913     C                   EVAL      Fld5 = IPBNC5                                              CSD015
475900230913     C                   EVAL      U = 7                                                      CSD015
476000230913     C                   EXSR      SRConvert                                                  CSD015
476100230913     C                   ENDIF                                                                CSD015
476200230913                                                                                              CSD015
476300230913     C                   ENDIF                                                                CSD015
476400230913                                                                                              CSD015
476500230913      ** Ordering Bank                                                                        CSD015
476600230913     C                   IF        IPORB1 <> *Blanks  OR  IPORB2 <> *Blanks  OR               CSD015
476700230913     C                             IPORB3 <> *Blanks  OR  IPORB4 <> *Blanks  OR               CSD015
476800230913     C                             IPORB5 <> *Blanks                                          CSD015
476900230913                                                                                              CSD015
477000230913     C                   IF        IPCHTP = 'I'  OR  WUNCFL = 'Y' OR                          CSD015
477100230913     C                             IPCHTP = 'A'  AND  IPORB1 <> CHORB1  OR                    CSD015
477200230913     C                             IPCHTP = 'A'  AND  IPORB2 <> CHORB2  OR                    CSD015
477300230913     C                             IPCHTP = 'A'  AND  IPORB3 <> CHORB3  OR                    CSD015
477400230913     C                             IPCHTP = 'A'  AND  IPORB4 <> CHORB4  OR                    CSD015
477500230913     C                             IPCHTP = 'A'  AND  IPORB5 <> CHORB5                        CSD015
477600230913     C                   EVAL      Fld1 = IPORB1                                              CSD015
477700230913     C                   EVAL      Fld2 = IPORB2                                              CSD015
477800230913     C                   EVAL      Fld3 = IPORB3                                              CSD015
477900230913     C                   EVAL      Fld4 = IPORB4                                              CSD015
478000230913     C                   EVAL      Fld5 = IPORB5                                              CSD015
478100230913     C                   EVAL      U = 9                                                      CSD015
478200230913     C                   EXSR      SRConvert                                                  CSD015
478300230913     C                   EVAL      WCustomer = OutFmt                                         CSD015
478400230913     C                   ENDIF                                                                CSD015
478500230913                                                                                              CSD015
478600230913     C                   ENDIF                                                                CSD015
478700230913                                                                                              CSD015
478800230913      ** Senders Correspondent                                                                CSD015
478900230913     C                   IF        IPSNC1 <> *Blanks  OR  IPSNC2 <> *Blanks  OR               CSD015
479000230913     C                             IPSNC3 <> *Blanks  OR  IPSNC4 <> *BLanks  OR               CSD015
479100230913     C                             IPSNC5 <> *Blanks                                          CSD015
479200230913                                                                                              CSD015
479300230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
479400230913     C                             IPCHTP = 'A'  AND  IPSNC1 <> CHSNC1  OR                    CSD015
479500230913     C                             IPCHTP = 'A'  AND  IPSNC2 <> CHSNC2  OR                    CSD015
479600230913     C                             IPCHTP = 'A'  AND  IPSNC3 <> CHSNC3  OR                    CSD015
479700230913     C                             IPCHTP = 'A'  AND  IPSNC4 <> CHSNC4  OR                    CSD015
479800230913     C                             IPCHTP = 'A'  AND  IPSNC5 <> CHSNC5                        CSD015
479900230913     C                   EVAL      Fld1 = IPSNC1                                              CSD015
480000230913     C                   EVAL      Fld2 = IPSNC2                                              CSD015
480100230913     C                   EVAL      Fld3 = IPSNC3                                              CSD015
480200230913     C                   EVAL      Fld4 = IPSNC4                                              CSD015
480300230913     C                   EVAL      Fld5 = IPSNC5                                              CSD015
480400230913     C                   EVAL      U = 11                                                     CSD015
480500230913     C                   EXSR      SRConvert                                                  CSD015
480600230913     C                   ENDIF                                                                CSD015
480700230913                                                                                              CSD015
480800230913     C                   ENDIF                                                                CSD015
480900230913                                                                                              CSD015
481000230913      ** Ordering Customer                                                                    CSD015
481100230913     C                   IF        IPORC1 <> *Blanks  OR  IPORC2 <> *Blanks  OR               CSD015
481200230913     C**********                   IPORC3 <> *Blanks  OR  IPORC4 <> *Blanks            CSD015 CFT032
481300230913     C                             IPORC3 <> *Blanks  OR  IPORC4 <> *Blanks  OR               CFT032
481400230913     C                             IPORC5 <> *Blanks                                          CFT032
481500230913                                                                                              CSD015
481600230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
481700230913     C                             IPCHTP = 'A'  AND  IPORC1 <> CHORC1  OR                    CSD015
481800230913     C                             IPCHTP = 'A'  AND  IPORC2 <> CHORC2  OR                    CSD015
481900230913     C                             IPCHTP = 'A'  AND  IPORC3 <> CHORC3  OR                    CSD015
482000230913     C**********                   IPCHTP = 'A'  AND  IPORC4 <> CHORC4                 CSD015 CFT032
482100230913     C                             IPCHTP = 'A'  AND  IPORC4 <> CHORC4  OR                    CFT032
482200230913     C                             IPCHTP = 'A'  AND  IPORC5 <> CHORC5                        CFT032
482300230913     C                                                                                        CFT032
482400230913     C                   EVAL      Fld1 = IPORC1                                              CSD015
482500230913     C                   EVAL      Fld2 = IPORC2                                              CSD015
482600230913     C                   EVAL      Fld3 = IPORC3                                              CSD015
482700230913     C                   EVAL      Fld4 = IPORC4                                              CSD015
482800230913     C                   EVAL      Fld5 = IPORC5                                              CFT032
482900230913     C                   EVAL      U = 13                                                     CSD015
483000230913     C                   EXSR      SRConvert                                                  CSD015
483100230913     C                   EVAL      WCustomer = OutFmt                                         CSD015
483200230913     C                   ENDIF                                                                CSD015
483300230913                                                                                              CSD015
483400230913     C                   ENDIF                                                                CSD015
483500230913                                                                                              CSD015
483600230913      ** Details of Payment                                                                   CSD015
483700230913     C                   IF        IPDTP1 <> *Blanks  OR  IPDTP2 <> *Blanks  OR               CSD015
483800230913     C                             IPDTP3 <> *Blanks  OR  IPDTP4 <> *BLanks                   CSD015
483900230913                                                                                              CSD015
484000230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
484100230913     C                             IPCHTP = 'A'  AND  IPDTP1 <> CHDTP1  OR                    CSD015
484200230913     C                             IPCHTP = 'A'  AND  IPDTP2 <> CHDTP2  OR                    CSD015
484300230913     C                             IPCHTP = 'A'  AND  IPDTP3 <> CHDTP3  OR                    CSD015
484400230913     C                             IPCHTP = 'A'  AND  IPDTP4 <> CHDTP4                        CSD015
484500230913     C                   EVAL      Fld1 = IPDTP1                                              CSD015
484600230913     C                   EVAL      Fld2 = IPDTP2                                              CSD015
484700230913     C                   EVAL      Fld3 = IPDTP3                                              CSD015
484800230913     C                   EVAL      Fld4 = IPDTP4                                              CSD015
484900230913     C                   EVAL      U = 15                                                     CSD015
485000230913     C                   EXSR      SRConvert                                                  CSD015
485100230913     C                   ENDIF                                                                CSD015
485200230913                                                                                              CSD015
485300230913     C                   ENDIF                                                                CSD015
485400230913                                                                                              CSD015
485500230913      ** Intermediary Bank                                                                    CSD015
485600230913     C                   IF        IPINB1 <> *Blanks  OR  IPINB2 <> *Blanks  OR               CSD015
485700230913     C                             IPINB3 <> *Blanks  OR  IPINB4 <> *BLanks  OR               CSD015
485800230913     C                             IPINB5 <> *Blanks                                          CSD015
485900230913                                                                                              CSD015
486000230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
486100230913     C                             IPCHTP = 'A'  AND  IPINB1 <> CHINB1  OR                    CSD015
486200230913     C                             IPCHTP = 'A'  AND  IPINB2 <> CHINB2  OR                    CSD015
486300230913     C                             IPCHTP = 'A'  AND  IPINB3 <> CHINB3  OR                    CSD015
486400230913     C                             IPCHTP = 'A'  AND  IPINB4 <> CHINB4  OR                    CSD015
486500230913     C                             IPCHTP = 'A'  AND  IPINB5 <> CHINB5                        CSD015
486600230913     C                   EVAL      Fld1 = IPINB1                                              CSD015
486700230913     C                   EVAL      Fld2 = IPINB2                                              CSD015
486800230913     C                   EVAL      Fld3 = IPINB3                                              CSD015
486900230913     C                   EVAL      Fld4 = IPINB4                                              CSD015
487000230913     C                   EVAL      Fld5 = IPINB5                                              CSD015
487100230913     C                   EVAL      U = 17                                                     CSD015
487200230913     C                   EXSR      SRConvert                                                  CSD015
487300230913     C                   ENDIF                                                                CSD015
487400230913                                                                                              CSD015
487500230913     C                   ENDIF                                                                CSD015
487600230913                                                                                              CSD015
487700230913      ** Receivers Correspondent                                                              CSD015
487800230913     C                   IF        INRCO1 <> *Blanks  OR INRCO2 <> *Blanks  OR                CSD015
487900230913     C                             INRCO3 <> *Blanks  OR INRCO4 <> *BLanks  OR                CSD015
488000230913     C                             INRCO5 <> *Blanks                                          CSD015
488100230913                                                                                              CSD015
488200230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
488300230913     C                             IPCHTP = 'A'  AND  INRCO1 <> CHINRCO1 OR                   CSD015
488400230913     C                             IPCHTP = 'A'  AND  INRCO2 <> CHINRCO2 OR                   CSD015
488500230913     C                             IPCHTP = 'A'  AND  INRCO3 <> CHINRCO3 OR                   CSD015
488600230913     C                             IPCHTP = 'A'  AND  INRCO4 <> CHINRCO4 OR                   CSD015
488700230913     C                             IPCHTP = 'A'  AND  INRCO5 <> CHINRCO5                      CSD015
488800230913     C                   EVAL      Fld1 = INRCO1                                              CSD015
488900230913     C                   EVAL      Fld2 = INRCO2                                              CSD015
489000230913     C                   EVAL      Fld3 = INRCO3                                              CSD015
489100230913     C                   EVAL      Fld4 = INRCO4                                              CSD015
489200230913     C                   EVAL      Fld5 = INRCO5                                              CSD015
489300230913     C                   EVAL      U = 19                                                     CSD015
489400230913     C                   EXSR      SRConvert                                                  CSD015
489500230913     C                   ENDIF                                                                CSD015
489600230913                                                                                              CSD015
489700230913     C                   ENDIF                                                                CSD015
489800230913                                                                                              CSD015
489900230913      ** Account with Bank                                                                    CSD015
490000230913     C                   IF        INACB1 <> *Blanks  OR  INACB2 <> *Blanks  OR               CSD015
490100230913     C                             INACB3 <> *Blanks  OR  INACB4 <> *BLanks  OR               CSD015
490200230913     C                             INACB5 <> *Blanks                                          CSD015
490300230913                                                                                              CSD015
490400230913     C                   IF        IPCHTP = 'I'  OR WUNCFL = 'Y' OR                           CSD015
490500230913     C                             IPCHTP = 'A'  AND  INACB1 <> CHINACB1  OR                  CSD015
490600230913     C                             IPCHTP = 'A'  AND  INACB2 <> CHINACB2  OR                  CSD015
490700230913     C                             IPCHTP = 'A'  AND  INACB3 <> CHINACB3  OR                  CSD015
490800230913     C                             IPCHTP = 'A'  AND  INACB4 <> CHINACB4  OR                  CSD015
490900230913     C                             IPCHTP = 'A'  AND  INACB5 <> CHINACB5                      CSD015
491000230913     C                   EVAL      Fld1 = INACB1                                              CSD015
491100230913     C                   EVAL      Fld2 = INACB2                                              CSD015
491200230913     C                   EVAL      Fld3 = INACB3                                              CSD015
491300230913     C                   EVAL      Fld4 = INACB4                                              CSD015
491400230913     C                   EVAL      Fld5 = INACB5                                              CSD015
491500230913     C                   EVAL      U = 21                                                     CSD015
491600230913     C                   EXSR      SRConvert                                                  CSD015
491700230913     C                   ENDIF                                                                CSD015
491800230913                                                                                              CSD015
491900230913     C                   ENDIF                                                                CSD015
492000230913                                                                                              CSD015
492100230913      ** Third Reimbursement Institution                                                      CSD015
492200230913     C                   IF        INTRIB <> *Blanks  OR  INTRI1 <> *Blanks  OR               CSD015
492300230913     C                             INTRI2 <> *Blanks  OR  INTRI3 <> *BLanks  OR               CSD015
492400230913     C                             INTRI4 <> *Blanks  OR  INTRI5 <> *Blanks                   CSD015
492500230913                                                                                              CSD015
492600230913     C                   IF        IPCHTP = 'I'  or WUNCFL = 'Y' OR                           CSD015
492700230913     C                             IPCHTP = 'A'  AND  INTRIB <> I2INTRIB  OR                  CSD015
492800230913     C                             IPCHTP = 'A'  AND  INTRI1 <> I2INTRI1  OR                  CSD015
492900230913     C                             IPCHTP = 'A'  AND  INTRI2 <> I2INTRI2  OR                  CSD015
493000230913     C                             IPCHTP = 'A'  AND  INTRI3 <> I2INTRI3  OR                  CSD015
493100230913     C                             IPCHTP = 'A'  AND  INTRI4 <> I2INTRI4  OR                  CSD015
493200230913     C                             IPCHTP = 'A'  AND  INTRI5 <> I2INTRI5                      CSD015
493300230913     C                   EVAL      Fld1 = INTRIB                                              CSD015
493400230913     C                   EVAL      Fld2 = INTRI1                                              CSD015
493500230913     C                   EVAL      Fld3 = INTRI2                                              CSD015
493600230913     C                   EVAL      Fld4 = INTRI3                                              CSD015
493700230913     C                   EVAL      Fld5 = INTRI4                                              CSD015
493800230913     C                   EVAL      Fld6 = INTRI5                                              CSD015
493900230913     C                   EVAL      U = 23                                                     CSD015
494000230913     C                   EXSR      SRConvert                                                  CSD015
494100230913     C                   ENDIF                                                                CSD015
494200230913                                                                                              CSD015
494300230913     C                   ENDIF                                                                CSD015
494400230913                                                                                              CSD015
494500230913     C                   IF        CSW209 = 'Y'                                               CSW209
494600230913      *                                                                                       CSW209
494700230913      ** Ordering Customer Cover                                                              CSW209
494800230913      *                                                                                       CSW209
494900230913     C                   IF        INCOC1 <> *Blanks  OR                                      CSW209
495000230913     C                             INCOC2 <> *Blanks  OR                                      CSW209
495100230913     C                             INCOC3 <> *Blanks  OR                                      CSW209
495200230913     C                             INCOC4 <> *Blanks  OR                                      CSW209
495300230913     C                             INCOC5 <> *Blanks                                          CSW209
495400230913      *                                                                                       CSW209
495500230913     C                   IF        IPCHTP = 'I' OR                                            CSW209
495600230913     C                             WUNCFL = 'Y' OR                                            CSW209
495700230913     C                             IPCHTP = 'A'  AND                                          CSW209
495800230913     C                             INCOC1 <> I2COC1  OR                                       CSW209
495900230913     C                             IPCHTP = 'A'  AND                                          CSW209
496000230913     C                             INCOC2 <> I2COC2  OR                                       CSW209
496100230913     C                             IPCHTP = 'A'  AND                                          CSW209
496200230913     C                             INCOC3 <> I2COC3  OR                                       CSW209
496300230913     C                             IPCHTP = 'A'  AND                                          CSW209
496400230913     C                             INCOC4 <> I2COC4  OR                                       CSW209
496500230913     C                             IPCHTP = 'A'  AND                                          CSW209
496600230913     C                             INCOC5 <> I2COC5                                           CSW209
496700230913     C                   EVAL      Fld1 = INCOC1                                              CSW209
496800230913     C                   EVAL      Fld2 = INCOC2                                              CSW209
496900230913     C                   EVAL      Fld3 = INCOC3                                              CSW209
497000230913     C                   EVAL      Fld4 = INCOC4                                              CSW209
497100230913     C                   EVAL      Fld5 = INCOC5                                              CSW209
497200230913     C                   EVAL      U = 25                                                     CSW209
497300230913     C                   EXSR      SRConvert                                                  CSW209
497400230913     C                   ENDIF                                                                CSW209
497500230913     C                   ENDIF                                                                CSW209
497600230913      *                                                                                       CSW209
497700230913      ** Ordering Bank Cover                                                                  CSW209
497800230913      *                                                                                       CSW209
497900230913     C                   IF        INCOB1 <> *Blanks  OR                                      CSW209
498000230913     C                             INCOB2 <> *Blanks  OR                                      CSW209
498100230913     C                             INCOB3 <> *Blanks  OR                                      CSW209
498200230913     C                             INCOB4 <> *Blanks  OR                                      CSW209
498300230913     C                             INCOB5 <> *Blanks                                          CSW209
498400230913      *                                                                                       CSW209
498500230913     C                   IF        IPCHTP = 'I' OR                                            CSW209
498600230913     C                             WUNCFL = 'Y' OR                                            CSW209
498700230913     C                             IPCHTP = 'A'  AND                                          CSW209
498800230913     C                             INCOB1 <> I2COB1  OR                                       CSW209
498900230913     C                             IPCHTP = 'A'  AND                                          CSW209
499000230913     C                             INCOB2 <> I2COB2  OR                                       CSW209
499100230913     C                             IPCHTP = 'A'  AND                                          CSW209
499200230913     C                             INCOB3 <> I2COB3  OR                                       CSW209
499300230913     C                             IPCHTP = 'A'  AND                                          CSW209
499400230913     C                             INCOB4 <> I2COB4  OR                                       CSW209
499500230913     C                             IPCHTP = 'A'  AND                                          CSW209
499600230913     C                             INCOB5 <> I2COB5                                           CSW209
499700230913     C                   EVAL      Fld1 = INCOB1                                              CSW209
499800230913     C                   EVAL      Fld2 = INCOB2                                              CSW209
499900230913     C                   EVAL      Fld3 = INCOB3                                              CSW209
500000230913     C                   EVAL      Fld4 = INCOB4                                              CSW209
500100230913     C                   EVAL      Fld5 = INCOB5                                              CSW209
500200230913     C                   EVAL      U = 27                                                     CSW209
500300230913     C                   EXSR      SRConvert                                                  CSW209
500400230913     C                   ENDIF                                                                CSW209
500500230913     C                   ENDIF                                                                CSW209
500600230913      *                                                                                       CSW209
500700230913      ** Intermediary Bank Cover                                                              CSW209
500800230913      *                                                                                       CSW209
500900230913     C                   IF        INCIB1 <> *Blanks  OR                                      CSW209
501000230913     C                             INCIB2 <> *Blanks  OR                                      CSW209
501100230913     C                             INCIB3 <> *Blanks  OR                                      CSW209
501200230913     C                             INCIB4 <> *Blanks  OR                                      CSW209
501300230913     C                             INCIB5 <> *Blanks                                          CSW209
501400230913      *                                                                                       CSW209
501500230913     C                   IF        IPCHTP = 'I' OR                                            CSW209
501600230913     C                             WUNCFL = 'Y' OR                                            CSW209
501700230913     C                             IPCHTP = 'A'  AND                                          CSW209
501800230913     C                             INCIB1 <> I2CIB1  OR                                       CSW209
501900230913     C                             IPCHTP = 'A'  AND                                          CSW209
502000230913     C                             INCIB2 <> I2CIB2  OR                                       CSW209
502100230913     C                             IPCHTP = 'A'  AND                                          CSW209
502200230913     C                             INCIB3 <> I2CIB3  OR                                       CSW209
502300230913     C                             IPCHTP = 'A'  AND                                          CSW209
502400230913     C                             INCIB4 <> I2CIB4  OR                                       CSW209
502500230913     C                             IPCHTP = 'A'  AND                                          CSW209
502600230913     C                             INCIB5 <> I2CIB5                                           CSW209
502700230913     C                   EVAL      Fld1 = INCIB1                                              CSW209
502800230913     C                   EVAL      Fld2 = INCIB2                                              CSW209
502900230913     C                   EVAL      Fld3 = INCIB3                                              CSW209
503000230913     C                   EVAL      Fld4 = INCIB4                                              CSW209
503100230913     C                   EVAL      Fld5 = INCIB5                                              CSW209
503200230913     C                   EVAL      U = 29                                                     CSW209
503300230913     C                   EXSR      SRConvert                                                  CSW209
503400230913     C                   ENDIF                                                                CSW209
503500230913     C                   ENDIF                                                                CSW209
503600230913      *                                                                                       CSW209
503700230913      ** Account with Bank Cover                                                              CSW209
503800230913      *                                                                                       CSW209
503900230913     C                   IF        INCAB1 <> *Blanks  OR                                      CSW209
504000230913     C                             INCAB2 <> *Blanks  OR                                      CSW209
504100230913     C                             INCAB3 <> *Blanks  OR                                      CSW209
504200230913     C                             INCAB4 <> *Blanks  OR                                      CSW209
504300230913     C                             INCAB5 <> *Blanks                                          CSW209
504400230913      *                                                                                       CSW209
504500230913     C                   IF        IPCHTP = 'I' OR                                            CSW209
504600230913     C                             WUNCFL = 'Y' OR                                            CSW209
504700230913     C                             IPCHTP = 'A'  AND                                          CSW209
504800230913     C                             INCAB1 <> I2CAB1  OR                                       CSW209
504900230913     C                             IPCHTP = 'A'  AND                                          CSW209
505000230913     C                             INCAB2 <> I2CAB2  OR                                       CSW209
505100230913     C                             IPCHTP = 'A'  AND                                          CSW209
505200230913     C                             INCAB3 <> I2CAB3  OR                                       CSW209
505300230913     C                             IPCHTP = 'A'  AND                                          CSW209
505400230913     C                             INCAB4 <> I2CAB4  OR                                       CSW209
505500230913     C                             IPCHTP = 'A'  AND                                          CSW209
505600230913     C                             INCAB5 <> I2CAB5                                           CSW209
505700230913     C                   EVAL      Fld1 = INCAB1                                              CSW209
505800230913     C                   EVAL      Fld2 = INCAB2                                              CSW209
505900230913     C                   EVAL      Fld3 = INCAB3                                              CSW209
506000230913     C                   EVAL      Fld4 = INCAB4                                              CSW209
506100230913     C                   EVAL      Fld5 = INCAB5                                              CSW209
506200230913     C                   EVAL      U = 31                                                     CSW209
506300230913     C                   EXSR      SRConvert                                                  CSW209
506400230913     C                   ENDIF                                                                CSW209
506500230913     C                   ENDIF                                                                CSW209
506600230913      *                                                                                       CSW209
506700230913      ** Beneficiary Cover                                                                    CSW209
506800230913      *                                                                                       CSW209
506900230913     C                   IF        INCBC1 <> *Blanks  OR                                      CSW209
507000230913     C                             INCBC2 <> *Blanks  OR                                      CSW209
507100230913     C                             INCBC3 <> *Blanks  OR                                      CSW209
507200230913     C                             INCBC4 <> *Blanks  OR                                      CSW209
507300230913     C                             INCBC5 <> *Blanks                                          CSW209
507400230913      *                                                                                       CSW209
507500230913     C                   IF        IPCHTP = 'I' OR                                            CSW209
507600230913     C                             WUNCFL = 'Y' OR                                            CSW209
507700230913     C                             IPCHTP = 'A'  AND                                          CSW209
507800230913     C                             INCBC1 <> I2CBC1  OR                                       CSW209
507900230913     C                             IPCHTP = 'A'  AND                                          CSW209
508000230913     C                             INCBC2 <> I2CBC2  OR                                       CSW209
508100230913     C                             IPCHTP = 'A'  AND                                          CSW209
508200230913     C                             INCBC3 <> I2CBC3  OR                                       CSW209
508300230913     C                             IPCHTP = 'A'  AND                                          CSW209
508400230913     C                             INCBC4 <> I2CBC4  OR                                       CSW209
508500230913     C                             IPCHTP = 'A'  AND                                          CSW209
508600230913     C                             INCBC5 <> I2CBC5                                           CSW209
508700230913     C                   EVAL      Fld1 = INCBC1                                              CSW209
508800230913     C                   EVAL      Fld2 = INCBC2                                              CSW209
508900230913     C                   EVAL      Fld3 = INCBC3                                              CSW209
509000230913     C                   EVAL      Fld4 = INCBC4                                              CSW209
509100230913     C                   EVAL      Fld5 = INCBC5                                              CSW209
509200230913     C                   EVAL      U = 33                                                     CSW209
509300230913     C                   EXSR      SRConvert                                                  CSW209
509400230913     C                   ENDIF                                                                CSW209
509500230913     C                   ENDIF                                                                CSW209
509600230913      *                                                                                       CSW209
509700230913      ** Details of Payment Cover                                                             CSW209
509800230913      *                                                                                       CSW209
509900230913     C                   IF        INCDP1 <> *Blanks  OR                                      CSW209
510000230913     C                             INCDP2 <> *Blanks  OR                                      CSW209
510100230913     C                             INCDP3 <> *Blanks  OR                                      CSW209
510200230913     C                             INCDP4 <> *Blanks                                          CSW209
510300230913      *                                                                                       CSW209
510400230913     C                   IF        IPCHTP = 'I' OR                                            CSW209
510500230913     C                             WUNCFL = 'Y' OR                                            CSW209
510600230913     C                             IPCHTP = 'A'  AND                                          CSW209
510700230913     C                             INCDP1 <> I2CDP1  OR                                       CSW209
510800230913     C                             IPCHTP = 'A'  AND                                          CSW209
510900230913     C                             INCDP2 <> I2CDP2  OR                                       CSW209
511000230913     C                             IPCHTP = 'A'  AND                                          CSW209
511100230913     C                             INCDP3 <> I2CDP3  OR                                       CSW209
511200230913     C                             IPCHTP = 'A'  AND                                          CSW209
511300230913     C                             INCDP4 <> I2CDP4                                           CSW209
511400230913     C                   EVAL      Fld1 = INCDP1                                              CSW209
511500230913     C                   EVAL      Fld2 = INCDP2                                              CSW209
511600230913     C                   EVAL      Fld3 = INCDP3                                              CSW209
511700230913     C                   EVAL      Fld4 = INCDP4                                              CSW209
511800230913     C                   EVAL      U = 35                                                     CSW209
511900230913     C                   EXSR      SRConvert                                                  CSW209
512000230913     C                   ENDIF                                                                CSW209
512100230913     C                   ENDIF                                                                CSW209
512200230913      *                                                                                       CSW209
512300230913     C                   ENDIF                                                                CSW209
512400230913      *                                                                                       CSD015
512500230913      ** If second parameter is not blank, setup first parameter and                          CSD015
512600230913      ** send transaction details to Compliance Watch by calling SDCWLCHK                     CSD015
512700230913      *                                                                                       CSD015
512800230913     C                   IF        PString <> *Blanks                                         CSD015
512900230913                                                                                              CSD015
513000230913     C                   EXSR      SRSet1stParm                                               CSD015
513100230913                                                                                              CSD015
513200230913     C                   CALL      'SDCWLCHK'                                                 CSD015
513300230913     C                   PARM                    SDWLTD                                       CSD015
513400230913     C                   PARM                    PString                                      CSD015
513500230913     C                   ENDIF                                                                CSD015
513600230913                                                                                              CSD015
513700230913     C                   ENDSR                                                                CSD015
513800230913      *****************************************************************                       CSD015
513900230913      /EJECT                                                                                  CSD015
514000230913      *****************************************************************                       CSD015
514100230913      *                                                               *                       CSD015
514200230913      * SRSet1stParm - Setup first parameter of SDCWLCHK.             *                       CSD015
514300230913      *                                                               *                       CSD015
514400230913      *****************************************************************                       CSD015
514500230913     C     SRSet1stParm  BEGSR                                                                CSD015
514600230913                                                                                              CSD015
514700230913      ** Item Type Code                                                                       CSD015
514800230913     C                   EVAL      W4ITEM = 'FTIPAY'                                          CSD015
514900230913                                                                                              CSD015
515000230913      ** Identifier                                                                           CSD015
515100230913     C                   EVAL      W4IDEN = IPPREF                                            CSD015
515200230913                                                                                              CSD015
515300230913      ** Branch                                                                               CSD015
515400230913     C                   EVAL      W4BRCH = IPBRCA                                            CSD015
515500230913                                                                                              CSD015
515600230913      ** System                                                                               CSD015
515700230913      ** If Midas 24x7 is installed, use Main system prefix otherwise use system prefix       CSD015
515800230913     C                   IF        CSC011 = 'Y'                                               CSD015
515900230913     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
516000230913     C                   ELSE                                                                 CSD015
516100230913     C                   EVAL      W4SYSM = LIBR                                              CSD015
516200230913     C                   ENDIF                                                                CSD015
516300230913                                                                                              CSD015
516400230913      ** Function Type                                                                        CSD015
516500230913     C                   EVAL      W4FUNT = 'INPAYDD'                                         CSD015
516600230913                                                                                              CSD015
516700230913      ** Counterparty Details                                                                 CSD015
516800230913      ** Counterparty is the sender of the message                                            CSD015
516900230913                                                                                              CSD015
517000230913     C                   EVAL      W4CNUM = *Blanks                                           CSD015
517100230913     C                   EVAL      W4CTYP = *Blanks                                           CSD015
517200230913     C                   EVAL      W4CUST = *Blanks                                           CSD015
517300230913     C                   MOVEL     IPRCCO        WRecCor           6                          CSD015
517400230913                                                                                              CSD015
517500230913     C                   IF        IPSND1 <> *Blanks  or  IPSND2 <> *Blanks  or               CSD015
517600230913     C                             IPSND3 <> *Blanks  or  IPSND4 <> *Blanks                   CSD015
517700230913     C                   EVAL      Fld1 = IPSND1                                              CSD015
517800230913     C                   EVAL      Fld2 = IPSND2                                              CSD015
517900230913     C                   EVAL      Fld3 = IPSND3                                              CSD015
518000230913     C                   EVAL      Fld4 = IPSND4                                              CSD015
518100230913     C                   EXSR      SRGetCtrpDet                                               CSD015
518200230913     C                   ENDIF                                                                CSD015
518300230913     C                   IF        OutFmt2 = '*FREE' or OutFmt2 = '*CPART' or                 CSD015
518400230913     C                             (IPSND1 = *Blanks and IPSND2 = *Blanks and                 CSD015
518500230913     C                             IPSND3 = *Blanks and IPSND4 = *Blanks)                     CSD015
518600230913     C                   MOVEL     WRecCor       Fld1                                         CSD015
518700230913     C                   EVAL      Fld2 = *Blanks                                             CSD015
518800230913     C                   EVAL      Fld3 = *Blanks                                             CSD015
518900230913     C                   EVAL      Fld4 = *Blanks                                             CSD015
519000230913     C                   EVAL      PInCcy = IPSMCY                                            CSD015
519100230913     C                   EXSR      SRGetCtrpDet                                               CSD015
519200230913     C                   ENDIF                                                                CSD015
519300230913     C                   IF        OutFmt2 = '*FREE' or OutFmt2 = '*CPART' or                 CSD015
519400230913     C                             (IPSND1 = *Blanks and IPSND2 = *Blanks  and                CSD015
519500230913     C                             IPSND3 = *Blanks and IPSND4 = *Blanks  and                 CSD015
519600230913     C                             WRecCor = *Blanks)                                         CSD015
519700230913     C                   EVAL      Fld1 = I2INTRIB                                            CSD015
519800230913     C                   EVAL      Fld2 = *Blanks                                             CSD015
519900230913     C                   EVAL      Fld3 = *Blanks                                             CSD015
520000230913     C                   EVAL      Fld4 = *Blanks                                             CSD015
520100230913     C                   ENDIF                                                                CSD015
520200230913     C                   IF        OutFmt2 <> '*FREE' and OutFmt2 <> '*CPART'                 CSD015
520300230913     C                   EVAL      W4CNUM = OutFmt2                                           CSD015
520400230913     C                   EVAL      W4CTYP = WCtrpTyp                                          CSD015
520500230913     C                   EVAL      W4CUST = WCtrpRpt                                          CSD015
520600230913     C                   ENDIF                                                                CSD015
520700230913                                                                                              CSD015
520800230913      ** Deal Date                                                                            CSD015
520900230913     C                   MOVE      '00000'       PZADayNo                                     CSD015
521000230913     C                   EXSR      SRDateToDDT                                                CSD015
521100230913     C                   EVAL      W4DDAT = WDDT                                              CSD015
521200230913                                                                                              CSD015
521300230913      ** Value Date                                                                           CSD015
521400230913     C                   MOVE      IPSLDT        PZADayNo                                     CSD015
521500230913     C                   EXSR      SRDateToDDT                                                CSD015
521600230913     C                   EVAL      W4VDAT = WDDT                                              CSD015
521700230913                                                                                              CSD015
521800230913      ** Maturity Date                                                                        CSD015
521900230913     C                   MOVE      IPPVDT        PZADayNo                                     CSD015
522000230913     C                   EXSR      SRDateToDDT                                                CSD015
522100230913     C                   EVAL      W4MDAT = WDDT                                              CSD015
522200230913                                                                                              CSD015
522300230913      ** Denomination Side 1                                                                  CSD015
522400230913     C                   EVAL      W4DEN1  = IPSMCY                                           CSD015
522500230913                                                                                              CSD015
522600230913      ** Denomination Side 2                                                                  CSD015
522700230913     C                   EVAL      W4DEN2  = IPPCCY                                           CSD015
522800230913                                                                                              CSD015
522900230913      ** Amount Side 1                                                                        CSD015
523000230913     C                   EVAL      PZACcy = IPSMCY                                            CSD015
523100230913     C                   MOVE      IPSMAM        PZAAmt                                       CSD015
523200230913     C                   EXSR      SRAmtToFPDT                                                CSD015
523300230913     C                   EVAL      W4AMT1 = WFPDT                                             CSD015
523400230913                                                                                              CSD015
523500230913      ** Amount Side 2                                                                        CSD015
523600230913     C                   EVAL      PZACcy = IPPCCY                                            CSD015
523700230913     C                   MOVE      IPPYAM        PZAAmt                                       CSD015
523800230913     C                   EXSR      SRAmtToFPDT                                                CSD015
523900230913     C                   EVAL      W4AMT2 = WFPDT                                             CSD015
524000230913                                                                                              CSD015
524100230913     C                   ENDSR                                                                CSD015
524200230913      *****************************************************************                       CSD015
524300230913      /EJECT                                                                                  CSD015
524400230913      *****************************************************************                       CSD015
524500230913      *                                                               *                       CSD015
524600230913      * SRDateToDDT - Converts a date into Date Data Type format.     *                       CSD015
524700230913      *                                                               *                       CSD015
524800230913      *****************************************************************                       CSD015
524900230913     C     SRDateToDDT   BEGSR                                                                CSD015
525000230913                                                                                              CSD015
525100230913      ** Convert the derived Midas Day Number into Date Data Type.                            CSD015
525200230913                                                                                              CSD015
525300230913     C                   CALL      'ZACVTDATE'                                                CSD015
525400230913     C                   PARM      *BLANKS       PRtCd                                        CSD015
525500230913     C                   PARM                    PZADayNo                                     CSD015
525600230913     C                   PARM                    PZADDT                                       CSD015
525700230913     C                   PARM                    PZACvtDt                                     CSD015
525800230913                                                                                              CSD015
525900230913     C                   EVAL      WDDT = PZADDT                                              CSD015
526000230913                                                                                              CSD015
526100230913     C                   ENDSR                                                                CSD015
526200230913      *****************************************************************                       CSD015
526300230913      /EJECT                                                                                  CSD015
526400230913      *****************************************************************                       CSD015
526500230913      *                                                               *                       CSD015
526600230913      * SRAmtToFPDT - Converts an amount into Floating Point Data     *                       CSD015
526700230913      *               Type format.                                    *                       CSD015
526800230913      *                                                               *                       CSD015
526900230913      *****************************************************************                       CSD015
527000230913     C     SRAmtToFPDT   BEGSR                                                                CSD015
527100230913      *                                                                                       CSD015
527200230913      ** Directly convert the given amount into Floating Point format.                        CSD015
527300230913      *                                                                                       CSD015
527400230913     C                   CALL      'ZACVTAMT'                                                 CSD015
527500230913     C                   PARM      *BLANKS       PZARtCd                                      CSD015
527600230913     C                   PARM                    PZACcy                                       CSD015
527700230913     C                   PARM                    PZAAmt                                       CSD015
527800230913     C                   PARM      0E0           PZOutAmt                                     CSD015
527900230913     C                   PARM                    PZCvtAmt                                     CSD015
528000230913      *                                                                                       CSD015
528100230913     C                   EVAL      WFPDT = PZOutAmt                                           CSD015
528200230913      *                                                                                       CSD015
528300230913     C                   ENDSR                                                                CSD015
528400230913      *****************************************************************                       CSD015
528500230913      /EJECT                                                                                  CSD015
528600230913      *****************************************************************                       CSD015
528700230913      *                                                               *                       CSD015
528800230913      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *                       CSD015
528900230913      *                Number.                                        *                       CSD015
529000230913      *                                                               *                       CSD015
529100230913      *****************************************************************                       CSD015
529200230913     C     SRGetCtrpDet  BEGSR                                                                CSD015
529300230913                                                                                              CSD015
529400230913      ** Initialise the relevant variables.                                                   CSD015
529500230913                                                                                              CSD015
529600230913     C                   EVAL      PCustNo = *BLANKS                                          CSD015
529700230913     C                   EVAL      WCtrpRpt = *BLANKS                                         CSD015
529800230913     C                   EVAL      WCtrpTyp = *BLANKS                                         CSD015
529900230913                                                                                              CSD015
530000230913     C                   CALL      'SDCWLFMT'                                                 CSD015
530100230913     C                   PARM      *Blanks       Prtcd                                        CSD015
530200230913     C                   PARM      Fld1          PInput                                       CSD015
530300230913     C                   PARM      Fld2          PInput1                                      CSD015
530400230913     C                   PARM      Fld3          PInput2                                      CSD015
530500230913     C                   PARM      Fld4          PInput3                                      CSD015
530600230913     C                   PARM                    PInput4                                      CSD015
530700230913     C                   PARM                    PInput5                                      CSD015
530800230913     C                   PARM                    PInCcy                                       CSD015
530900230913     C                   PARM                    OutFmt                                       CSD015
531000230913     C                   PARM                    OutFmt2                                      CSD015
531100230913                                                                                              CSD015
531200230913     C                   IF        Prtcd <> *Blanks  AND                                      CSD015
531300230913     C                             Prtcd <> '*NRF  '                                          CSD015
531400230913     C                   EVAL      DBKey = Fld1                                               CSD015
531500230913     C                   EVAL      DBFile = 'SDCWLFMT'                                        CSD015
531600230913     C                   EVAL      DBase = 13                                                 CSD015
531700230913     C                   EXSR      *PSSR                                                      CSD015
531800230913     C                   ENDIF                                                                CSD015
531900230913                                                                                              CSD015
532000230913     C                   EVAL      Fld1 = *Blanks                                             CSD015
532100230913     C                   EVAL      Fld2 = *Blanks                                             CSD015
532200230913     C                   EVAL      Fld3 = *Blanks                                             CSD015
532300230913     C                   EVAL      Fld4 = *Blanks                                             CSD015
532400230913     C                   EVAL      Fld5 = *Blanks                                             CSD015
532500230913     C                   EVAL      Fld6 = *Blanks                                             CSD015
532600230913     C                   EVAL      PCustNo = OutFmt2                                          CSD015
532700230913                                                                                              CSD015
532800230913      ** Get the Customer Detail.                                                             CSD015
532900230913                                                                                              CSD015
533000230913     C                   CALL      'AOCUSTR0'                                                 CSD015
533100230913     C                   PARM      *BLANKS       PrtCd                                        CSD015
533200230913     C                   PARM      '*KEY   '     POptn                                        CSD015
533300230913     C                   PARM                    PCustNo                                      CSD015
533400230913     C                   PARM      *BLANKS       PErrInf                                      CSD015
533500230913     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
533600230913                                                                                              CSD015
533700230913     C                   IF        PrtCd = *Blanks                                            CSD015
533800230913                                                                                              CSD015
533900230913      ** Assemble the Counterparty Report information.                                        CSD015
534000230913                                                                                              CSD015
534100230913     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                     CSD015
534200230913                                                                                              CSD015
534300230913      ** Determine the Counterparty Type.                                                     CSD015
534400230913                                                                                              CSD015
534500230913     C                   IF        CCF001 = 'Y'                                               CSD015
534600230913                                                                                              CSD015
534700230913     C                   IF        BBCRPC = 'Y'                                               CSD015
534800230913     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
534900230913     C                   ELSE                                                                 CSD015
535000230913     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
535100230913     C                   ENDIF                                                                CSD015
535200230913                                                                                              CSD015
535300230913     C                   ELSE                                                                 CSD015
535400230913                                                                                              CSD015
535500230913     C                   IF        BBLICD <> *BLANKS AND                                      CSD015
535600230913     C                             BBLICD <> W1IND1  AND                                      CSD015
535700230913     C                             BBLICD <> W1IND2  AND                                      CSD015
535800230913     C                             BBLICD <> W1IND3  AND                                      CSD015
535900230913     C                             BBLICD <> W1IND4  AND                                      CSD015
536000230913     C                             BBLICD <> W1IND5                                           CSD015
536100230913     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
536200230913     C                   ELSE                                                                 CSD015
536300230913     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
536400230913     C                   ENDIF                                                                CSD015
536500230913                                                                                              CSD015
536600230913     C                   ENDIF                                                                CSD015
536700230913                                                                                              CSD015
536800230913     C                   ELSE                                                                 CSD015
536900230913                                                                                              CSD015
537000230913      ** Handle Database Errors if any occur.                                                 CSD015
537100230913                                                                                              CSD015
537200230913     C                   IF        PrtCd <> '*NRF'                                            CSD015
537300230913     C     *LOCK         IN        LDA                                                        CSD015
537400230913     C                   EVAL      DBKey = POptn                                              CSD015
537500230913     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
537600230913     C                   EVAL      DBase = 21                                                 CSD015
537700230913     C                   OUT       LDA                                                      MD029681
537800230913     C                   EXSR      *PSSR                                                      CSD015
537900230913     C                   ENDIF                                                                CSD015
538000230913                                                                                              CSD015
538100230913     C                   ENDIF                                                                CSD015
538200230913                                                                                              CSD015
538300230913     C                   ENDSR                                                                CSD015
538400230913      /EJECT                                                                                  CSD015
538500230913      *****************************************************************                       CSD015
538600230913      *                                                               *                       CSD015
538700230913      * SRConvert - Subroutine to convert accounts, customer no. to   *                       CSD015
538800230913      *             customer name and address.                        *                       CSD015
538900230913      * Called by: SRWTCH                                             *                       CSD015
539000230913      *                                                               *                       CSD015
539100230913      * Calls: SDCWHLCHK                                              *                       CSD015
539200230913      *                                                               *                       CSD015
539300230913      *****************************************************************                       CSD015
539400230913     C     SRConvert     BEGSR                                                                CSD015
539500230913                                                                                              CSD015
539600230913     C                   EVAL      OutFmt = *Blanks                                           CSD015
539700230913     C                   EVAL      PInput = *Blanks                                           CSD015
539800230913     C                   EVAL      PInput1 = *Blanks                                          CSD015
539900230913     C                   EVAL      PInput2 = *Blanks                                          CSD015
540000230913     C                   EVAL      PInput3 = *Blanks                                          CSD015
540100230913     C                   EVAL      PInput4 = *Blanks                                          CSD015
540200230913                                                                                              CSD015
540300230913     C                   CALL      'SDCWLFMT'                                                 CSD015
540400230913     C                   PARM      *Blanks       Prtcd                                        CSD015
540500230913     C                   PARM      Fld1          PInput                                       CSD015
540600230913     C                   PARM      Fld2          PInput1                                      CSD015
540700230913     C                   PARM      Fld3          PInput2                                      CSD015
540800230913     C                   PARM      Fld4          PInput3                                      CSD015
540900230913     C                   PARM      Fld5          PInput4                                      CSD015
541000230913     C                   PARM      Fld6          PInput5                                      CSD015
541100230913     C                   PARM                    PInCcy                                       CSD015
541200230913     C                   PARM                    OutFmt                                       CSD015
541300230913     C                   PARM                    OutFmt2                                      CSD015
541400230913                                                                                              CSD015
541500230913     C                   IF        Prtcd <> *Blanks  and                                      CSD015
541600230913     C                             Prtcd <> '*NRF  '                                          CSD015
541700230913     C                   EVAL      DBKey = Fld1                                               CSD015
541800230913     C                   EVAL      DBFile = 'SDCWLFMT'                                        CSD015
541900230913     C                   EVAL      DBase = 10                                                 CSD015
542000230913     C                   EXSR      *PSSR                                                      CSD015
542100230913     C                   ENDIF                                                                CSD015
542200230913                                                                                              CSD015
542300230913                                                                                              CSD015
542400230913     C                   EVAL      Fld1 = *Blanks                                             CSD015
542500230913     C                   EVAL      Fld2 = *Blanks                                             CSD015
542600230913     C                   EVAL      Fld3 = *Blanks                                             CSD015
542700230913     C                   EVAL      Fld4 = *Blanks                                             CSD015
542800230913     C                   EVAL      Fld5 = *Blanks                                             CSD015
542900230913     C                   EVAL      Fld6 = *Blanks                                             CSD015
543000230913                                                                                              CSD015
543100230913     C     PString       CAT       WLARR(U):0    PString                                      CSD015
543200230913     C     PString       CAT       OUTFMT:0      PString                                      CSD015
543300230913     C                   EVAL      U = U+1                                                    CSD015
543400230913     C     PString       CAT       WLARR(U):0    PString                                      CSD015
543500230913                                                                                              CSD015
543600230913     C                   ENDSR                                                                CSD015
543700230913      *****************************************************************                     MD058914
543800230913      /EJECT                                                                                MD058914
543900230913      *****************************************************************                     MD058914
544000230913      *                                                               *                     MD058914
544100230913      * SRSetINPAYDQD - Gets the Customer and Branch Details          *                     MD058914
544200230913      *                                                               *                     MD058914
544300230913      *****************************************************************                     MD058914
544400230913     C     SRSetINPAYDQD BEGSR                                                              MD058914
544500230913      *                                                                                     MD058914
544600230913     C                   CALL      'FT1200'                                                 MD058914
544700230913     C                   PARM      *blank        P@Rtcd                                     MD058914
544800230913      * INPUTS                                                                              MD058914
544900230913     C                   PARM      'I'           P@INOT                                     MD058914
545000230913     C                   PARM      IPBNC1        P@BNC1                                     MD058914
545100230913     C                   PARM      IPBNC2        P@BNC2                                     MD058914
545200230913     C                   PARM                    P@ORC1                                     MD058914
545300230913     C                   PARM                    P@ORC2                                     MD058914
545400230913     C                   PARM                    P@ORC3                                     MD058914
545500230913     C                   PARM      IPBRCA        P@BRCA                                     MD058914
545600230913     C                   PARM      IPPCCY        P@PCCY                                     MD058914
545700230913     C                   PARM      IPSMCY        P@SMCY                                     MD058914
545800230913      * OUTPUTS                                                                             MD058914
545900230913     C                   PARM      *blanks       WCustNumb                                  MD058914
546000230913     C                   PARM      *blanks       WCustBrch                                  MD058914
546100230913      *                                                                                     MD058914
546200230913     C                   EVAL      IPBNCC = WCustNumb                                       MD058914
546300230913     C                   EVAL      IPBNCB = WCustBrch                                       MD058914
546400230913      *                                                                                     MD058914
546500230913     C                   ENDSR                                                              MD058914
546600230913                                                                                              CGL029
546700230913      *****************************************************************                       CGL029
546800230913      /EJECT                                                                                  CGL029
546900230913      *****************************************************************                       CGL029
547000230913      *                                                               *                       CGL029
547100230913      * SRFLGL - Sobroutine to assess full General Ledger.            *                       CGL029
547200230913      *                                                               *                       CGL029
547300230913      *****************************************************************                       CGL029
547400230913                                                                                              CGL029
547500230913     C     SRFLGL        BEGSR                                                                CGL029
547600230913                                                                                              CGL029
547700230913     C                   SELECT                                                              BUG3821
547800230913     C     C_ATYP        WHENEQ    'N'                                                       BUG3821
547900230913     C                   EVAL      C_NOSN = W_NOSN                                           BUG3821
548000230913     C     C_ATYP        WHENEQ    'F'                                                       BUG3821
548100230913     C                   EVAL      C_NOS  = W_NOS                                            BUG3821
548200230913     C     C_ATYP        WHENEQ    'R'                                                       BUG3821
548300230913     C                   EVAL      C_ACNO = W_ACNO                                           BUG3821
548400230913     C     C_ATYP        WHENEQ    'G'                                                       BUG3821
548500230913     C     C_ATYP        OREQ      'I'                                                      BUG23088
548600230913     C                   EVAL      C_CNU1 = W_CNU1                                            CGL029
548700230913     C                   EVAL      C_CCY1 = W_CCY1                                            CGL029
548800230913     C                   EVAL      C_ACO1 = W_ACO1                                            CGL029
548900230913     C                   EVAL      C_ACS1 = W_ACS1                                            CGL029
549000230913     C                   EVAL      C_BRC1 = W_BRC1                                            CGL029
549100230913     C     C_ATYP        WHENEQ    'P'                                                       BUG3821
549200230913     C*******************EVAL      C_CNU1 = W_CNU1                                    BUG3821 240008
549300230913     C*******************EVAL      C_ACO1 = W_ACO1                                    BUG3821 240008
549400230913     C*******************EVAL      C_ACS1 = W_ACS1                                    BUG3821 240008
549500230913     C                   EVAL      C_CNUM = P#CNUM                                            240008
549600230913     C                   EVAL      C_ACSQ = P#ACSQ                                            240008
549700230913     C                   EVAL      C_BRCA = P#BRCA                                            240008
549800230913     C                   EVAL      C_ACOD = P#ACOD                                            240008
549900230913     C     C_ATYP        WHENEQ    'I'                                                        237564
550000230913     C                   EVAL      C_CNU1 = WICNUM                                            237564
550100230913     C                   EVAL      C_CCY1 = WICCY                                             237564
550200230913     C                   EVAL      C_ACO1 = WIACOD                                            237564
550300230913     C                   EVAL      C_ACS1 = WIACSQ                                            237564
550400230913     C                   EVAL      C_BRC1 = WIBRCA                                            237564
550500230913     C                   ENDSL                                                               BUG3821
550600230913      *
550700230913     C*******************EVAL      C_ACOD = W_ACOD                                    BUG3854 240008
550800230913     C*******************EVAL      C_ACSQ = W_ACSQ                                    BUG3854 240008
550900230913      *                                                                                       240008
551000230913     C     C_ATYP        IFEQ      'R'                                                        240008
551100230913     C                   MOVEL     C_ACCT        C_ACNO                                       240008
551200230913     C                   END                                                                  240008
551300230913                                                                                              CGL029
551400230913     C                   ENDSR                                                                CGL029
551500230913     C/COPY WNCPYSRC,FTH00414
551600230913                                                                                              CGL029
551700230913      *****************************************************************                       CSD015
551800230913      /EJECT                                                                                  CSD015
551900230913      *****************************************************************                       CSD015
552000230913      *                                                                                       CSD015
552100230913**  CPY@
552200230913(c) Finastra International Limited 2001
552300230913** WLARR - Watch List Fields                                                                  CSD015
552400230913<Sender>                                                                                      CSD015
552500230913</Sender>                                                                                     CSD015
552600230913<Receiver Corr - FT>                                                                          CSD015
552700230913</Receiver Corr - FT>                                                                         CSD015
552800230913<A/C with Bank>                                                                               CSD015
552900230913</A/C with Bank>                                                                      CSD015 BUG4556
553000230913<Beneficiary>                                                                                 CSD015
553100230913</Beneficiary>                                                                                CSD015
553200230913<Ordering Bank>                                                                               CSD015
553300230913</Ordering Bank>                                                                              CSD015
553400230913<Sender Corr>                                                                                 CSD015
553500230913</Sender Corr>                                                                                CSD015
553600230913<Ordering Cust>                                                                               CSD015
553700230913</Ordering Cust>                                                                              CSD015
553800230913<Details of Payment>                                                                          CSD015
553900230913</Details of Payment>                                                                         CSD015
554000230913<Intermediary Bank>                                                                           CSD015
554100230913</Intermediary Bank>                                                                          CSD015
554200230913<Receivers Corr>                                                                              CSD015
554300230913</Receivers Corr>                                                                             CSD015
554400230913<A/C with Bank>                                                                               CSD015
554500230913</A/C with Bank>                                                                              CSD015
554600230913<Third Reimbur Inst>                                                                          CSD015
554700230913</Third Reimbur Inst>                                                                         CSD015
554800230913<Ordering Customer Cover>                                                                     CSW209
554900230913</Ordering Customer Cover>                                                                    CSW209
555000230913<Ordering Bank Cover>                                                                         CSW209
555100230913</Ordering Bank Cover>                                                                        CSW209
555200230913<Intermediary Bank Cover>                                                                     CSW209
555300230913</Intermediary Bank Cover>                                                                    CSW209
555400230913<Account with Bank Cover>                                                                     CSW209
555500230913</Account with Bank Cover>                                                                    CSW209
555600230913<Beneficiary Cover>                                                                           CSW209
555700230913</Beneficiary Cover>                                                                          CSW209
555800230913<Details of Payment Cover>                                                                    CSW209
555900230913</Details of Payment Cover>                                                                   CSW209
556000230913**  POWERS                                                                                    CAP211
5561002309130000001                                                                                       CAP211
5562002309130000010                                                                                       CAP211
5563002309130000100                                                                                       CAP211
5564002309130001000                                                                                       CAP211
5565002309130010000                                                                                       CAP211
5566002309130100000                                                                                       CAP211
5567002309131000000                                                                                       CAP211
556800230913**  @DFT                                                                                      CAP211
556900230913**** FUNDS FROM ****                                                                          CAP211
