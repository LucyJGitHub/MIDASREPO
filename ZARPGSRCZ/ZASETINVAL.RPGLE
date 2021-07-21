000100210712     H DEBUG
000200210712     H COPYRIGHT('(c) Finastra International Limited 2002')
000300210712      *****************************************************************
000400210712/*STD *  RPGBASEMOD                                                   *
000500210712/*EXI *  TEXT('Midas ZA Settle instructions validation')              *
000600210712      *****************************************************************
000700210712      *                                                               *
000800210712      *  Midas - MM Dealer Module                                     *
000900210712      *                                                               *
001000210712      *  ZASETINVAL - SETTLEMENT INSTRUCTIONS VALIDATION              *
001100210712      *                                                               *
001200210712      *  (c) Finastra International Limited 2001                      *
001300210712      *                                                               *
001400210712      *  Last Amend No. CSW221             Date 05Apr21               *
001500210712      *  Prev Amend No. MD051567           Date 26Sep20               *
001600210712      *                 MD056313           Date 21Sep20               *
001700210712      *                 MD052922           Date 03Mar19               *
001800210712      *                 MD022945           Date 18Oct13               *
001900210712      *                 MD051877A          Date 02Oct18               *
002000210712      *                 MD051877           Date 22Sep18               *
002100210712      *                 MD051932           Date 22Sep18               *
002200210712      *                 MD052228           Date 30Oct18               *
002300210712      *                 MD034521A          Date 14Sep15               *
002400210712      *                 MD041649           Date 06Oct16               *
002500210712      *                 MD051239           Date 14Jun18               *
002600210712      *                 CDL051             Date 02May18               *
002700210712      *                 CLE168             Date 26Feb18               *
002800210712      *                 MD046248           Date 27Oct17               *
002900210712      *                 MD046115           Date 24Jul17               *
003000210712      *                 MD036475           Date 04Dec15               *
003100210712      *                 MD024884A          Date 04Jul17               *
003200210712      *                 MD032089           Date 28Apr15               *
003300210712      *                 MD040199           Date 05Aug16               *
003400210712      *                 MD039348           Date 17Jun16               *
003500210712      *                 MD033870           Date 17Apr15               *
003600210712      *                 AR892347           Date 25Nov14               *
003700210712      *                 MD030342           Date 25Nov14               *
003800210712      *                 MD029779           Date 25Nov14               *
003900210712      *                 CSW214             Date 25Nov14               *
004000210712      *                 CDL094             Date 01Sep14               *
004100210712      *                 254023             Date 19Aug14               *
004200210712      *                 MD023833           Date 27Nov13               *
004300210712      *                 MD022945           Date 18Oct13               *
004400210712      *                 CSW213             Date 03Jun13               *
004500210712      *                 MD020242           Date 30Sep13               *
004600210712      *                 MD021526           Date 01Aug13               *
004700210712      *                 MD020816           Date 11Jun13               *
004800210712      *                 MD000091           Date 15May13               *
004900210712      *                 AR1096686          Date 22Mar13               *
005000210712      *                 CMG003             Date 04Oct12               *
005100210712      *                 AR1039735          Date 02Oct12               *
005200210712      *                 AR1005230          Date 11Feb13               *
005300210712      *                 AR853046           Date 25Nov12               *
005400210712      *                 AR641619           Date 24Sep12               *
005500210712      *                 CLE134             Date 01Aug12               *
005600210712      *                 AR1000515          Date 06Jul12               *
005700210712      *                 CSW212             Date 03May12               *
005800210712      *                 CSF011A            Date 28Nov11               *
005900210712      *                 AR863960           Date 14Nov11               *
006000210712      *                 AR787620           Date 10Jun11               *
006100210712      *                 260863             Date 01Jul09               *
006200210712      * Bank Fusion Midas 1.4 Base -----------------------------------*
006300210712      *                 260428             Date 28May09               *
006400210712      * Midas Plus 1.4 Base 04 ---------------------------------------*
006500210712      *                 256564             Date 17Sep08               *
006600210712      *                 BUG14913           Date 27Sep07               *
006700210712      *                 248393             Date 13Jun07               *
006800210712      *                 246120             Date 05Mar07               *
006900210712      * Midas Plus 1.4 Base ------------------------------------------*
007000210712      *                 244636             Date 15Feb07               *
007100210712      *                 244370             Date 15Dec06               *
007200210712      * Midas Plus 1.3 ----------- Base ------------------------------*
007300210712      *                 217715             Date 19Sep06               *
007400210712      *                 238721             Date 11Aug06               *
007500210712      *                 BUG12624           Date 21Nov06               *
007600210712      *                 BUG12540           Date 08Nov06               *
007700210712      *                 239587             Date 03May06               *
007800210712      *                 CSD027             Date 09Dec05               *
007900210712      *                 BUG11240           Date 23May06               *
008000210712      *                 239836             Date 18May06               *
008100210712      *                 CLE106             Date 01Aug04               *
008200210712      *                 CLE033             Date 26Apr05               *
008300210712      *                 CLE031             Date 26Apr05               *
008400210712      *                 CDL038             Date 10May05               *
008500210712      *                 BUG7875            Date 17Aug05               *
008600210712      *                 CSW037A            Date 02May05               *
008700210712      *                 CDL028             Date 07Feb05               *
008800210712      *                 BUG6393            Date 31Mar05               *
008900210712      *                 BUG6010            Date 30Mar05               *
009000210712      *                 CDL036             Date 28Feb05               *
009100210712      *                 CSD025             Date 11Jan05               *
009200210712      *                 CSW037             Date 15Dec04               *
009300210712      *                 CSW036             Date 15Dec04               *
009400210712      *                 BUG4511            Date 16Oct04               *
009500210712      *                 BUG4490            Date 11Oct04               *
009600210712      *                 BUG4478            Date 05Oct04               *
009700210712      *                 CGL014             Date 20Oct03               *
009800210712      *                 CLE025             Date 20Oct03               *
009900210712      *                 CDL018             Date 03Feb04               *
010000210712      *                 CGL029             Date 01Sep03               *
010100210712      *                 207137             Date 05Jun03               *
010200210712      *                 214110             Date 19Feb03               *
010300210712      *                 CRE008             Date 19Feb02               *
010400210712      *                 219241             Date 01Jul03               *
010500210712      *                 CSW203             Date 26May03               *
010600210712      * Midas Release 4.01.03 ----------------------------------------*
010700210712      * Midas Release 4.01.02 ----------------------------------------*
010800210712      *                 196461             Date 22Apr02               *
010900210712      *                 197865             Date 07Mar02               *
011000210712      * Midas Release 4.01.01 ----------------------------------------*
011100210712      *                 CSW202             Date 20May02               *
011200210712      * Midas Release 4.01 -------------------------------------------*
011300210712      *                 CAP068             Date 01Mar02               *
011400210712      *                 196808             Date 25Oct01               *
011500210712      *                 194282             Date 15Oct01               *
011600210712      * Midas Release 4 --------------- Base -------------------------*
011700210712      *                 200400             Date 20Nov01               *
011800210712      *                 CSW201             Date 02May01               *
011900210712      *                 193584             Date 08Jun01               *
012000210712      * Midas DBA 3.05 -----------------------------------------------*
012100210712      *                 CUT009             Date 22Mar01               *
012200210712      *                 182652             Date 20Feb01               *
012300210712      *                 CUT009             Date 05Feb01               *
012400210712      *                 185751             Date 17Nov00               *
012500210712      *                 179510             Date 03Jul00               *
012600210712      *                 CIR003             Date 12Sep00               *
012700210712      * Midas DBA 3.04 -----------------------------------------------*
012800210712      *                 186433             Date 16Nov00               *
012900210712      *                 CDL008             Date 02May00               *
013000210712      *                 182114             Date 27Sep00               *
013100210712      * Midas DBA 3.03 -----------------------------------------------*
013200210712      *                 CSW200             DATE 21Aug00               *
013300210712      * Midas DBA 3.02 -----------------------------------------------*
013400210712      *                 CSW097             Date 02Dec99               *
013500210712      *                 166320             Date 23Sep99               *
013600210712      *                 167942             Date 21Sep99               *
013700210712      * Midas DBA 3.01 -----------------------------------------------*
013800210712      *                 164570             Date 16Jul99               *
013900210712      * Midas DBA 3.00 ---------------- Base -------------------------*
014000210712      *                 152344             DATE 05Jan98               *
014100210712      *                 CAP004             Date 07Sep98               *
014200210712      *                 CAP003             Date 03Jun98               *
014300210712      *                 136939             Date 10Jun98               *
014400210712      *                 CAP002  *CREATE    Date 01Nov97               *
014500210712      *                                                               *
014600210712      *---------------------------------------------------------------*
014700210712      *                                                               *
014800210712      *  CSW221   - SWIFT Changes 2021                                *
014900210712      *  MD051567 - ISDA Rules version must be a valid year starting  *
015000210712      *             with 199 or 20.                                   *
015100210712      *           - Applied for MD056763                              *
015200210712      *  MD056313 - Warning message is missing when inserting MM deal *
015300210712      *             with blocked settlement account                   *
015400210712      *  MD052922 - Settlement Payment Customer details blank on WIP  *
015500210712      *             during dummy amend and reverse (SETL API).        *
015600210712      *  MD022945 - Incorrect message shown for /SRCE/ validation.    *
015700210712      *  MD051877A - Highlighted field not correct                    *
015800210712      *  MD051877 - Incorrect mapping on error field                  *
015900210712      *  MD051932 - No validation when invalid rate is entered on     *
016000210712      *             exhange rate field of settlement tabs             *
016100210712      *  MD052228 - Overridable message Settlement account is         *
016200210712      *             Referred is not displayed after clicking          *
016300210712      *             complete button in MAPY.                          *
016400210712      *  MD034521A - Error handling of Blocked account is not the     *
016500210712      *              same across the modules                          *
016600210712      *  MD041649 - Validation during authorisation should be executed*
016700210712      *  MD051239 - [CDL051]- Validation errors for Settlement        *
016800210712      *             Payment during Authorization in WIP are not       *
016900210712      *             appearing for FXDL, DEAM and NASP APis.           *
017000210712      *  CDL051 - Incomplete Deals to Repair                          *
017100210712      *  CLE168 - Allow Debit of Blocked Account                      *
017200210712      *  MD046248 - Finastra Rebranding                               *
017300210712      *  MD046115 - The error messages for CDL094 were not properly   *
017400210712      *             formatted.                                        *
017500210712      *  MD036475 - System error in MR loan events. Check account for *
017600210712      *             both blocked debit/credit when CALP is MAPY.      *
017700210712      *  MD024884A - Incorrect Payment and Receipt accounts           *
017800210712      *  MD032089  - PSTM and PONS lost when amended via SOAP with    *
017900210712      *              auto AUTH = 'Y'. Error due to clear of received  *
018000210712      *              ##PAYF, ##PAYR and ##PRIF on *INZSR and will not *
018100210712      *              execute SR/PAYMNT.  Remove CLEAR on *INZSR.      *
018200210712      *              They will be cleared as needed on specific SRs.  *
018300210712      *  MD040199 - ISDA Agreement Version reflected incorrectly in   *
018400210712      *             MT reports and deals enquiry. Reverse MD-33870.   *
018500210712      *  MD039348 - Error message "Settlement Payments fields cannot  *
018600210712      *             be amended. (Field: Pay - Ordering Customer)" is  *
018700210712      *             displayed during amendment of maturity date of    *
018800210712      *             a valued deal. Prevent defaulting of settlement   *
018900210712      *             fields when already protected by the system.      *
019000210712      *  MD033870 - Wrong value for DDAGVV. Corrected MOVE and MOVEL. *
019100210712      *  AR892347 - Details of payment defaulting should only take    *
019200210712      *             place if an MT103 is to be generated: i.e. if     *
019300210712      *             ordering customer is present or if beneficiary    *
019400210712      *             is not a bank. (Child: AR892348)                  *
019500210712      *  MD030342 - Valid values for Agreement Type for FX and AT     *
019600210712      *             transaction types for MT600                       *
019700210712      *  MD029779 - Incorrect error message displayed for Sender-to-  *
019800210712      *             Receiver fields                                   *
019900210712      *  CSW214 - SWIFT Changes 2014                                  *
020000210712      *  CDL094 - Enhance  Receive Settlement Instructions            *
020100210712      *  254023 - EXSS - ISDA cannot be input as 2006.                *
020200210712      *  MD023833 - Save return code before calling CSFACT and        *
020300210712      *             restore after and reset ACCT after call to        *
020400210712      *             AOACCTV0                                          *
020500210712      *  MD022945 - Incorrect message shown for /SRCE/ validation.    *
020600210712      *  CSW213 - SWIFT Changes 2013                                  *
020700210712      *  MD020242 - Pay settlement of Parts Sold Loan in MAPY is      *
020800210712      *             returned as blank by ZASETINVAL on authorisation. *
020900210712      *             Call PAYMNT for MAPY when action is X and ##PPAY  *
021000210712      *             is ' '.                                           *
021100210712      *  MD021526 - System allowed inserting a deal with closed       *
021200210712      *             settlement accounts. Reversed fix AR1096686 as    *
021300210712      *             the validation should prevent this and display    *
021400210712      *             error message instead of warning message.         *
021500210712      *  MD020816 - Cannot authorize a loan transaction when Receipt  *
021600210712      *             Settlement currency is different from transaction *
021700210712      *             currency.  Error message "Receipt Settlement Cur- *
021800210712      *             rency is not a valid dealing currency" is being   *
021900210712      *             displayed upon pressing the Authorise button      *
022000210712      *  MD000091 - Event Codes Substitution                          *
022100210712      *  AR1096686 - LDNI does not allow closed account in Pay-Our    *
022200210712      *              Account and Receipt-Our Account fields. Warning  *
022300210712      *              is expected instead of Error.                    *
022400210712      *  CMG003    - SWIFT MT600 Message Generation                   *
022500210712      *  AR1039735 - Message type not defined before call of ME9950   *
022600210712      *  AR1005230 - Error on cross ccy settlement of a Manual        *
022700210712      *              Repayment on a Loan (Child:AR1005231)            *
022800210712      *  AR853046 - CLE031: System is not allowing to set Settlement  *
022900210712      *             currency in MR.                                   *
023000210712      *             Inclusion of ##CALP='MAPY' on CLE031 validations. *
023100210712      *             (Child: AR853047)                                 *
023200210712      *  AR641619 - Defaulting of receipt/pay settlement should be    *
023300210712      *             done during insert only. Settlement fields not    *
023400210712      *             amendable should not be validated anymore.        *
023500210712      *             Pattern to fix AR375187.                          *
023600210712      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
023700210712      *  AR1000515 - 'DERV' must be accepted as a valid ISDA          *
023800210712      *              Agreement Type                                   *
023900210712      *  CSW212 - SWIFT 2012 Changes                                  *
024000210712      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
024100210712      *  AR863960 - Settlement Payment fields values are reset to     *
024200210712      *             blanks                                            *
024300210712      *  AR787620 - Hooks Incorporation                               *
024400210712      *             WNCPYSRC,ZAH00004                                 *
024500210712      *             WNCPYSRC,ZAH00005                                 *
024600210712      *  260863 - Skip Validation for closed Nostro Account and       *
024700210712      *           Blocked Debit/Credit.                               *
024800210712      *  260428 - For MM deals, skip validation for on receipt side / *
024900210712      *           pay side if accounting has taken place in the past  *
025000210712      *  256564 - Recompile due to PF changes done by fix 256330      *
025100210712      *  BUG14913 - MT103 was not generated for Loans Input           *
025200210712      *  248393 - If settlement type is 14, allow only a 10 digit     *
025300210712      *           retail account number (ie position 11-18 of RONS or *
025400210712      *           PONS should be blank otherwise send error message). *
025500210712      *  246120 - Default settlement receipt for loan/parts purchased *
025600210712      *           and settlement payment for part sold.               *
025700210712      *  244636 - Modify check of payment settlement protection       *
025800210712      *  244370 - Default pay and receipt details during reversal of  *
025900210712      *           manual repayment.                                   *
026000210712      *  217715 - Wrong defaulting of Ordering Customer.              *
026100210712      *           Applied 215211 that is annotated as 239836.         *
026200210712      *  238721 - Do not default details of charges if both ordering  *
026300210712      *           customer and beneficiary are SWIFT fin inst.        *
026400210712      *  BUG12624 - Validation error on Pay/Rec-Our Account for       *
026500210712      *              Settlement 05.                                   *
026600210712      *  BUG12540 - fix 182652 validates regardless of Fed Funds'     *
026700210712      *             value.                                            *
026800210712      *  239587 - For MAPY, only pay or receive details necessary,    *
026900210712      *           therefore don't need to validate that pay and       *
027000210712      *           receive currencies are the same.                    *
027100210712      *  CSD027 - Conversion Of Customer Number to Alpha              *
027200210712      *  BUG11240 - Unable to Authorise and/or Reject newly inserted  *
027300210712      *             Manual Repayment, error msg LEM0102 displayed.    *
027400210712      *  239836 - Validation of ordering bank field should consider   *
027500210712      *           BBSWFI and not BBBNBI anymore. Apply 215211.        *
027600210712      *  CLE106 - Syndications manager.                               *
027700210712      *  CLE033 - Settlement method 09                                *
027800210712      *  CLE031 - Lending Enhancements - Settlement Currency          *
027900210712      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
028000210712      *  BUG7875 - Loan input - Settlement payment misleading error   *
028100210712      *            message.                                           *
028200210712      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
028300210712      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
028400210712      *  BUG6393- When defaulting ACSQ pass back to front end         *
028500210712      *  BUG6010 - Allow Amendment of the value date settlement if    *
028600210712      *            the loan has passed value date.  Display Warning   *
028700210712      *            message instead of an error message.               *
028800210712      *  CDL036 - Prevent Trade input if CLS SSI missing              *
028900210712      *  CSD025 - Customer De-Activation                              *
029000210712      *  CSW037 - Additional Field Data on MT300/MT320                *
029100210712      *  CSW036 - Dual SWIFT BIC held on Client Details               *
029200210712      *  BUG4511 - Don't default Details of Charges for MT202 message *
029300210712      *           (field @OBNBI should be populated)                  *
029400210712      *  BUG4490 - Don't default Pay Ordering Customer if Pay         *
029500210712      *            Ordering Bank is entered (and vice-versa)          *
029600210712      *  BUG4478- Keep the warnings from previously called            *
029700210712      *           modules.                                            *
029800210712      *  CGL014 - Collaterals Processing                              *
029900210712      *  CLE025 - Credit Lines (Recompile)                            *
030000210712      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
030100210712      *  CGL029 - Increase Account Code to 10 digits                  *
030200210712      *  207137 - Do not validate pay settlement account when pay     *
030300210712      *           side is protected as it has already valued.         *
030400210712      *  214110 - Allow 'SHA' code on details of charges field and    *
030500210712      *           ensure that allowed values are validated correctly. *
030600210712      *  CRE008 - Cash Management                                     *
030700210712      *  219241 - Defaulting of "Details of Charges" assign a         *
030800210712      *           system value                                        *
030900210712      *  CSW203 - SWIFT 2003 Standards Update                         *
031000210712      *  196461 - Validation of settlement shall not be done when     *
031100210712      *           Receipt and/or Payment are protected.               *
031200210712      *  197865 - Pay Ordering Customer cannot be blanked out.        *
031300210712      *  CSW202 - SWIFT 2002 Standards Update                         *
031400210712      *  CAP068 - Enable Lending APIs to call this instead of SD2410  *
031500210712      *  196808 - Corrected the validation of settlement currency when*
031600210712      *           calling program is DEAM.                            *
031700210712      *  194282 - ESM0918 keeps on coming out if ordering bank is not *
031800210712      *           flag as SWIFT financial institution even if method  *
031900210712      *           01 is used.                                         *
032000210712      *  200400 - Reverse fix 179510                                  *
032100210712      *  CSW201 - SWIFT 2001 Standards Update                         *
032200210712      *  193584 - When the nostro is a CLS Dummy nostro,              *
032300210712      *           entry should not be allowed in :                    *
032400210712      *           the Account detail line for fields 56 and 57.       *
032500210712      *  CUT009 - Core hooks added manually.                          *
032600210712      *  182652 - Corrected the validation of Intermediary Bank line  *
032700210712      *           and Account with bank line.                         *
032800210712      *           They do not have to be mandatory or '//FW'' if      *
032900210712      *           Fed Funds is 'Y'.                                   *
033000210712      *  CUT009 - Core hooks added manually.                          *
033100210712      *  185751 - Addition of the action code parameter.              *
033200210712      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
033300210712      *           Midas our Receive/Pay instructions  respectively  not
033400210712      *           correctly  updated .  Introduced  new  Data Structure
033500210712      *           @MORPI  which is used  for that purpose .           *
033600210712      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
033700210712      *  186433 - Fix 166888 caused non-default of Ordering bank/     *
033800210712      *           customer and Beneficiary when SSIs are amended      *
033900210712      *           (after initially defaulted by system) but said      *
034000210712      *           fields have been left blank by the user             *
034100210712      *  CDL008 - Continuous Linked Settlement                        *
034200210712      *  182114 - Message 'Settlement Account is Blocked' is appearing*
034300210712      *           if either credits or debits are blocked, the type   *
034400210712      *           that is blocked may not be applicable. VLPONS should*
034500210712      *           check credits and VLRONS should check debits.       *
034600210712      *           System does not check for Blocked Retail Accounts.  *
034700210712      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
034800210712      *           to defaulted value all the time. Apply GEMS 163745  *
034900210712      *           However, 163745 only fixes the problem for 'A' and  *
035000210712      *           'X' processing. Problem still exists for insert.    *
035100210712      *           Need to default only the 1st time validation is     *
035200210712      *           done. Do not re-default for subsequent validations. *
035300210712      *           Due to this 163745 in its original form is no       *
035400210712      *           longer required, now default required only for      *
035500210712      *           'first time insert'.                                *
035600210712      *  CSW200 - SWIFT 2000 Changes                                  *
035700210712      *  CSW097 - Swift 97 Changes for MT360s and MT340s              *
035800210712      *  166320 - When checking if bank/non-bank, field BBSWFI        *
035900210712      *           (SWIFT financial institution) should be checked.    *
036000210712      *  167942 - Do not default pay ordering bank to a BICN.         *
036100210712      *  164570 - Initialize FRA/IRS extended instructions if         *
036200210712      *           switchable features CSW005/CSW011 are off           *
036300210712      *  152344 - Invalid pay/receipt settlement currencies accepted  *
036400210712      *  CAP004 - API's Phase 3.                                      *
036500210712      *           Allow A/c with Bank = Beneficiary                   *
036600210712      *           Extra defaulting for telex.                         *
036700210712      *           Do not treat CIRS same as FRAs (should be similar   *
036800210712      *           to FX).                                             *
036900210712      *  CAP003 - Phase II of Midas API conversions                   *
037000210712      *  136939 - Remove back-valuation check for EMU                 *
037100210712      *  CAP002 - Conversion of Midas inputs to modular API structure *
037200210712      *                                                               *
037300210712      *****************************************************************
037400210712     FDLDLDGLE  IF   E           K DISK    INFSR(SRERR)                                       CGL014
037500210712     F                                     PREFIX(P_)                                         CGL014
037600210712     FDLGXSTL0  IF   E           K DISK    INFSR(SRERR) USROPN                                CGL014
037700210712     F                                     PREFIX(P_)                                         CGL014
037800210712     FSDCUSTL7  IF   E           K DISK    INFSR(SRERR)                                       CDL094
037900210712     F                                     PREFIX(C_)                                         CDL094
038000210712     F/COPY WNCPYSRC,ZAH00010
038100210712      /EJECT
038200210712      *****************************************************************
038300210712     C/COPY WNCPYSRC,ZASETINVF1
038400210712
038500210712      ** +--------------------------------------+
038600210712      ** ¦ Automatically included D-specs       ¦
038700210712      ** ¦ ==============================       ¦
038800210712      ** +--------------------------------------+
038900210712      **
039000210712      ** Standard D-specs
039100210712      ** ================
039200210712      **
039300210712      ** The following /COPY line includes the LDA layout,
039400210712      ** the copyright array definition,
039500210712      ** and the following named constants:
039600210712      **    True       logical = *on (for indcator processing)
039700210712      **    False      logical = *off (for indcator processing)
039800210712      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
039900210712      **                                    handler)
040000210712      ** and the following variables:
040100210712      **    RunBefore  1A (for the PSSR)
040200210712
040300210712     D/COPY ZACPYSRC,STD_D_SPEC
040400210712
040500210712      **------------------------------------------------------------------------CAP003--------------
040600210712      ** The following /COPY line includes all the defined fields in the        CAP003
040700210712      ** Program Status Data Structures.  They have meaningful                  CAP003
040800210712      ** names, prefixed by 'PS'.                                               CAP003
040900210712     D/COPY ZACPYSRC,PSDS                                                       CAP003
041000210712      **------------------------------------------------------------------------CAP003--------------
041100210712                                                                                CAP003
041200210712      **--------------------------------------------------------------------------------------------
041300210712      ** The following /COPY line includes the definitions for error and
041400210712      ** warning message arrays.
041500210712     D/COPY ZACPYSRC,ERR_ARRAYS
041600210712      **--------------------------------------------------------------------------------------------
041700210712
041800210712      ** +--------------------------------------+
041900210712      ** ¦ End of automatically included D-specs¦
042000210712      ** ¦ =====================================¦
042100210712      ** +--------------------------------------+
042200210712
042300210712      *****************************************************************
042400210712      /EJECT
042500210712      *****************************************************************
042600210712
042700210712      ** +--------------------------------------+
042800210712      ** ¦ Manually included D-specs            ¦
042900210712      ** ¦ =========================            ¦
043000210712      ** +--------------------------------------+
043100210712                                                                                              CGL029
043200210712     D @ACCD           S             10                                                       CGL029
043300210712     D DDRONS          S             18                                                       CGL029
043400210712     D DDPONS          S             18                                                       CGL029
043500210712
043600210712      ** +--------------------------------------+
043700210712      ** ¦ Named constants                      ¦
043800210712      ** ¦ ===============                      ¦
043900210712      ** +--------------------------------------+
044000210712
044100210712     D/COPY WNCPYSRC,ZASETNVD01
044200210712      ** +--------------------------------------+
044300210712      ** ¦ Arrays and Data Structures           ¦
044400210712      ** ¦ ==========================           ¦
044500210712      ** +--------------------------------------+
044600210712
044700210712     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
044800210712      ** EXTERNAL DS FOR COUNTERPARTY NOSTRO DETAILS
044900210712      *
045000210712     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
045100210712      * DATA STRUCTURE FOR CUSTOMER DETAILS
045200210712      *
045300210712     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
045400210712      ** EXTERNAL DS FOR NOSTRO DETAILS
045500210712      *
045600210712     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
045700210712     D SDTRACCD      E                     EXTFLD(QQACCD)                                     CGL029
045800210712      ** EXTERNAL DS FOR TRADING DETAILS
045900210712      *
046000210712     D ACCT          E DS                  EXTNAME(ACCNTAB)
046100210712      ** EXTERNAL DS FOR ACCOUNT DETAILS
046200210712      *
046300210712     D SDBANK        E DS                  EXTNAME(SDBANKPD)
046400210712      ** EXTERNAL DS FOR BANK DETAILS
046500210712      *
046600210712     D SDGELR        E DS                  EXTNAME(SDGELRPD)
046700210712     D SDGEACCD      E                     EXTFLD(QQACCD)                                     CGL029
046800210712      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
046900210712      *
047000210712     D SDRETL        E DS                  EXTNAME(SDRETLPD)
047100210712     D SDREACCD      E                     EXTFLD(QQACCD)                                     CGL029
047200210712      ** EXTERNAL DS FOR RETAIL DETAILS
047300210712      *
047400210712     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
047500210712      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
047600210712      *
047700210712     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
047800210712     D SDBRDFAC      E                     EXTFLD(QQDFAC)                                     CGL029
047900210712      ** EXTERNAL DS FOR BRANCH DETAILS
048000210712      *
048100210712     D SDCURR        E DS                  EXTNAME(SDCURRPD)
048200210712      ** EXTERNAL DS FOR CURRENCY DETAILS
048300210712      *
048400210712     D DSSDY         E DS                  EXTNAME(DSSDY)
048500210712      ** EXTERNAL DS FOR LONG DUMMY DATA STRUCTURE
048600210712      *
048700210712     D DSFDY         E DS                  EXTNAME(DSFDY)
048800210712      ** EXTERNAL DS FOR SHORT DUMMY DATA STRUCTURE
048900210712                                                                                              219241
049000210712     D SDMGME        E DS                  EXTNAME(SDMGMEPD)                                  219241
049100210712      ** External DS for Midas Message Management ICD                                         219241
049200210712                                                                                              CLE033
049300210712     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  CLE033
049400210712     D SDACACCD      E                     EXTFLD(QQACCD)                                     CLE033
049500210712      ** External DS for Account Codes                                                        CLE033
049600210712      *
049700210712     D ##RECF        E DS                  EXTNAME(SDESFRPD)
049800210712      * FILE RECEIVE INSTRUCTIONS
049900210712      *
050000210712     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
050100210712      * FILE PAYMENT INSTRUCTIONS
050200210712      *
050300210712     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
050400210712      **FILE*FRA/IRS*INSTRUCTIONS**************************************                       CSW212
050500210712      * FILE EXTENDED SETTLEMENT INSTRUCTIONS                                                 CSW212
050600210712      *
050700210712     D ##RECS        E DS                  EXTNAME(SDESSRPD)
050800210712      * SCREEN RECEIVE INSTRUCTIONS
050900210712      *
051000210712     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
051100210712      * SCREEN PAYMENT INSTRUCTIONS
051200210712      *
051300210712     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
051400210712      **SCREEN*FRA/IRS*INSTRUCTIONS************************************                       CSW212
051500210712      * SCREEN EXTENDED SETTLEMENT INSTRUCTIONS                                               CSW212
051600210712      *
051700210712     D*@MORPI*****     DS                                                              179510 200400
051800210712      ***Midas*Our Receive / Pay  Instructions (for Sett Meth = 04 )                   179510 200400
051900210712     D**@@MORI****             1     12                                                179510 200400
052000210712     D**@@MOPI****            13     24                                                179510 200400
052100210712      ************                                                                     179510 200400
052200210712     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
052300210712     D  WLCD         E                     EXTFLD(LCD)                          CDL008
052400210712      ** External DS for SAR Details                                            CDL008
052500210712      *                                                                         CDL008
052600210712     D DLUFBO        E DS                  EXTNAME(DLUFBOPD) DTAARA                           CGL014
052700210712     D LEFCLY        E DS                  EXTNAME(LEFCLYPP) DTAARA                           CLE168
052800210712     D                                     PREFIX(A_)                                         CLE168
052900210712
053000210712      ** Array containing Copyright statement                                                 CLE033
053100210712     D SVAL            S             80    DIM(4) CTDATA PERRCD(1)                            CLE033
053200210712                                                                                              CLE033
053300210712      ** +--------------------------------------+
053400210712      ** ¦ Declared variables                   ¦
053500210712      ** ¦ ==================                   ¦
053600210712      ** +--------------------------------------+
053700210712
053800210712      ** Index for arrays of of error message ids etc
053900210712     D Idx             S              3P 0
054000210712                                                                                              219241
054100210712      ** flag to indicate if CFT013 is installed                                              219241
054200210712     D CFT013          S              1A                                                      219241
054300210712     D/COPY WNCPYSRC,ZAH00044
054400210712
054500210712      * FLAGS TO INDICATE WHETHER RECEIVE INSTRUCTIONS ARE OK
054600210712     D OKReceive       DS
054700210712     D  DDRscyOK                      1A
054800210712     D  DDRstmOK                      1A
054900210712     D  DDRonxOK                      1A
055000210712     D  DDRocnOK                      1A
055100210712     D  DDRobnOK                      1A
055200210712     D  DDRibnOK                      1A
055300210712     D  DDRibaOK                      1A
055400210712     D  DDRmacOK                      1A                                                      CDL018
055500210712     D  DDRexrOK                      1A                                                      CLE031
055600210712     D  DDRexiOK                      1A                                                      CLE031
055700210712     D  DDRbb1OK                      1A                                                      CDL094
055800210712     D  DDRbb2OK                      1A                                                      CDL094
055900210712     D  DDRbb3OK                      1A                                                      CDL094
056000210712     D  DDRbb4OK                      1A                                                      CDL094
056100210712     D  DDRbb5OK                      1A                                                      CDL094
056200210712     D  DDRbb6OK                      1A                                                      CDL094
056300210712      *
056400210712      * FLAGS TO INDICATE WHETHER PAYMENT INSTRUCTIONS ARE OK
056500210712     D OKPayment       DS
056600210712     D  DDPscyOK                      1A
056700210712     D  DDPstmOK                      1A
056800210712     D  DDPonxOK                      1A
056900210712     D  DDRvnoOK                      1A
057000210712     D  DDCvmrOK                      1A
057100210712     D  DDPocnOK                      1A
057200210712     D  DDPobnOK                      1A
057300210712     D  DDRcrnOK                      1A
057400210712     D  DDRcraOK                      1A
057500210712     D  DDPibnOK                      1A
057600210712     D  DDPibaOK                      1A
057700210712     D  DDAwbnOK                      1A
057800210712     D  DDAwbaOK                      1A
057900210712     D  DDBennOK                      1A
058000210712     D  DDBenaOK                      1A
058100210712     D  DDDtp1OK                      1A
058200210712     D  DDDtp2OK                      1A
058300210712     D  DDDtp3OK                      1A
058400210712     D  DDDtp4OK                      1A
058500210712     D  DDDchgOK                      1A
058600210712     D  DDIc72OK                      1A
058700210712     D  DDBtb1OK                      1A
058800210712     D  DDBtb2OK                      1A
058900210712     D  DDBtb3OK                      1A
059000210712     D  DDBtb4OK                      1A
059100210712     D  DDBtb5OK                      1A
059200210712     D  DDBtb6OK                      1A
059300210712     D  DDPmacOK                      1A                                                      CDL018
059400210712     D  DDPexrOK                      1A                                                      CLE031
059500210712     D  DDPexiOK                      1A                                                      CLE031
059600210712      *
059700210712      **FLAGS*TO*INDICATE*WHETHER*FRA/IRS*INSTRUCTIONS*ARE*OK**********                       CSW212
059800210712      * FLAGS TO INDICATE WHETHER EXTENDED SETTLEMENT INSTRUCTIONS ARE OK                     CSW212
059900210712     D OKFRAIRS        DS
060000210712     D  DDDsr1OK                      1A
060100210712     D  DDDsr2OK                      1A
060200210712     D  DDDsr3OK                      1A
060300210712     D  DDDsr4OK                      1A
060400210712     D  DDDsr5OK                      1A
060500210712     D  DDDsr6OK                      1A
060600210712     D  DDSsr1OK                      1A
060700210712     D  DDSsr2OK                      1A
060800210712     D  DDSsr3OK                      1A
060900210712     D  DDSsr4OK                      1A
061000210712     D  DDSsr5OK                      1A
061100210712     D  DDSsr6OK                      1A
061200210712     D  DDCnd1OK                      1A
061300210712     D  DDCnd2OK                      1A
061400210712     D  DDCnd3OK                      1A
061500210712     D  DDCnd4OK                      1A
061600210712     D  DDCnd5OK                      1A
061700210712     D  DDCnd6OK                      1A
061800210712     D  DDIsdaOK                      1A
061900210712     D  DDAgtyOK                      1A
062000210712     D  DDAgdtOK                      1A
062100210712     D  DDAgvvOK                      1A
062200210712      *
062300210712     D RUNDAT          DS
062400210712     D/COPY WNCPYSRC,ZASETNVD02
062500210712      ** DATA STRUCTURE FOR MULTIBRANCH INDICATOR USING RUNDAT.
062600210712     D  @MBIN                 13     13
062700210712      *
062800210712     D/COPY WNCPYSRC,ZASETNVD04
062900210712      * OUR ACCOUNT
063000210712      *
063100210712     D                 DS
063200210712     D***A#OURA*                1     12                                                      CGL029
063300210712     D  A#OURA                 1     18                                                       CGL029
063400210712     D  A#NOST                 1      2
063500210712     D  A#CNUM                 1      6
063600210712     D  A#RENO                 1     10
063700210712     D***A#ACOD*                7     10                                                      CGL029
063800210712     D***A#ACAS*                7     12                                                      CGL029
063900210712     D***A#ACSQ*               11     12                                                      CGL029
064000210712     D***A#REST*                3     12                                                      CGL029
064100210712     D  A#ACOD                 7     16                                                       CGL029
064200210712     D  A#ACAS                 7     18                                                       CGL029
064300210712     D  A#ACSQ                17     18                                                       CGL029
064400210712     D  A#REST                 3     18                                                       CGL029
064500210712     D  A#RES2                11     18                                                       248393
064600210712      *
064700210712      * A/C LINE
064800210712      *
064900210712     D                 DS
065000210712     D  L#XIBA                 1     35
065100210712     D  L#RCR2                 1      2
065200210712     D  L#XIB1                 1      1
065300210712     D  L#XIB2                 2      2
065400210712     D  L#XIBE                 3      3
065500210712     D                 DS
065600210712      ** Data structure for use in checking whether Account With field is
065700210712      ** a Nostro Number.
065800210712     D  W#AWBN                 1     10
065900210712     D  W#AW                   1     10
066000210712     D                                     DIM(10) ASCEND
066100210712     D  W#NOST                 1      2
066200210712     D  W#REST                 3     10
066300210712      *
066400210712      * Input Parameters
066500210712      *
066600210712     D***I#PARM*         DS           512                                                     CGL029
066700210712     D I#PARM          DS           514                                                       CGL029
066800210712      * Field to be validated
066900210712     D  I#VFLD                 1      5
067000210712      * Pay/Receive Settlement (PAY/REC)
067100210712     D  I#PR                   6      8
067200210712      * Customer/Counterparty Nostro /BIC indentified type
067300210712      *    C           X              S  X-> C'party Nostro or Customer
067400210712      * Customer/Counterparty/BIC indentified
067500210712     D  I#PRTT                 9      9
067600210712     D  I#PRTY                10     20
067700210712      * Pay Currency
067800210712     D  I#PCCY                21     23
067900210712      * Receive Currency
068000210712     D  I#RCCY                24     26
068100210712      * Account Line
068200210712     D  I#ACLN                27     61
068300210712      * Account Line Character 1
068400210712     D  I#ACC1                27     27
068500210712      * Account Line Character 2
068600210712     D  I#ACC2                28     28
068700210712      * Account Line Character 3
068800210712     D  I#ACC3                29     29
068900210712      * Account Line first 4 characters
069000210712     D  I#ACCL                27     30
069100210712      * Account Line Clearing System
069200210712     D  I#ACCS                29     30
069300210712      * Account Line No account data
069400210712     D  I#SPC1                31     61
069500210712      * Message Type
069600210712     D  I#MTYP                62     64
069700210712      * Intermediary Institution for Bank to Bank validation
069800210712     D  I#INBT                65     65
069900210712     D  I#INBK                66     76
070000210712      * Account with Institution for Bank to Bank validation
070100210712     D  I#AWBT                77     77
070200210712     D  I#AWBK                78     88
070300210712      * Beneficiary for Bank to Bank validation
070400210712     D  I#BENT                89     89
070500210712     D  I#BENF                90    100
070600210712      * Pay and Receive Settlement Methods
070700210712     D  I#RSTM               101    102
070800210712     D  I#PSTM               103    104
070900210712      * Field 53 and 54 Entered
071000210712     D  I#5354               105    105
071100210712      * Midas Module
071200210712     D  I#MMOD               106    107
071300210712      * Pay and Receive Settlement Accounts
071400210712     D***I#PYAC*              108    125                                                      CGL029
071500210712     D***I#RCAC*              126    143                                                      CGL029
071600210712     D  I#PYACQQ             108    125                                                       CGL029
071700210712     D  I#RCACQQ             126    143                                                       CGL029
071800210712      * Transaction Type
071900210712     D  I#TTYP               144    145
072000210712      * Cover required
072100210712     D  I#COVR               146    146
072200210712      * Bank to Bank Information
072300210712     D  I#BTB                257    466
072400210712     D  I#BTB1               257    291
072500210712     D  I#BTB2               292    326
072600210712     D  I#BTB3               327    361
072700210712     D  I#BTB4               362    396
072800210712     D  I#BTB5               397    431
072900210712     D  I#BTB6               432    466
073000210712      *
073100210712     D  I#PYAC               467    490                                                       CGL029
073200210712     D  I#RCAC               491    514                                                       CGL029
073300210712      *
073400210712      * Output Parameters
073500210712      *
073600210712     D***O#PARM*         DS           512                                                     CGL029
073700210712     D O#PARM          DS           514                                                       CGL029
073800210712      * Account Line modified
073900210712     D  O#ACLN                 1     35
074000210712      * Bank to Bank Information
074100210712     D  O#BTB                257    466
074200210712     D  O#BTB1               257    291
074300210712     D  O#BTB2               292    326
074400210712     D  O#BTB3               327    361
074500210712     D  O#BTB4               362    396
074600210712     D  O#BTB5               397    431
074700210712     D  O#BTB6               432    466
074800210712      *
074900210712      * Error Parameters
075000210712      *
075100210712     D E#PARM          DS           256
075200210712      * Calling Program
075300210712     D  E#CPGM                 1     10
075400210712      * Error message sent
075500210712     D  E#ERRM                12     12
075600210712      * Warning message sent
075700210712     D  E#WARN                13     13
075800210712      * Error index
075900210712     D  E#INDX                14     18  0
076000210712      * Message text to prefix error message
076100210712     D  E#MSGD                19     25
076200210712     D  E#MSGF                26     35
076300210712      * Error codes array
076400210712     D  E#ERCD                51    200
076500210712     D  O#E                   51    200
076600210712     D                                     DIM(50)                              Return Error code
076700210712      *
076800210712     D                 DS
076900210712     D  W#AGDR                 1      6
077000210712     D  W#YYR                  1      2  0
077100210712     D  W#MMR                  3      4  0
077200210712     D  W#DDR                  5      6  0
077300210712     D                 DS
077400210712     D  W#AGDT                 1      6
077500210712     D  W#DD                   1      2  0
077600210712     D  W#MM                   3      4  0
077700210712     D  W#YY                   5      6  0
077800210712                                                                                              CSW203
077900210712      ** Flag to indicate if CSW203 is installed                                              CSW203
078000210712     D CSW203          S              1                                                       CSW203
078100210712     D PRTCD           S              7                                                       CSW203
078200210712                                                                                              CSW203
078300210712                                                                                              CRE008
078400210712     D CRE008          S              1                                                       CRE008
078500210712                                                                                              CRE008
078600210712      ** Parameters for RE101901                                                              CRE008
078700210712     D PRetCode        S              7                                                       CRE008
078800210712     D PInBranch       S              3                                                       CRE008
078900210712     D*PInCust**       S              6  0                                             CRE008 CSD027
079000210712     D PInCust         S              6                                                       CSD027
079100210712     D PInCurr         S              3                                                       CRE008
079200210712     D***PInACode        S              4  0                                           CRE008 CGL029
079300210712     D PInACode        S             10  0                                                    CGL029
079400210712     D PInASeqN        S              2  0                                                    CRE008
079500210712     D PDebAmnt        S             15  0                                                    CRE008
079600210712     D POutBranch      S              3                                                       CRE008
079700210712     D*POutCust*       S              6  0                                             CRE008 CSD027
079800210712     D POutCust        S              6                                                       CSD027
079900210712     D POutCurr        S              3                                                       CRE008
080000210712     D***POutACode       S              4  0                                           CRE008 CGL029
080100210712     D POutACode       S             10  0                                                    CGL029
080200210712     D POutASeqN       S              2  0                                                    CRE008
080300210712     D POutRetNo       S             10  0                                                    CRE008
080400210712                                                                                              CRE008
080500210712     D WFldNameArr     S             10    DIM(75)                                            CRE008
080600210712     D*WkCust***       S              6  0                                             CRE008 CSD027
080700210712     D WkCust          S              6                                                       CSD027
080800210712     D WkCcy           S              3                                                       CRE008
080900210712     D***WkACOD*         S              4  0                                           CRE008 CGL029
081000210712     D WkACOD          S             10  0                                                    CGL029
081100210712     D WkASEQ          S              2  0                                                    CRE008
081200210712     D WkBRCA          S              3                                                       CRE008
081300210712     D WkCustA         S              6                                                       CRE008
081400210712     D***WkACodeA        S              4                                              CRE008 CGL029
081500210712     D WkACodeA        S             10                                                       CGL029
081600210712     D WkASeqNA        S              2                                                       CRE008
081700210712     D WkRetNoA        S             10                                                       CRE008
081800210712     D WIdx            S              3  0                                                    CRE008
081900210712                                                                                              CGL014
082000210712     D PAmount         S             15  0                                                    CGL014
082100210712     D PTCCY           S              3                                                       CGL014
082200210712     D PBranch         S              3                                                       CGL014
082300210712     D PCustNo         S              6                                                       CGL014
082400210712     D PCurr           S              3                                                       CGL014
082500210712     D PActCode        S             10                                                       CGL014
082600210712     D PAcSeq          S              2                                                       CGL014
082700210712     D PRetail         S             10  0                                                    CGL014
082800210712     D WRcCust         S              6                                                       CGL014
082900210712     D WRcCcy          S              3                                                       CGL014
083000210712     D WRcACOD         S             10                                                       CGL014
083100210712     D WRcASEQ         S              2                                                       CGL014
083200210712     D WRcBRCA         S              3                                                       CGL014
083300210712     D WRcRetail       S             10  0                                                    CGL014
083400210712     D WPyCust         S              6                                                       CGL014
083500210712     D WPyCcy          S              3                                                       CGL014
083600210712     D WPyACOD         S             10                                                       CGL014
083700210712     D WPyASEQ         S              2                                                       CGL014
083800210712     D WPyBRCA         S              3                                                       CGL014
083900210712     D WPyRetail       S             10  0                                                    CGL014
084000210712     D CGL014          S              1                                                       CGL014
084100210712     D WPRInd          S              1                                                       CGL014
084200210712     D WDiff           S             13  0                                                    CGL014
084300210712     D WCurAmt         S             13  0                                                    CGL014
084400210712     D WPrvAmt         S             13  0                                                    CGL014
084500210712     D KDLNO           S              6  0                                                    CGL014
084600210712     D KEDCD           S              3                                                       CGL014
084700210712     D SETTF           S              1    INZ('N')                                          CSF011A
084800210712     D W@TYPE          S              4    INZ(*BLANKS)                                      CSF011A
084900210712                                                                                             CSF011A
085000210712      **                                                                                    MD000091
085100210712     D BChar           DS                                                                   MD000091
085200210712     D   BLen                  1      2B 0                                                  MD000091
085300210712     D   LenStr                1      2                                                     MD000091
085400210712     D   MsgDtaTmp                   99                                                     MD000091
085500210712                                                                                              CGL014
085600210712      ** Flag to indicate if CMG003 is installed                                              CMG003
085700210712     D CMG003          S              1A                                                      CMG003
085800210712                                                                                              CMG003
085900210712      ** Workfields for CMG003                                                                CMG003
086000210712     D WPayPMRT        S                   LIKE(A6PMRT)                                       CMG003
086100210712     D WRecPMRT        S                   LIKE(A6PMRT)                                       CMG003
086200210712                                                                                              CMG003
086300210712     D CSW214          S              1A                                                      CSW214
086400210712      *                                                                                       CSW221
086500210712      ** SWIFT 2021 Paremeters                                                                CSW221
086600210712     D CSW221          S              1A                                                      CSW221
086700210712     D PSWIFT          S              6A                                                      CSW221
086800210712      *                                                                                       CSW221
086900210712      ** Return Code                                                                          CSW221
087000210712     D PMReturnCode    S              7A                                                      CSW221
087100210712     D/COPY WNCPYSRC,ZASETNVD03
087200210712      /EJECT
087300210712     C*******************************************************************
087400210712     C*  MAIN PROCESSING
087500210712     C*******************************************************************
087600210712      *
087700210712      ** INITIAL PROCESSING
087800210712      *
087900210712     C                   EXSR      SRINIT
088000210712      *
088100210712      ** DO RECEIVE SIDE DEFAULTING FOR SETTLEMENT METHOD 01, 07, 08
088200210712      *
088300210712     C     DDRSTM        IFEQ      '01'
088400210712     C     ##ACCD        ANDEQ     'I'                                                        166888
088500210712     C     ##ValIter     ANDEQ     '1ST'                                                      166888
088600210712     C     DDRSTM        OREQ      '01'                                                       186433
088700210712     C     ##ACCD        ANDEQ     'A'                                                        186433
088800210712     C     ##ValIter     ANDEQ     '1ST'                                                      186433
088900210712     C     ##PREC        ANDNE     'Y'                                                      MD039348
089000210712     C     DDRSTM        OREQ      '07'
089100210712     C     ##ACCD        ANDEQ     'I'                                                        166888
089200210712     C     ##ValIter     ANDEQ     '1ST'                                                      166888
089300210712     C     DDRSTM        OREQ      '07'                                                       186433
089400210712     C     ##ACCD        ANDEQ     'A'                                                        186433
089500210712     C     ##ValIter     ANDEQ     '1ST'                                                      186433
089600210712     C     ##PREC        ANDNE     'Y'                                                      MD039348
089700210712     C     DDRSTM        OREQ      '08'
089800210712     C     ##ACCD        ANDEQ     'I'                                                        166888
089900210712     C     ##ValIter     ANDEQ     '1ST'                                                      166888
090000210712     C     DDRSTM        OREQ      '08'                                                       186433
090100210712     C     ##ACCD        ANDEQ     'A'                                                        186433
090200210712     C     ##ValIter     ANDEQ     '1ST'                                                      186433
090300210712     C     ##PREC        ANDNE     'Y'                                                      MD039348
090400210712     C                   EXSR      DEFREC
090500210712     C                   END
090600210712      *
090700210712      ** DO PAYMENT SIDE DEFAULTING FOR SETTLEMENT METHOD 01, 07, 08
090800210712      *
090900210712     C     DDPSTM        IFEQ      '01'
091000210712     C     ##ACCD        ANDEQ     'I'                                                        166888
091100210712     C     ##ValIter     ANDEQ     '1ST'                                                      166888
091200210712     C     DDPSTM        OREQ      '01'                                                       186433
091300210712     C     ##ACCD        ANDEQ     'A'                                                        186433
091400210712     C     ##ValIter     ANDEQ     '1ST'                                                      186433
091500210712     C     ##PPAY        ANDNE     'Y'                                                      MD039348
091600210712     C     DDPSTM        OREQ      '07'
091700210712     C     ##ACCD        ANDEQ     'I'                                                        166888
091800210712     C     ##ValIter     ANDEQ     '1ST'                                                      166888
091900210712     C     DDPSTM        OREQ      '07'                                                       186433
092000210712     C     ##ACCD        ANDEQ     'A'                                                        186433
092100210712     C     ##ValIter     ANDEQ     '1ST'                                                      186433
092200210712     C     ##PPAY        ANDNE     'Y'                                                      MD039348
092300210712     C     DDPSTM        OREQ      '08'
092400210712     C     ##ACCD        ANDEQ     'I'                                                        166888
092500210712     C     ##ValIter     ANDEQ     '1ST'                                                      166888
092600210712     C     DDPSTM        OREQ      '08'                                                       186433
092700210712     C     ##ACCD        ANDEQ     'A'                                                        186433
092800210712     C     ##ValIter     ANDEQ     '1ST'                                                      186433
092900210712     C     ##PPAY        ANDNE     'Y'                                                      MD039348
093000210712     C                   EXSR      DEFPAY
093100210712     C                   END
093200210712      *
093300210712      ** Display error message if this is a CLS (FX) transaction and                          CDL036
093400210712      ** no default settlement instructions have been setup for                               CDL036
093500210712      ** receipts and/or payments side                                                        CDL036
093600210712      *                                                                                       CDL036
093700210712     C     CDL036        IFEQ      'Y'                                                        CDL036
093800210712     C     CDL008        ANDEQ     'Y'                                                        CDL036
093900210712     C     ##CALP        ANDEQ     'FXDL'                                                     CDL036
094000210712     C     ##TTYP        ANDEQ     'CL'                                                       CDL036
094100210712     C     ##ACCD        ANDEQ     'I'                                                        CDL036
094200210712      *                                                                                       CDL036
094300210712     C     DDPSTM        IFEQ      '00'                                                       CDL036
094400210712     C     DDPSTM        OREQ      '  '                                                       CDL094
094500210712     C                   ADD       1             Idx                                          CDL036
094600210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                                 CDL036
094700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0307'                                  CDL036
094800210712     C                   MOVE      'N'           DDPstmOK                                     CDL036
094900210712     C                   ENDIF                                                                CDL036
095000210712      *                                                                                       CDL036
095100210712     C     DDRSTM        IFEQ      '00'                                                       CDL036
095200210712     C     DDRSTM        OREQ      '  '                                                       CDL094
095300210712     C                   ADD       1             Idx                                          CDL036
095400210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                                 CDL036
095500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0307'                                  CDL036
095600210712     C                   MOVE      'N'           DDRstmOK                                     CDL036
095700210712     C                   ENDIF                                                                CDL036
095800210712      *                                                                                       CDL036
095900210712     C                   ENDIF                                                                CDL036
096000210712                                                                                            AR863960
096100210712     C                   MOVEL     ##CALP        ##CALP2           4                        AR863960
096200210712                                                                                            AR863960
096300210712      ** 'LERI' calling function must be reset to 'LEND' to process                         AR863960
096400210712      ** all its validation                                                                 AR863960
096500210712                                                                                            AR863960
096600210712     C                   IF        ##CALP2 = 'LERI'                                         AR863960
096700210712     C                   EVAL      ##CALP = 'LEND'                                          AR863960
096800210712     C                   ENDIF                                                              AR863960
096900210712      *                                                                                       CDL036
097000210712      * RECEIPT INSTRUCTIONS
097100210712      *
097200210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
097300210712     C                             OR ##ACTN = 'R' AND ##CALP = 'LEND'                       BUG6010
097400210712     C                             AND ##PREC <> 'Y'                                          244370
097500210712     C**********                   AND ##PREC = 'N'                                   BUG6010 244370
097600210712     C                             OR ##ACTN = 'R' AND ##CALP = 'MAPY'                        239587
097700210712     C**********                   AND ##PREC = 'N'                                  239587 AR853046
097800210712     C                             AND ##PREC <> 'Y'                                        AR853046
097900210712     C                   EXSR      RECEIP
098000210712     C                   ENDIF                                                               BUG6010
098100210712      *
098200210712      * PAYMENT INSTRUCTIONS
098300210712      *
098400210712     C**********         IF        ##ACTN <> 'R'                                      BUG6010 244636
098500210712     C**********                   OR ##ACTN = 'R' AND ##CALP = 'LEND'                BUG6010 244636
098600210712     C**********                   AND ##PPAY = 'N'                                   BUG6010 244636
098700210712     C**********         IF        (##ACTN <> 'R'                                    244636 BUG14913
098800210712     C                   IF        (##ACTN = 'I' OR ##ACTN = 'A'                            BUG14913
098900210712     C                             OR (##ACTN = ' ' AND ##CALP = 'LEND')                    MD052922
099000210712     C                             OR (##ACTN = 'R' AND ##CALP = 'LEND'))                     244636
099100210712     C                             AND ##PPAY <> 'Y'                                          244636
099200210712     C                             OR ##ACTN = 'X' AND ##PPAY = 'Y'                         BUG14913
099300210712     C                             OR ##ACTN = 'R' AND ##CALP = 'MAPY'                        239587
099400210712     C**********                   AND ##PPAY = 'N'                                  239587 AR853046
099500210712     C                             AND ##PPAY <> 'Y'                                        AR853046
099600210712     C                             OR ##ACTN = 'X' AND ##CALP = 'MAPY'                      MD020242
099700210712     C                             AND ##PPAY = ' ' AND ##PREC = 'Y'                        MD020242
099800210712     C                             OR ##ACTN <> 'R' AND ##CALP = 'LDNI'                       260428
099900210712     C                             OR ((##ACTN <> 'R' AND ##CALP2 = 'LERI')                 AR863960
100000210712     C                             OR ((##ACTN = 'R' AND ##CALP2 = 'LERI' )                 AR863960
100100210712     C                             AND ##PPAY <> 'Y'))                                      AR863960
100200210712     C                             OR (CDL051 = 'Y' AND ##ACTN = 'X'                        MD051239
100300210712     C                             AND ##PPAY = ' ' AND (##CALP = 'FXDL'                    MD051239
100400210712     C                             OR ##CALP = 'LDNI' OR ##CALP = 'NASP'                    MD051239
100500210712     C                             OR ##CALP = 'NASS' OR ##CALP = 'DEAM'))                  MD051239
100600210712     C                             OR ##ACTN = 'X' AND ##PPAY <> 'Y'                        MD041649
100700210712     C                             AND (##CALP = 'LEND' OR ##CALP = 'DEAM'                  MD041649
100800210712     C                               OR ##CALP = 'FXDL' OR ##CALP = 'NASP')                 MD041649
100900210712     C                   EXSR      PAYMNT
101000210712     C/COPY WNCPYSRC,ZASETNVC36
101100210712     C                   ENDIF                                                               BUG6010
101200210712                                                                                              CGL014
101300210712      ** Check for Blocked Amount                                                             CGL014
101400210712                                                                                              CGL014
101500210712     C                   IF        CGL014 = 'Y' AND (##CALP = 'SIRS' OR                       CGL014
101600210712     C                             ##CALP = 'CXSV' OR ##CALP = 'CXSM') AND                    CGL014
101700210712     C                             (FLRSTM = 04 OR FLRSTM = 14) AND                           CGL014
101800210712     C                             (DDRONXOK <> 'N' OR DDPONXOK <> 'N')                       CGL014
101900210712     C                   EXSR      SRBlockAmt                                                 CGL014
102000210712     C                   ENDIF                                                                CGL014
102100210712                                                                                              CGL014
102200210712     C/COPY WNCPYSRC,ZASETNVC28
102300210712     C     CLE031        IFEQ      'Y'                                                        CLE031
102400210712     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
102500210712     C                   ELSE                                                                 CLE031
102600210712      *
102700210712      * CROSS VALIDATE RECEIVE AND PAYMENT SETTLEMENT CURRENCY
102800210712      * IF NOT FX TYPE TRANSACTION
102900210712      *
103000210712     C     DDRscyOK      IFNE      'N'
103100210712     C     DDPscyOK      ANDNE     'N'
103200210712     C     ##CALP        ANDNE     'FXDL'
103300210712     C     ##CALP        ANDNE     'CIRS'
103400210712     C     ##CALP        ANDNE     'CXSV'                                                     CIR003
103500210712     C     ##CALP        ANDNE     'CXSM'                                                     CIR003
103600210712     C     ##ACTN        ANDNE     'R'                                                       BUG6010
103700210712     C                   EXSR      XVRPSETC
103800210712     C                   END
103900210712     C                   ENDIF                                                                CLE031
104000210712      *
104100210712      **FRA/IRS*SETTLEMENT*INSTRUCTIONS********************************                       CSW212
104200210712      * EXTENDED SETTLEMENT INSTRUCTIONS                                                      CSW212
104300210712      *
104400210712     C     ##CALP        IFEQ      'FRA '                                       164570
104500210712     C     ##CALP        OREQ      'SIRS'                                       164570
104600210712     C     ##CALP        OREQ      'CIRS'                                       164570
104700210712     C     ##CALP        OREQ      'SSI '                                       164570
104800210712     C     ##CALP        OREQ      'FXDL'                                                     CSW212
104900210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
105000210712     C                   CLEAR                   ##FRIF                         164570
105100210712     C                   MOVE      '0000'        FLISDA                         164570
105200210712     C                   MOVE      '000000'      FLAGDT                         164570
105300210712     C                   MOVE      '00'          FLAGVV                         164570
105400210712     C                   MOVE      '00'          FLAGVC                         CSW097
105500210712     C     CSW005        IFEQ      'Y'                                          164570
105600210712     C     CSW011        OREQ      'Y'                                          164570
105700210712     C     ##CALP        ANDEQ     'FRA '                                       164570
105800210712     C     ##CALP        OREQ      'FXDL'                                                     CSW212
105900210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
106000210712     C                   EXSR      VLFRIR                                       164570
106100210712     C                   END                                                    164570
106200210712     C                   END                                                    164570
106300210712     C/COPY WNCPYSRC,ZASETNVC29
106400210712                                                                                164570
106500210712     C*****CSW005********IFEQ      'Y'                                          164570
106600210712     C*****##CALP        ANDEQ     'FRAS'                                       CAP003
106700210712     C*****##CALP********ANDEQ     'FRAS'                                CAP003 164570
106800210712     C*****CSW005********OREQ      'Y'                                          164570
106900210712     C*****##CALP********ANDEQ     'SSI '                                       164570
107000210712     C*****CSW005********OREQ      'Y'                                   CAP004 164570
107100210712     C*****##CALP********ANDEQ     'CIRS'                                CAP004 164570
107200210712     C*****CSW011********OREQ      'Y'                                          164570
107300210712     C*****##CALP********ANDEQ     'FRAS'                                CAP003 164570
107400210712     C*****##CALP********ANDEQ     'FRA '                                CAP003 164570
107500210712     C*****CSW011********OREQ      'Y'                                          164570
107600210712     C*****##CALP********ANDEQ     'SSI '                                       164570
107700210712     C*****CSW011********OREQ      'Y'                                   CAP004 164570
107800210712     C*****##CALP********ANDEQ     'CIRS'                                CAP004 164570
107900210712     C*******************EXSR      VLFRIR                                       164570
108000210712     C*******************END                                                    164570
108100210712      *
108200210712      * RETURN
108300210712      *
108400210712     C                   RETURN
108500210712     C*****************************************************************
108600210712      /EJECT
108700210712     C*****************************************************************
108800210712     C*                                                               *
108900210712     C* RECEIP - VALIDATE RECEIPT INSTRUCTIONS                        *
109000210712     C*                                                               *
109100210712     C*****************************************************************
109200210712     C     RECEIP        BEGSR
109300210712      *
109400210712      ** CLEAR OUTPUT RECEIVE FIELDS
109500210712      *
109600210712     C                   CLEAR                   ##RECF
109700210712      *                                                                                       CLE168
109800210712     C                   IF        CLE168 = 'Y'                                               CLE168
109900210712     C                   IN        LEFCLY                                                     CLE168
110000210712     C                   ENDIF                                                                CLE168
110100210712      *
110200210712      ** RECEIVE SETTLEMENT FIELDS
110300210712      ** -------------------------
110400210712      *
110500210712     C     ##PREC        IFNE      'Y'                                                      AR641619
110600210712     C                   EXSR      VLRSFD
110700210712     C                   ENDIF                                                              AR641619
110800210712      *
110900210712      ** RECEIVE SETTLEMENT CURRENCY
111000210712      ** ---------------------------
111100210712      *
111200210712     C     DDRSCY        IFNE      *BLANKS
111300210712     C     ##PREC        ANDNE     'Y'                                                      AR641619
111400210712     C                   EXSR      VLRSCY
111500210712     C                   MOVE      DDRSCY        E#RCCY
111600210712     C                   ENDIF
111700210712     C                   MOVE      DDRSCY        FLRSCY
111800210712      *                                                                                       CDL018
111900210712      ** RECEIVE MORE ACCOUNT                                                                 CDL018
112000210712      ** --------------------                                                                 CDL018
112100210712      *                                                                                       CDL018
112200210712     C     CDL018        IFEQ      'Y'                                                        CDL018
112300210712     C                   EXSR      VLRMAC                                                     CDL018
112400210712     C                   MOVE      DDRMAC        FLRMAC                                       CDL018
112500210712     C                   ENDIF                                                                CDL018
112600210712      *                                                                                       CLE031
112700210712      ** RECEIVE EXCHANGE RATE AND INDICATOR                                                  CLE031
112800210712      ** -----------------------------------                                                  CLE031
112900210712      *                                                                                       CLE031
113000210712     C     CLE031        IFEQ      'Y'                                                        CLE031
113100210712     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
113200210712     C     CLE031        OREQ      'Y'                                                      AR853046
113300210712     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
113400210712     C                   EXSR      VLREXR                                                     CLE031
113500210712     C                   ENDIF                                                                CLE031
113600210712      *
113700210712      ** RECEIVE SETTLEMENT METHOD
113800210712      ** -------------------------
113900210712      *
114000210712     C     ##PREC        IFNE      'Y'                                                      AR641619
114100210712     C                   EXSR      VLRSTM
114200210712     C                   ENDIF                                                              AR641619
114300210712     C                   MOVE      DDRSTM        FLRSTM
114400210712      **
114500210712      ** RECEIVE SETTLEMENT BRANCH
114600210712      ** -------------------------
114700210712      ** (Only validate Branch in multi-branching environment.)
114800210712      *
114900210712     C     @MBIN         IFEQ      'Y'
115000210712     C     CLE033        OREQ      'Y'                                                        CLE033
115100210712     C     FLRSTM        ANDEQ     09                                                         CLE033
115200210712     C     ##PREC        IFNE      'Y'                                                      AR641619
115300210712     C                   EXSR      VLROBR
115400210712     C                   ENDIF                                                              AR641619
115500210712     C                   END
115600210712     C                   MOVE      DDROBR        FLROBR                                     AR641619
115700210712      *
115800210712      ** OUR RECEIVE NOSTRO
115900210712      ** ------------------
116000210712     C/COPY WNCPYSRC,ZASETINV11                                                               CUT009
116100210712      *
116200210712     C**********         MOVEL     *BLANKS       WARN_RFLAG        1              AR1096686 MD021526
116300210712     C     ##PREC        IFNE      'Y'                                                      AR641619
116400210712     C                   EXSR      VLRONS
116500210712     C                   ENDIF                                                              AR641619
116600210712     C                   MOVEL     DDRONS        FLRONS
116700210712     C/COPY WNCPYSRC,ZASETINV12                                                               CUT009
116800210712      ************                                                                     179510 200400
116900210712      **For*Settlement*method*04*,*move*the*required*data*into*the*work*****           179510 200400
117000210712      **fields**,*and*then**into*the**correspondent**DataStructure*.********           179510 200400
117100210712      ************                                                                     179510 200400
117200210712     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
117300210712     C************       MOVEL     ##CSNM        WMORIF           10                   179510 200400
117400210712     C************       MOVE      BMACCD        WMORIF                                179510 200400
117500210712     C************       MOVEL     WMORIF        WFMORI           12                   179510 200400
117600210712     C************       MOVE      '01'          WFMORI                                179510 200400
117700210712     C************       MOVE      WFMORI        @@MORI                                179510 200400
117800210712     C************       ENDIF                                                         179510 200400
117900210712      ************                                                                     179510 200400
118000210712      *                                                                                       179510
118100210712      *                                                                                       CLE033
118200210712      ** No need to validate swift fields if Swift for Lending is not                         CLE033
118300210712      ** on and settlement method is 09                                                       CLE033
118400210712      *                                                                                       CLE033
118500210712     C     CLE033        IFNE      'Y'                                                        CLE033
118600210712     C     FLRSTM        ORNE      09                                                         CLE033
118700210712     C     BGSWCL        OREQ      'Y'                                                        CLE033
118800210712      *
118900210712      ** RECEIVE ORDERING CUSTOMER
119000210712      ** -------------------------
119100210712      *
119200210712     C     DDRocnOK      IFNE      'N'
119300210712     C     DDROCN        ANDNE     *BLANKS
119400210712     C                   EXSR      VLROCN
119500210712     C                   END
119600210712      *
119700210712      ** RECEIVE ORDERING BANK
119800210712      ** ---------------------
119900210712      *
120000210712     C     DDRobnOK      IFNE      'N'
120100210712     C     DDROBN        ANDNE     *BLANKS
120200210712     C                   EXSR      VLROBN
120300210712     C                   END
120400210712      *
120500210712      ** RECEIVE ORDERING CUSTOMER & BANK
120600210712      ** --------------------------------
120700210712      *
120800210712     C     ##PREC        IFNE      'Y'                                                      AR641619
120900210712     C                   EXSR      VLROCB
121000210712     C                   ENDIF                                                              AR641619
121100210712      *
121200210712      ** RECEIVE INTERMEDIARY BANK
121300210712      ** -------------------------
121400210712      *
121500210712      * If CDL094 is On, check if an Intermediary has been defined for                        CDL094
121600210712      * the receive nostro and if so default the details defined                              CDL094
121700210712     C     CDL094        IFEQ      'Y'                                                        CDL094
121800210712     C                   IF        (##CALP = 'FXDL' or ##CALP = 'LDNI'                        CDL094
121900210712     C                             or ##CALP = 'DEAM')                                        CDL094
122000210712     C                             AND (DDRSTM = '01' or DDRSTM = '07'                        CDL094
122100210712     C                             or DDRSTM = '08')                                          CDL094
122200210712     C                             AND DDRonxOK = 'Y'                                         CDL094
122300210712     C                             AND DDRIBN = *BLANKS                                       CDL094
122400210712     C                   IF        A7RF56 <> *BLANKS                                          CDL094
122500210712      *                                                                                       CDL094
122600210712      * If entry is a SWIFT BIC, retreive the customer number and use                         CDL094
122700210712     C                   MOVEL     A7RF56        WBIC             12                          CDL094
122800210712     C     WBIC          CHAIN     SDCUSTL7                                                   CDL094
122900210712     C                   IF        %FOUND(SDCUSTL7)                                           CDL094
123000210712     C                   MOVEL     C_BBCUST      DDRIBN                                       CDL094
123100210712     C                   ELSE                                                                 CDL094
123200210712     C                   MOVEL     A7RF56        DDRIBN                                       CDL094
123300210712     C                   ENDIF                                                                CDL094
123400210712     C                   MOVEL     A7RA56        DDRIBA                                       CDL094
123500210712     C                   ENDIF                                                                CDL094
123600210712     C                   ENDIF                                                                CDL094
123700210712     C                   ENDIF                                                                CDL094
123800210712      *                                                                                       CDL094
123900210712     C     DDRibnOK      IFNE      'N'
124000210712     C     DDRIBN        ANDNE     *BLANKS
124100210712     C                   EXSR      VLRIBN
124200210712     C                   END
124300210712      *
124400210712      ** RECEIVE INTERMEDIARY BANK A/C LINE
124500210712      ** ----------------------------------
124600210712      *
124700210712     C     DDRibaOK      IFNE      'N'
124800210712     C     DDRIBA        ANDNE     *BLANKS
124900210712     C     ##PREC        ANDNE     'Y'                                                      AR641619
125000210712     C                   EXSR      VLRIBA
125100210712     C                   END
125200210712     C                   MOVE      DDRIBA        FLRIBA                                     AR641619
125300210712      *                                                                                       CLE033
125400210712      ** RECEIVE BANK TO BANK INFORMATION                                                     CDL094
125500210712      ** ------------------------                                                             CDL094
125600210712     C                   IF        CDL094 = 'Y'                                               CDL094
125700210712     C                   EXSR      VLRBTBI                                                    CDL094
125800210712     C                   ENDIF                                                                CDL094
125900210712      *                                                                                       CDL094
126000210712     C                   ELSE                                                                 CLE033
126100210712     C                   MOVEL     DDROCN        FLROCN                                       CLE033
126200210712     C                   MOVEL     DDROBN        FLROBN                                       CLE033
126300210712     C                   MOVEL     DDRIBN        FLRIBN                                       CLE033
126400210712     C                   MOVE      DDRIBA        FLRIBA                                       CLE033
126500210712     C                   MOVEL     DDRBB1        FLRBB1                                       CDL094
126600210712     C                   MOVEL     DDRBB2        FLRBB2                                       CDL094
126700210712     C                   MOVEL     DDRBB3        FLRBB3                                       CDL094
126800210712     C                   MOVEL     DDRBB4        FLRBB4                                       CDL094
126900210712     C                   MOVEL     DDRBB5        FLRBB5                                       CDL094
127000210712     C                   MOVEL     DDRBB6        FLRBB6                                       CDL094
127100210712     C                   ENDIF                                                                CLE033
127200210712                                                                                              CRE008
127300210712      ** Do an Overdraft Limit check                                                          CRE008
127400210712                                                                                              CRE008
127500210712     C                   IF        CRE008 = 'Y'                                               CRE008
127600210712     C                   EXSR      SROvrChk                                                   CRE008
127700210712     C                   ENDIF                                                                CRE008
127800210712                                                                                              CGL014
127900210712      ** Save Receive Settlement Instructions                                                 CGL014
128000210712                                                                                              CGL014
128100210712     C                   IF        CGL014 = 'Y'                                               CGL014
128200210712     C                   EVAL      WRcBRCA= WkBRCA                                            CGL014
128300210712     C                   EVAL      WRcCcy  = WkCcy                                            CGL014
128400210712     C                   MOVE      WkCust        WRcCust                                      CGL014
128500210712     C                   MOVE      WkACOD        WRcACOD                                      CGL014
128600210712     C                   MOVE      WkASEQ        WRcASEQ                                      CGL014
128700210712     C                   ENDIF                                                                CGL014
128800210712     C*
128900210712     C                   ENDSR
129000210712     C*****************************************************************
129100210712      /EJECT
129200210712     C*****************************************************************
129300210712     C*                                                               *
129400210712     C* PAYMNT - VALIDATE PAYMENT INSTRUCTIONS                        *
129500210712     C*                                                               *
129600210712     C*****************************************************************
129700210712     C     PAYMNT        BEGSR
129800210712      *
129900210712      ** CLEAR OUTPUT PAYMENT FIELDS
130000210712      *
130100210712     C                   CLEAR                   ##PAYF
130200210712      *
130300210712      ** PAYMENT SETTLEMENT FIELDS
130400210712      ** -------------------------
130500210712      *
130600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
130700210712     C                   EXSR      VLPSFD
130800210712     C                   ENDIF                                                              AR641619
130900210712      *
131000210712      ** RECIPIENT OF MT100
131100210712      ** ------------------
131200210712     C/COPY WNCPYSRC,ZASETINV13                                                               CUT009
131300210712      *
131400210712     C     DDRvnoOK      IFNE      'N'
131500210712     C                   EXSR      VLRVNO
131600210712     C                   END
131700210712     C/COPY WNCPYSRC,ZASETINV14                                                               CUT009
131800210712      *
131900210712      ** PAYMENT SETTLEMENT CURRENCY
132000210712      ** ---------------------------
132100210712     C/COPY WNCPYSRC,ZASETINV15                                                               CUT009
132200210712      *
132300210712     C     DDPSCY        IFNE      *BLANKS
132400210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
132500210712     C                   EXSR      VLPSCY
132600210712     C                   MOVE      DDPSCY        E#PCCY
132700210712     C                   ENDIF
132800210712     C                   MOVE      DDPSCY        FLPSCY
132900210712     C/COPY WNCPYSRC,ZASETINV16                                                               CUT009
133000210712      *                                                                                       CDL018
133100210712      ** PAY MORE ACCOUNT                                                                     CDL018
133200210712      ** ----------------                                                                     CDL018
133300210712      *                                                                                       CDL018
133400210712     C     CDL018        IFEQ      'Y'                                                        CDL018
133500210712     C                   EXSR      VLPMAC                                                     CDL018
133600210712     C                   MOVE      DDPMAC        FLPMAC                                       CDL018
133700210712     C                   ENDIF                                                                CDL018
133800210712      *                                                                                       CLE031
133900210712      ** PAYMENT EXCHANGE RATE AND INDICATOR                                                  CLE031
134000210712      ** -----------------------------------                                                  CLE031
134100210712      *                                                                                       CLE031
134200210712     C     CLE031        IFEQ      'Y'                                                        CLE031
134300210712     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
134400210712     C     CLE031        OREQ      'Y'                                                      AR853046
134500210712     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
134600210712     C                   EXSR      VLPEXR                                                     CLE031
134700210712     C                   ENDIF                                                                CLE031
134800210712      *
134900210712      ** PAYMENT SETTLEMENT METHOD
135000210712      ** -------------------------
135100210712      *
135200210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
135300210712     C                   EXSR      VLPSTM
135400210712     C                   ENDIF                                                              AR641619
135500210712     C                   MOVE      DDPSTM        FLPSTM
135600210712     C/COPY WNCPYSRC,ZASETINVC1
135700210712      **
135800210712      ** PAYMENT SETTLEMENT BRANCH
135900210712      ** -------------------------
136000210712      ** (Only validate Branch in multi-branching environment.)
136100210712      *
136200210712     C     @MBIN         IFEQ      'Y'
136300210712     C     CLE033        OREQ      'Y'                                                        CLE033
136400210712     C     FLPSTM        ANDEQ     09                                                         CLE033
136500210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
136600210712     C                   EXSR      VLPOBR
136700210712     C                   ENDIF                                                              AR641619
136800210712     C                   END
136900210712     C                   MOVE      DDPOBR        FLPOBR                                     AR641619
137000210712      *
137100210712      ** OUR PAYMENT NOSTRO
137200210712      ** ------------------
137300210712     C/COPY WNCPYSRC,ZASETINV09                                                               CUT009
137400210712      *
137500210712     C**********         MOVEL     *BLANKS       WARN_PFLAG        1              AR1096686 MD021526
137600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
137700210712     C                   EXSR      VLPONS
137800210712     C                   ENDIF                                                              AR641619
137900210712     C                   MOVEL     DDPONS        FLPONS
138000210712                                                                                              CGL014
138100210712      ** Save Pay Settlement Instructions                                                     CGL014
138200210712                                                                                              CGL014
138300210712     C                   IF        CGL014 = 'Y'                                               CGL014
138400210712     C                   EVAL      WPyBRCA= WkBRCA                                            CGL014
138500210712     C                   EVAL      WPyCcy  = WkCcy                                            CGL014
138600210712     C                   MOVE      WkCust        WPyCust                                      CGL014
138700210712     C                   MOVE      WkACOD        WPyACOD                                      CGL014
138800210712     C                   MOVE      WkASEQ        WPyASEQ                                      CGL014
138900210712     C                   ENDIF                                                                CGL014
139000210712     C/COPY WNCPYSRC,ZASETINV10                                                               CUT009
139100210712      ************                                                                     179510 200400
139200210712      ************                                                                     179510 200400
139300210712      **For*Settlement*method*04*,*move*the*required*data*into*the*work***             179510 200400
139400210712      **fields**,*and*then**into*the**correspondent**DataStructure*.******             179510 200400
139500210712      ************                                                                     179510 200400
139600210712     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
139700210712     C************       MOVEL     ##CSNM        WMOPIF           10                   179510 200400
139800210712     C************       MOVE      BMACCD        WMOPIF                                179510 200400
139900210712     C************       MOVEL     WMOPIF        WFMOPI           12                   179510 200400
140000210712     C************       MOVE      '01'          WFMOPI                                179510 200400
140100210712     C************       MOVE      WFMOPI        @@MOPI                                179510 200400
140200210712     C************       ENDIF                                                         179510 200400
140300210712      ************                                                                     179510 200400
140400210712      ************                                                                     179510 200400
140500210712      *                                                                                       CLE033
140600210712      ** No need to validate swift fields if Swift for Lending is not                         CLE033
140700210712      ** on and settlement method is 09                                                       CLE033
140800210712      *                                                                                       CLE033
140900210712     C     CLE033        IFNE      'Y'                                                        CLE033
141000210712     C     FLPSTM        ORNE      09                                                         CLE033
141100210712     C     BGSWCL        OREQ      'Y'                                                        CLE033
141200210712      *
141300210712      ** PAYMENT ORDERING CUSTOMER
141400210712      ** -------------------------
141500210712      *
141600210712     C     DDPocnOK      IFNE      'N'
141700210712     C     DDPOCN        ANDNE     *BLANKS
141800210712     C                   EXSR      VLPOCN
141900210712     C                   END
142000210712      *
142100210712      ** PAYMENT ORDERING BANK
142200210712      ** ---------------------
142300210712      *
142400210712     C     DDPobnOK      IFNE      'N'
142500210712     C     DDPOBN        ANDNE     *BLANKS
142600210712     C                   EXSR      VLPOBN
142700210712     C                   END
142800210712      *
142900210712      ** PAYMENT ORDERING CUSTOMER & BANK
143000210712      ** --------------------------------
143100210712      *
143200210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
143300210712     C                   EXSR      VLPOCB
143400210712     C                   ENDIF                                                              AR641619
143500210712      *
143600210712      ** RECEIVER'S CORRESPONDANT
143700210712      ** ------------------------
143800210712      *
143900210712     C/COPY WNCPYSRC,ZAH00004
144000210712     C     DDRcrnOK      IFNE      'N'
144100210712     C     DDRCRN        ANDNE     *BLANKS
144200210712     C/COPY WNCPYSRC,ZAH00016
144300210712     C                   EXSR      VLRCRN
144400210712     C                   END
144500210712      *
144600210712      ** RECEIVER'S CORRESPONDENT A/C LINE
144700210712      ** ---------------------------------
144800210712      *
144900210712     C     DDRcraOK      IFNE      'N'
145000210712     C     DDRCRA        ANDNE     *BLANKS
145100210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
145200210712     C                   EXSR      VLRCRA
145300210712     C                   END
145400210712     C                   MOVEL     DDRCRA        FLRCRA                                     AR641619
145500210712      *
145600210712      ** PAYMENT INTERMEDIARY BANK
145700210712      ** -------------------------
145800210712      *
145900210712     C     DDPibnOK      IFNE      'N'
146000210712     C     DDPIBN        ANDNE     *BLANKS
146100210712     C                   EXSR      VLPIBN
146200210712     C                   END
146300210712      *
146400210712      ** PAYMENT INTERMEDIARY BANK A/C LINE
146500210712      ** ----------------------------------
146600210712      *
146700210712     C     DDPibaOK      IFNE      'N'
146800210712     C     DDPIBA        ANDNE     *BLANKS
146900210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
147000210712     C                   EXSR      VLPIBA
147100210712     C                   END
147200210712     C                   MOVEL     DDPIBA        FLPIBA                                     AR641619
147300210712      *
147400210712      ** PAYMENT ACCOUNT WITH BANK
147500210712      ** -------------------------
147600210712     C/COPY WNCPYSRC,ZASETNVC06
147700210712      *
147800210712     C     DDAwbnOK      IFNE      'N'
147900210712     C     DDAWBN        ANDNE     *BLANKS
148000210712     C                   EXSR      VLAWBN
148100210712     C                   END
148200210712      *
148300210712      ** PAYMENT ACCOUNT WITH BANK A/C LINE
148400210712      ** ----------------------------------
148500210712     C/COPY WNCPYSRC,ZASETNVC07
148600210712      *
148700210712     C     DDAwbaOK      IFNE      'N'
148800210712     C     DDAWBA        ANDNE     *BLANKS
148900210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
149000210712     C                   EXSR      VLAWBA
149100210712     C                   END
149200210712     C                   MOVEL     DDAWBA        FLAWBA                                     AR641619
149300210712      *
149400210712      ** BENEFICIARY
149500210712      ** -----------
149600210712     C/COPY WNCPYSRC,ZASETNVC08
149700210712      *
149800210712     C     DDBennOK      IFNE      'N'
149900210712     C     DDPSTM        IFEQ      '01'
150000210712     C     DDPSTM        OREQ      '07'
150100210712     C     DDPSTM        OREQ      '08'
150200210712     C     DDPSTM        OREQ      '09'                                                       CLE033
150300210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
150400210712     C/COPY WNCPYSRC,ZASETNVC04
150500210712     C                   EXSR      VLBENN
150600210712     C                   END
150700210712     C                   END
150800210712      *
150900210712      ** BENEFICIARY A/C WITH LINE
151000210712      ** --------------------------
151100210712      *
151200210712     C     DDBenaOK      IFNE      'N'
151300210712     C     DDBENA        ANDNE     *BLANKS
151400210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
151500210712     C                   EXSR      VLBENA
151600210712     C                   END
151700210712     C                   MOVEL     DDBENA        FLBENA                                     AR641619
151800210712      *
151900210712      ** NUMEROUS PAYMENT FIELDS
152000210712      ** -----------------------
152100210712      *
152200210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
152300210712     C                   EXSR      VLPNFD
152400210712     C                   ENDIF                                                              AR641619
152500210712      *
152600210712      ** DETAILS OF PAYMENT
152700210712      ** ------------------
152800210712     C/COPY WNCPYSRC,ZASETINV01                                                               CUT009
152900210712      *
153000210712     C                   EXSR      VLDTPI
153100210712      *
153200210712     C/COPY WNCPYSRC,ZASETINV02                                                               CUT009
153300210712      ** DETAILS OF CHARGES
153400210712      ** ------------------
153500210712      *
153600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
153700210712     C                   EXSR      VLDCHG
153800210712     C                   ENDIF                                                              AR641619
153900210712     C                   MOVEL     DDDCHG        FLDCHG                                     AR641619
154000210712      *
154100210712      ** INCLUDE 'IN' CCY IN FIELD 72
154200210712      ** ----------------------------
154300210712      *
154400210712     C     DDIC72        IFNE      *BLANKS
154500210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
154600210712     C                   EXSR      VLIC72
154700210712     C                   ENDIF
154800210712     C                   MOVEL     DDIC72        FLIC72
154900210712      *
155000210712      ** BANK TO BANK INFORMATION
155100210712      ** ------------------------
155200210712      *
155300210712     C/COPY WNCPYSRC,ZASETNVC25
155400210712     C                   EXSR      VLBTBI
155500210712     C/COPY WNCPYSRC,ZASETNVC26
155600210712     C*                                                                                       CLE033
155700210712     C                   ELSE                                                                 CLE033
155800210712     C                   MOVEL     DDPOCN        FLPOCN                                       CLE033
155900210712     C                   MOVEL     DDPOBN        FLPOBN                                       CLE033
156000210712     C                   MOVEL     DDRCRN        FLRCRN                                       CLE033
156100210712     C                   MOVEL     DDRCRA        FLRCRA                                       CLE033
156200210712     C                   MOVEL     DDPIBN        FLPIBN                                       CLE033
156300210712     C                   MOVE      DDPIBA        FLPIBA                                       CLE033
156400210712     C                   MOVEL     DDAWBN        FLAWBN                                       CLE033
156500210712     C                   MOVEL     DDAWBA        FLAWBA                                       CLE033
156600210712     C                   MOVEL     DDBENN        FLBENN                                       CLE033
156700210712     C                   MOVEL     DDBENA        FLBENA                                       CLE033
156800210712     C                   MOVEL     DDDTP1        FLDTP1                                       CLE033
156900210712     C                   MOVEL     DDDTP2        FLDTP2                                       CLE033
157000210712     C                   MOVEL     DDDTP3        FLDTP3                                       CLE033
157100210712     C                   MOVEL     DDDTP4        FLDTP4                                       CLE033
157200210712     C                   MOVEL     DDDCHG        FLDCHG                                       CLE033
157300210712     C                   MOVEL     DDIC72        FLIC72                                       CLE033
157400210712     C                   MOVEL     DDBTB1        FLBTB1                                       CLE033
157500210712     C                   MOVEL     DDBTB2        FLBTB2                                       CLE033
157600210712     C                   MOVEL     DDBTB3        FLBTB3                                       CLE033
157700210712     C                   MOVEL     DDBTB4        FLBTB4                                       CLE033
157800210712     C                   MOVEL     DDBTB5        FLBTB5                                       CLE033
157900210712     C                   MOVEL     DDBTB6        FLBTB6                                       CLE033
158000210712     C                   ENDIF                                                                CLE033
158100210712      *
158200210712     C                   ENDSR
158300210712     C*****************************************************************
158400210712      /EJECT
158500210712     C*****************************************************************
158600210712     C*                                                               *
158700210712     C* VLRSFD - VALIDATE RECEIVE SETTLEMENT FIELDS                   *
158800210712     C*                                                               *
158900210712     C*****************************************************************
159000210712     C     VLRSFD        BEGSR
159100210712      *
159200210712      ** ENTRY IN ALL RECEIPT INSTRUCTIONS PROHIBITED IF RECEIPT
159300210712      ** SETTLEMENT METHOD IS BLANK
159400210712      *
159500210712     C     DDRSTM        IFEQ      *BLANKS
159600210712      *
159700210712     C     DDRONS        IFNE      *BLANKS
159800210712     C     DDROBN        ORNE      *BLANKS
159900210712     C     DDROCN        ORNE      *BLANKS
160000210712     C     DDRIBN        ORNE      *BLANKS
160100210712     C     DDRIBA        ORNE      *BLANKS
160200210712     C     DDROBR        ORNE      *BLANKS
160300210712     C     DDRMAC        ORNE      *BLANKS                                                    CDL018
160400210712     C     DDREXR        ORNE      *BLANKS                                                    CLE031
160500210712     C     DDREXI        ORNE      *BLANKS                                                    CLE031
160600210712     C                   ADD       1             Idx
160700210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
160800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0900'
160900210712     C                   MOVE      'N'           DDRstmOK
161000210712     C                   END
161100210712     C                   END
161200210712      *
161300210712      ** ENTRY PROHIBITED FOR ORDERING CUSTOMER; ORDERING BANK; INTERM.
161400210712      ** BANK AND INTERM. BANK A/C LINE UNLESS SETTL.TP IS 01 07 OR 08
161500210712      *
161600210712     C     DDRSTM        IFNE      '01'
161700210712     C     DDRSTM        ANDNE     '07'
161800210712     C     DDRSTM        ANDNE     '08'
161900210712     C     CLE033        ANDNE     'Y'                                                        CLE033
162000210712     C     DDRSTM        ORNE      '01'                                                       CLE033
162100210712     C     DDRSTM        ANDNE     '07'                                                       CLE033
162200210712     C     DDRSTM        ANDNE     '08'                                                       CLE033
162300210712     C     DDRSTM        ANDNE     '09'                                                       CLE033
162400210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
162500210712      *
162600210712     C     DDROCN        IFNE      *BLANKS
162700210712     C     DDROBN        ORNE      *BLANKS
162800210712     C     DDRIBN        ORNE      *BLANKS
162900210712     C     DDRIBA        ORNE      *BLANKS
163000210712     C                   ADD       1             Idx
163100210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
163200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0901'
163300210712     C                   MOVE      'N'           DDRstmOK
163400210712     C     DDROCN        IFNE      *BLANKS
163500210712     C                   MOVE      'N'           DDRocnOK
163600210712     C                   END
163700210712     C     DDROBN        IFNE      *BLANKS
163800210712     C                   MOVE      'N'           DDRobnOK
163900210712     C                   END
164000210712     C     DDRIBN        IFNE      *BLANKS
164100210712     C                   MOVE      'N'           DDRibnOK
164200210712     C                   END
164300210712     C     DDRIBA        IFNE      *BLANKS
164400210712     C                   MOVE      'N'           DDRibaOK
164500210712     C                   END
164600210712      *
164700210712     C                   END
164800210712     C                   END
164900210712      *                                                                                       CDL018
165000210712      ** Entry Prohibited for 'MORE A/C' unless Sett. Method is 05 or 14                      CDL018
165100210712      *                                                                                       CDL018
165200210712     C     CDL018        IFEQ      'Y'                                                        CDL018
165300210712      *                                                                                       CDL018
165400210712     C     DDRSTM        IFNE      '05'                                                       CDL018
165500210712     C     DDRSTM        ANDNE     '14'                                                       CDL018
165600210712      *                                                                                       CDL018
165700210712     C     DDRMAC        IFNE      *BLANKS                                                    CDL018
165800210712     C                   ADD       1             Idx                                          CDL018
165900210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                                 CDL018
166000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM1000'                                  CDL018
166100210712     C                   MOVE      'N'           DDRmacOK                                     CDL018
166200210712     C                   ENDIF                                                                CDL018
166300210712     C                   ENDIF                                                                CDL018
166400210712      *                                                                                       CDL018
166500210712     C                   ENDIF                                                                CDL018
166600210712      *                                                                                       CDL018
166700210712     C                   ENDSR
166800210712     C********************************************************************
166900210712      /EJECT
167000210712     C*****************************************************************
167100210712     C*                                                               *
167200210712     C* VLRSCY - VALIDATE RECEIVE SETTLEMENT CURRENCY                 *
167300210712     C*                                                               *
167400210712     C*****************************************************************
167500210712     C     VLRSCY        BEGSR
167600210712      *
167700210712      **  Access Currency Details
167800210712      *
167900210712     C                   CALLB     'AOCURRR0'
168000210712     C                   PARM      *BLANKS       @RTCD
168100210712     C                   PARM      '*KEY    '    @OPTN
168200210712     C                   PARM      DDRSCY        @CURR             3
168300210712     C     SDCURR        PARM      SDCURR        DSSDY
168400210712      *
168500210712      **  Receipt settlement currency is invalid
168600210712      **  or not a dealing currency
168700210712      *
168800210712     C     @RTCD         IFNE      *BLANKS
168900210712     C     A6DLCI        ORNE      'Y'
169000210712     C                   ADD       1             Idx
169100210712     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
169200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0862'
169300210712     C                   MOVE      'N'           DDRscyOK
169400210712     C                   ELSE
169500210712
169600210712     C                   MOVEL     A6CYCD        DDRSCY
169700210712      *                                                                                       CLE031
169800210712      **  CLE031 enhancement allows settlement of In-ccy or Euro currency                     CLE031
169900210712      **  against other currencies                                                            CLE031
170000210712      *                                                                                       CLE031
170100210712     C     CLE031        IFEQ      'Y'                                                        CLE031
170200210712     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
170300210712     C     CLE031        OREQ      'Y'                                                      AR853046
170400210712     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
170500210712     C                   MOVE      A6SPRT        AMREXR                                       CLE031
170600210712     C                   MOVE      A6MDIN        AMREXI                                       CLE031
170700210712     C                   MOVE      A6DLCI        BRDLCI            1                          CLE031
170800210712     C                   MOVE      A6INCY        BRINCY            1                          CLE031
170900210712      *                                                                                       CLE031
171000210712      **  Access Currency Details for transaction receive currency                            CLE031
171100210712      *                                                                                       CLE031
171200210712     C                   CALLB     'AOCURRR0'                                                 CLE031
171300210712     C                   PARM      *BLANKS       @RTCD                                        CLE031
171400210712     C                   PARM      '*KEY    '    @OPTN                                        CLE031
171500210712     C                   PARM      ##RCCY        @CURR                                        CLE031
171600210712     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE031
171700210712      *                                                                                       CLE031
171800210712     C                   MOVE      A6SPRT        ARSPRT                                       CLE031
171900210712     C                   MOVE      A6MDIN        ARMDIN                                       CLE031
172000210712     C                   MOVE      A6INCY        ARINCY            1                          CLE031
172100210712      *                                                                                       CLE031
172200210712     C                   ELSE                                                                 CLE031
172300210712      *
172400210712      ** If the transaction receive currency is Euros
172500210712      *
172600210712     C     ##RCCY        IFEQ      BKEURO
172700210712      *
172800210712      ** Error if settlement currency is not an 'In' currency
172900210712      *
173000210712     C     A6INCY        IFNE      'Y'
173100210712     C                   ADD       1             Idx
173200210712     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
173300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0850'
173400210712     C                   MOVE      'N'           DDRscyOK
173500210712     C                   ENDIF
173600210712      *
173700210712      ** If the transaction receive currency is NOT Euros (i.e. an 'in' ccy)
173800210712      *
173900210712     C                   ELSE
174000210712      *
174100210712      ** Error if settlement currency is not Euros
174200210712      *
174300210712     C     DDRSCY        IFNE      BKEURO
174400210712     C                   ADD       1             Idx
174500210712     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
174600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0851'
174700210712     C                   MOVE      'N'           DDRscyOK
174800210712     C                   ELSE                                                   152344
174900210712      *                                                                         152344
175000210712      **  Access Currency Details for transaction receive currency              152344
175100210712      *                                                                         152344
175200210712     C                   CALLB     'AOCURRR0'                                   152344
175300210712     C                   PARM      *BLANKS       @RTCD                          152344
175400210712     C                   PARM      '*KEY    '    @OPTN                          152344
175500210712     C                   PARM      ##RCCY        @CURR                          152344
175600210712     C     SDCURR        PARM      SDCURR        DSSDY                          152344
175700210712      *                                                                         152344
175800210712      ** Error if receive currency is not an 'In' currency                      152344
175900210712      *                                                                         152344
176000210712     C     A6INCY        IFNE      'Y'                                          152344
176100210712     C                   ADD       1             Idx                            152344
176200210712     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'                   152344
176300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0862'                    152344
176400210712     C                   MOVE      'N'           DDRscyOK                       152344
176500210712     C                   ENDIF                                                  152344
176600210712                                                                                152344
176700210712     C                   ENDIF
176800210712      *
176900210712     C                   ENDIF
177000210712      *
177100210712     C                   ENDIF                                                                CLE031
177200210712      *                                                                                       CLE031
177300210712     C                   ENDIF
177400210712      *
177500210712     C                   ENDSR
177600210712     C********************************************************************
177700210712      /EJECT
177800210712      *****************************************************************                       CDL018
177900210712      *                                                               *                       CDL018
178000210712      * VLRMAC - VALIDATE RECEIVE MORE ACCOUNT                        *                       CDL018
178100210712      *                                                               *                       CDL018
178200210712      *****************************************************************                       CDL018
178300210712     C     VLRMAC        BEGSR                                                                CDL018
178400210712      *                                                                                       CDL018
178500210712      ** More Accounts only valid for Deal Types IP, IT, TI or TD                             CDL018
178600210712      *                                                                                       CDL018
178700210712     C     ##TTYP        IFNE      'IP'                                                       CDL018
178800210712     C     ##TTYP        ANDNE     'IT'                                                       CDL018
178900210712     C     ##TTYP        ANDNE     'TI'                                                       CDL018
179000210712     C     ##TTYP        ANDNE     'TD'                                                       CDL018
179100210712     C     DDRMAC        ANDNE     *BLANKS                                                    CDL018
179200210712     C                   ADD       1             Idx                                          CDL018
179300210712     C                   EVAL      FldNameArr(Idx) = 'DDRMAC'                                 CDL018
179400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM1025'                                  CDL018
179500210712     C                   MOVE      'N'           DDRmacOK                                     CDL018
179600210712     C                   ENDIF                                                                CDL018
179700210712      *                                                                                       CDL018
179800210712      ** Must be 'Y', 'N' or blanks                                                           CDL018
179900210712      *                                                                                       CDL018
180000210712     C     DDRMAC        IFNE      *BLANKS                                                    CDL018
180100210712     C     DDRMAC        ANDNE     'Y'                                                        CDL018
180200210712     C     DDRMAC        ANDNE     'N'                                                        CDL018
180300210712     C                   ADD       1             Idx                                          CDL018
180400210712     C                   EVAL      FldNameArr(Idx) = 'DDRMAC'                                 CDL018
180500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM1001'                                  CDL018
180600210712     C                   MOVE      'N'           DDRmacOK                                     CDL018
180700210712     C                   ENDIF                                                                CDL018
180800210712      *                                                                                       CDL018
180900210712     C                   ENDSR                                                                CDL018
181000210712      *****************************************************************                       CDL018
181100210712      /EJECT                                                                                  CDL018
181200210712      *****************************************************************                       CLE031
181300210712      *                                                               *                       CLE031
181400210712      * VLREXR - VALIDATE RECEIVE EXCHANGE RATE                       *                       CLE031
181500210712      *                                                               *                       CLE031
181600210712      *****************************************************************                       CLE031
181700210712     C     VLREXR        BEGSR                                                                CLE031
181800210712      *                                                                                       CLE031
181900210712     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
182000210712     C                   MOVE      DDREXR        ZFIELD                                       CLE031
182100210712     C                   Z-ADD     5             ZADIG                                        CLE031
182200210712     C                   Z-ADD     8             ZADEC                                        CLE031
182300210712      *                                                                                       CLE031
182400210712     C                   CALLB     'ZALIGN'                                                   CLE031
182500210712     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
182600210712     C                   PARM      *BLANK        ZALIGNok          1                          CLE106
182700210712     C                   PARM                    ZFIELD                                       CLE031
182800210712     C                   PARM                    ZADEC                                        CLE031
182900210712     C                   PARM                    ZADIG                                        CLE031
183000210712     C**********         PARM      *BLANKS       ZAVAL                                 CLE031 CLE106
183100210712      *                                                                                       CLE031
183200210712     C     DDREXR        IFNE      *BLANKS                                                  MD051932
183300210712     C     ZALIGNok      ANDNE     'Y'                                                      MD051932
183400210712     C                   ADD       1             Idx                                        MD051932
183500210712     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                               MD051932
183600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0865'                                MD051932
183700210712     C                   MOVE      'N'           DDRexrOK                                   MD051932
183800210712     C                   ENDIF                                                              MD051932
183900210712      *                                                                                     MD051932
184000210712     C**********         MOVE      ZAVAL         WMREXR           14 0                 CLE031 CLE106
184100210712     C*****ZAVAL         IFEQ      *BLANKS                                             CLE031 CLE106
184200210712     C                   MOVE      ZFIELD        WMREXR           14 0                        CLE106
184300210712     C     ZFIELD        IFEQ      *BLANKS                                                    CLE106
184400210712     C                   Z-ADD     *ZEROS        WMREXR                                       CLE031
184500210712     C                   ENDIF                                                                CLE031
184600210712      *                                                                                       CLE031
184700210712     C     ARINCY        IFNE      'Y'                                                        CLE031
184800210712      *                                                                                       CLE031
184900210712     C     DDRSCY        IFEQ      *BLANKS                                                    CLE031
185000210712     C     DDREXR        ANDNE     *BLANKS                                                    CLE031
185100210712     C     WMREXR        ANDNE     *ZEROS                                                     CLE031
185200210712     C     DDRSCY        OREQ      *BLANKS                                                    CLE031
185300210712     C     DDREXI        ANDNE     *BLANKS                                                    CLE031
185400210712     C                   ADD       1             Idx                                          CLE031
185500210712     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
185600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0801'                                  CLE031
185700210712     C                   MOVE      'N'           DDRexrOK                                     CLE031
185800210712     C                   ENDIF                                                                CLE031
185900210712      *                                                                                       CLE031
186000210712     C     ##RCCY        IFEQ      BKEURO                                                     CLE031
186100210712     C     BRINCY        ANDEQ     'Y'                                                        CLE031
186200210712     C     ##RCCY        OREQ      BKEURO                                                     CLE031
186300210712     C     DDRSCY        ANDEQ     BKEURO                                                     CLE031
186400210712      *                                                                                       CLE031
186500210712     C     DDREXR        IFNE      *BLANKS                                                    CLE031
186600210712     C     WMREXR        ANDNE     *ZEROS                                                     CLE031
186700210712     C     DDREXI        ORNE      *BLANKS                                                    CLE031
186800210712     C                   ADD       1             Idx                                          CLE031
186900210712     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
187000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0802'                                  CLE031
187100210712     C                   MOVE      'N'           DDRexrOK                                     CLE031
187200210712     C                   ENDIF                                                                CLE031
187300210712     C                   ENDIF                                                                CLE031
187400210712      *                                                                                       CLE031
187500210712     C     ARINCY        IFNE      'Y'                                                        CLE031
187600210712     C     ##RCCY        ANDNE     BKEURO                                                     CLE031
187700210712     C     DDRSCY        ANDNE     *BLANKS                                                    CLE031
187800210712     C     BRINCY        ANDEQ     'Y'                                                        CLE031
187900210712     C                   ADD       1             Idx                                          CLE031
188000210712     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
188100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0810'                                  CLE031
188200210712     C                   MOVE      'N'           DDRexrOK                                     CLE031
188300210712     C                   ENDIF                                                                CLE031
188400210712      *                                                                                       CLE031
188500210712     C     ##PREC        IFNE      'Y'                                                        CLE031
188600210712     C     ##ACTN        OREQ      'X'                                                        CLE031
188700210712     C     DDRSCY        IFNE      *BLANKS                                                    CLE031
188800210712     C*****BRDLCI        ANDNE     'Y'                                               CLE031 MD020816
188900210712     C     BRDLCI        ANDEQ     'N'                                                      MD020816
189000210712     C                   ADD       1             Idx                                          CLE031
189100210712     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
189200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0812'                                  CLE031
189300210712     C                   MOVE      'N'           DDRexrOK                                     CLE031
189400210712     C                   ENDIF                                                                CLE031
189500210712     C                   ENDIF                                                                CLE031
189600210712      *                                                                                       CLE031
189700210712     C     DDRSCY        IFEQ      ##RCCY                                                     CLE031
189800210712     C     DDRSCY        ANDNE     *BLANKS                                                    CLE031
189900210712     C                   ADD       1             Idx                                          CLE031
190000210712     C**********         EVAL      FldNameArr(Idx) = 'DDRexr'                          CLE031 CLE106
190100210712     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'                                 CLE106
190200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0814'                                  CLE031
190300210712     C**********         MOVE      'N'           DDRexrOK                            CLE031 MD051877
190400210712     C                   MOVE      'N'           DDRscyOK                                   MD051877
190500210712     C                   ENDIF                                                                CLE031
190600210712      *                                                                                       CLE031
190700210712     C     DDRSCY        IFNE      *BLANKS                                                  MD051932
190800210712     C     DDRONS        ANDEQ     *BLANKS                                                  MD051932
190900210712     C                   ADD       1             Idx                                        MD051932
191000210712     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'                               MD051932
191100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0816'                                MD051932
191200210712     C                   MOVE      'N'           DDRscyOK                                   MD051932
191300210712     C                   ENDIF                                                              MD051932
191400210712      *                                                                                     MD051932
191500210712     C     DDRexrOK      IFNE      'N'                                                        CLE031
191600210712     C                   MOVEL     *BLANKS       ZMDIX                                        CLE031
191700210712     C     DDREXR        IFEQ      *BLANKS                                                    CLE031
191800210712     C     WMREXR        OREQ      *ZEROS                                                     CLE031
191900210712     C     DDRSCY        IFNE      *BLANKS                                                    CLE031
192000210712     C     CLE033        IFEQ      'Y'                                                        CLE031
192100210712     C     SET09         ANDEQ     'T'                                                        CLE031
192200210712     C     DDRSTM        ANDEQ     '09'                                                       CLE031
192300210712      *                                                                                       CLE031
192400210712      ** Do not want exchange rate default in these circumstances                             CLE031
192500210712      *                                                                                       CLE031
192600210712     C                   ELSE                                                                 CLE031
192700210712      *                                                                                       CLE031
192800210712      ** Calculate cross rate from Receive Ccy to Receive Sett Ccy                            CLE031
192900210712      *                                                                                       CLE031
193000210712     C                   Z-ADD     ARSPRT        ZRATE1                                       CLE031
193100210712     C                   MOVEL     ARMDIN        ZMDI1                                        CLE031
193200210712     C                   Z-ADD     AMREXR        ZRATE2                                       CLE031
193300210712     C                   MOVEL     AMREXI        ZMDI2                                        CLE031
193400210712     C                   CALLB     'ZXRATE'                                                   CLE031
193500210712     C                   PARM                    ZRATE1           13 8                        CLE031
193600210712     C                   PARM                    ZMDI1             1                          CLE031
193700210712     C                   PARM                    ZRATE2           13 8                        CLE031
193800210712     C                   PARM                    ZMDI2             1                          CLE031
193900210712     C                   PARM                    ZRATEX           13 8                        CLE031
194000210712     C                   PARM                    ZMDIX             1                          CLE031
194100210712     C                   MOVE      ZRATEX        DDREXC           14                          CLE031
194200210712     C                   MOVE      ZRATEX        DDREXCR          13 8                        CLE031
194300210712     C                   ENDIF                                                                CLE031
194400210712     C                   ENDIF                                                                CLE031
194500210712      *                                                                                       CLE031
194600210712     C                   ELSE                                                                 CLE031
194700210712      *                                                                                       CLE031
194800210712     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
194900210712     C                   MOVE      DDREXR        ZFIELD           16                          CLE031
195000210712     C                   Z-ADD     5             ZADIG             2 0                        CLE031
195100210712     C                   Z-ADD     8             ZADEC             1 0                        CLE031
195200210712      *                                                                                       CLE031
195300210712     C                   CALLB     'ZALIGN'                                                   CLE031
195400210712     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
195500210712     C                   PARM      *BLANK        ZALIGNok                                     CLE106
195600210712     C                   PARM                    ZFIELD                                       CLE031
195700210712     C                   PARM                    ZADEC                                        CLE031
195800210712     C                   PARM                    ZADIG                                        CLE031
195900210712     C**********         PARM      *BLANKS       ZAVAL            16                   CLE031 CLE106
196000210712      *                                                                                       CLE031
196100210712     C*****PRTCD         IFNE      *BLANK                                              CLE031 CLE106
196200210712     C     ZALIGNok      IFNE      'Y'                                                        CLE106
196300210712     C                   ADD       1             Idx                                          CLE031
196400210712     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
196500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0865'                                  CLE031
196600210712     C                   MOVE      'N'           DDRexrOK                                     CLE031
196700210712     C                   ELSE                                                                 CLE031
196800210712     C**********         MOVE      ZAVAL         DDREXC                                CLE031 CLE106
196900210712     C                   MOVE      ZFIELD        DDREXC                                       CLE106
197000210712     C                   MOVE      DDREXC        DDREXCR          13 8                        CLE031
197100210712     C                   ENDIF                                                                CLE031
197200210712     C                   ENDIF                                                                CLE031
197300210712      *                                                                                       CLE031
197400210712     C*****PRTCD         IFEQ      *BLANKS                                             CLE031 CLE106
197500210712     C     ZALIGNok      IFEQ      'Y'                                                        CLE106
197600210712     C     DDREXC        ANDNE     *BLANKS                                                    CLE031
197700210712     C     DDRSCY        ANDNE     *BLANKS                                                    CLE031
197800210712     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
197900210712     C                   MOVE      DDREXC        ZFIELD                                       CLE031
198000210712     C                   Z-ADD     8             ZADEC                                        CLE031
198100210712     C                   CALLB     'ZEDIT'                                                    CLE031
198200210712     C                   PARM                    ZFIELD                                       CLE031
198300210712     C                   PARM                    ZADEC             1 0                        CLE031
198400210712     C                   MOVE      ZFIELD        DDREXR                                       CLE031
198500210712     C**********         MOVE      DDREXCR       FLREXR                                CLE031 CLE106
198600210712     C                   MOVEL     DDREXCR       FLREXR                                       CLE106
198700210712     C                   ENDIF                                                                CLE031
198800210712     C                   ENDIF                                                                CLE031
198900210712      *                                                                                       CLE031
199000210712     C     DDRexrOK      IFNE      'N'                                                        CLE031
199100210712     C     DDREXI        IFNE      *BLANKS                                                    CLE031
199200210712     C     DDREXI        ANDNE     'M'                                                        CLE031
199300210712     C     DDREXI        ANDNE     'D'                                                        CLE031
199400210712     C                   ADD       1             Idx                                          CLE031
199500210712     C                   EVAL      FldNameArr(Idx) = 'DDRexi'                                 CLE031
199600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0878'                                  CLE031
199700210712     C                   MOVE      'N'           DDRexiOK                                     CLE031
199800210712     C                   ELSE                                                                 CLE031
199900210712      *                                                                                       CLE031
200000210712     C     DDREXI        IFEQ      *BLANKS                                                    CLE031
200100210712     C     DDREXR        ANDNE     *BLANKS                                                    CLE031
200200210712     C     CLE033        IFEQ      'Y'                                                        CLE031
200300210712     C     SET09         ANDEQ     'T'                                                        CLE031
200400210712     C     DDRSTM        ANDEQ     '09'                                                       CLE031
200500210712      *                                                                                       CLE031
200600210712      ** Do not want multiply/divide ind default in these circumstances                       CLE031
200700210712      *                                                                                       CLE031
200800210712     C                   ELSE                                                                 CLE031
200900210712     C     ZMDIX         IFNE      *BLANKS                                                    CLE031
201000210712     C                   MOVEL     ZMDIX         DDREXI                                       CLE031
201100210712     C                   ELSE                                                                 CLE031
201200210712     C                   MOVE      AMREXI        DDREXI                                       CLE031
201300210712     C                   ENDIF                                                                CLE031
201400210712     C                   ENDIF                                                                CLE031
201500210712     C                   ENDIF                                                                CLE031
201600210712     C                   ENDIF                                                                CLE031
201700210712     C                   ENDIF                                                                CLE031
201800210712     C                   MOVEL     DDREXI        FLREXI                                       CLE031
201900210712      *                                                                                       CLE031
202000210712     C                   ELSE                                                                 CLE031
202100210712     C     DDREXR        IFNE      *BLANKS                                                    CLE031
202200210712     C     WMREXR        ANDNE     *ZEROS                                                     CLE031
202300210712     C                   ADD       1             Idx                                          CLE031
202400210712     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
202500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0802'                                  CLE031
202600210712     C                   MOVE      'N'           DDRexrOK                                     CLE031
202700210712     C                   ENDIF                                                                CLE031
202800210712     C     DDREXI        IFNE      *BLANKS                                                    CLE031
202900210712     C                   ADD       1             Idx                                          CLE031
203000210712     C                   EVAL      FldNameArr(Idx) = 'DDRexi'                                 CLE031
203100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0802'                                  CLE031
203200210712     C                   MOVE      'N'           DDRexiOK                                     CLE031
203300210712     C                   ENDIF                                                                CLE031
203400210712      *                                                                                       CLE031
203500210712     C                   ENDIF                                                                CLE031
203600210712      *                                                                                       CLE031
203700210712     C                   ENDSR                                                                CLE031
203800210712      *****************************************************************                       CLE031
203900210712      /EJECT                                                                                  CLE031
204000210712     C*****************************************************************
204100210712     C*                                                               *
204200210712     C* VLRSTM - VALIDATE RECEIVE SETTLEMENT METHOD                   *
204300210712     C*                                                               *
204400210712     C*****************************************************************
204500210712     C     VLRSTM        BEGSR
204600210712      *                                                                                       182114
204700210712      ** RESET A/C CLOSED INDICATOR                                                           182114
204800210712      *                                                                                       182114
204900210712     C                   MOVE      *BLANKS       W#ACOPEN                                     182114
205000210712     C/COPY WNCPYSRC,ZASETINV17                                                               CUT009
205100210712      *
205200210712      ** MUST BE 00,01,02,03,04,05,06,07,08,12 OR 14
205300210712      *
205400210712     C     DDRSTM        IFNE      '00'
205500210712     C     DDRSTM        ANDNE     '01'
205600210712     C     DDRSTM        ANDNE     '02'
205700210712     C     DDRSTM        ANDNE     '03'
205800210712     C     DDRSTM        ANDNE     '04'
205900210712     C     DDRSTM        ANDNE     '05'
206000210712     C     DDRSTM        ANDNE     '06'
206100210712     C     DDRSTM        ANDNE     '07'
206200210712     C     DDRSTM        ANDNE     '08'
206300210712     C     DDRSTM        ANDNE     '12'
206400210712     C     DDRSTM        ANDNE     '14'
206500210712     C     DDRSTM        ANDNE     '  '                                                       246120
206600210712     C     CLE033        ANDNE     'Y'                                                        CLE033
206700210712     C     DDRSTM        ORNE      '00'                                                       CLE033
206800210712     C     DDRSTM        ANDNE     '01'                                                       CLE033
206900210712     C     DDRSTM        ANDNE     '02'                                                       CLE033
207000210712     C     DDRSTM        ANDNE     '03'                                                       CLE033
207100210712     C     DDRSTM        ANDNE     '04'                                                       CLE033
207200210712     C     DDRSTM        ANDNE     '05'                                                       CLE033
207300210712     C     DDRSTM        ANDNE     '06'                                                       CLE033
207400210712     C     DDRSTM        ANDNE     '07'                                                       CLE033
207500210712     C     DDRSTM        ANDNE     '08'                                                       CLE033
207600210712     C     DDRSTM        ANDNE     '12'                                                       CLE033
207700210712     C     DDRSTM        ANDNE     '14'                                                       CLE033
207800210712     C     DDRSTM        ANDNE     '09'                                                       CLE033
207900210712     C     DDRSTM        ANDNE     '  '                                                       246120
208000210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
208100210712     C                   ADD       1             Idx
208200210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
208300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0902'
208400210712     C                   MOVE      'N'           DDRstmOK
208500210712     C                   END
208600210712     C/COPY WNCPYSRC,ZASETINV18                                                               CUT009
208700210712      *                                                                                       CDL051
208800210712     C     CDL051        IFEQ      'Y'                                                        CDL051
208900210712      *                                                                                       CDL051
209000210712      **  If FX or MM deal then settlement instructions must be entered                       CDL051
209100210712     C     ##CALP        IFEQ      'FXDL'                                                     CDL051
209200210712     C     ##CALP        OREQ      'LDNI'                                                     CDL051
209300210712     C     ##CALP        OREQ      'NASP'                                                     CDL051
209400210712     C     ##CALP        OREQ      'NASS'                                                     CDL051
209500210712     C     ##CALP        OREQ      'DEAM'                                                     CDL051
209600210712      *                                                                                       CDL051
209700210712      *                                                                                       CDL051
209800210712     C     DDRSTM        IFEQ      '00'                                                       CDL051
209900210712     C     DDRSTM        OREQ      *Blanks                                                    CDL051
210000210712     C                   EVAL      WIdx = WIdx + 1                                            CDL051
210100210712     C                   EVAL      WFldNameArr(WIdx)  = 'DDRSTM'                              CDL051
210200210712     C                   EVAL      WMsgIDArr(WIdx)    = 'ESM1028'                             CDL051
210300210712     C                   ENDIF                                                                CDL051
210400210712      *                                                                                       CDL051
210500210712     C                   ENDIF                                                                CDL051
210600210712      *                                                                                       CDL051
210700210712     C                   ENDIF                                                                CDL051
210800210712      *                                                                         CDL008
210900210712     C     CDL008        IFEQ      'Y'                                          CDL008
211000210712     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
211100210712     C     ##TTYP        ANDEQ     'CL'                                         CDL008
211200210712     C     DDRSTM        ANDNE     '00'                                         CDL008
211300210712     C     DDRSTM        ANDNE     '01'                                         CDL008
211400210712     C     DDRSTM        ANDNE     '07'                                         CDL008
211500210712     C     DDRSTM        ANDNE     '08'                                         CDL008
211600210712     C     DDRSTM        ANDNE     '02'                                         CDL008
211700210712     C     DDRSTM        ANDNE     '12'                                         CDL008
211800210712     C                   ADD       1             Idx                            CDL008
211900210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                   CDL008
212000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0303'                    CDL008
212100210712     C                   MOVE      'N'           DDRstmOK                       CDL008
212200210712     C                   ENDIF                                                  CDL008
212300210712     C/COPY WNCPYSRC,ZASETNVC34
212400210712      *
212500210712      ** IF SETL TYPE IS 04 OR 14 THE RETAIL MODULE MUST BE PRESENT
212600210712      *
212700210712     C     DDRSTM        IFEQ      '04'
212800210712     C     DDRSTM        OREQ      '14'
212900210712     C     BGRTBN        IFNE      'Y'
213000210712     C                   ADD       1             Idx
213100210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
213200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0903'
213300210712     C                   MOVE      'N'           DDRstmOK
213400210712     C                   END
213500210712     C                   END
213600210712      *
213700210712      ** IF REC SETL METHOD IS 04 A LIVE RECORD MUST EXIST IN ACCNTAB
213800210712      *
213900210712     C     DDRSTM        IFEQ      '04'
214000210712     C                   MOVEL     ##CSNM        @ACID
214100210712     C                   MOVE      E#RCCY        @CYCD
214200210712     C                   MOVE      BMACCD        @ACCD
214300210712     C                   MOVE      '01'          @ACSN
214400210712     C                   MOVE      ##BRCA        @BRCA
214500210712      *
214600210712      ** SET UP SETTLEMENT BRANCH
214700210712      *
214800210712     C                   MOVE      ##BRCA        DDROBR
214900210712     C                   MOVE      ##BRCA        FLROBR
215000210712      *
215100210712      **  FOR STANDING DATA - EXTENDED SETTLEMENTS:
215200210712      **  WITH SETTLEMENT TYPE 04 CHECKING OF ACCOUNT WON'T BE DONE
215300210712      *
215400210712     C     ##CALP        IFNE      'SSI '
215500210712      *
215600210712      * ACCESS ACCOUNT DETAILS
215700210712      *
215800210712     C                   EXSR      ACACCT
215900210712      *
216000210712      * ACCOUNT IS CLOSED
216100210712      *
216200210712     C     @RTCD         IFNE      *BLANKS
216300210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
216400210712     C     RECI          ORNE      'D'
216500210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
216600210712     C     ACST          OREQ      'C'
216700210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
216800210712     C                   IF        ##PREC = 'Y'                                              BUG6010
216900210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
217000210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
217100210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRSTM'                              BUG6010
217200210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1104'                               BUG6010
217300210712     C                   ENDIF                                                               BUG6010
217400210712     C                   ELSE                                                                BUG6010
217500210712     C                   ADD       1             Idx
217600210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
217700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0904'
217800210712     C                   MOVE      'N'           DDRstmOK
217900210712     C                   ENDIF                                                               BUG6010
218000210712     C                   ELSE                                                                 182114
218100210712      *                                                                                       182114
218200210712     C                   MOVE      'Y'           W#ACOPEN                                     182114
218300210712      *                                                                                       182114
218400210712      ** Ensure account is not blocked for Debit/Credit                                       182114
218500210712      *                                                                                       182114
218600210712     C                   TESTB     '2'           RETB                     91    DEBIT         182114
218700210712     C                   TESTB     '3'           RETB                     92    CREDIT        182114
218800210712     C/COPY WNCPYSRC,ZAH00045
218900210712      *                                                                                       182114
219000210712      ** A/C IS BLOCKED                                                                       182114
219100210712      *                                                                                       182114
219200210712     C     ##PREC        IFNE      'Y'                                                        260863
219300210712      *                                                                                       CLE168
219400210712      ** Allow debit of blocked account when bankrupt flag is 'Y'                             CLE168
219500210712      *                                                                                       CLE168
219600210712     C                   IF        *IN91 = '1' AND CLE168 = 'Y'                               CLE168
219700210712     C                   IF        ##CALP = 'LERI' OR ##CALP = 'LEND'                         CLE168
219800210712     C                             OR ##CALP = 'MAPY'                                         CLE168
219900210712     C                   IF        A_XBKPT = 'Y'                                              CLE168
220000210712     C                   EVAL      WIdx = WIdx + 1                                            CLE168
220100210712     C                   EVAL      WFldNameArr(WIdx)  = 'DDRONX'                              CLE168
220200210712     C                   EVAL      WMsgIDArr(WIdx)    = 'XXX8000'                             CLE168
220300210712     C                   ELSE                                                                 CLE168
220400210712     C                   ADD       1             Idx                                          CLE168
220500210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 CLE168
220600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'                                  CLE168
220700210712     C                   MOVE      'N'           DDRonxOK                                     CLE168
220800210712     C                   ENDIF                                                                CLE168
220900210712     C                   ELSE                                                               MD056313
221000210712     C                   ADD       1             WIdx                                       MD056313
221100210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                             MD056313
221200210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                              MD056313
221300210712     C                   MOVE      'W'           DDRonxOK                                   MD056313
221400210712     C                   ENDIF                                                                CLE168
221500210712     C                   ELSE                                                                 CLE168
221600210712      *                                                                                       CLE168
221700210712     C     *IN91         IFEQ      '1'                                                        182114
221800210712     C     *IN92         OREQ      '1'                                                        182114
221900210712     C**********         ADD       1             Idx                                182114 MD034521A
222000210712     C**********         EVAL      FldNameArr(Idx) = 'DDRONX'                       182114 MD034521A
222100210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0991'                        182114 MD034521A
222200210712     C**********         MOVE      'N'           DDRonxOK                           182114 MD034521A
222300210712     C                   ADD       1             WIdx                                      MD034521A
222400210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                            MD034521A
222500210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                             MD034521A
222600210712     C                   MOVE      'W'           DDRonxOK                                  MD034521A
222700210712     C                   END                                                                  182114
222800210712     C                   ENDIF                                                                CLE168
222900210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
223000210712     C                   ENDIF                                                                260863
223100210712     C                   END
223200210712                                                                                              CRE008
223300210712      ** Set up Account ID for Overdraft Limit Check                                          CRE008
223400210712                                                                                              CRE008
223500210712     C                   IF        CDL008 = 'Y'                                               CRE008
223600210712     C                             OR CGL014 = 'Y'                                            CGL014
223700210712     C                   EVAL      WkCust = CNUM                                              CRE008
223800210712     C                   EVAL      WkCcy  = CCY                                               CRE008
223900210712     C                   EVAL      WkACOD = ACOD                                              CRE008
224000210712     C                   EVAL      WkASeq = ACSQ                                              CRE008
224100210712     C                   EVAL      WkBRCA = BRCA                                              CRE008
224200210712     C                   ENDIF                                                                CRE008
224300210712      *
224400210712     C                   END
224500210712     C                   END
224600210712      *
224700210712      ** IF SETL TYPE IS 07 THE RECEIPT CURRENCY MUST BE USD
224800210712      *
224900210712     C     DDRSTM        IFEQ      '07'
225000210712     C     E#RCCY        ANDNE     'USD'
225100210712     C                   ADD       1             Idx
225200210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
225300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0905'
225400210712     C                   MOVE      'N'           DDRstmOK
225500210712     C                   END
225600210712      *
225700210712      ** IF SETL TYPE IS 14, RETAIL ACCOUNT NUMBERS MUST BE SUPPORTED
225800210712      *
225900210712     C     DDRSTM        IFEQ      '14'
226000210712     C     BMRANR        ANDNE     'Y'
226100210712     C                   ADD       1             Idx
226200210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
226300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0906'
226400210712     C                   MOVE      'N'           DDRstmOK
226500210712     C                   END
226600210712                                                                                              CGL014
226700210712     C                   IF        DDRSTM = '14' AND CGL014 = 'Y'                             CGL014
226800210712     C                   MOVEL     DDRONX        WRcRetail                                    CGL014
226900210712     C                   ENDIF                                                                CGL014
227000210712      *                                                                                       CLE033
227100210712      ** IF SETL TYPE IS 09, SET CORRECT CURRENCY UP ACCORDING TO                             CLE033
227200210712      ** SYSTEM VALUE                                                                         CLE033
227300210712      *                                                                                       CLE033
227400210712     C     DDRSTM        IFEQ      '09'                                                       CLE033
227500210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
227600210712     C     A5ACTY        ANDEQ     'R'                                                        CLE033
227700210712      *                                                                                       CLE033
227800210712     C     DDRSCY        IFNE      *BLANKS                                                    CLE033
227900210712     C     SET09         ANDNE     'T'                                                        CLE033
228000210712     C                   MOVEL     DDRSCY        W0RSCY            3                          CLE033
228100210712     C                   END                                                                  CLE033
228200210712      *                                                                                       CLE033
228300210712     C     DDRSCY        IFEQ      *BLANKS                                                    CLE033
228400210712     C     SET09         OREQ      'T'                                                        CLE033
228500210712     C                   MOVEL     ##RCCY        W0RSCY                                       CLE033
228600210712     C                   END                                                                  CLE033
228700210712      *                                                                                       CLE033
228800210712     C                   MOVEL     P@VL02        W0ACCD           10                          CLE033
228900210712     C                   MOVEL     P@VL01        W0CNUM            6                          CLE033
229000210712      *                                                                                       CLE033
229100210712      ** For Settlement Type 09 for SSI, only partial checking of                             CLE033
229200210712      ** account entered can be done, as not all details are available.                       CLE033
229300210712      ** Therefore subroutine ACACCT should not be called.                                    CLE033
229400210712      *                                                                                       CLE033
229500210712     C     ##CALP        IFNE      'SSI '                                                     CLE033
229600210712     C*                                                                                       CLE033
229700210712     C                   MOVEL     *BLANKS       @ACID                                        CLE033
229800210712     C                   MOVEL     W0CNUM        @ACID                                        CLE033
229900210712     C                   MOVE      W0RSCY        @CYCD                                        CLE033
230000210712     C                   MOVE      W0ACCD        @ACCD                                        CLE033
230100210712     C                   MOVE      '01'          @ACSN                                        CLE033
230200210712     C                   MOVE      ##BRCA        @BRCA                                        CLE033
230300210712     C                   EXSR      ACACCT                                                     CLE033
230400210712     C*                                                                                       CLE033
230500210712     C     @RTCD         IFNE      *BLANKS                                                    CLE033
230600210712     C     RECI          ORNE      'D'                                                        CLE033
230700210712     C     ATYP          ORNE      'R'                                                        CLE033
230800210712     C                   ADD       1             Idx                                          CLE033
230900210712     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                                 CLE033
231000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0904'                                  CLE033
231100210712     C                   MOVE      'N'           DDRstmOK                                     CLE033
231200210712     C                   ENDIF                                                                CLE033
231300210712     C*                                                                                       CLE033
231400210712     C                   ENDIF                                                                CLE033
231500210712      *                                                                                       CLE033
231600210712     C                   ENDIF                                                                CLE033
231700210712      *
231800210712     C                   ENDSR
231900210712     C********************************************************************
232000210712      /EJECT
232100210712     C*****************************************************************
232200210712     C*                                                               *
232300210712     C* VLROBR - VALIDATE RECEIVE SETTLEMENT BRANCH                   *
232400210712     C*                                                               *
232500210712     C*****************************************************************
232600210712     C     VLROBR        BEGSR
232700210712      *
232800210712      ** IF SETTLEMENT METHOD IS 05
232900210712      *
233000210712     C     DDRSTM        IFEQ      '05'
233100210712      *
233200210712      ** SETTLEMENT BRANCH IS MANDATORY
233300210712      *
233400210712     C     DDROBR        IFEQ      *BLANKS
233500210712     C                   ADD       1             Idx
233600210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
233700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0885'
233800210712     C                   MOVE      'N'           DDRonxOK
233900210712     C                   ELSE
234000210712      *
234100210712      ** NOW VALIDATE SETTLEMENT BRANCH
234200210712      *
234300210712     C                   MOVE      DDROBR        @BRCA
234400210712     C                   EXSR      ACBRCH
234500210712      *
234600210712      * NO SELECTION
234700210712      *
234800210712     C     @RTCD         IFEQ      '*NOSEL '
234900210712     C                   ADD       1             Idx
235000210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
235100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0863'
235200210712     C                   MOVE      'N'           DDRonxOK
235300210712     C                   END
235400210712      *
235500210712      * ERROR IN SETTLEMENT BRANCH
235600210712      *
235700210712     C     @RTCD         IFNE      *BLANKS
235800210712     C                   ADD       1             Idx
235900210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
236000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0884'
236100210712     C                   MOVE      'N'           DDRonxOK
236200210712     C                   ELSE
236300210712     C                   MOVE      @DSNB         DDROBR
236400210712     C                   MOVE      @DSNB         FLROBR
236500210712     C                   END
236600210712     C                   END
236700210712      *                                                                                       CLE033
236800210712     C                   ELSE                                                                 CLE033
236900210712     C     CLE033        IFEQ      'Y'                                                        CLE033
237000210712     C     DDRSTM        ANDEQ     '09'                                                       CLE033
237100210712     C                   MOVEL     DDROBR        FLROBR                                       CLE033
237200210712     C                   ENDIF                                                                CLE033
237300210712      *                                                                                       CLE033
237400210712     C                   END
237500210712      *
237600210712     C                   ENDSR
237700210712     C*****************************************************************
237800210712      /EJECT
237900210712     C*****************************************************************
238000210712     C*                                                               *
238100210712     C* VLRONS - VALIDATE OUR RECEIVE NOSTRO                          *
238200210712     C*                                                               *
238300210712     C*****************************************************************
238400210712     C     VLRONS        BEGSR
238500210712      *
238600210712      ** RESET A/C CLOSED INDICATOR
238700210712      *
238800210712     C                   MOVE      *BLANKS       W#ACOPEN          1
238900210712      *
239000210712      ** MOVE OUR NOSTRO INTO OUR ACCOUNT DATA STRUCTURE
239100210712      *
239200210712     C                   MOVE      DDRONS        A#OURA
239300210712     C                   EVAL      SETTF = 'R'                                               CSF011A
239400210712      *
239500210712      ** OUR NOSTRO MUST BE BLANK IF SETTLEMENT TYPE IS 00,04 OR 06
239600210712      *
239700210712     C     DDRSTM        IFEQ      '00'
239800210712     C     DDRSTM        OREQ      '04'
239900210712     C     DDRSTM        OREQ      '06'
240000210712     C     DDRONS        IFNE      *BLANKS
240100210712     C                   ADD       1             Idx
240200210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
240300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0907'
240400210712     C                   MOVE      'N'           DDRonxOK
240500210712     C                   END
240600210712     C                   END
240700210712      *
240800210712      ** IF SETL TYPE IS 01,02,07,08 OR 12 MUST BE A 2 DIGIT NUMBER
240900210712      ** AND IDENTIFY A LIVE RECORD ON THE NOSTRO FILE SDNOSTPD
241000210712      *
241100210712     C     DDRSTM        IFEQ      '01'
241200210712     C     DDRSTM        OREQ      '02'
241300210712     C     DDRSTM        OREQ      '07'
241400210712     C     DDRSTM        OREQ      '08'
241500210712     C     DDRSTM        OREQ      '12'
241600210712      *
241700210712     C/COPY WNCPYSRC,ZASETINVC2
241800210712      *
241900210712      ** CHECK OTHER 10 CHARACTERS ARE BLANK
242000210712      *
242100210712     C                   TESTN                   A#NOST               99
242200210712     C     *IN99         IFNE      '1'
242300210712     C     A#REST        ORNE      *BLANKS
242400210712     C                   ADD       1             Idx
242500210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
242600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0908'
242700210712     C                   MOVE      'N'           DDRonxOK
242800210712     C                   ELSE
242900210712      *
243000210712      * NOW VALIDATE NOSTRO CODE
243100210712      *
243200210712     C                   MOVE      E#RCCY        @CYCD
243300210712     C                   MOVE      A#NOST        @NONB
243400210712      *
243500210712      * ACCESS NOSTRO DETAILS
243600210712      *
243700210712     C                   EXSR      ACNOST
243800210712      *
243900210712      * NOSTRO NOT FOUND
244000210712      *
244100210712     C     @RTCD         IFNE      *BLANKS
244200210712     C                   IF        ##PREC = 'Y'                                               260863
244300210712     C                   IF        ##ACTN <> 'R'                                              260863
244400210712     C                   EVAL      WIdx = WIdx + 1                                            260863
244500210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                               260863
244600210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1111'                                260863
244700210712     C                   MOVE      'W'           DDRonxOK                                     260863
244800210712     C                   ENDIF                                                                260863
244900210712     C                   ELSE                                                                 260863
245000210712     C                   ADD       1             Idx
245100210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
245200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0908'
245300210712     C                   MOVE      'N'           DDRonxOK
245400210712     C                   ENDIF                                                                260863
245500210712     C                   ELSE
245600210712      *
245700210712      ** NOSTRO GL ACCOUNT
245800210712      *
245900210712     C     CDL008        IFEQ      'Y'                                          CDL008
246000210712      *                                                                         CDL008
246100210712     C     ##TTYP        IFEQ      'CL'                                         CDL008
246200210712     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
246300210712     C     A7CLSD        ANDNE     'Y'                                          CDL008
246400210712     C                   ADD       1             Idx                            CDL008
246500210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                   CDL008
246600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0301'                    CDL008
246700210712     C                   MOVE      'N'           DDRonxOK                       CDL008
246800210712     C                   ENDIF                                                  CDL008
246900210712      *                                                                         CDL008
247000210712     C     ##TTYP        IFNE      'CL'                                         CDL008
247100210712     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
247200210712     C     A7CLSD        ANDEQ     'Y'                                          CDL008
247300210712     C                   ADD       1             Idx                            CDL008
247400210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                   CDL008
247500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0305'                    CDL008
247600210712     C                   MOVE      'N'           DDRonxOK                       CDL008
247700210712     C                   ENDIF                                                  CDL008
247800210712      *                                                                         CDL008
247900210712     C                   ENDIF                                                  CDL008
248000210712      *                                                                         CDL008
248100210712     C                   MOVEL     *BLANKS       @ACID
248200210712     C                   MOVEL     A7CUST        @ACID
248300210712     C                   MOVE      E#RCCY        @CYCD
248400210712     C                   MOVE      A7ACCD        @ACCD
248500210712     C                   MOVE      A7ACSN        @ACSN
248600210712     C                   MOVE      A7BRCD        @BRCA
248700210712      *
248800210712      ** SET UP SETTLEMENT BRANCH
248900210712      *
249000210712     C                   MOVE      A7BRCD        DDROBR
249100210712     C                   MOVE      A7BRCD        FLROBR
249200210712      *
249300210712      * ACCESS ACCOUNT DETAILS
249400210712      *
249500210712     C                   EXSR      ACACCT
249600210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
249700210712     C                   EXSR      CSFACT                                                    CSF011A
249800210712     C                   ENDIF                                                               CSF011A
249900210712      *
250000210712      * ACCOUNT IS CLOSED
250100210712      *
250200210712     C     @RTCD         IFNE      *BLANKS
250300210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
250400210712     C     RECI          ORNE      'D'
250500210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
250600210712      *                                                                                      BUG6010
250700210712      ** Warn if the account is closed.                                                      BUG6010
250800210712      *                                                                                      BUG6010
250900210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
251000210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
251100210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                              BUG6010
251200210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1105'                               BUG6010
251300210712     C                   ENDIF                                                               BUG6010
251400210712     C                   ELSE
251500210712      *
251600210712     C                   MOVE      'Y'           W#ACOPEN
251700210712      *                                                                                       182114
251800210712      ** Ensure account is not blocked for Debit/Credit                                       182114
251900210712      *                                                                                       182114
252000210712     C                   TESTB     '2'           RETB                     91    DEBIT         182114
252100210712     C/COPY WNCPYSRC,ZAH00046
252200210712      *                                                                                       182114
252300210712      ** A/C IS BLOCKED                                                                       182114
252400210712      *                                                                                       182114
252500210712     C     ##PREC        IFNE      'Y'                                                        260863
252600210712      *                                                                                       CLE168
252700210712      ** Allow debit of blocked account when bankrupt flag is 'Y'                             CLE168
252800210712      *                                                                                       CLE168
252900210712     C                   IF        *IN91 = '1' AND CLE168 = 'Y'                               CLE168
253000210712     C                   IF        ##CALP = 'LERI' OR ##CALP = 'LEND'                         CLE168
253100210712     C                             OR ##CALP = 'MAPY'                                         CLE168
253200210712     C                   IF        A_XBKPT = 'Y'                                              CLE168
253300210712     C                   EVAL      WIdx = WIdx + 1                                            CLE168
253400210712     C                   EVAL      WFldNameArr(WIdx)  = 'DDRONX'                              CLE168
253500210712     C                   EVAL      WMsgIDArr(WIdx)    = 'XXX8000'                             CLE168
253600210712     C                   ELSE                                                                 CLE168
253700210712     C                   ADD       1             Idx                                          CLE168
253800210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 CLE168
253900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'                                  CLE168
254000210712     C                   MOVE      'N'           DDRonxOK                                     CLE168
254100210712     C                   ENDIF                                                                CLE168
254200210712     C                   ELSE                                                               MD056313
254300210712     C                   ADD       1             WIdx                                       MD056313
254400210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                             MD056313
254500210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                              MD056313
254600210712     C                   MOVE      'W'           DDRonxOK                                   MD056313
254700210712     C                   ENDIF                                                                CLE168
254800210712     C                   ELSE                                                                 CLE168
254900210712      *                                                                                       CLE168
255000210712     C     *IN91         IFEQ      '1'                                                        182114
255100210712     C**********         ADD       1             Idx                                182114 MD034521A
255200210712     C**********         EVAL      FldNameArr(Idx) = 'DDRONX'                       182114 MD034521A
255300210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0991'                        182114 MD034521A
255400210712     C**********         MOVE      'N'           DDRonxOK                           182114 MD034521A
255500210712     C                   ADD       1             WIdx                                      MD034521A
255600210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                            MD034521A
255700210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                             MD034521A
255800210712     C                   MOVE      'W'           DDRonxOK                                  MD034521A
255900210712     C                   END                                                                  182114
256000210712     C                   ENDIF                                                                CLE168
256100210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
256200210712     C                   ENDIF                                                                260863
256300210712      *
256400210712      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
256500210712      *
256600210712     C     @MBIN         IFEQ      'N'
256700210712     C     BJSBRC        ANDNE     A7BRCD
256800210712     C                   ADD       1             Idx
256900210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
257000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0500'
257100210712     C                   MOVE      'N'           DDRonxOK
257200210712     C                   END
257300210712      *
257400210712      ** RETRIEVE BRANCH INTERNAL CUSTOMER NUMBER ASSOCIATED WITH
257500210712      ** NOSTRO BRANCH FOR VALIDATION LATER.
257600210712      *
257700210712     C                   MOVE      A7BRCD        @BRCA
257800210712     C                   EXSR      ACBRCH
257900210712     C                   MOVEL     A8BICN        @RBICN            6
258000210712      *
258100210712     C                   END
258200210712                                                                                              CRE008
258300210712      ** Set up Account ID for Overdraft Limit Check                                          CRE008
258400210712                                                                                              CRE008
258500210712     C                   IF        CDL008 = 'Y'                                               CRE008
258600210712     C                   EVAL      WkCust = CNUM                                              CRE008
258700210712     C                   EVAL      WkCcy  = CCY                                               CRE008
258800210712     C                   EVAL      WkACOD = ACOD                                              CRE008
258900210712     C                   EVAL      WkASeq = ACSQ                                              CRE008
259000210712     C                   EVAL      WkBRCA = BRCA                                              CRE008
259100210712     C                   ENDIF                                                                CRE008
259200210712                                                                                              CRE008
259300210712     C                   END
259400210712     C                   END
259500210712     C                   END
259600210712      *
259700210712      ** IF SETTLEMENT TYPE IS 03, 'OUR NOSTRO' MUST EITHER BE BLANK OR
259800210712      ** CONTAIN A SIX DIGIT DEAL NUMBER (TO COMPENSATE AGAINST).
259900210712      *
260000210712     C     DDRSTM        IFEQ      '03'
260100210712     C     A#OURA        ANDNE     *BLANKS
260200210712     C                   TESTN                   A#CNUM               99
260300210712     C     *IN99         IFNE      '1'
260400210712     C     A#ACAS        ORNE      *BLANKS
260500210712     C                   ADD       1             Idx
260600210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
260700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0909'
260800210712     C                   MOVE      'N'           DDRonxOK
260900210712     C                   ELSE                                                                CSF011A
261000210712     C                   EVAL      @RTCD = *BLANKS                                           CSF011A
261100210712     C                   EVAL      W@TYPE = 'CUST'                                           CSF011A
261200210712     C                   EXSR      CSFACT                                                    CSF011A
261300210712     C                   END
261400210712     C                   END
261500210712      *
261600210712      ** IF SETLEMENT TYPE IS 05 MUST IDENTIFY A LIVE RECORD ON ACCNTAB
261700210712      ** (IN COMBINATION WITH RECEIPT CURRENCY)
261800210712      *
261900210712     C     DDRSTM        IFEQ      '05'
262000210712      *
262100210712     C                   MOVEL     DDRONX        WDRONX           21                       MD024884A
262200210712     C     DDRONX        IFNE      *BLANKS                                                  BUG12624
262300210712     C     A#ACSQ        IFEQ      *BLANKS
262400210712     C     A#ACSQ        OREQ      '00'
262500210712     C                   MOVE      '01'          A#ACSQ
262600210712     C                   MOVE      A#ACSQ        DDRONX                                      BUG6393
262700210712     C                   END
262800210712      *
262900210712     C**********         TESTN                   A#CNUM               99                      CSD027
263000210712     C***99*****         TESTN                   A#ACOD               99                      CSD027
263100210712     C                   TESTN                   A#ACOD               99                      CSD027
263200210712     C   99              TESTN                   A#ACSQ               99
263300210712      *
263400210712      ** INVALID CUSTOMER, A/C CODE & A/C SEQUENCE
263500210712      *
263600210712     C     *IN99         IFNE      '1'
263700210712     C                   ADD       1             Idx
263800210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
263900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0910'
264000210712     C                   MOVE      'N'           DDRonxOK
264100210712     C                   ELSE
264200210712      *
264300210712     C                   MOVEL     *BLANKS       @ACID
264400210712     C                   MOVEL     A#CNUM        @ACID
264500210712     C                   MOVE      E#RCCY        @CYCD
264600210712     C                   MOVE      A#ACSQ        @ACSN
264700210712     C                   MOVE      A#ACOD        @ACCD
264800210712      *
264900210712      * Default branch
265000210712      *
265100210712     C     @MBIN         IFEQ      'N'
265200210712     C                   MOVE      BJSBRC        DDROBR
265300210712     C                   MOVE      BJSBRC        FLROBR
265400210712     C                   END
265500210712      *
265600210712     C                   MOVE      DDROBR        @BRCA
265700210712      *
265800210712      * ACCESS ACCOUNT DETAILS
265900210712      *
266000210712     C                   EXSR      ACACCT
266100210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
266200210712     C                   EXSR      CSFACT                                                    CSF011A
266300210712     C                   ENDIF                                                               CSF011A
266400210712      *
266500210712      * ACCOUNT IS CLOSED
266600210712      *
266700210712     C     @RTCD         IFNE      *BLANKS
266800210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
266900210712     C     RECI          ORNE      'D'
267000210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
267100210712     C     ACST          OREQ      'C'
267200210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
267300210712     C                   IF        ##PREC = 'Y'                                              BUG6010
267400210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
267500210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
267600210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                              BUG6010
267700210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1110'                               BUG6010
267800210712     C                   ENDIF                                                               BUG6010
267900210712     C                   ELSE                                                                BUG6010
268000210712     C                   ADD       1             Idx
268100210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
268200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0910'
268300210712     C                   MOVE      'N'           DDRonxOK
268400210712     C                   ENDIF                                                               BUG6010
268500210712     C                   ELSE
268600210712     C                   MOVE      'Y'           W#ACOPEN
268700210712     C                   MOVE      A#OURA        DDRONS
268800210712      *                                                                                       182114
268900210712      ** Ensure account is not blocked for Debit/Credit                                       182114
269000210712      *                                                                                       182114
269100210712     C                   TESTB     '2'           RETB                     91    DEBIT         182114
269200210712     C/COPY WNCPYSRC,ZAH00047
269300210712      *                                                                                       182114
269400210712      ** A/C IS BLOCKED                                                                       182114
269500210712      *                                                                                       182114
269600210712     C     ##PREC        IFNE      'Y'                                                        260863
269700210712      *                                                                                       CLE168
269800210712      ** Allow debit of blocked account when bankrupt flag is 'Y'                             CLE168
269900210712      *                                                                                       CLE168
270000210712     C                   IF        *IN91 = '1' AND CLE168 = 'Y'                               CLE168
270100210712     C                   IF        ##CALP = 'LERI' OR ##CALP = 'LEND'                         CLE168
270200210712     C                             OR ##CALP = 'MAPY'                                         CLE168
270300210712     C                   IF        A_XBKPT = 'Y'                                              CLE168
270400210712     C                   EVAL      WIdx = WIdx + 1                                            CLE168
270500210712     C                   EVAL      WFldNameArr(WIdx)  = 'DDRONX'                              CLE168
270600210712     C                   EVAL      WMsgIDArr(WIdx)    = 'XXX8000'                             CLE168
270700210712     C                   ELSE                                                                 CLE168
270800210712     C                   ADD       1             Idx                                          CLE168
270900210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 CLE168
271000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'                                  CLE168
271100210712     C                   MOVE      'N'           DDRonxOK                                     CLE168
271200210712     C                   ENDIF                                                                CLE168
271300210712     C                   ELSE                                                               MD056313
271400210712     C                   ADD       1             WIdx                                       MD056313
271500210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                             MD056313
271600210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                              MD056313
271700210712     C                   MOVE      'W'           DDRonxOK                                   MD056313
271800210712     C                   ENDIF                                                                CLE168
271900210712     C                   ELSE                                                                 CLE168
272000210712      *                                                                                       CLE168
272100210712     C     *IN91         IFEQ      '1'                                                        182114
272200210712     C**********         ADD       1             Idx                                182114 MD034521A
272300210712     C**********         EVAL      FldNameArr(Idx) = 'DDRONX'                       182114 MD034521A
272400210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0991'                        182114 MD034521A
272500210712     C**********         MOVE      'N'           DDRonxOK                           182114 MD034521A
272600210712     C                   ADD       1             WIdx                                      MD034521A
272700210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                            MD034521A
272800210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                             MD034521A
272900210712     C                   MOVE      'W'           DDRonxOK                                  MD034521A
273000210712     C                   END                                                                  182114
273100210712     C                   ENDIF                                                                CLE168
273200210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
273300210712     C                   ENDIF                                                                260863
273400210712     C                   END
273500210712                                                                                              CRE008
273600210712      ** Set up Account ID for Overdraft Limit Check                                          CRE008
273700210712                                                                                              CRE008
273800210712     C                   IF        CDL008 = 'Y'                                               CRE008
273900210712     C                   EVAL      WkCust = CNUM                                              CRE008
274000210712     C                   EVAL      WkCcy  = CCY                                               CRE008
274100210712     C                   EVAL      WkACOD = ACOD                                              CRE008
274200210712     C                   EVAL      WkASeq = ACSQ                                              CRE008
274300210712     C                   EVAL      WkBRCA = BRCA                                              CRE008
274400210712     C                   ENDIF                                                                CRE008
274500210712      *
274600210712     C                   END
274700210712     C                   ENDIF                                                              BUG12624
274800210712     C                   IF        DDRonxOK = 'N'                                          MD024884A
274900210712     C                   MOVEL     WDRONX        DDRONX                                    MD024884A
275000210712     C                   ENDIF                                                             MD024884A
275100210712     C                   END
275200210712      *
275300210712      ** IF SETL TYPE IS 14, NOSTRO MUST CONTAIN A 10 DIGIT NUMBER
275400210712      ** WHICH IDENTIFIES A LIVE RECORD ON FILE ACCNTAB
275500210712      *
275600210712     C     DDRSTM        IFEQ      '14'
275700210712     C                   TESTN                   A#RENO               99
275800210712      *
275900210712      ** INVALID RETAIL A/C NUMBER
276000210712      *
276100210712     C     *IN99         IFNE      '1'
276200210712     C     A#ACSQ        ORNE      *BLANKS
276300210712     C     A#RES2        ORNE      *BLANKS                                                    248393
276400210712     C                   ADD       1             Idx
276500210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
276600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0911'
276700210712     C                   MOVE      'N'           DDRonxOK
276800210712     C                   ELSE
276900210712      *
277000210712     C                   MOVEL     A#RENO        @ACID
277100210712     C                   MOVE      *BLANKS       @CYCD
277200210712     C                   MOVE      *BLANKS       @ACSN
277300210712     C                   MOVE      *BLANKS       @ACCD
277400210712     C                   MOVE      *BLANKS       @BRCA
277500210712      *
277600210712      * ACCESS ACCOUNT DETAILS
277700210712      *
277800210712     C                   EXSR      ACACCT
277900210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
278000210712     C                   EXSR      CSFACT                                                    CSF011A
278100210712     C                   ENDIF                                                               CSF011A
278200210712      *
278300210712      * ACCOUNT IS CLOSED
278400210712      *
278500210712     C     @RTCD         IFNE      *BLANKS
278600210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
278700210712     C     RECI          ORNE      'D'
278800210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
278900210712     C     ACST          OREQ      'C'
279000210712     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
279100210712     C                   IF        ##PREC = 'Y'                                              BUG6010
279200210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
279300210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
279400210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                              BUG6010
279500210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1111'                               BUG6010
279600210712     C                   ENDIF                                                               BUG6010
279700210712     C                   ELSE                                                                BUG6010
279800210712     C**********         IF        ##ACTN <> 'R' AND ##PREC <> 'Y'                AR1096686 MD021526
279900210712     C**********                   AND ACST = 'C' AND @RTCD = '*ACST'             AR1096686 MD021526
280000210712     C**********         EVAL      WIdx = WIdx + 1                                AR1096686 MD021526
280100210712     C**********         EVAL      WFldNameArr(WIdx) = 'DDRONX'                   AR1096686 MD021526
280200210712     C**********         EVAL      WMsgIDArr(WIdx) = 'ESM1111'                    AR1096686 MD021526
280300210712     C**********         EVAL      WARN_RFLAG = 'Y'                               AR1096686 MD021526
280400210712     C**********         ENDIF                                                    AR1096686 MD021526
280500210712      *****************************************************************           AR1096686 MD021526
280600210712      ***Bypass*error*message*when*warning*is*already*been*issued******           AR1096686 MD021526
280700210712      *****************************************************************           AR1096686 MD021526
280800210712     C**********         IF        WARN_RFLAG <> 'Y'                              AR1096686 MD021526
280900210712     C                   ADD       1             Idx
281000210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
281100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0911'
281200210712     C                   MOVE      'N'           DDRonxOK
281300210712     C**********         ENDIF                                                    AR1096686 MD021526
281400210712     C                   ENDIF                                                               BUG6010
281500210712     C                   ELSE
281600210712      *
281700210712     C                   MOVE      'Y'           W#ACOPEN
281800210712      *
281900210712      ** Ensure account is not blocked for Debit/Credit
282000210712      *
282100210712     C                   TESTB     '2'           RETB                     91    DEBIT
282200210712     C**********         TESTB     '3'           RETB                     92    CREDIT        182114
282300210712     C/COPY WNCPYSRC,ZAH00048
282400210712      *
282500210712      ** A/C IS BLOCKED
282600210712      *
282700210712     C     ##PREC        IFNE      'Y'                                                        260863
282800210712      *                                                                                       CLE168
282900210712      ** Allow debit of blocked account when bankrupt flag is 'Y'                             CLE168
283000210712      *                                                                                       CLE168
283100210712     C                   IF        *IN91 = '1' AND CLE168 = 'Y'                               CLE168
283200210712     C                   IF        ##CALP = 'LERI' OR ##CALP = 'LEND'                         CLE168
283300210712     C                             OR ##CALP = 'MAPY'                                         CLE168
283400210712     C                   IF        A_XBKPT = 'Y'                                              CLE168
283500210712     C                   EVAL      WIdx = WIdx + 1                                            CLE168
283600210712     C                   EVAL      WFldNameArr(WIdx)  = 'DDRONX'                              CLE168
283700210712     C                   EVAL      WMsgIDArr(WIdx)    = 'XXX8000'                             CLE168
283800210712     C                   ELSE                                                                 CLE168
283900210712     C                   ADD       1             Idx                                          CLE168
284000210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 CLE168
284100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'                                  CLE168
284200210712     C                   MOVE      'N'           DDRonxOK                                     CLE168
284300210712     C                   ENDIF                                                                CLE168
284400210712     C                   ELSE                                                               MD056313
284500210712     C                   ADD       1             WIdx                                       MD056313
284600210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                             MD056313
284700210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                              MD056313
284800210712     C                   MOVE      'W'           DDRonxOK                                   MD056313
284900210712     C                   ENDIF                                                                CLE168
285000210712     C                   ELSE                                                                 CLE168
285100210712      *                                                                                       CLE168
285200210712     C     *IN91         IFEQ      '1'
285300210712     C******IN92         OREQ      '1'                                                        182114
285400210712     C**********         ADD       1             Idx                                       MD034521A
285500210712     C**********         EVAL      FldNameArr(Idx) = 'DDRONX'                              MD034521A
285600210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0991'                               MD034521A
285700210712     C**********         MOVE      'N'           DDRonxOK                                  MD034521A
285800210712     C                   ADD       1             WIdx                                      MD034521A
285900210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                            MD034521A
286000210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0991'                             MD034521A
286100210712     C                   MOVE      'W'           DDRonxOK                                  MD034521A
286200210712     C                   END
286300210712     C                   ENDIF                                                                CLE168
286400210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
286500210712     C                   ENDIF                                                                260863
286600210712      *
286700210712      ** SET UP SETTLEMENT BRANCH
286800210712      *
286900210712     C                   MOVE      BRCA          DDROBR
287000210712     C                   MOVE      BRCA          FLROBR
287100210712      *
287200210712      ** IF SETL IS 14 AND NOSTRO IDENTIFIES A LIVE RECORD ON ACCNTAB
287300210712      ** RECEIPT CURRENCY MUST BE SAME AS CURRENCY OF ACCOUNT
287400210712      *
287500210712     C     E#RCCY        IFNE      CCY
287600210712     C                   ADD       1             Idx
287700210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
287800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0914'
287900210712     C                   MOVE      'N'           DDRonxOK
288000210712      *
288100210712     C                   ELSE
288200210712      *
288300210712      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
288400210712      *
288500210712     C     @MBIN         IFEQ      'N'
288600210712     C     BRCA          ANDNE     BJSBRC
288700210712     C                   ADD       1             Idx
288800210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
288900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0888'
289000210712     C                   MOVE      'N'           DDRonxOK
289100210712     C                   END
289200210712     C*
289300210712     C                   END
289400210712     C                   END
289500210712                                                                                              CRE008
289600210712      ** Set up Account ID for Overdraft Limit Check                                          CRE008
289700210712                                                                                              CRE008
289800210712     C                   IF        CDL008 = 'Y'                                               CRE008
289900210712     C                             OR CGL014 = 'Y'                                            CGL014
290000210712     C                   EVAL      WkCust = CNUM                                              CRE008
290100210712     C                   EVAL      WkCcy  = CCY                                               CRE008
290200210712     C                   EVAL      WkACOD = ACOD                                              CRE008
290300210712     C                   EVAL      WkASeq = ACSQ                                              CRE008
290400210712     C                   EVAL      WkBRCA = BRCA                                              CRE008
290500210712     C                   ENDIF                                                                CRE008
290600210712                                                                                              CRE008
290700210712     C                   END
290800210712     C/COPY WNCPYSRC,ZASETNVC03
290900210712     C                   END
291000210712      *
291100210712      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
291200210712      ** THE DATE OF RECEIPT MUST NOT BE BEFORE THE DATE A/C OPENED
291300210712      *
291400210712     C     DDRSTM        IFEQ      '01'
291500210712     C     DDRSTM        OREQ      '02'
291600210712     C     DDRSTM        OREQ      '05'
291700210712     C     DDRSTM        OREQ      '07'
291800210712     C     DDRSTM        OREQ      '08'
291900210712     C     DDRSTM        OREQ      '12'
292000210712     C     DDRSTM        OREQ      '14'
292100210712      *
292200210712     C     W#ACOPEN      IFEQ      'Y'
292300210712     C     ##ACTN        ANDEQ     'I'                                                        185751
292400210712     C     ##DATR        ANDLT     DACO
292500210712     C                   ADD       1             Idx
292600210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
292700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0912'
292800210712     C                   MOVE      'N'           DDRonxOK
292900210712     C                   END
293000210712      *
293100210712     C                   END
293200210712      *
293300210712      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
293400210712      ** FOR RETAIL A/CS THE REC DATE CAN'T BE BEFORE THE BACK-VALUE PERIOD
293500210712      *
293600210712     C     DDRSTM        IFEQ      '01'
293700210712     C     DDRSTM        OREQ      '02'
293800210712     C     DDRSTM        OREQ      '05'
293900210712     C     DDRSTM        OREQ      '07'
294000210712     C     DDRSTM        OREQ      '08'
294100210712     C     DDRSTM        OREQ      '12'
294200210712     C     DDRSTM        OREQ      '14'
294300210712      *
294400210712     C     W#ACOPEN      IFEQ      'Y'
294500210712     C     ATYP          ANDEQ     'R'
294600210712     C     ##DATR        ANDLT     W#BVDT
294700210712     C                   ADD       1             Idx
294800210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
294900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0913'
295000210712     C                   MOVE      'N'           DDRonxOK
295100210712     C                   END
295200210712      *
295300210712     C                   END
295400210712      *
295500210712     C                   ENDSR
295600210712     C*****************************************************************
295700210712      /EJECT
295800210712     C*****************************************************************
295900210712     C*                                                               *
296000210712     C* VLROCN - VALIDATE RECEIVE ORDERING CUSTOMER                   *
296100210712     C*                                                               *
296200210712     C*****************************************************************
296300210712     C     VLROCN        BEGSR
296400210712      *
296500210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
296600210712      *
296700210712     C                   MOVE      *BLANKS       P#PART           10
296800210712     C                   MOVE      DDROCN        P#PART
296900210712     C                   MOVEL     'NOTALLOW'    @CPNAL            8
297000210712     C                   EXSR      PARTYT
297100210712                                                                                             CSF011A
297200210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
297300210712     C                   EVAL      DDRSH4 = BBCSSN                                           CSF011A
297400210712     C                   EVAL      DDRRN4 = BBCRNM                                           CSF011A
297500210712     C                   EVAL      DDRRT4 = BBCRTN                                           CSF011A
297600210712     C                   EVAL      DDRSI4 = BBCSID                                           CSF011A
297700210712     C                   ENDIF                                                               CSF011A
297800210712      *
297900210712      * NO SELECTION
298000210712      *
298100210712     C     ##PREC        IFNE      'Y'                                                      AR641619
298200210712     C     @RTCD         IFEQ      '*NOSEL '
298300210712     C                   ADD       1             Idx
298400210712     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
298500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0868'
298600210712     C                   MOVE      'N'           DDRocnOK
298700210712     C                   GOTO      EVROCN
298800210712     C                   END
298900210712      *
299000210712      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
299100210712      *
299200210712     C     @PARTY        IFNE      'CUSTNUM'
299300210712     C     @PARTY        ANDNE     'CUSTSNM'
299400210712     C                   ADD       1             Idx
299500210712     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
299600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0915'
299700210712     C                   MOVE      'N'           DDRocnOK
299800210712     C                   GOTO      EVROCN
299900210712     C                   END
300000210712      *
300100210712      ** Ordering customer can't be a bank
300200210712      *
300300210712     C     @BANK         IFEQ      'Y'
300400210712     C                   ADD       1             Idx
300500210712     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
300600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0803'
300700210712     C                   MOVE      'N'           DDRocnOK
300800210712     C                   GOTO      EVROCN
300900210712     C                   END
301000210712     C                   ENDIF                                                              AR641619
301100210712      *
301200210712      ** UPDATE OUTPUT FIELD
301300210712      *
301400210712     C                   MOVEL     BBCUST        FLROCN
301500210712      *
301600210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
301700210712      **   INTO SCREEN FIELD.
301800210712      *
301900210712     C                   MOVEL     DDROCN        @TSTQ             1
302000210712     C     @TSTQ         IFEQ      '?'
302100210712     C                   MOVEL     BBCSSN        DDROCN
302200210712     C                   END
302300210712      *
302400210712     C     EVROCN        ENDSR
302500210712     C********************************************************************
302600210712      /EJECT
302700210712     C*****************************************************************
302800210712     C*                                                               *
302900210712     C* VLROBN - VALIDATE RECEIVE ORDERING BANK                       *
303000210712     C*                                                               *
303100210712     C*****************************************************************
303200210712     C     VLROBN        BEGSR
303300210712      *
303400210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
303500210712      *
303600210712     C                   MOVE      *BLANKS       P#PART
303700210712     C                   MOVE      DDROBN        P#PART
303800210712     C                   MOVEL     'NOTALLOW'    @CPNAL
303900210712     C                   EXSR      PARTYT
304000210712                                                                                             CSF011A
304100210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
304200210712     C                   EVAL      DDRSH3 = BBCSSN                                           CSF011A
304300210712     C                   EVAL      DDRRN3 = BBCRNM                                           CSF011A
304400210712     C                   EVAL      DDRRT3 = BBCRTN                                           CSF011A
304500210712     C                   EVAL      DDRSI3 = BBCSID                                           CSF011A
304600210712     C                   ENDIF                                                               CSF011A
304700210712      *
304800210712      * NO SELECTION
304900210712      *
305000210712     C     ##PREC        IFNE      'Y'                                                      AR641619
305100210712     C     @RTCD         IFEQ      '*NOSEL '
305200210712     C                   ADD       1             Idx
305300210712     C                   EVAL      FldNameArr(Idx) = 'DDROBN'
305400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0869'
305500210712     C                   MOVE      'N'           DDRobnOK
305600210712     C                   GOTO      EVROBN
305700210712     C                   END
305800210712      *
305900210712      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
306000210712      *
306100210712     C     @PARTY        IFNE      'CUSTNUM'
306200210712     C     @PARTY        ANDNE     'CUSTSNM'
306300210712     C                   ADD       1             Idx
306400210712     C                   EVAL      FldNameArr(Idx) = 'DDROBN'
306500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0917'
306600210712     C                   MOVE      'N'           DDRobnOK
306700210712     C                   GOTO      EVROBN
306800210712     C                   END
306900210712      *
307000210712      ** Ordering bank must be a bank
307100210712      *
307200210712     C     @BANK         IFNE      'Y'
307300210712     C*****DDRSTM        ANDEQ     '08'                                                194282 239836
307400210712     C                   ADD       1             Idx
307500210712     C                   EVAL      FldNameArr(Idx) = 'DDROBN'
307600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0918'
307700210712     C                   MOVE      'N'           DDRobnOK
307800210712     C                   GOTO      EVROBN
307900210712     C                   END
308000210712      *
308100210712     C*****BBBNBI        IFNE      'Y'                                                 194282 239836
308200210712     C*****DDRSTM        ANDNE     '08'                                                194282 239836
308300210712     C**********         MOVE      'N'           @BANK                                 194282 239836
308400210712     C**********         ELSE                                                          194282 239836
308500210712     C**********         MOVE      'Y'           @BANK                                 194282 239836
308600210712     C**********         END                                                           194282 239836
308700210712      *                                                                                       194282
308800210712     C*****@BANK         IFNE      'Y'                                                 194282 239836
308900210712     C*****DDRSTM        ANDNE     '08'                                                194282 239836
309000210712     C**********         ADD       1             Idx                                   194282 239836
309100210712     C**********         EVAL      FldNameArr(Idx) = 'DDROBN'                          194282 239836
309200210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM1918'                           194282 239836
309300210712     C**********         MOVE      'N'           DDRobnOK                              194282 239836
309400210712     C**********         GOTO      EVROBN                                              194282 239836
309500210712     C**********         END                                                           194282 239836
309600210712     C                   ENDIF                                                              AR641619
309700210712      *                                                                                       194282
309800210712      ** UPDATE OUTPUT FIELD
309900210712      *
310000210712     C                   MOVEL     BBCUST        FLROBN
310100210712      *
310200210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
310300210712      **   INTO SCREEN FIELD.
310400210712      *
310500210712     C                   MOVEL     DDROBN        @TSTQ             1
310600210712     C     @TSTQ         IFEQ      '?'
310700210712     C                   MOVEL     BBCSSN        DDROBN
310800210712     C                   END
310900210712      *
311000210712     C     EVROBN        ENDSR
311100210712     C********************************************************************
311200210712      /EJECT
311300210712     C*****************************************************************
311400210712     C*                                                               *
311500210712     C* VLROCB - VALIDATE RECEIVE ORDERING CUSTOMER & BANK            *
311600210712     C*                                                               *
311700210712     C*****************************************************************
311800210712     C     VLROCB        BEGSR
311900210712      *
312000210712      ** FOR SETTLEMENT TYPE 01 OR 08 EITHER ORDERING BANK OR ORDERING
312100210712      ** CUSTOMER MUST BE ENTERED
312200210712      *
312300210712     C     DDRSTM        IFEQ      '01'
312400210712     C     DDRSTM        OREQ      '08'
312500210712     C     DDROBN        IFEQ      *BLANKS
312600210712     C     DDROCN        ANDEQ     *BLANKS
312700210712     C                   ADD       1             Idx
312800210712     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
312900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0699'
313000210712     C                   MOVE      'N'           DDRocnOK
313100210712     C                   MOVE      'N'           DDRobnOK
313200210712     C                   END
313300210712     C                   END
313400210712     C/COPY WNCPYSRC,ZASETNVC05
313500210712      *
313600210712      ** ENTRY IN BOTH RECEIPT ORDERING BANK AND ORDERING CUSTOMER NOT
313700210712      ** ALLOWED
313800210712      *
313900210712     C     DDRSTM        IFEQ      '09'                                                       CLE033
314000210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
314100210712     C     DDROBN        IFNE      *BLANKS
314200210712     C     DDROCN        ANDNE     *BLANKS
314300210712     C                   ADD       1             Idx
314400210712     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
314500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0919'
314600210712     C                   MOVE      'N'           DDRocnOK
314700210712     C                   MOVE      'N'           DDRobnOK
314800210712     C                   END
314900210712     C                   ENDIF                                                                CLE033
315000210712      *
315100210712     C                   ENDSR
315200210712     C********************************************************************
315300210712      /EJECT
315400210712     C*****************************************************************
315500210712     C*                                                               *
315600210712     C* VLRIBN - VALIDATE RECEIVE INTERMEDIARY BANK                   *
315700210712     C*                                                               *
315800210712     C*****************************************************************
315900210712     C     VLRIBN        BEGSR
316000210712      *
316100210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
316200210712      *
316300210712     C                   MOVE      *BLANKS       P#PART
316400210712     C                   MOVE      DDRIBN        P#PART
316500210712     C                   MOVEL     'ALLOWED '    @CPNAL
316600210712     C                   EXSR      PARTYT
316700210712                                                                                             CSF011A
316800210712     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
316900210712     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
317000210712     C                   EVAL      DDRSH2 = BBCSSN                                           CSF011A
317100210712     C                   EVAL      DDRRN2 = BBCRNM                                           CSF011A
317200210712     C                   EVAL      DDRRT2 = BBCRTN                                           CSF011A
317300210712     C                   EVAL      DDRSI2 = BBCSID                                           CSF011A
317400210712     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
317500210712     C                   EVAL      DDRSH2 = AWCSN1  + AWCSN2                                 CSF011A
317600210712     C                   EVAL      DDRRN2 = AWCPNM                                           CSF011A
317700210712     C                   EVAL      DDRRT2 = AWCNTN                                           CSF011A
317800210712     C                   EVAL      DDRSI2 = AWSWID                                           CSF011A
317900210712     C                   ENDIF                                                               CSF011A
318000210712      *
318100210712      * NO SELECTION
318200210712      *
318300210712     C     ##PREC        IFNE      'Y'                                                      AR641619
318400210712     C     @RTCD         IFEQ      '*NOSEL '
318500210712     C                   ADD       1             Idx
318600210712     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
318700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0870'
318800210712     C                   MOVE      'N'           DDRibnOK
318900210712     C                   GOTO      EVRIBN
319000210712     C                   END
319100210712      *
319200210712      * ERROR
319300210712      *
319400210712     C     @PARTY        IFEQ      'ERROR'
319500210712     C                   ADD       1             Idx
319600210712     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
319700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0922'
319800210712     C                   MOVE      'N'           DDRibnOK
319900210712     C                   GOTO      EVRIBN
320000210712     C                   END
320100210712     C                   ENDIF                                                              AR641619
320200210712      *
320300210712      * TEST 1ST DIGIT
320400210712      *
320500210712     C                   MOVEL     DDRIBN        @TSTQ
320600210712      *
320700210712      ** IF A CUSTOMER NUMBER OR SHORTNAME
320800210712      *
320900210712     C     @PARTY        IFEQ      'CUSTNUM'
321000210712     C     @PARTY        OREQ      'CUSTSNM'
321100210712      *
321200210712      **  ERROR IF NOT A BANK
321300210712      *
321400210712     C     @BANK         IFEQ      'Y'
321500210712     C                   MOVEL     BBCUST        FLRIBN
321600210712     C                   ELSE
321700210712     C     ##PREC        IFNE      'Y'                                                      AR641619
321800210712     C                   ADD       1             Idx
321900210712     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
322000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0923'
322100210712     C                   MOVE      'N'           DDRibnOK
322200210712     C                   GOTO      EVRIBN
322300210712     C                   ENDIF                                                              AR641619
322400210712     C                   END
322500210712      *
322600210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
322700210712      **   INTO SCREEN FIELD.
322800210712      *
322900210712     C     @TSTQ         IFEQ      '?'
323000210712     C                   MOVEL     BBCSSN        DDRIBN
323100210712     C                   END
323200210712      *
323300210712      ** ELSE IF A COUNTERPARTY NOSTRO
323400210712      *
323500210712     C                   ELSE
323600210712     C                   MOVEL     AWCPNC        FLRIBN
323700210712      *
323800210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
323900210712      **   INTO SCREEN FIELD.
324000210712      *
324100210712     C     @TSTQ         IFEQ      '?'
324200210712     C                   MOVEL     *BLANKS       DDRIBN
324300210712     C                   MOVEL     AWCPNC        DDRIBN
324400210712     C                   END
324500210712     C                   END
324600210712      *
324700210712      ** ENTRY MUST NOT BE THE SAME AS BRANCH INTERNAL CUSTOMER NUMBER
324800210712      ** OF THE RECEIVE NOSTRO
324900210712      *
325000210712     C     FLRIBN        IFNE      *BLANKS
325100210712     C     FLRIBN        ANDEQ     @RBICN
325200210712     C     ##PREC        ANDNE     'Y'                                                      AR641619
325300210712     C                   ADD       1             Idx
325400210712     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
325500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0926'
325600210712     C                   MOVE      'N'           DDRibnOK
325700210712     C                   END
325800210712      *
325900210712     C     EVRIBN        ENDSR
326000210712     C********************************************************************
326100210712      /EJECT
326200210712     C*****************************************************************
326300210712     C*                                                               *
326400210712     C* VLRIBA - VALIDATE RECEIVE INTERMEDIARY BANK A/C LINE          *
326500210712     C*                                                               *
326600210712     C*****************************************************************
326700210712     C     VLRIBA        BEGSR
326800210712      *
326900210712     C                   MOVE      DDRIBA        L#XIBA
327000210712      *
327100210712      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN INTER. BANK
327200210712      *
327300210712     C     DDRIBN        IFEQ      *BLANKS
327400210712     C                   ADD       1             Idx
327500210712     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'
327600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0924'
327700210712     C                   MOVE      'N'           DDRibaOK
327800210712     C                   GOTO      EVRIBA
327900210712     C                   END
328000210712      *                                                                                       193584
328100210712      * If Nostro is a CLS Dummy Nostro, this field must be blank.                            193584
328200210712      *                                                                                       193584
328300210712     C                   MOVE      DDRONS        A#OURA                                       193584
328400210712     C                   MOVE      E#RCCY        @CYCD                                        193584
328500210712     C                   MOVE      A#NOST        @NONB                                        193584
328600210712      *                                                                                       193584
328700210712      * ACCESS NOSTRO DETAILS                                                                 193584
328800210712      *                                                                                       193584
328900210712     C                   EXSR      ACNOST                                                     193584
329000210712      *                                                                                       193584
329100210712     C     A7CLSD        IFEQ      'Y'                                                        193584
329200210712     C                   ADD       1             Idx                                          193584
329300210712     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'                                 193584
329400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0160'                                  193584
329500210712     C                   MOVEL     'N'           DDRibaOK                                     193584
329600210712     C                   GOTO      EVRIBA                                                     193584
329700210712     C                   END                                                                  193584
329800210712      *
329900210712      * Call Account Line Validation object
330000210712      *
330100210712      * Set up parameters
330200210712      *
330300210712     C                   MOVEL     *BLANKS       W0RTN
330400210712     C                   CLEAR                   I#PARM
330500210712     C                   MOVEL     'INBK '       I#VFLD
330600210712     C                   MOVEL     'REC'         I#PR
330700210712     C                   MOVEL     'X'           I#PRTT
330800210712     C                   MOVEL     DDRIBN        I#PRTY
330900210712     C                   MOVEL     E#PCCY        I#PCCY
331000210712     C                   MOVEL     E#RCCY        I#RCCY
331100210712     C                   MOVEL     DDRIBA        I#ACLN
331200210712     C                   MOVEL     DDPSTM        I#PSTM
331300210712     C                   MOVEL     DDRSTM        I#RSTM
331400210712     C                   MOVEL     '210'         I#MTYP
331500210712      *
331600210712      * Set up receive account information
331700210712      *
331800210712     C     DDRONS        IFNE      *BLANKS
331900210712     C                   SELECT
332000210712     C     DDROBR        WHENNE    *BLANKS
332100210712     C     DDRONS        CAT       DDROBR        I#RCAC
332200210712     C     DDRONS        WHENNE    *BLANKS
332300210712     C                   MOVEL     DDRONS        I#RCAC
332400210712     C                   ENDSL
332500210712     C                   ENDIF
332600210712      *
332700210712      * Set up Pay account information
332800210712      *
332900210712     C     DDPONS        IFNE      *BLANKS
333000210712     C                   SELECT
333100210712     C     DDPOBR        WHENNE    *BLANKS
333200210712     C     DDPONS        CAT       DDPOBR        I#PYAC
333300210712     C     DDPONS        WHENNE    *BLANKS
333400210712     C                   MOVEL     DDPONS        I#PYAC
333500210712     C                   ENDSL
333600210712     C                   ENDIF
333700210712      *
333800210712      * If extra message and Rec Corr. then set 5354 field
333900210712      *
334000210712     C     DDRVNO        IFNE      *BLANKS
334100210712     C     DDRCRN        ANDNE     *BLANKS
334200210712     C                   MOVEL     'Y'           I#5354
334300210712     C                   ENDIF
334400210712      *
334500210712      * Transaction Type
334600210712      *
334700210712     C                   MOVEL     ##TTYP        I#TTYP
334800210712      *
334900210712      * Set up Cover field
335000210712      *
335100210712     C                   MOVEL     DDCVMR        I#COVR
335200210712      *
335300210712     C                   CLEAR                   O#PARM
335400210712     C                   CLEAR                   E#PARM
335500210712      *
335600210712      * Send messages to correct calling process
335700210712      *
335800210712     C                   SELECT
335900210712     C     ##CALP        WHENEQ    'FXDL'
336000210712     C                   MOVEL     'ME9940'      E#CPGM
336100210712     C                   MOVEL     'DL'          I#MMOD
336200210712     C     ##CALP        WHENEQ    'LDNI'
336300210712     C                   MOVEL     'ME9940'      E#CPGM
336400210712     C                   MOVEL     'DL'          I#MMOD
336500210712     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
336600210712     C     ##CALP        OREQ      'MAPY'                                                     239587
336700210712     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
336800210712     C                   MOVEL     'LE'          I#MMOD                                       CAP068
336900210712     C     ##CALP        WHENEQ    'SSI '
337000210712     C                   MOVEL     'SD0401R'     E#CPGM
337100210712     C                   MOVEL     'AT'          I#MMOD
337200210712     C                   OTHER
337300210712     C                   MOVEL     'ME9940'      E#CPGM
337400210712     C                   ENDSL
337500210712     C                   MOVEL     'MEC0019'     E#MSGD
337600210712     C                   MOVEL     'MEMSG'       E#MSGF
337700210712      *
337800210712     C                   CALL      'ME9940'
337900210712     C                   PARM                    W0RTN             7
338000210712     C                   PARM                    I#PARM                         I Input Parms
338100210712     C                   PARM                    O#PARM                         O Output Parms
338200210712     C                   PARM                    E#PARM                         E Error Inform
338300210712     C                   PARM                    Z#PARM          256            B User Defined
338400210712      *
338500210712      * A/c line modified
338600210712     C                   MOVEL     O#ACLN        DDRIBA
338700210712      *
338800210712      ** Subtract 1 from error array index
338900210712     C                   SUB       1             E#INDX
339000210712      *
339100210712      * On return, if errors copy into error array
339200210712      *
339300210712     C     E#ERRM        IFNE      *BLANKS
339400210712     C     1             DO        E#INDX        Q#                5 0
339500210712     C                   ADD       1             Idx
339600210712     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'
339700210712     C                   MOVEL     'ESM0'        WMessageID        7
339800210712     C                   MOVE      O#E(Q#)       WMessageID
339900210712     C                   EVAL      MsgIDArr(Idx) = WMessageID
340000210712     C                   ENDDO
340100210712     C                   MOVEL     'N'           DDRibaOK
340200210712     C                   ENDIF
340300210712      *
340400210712      *  UPDATE OUTPUT FIELD
340500210712      *
340600210712     C                   MOVE      DDRIBA        FLRIBA
340700210712      *
340800210712     C     EVRIBA        ENDSR
340900210712     C*****************************************************************
341000210712      /EJECT
341100210712     C*****************************************************************
341200210712     C*                                                               *
341300210712     C* VLPSFD - VALIDATE PAYMENT SETTLEMENT FIELDS                   *
341400210712     C*                                                               *
341500210712     C*****************************************************************
341600210712     C     VLPSFD        BEGSR
341700210712      *
341800210712      ** ENTRY IN ALL PAYMENT INSTRUCTIONS PROHIBITED IF PAYMENT
341900210712      ** SETTLEMENT METHOD IS 00
342000210712      *
342100210712     C     DDPSTM        IFEQ      *BLANKS
342200210712      *
342300210712     C     DDPONS        IFNE      *BLANKS
342400210712     C     DDPOBN        ORNE      *BLANKS
342500210712     C     DDPOCN        ORNE      *BLANKS
342600210712     C     DDPIBN        ORNE      *BLANKS
342700210712     C     DDPIBA        ORNE      *BLANKS
342800210712     C     DDRCRN        ORNE      *BLANKS
342900210712     C     DDRCRA        ORNE      *BLANKS
343000210712     C     DDRVNO        ORNE      *BLANKS
343100210712     C     DDCVMR        ORNE      *BLANKS
343200210712     C     DDAWBN        ORNE      *BLANKS
343300210712     C     DDAWBA        ORNE      *BLANKS
343400210712     C     DDBENN        ORNE      *BLANKS
343500210712     C     DDBENA        ORNE      *BLANKS
343600210712     C     DDDTP1        ORNE      *BLANKS
343700210712     C     DDDTP2        ORNE      *BLANKS
343800210712     C     DDDTP3        ORNE      *BLANKS
343900210712     C     DDDTP4        ORNE      *BLANKS
344000210712     C     DDDCHG        ORNE      *BLANKS
344100210712     C     DDPOBR        ORNE      *BLANKS
344200210712     C     DDPMAC        ORNE      *BLANKS                                                    CDL018
344300210712     C     DDPEXR        ORNE      *BLANKS                                                    CLE031
344400210712     C     DDPEXI        ORNE      *BLANKS                                                    CLE031
344500210712     C                   ADD       1             Idx
344600210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
344700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0929'
344800210712     C                   MOVE      'N'           DDPstmOK
344900210712     C                   END
345000210712     C                   END
345100210712      *
345200210712     C/COPY WNCPYSRC,ZASETNVC32
345300210712      ** ENTRY IN FOLLOWING FIELDS IS PROHIBITED UNLESS SETL. TYPE
345400210712      ** IS 01,07 OR 08.
345500210712      *
345600210712     C     DDPSTM        IFNE      '01'
345700210712     C     DDPSTM        ANDNE     '07'
345800210712     C     DDPSTM        ANDNE     '08'
345900210712     C     CLE033        ANDNE     'Y'                                                        CLE033
346000210712     C     DDPSTM        ORNE      '01'                                                       CLE033
346100210712     C     DDPSTM        ANDNE     '07'                                                       CLE033
346200210712     C     DDPSTM        ANDNE     '08'                                                       CLE033
346300210712     C     DDPSTM        ANDNE     '09'                                                       CLE033
346400210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
346500210712     C/COPY WNCPYSRC,ZASETINVC3
346600210712      *
346700210712     C     DDPOCN        IFNE      *BLANKS
346800210712     C     DDPOBN        ORNE      *BLANKS
346900210712     C     DDPIBN        ORNE      *BLANKS
347000210712     C     DDPIBA        ORNE      *BLANKS
347100210712     C     DDRVNO        ORNE      *BLANKS
347200210712     C     DDCVMR        ORNE      *BLANKS
347300210712     C     DDRCRN        ORNE      *BLANKS
347400210712     C     DDRCRA        ORNE      *BLANKS
347500210712     C     DDAWBN        ORNE      *BLANKS
347600210712     C     DDAWBA        ORNE      *BLANKS
347700210712     C     DDBENN        ORNE      *BLANKS
347800210712     C     DDBENA        ORNE      *BLANKS
347900210712     C     DDDTP1        ORNE      *BLANKS
348000210712     C     DDDTP2        ORNE      *BLANKS
348100210712     C     DDDTP3        ORNE      *BLANKS
348200210712     C     DDDTP4        ORNE      *BLANKS
348300210712     C     DDDCHG        ORNE      *BLANKS
348400210712     C*
348500210712     C                   ADD       1             Idx
348600210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
348700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0930'
348800210712     C                   MOVE      'N'           DDPstmOK
348900210712     C     DDPOCN        IFNE      *BLANKS
349000210712     C                   MOVE      'N'           DDPocnOK
349100210712     C                   END
349200210712     C     DDPOBN        IFNE      *BLANKS
349300210712     C                   MOVE      'N'           DDPobnOK
349400210712     C                   END
349500210712     C     DDPIBN        IFNE      *BLANKS
349600210712     C                   MOVE      'N'           DDPibnOK
349700210712     C                   END
349800210712     C     DDPIBA        IFNE      *BLANKS
349900210712     C                   MOVE      'N'           DDPibaOK
350000210712     C                   END
350100210712     C     DDRVNO        IFNE      *BLANKS
350200210712     C                   MOVE      'N'           DDRvnoOK
350300210712     C                   END
350400210712     C     DDRCRN        IFNE      *BLANKS
350500210712     C                   MOVE      'N'           DDRcrnOK
350600210712     C                   END
350700210712     C     DDRCRA        IFNE      *BLANKS
350800210712     C                   MOVE      'N'           DDRcraOK
350900210712     C                   END
351000210712     C     DDAWBN        IFNE      *BLANKS
351100210712     C                   MOVE      'N'           DDAwbnOK
351200210712     C                   END
351300210712     C     DDAWBA        IFNE      *BLANKS
351400210712     C                   MOVE      'N'           DDAwbaOK
351500210712     C                   END
351600210712     C     DDBENN        IFNE      *BLANKS
351700210712     C                   MOVE      'N'           DDBennOK
351800210712     C                   END
351900210712     C     DDBENA        IFNE      *BLANKS
352000210712     C                   MOVE      'N'           DDBenaOK
352100210712     C                   END
352200210712     C*
352300210712     C                   END
352400210712     C                   END
352500210712      *                                                                                       CDL018
352600210712      ** Entry Prohibited for 'MORE A/C' unless Sett. Method is 05 or 14                      CDL018
352700210712      *                                                                                       CDL018
352800210712     C     CDL018        IFEQ      'Y'                                                        CDL018
352900210712      *                                                                                       CDL018
353000210712     C     DDPSTM        IFNE      '05'                                                       CDL018
353100210712     C     DDPSTM        ANDNE     '14'                                                       CDL018
353200210712      *                                                                                       CDL018
353300210712     C     DDPMAC        IFNE      *BLANKS                                                    CDL018
353400210712     C                   ADD       1             Idx                                          CDL018
353500210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                                 CDL018
353600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM1000'                                  CDL018
353700210712     C                   MOVE      'N'           DDPmacOK                                     CDL018
353800210712     C                   ENDIF                                                                CDL018
353900210712     C                   ENDIF                                                                CDL018
354000210712      *                                                                                       CDL018
354100210712     C                   ENDIF                                                                CDL018
354200210712     C*
354300210712     C/COPY WNCPYSRC,ZASETNVC33
354400210712     C                   ENDSR
354500210712     C********************************************************************
354600210712      /EJECT
354700210712     C*****************************************************************
354800210712     C*                                                               *
354900210712     C* VLRVNO - VALIDATE RECEIVE NUMBER                              *
355000210712     C*                                                               *
355100210712     C*****************************************************************
355200210712     C     VLRVNO        BEGSR
355300210712      *
355400210712      ** IF RECEIVER NUMBER ENTERED
355500210712      *
355600210712     C     DDRVNO        IFNE      *BLANKS
355700210712      *
355800210712      * DETERMINE PARTY TYPE (CUSTOMER NO OR SHORTNAME)
355900210712      *
356000210712     C                   MOVE      *BLANKS       P#PART
356100210712     C                   MOVE      DDRVNO        P#PART
356200210712     C                   MOVEL     'NOTALLOW'    @CPNAL
356300210712     C                   EXSR      PARTYT
356400210712                                                                                             CSF011A
356500210712      ** Populate Customer details                                                           CSF011A
356600210712                                                                                             CSF011A
356700210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
356800210712     C                   EVAL      DDPSH2 = BBCSSN                                           CSF011A
356900210712     C                   EVAL      DDPRN2 = BBCRNM                                           CSF011A
357000210712     C                   EVAL      DDPRT2 = BBCRTN                                           CSF011A
357100210712     C                   EVAL      DDPSI2 = BBCSID                                           CSF011A
357200210712     C                   ENDIF                                                               CSF011A
357300210712      *
357400210712      * NO SELECTION
357500210712      *
357600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
357700210712     C     @RTCD         IFEQ      '*NOSEL '
357800210712     C                   ADD       1             Idx
357900210712     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
358000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0871'
358100210712     C                   MOVE      'N'           DDRvnoOK
358200210712     C                   GOTO      EVRVNO
358300210712     C                   END
358400210712      *
358500210712      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
358600210712      *
358700210712     C     @PARTY        IFNE      'CUSTNUM'
358800210712     C     @PARTY        ANDNE     'CUSTSNM'
358900210712     C                   ADD       1             Idx
359000210712     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
359100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0952'
359200210712     C                   MOVE      'N'           DDRvnoOK
359300210712     C                   GOTO      EVRVNO
359400210712     C                   END
359500210712      *
359600210712      * CHECK RECIPIENT IS A BANK
359700210712      *
359800210712     C     @BANK         IFNE      'Y'
359900210712     C                   ADD       1             Idx
360000210712     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
360100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0955'
360200210712     C                   MOVE      'N'           DDRvnoOK
360300210712     C                   GOTO      EVRVNO
360400210712     C                   END
360500210712     C                   ENDIF                                                              AR641619
360600210712      *
360700210712      ** UPDATE OUTPUT FIELD
360800210712      *
360900210712     C                   MOVEL     BBCUST        FLRVNO
361000210712      *
361100210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
361200210712      **   INTO SCREEN FIELD.
361300210712      *
361400210712     C                   MOVEL     DDRVNO        @TSTQ             1
361500210712     C     @TSTQ         IFEQ      '?'
361600210712     C                   MOVEL     BBCSSN        DDRVNO
361700210712     C                   END
361800210712      *
361900210712      ** RECEIVER MUST HAVE SWIFT ADDRESS, A STTX ADDRESS OR A TELEX
362000210712      ** ADDRESS
362100210712      *
362200210712     C     BBCSID        IFEQ      *BLANKS
362300210712     C     BBSTAD        ANDEQ     *BLANKS
362400210712     C     BBTXA1        ANDEQ     *BLANKS
362500210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
362600210712     C                   ADD       1             Idx
362700210712     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
362800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0953'
362900210712     C                   MOVE      'N'           DDRvnoOK
363000210712     C                   END
363100210712      *
363200210712      **  CHECK COVER-MT202-REQUIRED IS "Y" OR "N"
363300210712      *
363400210712     C     DDCVMR        IFNE      'N'
363500210712     C     DDCVMR        ANDNE     'Y'
363600210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
363700210712     C                   ADD       1             Idx
363800210712     C                   EVAL      FldNameArr(Idx) = 'DDCVMR'
363900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0889'
364000210712     C                   MOVE      'N'           DDCvmrOK
364100210712     C                   ELSE                                                   CAP003
364200210712     C                   MOVE      DDCVMR        FLCVMR                         CAP003
364300210712     C                   END
364400210712     C                   END
364500210712      *
364600210712      **  IF RECIPIENT OF PAYMENT INSTRUCTION HASN'T BEEN ENTERED,
364700210712      **  COVER-MT202-REQUIRED MUST BE BLANK
364800210712      *
364900210712     C     DDRVNO        IFEQ      *BLANKS
365000210712     C     DDCVMR        ANDNE     *BLANKS
365100210712     C     DDCVMR        ANDNE     'N'                                                       BUG7875
365200210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
365300210712     C                   ADD       1             Idx
365400210712     C                   EVAL      FldNameArr(Idx) = 'DDCVMR'
365500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0890'
365600210712     C                   MOVE      'N'           DDCvmrOK
365700210712     C                   END
365800210712      *
365900210712     C/COPY WNCPYSRC,ZAH00005
366000210712     C     EVRVNO        ENDSR
366100210712     C********************************************************************
366200210712      /EJECT
366300210712     C*****************************************************************
366400210712     C*                                                               *
366500210712     C* VLPSCY - VALIDATE PAYMENT SETTLEMENT CURRENCY                 *
366600210712     C*                                                               *
366700210712     C*****************************************************************
366800210712     C     VLPSCY        BEGSR
366900210712      *
367000210712      **  Access Currency Details
367100210712      *
367200210712     C                   CALLB     'AOCURRR0'
367300210712     C                   PARM      *BLANKS       @RTCD
367400210712     C                   PARM      '*KEY    '    @OPTN
367500210712     C                   PARM      DDPSCY        @CURR
367600210712     C     SDCURR        PARM      SDCURR        DSSDY
367700210712      *
367800210712      **  Payment settlement currency is invalid
367900210712      **  or not a dealing currency
368000210712      *
368100210712     C     @RTCD         IFNE      *BLANKS
368200210712     C     A6DLCI        ORNE      'Y'
368300210712     C                   ADD       1             Idx
368400210712     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'
368500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0848'
368600210712     C                   MOVE      'N'           DDPscyOK
368700210712     C                   ELSE
368800210712
368900210712     C                   MOVEL     A6CYCD        DDPSCY
369000210712      *                                                                                       CLE031
369100210712      **  CLE031 enhancement allows settlement of In-ccy or Euro currency                     CLE031
369200210712      **  against other currencies                                                            CLE031
369300210712      *                                                                                       CLE031
369400210712     C     CLE031        IFEQ      'Y'                                                        CLE031
369500210712     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
369600210712     C     CLE031        OREQ      'Y'                                                      AR853046
369700210712     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
369800210712     C                   MOVE      A6SPRT        AMPEXR                                       CLE031
369900210712     C                   MOVE      A6MDIN        AMPEXI                                       CLE031
370000210712     C                   MOVE      A6DLCI        BPDLCI            1                          CLE031
370100210712     C                   MOVE      A6INCY        BPINCY            1                          CLE031
370200210712      *                                                                                       CLE031
370300210712      **  Access Currency Details for transaction payment currency                            CLE031
370400210712      *                                                                                       CLE031
370500210712     C                   CALLB     'AOCURRR0'                                                 CLE031
370600210712     C                   PARM      *BLANKS       @RTCD                                        CLE031
370700210712     C                   PARM      '*KEY    '    @OPTN                                        CLE031
370800210712     C                   PARM      ##PCCY        @CURR                                        CLE031
370900210712     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE031
371000210712      *                                                                                       CLE031
371100210712     C                   MOVE      A6SPRT        APSPRT                                       CLE031
371200210712     C                   MOVE      A6MDIN        APMDIN                                       CLE031
371300210712     C                   MOVE      A6INCY        APINCY            1                          CLE031
371400210712      *                                                                                       CLE031
371500210712     C                   ELSE                                                                 CLE031
371600210712      *
371700210712      ** If the transaction payment currency is Euros
371800210712      *
371900210712     C     ##PCCY        IFEQ      BKEURO
372000210712      *
372100210712      ** Error if settlement currency is not an 'In' currency
372200210712      *
372300210712     C     A6INCY        IFNE      'Y'
372400210712     C                   ADD       1             Idx
372500210712     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'
372600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0853'
372700210712     C                   MOVE      'N'           DDPscyOK
372800210712     C                   ENDIF
372900210712      *
373000210712      ** If the transaction payment currency is NOT Euros (i.e. an 'in' ccy)
373100210712      *
373200210712     C                   ELSE
373300210712      *
373400210712      ** Error if settlement currency is not Euros
373500210712      *
373600210712     C     DDPSCY        IFNE      BKEURO
373700210712     C                   ADD       1             Idx
373800210712     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'
373900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0854'
374000210712     C                   MOVE      'N'           DDPscyOK
374100210712     C                   ELSE                                                   152344
374200210712      *                                                                         152344
374300210712      **  Access Currency Details for transaction payment currency              152344
374400210712      *                                                                         152344
374500210712     C                   CALLB     'AOCURRR0'                                   152344
374600210712     C                   PARM      *BLANKS       @RTCD                          152344
374700210712     C                   PARM      '*KEY    '    @OPTN                          152344
374800210712     C                   PARM      ##PCCY        @CURR                          152344
374900210712     C     SDCURR        PARM      SDCURR        DSSDY                          152344
375000210712      *                                                                         152344
375100210712      ** Error if payment currency is not an 'In' currency                      152344
375200210712      *                                                                         152344
375300210712     C     A6INCY        IFNE      'Y'                                          152344
375400210712     C                   ADD       1             Idx                            152344
375500210712     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'                   152344
375600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0848'                    152344
375700210712     C                   MOVE      'N'           DDPscyOK                       152344
375800210712     C                   ENDIF                                                  152344
375900210712                                                                                152344
376000210712     C                   ENDIF
376100210712      *
376200210712     C                   ENDIF
376300210712      *
376400210712     C                   ENDIF                                                                CLE031
376500210712      *                                                                                       CLE031
376600210712     C                   ENDIF
376700210712      *
376800210712     C                   ENDSR
376900210712     C********************************************************************
377000210712      /EJECT
377100210712      *****************************************************************                       CDL018
377200210712      *                                                               *                       CDL018
377300210712      * VLPMAC - VALIDATE PAY MORE ACCOUNT                            *                       CDL018
377400210712      *                                                               *                       CDL018
377500210712      *****************************************************************                       CDL018
377600210712     C     VLPMAC        BEGSR                                                                CDL018
377700210712      *                                                                                       CDL018
377800210712      ** More Accounts only valid for Deal Types IP, IT, TI or TD                             CDL018
377900210712      *                                                                                       CDL018
378000210712     C     ##TTYP        IFNE      'IP'                                                       CDL018
378100210712     C     ##TTYP        ANDNE     'IT'                                                       CDL018
378200210712     C     ##TTYP        ANDNE     'TI'                                                       CDL018
378300210712     C     ##TTYP        ANDNE     'TD'                                                       CDL018
378400210712     C     DDPMAC        ANDNE     *BLANKS                                                    CDL018
378500210712     C                   ADD       1             Idx                                          CDL018
378600210712     C                   EVAL      FldNameArr(Idx) = 'DDPMAC'                                 CDL018
378700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM1025'                                  CDL018
378800210712     C                   MOVE      'N'           DDPmacOK                                     CDL018
378900210712     C                   ENDIF                                                                CDL018
379000210712      *                                                                                       CDL018
379100210712      ** Must be 'Y', 'N' or blanks                                                           CDL018
379200210712      *                                                                                       CDL018
379300210712     C     DDPMAC        IFNE      *BLANKS                                                    CDL018
379400210712     C     DDPMAC        ANDNE     'Y'                                                        CDL018
379500210712     C     DDPMAC        ANDNE     'N'                                                        CDL018
379600210712     C                   ADD       1             Idx                                          CDL018
379700210712     C                   EVAL      FldNameArr(Idx) = 'DDPMAC'                                 CDL018
379800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM1001'                                  CDL018
379900210712     C                   MOVE      'N'           DDPmacOK                                     CDL018
380000210712     C                   ENDIF                                                                CDL018
380100210712      *                                                                                       CDL018
380200210712     C                   ENDSR                                                                CDL018
380300210712      *****************************************************************                       CDL018
380400210712      /EJECT                                                                                  CDL018
380500210712      *****************************************************************                       CLE031
380600210712      *                                                               *                       CLE031
380700210712      * VLPEXR - VALIDATE PAYMENT EXCHANGE RATE                       *                       CLE031
380800210712      *                                                               *                       CLE031
380900210712      *****************************************************************                       CLE031
381000210712     C     VLPEXR        BEGSR                                                                CLE031
381100210712      *                                                                                       CLE031
381200210712     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
381300210712     C                   MOVE      DDPEXR        ZFIELD                                       CLE031
381400210712     C                   Z-ADD     5             ZADIG                                        CLE031
381500210712     C                   Z-ADD     8             ZADEC                                        CLE031
381600210712      *                                                                                       CLE031
381700210712     C                   CALLB     'ZALIGN'                                                   CLE031
381800210712     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
381900210712     C                   PARM      *BLANK        ZALIGNok                                     CLE106
382000210712     C                   PARM                    ZFIELD                                       CLE031
382100210712     C                   PARM                    ZADEC                                        CLE031
382200210712     C                   PARM                    ZADIG                                        CLE031
382300210712     C**********         PARM      *BLANKS       ZAVAL                                 CLE031 CLE106
382400210712      *                                                                                       CLE031
382500210712     C     DDPEXR        IFNE      *BLANKS                                                  MD051932
382600210712     C     ZALIGNok      ANDNE     'Y'                                                      MD051932
382700210712     C                   ADD       1             Idx                                        MD051932
382800210712     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                               MD051932
382900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0866'                                MD051932
383000210712     C                   MOVE      'N'           DDPexrOK                                   MD051932
383100210712     C                   ENDIF                                                              MD051932
383200210712      *                                                                                     MD051932
383300210712     C**********         MOVE      ZAVAL         WMPEXR           14 0                 CLE031 CLE106
383400210712     C*****ZAVAL         IFEQ      *BLANKS                                             CLE031 CLE106
383500210712     C                   MOVE      ZFIELD        WMPEXR           14 0                        CLE106
383600210712     C     ZFIELD        IFEQ      *BLANKS                                                    CLE106
383700210712     C                   Z-ADD     *ZEROS        WMPEXR                                       CLE031
383800210712     C                   ENDIF                                                                CLE031
383900210712      *                                                                                       CLE031
384000210712     C     APINCY        IFNE      'Y'                                                        CLE031
384100210712      *                                                                                       CLE031
384200210712     C     DDPSCY        IFEQ      *BLANKS                                                    CLE031
384300210712     C     DDPEXR        ANDNE     *BLANKS                                                    CLE031
384400210712     C     WMPEXR        ANDNE     *ZEROS                                                     CLE031
384500210712     C     DDPSCY        OREQ      *BLANKS                                                    CLE031
384600210712     C     DDPEXI        ANDNE     *BLANKS                                                    CLE031
384700210712     C                   ADD       1             Idx                                          CLE031
384800210712     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
384900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0808'                                  CLE031
385000210712     C                   MOVE      'N'           DDPexrOK                                     CLE031
385100210712     C                   ENDIF                                                                CLE031
385200210712      *                                                                                       CLE031
385300210712     C     ##PCCY        IFEQ      BKEURO                                                     CLE031
385400210712     C     BPINCY        ANDEQ     'Y'                                                        CLE031
385500210712     C     ##PCCY        OREQ      BKEURO                                                     CLE031
385600210712     C     DDPSCY        ANDEQ     BKEURO                                                     CLE031
385700210712      *                                                                                       CLE031
385800210712     C     DDPEXR        IFNE      *BLANKS                                                    CLE031
385900210712     C     WMPEXR        ANDNE     *ZEROS                                                     CLE031
386000210712     C     DDPEXI        ORNE      *BLANKS                                                    CLE031
386100210712     C                   ADD       1             Idx                                          CLE031
386200210712     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
386300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0809'                                  CLE031
386400210712     C                   MOVE      'N'           DDPexrOK                                     CLE031
386500210712     C                   ENDIF                                                                CLE031
386600210712     C                   ENDIF                                                                CLE031
386700210712      *                                                                                       CLE031
386800210712     C     APINCY        IFNE      'Y'                                                        CLE031
386900210712     C     ##PCCY        ANDNE     BKEURO                                                     CLE031
387000210712     C     DDPSCY        ANDNE     *BLANKS                                                    CLE031
387100210712     C     BPINCY        ANDEQ     'Y'                                                        CLE031
387200210712     C                   ADD       1             Idx                                          CLE031
387300210712     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
387400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0811'                                  CLE031
387500210712     C                   MOVE      'N'           DDPexrOK                                     CLE031
387600210712     C                   ENDIF                                                                CLE031
387700210712      *                                                                                       CLE031
387800210712     C     ##PPAY        IFNE      'Y'                                                        CLE031
387900210712     C     ##ACTN        OREQ      'X'                                                        CLE031
388000210712     C     DDPSCY        IFNE      *BLANKS                                                    CLE031
388100210712     C*****BPDLCI        ANDNE     'Y'                                               CLE031 MD020816
388200210712     C     BPDLCI        ANDEQ     'N'                                                      MD020816
388300210712     C                   ADD       1             Idx                                          CLE031
388400210712     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
388500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0813'                                  CLE031
388600210712     C                   MOVE      'N'           DDPexrOK                                     CLE031
388700210712     C                   ENDIF                                                                CLE031
388800210712     C                   ENDIF                                                                CLE031
388900210712      *                                                                                       CLE031
389000210712     C     DDPSCY        IFEQ      ##PCCY                                                     CLE031
389100210712     C     DDPSCY        ANDNE     *BLANKS                                                    CLE031
389200210712     C                   ADD       1             Idx                                          CLE031
389300210712     C**********         EVAL      FldNameArr(Idx) = 'DDPexr'                       CLE031 MD051877A
389400210712     C                   EVAL      FldNameArr(Idx) = 'DDPscy'                              MD051877A
389500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0815'                                  CLE031
389600210712     C**********         MOVE      'N'           DDPexrOK                            CLE031 MD051877
389700210712     C                   MOVE      'N'           DDPscyOK                                   MD051877
389800210712     C                   ENDIF                                                                CLE031
389900210712      *                                                                                       CLE031
390000210712     C     DDPSCY        IFNE      *BLANKS                                                  MD051932
390100210712     C     DDPONS        ANDEQ     *BLANKS                                                  MD051932
390200210712     C                   ADD       1             Idx                                        MD051932
390300210712     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'                               MD051932
390400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0817'                                MD051932
390500210712     C                   MOVE      'N'           DDPscyOK                                   MD051932
390600210712     C                   ENDIF                                                              MD051932
390700210712      *                                                                                     MD051932
390800210712     C     DDPexrOK      IFNE      'N'                                                        CLE031
390900210712     C                   MOVEL     *BLANKS       ZMDIX                                        CLE031
391000210712     C     DDPEXR        IFEQ      *BLANKS                                                    CLE031
391100210712     C     WMPEXR        OREQ      *ZEROS                                                     CLE031
391200210712     C     DDPSCY        IFNE      *BLANKS                                                    CLE031
391300210712     C     CLE033        IFEQ      'Y'                                                        CLE031
391400210712     C     SET09         ANDEQ     'T'                                                        CLE031
391500210712     C     DDPSTM        ANDEQ     '09'                                                       CLE031
391600210712      *                                                                                       CLE031
391700210712      ** Do not want exchange rate default in these circumstances                             CLE031
391800210712      *                                                                                       CLE031
391900210712     C                   ELSE                                                                 CLE031
392000210712      *                                                                                       CLE031
392100210712      ** Calculate cross rate from Receive Ccy to Receive Sett Ccy                            CLE031
392200210712      *                                                                                       CLE031
392300210712     C                   Z-ADD     APSPRT        ZRATE1                                       CLE031
392400210712     C                   MOVEL     APMDIN        ZMDI1                                        CLE031
392500210712     C                   Z-ADD     AMPEXR        ZRATE2                                       CLE031
392600210712     C                   MOVEL     AMPEXI        ZMDI2                                        CLE031
392700210712     C                   CALLB     'ZXRATE'                                                   CLE031
392800210712     C                   PARM                    ZRATE1           13 8                        CLE031
392900210712     C                   PARM                    ZMDI1             1                          CLE031
393000210712     C                   PARM                    ZRATE2           13 8                        CLE031
393100210712     C                   PARM                    ZMDI2             1                          CLE031
393200210712     C                   PARM                    ZRATEX           13 8                        CLE031
393300210712     C                   PARM                    ZMDIX             1                          CLE031
393400210712     C                   MOVE      ZRATEX        DDPEXC           14                          CLE031
393500210712     C                   MOVE      ZRATEX        DDPEXCR          13 8                        CLE031
393600210712     C                   ENDIF                                                                CLE031
393700210712     C                   ENDIF                                                                CLE031
393800210712      *                                                                                       CLE031
393900210712     C                   ELSE                                                                 CLE031
394000210712      *                                                                                       CLE031
394100210712     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
394200210712     C                   MOVE      DDPEXR        ZFIELD           16                          CLE031
394300210712     C                   Z-ADD     5             ZADIG             2 0                        CLE031
394400210712     C                   Z-ADD     8             ZADEC             1 0                        CLE031
394500210712      *                                                                                       CLE031
394600210712     C                   CALLB     'ZALIGN'                                                   CLE031
394700210712     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
394800210712     C                   PARM      *BLANK        ZALIGNok                                     CLE106
394900210712     C                   PARM                    ZFIELD                                       CLE031
395000210712     C                   PARM                    ZADEC                                        CLE031
395100210712     C                   PARM                    ZADIG                                        CLE031
395200210712     C**********         PARM      *BLANKS       ZAVAL            16                   CLE031 CLE106
395300210712      *                                                                                       CLE031
395400210712     C*****PRTCD         IFNE      *BLANK                                              CLE031 CLE106
395500210712     C     ZALIGNok      IFNE      'Y'                                                        CLE106
395600210712     C                   ADD       1             Idx                                          CLE031
395700210712     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
395800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0866'                                  CLE031
395900210712     C                   MOVE      'N'           DDPexrOK                                     CLE031
396000210712     C                   ELSE                                                                 CLE031
396100210712     C**********         MOVE      ZAVAL         DDPEXC                                CLE031 CLE106
396200210712     C                   MOVE      ZFIELD        DDPEXC                                       CLE106
396300210712     C**********         MOVE      DDPEXR        DDPEXCR          13 8                 CLE031 CLE106
396400210712     C                   MOVE      DDPEXC        DDPEXCR          13 8                        CLE106
396500210712     C                   ENDIF                                                                CLE031
396600210712     C                   ENDIF                                                                CLE031
396700210712      *                                                                                       CLE031
396800210712     C*****PRTCD         IFEQ      *BLANKS                                             CLE031 CLE106
396900210712     C     ZALIGNok      IFEQ      'Y'                                                        CLE106
397000210712     C     DDPEXC        ANDNE     *BLANKS                                                    CLE031
397100210712     C     DDPSCY        ANDNE     *BLANKS                                                    CLE031
397200210712     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
397300210712     C                   MOVE      DDPEXC        ZFIELD                                       CLE031
397400210712     C                   Z-ADD     8             ZADEC                                        CLE031
397500210712     C                   CALLB     'ZEDIT'                                                    CLE031
397600210712     C                   PARM                    ZFIELD                                       CLE031
397700210712     C                   PARM                    ZADEC             1 0                        CLE031
397800210712     C                   MOVE      ZFIELD        DDPEXR                                       CLE031
397900210712     C                   Z-ADD     DDPEXCR       FLPEXR                                       CLE031
398000210712     C                   ENDIF                                                                CLE031
398100210712     C                   ENDIF                                                                CLE031
398200210712      *                                                                                       CLE031
398300210712     C     DDPexrOK      IFNE      'N'                                                        CLE031
398400210712     C     DDPEXI        IFNE      *BLANKS                                                    CLE031
398500210712     C     DDPEXI        ANDNE     'M'                                                        CLE031
398600210712     C     DDPEXI        ANDNE     'D'                                                        CLE031
398700210712     C                   ADD       1             Idx                                          CLE031
398800210712     C                   EVAL      FldNameArr(Idx) = 'DDPexi'                                 CLE031
398900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0880'                                  CLE031
399000210712     C                   MOVE      'N'           DDPexiOK                                     CLE031
399100210712     C                   ELSE                                                                 CLE031
399200210712      *                                                                                       CLE031
399300210712     C     DDPEXI        IFEQ      *BLANKS                                                    CLE031
399400210712     C     DDPEXR        ANDNE     *BLANKS                                                    CLE031
399500210712     C     CLE033        IFEQ      'Y'                                                        CLE031
399600210712     C     SET09         ANDEQ     'T'                                                        CLE031
399700210712     C     DDPSTM        ANDEQ     '09'                                                       CLE031
399800210712      *                                                                                       CLE031
399900210712      ** Do not want multiply/divide ind default in these circumstances                       CLE031
400000210712      *                                                                                       CLE031
400100210712     C                   ELSE                                                                 CLE031
400200210712     C     ZMDIX         IFNE      *BLANKS                                                    CLE031
400300210712     C                   MOVEL     ZMDIX         DDPEXI                                       CLE031
400400210712     C                   ELSE                                                                 CLE031
400500210712     C                   MOVE      AMREXI        DDPEXI                                       CLE031
400600210712     C                   ENDIF                                                                CLE031
400700210712     C                   ENDIF                                                                CLE031
400800210712     C                   ENDIF                                                                CLE031
400900210712     C                   ENDIF                                                                CLE031
401000210712     C                   ENDIF                                                                CLE031
401100210712     C                   MOVEL     DDPEXI        FLPEXI                                       CLE031
401200210712      *                                                                                       CLE031
401300210712     C                   ELSE                                                                 CLE031
401400210712     C     DDPEXR        IFNE      *BLANKS                                                    CLE031
401500210712     C     WMPEXR        ANDNE     *ZEROS                                                     CLE031
401600210712     C                   ADD       1             Idx                                          CLE031
401700210712     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
401800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0809'                                  CLE031
401900210712     C                   MOVE      'N'           DDPexrOK                                     CLE031
402000210712     C                   ENDIF                                                                CLE031
402100210712     C     DDPEXI        IFNE      *BLANKS                                                    CLE031
402200210712     C                   ADD       1             Idx                                          CLE031
402300210712     C                   EVAL      FldNameArr(Idx) = 'DDPexi'                                 CLE031
402400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0809'                                  CLE031
402500210712     C                   MOVE      'N'           DDPexiOK                                     CLE031
402600210712     C                   ENDIF                                                                CLE031
402700210712      *                                                                                       CLE031
402800210712     C                   ENDIF                                                                CLE031
402900210712      *                                                                                       CLE031
403000210712     C                   ENDSR                                                                CLE031
403100210712      *****************************************************************                       CLE031
403200210712     C*****************************************************************
403300210712     C*                                                               *
403400210712     C* VLPSTM - VALIDATE PAYMENT SETTLEMENT METHOD                   *
403500210712     C*                                                               *
403600210712     C*****************************************************************
403700210712     C     VLPSTM        BEGSR
403800210712      *                                                                                       182114
403900210712      ** RESET A/C CLOSED INDICATOR                                                           182114
404000210712      *                                                                                       182114
404100210712     C                   MOVE      *BLANKS       W#ACOPEN                                     182114
404200210712     C/COPY WNCPYSRC,ZASETINV19                                                               CUT009
404300210712      *
404400210712      ** MUST BE 00,01,02,03,04,05,06,07,08,12 OR 14
404500210712      *
404600210712     C     DDPSTM        IFNE      '00'
404700210712     C     DDPSTM        ANDNE     '01'
404800210712     C     DDPSTM        ANDNE     '02'
404900210712     C     DDPSTM        ANDNE     '03'
405000210712     C     DDPSTM        ANDNE     '04'
405100210712     C     DDPSTM        ANDNE     '05'
405200210712     C     DDPSTM        ANDNE     '06'
405300210712     C     DDPSTM        ANDNE     '07'
405400210712     C     DDPSTM        ANDNE     '08'
405500210712     C     DDPSTM        ANDNE     '12'
405600210712     C     DDPSTM        ANDNE     '14'
405700210712     C     DDPSTM        ANDNE     '  '                                                       246120
405800210712     C     CLE033        ANDNE     'Y'                                                        CLE033
405900210712     C     DDPSTM        ORNE      '00'                                                       CLE033
406000210712     C     DDPSTM        ANDNE     '01'                                                       CLE033
406100210712     C     DDPSTM        ANDNE     '02'                                                       CLE033
406200210712     C     DDPSTM        ANDNE     '03'                                                       CLE033
406300210712     C     DDPSTM        ANDNE     '04'                                                       CLE033
406400210712     C     DDPSTM        ANDNE     '05'                                                       CLE033
406500210712     C     DDPSTM        ANDNE     '06'                                                       CLE033
406600210712     C     DDPSTM        ANDNE     '07'                                                       CLE033
406700210712     C     DDPSTM        ANDNE     '08'                                                       CLE033
406800210712     C     DDPSTM        ANDNE     '12'                                                       CLE033
406900210712     C     DDPSTM        ANDNE     '14'                                                       CLE033
407000210712     C     DDPSTM        ANDNE     '09'                                                       CLE033
407100210712     C     DDPSTM        ANDNE     '  '                                                       246120
407200210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
407300210712     C/COPY WNCPYSRC,ZASETINVC4
407400210712     C                   ADD       1             Idx
407500210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
407600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0931'
407700210712     C                   MOVE      'N'           DDPstmOK
407800210712     C                   END
407900210712     C/COPY WNCPYSRC,ZASETINV20                                                               CUT009
408000210712      *                                                                                       CDL051
408100210712     C     CDL051        IFEQ      'Y'                                                        CDL051
408200210712      *                                                                                       CDL051
408300210712      **  If FX or MM deal then settlement instructions must be entered                       CDL051
408400210712     C     ##CALP        IFEQ      'FXDL'                                                     CDL051
408500210712     C     ##CALP        OREQ      'LDNI'                                                     CDL051
408600210712     C     ##CALP        OREQ      'NASP'                                                     CDL051
408700210712     C     ##CALP        OREQ      'NASS'                                                     CDL051
408800210712     C     ##CALP        OREQ      'DEAM'                                                     CDL051
408900210712      *                                                                                       CDL051
409000210712     C     DDPSTM        IFEQ      '00'                                                       CDL051
409100210712     C     DDPSTM        OREQ      *Blanks                                                    CDL051
409200210712     C                   EVAL      WIdx = WIdx + 1                                            CDL051
409300210712     C                   EVAL      WFldNameArr(WIdx)  = 'DDPSTM'                              CDL051
409400210712     C                   EVAL      WMsgIDArr(WIdx)    = 'ESM1027'                             CDL051
409500210712     C                   ENDIF                                                                CDL051
409600210712      *                                                                                       CDL051
409700210712     C                   ENDIF                                                                CDL051
409800210712      *                                                                                       CDL051
409900210712     C                   ENDIF                                                                CDL051
410000210712      *                                                                         CDL008
410100210712     C     CDL008        IFEQ      'Y'                                          CDL008
410200210712     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
410300210712     C     ##TTYP        ANDEQ     'CL'                                         CDL008
410400210712     C     DDPSTM        ANDNE     '00'                                         CDL008
410500210712     C     DDPSTM        ANDNE     '01'                                         CDL008
410600210712     C     DDPSTM        ANDNE     '07'                                         CDL008
410700210712     C     DDPSTM        ANDNE     '08'                                         CDL008
410800210712     C     DDPSTM        ANDNE     '02'                                         CDL008
410900210712     C     DDPSTM        ANDNE     '12'                                         CDL008
411000210712     C                   ADD       1             Idx                            CDL008
411100210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                   CDL008
411200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0304'                    CDL008
411300210712     C                   MOVE      'N'           DDPstmOK                       CDL008
411400210712     C                   ENDIF                                                  CDL008
411500210712     C/COPY WNCPYSRC,ZASETNVC35
411600210712      *
411700210712      ** IF SETL TYPE IS 04 OR 14 THE RETAIL MODULE MUST BE PRESENT
411800210712      *
411900210712     C     DDPSTM        IFEQ      '04'
412000210712     C     DDPSTM        OREQ      '14'
412100210712     C     BGRTBN        IFNE      'Y'
412200210712     C                   ADD       1             Idx
412300210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
412400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0932'
412500210712     C                   MOVE      'N'           DDPstmOK
412600210712     C                   END
412700210712     C                   END
412800210712      *
412900210712      ** IF PAY SETL METHOD IS 04 A LIVE RECORD MUST EXIST IN ACCNTAB
413000210712      *
413100210712     C     DDPSTM        IFEQ      '04'
413200210712     C                   MOVEL     ##CSNM        @ACID
413300210712     C                   MOVE      E#PCCY        @CYCD
413400210712     C                   MOVE      BMACCD        @ACCD
413500210712     C                   MOVE      '01'          @ACSN
413600210712     C                   MOVE      ##BRCA        @BRCA
413700210712      *
413800210712      ** SET UP SETTLEMENT BRANCH
413900210712      *
414000210712     C                   MOVE      ##BRCA        DDPOBR
414100210712     C                   MOVE      ##BRCA        FLPOBR
414200210712      *
414300210712      **  FOR STANDING DATA - EXTENDED SETTLEMENTS:
414400210712      **  WITH SETTLEMENT TYPE 04 CHECKING OF ACCOUNT WON'T BE DONE
414500210712      *
414600210712     C     ##CALP        IFNE      'SSI '
414700210712      *
414800210712      * ACCESS ACCOUNT DETAILS
414900210712      *
415000210712     C                   EXSR      ACACCT
415100210712      *
415200210712      * ACCOUNT IS CLOSED
415300210712      *
415400210712     C     @RTCD         IFNE      *BLANKS
415500210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
415600210712     C     RECI          ORNE      'D'
415700210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
415800210712     C     ACST          OREQ      'C'
415900210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
416000210712     C                   IF        ##PPAY = 'Y'                                              BUG6010
416100210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
416200210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
416300210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPSTM'                              BUG6010
416400210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1134'                               BUG6010
416500210712     C                   ENDIF                                                               BUG6010
416600210712     C                   ELSE                                                                BUG6010
416700210712     C                   ADD       1             Idx
416800210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
416900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0934'
417000210712     C                   MOVE      'N'           DDPstmOK
417100210712     C                   ENDIF                                                               BUG6010
417200210712     C                   ELSE                                                                 182114
417300210712      *                                                                                       182114
417400210712     C                   MOVE      'Y'           W#ACOPEN                                     182114
417500210712      *                                                                                       182114
417600210712      ** Ensure account is not blocked for Debit/Credit                                       182114
417700210712      *                                                                                       182114
417800210712     C                   TESTB     '3'           RETB                     92    CREDIT        182114
417900210712     C/COPY WNCPYSRC,ZAH00049
418000210712      *                                                                                       182114
418100210712      ** A/C IS BLOCKED                                                                       182114
418200210712      *                                                                                       182114
418300210712     C     ##PPAY        IFNE      'Y'                                                        260863
418400210712     C     *IN92         IFEQ      '1'                                                        182114
418500210712     C**********         ADD       1             Idx                                182114 MD034521A
418600210712     C**********         EVAL      FldNameArr(Idx) = 'DDPONX'                       182114 MD034521A
418700210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0992'                        182114 MD034521A
418800210712     C**********         MOVE      'N'           DDPonxOK                           182114 MD034521A
418900210712     C                   ADD       1             WIdx                                      MD034521A
419000210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                            MD034521A
419100210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0992'                             MD034521A
419200210712     C                   MOVE      'W'           DDPonxOK                                  MD034521A
419300210712     C                   END                                                                  182114
419400210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
419500210712     C                   ENDIF                                                                260863
419600210712     C                   END
419700210712      *
419800210712     C                   END
419900210712                                                                                              CGL014
420000210712     C                   IF        CGL014 = 'Y'                                               CGL014
420100210712     C                   EVAL      WPyCust = ##CSNM                                           CGL014
420200210712     C                   EVAL      WPyCcy  = E#PCCY                                           CGL014
420300210712     C                   EVAL      WPyACOD = BMACCD                                           CGL014
420400210712     C                   EVAL      WPyASEQ = '01'                                             CGL014
420500210712     C                   EVAL      WPyBRCA = ##BRCA                                           CGL014
420600210712     C                   ENDIF                                                                CGL014
420700210712                                                                                              CGL014
420800210712     C                   END
420900210712      *
421000210712      ** IF SETTL. TYPE IS 07 THE PAYMENT CURRENCY MUST BE USD
421100210712      *
421200210712     C     DDPSTM        IFEQ      '07'
421300210712     C     E#PCCY        ANDNE     'USD'
421400210712     C                   ADD       1             Idx
421500210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
421600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0935'
421700210712     C                   MOVE      'N'           DDPstmOK
421800210712     C                   END
421900210712      *
422000210712      ** IF TYPE IS 14, RETAIL ACCOUNT NUMBERS MUST BE SUPPORTED
422100210712      *
422200210712     C     DDPSTM        IFEQ      '14'
422300210712     C     BMRANR        ANDNE     'Y'
422400210712     C                   ADD       1             Idx
422500210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
422600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0936'
422700210712     C                   MOVE      'N'           DDPstmOK
422800210712     C                   END
422900210712      *                                                                                       CLE033
423000210712      ** IF SETL TYPE IS 09, SET CORRECT CURRENCY UP ACCORDING TO                             CLE033
423100210712      ** SYSTEM VALUE                                                                         CLE033
423200210712      *                                                                                       CLE033
423300210712     C     DDPSTM        IFEQ      '09'                                                       CLE033
423400210712     C     CLE033        ANDEQ     'Y'                                                        CLE033
423500210712     C     A5ACTY        ANDEQ     'R'                                                        CLE033
423600210712      *                                                                                       CLE033
423700210712     C     DDPSCY        IFNE      *BLANKS                                                    CLE033
423800210712     C     SET09         ANDNE     'T'                                                        CLE033
423900210712     C                   MOVEL     DDPSCY        W0PSCY            3                          CLE033
424000210712     C                   ENDIF                                                                CLE033
424100210712      *                                                                                       CLE033
424200210712     C     DDPSCY        IFEQ      *BLANKS                                                    CLE033
424300210712     C     SET09         OREQ      'T'                                                        CLE033
424400210712     C                   MOVEL     ##PCCY        W0PSCY                                       CLE033
424500210712     C                   ENDIF                                                                CLE033
424600210712      *                                                                                       CLE033
424700210712     C                   MOVEL     P@VL02        W0ACCD           10                          CLE033
424800210712     C                   MOVEL     P@VL01        W0CNUM            6                          CLE033
424900210712      *                                                                                       CLE033
425000210712     **  For Settlement Type 09 for SSI, only partial checking of                             CLE033
425100210712     **  account entered can be done, as not all details are available.                       CLE033
425200210712     **  Therefore subroutine ACACCT should not be called.                                    CLE033
425300210712     C     ##CALP        IFNE      'SSI '                                                     CLE033
425400210712     C*                                                                                       CLE033
425500210712     C                   MOVEL     *BLANKS       @ACID                                        CLE033
425600210712     C                   MOVEL     W0CNUM        @ACID                                        CLE033
425700210712     C                   MOVE      W0PSCY        @CYCD                                        CLE033
425800210712     C                   MOVE      W0ACCD        @ACCD                                        CLE033
425900210712     C                   MOVE      '01'          @ACSN                                        CLE033
426000210712     C                   MOVE      ##BRCA        @BRCA                                        CLE033
426100210712     C                   EXSR      ACACCT                                                     CLE033
426200210712     C*                                                                                       CLE033
426300210712     C     @RTCD         IFNE      *BLANKS                                                    CLE033
426400210712     C     RECI          ORNE      'D'                                                        CLE033
426500210712     C     ATYP          ORNE      'R'                                                        CLE033
426600210712     C                   ADD       1             Idx                                          CLE033
426700210712     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                                 CLE033
426800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0934'                                  CLE033
426900210712     C                   MOVE      'N'           DDPstmOK                                     CLE033
427000210712     C                   ENDIF                                                                CLE033
427100210712     C*                                                                                       CLE033
427200210712     C                   ENDIF                                                                CLE033
427300210712      *                                                                                       CLE033
427400210712     C                   ENDIF                                                                CLE033
427500210712      *
427600210712     C/COPY WNCPYSRC,ZASETINVC5
427700210712     C                   ENDSR
427800210712     C********************************************************************
427900210712      /EJECT
428000210712     C*****************************************************************
428100210712     C*                                                               *
428200210712     C* VLPOBR - VALIDATE PAYMENT SETTLEMENT BRANCH                   *
428300210712     C*                                                               *
428400210712     C*****************************************************************
428500210712     C     VLPOBR        BEGSR
428600210712      *
428700210712      ** IF SETTLEMENT METHOD IS 05
428800210712      *
428900210712     C     DDPSTM        IFEQ      '05'
429000210712      *
429100210712      ** SETTLEMENT BRANCH IS MANDATORY
429200210712      *
429300210712     C     DDPOBR        IFEQ      *BLANKS
429400210712     C                   ADD       1             Idx
429500210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
429600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0882'
429700210712     C                   MOVE      'N'           DDPonxOK
429800210712     C                   ELSE
429900210712      *
430000210712      ** NOW VALIDATE SETTLEMENT BRANCH
430100210712      *
430200210712     C                   MOVE      DDPOBR        @BRCA
430300210712     C                   EXSR      ACBRCH
430400210712      *
430500210712      * NO SELECTION
430600210712      *
430700210712     C     @RTCD         IFEQ      '*NOSEL '
430800210712     C                   ADD       1             Idx
430900210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
431000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0864'
431100210712     C                   MOVE      'N'           DDPonxOK
431200210712     C                   END
431300210712      *
431400210712      * ERROR IN SETTLEMENT BRANCH
431500210712      *
431600210712     C     @RTCD         IFNE      *BLANKS
431700210712     C                   ADD       1             Idx
431800210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
431900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0881'
432000210712     C                   MOVE      'N'           DDPonxOK
432100210712     C                   ELSE
432200210712     C                   MOVE      @DSNB         DDPOBR
432300210712     C                   MOVE      @DSNB         FLPOBR
432400210712     C                   END
432500210712     C                   END
432600210712      *                                                                                       CLE033
432700210712     C                   ELSE                                                                 CLE033
432800210712     C     CLE033        IFEQ      'Y'                                                        CLE033
432900210712     C     DDPSTM        ANDEQ     '09'                                                       CLE033
433000210712     C                   MOVEL     DDPOBR        FLPOBR                                       CLE033
433100210712     C                   END                                                                  CLE033
433200210712      *                                                                                       CLE033
433300210712     C                   END
433400210712      *
433500210712     C                   ENDSR
433600210712     C********************************************************************
433700210712      /EJECT
433800210712     C*****************************************************************
433900210712     C*                                                               *
434000210712     C* VLPONS - VALIDATE OUR PAYMENT NOSTRO                          *
434100210712     C*                                                               *
434200210712     C*****************************************************************
434300210712     C     VLPONS        BEGSR
434400210712     C/COPY WNCPYSRC,ZAH00011
434500210712      *
434600210712      ** RESET A/C CLOSED INDICATOR
434700210712      *
434800210712     C                   MOVE      *BLANKS       W#ACOPEN
434900210712      *
435000210712      ** MOVE OUR NOSTRO INTO OUR ACCOUNT DATA STRUCTURE
435100210712      *
435200210712     C                   MOVE      DDPONS        A#OURA
435300210712                                                                                             CSF011A
435400210712     C                   EVAL      SETTF = 'P'                                               CSF011A
435500210712      *
435600210712      ** OUR NOSTRO MUST BE BLANK IF SETTLEMENT TYPE IS 00,04 OR 06
435700210712      *
435800210712     C     DDPSTM        IFEQ      '00'
435900210712     C     DDPSTM        OREQ      '04'
436000210712     C     DDPSTM        OREQ      '06'
436100210712     C     DDPONS        IFNE      *BLANKS
436200210712     C                   ADD       1             Idx
436300210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
436400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0937'
436500210712     C                   MOVE      'N'           DDPonxOK
436600210712     C                   END
436700210712     C                   END
436800210712      *
436900210712      ** IF SETL TYPE IS 01,02,07,08 OR 12 MUST BE A 2 DIGIT NUMBER
437000210712      ** AND IDENTIFY A LIVE RECORD ON THE NOSTRO FILE SDNOSTPD
437100210712      *
437200210712     C     DDPSTM        IFEQ      '01'
437300210712     C     DDPSTM        OREQ      '02'
437400210712     C     DDPSTM        OREQ      '07'
437500210712     C     DDPSTM        OREQ      '08'
437600210712     C     DDPSTM        OREQ      '12'
437700210712     C/COPY WNCPYSRC,ZASETINVC6
437800210712      *
437900210712      ** CHECK OTHER 10 CHARACTERS ARE BLANK
438000210712      *
438100210712     C                   TESTN                   A#NOST               99
438200210712     C     *IN99         IFNE      '1'
438300210712     C     A#REST        ORNE      *BLANKS
438400210712     C                   ADD       1             Idx
438500210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
438600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0938'
438700210712     C                   MOVE      'N'           DDPonxOK
438800210712     C                   ELSE
438900210712      *
439000210712      * NOW VALIDATE NOSTRO CODE
439100210712      *
439200210712     C                   MOVE      E#PCCY        @CYCD
439300210712     C                   MOVE      A#NOST        @NONB
439400210712      *
439500210712      * ACCESS NOSTRO DETAILS
439600210712      *
439700210712     C                   EXSR      ACNOST
439800210712      *
439900210712      * NOSTRO NOT FOUND
440000210712      *
440100210712     C     @RTCD         IFNE      *BLANKS
440200210712     C                   IF        ##PPAY = 'Y'                                               260863
440300210712     C                   IF        ##ACTN <> 'R'                                              260863
440400210712     C                   EVAL      WIdx = WIdx + 1                                            260863
440500210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                               260863
440600210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1140'                                260863
440700210712     C                   MOVE      'W'           DDPonxOK                                     260863
440800210712     C                   ENDIF                                                                260863
440900210712     C                   ELSE                                                                 260863
441000210712     C                   ADD       1             Idx
441100210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
441200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0938'
441300210712     C                   MOVE      'N'           DDPonxOK
441400210712     C                   ENDIF                                                                260863
441500210712     C                   ELSE
441600210712      *
441700210712      ** STORE CUSTOMER NUMBER OF OUR PAY NOSTRO FOR VALIDATION
441800210712      *
441900210712     C                   MOVEL     A7CUST        @PNOCN            8
442000210712     C/COPY WNCPYSRC,ZAH00012
442100210712      *
442200210712      ** NOSTRO GL ACCOUNT
442300210712      *
442400210712     C     CDL008        IFEQ      'Y'                                          CDL008
442500210712      *                                                                         CDL008
442600210712     C     ##TTYP        IFEQ      'CL'                                         CDL008
442700210712     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
442800210712     C     A7CLSD        ANDNE     'Y'                                          CDL008
442900210712     C                   ADD       1             Idx                            CDL008
443000210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                   CDL008
443100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0302'                    CDL008
443200210712     C                   MOVE      'N'           DDPonxOK                       CDL008
443300210712     C                   ENDIF                                                  CDL008
443400210712      *                                                                         CDL008
443500210712     C     ##TTYP        IFNE      'CL'                                         CDL008
443600210712     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
443700210712     C     A7CLSD        ANDEQ     'Y'                                          CDL008
443800210712     C                   ADD       1             Idx                            CDL008
443900210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                   CDL008
444000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0306'                    CDL008
444100210712     C                   MOVE      'N'           DDPonxOK                       CDL008
444200210712     C                   ENDIF                                                  CDL008
444300210712      *                                                                         CDL008
444400210712     C                   ENDIF                                                  CDL008
444500210712      *                                                                         CDL008
444600210712     C                   MOVEL     *BLANKS       @ACID
444700210712     C                   MOVEL     A7CUST        @ACID
444800210712     C                   MOVE      E#PCCY        @CYCD
444900210712     C                   MOVE      A7ACCD        @ACCD
445000210712     C                   MOVE      A7ACSN        @ACSN
445100210712     C                   MOVE      A7BRCD        @BRCA
445200210712      *
445300210712      ** SET UP SETTLEMENT BRANCH
445400210712      *
445500210712     C                   MOVE      A7BRCD        DDPOBR
445600210712     C                   MOVE      A7BRCD        FLPOBR
445700210712      *
445800210712      * ACCESS ACCOUNT DETAILS
445900210712      *
446000210712     C                   EXSR      ACACCT
446100210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
446200210712     C                   EXSR      CSFACT                                                    CSF011A
446300210712     C                   ENDIF                                                               CSF011A
446400210712      *
446500210712      * ACCOUNT IS CLOSED
446600210712      *
446700210712     C     @RTCD         IFNE      *BLANKS
446800210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
446900210712     C     RECI          ORNE      'D'
447000210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
447100210712      *                                                                                      BUG6010
447200210712      ** Warn if the account is closed.                                                      BUG6010
447300210712      *                                                                                      BUG6010
447400210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
447500210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
447600210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                              BUG6010
447700210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1138'                               BUG6010
447800210712     C                   ENDIF                                                               BUG6010
447900210712     C                   ELSE
448000210712      *
448100210712     C                   MOVE      'Y'           W#ACOPEN
448200210712      *                                                                                       182114
448300210712      ** Ensure account is not blocked for Debit/Credit                                       182114
448400210712      *                                                                                       182114
448500210712     C                   TESTB     '3'           RETB                     92    CREDIT        182114
448600210712     C/COPY WNCPYSRC,ZAH00050
448700210712      *                                                                                       182114
448800210712      ** A/C IS BLOCKED                                                                       182114
448900210712      *                                                                                       182114
449000210712     C     ##PPAY        IFNE      'Y'                                                        260863
449100210712     C     *IN92         IFEQ      '1'                                                        182114
449200210712     C**********         ADD       1             Idx                                182114 MD034521A
449300210712     C**********         EVAL      FldNameArr(Idx) = 'DDPONX'                       182114 MD034521A
449400210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0992'                        182114 MD034521A
449500210712     C**********         MOVE      'N'           DDPonxOK                           182114 MD034521A
449600210712     C                   ADD       1             WIdx                                      MD034521A
449700210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                            MD034521A
449800210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0992'                             MD034521A
449900210712     C                   MOVE      'W'           DDPonxOK                                  MD034521A
450000210712     C                   END                                                                  182114
450100210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
450200210712     C                   ENDIF                                                                260863
450300210712      *
450400210712      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
450500210712      *
450600210712     C     @MBIN         IFEQ      'N'
450700210712     C     BJSBRC        ANDNE     A7BRCD
450800210712     C                   ADD       1             Idx
450900210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
451000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0501'
451100210712     C                   MOVE      'N'           DDPonxOK
451200210712     C                   END
451300210712      *
451400210712      ** RETRIEVE BRANCH INTERNAL CUSTOMER NUMBER ASSOCIATED WITH
451500210712      ** NOSTRO BRANCH FOR VALIDATION LATER.
451600210712      *
451700210712     C                   MOVE      A7BRCD        @BRCA
451800210712     C                   EXSR      ACBRCH
451900210712     C                   MOVEL     A8BICN        @PBICN            8
452000210712      *
452100210712     C                   END
452200210712     C                   END
452300210712     C                   END
452400210712     C                   END
452500210712      *
452600210712      ** IF SETTLEMENT TYPE IS 03, 'OUR NOSTRO' MUST EITHER BE BLANK OR
452700210712      ** CONTAIN A SIX DIGIT DEAL NUMBER (TO COMPENSATE AGAINST).
452800210712      *
452900210712     C     DDPSTM        IFEQ      '03'
453000210712     C     A#OURA        ANDNE     *BLANKS
453100210712     C                   TESTN                   A#CNUM               99
453200210712     C     *IN99         IFNE      '1'
453300210712     C     A#ACAS        ORNE      *BLANKS
453400210712     C                   ADD       1             Idx
453500210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
453600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0939'
453700210712     C                   MOVE      'N'           DDPonxOK
453800210712     C                   ELSE                                                                CSF011A
453900210712     C                   EVAL      @RTCD = *BLANKS                                           CSF011A
454000210712     C                   EVAL      W@TYPE = 'CUST'                                           CSF011A
454100210712     C                   EXSR      CSFACT                                                    CSF011A
454200210712     C                   END
454300210712     C                   END
454400210712      *
454500210712      ** IF SETLEMENT TYPE IS 05 MUST IDENTIFY A LIVE RECORD ON ACCNTAB
454600210712      ** (IN COMBINATION WITH PAYMENT CURRENCY)
454700210712      *
454800210712     C     DDPSTM        IFEQ      '05'
454900210712      *
455000210712     C                   MOVEL     DDPONX        WDPONX           21                       MD024884A
455100210712     C     DDPONX        IFNE      *BLANKS                                                  BUG12624
455200210712     C     A#ACSQ        IFEQ      *BLANKS
455300210712     C     A#ACSQ        OREQ      '00'
455400210712     C                   MOVE      '01'          A#ACSQ
455500210712     C                   MOVE      A#ACSQ        DDPONX                                      BUG6393
455600210712     C                   END
455700210712      *
455800210712     C**********         TESTN                   A#CNUM               99                      CSD027
455900210712     C***99*****         TESTN                   A#ACOD               99                      CSD027
456000210712     C                   TESTN                   A#ACOD               99                      CSD027
456100210712     C   99              TESTN                   A#ACSQ               99
456200210712      *
456300210712      ** INVALID CUSTOMER, A/C CODE & A/C SEQUENCE
456400210712      *
456500210712     C     *IN99         IFNE      '1'
456600210712     C                   ADD       1             Idx
456700210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
456800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0940'
456900210712     C                   MOVE      'N'           DDPonxOK
457000210712     C                   ELSE
457100210712      *
457200210712     C                   MOVEL     *BLANKS       @ACID
457300210712     C                   MOVEL     A#CNUM        @ACID
457400210712     C                   MOVE      E#PCCY        @CYCD
457500210712     C                   MOVE      A#ACSQ        @ACSN
457600210712     C                   MOVE      A#ACOD        @ACCD
457700210712      *
457800210712      * Default branch
457900210712      *
458000210712     C     @MBIN         IFEQ      'N'
458100210712     C                   MOVE      BJSBRC        DDPOBR
458200210712     C                   MOVE      BJSBRC        FLPOBR
458300210712     C                   END
458400210712      *
458500210712     C                   MOVE      DDPOBR        @BRCA
458600210712      *
458700210712      * ACCESS ACCOUNT DETAILS
458800210712      *
458900210712     C                   EXSR      ACACCT
459000210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
459100210712     C                   EXSR      CSFACT                                                    CSF011A
459200210712     C                   ENDIF                                                               CSF011A
459300210712      *
459400210712      * ACCOUNT IS CLOSED
459500210712      *
459600210712     C     @RTCD         IFNE      *BLANKS
459700210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
459800210712     C     RECI          ORNE      'D'
459900210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
460000210712     C     ACST          OREQ      'C'
460100210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
460200210712     C                   IF        ##PPAY = 'Y'                                              BUG6010
460300210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
460400210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
460500210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                              BUG6010
460600210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1140'                               BUG6010
460700210712     C                   ENDIF                                                               BUG6010
460800210712     C                   ELSE                                                                BUG6010
460900210712     C                   ADD       1             Idx
461000210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
461100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0940'
461200210712     C                   MOVE      'N'           DDPonxOK
461300210712     C                   ENDIF                                                               BUG6010
461400210712     C                   ELSE
461500210712     C                   MOVE      'Y'           W#ACOPEN
461600210712     C                   MOVEL     A#OURA        DDPONS
461700210712      *                                                                                       182114
461800210712      ** Ensure account is not blocked for Debit/Credit                                       182114
461900210712      *                                                                                       182114
462000210712     C                   TESTB     '3'           RETB                     92    CREDIT        182114
462100210712     C/COPY WNCPYSRC,ZAH00051
462200210712      *                                                                                       182114
462300210712      ** A/C IS BLOCKED                                                                       182114
462400210712      *                                                                                       182114
462500210712     C     ##PPAY        IFNE      'Y'                                                        260863
462600210712     C     *IN92         IFEQ      '1'                                                        182114
462700210712     C**********         ADD       1             Idx                                182114 MD034521A
462800210712     C**********         EVAL      FldNameArr(Idx) = 'DDPONX'                       182114 MD034521A
462900210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0992'                        182114 MD034521A
463000210712     C**********         MOVE      'N'           DDPonxOK                           182114 MD034521A
463100210712     C                   ADD       1             WIdx                                      MD034521A
463200210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                            MD034521A
463300210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0992'                             MD034521A
463400210712     C                   MOVE      'W'           DDPonxOK                                  MD034521A
463500210712     C                   END                                                                  182114
463600210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
463700210712     C                   ENDIF                                                                260863
463800210712     C                   END
463900210712      *
464000210712     C                   END
464100210712     C                   ENDIF                                                              BUG12624
464200210712     C                   IF        DDPonxOK = 'N'                                          MD024884A
464300210712     C                   MOVEL     WDPONX        DDPONX                                    MD024884A
464400210712     C                   ENDIF                                                             MD024884A
464500210712     C                   END
464600210712      *
464700210712      ** IF SETL TYPE IS 14, NOSTRO MUST CONTAIN A 10 DIGIT NUMBER
464800210712      ** WHICH IDENTIFIES A LIVE RECORD ON FILE ACCNTAB
464900210712      *
465000210712     C     DDPSTM        IFEQ      '14'
465100210712     C                   TESTN                   A#RENO               99
465200210712      *
465300210712      ** INVALID RETAIL A/C NUMBER
465400210712      *
465500210712     C     *IN99         IFNE      '1'
465600210712     C     A#ACSQ        ORNE      *BLANKS
465700210712     C     A#RES2        ORNE      *BLANKS                                                    248393
465800210712     C                   ADD       1             Idx
465900210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
466000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0941'
466100210712     C                   MOVE      'N'           DDPonxOK
466200210712     C                   ELSE
466300210712      *
466400210712     C                   MOVEL     A#RENO        @ACID
466500210712     C                   MOVE      *BLANKS       @CYCD
466600210712     C                   MOVE      *BLANKS       @ACSN
466700210712     C                   MOVE      *BLANKS       @ACCD
466800210712     C                   MOVE      *BLANKS       @BRCA
466900210712      *
467000210712      * ACCESS ACCOUNT DETAILS
467100210712      *
467200210712     C                   EXSR      ACACCT
467300210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
467400210712     C                   EXSR      CSFACT                                                    CSF011A
467500210712     C                   ENDIF                                                               CSF011A
467600210712      *
467700210712      * ACCOUNT IS CLOSED
467800210712      *
467900210712     C     @RTCD         IFNE      *BLANKS
468000210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
468100210712     C     RECI          ORNE      'D'
468200210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
468300210712     C     ACST          OREQ      'C'
468400210712     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
468500210712     C                   IF        ##PPAY = 'Y'                                              BUG6010
468600210712     C                   IF        ##ACTN <> 'R'                                             BUG6010
468700210712     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
468800210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                              BUG6010
468900210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1141'                               BUG6010
469000210712     C                   ENDIF                                                               BUG6010
469100210712     C                   ELSE                                                                BUG6010
469200210712     C**********         IF        ##ACTN <> 'R' AND ##PPAY <> 'Y'                AR1096686 MD021526
469300210712     C**********                   AND ACST = 'C' AND @RTCD = '*ACST'             AR1096686 MD021526
469400210712     C**********         EVAL      WIdx = WIdx + 1                                AR1096686 MD021526
469500210712     C**********         EVAL      WFldNameArr(WIdx) = 'DDPONX'                   AR1096686 MD021526
469600210712     C**********         EVAL      WMsgIDArr(WIdx) = 'ESM1141'                    AR1096686 MD021526
469700210712     C**********         EVAL      WARN_PFLAG = 'Y'                               AR1096686 MD021526
469800210712     C**********         ENDIF                                                    AR1096686 MD021526
469900210712      *****************************************************************           AR1096686 MD021526
470000210712      ***Bypass*error*message*when*warning*is*already*been*issued******           AR1096686 MD021526
470100210712      *****************************************************************           AR1096686 MD021526
470200210712     C**********         IF        WARN_PFLAG <> 'Y'                              AR1096686 MD021526
470300210712     C                   ADD       1             Idx
470400210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
470500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0941'
470600210712     C                   MOVE      'N'           DDPonxOK
470700210712     C**********         ENDIF                                                    AR1096686 MD021526
470800210712     C                   ENDIF                                                               BUG6010
470900210712     C                   ELSE
471000210712      *
471100210712     C                   MOVE      'Y'           W#ACOPEN
471200210712      *
471300210712      ** Ensure account is not blocked for Debit/Credit
471400210712      *
471500210712     C**********         TESTB     '2'           RETB                     91    DEBIT         182114
471600210712     C                   TESTB     '3'           RETB                     92    CREDIT
471700210712     C/COPY WNCPYSRC,ZAH00052
471800210712      *
471900210712      ** A/C IS BLOCKED
472000210712      *
472100210712     C******IN91         IFEQ      '1'                                                        182114
472200210712     C******IN92         OREQ      '1'                                                        182114
472300210712     C     ##PPAY        IFNE      'Y'                                                        260863
472400210712     C     *IN92         IFEQ      '1'                                                        182114
472500210712     C**********         ADD       1             Idx                                       MD034521A
472600210712     C**********         EVAL      FldNameArr(Idx) = 'DDPONX'                              MD034521A
472700210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0992'                               MD034521A
472800210712     C**********         MOVE      'N'           DDPonxOK                                  MD034521A
472900210712     C                   ADD       1             WIdx                                      MD034521A
473000210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                            MD034521A
473100210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0992'                             MD034521A
473200210712     C                   MOVE      'W'           DDPonxOK                                  MD034521A
473300210712     C                   END
473400210712     C                   EXSR      SRExtChkBlkAc                                            MD036475
473500210712     C                   ENDIF                                                                260863
473600210712      *
473700210712      ** SET UP SETTLEMENT BRANCH
473800210712      *
473900210712     C                   MOVE      BRCA          DDPOBR
474000210712     C                   MOVE      BRCA          FLPOBR
474100210712      *
474200210712      ** IF SETL IS 14 AND NOSTRO IDENTIFIES A LIVE RECORD ON ACCNTAB
474300210712      ** RECEIPT CURRENCY MUST BE SAME AS CURRENCY OF ACCOUNT
474400210712      *
474500210712     C     E#PCCY        IFNE      CCY
474600210712     C                   ADD       1             Idx
474700210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
474800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0944'
474900210712     C                   MOVE      'N'           DDPonxOK
475000210712      *
475100210712     C                   ELSE
475200210712      *
475300210712      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
475400210712      *
475500210712     C     @MBIN         IFEQ      'N'
475600210712     C     BRCA          ANDNE     BJSBRC
475700210712     C                   ADD       1             Idx
475800210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
475900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0887'
476000210712     C                   MOVE      'N'           DDPonxOK
476100210712     C                   END
476200210712     C*
476300210712     C                   END
476400210712     C                   END
476500210712     C                   END
476600210712     C                   END
476700210712                                                                                              CGL014
476800210712     C                   IF        CGL014 = 'Y' AND DDPSTM = '14'                             CGL014
476900210712     C                             AND DDPonxOK <> 'N'                                        CGL014
477000210712     C                   MOVEL     A#RENO        WPyRetail                                    CGL014
477100210712     C                   ENDIF                                                                CGL014
477200210712      *
477300210712      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
477400210712      ** THE DATE OF PAYMENT MUST NOT BE BEFORE THE DATE A/C OPENED
477500210712      *
477600210712     C     DDPSTM        IFEQ      '01'
477700210712     C     DDPSTM        OREQ      '02'
477800210712     C     DDPSTM        OREQ      '05'
477900210712     C     DDPSTM        OREQ      '07'
478000210712     C     DDPSTM        OREQ      '08'
478100210712     C     DDPSTM        OREQ      '12'
478200210712     C     DDPSTM        OREQ      '14'
478300210712      *
478400210712     C     W#ACOPEN      IFEQ      'Y'
478500210712     C     ##ACTN        ANDEQ     'I'                                                        207137
478600210712     C     ##DATP        ANDLT     DACO
478700210712     C                   ADD       1             Idx
478800210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
478900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0942'
479000210712     C                   MOVE      'N'           DDPonxOK
479100210712     C                   END
479200210712      *
479300210712     C                   END
479400210712      *
479500210712      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
479600210712      ** FOR RETAIL A/CS THE PAY DATE CAN'T BE BEFORE THE BACK-VALUE PERIOD
479700210712      *
479800210712     C     DDPSTM        IFEQ      '01'
479900210712     C     DDPSTM        OREQ      '02'
480000210712     C     DDPSTM        OREQ      '05'
480100210712     C     DDPSTM        OREQ      '07'
480200210712     C     DDPSTM        OREQ      '08'
480300210712     C     DDPSTM        OREQ      '12'
480400210712     C     DDPSTM        OREQ      '14'
480500210712      *
480600210712     C     W#ACOPEN      IFEQ      'Y'
480700210712     C     ATYP          ANDEQ     'R'
480800210712     C     ##DATP        ANDLT     W#BVDT
480900210712     C                   ADD       1             Idx
481000210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
481100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0943'
481200210712     C                   MOVE      'N'           DDPonxOK
481300210712     C                   END
481400210712     C*
481500210712     C                   END
481600210712      *
481700210712     C                   ENDSR
481800210712     C********************************************************************
481900210712      /EJECT
482000210712     C*****************************************************************
482100210712     C*                                                               *
482200210712     C* VLPOCN - VALIDATE PAYMENT ORDERING CUSTOMER                   *
482300210712     C*                                                               *
482400210712     C*****************************************************************
482500210712     C     VLPOCN        BEGSR
482600210712      *
482700210712     C/COPY WNCPYSRC,ZASETINV03                                                               CUT009
482800210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
482900210712      *
483000210712     C                   MOVE      *BLANKS       P#PART
483100210712     C                   MOVE      DDPOCN        P#PART
483200210712     C                   MOVEL     'NOTALLOW'    @CPNAL
483300210712     C                   EXSR      PARTYT
483400210712                                                                                             CSF011A
483500210712      ** Populate customer details                                                           CSF011A
483600210712                                                                                             CSF011A
483700210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
483800210712     C                   EVAL      DDPSH3 = BBCSSN                                           CSF011A
483900210712     C                   EVAL      DDPRN3 = BBCRNM                                           CSF011A
484000210712     C                   EVAL      DDPRT3 = BBCRTN                                           CSF011A
484100210712     C                   EVAL      DDPSI3 = BBCSID                                           CSF011A
484200210712     C                   ENDIF                                                               CSF011A
484300210712      *
484400210712      * NO SELECTION
484500210712      *
484600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
484700210712     C     @RTCD         IFEQ      '*NOSEL '
484800210712     C                   ADD       1             Idx
484900210712     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
485000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0872'
485100210712     C                   MOVE      'N'           DDPocnOK
485200210712     C                   GOTO      EVPOCN
485300210712     C                   END
485400210712      *
485500210712      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
485600210712      *
485700210712     C     @PARTY        IFNE      'CUSTNUM'
485800210712     C     @PARTY        ANDNE     'CUSTSNM'
485900210712     C                   ADD       1             Idx
486000210712     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
486100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0946'
486200210712     C                   MOVE      'N'           DDPocnOK
486300210712     C                   GOTO      EVPOCN
486400210712     C                   END
486500210712      *
486600210712      ** Ordering customer can't be a bank
486700210712      *
486800210712     C     @BANK         IFEQ      'Y'
486900210712     C                   ADD       1             Idx
487000210712     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
487100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0804'
487200210712     C                   MOVE      'N'           DDPocnOK
487300210712     C                   GOTO      EVPOCN
487400210712     C                   END
487500210712     C                   ENDIF                                                              AR641619
487600210712      *
487700210712     C/COPY WNCPYSRC,ZASETINV04                                                               CUT009
487800210712      ** UPDATE OUTPUT FIELD
487900210712      *
488000210712     C                   MOVEL     BBCUST        FLPOCN
488100210712      *
488200210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
488300210712      **   INTO SCREEN FIELD.
488400210712      *
488500210712     C                   MOVEL     DDPOCN        @TSTQ             1
488600210712     C     @TSTQ         IFEQ      '?'
488700210712     C                   MOVEL     BBCSSN        DDPOCN
488800210712     C                   END
488900210712      *
489000210712     C     EVPOCN        ENDSR
489100210712     C********************************************************************
489200210712      /EJECT
489300210712     C*****************************************************************
489400210712     C*                                                               *
489500210712     C* VLPOBN - VALIDATE PAYMENT ORDERING BANK                       *
489600210712     C*                                                               *
489700210712     C*****************************************************************
489800210712     C     VLPOBN        BEGSR
489900210712      *
490000210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
490100210712      *
490200210712     C                   MOVE      *BLANKS       P#PART
490300210712     C                   MOVE      DDPOBN        P#PART
490400210712     C                   MOVEL     'NOTALLOW'    @CPNAL
490500210712     C                   EXSR      PARTYT
490600210712                                                                                             CSF011A
490700210712      ** Populate customer details                                                           CSF011A
490800210712                                                                                             CSF011A
490900210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
491000210712     C                   EVAL      DDPSH4 = BBCSSN                                           CSF011A
491100210712     C                   EVAL      DDPRN4 = BBCRNM                                           CSF011A
491200210712     C                   EVAL      DDPRT4 = BBCRTN                                           CSF011A
491300210712     C                   EVAL      DDPSI4 = BBCSID                                           CSF011A
491400210712     C                   ENDIF                                                               CSF011A
491500210712      *
491600210712      * NO SELECTION
491700210712      *
491800210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
491900210712     C     @RTCD         IFEQ      '*NOSEL '
492000210712     C                   ADD       1             Idx
492100210712     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
492200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0873'
492300210712     C                   MOVE      'N'           DDPobnOK
492400210712     C                   GOTO      EVPOBN
492500210712     C                   END
492600210712      *
492700210712     C/COPY WNCPYSRC,ZASETINV05                                                               CUT009
492800210712      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
492900210712      *
493000210712     C     @PARTY        IFNE      'CUSTNUM'
493100210712     C     @PARTY        ANDNE     'CUSTSNM'
493200210712     C                   ADD       1             Idx
493300210712     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
493400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0947'
493500210712     C                   MOVE      'N'           DDPobnOK
493600210712     C                   GOTO      EVPOBN
493700210712     C                   END
493800210712      *
493900210712      ** Ordering bank must be a bank
494000210712      *
494100210712     C     @BANK         IFNE      'Y'
494200210712     C*****DDPSTM        ANDEQ     '08'                                                194282 239836
494300210712     C                   ADD       1             Idx
494400210712     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
494500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0948'
494600210712     C                   MOVE      'N'           DDPobnOK
494700210712     C                   GOTO      EVPOBN
494800210712     C                   END
494900210712      *
495000210712     C*****BBBNBI        IFNE      'Y'                                                 194282 239836
495100210712     C*****DDPSTM        ANDNE     '08'                                                194282 239836
495200210712     C*********          MOVE      'N'           @BANK                                 194282 239836
495300210712     C*********          ELSE                                                          194282 239836
495400210712     C*********          MOVE      'Y'           @BANK                                 194282 239836
495500210712     C*********          END                                                           194282 239836
495600210712     C*****@BANK         IFNE      'Y'                                                 194282 239836
495700210712     C*****DDPSTM        ANDNE     '08'                                                194282 239836
495800210712     C*********          ADD       1             Idx                                   194282 239836
495900210712     C*********          EVAL      FldNameArr(Idx) = 'DDPOBN'                          194282 239836
496000210712     C*********          EVAL      MsgIDArr(Idx) = 'ESM1948'                           194282 239836
496100210712     C*********          MOVE      'N'           DDRobnOK                              194282 239836
496200210712     C*********          GOTO      EVPOBN                                              194282 239836
496300210712     C*********          END                                                           194282 239836
496400210712     C                   ENDIF                                                              AR641619
496500210712      *                                                                                       194282
496600210712      ** UPDATE OUTPUT FIELD
496700210712      *
496800210712     C                   MOVE      BBCUST        FLPOBN
496900210712      *
497000210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
497100210712      **   INTO SCREEN FIELD.
497200210712      *
497300210712     C                   MOVEL     DDPOBN        @TSTQ             1
497400210712     C     @TSTQ         IFEQ      '?'
497500210712     C                   MOVEL     BBCSSN        DDPOBN
497600210712     C                   END
497700210712      *
497800210712     C     EVPOBN        ENDSR
497900210712     C********************************************************************
498000210712      /EJECT
498100210712     C*****************************************************************
498200210712     C*                                                               *
498300210712     C* VLPOCB - VALIDATE PAYMENT ORDERING CUSTOMER & BANK            *
498400210712     C*                                                               *
498500210712     C*****************************************************************
498600210712     C     VLPOCB        BEGSR
498700210712      *
498800210712      ** ORDERING BANK MUST NOT BE THE SAME AS ORDERING CUSTOMER
498900210712      *
499000210712     C*****FLPOBN        IFNE      *ZEROS                                                     CSD027
499100210712     C     FLPOBN        IFNE      *BLANKS                                                    CSD027
499200210712     C     FLPOBN        ANDEQ     FLPOCN
499300210712     C                   ADD       1             Idx
499400210712     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
499500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0949'
499600210712     C                   MOVE      'N'           DDPobnOK
499700210712     C                   END
499800210712      *
499900210712     C                   ENDSR
500000210712     C********************************************************************
500100210712      /EJECT
500200210712     C*****************************************************************
500300210712     C*                                                               *
500400210712     C* VLRCRN - VALIDATE RECEIVERS CORRESPONDENT                     *
500500210712     C*                                                               *
500600210712     C*****************************************************************
500700210712     C     VLRCRN        BEGSR
500800210712     C/COPY WNCPYSRC,ZAH00013
500900210712      *
501000210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
501100210712      *
501200210712     C                   MOVE      *BLANKS       P#PART
501300210712     C                   MOVE      DDRCRN        P#PART
501400210712     C                   MOVEL     'ALLOWED '    @CPNAL
501500210712     C/COPY WNCPYSRC,ZAH00018
501600210712     C                   EXSR      PARTYT
501700210712                                                                                             CSF011A
501800210712      ** Populate Customer details                                                           CSF011A
501900210712                                                                                             CSF011A
502000210712     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
502100210712     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
502200210712     C                   EVAL      DDPSH5 = BBCSSN                                           CSF011A
502300210712     C                   EVAL      DDPRN5 = BBCRNM                                           CSF011A
502400210712     C                   EVAL      DDPRT5 = BBCRTN                                           CSF011A
502500210712     C                   EVAL      DDPSI5 = BBCSID                                           CSF011A
502600210712     C                   ELSEIF    @PARTY  = 'COUNTNS'                                       CSF011A
502700210712     C                   EVAL      DDPSH5 = AWCSN1 + AWCSN2                                  CSF011A
502800210712     C                   EVAL      DDPRN5 = AWCPNM                                           CSF011A
502900210712     C                   EVAL      DDPRT5 = AWCNTN                                           CSF011A
503000210712     C                   EVAL      DDPSI5 = AWSWID                                           CSF011A
503100210712     C                   ENDIF                                                               CSF011A
503200210712      *
503300210712      * NO SELECTION
503400210712      *
503500210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
503600210712     C     @RTCD         IFEQ      '*NOSEL '
503700210712     C                   ADD       1             Idx
503800210712     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
503900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0874'
504000210712     C                   MOVE      'N'           DDRcrnOK
504100210712     C                   GOTO      EVRCRN
504200210712     C                   END
504300210712      *
504400210712      ** ERROR
504500210712      *
504600210712     C     @PARTY        IFEQ      'ERROR'
504700210712     C/COPY WNCPYSRC,ZAH00021
504800210712     C                   ADD       1             Idx
504900210712     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
505000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0957'
505100210712     C                   MOVE      'N'           DDRcrnOK
505200210712     C/COPY WNCPYSRC,ZAH00022
505300210712     C                   GOTO      EVRCRN
505400210712     C                   END
505500210712     C                   ENDIF                                                              AR641619
505600210712      *
505700210712      * TEST 1ST DIGIT
505800210712      *
505900210712     C                   MOVEL     DDRCRN        @TSTQ
506000210712      *
506100210712      ** IF A CUSTOMER NUMBER OR SHORTNAME
506200210712      *
506300210712     C     @PARTY        IFEQ      'CUSTNUM'
506400210712     C     @PARTY        OREQ      'CUSTSNM'
506500210712      *
506600210712      **  ERROR IF NOT A BANK
506700210712      *
506800210712     C     @BANK         IFEQ      'Y'
506900210712     C                   MOVEL     BBCUST        FLRCRN
507000210712     C/COPY WNCPYSRC,ZAH00014
507100210712     C                   ELSE
507200210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
507300210712     C                   ADD       1             Idx
507400210712     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
507500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0958'
507600210712     C                   MOVE      'N'           DDRcrnOK
507700210712     C                   GOTO      EVRCRN
507800210712     C                   ENDIF                                                              AR641619
507900210712     C                   END
508000210712      *
508100210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
508200210712      **   INTO SCREEN FIELD.
508300210712      *
508400210712     C     @TSTQ         IFEQ      '?'
508500210712     C                   MOVEL     BBCSSN        DDRCRN
508600210712     C                   END
508700210712      *
508800210712      ** ELSE IF A COUNTERPARTY NOSTRO
508900210712      *
509000210712     C                   ELSE
509100210712     C                   MOVEL     AWCPNC        FLRCRN
509200210712      *
509300210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
509400210712      **   INTO SCREEN FIELD.
509500210712      *
509600210712     C     @TSTQ         IFEQ      '?'
509700210712     C                   MOVE      *BLANKS       DDRCRN
509800210712     C                   MOVEL     AWCPNC        DDRCRN
509900210712     C                   END
510000210712     C                   END
510100210712     C/COPY WNCPYSRC,ZAH00015
510200210712      *
510300210712     C     EVRCRN        ENDSR
510400210712     C*****************************************************************
510500210712      /EJECT
510600210712     C*****************************************************************
510700210712     C*                                                               *
510800210712     C* VLRCRA - VALIDATE RECEIVERS CORRESPONDENT A/C LINE            *
510900210712     C*                                                               *
511000210712     C*****************************************************************
511100210712     C     VLRCRA        BEGSR
511200210712      *
511300210712      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN REC. CORR.
511400210712      *
511500210712     C     DDRCRN        IFEQ      *BLANKS
511600210712     C                   ADD       1             Idx
511700210712     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
511800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0899'
511900210712     C                   MOVE      'N'           DDRcrnOK
512000210712     C                   END
512100210712      *
512200210712      ** FIRST TWO CHARACTERS MAY NOT BE '//'
512300210712      *
512400210712     C                   MOVE      DDRCRA        L#XIBA
512500210712     C     L#RCR2        IFEQ      '//'
512600210712     C                   ADD       1             Idx
512700210712     C                   EVAL      FldNameArr(Idx) = 'DDRCRA'
512800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0960'
512900210712     C                   MOVE      'N'           DDRcraOK
513000210712     C                   END
513100210712      *
513200210712      ** If 1st & 3rd character are '/',
513300210712      ** then 2nd character must be 'C' or 'D'.
513400210712      *
513500210712     C     L#XIB1        IFEQ      '/'
513600210712     C     L#XIBE        ANDEQ     '/'
513700210712     C     L#XIB2        IFNE      'C'
513800210712     C     L#XIB2        ANDNE     'D'
513900210712     C                   ADD       1             Idx
514000210712     C                   EVAL      FldNameArr(Idx) = 'DDRCRA'
514100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0201'
514200210712     C                   MOVE      'N'           DDRcraOK
514300210712     C                   END
514400210712     C                   END
514500210712      *
514600210712      * UPDATE OUTPUT FIELD
514700210712      *
514800210712     C                   MOVEL     DDRCRA        FLRCRA
514900210712     C                   ENDSR
515000210712     C*****************************************************************
515100210712      /EJECT
515200210712     C*****************************************************************
515300210712     C*                                                               *
515400210712     C* VLPIBN - VALIDATE PAYMENT INTERMEDIARY BANK                   *
515500210712     C*                                                               *
515600210712     C*****************************************************************
515700210712     C     VLPIBN        BEGSR
515800210712      *
515900210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
516000210712      *
516100210712     C                   MOVE      *BLANKS       P#PART
516200210712     C                   MOVE      DDPIBN        P#PART
516300210712     C                   MOVEL     'ALLOWED '    @CPNAL
516400210712     C     DDPSTM        IFEQ      '07'
516500210712     C                   MOVEL     'NOTALLOW'    @CPNAL
516600210712     C                   END
516700210712     C                   EXSR      PARTYT
516800210712                                                                                             CSF011A
516900210712      ** Populate customer details                                                           CSF011A
517000210712                                                                                             CSF011A
517100210712     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
517200210712     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
517300210712     C                   EVAL      DDPSH6 = BBCSSN                                           CSF011A
517400210712     C                   EVAL      DDPRN6 = BBCRNM                                           CSF011A
517500210712     C                   EVAL      DDPRT6 = BBCRTN                                           CSF011A
517600210712     C                   EVAL      DDPSI6 = BBCSID                                           CSF011A
517700210712     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
517800210712     C                   EVAL      DDPSH6 = AWCSN1 + AWCSN2                                  CSF011A
517900210712     C                   EVAL      DDPRN6 = AWCPNM                                           CSF011A
518000210712     C                   EVAL      DDPRT6 = AWCNTN                                           CSF011A
518100210712     C                   EVAL      DDPSI6 = AWSWID                                           CSF011A
518200210712     C                   ENDIF                                                               CSF011A
518300210712      *
518400210712      * NO SELECTION
518500210712      *
518600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
518700210712     C     @RTCD         IFEQ      '*NOSEL '
518800210712     C                   ADD       1             Idx
518900210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
519000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0875'
519100210712     C                   MOVE      'N'           DDPibnOK
519200210712     C                   GOTO      EVPIBN
519300210712     C                   END
519400210712      *
519500210712      ** ERROR
519600210712      *
519700210712     C     @PARTY        IFEQ      'ERROR'
519800210712     C                   ADD       1             Idx
519900210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
520000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0962'
520100210712     C                   MOVE      'N'           DDPibnOK
520200210712     C                   GOTO      EVPIBN
520300210712     C                   END
520400210712     C                   ENDIF                                                              AR641619
520500210712      *
520600210712      * TEST 1ST DIGIT
520700210712      *
520800210712     C                   MOVEL     DDPIBN        @TSTQ
520900210712      *
521000210712      ** IF A CUSTOMER NUMBER OR SHORTNAME
521100210712      *
521200210712     C     @PARTY        IFEQ      'CUSTNUM'
521300210712     C     @PARTY        OREQ      'CUSTSNM'
521400210712      *
521500210712      **  ERROR IF NOT A BANK
521600210712      *
521700210712     C     @BANK         IFEQ      'Y'
521800210712     C                   MOVEL     BBCUST        FLPIBN
521900210712     C                   ELSE
522000210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
522100210712     C                   ADD       1             Idx
522200210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
522300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0963'
522400210712     C                   MOVE      'N'           DDPibnOK
522500210712     C                   GOTO      EVPIBN
522600210712     C                   ENDIF                                                              AR641619
522700210712     C                   END
522800210712      *
522900210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
523000210712      **   INTO SCREEN FIELD.
523100210712      *
523200210712     C     @TSTQ         IFEQ      '?'
523300210712     C                   MOVEL     BBCSSN        DDPIBN
523400210712     C                   END
523500210712      *
523600210712      ** ELSE IF A COUNTERPARTY NOSTRO
523700210712      *
523800210712     C                   ELSE
523900210712     C                   MOVEL     AWCPNC        FLPIBN
524000210712      *
524100210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
524200210712      **   INTO SCREEN FIELD.
524300210712      *
524400210712     C     @TSTQ         IFEQ      '?'
524500210712     C                   MOVE      *BLANKS       DDPIBN
524600210712     C                   MOVEL     AWCPNC        DDPIBN
524700210712     C                   END
524800210712     C                   END
524900210712      *
525000210712     C     EVPIBN        ENDSR
525100210712     C********************************************************************
525200210712      /EJECT
525300210712     C*****************************************************************
525400210712     C*                                                               *
525500210712     C* VLPIBA - VALIDATE PAYMENT INTERMEDIARY BANK A/C LINE          *
525600210712     C*                                                               *
525700210712     C*****************************************************************
525800210712     C     VLPIBA        BEGSR
525900210712      *
526000210712     C                   MOVE      DDPIBA        L#XIBA
526100210712      *
526200210712      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN INTER. BANK
526300210712      *
526400210712     C     DDPIBN        IFEQ      *BLANKS
526500210712     C                   ADD       1             Idx
526600210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'
526700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0965'
526800210712     C                   MOVE      'N'           DDPibaOK
526900210712     C                   GOTO      EVPIBA
527000210712     C                   END
527100210712      *                                                                                       193584
527200210712      * If Nostro is a CLS Dummy Nostro, field must be blank.                                 193584
527300210712      *                                                                                       193584
527400210712     C                   MOVE      DDPONS        A#OURA                                       193584
527500210712     C                   MOVE      E#PCCY        @CYCD                                        193584
527600210712     C                   MOVE      A#NOST        @NONB                                        193584
527700210712      *                                                                                       193584
527800210712      * ACCESS NOSTRO DETAILS                                                                 193584
527900210712      *                                                                                       193584
528000210712     C                   EXSR      ACNOST                                                     193584
528100210712      *                                                                                       193584
528200210712     C     A7CLSD        IFEQ      'Y'                                                        193584
528300210712     C                   ADD       1             Idx                                          193584
528400210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'                                 193584
528500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0161'                                  193584
528600210712     C                   MOVE      'N'           DDPibaOK                                     193584
528700210712     C                   GOTO      EVPIBA                                                     193584
528800210712     C                   END                                                                  193584
528900210712      *
529000210712      * Call Account Line Validation object
529100210712      *
529200210712      * Set up parameters
529300210712      *
529400210712     C                   MOVEL     *BLANKS       W0RTN
529500210712     C                   CLEAR                   I#PARM
529600210712     C                   MOVEL     'INBK '       I#VFLD
529700210712     C                   MOVEL     'PAY'         I#PR
529800210712     C                   MOVEL     'X'           I#PRTT
529900210712     C                   MOVEL     DDPIBN        I#PRTY
530000210712     C                   MOVEL     E#PCCY        I#PCCY
530100210712     C                   MOVEL     E#RCCY        I#RCCY
530200210712     C                   MOVEL     DDPIBA        I#ACLN
530300210712     C                   MOVEL     DDPSTM        I#PSTM
530400210712     C                   MOVEL     DDRSTM        I#RSTM
530500210712     C     DDPOCN        IFNE      *BLANKS
530600210712                                                                                              CSW203
530700210712      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
530800210712                                                                                              CSW203
530900210712     C                   IF        CSW203 = 'Y'                                               CSW203
531000210712     C                   EVAL      I#MTYP = '103'                                             CSW203
531100210712     C                   ELSE                                                                 CSW203
531200210712     C                   MOVEL     '100'         I#MTYP
531300210712     C                   ENDIF                                                                CSW203
531400210712     C                   ELSE
531500210712     C                   MOVEL     '202'         I#MTYP
531600210712     C                   ENDIF
531700210712      *
531800210712      * Set up receive account information
531900210712      *
532000210712     C     DDRONS        IFNE      *BLANKS
532100210712     C                   SELECT
532200210712     C     DDROBR        WHENNE    *BLANKS
532300210712     C     DDRONS        CAT       DDROBR        I#RCAC
532400210712     C     DDRONS        WHENNE    *BLANKS
532500210712     C                   MOVEL     DDRONS        I#RCAC
532600210712     C                   ENDSL
532700210712     C                   ENDIF
532800210712      *
532900210712      * Set up Pay account information
533000210712      *
533100210712     C     DDPONS        IFNE      *BLANKS
533200210712     C                   SELECT
533300210712     C     DDPOBR        WHENNE    *BLANKS
533400210712     C     DDPONS        CAT       DDPOBR        I#PYAC
533500210712     C     DDPONS        WHENNE    *BLANKS
533600210712     C                   MOVEL     DDPONS        I#PYAC
533700210712     C                   ENDSL
533800210712     C                   ENDIF
533900210712      *
534000210712      * If extra message and Rec Corr. then set 5354 field
534100210712      *
534200210712     C     DDRVNO        IFNE      *BLANKS
534300210712     C     DDRCRN        ANDNE     *BLANKS
534400210712     C                   MOVEL     'Y'           I#5354
534500210712     C                   ENDIF
534600210712      *
534700210712      * Transaction Type
534800210712      *
534900210712     C                   MOVEL     ##TTYP        I#TTYP
535000210712      *
535100210712     C                   CLEAR                   O#PARM
535200210712     C                   CLEAR                   E#PARM
535300210712      *
535400210712      * Send messages to correct calling process
535500210712      *
535600210712     C                   SELECT
535700210712     C     ##CALP        WHENEQ    'FXDL'
535800210712     C                   MOVEL     'ME9940'      E#CPGM
535900210712     C                   MOVEL     'DL'          I#MMOD
536000210712     C     ##CALP        WHENEQ    'LDNI'
536100210712     C                   MOVEL     'ME9940'      E#CPGM
536200210712     C                   MOVEL     'DL'          I#MMOD
536300210712     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
536400210712     C     ##CALP        OREQ      'MAPY'                                                     239587
536500210712     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
536600210712     C                   MOVEL     'LE'          I#MMOD                                       CAP068
536700210712     C     ##CALP        WHENEQ    'SSI '
536800210712     C                   MOVEL     'SD0401R'     E#CPGM
536900210712     C                   MOVEL     'AT'          I#MMOD
537000210712     C                   OTHER
537100210712     C                   MOVEL     'ME9940'      E#CPGM
537200210712     C                   ENDSL
537300210712     C                   MOVEL     'MEC0016'     E#MSGD
537400210712     C                   MOVEL     'MEMSG'       E#MSGF
537500210712      *
537600210712     C                   CALL      'ME9940'
537700210712     C                   PARM                    W0RTN             7
537800210712     C                   PARM                    I#PARM                         I Input Parms
537900210712     C                   PARM                    O#PARM                         O Output Parms
538000210712     C                   PARM                    E#PARM                         E Error Inform
538100210712     C                   PARM                    Z#PARM          256            B User Defined
538200210712      *
538300210712      * A/c line modified
538400210712     C                   MOVEL     O#ACLN        DDPIBA
538500210712      *
538600210712      ** Subtract 1 from error array index
538700210712     C                   SUB       1             E#INDX
538800210712      *
538900210712      * On return, if errors copy into error array
539000210712      *
539100210712     C     E#ERRM        IFNE      *BLANKS
539200210712     C     1             DO        E#INDX        Q#                5 0
539300210712     C                   ADD       1             Idx
539400210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'
539500210712     C                   MOVEL     'ESM0'        WMessageID
539600210712     C                   MOVE      O#E(Q#)       WMessageID
539700210712     C                   EVAL      MsgIDArr(Idx) = WMessageID
539800210712     C                   ENDDO
539900210712     C                   MOVEL     'N'           DDPibaOK
540000210712     C                   ENDIF
540100210712      *
540200210712      * UPDATE OUTPUT FIELD
540300210712      *
540400210712     C                   MOVEL     DDPIBA        FLPIBA
540500210712      *
540600210712     C     EVPIBA        ENDSR
540700210712      *****************************************************************
540800210712      /EJECT
540900210712     C*****************************************************************
541000210712     C*                                                               *
541100210712     C* VLAWBN - VALIDATE PAYMENT A/C WITH BANK                       *
541200210712     C*                                                               *
541300210712     C*****************************************************************
541400210712     C     VLAWBN        BEGSR
541500210712      *
541600210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
541700210712      *
541800210712     C                   MOVE      *BLANKS       P#PART
541900210712     C                   MOVE      DDAWBN        P#PART
542000210712     C                   MOVEL     'ALLOWED '    @CPNAL
542100210712     C     DDPSTM        IFEQ      '07'
542200210712     C                   MOVEL     'NOTALLOW'    @CPNAL
542300210712     C                   END
542400210712     C                   EXSR      PARTYT
542500210712                                                                                             CSF011A
542600210712     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
542700210712     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
542800210712     C                   EVAL      DDPSH7 = BBCSSN                                           CSF011A
542900210712     C                   EVAL      DDPRN7 = BBCRNM                                           CSF011A
543000210712     C                   EVAL      DDPRT7 = BBCRTN                                           CSF011A
543100210712     C                   EVAL      DDPSI7 = BBCSID                                           CSF011A
543200210712     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
543300210712     C                   EVAL      DDPSH7 = AWCSN1 + AWCSN2                                  CSF011A
543400210712     C                   EVAL      DDPRN7 = AWCPNM                                           CSF011A
543500210712     C                   EVAL      DDPRT7 = AWCNTN                                           CSF011A
543600210712     C                   EVAL      DDPSI7 = AWSWID                                           CSF011A
543700210712     C                   ENDIF                                                               CSF011A
543800210712      *
543900210712      ** If no record selected from the Customer or Counterparty Nostro
544000210712      ** screens, or if field was neither of these, and only two
544100210712      ** characters have been entered into the field, check for a Nostro
544200210712      ** Number.
544300210712      *
544400210712     C     @RTCD         IFEQ      '*NOSEL '
544500210712     C     @PARTY        OREQ      'ERROR'
544600210712      *
544700210712      ** Set up work field for checking Nostro Number
544800210712      *
544900210712     C                   MOVEL     DDAWBN        W#AWBN
545000210712      *
545100210712      ** Align and check Nostro Number
545200210712      *
545300210712     C                   Z-ADD     1             @                 2 0
545400210712     C     *BLANKS       LOOKUP    W#AW(@)                            99
545500210712      *
545600210712      ** If a non-blank character was found:
545700210712      *
545800210712     C     *IN99         IFEQ      '1'
545900210712      *
546000210712     C                   MOVEL     *BLANKS       W#WK10           10
546100210712     C                   MOVEA     W#AW(@)       W#WK10
546200210712     C                   MOVE      W#WK10        W#AWBN
546300210712      *
546400210712      ** The first two characters of W#AWBN should now contain the Nostro
546500210712      ** Number; check that the remaining characters are blank
546600210712      *
546700210712     C     W#REST        IFEQ      *BLANKS
546800210712      *
546900210712      ** If they are, check whether the value in the first two characters
547000210712      ** is a valid Nostro Number
547100210712      *
547200210712     C                   MOVE      E#PCCY        @CYCD
547300210712     C                   MOVEL     W#NOST        @NONB
547400210712     C                   EXSR      ACNOST
547500210712                                                                                             CSF011A
547600210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
547700210712     C                   EVAL      @CSCN  = A7CUST                                           CSF011A
547800210712     C                   EXSR      ACCUST                                                    CSF011A
547900210712     C                   EVAL      DDPSH7 = BBCSSN                                           CSF011A
548000210712     C                   EVAL      DDPRN7 = BBCRNM                                           CSF011A
548100210712     C                   EVAL      DDPRT7 = BBCRTN                                           CSF011A
548200210712     C                   EVAL      DDPSI7 = BBCSID                                           CSF011A
548300210712     C                   ENDIF                                                               CSF011A
548400210712                                                                                             CSF011A
548500210712     C                   END
548600210712     C                   END
548700210712     C                   END
548800210712      *
548900210712      * NO SELECTION
549000210712      *
549100210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
549200210712     C     @RTCD         IFEQ      '*NOSEL '
549300210712     C                   ADD       1             Idx
549400210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
549500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0876'
549600210712     C                   MOVE      'N'           DDAwbnOK
549700210712     C                   GOTO      EVAWBN
549800210712     C                   END
549900210712      *
550000210712      * ERROR
550100210712      *
550200210712     C     @RTCD         IFNE      *BLANKS
550300210712     C                   ADD       1             Idx
550400210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
550500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0970'
550600210712     C                   MOVE      'N'           DDAwbnOK
550700210712     C                   GOTO      EVAWBN
550800210712     C                   END
550900210712     C                   ENDIF                                                              AR641619
551000210712      *
551100210712      * TEST 1ST DIGIT
551200210712      *
551300210712     C                   MOVEL     DDAWBN        @TSTQ
551400210712      *
551500210712      ** IF A CUSTOMER NUMBER OR SHORTNAME
551600210712      *
551700210712     C     @PARTY        IFEQ      'CUSTNUM'
551800210712     C     @PARTY        OREQ      'CUSTSNM'
551900210712     C/COPY WNCPYSRC,ZASETNVC09
552000210712      *
552100210712      **  ERROR IF NOT A BANK
552200210712      *
552300210712     C     @BANK         IFEQ      'Y'
552400210712     C                   MOVEL     BBCUST        FLAWBN
552500210712     C                   ELSE
552600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
552700210712     C                   ADD       1             Idx
552800210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
552900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0971'
553000210712     C                   MOVE      'N'           DDAwbnOK
553100210712     C                   GOTO      EVAWBN
553200210712     C                   ENDIF                                                              AR641619
553300210712     C                   END
553400210712     C/COPY WNCPYSRC,ZASETNVC10
553500210712      *
553600210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
553700210712      **   INTO SCREEN FIELD.
553800210712      *
553900210712     C     @TSTQ         IFEQ      '?'
554000210712     C                   MOVEL     BBCSSN        DDAWBN
554100210712     C                   END
554200210712      *
554300210712      ** ELSE IF A COUNTERPARTY NOSTRO
554400210712      *
554500210712     C                   ELSE
554600210712     C     @PARTY        IFEQ      'COUNTNS'
554700210712     C                   MOVEL     AWCPNC        FLAWBN
554800210712      *
554900210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
555000210712      **   INTO SCREEN FIELD.
555100210712      *
555200210712     C     @TSTQ         IFEQ      '?'
555300210712     C                   MOVE      *BLANKS       DDAWBN
555400210712     C                   MOVEL     AWCPNC        DDAWBN
555500210712     C                   END
555600210712      *
555700210712      ** ELSE IF A NOSTRO
555800210712      *
555900210712     C                   ELSE
556000210712     C                   MOVEL     A7CUST        FLAWBN
556100210712      *
556200210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
556300210712      **   INTO SCREEN FIELD.
556400210712      *
556500210712     C     @TSTQ         IFEQ      '?'
556600210712     C                   MOVE      *BLANKS       DDAWBN
556700210712     C                   MOVEL     A7CUST        DDAWBN
556800210712     C                   END
556900210712     C                   END
557000210712     C                   END
557100210712      *
557200210712     C     EVAWBN        ENDSR
557300210712      *****************************************************************
557400210712      /EJECT
557500210712     C*****************************************************************
557600210712     C*                                                               *
557700210712     C* VLAWBA - VALIDATE PAYMENT A/C WITH BANK A/C LINE              *
557800210712     C*                                                               *
557900210712     C*****************************************************************
558000210712     C     VLAWBA        BEGSR
558100210712      *
558200210712     C                   MOVEL     DDAWBA        W#AW06            6
558300210712     C                   MOVE      DDAWBA        W#AW29           29
558400210712      *
558500210712      ** ACCOUNT WITH MUST BE BLANK IF 'DIRECT' ENTERED IN ACCOUNT WITH
558600210712      ** BANK A/C LINE
558700210712      *
558800210712     C     DDAWBN        IFNE      *BLANKS
558900210712     C     W#AW06        ANDEQ     'DIRECT'
559000210712     C                   ADD       1             Idx
559100210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
559200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0973'
559300210712     C                   MOVE      'N'           DDAwbnOK
559400210712     C                   GOTO      EVAWBA
559500210712     C                   END
559600210712      *                                                                                       193584
559700210712      * If Nostro is a CLS Dummy Nostro, this field must be blank.                            193584
559800210712      *                                                                                       193584
559900210712     C                   MOVE      DDPONS        A#OURA                                       193584
560000210712     C                   MOVE      E#PCCY        @CYCD                                        193584
560100210712     C                   MOVE      A#NOST        @NONB                                        193584
560200210712      *                                                                                       193584
560300210712      * ACCESS NOSTRO DETAILS                                                                 193584
560400210712      *                                                                                       193584
560500210712     C                   EXSR      ACNOST                                                     193584
560600210712      *                                                                                       193584
560700210712     C     A7CLSD        IFEQ      'Y'                                                        193584
560800210712     C                   ADD       1             Idx                                          193584
560900210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'                                 193584
561000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0162'                                  193584
561100210712     C                   MOVE      'N'           DDAwbaOK                                     193584
561200210712     C                   GOTO      EVAWBA                                                     193584
561300210712     C                   END                                                                  193584
561400210712      *
561500210712      ** AWBA MAY ONLY CONTAIN WORD 'DIRECT' WHEN AWBN BLANK
561600210712      *
561700210712     C     DDAWBN        IFEQ      *BLANKS
561800210712     C     DDAWBA        ANDNE     *BLANKS
561900210712     C     W#AW06        ANDNE     'DIRECT'
562000210712     C*
562100210712     C     DDAWBN        OREQ      *BLANKS
562200210712     C     DDAWBA        ANDNE     *BLANKS
562300210712     C     W#AW29        ANDNE     *BLANKS
562400210712     C*
562500210712     C     DDAWBN        OREQ      *BLANKS
562600210712     C     W#AW29        ANDNE     *BLANKS
562700210712     C*
562800210712     C     DDAWBN        ORNE      *BLANKS
562900210712     C     W#AW06        ANDEQ     'DIRECT'
563000210712     C     W#AW29        ANDEQ     *BLANKS
563100210712     C                   ADD       1             Idx
563200210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'
563300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0974'
563400210712     C                   MOVE      'N'           DDAwbaOK
563500210712     C                   GOTO      EVAWBA
563600210712     C                   END
563700210712      *
563800210712     C     DDAWBA        IFNE      *BLANKS
563900210712     C     W#AW06        ANDNE     'DIRECT'
564000210712     C                   MOVE      DDAWBA        L#XIBA
564100210712      *
564200210712      ** FIRST CHARACTER MUST BE '/'
564300210712      *
564400210712     C     L#XIB1        IFNE      '/'
564500210712     C                   ADD       1             Idx
564600210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'
564700210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0974'                                  182652
564800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0502'                                  182652
564900210712     C                   MOVE      'N'           DDAwbaOK
565000210712     C                   END
565100210712      *
565200210712      * Call Account Line Validation object
565300210712      *
565400210712      * Set up parameters
565500210712      *
565600210712     C                   MOVEL     *BLANKS       W0RTN
565700210712     C                   CLEAR                   I#PARM
565800210712     C                   MOVEL     'AWBK '       I#VFLD
565900210712     C                   MOVEL     'PAY'         I#PR
566000210712     C                   MOVEL     'X'           I#PRTT
566100210712     C                   MOVEL     DDAWBN        I#PRTY
566200210712     C                   MOVEL     E#PCCY        I#PCCY
566300210712     C                   MOVEL     E#RCCY        I#RCCY
566400210712     C                   MOVEL     DDAWBA        I#ACLN
566500210712     C                   MOVEL     DDPSTM        I#PSTM
566600210712     C                   MOVEL     DDRSTM        I#RSTM
566700210712     C     DDPOCN        IFNE      *BLANKS
566800210712                                                                                              CSW203
566900210712      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
567000210712                                                                                              CSW203
567100210712     C                   IF        CSW203 = 'Y'                                               CSW203
567200210712     C                   EVAL      I#MTYP = '103'                                             CSW203
567300210712     C                   ELSE                                                                 CSW203
567400210712     C                   MOVEL     '100'         I#MTYP
567500210712     C                   ENDIF                                                                CSW203
567600210712     C                   ELSE
567700210712     C                   MOVEL     '202'         I#MTYP
567800210712     C                   ENDIF
567900210712      *
568000210712      * Set up receive account information
568100210712      *
568200210712     C     DDRONS        IFNE      *BLANKS
568300210712     C                   SELECT
568400210712     C     DDROBR        WHENNE    *BLANKS
568500210712     C     DDRONS        CAT       DDROBR        I#RCAC
568600210712     C     DDRONS        WHENNE    *BLANKS
568700210712     C                   MOVEL     DDRONS        I#RCAC
568800210712     C                   ENDSL
568900210712     C                   ENDIF
569000210712      *
569100210712      * Set up Pay account information
569200210712      *
569300210712     C     DDPONS        IFNE      *BLANKS
569400210712     C                   SELECT
569500210712     C     DDPOBR        WHENNE    *BLANKS
569600210712     C     DDPONS        CAT       DDPOBR        I#PYAC
569700210712     C     DDPONS        WHENNE    *BLANKS
569800210712     C                   MOVEL     DDPONS        I#PYAC
569900210712     C                   ENDSL
570000210712     C                   ENDIF
570100210712      *
570200210712      * If extra message and Rec Corr. then set 5354 field
570300210712      *
570400210712     C     DDRVNO        IFNE      *BLANKS
570500210712     C     DDRCRN        ANDNE     *BLANKS
570600210712     C                   MOVEL     'Y'           I#5354
570700210712     C                   ENDIF
570800210712      *
570900210712      * Transaction Type
571000210712      *
571100210712     C                   MOVEL     ##TTYP        I#TTYP
571200210712      *
571300210712     C                   CLEAR                   O#PARM
571400210712     C                   CLEAR                   E#PARM
571500210712      *
571600210712      * Send messages to correct calling process
571700210712      *
571800210712     C                   SELECT
571900210712     C     ##CALP        WHENEQ    'FXDL'
572000210712     C                   MOVEL     'ME9940'      E#CPGM
572100210712     C                   MOVEL     'DL'          I#MMOD
572200210712     C     ##CALP        WHENEQ    'LDNI'
572300210712     C                   MOVEL     'ME9940'      E#CPGM
572400210712     C                   MOVEL     'DL'          I#MMOD
572500210712     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
572600210712     C     ##CALP        OREQ      'MAPY'                                                     239587
572700210712     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
572800210712     C                   MOVEL     'LE'          I#MMOD                                       CAP068
572900210712     C     ##CALP        WHENEQ    'SSI '
573000210712     C                   MOVEL     'SD0401R'     E#CPGM
573100210712     C                   MOVEL     'AT'          I#MMOD
573200210712     C                   OTHER
573300210712     C                   MOVEL     'ME9940'      E#CPGM
573400210712     C                   ENDSL
573500210712     C                   MOVEL     'MEC0017'     E#MSGD
573600210712     C                   MOVEL     'MEMSG'       E#MSGF
573700210712      *
573800210712     C                   CALL      'ME9940'
573900210712     C                   PARM                    W0RTN             7
574000210712     C                   PARM                    I#PARM                         I Input Parms
574100210712     C                   PARM                    O#PARM                         O Output Parms
574200210712     C                   PARM                    E#PARM                         E Error Inform
574300210712     C                   PARM                    Z#PARM          256            B User Defined
574400210712      *
574500210712      * A/c line modified
574600210712     C                   MOVEL     O#ACLN        DDAWBA
574700210712      *
574800210712      ** Subtract 1 from error array index
574900210712     C                   SUB       1             E#INDX
575000210712      *
575100210712      * On return if errors copy into error array
575200210712      *
575300210712     C     E#ERRM        IFNE      *BLANKS
575400210712     C     1             DO        E#INDX        Q#                5 0
575500210712     C                   ADD       1             Idx
575600210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'
575700210712     C                   MOVEL     'ESM0'        WMessageID
575800210712     C                   MOVE      O#E(Q#)       WMessageID
575900210712     C                   EVAL      MsgIDArr(Idx) = WMessageID
576000210712     C                   ENDDO
576100210712     C                   MOVEL     'N'           DDAwbaOK
576200210712     C                   ENDIF
576300210712      *
576400210712     C                   ENDIF
576500210712      *
576600210712      * UPDATE OUTPUT FIELD
576700210712      *
576800210712     C                   MOVEL     DDAWBA        FLAWBA
576900210712      *
577000210712     C     EVAWBA        ENDSR
577100210712      *****************************************************************
577200210712      /EJECT
577300210712     C*****************************************************************
577400210712     C*                                                               *
577500210712     C* VLBENN - VALIDATE BENEFICIARY                                 *
577600210712     C*                                                               *
577700210712     C*****************************************************************
577800210712     C     VLBENN        BEGSR
577900210712      *
578000210712      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
578100210712      *
578200210712     C                   MOVE      *BLANKS       P#PART
578300210712     C                   MOVE      DDBENN        P#PART
578400210712     C                   MOVEL     'ALLOWED '    @CPNAL
578500210712     C     DDPSTM        IFEQ      '07'
578600210712     C                   MOVEL     'NOTALLOW'    @CPNAL
578700210712     C                   END
578800210712     C                   EXSR      PARTYT
578900210712                                                                                             CSF011A
579000210712     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
579100210712     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
579200210712     C                   EVAL      DDPSH8 = BBCSSN                                           CSF011A
579300210712     C                   EVAL      DDPRN8 = BBCRNM                                           CSF011A
579400210712     C                   EVAL      DDPRT8 = BBCRTN                                           CSF011A
579500210712     C                   EVAL      DDPSI8 = BBCSID                                           CSF011A
579600210712     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
579700210712     C                   EVAL      DDPSH8 = AWCSN1 + AWCSN2                                  CSF011A
579800210712     C                   EVAL      DDPRN8 = AWCPNM                                           CSF011A
579900210712     C                   EVAL      DDPRT8 = AWCNTN                                           CSF011A
580000210712     C                   EVAL      DDPSI7 = AWSWID                                           CSF011A
580100210712     C                   ENDIF                                                               CSF011A
580200210712      *
580300210712      * NO SELECTION
580400210712      *
580500210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
580600210712     C     @RTCD         IFEQ      '*NOSEL '
580700210712     C                   ADD       1             Idx
580800210712     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
580900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0877'
581000210712     C                   MOVE      'N'           DDBennOK
581100210712     C                   GOTO      EVBENN
581200210712     C                   END
581300210712      *
581400210712      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
581500210712      *
581600210712     C     @PARTY        IFEQ      'ERROR'
581700210712     C                   ADD       1             Idx
581800210712     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
581900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0978'
582000210712     C                   MOVE      'N'           DDBennOK
582100210712     C                   GOTO      EVBENN
582200210712     C                   END
582300210712     C                   ENDIF                                                              AR641619
582400210712      *
582500210712      * TEST 1ST DIGIT
582600210712      *
582700210712     C                   MOVEL     DDBENN        @TSTQ
582800210712      *
582900210712      ** IF A CUSTOMER NUMBER OR SHORTNAME
583000210712      *
583100210712     C     @PARTY        IFEQ      'CUSTNUM'
583200210712     C     @PARTY        OREQ      'CUSTSNM'
583300210712      *
583400210712      ** UPDATE OUTPUT FIELD
583500210712      *
583600210712     C                   MOVEL     BBCUST        FLBENN
583700210712      *                                                                                     AR892347
583800210712      ** UPDATE BENEFICIARY BANK/NON-BANK IND.                                              AR892347
583900210712      *                                                                                     AR892347
584000210712     C                   MOVEL     @BANK         @BBNBI                                     AR892347
584100210712      *
584200210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
584300210712      **   INTO SCREEN FIELD.
584400210712      *
584500210712     C     @TSTQ         IFEQ      '?'
584600210712     C                   MOVEL     BBCSSN        DDBENN
584700210712     C                   END
584800210712      *
584900210712      ** ELSE IF A COUNTERPARTY NOSTRO
585000210712      *
585100210712     C                   ELSE
585200210712      *
585300210712      ** UPDATE OUTPUT FIELD
585400210712      *
585500210712     C                   MOVEL     AWCPNC        FLBENN
585600210712      *
585700210712      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
585800210712      **   INTO SCREEN FIELD.
585900210712      *
586000210712     C     @TSTQ         IFEQ      '?'
586100210712     C                   MOVE      *BLANKS       DDBENN
586200210712     C                   MOVEL     AWCPNC        DDBENN
586300210712     C                   END
586400210712      *
586500210712     C                   END
586600210712      *
586700210712     C     EVBENN        ENDSR
586800210712     C********************************************************************
586900210712      /EJECT
587000210712     C*****************************************************************
587100210712     C*                                                               *
587200210712     C* VLBENA - VALIDATE BENEFICIARY A/C WITH LINE                   *
587300210712     C*                                                               *
587400210712     C*****************************************************************
587500210712     C     VLBENA        BEGSR
587600210712      *
587700210712     C                   MOVE      DDBENA        L#XIBA
587800210712      *
587900210712      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN BENEFICIARY
588000210712      *
588100210712     C     DDBENN        IFEQ      *BLANKS
588200210712     C                   ADD       1             Idx
588300210712     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
588400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0999'
588500210712     C                   MOVE      'N'           DDBennOK
588600210712     C                   GOTO      EVBENA
588700210712     C                   END
588800210712      *
588900210712      * Call Account Line Validation object
589000210712      *
589100210712      * Set up parameters
589200210712      *
589300210712     C                   MOVEL     *BLANKS       W0RTN
589400210712     C                   CLEAR                   I#PARM
589500210712     C                   MOVEL     'BENF '       I#VFLD
589600210712     C                   MOVEL     'PAY'         I#PR
589700210712     C                   MOVEL     'X'           I#PRTT
589800210712     C                   MOVEL     DDBENN        I#PRTY
589900210712     C                   MOVEL     E#PCCY        I#PCCY
590000210712     C                   MOVEL     E#RCCY        I#RCCY
590100210712     C                   MOVEL     DDBENA        I#ACLN
590200210712     C                   MOVEL     DDPSTM        I#PSTM
590300210712     C                   MOVEL     DDRSTM        I#RSTM
590400210712     C     DDPOCN        IFNE      *BLANKS
590500210712                                                                                              CSW203
590600210712      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
590700210712                                                                                              CSW203
590800210712     C                   IF        CSW203 = 'Y'                                               CSW203
590900210712     C                   EVAL      I#MTYP = '103'                                             CSW203
591000210712     C                   ELSE                                                                 CSW203
591100210712     C                   MOVEL     '100'         I#MTYP
591200210712     C                   ENDIF                                                                CSW203
591300210712     C                   ELSE
591400210712     C                   MOVEL     '202'         I#MTYP
591500210712     C                   ENDIF
591600210712      *
591700210712      * Set up receive account information
591800210712      *
591900210712     C     DDRONS        IFNE      *BLANKS
592000210712     C                   SELECT
592100210712     C     DDROBR        WHENNE    *BLANKS
592200210712     C     DDRONS        CAT       DDROBR        I#RCAC
592300210712     C     DDRONS        WHENNE    *BLANKS
592400210712     C                   MOVEL     DDRONS        I#RCAC
592500210712     C                   ENDSL
592600210712     C                   ENDIF
592700210712      *
592800210712      * Set up Pay account information
592900210712      *
593000210712     C     DDPONS        IFNE      *BLANKS
593100210712     C                   SELECT
593200210712     C     DDPOBR        WHENNE    *BLANKS
593300210712     C     DDPONS        CAT       DDPOBR        I#PYAC
593400210712     C     DDPONS        WHENNE    *BLANKS
593500210712     C                   MOVEL     DDPONS        I#PYAC
593600210712     C                   ENDSL
593700210712     C                   ENDIF
593800210712      *
593900210712      * If extra message and Rec Corr. then set 5354 field
594000210712      *
594100210712     C     DDRVNO        IFNE      *BLANKS
594200210712     C     DDRCRN        ANDNE     *BLANKS
594300210712     C                   MOVEL     'Y'           I#5354
594400210712     C                   ENDIF
594500210712      *
594600210712      * Transaction Type
594700210712      *
594800210712     C                   MOVEL     ##TTYP        I#TTYP
594900210712      *
595000210712     C                   CLEAR                   O#PARM
595100210712     C                   CLEAR                   E#PARM
595200210712      *
595300210712      * Send messages to correct calling process
595400210712      *
595500210712     C                   SELECT
595600210712     C     ##CALP        WHENEQ    'FXDL'
595700210712     C                   MOVEL     'ME9940'      E#CPGM
595800210712     C                   MOVEL     'DL'          I#MMOD
595900210712     C     ##CALP        WHENEQ    'LDNI'
596000210712     C                   MOVEL     'ME9940'      E#CPGM
596100210712     C                   MOVEL     'DL'          I#MMOD
596200210712     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
596300210712     C     ##CALP        OREQ      'MAPY'                                                     239587
596400210712     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
596500210712     C                   MOVEL     'LE'          I#MMOD                                       CAP068
596600210712     C     ##CALP        WHENEQ    'SSI '
596700210712     C                   MOVEL     'SD0401R'     E#CPGM
596800210712     C                   MOVEL     'AT'          I#MMOD
596900210712     C                   OTHER
597000210712     C                   MOVEL     'ME9940'      E#CPGM
597100210712     C                   ENDSL
597200210712     C                   MOVEL     'MEC0018'     E#MSGD
597300210712     C                   MOVEL     'MEMSG'       E#MSGF
597400210712      *
597500210712     C                   CALL      'ME9940'
597600210712     C                   PARM                    W0RTN             7
597700210712     C                   PARM                    I#PARM                         I Input Parms
597800210712     C                   PARM                    O#PARM                         O Output Parms
597900210712     C                   PARM                    E#PARM                         E Error Inform
598000210712     C                   PARM                    Z#PARM          256            B User Defined
598100210712      *
598200210712      * A/c line modified
598300210712     C                   MOVEL     O#ACLN        DDBENA
598400210712      *
598500210712      ** Subtract 1 from error array index
598600210712     C                   SUB       1             E#INDX
598700210712      *
598800210712      * On return if errors copy into error array
598900210712      *
599000210712     C     E#ERRM        IFNE      *BLANKS
599100210712     C     1             DO        E#INDX        Q#                5 0
599200210712     C                   ADD       1             Idx
599300210712     C                   EVAL      FldNameArr(Idx) = 'DDBENA'
599400210712     C                   MOVEL     'ESM0'        WMessageID
599500210712     C                   MOVE      O#E(Q#)       WMessageID
599600210712     C                   EVAL      MsgIDArr(Idx) = WMessageID
599700210712     C                   ENDDO
599800210712     C                   MOVEL     'N'           DDBenaOK
599900210712     C                   ENDIF
600000210712      *
600100210712      * UPDATE OUTPUT FIELD
600200210712      *
600300210712     C                   MOVEL     DDBENA        FLBENA
600400210712      *
600500210712     C     EVBENA        ENDSR
600600210712     C********************************************************************
600700210712      /EJECT
600800210712     C*****************************************************************
600900210712     C*                                                               *
601000210712     C* VLPNFD - CROSS VALIDATE NUMEROUS PAYMENT FIELDS               *
601100210712     C*                                                               *
601200210712     C*****************************************************************
601300210712     C     VLPNFD        BEGSR
601400210712      *
601500210712      ** IF BENEFICIARY IS A NON-BANK
601600210712      ** ORDERING CUSTOMER IS MANDATORY
601700210712      *
601800210712     C     @BBNBI        IFEQ      'N'
601900210712     C     DDPOCN        ANDEQ     *BLANKS
602000210712     C     DDPSTM        ANDEQ     '08'                                                       197865
602100210712     C                   ADD       1             Idx
602200210712     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
602300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0945'
602400210712     C                   MOVE      'N'           DDPocnOK
602500210712     C                   END
602600210712      *
602700210712      ** IF BENEFICIARY IS A BANK MAY NOT ENTER BOTH ORDERING
602800210712      ** CUSTOMER AND ORDERING BANK
602900210712      *
603000210712     C     @BBNBI        IFEQ      'Y'
603100210712     C     DDPOBN        ANDNE     *BLANKS
603200210712     C     DDPOCN        ANDNE     *BLANKS
603300210712     C                   ADD       1             Idx
603400210712     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
603500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0951'
603600210712     C                   MOVE      'N'           DDPobnOK
603700210712     C                   END
603800210712     C/COPY WNCPYSRC,ZASETNVC11
603900210712      *
604000210712      ** RECEIVER (OF MT100) CAN'T BE THE SAME AS:
604100210712      ** BICN OF BRANCH OF OUR NOSTRO, OUR NOSTRO, RECEIVERS CORRESPONDENT,
604200210712      ** INTERMEDIARY OR A/C WITH BANK
604300210712      *
604400210712     C     FLRVNO        IFNE      *BLANKS
604500210712     C     FLRVNO        IFEQ      @PBICN
604600210712     C     FLRVNO        OREQ      @PNOCN
604700210712     C     FLRVNO        OREQ      FLRCRN
604800210712     C     FLRVNO        OREQ      FLPIBN
604900210712     C     FLRVNO        OREQ      FLAWBN
605000210712     C                   ADD       1             Idx
605100210712     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
605200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0954'
605300210712     C                   MOVE      'N'           DDRvnoOK
605400210712     C                   END
605500210712     C                   END
605600210712     C/COPY WNCPYSRC,ZASETNVC12
605700210712      *
605800210712      ** RECEIVER'S CORRESPONDANT CAN'T BE THE SAME AS:
605900210712      ** BICN OF BRANCH OF OUR NOSTRO, OUR NOSTRO, RECEIVER OF MT100,
606000210712      ** INTERMEDIARY OR A/C WITH BANK
606100210712      *
606200210712     C     FLRCRN        IFNE      *BLANKS
606300210712     C     FLRCRN        IFEQ      @PBICN
606400210712     C     FLRCRN        OREQ      @PNOCN
606500210712     C     FLRCRN        OREQ      FLRVNO
606600210712     C     FLRCRN        OREQ      FLPIBN
606700210712     C     FLRCRN        OREQ      FLAWBN
606800210712     C                   ADD       1             Idx
606900210712     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
607000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0959'
607100210712     C                   MOVE      'N'           DDRcrnOK
607200210712     C                   END
607300210712     C                   END
607400210712     C/COPY WNCPYSRC,ZASETNVC13
607500210712      *
607600210712      ** INTERMEDIARY BANK CAN'T BE THE SAME AS:
607700210712      ** BICN OF BRANCH OF OUR NOSTRO, RECEIVER OF MT100, RECEIVERS
607800210712      ** CORRESPONDENT OR BENEFICIARY
607900210712      *
608000210712     C     FLPIBN        IFNE      *BLANKS
608100210712     C     FLPIBN        IFEQ      @PBICN
608200210712     C     FLPIBN        OREQ      FLRVNO
608300210712     C     FLPIBN        OREQ      FLRCRN
608400210712     C     FLPIBN        OREQ      FLBENN
608500210712     C                   ADD       1             Idx
608600210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
608700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0964'
608800210712     C                   MOVE      'N'           DDPibnOK
608900210712     C                   END
609000210712     C                   END
609100210712      *
609200210712      ** IF Account With Bank not entered, Intermediary Bank should
609300210712      ** also be blank
609400210712      *
609500210712     C     FLPIBN        IFNE      *BLANKS
609600210712     C     FLAWBN        ANDEQ     *BLANKS
609700210712     C                   ADD       1             Idx
609800210712     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
609900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0979'
610000210712     C                   MOVE      'N'           DDPibnOK
610100210712     C                   END
610200210712     C/COPY WNCPYSRC,ZASETNVC14
610300210712      *
610400210712      ** ACCOUNT WITH BANK
610500210712      *
610600210712     C     FLAWBN        IFNE      *BLANKS
610700210712     C     FLAWBN        IFEQ      @PBICN
610800210712     C     FLAWBN        OREQ      FLRVNO
610900210712     C     FLAWBN        OREQ      FLRCRN
611000210712     C*****FLAWBN********OREQ      FLBENN                                       CAP004
611100210712     C                   ADD       1             Idx
611200210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
611300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0972'
611400210712     C                   MOVE      'N'           DDAwbnOK
611500210712     C                   END
611600210712     C                   END
611700210712     C/COPY WNCPYSRC,ZASETNVC15
611800210712      *
611900210712      ** BENEFICIARY CAN'T BE THE PAY INTERMEDIARY BANK
612000210712      ***OR*THE*ACCOUNT*WITH*BANK**********************                         CAP004
612100210712      *
612200210712     C     FLBENN        IFNE      *BLANKS
612300210712     C     FLBENN        IFEQ      FLPIBN
612400210712     C*****FLBENN********OREQ      FLAWBN                                       CAP004
612500210712     C                   ADD       1             Idx
612600210712     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
612700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0980'
612800210712     C                   MOVE      'N'           DDBennOK
612900210712     C                   END
613000210712     C                   END
613100210712      *
613200210712     C                   ENDSR
613300210712     C********************************************************************
613400210712      /EJECT
613500210712     C*****************************************************************
613600210712     C*                                                               *
613700210712     C* VLDTPI - VALIDATE DETAILS OF PAYMENT                          *
613800210712     C*                                                               *
613900210712     C*****************************************************************
614000210712     C     VLDTPI        BEGSR
614100210712      *
614200210712      ** MUST BE BLANK IF BENEFICIARY IS A BANK
614300210712      *
614400210712     C     @BBNBI        IFEQ      'Y'
614500210712     C     ##PPAY        ANDNE     'Y'                                                      AR641619
614600210712     C     DDDTP1        IFNE      *BLANKS
614700210712     C     DDDTP2        ORNE      *BLANKS
614800210712     C     DDDTP3        ORNE      *BLANKS
614900210712     C     DDDTP4        ORNE      *BLANKS
615000210712     C                   ADD       1             Idx
615100210712     C                   EVAL      FldNameArr(Idx) = 'DDDTP1'
615200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0987'
615300210712     C                   MOVE      'N'           DDDtp1OK
615400210712     C                   MOVE      'N'           DDDtp2OK
615500210712     C                   MOVE      'N'           DDDtp3OK
615600210712     C                   MOVE      'N'           DDDtp4OK
615700210712     C                   END
615800210712     C                   END
615900210712      *
616000210712      ** UPDATE OUTPUT FIELDS
616100210712      *
616200210712     C                   MOVEL     DDDTP1        FLDTP1
616300210712     C                   MOVEL     DDDTP2        FLDTP2
616400210712     C                   MOVEL     DDDTP3        FLDTP3
616500210712     C                   MOVEL     DDDTP4        FLDTP4
616600210712      *
616700210712     C                   ENDSR
616800210712     C********************************************************************
616900210712      /EJECT
617000210712     C*****************************************************************
617100210712     C*                                                               *
617200210712     C* VLDCHG - VALIDATE DETAILS OF CHARGES                          *
617300210712     C*                                                               *
617400210712     C*****************************************************************
617500210712     C     VLDCHG        BEGSR
617600210712      *                                                                                      BUG4511
617700210712      ** Set up ordering bank indicator                                                      BUG4511
617800210712     C                   If        DDPOBN <> *Blank and                                      BUG4511
617900210712     C                             DDPOCN = *Blank                                           BUG4511
618000210712     C                   Eval      @OBNBI = 'Y'                                              BUG4511
618100210712     C                   EndIf                                                               BUG4511
618200210712      *
618300210712      ***MUST*BE*BLANK*IF*NO*MT100*MESSAGE*IS*TO*BE*PRODUCED***********                     AR892347
618400210712      ***(BOTH*PAY*ORDERING*CUSTOMER*AND*BENEFICIARY*ARE*BANKS)********                     AR892347
618500210712      ** MUST BE BLANK IF NO MT103 MESSAGE IS TO BE PRODUCED                                AR892347
618600210712      ** (BOTH PAY ORDERING BANK DEFINED AND BEFICIARY IS A BANK)                           AR892347
618700210712      *
618800210712     C     DDDCHG        IFNE      *BLANKS
618900210712     C     DDPOBN        ANDNE     *BLANK                                                   AR892347
619000210712     C*****@OBNBI        ANDEQ     'Y'                                                      AR892347
619100210712     C     @BBNBI        ANDEQ     'Y'
619200210712     C                   ADD       1             Idx
619300210712     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'
619400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0920'
619500210712     C                   MOVE      'N'           DDDchgOK
619600210712     C                   END
619700210712                                                                                              219241
619800210712      ** If CFT013 is installed, use the default value from the                               219241
619900210712      ** Message Management ICD                                                               219241
620000210712                                                                                              219241
620100210712     C                   IF        CFT013 = 'Y'                                               219241
620200210712     C                             AND DDDCHG =  *BLANKS                                      219241
620300210712     C                             AND DDPOBN = *BLANK                                      AR892347
620400210712     C                             AND DDPOCN <>*BLANK                                      AR892347
620500210712     C**********                   AND @OBNBI <> 'Y'                                 219241 AR892347
620600210712     C                             OR CFT013 = 'Y'                                            219241
620700210712     C                             AND DDDCHG =  *BLANKS                                      219241
620800210712     C                             AND @BBNBI <> 'Y'                                          219241
620900210712     C                             AND DDBennOK <> 'N'                                      AR892347
621000210712     C                   IF        DDPSTM =  '01'                                             219241
621100210712     C                             OR DDPSTM = '07'                                           219241
621200210712     C                             OR DDPSTM = '08'                                           219241
621300210712     C                   EVAL      DDDCHG = ENDCHG                                            219241
621400210712     C                   ENDIF                                                                219241
621500210712     C                   ENDIF                                                                219241
621600210712      *
621700210712      ** MUST BE BEN,CLM OR OUR
621800210712      *
621900210712     C     DDDCHG        IFNE      *BLANKS
622000210712     C*****@OBNBI        ANDNE     'Y'                                                      AR892347
622100210712     C     DDPOBN        ANDEQ     *BLANK                                                   AR892347
622200210712     C     DDPOCN        ANDNE     *BLANK                                                   AR892347
622300210712     C     DDDCHG        ORNE      *BLANKS
622400210712     C     @BBNBI        ANDNE     'Y'
622500210712     C     DDBennOK      ANDNE     'N'                                                      AR892347
622600210712     C     DDDCHG        IFNE      'BEN'
622700210712     C     DDDCHG        ANDNE     'OUR'
622800210712     C     DDDCHG        ANDNE     'CLM'
622900210712     C     DDDCHG        ANDNE     'SHA'                                                      214110
623000210712     C     CFT013        ANDEQ     'N'                                                        219241
623100210712     C     DDDCHG        ORNE      'BEN'                                                      219241
623200210712     C     DDDCHG        ANDNE     'OUR'                                                      219241
623300210712     C     DDDCHG        ANDNE     'SHA'                                                      219241
623400210712     C     CFT013        ANDEQ     'Y'                                                        219241
623500210712     C     DDDCHG        OREQ      '?  '                                                      214110
623600210712     C                   ADD       1             Idx
623700210712     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'
623800210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0961'                                  214110
623900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0986'                                  214110
624000210712     C                   MOVE      'N'           DDDchgOK
624100210712     C                   END
624200210712     C                   END
624300210712      *
624400210712      ** CLM ONLY ALLOWED IF THE BENEFICIARY IS A BANK
624500210712      *
624600210712     C     DDDCHG        IFEQ      'CLM'
624700210712     C     @BBNBI        ANDNE     'Y'
624800210712     C                   ADD       1             Idx
624900210712     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'
625000210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0986'                                  214110
625100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0961'                                  214110
625200210712     C                   MOVE      'N'           DDDchgOK
625300210712     C                   END
625400210712      *
625500210712      ** UPDATE OUTPUT FIELD
625600210712      *
625700210712     C                   MOVEL     DDDCHG        FLDCHG
625800210712      *
625900210712     C                   ENDSR
626000210712     C********************************************************************
626100210712      /EJECT
626200210712     C*****************************************************************
626300210712     C*                                                               *
626400210712     C* VLIC72 - VALIDATE INCLUDE 'IN' CURRENCY IN FIELD 72           *
626500210712     C*                                                               *
626600210712     C*****************************************************************
626700210712     C     VLIC72        BEGSR
626800210712      *
626900210712      **  Pay settlement ccy is Euros or
627000210712      **  pay settlement ccy is blank but transaction ccy is Euros
627100210712      *
627200210712     C     DDPSCY        IFEQ      BKEURO
627300210712     C     DDPSCY        OREQ      *BLANKS
627400210712     C     ##PCCY        ANDEQ     BKEURO
627500210712      *
627600210712      **  Pay settlement method is 01 or 08
627700210712      *
627800210712     C     DDPSTM        IFEQ      '01'
627900210712     C     DDPSTM        OREQ      '08'
628000210712      *
628100210712      **  Access Currency Details
628200210712      *
628300210712     C                   CALLB     'AOCURRR0'
628400210712     C                   PARM      *BLANKS       @RTCD
628500210712     C                   PARM      '*KEY    '    @OPTN
628600210712     C                   PARM      DDIC72        @CURR
628700210712     C     SDCURR        PARM      SDCURR        DSSDY
628800210712      *
628900210712      **  'In' ccy in field 72 is invalid
629000210712      **  or not a dealing currency
629100210712      *
629200210712     C     @RTCD         IFNE      *BLANKS
629300210712     C     A6DLCI        ORNE      'Y'
629400210712     C                   ADD       1             Idx
629500210712     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
629600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0849'
629700210712     C                   MOVE      'N'           DDIc72OK
629800210712     C                   ELSE
629900210712
630000210712     C                   MOVEL     A6CYCD        DDIC72
630100210712
630200210712      * If transaction pay currency is Euros
630300210712
630400210712     C     ##PCCY        IFEQ      BKEURO
630500210712      *
630600210712      ** Currency in field 72 is not an 'In' currency
630700210712      *
630800210712     C     A6INCY        IFNE      'Y'
630900210712     C                   ADD       1             Idx
631000210712     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
631100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0856'
631200210712     C                   MOVE      'N'           DDIc72OK
631300210712     C                   ENDIF
631400210712      *
631500210712     C                   ELSE
631600210712      *
631700210712      **  Transaction currency is an 'In' currency but the currency
631800210712      **  entered is not equal to the transaction pay currency
631900210712      *
632000210712     C     ##PCCY        IFNE      DDIC72
632100210712     C                   ADD       1             Idx
632200210712     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
632300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0858'
632400210712     C                   MOVE      'N'           DDIc72OK
632500210712     C                   ENDIF
632600210712      *
632700210712     C                   ENDIF
632800210712      *
632900210712     C                   ENDIF
633000210712      *
633100210712     C                   ELSE
633200210712      *
633300210712      **  Pay settlement method is not 01 or 08
633400210712      *
633500210712     C                   ADD       1             Idx
633600210712     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
633700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0855'
633800210712     C                   MOVE      'N'           DDIc72OK
633900210712     C                   ENDIF
634000210712      *
634100210712     C                   ELSE
634200210712      *
634300210712      **  Transaction ccy is Euro but settlement ccy is not blank or
634400210712      **  settlement ccy is not Euro
634500210712      *
634600210712     C                   ADD       1             Idx
634700210712     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
634800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0857'
634900210712     C                   MOVE      'N'           DDIc72OK
635000210712     C                   ENDIF
635100210712
635200210712     C                   ENDSR
635300210712     C********************************************************************
635400210712      /EJECT
635500210712     C*****************************************************************
635600210712     C*                                                               *
635700210712     C* VLBTBI - VALIDATE BANK TO BANK INFO                           *
635800210712     C*                                                               *
635900210712     C*****************************************************************
636000210712     C     VLBTBI        BEGSR
636100210712      *
636200210712     C                   Z-ADD     *ZERO         X                 1 0
636300210712      *
636400210712      ** MUST BE BLANK IF SETTLEMENT TYPE IS '00'
636500210712      *
636600210712     C     ##PPAY        IFNE      'Y'                                                      AR641619
636700210712     C     DDPSTM        IFEQ      '00'
636800210712      *
636900210712     C     DDBTB1        IFNE      *BLANKS
637000210712     C     DDBTB2        ORNE      *BLANKS
637100210712     C     DDBTB3        ORNE      *BLANKS
637200210712     C     DDBTB4        ORNE      *BLANKS
637300210712     C     DDBTB5        ORNE      *BLANKS
637400210712     C     DDBTB6        ORNE      *BLANKS
637500210712     C                   ADD       1             Idx
637600210712     C                   EVAL      FldNameArr(Idx) = 'DDBTB1'
637700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0988'
637800210712     C                   MOVE      'N'           DDBtb1OK
637900210712     C                   MOVE      'N'           DDBtb2OK
638000210712     C                   MOVE      'N'           DDBtb3OK
638100210712     C                   MOVE      'N'           DDBtb4OK
638200210712     C                   MOVE      'N'           DDBtb5OK
638300210712     C                   MOVE      'N'           DDBtb6OK
638400210712     C                   END
638500210712     C                   END
638600210712      *
638700210712      * Call Bank to Bank Validation object
638800210712      *
638900210712      * Set up parameters
639000210712      *
639100210712     C                   MOVEL     *BLANKS       W0RTN
639200210712     C                   CLEAR                   I#PARM
639300210712      *
639400210712      * Set up Control fields
639500210712     C                   MOVEL     ':72: '       I#VFLD
639600210712     C                   MOVEL     'PAY'         I#PR
639700210712      *
639800210712      * Set up Currency fields
639900210712     C                   MOVEL     E#PCCY        I#PCCY
640000210712     C                   MOVEL     E#RCCY        I#RCCY
640100210712      *
640200210712      * Set up Intermediary
640300210712     C     DDPIBN        IFNE      *BLANKS
640400210712     C                   MOVEL     'X'           I#INBT
640500210712     C                   MOVEL     DDPIBN        I#INBK
640600210712     C                   ENDIF
640700210712      *
640800210712      * Set up Account with Bank
640900210712     C     DDAWBN        IFNE      *BLANKS
641000210712     C                   MOVEL     'X'           I#AWBT
641100210712     C                   MOVEL     DDAWBN        I#AWBK
641200210712     C                   ENDIF
641300210712      *
641400210712      * Set up Beneficiary
641500210712     C     DDBENN        IFNE      *BLANKS
641600210712     C                   MOVEL     'X'           I#BENT
641700210712     C                   MOVEL     DDBENN        I#BENF
641800210712     C                   ENDIF
641900210712     C/COPY WNCPYSRC,ZASETINVC7
642000210712      *
642100210712      * Move in Bank to Bank Information
642200210712     C                   MOVEL     DDBTB1        I#BTB1
642300210712     C                   MOVEL     DDBTB2        I#BTB2
642400210712     C                   MOVEL     DDBTB3        I#BTB3
642500210712     C                   MOVEL     DDBTB4        I#BTB4
642600210712     C                   MOVEL     DDBTB5        I#BTB5
642700210712     C                   MOVEL     DDBTB6        I#BTB6
642800210712     C                   MOVEL     DDPSTM        I#PSTM
642900210712     C                   MOVEL     DDRSTM        I#RSTM
643000210712     C/COPY WNCPYSRC,ZASETNVC27
643100210712      *
643200210712      * Set up receive account information
643300210712     C     DDRONS        IFNE      *BLANKS
643400210712     C                   SELECT
643500210712     C     DDROBR        WHENNE    *BLANKS
643600210712     C     DDRONS        CAT       DDROBR        I#RCAC
643700210712     C     DDRONS        WHENNE    *BLANKS
643800210712     C                   MOVEL     DDRONS        I#RCAC
643900210712     C                   ENDSL
644000210712     C                   ENDIF
644100210712      *
644200210712      * Set up Pay account information
644300210712     C     DDPONS        IFNE      *BLANKS
644400210712     C                   SELECT
644500210712     C     DDPOBR        WHENNE    *BLANKS
644600210712     C     DDPONS        CAT       DDPOBR        I#PYAC
644700210712     C     DDPONS        WHENNE    *BLANKS
644800210712     C                   MOVEL     DDPONS        I#PYAC
644900210712     C                   ENDSL
645000210712     C                   ENDIF
645100210712      *
645200210712      * If extra message and Rec Corr. then set 5354 field
645300210712     C     DDRVNO        IFNE      *BLANKS
645400210712     C     DDRCRN        ANDNE     *BLANKS
645500210712     C                   MOVEL     'Y'           I#5354
645600210712     C                   ENDIF
645700210712      *
645800210712      * Set up message type
645900210712     C     DDPOCN        IFNE      *BLANKS
646000210712                                                                                              CSW203
646100210712      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
646200210712                                                                                              CSW203
646300210712     C                   IF        CSW203 = 'Y'                                               CSW203
646400210712     C                   EVAL      I#MTYP = '103'                                             CSW203
646500210712     C                   ELSE                                                                 CSW203
646600210712     C                   MOVEL     '100'         I#MTYP
646700210712     C                   ENDIF                                                                CSW203
646800210712     C                   ELSE
646900210712     C                   MOVEL     '202'         I#MTYP
647000210712     C                   ENDIF
647100210712      *
647200210712      * Transaction Type
647300210712     C                   MOVEL     ##TTYP        I#TTYP
647400210712      *
647500210712     C                   CLEAR                   O#PARM
647600210712     C                   CLEAR                   E#PARM
647700210712      *
647800210712      * Send messages to correct calling process
647900210712     C                   SELECT
648000210712     C     ##CALP        WHENEQ    'FXDL'
648100210712     C                   MOVEL     'ME9950'      E#CPGM
648200210712     C                   MOVEL     'DL'          I#MMOD
648300210712     C     ##CALP        WHENEQ    'LDNI'
648400210712     C                   MOVEL     'ME9950'      E#CPGM
648500210712     C                   MOVEL     'DL'          I#MMOD
648600210712     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
648700210712     C     ##CALP        OREQ      'MAPY'                                                     239587
648800210712     C                   MOVEL     'ME9950'      E#CPGM                                       CAP068
648900210712     C                   MOVEL     'LE'          I#MMOD                                       CAP068
649000210712     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
649100210712     C     ##CALP        WHENEQ    'FRA '                                       CAP003
649200210712     C     CSW005        ANDEQ     'Y'
649300210712     C     ##CALP        OREQ      'SIRS'                                       164570
649400210712     C     CSW005        ANDEQ     'Y'                                          164570
649500210712     C     ##CALP        OREQ      'CIRS'                                       CAP004
649600210712     C     CSW005        ANDEQ     'Y'                                          CAP004
649700210712     C*****##CALP        OREQ      'FRAS'                                       CAP003
649800210712     C     ##CALP        OREQ      'FRA '                                       CAP003
649900210712     C     CSW011        ANDEQ     'Y'
650000210712     C*****##CALP        OREQ      'CIRS'                                CAP004 164570
650100210712     C*****CSW011        ANDEQ     'Y'                                   CAP004 164570
650200210712     C     ##CALP        OREQ      'CXSV'                                                     CIR003
650300210712     C     CSW005        ANDEQ     'Y'                                                        CIR003
650400210712     C     CIR003        ANDEQ     'Y'                                                        CIR003
650500210712     C     ##CALP        OREQ      'CXSM'                                                     CIR003
650600210712     C     CSW005        ANDEQ     'Y'                                                        CIR003
650700210712     C     CIR003        ANDEQ     'Y'                                                        CIR003
650800210712     C                   MOVEL     'ME9950'      E#CPGM
650900210712     C                   MOVEL     'DL'          I#MMOD
651000210712     C     ##CALP        WHENEQ    'SSI '
651100210712     C                   MOVEL     'SD0401R'     E#CPGM
651200210712     C                   MOVEL     'AT'          I#MMOD
651300210712     C                   OTHER
651400210712     C                   MOVEL     'ME9950'      E#CPGM
651500210712     C                   ENDSL
651600210712      *
651700210712      * Set standard message text
651800210712     C                   MOVEL     'MEC0114'     E#MSGD
651900210712     C                   MOVEL     'MEMSG'       E#MSGF
652000210712     C/COPY WNCPYSRC,ZASETNVC16
652100210712      *
652200210712     C                   CALL      'ME9950'
652300210712     C                   PARM                    W0RTN             7
652400210712     C                   PARM                    I#PARM                         I Input Parms
652500210712     C                   PARM                    O#PARM                         O Output Parms
652600210712     C                   PARM                    E#PARM                         E Error Inform
652700210712     C                   PARM                    Z#PARM          256            B User Defined
652800210712     C/COPY WNCPYSRC,ZASETNVC17
652900210712      *
653000210712      * On return if errors copy into error array
653100210712      *
653200210712     C                   MOVEL     O#BTB1        DDBTB1
653300210712     C                   MOVEL     O#BTB2        DDBTB2
653400210712     C                   MOVEL     O#BTB3        DDBTB3
653500210712     C                   MOVEL     O#BTB4        DDBTB4
653600210712     C                   MOVEL     O#BTB5        DDBTB5
653700210712     C                   MOVEL     O#BTB6        DDBTB6
653800210712     C/COPY WNCPYSRC,ZASETNVC18
653900210712      *
654000210712      ** Subtract 1 from error array index
654100210712     C                   SUB       1             E#INDX
654200210712      *
654300210712     C     E#ERRM        IFNE      *BLANKS
654400210712     C     1             DO        E#INDX        Q#                5 0
654500210712     C                   ADD       1             Idx
654600210712     C                   EVAL      FldNameArr(Idx) = 'DDBTB1'
654700210712     C                   MOVEL     'ESM0'        WMessageID
654800210712     C                   MOVE      O#E(Q#)       WMessageID
654900210712     C                   EVAL      MsgIDArr(Idx) = WMessageID
655000210712     C     O#E(Q#)       IFEQ      '994'                                                    MD046115
655100210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0105'                                MD046115
655200210712     C                   ENDIF                                                              MD046115
655300210712     C     O#E(Q#)       IFEQ      '302'                                                    MD046115
655400210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0302'                                MD046115
655500210712     C                   ENDIF                                                              MD046115
655600210712     C     O#E(Q#)       IFEQ      '103'                                                    MD046115
655700210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0103'                                MD046115
655800210712     C                   ENDIF                                                              MD046115
655900210712     C     O#E(Q#)       IFEQ      '104'                                                    MD046115
656000210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0104'                                MD046115
656100210712     C                   ENDIF                                                              MD046115
656200210712     C     O#E(Q#)       IFEQ      '897'                                                    MD046115
656300210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0116'                                MD046115
656400210712     C                   ENDIF                                                              MD046115
656500210712     C     O#E(Q#)       IFEQ      '893'                                                    MD046115
656600210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0108'                                MD046115
656700210712     C                   ENDIF                                                              MD046115
656800210712     C     O#E(Q#)       IFEQ      '895'                                                    MD046115
656900210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0107'                                MD046115
657000210712     C                   ENDIF                                                              MD046115
657100210712     C                   ENDDO
657200210712     C                   MOVE      'N'           DDBtb1OK
657300210712     C                   MOVE      'N'           DDBtb2OK
657400210712     C                   MOVE      'N'           DDBtb3OK
657500210712     C                   MOVE      'N'           DDBtb4OK
657600210712     C                   MOVE      'N'           DDBtb5OK
657700210712     C                   MOVE      'N'           DDBtb6OK
657800210712     C                   ENDIF
657900210712     C                   ENDIF                                                              AR641619
658000210712      *
658100210712      ** UPDATE OUTPUT FIELDS
658200210712      *
658300210712     C                   MOVEL     DDBTB1        FLBTB1
658400210712     C                   MOVEL     DDBTB2        FLBTB2
658500210712     C                   MOVEL     DDBTB3        FLBTB3
658600210712     C                   MOVEL     DDBTB4        FLBTB4
658700210712     C                   MOVEL     DDBTB5        FLBTB5
658800210712     C                   MOVEL     DDBTB6        FLBTB6
658900210712      *
659000210712     C                   ENDSR
659100210712     C********************************************************************
659200210712      /EJECT                                                                                  CDL094
659300210712     C*****************************************************************                       CDL094
659400210712     C*                                                               *                       CDL094
659500210712     C* VLRBTBI - VALIDATE RECEIVE BANK TO BANK INFO                  *                       CDL094
659600210712     C*                                                               *                       CDL094
659700210712     C*****************************************************************                       CDL094
659800210712     C     VLRBTBI       BEGSR                                                                CDL094
659900210712      *                                                                                       CDL094
660000210712     C                   Z-ADD     *ZERO         X                 1 0                        CDL094
660100210712      *                                                                                       CDL094
660200210712      ** MUST BE BLANK IF SETTLEMENT TYPE IS '00'                                             CDL094
660300210712      *                                                                                       CDL094
660400210712     C     ##PREC        IFNE      'Y'                                                        CDL094
660500210712     C     DDRSTM        IFEQ      '00'                                                       CDL094
660600210712     C     DDRSTM        OREQ      '  '                                                       CDL094
660700210712      *                                                                                       CDL094
660800210712     C     DDRBB1        IFNE      *BLANKS                                                    CDL094
660900210712     C     DDRBB2        ORNE      *BLANKS                                                    CDL094
661000210712     C     DDRBB3        ORNE      *BLANKS                                                    CDL094
661100210712     C     DDRBB4        ORNE      *BLANKS                                                    CDL094
661200210712     C     DDRBB5        ORNE      *BLANKS                                                    CDL094
661300210712     C     DDRBB6        ORNE      *BLANKS                                                    CDL094
661400210712     C                   ADD       1             Idx                                          CDL094
661500210712     C                   EVAL      FldNameArr(Idx) = 'DDRBB1'                                 CDL094
661600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0988'                                  CDL094
661700210712     C                   MOVE      'N'           DDRbb1OK                                     CDL094
661800210712     C                   MOVE      'N'           DDRbb2OK                                     CDL094
661900210712     C                   MOVE      'N'           DDRbb3OK                                     CDL094
662000210712     C                   MOVE      'N'           DDRbb4OK                                     CDL094
662100210712     C                   MOVE      'N'           DDRbb5OK                                     CDL094
662200210712     C                   MOVE      'N'           DDRbb6OK                                     CDL094
662300210712     C                   END                                                                  CDL094
662400210712     C                   END                                                                  CDL094
662500210712      *                                                                                       CDL094
662600210712      * Call Bank to Bank Validation object                                                   CDL094
662700210712      *                                                                                       CDL094
662800210712      * Set up parameters                                                                     CDL094
662900210712      *                                                                                       CDL094
663000210712     C                   MOVEL     *BLANKS       W0RTN                                        CDL094
663100210712     C                   CLEAR                   I#PARM                                       CDL094
663200210712      *                                                                                       CDL094
663300210712      * Set up Control fields                                                                 CDL094
663400210712     C                   MOVEL     ':72: '       I#VFLD                                       CDL094
663500210712     C                   MOVEL     'PAY'         I#PR                                         CDL094
663600210712      *                                                                                       CDL094
663700210712      * Set up Currency fields                                                                CDL094
663800210712     C                   MOVEL     E#RCCY        I#PCCY                                       CDL094
663900210712     C                   MOVEL     E#PCCY        I#RCCY                                       CDL094
664000210712      *                                                                                       CDL094
664100210712      * Set up Intermediary                                                                   CDL094
664200210712     C     DDRIBN        IFNE      *BLANKS                                                    CDL094
664300210712     C                   MOVEL     'X'           I#INBT                                       CDL094
664400210712     C                   MOVEL     DDRIBN        I#INBK                                       CDL094
664500210712     C                   ENDIF                                                                CDL094
664600210712      *                                                                                       CDL094
664700210712      * Set up Account with Bank (If defined for the Receive Nostro)                          CDL094
664800210712     C     A7RF57        IFNE      *BLANKS                                                    CDL094
664900210712     C                   MOVEL     'X'           I#AWBT                                       CDL094
665000210712     C                   MOVEL     A7RF57        I#AWBK                                       CDL094
665100210712     C                   ENDIF                                                                CDL094
665200210712      *                                                                                       CDL094
665300210712      * Set up Beneficiary (If defined for the Receive Nostro and not FX Deal)                CDL094
665400210712     C     A7RF58        IFNE      *BLANKS                                                    CDL094
665500210712     C     ##CALP        ANDNE     'FXDL'                                                     CDL094
665600210712     C                   MOVEL     'X'           I#BENT                                       CDL094
665700210712     C                   MOVEL     A7RF58        I#BENF                                       CDL094
665800210712     C                   ENDIF                                                                CDL094
665900210712      *                                                                                       CDL094
666000210712      * Move in Bank to Bank Information                                                      CDL094
666100210712     C                   MOVEL     DDRBB1        I#BTB1                                       CDL094
666200210712     C                   MOVEL     DDRBB2        I#BTB2                                       CDL094
666300210712     C                   MOVEL     DDRBB3        I#BTB3                                       CDL094
666400210712     C                   MOVEL     DDRBB4        I#BTB4                                       CDL094
666500210712     C                   MOVEL     DDRBB5        I#BTB5                                       CDL094
666600210712     C                   MOVEL     DDRBB6        I#BTB6                                       CDL094
666700210712     C                   MOVEL     DDRSTM        I#PSTM                                       CDL094
666800210712     C                   MOVEL     DDPSTM        I#RSTM                                       CDL094
666900210712      *                                                                                       CDL094
667000210712      * Set up receive account information (use Pay details since we are                      CDL094
667100210712      * calling ME9950 for the Receive Bank to Bank details)                                  CDL094
667200210712     C     DDPONS        IFNE      *BLANKS                                                    CDL094
667300210712     C                   SELECT                                                               CDL094
667400210712     C     DDPOBR        WHENNE    *BLANKS                                                    CDL094
667500210712     C     DDPONS        CAT       DDPOBR        I#RCAC                                       CDL094
667600210712     C     DDPONS        WHENNE    *BLANKS                                                    CDL094
667700210712     C                   MOVEL     DDPONS        I#RCAC                                       CDL094
667800210712     C                   ENDSL                                                                CDL094
667900210712     C                   ENDIF                                                                CDL094
668000210712      *                                                                                       CDL094
668100210712      * Set up Pay account information (use Receive details since we are                      CDL094
668200210712      * calling ME9950 for the Receive Bank to Bank details)                                  CDL094
668300210712     C     DDRONS        IFNE      *BLANKS                                                    CDL094
668400210712     C                   SELECT                                                               CDL094
668500210712     C     DDROBR        WHENNE    *BLANKS                                                    CDL094
668600210712     C     DDRONS        CAT       DDROBR        I#PYAC                                       CDL094
668700210712     C     DDRONS        WHENNE    *BLANKS                                                    CDL094
668800210712     C                   MOVEL     DDRONS        I#PYAC                                       CDL094
668900210712     C                   ENDSL                                                                CDL094
669000210712     C                   ENDIF                                                                CDL094
669100210712      *                                                                                       CDL094
669200210712      * Transaction Type                                                                      CDL094
669300210712     C                   MOVEL     ##TTYP        I#TTYP                                       CDL094
669400210712      *                                                                                       CDL094
669500210712     C                   CLEAR                   O#PARM                                       CDL094
669600210712     C                   CLEAR                   E#PARM                                       CDL094
669700210712      *                                                                                       CDL094
669800210712      * Send messages to correct calling process                                              CDL094
669900210712     C                   MOVEL     'ME9950'      E#CPGM                                       CDL094
670000210712     C                   MOVEL     'DL'          I#MMOD                                       CDL094
670100210712      *                                                                                       CDL094
670200210712      * Set standard message text                                                             CDL094
670300210712     C                   MOVEL     'MEC0114'     E#MSGD                                       CDL094
670400210712     C                   MOVEL     'MEMSG'       E#MSGF                                       CDL094
670500210712      *                                                                                       CDL094
670600210712     C                   CALL      'ME9950'                                                   CDL094
670700210712     C                   PARM                    W0RTN             7                          CDL094
670800210712     C                   PARM                    I#PARM                         I Input Parms CDL094
670900210712     C                   PARM                    O#PARM                         O Output ParmsCDL094
671000210712     C                   PARM                    E#PARM                         E Error InformCDL094
671100210712     C                   PARM                    Z#PARM          256            B User DefinedCDL094
671200210712      *                                                                                       CDL094
671300210712      * On return if errors copy into error array                                             CDL094
671400210712      *                                                                                       CDL094
671500210712     C                   MOVEL     O#BTB1        DDRBB1                                       CDL094
671600210712     C                   MOVEL     O#BTB2        DDRBB2                                       CDL094
671700210712     C                   MOVEL     O#BTB3        DDRBB3                                       CDL094
671800210712     C                   MOVEL     O#BTB4        DDRBB4                                       CDL094
671900210712     C                   MOVEL     O#BTB5        DDRBB5                                       CDL094
672000210712     C                   MOVEL     O#BTB6        DDRBB6                                       CDL094
672100210712      *                                                                                       CDL094
672200210712      ** Subtract 1 from error array index                                                    CDL094
672300210712     C                   SUB       1             E#INDX                                       CDL094
672400210712      *                                                                                       CDL094
672500210712     C     E#ERRM        IFNE      *BLANKS                                                    CDL094
672600210712     C     1             DO        E#INDX        Q#                5 0                        CDL094
672700210712     C                   ADD       1             Idx                                          CDL094
672800210712     C                   EVAL      FldNameArr(Idx) = 'DDRBB1'                                 CDL094
672900210712     C                   MOVEL     'ESM0'        WMessageID                                   CDL094
673000210712     C                   MOVE      O#E(Q#)       WMessageID                                   CDL094
673100210712     C                   EVAL      MsgIDArr(Idx) = WMessageID                                 CDL094
673200210712     C     O#E(Q#)       IFEQ      '994'                                                      CDL094
673300210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0105'                                  CDL094
673400210712     C                   ENDIF                                                                CDL094
673500210712     C     O#E(Q#)       IFEQ      '101'                                                      CDL094
673600210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0101'                                  CDL094
673700210712     C                   ENDIF                                                                CDL094
673800210712     C     O#E(Q#)       IFEQ      '100'                                                      CDL094
673900210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0100'                                  CDL094
674000210712     C                   ENDIF                                                                CDL094
674100210712     C     O#E(Q#)       IFEQ      '302'                                                      CDL094
674200210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0302'                                  CDL094
674300210712     C                   ENDIF                                                                CDL094
674400210712     C     O#E(Q#)       IFEQ      '103'                                                      CDL094
674500210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0103'                                  CDL094
674600210712     C                   ENDIF                                                                CDL094
674700210712     C     O#E(Q#)       IFEQ      '104'                                                      CDL094
674800210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0104'                                  CDL094
674900210712     C                   ENDIF                                                                CDL094
675000210712     C     O#E(Q#)       IFEQ      '897'                                                      CDL094
675100210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0116'                                  CDL094
675200210712     C                   ENDIF                                                                CDL094
675300210712     C     O#E(Q#)       IFEQ      '893'                                                      CDL094
675400210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0108'                                  CDL094
675500210712     C                   ENDIF                                                                CDL094
675600210712     C     O#E(Q#)       IFEQ      '895'                                                      CDL094
675700210712     C                   EVAL      MsgIDArr(Idx) = 'MEC0107'                                  CDL094
675800210712     C                   ENDIF                                                                CDL094
675900210712     C                   ENDDO                                                                CDL094
676000210712     C                   MOVE      'N'           DDRbb1OK                                     CDL094
676100210712     C                   MOVE      'N'           DDRbb2OK                                     CDL094
676200210712     C                   MOVE      'N'           DDRbb3OK                                     CDL094
676300210712     C                   MOVE      'N'           DDRbb4OK                                     CDL094
676400210712     C                   MOVE      'N'           DDRbb5OK                                     CDL094
676500210712     C                   MOVE      'N'           DDRbb6OK                                     CDL094
676600210712     C                   ENDIF                                                                CDL094
676700210712     C                   ENDIF                                                                CDL094
676800210712      *                                                                                       CDL094
676900210712      ** UPDATE OUTPUT FIELDS                                                                 CDL094
677000210712      *                                                                                       CDL094
677100210712     C                   MOVEL     DDRBB1        FLRBB1                                       CDL094
677200210712     C                   MOVEL     DDRBB2        FLRBB2                                       CDL094
677300210712     C                   MOVEL     DDRBB3        FLRBB3                                       CDL094
677400210712     C                   MOVEL     DDRBB4        FLRBB4                                       CDL094
677500210712     C                   MOVEL     DDRBB5        FLRBB5                                       CDL094
677600210712     C                   MOVEL     DDRBB6        FLRBB6                                       CDL094
677700210712      *                                                                                       CDL094
677800210712     C                   ENDSR                                                                CDL094
677900210712     C********************************************************************
678000210712      /EJECT
678100210712     C*****************************************************************
678200210712     C*                                                               *
678300210712     C* XVRPSETC - CROSS VALIDATE REC/PAY SETTLEMENT CURRENCY         *
678400210712     C*                                                               *
678500210712     C*****************************************************************
678600210712     C     XVRPSETC      BEGSR
678700210712      *
678800210712      * Receive and payment settlement currencies can't be different
678900210712      *
679000210712     C     DDRSCY        IFNE      DDPSCY
679100210712     C     ##CALP        IFEQ      'DEAM'                                                     196808
679200210712     C     DDRSCY        ANDEQ     *BLANK                                                     196808
679300210712     C     DDRSTM        ANDEQ     '00'                                                       196808
679400210712     C     ##CALP        OREQ      'DEAM'                                                     196808
679500210712     C     DDPSCY        ANDEQ     *BLANK                                                     196808
679600210712     C     DDPSTM        ANDEQ     '00'                                                       196808
679700210712     C     ##CALP        OREQ      'MAPY'                                                     239587
679800210712     C     DDRSCY        ANDEQ     *BLANK                                                     239587
679900210712     C*****DDRSTM        ANDEQ     '00'                                              239587 AR853046
680000210712     C     DDRSTM        ANDEQ     *BLANKS                                                  AR853046
680100210712     C     ##CALP        OREQ      'MAPY'                                                     239587
680200210712     C     DDPSCY        ANDEQ     *BLANK                                                     239587
680300210712     C*****DDPSTM        ANDEQ     '00'                                              239587 AR853046
680400210712     C     ##CALP        OREQ      'MAPY'                                                  AR1005230
680500210712     C     DDPSCY        ANDEQ     *BLANK                                                  AR1005230
680600210712     C     DDPSTM        ANDEQ     *BLANKS                                                  AR853046
680700210712     C                   GOTO      XVRPEND                                                    196808
680800210712     C                   ENDIF                                                                196808
680900210712     C                   ADD       1             Idx
681000210712     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
681100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0847'
681200210712     C                   MOVE      'N'           DDRscyOK
681300210712     C                   MOVE      'N'           DDPscyOK
681400210712     C                   ENDIF
681500210712
681600210712     C**********         ENDSR                                                                196808
681700210712     C     XVRPEND       ENDSR                                                                196808
681800210712     C********************************************************************
681900210712      /EJECT
682000210712     C*****************************************************************
682100210712     C*                                                               *
682200210712     C**VLFRIR*-*VALIDATE*FRA/IRS*SETTLEMENT*DETAILS*******************                       CSW212
682300210712     C* VLFRIR - VALIDATE EXTENDED SETTLEMENT DETAILS                 *                       CSW212
682400210712     C*                                                               *
682500210712     C*****************************************************************
682600210712     C     VLFRIR        BEGSR
682700210712      *
682800210712      ** CLEAR OUTPUT FRA/IRS FIELDS
682900210712      *
683000210712     C                   CLEAR                   ##FRIF
683100210712      *
683200210712      ** DEFINITION SENDER TO RECEIVER INFORMATION
683300210712      ** -----------------------------------------
683400210712      *
683500210712     C                   EXSR      VLDSRI
683600210712      *
683700210712      ** SETTLEMENT/RESET SENDER TO RECEIVER INFORMATION
683800210712      ** -----------------------------------------------
683900210712      *
684000210712     C                   EXSR      VLSSRI
684100210712      *
684200210712      ** CONDITIONS
684300210712      ** ----------
684400210712      *
684500210712     C                   EXSR      VLCNDI
684600210712      *
684700210712      ** AGREEMENT DETAILS
684800210712      ** -----------------
684900210712      *
685000210712     C     ##TTYP        IFEQ      'RS'
685100210712     C     ##TTYP        OREQ      'FR'                                         CSW097
685200210712     C     ##TTYP        OREQ      'RX'
685300210712     C     CIR003        ANDEQ     'N'                                                        CIR003
685400210712     C     ##CALP        OREQ      'CIRS'                                                     CIR003
685500210712     C     CIR003        ANDEQ     'Y'                                                        CIR003
685600210712     C     ##CALP        OREQ      'SSI '
685700210712     C     ##TTYP        ANDEQ     'AT'
685800210712     C     CSW005        ANDEQ     'Y'
685900210712     C     ##CALP        OREQ      'FXDL'                                                     CSW212
686000210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
686100210712     C                   EXSR      VLAGRD
686200210712     C                   ENDIF
686300210712      *
686400210712      ** UPDATE OUTPUT FIELDS
686500210712      *
686600210712     C                   MOVEL     ##FRIS        ##FRIF
686700210712     C**********         MOVEL     DDAGVV        FLAGVC                              CSW097 MD033870
686800210712     C**********         MOVE      DDAGVV        FLAGVV                              CSW097 MD033870
686900210712     C**********         MOVE      DDAGVV        FLAGVC                            MD033870 MD040199
687000210712     C**********         MOVEL     DDAGVV        FLAGVV                            MD033870 MD040199
687100210712     C                   MOVEL     DDAGVV        FLAGVC                                     MD040199
687200210712     C                   MOVE      DDAGVV        FLAGVV                                     MD040199
687300210712      *
687400210712     C                   ENDSR
687500210712     C********************************************************************
687600210712      /EJECT
687700210712     C*****************************************************************
687800210712     C*                                                               *
687900210712     C* VLDSRI - VALIDATE DEFINITION SENDER TO RECEIVER INFORMATION   *
688000210712     C*                                                               *
688100210712     C*****************************************************************
688200210712     C     VLDSRI        BEGSR
688300210712      *
688400210712      **  First, convert Agreement Type to disregard leading blanks
688500210712      *
688600210712     C     DDAGTY        IFNE      *BLANKS
688700210712      *
688800210712     C     ##TTYP        IFEQ      'RS'
688900210712     C     ##TTYP        OREQ      'RX'
689000210712     C     ##TTYP        OREQ      'FR'                                         CSW097
689100210712     C     ##CALP        OREQ      'SSI '
689200210712     C     ##TTYP        ANDEQ     'AT'
689300210712     C     CSW005        ANDEQ     'Y'
689400210712     C     ##CALP        OREQ      'FXDL'                                                     CSW212
689500210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
689600210712     C*
689700210712     C                   MOVEL     DDAGTY        WorkAGTY          6
689800210712     C     1             DO        6             W@X               1 0
689900210712     C     1             SUBST     DDAGTY:W@X    Work01            1
690000210712     C     Work01        IFNE      *BLANKS
690100210712     C                   LEAVE
690200210712     C                   ENDIF
690300210712     C                   ENDDO
690400210712     C*
690500210712     C                   SUBST(P)  WorkAGTY:W@X  DDAGTY
690600210712     C*
690700210712     C                   ENDIF
690800210712     C                   ENDIF
690900210712     C*
691000210712     C**  Definition Confirmation Sender to Receiver
691100210712     C*
691200210712     C                   CLEAR                   I#PARM
691300210712     C                   CLEAR                   E#PARM
691400210712     C                   CLEAR                   O#PARM
691500210712     C*
691600210712     C                   MOVEL(P)  ':72: '       I#VFLD
691700210712     C                   MOVEL     ##TTYP        I#TTYP
691800210712     C                   MOVEL     'FI'          I#MMOD
691900210712     C     DDAWBN        IFNE      *BLANKS
692000210712     C                   MOVEL     'X'           I#AWBT
692100210712     C                   MOVEL     DDAWBN        I#AWBK
692200210712     C                   ENDIF
692300210712     C                   MOVEL     DDDSR1        I#BTB1
692400210712     C                   MOVEL     DDDSR2        I#BTB2
692500210712     C                   MOVEL     DDDSR3        I#BTB3
692600210712     C                   MOVEL     DDDSR4        I#BTB4
692700210712     C                   MOVEL     DDDSR5        I#BTB5
692800210712     C                   MOVEL     DDDSR6        I#BTB6
692900210712      *
693000210712     C     ##CALP        IFEQ      'FXDL'                                                  AR1039735
693100210712     C     CSW212        ANDEQ     'Y'                                                     AR1039735
693200210712     C                   MOVEL     'DL'          I#MMOD                                    AR1039735
693300210712     C                   MOVEL     DDPSTM        I#PSTM                                    AR1039735
693400210712     C                   MOVEL     '202'         I#MTYP                                    AR1039735
693500210712     C                   ENDIF                                                             AR1039735
693600210712                                                                                           AR1039735
693700210712     C                   SELECT
693800210712     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
693900210712     C******             MOVEL     'SD2400'      E#CPGM                         CAP003
694000210712     C     ##CALP        WHENEQ    'SSI '
694100210712     C                   MOVEL     'SD0402R'     E#CPGM
694200210712     C                   OTHER
694300210712     C                   MOVEL     'ME9950'      E#CPGM
694400210712     C                   ENDSL
694500210712      *
694600210712      * Set standard message text
694700210712      *
694800210712     C                   MOVEL     'MEC0201'     E#MSGD
694900210712     C                   MOVEL     'MEMSG'       E#MSGF
695000210712     C/COPY WNCPYSRC,ZASETNVC19
695100210712      *
695200210712     C                   CALL      'ME9950'
695300210712     C                   PARM                    W0RTN             7
695400210712     C                   PARM                    I#PARM                         I Input Parms
695500210712     C                   PARM                    O#PARM                         O Output Parms
695600210712     C                   PARM                    E#PARM                         E Error Inform
695700210712     C                   PARM                    Z#PARM          256            B User Defined
695800210712     C/COPY WNCPYSRC,ZASETNVC20
695900210712      *
696000210712      * On return if errors copy into error array
696100210712      *
696200210712     C                   MOVEL     O#BTB1        DDDSR1
696300210712     C                   MOVEL     O#BTB2        DDDSR2
696400210712     C                   MOVEL     O#BTB3        DDDSR3
696500210712     C                   MOVEL     O#BTB4        DDDSR4
696600210712     C                   MOVEL     O#BTB5        DDDSR5
696700210712     C                   MOVEL     O#BTB6        DDDSR6
696800210712     C/COPY WNCPYSRC,ZASETNVC21
696900210712      *
697000210712      ** Subtract 1 from error array index
697100210712     C                   SUB       1             E#INDX
697200210712      *                                                                                       CSW214
697300210712     C     ##CALP        IFEQ      'FXDL'                                                     CSW214
697400210712     C     ##CALP        OREQ      'FRA'                                                      CSW214
697500210712     C     ##CALP        OREQ      'SIRS'                                                     CSW214
697600210712     C     ##CALP        OREQ      'CIRS'                                                     CSW214
697700210712     C     CSW214        IFEQ      'Y'                                                        CSW214
697800210712     C     E#WARN        ANDEQ     'Y'                                                        CSW214
697900210712     C     1             DO        E#INDX        Q#                                           CSW214
698000210712     C                   ADD       1             WIdx                                         CSW214
698100210712     C                   EVAL      WMessageID = '5047377'                                     CSW214
698200210712     C                   EVAL      WMsgIDArr(WIdx) = WMessageID                               CSW214
698300210712     C                   EVAL      WFldNameArr(WIdx) = 'DDDSR1'                               CSW214
698400210712     C                   ENDDO                                                                CSW214
698500210712     C                   ENDIF                                                                CSW214
698600210712     C                   ENDIF                                                                CSW214
698700210712      *
698800210712     C     E#ERRM        IFNE      *BLANKS
698900210712     C                   ADD       1             Idx
699000210712     C                   EVAL      FldNameArr(Idx) = 'DDDSR1'
699100210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0X01'                    CAP003
699200210712     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
699300210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
699400210712     C                   EVAL      MsgIDArr(Idx) = '5045758'                                  CSW212
699500210712     C                   ELSE                                                                 CSW212
699600210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0600'                         CAP003 MD029779
699700210712     C                   EVAL      MsgIDArr(Idx) = '5047378'                                MD029779
699800210712     C                   ENDIF                                                                CSW212
699900210712     C                   MOVE      'N'           DDDsr1OK
700000210712     C                   MOVE      'N'           DDDsr2OK
700100210712     C                   MOVE      'N'           DDDsr3OK
700200210712     C                   MOVE      'N'           DDDsr4OK
700300210712     C                   MOVE      'N'           DDDsr5OK
700400210712     C                   MOVE      'N'           DDDsr6OK
700500210712     C                   ENDIF
700600210712      *
700700210712      ** Field 72 (Cover Message) cannly be input if 'Cover MT202 required' flag is 'Y'       CSW212
700800210712      *                                                                                       CSW212
700900210712     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
701000210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
701100210712     C     DDCVMR        IFNE      'Y'                                                        CSW212
701200210712     C     DDDSR1        ANDNE     *BLANKS                                                    CSW212
701300210712     C                   ADD       1             Idx                                          CSW212
701400210712     C                   EVAL      FldNameArr(Idx) = 'DDDSR1'                                 CSW212
701500210712     C                   EVAL      MsgIDArr(Idx) = '5045750'                                  CSW212
701600210712     C                   MOVEL     'N'           DDDsr1OK                                     CSW212
701700210712     C                   ENDIF                                                                CSW212
701800210712     C                   ENDIF                                                                CSW212
701900210712      *                                                                                       CSW212
702000210712     C                   ENDSR
702100210712     C********************************************************************
702200210712      /EJECT
702300210712     C*****************************************************************
702400210712     C*                                                               *
702500210712     C* VLSSRI - VALIDATE SETTLEMENT/RESET SENDER TO RECEIVER INFO    *
702600210712     C*                                                               *
702700210712     C*****************************************************************
702800210712     C     VLSSRI        BEGSR
702900210712      *
703000210712      **  Settlement/Reset Confirmation Sender to Receiver
703100210712      *
703200210712     C                   CLEAR                   I#PARM
703300210712     C                   CLEAR                   E#PARM
703400210712     C                   CLEAR                   O#PARM
703500210712     C*
703600210712     C                   MOVEL(P)  ':72: '       I#VFLD
703700210712     C                   MOVEL     ##TTYP        I#TTYP
703800210712     C                   MOVEL     'FI'          I#MMOD
703900210712     C     DDAWBN        IFNE      *BLANKS
704000210712     C                   MOVEL     'X'           I#AWBT
704100210712     C                   MOVEL     DDAWBN        I#AWBK
704200210712     C                   ENDIF
704300210712                                                                                           AR1039735
704400210712     C     ##CALP        IFEQ      'FXDL'                                                  AR1039735
704500210712     C     CSW212        ANDEQ     'Y'                                                     AR1039735
704600210712     C                   MOVEL     'DL'          I#MMOD                                    AR1039735
704700210712     C                   MOVEL     DDPSTM        I#PSTM                                    AR1039735
704800210712     C                   MOVEL     '300'         I#MTYP                                    AR1039735
704900210712      *                                                                                       CMG003
705000210712      **  Access Currency Details for transaction Payment Currency                            CMG003
705100210712      *                                                                                       CMG003
705200210712     C                   CALLB     'AOCURRR0'                                                 CMG003
705300210712     C                   PARM      *BLANKS       @RTCD                                        CMG003
705400210712     C                   PARM      '*KEY    '    @OPTN                                        CMG003
705500210712     C                   PARM      ##PCCY        @CURR                                        CMG003
705600210712     C     SDCURR        PARM      SDCURR        DSSDY                                        CMG003
705700210712      *                                                                                       CMG003
705800210712      ** Move Precious Metal Ind value to temporary workfield                                 CMG003
705900210712     C                   IF        @RTCD = *BLANKS                                            CMG003
706000210712     C                   EVAL      WPayPMRT = A6PMRT                                          CMG003
706100210712     C                   ENDIF                                                                CMG003
706200210712      *                                                                                       CMG003
706300210712      **  Access Currency Details for transaction Receive Currency                            CMG003
706400210712      *                                                                                       CMG003
706500210712     C                   CALLB     'AOCURRR0'                                                 CMG003
706600210712     C                   PARM      *BLANKS       @RTCD                                        CMG003
706700210712     C                   PARM      '*KEY    '    @OPTN                                        CMG003
706800210712     C                   PARM      ##RCCY        @CURR                                        CMG003
706900210712     C     SDCURR        PARM      SDCURR        DSSDY                                        CMG003
707000210712      *                                                                                       CMG003
707100210712      ** Move Precious Metal Ind value to temporary workfield                                 CMG003
707200210712     C                   IF        @RTCD = *BLANKS                                            CMG003
707300210712     C                   EVAL      WRecPMRT = A6PMRT                                          CMG003
707400210712     C                   ENDIF                                                                CMG003
707500210712      *                                                                                       CMG003
707600210712      ** If CMG003 is *ON, use I#MTYP = '600' if one and only the                             CMG003
707700210712      ** currency (Purchase or Sell) is flagged as previous metal                             CMG003
707800210712      *                                                                                       CMG003
707900210712     C                   IF        CMG003 = 'Y'                                               CMG003
708000210712     C                   IF        (WPayPMRT = 'Y' AND WRecPMRT = 'N') OR                     CMG003
708100210712     C                             (WPayPMRT = 'N' AND WRecPMRT = 'Y')                        CMG003
708200210712     C                   EVAL      I#MTYP = '600'                                             CMG003
708300210712     C                   ENDIF                                                                CMG003
708400210712     C                   ENDIF                                                                CMG003
708500210712      *                                                                                       CMG003
708600210712     C                   ENDIF                                                             AR1039735
708700210712                                                                                           AR1039735
708800210712     C                   MOVEL     DDSSR1        I#BTB1
708900210712     C                   MOVEL     DDSSR2        I#BTB2
709000210712     C                   MOVEL     DDSSR3        I#BTB3
709100210712     C                   MOVEL     DDSSR4        I#BTB4
709200210712     C                   MOVEL     DDSSR5        I#BTB5
709300210712     C                   MOVEL     DDSSR6        I#BTB6
709400210712      *
709500210712     C                   SELECT
709600210712     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
709700210712     C******             MOVEL     'SD2400'      E#CPGM                         CAP003
709800210712     C     ##CALP        WHENEQ    'SSI '
709900210712     C                   MOVEL     'SD0402R'     E#CPGM
710000210712     C                   OTHER
710100210712     C                   MOVEL     'ME9950'      E#CPGM
710200210712     C                   ENDSL
710300210712      *
710400210712      * Set standard message text
710500210712     C                   MOVEL     'MEC0202'     E#MSGD
710600210712     C                   MOVEL     'MEMSG'       E#MSGF
710700210712     C/COPY WNCPYSRC,ZASETNVC22
710800210712      *
710900210712     C                   CALL      'ME9950'
711000210712     C                   PARM                    W0RTN             7
711100210712     C                   PARM                    I#PARM                         I Input Parms
711200210712     C                   PARM                    O#PARM                         O Output Parms
711300210712     C                   PARM                    E#PARM                         E Error Inform
711400210712     C                   PARM                    Z#PARM          256            B User Defined
711500210712     C/COPY WNCPYSRC,ZASETNVC23
711600210712      *
711700210712      * On return if errors copy into error array
711800210712      *
711900210712     C                   MOVEL     O#BTB1        DDSSR1
712000210712     C                   MOVEL     O#BTB2        DDSSR2
712100210712     C                   MOVEL     O#BTB3        DDSSR3
712200210712     C                   MOVEL     O#BTB4        DDSSR4
712300210712     C                   MOVEL     O#BTB5        DDSSR5
712400210712     C                   MOVEL     O#BTB6        DDSSR6
712500210712     C/COPY WNCPYSRC,ZASETNVC24
712600210712      *
712700210712      ** Subtract 1 from error array index
712800210712     C                   SUB       1             E#INDX
712900210712      *                                                                                       CSW214
713000210712     C     ##CALP        IFEQ      'FXDL'                                                     CSW214
713100210712     C     ##CALP        OREQ      'FRA'                                                      CSW214
713200210712     C     ##CALP        OREQ      'SIRS'                                                     CSW214
713300210712     C     ##CALP        OREQ      'CIRS'                                                     CSW214
713400210712     C     CSW214        IFEQ      'Y'                                                        CSW214
713500210712     C     E#WARN        ANDEQ     'Y'                                                        CSW214
713600210712     C     1             DO        E#INDX        Q#                                           CSW214
713700210712     C                   ADD       1             WIdx                                         CSW214
713800210712     C                   EVAL      WMessageID = '5047377'                                     CSW214
713900210712     C                   EVAL      WMsgIDArr(WIdx) = WMessageID                               CSW214
714000210712     C                   EVAL      WFldNameArr(WIdx) = 'DDSSR1'                               CSW214
714100210712     C                   ENDDO                                                                CSW214
714200210712     C                   ENDIF                                                                CSW214
714300210712     C                   ENDIF                                                                CSW214
714400210712      *
714500210712     C     E#ERRM        IFNE      *BLANKS
714600210712     C                   ADD       1             Idx
714700210712     C                   EVAL      FldNameArr(Idx) = 'DDSSR1'
714800210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0X02'                    CAP003
714900210712     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
715000210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
715100210712     C                   EVAL      MsgIDArr(Idx) = '5045759'                                  CSW212
715200210712     C                   ELSE                                                                 CSW212
715300210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0601'                         CAP003 MD029779
715400210712     C                   EVAL      MsgIDArr(Idx) = '5047379'                                MD029779
715500210712     C                   ENDIF                                                                CSW212
715600210712     C                   MOVE      'N'           DDSsr1OK
715700210712     C                   MOVE      'N'           DDSsr2OK
715800210712     C                   MOVE      'N'           DDSsr3OK
715900210712     C                   MOVE      'N'           DDSsr4OK
716000210712     C                   MOVE      'N'           DDSsr5OK
716100210712     C                   MOVE      'N'           DDSsr6OK
716200210712     C                   ENDIF
716300210712      *
716400210712     C                   ENDSR
716500210712     C********************************************************************
716600210712      /EJECT
716700210712     C*****************************************************************
716800210712     C*                                                               *
716900210712     C* VLCNDI - VALIDATE CONDITIONS                                  *
717000210712     C*                                                               *
717100210712     C*****************************************************************
717200210712     C     VLCNDI        BEGSR
717300210712      *
717400210712      **  Conditions
717500210712      *
717600210712      **     Condition 1 mandatory if Agreement type is 'OTHER'
717700210712      *
717800210712     C     ##TTYP        IFEQ      'RS'
717900210712     C     ##TTYP        OREQ      'RX'
718000210712     C     ##CALP        OREQ      'SSI '
718100210712     C     ##TTYP        ANDEQ     'AT'
718200210712     C     CSW005        ANDEQ     'Y'
718300210712     C     ##CALP        OREQ      'FXDL'                                                     CSW212
718400210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
718500210712     C     DDAGTY        IFEQ      'OTHER'
718600210712     C     DDCND1        ANDEQ     *BLANKS
718700210712     C                   ADD       1             Idx
718800210712     C                   EVAL      FldNameArr(Idx) = 'DDCND1'
718900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0400'
719000210712     C                   MOVE      'N'           DDCnd1OK
719100210712     C                   ENDIF
719200210712     C                   ENDIF
719300210712      *
719400210712      **     Other validation
719500210712      *
719600210712     C                   CLEAR                   I#PARM
719700210712     C                   CLEAR                   E#PARM
719800210712     C                   CLEAR                   O#PARM
719900210712      *
720000210712      * Set standard message text
720100210712     C                   MOVEL     'MEC0203'     E#MSGD
720200210712     C                   MOVEL     'MEMSG'       E#MSGF
720300210712     C*
720400210712     C                   MOVEL(P)  ':77D:'       I#VFLD
720500210712     C                   MOVEL(P)  ##TTYP        I#TTYP
720600210712     C                   MOVEL     'FI'          I#MMOD
720700210712     C                   MOVEL     DDCND1        I#BTB1
720800210712     C                   MOVEL     DDCND2        I#BTB2
720900210712     C                   MOVEL     DDCND3        I#BTB3
721000210712     C                   MOVEL     DDCND4        I#BTB4
721100210712     C                   MOVEL     DDCND5        I#BTB5
721200210712     C                   MOVEL     DDCND6        I#BTB6
721300210712      *
721400210712     C                   SELECT
721500210712     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
721600210712     C******             MOVEL     'SD2400'      E#CPGM                         CAP003
721700210712     C     ##CALP        WHENEQ    'SSI '
721800210712     C                   MOVEL     'SD0402R'     E#CPGM
721900210712     C                   OTHER
722000210712     C******             MOVEL     'ME9950'      E#CPGM                         CAP003
722100210712     C                   MOVEL     'ME9960'      E#CPGM                         CAP003
722200210712     C                   ENDSL
722300210712      *
722400210712     C     CSW212        IFEQ      'Y'                                                        CSW212
722500210712     C     ##CALP        ANDEQ     'FXDL'                                                     CSW212
722600210712     C                   MOVEL     '300'         I#MTYP                                       CSW212
722700210712     C                   MOVEL     'FX'          I#TTYP                                       CSW212
722800210712      *                                                                                       CMG003
722900210712      ** If CMG003 is *ON, use I#MTYP = '600' if one and only the                             CMG003
723000210712      ** currency (Purchase or Sell) is flagged as previous metal and                         CMG003
723100210712      ** if the transaction type is related to FX deal                                        CMG003
723200210712      *                                                                                       CMG003
723300210712     C                   IF        CMG003 = 'Y'                                               CMG003
723400210712     C                   IF        ##TTYP <> 'CL' AND                                         CMG003
723500210712     C                             ##TTYP <> 'NX'                                             CMG003
723600210712     C                   IF        (WPayPMRT = 'Y' AND WRecPMRT = 'N') OR                     CMG003
723700210712     C                             (WPayPMRT = 'N' AND WRecPMRT = 'Y')                        CMG003
723800210712     C                   EVAL      I#MTYP = '600'                                             CMG003
723900210712     C                   ENDIF                                                                CMG003
724000210712     C                   ENDIF                                                                CMG003
724100210712     C                   ENDIF                                                                CMG003
724200210712                                                                                              CMG003
724300210712     C                   ENDIF                                                                CSW212
724400210712      *                                                                                       CSW212
724500210712     C     I#TTYP        IFEQ      'FX'                                                       CSW213
724600210712     C     I#TTYP        OREQ      'OP'                                                       CSW213
724700210712     C     I#TTYP        OREQ      'FF'                                                       CSW213
724800210712     C     I#TTYP        OREQ      'CL'                                                       CSW213
724900210712     C     CDL008        ANDEQ     'Y'                                                        CSW213
725000210712     C     CSW213        IFEQ      'Y'                                                        CSW213
725100210712                                                                                              CSW213
725200210712     C                   EVAL      I#MTYP = '300'                                             CSW213
725300210712                                                                                              CSW213
725400210712     C                   CALLB     'AOCURRR0'                                                 CSW213
725500210712     C                   PARM      *BLANKS       @RTCD                                        CSW213
725600210712     C                   PARM      '*KEY    '    @OPTN                                        CSW213
725700210712     C                   PARM      ##RCCY        @CURR                                        CSW213
725800210712     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW213
725900210712     C     @RTCD         IFEQ      *BLANKS                                                    CSW213
726000210712     C                   MOVE      A6PMRT        RPMRT             1                          CSW213
726100210712     C                   ENDIF                                                                CSW213
726200210712                                                                                              CSW213
726300210712     C                   CALLB     'AOCURRR0'                                                 CSW213
726400210712     C                   PARM      *BLANKS       @RTCD                                        CSW213
726500210712     C                   PARM      '*KEY    '    @OPTN                                        CSW213
726600210712     C                   PARM      ##PCCY        @CURR                                        CSW213
726700210712     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW213
726800210712     C     @RTCD         IFEQ      *BLANKS                                                    CSW213
726900210712     C                   MOVE      A6PMRT        PPMRT             1                          CSW213
727000210712     C                   ENDIF                                                                CSW213
727100210712                                                                                              CSW213
727200210712     C*****RPMRT         IFEQ      'Y'                                                 CSW213 CSW214
727300210712     C*****PPMRT         OREQ      'Y'                                                 CSW213 CSW214
727400210712     C                   IF        (RPMRT = 'Y' AND PPMRT = 'N')                              CSW214
727500210712     C                             OR (RPMRT = 'N' AND PPMRT = 'Y')                           CSW214
727600210712     C                   EVAL      I#MTYP = '600'                                             CSW213
727700210712     C                   ENDIF                                                                CSW213
727800210712                                                                                              CSW213
727900210712     C                   ENDIF                                                                CSW213
728000210712     C                   ENDIF                                                                CSW213
728100210712                                                                                              CSW213
728200210712     C                   CALL      'ME9960'
728300210712     C                   PARM                    W0RTN             7
728400210712     C                   PARM                    I#PARM                         I Input Parms
728500210712     C                   PARM                    O#PARM                         O Output Parms
728600210712     C                   PARM                    E#PARM                         E Error Inform
728700210712     C                   PARM                    Z#PARM          256            B User Defined
728800210712      *
728900210712      * On return if errors copy into error array
729000210712      *
729100210712     C                   MOVEL     O#BTB1        DDCND1
729200210712     C                   MOVEL     O#BTB2        DDCND2
729300210712     C                   MOVEL     O#BTB3        DDCND3
729400210712     C                   MOVEL     O#BTB4        DDCND4
729500210712     C                   MOVEL     O#BTB5        DDCND5
729600210712     C                   MOVEL     O#BTB6        DDCND6
729700210712      *
729800210712      ** Subtract 1 from error array index
729900210712     C                   SUB       1             E#INDX
730000210712      *
730100210712     C     E#ERRM        IFNE      *BLANKS
730200210712     C     E#MSGD        IFNE      *BLANKS                                                    CSW212
730300210712     C     1             DO        E#INDX        Q#                                           CSW212
730400210712     C                   ADD       1             Idx                                          CSW212
730500210712     C                   EVAL      FldNameArr(Idx) = 'DDCND1'                                 CSW212
730600210712     C     O#E(Q#)       IFEQ      '143'                                                    MD022945
730700210712     C     O#E(Q#)       OREQ      '144'                                                    MD022945
730800210712     C                   MOVEL     '5046'        WMessageID                                 MD022945
730900210712     C                   ELSE                                                               MD022945
731000210712     C                   MOVEL     '5045'        WMessageID                                   CSW212
731100210712     C                   ENDIF                                                              MD022945
731200210712     C                   MOVE      O#E(Q#)       WMessageID                                   CSW212
731300210712     C                   EVAL      MsgIDArr(Idx) = WMessageID                                 CSW212
731400210712     C     O#E(Q#)       IFEQ      'X03'                                                      CSW212
731500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0602'                                  CSW212
731600210712     C                   ENDIF                                                                CSW212
731700210712     C                   ENDDO                                                                CSW212
731800210712     C                   ELSE                                                                 CSW212
731900210712     C*****1****         DO        E#INDX        Q#                5 0          CAP003
732000210712     C                   ADD       1             Idx
732100210712     C                   EVAL      FldNameArr(Idx) = 'DDCND1'
732200210712     C**********         MOVEL     'ESM0'        WMessageID                     CAP003
732300210712     C**********         MOVE      O#E(Q#)       WMessageID                     CAP003
732400210712     C**********         EVAL      MsgIDArr(Idx) = WMessageID                   CAP003
732500210712     C**********         ENDDO                                                  CAP003
732600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0602'                    CAP003
732700210712     C                   ENDIF                                                                CSW212
732800210712     C                   MOVEL     'N'           DDCnd1OK
732900210712     C                   MOVEL     'N'           DDCnd2OK
733000210712     C                   MOVEL     'N'           DDCnd3OK
733100210712     C                   MOVEL     'N'           DDCnd4OK
733200210712     C                   MOVEL     'N'           DDCnd5OK
733300210712     C                   MOVEL     'N'           DDCnd6OK
733400210712     C                   ENDIF
733500210712      *
733600210712     C                   ENDSR
733700210712     C********************************************************************
733800210712      /EJECT
733900210712     C*****************************************************************
734000210712     C*                                                               *
734100210712     C* VLAGRD - VALIDATE AGREEMENT DETAILS                           *
734200210712     C*                                                               *
734300210712     C*****************************************************************
734400210712     C     VLAGRD        BEGSR
734500210712      *                                                                         CSW097
734600210712     C     ##TTYP        IFEQ      'RS'                                         CSW097
734700210712     C     ##TTYP        OREQ      'RX'                                         CSW097
734800210712     C     ##TTYP        OREQ      'AT'                                         CSW097
734900210712     C     CSW005        ANDEQ     'Y'                                          CSW200
735000210712      *                                                                         CSW097
735100210712      **  Allow all blank entry for type AT only                                CSW097
735200210712      *                                                                         CSW097
735300210712     C     DDISDA        IFNE      *BLANKS                                      CSW097
735400210712     C     DDAGTY        ORNE      *BLANKS                                      CSW097
735500210712     C     DDAGDT        ORNE      *BLANKS                                      CSW097
735600210712     C     DDAGVV        ORNE      *BLANKS                                      CSW097
735700210712     C     ##TTYP        OREQ      'RS'                                         CSW097
735800210712     C     ##TTYP        OREQ      'RX'                                         CSW097
735900210712      *
736000210712      **  ISDA Rules version must be numeric
736100210712      **  RS/RX                                                                 CSW097
736200210712      *
736300210712     C     DDAGTY        IFNE      'ISDA  '                                     CSW097
736400210712     C     DDAGTY        ANDNE     'OTHER '                                     CSW097
736500210712     C     DDISDA        IFNE      *BLANKS                                      CSW097
736600210712     C     DDISDA        ANDNE     '0000'                                       CSW097
736700210712     C                   ADD       1             Idx                            CSW097
736800210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW097
736900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0407'                    CSW097
737000210712     C                   MOVEL     'N'           DDIsdaOK                       CSW097
737100210712     C                   ENDIF                                                  CSW097
737200210712     C                   ENDIF                                                  CSW097
737300210712      *                                                                         CSW097
737400210712     C     DDAGTY        IFEQ      'ISDA  '                                     CSW097
737500210712     C     DDAGTY        OREQ      'OTHER '                                     CSW097
737600210712     C     DDISDA        ANDNE     *BLANKS                                      CSW097
737700210712     C                   MOVE      '0'           WISDA             5            CSW097
737800210712     C                   MOVEL     DDISDA        WISDA             5            CSW097
737900210712     C                   TESTN                   WISDA                99        CSW097
738000210712     C***********        TESTN                   DDISDA               99        CSW097
738100210712     C     *IN99         IFEQ      *OFF
738200210712     C     DDISDA        OREQ      *ZEROS                                       CSW097
738300210712     C     DDAGTY        ANDEQ     'ISDA  '                                     CSW097
738400210712     C                   ADD       1             Idx
738500210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'
738600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0406'
738700210712     C                   MOVEL     'N'           DDIsdaOK
738800210712     C                   ENDIF
738900210712     C                   ENDIF                                                  CSW097
739000210712      *                                                                                     MD051567
739100210712      **  ISDA Rules version must be a valid year starting with 199 or 20.                  MD051567
739200210712      *                                                                                     MD051567
739300210712     C     CSW212        IFEQ      'Y'                                                      MD051567
739400210712     C     DDISDA        IFNE      *BLANKS                                                  MD051567
739500210712     C     DDISDA        ANDNE     '0000'                                                   MD051567
739600210712     C                   MOVEL     DDISDA        ISDA3                                      MD051567
739700210712     C                   MOVEL     DDISDA        ISDA2                                      MD051567
739800210712     C     ISDA3         IFNE      '199'                                                    MD051567
739900210712     C     ISDA2         ANDNE     '20'                                                     MD051567
740000210712     C     DDAGTY        ANDEQ     'ISDA  '                                                 MD051567
740100210712     C                   ADD       1             Idx                                        MD051567
740200210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                               MD051567
740300210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0418'                                MD051567
740400210712     C                   MOVEL     'N'           DDIsdaOK                                   MD051567
740500210712     C                   ENDIF                                                              MD051567
740600210712     C                   ENDIF                                                              MD051567
740700210712     C                   ELSE                                                               MD051567
740800210712      *                                                                                       CSW201
740900210712      ** If SWIFT 2001 is installed, DDISDA may be '2000'                                     CSW201
741000210712      *                                                                                       CSW201
741100210712     C     CSW201        IFEQ      'Y'                                                        CSW201
741200210712     C     DDISDA        ANDEQ     '2000'                                                     CSW201
741300210712     C                   MOVEL     'Y'           WY2000            1                          CSW201
741400210712     C                   ELSE                                                                 CSW201
741500210712     C                   MOVEL     'N'           WY2000                                       CSW201
741600210712     C                   ENDIF                                                                CSW201
741700210712                                                                                CSW200
741800210712     C     DDAGTY        IFEQ      'ISDA  '                                     CSW200
741900210712     C     DDISDA        IFNE      '1991'                                       CSW200
742000210712     C     DDISDA        ANDNE     '1998'                                       CSW200
742100210712     C     WY2000        ANDNE     'Y'                                                        CSW201
742200210712     C     DDISDA        ANDNE     '2006'                                                     254023
742300210712     C                   ADD       1             Idx                            CSW200
742400210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW200
742500210712     C***********        EVAL      MsgIDArr(Idx) = 'ESM0414'                           CSW200 CSW201
742600210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0417'                           CSW201 CSW202
742700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0414'                                  CSW202
742800210712     C                   MOVEL     'N'           DDIsdaOK                       CSW200
742900210712     C                   ENDIF                                                  CSW200
743000210712     C                   ENDIF                                                  CSW200
743100210712     C                   ENDIF                                                              MD051567
743200210712      *
743300210712      **  Agreement Type
743400210712      **  RS/RX                                                                 CSW097
743500210712      *
743600210712     C     DDAGTY        IFNE      'ISDA  '
743700210712     C     DDAGTY        ANDNE     'AFB   '
743800210712     C     DDAGTY        ANDNE     'BBAIRS'
743900210712     C     DDAGTY        ANDNE     'OTHER '
744000210712     C     DDAGTY        ANDNE     'DERV  '                                                   CSW202
744100210712     C     DDAGTY        ANDNE     'ISDACN'                                                   CSW214
744200210712     C     DDAGTY        OREQ      'DERV  '                                                   CSW202
744300210712     C     CSW202        ANDEQ     'N'                                                        CSW202
744400210712     C     DDAGTY        OREQ      'ISDACN'                                                   CSW214
744500210712     C     CSW214        ANDEQ     'N'                                                        CSW214
744600210712     C                   ADD       1             Idx
744700210712     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'
744800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0401'
744900210712     C                   MOVEL     'N'           DDAgtyOK
745000210712     C                   ENDIF
745100210712      *
745200210712      **  Agreement Date
745300210712      **  RS/RX                                                                 CSW097
745400210712      *
745500210712     C*****DDAGTY        IFEQ      'OTHER'                                      CSW097
745600210712     C     DDAGTY        IFEQ      'BBAIRS'                                     CSW097
745700210712      *
745800210712     C     DDAGDT        IFNE      *BLANKS
745900210712     C                   ADD       1             Idx
746000210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'
746100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0402'
746200210712     C                   MOVEL     'N'           DDAgdtOK
746300210712     C                   ENDIF
746400210712      *
746500210712     C                   ELSE
746600210712      *                                                                         CSW097
746700210712     C     DDAGTY        IFEQ      'OTHER '                                     CSW097
746800210712     C     DDAGDT        ANDNE     *BLANKS                                      CSW097
746900210712     C     DDAGTY        OREQ      'OTHER '                                     CSW097
747000210712     C     DDAGVV        ANDNE     *BLANK                                       CSW097
747100210712     C     DDAGDT        ANDEQ     *BLANK                                       CSW097
747200210712     C     DDAGTY        ORNE      'OTHER '                                     CSW097
747300210712      *
747400210712      **  Input date must be in YYMMDD format
747500210712      **  RS/RX                                                                 CSW097
747600210712      *
747700210712     C                   MOVE      '0'           WAGDT             7            CSW097
747800210712     C                   MOVEL     DDAGDT        WAGDT                          CSW097
747900210712     C                   TESTN                   WAGDT                99        CSW097
748000210712     C***********        TESTN                   DDAGDT               99        CSW097
748100210712      *
748200210712      ** Non Numeric Date
748300210712     C     *IN99         IFEQ      *OFF
748400210712     C                   ADD       1             Idx
748500210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'
748600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'
748700210712     C                   MOVEL     'N'           DDAgdtOK
748800210712     C                   ELSE
748900210712      *
749000210712      ** Numeric Date
749100210712     C                   MOVEL     DDAGDT        W#AGDR
749200210712     C                   Z-ADD     W#DDR         W#DD
749300210712     C                   Z-ADD     W#MMR         W#MM
749400210712     C                   Z-ADD     W#YYR         W#YY
749500210712     C                   RESET                   RetCodeOut
749600210712     C                   CALLB     'ZAVDATE'
749700210712     C                   PARM                    RetCodeOut
749800210712     C                   PARM                    W#AGDT
749900210712     C                   PARM      'D'           Datefmt           1
750000210712     C                   PARM                    @DAYNO            5 0
750100210712      *
750200210712      ** Error in form of date
750300210712     C     RetCodeOut    IFEQ      'Error'
750400210712     C                   ADD       1             Idx
750500210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'
750600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'
750700210712     C                   MOVEL     'N'           DDAgdtOK
750800210712     C                   ENDIF
750900210712     C                   ENDIF
751000210712     C                   ENDIF
751100210712     C                   ENDIF                                                  CSW097
751200210712      *
751300210712      **  Agreement Version
751400210712      **  RS/RX                                                                 CSW097
751500210712      *
751600210712     C*****DDAGTY        IFEQ      'OTHER''                                     CSW097
751700210712     C     DDAGTY        IFEQ      'BBAIRS'                                     CSW097
751800210712     C     DDAGVV        IFNE      *BLANKS
751900210712     C                   ADD       1             Idx
752000210712     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'
752100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0404'
752200210712     C                   MOVEL     'N'           DDAgvvOK
752300210712     C                   ENDIF
752400210712     C                   ELSE
752500210712      *                                                                         CSW097
752600210712     C     DDAGTY        IFEQ      'OTHER '                                     CSW097
752700210712     C     DDAGVV        ANDNE     *BLANKS                                      CSW097
752800210712     C     DDAGTY        OREQ      'OTHER '                                     CSW097
752900210712     C     DDAGDT        ANDNE     *BLANK                                       CSW097
753000210712     C     DDAGVV        ANDEQ     *BLANK                                       CSW097
753100210712     C     DDAGTY        ORNE      'OTHER '                                     CSW097
753200210712     C                   MOVE      '0'           WAGVV             5            CSW097
753300210712     C                   MOVEL     DDAGVV        WAGVV                          CSW097
753400210712     C                   TESTN                   WAGVV                99        CSW097
753500210712     C***********        TESTN                   DDAGVV               99        CSW097
753600210712      *
753700210712      ** Version must be numeric
753800210712     C     *IN99         IFEQ      *OFF
753900210712     C     DDAGVV        OREQ      *ZEROS                                       CSW097
754000210712     C                   ADD       1             Idx
754100210712     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'
754200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0405'
754300210712     C                   MOVEL     'N'           DDAgvvOK
754400210712     C                   ENDIF
754500210712     C                   ENDIF
754600210712     C                   ENDIF                                                  CSW097
754700210712     C                   ENDIF                                                  CSW097
754800210712      *
754900210712     C                   ELSE                                                   CSW097
755000210712      *                                                                         CSW097
755100210712     C     ##TTYP        IFEQ      'FR'                                         CSW097
755200210712     C     ##TTYP        OREQ      'AT'                                         CSW200
755300210712     C     CSW011        ANDEQ     'Y'                                          CSW200
755400210712     C     CSW200        ANDEQ     'Y'                                          CSW200
755500210712      *                                                                         CSW097
755600210712      ** Validate ISDA fields for FR type agreement                             CSW097
755700210712      *                                                                         CSW097
755800210712      ** Allow all blank entry                                                  CSW097
755900210712      *                                                                         CSW097
756000210712     C     DDISDA        IFNE      *BLANKS                                      CSW097
756100210712     C     DDAGTY        ORNE      *BLANKS                                      CSW097
756200210712     C     DDAGDT        ORNE      *BLANKS                                      CSW097
756300210712     C     DDAGVV        ORNE      *BLANKS                                      CSW097
756400210712      *                                                                         CSW097
756500210712      ** FR ISDA Rules version must be numeric                                  CSW097
756600210712      *                                                                         CSW097
756700210712     C     DDAGTY        IFNE      'ISDA  '                                     CSW097
756800210712     C     DDISDA        IFNE      *BLANKS                                      CSW097
756900210712     C     DDISDA        ANDNE     '0000'                                       CSW097
757000210712     C                   ADD       1             Idx                            CSW097
757100210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW097
757200210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0408'                    CSW097
757300210712     C                   MOVEL     'N'           DDIsdaOK                       CSW097
757400210712     C                   ENDIF                                                  CSW097
757500210712     C                   ENDIF                                                  CSW097
757600210712     C     DDAGTY        IFEQ      'ISDA  '                                     CSW097
757700210712     C                   MOVE      '0'           WISDA             5            CSW097
757800210712     C                   MOVEL     DDISDA        WISDA             5            CSW097
757900210712     C                   TESTN                   WISDA                99        CSW097
758000210712     C     *IN99         IFEQ      *OFF                                         CSW097
758100210712     C     DDISDA        OREQ      *ZEROS                                       CSW097
758200210712     C                   ADD       1             Idx                            CSW097
758300210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW097
758400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0406'                    CSW097
758500210712     C                   MOVEL     'N'           DDIsdaOK                       CSW097
758600210712     C                   ENDIF                                                  CSW097
758700210712     C                   ENDIF                                                  CSW097
758800210712      *                                                                                     MD051567
758900210712      **  ISDA Rules version must be a valid year starting with 199 or 20.                  MD051567
759000210712      *                                                                                     MD051567
759100210712     C     CSW212        IFEQ      'Y'                                                      MD051567
759200210712     C     DDISDA        IFNE      *BLANKS                                                  MD051567
759300210712     C     DDISDA        ANDNE     '0000'                                                   MD051567
759400210712     C                   MOVEL     DDISDA        ISDA3                                      MD051567
759500210712     C                   MOVEL     DDISDA        ISDA2                                      MD051567
759600210712     C     ISDA3         IFNE      '199'                                                    MD051567
759700210712     C     ISDA2         ANDNE     '20'                                                     MD051567
759800210712     C     DDAGTY        ANDEQ     'ISDA  '                                                 MD051567
759900210712     C                   ADD       1             Idx                                        MD051567
760000210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                               MD051567
760100210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0418'                                MD051567
760200210712     C                   MOVEL     'N'           DDIsdaOK                                   MD051567
760300210712     C                   ENDIF                                                              MD051567
760400210712     C                   ENDIF                                                              MD051567
760500210712     C                   ELSE                                                               MD051567
760600210712      *                                                                                       CSW201
760700210712      ** If SWIFT 2001 is installed, DDISDA may be '2000'                                     CSW201
760800210712      *                                                                                       CSW201
760900210712     C     CSW201        IFEQ      'Y'                                                        CSW201
761000210712     C     DDISDA        ANDEQ     '2000'                                                     CSW201
761100210712     C                   MOVEL     'Y'           WY2000                                       CSW201
761200210712     C                   ELSE                                                                 CSW201
761300210712     C                   MOVEL     'N'           WY2000                                       CSW201
761400210712     C                   ENDIF                                                                CSW201
761500210712                                                                                CSW200
761600210712     C     DDAGTY        IFEQ      'ISDA  '                                     CSW200
761700210712     C     DDISDA        IFNE      '1991'                                       CSW200
761800210712     C     DDISDA        ANDNE     '1998'                                       CSW200
761900210712     C     WY2000        ANDNE     'Y'                                                        CSW201
762000210712     C     DDISDA        ANDNE     '2006'                                                     254023
762100210712     C                   ADD       1             Idx                            CSW200
762200210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW200
762300210712     C***********        EVAL      MsgIDArr(Idx) = 'ESM0414'                           CSW200 CSW201
762400210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0417'                           CSW201 CSW202
762500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0414'                                  CSW202
762600210712     C                   MOVEL     'N'           DDIsdaOK                       CSW200
762700210712     C                   ENDIF                                                  CSW200
762800210712     C                   ENDIF                                                  CSW200
762900210712     C                   ENDIF                                                              MD051567
763000210712      *                                                                         CSW097
763100210712      ** FR Agreement Type                                                      CSW097
763200210712      *                                                                         CSW097
763300210712     C     DDAGTY        IFNE      'ISDA'                                       CSW097
763400210712     C     DDAGTY        ANDNE     'AFB'                                        CSW097
763500210712     C     DDAGTY        ANDNE     'DERV'                                       CSW200
763600210712     C     DDAGTY        ANDNE     'FRABBA'                                     CSW200
763700210712     C     DDAGTY        ANDNE     'EMA'                                                      CSW214
763800210712     C     DDAGTY        ANDNE     'ISDACN'                                                   CSW214
763900210712     C     DDAGTY        ANDNE     'OTHER'                                                    CSW214
764000210712     C     DDAGTY        OREQ      'DERV'                                       CSW200
764100210712     C     CSW200        ANDEQ     'N'                                          CSW200
764200210712     C     DDAGTY        OREQ      'FRABBA'                                     CSW200
764300210712     C     CSW200        ANDEQ     'N'                                          CSW200
764400210712     C     DDAGTY        OREQ      'ISDACN'                                                   CSW214
764500210712     C     CSW214        ANDEQ     'N'                                                        CSW214
764600210712     C                   ADD       1             Idx                            CSW097
764700210712     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                   CSW097
764800210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0409'                    CSW097
764900210712     C                   MOVEL     'N'           DDAgtyOK                       CSW097
765000210712     C                   ENDIF                                                  CSW097
765100210712      *                                                                         CSW097
765200210712      ** FR Agreement Date                                                      CSW097
765300210712      *                                                                         CSW097
765400210712     C     CSW200        IFEQ      'Y'                                          CSW200
765500210712     C     DDAGTY        ANDEQ     'FRABBA'                                     CSW200
765600210712     C     DDAGDT        ANDNE     *BLANKS                                      CSW200
765700210712     C                   ADD       1             Idx                            CSW200
765800210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                   CSW200
765900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0415'                    CSW200
766000210712     C                   MOVEL     'N'           DDAgdtOK                       CSW200
766100210712     C                   ENDIF                                                  CSW200
766200210712      *                                                                         CSW200
766300210712     C     CSW200        IFEQ      'Y'                                          CSW200
766400210712     C     DDAGDT        ANDNE     *BLANKS                                      CSW200
766500210712     C     CSW200        OREQ      'N'                                          CSW200
766600210712      *                                                                         CSW200
766700210712      ** FR Input date, must be in YYMMDD format                                CSW097
766800210712      *                                                                         CSW097
766900210712     C                   MOVE      '0'           WAGDT             7            CSW097
767000210712     C                   MOVEL     DDAGDT        WAGDT                          CSW097
767100210712     C                   TESTN                   WAGDT                99        CSW097
767200210712     C     *IN99         IFEQ      *OFF                                         CSW097
767300210712     C                   ADD       1             Idx                            CSW097
767400210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                   CSW097
767500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                    CSW097
767600210712     C                   MOVEL     'N'           DDAgdtOK                       CSW097
767700210712     C                   ELSE                                                   CSW097
767800210712      *                                                                         CSW097
767900210712      ** Numeric Date                                                           CSW097
768000210712     C                   MOVEL     DDAGDT        W#AGDR                         CSW097
768100210712     C                   Z-ADD     W#DDR         W#DD                           CSW097
768200210712     C                   Z-ADD     W#MMR         W#MM                           CSW097
768300210712     C                   Z-ADD     W#YYR         W#YY                           CSW097
768400210712     C                   RESET                   RetCodeOut                     CSW097
768500210712     C                   CALLB     'ZAVDATE'                                    CSW097
768600210712     C                   PARM                    RetCodeOut                     CSW097
768700210712     C                   PARM                    W#AGDT                         CSW097
768800210712     C                   PARM      'D'           Datefmt                        CSW097
768900210712     C                   PARM                    @DAYNO                         CSW097
769000210712      *                                                                         CSW097
769100210712      ** Error in form of date                                                  CSW097
769200210712     C     RetCodeOut    IFEQ      'Error'                                      CSW097
769300210712     C                   ADD       1             Idx                            CSW097
769400210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                   CSW097
769500210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                    CSW097
769600210712     C                   MOVEL     'N'           DDAgdtOK                       CSW097
769700210712     C                   ENDIF                                                  CSW097
769800210712     C                   ENDIF                                                  CSW097
769900210712      *                                                                         CSW097
770000210712     C                   ENDIF                                                  CSW200
770100210712      *                                                                         CSW200
770200210712      ** FR Agreement Version                                                   CSW097
770300210712      *                                                                         CSW097
770400210712     C     CSW200        IFEQ      'Y'                                          CSW200
770500210712     C     DDAGTY        ANDEQ     'FRABBA'                                     CSW200
770600210712     C     DDAGVV        ANDNE     *BLANKS                                      CSW200
770700210712     C                   ADD       1             Idx                            CSW200
770800210712     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'                   CSW200
770900210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0416'                    CSW200
771000210712     C                   MOVEL     'N'           DDAgvvOK                       CSW200
771100210712     C                   ENDIF                                                  CSW200
771200210712      *                                                                         CSW200
771300210712     C     CSW200        IFEQ      'Y'                                          CSW200
771400210712     C     DDAGVV        ANDNE     *BLANKS                                      CSW200
771500210712     C     CSW200        OREQ      'N'                                          CSW200
771600210712      *                                                                         CSW200
771700210712     C                   MOVE      '0'           WAGVV             5            CSW097
771800210712     C                   MOVEL     DDAGVV        WAGVV                          CSW097
771900210712     C                   TESTN                   WAGVV                99        CSW097
772000210712     C     *IN99         IFEQ      *OFF                                         CSW097
772100210712     C     DDAGVV        OREQ      *ZEROS                                       CSW097
772200210712     C                   ADD       1             Idx                            CSW097
772300210712     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'                   CSW097
772400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0405'                    CSW097
772500210712     C                   MOVEL     'N'           DDAgvvOK                       CSW097
772600210712     C                   ENDIF                                                  CSW097
772700210712     C                   ENDIF                                                  CSW200
772800210712     C                   ENDIF                                                  CSW097
772900210712     C                   ENDIF                                                  CSW097
773000210712     C                   ENDIF                                                  CSW097
773100210712      *                                                                         CSW097
773200210712      ** Additional validations for FXDL if CSW212 is ON.                                     CSW212
773300210712      *                                                                                       CSW212
773400210712     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
773500210712     C     CSW212        ANDEQ     'Y'                                                        CSW212
773600210712      *                                                                                       CSW212
773700210712      ** ISDA Rules version must be a valid year starting with 199 or 20.                     CSW212
773800210712      *                                                                                       CSW212
773900210712     C     DDISDA        IFNE      *BLANKS                                                    CSW212
774000210712     C     DDISDA        ANDNE     '0000'                                                     CSW212
774100210712     C                   MOVEL     DDISDA        ISDA3             3                          CSW212
774200210712     C                   MOVEL     DDISDA        ISDA2             2                          CSW212
774300210712     C     ISDA3         IFNE      '199'                                                      CSW212
774400210712     C     ISDA2         ANDNE     '20'                                                       CSW212
774500210712     C                   ADD       1             Idx                                          CSW212
774600210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                                 CSW212
774700210712     C                   EVAL      MsgIDArr(Idx) = '5045747'                                  CSW212
774800210712     C                   MOVEL     'N'           DDIsdaOK                                     CSW212
774900210712     C                   ENDIF                                                                CSW212
775000210712     C                   MOVE      '0'           WISDA                                        CSW212
775100210712     C                   MOVEL     DDISDA        WISDA                                        CSW212
775200210712     C                   TESTN                   WISDA                99                      CSW212
775300210712     C     *IN99         IFEQ      *OFF                                                       CSW212
775400210712     C                   ADD       1             Idx                                          CSW212
775500210712     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                                 CSW212
775600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0406'                                  CSW212
775700210712     C                   MOVEL     'N'           DDIsdaOK                                     CSW212
775800210712     C                   ENDIF                                                                CSW212
775900210712     C                   ENDIF                                                                CSW212
776000210712      *                                                                                       CSW212
776100210712      ** ISDA Agreement Type must only be any of the following:                               CSW212
776200210712      *                                                                                       CSW212
776300210712     C     DDAGTY        IFNE      *BLANKS                                                    CSW212
776400210712     C     DDAGTY        IFNE      'AFB'                                                      CSW212
776500210712     C     DDAGTY        ANDNE     'DERV'                                                  AR1000515
776600210712     C     DDAGTY        ANDNE     'FBF'                                                      CSW212
776700210712     C     DDAGTY        ANDNE     'FEOMA'                                                    CSW212
776800210712     C     DDAGTY        ANDNE     'ICOM'                                                     CSW212
776900210712     C     DDAGTY        ANDNE     'IFEMA'                                                    CSW212
777000210712     C     DDAGTY        ANDNE     'ISDA'                                                     CSW212
777100210712     C     DDAGTY        ANDNE     'OTHER'                                                    CSW212
777200210712     C     DDAGTY        ANDNE     'ISDACN'                                                   CSW214
777300210712     C     DDAGTY        ANDNE     'ISDACS'                                                   CSW221
777400210712     C     DDAGTY        OREQ      'ISDACN'                                                   CSW214
777500210712     C     CSW214        ANDEQ     'N'                                                        CSW214
777600210712     C     DDAGTY        OREQ      'ISDACS'                                                   CSW221
777700210712     C     CSW221        ANDEQ     'N'                                                        CSW221
777800210712     C                   ADD       1             Idx                                          CSW212
777900210712     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                                 CSW212
778000210712     C                   EVAL      MsgIDArr(Idx) = '5045748'                                  CSW212
778100210712     C                   MOVEL     'N'           DDAgtyOK                                     CSW212
778200210712     C                   ENDIF                                                                CSW212
778300210712      *                                                                                     MD030342
778400210712     C                   IF        I#MTYP = '600' AND                                       MD030342
778500210712     C                             (DDAGTY <> 'ISDA' AND                                    MD030342
778600210712     C                              DDAGTY <> 'OTHER')                                      MD030342
778700210712     C                   ADD       1             Idx                                        MD030342
778800210712     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                               MD030342
778900210712     C                   EVAL      MsgIDArr(Idx) = '5047391'                                MD030342
779000210712     C                   MOVEL     'N'           DDAgtyOK                                   MD030342
779100210712     C                   ENDIF                                                              MD030342
779200210712      *                                                                                       CSW212
779300210712     C                   ELSE                                                                 CSW212
779400210712      *                                                                                       CSW214
779500210712     C                   IF        CSW214 = 'Y' AND                                           CSW214
779600210712     C                             I#MTYP = '600'                                             CSW214
779700210712     C                   ADD       1             Idx                                          CSW214
779800210712     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                                 CSW214
779900210712     C                   EVAL      MsgIDArr(Idx) = '5047390'                                  CSW214
780000210712     C                   MOVEL     'N'           DDAgtyOK                                     CSW214
780100210712     C                   ENDIF                                                                CSW214
780200210712      *                                                                                       CSW212
780300210712      ** Mandatory if ISDA agreement date or version is inserted                              CSW212
780400210712      *                                                                                       CSW212
780500210712     C     DDAGDT        IFNE      *BLANKS                                                    CSW212
780600210712     C     DDAGVV        ORNE      *BLANKS                                                    CSW212
780700210712     C                   ADD       1             Idx                                          CSW212
780800210712     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                                 CSW212
780900210712     C                   EVAL      MsgIDArr(Idx) = '5045749'                                  CSW212
781000210712     C                   MOVEL     'N'           DDAgtyOK                                     CSW212
781100210712     C                   ENDIF                                                                CSW212
781200210712      *                                                                                       CSW212
781300210712     C                   ENDIF                                                                CSW212
781400210712      *                                                                                       CSW212
781500210712      ** ISDA Agreement Date must be valid in YYMMDD format                                   CSW212
781600210712      *                                                                                       CSW212
781700210712     C     DDAGDT        IFNE      *BLANKS                                                    CSW212
781800210712     C                   MOVE      '0'           WAGDT                                        CSW212
781900210712     C                   MOVEL     DDAGDT        WAGDT                                        CSW212
782000210712     C                   TESTN                   WAGDT                99                      CSW212
782100210712     C     *IN99         IFEQ      *OFF                                                       CSW212
782200210712     C                   ADD       1             Idx                                          CSW212
782300210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                                 CSW212
782400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                                  CSW212
782500210712     C                   MOVEL     'N'           DDAgdtOK                                     CSW212
782600210712     C                   ELSE                                                                 CSW212
782700210712      *                                                                                       CSW212
782800210712      ** Numeric Date                                                                         CSW212
782900210712      *                                                                                       CSW212
783000210712     C                   MOVEL     DDAGDT        W#AGDR                                       CSW212
783100210712     C                   Z-ADD     W#DDR         W#DD                                         CSW212
783200210712     C                   Z-ADD     W#MMR         W#MM                                         CSW212
783300210712     C                   Z-ADD     W#YYR         W#YY                                         CSW212
783400210712     C                   RESET                   RetCodeOut                                   CSW212
783500210712     C                   CALLB     'ZAVDATE'                                                  CSW212
783600210712     C                   PARM                    RetCodeOut                                   CSW212
783700210712     C                   PARM                    W#AGDT                                       CSW212
783800210712     C                   PARM      'D'           Datefmt                                      CSW212
783900210712     C                   PARM                    @DAYNO                                       CSW212
784000210712      *                                                                                       CSW212
784100210712      ** Error in form of date                                                                CSW212
784200210712      *                                                                                       CSW212
784300210712     C     RetCodeOut    IFEQ      'Error'                                                    CSW212
784400210712     C                   ADD       1             Idx                                          CSW212
784500210712     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                                 CSW212
784600210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                                  CSW212
784700210712     C                   MOVEL     'N'           DDAgdtOK                                     CSW212
784800210712     C                   ENDIF                                                                CSW212
784900210712     C                   ENDIF                                                                CSW212
785000210712     C                   ENDIF                                                                CSW212
785100210712      *                                                                                       CSW212
785200210712      ** ISDA Agreement Version must be numeric                                               CSW212
785300210712      *                                                                                       CSW212
785400210712     C     DDAGVV        IFNE      *BLANKS                                                    CSW212
785500210712     C     DDAGVV        ANDNE     '0000'                                                     CSW212
785600210712     C                   MOVE      '0'           WAGVV                                        CSW212
785700210712     C                   MOVEL     DDAGVV        WAGVV                                        CSW212
785800210712     C                   TESTN                   WAGVV                99                      CSW212
785900210712      *                                                                                       CSW212
786000210712     C     *IN99         IFEQ      *OFF                                                       CSW212
786100210712     C     DDAGVV        OREQ      *ZEROS                                                     CSW212
786200210712     C                   ADD       1             Idx                                          CSW212
786300210712     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'                                 CSW212
786400210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0405'                                  CSW212
786500210712     C                   MOVEL     'N'           DDAgvvOK                                     CSW212
786600210712     C                   ENDIF                                                                CSW212
786700210712     C                   ENDIF                                                                CSW212
786800210712      *                                                                                       CSW212
786900210712     C                   ENDIF                                                                CSW212
787000210712      *                                                                                       CSW212
787100210712     C                   ENDSR
787200210712     C*****************************************************************
787300210712      /EJECT
787400210712     C*****************************************************************
787500210712     C*
787600210712     C* PARTYT - DETERMINE PARTY TYPE
787700210712     C*
787800210712     C*****************************************************************
787900210712     C     PARTYT        BEGSR
788000210712      *
788100210712      * INITIALIZE OUTPUT FIELDS. THEY ARE:
788200210712      *
788300210712      * @PARTY. TAKES VALUES: CUSTNUM = CUSTOMER NUMBER
788400210712      *                       CUSTSNM = CUSTOMER SHORTNAME
788500210712      *                       COUNTNS = COUNTERPARTY NOSTRO CODE
788600210712      *                       ERROR   = ERROR (NON OF ABOVE)
788700210712      * @BANK . TAKES VALUES: 'Y'     = BANK
788800210712      *                       'N'     = NON-BANK
788900210712      *
789000210712     C/COPY WNCPYSRC,ZASETNVC01
789100210712     C                   MOVE      *BLANKS       @PARTY           10
789200210712     C                   MOVE      *BLANKS       @BANK             1
789300210712      *
789400210712      ** CHECK FOR CUSTOMER NUMBER OR SHORTNAME
789500210712      *
789600210712     C                   MOVE      *BLANKS       @KEY1            10
789700210712     C                   MOVEL     P#PART        @KEY1
789800210712     C                   CALL      'AOCUSTR0'
789900210712     C                   PARM      *BLANKS       @RTCD
790000210712     C                   PARM      '*KEY   '     @OPTN
790100210712     C                   PARM                    @KEY1
790200210712     C                   PARM      *BLANKS       @KYST             7
790300210712     C     SDCUST        PARM      *BLANKS       DSSDY
790400210712      *
790500210712      * CUSTOMER FOUND
790600210712      *
790700210712     C     @RTCD         IFEQ      *BLANKS
790800210712      *
790900210712      ** CUSTOMER NUMBER OR SHORTNAME?
791000210712      *
791100210712     C     @KYST         IFEQ      '*CNUM  '
791200210712     C                   MOVEL     'CUSTNUM'     @PARTY
791300210712     C                   ELSE
791400210712     C                   MOVEL     'CUSTSNM'     @PARTY
791500210712     C                   END
791600210712      *
791700210712      ** TEST FOR BANK/NON-BANK WHEN LIVE CUSTOMER FOUND
791800210712      *
791900210712     C*****BBBNBI****    IFNE      'Y'                                          166320
792000210712     C     BBSWFI        IFNE      'Y'                                          166320
792100210712     C                   MOVE      'N'           @BANK
792200210712     C                   ELSE
792300210712     C                   MOVE      'Y'           @BANK
792400210712     C                   END
792500210712      *
792600210712      ** ELSE: NO VALID CUSTOMER NUMBER OR SHORTNAME RETURNED
792700210712      **       CHECK FOR COUNTERPARTY NOSTRO (IF ALLOWED)
792800210712      *
792900210712     C                   ELSE
793000210712      *
793100210712      ** COUNTERPARTY NOSTRO NOT ALLOWED
793200210712      *
793300210712     C     @CPNAL        IFNE      'ALLOWED '
793400210712     C                   MOVEL     'ERROR  '     @PARTY
793500210712     C                   ELSE
793600210712     C                   MOVE      *BLANKS       @CBNB             8
793700210712     C                   MOVEL     P#PART        @CBNB
793800210712      *
793900210712     C                   CALL      'AOCNSTR0'
794000210712     C                   PARM      *BLANKS       @RTCD
794100210712     C                   PARM      '*KEY   '     @OPTN
794200210712     C                   PARM                    @CBNB
794300210712     C     SDCNST        PARM      SDCNST        DSFDY
794400210712      *
794500210712      * VALID COUNTERPARTY NOSTRO, OR NOT
794600210712      *
794700210712     C     @RTCD         IFEQ      *BLANKS
794800210712     C                   MOVEL     'COUNTNS'     @PARTY
794900210712     C                   ELSE
795000210712     C                   MOVEL     'ERROR  '     @PARTY
795100210712     C                   END
795200210712      *
795300210712     C                   END
795400210712      *
795500210712     C                   END
795600210712     C                   ENDSR
795700210712     C*****************************************************************
795800210712      /EJECT
795900210712     C*****************************************************************
796000210712     C*                                                               *
796100210712     C* DEFPAY   - Do Payment side Defaulting                         *
796200210712     C*                                                               *
796300210712     C*****************************************************************
796400210712     C     DEFPAY        BEGSR
796500210712      *
796600210712      * FIND OUT WHAT THE PAY SETTLEMENT BRANCH IS
796700210712      *
796800210712     C                   EXSR      PYSETB
796900210712      *
797000210712     C     @RTCD         IFEQ      *BLANKS
797100210712     C                   MOVEL     A7BRCD        @PSETB            3
797200210712     C                   ELSE
797300210712     C                   GOTO      EDEFPY
797400210712     C                   END
797500210712      *
797600210712      * FIELD 58, BENEFICIARY
797700210712      * ---------------------
797800210712      * BENEFICIARY DEFAULTS TO THE DEAL COUNTERPARTY
797900210712      *
798000210712     C     DDBENN        IFEQ      *BLANKS
798100210712     C                   MOVEL     ##CSNM        DDBENN
798200210712     C                   END
798300210712      *
798400210712      * FIND WHETHER BENEFICIARY IS A BANK AND
798500210712      * STORE INFORMATION FOR LATER USE
798600210712      *
798700210712     C                   MOVEL     DDBENN        @CSCN
798800210712     C                   EXSR      ACCUST
798900210712     C     @RTCD         IFEQ      *BLANKS
799000210712     C**********         MOVEL     BBBNBI        @BBNBI                                       197865
799100210712     C                   MOVEL     BBSWFI        @BBNBI                                       197865
799200210712     C                   ELSE
799300210712     C                   GOTO      EDEFPY
799400210712     C                   END
799500210712      *
799600210712      * FIELD 72, BANK TO BANK INFORMATION
799700210712      * ----------------------------------
799800210712      * FOR DEALS INPUT ONLY:
799900210712      *                    IF THE DEAL IS SETTLED VIA SWIFT AND
800000210712      * IF THE BENEFICIARY IS A BANK, AND NOT THE DEAL COUNTERPARTY
800100210712      * AND THE DEAL COUNTERPARTY IS ALSO A BANK AND THE DEAL BOOKING
800200210712      * BRANCH DIFFERS FROM THE SETTLEMENT BRANCH, DEFAULT FIELD 72.
800300210712      *
800400210712     C     ##CALP        IFNE      'SSI '
800500210712     C     DDBTB1        ANDEQ     *BLANKS
800600210712      *
800700210712     C     DDPSTM        ANDEQ     '08'
800800210712     C     @BBNBI        ANDEQ     'Y'
800900210712     C     DDBENN        ANDNE     @CCSSN
801000210712     C     DDBENN        ANDNE     @CCUST
801100210712     C     @CBNBI        ANDEQ     'Y'
801200210712     C     ##BRCA        ANDNE     @PSETB
801300210712      *
801400210712     C/COPY WNCPYSRC,ZASETINV06                                                               CUT009
801500210712      * USE COUNTERPARTY SWIFT ID IF PRESENT, ELSE USE REPORT NAME AND TOWN
801600210712      *
801700210712     C     @CCSID        IFNE      *BLANKS
801800210712     C                   MOVE      @CCSID        W#WK17           17
801900210712     C                   MOVEL     W#WK17        DDBTB1
802000210712     C                   ELSE
802100210712      *
802200210712      ** FIND COUNTERPARTY REPORT NAME AND TOWN
802300210712      *
802400210712     C                   MOVEL     ##CSNM        @CSCN
802500210712     C                   EXSR      ACCUST
802600210712     C     @RTCD         IFNE      *BLANKS
802700210712     C                   GOTO      EDEFPY
802800210712     C                   END
802900210712     C                   MOVEL     BBCRNM        W#WK30           30
803000210712     C                   MOVE      BBCRTN        W#WK30
803100210712     C                   MOVE      W#WK30        DDBTB1
803200210712     C                   END
803300210712      *
803400210712     C                   MOVEL     '/INS/'       DDBTB1
803500210712     C/COPY WNCPYSRC,ZASETINV07                                                               CUT009
803600210712     C                   END
803700210712      *                                                                         CAP004
803800210712      * TELEX DEFAULTING                                                        CAP004
803900210712      *                                                                         CAP004
804000210712     C     DDPSTM        IFEQ      '01'                                         CAP004
804100210712     C                   EXSR      TELEX                                        CAP004
804200210712     C                   END                                                    CAP004
804300210712      *
804400210712      * CHIPS DEFAULTING
804500210712      *
804600210712     C     DDPSTM        IFEQ      '07'
804700210712     C                   EXSR      CHIPS
804800210712     C                   END
804900210712      *
805000210712      * SWIFT DEFAULTING
805100210712      *
805200210712     C     DDPSTM        IFEQ      '08'
805300210712     C                   EXSR      SWIFT
805400210712     C                   END
805500210712      *
805600210712     C     EDEFPY        ENDSR
805700210712     C********************************************************************
805800210712      /EJECT
805900210712     C*****************************************************************
806000210712     C*                                                               *
806100210712     C* PYSETB - GET PAY SETTLEMENT BRANCH                            *
806200210712     C*                                                               *
806300210712     C*****************************************************************
806400210712     C     PYSETB        BEGSR
806500210712      *
806600210712     C                   MOVEL     DDPONS        A#OURA
806700210712     C                   MOVEL     E#PCCY        @CYCD
806800210712     C                   MOVEL     A#NOST        @NONB
806900210712      *
807000210712     C**********         CALL      'AONOSTR0'                                                 CDL094
807100210712     C                   CALL      'AONOSTR1'                                                 CDL094
807200210712     C                   PARM      *BLANKS       @RTCD
807300210712     C                   PARM      '*KEY   '     @OPTN
807400210712     C                   PARM      *BLANKS       @CUST             6
807500210712     C                   PARM                    @CYCD             3
807600210712     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
807700210712     C                   PARM      *BLANKS       @ACCD                                        CGL029
807800210712     C                   PARM      *BLANKS       @ACSN             2
807900210712     C                   PARM                    @NONB             2
808000210712     C                   PARM      *BLANKS       @BRCD             3
808100210712     C                   PARM      *BLANKS       @CSSN            10
808200210712     C                   PARM      *BLANKS       @PNOI             1
808300210712     C*****SDNOST        PARM      SDNOST        DSFDY                                        CDL094
808400210712     C     SDNOST        PARM      SDNOST        DSSDY                                        CDL094
808500210712     C*
808600210712     C                   ENDSR
808700210712     C*****************************************************************
808800210712      /EJECT
808900210712     C*****************************************************************
809000210712     C*                                                               *
809100210712     C* CHIPS - CHIPS DEFAULTING                                      *
809200210712     C*                                                               *
809300210712     C*****************************************************************
809400210712     C     CHIPS         BEGSR
809500210712      *
809600210712      * FIELD 50, ORDERING CUSTOMER (PAY SIDE)
809700210712      * --------------------------------------
809800210712      * IF THE BENEFICIARY DIFFERS FROM THE DEAL COUNTERPARTY AND THE
809900210712      * DEAL COUNTERPARTY IS A NON-BANK, THEN DEFAULT TO THE DEAL
810000210712      * COUNTERPARTY.
810100210712      *
810200210712     C     DDPOCN        IFEQ      *BLANKS
810300210712     C     DDPOBN        ANDEQ     *BLANKS                                                   BUG4490
810400210712     C     DDBENN        ANDNE     @CCSSN
810500210712     C     DDBENN        ANDNE     @CCUST
810600210712     C     @CBNBI        ANDNE     'Y'
810700210712     C                   MOVEL     ##CSNM        DDPOCN
810800210712     C                   END
810900210712      *
811000210712      * FIELD 52 - ORDERING BANK, PAY SIDE.
811100210712      * -----------------------------------
811200210712      * IF THE BENEFICIARY DIFFERS FROM THE DEAL COUNTERPARTY
811300210712      * AND THE DEAL COUNTERPARTY IS A BANK THEN DEFAULT TO DEAL
811400210712      * COUNTERPARTY.
811500210712      *
811600210712     C     DDPOBN        IFEQ      *BLANKS
811700210712     C     DDPOCN        ANDEQ     *BLANKS                                                   BUG4490
811800210712     C     DDBENN        ANDNE     @CCSSN
811900210712     C     DDBENN        ANDNE     @CCUST
812000210712     C     @CBNBI        ANDEQ     'Y'
812100210712     C                   MOVEL     ##CSNM        DDPOBN
812200210712     C                   END
812300210712      *
812400210712      * IF FIELD 57 IS BLANK THEN DISPLAY ERROR MESSAGE
812500210712      *
812600210712     C     DDAWBN        IFEQ      *BLANKS
812700210712     C     ##FFND        ANDNE     'Y'                                                      BUG12540
812800210712     C                   ADD       1             Idx
812900210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
813000210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0703'
813100210712     C                   MOVE      'N'           DDAwbnOK
813200210712     C                   END
813300210712     C*
813400210712     C                   ENDSR
813500210712     C*****************************************************************
813600210712      /EJECT                                                                    CAP004
813700210712     C*****************************************************************         CAP004
813800210712     C*                                                               *         CAP004
813900210712     C* TELEX - TELEX DEFAULTING                                      *         CAP004
814000210712     C*                                                               *         CAP004
814100210712     C*****************************************************************         CAP004
814200210712     C*                                                                         CAP004
814300210712     C     TELEX         BEGSR                                                  CAP004
814400210712      *                                                                         CAP004
814500210712      * FIELD 50, ORDERING CUSTOMER (PAY SIDE)                                  CAP004
814600210712      * --------------------------------------                                  CAP004
814700210712      ** IF PAY ORDERING CUSTOMER IS NOT DEFINED                                CAP004
814800210712      ** IF THE BENEFICIARY IS A NON BANK AND THE DEAL C/PARTY IS               CAP004
814900210712      ** A NON BANK THEN DEFAULT FIELD 50 TO THE DEAL C/PARTY                   CAP004
815000210712      *                                                                         CAP004
815100210712     C     DDPOCN        IFEQ      *BLANK                                       CAP004
815200210712     C     @BBNBI        IFEQ      'N'                                          CAP004
815300210712     C     @CBNBI        ANDEQ     'N'                                          CAP004
815400210712     C                   MOVEL     ##CSNM        DDPOCN                         CAP004
815500210712     C                   END                                                    CAP004
815600210712     C                   END                                                    CAP004
815700210712      *                                                                         CAP004
815800210712     C                   ENDSR                                                  CAP004
815900210712     C*****************************************************************         CAP004
816000210712      /EJECT
816100210712     C*****************************************************************
816200210712     C*                                                               *
816300210712     C* SWIFT - SWIFT DEFAULTING                                      *
816400210712     C*                                                               *
816500210712     C*****************************************************************
816600210712     C*
816700210712     C     SWIFT         BEGSR
816800210712      *
816900210712      * FIELD 50, ORDERING CUSTOMER (PAY SIDE)
817000210712      * --------------------------------------
817100210712      ** IF THE BENEFICIARY IS A NON BANK OR THE DEAL C/PARTY IS
817200210712      ** A NON BANK THEN DEFAULT FIELD 50 TO THE DEAL C/PARTY
817300210712      *
817400210712     C     DDPOCN        IFEQ      *BLANKS                                                   BUG4490
817500210712     C     DDPOBN        ANDEQ     *BLANKS                                                   BUG4490
817600210712     C     @BBNBI        IFEQ      'N'
817700210712     C     @CBNBI        OREQ      'N'
817800210712     C**********         MOVEL     ##CSNM        DDPOCN                                       197865
817900210712     C                   MOVEL     ##CSNM        @CSCN                                        197865
818000210712     C                   EXSR      ACCUST                                                     197865
818100210712     C     BBSWFI        IFEQ      'N'                                                        197865
818200210712     C                   MOVEL     ##CSNM        DDPOCN                                       197865
818300210712     C                   ENDIF                                                                197865
818400210712     C                   END
818500210712     C                   ENDIF                                                               BUG4490
818600210712      *
818700210712      * FIELD 52 - ORDERING BANK, PAY SIDE.
818800210712      * -----------------------------------
818900210712      *
819000210712     C/COPY WNCPYSRC,ZASETNVC31
819100210712      ***IF*SD*INPUT,*OR*BOOKING BRANCH = SETTLEMENT BRANCH                     167942
819200210712      *******************                                                       167942
819300210712     C*****##CALP********IFEQ      'SSI '                                       167942
819400210712     C*****##BRCA********OREQ      @PSETB                                       167942
819500210712      *
819600210712      * IF PAY ORDERING BANK NOT DEFINED
819700210712      * BENEFICIARY IS A BANK AND C/PARTY IS A BANK
819800210712      * AND BENEFICIARY IS NOT THE  C/PARTY
819900210712      *
820000210712     C     DDPOBN        IFEQ      *BLANKS
820100210712     C     DDPOCN        ANDEQ     *BLANKS                                                   BUG4490
820200210712     C     @BBNBI        ANDEQ     'Y'
820300210712     C     @CBNBI        ANDEQ     'Y'
820400210712     C     DDBENN        ANDNE     @CCSSN
820500210712     C     DDBENN        ANDNE     @CCUST
820600210712      *
820700210712      **  DEFAULT TO DEAL COUNTERPARTY
820800210712      *
820900210712     C                   MOVEL     ##CSNM        DDPOBN
821000210712      *
821100210712     C                   END
821200210712     C/COPY WNCPYSRC,ZASETINV08                                                               CUT009
821300210712     C*******************END                                                    167942
821400210712      *
821500210712      ***IF*NOT*SD*INPUT,*AND*BOOKING*BRANCH*IS*NOT*=*SETTLEMENT*BRANCH******** 167942
821600210712      *******************                                                       167942
821700210712     C*****##CALP********IFNE      'SSI '                                       167942
821800210712     C*****##BRCA********ANDNE     @PSETB                                       167942
821900210712     C*****DDPOBN********ANDEQ     *BLANKS                                      167942
822000210712      *******************                                                       167942
822100210712      ***GET*BOOKING*BRANCH*BICN*********************************************** 167942
822200210712      *******************                                                       167942
822300210712     C*******************CALL      'AOBRCHR0'                                   167942
822400210712     C*******************PARM      *BLANKS       @RTCD                          167942
822500210712     C*******************PARM      '*KEY'        @OPTN                          167942
822600210712     C*******************PARM                    ##BRCA                         167942
822700210712     C*****SDBRCH********PARM      SDBRCH        DSFDY                          167942
822800210712      *******************                                                       167942
822900210712      ***ACCESS*CUSTOMER*FOR*THIS*BICN***************************************** 167942
823000210712      *******************                                                       167942
823100210712     C*****@RTCD*********IFEQ      *BLANKS                                      167942
823200210712     C*******************MOVEL(P)  A8BICN        @CSCN                          167942
823300210712     C*******************EXSR      ACCUST                                       167942
823400210712      *******************                                                       167942
823500210712      ***IF*SHORTNAME*IS*NON*BLANK*DEFAULT*FIELD*52*TO*THE*SHORTNAME*********** 167942
823600210712      *******************                                                       167942
823700210712     C*****BBCSSN********IFNE      *BLANKS                                      167942
823800210712     C*******************MOVEL     BBCSSN        DDPOBN                         167942
823900210712     C*******************ELSE                                                   167942
824000210712      *******************                                                       167942
824100210712      ***ELSE*DEFAULT*FIELD*52*TO*THE*CUSTOMER*NUMBER************************** 167942
824200210712      *******************                                                       167942
824300210712     C*******************MOVEL     A8BICN        DDPOBN                         167942
824400210712     C*******************END                                                    167942
824500210712     C*******************END                                                    167942
824600210712     C*******************END                                                    167942
824700210712      *
824800210712      * FIELD 57, 'ACCOUNT WITH' BANK (PAY SIDE)
824900210712      * ----------------------------------------
825000210712      * FOR DEALS INPUT ONLY:
825100210712      *
825200210712     C     ##CALP        IFNE      'SSI '
825300210712      *
825400210712      * IF THE DEAL IS FOR FEDERAL FUNDS AND THE DEAL (PAY) CURRENCY
825500210712      * IS US DOLLARS.
825600210712      *
825700210712     C     ##FFND        ANDEQ     'Y'
825800210712     C     E#PCCY        ANDEQ     BLUSCY
825900210712      *
826000210712      * IF FIELD 57 IS BLANK THEN DISPLAY ERROR MESSAGE
826100210712      *
826200210712     C     DDAWBN        IFEQ      *BLANKS
826300210712     C     ##FFND        ANDNE     'Y'                                                      BUG12540
826400210712     C*****W#BLK3        IFNE      'Y'                                               182652 BUG12540
826500210712     C                   ADD       1             Idx
826600210712     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
826700210712     C                   EVAL      MsgIDArr(Idx) = 'ESM0703'
826800210712     C                   MOVE      'N'           DDAwbnOK
826900210712     C**********         MOVE      'Y'           W#BLK3            1                 182652 BUG12540
827000210712     C**********         END                                                                BUG12540
827100210712     C                   END
827200210712      *
827300210712      * IF THE INTERMEDIARY BANK IS NOT BLANK:
827400210712      *
827500210712     C     DDPIBN        IFNE      *BLANKS
827600210712      *
827700210712      * IF INTERMEDIARY BANK A/C LINE IS BLANK DEFAULT, ELSE VALIDATE.
827800210712      *
827900210712     C     DDPIBA        IFEQ      *BLANKS
828000210712     C     ##FFND        ANDNE     'Y'                                                      BUG12540
828100210712     C*****W#BLK1        IFNE      'Y'                                               182652 BUG12540
828200210712     C                   MOVEL     '//FW'        DDPIBA
828300210712     C**********         MOVE      'Y'           W#BLK1            1                 182652 BUG12540
828400210712     C**********         END                                                                BUG12540
828500210712     C**********         ELSE                                                                 182652
828600210712     C**********         MOVEL     DDPIBA        W#CHK4            4                          182652
828700210712     C*****W#CHK4        IFNE      '//FW'                                                     182652
828800210712     C**********         ADD       1             Idx                                          182652
828900210712     C**********         EVAL      FldNameArr(Idx) = 'DDPIBN'                                 182652
829000210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0700'                                  182652
829100210712     C**********         MOVE      'N'           DDPibnOK                                     182652
829200210712     C**********         END                                                                  182652
829300210712     C*
829400210712     C                   END
829500210712      *
829600210712      * IF INTERMEDIARY BANK (FIELD 56) IS BLANK:
829700210712      *
829800210712     C                   ELSE
829900210712      *
830000210712      * IF ACCOUNT WITH BANK A/C LINE IS BLANK DEFAULT, ELSE VALIDATE.
830100210712      *
830200210712     C     DDAWBA        IFEQ      *BLANKS
830300210712     C     ##FFND        ANDNE     'Y'                                                      BUG12540
830400210712     C*****W#BLK2        IFNE      'Y'                                               182652 BUG12540
830500210712     C                   MOVEL     '//FW'        DDAWBA
830600210712     C**********         MOVE      'Y'           W#BLK2            1                 182652 BUG12540
830700210712     C**********         END                                                         182652 BUG12540
830800210712     C**********         ELSE                                                                 182652
830900210712     C**********         MOVEL     DDAWBA        W#CHK4                                       182652
831000210712     C*****W#CHK4        IFNE      '//FW'                                                     182652
831100210712     C**********         ADD       1             Idx                                          182652
831200210712     C**********         EVAL      FldNameArr(Idx) = 'DDAWBA'                                 182652
831300210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0701'                                  182652
831400210712     C**********         MOVE      'N'           DDAwbaOK                                     182652
831500210712     C**********         END                                                                  182652
831600210712     C                   END
831700210712     C                   END
831800210712     C                   END
831900210712      *
832000210712     C                   ENDSR
832100210712     C********************************************************************
832200210712      /EJECT
832300210712     C*****************************************************************
832400210712     C*                                                               *
832500210712     C* DEFREC   - Do Receive side Defaulting                         *
832600210712     C*                                                               *
832700210712     C*****************************************************************
832800210712     C     DEFREC        BEGSR
832900210712      *
833000210712      ** IF BOTH ORDERING CUSTOMER AND ORDERING BANK ARE BLANK
833100210712      ** AND THE DEAL COUNTERPARTY IS A BANK DEFAULT ORDERING
833200210712      ** BANK TO THE CUSTOMER
833300210712      *
833400210712     C     @CBNBI        IFEQ      'Y'
833500210712     C     DDROCN        ANDEQ     *BLANKS
833600210712     C     DDROBN        ANDEQ     *BLANKS
833700210712     C                   MOVE      ##CSNM        DDROBN
833800210712     C                   END
833900210712      *
834000210712      ** IF BOTH ORDERING CUSTOMER AND ORDERING BANK ARE BLANK
834100210712      ** AND THE DEAL COUNTERPARTY IS NOT A BANK DEFAULT ORDERING
834200210712      ** CUSTOMER TO THE CUSTOMER
834300210712      *
834400210712     C     @CBNBI        IFEQ      'N'
834500210712     C     DDROBN        ANDEQ     *BLANKS
834600210712     C     DDROCN        ANDEQ     *BLANKS
834700210712     C                   MOVE      ##CSNM        DDROCN
834800210712     C                   END
834900210712      *
835000210712     C                   ENDSR
835100210712      *****************************************************************
835200210712      /EJECT
835300210712     C*****************************************************************
835400210712     C*
835500210712     C* ACBRCH - ACCESS BRANCH DETAILS
835600210712     C*
835700210712     C*****************************************************************
835800210712     C     ACBRCH        BEGSR
835900210712      *
836000210712     C**********         CALL      'AOBRCHR0'                                                 CGL029
836100210712     C                   CALL      'AOBRCHR1'                                                 CGL029
836200210712     C                   PARM      *BLANKS       @RTCD             7
836300210712     C                   PARM      '*KEY   '     @OPTN             7
836400210712     C                   PARM      @BRCA         @DSNB             3
836500210712     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
836600210712     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
836700210712      *
836800210712     C                   ENDSR
836900210712      *****************************************************************
837000210712      /EJECT
837100210712     C*****************************************************************
837200210712     C*                                                               *
837300210712     C* ACCUST - Access Customer Details                              *
837400210712     C*                                                               *
837500210712     C*****************************************************************
837600210712     C     ACCUST        BEGSR
837700210712      *
837800210712     C/COPY WNCPYSRC,ZASETNVC02
837900210712     C                   CALL      'AOCUSTR0'
838000210712     C                   PARM      *BLANKS       @RTCD             7
838100210712     C                   PARM      '*KEY   '     @OPTN             7
838200210712     C                   PARM                    @CSCN            10
838300210712     C                   PARM                    @KYST             7
838400210712     C     SDCUST        PARM      SDCUST        DSSDY
838500210712      *
838600210712     C                   ENDSR
838700210712     C*********************************************************************
838800210712      /EJECT
838900210712     C*****************************************************************
839000210712     C*
839100210712     C* ACNOST - ACCESS NOSTRO DETAILS
839200210712     C*
839300210712     C*****************************************************************
839400210712     C     ACNOST        BEGSR
839500210712      *
839600210712     C**********         CALL      'AONOSTR0'                                                 CDL094
839700210712     C                   CALL      'AONOSTR1'                                                 CDL094
839800210712     C                   PARM      *BLANKS       @RTCD
839900210712     C                   PARM      '*KEY   '     @OPTN
840000210712     C                   PARM      *BLANKS       @CUST             6
840100210712     C                   PARM                    @CYCD             3
840200210712     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
840300210712     C                   PARM      *BLANKS       @ACCD                                        CGL029
840400210712     C                   PARM      *BLANKS       @ACSN             2
840500210712     C                   PARM                    @NONB             2
840600210712     C                   PARM      *BLANKS       @BRCD             3
840700210712     C                   PARM      *BLANKS       @CSSN            10
840800210712     C                   PARM      *BLANKS       @PNOI             1
840900210712     C*****SDNOST        PARM      SDNOST        DSFDY                                        CDL094
841000210712     C     SDNOST        PARM      SDNOST        DSSDY                                        CDL094
841100210712      *
841200210712     C                   ENDSR
841300210712     C*****************************************************************
841400210712      /EJECT
841500210712     C*****************************************************************
841600210712     C*
841700210712     C* ACACCT - ACCESS ACCOUNT DETAILS
841800210712     C*
841900210712     C*****************************************************************
842000210712     C     ACACCT        BEGSR
842100210712      *
842200210712     C                   CLEAR                   DSSDY                                      MD023833
842300210712     C                   CLEAR                   ACCT                                       MD023833
842400210712     C                   CALL      'AOACCTV0'
842500210712     C                   PARM      *BLANKS       @RTCD             7
842600210712     C                   PARM                    @ACID            10
842700210712     C                   PARM                    @CYCD             3
842800210712     C**********         PARM                    @ACCD             4                          CGL029
842900210712     C                   PARM                    @ACCD                                        CGL029
843000210712     C                   PARM                    @ACSN             2
843100210712     C                   PARM                    @BRCA             3
843200210712     C                   PARM                    @TYPE             7
843300210712     C                   PARM                    @NOSN             2
843400210712     C     ACCT          PARM      ACCT          DSSDY
843500210712     C                   MOVEL     DSSDY         ACCT                                       MD023833
843600210712      *
843700210712     C                   ENDSR
843800210712     C*****************************************************************                      CSF011A
843900210712      /EJECT                                                                                 CSF011A
844000210712     C*****************************************************************                      CSF011A
844100210712      *                                                               *                      CSF011A
844200210712      * CSFACT - Get Customer Details for Account field               *                      CSF011A
844300210712      *                                                               *                      CSF011A
844400210712      *****************************************************************                      CSF011A
844500210712     C     CSFACT        BEGSR                                                               CSF011A
844600210712                                                                                            MD023833
844700210712     C                   MOVE      @RTCD         #RTCD             7                        MD023833
844800210712                                                                                             CSF011A
844900210712     C                   IF        W@TYPE = 'CUST'                                           CSF011A
845000210712     C                   EVAL      @CSCN  = A#CNUM                                           CSF011A
845100210712     C                   ELSE                                                                CSF011A
845200210712     C                   EVAL      @CSCN  = CNUM                                             CSF011A
845300210712     C                   ENDIF                                                               CSF011A
845400210712                                                                                             CSF011A
845500210712     C                   EVAL      W@TYPE = *BLANKS                                          CSF011A
845600210712     C                   EVAL      @KYST = *BLANKS                                           CSF011A
845700210712     C                   EXSR      ACCUST                                                    CSF011A
845800210712                                                                                             CSF011A
845900210712     C                   IF        @RTCD = *BLANKS                                           CSF011A
846000210712                                                                                             CSF011A
846100210712     C                   IF        SETTF = 'P'                                               CSF011A
846200210712     C                   EVAL      DDPSH1 = BBCSSN                                           CSF011A
846300210712     C                   EVAL      DDPRN1 = BBCRNM                                           CSF011A
846400210712     C                   EVAL      DDPRT1 = BBCRTN                                           CSF011A
846500210712     C                   EVAL      DDPAC1 = ANAM                                             CSF011A
846600210712     C                   EVAL      DDPSI1 = BBCSID                                           CSF011A
846700210712     C                   ELSEIF    SETTF = 'R'                                               CSF011A
846800210712     C                   EVAL      DDRSH1 = BBCSSN                                           CSF011A
846900210712     C                   EVAL      DDRRN1 = BBCRNM                                           CSF011A
847000210712     C                   EVAL      DDRRT1 = BBCRTN                                           CSF011A
847100210712     C                   EVAL      DDRAC1 = ANAM                                             CSF011A
847200210712     C                   EVAL      DDRSI1 = BBCSID                                           CSF011A
847300210712     C                   ENDIF                                                               CSF011A
847400210712                                                                                             CSF011A
847500210712     C                   ENDIF                                                               CSF011A
847600210712                                                                                             CSF011A
847700210712     C                   MOVE      #RTCD         @RTCD                                      MD023833
847800210712     C                   ENDSR                                                               CSF011A
847900210712     C*****************************************************************
848000210712      /EJECT
848100210712      *****************************************************************
848200210712      *                                                               *
848300210712      * SRINIT - INITIAL PROCESSING                                   *
848400210712      *                                                               *
848500210712      *****************************************************************
848600210712     C     SRINIT        BEGSR
848700210712      *
848800210712      ** INITIALIZE:
848900210712      *                                                                         CAP003
849000210712      ***Set*up*combined*FRA/IRS indicator                               CAP003 164570
849100210712      ***Validation*check*is same for FRAs and Single and Cross Ccy      CAP003 164570
849200210712      ***IRS*types*(where*differentiation required, use ##TTYP)          CAP003 164570
849300210712     C*****##CALP********IFEQ      'SIRS'                                CAP003 164570
849400210712     C*****##CALP********OREQ      'CIRS'                                CAP003 CAP004
849500210712     C*******************EVAL      ##CALP = 'FRA '                       CAP003 164570
849600210712     C*******************ENDIF                                           CAP003 164570
849700210712      ** Initialize packed fields to zero(0), serious midas error encountered               BUG11240
849800210712      **    in LEMAPYVU                                                                     BUG11240
849900210712     C                   Eval      FLREXR = 0                                               BUG11240
850000210712     C                   Eval      FLPEXR = 0                                               BUG11240
850100210712      *
850200210712      * Beneficiary bank/non-bank
850300210712     C                   MOVEL     *BLANK        @BBNBI            1
850400210712      *
850500210712      * Ordering cust bank/non-bank
850600210712     C                   MOVEL     *BLANK        @OBNBI            1
850700210712      *
850800210712      ** RECEIVE AND PAYMENT ACCOUNTS AND SETTLEMENT BRANCHES
850900210712      ** IF NOT MULTI-BRANCHING
851000210712      *
851100210712     C     @MBIN         IFNE      'Y'
851200210712     C**********         MOVEL     DDRONX        DDRONS           12                          CGL029
851300210712     C     CLE033        IFEQ      'Y'                                                        CLE033
851400210712     C     DDRSTM        ANDNE     '09'                                                       CLE033
851500210712     C                   MOVEL     DDRONX        DDRONS                                       CGL029
851600210712     C                   MOVEL     *BLANKS       DDROBR            3
851700210712     C                   ENDIF                                                                CLE033
851800210712     C**********         MOVEL     DDPONX        DDPONS           12                          CGL029
851900210712     C     CLE033        IFEQ      'Y'                                                        CLE033
852000210712     C     DDPSTM        ANDNE     '09'                                                       CLE033
852100210712     C                   MOVEL     DDPONX        DDPONS                                       CGL029
852200210712     C                   MOVEL     *BLANKS       DDPOBR            3
852300210712     C                   ENDIF                                                                CLE033
852400210712     C                   END
852500210712      *
852600210712      ** RECEIVE AND PAYMENT ACCOUNTS AND SETTLEMENT BRANCHES
852700210712      ** IF MULTI-BRANCHING
852800210712      *
852900210712     C     @MBIN         IFEQ      'Y'
853000210712     C     DDRSTM        IFEQ      '05'
853100210712     C     CLE033        OREQ      'Y'                                                        CLE033
853200210712     C     DDRSTM        ANDEQ     '09'                                                       CLE033
853300210712     C                   MOVE      DDRONX        DDRONS
853400210712     C                   MOVEL     DDRONX        DDROBR
853500210712     C                   ELSE
853600210712     C                   MOVEL     DDRONX        DDRONS
853700210712     C                   MOVEL     *BLANKS       DDROBR
853800210712     C                   END
853900210712     C     DDPSTM        IFEQ      '05'
854000210712     C     CLE033        OREQ      'Y'                                                        CLE033
854100210712     C     DDPSTM        ANDEQ     '09'                                                       CLE033
854200210712     C                   MOVE      DDPONX        DDPONS
854300210712     C                   MOVEL     DDPONX        DDPOBR
854400210712     C                   ELSE
854500210712     C                   MOVEL     DDPONX        DDPONS
854600210712     C                   MOVEL     *BLANKS       DDPOBR
854700210712     C                   END
854800210712     C                   END
854900210712      *
855000210712      ** Initialize Effective Receive and Payment Currencies
855100210712      *
855200210712     C                   MOVEL     ##RCCY        E#RCCY            3
855300210712     C                   MOVEL     ##PCCY        E#PCCY            3
855400210712                                                                                              CRE008
855500210712     C**********         EVAL      WIdx = *ZEROS                                      CRE008 BUG4478
855600210712      *
855700210712      ** Get Counterparty Details
855800210712      *
855900210712     C                   EXSR      CPTYDT
856000210712      *
856100210712     C/COPY WNCPYSRC,ZASETINVC8
856200210712      *
856300210712     C                   MOVEL     DDBENN        @CSCN                                        238721
856400210712     C                   EXSR      ACCUST                                                     238721
856500210712     C     @RTCD         IFEQ      *BLANKS                                                    238721
856600210712     C                   MOVEL     BBSWFI        @BBNBI                                       238721
856700210712     C                   ENDIF                                                                238721
856800210712                                                                                             CSF011A
856900210712      ** Initialise Customer Name on Input fields                                            CSF011A
857000210712                                                                                             CSF011A
857100210712     C                   IF        ##ACTN <> 'X' AND                                         CSF011A
857200210712     C                             ##ACTN <> 'R'                                             CSF011A
857300210712     C                   EVAL      DDPSH1 = *BLANKS                                          CSF011A
857400210712     C                   EVAL      DDPRN1 = *BLANKS                                          CSF011A
857500210712     C                   EVAL      DDPRT1 = *BLANKS                                          CSF011A
857600210712     C                   EVAL      DDPAC1 = *BLANKS                                          CSF011A
857700210712     C                   EVAL      DDPSI1 = *BLANKS                                          CSF011A
857800210712     C                   EVAL      DDPSH2 = *BLANKS                                          CSF011A
857900210712     C                   EVAL      DDPRN2 = *BLANKS                                          CSF011A
858000210712     C                   EVAL      DDPRT2 = *BLANKS                                          CSF011A
858100210712     C                   EVAL      DDPSI2 = *BLANKS                                          CSF011A
858200210712     C                   EVAL      DDPSH3 = *BLANKS                                          CSF011A
858300210712     C                   EVAL      DDPRN3 = *BLANKS                                          CSF011A
858400210712     C                   EVAL      DDPRT3 = *BLANKS                                          CSF011A
858500210712     C                   EVAL      DDPSI3 = *BLANKS                                          CSF011A
858600210712     C                   EVAL      DDPSH4 = *BLANKS                                          CSF011A
858700210712     C                   EVAL      DDPRN4 = *BLANKS                                          CSF011A
858800210712     C                   EVAL      DDPRT4 = *BLANKS                                          CSF011A
858900210712     C                   EVAL      DDPSI4 = *BLANKS                                          CSF011A
859000210712     C                   EVAL      DDPSH5 = *BLANKS                                          CSF011A
859100210712     C                   EVAL      DDPRN5 = *BLANKS                                          CSF011A
859200210712     C                   EVAL      DDPRT5 = *BLANKS                                          CSF011A
859300210712     C                   EVAL      DDPSI5 = *BLANKS                                          CSF011A
859400210712     C                   EVAL      DDPSH6 = *BLANKS                                          CSF011A
859500210712     C                   EVAL      DDPRN6 = *BLANKS                                          CSF011A
859600210712     C                   EVAL      DDPRT6 = *BLANKS                                          CSF011A
859700210712     C                   EVAL      DDPSI6 = *BLANKS                                          CSF011A
859800210712     C                   EVAL      DDPSH7 = *BLANKS                                          CSF011A
859900210712     C                   EVAL      DDPRN7 = *BLANKS                                          CSF011A
860000210712     C                   EVAL      DDPRT7 = *BLANKS                                          CSF011A
860100210712     C                   EVAL      DDPSI7 = *BLANKS                                          CSF011A
860200210712     C                   EVAL      DDPSH8 = *BLANKS                                          CSF011A
860300210712     C                   EVAL      DDPRN8 = *BLANKS                                          CSF011A
860400210712     C                   EVAL      DDPRT8 = *BLANKS                                          CSF011A
860500210712     C                   EVAL      DDPSI8 = *BLANKS                                          CSF011A
860600210712     C                   EVAL      DDRSH1 = *BLANKS                                          CSF011A
860700210712     C                   EVAL      DDRRN1 = *BLANKS                                          CSF011A
860800210712     C                   EVAL      DDRRT1 = *BLANKS                                          CSF011A
860900210712     C                   EVAL      DDRAC1 = *BLANKS                                          CSF011A
861000210712     C                   EVAL      DDRSI1 = *BLANKS                                          CSF011A
861100210712     C                   EVAL      DDRSH2 = *BLANKS                                          CSF011A
861200210712     C                   EVAL      DDRRN2 = *BLANKS                                          CSF011A
861300210712     C                   EVAL      DDRRT2 = *BLANKS                                          CSF011A
861400210712     C                   EVAL      DDRSI2 = *BLANKS                                          CSF011A
861500210712     C                   EVAL      DDRSH3 = *BLANKS                                          CSF011A
861600210712     C                   EVAL      DDRRN3 = *BLANKS                                          CSF011A
861700210712     C                   EVAL      DDRRT3 = *BLANKS                                          CSF011A
861800210712     C                   EVAL      DDRSI3 = *BLANKS                                          CSF011A
861900210712     C                   EVAL      DDRSH4 = *BLANKS                                          CSF011A
862000210712     C                   EVAL      DDRRN4 = *BLANKS                                          CSF011A
862100210712     C                   EVAL      DDRRT4 = *BLANKS                                          CSF011A
862200210712     C                   EVAL      DDRSI4 = *BLANKS                                          CSF011A
862300210712     C                   ENDIF                                                               CSF011A
862400210712                                                                                             CSF011A
862500210712     C                   ENDSR
862600210712     C*****************************************************************
862700210712      /EJECT
862800210712     C*****************************************************************
862900210712     C*                                                               *
863000210712     C* CPTYDT - Get Counterparty Details                             *
863100210712     C*                                                               *
863200210712     C*****************************************************************
863300210712     C     CPTYDT        BEGSR
863400210712      *
863500210712      * GET DEAL COUNTERPARTY DETAILS
863600210712      *
863700210712     C                   MOVEL     ##CSNM        @CSCN
863800210712     C                   EXSR      ACCUST
863900210712      *
864000210712     C     @RTCD         IFNE      *BLANKS
864100210712     C                   MOVEL     ##CSNM        DBKEY
864200210712     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************
864300210712     C                   MOVEL     '800'         DBASE                          * DBERR 800*
864400210712     C                   EXSR      SRERR                                        ************
864500210712     C                   END
864600210712      *
864700210712      * SAVE COUNTERPARTY BANK/NON-BANK IND, SWIFT ID, SHORTNAME & NUMBER
864800210712      *
864900210712     C**********         MOVEL     BBBNBI        @CBNBI            1                          197865
865000210712     C                   MOVEL     BBSWFI        @CBNBI            1                          197865
865100210712     C                   MOVEL     BBCSID        @CCSID           12
865200210712     C                   MOVEL     BBCSSN        @CCSSN           10
865300210712     C                   MOVEL     BBCUST        @CCUST            6
865400210712      *
865500210712     C                   ENDSR
865600210712     C********************************************************************
865700210712     C/COPY WNCPYSRC,ZASETNVC30
865800210712      /EJECT                                                                                  CRE008
865900210712      *****************************************************************                       CRE008
866000210712      *                                                               *                       CRE008
866100210712      * SROvrChk - Overdraft Limit Check for the receive settlement   *                       CRE008
866200210712      *            Account                                            *                       CRE008
866300210712      *                                                               *                       CRE008
866400210712      *****************************************************************                       CRE008
866500210712     C     SROvrChk      BEGSR                                                                CRE008
866600210712                                                                                              CRE008
866700210712     C                   EVAL      PInBranch = WkBRCA                                         CRE008
866800210712     C                   EVAL      PInCust = WkCust                                           CRE008
866900210712     C                   EVAL      PInCurr = WkCcy                                            CRE008
867000210712     C                   EVAL      PInACode = WkACOD                                          CRE008
867100210712     C                   EVAL      PInASeqN = WkASEQ                                          CRE008
867200210712                                                                                              CRE008
867300210712     C                   CALL      'RE101901'                                                 CRE008
867400210712     C                   PARM      *BLANKS       PRetCode                                     CRE008
867500210712     C                   PARM                    PInBranch                                    CRE008
867600210712     C                   PARM                    PInCust                                      CRE008
867700210712     C                   PARM                    PInCurr                                      CRE008
867800210712     C                   PARM                    PInACode                                     CRE008
867900210712     C                   PARM                    PInASeqN                                     CRE008
868000210712     C                   PARM                    PDebAmnt                                     CRE008
868100210712     C                   PARM                    POutBranch                                   CRE008
868200210712     C                   PARM                    POutCust                                     CRE008
868300210712     C                   PARM                    POutCurr                                     CRE008
868400210712     C                   PARM                    POutACode                                    CRE008
868500210712     C                   PARM                    POutASeqN                                    CRE008
868600210712     C                   PARM                    POutRetNo                                    CRE008
868700210712                                                                                              CRE008
868800210712     C                   IF        PRetCode = '*ODLMTX'                                       CRE008
868900210712     C                   MOVE      POutCust      WkCustA                                      CRE008
869000210712     C                   MOVE      POutACode     WkACodeA                                     CRE008
869100210712     C                   MOVE      POutASeqN     WkASeqNA                                     CRE008
869200210712     C                   MOVE      POutRetNo     WkRetNoA                                     CRE008
869300210712     C                   EVAL      WIdx = WIdx + 1                                            CRE008
869400210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONS'                               CRE008
869500210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1949'                                CRE008
869600210712     C                   IF        POutRetNo = *Zeros                                         CRE008
869700210712     C**********         EVAL      WMsgDtaArr(WIdx) = POutBranch + '-' +             CRE008 MD000091
869800210712     C**********                   WkCustA + '-' + POutCurr + '-' +                  CRE008 MD000091
869900210712     C**********                   WkACodeA + '-' + WkASeqNA                         CRE008 MD000091
870000210712     C                   EVAL      MsgDtaTmp = POutBranch + '-' +                           MD000091
870100210712     C                             WkCustA + '-' + POutCurr + '-' +                         MD000091
870200210712     C                             WkACodeA + '-' + WkASeqNA                                MD000091
870300210712     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
870400210712     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(MsgDtaTmp)              MD000091
870500210712     C                   ELSE                                                                 CRE008
870600210712     C**********         EVAL      WMsgDtaArr(WIdx) = POutBranch + '-' +             CRE008 MD000091
870700210712     C**********                   WkCustA + '-' + POutCurr + '-' +                  CRE008 MD000091
870800210712     C**********                   WkACodeA + '-' + WkASeqNA + '/' +                 CRE008 MD000091
870900210712     C**********                   WkRetNoA                                          CRE008 MD000091
871000210712     C                   EVAL      MsgDtaTmp = POutBranch + '-' +                           MD000091
871100210712     C                             WkCustA + '-' + POutCurr + '-' +                         MD000091
871200210712     C                             WkACodeA + '-' + WkASeqNA + '/' +                        MD000091
871300210712     C                             WkRetNoA                                                 MD000091
871400210712     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
871500210712     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(MsgDtaTmp)              MD000091
871600210712     C                   ENDIF                                                                CRE008
871700210712     C                   ENDIF                                                                CRE008
871800210712                                                                                              CRE008
871900210712     C                   ENDSR                                                                CRE008
872000210712      *****************************************************************                       CRE008
872100210712      /EJECT                                                                                  CGL014
872200210712      *****************************************************************                       CGL014
872300210712      *                                                               *                       CGL014
872400210712      *  SRBlockAmt - Validation for Blocked Collateral Amount        *                       CGL014
872500210712      *                                                               *                       CGL014
872600210712      *****************************************************************                       CGL014
872700210712     C     SRBlockAmt    BEGSR                                                                CGL014
872800210712                                                                                              CGL014
872900210712     C                   IN        DLUFBO                                                     CGL014
873000210712                                                                                              CGL014
873100210712      ** If Action code is Insert                                                             CGL014
873200210712                                                                                              CGL014
873300210712     C                   IF        ##ACTN = 'I'                                               CGL014
873400210712                                                                                              CGL014
873500210712      ** Check for Up-Front details                                                           CGL014
873600210712                                                                                              CGL014
873700210712     C                   IF        DLUPPR = 'R' AND DLUPVD <= BJRDNB AND                      CGL014
873800210712     C                             DLUPFE > 0                                                 CGL014
873900210712     C                   EVAL      PAmount = DLUPFE                                           CGL014
874000210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
874100210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
874200210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
874300210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
874400210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
874500210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
874600210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
874700210712     C                   EVAL      WPRInd = 'R'                                               CGL014
874800210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
874900210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
875000210712     C                   ENDIF                                                                CGL014
875100210712     C                   EXSR      SRCallPgm                                                  CGL014
875200210712     C                   ENDIF                                                                CGL014
875300210712                                                                                              CGL014
875400210712      ** Check for Buy-out Details                                                            CGL014
875500210712                                                                                              CGL014
875600210712     C                   IF        DLBOPR = 'R' AND DLBOVD <= BJRDNB AND                      CGL014
875700210712     C                             DLBOAM > 0                                                 CGL014
875800210712     C                   EVAL      PAmount = DLBOAM                                           CGL014
875900210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
876000210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
876100210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
876200210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
876300210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
876400210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
876500210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
876600210712     C                   EVAL      WPRInd = 'R'                                               CGL014
876700210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
876800210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
876900210712     C                   ENDIF                                                                CGL014
877000210712     C                   EXSR      SRCallPgm                                                  CGL014
877100210712     C                   ENDIF                                                                CGL014
877200210712                                                                                              CGL014
877300210712     C                   ENDIF                                                                CGL014
877400210712                                                                                              CGL014
877500210712      ** If Action is Amend                                                                   CGL014
877600210712                                                                                              CGL014
877700210712     C                   IF        ##ACTN = 'A'                                               CGL014
877800210712                                                                                              CGL014
877900210712      ** Retrieve the previous details                                                        CGL014
878000210712                                                                                              CGL014
878100210712     C     DLDLNO        CHAIN     DEALSDGF                                                   CGL014
878200210712     C                   IF        NOT %FOUND(DLDLDGLE)                                       CGL014
878300210712     C     *LOCK         IN        LDA                                                        CGL014
878400210712     C                   EVAL      DBFILE = 'DEALSDG'                                         CGL014
878500210712     C                   EVAL      DBASE = 7                                                  CGL014
878600210712     C                   MOVE      DLDLNO        DBKEY                                        CGL014
878700210712     C                   OUT       LDA                                                        CGL014
878800210712     C                   EXSR      SRERR                                                      CGL014
878900210712     C                   ENDIF                                                                CGL014
879000210712                                                                                              CGL014
879100210712     C                   IF        ##CALP = 'CXSV'                                            CGL014
879200210712     C                   OPEN      DLGXSTL0                                                   CGL014
879300210712     C                   EVAL      KEDCD = 'VAL'                                              CGL014
879400210712     C                   EVAL      KDLNO = DLDLNO                                             CGL014
879500210712     C     KGXST         CHAIN     DLGXSTL0                                                   CGL014
879600210712     C                   IF        NOT %FOUND(DLGXSTL0)                                       CGL014
879700210712     C     *LOCK         IN        LDA                                                        CGL014
879800210712     C                   EVAL      DBFILE = 'DLGXSTPD'                                        CGL014
879900210712     C                   EVAL      DBASE = 8                                                  CGL014
880000210712     C                   MOVE      DLDLNO        DBKEY                                        CGL014
880100210712     C                   OUT       LDA                                                        CGL014
880200210712     C                   EXSR      SRERR                                                      CGL014
880300210712     C                   ENDIF                                                                CGL014
880400210712     C                   CLOSE     DLGXSTL0                                                   CGL014
880500210712     C                   ENDIF                                                                CGL014
880600210712                                                                                              CGL014
880700210712     C                   IF        ##CALP = 'CXSM'                                            CGL014
880800210712     C                   OPEN      DLGXSTL0                                                   CGL014
880900210712     C                   EVAL      KEDCD = 'MAT'                                              CGL014
881000210712     C                   EVAL      KDLNO = DLDLNO                                             CGL014
881100210712     C     KGXST         CHAIN     DLGXSTL0                                                   CGL014
881200210712     C                   IF        NOT %FOUND(DLGXSTL0)                                       CGL014
881300210712     C     *LOCK         IN        LDA                                                        CGL014
881400210712     C                   EVAL      DBFILE = 'DLGXSTPD'                                        CGL014
881500210712     C                   EVAL      DBASE = 9                                                  CGL014
881600210712     C                   MOVE      DLDLNO        DBKEY                                        CGL014
881700210712     C                   OUT       LDA                                                        CGL014
881800210712     C                   EXSR      SRERR                                                      CGL014
881900210712     C                   ENDIF                                                                CGL014
882000210712     C                   CLOSE     DLGXSTL0                                                   CGL014
882100210712     C                   ENDIF                                                                CGL014
882200210712                                                                                              CGL014
882300210712     C                   IF        DLUPVD <= BJRDNB AND P_ORED = BJRDNB OR                    CGL014
882400210712     C                             DLBOVD <= BJRDNB AND P_ORED = BJRDNB                       CGL014
882500210712                                                                                              CGL014
882600210712      ** Up-Front Details checking                                                            CGL014
882700210712                                                                                              CGL014
882800210712     C                   EXSR      SRAmdUpFrt                                                 CGL014
882900210712                                                                                              CGL014
883000210712      ** Buy-out Details checking                                                             CGL014
883100210712                                                                                              CGL014
883200210712     C                   EXSR      SRAmdByOut                                                 CGL014
883300210712                                                                                              CGL014
883400210712     C                   ENDIF                                                                CGL014
883500210712                                                                                              CGL014
883600210712     C                   ENDIF                                                                CGL014
883700210712                                                                                              CGL014
883800210712     C                   ENDSR                                                                CGL014
883900210712      *****************************************************************                       CGL014
884000210712      /EJECT                                                                                  CGL014
884100210712      *****************************************************************                       CGL014
884200210712      *                                                               *                       CGL014
884300210712      *  SRCallPgm - Calls GL00600 to check for Blocked Amount        *                       CGL014
884400210712      *                                                               *                       CGL014
884500210712      *****************************************************************                       CGL014
884600210712     C     SRCallPgm     BEGSR                                                                CGL014
884700210712                                                                                              CGL014
884800210712     C                   CALL      'GL006000'                                                 CGL014
884900210712     C                   PARM                    PAmount                                      CGL014
885000210712     C                   PARM                    PTCCY                                        CGL014
885100210712     C                   PARM                    PBranch                                      CGL014
885200210712     C                   PARM                    PCustNo                                      CGL014
885300210712     C                   PARM                    PCurr                                        CGL014
885400210712     C                   PARM                    PActCode                                     CGL014
885500210712     C                   PARM                    PAcSeq                                       CGL014
885600210712     C                   PARM                    PRetail                                      CGL014
885700210712     C                   PARM                    PRTCD                                        CGL014
885800210712                                                                                              CGL014
885900210712      ** Send error message if available balance is not enough to cover                       CGL014
886000210712      ** blocked amount                                                                       CGL014
886100210712                                                                                              CGL014
886200210712     C                   IF        PRTCD = '*BLKERR'                                          CGL014
886300210712     C                   ADD       1             Idx                                          CGL014
886400210712     C                   EVAL      MsgIDArr(Idx) = 'MMA0862'                                  CGL014
886500210712     C                   IF        WPRInd = 'R'                                               CGL014
886600210712     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 CGL014
886700210712     C                   EVAL      DDRonxOk = 'N'                                             CGL014
886800210712     C                   ELSE                                                                 CGL014
886900210712     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                                 CGL014
887000210712     C                   EVAL      DDPonxOk = 'N'                                             CGL014
887100210712     C                   ENDIF                                                                CGL014
887200210712     C                   ENDIF                                                                CGL014
887300210712                                                                                              CGL014
887400210712      ** Send warning message if minimum balance will be exceeded                             CGL014
887500210712                                                                                              CGL014
887600210712     C                   IF        PRTCD = '*WARN  '                                          CGL014
887700210712     C                   ADD       1             WIdx                                         CGL014
887800210712     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0863'                                CGL014
887900210712     C                   IF        WPRInd = 'R'                                               CGL014
888000210712     C                   EVAL      WFldNameArr(Idx) = 'DDRONX'                                CGL014
888100210712     C                   EVAL      DDRonxOk = 'N'                                             CGL014
888200210712     C                   ELSE                                                                 CGL014
888300210712     C                   EVAL      WFldNameArr(Idx) = 'DDPONX'                                CGL014
888400210712     C                   EVAL      DDPonxOk = 'N'                                             CGL014
888500210712     C                   ENDIF                                                                CGL014
888600210712     C                   ENDIF                                                                CGL014
888700210712                                                                                              CGL014
888800210712     C                   ENDSR                                                                CGL014
888900210712      *****************************************************************                       CGL014
889000210712      /EJECT                                                                                  CGL014
889100210712      *****************************************************************                       CGL014
889200210712      *                                                               *                       CGL014
889300210712      *  SRChkDiff - Check for Amount difference                      *                       CGL014
889400210712      *                                                               *                       CGL014
889500210712      *****************************************************************                       CGL014
889600210712     C     SRChkDiff     BEGSR                                                                CGL014
889700210712                                                                                              CGL014
889800210712     C                   IF        WCurAmt > WPrvAmt                                          CGL014
889900210712     C                   EVAL      WDiff = WCurAmt - WPrvAmt                                  CGL014
890000210712     C                   EVAL      PAmount = WDiff                                            CGL014
890100210712     C                   EXSR      SRCallPgm                                                  CGL014
890200210712     C                   ENDIF                                                                CGL014
890300210712                                                                                              CGL014
890400210712     C                   ENDSR                                                                CGL014
890500210712      *****************************************************************                       CGL014
890600210712      /EJECT                                                                                  CGL014
890700210712      *****************************************************************                       CGL014
890800210712      *                                                               *                       CGL014
890900210712      *  SRAmdUpFrt - Validation for Up-Front Details on Amend        *                       CGL014
891000210712      *                                                               *                       CGL014
891100210712      *****************************************************************                       CGL014
891200210712     C     SRAmdUpFrt    BEGSR                                                                CGL014
891300210712                                                                                              CGL014
891400210712                                                                                              CGL014
891500210712      ** If Pay/Rcv Indicator was changed                                                     CGL014
891600210712                                                                                              CGL014
891700210712     C                   IF        P_UPPR <> DLUPPR                                           CGL014
891800210712     C                   IF        DLUPPR = 'R'                                               CGL014
891900210712                                                                                              CGL014
892000210712      ** If New Receipt Account is not the same as previous accounts                          CGL014
892100210712                                                                                              CGL014
892200210712     C                   IF        DDRONS <> P_RONS AND ##CALP = 'SIRS' OR                    CGL014
892300210712     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSV' OR                  CGL014
892400210712     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSM'                     CGL014
892500210712     C                   EVAL      PAmount = DLUPFE                                           CGL014
892600210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
892700210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
892800210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
892900210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
893000210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
893100210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
893200210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
893300210712     C                   EVAL      WPRInd = 'R'                                               CGL014
893400210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
893500210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
893600210712     C                   ENDIF                                                                CGL014
893700210712     C                   EXSR      SRCallPgm                                                  CGL014
893800210712     C                   ENDIF                                                                CGL014
893900210712                                                                                              CGL014
894000210712      ** If New Receipt Account is the same as Previous Pay Account                           CGL014
894100210712                                                                                              CGL014
894200210712     C                   IF        DDRONS = P_PONS AND ##CALP = 'SIRS' OR                     CGL014
894300210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
894400210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
894500210712     C                   EVAL      WCurAmt = DLUPFE                                           CGL014
894600210712     C                   EVAL      WPrvAmt = P_UPFE                                           CGL014
894700210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
894800210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
894900210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
895000210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
895100210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
895200210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
895300210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
895400210712     C                   EVAL      WPRInd = 'R'                                               CGL014
895500210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
895600210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
895700210712     C                   ENDIF                                                                CGL014
895800210712     C                   EXSR      SRChkDiff                                                  CGL014
895900210712     C                   ENDIF                                                                CGL014
896000210712                                                                                              CGL014
896100210712     C                   ENDIF                                                                CGL014
896200210712     C                   ENDIF                                                                CGL014
896300210712                                                                                              CGL014
896400210712      ** If Pay/Rcv Indicator was not changed                                                 CGL014
896500210712                                                                                              CGL014
896600210712     C                   IF        P_UPPR = DLUPPR                                            CGL014
896700210712                                                                                              CGL014
896800210712      ** If Receive Account was changed                                                       CGL014
896900210712                                                                                              CGL014
897000210712     C                   IF        DDRONS <> P_RONS AND ##CALP = 'SIRS' OR                    CGL014
897100210712     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSV' OR                  CGL014
897200210712     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSM'                     CGL014
897300210712     C                   EVAL      PAmount = DLUPFE                                           CGL014
897400210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
897500210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
897600210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
897700210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
897800210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
897900210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
898000210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
898100210712     C                   EVAL      WPRInd = 'R'                                               CGL014
898200210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
898300210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
898400210712     C                   ENDIF                                                                CGL014
898500210712     C                   EXSR      SRCallPgm                                                  CGL014
898600210712     C                   ENDIF                                                                CGL014
898700210712                                                                                              CGL014
898800210712      ** If Receive Account was not changed                                                   CGL014
898900210712                                                                                              CGL014
899000210712     C                   IF        DDRONS = P_RONS AND ##CALP = 'SIRS' OR                     CGL014
899100210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
899200210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
899300210712     C                   EVAL      WCurAmt = DLUPFE                                           CGL014
899400210712     C                   EVAL      WPrvAmt = P_UPFE                                           CGL014
899500210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
899600210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
899700210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
899800210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
899900210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
900000210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
900100210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
900200210712     C                   EVAL      WPRInd = 'R'                                               CGL014
900300210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
900400210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
900500210712     C                   ENDIF                                                                CGL014
900600210712     C                   EXSR      SRChkDiff                                                  CGL014
900700210712     C                   ENDIF                                                                CGL014
900800210712                                                                                              CGL014
900900210712     C                   ENDIF                                                                CGL014
901000210712                                                                                              CGL014
901100210712     C                   ENDSR                                                                CGL014
901200210712      *****************************************************************                       CGL014
901300210712      /EJECT                                                                                  CGL014
901400210712      *****************************************************************                       CGL014
901500210712      *                                                               *                       CGL014
901600210712      *  SRAmdByOut - Validation for Buy-Out Details on Amend         *                       CGL014
901700210712      *                                                               *                       CGL014
901800210712      *****************************************************************                       CGL014
901900210712     C     SRAmdByOut    BEGSR                                                                CGL014
902000210712                                                                                              CGL014
902100210712                                                                                              CGL014
902200210712      ** If Pay/Rcv Indicator was changed                                                     CGL014
902300210712                                                                                              CGL014
902400210712     C                   IF        P_BAPR <> DLBOPR                                           CGL014
902500210712     C                   IF        DLBOPR = 'R'                                               CGL014
902600210712                                                                                              CGL014
902700210712      ** If New Receipt Account is not the same as previous accounts                          CGL014
902800210712                                                                                              CGL014
902900210712     C                   IF        DDRONS <> P_RONS AND ##CALP = 'SIRS' OR                    CGL014
903000210712     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSV' OR                  CGL014
903100210712     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSM'                     CGL014
903200210712     C                   EVAL      PAmount = DLBOAM                                           CGL014
903300210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
903400210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
903500210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
903600210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
903700210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
903800210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
903900210712     C                   EVAL      WPRInd = 'R'                                               CGL014
904000210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
904100210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
904200210712     C                   ENDIF                                                                CGL014
904300210712     C                   EXSR      SRCallPgm                                                  CGL014
904400210712     C                   ENDIF                                                                CGL014
904500210712                                                                                              CGL014
904600210712      ** If New Receipt Account is the same as Previous Pay Account                           CGL014
904700210712                                                                                              CGL014
904800210712     C                   IF        DDRONS = P_PONS AND ##CALP = 'SIRS' OR                     CGL014
904900210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
905000210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
905100210712     C                   EVAL      WCurAmt = DLBOAM                                           CGL014
905200210712     C                   EVAL      WPrvAmt = P_BOAM                                           CGL014
905300210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
905400210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
905500210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
905600210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
905700210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
905800210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
905900210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
906000210712     C                   EVAL      WPRInd = 'R'                                               CGL014
906100210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
906200210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
906300210712     C                   ENDIF                                                                CGL014
906400210712     C                   EXSR      SRChkDiff                                                  CGL014
906500210712     C                   ENDIF                                                                CGL014
906600210712                                                                                              CGL014
906700210712     C                   ENDIF                                                                CGL014
906800210712     C                   ENDIF                                                                CGL014
906900210712                                                                                              CGL014
907000210712      ** If Pay/Rcv Indicator was not changed                                                 CGL014
907100210712                                                                                              CGL014
907200210712     C                   IF        P_BAPR = DLBOPR                                            CGL014
907300210712                                                                                              CGL014
907400210712      ** If Receive Account was changed                                                       CGL014
907500210712                                                                                              CGL014
907600210712     C                   IF        DDRONS <> P_RONS AND DDRONS <> P_PONS AND                  CGL014
907700210712     C                             ##CALP = 'SIRS' OR                                         CGL014
907800210712     C                             DDRONS <> P_RXPONS AND DDRONS <> P_RXPONS AND              CGL014
907900210712     C                             ##CALP = 'CXSV' OR                                         CGL014
908000210712     C                             DDRONS <> P_RXPONS AND DDRONS <> P_RXPONS AND              CGL014
908100210712     C                             ##CALP = 'CXSM'                                            CGL014
908200210712     C                   EVAL      PAmount = DLBOAM                                           CGL014
908300210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
908400210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
908500210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
908600210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
908700210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
908800210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
908900210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
909000210712     C                   EVAL      WPRInd = 'R'                                               CGL014
909100210712     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
909200210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
909300210712     C                   ENDIF                                                                CGL014
909400210712     C                   EXSR      SRCallPgm                                                  CGL014
909500210712     C                   ENDIF                                                                CGL014
909600210712                                                                                              CGL014
909700210712      ** If Receive Account was not changed                                                   CGL014
909800210712                                                                                              CGL014
909900210712     C                   IF        DDRONS = P_RONS AND ##CALP = 'SIRS' OR                     CGL014
910000210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
910100210712     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
910200210712     C                   EVAL      WCurAmt = DLBOAM                                           CGL014
910300210712     C                   EVAL      WPrvAmt = P_BOAM                                           CGL014
910400210712     C                   EVAL      PTCCY = DLUCCY                                             CGL014
910500210712     C                   EVAL      PBranch = WRcBRCA                                          CGL014
910600210712     C                   EVAL      PCustNo = WRcCust                                          CGL014
910700210712     C                   EVAL      PCurr = WRcCcy                                             CGL014
910800210712     C                   EVAL      PActCode = WRcACOD                                         CGL014
910900210712     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
911000210712     C                   EVAL      PRetail = WRcRetail                                        CGL014
911100210712     C                   EVAL      WPRInd = 'R'                                               CGL014
911200210712     C                   IF        CIR003 = 'Y' AND  ##CALP = 'CXSV'                          CGL014
911300210712     C                   EVAL      PTCCY = DLTCCY                                             CGL014
911400210712     C                   ENDIF                                                                CGL014
911500210712     C                   EXSR      SRChkDiff                                                  CGL014
911600210712     C                   ENDIF                                                                CGL014
911700210712                                                                                              CGL014
911800210712     C                   ENDIF                                                                CGL014
911900210712                                                                                              CGL014
912000210712     C                   ENDSR                                                                CGL014
912100210712      *****************************************************************                     MD036475
912200210712      /EJECT                                                                                MD036475
912300210712      *****************************************************************                     MD036475
912400210712      *                                                               *                     MD036475
912500210712      *  SRExtChkBlkAc - Extra Check on Account for Blocked DR/CR     *                     MD036475
912600210712      *                                                               *                     MD036475
912700210712      *****************************************************************                     MD036475
912800210712     C     SRExtChkBlkAc BEGSR                                                              MD036475
912900210712                                                                                            MD036475
913000210712     C                   IF        ##CALP = 'MAPY'                                          MD036475
913100210712                                                                                            MD036475
913200210712      ** Also check for blocked credit on Receive Side                                      MD036475
913300210712                                                                                            MD036475
913400210712     C     ##PREC        IFNE      'Y'                                                      MD036475
913500210712     C                   TESTB     '3'           RETB                     92                MD036475
913600210712     C     *IN92         IFEQ      '1'                                                      MD036475
913700210712     C**********         ADD       1             Idx                               MD036475 MD052228
913800210712     C**********         EVAL      FldNameArr(Idx) = 'DDRONX'                      MD036475 MD052228
913900210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0992'                       MD036475 MD052228
914000210712     C**********         MOVE      'N'           DDRonxOK                          MD036475 MD052228
914100210712     C                   ADD       1             WIdx                                       MD052228
914200210712     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                             MD052228
914300210712     C                   EVAL      WMsgIDArr(WIdx) = 'ESM0992'                              MD052228
914400210712     C                   MOVE      'W'           DDRonxOK                                   MD052228
914500210712     C                   END                                                                MD036475
914600210712     C                   ENDIF                                                              MD036475
914700210712                                                                                            MD036475
914800210712      ** Also check for blocked debit on Payment Side                                       MD036475
914900210712                                                                                            MD036475
915000210712     C     ##PPAY        IFNE      'Y'                                                      MD036475
915100210712     C                   TESTB     '2'           RETB                     91                MD036475
915200210712     C     *IN91         IFEQ      '1'                                                      MD036475
915300210712     C**********         ADD       1             Idx                               MD036475 MD052228
915400210712     C**********         EVAL      FldNameArr(Idx) = 'DDPONX'                      MD036475 MD052228
915500210712     C**********         EVAL      MsgIDArr(Idx) = 'ESM0991'                       MD036475 MD052228
915600210712     C**********         MOVE      'N'           DDPonxOK                          MD036475 MD052228
915700210712     C                   ADD       1             WIdx                                       MD052228
915800210712     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                             MD052228
915900210712     C                   EVAL      WMsgIDArr(Idx) = 'ESM0991'                               MD052228
916000210712     C                   MOVE      'W'           DDPonxOK                                   MD052228
916100210712     C                   END                                                                MD036475
916200210712     C                   ENDIF                                                              MD036475
916300210712                                                                                            MD036475
916400210712     C                   ENDIF                                                              MD036475
916500210712                                                                                            MD036475
916600210712     C                   ENDSR                                                              MD036475
916700210712      *****************************************************************
916800210712      /EJECT
916900210712      *****************************************************************
917000210712      *                                                               *
917100210712      * *INZSR - Program Initialisation routine                       *
917200210712      *                                                               *
917300210712      * Called by: Main processing                                    *
917400210712      *                                                               *
917500210712      * Calls: None                                                   *
917600210712      *                                                               *
917700210712      *****************************************************************
917800210712     C     *INZSR        BEGSR
917900210712      *
918000210712      * PARAMETERS
918100210712      *
918200210712     C     *ENTRY        PLIST
918300210712     C                   PARM                    RetCodeIn
918400210712
918500210712      * INPUTS
918600210712      ** Code to indicate calling function
918700210712     C                   PARM                    ##CALP            4
918800210712
918900210712      * Payment currency
919000210712     C                   PARM                    ##PCCY            3
919100210712
919200210712      * Receive currency
919300210712     C                   PARM                    ##RCCY            3
919400210712
919500210712      * Customer shortname (or number)
919600210712     C                   PARM                    ##CSNM           10
919700210712
919800210712      * Transaction Type
919900210712     C                   PARM                    ##TTYP            2
920000210712
920100210712      * Federal Funds Ind.
920200210712     C                   PARM                    ##FFND            1
920300210712
920400210712      * Booking branch
920500210712     C                   PARM                    ##BRCA            3
920600210712
920700210712      * Receipt Date
920800210712      * (must = 99999 if no back valuation validation to be done)
920900210712     C                   PARM                    ##DATR            5 0
921000210712
921100210712      * Payment Date
921200210712      * (must = 99999 if no back valuation validation to be done)
921300210712     C                   PARM                    ##DATP            5 0
921400210712
921500210712      * Payment instructions - screen format
921600210712     C                   PARM                    ##PAYS
921700210712
921800210712      * Receive instructions - screen format
921900210712     C                   PARM                    ##RECS
922000210712
922100210712      **FRA/IRS*instructions*-*screen*format***************************                       CSW212
922200210712      * Extended Settlement instructions - screen format                                      CSW212
922300210712     C                   PARM                    ##FRIS
922400210712
922500210712      * Action Code                                                                           185751
922600210712     C                   PARM                    ##ACTN            1                          185751
922700210712      * Protect Payment Field                                                                 196461
922800210712     C                   PARM                    ##PPAY            1                          196461
922900210712      * Protect Receipt Field                                                                 196461
923000210712     C                   PARM                    ##PREC            1                          196461
923100210712                                                                                              185751
923200210712      * OUTPUTS
923300210712
923400210712      * Payment instructions OK
923500210712     C                   PARM                    OKPayment
923600210712
923700210712      * Receive instructions OK
923800210712     C                   PARM                    OKReceive
923900210712
924000210712      * FRA/IRS instructions OK
924100210712     C                   PARM                    OKFRAIRS
924200210712
924300210712      * Error fields/message IDs/message data (arrays) from/to caller
924400210712     C                   PARM                    FldNameArr
924500210712     C                   PARM                    MsgIDArr
924600210712
924700210712      * Array index (3P0) from/to caller
924800210712     C                   PARM                    Idx
924900210712                                                                                              CRE008
925000210712      ** Warning Messages                                                                     CRE008
925100210712     C                   PARM                    WFldNameArr                                  CRE008
925200210712     C                   PARM                    WMsgIdArr                                    CRE008
925300210712     C                   PARM                    WMsgDtaArr                                   CRE008
925400210712     C                   PARM                    WIdx                                         CRE008
925500210712
925600210712      * Payment instructions - file format
925700210712     C                   PARM                    ##PAYF
925800210712
925900210712      * Receive instructions - file format
926000210712     C                   PARM                    ##RECF
926100210712
926200210712      **FRA/IRS*instructions*-*file*format*****************************                       CSW212
926300210712      * Extended Settlement instructions - file format                                        CSW212
926400210712     C                   PARM                    ##FRIF
926500210712      ** Extra Input                                                                          166888
926600210712      ** Action Code used                                                                     166888
926700210712     C                   PARM                    ##ACCD            1                          166888
926800210712      ** Validation Iteration                                                                 166888
926900210712     C                   PARM                    ##ValIter         3                          166888
927000210712      ************                                                                     179510 200400
927100210712      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
927200210712     C************       PARM                    @MORPI                                179510 200400
927300210712      ************                                                                     179510 200400
927400210712      *
927500210712      ** Remove CLEAR of passed parameter values; they will be cleared when
927600210712      ** needed on specific subroutines (PAYMNT, RECEIP, VLFRIR)
927700210712      *
927800210712     C**********         CLEAR                   ##PAYF                              CLE031 MD032089
927900210712     C**********         CLEAR                   ##RECF                              CLE031 MD032089
928000210712     C**********         CLEAR                   ##FRIF                              CLE031 MD032089
928100210712      *
928200210712      ** READ DATA AREA - RUNDAT
928300210712      *
928400210712     C     *DTAARA       DEFINE                  RUNDAT
928500210712     C                   IN        RUNDAT
928600210712      *
928700210712      ** GET BANK DETAILS
928800210712      *
928900210712     C                   CALLB     'AOBANKR0'
929000210712     C                   PARM      *BLANKS       @RTCD             7
929100210712     C                   PARM      '*FIRST  '    @OPTN             7
929200210712     C     SDBANK        PARM      SDBANK        DSFDY
929300210712      *
929400210712      ** DATABASE ERROR
929500210712      *
929600210712     C     @RTCD         IFNE      *BLANKS
929700210712     C                   MOVEL     '*FIRST '     DBKEY
929800210712     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
929900210712     C                   MOVEL     '900'         DBASE                          * DBERR 900*
930000210712     C                   EXSR      SRERR                                        ************
930100210712     C                   END
930200210712      *
930300210712      ** GET GENERAL LEDGER DETAILS
930400210712      *
930500210712     C**********         CALLB     'AOGELRR0'                                                 CGL029
930600210712     C                   CALLB     'AOGELRR1'                                                 CGL029
930700210712     C                   PARM      *BLANKS       @RTCD
930800210712     C                   PARM      '*FIRST  '    @OPTN
930900210712     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
931000210712     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
931100210712      *
931200210712      ** DATABASE ERROR
931300210712      *
931400210712     C     @RTCD         IFNE      *BLANKS
931500210712     C                   MOVEL     '*FIRST '     DBKEY
931600210712     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
931700210712     C                   MOVEL     '901'         DBASE                          * DBERR 900*
931800210712     C                   EXSR      SRERR                                        ************
931900210712     C                   END
932000210712      *
932100210712      ** SET UP BACK VALUE DATE
932200210712      *
932300210712     C*****BJRDNB        SUB       BJBVPD        W#BVDT            5 0          136939
932400210712     C                   Z-ADD     0             W#BVDT            5 0          136939
932500210712      *
932600210712      ** GET TRADING DETAILS
932700210712      *
932800210712     C                   CALLB     'AOTRADR0'
932900210712     C                   PARM      *BLANKS       @RTCD
933000210712     C                   PARM      '*FIRST'      @OPTN
933100210712     C     SDTRAD        PARM      SDTRAD        DSFDY
933200210712      *
933300210712      ** DATABASE ERROR
933400210712      *
933500210712     C     @RTCD         IFNE      *BLANKS
933600210712     C                   MOVEL     '*FIRST '     DBKEY
933700210712     C                   MOVEL     'SDTRADPD'    DBFILE                         ************
933800210712     C                   MOVEL     '902'         DBASE                          * DBERR 901*
933900210712     C                   EXSR      SRERR                                        ************
934000210712     C                   END
934100210712      *
934200210712      ** GET MODULE DETAILS
934300210712      *
934400210712     C                   CALLB     'AOMMODR0'
934500210712     C                   PARM      *BLANKS       @RTCD
934600210712     C                   PARM      '*FIRST'      @OPTN
934700210712     C     SDMMOD        PARM      SDMMOD        DSFDY
934800210712      *
934900210712      ** DATABASE ERROR
935000210712      *
935100210712     C     @RTCD         IFNE      *BLANKS
935200210712     C                   MOVEL     '*FIRST '     DBKEY
935300210712     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
935400210712     C                   MOVEL     '903'         DBASE                          * DBERR 902*
935500210712     C                   EXSR      SRERR                                        ************
935600210712     C                   END
935700210712      *
935800210712      ** GET RETAIL DETAILS
935900210712      *
936000210712     C     BGRTBN        IFEQ      'Y'
936100210712     C     BGIOAC        OREQ      'Y'
936200210712     C                   CALLB     'AORETLR0'
936300210712     C                   PARM      *BLANKS       @RTCD
936400210712     C                   PARM      '*FIRST'      @OPTN
936500210712     C     SDRETL        PARM      SDRETL        DSFDY
936600210712      *
936700210712      ** DATABASE ERROR
936800210712      *
936900210712     C     @RTCD         IFNE      *BLANKS
937000210712     C                   MOVEL     '*FIRST '     DBKEY
937100210712     C                   MOVEL     'SDRETLPD'    DBFILE                         ************
937200210712     C                   MOVEL     '904'         DBASE                          * DBERR 903*
937300210712     C                   EXSR      SRERR                                        ************
937400210712     C                   END
937500210712     C                   END
937600210712      *
937700210712      ** Check if switchable feature CSW005 is switched on.
937800210712      *
937900210712     C                   CALLB     'AOSARDR0'
938000210712     C                   PARM      *BLANKS       @RTCD             7
938100210712     C                   PARM      '*VERIFY'     @OPTN             7
938200210712     C                   PARM      'CSW005'      @SARD             6
938300210712      *
938400210712      ** DATABASE ERROR
938500210712      *
938600210712     C     @RTCD         IFNE      *BLANKS
938700210712     C     @RTCD         ANDNE     '*NRF   '
938800210712     C                   MOVEL     'CSW005'      DBKEY
938900210712     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
939000210712     C                   MOVEL     '905'         DBASE                          * DBERR 904*
939100210712     C                   EXSR      SRERR                                        ************
939200210712     C                   END
939300210712      *
939400210712     C     @RTCD         IFEQ      *BLANKS
939500210712     C                   MOVEL     'Y'           CSW005            1
939600210712     C                   ENDIF
939700210712      *
939800210712      ** Check if switchable feature CSW011 is switched on.
939900210712      *
940000210712     C                   CALLB     'AOSARDR0'
940100210712     C                   PARM      *BLANKS       @RTCD             7
940200210712     C                   PARM      '*VERIFY'     @OPTN             7
940300210712     C                   PARM      'CSW011'      @SARD             6
940400210712      *
940500210712      ** DATABASE ERROR
940600210712      *
940700210712     C     @RTCD         IFNE      *BLANKS
940800210712     C     @RTCD         ANDNE     '*NRF   '
940900210712     C                   MOVEL     'CSW011'      DBKEY
941000210712     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
941100210712     C                   MOVEL     '906'         DBASE                          * DBERR 905*
941200210712     C                   EXSR      SRERR                                        ************
941300210712     C                   END
941400210712      *
941500210712     C     @RTCD         IFEQ      *BLANKS
941600210712     C                   MOVEL     'Y'           CSW011            1
941700210712     C                   ENDIF
941800210712      *                                                                                       CIR003
941900210712      ** Check if switchable feature CIR003 is switched on                                    CIR003
942000210712      *                                                                                       CIR003
942100210712     C                   CALLB     'AOSARDR0'                                                 CIR003
942200210712     C                   PARM      *BLANKS       @RTCD                                        CIR003
942300210712     C                   PARM      '*VERIFY '    @OPTN                                        CIR003
942400210712     C                   PARM      'CIR003'      @SARD                                        CIR003
942500210712     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR003
942600210712      *                                                                                       CIR003
942700210712     C     @RTCD         IFNE      *BLANK                                                     CIR003
942800210712     C     @RTCD         ANDNE     '*NRF   '                                                  CIR003
942900210712     C                   MOVEL     'CIR003'      DBKEY                                        CIR003
943000210712     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR003
943100210712     C                   MOVEL     '002'         DBASE                                        CIR003
943200210712     C                   EXSR      SRERR                                                      CIR003
943300210712     C                   ENDIF                                                                CIR003
943400210712      *                                                                                       CIR003
943500210712     C     @RTCD         IFEQ      *BLANKS                                                    CIR003
943600210712     C                   MOVE      'Y'           CIR003            1                          CIR003
943700210712     C                   ELSE                                                                 CIR003
943800210712     C                   MOVE      'N'           CIR003                                       CIR003
943900210712     C                   ENDIF                                                                CIR003
944000210712      *                                                                         CDL008
944100210712      ** Check if switchable feature CDL008 is switched on                      CDL008
944200210712      *                                                                         CDL008
944300210712     C                   CALLB     'AOSARDR0'                                   CDL008
944400210712     C                   PARM      *BLANKS       @RTCD                          CDL008
944500210712     C                   PARM      '*VERIFY '    @OPTN                          CDL008
944600210712     C                   PARM      'CDL008'      @SARD                          CDL008
944700210712     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
944800210712      *                                                                         CDL008
944900210712     C     @RTCD         IFNE      *BLANK                                       CDL008
945000210712     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
945100210712     C                   MOVEL     'CDL008'      DBKEY                          CDL008
945200210712     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
945300210712     C                   MOVEL     '001'         DBASE                          CDL008
945400210712     C                   EXSR      SRERR                                        CDL008
945500210712     C                   ENDIF                                                  CDL008
945600210712      *                                                                         CDL008
945700210712     C     @RTCD         IFEQ      *BLANKS                                      CDL008
945800210712     C                   MOVE      'Y'           CDL008            1            CDL008
945900210712     C                   ELSE                                                   CDL008
946000210712     C                   MOVE      'N'           CDL008                         CDL008
946100210712     C                   ENDIF                                                  CDL008
946200210712                                                                                              CRE008
946300210712      ** Check if Cash Management is installed                                                CRE008
946400210712                                                                                              CRE008
946500210712     C                   CALL      'AOSARDR0'                                                 CRE008
946600210712     C                   PARM      *BLANKS       @RTCD                                        CRE008
946700210712     C                   PARM      '*VERIFY '    @OPTN                                        CRE008
946800210712     C                   PARM      'CRE008'      @SARD                                        CRE008
946900210712     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
947000210712                                                                                              CRE008
947100210712     C                   IF        @RTCD = *Blanks                                            CRE008
947200210712     C                   EVAL      CRE008 = 'Y'                                               CRE008
947300210712     C                   ELSE                                                                 CRE008
947400210712     C                   EVAL      CRE008 = 'N'                                               CRE008
947500210712     C                   IF        @RTCD <> '*NRF   '                                         CRE008
947600210712     C                   EVAL      DBKEY = 'CRE008'                                           CRE008
947700210712     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE008
947800210712     C                   EVAL      DBASE = 3                                                  CRE008
947900210712     C                   EXSR      SRERR                                                      CRE008
948000210712     C                   ENDIF                                                                CRE008
948100210712     C                   ENDIF                                                                CRE008
948200210712                                                                                              219241
948300210712      ** Check if switchable feature CFT013 is switched on                                    219241
948400210712                                                                                              219241
948500210712     C                   CALLB     'AOSARDR0'                                                 219241
948600210712     C                   PARM      *BLANKS       @RTCD                                        219241
948700210712     C                   PARM      '*VERIFY '    @OPTN                                        219241
948800210712     C                   PARM      'CFT013'      @SARD                                        219241
948900210712     C     SCSARD        PARM      SCSARD        DSFDY                                        219241
949000210712      *                                                                                       219241
949100210712     C                   IF        @RTCD <> *BLANK                                            219241
949200210712     C                             AND @RTCD <> '*NRF   '                                     219241
949300210712     C                   EVAL      DBKEY = 'CFT013'                                           219241
949400210712     C                   EVAL      DBFILE = 'SCSARDPD'                                        219241
949500210712     C                   EVAL      DBASE = 3                                                  219241
949600210712     C                   EXSR      SRERR                                                      219241
949700210712     C                   ENDIF                                                                219241
949800210712      *                                                                                       219241
949900210712     C                   IF        @RTCD = *BLANKS                                            219241
950000210712     C                   EVAL      CFT013 = 'Y'                                               219241
950100210712     C                   ELSE                                                                 219241
950200210712     C                   EVAL      CFT013 = 'N'                                               219241
950300210712     C                   ENDIF                                                                219241
950400210712                                                                                              219241
950500210712      ** Get Message Management Details if CFT013 is installed.                               219241
950600210712                                                                                              219241
950700210712     C                   IF        CFT013 = 'Y'                                               219241
950800210712                                                                                              219241
950900210712     C                   CALL      'AOMGMER1'                                                 219241
951000210712     C                   PARM      *BLANKS       @RTCD                                        219241
951100210712     C                   PARM      '*FIRST'      @OPTN                                        219241
951200210712     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
951300210712                                                                                              219241
951400210712     C                   IF        @RTCD <> *BLANKS                                           219241
951500210712     C                   EVAL      DBKEY = @OPTN                                              219241
951600210712     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
951700210712     C                   EVAL      DBASE = 4                                                  219241
951800210712     C                   EXSR      SRERR                                                      219241
951900210712     C                   ENDIF                                                                219241
952000210712                                                                                              219241
952100210712     C                   ENDIF                                                                219241
952200210712                                                                                              CMG003
952300210712      ** Check if switchable feature CMG003 is switched on                                    CMG003
952400210712                                                                                              CMG003
952500210712     C                   CALLB     'AOSARDR0'                                                 CMG003
952600210712     C                   PARM      *BLANKS       @RTCD                                        CMG003
952700210712     C                   PARM      '*VERIFY '    @OPTN                                        CMG003
952800210712     C                   PARM      'CMG003'      @SARD                                        CMG003
952900210712     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG003
953000210712                                                                                              CMG003
953100210712     C                   IF        @RTCD <> *BLANK                                            CMG003
953200210712     C                             AND @RTCD <> '*NRF   '                                     CMG003
953300210712     C                   EVAL      DBKEY  = 'CMG003'                                          CMG003
953400210712     C                   EVAL      DBFILE = 'SCSARDPD'                                        CMG003
953500210712     C                   EVAL      DBASE  = 700                                               CMG003
953600210712     C                   EXSR      SRERR                                                      CMG003
953700210712     C                   ENDIF                                                                CMG003
953800210712                                                                                              CMG003
953900210712     C                   IF        @RTCD = *BLANKS                                            CMG003
954000210712     C                   EVAL      CMG003 = 'Y'                                               CMG003
954100210712     C                   ELSE                                                                 CMG003
954200210712     C                   EVAL      CMG003 = 'N'                                               CMG003
954300210712     C                   ENDIF                                                                CMG003
954400210712                                                                                              CDL018
954500210712      ** Access SAR details file to determine if CDL018 is switched on                        CDL018
954600210712      ** (Multiple Settlement Accounts on Loans/Deposit)                                      CDL018
954700210712                                                                                              CDL018
954800210712     C                   CallB     'AOSARDR0'                                                 CDL018
954900210712     C                   Parm      *Blanks       @RTCD                                        CDL018
955000210712     C                   Parm      '*VERIFY'     @OPTN                                        CDL018
955100210712     C                   Parm      'CDL018'      @SARD                                        CDL018
955200210712     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL018
955300210712      *                                                                                       CDL018
955400210712     C                   Move      'N'           CDL018            1                          CDL018
955500210712     C                   If        PRTCD = *Blanks                                            CDL018
955600210712     C                   Eval      CDL018 = 'Y'                                               CDL018
955700210712     C                   Endif                                                                CDL018
955800210712
955900210712      ** Access SAR details file to determine if CDL036 is switched on                        CDL036
956000210712      ** (CLS Enhancements 2)                                                                 CDL036
956100210712     C                   CallB     'AOSARDR0'                                                 CDL036
956200210712     C                   Parm      *Blanks       @RTCD                                        CDL036
956300210712     C                   Parm      '*VERIFY'     @OPTN                                        CDL036
956400210712     C                   Parm      'CDL036'      @SARD                                        CDL036
956500210712     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL036
956600210712      *                                                                                       CDL036
956700210712     C                   Move      'N'           CDL036            1                          CDL036
956800210712     C                   If        PRTCD = *Blanks                                            CDL036
956900210712     C                   Eval      CDL036 = 'Y'                                               CDL036
957000210712     C                   Endif                                                                CDL036
957100210712                                                                                              CDL036
957200210712      *                                                                                       CLE031
957300210712      ** Access SAR details file to determine if CLE031 is switched on                        CLE031
957400210712      ** (Settlement Currency and Exchange Rate)                                              CLE031
957500210712      *                                                                                       CLE031
957600210712     C                   CallB     'AOSARDR0'                                                 CLE031
957700210712     C                   Parm      *Blanks       @RTCD                                        CLE031
957800210712     C                   Parm      '*VERIFY'     @OPTN                                        CLE031
957900210712     C                   Parm      'CLE031'      @SARD                                        CLE031
958000210712     C     SCSARD        Parm      SCSARD        DSFDY                                        CLE031
958100210712      *                                                                                       CLE031
958200210712     C                   Move      'N'           CLE031            1                          CLE031
958300210712     C                   If        @RTCD = *Blanks                                            CLE031
958400210712     C                   Eval      CLE031 = 'Y'                                               CLE031
958500210712     C                   Endif                                                                CLE031
958600210712      *                                                                                       CLE033
958700210712      ** Access SAR details file to determine if CLE033 is switched on                        CLE033
958800210712      *                                                                                       CLE033
958900210712     C                   CallB     'AOSARDR0'                                                 CLE033
959000210712     C                   Parm      *Blanks       @RTCD                                        CLE033
959100210712     C                   Parm      '*VERIFY'     @OPTN                                        CLE033
959200210712     C                   Parm      'CLE033'      @SARD                                        CLE033
959300210712     C     SCSARD        Parm      SCSARD        DSFDY                                        CLE033
959400210712      *                                                                                       CLE033
959500210712     C                   Move      'N'           CLE033            1                          CLE033
959600210712     C                   If        @RTCD = *Blanks                                            CLE033
959700210712     C                   Eval      CLE033 = 'Y'                                               CLE033
959800210712      *                                                                                       CLE033
959900210712     C                   CALLB     'AOSVALR0'                                                 CLE033
960000210712     C                   PARM      *BLANKS       @RTCD                                        CLE033
960100210712     C                   PARM      SVAL(1)       P@OP01           20                          CLE033
960200210712     C                   PARM      *BLANKS       P@VL01          200                          CLE033
960300210712     C                   PARM      SVAL(2)       P@OP02           20                          CLE033
960400210712     C                   PARM      *BLANKS       P@VL02          200                          CLE033
960500210712     C                   PARM      SVAL(3)       P@OP03           20                          CLE033
960600210712     C                   PARM      *BLANKS       P@VL03          200                          CLE033
960700210712     C                   PARM      SVAL(4)       P@OP04           20                          CLE033
960800210712     C                   PARM      *BLANKS       P@VL04          200                          CLE033
960900210712     C                   PARM      *BLANKS       P@OP05           20                          CLE033
961000210712     C                   PARM      *BLANKS       P@VL05          200                          CLE033
961100210712     C                   PARM      *BLANKS       P@OP06           20                          CLE033
961200210712     C                   PARM      *BLANKS       P@VL06          200                          CLE033
961300210712     C                   PARM      *BLANKS       P@OP07           20                          CLE033
961400210712     C                   PARM      *BLANKS       P@VL07          200                          CLE033
961500210712     C                   PARM      *BLANKS       P@OP08           20                          CLE033
961600210712     C                   PARM      *BLANKS       P@VL08          200                          CLE033
961700210712     C                   PARM      *BLANKS       P@OP09           20                          CLE033
961800210712     C                   PARM      *BLANKS       P@VL09          200                          CLE033
961900210712     C                   PARM      *BLANKS       P@OP10           20                          CLE033
962000210712     C                   PARM      *BLANKS       P@VL10          200                          CLE033
962100210712      *                                                                                       CLE033
962200210712     C     @RTCD         IFNE      *BLANK                                                     CLE033
962300210712     C                   MOVEL     ##CSNM        DBKEY                                        CLE033
962400210712     C                   MOVEL     'SDSVALPD'    DBFILE                         ************  CLE033
962500210712     C                   MOVEL     '10'          DBASE                          * DBERR 10 *  CLE033
962600210712     C                   EXSR      SRERR                                        ************  CLE033
962700210712     C                   ENDIF                                                                CLE033
962800210712      *                                                                                       CLE033
962900210712     C                   MOVEL     P@VL02        W0ACOD           10                          CLE033
963000210712      *                                                                                       CLE033
963100210712      ** Save value of Settlement09Postings in a one character field                          CLE033
963200210712      *                                                                                       CLE033
963300210712     C                   MOVEL     P@VL04        SET09             1                          CLE033
963400210712      *                                                                                       CLE033
963500210712     C                   CALLB     'AOACODR0'                                                 CLE033
963600210712     C                   PARM      *BLANKS       @RTCD                                        CLE033
963700210712     C                   PARM      '*KEY    '    @OPTN                                        CLE033
963800210712     C                   PARM      W0ACOD        @ACCD                                        CLE033
963900210712     C     SDACOD        PARM      SDACOD        DSSDY                                        CLE033
964000210712      *                                                                                       CLE033
964100210712     C     @RTCD         IFNE      *BLANK                                                     CLE033
964200210712     C                   MOVEL     W0ACOD        DBKEY                                        CLE033
964300210712     C                   MOVEL     'SDACODPD'    DBFILE                         ************  CLE033
964400210712     C                   MOVEL     '11'          DBASE                          * DBERR 11 *  CLE033
964500210712     C                   EXSR      SRERR                                        ************  CLE033
964600210712     C                   ENDIF                                                                CLE033
964700210712      *                                                                                       CLE033
964800210712     C                   Endif                                                                CLE033
964900210712      *                                                                                       CDL094
965000210712      ** Access SAR details file to determine if CDL094 is switched on                        CDL094
965100210712      ** (Enhanced Receive Settlement Instructions)                                           CDL094
965200210712                                                                                              CDL094
965300210712     C                   CallB     'AOSARDR0'                                                 CDL094
965400210712     C                   Parm      *Blanks       @RTCD                                        CDL094
965500210712     C                   Parm      '*VERIFY'     @OPTN                                        CDL094
965600210712     C                   Parm      'CDL094'      @SARD                                        CDL094
965700210712     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL094
965800210712      *                                                                                       CDL094
965900210712     C                   Move      'N'           CDL094            1                          CDL094
966000210712     C                   If        PRTCD = *Blanks                                            CDL094
966100210712     C                   Eval      CDL094 = 'Y'                                               CDL094
966200210712     C                   Endif                                                                CDL094
966300210712                                                                                              CDL094
966400210712     C     *LIKE         DEFINE    A6SPRT        ARSPRT                                       CLE031
966500210712     C     *LIKE         DEFINE    A6SPRT        APSPRT                                       CLE031
966600210712     C     *LIKE         DEFINE    A6SPRT        AMREXR                                       CLE031
966700210712     C     *LIKE         DEFINE    A6SPRT        AMPEXR                                       CLE031
966800210712     C     *LIKE         DEFINE    A6MDIN        ARMDIN                                       CLE031
966900210712     C     *LIKE         DEFINE    A6MDIN        APMDIN                                       CLE031
967000210712     C     *LIKE         DEFINE    A6MDIN        AMREXI                                       CLE031
967100210712     C     *LIKE         DEFINE    A6MDIN        AMPEXI                                       CLE031
967200210712      ** Check if SWIFT 2000 Changes is on.                                     CSW200
967300210712                                                                                CSW200
967400210712     C                   CALL      'SWIF2000'                                   CSW200
967500210712     C                   PARM      *BLANKS       @RTCD                          CSW200
967600210712      *                                                                         CSW200
967700210712     C                   MOVEL     'N'           CSW200            1            CSW200
967800210712     C     @RTCD         IFEQ      'CSW200'                                     CSW200
967900210712     C                   MOVEL     'Y'           CSW200                         CSW200
968000210712     C                   ENDIF                                                  CSW200
968100210712      *                                                                                       CSW201
968200210712      ** Check if SWIFT 2001 Changes is on.                                                   CSW201
968300210712      *                                                                                       CSW201
968400210712     C                   CALL      'SWIF2001'                                                 CSW201
968500210712     C                   PARM      *BLANKS       @RTCD                                        CSW201
968600210712      *                                                                                       CSW201
968700210712     C     @RTCD         IFEQ      'CSW2001'                                                  CSW201
968800210712     C                   MOVEL     'Y'           CSW201            1                          CSW201
968900210712     C                   ELSE                                                                 CSW201
969000210712     C                   MOVEL     'N'           CSW201                                       CSW201
969100210712     C                   ENDIF                                                                CSW201
969200210712      *                                                                                       CSW201
969300210712      ** Check if SWIFT 2002 Changes is on.                                                   CSW202
969400210712      *                                                                                       CSW202
969500210712     C                   CALL      'SWIF2002'                                                 CSW202
969600210712     C                   PARM      *BLANKS       @RTCD                                        CSW202
969700210712      *                                                                                       CSW202
969800210712     C     @RTCD         IFEQ      'CSW2002'                                                  CSW202
969900210712     C                   MOVEL     'Y'           CSW202            1                          CSW202
970000210712     C                   ELSE                                                                 CSW202
970100210712     C                   MOVEL     'N'           CSW202                                       CSW202
970200210712     C                   ENDIF                                                                CSW202
970300210712      *                                                                                       CSW202
970400210712      ** Call SWIF2003 to check if CSW203 is installed                                        CSW203
970500210712                                                                                              CSW203
970600210712     C                   CALL      'SWIF2003'                                                 CSW203
970700210712     C                   PARM      *BLANKS       PRTCD                                        CSW203
970800210712                                                                                              CSW203
970900210712      ** If ret. code is "CSW2003", set CSW203 flag to "Y", else set it to "N"                CSW203
971000210712                                                                                              CSW203
971100210712     C                   IF        PRTCD = 'CSW2003'                                          CSW203
971200210712     C                   EVAL      CSW203 = 'Y'                                               CSW203
971300210712     C                   ELSE                                                                 CSW203
971400210712     C                   EVAL      CSW203 = 'N'                                               CSW203
971500210712     C                   ENDIF                                                                CSW203
971600210712                                                                                              CSW203
971700210712     C/COPY WNCPYSRC,ZAH00053
971800210712      ** Check if Collaterals Processing is installed                                         CGL014
971900210712                                                                                              CGL014
972000210712     C                   CALL      'AOSARDR0'                                                 CGL014
972100210712     C                   PARM      *BLANKS       @RTCD                                        CGL014
972200210712     C                   PARM      '*VERIFY '    @OPTN                                        CGL014
972300210712     C                   PARM      'CGL014'      @SARD                                        CGL014
972400210712     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
972500210712                                                                                              CGL014
972600210712     C                   IF        @RTCD = *Blanks                                            CGL014
972700210712     C                   EVAL      CGL014 = 'Y'                                               CGL014
972800210712     C                   ELSE                                                                 CGL014
972900210712     C                   EVAL      CGL014 = 'N'                                               CGL014
973000210712     C                   IF        @RTCD <> '*NRF   '                                         CGL014
973100210712     C                   EVAL      DBKEY = 'CGL014'                                           CGL014
973200210712     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
973300210712     C                   EVAL      DBASE = 6                                                  CGL014
973400210712     C                   EXSR      SRERR                                                      CGL014
973500210712     C                   ENDIF                                                                CGL014
973600210712     C                   ENDIF                                                                CGL014
973700210712                                                                                              CGL014
973800210712     C     KGXST         KLIST                                                                CGL014
973900210712     C                   KFLD                    KDLNO                                        CGL014
974000210712     C                   KFLD                    KEDCD                                        CGL014
974100210712      *                                                                                       CSW212
974200210712      ** Check if SWIFT 2012 is on                                                            CSW212
974300210712      *                                                                                       CSW212
974400210712     C                   CALL      'SWIF2012'                                                 CSW212
974500210712     C                   PARM      *BLANKS       @RTCD                                        CSW212
974600210712      *                                                                                       CSW212
974700210712     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
974800210712     C                   MOVEL     'Y'           CSW212            1                          CSW212
974900210712     C                   ELSE                                                                 CSW212
975000210712     C                   MOVEL     'N'           CSW212                                       CSW212
975100210712     C                   ENDIF                                                                CSW212
975200210712      *                                                                                       CSW212
975300210712      ** Check if SWIFT 2013  is on                                                           CSW213
975400210712      *                                                                                       CSW213
975500210712     C                   CALL      'SWIF2013'                                                 CSW213
975600210712     C                   PARM      *BLANKS       @RTCD                                        CSW213
975700210712      *                                                                                       CSW213
975800210712     C     @RTCD         IFEQ      'CSW2013'                                                  CSW213
975900210712     C                   MOVEL     'Y'           CSW213            1                          CSW213
976000210712     C                   ELSE                                                                 CSW213
976100210712     C                   MOVEL     'N'           CSW213                                       CSW213
976200210712     C                   ENDIF                                                                CSW213
976300210712      *                                                                                       CSW213
976400210712                                                                                              CSW203
976500210712      *                                                                                       CSW214
976600210712      ** Check if SWIFT 2014  is on                                                           CSW214
976700210712      *                                                                                       CSW214
976800210712     C                   CALL      'SWIF2014'                                                 CSW214
976900210712     C                   PARM      *BLANKS       PRTCD                                        CSW214
977000210712      *                                                                                       CSW214
977100210712     C                   IF        PRTCD = 'CSW2014'                                          CSW214
977200210712     C                   EVAL      CSW214 = 'Y'                                               CSW214
977300210712     C                   ELSE                                                                 CSW214
977400210712     C                   EVAL      CSW214 = 'N'                                               CSW214
977500210712     C                   ENDIF                                                                CSW214
977600210712      *                                                                                       CSW214
977700210712      *                                                                                       CSW214
977800210712      *                                                                                       CSW221
977900210712      ** Check if SWIFT2021 is enabled                                                        CSW221
978000210712      *                                                                                       CSW221
978100210712     C                   EVAL      CSW221 = 'N'                                               CSW221
978200210712     C                   CALL      'SWIFTACTV'                                                CSW221
978300210712     C                   PARM      'CSW221'      PSWIFT                                       CSW221
978400210712     C                   PARM      *BLANKS       PMReturnCode                                 CSW221
978500210712      *                                                                                       CSW221
978600210712     C                   IF        PMReturnCode = 'CSWACTV'                                   CSW221
978700210712     C                   EVAL      CSW221 = 'Y'                                               CSW221
978800210712     C                   ELSE                                                                 CSW221
978900210712     C                   EVAL      CSW221 = 'N'                                               CSW221
979000210712     C                   ENDIF                                                                CSW221
979100210712     C/COPY WNCPYSRC,ZASETINV21                                                               CUT009
979200210712      *                                                                                       CLE168
979300210712      ** Access SAR details file                                                              CLE168
979400210712      *                                                                                       CLE168
979500210712     C                   CALLB     'AOSARDR0'                                                 CLE168
979600210712     C                   PARM      *BLANKS       @RTCD                                        CLE168
979700210712     C                   PARM      '*VERIFY'     @OPTN                                        CLE168
979800210712     C                   PARM      'CLE168'      @SARD                                        CLE168
979900210712     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE168
980000210712                                                                                              CLE168
980100210712     C                   IF        @RTCD = *BLANK                                             CLE168
980200210712     C                   MOVEL     'Y'           CLE168            1                          CLE168
980300210712     C                   ELSE                                                                 CLE168
980400210712     C                   MOVEL     'N'           CLE168                                       CLE168
980500210712     C                   ENDIF                                                                CLE168
980600210712      *                                                                                       CLE168
980700210712      ** Access SAR details file for CDL051                                                   CDL051
980800210712      *                                                                                       CDL051
980900210712     C                   CALLB     'AOSARDR0'                                                 CDL051
981000210712     C                   PARM      *BLANKS       @RTCD                                        CDL051
981100210712     C                   PARM      '*VERIFY'     @OPTN                                        CDL051
981200210712     C                   PARM      'CDL051'      @SARD                                        CDL051
981300210712     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL051
981400210712                                                                                              CDL051
981500210712     C                   IF        @RTCD = *BLANK                                             CDL051
981600210712     C                   MOVEL     'Y'           CDL051            1                          CDL051
981700210712     C                   ELSE                                                                 CDL051
981800210712     C                   MOVEL     'N'           CDL051                                       CDL051
981900210712     C                   ENDIF                                                                CDL051
982000210712      *                                                                                       CDL051
982100210712      *                                                                         CSW200
982200210712     C                   ENDSR
982300210712     C*****************************************************************
982400210712      /EJECT
982500210712     C*****************************************************************
982600210712     C/COPY WNCPYSRC,ZASETINVC9
982700210712     C*****************************************************
982800210712     C*                                                   *
982900210712     C* SRERR - EXCEPTION ERRORS                          *
983000210712     C*                                                   *
983100210712     C*****************************************************
983200210712     C     SRERR         BEGSR
983300210712     C*
983400210712     C                   MOVEL     '*ERROR '     RetCodeIn
983500210712     C                   MOVEL     'ZASETINVAL'  DBPGM
983600210712     C                   MOVE      '1'           *INU7
983700210712     C                   MOVE      '1'           *INU8
983800210712     C                   MOVE      '1'           *INLR
983900210712     C                   DUMP
984000210712     C*
984100210712     C**  TERMINATE THE PROGRAM
984200210712     C*
984300210712     C                   RETURN
984400210712     C*
984500210712     C                   ENDSR
984600210712     C*****************************************************
984700210712**  CPY@
984800210712(c) Finastra International Limited 2001
984900210712**   SVAL  -  SYSTEM VALUES ARRAY                                                             CLE033
985000210712Settlement09Customer                                                                          CLE033
985100210712Settlement09AccCode                                                                           CLE033
985200210712Settlement09Hostpgm                                                                           CLE033
985300210712Settlement09Postings                                                                          CLE033
