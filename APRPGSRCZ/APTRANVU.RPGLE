000100200528     H COPYRIGHT('(c) Finastra International Limited 2003')
000200200528      *****************************************************************
000300200528/*STD *  RPGBASEMOD                                                   *
000400200528/*EXI *  TEXT('Midas AP Validate and update')                         *
000500200528      *****************************************************************
000600200528      *                                                               *
000700200528      *  Midas - Application Programming Interfaces module            *
000800200528      *                                                               *
000900200528      *  APTRANVU - Transaction Validate and Update                   *
001000200528      *                                                               *
001100200528      *  Function: This module is used to validate and update         *
001200200528      *            transactions in the Midas database.                *
001300200528      *                                                               *
001400200528      *  (c) Finastra International Limited 2003                      *
001500200528      *                                                               *
001600200604      *  Last Amend No. 260173             Date 22May20               *
001700200528      *  Prev Amend No. MD054696           Date 29Oct19               *
001800200528      *                 MD054538           Date 08Oct19               *
001900200528      *                 MD054028           Date 05Sep19               *
002000200528      *                 CER050             Date 16Jun19               *
002100200528      *                 MD052075           Date 07Jun19               *
002200200528      *                 CSD102             Date 08Jan19               *
002300200528      *                 MD050928A          Date 28Jun18               *
002400200528      *                 MD050928           Date 15May18               *
002500200528      *                 MD050345           Date 04Apr18               *
002600200528      *                 MD050342           Date 04Apr18               *
002700200528      *                 CGL157             Date 17Aug15               *
002800200528      *                 CFT163             Date 04May18               *
002900200528      *                 MD044880           Date 15Jan18               *
003000200528      *                 MD046248           Date 27Oct17               *
003100200528      *                 CDL099             Date 03Nov17               *
003200200528      *                 MD041996           Date 12Oct16               *
003300200528      *                 MD042042           Date 14Feb17               *
003400200528      *                 MD042033           Date 30Sep16               *
003500200528      *                 MD043890           Date 06Feb17               *
003600200528      *                 MD039986           Date 10Aug16               *
003700200528      *                 AR1090283          Date 10Aug16               *
003800200528      *                 CSW216             Date 14Mar16               *
003900200528      *                 AR701789           Date 26Sep16               *
004000200528      *                 MD038485           Date 10Aug16               *
004100200528      *                 CER071             Date 01Aug16               *
004200200528      *                 CLE141             Date 08Feb16               *
004300200528      *                 AR316373           Date 03Jun15               *
004400200528      *                 LLN022             Date 03Jun15               *
004500200528      *                 AR702532           Date 13Jan15               *
004600200528      *                 CAP212             Date 15Sep14               *
004700200528      *                 CGL158             Date 16Sep14               *
004800200528      *                 CRE101             Date 27Aug14               *
004900200528      *                 CGL165             Date 17Mar15               *
005000200528      *                 MD030621           Date 26Feb15               *
005100200528      *                 CLE164             Date 18Aug14               *
005200200528      *                 CDL096             Date 24Nov14               *
005300200528      *                 CSW214             Date 25Nov14               *
005400200528      *                 MD030454           Date 29Sep14               *
005500200528      *                 CFT157             Date 29Aug14               *
005600200528      *                 MD029663           Date 13Aug14               *
005700200528      *                 CDL094             Date 11Jun14               *
005800200528      *                 MD026979           Date 09Jun14               *
005900200528      *                 CIR017             Date 10Apr14               *
006000200528      *                 CGL132             Date 01May13               *
006100200528      *                 CSD092             Date 01Apr13               *
006200200528      *                 CSD093             Date 10Mar14               *
006300200528      *                 MD024631           Date 12Feb14               *
006400200528      *                 MD023331           Date 08Nov13               *
006500200528      *                 CGL135A            Date 10Jul13               *
006600200528      *                 CAP090             Date 10Jul13               *
006700200528      *                 AR1086546          Date 18Jun13               *
006800200528      *                 MD022093           Date 01Sep13               *
006900200528      *                 CSW213             Date 03Jun13               *
007000200528      *                 MD020733           Date 14Jun13               *
007100200528      *                 MD000091           Date 03May13               *
007200200528      *                 MD020445           Date 16May13               *
007300200528      *                 AR1080805          Date 25Feb13               *
007400200528      *                 AR910559           Date 10Dec12               *
007500200528      *                 AR804863           Date 10Dec12               *
007600200528      *                 CAP210             Date 28Sep12               *
007700200528      *                 CFT120             Date 28Sep12               *
007800200528      *                 CFT039             Date 28Sep12               *
007900200528      *                 AR1021983          Date 01Aug12               *
008000200528      *                 CLE134             Date 01Aug12               *
008100200528      *                 CSW212             Date 03May12               *
008200200528      *                 AR1005984          Date 18Jul12               *
008300200528      *                 AR1005162          Date 16Jul12               *
008400200528      *                 AR1002463          Date 11Jul12               *
008500200528      *                 AR971184           Date 28May12               *
008600200528      *                 CSC054             Date 23Feb12               *
008700200528      *                 AR946674           Date 03Apr12               *
008800200528      *                 CSF011A            Date 28Nov11               *
008900200528      *                 AR863281           Date 16Nov11               *
009000200528      *                 AR863279           Date 16Nov11               *
009100200528      *                 CLE147             Date 17Oct11               *
009200200528      *                 CSF011             Date 12Sep11               *
009300200528      *                 CBF011             Date 04Jul11               *
009400200528      *                 AR819540A          Date 30Aug11               *
009500200528      *                 AR819540           Date 25Aug11               *
009600200528      *                 CER049             Date 06Dec10               *
009700200528      *                 CRE073             Date 06Dec10               *
009800200528      *                 AR802610           Date 15Jul11               *
009900200528      *                 AR698195B          Date 20Jan11               *
010000200528      *                 261692             Date 17Nov09               *
010100200528      *                 261962             Date 23Sep09               *
010200200528      *                 CER059             Date 19Jul10               *
010300200528      *                 BUG23742           Date 09May09               *
010400200528      *                 BUG22321           Date 20Jan09               *
010500200528      *                 CER030             Date 09Jul08               *
010600200528      *                 CER043             Date 19May08               *
010700200528      *                 BUG28091           Date 06Sep10               *
010800200528      *                 CSD083             Date 27May10               *
010900200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
011000200528      *                 CRE015             Date 18Dec09               *
011100200528      *                 BUG26906           Date 21Jan10               *
011200200528      *                 CAP191             Date 26Nov09               *
011300200528      *                 261140             Date 16Sep09               *
011400200528      *                 BUG25664           Date 20Aug09               *
011500200528      *                 CSW209             Date 01Apr09               *
011600200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
011700200528      *                 BUG22155           Date 16Jan09               *
011800200528      *                 BUG22140           Date 14Jan09               *
011900200528      *                 256564             Date 17Sep08               *
012000200528      *                 255190             Date 21Jul08               *
012100200528      *                 BUG18701           Date 12May08               *
012200200528      *                 BUG15872           Date 12Feb08               *
012300200528      *                 248299             Date 05Jun07               *
012400200528      *                 247172             Date 10May07               *
012500200528      *                 246418             Date 14Mar07               *
012600200528      *                 244505             Date 12Jan07               *
012700200528      *                 BUG14803           Date 06Sep07               *
012800200528      *                 BUG14485           Date 31Jul07               *
012900200528      *                 BUG13579           Date 22Mar07               *
013000200528      * Midas Plus 1.4 Base ------------------------------------------*
013100200528      *                 CSD079             Date 05Feb07               *
013200200528      *                 BUG12213           Date 16Jan07               *
013300200528      *                 CRE026             Date 24May06               *
013400200528      *                 BUG13174           Date 02Feb07               *
013500200528      *                 BUG13172           Date 30Jan07               *
013600200528      * Midas Plus 1.3 ----------- Base ------------------------------*
013700200528      *                 240684             Date 26Jun06               *
013800200528      *                 BUG8953            Date 07Nov05               *
013900200528      *                 CDL049             Date 04Jul06               *
014000200528      *                 BUG11194           Date 24Apr06               *
014100200528      *                 BUG10391R          Date 17Feb06               *
014200200528      *                 BUG10671R          Date 07Mar06               *
014300200528      *                 BUG10540           Date 14Feb06               *
014400200528      *                 BUG10563           Date 14Feb06               *
014500200528      *                 BUG10296           Date 07Feb06               *
014600200528      *                 BUG10384           Date 06Feb06               *
014700200528      *                 BUG10280           Date 02Feb06               *
014800200528      *                 BUG10202           Date 27Jan06               *
014900200528      *                 BUG10093           Date 26Jan06               *
015000200528      *                 BUG9829            Date 10Jan06               *
015100200528      *                 239400             Date 26Jun06               *
015200200528      *                 BUG8953            Date 07Nov05               *
015300200528      *                 BUG9009            Date 03Nov05               *
015400200528      *                 CAP087             Date 04Aug05               *
015500200528      *                 BUG9601            Date 13Dec05               *
015600200528      *                 BUG9584            Date 25Apr05               *
015700200528      *                 BUG8163            Date 16Aug05               *
015800200528      *                 BUG9089            Date 25Apr05               *
015900200528      *                 CER001             Date 25Apr05               *
016000200528      *                 BUG5988            Date 10Feb05               *
016100200528      *                 BUG9493            Date 07Dec05               *
016200200528      *                 CLE106             Date 01Aug04               *
016300200528      *                 CLE031             Date 26Apr05               *
016400200528      *                 CDL038             Date 10May05               *
016500200528      *                 CSE071             Date 26May05               *
016600200528      *                 CAS011             Date 16May05               *
016700200528      *                 CAP086             Date 08Jun05               *
016800200528      *                 BUG7664            Date 21Jun05               *
016900200528      *                 CDL033             Date 10Feb05               *
017000200528      *                 CGP010             Date 17Jan05               *
017100200528      *                 BUG5871            Date 24May05               *
017200200528      *                 BUG6512            Date 17May05               *
017300200528      *                 CDL028             Date 07Feb05               *
017400200528      *                 BUG6417            Date 28Mar05               *
017500200528      *                 BUG4562            Date 15Mar05               *
017600200528      *                 BUG6377            Date 11Apr05               *
017700200528      *                 BUG6671            Date 25Apr05               *
017800200528      *                 BUG6472            Date 23Apr05               *
017900200528      *                 BUG6534            Date 08Apr05               *
018000200528      *                 BUG6274            Date 18Mar05               *
018100200528      *                 BUG5728            Date 28Jan05               *
018200200528      *                 BUG5403            Date 10Jan05               *
018300200528      *                 BUG5449            Date 07Dec04               *
018400200528      *                 BUG683             Date 22Dec04               *
018500200528      *                 BUG4646            Date 25Oct04               *
018600200528      *                 BUG4815            Date 24Nov04               *
018700200528      *                 BUG4469            Date 06Oct04               *
018800200528      *                 BUG3792            Date 29Sep04               *
018900200528      *                 BUG4258            Date 13Sep04               *
019000200528      *                 BUG4196            Date 08Sep04               *
019100200528      *                 BUG4190            Date 08Sep04               *
019200200528      *                 BUG4146            Date 01Sep04               *
019300200528      *                 CFT118             Date 01Sep04               *
019400200528      *                 BUG4087            Date 26Aug04               *
019500200528      *                 CFT118             Date 24Aug04               *
019600200528      *                 BUG3684            Date 18Aug04               *
019700200528      *                 CLE120             Date 09Aug04               *
019800200528      *                 CFT116             Date 12Jul04               *
019900200528      *                 CFT115             Date 01Jul04               *
020000200528      *                 BUG3986            Date 13Aug04               *
020100200528      *                 CMM121             Date 29Jun04               *
020200200528      *                 CMM105             Date 22Jun04               *
020300200528      *                 CFX114             Date 15Jun04               *
020400200528      *                 BUG629             Date 30Jul04               *
020500200528      *                 BUG3071            Date 17Jun04               *
020600200528      *                 BUG2789            Date 21May04               *
020700200528      *                 CTI004             Date 12Apr04               *
020800200528      *                 BUG2480           Date 26May04                *
020900200528      *                 CGL014             Date 03Feb04               *
021000200528      *                 CDL019             Date 03Feb04               *
021100200528      *                 CDL018             Date 03Feb04               *
021200200528      *                 CDL017             Date 03Feb04               *
021300200528      *                 CDL016             Date 03Feb04               *
021400200528      *                 BG1105             Date 15Dec03               *
021500200528      *                 BUG19  (CAP084)    Date 26Jan04               *
021600200528      *                 BUG1100            Date 04May04               *
021700200528      *                 CRE020             Date 20Jan04               *
021800200528      *                 BUG1569            Date 17Mar04               *
021900200528      *                 BUG1304            Date 11Mar04               *
022000200528      *                 BUG1218            Date 11Mar04               *
022100200528      *                 BG0505             Date 04Mar04               *
022200200528      *                 CAP084  *CREATE    Date 24Mar03               *
022300200528      *                                                               *
022400200528      *---------------------------------------------------------------*
022500200528      *                                                               *
022600200528      *  260173 - Introduce new parameter in DEAM API to be used in   *
022700200528      *           the validation of action code during reversal       *
022800200528      *           authorization. Apply fix 258724. (Recompile)        *
022900200528      *  MD054696 - Journal Entries Avoid Shadow Postings Update.     *
023000200528      *             Add Shadow Post Indicator in BITH API (SOAP/JMS). *
023100200528      *  MD054538 - Buffer issue on Rollover Maintenance              *
023200200528      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
023300200528      *             being updated                                     *
023400200528      *  CER050 - Annualised Percentage Rate                          *
023500200528      *           (Change applied to CRE101_064 as well)              *
023600200528      *  MD052075 - [CGL150] Warning message should be displayed when *
023700200528      *           the system defaults the value date.                 *
023800200528      *  CSD102 - Password Length Extension                           *
023900200528      *  MD050928A - Reinstate codes by CFT157 as codes on FTOP* files*
024000200528      *              were reversed.                                   *
024100200528      *  MD050928 - SP15_MQ: Unclear error message - Error validating *
024200200528      *             'Stamp Tax Amount' : Invalid Numeric Value        *
024300200528      *           - Patterned after fix MD039094                      *
024400200528      *  MD050345 - Data under CRS Country Details are not aligned to *
024500200528      *             their corresponding columns                       *
024600200528      *  MD050342 - Mailing Country details is not displayed during   *
024700200528      *             Pre-Confirmation page                             *
024800200528      *  CGL157 - CRS Reporting                                       *
024900200528      *  CFT163 - FT Nostro Transfer Authorisation (RPG)              *
025000200528      *  MD044880 - BOE Switched On Testing and Fixing                *
025100200528      *  MD046248 - Finastra Rebranding                               *
025200200528      *  CDL099 - Split Value Date                                    *
025300200528      *           Applied for MD-48461                                *
025400200528      *  MD041996 - Incorrect mapping for FX Netting                  *
025500200528      *  MD042042 - Input Officer 1 and Input Officer 2 in IPAY and   *
025600200528      *             OPAY are being populated with WIP authoriser.     *
025700200528      *             Use the WIP input user profile instead.           *
025800200528      *  MD042033 - Correct DECPRIF positioning based on new CLIP.xml.*
025900200528      *  MD043890 - Cannot insert term and notice (Recompile)         *
026000200528      *  MD039986 - Additional codes to upgrade AR1090283.            *
026100200528      *  AR1090283 - Customer details not visible for enquire.        *
026200200528      *              (Child: AR1090284)                               *
026300200528      *            - Applied for MD-39986.                            *
026400200528      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
026500200528      *  AR701789 - Unable to reject a deal amendment. Add a new      *
026600200528      *             parameter to indicate reject transaction.         *
026700200528      *             Applied for MD041482                              *
026800200528      *  MD038485 - Correct mapping of Stamp Tax fields (CER049).     *
026900200528      *  CER071 - BAIS - Legal Form field (Recompile)                 *
027000200528      *  CLE141 - Currency and Location Business Day Convention for   *
027100200528      *           Lending Transactions                                *
027200200528      *  AR316373 - BOE @ MPlus - BOE cust dtls are not displayed in  *
027300200528      *             java wrapped function. Retrieve customer details  *
027400200528      *             from screen passed by java.                       *
027500200528      *  LLN022 - BOE Upgrade to MidasPlus (Recompile)                *
027600200528      *  AR702532 - After rejection, there is no WIP record but RSTS  *
027700200528      *             is still 'R'. Pass reject action parameter to     *
027800200528      *             skip validation during rejection to prevent the   *
027900200528      *             error. Applied fix 262574. (Child: AR702533)      *
028000200528      *           - Applied for MD023814                              *
028100200528      *  CAP212 - FT Nostro Transfer API                              *
028200200528      *  CGL158 - Nostro Sweeping Rules Maintenance                   *
028300200528      *           Added hooks: CGL158_001, CGL158_002, CGL158_003     *
028400200528      *                        CGL158_004, CGL158_005                 *
028500200528      *  CRE101 - Interim Interest Statement on a Frequency           *
028600200528      *           Added hooks: CRE101_001, CRE101_002, CRE101_003,    *
028700200528      *                        CRE101_004, CRE101_005, CRE101_063,    *
028800200528      *                        CRE101_064, CRE101_065, CRE101_066     *
028900200528      *  CGL165 - Dual Withholding Tax                                *
029000200528      *  MD030621 - Add @DEPI (Decrease Principal indicator) for PDCL *
029100200528      *             generated during IC.                              *
029200200528      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
029300200528      *  CDL096 - Business Day Conventions on MM Deals                *
029400200528      *  CSW214 - SWIFT Changes 2014                                  *
029500200528      *  MD030454 - Errors encountered during confirm authorise.      *
029600200528      *             Correct mapping done by MD029663.                 *
029700200528      *  CFT157 - Stop FT Transaction after Authorisation             *
029800200528      *  MD029663 - Misaligned Data in CIRS API.                      *
029900200528      *  CDL094 - Enhance Receive Settlement Instructions.            *
030000200528      *           Recompile based on additional field on SDESSRPD.    *
030100200528      *  MD026979 - Added field for Retail account and IBAN           *
030200200528      *             validation against WIP entries                    *
030300200528      *  CIR017 - SIRS Business Day Conventions for both Legs         *
030400200528      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
030500200528      *           Classification - Master                             *
030600200528      *  CSD092 - Account Review                                      *
030700200528      *  CSD093 - Document Management                                 *
030800200528      *  MD024631 - Incorporation of SWIFT 2013 to BF Midas 2.1.      *
030900200528      *             Renamed DDACTN in SDCUPR, DDCUST in SDRWAN and    *
031000200528      *             DDNTCP in SDCUFX.                                 *
031100200528      *  MD023331 - Database error encountered when CGL135 is         *
031200200528      *             switched off.                                     *
031300200528      *             Amended hook: CGL135_042, CGL135_045              *
031400200528      *  CGL135A - Accounting Rules Process                           *
031500200528      *            Added hooks: CGL135_041, CGL135_042, CGL135_043,   *
031600200528      *                         CGL135_044, CGL135_045, CGL135_046    *
031700200528      *  CAP090 - Initiate Batch Process API                          *
031800200528      *           Added hooks: CAP090_001, CAP090_002, CAP090_003,    *
031900200528      *                        CAP090_004, CAP090_005                 *
032000200528      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
032100200528      *              Applied for MD021813 (Recompile)                 *
032200200528      *  MD022093 - Additional Delivery for CSW213 Drop 2             *
032300200528      *  CSW213 - SWIFT Changes 2013                                  *
032400200528      *  MD020733 - CLE134_transfer to past due duplicated. Output    *
032500200528      *             record to LELOMKPD (same as LOAMSDK) when MR is   *
032600200528      *             created by PDCL generation in IC. Reuse UpSRFlg   *
032700200528      *             to check MR Autogen events from PDCL online.      *
032800200528      *  MD000091 - Event Codes Substitution (Recompile)              *
032900200528      *  MD020445 - CLE134 CCR2 updated functionality                 *
033000200528      *  AR1080805 - Error in LEMAPYUPD                               *
033100200528      *  AR910559 - Details are not correctly reverted back when the  *
033200200528      *             amended transaction is rejected in WIP. Introduce *
033300200528      *             @ACTRV variable to indicate reject action. Apply  *
033400200528      *             part of fix AR725754. (Child: AR910560)           *
033500200528      *  AR804863 - Details are not correctly reverted back when the  *
033600200528      *             amended transaction is rejected in WIP. Pass      *
033700200528      *             reject button to correctly revert back amended    *
033800200528      *             details. (Child: AR804864)                        *
033900200528      *           - Applied for AR910559 (Child: AR910560)            *
034000200528      *  CAP210 - Adjustment to Accrued Interests API                 *
034100200528      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
034200200528      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
034300200528      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
034400200528      *              in POC                                           *
034500200528      *  CLE134 - Past Due Call Loan Processing                       *
034600200528      *  CSW212 - SWIFT 2012 Changes                                  *
034700200528      *  AR1005984 - A serious midas error was encountered in OPAY    *
034800200528      *  AR1005162 - Base ccy exchange rate in corrective batch has   *
034900200528      *              incorrect number of decimal places               *
035000200528      *  AR1002463- Incorrect retrieval of auto-authorization flag    *
035100200528      *             for OPAY & IPAY (Child:AR1002464)                 *
035200200528      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
035300200528      *             Office Id is no more updated in master database   *
035400200528      *             files which provokes some big problems in third   *
035500200528      *             party product such as TOF.(Child:AR971185)        *
035600200528      *  CSC054 - Period End Adjustments                              *
035700200528      *  AR946674 - Serious midas error has occured (Child: AR946675) *
035800200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
035900200528      *          - Some codes of CSF011 will be physically deleted ;  *
036000200528      *            fixes for artifacts 863281 and 863279 will be      *
036100200528      *            physically deleted                                 *
036200200528      *  AR863281 - Pay Settlement Customer Name on Input fields      *
036300200528      *             are not displayed                                 *
036400200528      *  AR863279 - Pay Settlement Customer Name on Input fields      *
036500200528      *             are not displayed                                 *
036600200528      *  CLE147 - Aggregate Facility                                  *
036700200528      *  CSF011 - Customer Name on Inputs                             *
036800200528      *  CBF011 - BF Infrastructure: Error Message Handling           *
036900200528      *  AR819540A - Mapping error encountered in LDNI                *
037000200528      *  AR819540 - Mapping error encountered in OPAY transaction     *
037100200528      *  CER049 - Stamp Tax                                           *
037200200528      *  CRE073 - Interest Rate Rounding                              *
037300200528      *  AR802610 - Add Interest Scale flag in API definition.        *
037400200528      *  AR698195B - Added Front Office field on the buffer for TRADS *
037500200528      *             (Child: AR698196)                                 *
037600200528      *  261692 - Amended so that system can get the associated       *
037700200528      *           front office ID from JAVA.                          *
037800200528      *  261962 - Amended so that system can get the associated front *
037900200528      *           office ID from Java for INTC.                       *
038000200528      *  CER059 - German Feature Upgrade to Delhi                     *
038100200528      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
038200200528      *  BUG23742 - Improper handling of Ext Narr from Batch          *
038300200528      *             Interface Input                                   *
038400200528      *  BUG22321 - Mapping error causes Midas Error in Spot Rates    *
038500200528      *             input.                                            *
038600200528      *  CER030 - Multicash German Feature                            *
038700200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
038800200528      *  BUG28091 - Error "The batch is in used by another operator.  *
038900200528      *             It was last used by operator..." appeared upon    *
039000200528      *             input of a second batch item.                     *
039100200528      *  CSD083 - Watch List Compliance Upgrade                       *
039200200528      *  CRE015 - Retail Term and Notice Accounts                     *
039300200528      *  BUG26906 - Values for Broker and Customer tabs were reset    *
039400200528      *             to blanks                                         *
039500200528      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
039600200528      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
039700200528      *  BUG25664 - Database Error Encountered.                       *
039800200528      *  CSW209 - SWIFT 2009 Changes                                  *
039900200528      *  BUG22155 - Missing authorization field in repository for     *
040000200528      *             SECD and TRAD.                                    *
040100200528      *  BUG22140 - Missing authorization field in repository.        *
040200200528      *  256564 - Recompile due to PF changes done by fix 256330      *
040300200528      *  255190 - Added message type parameter on call to FTIPAYVU.   *
040400200528      *  BUG18701 - Implement Auto Authorisation                      *
040500200528      *  BUG15872 - Applied fix BUG14992                              *
040600200528      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
040700200528      *  248299 - Extdata no more setup for MMLDNIVU                  *
040800200528      *           Redo it based on MMLDEXPD                           *
040900200528      *  247172 - Re-arrange the sending of buffer so that  Extdata   *
041000200528      *           is at the end of the string.                        *
041100200528      *  246418 - CGL013 changes for midasplus                        *
041200200528      *  244505 - FCIP: fields for REGDATAZ not correctly retrieved   *
041300200528      *           due to additional fild 'DDPATH' sent by JAVA        *
041400200528      *           (field added by BUG11649)                           *
041500200528      *  BUG14803 - XML Input falls into Repair Queue due             *
041600200528      *             to field mismatched.                              *
041700200528      *  BUG14485 - MidasPlus Definition for CUSD is not in synch     *
041800200528      *             with that of API XML definition                   *
041900200528      *             Applied fix is BUG14228                           *
042000200528      *  BUG13579 - A Midas Plus error on FCIP insert (Recompile)     *
042100200528      *  CSD079 - Enhanced Customer Maintenance API                   *
042200200528      *  BUG12213 - Depot details missing on wholesale customer input *
042300200528      *  CRE026 - Consumer Banking                                    *
042400200528      *  BUG13174 - Applied fix 244505                                *
042500200528      *  BUG13172 - A serious midas error occurred (Recompile)        *
042600200528      *  240684 - Applied fix BUG9009.                                *
042700200528      *  BUG9009 - Implement CGL037                                   *
042800200528      *  BUG8953 - Recompile                                          *
042900200528      *  CDL049 - Addition of a Reference Rate field                  *
043000200528      *  BUG11194 - SEFRN- Purchased Interest not recalculated when   *
043100200528      *             trade value date is changed                       *
043200200528      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
043300200528      *              should be shown separately when CLE036 is *ON    *
043400200528      *              (Recompile)                                      *
043500200528      *  BUG10671R - Auto generated error on completion of agented    *
043600200528      *              loan. (Recompile)                                *
043700200528      *  BUG10540 - Add new assignment indicator. (Recompile)         *
043800200528      *  BUG10563 - Resolve conflict between BUG10296 and 9827        *
043900200528      *  BUG10296 - LUX extension fields are missing                  *
044000200528      *  BUG10384 - Incorrect buffer position in FAMD.                *
044100200528      *  BUG10280- Could not Amend record on AMAD                     *
044200200528      *  BUG10202- Mapping error in TRAD                              *
044300200528      *  BUG10093- Mapping error in FCIP                              *
044400200528      *  BUG9829 - CAP086 incorrectly applied a code change for       *
044500200528      *            CLIFLn to the wrong subroutine                     *
044600200528      *  239400 - Add Front Office ID for LDNI, DEAM, NASP and NASS   *
044700200528      *  BUG8953 - Recompile                                          *
044800200528      *  BUG9009 - Implement CGL037                                   *
044900200528      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
045000200528      *           Amend to handle TransType='DPMV' for Repos          *
045100200528      *           and Depot Transfers.                                *
045200200528      *  BUG9601- Mapping error in APTRANVU                           *
045300200528      *  BUG9584- Mapping correction with Java.                       *
045400200528      *  BUG8163 - FF Non-currency OTCs - TimeStamp value is not shown*
045500200528      *            after completion.                                  *
045600200528      *  BUG9089 - Mapping error with Java for DPMV                   *
045700200528      *  CER001 - Lux upgrade to MidasPlus                            *
045800200528      *  BUG5988- Data mapping for AMAD and SECS not consistent with  *
045900200528      *           the buffer setup in GLAMADVU and SESECSVU           *
046000200528      *  BUG9493 - Corrected position of ExtData data structure on    *
046100200528      *            buffer.                                            *
046200200528      *  CLE106 - Syndications Manager                                *
046300200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
046400200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
046500200528      *  CSE071 - Multiple Holidays Re Securities                     *
046600200528      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
046700200528      *  CAP086 - Introduce Auto Authorisation to the API's           *
046800200528      *           without it.                                         *
046900200528      *  BUG7664- change position of TRAM fields LDNI                 *
047000200528      *  CDL033 - Floating Rate CDs Issued.                           *
047100200528      *  CGP010 - Global BSPL                                         *
047200200528      *  BUG5871- Send deal status to midasplus for FRA/IRS modules   *
047300200528      *  BUG6512- Retrieve TRAM details, All Modules                  *
047400200528      *  CDL028 - Automatic Rate Interpolations                       *
047500200528      *  BUG6417- Cash management components are missing in MidasPlus *
047600200528      *  BUG4562- Retrieve TRAM details                               *
047700200528      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
047800200528      *            the confirmation screens                           *
047900200528      *  BUG6671- Implement Automatic Authorisation for CIRS/SIRS     *
048000200528      *  BUG6472- Changes to screen fmt file for CIRS/SIRS/CACF       *
048100200528      *  BUG6534- Condition settlement tabs on Loan or Deposit.       *
048200200528      *           Add Loan/Deposit indicator.                         *
048300200528      *  BUG6274- Premium amount does not revise on first confirmation*
048400200528      *           for insert                                          *
048500200528      *  BUG5728- UDF API to drop columns from a table                *
048600200528      *  BUG683 - Add PPayRcv to CLSP/CLS2                            *
048700200528      *  BUG5403 - Principle Change Schedule missing in CACF          *
048800200528      *  BUG5449- Schedules for CIRS api                              *
048900200528      *  BUG4646- Completion of SIRS api                              *
049000200528      *  BUG4815- Rationalise parameters for FXFXDLVU call.           *
049100200528      *  BUG4469- Stopping users overwrite changes for BSRT, SPTR,    *
049200200528      *           INTR and FRAS when amending the same record at the  *
049300200528      *           same time by passing the Timestamp to and from APIs.*
049400200528      *  BUG3792- Only allow Block/Unblock on Deposits.               *
049500200528      *           Add Placing/Taking indicator.                       *
049600200528      *  BUG4258- Stopping users overwrite changes for OTCC, OTCO,    *
049700200528      *           SEDE and PRCS when amending the same record at the  *
049800200528      *           same time.                                          *
049900200528      *  BUG4196- Stopping users overwrite changes for OPAY, IPAY,    *
050000200528      *           AMAD and CUSD when amending the same record at the  *
050100200528      *           same time.                                          *
050200200528      *  BUG4190- Missing parameter on call to FXFXDLVU               *
050300200528      *  BUG4146- Stopping users updating the same DEAM, NASP and NASS*
050400200528      *           records at the same time.                           *
050500200528      *  CFT118 - Core changes for GBO018.                            *
050600200528      *           Demand Drafts Printing - Upgrade to Midasplus.      *
050700200528      *           (Re-delivery) Add new field CQIN in the buffer.     *
050800200528      *  BUG4087- Stopping users updating the same FXDL record at the *
050900200528      *           same time.                                          *
051000200528      *  CFT118 - Core changes for GBO018.                            *
051100200528      *           Demand Drafts Printing. Upgrade to Midasplus.       *
051200200528      *  BUG3684- Pass the Block/Unblock action from the LDNI Pre-    *
051300200528      *           confirmation screen action buttons.                 *
051400200528      *  CLE120 - Core changes for GBO020.                            *
051500200528      *         - Debt Classification by Assets                       *
051600200528      *         - Upgrade to Midasplus                                *
051700200528      *  CFT116 - Core changes for GBO016                             *
051800200528      *         - MT110 Generation in Funds Transfer                  *
051900200528      *         - Upgrade to Midasplus                                *
052000200528      *  CFT115 - Core changes for GBO015                             *
052100200528      *         - Incoming Payments Beneficiary Validation            *
052200200528      *         - Upgrade to Midasplus                                *
052300200528      *  BUG3986- Pass the status and TimeStamp out to the MidasPlus  *
052400200528      *           by LDNI                                             *
052500200528      *  CMM121 - Core changes for GBO021                             *
052600200528      *         - OUTPUT tag :86: - Information to Account Owners     *
052700200528      *         - Upgrade to Midasplus                                *
052800200528      *  CMM105 - Core changes for GBO005                             *
052900200528      *         - Fixed Deposits Held Under Lien                      *
053000200528      *         - Upgrade to Midasplus                                *
053100200528      *  CFX114 - Core changes for GBO014                             *
053200200528      *         - Perform Override when Exchange Rate Tolerance is    *
053300200528      *           exceeded.                                           *
053400200528      *         - Upgrade to Midasplus                                *
053500200528      *  BUG629 - Add Deal Status field (DDSTS) in TRANS1 mapping     *
053600200528      *           for NASP function.                                  *
053700200528      *  BUG3071 - Online Printing of Advice for Fees Maintenance.    *
053800200528      *  BUG2789 - System test SOAP call from TI.                     *
053900200528      *  CTI004 - MidasPlus-TI Integration Enhancements               *
054000200528      *           FX Deals Integration                                *
054100200528      *  BUG2480 - Send the reservation id to the back end            *
054200200528      *  CGL014 - Collaterals Processing (Recompile)                  *
054300200528      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
054400200528      *           (Recompile)                                         *
054500200528      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
054600200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
054700200528      *           (Recompile)                                         *
054800200528      *  CDL016 - Truly Autumatic Rollover of Fixed Term Loan/Deposit *
054900200528      *           (Recompile)                                         *
055000200528      *  BG1105 - Bug1105 Make MSGARROUT a variable length string     *
055100200528      *  BUG19  - Changes on LERI processing.                         *
055200200528      *  BUG1100 - Added FEEM processing.                             *
055300200528      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
055400200528      *  BUG1569- Stop multi-user updating the same record at the     *
055500200528      *           time by holding original timestamp with the record  *
055600200528      *           retreated by each user.                             *
055700200528      *  BUG1304- Fee fields missing from display                     *
055800200528      *  BUG1218- Status not shown for FEAD records                   *
055900200528      *  BG0505 - Block question marks                                *
056000200528      *  CAP084 - Synchronous calling of APIs                         *
056100200528      *                                                               *
056200200528      *****************************************************************
056300200528     FAPQMBXPD  IF   E           K DISK                                                       BG0505
056400200528      ** +--------------------------------------+
056500200528      ** ¦ Automatically included D-specs       ¦
056600200528      ** ¦ ==============================       ¦
056700200528      ** +--------------------------------------+
056800200528      **
056900200528      **---------------------------------------------------------------
057000200528      ** The following /COPY line includes (among others) the LDA layout
057100200528      ** and the copyright array definition:
057200200528     D/COPY ZACPYSRC,STD_D_SPEC
057300200528      **---------------------------------------------------------------
057400200528
057500200528      **---------------------------------------------------------------
057600200528      ** The following /COPY line includes all the defined fields in the
057700200528      ** Program Status Data Structures.  They have meaningful
057800200528      ** names, prefixed by 'PS'.
057900200528     D/COPY ZACPYSRC,PSDS
058000200528      **---------------------------------------------------------------
058100200528
058200200528      **---------------------------------------------------------------
058300200528      ** The following /COPY line includes all the definitions of the
058400200528      ** error arrays, including the named constant giving the size of
058500200528      ** the arrays.
058600200528     D/COPY ZACPYSRC,FVAL_ARRAY
058700200528      **---------------------------------------------------------------
058800200528
058900200528      ** +--------------------------------------+
059000200528      ** ¦ End of automatically included D-specs¦
059100200528      ** ¦ =====================================¦
059200200528      ** +--------------------------------------+
059300200528
059400200528     D WDSPgmMod       DS                                                                     CRE020
059500200528     D  WrkPgm                 1     10                                                       CRE020
059600200528     D  WrkMod                11     12                                                       CRE020
059700200528                                                                                              CRE020
059800200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
059900200528      ** Midas Switchable features file accessed via access program                           CRE020
060000200528                                                                                              CRE020
060100200528     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE020
060200200528      ** DS for access programs - Short data structure                                        CRE020
060300200528                                                                                              CRE020
060400200528     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
060500200528      * Pay Settlement Instructions
060600200528     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
060700200528      * Receive Settlement Instructions
060800200528     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
060900200528      * FRA/IRS Settlement Instructions
061000200528     D PayStmtV      E DS                  EXTNAME(SDESSPPD)
061100200528     D                                     PREFIX(V)
061200200528      * Pay Settlement Instructions (Value Date)
061300200528     D RecStmtV      E DS                  EXTNAME(SDESSRPD)
061400200528     D                                     PREFIX(V)
061500200528      * Receive Settlement Instructions (Value Date)
061600200528     D PayStmtM      E DS                  EXTNAME(SDESSPPD)
061700200528     D                                     PREFIX(M)
061800200528      * Pay Settlement Instructions (Maturity Date)
061900200528     D RecStmtM      E DS                  EXTNAME(SDESSRPD)
062000200528     D                                     PREFIX(M)
062100200528      * Receive Settlement Instructions (Maturity Date)
062200200528                                                                                              CDL018
062300200528     D #FRECS        E DS                  EXTNAME(SDFSSRPD)                                  CDL018
062400200528      * Receive Further Settlement instructions in screen format                              CDL018
062500200528                                                                                              CDL018
062600200528     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)                                  CDL018
062700200528      * Payment Further Settlement instructions in screen format                              CDL018
062800200528      ** Midas DL Dealing Reporting Information file                                          CSW213
062900200528     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
063000200528     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
063100200528     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
063200200528     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
063300200528                                                                                              CSW213
063400200528     D TransInTot      DS          9999                                                       CSW213
063500200528     D  TransCUPR                          LIKE(SDCUPR)                                       CSW213
063600200528     D  TransCUSE                          LIKE(SDCUSE)                                       CSW213
063700200528     D  TransCUMT                          LIKE(SDCUMT)                                       CSW213
063800200528     D  TransCUMR                          LIKE(SDCUMR)                                       CSW213
063900200528     D  TransCUBR                          LIKE(SDCUBR)                                       CSW213
064000200528     D  TransCUPB                          LIKE(SDCUPB)                                       CSW213
064100200528     D  TransCUMI                          LIKE(SDCUMI)                                       CSW213
064200200528     D  TransCUAD                          LIKE(SDCUAD)                                       CSW213
064300200528     D  TransACU3                          LIKE(SDACU3)                                       CSW213
064400200528     D  TransACU4                          LIKE(SDACU4)                                       CSW213
064500200528     D  TransSFEE                          LIKE(SDSFEE)                                       CSW213
064600200528     D  TransCHEC                          LIKE(SDCHEC)                                       CSW213
064700200528     D  TransCUSF                          LIKE(SDCUSF)                                       CSW213
064800200528     D  TransCUFX                          LIKE(SDCUFX)                                       CSW213
064900200528     D  TransCUFD                          LIKE(SDCUFD)                                       CSW213
065000200528     D  TransCUFO                          LIKE(SDCUFO)                                       CSW213
065100200528     D  TransCUPM                          LIKE(SDCUPM)                                       CSW213
065200200528     D  TransTICD                          LIKE(SDTICD)                                       CSW213
065300200528     D  TransCUSW                          LIKE(SDCUSW)                                       CSW213
065400200528     D  TransCURX                          LIKE(SDCURX)                                       CSW213
065500200528     D  TransTimeStmp                      LIKE(@Timestamp)                                   CSW213
065600200528     D  TransRWAN                          LIKE(SDRWAN)                                       CSW213
065700200528     D  TransStmpTax                       LIKE(StampTax)                                   MD022093
065800200528     D  TransAUTH                          LIKE(AAUTH)                                        CSW213
065900200528                                                                                              CSW213
066000200528     D TransInEx2      DS          9999                                                       CSW213
066100200528     D  TransCS13                          LIKE(SDSW13)                                       CSW213
066200200528     D  TransCUXC                          LIKE(SDCUXC)                                       CGL132
066300200528     D  TransFTCR                          LIKE(SDFTCR)                                       CGL132
066400200528     D  TransCUEX                          LIKE(SDCUEX)                                     MD044880
066500200528     D  TransCRSH                          LIKE(SDCRSS)                                       CGL157
066600200528     D  TransCR50                     1A                                                    MD054028
066700200528                                                                                              CSW213
066800200528     D TransInEx3      DS          9999                                                       CSW213
066900200528     D  TransCARS              1   9999                                                       CSW213
067000200528                                                                                              CSW213
067100200528     D TransInEx4      DS          9999                                                       CSW213
067200200528     D  TransCUAH                          LIKE(SDCUAH)                                       CSW213
067300200528     D  TransCCTX                          LIKE(SDCCTX)                                       CSW213
067400200528     D  TransCRDD1                 6039                                                       CGL157
067500200528                                                                                              CGL157
067600200528     D TransInEx5      DS          9999                                                       CGL157
067700200528     D  TransCRDD2                  651                                                       CGL157
067800200528                                                                                              CSW213
067900200528     D SDCUPR        E DS                  EXTNAME(SDCUPRPD)                                  CSW213
068000200528     D  DDACTN_CP    E                     EXTFLD(DDACTN)                                   MD024631
068100200528     D SDCUSE        E DS                  EXTNAME(SDCUSEPD)                                  CSW213
068200200528     D SDCUMT        E DS                  EXTNAME(SDCUMTPD)                                  CSW213
068300200528     D SDCUMR        E DS                  EXTNAME(SDCUMRPD)                                  CSW213
068400200528     D SDCUBR        E DS                  EXTNAME(SDCUBRPD)                                  CSW213
068500200528     D SDCUPB        E DS                  EXTNAME(SDCUPBPD)                                  CSW213
068600200528     D SDCUMI        E DS                  EXTNAME(SDCUMIPD)                                  CSW213
068700200528     D  DDACTN_CU    E                     EXTFLD(DDACTN)                                     CSW213
068800200528     D SDCUAD        E DS                  EXTNAME(SDCUADPD)                                  CSW213
068900200528     D  DDACTN_CA    E                     EXTFLD(DDACTN)                                     CSW213
069000200528     D  DDCNA1_CA    E                     EXTFLD(DDCNA1)                                     CSW213
069100200528     D  DDCNA2_CA    E                     EXTFLD(DDCNA2)                                     CSW213
069200200528     D  DDCNA3_CA    E                     EXTFLD(DDCNA3)                                     CSW213
069300200528     D  DDCNA4_CA    E                     EXTFLD(DDCNA4)                                     CSW213
069400200528     D  DDCSSN_CA    E                     EXTFLD(DDCSSN)                                     CSW213
069500200528     D SDACU3        E DS                  EXTNAME(SDACU3DPD)                                 CSW213
069600200528     D SDACU4        E DS                  EXTNAME(SDACU4DPD)                                 CSW213
069700200528     D SDSFEE        E DS                  EXTNAME(SDSFEEPD)                                  CSW213
069800200528     D  DDACTN_FE    E                     EXTFLD(DDACTN)                                     CSW213
069900200528     D SDCHEC        E DS                  EXTNAME(SDCHECPD)                                  CSW213
070000200528     D  DDACTN_CH    E                     EXTFLD(DDACTN)                                     CSW213
070100200528     D SDCUSF        E DS                  EXTNAME(SDCUSFPD)                                  CSW213
070200200528     D  DDACTN_SF    E                     EXTFLD(DDACTN)                                     CSW213
070300200528     D SDCUFX        E DS                  EXTNAME(SDCUFXPD)                                  CSW213
070400200528     D  DDACTN_FX    E                     EXTFLD(DDACTN)                                     CSW213
070500200528     D  DDNTCP_FX    E                     EXTFLD(DDNTCP)                                   MD024631
070600200528     D SDCUFD        E DS                  EXTNAME(SDCUFDPD)                                  CSW213
070700200528     D  DDACTN_FD    E                     EXTFLD(DDACTN)                                     CSW213
070800200528     D SDCUFO        E DS                  EXTNAME(SDCUFOPD)                                  CSW213
070900200528     D  DDACTN_FO    E                     EXTFLD(DDACTN)                                     CSW213
071000200528     D  DDSMAC_FO    E                     EXTFLD(DDSMAC)                                     CSW213
071100200528     D SDCUPM        E DS                  EXTNAME(SDCUPMPD)                                  CSW213
071200200528     D  DDACTN_PM    E                     EXTFLD(DDACTN)                                     CSW213
071300200528     D SDTICD        E DS                  EXTNAME(SDTICDPD)                                  CSW213
071400200528     D  DDACTN_TI    E                     EXTFLD(DDACTN)                                     CSW213
071500200528     D SDCUSW        E DS                  EXTNAME(SDCUSWPD)                                  CSW213
071600200528     D SDCURX        E DS                  EXTNAME(SDCURXPD)                                  CSW213
071700200528     D SDRWAN        E DS                  EXTNAME(SDRWANPD)                                  CSW213
071800200528     D  DDACTN_RW    E                     EXTFLD(DDACTN)                                     CSW213
071900200528     D  DDCUST_RW    E                     EXTFLD(DDCUST)                                   MD024631
072000200528     D  DDCSSN_RW    E                     EXTFLD(DDCSSN)                                     CSW213
072100200528     D  DDCRNM_RW    E                     EXTFLD(DDCRNM)                                     CSW213
072200200528     D  DDCNA2_RW    E                     EXTFLD(DDCNA2)                                     CSW213
072300200528     D SDCUAH        E DS                  EXTNAME(SDCUAHDPD)                                 CSW213
072400200528     D SDCCTX        E DS                  EXTNAME(SDCCTXDPD)                                 CSW213
072500200528     D SDSW13        E DS                  EXTNAME(SDSW13PD)                                  CSW213
072600200528     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CSW213
072700200528     D  S13DDCITY    E                     EXTFLD(DDCITY)                                     CSW213
072800200528     D  S13DDPOBN    E                     EXTFLD(DDPOBN)                                     CSW213
072900200528                                                                                              CSW213
073000200528     D SDCUXC        E DS                  EXTNAME(SDCUXCPD)                                  CGL132
073100200528     D SDFTCR        E DS                  EXTNAME(SDFTCRPD)                                  CGL132
073200200528     D  DDCUST_FC    E                     EXTFLD(DDCUST)                                     CGL132
073300200528     D SDCRSS        E DS                  EXTNAME(SDCRSSPD)                                  CGL157
073400200528     D                                     PREFIX(W)                                          CGL157
073500200528     D SDCRDD        E DS                  EXTNAME(SDCRDDPD)                                  CGL157
073600200528     D                                     PREFIX(W)                                          CGL157
073700200528                                                                                              CDL099
073800200528      ** CDL099 Split Value Date with additional extra fields                                 CDL099
073900200528     D InCDL099      E DS                  EXTNAME(FXDLEXPD)                                  CDL099
074000200528     D DDEXDT_FX     E                     EXTFLD(DDEXDT)                                     CDL099
074100200528     D SDCUEX        E DS                  EXTNAME(SDCUEXPD)                                MD044880
074200200528      *                                                                                     BUG23742
074300200528     D POthNarr1       S            500A                                                    BUG23742
074400200528      *                                                                                     BUG23742
074500200528      ** External DS on BITP Additional Info 1                                              BUG23742
074600200528      *                                                                                     BUG23742
074700200528     D POthNarr2       S            500A                                                    BUG23742
074800200528      *                                                                                     BUG23742
074900200528      ** External DS on BITP Additional Info 2                                              BUG23742
075000200528
075100200528      ** The maximum size of the error arrays
075200200528     D ArrayMax        C                   CONST(75)
075300200528
075400200528      ** Array of Fields in error.
075500200528     D FldNameArr      S             10A   DIM(ArrayMax)
075600200528
075700200528      ** Array of error message IDs
075800200528     D MsgIDArr        S                   DIM(ArrayMax)
075900200528     D                                     LIKE(#MsgID)
076000200528
076100200528      ** Array of error message data.
076200200528     D MsgDtaArr       S                   DIM(ArrayMax)
076300200528     D                                     LIKE(#MsgData)
076400200528
076500200528      ** Array of Fields with warnings.
076600200528     D WFldNamArr      S             10A   DIM(ArrayMax)
076700200528
076800200528      ** Array of warning message IDs
076900200528     D WMsgIDArr       S                   DIM(ArrayMax)
077000200528     D                                     LIKE(#MsgID)
077100200528
077200200528      ** Array of warning message data.
077300200528     D WMsgDtaArr      S                   DIM(ArrayMax)
077400200528     D                                     LIKE(#MsgData)
077500200528
077600200528      ** Entry parameters
077700200528     D TransType       S              4
077800200528     D Parm            S           1000
077900200528     D Buffer          S           6000
078000200528     D***ApHead*         S            200                                            AR971184 CSD102
078100200528     D ApHead          S            318                                                       CSD102
078200200528      * In order to allow for growing and variable buffers, this buffer must be split up
078300200528      * Any APIs requiring more than 6000 buffer should use buffer2
078400200528     D BufferTotal     S           9999
078500200528     D Buffer9999      S           9999                                                       CER059
078600200528     D Buffer2         S           3999
078700200528     D BufferEx2       S           9999                                                      BUG4646
078800200528     D BufferEx3       S           9999                                                      BUG4646
078900200528     D BufferEx4       S           9999                                                      BUG4646
079000200528     D BufferEx5       S           9999                                                      BUG4646
079100200528     D BufferEx6       S           9999                                                      BUG4646
079200200528     D BufferEx7       S           9999                                                      BUG4646
079300200528     D BufferEx8       S           9999                                                      BUG4646
079400200528     D BufferEx9       S           9999                                                      BUG4646
079500200528     D****** MsgArrOUT       S           2000                                                 BG1105
079600200528     D MsgArrOUT       S           9999                                                       BG1105
079700200528     D APIRetC         S              1
079800200528     D @TimeStamp      S             26                                                      BUG1569
079900200528     D NewButton       S              3                                                       255190
080000200528     D DDACTC          S              1                                                      BUG3684
080100200528     D DDFOID          S             20                                                       239400
080200200528     D PLATAK          S              1                                                      BUG3792
080300200528     D LONDEP          S              1                                                      BUG6534
080400200528     D ACTRJ           S              1                                                     AR701789
080500200528     D DepData         S           4050                                                     BUG12213
080600200528     D FRNT            S             20                                                       261140
080700200528     D AFRT            S             20                                                       261140
080800200528     D*WLCData**       S            181                                                CSD083 CFT039
080900200528     D WLCData         S            184                                                       CFT039
081000200528     D APINam          S             20                                                       CBF011
081100200528     D @ACTRV          S              1                                                     AR910559
081200200528     D @DEPI           S              1                                                     MD030621
081300200528     D AuthUsers       S             20                                                       CFT163
081400200528
081500200528      ** DS/variables to split up incoming parameter
081600200528     D APParm          DS          1000
081700200528     D  UPDATEYN               1      1
081800200528     D  ReservID15             2     16                                         BUG2480
081900200528                                                                                             BUG5988
082000200528      ** Extra fields for AMAD                                                               BUG5988
082100200528     D AMADFldDS1      DS                                                                    BUG5988
082200200528     D  DDFAMT                 1      8                                                      BUG5988
082300200528     D  AMATYP                 9      9                                                      BUG5988
082400200528     D  AMSTYP                10     10                                                      BUG5988
082500200528     D  DODRCD                11     16                                                      BUG5988
082600200528     D  DOCRCD                17     22                                                      BUG5988
082700200528     D  INCST                 23     23                                                      BUG5988
082800200528     D  BRT                   24     24                                                      BUG5988
082900200528     D  ALT                   25     25                                                      BUG5988
083000200528     D  LTYP                  26     26                                                      BUG5988
083100200528     D  LINK                  27     44                                                      BUG5988
083200200528     D  IBA1                  45     45                                                      BUG5988
083300200528     D  DOPOLC                46     51                                                      BUG5988
083400200528     D  DOPOLE                52     57                                                      BUG5988
083500200528     D  DSPTFR                58     58                                                      BUG5988
083600200528     D  DDDRMG1               59     70                                                      BUG5988
083700200528     D  DDCRMG1               71     82                                                      BUG5988
083800200528     D  DDCEXA1               83     93                                                      BUG5988
083900200528     D  DDCEXB1               94    104                                                      BUG5988
084000200528     D  DDCEXC1              105    115                                                      BUG5988
084100200528     D  DDCEXD1              116    123                                                      BUG5988
084200200528     D  DDCEXE1              124    131                                                      BUG5988
084300200528     D  DDCEXF1              132    139                                                      BUG5988
084400200528     D  DDCEXG1              140    147                                                      BUG5988
084500200528     D  DDEABC               148    148                                                      BUG5988
084600200528                                                                                             BUG5988
084700200528      ** Extra fields for SECS                                                               BUG5988
084800200528     D SECSFldDS1      DS                                                                    BUG5988
084900200528     D  PPROT                  1      1                                                      BUG5988
085000200528     D  PTRBS                  2      2                                                      BUG5988
085100200528     D  PPRBS                  3      3                                                      BUG5988
085200200528     D  ASDC1                  4      9                                                      BUG5988
085300200528     D  ASDC2                 10     15                                                      BUG5988
085400200528     D  ASDC3                 16     21                                                      BUG5988
085500200528      *                                                                                     MD021813
085600200528      ** Extra fields for CTNM                                                              MD021813
085700200528     D CTNMFldDS1      DS                                                                   MD021813
085800200528     D  DDACTN                 1      1                                                     MD021813
085900200528     D  DDCUST                 2      7                                                     MD021813
086000200528     D  DDNTCP                 8      8                                                     MD021813
086100200528
086200200528      ** Extra fields for CSW213                                                              CSW213
086300200528     D InSwift2013     DS                                                                     CSW213
086400200528     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
086500200528     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
086600200528     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
086700200528RGC  D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
086800200528                                                                                              CSW213
086900200528      * Incoming Header
087000200528     D HeadIn        E DS                  EXTNAME(APHEADPD)
087100200528
087200200528      * Standard parameters for called programs
087300200528     D TRANS1A         S           1000                                                       CDL028
087400200528     D TRANS1          S            500
087500200528     D TRANS2          S            500
087600200528     D TRANS2A         S           1000                                                      CSF011A
087700200528     D TRANS2B         S            500                                                     BUG11194
087800200528     D TRANS3          S            500
087900200528     D TRANS3A         S           1000                                                      CSF011A
088000200528     D TRANS4          S            500
088100200528     D TRANS4A         S           1000                                                      CSF011A
088200200528     D TRANS5          S            500
088300200528     D TRANS5A         S           1000                                                      CSF011A
088400200528     D TRANS6          S            500
088500200528     D TRANS6A         S           1000                                                      CSF011A
088600200528     D TRANS7a         S            500                                                     BUG14485
088700200528     D TRANS7          S            500
088800200528     D TRANS8          S            500
088900200528     D TRANS9          S            500
089000200528     D TRANSQ          S            500                                                       CER049
089100200528     D OthData         S            500                                                      BUG9089
089200200528     D OthData1        S            500                                                      BUG9584
089300200528     D RegData         S            500                                                       CER001
089400200528     D TRANS10         S            500                                                       CSD079
089500200528     D TRANS10A        S            500                                                       CER030
089600200528     D TRANSEXT        S            500                                                       CSD079
089700200528     D TRANS11         S            500                                                       CSD079
089800200528     D TRANS11A        S            500                                                       CER030
089900200528     D TRANS11B        S            500                                                       CFT039
090000200528     D TRANS12         S            500                                                       CSD079
090100200528     D TRANS13         S            500                                                       CSD079
090200200528     D TRANS14         S            500                                                       CSD079
090300200528     D TRANS15         S            500                                                       CSD079
090400200528     D TRANS16         S            500                                                       CSD079
090500200528     D TransSW         S            500                                                     BUG14992
090600200528     D TransCUA1       S            500                                                       CER059
090700200528     D TransCUA2       S            500                                                       CER059
090800200528     D TransCUA3       S            500                                                       CER059
090900200528     D TransACT1       S            500                                                       CER059
091000200528     D TransACT2       S            500                                                       CER059
091100200528     D TransACT3       S            500                                                       CER059
091200200528     D TransACT4       S            500                                                       CER059
091300200528     D TransACT5       S            500                                                       CER059
091400200528     D TransACT6       S            500                                                       CER059
091500200528     D TransCRS01      S            500                                                       CGL157
091600200528     D TransCRS02      S            500                                                       CGL157
091700200528     D TransCRS03      S            500                                                       CGL157
091800200528     D TransCRS04      S            500                                                       CGL157
091900200528     D TransCRS05      S            500                                                       CGL157
092000200528     D TransCRS06      S            500                                                       CGL157
092100200528     D TransCRS07      S            500                                                       CGL157
092200200528     D TransCRS08      S            500                                                       CGL157
092300200528     D TransCRS09      S            500                                                       CGL157
092400200528     D TransCRS10      S            500                                                       CGL157
092500200528     D TransCRS11      S            500                                                       CGL157
092600200528     D TransCRS12      S            500                                                       CGL157
092700200528     D TransCRS13      S             39                                                       CGL157
092800200528     D TransCRS14      S            500                                                       CGL157
092900200528     D TransCRS15      S            500                                                       CGL157
093000200528     D TRANS17         S            500                                                       CSD079
093100200528     D TRANS18         S            500                                                       CSD079
093200200528     D BCLData         S            500                                                       CSD079
093300200528     D EurRepData      S            500                                                       CSD079
093400200528     D TRANS8A         S            500                                                       CSD079
093500200528     D TRANS8B         S            500                                                       CSD079
093600200528     D TRANS8C         S            500                                                       CGL157
093700200528     D Trans83         S            500                                                       CER059
093800200528     D Trans84         S            500                                                       CER059
093900200528     D TRANS19         S            500                                                    AR1086546
094000200528     D TransCCTN       S            500                                                     MD021813
094100200528     D ExtData         S            500
094200200528     D InfData         S            500
094300200528     D FCIPNotes       S            500                                                     BUG10093
094400200528     D CustData        S            500                                                       CER043
094500200528     D StampTax        S            500                                                       CER049
094600200528     D OthrData        S           4755A
094700200528     D TRADSettleData  S           4878A                                                     CSF011A
094800200528     D*RepeatData      S           4500A                                                      CRE015
094900200528     D RepeatData      S           5382A                                                      CRE073
095000200528     D*TempData#1      S           4972A                                               CRE073 CSF011
095100200528     D*TempData#2      S            410A                                               CRE073 CSF011
095200200528     D TempData#1      S           4932A                                                      CSF011
095300200528     D TempData#2      S            450A                                                      CSF011
095400200528     D*TempData#3      S              2A                                            CSF011 AR1005984
095500200528     D*TempData#4      S             18A                                            CSF011 AR1005984
095600200528     D TempData#3      S              1A                                                   AR1005984
095700200528     D TempData#4      S             19A                                                   AR1005984
095800200528     D TempData#5      S           4667A                                                      CSF011
095900200528     D TempData#6      S            211A                                                      CSF011
096000200528     D TempData#7      S             13A                                                    MD029663
096100200528     D TempData#8      S             37A                                                    MD029663
096200200528     D TempData#9      S             50A                                                    MD029663
096300200528     D GLFullAcct      S             24A                                                    MD026979
096400200528     D TempData7       S              1A                                                      CLE164
096500200528     D InputUser       S             10A                                                    MD042042
096600200528     D StopFTDta       S             10A                                                    MD050928
096700200528
096800200528     D*WCFSC1OLn       S              4P 0                                                   BUG4646
096900200528     D*WCFSC2OLn       S              4P 0                                                   BUG4646
097000200528     D*WCFSC3OLn       S              4P 0                                                   BUG4646
097100200528     D*WCFSC4OLn       S              4P 0                                                   BUG4646
097200200528     D*WPCSC1OLn       S              4P 0                                                   BUG4646
097300200528     D*WPCSC2OLn       S              4P 0                                                   BUG4646
097400200528     D*WPCSC3OLn       S              4P 0                                                   BUG4646
097500200528     D*WPCSC4OLn       S              4P 0                                                   BUG4646
097600200528     D*WCFSC1TLn       S              4P 0                                                   BUG4646
097700200528     D*WCFSC2TLn       S              4P 0                                                   BUG4646
097800200528     D*WCFSC3TLn       S              4P 0                                                   BUG4646
097900200528     D*WCFSC4TLn       S              4P 0                                                   BUG4646
098000200528     D*WPCSC1TLn       S              4P 0                                                   BUG4646
098100200528     D*WPCSC2TLn       S              4P 0                                                   BUG4646
098200200528     D*WPCSC3TLn       S              4P 0                                                   BUG4646
098300200528     D*WPCSC4TLn       S              4P 0                                                   BUG4646
098400200528     D*WTRSCLn**       S              4P 0                                                   BUG4646
098500200528                                                                                              CRE020
098600200528     D CRE020          S              1                                                       CRE020
098700200528     D PRTCD           S              7A                                                      CRE020
098800200528     D POPTN           S              7A                                                      CRE020
098900200528     D PSARD           S              6A                                                      CRE020
099000200528     D PDtqNam         S             10A                                                      CRE020
099100200528     D PDtqLib         S             10A                                                      CRE020
099200200528     D PDtqLen         S              5  0                                                    CRE020
099300200528     D PDtqMsg         S             50A                                                      CRE020
099400200528                                                                                             BUG5988
099500200528     D AMADFLn         S              4  0                                                   BUG5988
099600200528     D AMADFiller      S            500A                                                     BUG5988
099700200528     D SECSFLn         S              4  0                                                   BUG5988
099800200528     D SECSFiller      S            500A                                                     BUG5988
099900200528     D*LDNIFiller      S           4000A                                           BUG10296 BUG10563
100000200528     D RatDateDS       S           4800A                                                    BUG10563
100100200528     D PayDateDS       S           4800A                                                    BUG10563
100200200528     D WDUMMY          S             90A                                                    BUG10563
100300200528
100400200528      *                                                                                       CER001
100500200528      ** Length for regional fields                                                           CER001
100600200528      *                                                                                       CER001
100700200528     D AMRXLn          S              4  0                                                    CER001
100800200528     D BPRXLn          S              4  0                                                    CER001
100900200528     D CLRXLn          S              4  0                                                    CER001
101000200528     D DMRXLn          S              4  0                                                    CER001
101100200528     D FCRXLn          S              4  0                                                    CER001
101200200528     D IPRXLn          S              4  0                                                    CER001
101300200528     D LDRXLn          S              4  0                                                    CER001
101400200528     D NPRXLn          S              4  0                                                    CER001
101500200528     D OPRXLn          S              4  0                                                    CER001
101600200528     D OTEXLn          S              4  0                                                    CER001
101700200528     D OTRXLn          S              4  0                                                    CER001
101800200528     D RORXLn          S              4  0                                                    CER001
101900200528     D SERXLn          S              4  0                                                    CER001
102000200528     D TDRXLn          S              4  0                                                    CER001
102100200528     D TDAXLn          S              4  0                                                   BUG9584
102200200528     D FCRNLn          S              4  0                                                  BUG10093
102300200528     D ExtLength       S              4  0                                                    CSD079
102400200528     D SDARLn          S              4  0                                                    CSD092
102500200528     D ACEXLn          S              4P 0                                                    CSD092
102600200528     D ACRFLn          S              4P 0                                                    CSD092
102700200528     D SDMILn          S              4  0                                                    CRE026
102800200528     D SDADLn          S              4  0                                                    CRE026
102900200528     D SDADLnA         S              4  0                                                    CRE026
103000200528     D SDADLnB         S              4  0                                                    CRE026
103100200528     D SDADLnC         S              4  0                                                    CGL157
103200200528     D SDADLn3         S              4  0                                                    CER059
103300200528     D SDADLn4         S              4  0                                                    CER059
103400200528     D SDSFLn          S              4  0                                                    CRE026
103500200528     D SDCHLn          S              4  0                                                    CRE026
103600200528     D SDCSLn          S              4  0                                                    CRE026
103700200528     D SDFXLn          S              4  0                                                    CRE026
103800200528     D SDFDLn          S              4  0                                                    CRE026
103900200528     D SDRWLn          S              4  0                                                    CRE026
104000200528     D SDFOLn          S              4  0                                                    CRE026
104100200528     D SDPMLn          S              4  0                                                    CRE026
104200200528     D SDTILn          S              4  0                                                    CRE026
104300200528     D SDCULn          S              4  0                                                    CRE026
104400200528     D COTYLn          S              4  0                                                    CRE026
104500200528     D SDCXLn          S              4  0                                                    CRE026
104600200528     D CNTYLn          S              4  0                                                    CRE026
104700200528     D CTX1Ln          S              4  0                                                    CRE026
104800200528     D CTX2Ln          S              4  0                                                    CRE026
104900200528     D ALNALn          S              4  0                                                    CRE026
105000200528     D SDAXLn          S              4  0                                                    CRE026
105100200528     D AMUSLn          S              4  0                                                    CRE026
105200200528     D BBR1Ln          S              4  0                                                    CRE026
105300200528     D BBR2Ln          S              4  0                                                    CRE026
105400200528     D BBR3Ln          S              4  0                                                    CRE026
105500200528     D BBR4Ln          S              4  0                                                    CRE026
105600200528     D BBR5Ln          S              4  0                                                    CRE026
105700200528     D BBR6Ln          S              4  0                                                    CRE026
105800200528     D BBR7Ln          S              4  0                                                    CRE026
105900200528     D BBR8Ln          S              4  0                                                    CRE026
106000200528     D OBR1Ln          S              4  0                                                    CRE026
106100200528     D OBR2Ln          S              4  0                                                    CRE026
106200200528     D OBR3Ln          S              4  0                                                    CRE026
106300200528     D OBR4Ln          S              4  0                                                    CRE026
106400200528     D OBR5Ln          S              4  0                                                    CRE026
106500200528     D OBR6Ln          S              4  0                                                    CRE026
106600200528     D OBR7Ln          S              4  0                                                    CRE026
106700200528     D OBR8Ln          S              4  0                                                    CRE026
106800200528     D SFUXLn          S              4  0                                                    CRE026
106900200528     D COMPLn          S              4  0                                                    CRE026
107000200528     D NOSRLn          S              4  0                                                    CRE026
107100200528     D SDNXLn          S              4  0                                                    CRE026
107200200528     D YLCULn          S              4  0                                                    CRE026
107300200528     D SDYXLn          S              4  0                                                    CRE026
107400200528     D YRA1Ln          S              4  0                                                    CRE026
107500200528     D YRA2Ln          S              4  0                                                    CRE026
107600200528     D YRA3Ln          S              4  0                                                    CRE026
107700200528     D YRA4Ln          S              4  0                                                    CRE026
107800200528     D SDYELn          S              4  0                                                    CRE026
107900200528     D RWANLn          S              4  0                                                    CRE026
108000200528     D CUW1Ln          S              4  0                                                    CRE026
108100200528     D CUW2Ln          S              4  0                                                    CRE026
108200200528     D AMPPLn1         S              4  0                                                    CRE015
108300200528     D AMPPLn2         S              4  0                                                    CRE015
108400200528     D CPD1Ln          S              4  0                                                    CLE134
108500200528     D DLAALn          S              4  0                                                    CAP210
108600200528     D CCTNLn          S              4  0                                                 AR1086546
108700200528     D CCTNLn1         S              4  0                                                  MD021813
108800200528                                                                                              CSW209
108900200528      ** Work variable used by CSW209                                                         CSW209
109000200528     D IPY9ALn         S              4P 0                                                    CSW209
109100200528     D IPY9BLn         S              4P 0                                                    CSW209
109200200528     D OPY10Ln         S              4P 0                                                    CSW209
109300200528     D OPY11Ln         S              4P 0                                                    CSW209
109400200528     D TRANS9A         S           1000A                                                      CSW209
109500200528     D TRANS9B         S           1000A                                                      CSW209
109600200528     D CSW209          S              1                                                       CSW209
109700200528                                                                                              CSW209
109800200528     D yAAuth          S              1A                                                    AR316373
109900200528     D OPY12Ln         S              4P 0                                                    CER049
110000200528      *                                                                                       CER049
110100200528      ** Work variable used by CSW213                                                         CSW213
110200200528     D RPIFLn          S              4  0                                                    CSW213
110300200528     D RPIF1Ln         S              4  0                                                    CSW213
110400200528     D RPIF2Ln         S              4  0                                                    CSW213
110500200528     D RPIF3Ln         S              4  0                                                    CSW213
110600200528RGC  D RPIF4LN         S              4  0                                                    CSW214
110700200528                                                                                              CSW213
110800200528     D SW13Ln          S              4  0                                                    CSW213
110900200528     D BFTotLn         S              4  0 INZ(9999)                                        MD022093
111000200528     D BFEX2Ln         S              4  0 INZ(9999)                                        MD022093
111100200528     D BFEX3Ln         S              4  0 INZ(9999)                                        MD022093
111200200528     D BFEX4Ln         S              4  0 INZ(9999)                                        MD022093
111300200528     D BFEX5Ln         S              4  0 INZ(9999)                                          CGL157
111400200528                                                                                            MD022093
111500200528      ** Remaining filler for CUSP API only                                                 MD022093
111600200528     D FillerBufTot    S           5235A                                                    MD022093
111700200528     D FillerBufEx2    S           8951A                                                    MD022093
111800200528     D FillerBufEx3    S           9999A                                                    MD022093
111900200528     D FillerBufEx4    S           6284A                                                    MD022093
112000200528                                                                                            MD022093
112100200528      *                                                                                    AR1090283
112200200528     D BtnPressed      S             10                                                    AR1090283
112300200528     D***/COPY*OFCPYSRCZ,CAP090_001                                                    CAP090 CLE164
112400200528     D CAP090          S              1A                                                      CLE164
112500200528     D SBJBLen         S              4S 0                                                    CLE164
112600200528     D SBEXLen         S              4S 0                                                    CLE164
112700200528     D SBJBParm        S           2000A                                                      CLE164
112800200528     D/COPY OFCPYSRCZ,CGL135_041                                                             CGL135A
112900200528     D/COPY OFCPYSRCZ,CGL158_001                                                              CGL158
113000200528     D CUXCLn          S              4  0                                                    CGL132
113100200528     D FTCRLn          S              4  0                                                    CGL132
113200200528     D CRSSLn          S              4  0                                                    CGL157
113300200528     D CRDDLn          S              4  0                                                    CGL157
113400200528     D/COPY OFCPYSRCZ,CRE101_001                                                              CRE101
113500200528      ** +--- Start of main processing -----------------------------------+
113600200528
113700200528     C     *ENTRY        PLIST
113800200528     C                   PARM                    TransType
113900200528     C                   PARM                    Parm
114000200528     C                   PARM                    BufferTotal
114100200528     C                   PARM                    BufferEx2                                   BUG4646
114200200528     C                   PARM                    BufferEx3                                   BUG4646
114300200528     C                   PARM                    BufferEx4                                   BUG4646
114400200528     C                   PARM                    BufferEx5                                   BUG4646
114500200528     C                   PARM                    BufferEx6                                   BUG4646
114600200528     C                   PARM                    BufferEx7                                   BUG4646
114700200528     C                   PARM                    BufferEx8                                   BUG4646
114800200528     C                   PARM                    BufferEx9                                   BUG4646
114900200528     C                   PARM                    MsgArrOUT
115000200528     C                   PARM                    APIRetC
115100200528     C                   PARM                    ApHead                                     AR971184
115200200528      *
115300200528      * Extract entry parameters
115400200528     C                   Eval      APParm = Parm
115500200528                                                                                              BG0505
115600200528      * Block question marks in input buffer                                                  BG0505
115700200528                                                                                              BG0505
115800200528     C                   EXSR      BLOCK_QM                                                   BG0505
115900200528
116000200528      * Clear down buffers
116100200528     C                   Eval      Buffer = *BLANKS
116200200528     C                   Eval      Buffer2 = *BLANKS
116300200528      * Any API requiring more than 6000 should move the remaining BufferTotal
116400200528      * into Buffer2 here
116500200528     C                   Eval      Buffer = BufferTotal
116600200528     C                   MOVE      BufferTotal   Buffer2                                     BUG4646
116700200528     C                   EVAL      HeadIn = ApHead                                          AR971184
116800200528
116900200528      * Call the required API
117000200528
117100200528     C                   EXSR      CALLAPI
117200200528
117300200528      * Move the buffers into the full buffer
117400200528     C                   EVAL      BufferTotal = Buffer + Buffer2
117500200528                                                                                              BG0505
117600200528      * Add question mark error to warning messages                                           BG0505
117700200528                                                                                              BG0505
117800200528     C     QM_Blocked    IFEQ      'Y'                                                        BG0505
117900200528     C                   EXSR      ADD_QM_ERROR                                               BG0505
118000200528     C                   ENDIF                                                                BG0505
118100200528
118200200528      * Edit the Messages for output
118300200528
118400200528     C                   If        TransTYPE <> 'COLD'                                       BUG5728
118500200528     C                   EXSR      EDTMSGS
118600200528     C                   EndIf                                                               BUG5728
118700200528
118800200528     C                   SETON                                        LR
118900200528     C                   RETURN
119000200528      **********************************************************************
119100200528      /SPACE 5
119200200528      ****************************************************************
119300200528      * Call the required API
119400200528      ****************************************************************
119500200528     C     CALLAPI       BEGSR
119600200528
119700200528     C                   CLEAR                   TRANS1
119800200528     C                   CLEAR                   TRANS2
119900200528     C                   CLEAR                   TRANS2B                                    BUG11194
120000200528     C                   CLEAR                   TRANS3
120100200528     C                   CLEAR                   TRANS4
120200200528     C                   CLEAR                   TRANS4A                                     CSF011A
120300200528     C                   CLEAR                   TRANS5
120400200528     C                   CLEAR                   TRANS6
120500200528     C                   CLEAR                   TRANS7
120600200528     C                   CLEAR                   TRANS8
120700200528     C                   CLEAR                   TRANS9
120800200528     C                   CLEAR                   TRANS9A                                      CSW209
120900200528     C                   CLEAR                   TRANS9B                                      CSW209
121000200528     C                   CLEAR                   TRANS10                                      CSD079
121100200528     C                   CLEAR                   TRANSEXT                                     CSD079
121200200528     C                   CLEAR                   TRANS11                                      CSD079
121300200528     C                   CLEAR                   TRANS11B                                     CFT039
121400200528     C                   CLEAR                   TRANS12                                      CSD079
121500200528     C                   CLEAR                   TRANS13                                      CSD079
121600200528     C                   CLEAR                   TRANS14                                      CSD079
121700200528     C                   CLEAR                   TRANS15                                      CSD079
121800200528     C                   CLEAR                   TRANS16                                      CSD079
121900200528     C                   CLEAR                   TransSW                                    BUG14992
122000200528     C                   CLEAR                   TRANS17                                      CSD079
122100200528     C                   CLEAR                   TRANS18                                      CSD079
122200200528     C                   CLEAR                   BCLData                                      CSD079
122300200528     C                   CLEAR                   EurRepData                                   CSD079
122400200528     C                   CLEAR                   TRANS8A                                      CSD079
122500200528     C                   CLEAR                   TRANS8B                                      CSD079
122600200528     C                   CLEAR                   Trans83                                      CER059
122700200528     C                   CLEAR                   Trans84                                      CER059
122800200528     C                   CLEAR                   TransCUA1                                    CER059
122900200528     C                   CLEAR                   TransCUA2                                    CER059
123000200528     C                   CLEAR                   TransCUA3                                    CER059
123100200528     C                   CLEAR                   TransACT1                                    CER059
123200200528     C                   CLEAR                   TransACT2                                    CER059
123300200528     C                   CLEAR                   TransACT3                                    CER059
123400200528     C                   CLEAR                   TransACT4                                    CER059
123500200528     C                   CLEAR                   TransACT5                                    CER059
123600200528     C                   CLEAR                   TransACT6                                    CER059
123700200528     C                   CLEAR                   RegData                                      CSD079
123800200528     C                   CLEAR                   PaySttmt
123900200528     C                   CLEAR                   RecSttmt
124000200528     C                   CLEAR                   FRASttmt
124100200528     C                   CLEAR                   ExtData
124200200528     C                   CLEAR                   InfData
124300200528     C                   CLEAR                   FCIPNotes                                  BUG10093
124400200528     C                   CLEAR                   CustData                                     CER043
124500200528     C                   CLEAR                   StampTax                                     CER049
124600200528     C                   CLEAR                   TransQ                                       CER049
124700200528     C                   CLEAR                   InSwift2013                                  CSW213
124800200528     C***/COPY*OFCPYSRCZ,CAP090_002                                                    CAP090 CLE164
124900200528     C                   CLEAR                   SBJBParm                                     CLE164
125000200528     C                   CLEAR                   InputUser                                  MD042042
125100200528     C                   CLEAR                   InCDL099                                     CDL099
125200200528     C                   CLEAR                   AuthUsers                                    CFT163
125300200528     C/COPY OFCPYSRCZ,CGL135_042                                                             CGL135A
125400200528     C/COPY OFCPYSRCZ,CRE101_002                                                              CRE101
125500200528     C/COPY OFCPYSRCZ,CGL158_002                                                              CGL158
125600200528
125700200528      ** Position Buffer pointer to 1st byte
125800200528
125900200528     C                   Z-ADD     1             Bfp               4 0
126000200528     C                   Z-ADD     1             Bfp2              4 0                      BUG10296
126100200528
126200200528     C                   SELECT
126300200528
126400200528      * FX deals
126500200528
126600200528     C     TransTYPE     WHENEQ    'FXDL'
126700200528
126800200528     C                   EXSR      FXDLFmts
126900200528     C                   EXSR      SettleFmts
127000200528     C                   EXSR      RPIFFmts                                                   CSW213
127100200528
127200200528     C     FXDLLn        SUBST     BUFFER:Bfp    TRANS1
127300200528     C                   ADD       FXDLLn        Bfp
127400200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4087
127500200528     C                   ADD       26            Bfp                                         BUG4087
127600200528      *                                                                                       CER043
127700200528     C*****SDCULn        SUBST     BUFFER:Bfp    CustData                              CER043 CSF011
127800200528     C**********         ADD       SDCULn        Bfp                                   CER043 CSF011
127900200528      *                                                                                       CER043
128000200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
128100200528     C                   ADD       ESSRLn        Bfp
128200200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
128300200528     C                   ADD       ESSPLn        Bfp
128400200528     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CSW212
128500200528     C                   ADD       ESSFLn        Bfp                                          CSW212
128600200528     C*****CFIFLn        SUBST     BUFFER:Bfp    InfData                              CTI004 BUG2789
128700200528     C**********         ADD       CFIFLn        Bfp                                  CTI004 BUG2789
128800200528     C     FXIFLn        SUBST     BUFFER:Bfp    InfData                                     BUG4815
128900200528     C                   ADD       FXIFLn        Bfp                                         BUG4815
129000200528     C     FXFXLn        SUBST     BUFFER:Bfp    ExtData
129100200528     C                   ADD       FXFXLn        Bfp                                          CSW213
129200200528     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213
129300200528     C                   ADD       RPIFLn        Bfp                                          CDL099
129400200528     C     FXEDLn        SUBST     BUFFER:Bfp    InCDL099                                     CDL099
129500200528
129600200528     C                   CALL      'FXFXDLVU'
129700200528      * Common header information (DS) from source system
129800200528     C                   PARM                    HeadIn
129900200528      * Transaction information in a single large field from source system
130000200528     C                   PARM                    Trans1
130100200528     C**********         PARM                    CustData                              CER043 CSF011
130200200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
130300200528     C                   PARM                    PaySttmt
130400200528     C                   PARM                    RecSttmt
130500200528     C                   PARM                    FRASttmt
130600200528     C                   PARM                    InfData                                     BUG4815
130700200528     C                   PARM                    ExtData
130800200528     C                   PARM                    InSwift2013                                  CSW213
130900200528     C                   PARM                    FldNameArr
131000200528     C                   PARM                    MsgIDArr
131100200528     C                   PARM                    MsgDtaArr
131200200528     C                   PARM                    WFldNamArr
131300200528     C                   PARM                    WMsgIDArr
131400200528     C                   PARM                    WMsgDtaArr
131500200528     C                   PARM                    MsgFArray
131600200528     C                   PARM                    UpdateYN
131700200528     C                   PARM                    Buffer
131800200528     C                   PARM                    APIRetc
131900200528     C                   PARM                    @TimeStamp                                  BUG4190
132000200528     C                   PARM                    InCDL099                                     CDL099
132100200528                                                                                              CRE020
132200200528     C                   IF        CRE020 = 'Y'                                               CRE020
132300200528     C                   EVAL      WrkPgm = 'FXFXDLUPD'                                       CRE020
132400200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
132500200528     C                   EXSR      SRSndDtaQ                                                  CRE020
132600200528     C                   ENDIF                                                                CRE020
132700200528
132800200528      * MM Loan/deposit deals
132900200528
133000200528     C     TransTYPE     WHENEQ    'LDNI'
133100200528
133200200528     C                   EXSR      LDNIFmts
133300200528     C                   EXSR      SettleFmts
133400200528     C                   EXSR      FSettleFmts                                                CDL018
133500200528
133600200528     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
133700200528     C     LDNILn        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
133800200528     C                   ADD       LDNILn        Bfp
133900200528     C     LDIFLn        SUBST     BUFFER:Bfp    TRANS2
134000200528     C                   ADD       LDIFLn        Bfp
134100200528      **  Restore Timestamp field from the record                                            BUG3986
134200200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG3986
134300200528     C                   ADD       26            Bfp                                         BUG3986
134400200528      **  Send Block/Unblock action from the JSP action button                               BUG3684
134500200528     C     1             SUBST     BUFFER:Bfp    DDACTC                                      BUG3684
134600200528     C                   ADD       1             Bfp                                         BUG3684
134700200528      **  Send Placing/Taking indicator for JSP Block/Unblock conditioning.                  BUG3792
134800200528     C     1             SUBST     BUFFER:Bfp    PLATAK                                      BUG3792
134900200528     C                   ADD       1             Bfp                                         BUG3792
135000200528     C     1             SUBST     BUFFER:Bfp    ACTRJ                                      AR701789
135100200528     C                   ADD       1             Bfp                                        AR701789
135200200528     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
135300200528     C                   ADD       20            Bfp                                          239400
135400200528     C     FSSRLn        SUBST     BUFFER:Bfp    #FRECS                                       CDL018
135500200528     C                   ADD       FSSRLn        Bfp                                          CDL018
135600200528     C     FSSPLn        SUBST     BUFFER:Bfp    #FPAYS                                       CDL018
135700200528     C                   ADD       FSSPLn        Bfp                                          CDL018
135800200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
135900200528     C                   ADD       ESSRLn        Bfp
136000200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
136100200528     C                   ADD       ESSPLn        Bfp
136200200528     C     90            SUBST     BUFFER:Bfp    WDUMMY                                     BUG10563
136300200528     C                   ADD       90            Bfp                                        BUG10563
136400200528      *                                                                                       CER043
136500200528      ***Need*to*add*240*+*2072*to*extract*the*Customer*ease*of*use*details*         CER043 MD054028
136600200528      ** Need to add 240 + 2034 to extract the Customer ease of use details                 MD054028
136700200528      ** Narrative - 240 (SFNARR01 (60A) + SFNARR02 (60A) +                                   CER043
136800200528      **                  SFNARR03 (60A) + SFNARR04 (60A))                                    CER043
136900200528      ***Filler2*-*2072A***********************************************              CER043 MD054028
137000200528      ** Filler2 - 2034A                                                                    MD054028
137100200528      *                                                                                       CER043
137200200528     C                   ADD       240           Bfp                                          CER043
137300200528     C**********         ADD       2072          Bfp                                   CER043 CSF011
137400200528     C**********         ADD       605           Bfp                                   CSF011 CDL096
137500200528     C**********         ADD       571           Bfp                                   CDL096 CGL165
137600200528     C**********         ADD       567           Bfp                                   CGL165 CER050
137700200528     C**********         ADD       558           Bfp                                 CER050 MD054028
137800200528      ** Buffer1 has remaining 356 fields that should be empty because of Filler2           MD054028
137900200528     C                   ADD       356           Bfp                                        MD054028
138000200528      ** Remaining from Filler2 is 1678 = 2034 - 356                                        MD054028
138100200528                                                                                              CSF011
138200200528      ** Start of Buffer2                                                                     CSF011
138300200528                                                                                              CSF011
138400200528     C**********         ADD       1467          Bfp2                                CSF011 MD038485
138500200528     C**********         ADD       1681          Bfp2                                MD038485 CER050
138600200528     C**********         ADD       1680          Bfp2                                CER050 MD054028
138700200528     C                   ADD       1678          Bfp2                                       MD054028
138800200528      *                                                                                       CER043
138900200528     C*****LDSTQLn       SUBST     BUffer:Bfp    TransQ                             CER049 AR819540A
139000200528     C**********         ADD       LDSTQLn       Bfp                                CER049 AR819540A
139100200528                                                                                              CER049
139200200528     C*****SDCULn        SUBST     BUFFER:Bfp    CustData                              CER043 CSF011
139300200528     C**********         ADD       SDCULn        Bfp                                   CER043 CSF011
139400200528                                                                                           AR819540A
139500200528     C*****LDSTQLn       SUBST     BUffer:Bfp    TransQ                             AR819540A CSF011
139600200528     C**********         ADD       LDSTQLn       Bfp                                AR819540A CSF011
139700200528     C     LDSTQLn       SUBST     BUFFER2:Bfp2  TransQ                                       CSF011
139800200528     C                   ADD       LDSTQLn       Bfp2                                         CSF011
139900200528      *                                                                                       CER043
140000200528      ***This*should*be*reduced*everytime*a*core*field*is*added*on*the*buffer      BUG10296 BUG10563
140100200528     C*****3953**        SUBST     BUFFER2:Bfp2  LDNIFiller                        BUG10296 BUG10563
140200200528     C**********         ADD       3953          Bfp2                              BUG10296 BUG10563
140300200528                                                                                              CSF011
140400200528      ** Previous data: from Buffer excess and Buffer2 length: 4752                           CSF011
140500200528      ** Use current excess from Buffer2 then continue on BUfferEx2                           CSF011
140600200528                                                                                              CSF011
140700200528     C                   ADD       2437          Bfp2                                         CSF011
140800200528                                                                                              CSF011
140900200528      ** End of BUffer2                                                                       CSF011
141000200528      ** Reset Bfp2 to be re-use for BufferEx2                                                CSF011
141100200528                                                                                              CSF011
141200200528     C                   Z-ADD     1             Bfp2                                         CSF011
141300200528     C                   ADD       2315          Bfp2                                         CSF011
141400200528     C     4800          SUBST     BufferEx2:Bfp2RatDateDS                                  BUG10563
141500200528     C                   ADD       4800          Bfp2                                       BUG10563
141600200528     C*****4800*         SUBST     BufferEx2:Bfp2PayDateDS                           BUG10563 CSF011
141700200528     C**********         ADD       4800          Bfp2                                BUG10563 CSF011
141800200528     C     2884          SUBST     BufferEx2:Bfp2PayDateDS                                    CSF011
141900200528     C                   ADD       2884          Bfp2                                         CSF011
142000200528                                                                                              CSF011
142100200528      ** End of BufferEx2                                                                     CSF011
142200200528      ** Reset Bfp2 to be re-use for BufferEx3                                                CSF011
142300200528                                                                                              CSF011
142400200528     C                   Z-ADD     1             Bfp2                                         CSF011
142500200528     C                   ADD       1916          Bfp2                                         CSF011
142600200528     C*****LDRXLn        SUBST     BufferEx2:Bfp2RegData                             BUG10563 CSF011
142700200528     C     LDRXLn        SUBST     BufferEx3:Bfp2RegData                                      CSF011
142800200528     C*****LDRXLn        SUBST     BUFFER2:Bfp2  RegData                           BUG10296 BUG10563
142900200528     C*****LDRXLn        SUBST     BUFFER:Bfp    RegData                             CER001 BUG10296
143000200528     C**********         ADD       LDRXLn        Bfp                                 CER001 BUG10296
143100200528     C*****LDEXLn        SUBST     BUFFER:Bfp    ExtData                                    BUG10296
143200200528     C                   ADD       LDRXLn        Bfp2                                         248299
143300200528     C*****LDEXLn        SUBST     BufferEx2:Bfp2ExtData                               248299 CSF011
143400200528     C     LDEXLn        SUBST     BufferEx3:Bfp2ExtData                                      CSF011
143500200528     C                   ADD       LDEXLn        Bfp2                                         248299
143600200528
143700200528     C                   CALL      'MMLDNIVU'
143800200528      * Common header information (DS) from source system
143900200528     C                   PARM                    HeadIn
144000200528      * Transaction information in a single large field from source system
144100200528     C**********         PARM                    Trans1                                      CSF011A
144200200528     C                   PARM                    Trans1A                                     CSF011A
144300200528     C                   PARM                    Trans2
144400200528     C                   PARM                    TransQ                                       CER049
144500200528     C**********         PARM                    CustData                              CER043 CSF011
144600200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
144700200528     C                   PARM                    #FPAYS                                       CDL018
144800200528     C                   PARM                    #FRECS                                       CDL018
144900200528     C                   PARM                    PaySttmt
145000200528     C                   PARM                    RecSttmt
145100200528     C                   PARM                    FRASttmt
145200200528     C                   PARM                    RegData                                      CER001
145300200528     C                   PARM                    ExtData
145400200528     C                   PARM                    FldNameArr
145500200528     C                   PARM                    MsgIDArr
145600200528     C                   PARM                    MsgDtaArr
145700200528     C                   PARM                    WFldNamArr
145800200528     C                   PARM                    WMsgIDArr
145900200528     C                   PARM                    WMsgDtaArr
146000200528     C                   PARM                    MsgFArray
146100200528     C                   PARM                    UpdateYN
146200200528     C                   PARM                    Buffer
146300200528     C                   PARM                    Buffer2                                      CDL033
146400200528     C                   PARM                    BufferEx2                                    CDL033
146500200528     C                   PARM                    BufferEx3                                    CSF011
146600200528     C                   PARM                    APIRetc
146700200528     C                   PARM                    @TimeStamp                                  BUG3986
146800200528     C                   PARM                    DDACTC                                      BUG3684
146900200528     C                   PARM                    PLATAK                                      BUG3792
147000200528     C                   PARM                    ACTRJ                                      AR701789
147100200528     C                   PARM                    DDFOID                                       239400
147200200528                                                                                              CRE020
147300200528     C                   IF        CRE020 = 'Y'                                               CRE020
147400200528     C                   EVAL      WrkPgm = 'MMLDNIUPD'                                       CRE020
147500200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
147600200528     C                   EXSR      SRSndDtaQ                                                  CRE020
147700200528     C                   ENDIF                                                                CRE020
147800200528
147900200528      * Incoming Payments
148000200528
148100200528     C     TransTYPE     WHENEQ    'IPAY'
148200200528
148300200528     C                   EXSR      IPAYFmts
148400200528
148500200528     C*****IPY1Ln        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
148600200528     C     IPY1Ln        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
148700200528     C                   ADD       IPY1Ln        Bfp
148800200528     C     IPY2Ln        SUBST     BUFFER:Bfp    TRANS2
148900200528     C                   ADD       IPY2Ln        Bfp
149000200528     C*****IPY3Ln        SUBST     BUFFER:Bfp    TRANS3                                      CSF011A
149100200528     C     IPY3Ln        SUBST     BUFFER:Bfp    TRANS3A                                     CSF011A
149200200528     C                   ADD       IPY3Ln        Bfp
149300200528     C     IPY4Ln        SUBST     BUFFER:Bfp    TRANS4
149400200528     C                   ADD       IPY4Ln        Bfp
149500200528     C*****IPY5Ln        SUBST     BUFFER:Bfp    TRANS5                                      CSF011A
149600200528     C     IPY5Ln        SUBST     BUFFER:Bfp    TRANS5A                                     CSF011A
149700200528     C                   ADD       IPY5Ln        Bfp
149800200528     C     IPY6Ln        SUBST     BUFFER:Bfp    TRANS6
149900200528     C                   ADD       IPY6Ln        Bfp
150000200528     C     IPY7Ln        SUBST     BUFFER:Bfp    TRANS7
150100200528     C                   ADD       IPY7Ln        Bfp
150200200528     C     IPY8Ln        SUBST     BUFFER:Bfp    TRANS8
150300200528     C                   ADD       IPY8Ln        Bfp
150400200528     C                   IF        CSW209 = 'Y'                                             BUG25664
150500200528     C     IPY9ALn       SUBST     BUFFER:Bfp    TRANS9A                                      CSW209
150600200528     C                   ADD       IPY9ALn       Bfp                                          CSW209
150700200528     C     IPY9BLn       SUBST     BUFFER:Bfp    TRANS9B                                      CSW209
150800200528     C                   ADD       IPY9BLn       Bfp                                          CSW209
150900200528     C                   ENDIF                                                              BUG25664
151000200528      *                                                                                       CER030
151100200528     C     IPY9Ln        SUBST     BUFFER:Bfp    TRANS9                                       CER030
151200200528     C                   ADD       IPY9Ln        Bfp                                          CER030
151300200528      *                                                                                       CER030
151400200528      **  Restore Timestamp field from the record                                            BUG4196
151500200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4196
151600200528     C                   ADD       26            Bfp                                         BUG4196
151700200528      **  Restore value of Newbutton                                                          255190
151800200528     C     3             SUBST     BUFFER:Bfp    NewButton                                    255190
151900200528     C                   ADD       3             Bfp                                          255190
152000200528      *                                                                                       CER049
152100200528     C     IPY10Ln       SUBST     BUFFER:Bfp    TRANS10                                      CER049
152200200528     C                   ADD       IPY10Ln       Bfp                                          CER049
152300200528      *                                                                                    AR1002463
152400200528     C     1             SUBST     BUFFER:Bfp    AAuth                                     AR1002463
152500200528     C                   ADD       1             Bfp                                       AR1002463
152600200528     C     10            SUBST     BUFFER:Bfp    BtnPressed                                AR1090283
152700200528     C                   ADD       10            Bfp                                       AR1090283
152800200528      *                                                                                     MD042042
152900200528     C     IPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD042042
153000200528     C                   ADD       IPEXLn        Bfp                                        MD042042
153100200528      *                                                                                     MD042042
153200200528     C     10            SUBST     BUFFER:Bfp    InputUser                                  MD042042
153300200528     C                   ADD       10            Bfp                                        MD042042
153400200528     C/COPY WNCPYSRC,APH00058
153500200528      *                                                                                       CER049
153600200528     C     IPRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
153700200528     C                   ADD       IPRXLn        Bfp                                          CER001
153800200528     C*****IPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD042042
153900200528     C**********         ADD       IPEXLn        Bfp                               BUG22140 MD042042
154000200528     C/COPY WNCPYSRC,APH00059
154100200528     C*****1****         SUBST     BUFFER:Bfp    AAuth                            BUG22140 AR1002463
154200200528     C**********         ADD       1             Bfp                              BUG22140 AR1002463
154300200528     C/COPY WNCPYSRC,APH00060
154400200528     C     StopIPLen     SUBST     BUFFER:Bfp    StopFTDta                                  MD050928
154500200528     C                   ADD       StopIPLen     Bfp                                        MD050928
154600200528
154700200528     C                   CALL      'FTIPAYVU'
154800200528      * Common header information (DS) from source system
154900200528     C                   PARM                    HeadIn
155000200528      * Transaction information
155100200528     C**********         PARM                    Trans1                                      CSF011A
155200200528     C                   PARM                    Trans1A                                     CSF011A
155300200528     C                   PARM                    Trans2
155400200528     C**********         PARM                    Trans3                                      CSF011A
155500200528     C                   PARM                    Trans3A                                     CSF011A
155600200528     C                   PARM                    Trans4
155700200528     C**********         PARM                    Trans5                                      CSF011A
155800200528     C                   PARM                    Trans5A                                     CSF011A
155900200528     C                   PARM                    Trans6
156000200528     C                   PARM                    Trans7
156100200528     C                   PARM                    Trans8
156200200528     C                   PARM                    Trans9A                                      CSW209
156300200528     C                   PARM                    Trans9B                                      CSW209
156400200528     C                   PARM                    Trans9                                       CER030
156500200528     C                   PARM                    Trans10                                      CER049
156600200528      ** Extra Data
156700200528     C                   PARM                    RegData                                      CER001
156800200528     C                   PARM                    ExtData
156900200528     C                   PARM                    StopFTDta                                  MD050928
157000200528      ** Error fields/message IDs/message data (arrays) from/to caller
157100200528     C                   PARM                    FldNameArr
157200200528     C                   PARM                    MsgIDArr
157300200528     C                   PARM                    MsgDtaArr
157400200528     C                   PARM                    WFldNamArr
157500200528     C                   PARM                    WMsgIDArr
157600200528     C                   PARM                    WMsgDtaArr
157700200528     C                   PARM                    MsgFArray
157800200528     C                   PARM                    UpdateYN
157900200528     C                   PARM                    Buffer
158000200528     C                   PARM                    APIRetc
158100200528     C                   PARM                    @TimeStamp                                  BUG4196
158200200528     C                   PARM                    NewButton                                    255190
158300200528     C                   PARM                    AAuth                                      BUG22140
158400200528     C                   PARM                    InputUser                                  MD042042
158500200528                                                                                              CRE020
158600200528     C                   IF        CRE020 = 'Y'                                               CRE020
158700200528     C                   EVAL      WrkPgm = 'FTIPAYUPD'                                       CRE020
158800200528     C                   EVAL      WrkMod = 'FT'                                              CRE020
158900200528     C                   EXSR      SRSndDtaQ                                                  CRE020
159000200528     C                   ENDIF                                                                CRE020
159100200528
159200200528      * Outgoing payments
159300200528
159400200528     C     TransTYPE     WHENEQ    'OPAY'
159500200528
159600200528     C                   EXSR      OPAYFmts
159700200528
159800200528     C*****OPY1Ln        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
159900200528     C     OPY1Ln        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
160000200528     C                   ADD       OPY1Ln        Bfp
160100200528     C*****OPY2Ln        SUBST     BUFFER:Bfp    TRANS2                                      CSF011A
160200200528     C     OPY2Ln        SUBST     BUFFER:Bfp    TRANS2A                                     CSF011A
160300200528     C                   ADD       OPY2Ln        Bfp
160400200528     C*****OPY3Ln        SUBST     BUFFER:Bfp    TRANS3                                      CSF011A
160500200528     C     OPY3Ln        SUBST     BUFFER:Bfp    TRANS3A                                     CSF011A
160600200528     C                   ADD       OPY3Ln        Bfp
160700200528     C*****OPY4Ln        SUBST     BUFFER:Bfp    TRANS4                                       CFT120
160800200528     C     OPY4Ln        SUBST     BUFFER:Bfp    TRANS4A                                      CFT120
160900200528     C                   ADD       OPY4Ln        Bfp
161000200528     C     OPY5Ln        SUBST     BUFFER:Bfp    TRANS5
161100200528     C                   ADD       OPY5Ln        Bfp
161200200528     C*****OPY6Ln        SUBST     BUFFER:Bfp    TRANS6                                      CSF011A
161300200528     C*****OPY6Ln        SUBST     BUFFER:Bfp    TRANS6A                              CSF011A CFT120
161400200528     C     OPY6Ln        SUBST     BUFFER:Bfp    TRANS6                                       CFT120
161500200528     C                   ADD       OPY6Ln        Bfp
161600200528     C     OPY7Ln        SUBST     BUFFER:Bfp    TRANS7
161700200528     C                   ADD       OPY7Ln        Bfp
161800200528     C     OPY7Ln        SUB       500           OPY8Ln            4 0
161900200528     C                   SUB       OPY8Ln        Bfp
162000200528     C     OPY8Ln        SUBST     BUFFER:Bfp    TRANS8
162100200528     C                   ADD       OPY8Ln        Bfp
162200200528     C     OPY9Ln        SUBST     BUFFER:Bfp    TRANS9
162300200528     C                   ADD       OPY9Ln        Bfp
162400200528     C                   IF        CSW209 = 'Y'                                             BUG25664
162500200528     C     OPY10Ln       SUBST     BUFFER:Bfp    TRANS9A                                      CSW209
162600200528     C                   ADD       OPY10Ln       Bfp                                          CSW209
162700200528     C     OPY11Ln       SUBST     BUFFER:Bfp    TRANS9B                                      CSW209
162800200528     C                   ADD       OPY11Ln       Bfp                                          CSW209
162900200528     C                   ENDIF                                                              BUG25664
163000200528      *                                                                                       CER030
163100200528     C     OPY10LAn      SUBST     BUFFER:Bfp    TRANS10A                                     CER030
163200200528     C                   ADD       OPY10LAn      Bfp                                          CER030
163300200528      *                                                                                       CER030
163400200528     C     OPY11LAn      SUBST     BUFFER:Bfp    TRANS11A                                     CER030
163500200528     C                   ADD       OPY11LAn      Bfp                                          CER030
163600200528      *                                                                                       CER030
163700200528      **  Restore Timestamp field from the record                                            BUG4196
163800200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4196
163900200528     C                   ADD       26            Bfp                                         BUG4196
164000200528     C     WLCLn         SUBST     BUFFER:Bfp    WLCData                                      CSD083
164100200528     C                   ADD       WLCLn         Bfp                                          CSD083
164200200528     C                   EVAL      TRANS11B = %SUBST(WLCData:9:176)                           CFT039
164300200528     C*****OPY12Ln       SUBST     BUFFER:Bfp    TRANS12                               CER049 CFT120
164400200528     C**********         ADD       OPY12Ln       Bfp                                   CER049 CFT120
164500200528     C*****19            SUBST     BUFFER:Bfp    #TempData        19                   CFT120 CFT157
164600200528     C*****              ADD       19            Bfp                                   CFT120 CFT157
164700200528     C*****9             SUBST     BUFFER:Bfp    #TempData         9                CFT157 MD050928A
164800200528     C******             ADD       9             Bfp                                CFT157 MD050928A
164900200528     C     19            SUBST     BUFFER:Bfp    #TempData        19                       MD050928A
165000200528     C                   ADD       19            Bfp                                       MD050928A
165100200528      *                                                                                    AR1002463
165200200528     C*****1****         SUBST     BUFFER:Bfp    AAuth                              AR1002463 CFT120
165300200528     C**********         ADD       1             Bfp                                AR1002463 CFT120
165400200528     C*****1             SUBST     BUFFER2:Bfp2  #TempData2        1                   CFT120 CFT157
165500200528     C*****              ADD       1             Bfp2                                  CFT120 CFT157
165600200528     C*****11            SUBST     BUFFER2:Bfp2  #TempData2       11                CFT157 MD050928A
165700200528     C*****              ADD       11            Bfp2                               CFT157 MD050928A
165800200528     C     1             SUBST     BUFFER2:Bfp2  #TempData2        1                       MD050928A
165900200528     C                   ADD       1             Bfp2                                      MD050928A
166000200528     C                   MOVEL     #TempData     #TempTrans12     20                          CFT120
166100200528     C                   MOVE      #TempData2    #TempTrans12                                 CFT120
166200200528     C                   EVAL      TRANS12 = #TempTrans12                                     CFT120
166300200528      *                                                                                       CFT120
166400200528     C     1             SUBST     BUFFER2:Bfp2  AAuth                                        CFT120
166500200528     C                   ADD       1             Bfp2                                         CFT120
166600200528     C     10            SUBST     BUFFER:Bfp2   BtnPressed                                 MD039986
166700200528     C                   ADD       10            Bfp2                                       MD039986
166800200528      *                                                                                     MD042042
166900200528     C     OPEXLn        SUBST     BUFFER2:Bfp2  ExtData                                    MD042042
167000200528     C                   ADD       OPEXLn        Bfp2                                       MD042042
167100200528      *                                                                                     MD042042
167200200528     C     10            SUBST     BUFFER2:Bfp2  InputUser                                  MD042042
167300200528     C                   ADD       10            Bfp2                                       MD042042
167400200528      *                                                                                    AR1002463
167500200528     C*****2****         SUBST     BUFFER:Bfp    TempData#3                         CSF011 AR1005984
167600200528     C/COPY WNCPYSRC,APH00061
167700200528     C**********         ADD       2             Bfp                                CSF011 AR1005984
167800200528     C*****1****         SUBST     BUFFER:Bfp    TempData#3                         AR1005984 CFT120
167900200528     C**********         ADD       1             Bfp                                AR1005984 CFT120
168000200528     C**********         SUB       2             OPRXLn                             CSF011 AR1005984
168100200528     C**********         SUB       1             OPRXLn                             AR1005984 CFT120
168200200528     C*****OPRXLn        SUBST     BUFFER:Bfp    RegData                               CER001 CSF011
168300200528     C*****OPRXLn        SUBST     BUFFER2:Bfp2  TempData#4                            CSF011 CFT120
168400200528     C     OPRXLn        SUBST     BUFFER2:Bfp2  RegData                                      CFT120
168500200528     C**********         MOVEL     TempData#3    RegData                               CSF011 CFT120
168600200528     C**********         MOVE      TempData#4    RegData                               CSF011 CFT120
168700200528     C**********         ADD       OPRXLn        Bfp                                   CER001 CSF011
168800200528     C*****OPEXLn        SUBST     BUFFER:Bfp    ExtData                                      CSF011
168900200528     C**********         ADD       OPEXLn        Bfp                                 BUG22140 CSF011
169000200528     C*****1****         SUBST     BUFFER:Bfp    AAuth                               BUG22140 CSF011
169100200528     C**********         ADD       1             Bfp                                 BUG22140 CSF011
169200200528     C                   ADD       OPRXLn        Bfp2                                         CSF011
169300200528     C*****OPEXLn        SUBST     BUFFER2:Bfp2  ExtData                             CSF011 MD042042
169400200528     C**********         ADD       OPEXLn        Bfp2                                CSF011 MD042042
169500200528     C/COPY WNCPYSRC,APH00062
169600200528     C*****1****         SUBST     BUFFER2:Bfp2  AAuth                              CSF011 AR1002463
169700200528     C**********         ADD       1             Bfp2                               CSF011 AR1002463
169800200528     C/COPY WNCPYSRC,APH00063
169900200528     C                   EVAL      StopFTDta = %SUBST(BUFFER2:Bfp2:StopOPLen)               MD050928
170000200528     C                   ADD       StopOPLen     Bfp2                                       MD050928
170100200528
170200200528     C                   CALL      'FTOPAYVU'
170300200528      * Common header information (DS) from source system
170400200528     C                   PARM                    HeadIn
170500200528      * Transaction information
170600200528     C**********         PARM                    Trans1                                      CSF011A
170700200528     C**********         PARM                    Trans2                                      CSF011A
170800200528     C**********         PARM                    Trans3                                      CSF011A
170900200528     C                   PARM                    Trans1A
171000200528     C                   PARM                    Trans2A
171100200528     C                   PARM                    Trans3A
171200200528     C**********         PARM                    Trans4                                       CFT120
171300200528     C                   PARM                    Trans4A                                      CFT120
171400200528     C                   PARM                    Trans5
171500200528     C**********         PARM                    Trans6                                      CSF011A
171600200528     C**********         PARM                    Trans6A                              CSF011A CFT120
171700200528     C                   PARM                    Trans6                                       CFT120
171800200528     C                   PARM                    Trans7
171900200528     C                   PARM                    Trans8
172000200528     C                   PARM                    Trans9
172100200528     C                   PARM                    Trans9A                                      CSW209
172200200528     C                   PARM                    Trans9B                                      CSW209
172300200528     C                   PARM                    Trans10A                                     CER030
172400200528     C                   PARM                    Trans11A                                     CER030
172500200528     C                   PARM                    Trans11B                                     CFT039
172600200528     C                   PARM                    Trans12                                      CER049
172700200528
172800200528     C                   PARM                    RegData                                      CER001
172900200528     C                   PARM                    ExtData
173000200528     C                   PARM                    StopFTDta                                  MD050928
173100200528
173200200528     C                   PARM                    FldNameArr
173300200528     C                   PARM                    MsgIDArr
173400200528     C                   PARM                    MsgDtaArr
173500200528     C                   PARM                    WFldNamArr
173600200528     C                   PARM                    WMsgIDArr
173700200528     C                   PARM                    WMsgDtaArr
173800200528     C                   PARM                    MsgFArray
173900200528     C                   PARM                    UpdateYN
174000200528     C                   PARM                    Buffer
174100200528     C                   PARM                    Buffer2                                      CSF011
174200200528     C                   PARM                    APIRetc
174300200528     C                   PARM                    @TimeStamp                                  BUG4196
174400200528     C                   PARM                    AAuth                                      BUG22140
174500200528     C                   PARM                    InputUser                                  MD042042
174600200528                                                                                              CRE020
174700200528     C                   IF        CRE020 = 'Y'                                               CRE020
174800200528     C                   EVAL      WrkPgm = 'FTOPAYUPD'                                       CRE020
174900200528     C                   EVAL      WrkMod = 'FT'                                              CRE020
175000200528     C                   EXSR      SRSndDtaQ                                                  CRE020
175100200528     C                   ENDIF                                                                CRE020
175200200528
175300200528      * GL Accounts Maintenance
175400200528
175500200528     C     TransTYPE     WHENEQ    'AMAD'
175600200528     C     TransTYPE     OREQ      'ACMC'                                                     CRE026
175700200528     C     TransTYPE     OREQ      'ACMI'                                                     CRE026
175800200528     C     TransTYPE     OREQ      'ACMN'                                                     CRE026
175900200528
176000200528     C                   EXSR      AMADFmts
176100200528
176200200528     C*****AMMDLn        SUBST     BUFFER:Bfp    TRANS1                                     MD044880
176300200528     C                   EVAL      TRANS1 = %SUBST(BufferTotal:Bfp:AMMDLn)                  MD044880
176400200528     C                   ADD       AMMDLn        Bfp
176500200528     C*****AMDILn        SUBST     BUFFER:Bfp    TRANS2                                     MD044880
176600200528     C                   EVAL      TRANS2 = %SUBST(BufferTotal:Bfp:AMDILn)                  MD044880
176700200528     C                   ADD       AMDILn        Bfp
176800200528     C*****AMCILn        SUBST     BUFFER:Bfp    TRANS3                                     MD044880
176900200528     C                   EVAL      TRANS3 = %SUBST(BufferTotal:Bfp:AMCILn)                  MD044880
177000200528     C                   ADD       AMCILn        Bfp
177100200528     C*****AMCOLn        SUBST     BUFFER:Bfp    TRANS4                                     MD044880
177200200528     C                   EVAL      TRANS4 = %SUBST(BufferTotal:Bfp:AMCOLn)                  MD044880
177300200528     C                   ADD       AMCOLn        Bfp
177400200528     C*****AMODLn        SUBST     BUFFER:Bfp    TRANS5                                     MD044880
177500200528     C                   EVAL      TRANS5 = %SUBST(BufferTotal:Bfp:AMODLn)                  MD044880
177600200528     C                   ADD       AMODLn        Bfp                                         BUG4196
177700200528      **  Restore Timestamp field from the record                                            BUG4196
177800200528     C*****26***         SUBST     BUFFER:Bfp    @TimeStamp                         BUG4196 MD044880
177900200528     C                   EVAL      @TimeStamp = %SUBST(BufferTotal:Bfp:26)                  MD044880
178000200528     C                   ADD       26            Bfp                                         BUG4196
178100200528     C*****AMADFLn       SUBST     BUFFER:Bfp    AMADFiller                         BUG5988 MD044880
178200200528     C                   EVAL      AMADFiller = %SUBST(BufferTotal:Bfp:AMADFLn)             MD044880
178300200528     C                   ADD       AMADFLn       Bfp                                         BUG5988
178400200528     C*****AMPPLn1       SUBST     BUFFER:Bfp    TRANS6                              CRE015 MD044880
178500200528     C                   EVAL      TRANS6 = %SUBST(BufferTotal:Bfp:AMPPLn1)                 MD044880
178600200528     C                   ADD       AMPPLn1       Bfp                                          CRE015
178700200528     C*****124**         SUBST     BUFFER:Bfp    StampTax                            CER049 MD044880
178800200528     C                   EVAL      StampTax = %SUBST(BufferTotal:Bfp:124)                   MD044880
178900200528     C                   ADD       124           Bfp                                          CER049
179000200528     C*****24***         SUBST     BUFFER:Bfp    GLFullAcct                        MD026979 MD044880
179100200528     C                   EVAL      GLFullAcct = %SUBST(BufferTotal:Bfp:24)                  MD044880
179200200528     C                   ADD       24            Bfp                                        MD026979
179300200528     C***/COPY*OFCPYSRCZ,CRE101_003                                                  CRE101 MD044880
179400200528     C                   EVAL      ACMILn = 10                                              MD054028
179500200528     C                   EVAL      ACMIData = %SUBST(BufferTotal:Bfp:ACMILn)                MD044880
179600200528     C                   ADD       ACMILn        Bfp                                        MD044880
179700200528     C*****AMIFLn        SUBST     BUFFER:Bfp    InfData                             CAP086 MD044880
179800200528     C                   EVAL      InfData = %SUBST(BufferTotal:Bfp:AMIFLn)                 MD044880
179900200528     C                   ADD       AMIFLn        Bfp                                        BUG10280
180000200528     C                   EVAL      ExtData = %SUBST(BufferTotal:Bfp:AMEXLn)                 MD044880
180100200528     C                   ADD       AMEXLn        Bfp                                        MD044800
180200200528                                                                                            MD054028
180300200528      *** APR Fields for AMAD (CER050)                                                      MD054028
180400200528     C     AMCR50Ln      SUBST     BUFFER:Bfp    AMAPRDta         17                        MD054028
180500200528     C                   EVAL      ExtData = %SUBST(ExtData:1:AMEXLn) + AMAPRDta            MD054028
180600200528     C                   ADD       AMCR50Ln      Bfp                                        MD054028
180700200528                                                                                            MD054028
180800200528     C                   EVAL      RepeatData = %SUBST(BufferTotal:Bfp:AMPPLn2)             MD044880
180900200528     C                   ADD       AMPPLn2       Bfp                                        MD044880
181000200528     C                   EVAL      RegData = %SUBST(BufferTotal:Bfp:AMRXLn)                 MD044880
181100200528     C                   ADD       AMRXLn        Bfp                                        MD044880
181200200528     C*****AMPPLn2       SUBST     BUFFER:Bfp    RepeatData                            CRE015 CRE073
181300200528     C**********         ADD       AMPPLn2       Bfp                                   CRE015 CRE073
181400200528     C*****AMRXLn        SUBST     BUFFER:Bfp    RegData                               CER001 CRE073
181500200528     C**********         ADD       AMRXLn        Bfp                                   CER001 CRE073
181600200528     C*****AMEXLn        SUBST     BUFFER:bfp    Extdata                             BUG10280 CRE073
181700200528     C**********         ADD       AMEXLn        Bfp                                 BUG10280 CRE073
181800200528     C*****4972*         SUBST     BUFFER:Bfp    TempData#1                           CRE073 CSF011A
181900200528     C**********         ADD       4972          Bfp                                  CRE073 CSF011A
182000200528     C*****410**         SUBST     BUFFER2:Bfp2  TempData#2                           CRE073 CSF011A
182100200528     C*****4932*         SUBST     BUFFER:Bfp    TempData#1                         CSF011A AR946674
182200200528     C**********         ADD       4932          Bfp                                CSF011A AR946674
182300200528     C*****4923*         SUBST     BUFFER:Bfp    TempData#1                        AR946674 MD026979
182400200528     C**********         ADD       4923          Bfp                               AR946674 MD026979
182500200528     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
182600200528     C*****4899*         SUBST     BUFFER:Bfp    TempData#1                        MD026979 MD044880
182700200528     C**********         ADD       4899          Bfp                               MD026979 MD044880
182800200528     C***/COPY*OFCPYSRCZ,CRE101_064                                                  CRE101 MD044880
182900200528     C*****450**         SUBST     BUFFER2:Bfp2  TempData#2                         CSF011A AR946674
183000200528     C*****459**         SUBST     BUFFER2:Bfp2  TempData#2                        AR946674 MD026979
183100200528     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
183200200528     C*****483**         SUBST     BUFFER2:Bfp2  TempData#2                        MD026979 MD044880
183300200528     C***/COPY*OFCPYSRCZ,CRE101_065                                                  CRE101 MD044880
183400200528     C**********         MOVEL     TempData#1    RepeatData                          CRE073 MD044880
183500200528     C**********         MOVE      TempData#2    RepeatData                          CRE073 MD044880
183600200528     C**********         ADD       410           Bfp2                                 CRE073 CSF011A
183700200528     C*****AMRXLn        SUBST     BUFFER:Bfp2   InfData                              CRE073 CSF011A
183800200528     C**********         ADD       AMRXLn        Bfp                                  CRE073 CSF011A
183900200528     C**********         ADD       450           Bfp2                               CSF011A AR946674
184000200528     C**********         ADD       459           Bfp2                              AR946674 MD026979
184100200528     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
184200200528     C**********         ADD       483           Bfp2                              MD026979 MD044880
184300200528     C***/COPY*OFCPYSRCZ,CRE101_066                                                  CRE101 MD044880
184400200528     C*****AMRXLn        SUBST     BUFFER2:Bfp2  RegData                            CSF011A MD044880
184500200528     C**********         ADD       AMRXLn        Bfp2                               CSF011A MD044880
184600200528     C*****AMEXLn        SUBST     BUFFER2:Bfp2  Extdata                             CRE073 MD044880
184700200528     C**********         ADD       AMEXLn        Bfp2                                CRE073 MD044880
184800200528      ** Remove fix MD054028                                                                MD054538
184900200528     C**********         EVAL      Buffer9999 = Buffer + Buffer2                   MD054028 MD054538
185000200528
185100200528     C                   CALL      'GLAMADVU'
185200200528      * Common header information (DS) from source system
185300200528     C                   PARM                    HeadIn
185400200528      * Transaction information
185500200528     C                   PARM                    Trans1
185600200528     C                   PARM                    Trans2
185700200528     C                   PARM                    Trans3
185800200528     C                   PARM                    Trans4
185900200528     C                   PARM                    Trans5
186000200528     C                   PARM                    Trans6                                       CRE015
186100200528     C                   PARM                    StampTax                                     CER049
186200200528     C/COPY OFCPYSRCZ,CRE101_004                                                              CRE101
186300200528     C                   PARM                    InfData                                      CAP086
186400200528     C                   PARM                    RegData                                      CER001
186500200528     C                   PARM                    ExtData
186600200528     C                   PARM                    RepeatData                                   CRE015
186700200528     C                   PARM                    FldNameArr
186800200528     C                   PARM                    MsgIDArr
186900200528     C                   PARM                    MsgDtaArr
187000200528     C                   PARM                    WFldNamArr
187100200528     C                   PARM                    WMsgIDArr
187200200528     C                   PARM                    WMsgDtaArr
187300200528     C                   PARM                    MsgFArray
187400200528     C                   PARM                    UpdateYN
187500200528     C**********         PARM                    Buffer                                     MD044880
187600200528     C**********         PARM                    Buffer2                             CRE073 MD044880
187700200528     C                   PARM                    Buffer9999                                 MD044880
187800200528     C                   PARM                    APIRetc
187900200528     C                   PARM                    @TimeStamp                                  BUG4196
188000200528     C                   PARM                    GLFullAcct                                 MD026979
188100200528
188200200528     C                   MOVEL     Buffer9999    Buffer                                     MD044880
188300200528     C                   MOVE      Buffer9999    Buffer2                                    MD044880
188400200528
188500200528      * GL Journal Entry Header Maintenance
188600200528      * GL Journal Entry Header Maintenance - Non-retail                                     BUG9009
188700200528
188800200528     C     TransTYPE     WHENEQ    'BITH'
188900200528     C     TransTYPE     OrEq      'BINH'                                                    BUG9009
189000200528
189100200528     C                   EXSR      BITHFmts
189200200528
189300200528     C     BITHLn        SUBST     BUFFER:Bfp    TRANS1
189400200528     C                   ADD       BITHLn        Bfp
189500200528     C     8             SUBST     BUFFER:Bfp    PEAHeader         8                          CSC054
189600200528     C                   ADD       8             Bfp                                          CSC054
189700200528     C     GLIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
189800200528     C                   ADD       GLIFLn        Bfp                                          CAP086
189900200528     C     BHEXLn        SUBST     BUFFER:Bfp    ExtData
190000200528     C                   ADD       BHEXLn        Bfp                                        MD054696
190100200528     C     1             SUBST     BUFFER:Bfp    PShadowPost       1                        MD054696
190200200528     C                   ADD       1             Bfp                                        MD054696
190300200528
190400200528     C                   CALL      'GLBITHVU'
190500200528      * Common header information (DS) from source system
190600200528     C                   PARM                    HeadIn
190700200528      * Transaction information
190800200528     C                   PARM                    Trans1
190900200528     C                   PARM                    PEAHeader                                    CSC054
191000200528     C                   PARM                    InfData                                      CAP086
191100200528     C                   PARM                    ExtData
191200200528     C                   PARM                    PShadowPost                                MD054696
191300200528     C                   PARM                    FldNameArr
191400200528     C                   PARM                    MsgIDArr
191500200528     C                   PARM                    MsgDtaArr
191600200528     C                   PARM                    WFldNamArr
191700200528     C                   PARM                    WMsgIDArr
191800200528     C                   PARM                    WMsgDtaArr
191900200528     C                   PARM                    MsgFArray
192000200528     C                   PARM                    UpdateYN
192100200528     C                   PARM                    Buffer
192200200528     C                   PARM                    APIRetc
192300200528
192400200528      * GL Journal Entry Item Maintenance
192500200528      * GL Journal Entry Item Maintenance - Non-retail                                       BUG9009
192600200528
192700200528     C     TransTYPE     WHENEQ    'BITP'
192800200528     C     TransTYPE     OrEq      'BINP'                                                    BUG9009
192900200528
193000200528     C                   EXSR      BITPFmts
193100200528
193200200528     C     BITPLn        SUBST     BUFFER:Bfp    TRANS1
193300200528     C                   ADD       BITPLn        Bfp
193400200528     C     BIPXLn        SUBST     BUFFER:Bfp    OthData                                      246418
193500200528     C                   ADD       BIPXLn        Bfp                                          246418
193600200528      *                                                                                     BUG23742
193700200528     C     500           SUBST     BUFFER:Bfp    POthNarr1                                  BUG23742
193800200528     C                   ADD       500           Bfp                                        BUG23742
193900200528      *                                                                                     BUG23742
194000200528     C     270           SUBST     BUFFER:Bfp    POthNarr2                                  BUG23742
194100200528     C                   ADD       270           Bfp                                        BUG23742
194200200528      *                                                                                     BUG23742
194300200528     C*****13***         SUBST     BUFFER:Bfp    PEADetail        13                CSC054 AR1005162
194400200528     C**********         ADD       13            Bfp                                CSC054 AR1005162
194500200528     C     15            SUBST     BUFFER:Bfp    PEADetail        15                       AR1005162
194600200528     C                   ADD       15            Bfp                                       AR1005162
194700200528      *                                                                                       CSC054
194800200528     C/COPY OFCPYSRCZ,CGL135_043                                                             CGL135A
194900200528     C     1             SUBST     BUFFER:Bfp    VDFLTF            1                        MD052075
195000200528     C                   ADD       1             Bfp                                        MD052075
195100200528     C
195200200528     C     BPRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
195300200528     C                   ADD       BPRXLn        Bfp                                          CER001
195400200528     C     BPEXLn        SUBST     BUFFER:Bfp    ExtData
195500200528
195600200528     C                   CALL      'GLBITPVU'
195700200528      * Common header information (DS) from source system
195800200528     C                   PARM                    HeadIn
195900200528      * Transaction information
196000200528     C                   PARM                    Trans1
196100200528     C                   PARM                    OthData                                      246418
196200200528     C                   PARM                    POthNarr1                                  BUG23742
196300200528     C                   PARM                    POthNarr2                                  BUG23742
196400200528     C                   PARM                    PEADetail                                    CSC054
196500200528     C/COPY OFCPYSRCZ,CGL135_044                                                             CGL135A
196600200528      ** CGL150 Default Value Date 'Y'                                                      MD052075
196700200528     C                   PARM                    VDFLTF                                     MD052075
196800200528     C                   PARM                    RegData                                      CER001
196900200528     C                   PARM                    ExtData
197000200528     C                   PARM                    FldNameArr
197100200528     C                   PARM                    MsgIDArr
197200200528     C                   PARM                    MsgDtaArr
197300200528     C                   PARM                    WFldNamArr
197400200528     C                   PARM                    WMsgIDArr
197500200528     C                   PARM                    WMsgDtaArr
197600200528     C                   PARM                    MsgFArray
197700200528     C                   PARM                    UpdateYN
197800200528     C                   PARM                    Buffer
197900200528     C                   PARM                    APIRetc
198000200528
198100200528      * SD Customers
198200200528
198300200528     C     TransTYPE     WHENEQ    'CUSD'
198400200528     C     TransTYPE     OREQ      'CSDU'                                                     CSD079
198500200528     C     TransTYPE     OREQ      'CSDV'                                                     CSD079
198600200528
198700200528     C                   EXSR      CUSDFmts
198800200528
198900200528     C     SDPRLn        SUBST     BUFFER:Bfp    TRANS1
199000200528     C                   EVAL      TransCUPR = TRANS1                                       MD022093
199100200528     C                   ADD       SDPRLn        Bfp
199200200528     C     SDSELn        SUBST     BUFFER:Bfp    TRANS2
199300200528     C                   EVAL      TransCUSE = TRANS2                                       MD022093
199400200528     C                   ADD       SDSELn        Bfp
199500200528     C     SDMTLn        SUBST     BUFFER:Bfp    TRANS7a                                    BUG14803
199600200528     C                   EVAL      TransCUMT = TRANS7a                                      MD022093
199700200528     C                   ADD       SDMTLn        Bfp                                        BUG14803
199800200528     C     SDMRLn        SUBST     BUFFER:Bfp    TRANS3
199900200528     C                   EVAL      TransCUMR = TRANS3                                       MD022093
200000200528     C                   ADD       SDMRLn        Bfp
200100200528     C     SDB1Ln        SUBST     BUFFER:Bfp    TRANS4
200200200528     C                   ADD       SDB1Ln        Bfp
200300200528     C     SDB2Ln        SUBST     BUFFER:Bfp    TRANS5
200400200528     C                   EVAL      TransCUBR = TRANS4 + TRANS5                              MD022093
200500200528     C                   ADD       SDB2Ln        Bfp
200600200528     C     SDPBLn        SUBST     BUFFER:Bfp    TRANS6
200700200528     C                   EVAL      TransCUPB = TRANS6                                       MD022093
200800200528     C                   ADD       SDPBLn        Bfp
200900200528     C*****SDMTLn        SUBST     BUFFER:Bfp    TRANS7a                           BUG14485 BUG14803
201000200528     C**********         ADD       SDMTLn        Bfp                               BUG14485 BUG14803
201100200528     C     SDMILn        SUBST     BUFFER:Bfp    TRANS7                                       CSD079
201200200528     C                   EVAL      TransCUMI = TRANS7                                       MD022093
201300200528     C                   ADD       SDMILn        Bfp                                          CSD079
201400200528     C                   EVAL      TRANS8  = %SUBST(BUFFER:Bfp:SDADLn)                        CSD079
201500200528     C                   ADD       SDADLn        Bfp                                          CSD079
201600200528     C                   EVAL      TRANS8A = %SUBST(BUFFER:Bfp:SDADLnA)                       CSD079
201700200528     C                   ADD       SDADLnA       Bfp                                          CSD079
201800200528     C                   EVAL      TRANS8B = %SUBST(BUFFER:Bfp:SDADLnB)                       CSD079
201900200528     C                   ADD       SDADLnB       Bfp                                        MD050342
202000200528     C                   EVAL      TRANS8C = %SUBST(BUFFER:Bfp:SDADLnC)                       CGL157
202100200528     C                   EVAL      TransCUAD = TRANS8 + TRANS8A + TRANS8B                   MD022093
202200200528     C                                         + TRANS8C                                      CGL157
202300200528     C**********         ADD       SDADLnB       Bfp                                 CSD079 MD050342
202400200528     C                   ADD       SDADLnC       Bfp                                          CGL157
202500200528     C                   EVAL      Trans83 = %SUBST(BUFFERTOTAL:Bfp:SDADLn3)                  CER059
202600200528     C                   EVAL      TransACU3 = TRANS83                                      MD022093
202700200528     C                   ADD       SDADLn3       Bfp                                          CER059
202800200528     C                   EVAL      Trans84 = %SUBST(BUFFERTOTAL:Bfp:SDADLn4)                  CER059
202900200528     C                   EVAL      TransACU4 = TRANS84                                      MD022093
203000200528     C                   ADD       SDADLn4       Bfp                                          CER059
203100200528     C     SDSFLn        SUBST     BUFFER:Bfp    TRANS9                                       CSD079
203200200528     C                   EVAL      TransSFEE = TRANS9                                       MD022093
203300200528     C                   ADD       SDSFLn        Bfp                                          CSD079
203400200528     C     SDCHLn        SUBST     BUFFER:Bfp    TRANS10                                      CSD079
203500200528     C                   EVAL      TransCHEC = TRANS10                                      MD022093
203600200528     C                   ADD       SDCHLn        Bfp                                          CSD079
203700200528     C     SDCHLn        SUB       500           ExtLength                                    CSD079
203800200528     C                   SUB       ExtLength     Bfp                                          CSD079
203900200528     C     ExtLength     SUBST     BUFFER:Bfp    TRANSEXT                                     CSD079
204000200528     C                   ADD       ExtLength     Bfp                                          CSD079
204100200528     C     SDCSLn        SUBST     BUFFER:Bfp    TRANS11                                      CSD079
204200200528     C                   EVAL      TransCUSF = TRANS11                                      MD022093
204300200528     C                   ADD       SDCSLn        Bfp                                          CSD079
204400200528     C     SDFXLn        SUBST     BUFFER:Bfp    TRANS12                                      CSD079
204500200528     C                   EVAL      TransCUFX = TRANS12                                      MD022093
204600200528     C                   ADD       SDFXLn        Bfp                                          CSD079
204700200528     C     SDFDLn        SUBST     BUFFER:Bfp    TRANS13                                      CSD079
204800200528     C                   EVAL      TransCUFD = TRANS13                                      MD022093
204900200528     C                   ADD       SDFDLn        Bfp                                          CSD079
205000200528     C     SDFOLn        SUBST     BUFFER:Bfp    TRANS14                                      CSD079
205100200528     C                   EVAL      TransCUFO = TRANS14                                      MD022093
205200200528     C                   ADD       SDFOLn        Bfp                                          CSD079
205300200528     C     SDPMLn        SUBST     BUFFER:Bfp    TRANS15                                      CSD079
205400200528     C                   EVAL      TransCUPM = TRANS15                                      MD022093
205500200528     C                   ADD       SDPMLn        Bfp                                          CSD079
205600200528     C     SDTILn        SUBST     BUFFER:Bfp    TRANS16                                      CSD079
205700200528     C                   EVAL      TransTICD = TRANS16                                      MD022093
205800200528     C                   ADD       SDTILn        Bfp                                          CSD079
205900200528     C     CUSWLn        SUBST     BUFFER:Bfp    TransSW                                    BUG14992
206000200528     C                   EVAL      TransCUSW = TRANSSW                                      MD022093
206100200528     C                   ADD       CUSWLn        Bfp                                        BUG14992
206200200528     C     SDCULn        SUBST     BUFFER:Bfp    RegData                                      CSD079
206300200528     C                   EVAL      TransCURX = RegData                                      MD022093
206400200528     C                   ADD       SDCULn        Bfp                                          CSD079
206500200528      **  Restore Timestamp field from the record                                            BUG4196
206600200528     C*****26***         SUBST     BUFFER:Bfp    @TimeStamp                         BUG4196 MD022093
206700200528     C     26            SUBST     BUFFER:Bfp    TransTimeStmp                              MD022093
206800200528     C                   ADD       26            Bfp                                         BUG4196
206900200528     C     SDRWLn        SUBST     BUFFER:Bfp    TRANS17                                      CSD079
207000200528     C                   EVAL      TransRWAN = TRANS17                                      MD022093
207100200528     C                   ADD       SDRWLn        Bfp                                          CSD079
207200200528     C*****31***         SUBST     BUFFER:Bfp    StampTax                            CER049 MD022093
207300200528     C     31            SUBST     BUFFER:Bfp    TransStmpTax                               MD022093
207400200528     C                   ADD       31            Bfp                                          CER049
207500200528     C                   EVAL      TransCCTN = %SUBST(BUFFERTOTAL:Bfp:CCTNLn1)              MD021813
207600200528     C                   ADD       CCTNLn1       Bfp                                        MD021813
207700200528     C**********         EVAL      AAuth     = %SUBST(BUFFERTOTAL:Bfp:1)             CER059 MD022093
207800200528     C                   EVAL      TransAUTH = %SUBST(BUFFERTOTAL:Bfp:1)                    MD022093
207900200528     C                   Z-ADD     Bfp           xBfp              4 0                      AR316373
208000200528     C                   MOVE      TransAUTH     xAAuth            1                        AR316373
208100200528     C                   ADD       1             Bfp                                          CER059
208200200528     C**********         EVAL      TransCUA1 = %SUBST(BUFFERTOTAL:Bfp:CUA1Ln)        CER059 MD022093
208300200528     C**********         ADD       CUA1Ln        Bfp                                 CER059 MD022093
208400200528     C**********         EVAL      TransCUA2 = %SUBST(BUFFERTOTAL:Bfp:CUA2Ln)        CER059 MD022093
208500200528     C**********         ADD       CUA2Ln        Bfp                                 CER059 MD022093
208600200528     C**********         EVAL      TransCUA3 = %SUBST(BUFFERTOTAL:Bfp:CUA3Ln)        CER059 MD022093
208700200528     C**********         ADD       CUA3Ln        Bfp                                 CER059 MD022093
208800200528     C**********         EVAL      TransACT1 = %SUBST(BUFFERTOTAL:Bfp:ACT1Ln)        CER059 MD022093
208900200528     C**********         ADD       ACT1Ln        Bfp                                 CER059 MD022093
209000200528     C**********         EVAL      TransACT2 = %SUBST(BUFFERTOTAL:Bfp:ACT2Ln)        CER059 MD022093
209100200528     C**********         ADD       ACT2Ln        Bfp                                 CER059 MD022093
209200200528     C**********         EVAL      TransACT3 = %SUBST(BUFFERTOTAL:Bfp:ACT3Ln)        CER059 MD022093
209300200528     C**********         ADD       ACT3Ln        Bfp                                 CER059 MD022093
209400200528     C**********         EVAL      TransACT4 = %SUBST(BUFFERTOTAL:Bfp:ACT4Ln)        CER059 MD022093
209500200528     C**********         ADD       ACT4Ln        Bfp                                 CER059 MD022093
209600200528     C**********         EVAL      TransACT5 = %SUBST(BUFFERTOTAL:Bfp:ACT5Ln)        CER059 MD022093
209700200528     C**********         ADD       ACT5Ln        Bfp                                 CER059 MD022093
209800200528     C**********         EVAL      TransACT6 = %SUBST(BUFFERTOTAL:Bfp:ACT6Ln)        CER059 MD022093
209900200528     C**********         ADD       ACT6Ln        Bfp                                 CER059 MD022093
210000200528     C**********         EVAL      TRANS19   = %SUBST(TransCCTN:1:CCTNLn1) +       MD021813 MD041996
210100200528     C**********                               %SUBST(BUFFERTOTAL:Bfp:CCTNLn)      MD021813 MD041996
210200200528     C**********         ADD       CCTNLn        Bfp                               MD021813 MD041996
210300200528     C**********         EVAL      ExtData   = %SUBST(BUFFERTOTAL:Bfp:SDEXLn)        CER059 MD022093
210400200528     C**********         ADD       SDEXLn        Bfp                                 CER059 MD022093
210500200528      ** REMINDER : Moving forward, STOP adding new data in the first buffer                MD022093
210600200528     C                   EXSR      ExtCUSDBufTot                                            MD022093
210700200528      ** Extract from BufferEx2                                                             MD022093
210800200528     C                   EXSR      ExtCUSDBufEx2                                            MD022093
210900200528      ** Extract from BufferEx3                                                             MD022093
211000200528     C                   EXSR      ExtCUSDBufEx3                                            MD022093
211100200528      ** Extract from BufferEx4                                                             MD022093
211200200528     C                   EXSR      ExtCUSDBufEx4                                            MD022093
211300200528                                                                                              CSW059
211400200528     C                   EXSR      ExtCUSDBufEx5                                              CGL157
211500200528                                                                                              CGL157
211600200528     C*****CCTNLn        SUBST     BUFFER:Bfp    TRANS19                          AR1086546 MD021813
211700200528     C**********         ADD       CCTNLn        Bfp                              AR1086546 MD021813
211800200528     C*****SDEXLn        SUBST     BUFFER:Bfp    ExtData                                      CER059
211900200528     C**********         ADD       SDEXLn        Bfp                                 BUG22140 CER059
212000200528     C*****1****         SUBST     BUFFER:Bfp    AAuth                               BUG22140 CER059
212100200528     C**********         ADD       1             Bfp                                 BUG22140 CER059
212200200528
212300200528     C                   CALL      'SDCUSDVU'
212400200528      * Common header information (DS) from source system
212500200528     C                   PARM                    HeadIn
212600200528      * Transaction information
212700200528     C**********         PARM                    Trans1                                     MD022093
212800200528     C**********         PARM                    Trans2                                     MD022093
212900200528     C**********         PARM                    Trans7a                           BUG14803 MD022093
213000200528     C**********         PARM                    Trans3                                     MD022093
213100200528     C**********         PARM                    Trans4                                     MD022093
213200200528     C**********         PARM                    Trans5                                     MD022093
213300200528     C**********         PARM                    Trans6                                     MD022093
213400200528     C**********         PARM                    Trans7a                           BUG14485 BUG14803
213500200528     C**********         PARM                    Trans7                              CSD079 MD022093
213600200528     C**********         PARM                    Trans8                              CSD079 MD022093
213700200528     C**********         PARM                    Trans8A                             CSD079 MD022093
213800200528     C**********         PARM                    Trans8B                             CSD079 MD022093
213900200528     C**********         PARM                    Trans83                             CER059 MD022093
214000200528     C**********         PARM                    Trans84                             CER059 MD022093
214100200528     C**********         PARM                    Trans9                              CSD079 MD022093
214200200528     C**********         PARM                    Trans10                             CSD079 MD022093
214300200528     C**********         PARM                    TransExt                            CSD079 MD022093
214400200528     C**********         PARM                    Trans11                             CSD079 MD022093
214500200528     C**********         PARM                    Trans12                             CDS079 MD022093
214600200528     C**********         PARM                    Trans13                             CSD079 MD022093
214700200528     C**********         PARM                    Trans14                             CSD079 MD022093
214800200528     C**********         PARM                    Trans15                             CSD079 MD022093
214900200528     C**********         PARM                    Trans16                             CSD079 MD022093
215000200528     C**********         PARM                    TransSW                           BUG14992 MD022093
215100200528     C**********         PARM                    RegData                             CSD079 MD022093
215200200528     C**********         PARM                    Trans17                             CSD079 MD022093
215300200528     C**********         PARM                    StampTax                            CER049 MD022093
215400200528     C**********         PARM                    TransCUA1                           CER059 MD022093
215500200528     C**********         PARM                    TransCUA2                           CER059 MD022093
215600200528     C**********         PARM                    TransCUA3                           CER059 MD022093
215700200528     C**********         PARM                    TransACT1                           CER059 MD022093
215800200528     C**********         PARM                    TransACT2                           CER059 MD022093
215900200528     C**********         PARM                    TransACT3                           CER059 MD022093
216000200528     C**********         PARM                    TransACT4                           CER059 MD022093
216100200528     C**********         PARM                    TransACT5                           CER059 MD022093
216200200528     C**********         PARM                    TransACT6                           CER059 MD022093
216300200528     C                   PARM                    Trans19                                   AR1086546
216400200528     C**********         PARM                    ExtData                                    MD022093
216500200528     C                   PARM                    TransInTot                                 MD022093
216600200528     C                   PARM                    TransInEx2                                 MD022093
216700200528     C                   PARM                    TransInEx3                                 MD022093
216800200528     C                   PARM                    TransInEx4                                 MD022093
216900200528     C                   PARM                    TransInEx5                                   CGL157
217000200528     C                   PARM                    FldNameArr
217100200528     C                   PARM                    MsgIDArr
217200200528     C                   PARM                    MsgDtaArr
217300200528     C                   PARM                    WFldNamArr
217400200528     C                   PARM                    WMsgIDArr
217500200528     C                   PARM                    WMsgDtaArr
217600200528     C                   PARM                    MsgFArray
217700200528     C                   PARM                    UpdateYN
217800200528     C**********         PARM                    Buffer                                       CER059
217900200528     C                   PARM                    Buffer9999                                   CER059
218000200528     C                   PARM                    BufferEx2                                  MD022093
218100200528     C                   PARM                    BufferEx3                                  MD022093
218200200528     C                   PARM                    BufferEx4                                  MD022093
218300200528     C                   PARM                    BufferEx5                                    CGL157
218400200528     C                   PARM                    APIRetc
218500200528     C                   PARM                    @TimeStamp                                  BUG4196
218600200528     C                   PARM                    AAuth                                      BUG22140
218700200528
218800200528     C                   MOVEL     Buffer9999    Buffer                                       CER059
218900200528     C                   MOVE      Buffer9999    Buffer2                                      CER059
219000200528                                                                                              CER059
219100200528      * SD Securities Customers
219200200528
219300200528     C     TransTYPE     WHENEQ    'SECD'
219400200528
219500200528     C                   EXSR      SECDFmts
219600200528
219700200528     C     SDSCLn        SUBST     BUFFER:Bfp    TRANS1
219800200528     C                   ADD       SDSCLn        Bfp
219900200528     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22155
220000200528     C                   ADD       1             Bfp                                        BUG22155
220100200528     C     4050          SUBST     BUFFER:Bfp    DepData                                    BUG12213
220200200528     C                   ADD       4050          Bfp                                        BUG12213
220300200528     C     SDSXLn        SUBST     BUFFER:Bfp    ExtData
220400200528     C                   ADD       SDSXLn        Bfp                                        BUG22140
220500200528     C*****1****         SUBST     BUFFER:Bfp    AAuth                             BUG22140 BUG22155
220600200528     C**********         ADD       1             Bfp                               BUG22140 BUG22155
220700200528
220800200528     C                   CALL      'SDSECDVU'
220900200528      * Common header information (DS) from source system
221000200528     C                   PARM                    HeadIn
221100200528      * Transaction information
221200200528     C                   PARM                    Trans1
221300200528     C                   PARM                    ExtData
221400200528     C                   PARM                    DepData                                    BUG12213
221500200528     C                   PARM                    FldNameArr
221600200528     C                   PARM                    MsgIDArr
221700200528     C                   PARM                    MsgDtaArr
221800200528     C                   PARM                    WFldNamArr
221900200528     C                   PARM                    WMsgIDArr
222000200528     C                   PARM                    WMsgDtaArr
222100200528     C                   PARM                    MsgFArray
222200200528     C                   PARM                    UpdateYN
222300200528     C                   PARM                    Buffer
222400200528     C                   PARM                    APIRetc
222500200528     C                   PARM                    AAuth                                      BUG22140
222600200528
222700200528      * PM Portfolio Definition
222800200528
222900200528     C     TransTYPE     WHENEQ    'PFDM'
223000200528
223100200528     C                   EXSR      PFDMFmts
223200200528
223300200528     C     PMPMLn        SUBST     BUFFER:Bfp    TRANS1
223400200528     C                   ADD       PMPMLn        Bfp
223500200528     C     PMEXLn        SUBST     BUFFER:Bfp    ExtData
223600200528
223700200528     C                   CALL      'PMPFDMVU'
223800200528      * Common header information (DS) from source system
223900200528     C                   PARM                    HeadIn
224000200528      * Transaction information
224100200528     C                   PARM                    Trans1
224200200528     C                   PARM                    ExtData
224300200528     C                   PARM                    FldNameArr
224400200528     C                   PARM                    MsgIDArr
224500200528     C                   PARM                    MsgDtaArr
224600200528     C                   PARM                    WFldNamArr
224700200528     C                   PARM                    WMsgIDArr
224800200528     C                   PARM                    WMsgDtaArr
224900200528     C                   PARM                    MsgFArray
225000200528     C                   PARM                    UpdateYN
225100200528     C                   PARM                    Buffer
225200200528     C                   PARM                    APIRetc
225300200528
225400200528      * MM Deal Amendments
225500200528
225600200528     C     TransTYPE     WHENEQ    'DEAM'
225700200528
225800200528     C                   EXSR      DEAMFmts
225900200528     C                   EXSR      SettleFmts
226000200528
226100200528     C     DEAMLn        SUBST     BUFFER:Bfp    TRANS1
226200200528     C                   ADD       DEAMLn        Bfp
226300200528      **  Restore Timestamp field from the record                                            BUG4146
226400200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4146
226500200528     C                   ADD       26            Bfp                                         BUG4146
226600200528      *                                                                                       CER043
226700200528     C     SDCULn        SUBST     BUFFER:Bfp    CustData                                     CER043
226800200528     C                   ADD       SDCULn        Bfp                                          CER043
226900200528      *                                                                                       CER043
227000200528      **  Send Loan/Deposit indicator for settlement tab conditioning.                       BUG6534
227100200528     C     1             SUBST     BUFFER:Bfp    LONDEP                                      BUG6534
227200200528     C                   ADD       1             Bfp                                         BUG6534
227300200528      **  Restore Authorise Reversal Action Code                                              260173
227400200528     C     1             SUBST     BUFFER:Bfp    @ACTRV                                       260173
227500200528     C                   ADD       1             Bfp                                          260173
227600200528     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
227700200528     C                   ADD       20            Bfp                                          239400
227800200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
227900200528     C                   ADD       ESSRLn        Bfp
228000200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
228100200528     C                   ADD       ESSPLn        Bfp
228200200528     C     DAIFLn        SUBST     BUFFER:Bfp    TRANS2
228300200528     C                   ADD       DAIFLn        Bfp
228400200528     C     DAEXLn        SUBST     BUFFER:Bfp    ExtData
228500200528
228600200528     C                   CALL      'MMDEAMVU'
228700200528      * Common header information (DS) from source system
228800200528     C                   PARM                    HeadIn
228900200528      * Transaction information in a single large field from source system
229000200528     C                   PARM                    Trans1
229100200528     C                   PARM                    CustData                                     CER043
229200200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
229300200528     C                   PARM                    PaySttmt
229400200528     C                   PARM                    RecSttmt
229500200528     C                   PARM                    FRASttmt
229600200528     C                   PARM                    Trans2
229700200528     C                   PARM                    ExtData
229800200528     C                   PARM                    FldNameArr
229900200528     C                   PARM                    MsgIDArr
230000200528     C                   PARM                    MsgDtaArr
230100200528     C                   PARM                    WFldNamArr
230200200528     C                   PARM                    WMsgIDArr
230300200528     C                   PARM                    WMsgDtaArr
230400200528     C                   PARM                    MsgFArray
230500200528     C                   PARM                    UpdateYN
230600200528     C                   PARM                    Buffer
230700200528     C                   PARM                    APIRetc
230800200528     C                   PARM                    @TimeStamp                                  BUG4146
230900200528     C                   PARM                    LONDEP                                      BUG6534
231000200528     C                   PARM                    DDFOID                                       239400
231100200528     C                   PARM                    @ACTRV                                       260173
231200200528                                                                                              CRE020
231300200528     C                   IF        CRE020 = 'Y'                                               CRE020
231400200528     C                   EVAL      WrkPgm = 'MMDEAMUPD'                                       CRE020
231500200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
231600200528     C                   EXSR      SRSndDtaQ                                                  CRE020
231700200528     C                   ENDIF                                                                CRE020
231800200528
231900200528      * Facilities amendments
232000200528
232100200528     C     TransTYPE     WHENEQ    'FAMD'
232200200528
232300200528     C                   EXSR      FAMDFmts
232400200528     C     FAMDLn        SUBST     BUFFER:Bfp    TRANS1
232500200528     C                   ADD       FAMDLn        Bfp                                          CAP086
232600200528     C     FAM2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
232700200528     C                   ADD       FAM2Ln        Bfp                                        BUG10384
232800200528                                                                                              CAP086
232900200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
233000200528     C                   ADD       LEIFLn        Bfp                                          CAP086
233100200528
233200200528     C                   CALL      'LEFAMDVU'
233300200528     C                   PARM                    HeadIn
233400200528      * Transaction information
233500200528     C                   PARM                    Trans1
233600200528     C                   PARM                    Trans2                                       CLE106
233700200528     C                   PARM                    InfData                                      CAP086
233800200528     C                   PARM                    FldNameArr
233900200528     C                   PARM                    MsgIDArr
234000200528     C                   PARM                    MsgDtaArr
234100200528     C                   PARM                    WFldNamArr
234200200528     C                   PARM                    WMsgIDArr
234300200528     C                   PARM                    WMsgDtaArr
234400200528     C                   PARM                    MsgFArray
234500200528     C                   PARM                    UpdateYN
234600200528     C                   PARM                    Buffer
234700200528     C                   PARM                    APIRetc
234800200528
234900200528      * Collateral details
235000200528
235100200528     C     TransTYPE     WHENEQ    'COLL'
235200200528
235300200528     C                   EXSR      COLLFmts
235400200528     C     COL1Ln        SUBST     BUFFER:Bfp    TRANS1
235500200528     C                   ADD       COL1Ln        Bfp
235600200528     C     COL2Ln        SUBST     BUFFER:Bfp    TRANS2
235700200528     C                   ADD       COL2Ln        Bfp
235800200528     C     COL3Ln        SUBST     BUFFER:Bfp    TRANS3
235900200528     C                   ADD       COL3Ln        Bfp
236000200528     C     COL4Ln        SUBST     BUFFER:Bfp    TRANS4
236100200528
236200200528     C                   CALL      'GLCOLLVU'
236300200528     C                   PARM                    HeadIn
236400200528      * Transaction information
236500200528     C                   PARM                    Trans1
236600200528     C                   PARM                    Trans2
236700200528     C                   PARM                    Trans3
236800200528     C                   PARM                    Trans4
236900200528     C                   PARM                    FldNameArr
237000200528     C                   PARM                    MsgIDArr
237100200528     C                   PARM                    MsgDtaArr
237200200528     C                   PARM                    WFldNamArr
237300200528     C                   PARM                    WMsgIDArr
237400200528     C                   PARM                    WMsgDtaArr
237500200528     C                   PARM                    MsgFArray
237600200528     C                   PARM                    UpdateYN
237700200528     C                   PARM                    Buffer
237800200528     C                   PARM                    APIRetc
237900200528
238000200528      * Collateral Allocations
238100200528     C     TransTYPE     WHENEQ    'COLA'
238200200528
238300200528     C                   EXSR      COLAFmts
238400200528     C                   EXSR      SettleFmts
238500200528     C     COLALn        SUBST     BUFFER:Bfp    TRANS1
238600200528     C                   ADD       COLALn        Bfp
238700200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
238800200528     C                   ADD       ESSRLn        Bfp
238900200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
239000200528     C                   ADD       ESSPLn        Bfp
239100200528
239200200528     C                   CALL      'GLCOLAVU'
239300200528
239400200528      * Common header information (DS) from source system
239500200528     C                   PARM                    HeadIn
239600200528
239700200528      * Transaction information
239800200528     C                   PARM                    TRANS1
239900200528     C                   PARM                    PaySttmt
240000200528     C                   PARM                    RecSttmt
240100200528     C                   PARM                    ReservID
240200200528     C                   PARM                    ExtData
240300200528     C                   PARM                    FldNameArr
240400200528     C                   PARM                    MsgIDArr
240500200528     C                   PARM                    MsgDtaArr
240600200528     C                   PARM                    WFldNamArr
240700200528     C                   PARM                    WMsgIDArr
240800200528     C                   PARM                    WMsgDtaArr
240900200528     C                   PARM                    MsgFArray
241000200528     C                   PARM                    UpdateYN
241100200528     C                   PARM                    Buffer
241200200528     C                   PARM                    APIRetc
241300200528
241400200528      * Facilities details
241500200528
241600200528     C     TransTYPE     WHENEQ    'FCIP'
241700200528
241800200528     C                   EXSR      FCIPFmts
241900200528     C                   EXSR      SettleFmts                                                 CLE106
242000200528
242100200528     C     FCI1Ln        SUBST     BUFFER:Bfp    TRANS1
242200200528     C                   ADD       FCI1Ln        Bfp
242300200528
242400200528     C     FCI2Ln        SUBST     BUFFER:Bfp    TRANS2
242500200528     C                   ADD       FCI2Ln        Bfp
242600200528                                                                                              CLE106
242700200528     C     FCI7Ln        SUBST     BUFFER:Bfp    TRANS7                                       CLE106
242800200528     C                   ADD       FCI7Ln        Bfp                                          CLE106
242900200528                                                                                              CLE106
243000200528     C     FCI9Ln        SUBST     BUFFER:Bfp    TRANS9                                       CLE106
243100200528     C                   ADD       FCI9Ln        Bfp                                          CLE106
243200200528                                                                                            BUG10093
243300200528     C     FCRNLn        SUBST     BUFFER:Bfp    FCIPNotes                                  BUG10093
243400200528     C                   ADD       FCRNLn        Bfp                                        BUG10093
243500200528                                                                                            BUG13174
243600200528      ** Field 'DDPATH'                                                                     BUG13174
243700200528                                                                                            BUG13174
243800200528     C     LEIFLn        SUBST     BUFFER:Bfp    DDPATH          200                        BUG13174
243900200528     C                   ADD       200           Bfp                                        BUG13174
244000200528                                                                                              CER049
244100200528      ** Stamp Tax fields                                                                     CER049
244200200528                                                                                              CER049
244300200528     C     51            SUBST     BUFFER:Bfp    TranStamp        51                          CER049
244400200528     C                   ADD       51            Bfp                                          CER049
244500200528                                                                                              CLE147
244600200528      ** Credit Agreement Change Flag                                                         CLE147
244700200528                                                                                              CLE147
244800200528     C     33            SUBST     BUFFER:Bfp    CADetails        33                          CLE147
244900200528     C                   ADD       33            Bfp                                          CLE147
245000200528                                                                                              CAP086
245100200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
245200200528     C                   ADD       LEIFLn        Bfp                                          CAP086
245300200528
245400200528     C*****FCRXLn        SUBST     BUFFER:Bfp    RegData                             CER001 BUG10093
245500200528     C**********         ADD       FCRXLn        Bfp                                 CER001 BUG10093
245600200528      **********                                                                     CER001 BUG10093
245700200528     C*****FCEXLn        SUBST     BUFFER:Bfp    ExtData                                    BUG10093
245800200528     C**********         ADD       FCEXLn        Bfp                                 CLE106 BUG10093
245900200528                                                                                              CLE106
246000200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CLE106
246100200528     C                   ADD       ESSRLn        Bfp                                          CLE106
246200200528                                                                                              CLE106
246300200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CLE106
246400200528     C                   ADD       ESSPLn        Bfp                                        BUG10093
246500200528                                                                                            BUG10093
246600200528     C     FCEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
246700200528     C                   ADD       FCEXLn        Bfp                                        MD044880
246800200528                                                                                            MD044880
246900200528     C     FCRXLn        SUBST     BUFFER:Bfp    RegData                                    BUG10093
247000200528     C                   ADD       FCRXLn        Bfp                                        BUG10093
247100200528                                                                                            BUG10093
247200200528     C*****FCEXLn        SUBST     BUFFER:Bfp    ExtData                           BUG10093 MD044880
247300200528
247400200528     C                   CALL      'LEFCIPVU'
247500200528     C                   PARM                    HeadIn
247600200528      * Transaction information
247700200528     C                   PARM                    Trans1
247800200528     C                   PARM                    Trans2
247900200528     C                   PARM                    Trans7                                       CLE106
248000200528     C                   PARM                    Trans9                                       CLE106
248100200528     C                   PARM                    FCIPNotes                                  BUG10093
248200200528     C                   PARM                    TranStamp                                    CER049
248300200528     C                   PARM                    InfData                                      CAP086
248400200528     C                   PARM                    RegData                                      CER001
248500200528     C                   PARM                    ExtData
248600200528     C                   PARM                    PaySttmt                                     CLE106
248700200528     C                   PARM                    RecSttmt                                     CLE106
248800200528     C                   PARM                    FldNameArr
248900200528     C                   PARM                    MsgIDArr
249000200528     C                   PARM                    MsgDtaArr
249100200528     C                   PARM                    WFldNamArr
249200200528     C                   PARM                    WMsgIDArr
249300200528     C                   PARM                    WMsgDtaArr
249400200528     C                   PARM                    MsgFArray
249500200528     C                   PARM                    UpdateYN
249600200528     C                   PARM                    Buffer
249700200528     C                   PARM                    APIRetc
249800200528     C                   PARM                    DDPATH                                     BUG13174
249900200528     C                   PARM                    CADetails                                    CLE147
250000200528
250100200528      * Loan Input
250200200528
250300200528     C     TransTYPE     WHENEQ    'CLIP'
250400200528
250500200528     C                   EXSR      CLIPFmts
250600200528     C                   EXSR      SettleFmts
250700200528
250800200528     C     CLI1Ln        SUBST     BUFFER:Bfp    TRANS1
250900200528     C                   ADD       CLI1Ln        Bfp
251000200528
251100200528     C     CLI2Ln        SUBST     BUFFER:Bfp    TRANS2
251200200528     C                   ADD       CLI2Ln        Bfp
251300200528
251400200528     C     CLI3Ln        SUBST     BUFFER:Bfp    TRANS3
251500200528     C                   ADD       CLI3Ln        Bfp
251600200528
251700200528     C     CLI4Ln        SUBST     BUFFER:Bfp    TRANS4
251800200528     C                   ADD       CLI4Ln        Bfp
251900200528
252000200528     C     CLI5Ln        SUBST     BUFFER:Bfp    TRANS5                                       CLE106
252100200528     C                   ADD       CLI5Ln        Bfp                                          CLE106
252200200528                                                                                              CLE106
252300200528      *                                                                                     AR804863
252400200528      ** Restore Reject Action Code.                                                        AR804863
252500200528      *                                                                                     AR804863
252600200528     C     1             SUBST     BUFFER:Bfp    @ACTRV                                     AR804863
252700200528     C                   ADD       1             Bfp                                        AR804863
252800200528     C     CLIQLn        SUBST     Buffer:Bfp    TRANSQ                                       CER049
252900200528     C                   ADD       CLIQLn        Bfp                                          CER049
253000200528                                                                                              CER049
253100200528     C     CLI6Ln        SUBST     BUFFER:Bfp    TRANS6                                    AR1021983
253200200528     C                   ADD       CLI6Ln        Bfp                                       AR1021983
253300200528                                                                                           AR1021983
253400200528     C     CLI7Ln        SUBST     BUFFER:Bfp    TRANS7                                       CLE141
253500200528     C                   ADD       CLI7Ln        Bfp                                          CLE141
253600200528                                                                                              CLE141
253700200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
253800200528     C                   ADD       ESSRLn        Bfp
253900200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
254000200528     C                   ADD       ESSPLn        Bfp
254100200528      *                                                                                     MD030621
254200200528     C*****Bfp**         Add       1             BfpTMP            4 0             MD030621 MD042033
254300200528     C*****1****         SUBST     BUFFER:BfpTMP @DEPI                             MD030621 MD042033
254400200528     C     1             SUBST     BUFFER:Bfp    @DEPI                                      MD042033
254500200528     C                   ADD       1             Bfp                                        MD042033
254600200528      *                                                                                     MD030621
254700200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
254800200528     C                   ADD       LEIFLn        Bfp                                          CAP086
254900200528
255000200528     C*****10************SUBST     BUFFER:Bfp    ReservID                       BUG2480
255100200528     C*******************ADD       10            Bfp                            BUG2480
255200200528
255300200528     C     CLEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
255400200528     C                   ADD       CLEXLn        Bfp                                        MD044880
255500200528                                                                                            MD044880
255600200528      *** APR Fields for CLIP (CER050)                                                      MD054028
255700200528     C     CLCR50Ln      SUBST     BUFFER:Bfp    CLAPRDta         24                        MD054028
255800200528     C                   EVAL      ExtData = %SUBST(ExtData:1:CLEXLn) + CLAPRDta            MD054028
255900200528     C                   ADD       CLCR50Ln      Bfp                                        MD054028
256000200528                                                                                            MD054028
256100200528     C     CLRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
256200200528     C                   ADD       CLRXLn        Bfp                                          CER001
256300200528                                                                                              CER001
256400200528     C*****CLEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
256500200528     C**********         ADD       CLEXLn        Bfp                                        MD044880
256600200528
256700200528     C                   MOVE      ReservID15    ReservID                       BUG2480
256800200528                                                                                BUG2480
256900200528     C                   CALL      'LECLIPVU'
257000200528     C                   PARM                    HeadIn
257100200528      * Transaction information
257200200528     C                   PARM                    Trans1
257300200528     C                   PARM                    Trans2
257400200528     C                   PARM                    Trans3
257500200528     C                   PARM                    Trans4
257600200528     C                   PARM                    Trans5                                       CLE106
257700200528     C                   PARM                    TransQ                                       CER049
257800200528     C                   PARM                    Trans6                                    AR1021983
257900200528     C                   PARM                    Trans7                                       CLE141
258000200528     C                   PARM                    PaySttmt
258100200528     C                   PARM                    RecSttmt
258200200528     C                   PARM                    ReservID         10
258300200528     C                   PARM                    InfData                                      CAP086
258400200528     C                   PARM                    RegData                                      CER001
258500200528     C                   PARM                    ExtData
258600200528     C                   PARM                    FldNameArr
258700200528     C                   PARM                    MsgIDArr
258800200528     C                   PARM                    MsgDtaArr
258900200528     C                   PARM                    WFldNamArr
259000200528     C                   PARM                    WMsgIDArr
259100200528     C                   PARM                    WMsgDtaArr
259200200528     C                   PARM                    MsgFArray
259300200528     C                   PARM                    UpdateYN
259400200528     C                   PARM                    Buffer
259500200528     C                   PARM                    APIRetc
259600200528      *                                                                                     AR804863
259700200528      ** Action Code (Reject transaction)                                                   AR804863
259800200528      *                                                                                     AR804863
259900200528     C                   PARM                    @ACTRV                                     AR804863
260000200528     C                   PARM                    @DEPI                                      MD030621
260100200528                                                                                              CRE020
260200200528     C                   IF        CRE020 = 'Y'                                               CRE020
260300200528     C                   EVAL      WrkPgm = 'LECLIPUPD'                                       CRE020
260400200528     C                   EVAL      WrkMod = 'LE'                                              CRE020
260500200528     C                   EXSR      SRSndDtaQ                                                  CRE020
260600200528     C                   ENDIF                                                                CRE020
260700200528
260800200528      * Rollover instructions
260900200528
261000200528     C     TransTYPE     WHENEQ    'LERI'
261100200528
261200200528     C                   EXSR      LERIFmts
261300200528     C                   EXSR      SettleFmts
261400200528
261500200528     C     LERILn        SUBST     BUFFER:Bfp    TRANS1
261600200528     C                   ADD       LERILn        Bfp
261700200528
261800200528     C     LER2Ln        SUBST     BUFFER:Bfp    TRANS2
261900200528     C                   ADD       LER2Ln        Bfp
262000200528
262100200528     C     LER3Ln        SUBST     BUFFER:Bfp    TRANS3                                        BUG19
262200200528     C                   ADD       LER3Ln        Bfp                                           BUG19
262300200528                                                                                               BUG19
262400200528      *                                                                                     AR702532
262500200528      **  Restore Reject Action Code.                                                       AR702532
262600200528      *                                                                                     AR702532
262700200528     C     1             SUBST     BUFFER:Bfp    @ACTRV                                     AR702532
262800200528     C                   ADD       1             Bfp                                        AR702532
262900200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
263000200528     C                   ADD       ESSRLn        Bfp
263100200528
263200200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
263300200528     C                   ADD       ESSPLn        Bfp
263400200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
263500200528     C                   ADD       LEIFLn        Bfp                                          CAP086
263600200528
263700200528     C     LEEXLn        SUBST     BUFFER:Bfp    ExtData
263800200528
263900200528     C                   CALL      'LELERIVU'
264000200528     C                   PARM                    HeadIn
264100200528      * Transaction information
264200200528     C                   PARM                    Trans1
264300200528     C                   PARM                    Trans2
264400200528     C                   PARM                    Trans3                                        BUG19
264500200528     C                   PARM                    PaySttmt
264600200528     C                   PARM                    RecSttmt
264700200528     C                   PARM                    FRASttmt
264800200528     C                   PARM                    InfData                                      CAP086
264900200528     C                   PARM                    ExtData
265000200528     C                   PARM                    FldNameArr
265100200528     C                   PARM                    MsgIDArr
265200200528     C                   PARM                    MsgDtaArr
265300200528     C                   PARM                    WFldNamArr
265400200528     C                   PARM                    WMsgIDArr
265500200528     C                   PARM                    WMsgDtaArr
265600200528     C                   PARM                    MsgFArray
265700200528     C                   PARM                    UpdateYN
265800200528     C                   PARM                    Buffer
265900200528     C                   PARM                    APIRetc
266000200528     C                   PARM                    @ACTRV                                     AR702532
266100200528
266200200528      * Repayment schedule
266300200528
266400200528     C     TransTYPE     WHENEQ    'RPSC'
266500200528
266600200528     C                   EXSR      RPSCFmts
266700200528     C                   EXSR      SettleFmts
266800200528
266900200528     C     RPSCLn        SUBST     BUFFER:Bfp    TRANS1
267000200528     C                   ADD       RPSCLn        Bfp
267100200528
267200200528     C     RPS2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
267300200528     C                   ADD       RPS2Ln        Bfp                                          CLE106
267400200528                                                                                              CLE106
267500200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
267600200528     C                   ADD       ESSRLn        Bfp
267700200528
267800200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
267900200528     C                   ADD       ESSPLn        Bfp
268000200528                                                                                              CAP086
268100200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
268200200528     C                   ADD       LEIFLn        Bfp                                          CAP086
268300200528
268400200528     C     RPEXLn        SUBST     BUFFER:Bfp    ExtData
268500200528
268600200528     C                   CALL      'LERPSCVU'
268700200528     C                   PARM                    HeadIn
268800200528      * Transaction information
268900200528     C                   PARM                    Trans1
269000200528     C                   PARM                    Trans2                                       CLE106
269100200528     C                   PARM                    PaySttmt
269200200528     C                   PARM                    RecSttmt
269300200528     C                   PARM                    FRASttmt
269400200528     C                   PARM                    InfData                                      CAP086
269500200528     C                   PARM                    ExtData
269600200528     C                   PARM                    FldNameArr
269700200528     C                   PARM                    MsgIDArr
269800200528     C                   PARM                    MsgDtaArr
269900200528     C                   PARM                    WFldNamArr
270000200528     C                   PARM                    WMsgIDArr
270100200528     C                   PARM                    WMsgDtaArr
270200200528     C                   PARM                    MsgFArray
270300200528     C                   PARM                    UpdateYN
270400200528     C                   PARM                    Buffer
270500200528     C                   PARM                    APIRetc
270600200528                                                                                              CRE020
270700200528     C                   IF        CRE020 = 'Y'                                               CRE020
270800200528     C                   EVAL      WrkPgm = 'LERPSCUPD'                                       CRE020
270900200528     C                   EVAL      WrkMod = 'LE'                                              CRE020
271000200528     C                   EXSR      SRSndDtaQ                                                  CRE020
271100200528     C                   ENDIF                                                                CRE020
271200200528
271300200528      * Loan Amendment
271400200528
271500200528     C     TransTYPE     WHENEQ    'LOAM'
271600200528
271700200528     C                   EXSR      LOAMFmts
271800200528     C                   EXSR      SettleFmts
271900200528
272000200528     C     LOAMLn        SUBST     BUFFER:Bfp    TRANS1
272100200528     C                   ADD       LOAMLn        Bfp
272200200528
272300200528     C     LOA2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
272400200528     C                   ADD       LOA2Ln        Bfp                                          CLE106
272500200528                                                                                              CLE106
272600200528     C*****LOEXLn        SUBST     BUFFER:Bfp    ExtData                              BUG9493 247172
272700200528     C**********         ADD       LOEXLn        Bfp                                  BUG9493 247172
272800200528     C*****10************SUBST     BUFFER:Bfp    ReservID                       BUG2480
272900200528     C*******************ADD       10            Bfp                            BUG2480
273000200528
273100200528     C*****16***         SUBST     BUFFER:Bfp    DDSTAT                                       CLE106
273200200528     C**********         ADD       16            Bfp                                          CLE106
273300200528
273400200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
273500200528     C                   ADD       ESSRLn        Bfp
273600200528
273700200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
273800200528     C                   ADD       ESSPLn        Bfp
273900200528                                                                                              CAP086
274000200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
274100200528     C                   ADD       LEIFLn        Bfp                                          CAP086
274200200528
274300200528     C     LOEXLn        SUBST     BUFFER:Bfp    ExtData                                      247172
274400200528     C                   ADD       LOEXLn        Bfp                                          247172
274500200528     C*****LOEXLn        SUBST     BUFFER:Bfp    ExtData                                     BUG9493
274600200528     C**********         ADD       LOEXLn        Bfp                                         BUG9493
274700200528
274800200528     C                   MOVE      ReservID15    ReservID                       BUG2480
274900200528                                                                                BUG2480
275000200528     C                   CALL      'LELOAMVU'
275100200528     C                   PARM                    HeadIn
275200200528      * Transaction information
275300200528     C                   PARM                    Trans1
275400200528     C                   PARM                    Trans2                                       CLE106
275500200528     C                   PARM                    PaySttmt
275600200528     C                   PARM                    RecSttmt
275700200528     C                   PARM                    InfData                                      CAP086
275800200528     C                   PARM                    ExtData
275900200528     C                   PARM                    ReservID         10
276000200528     C                   PARM                    DDSTAT           16
276100200528     C                   PARM                    FldNameArr
276200200528     C                   PARM                    MsgIDArr
276300200528     C                   PARM                    MsgDtaArr
276400200528     C                   PARM                    WFldNamArr
276500200528     C                   PARM                    WMsgIDArr
276600200528     C                   PARM                    WMsgDtaArr
276700200528     C                   PARM                    MsgFArray
276800200528     C                   PARM                    UpdateYN
276900200528     C                   PARM                    Buffer
277000200528     C                   PARM                    APIRetc
277100200528                                                                                              CRE020
277200200528     C                   IF        CRE020 = 'Y'                                               CRE020
277300200528     C                   EVAL      WrkPgm = 'LELOAMUPD'                                       CRE020
277400200528     C                   EVAL      WrkMod = 'LE'                                              CRE020
277500200528     C                   EXSR      SRSndDtaQ                                                  CRE020
277600200528     C                   ENDIF                                                                CRE020
277700200528
277800200528      * Manual repayment
277900200528
278000200528     C     TransTYPE     WHENEQ    'MAPY'
278100200528
278200200528     C                   EXSR      MAPYFmts
278300200528     C                   EXSR      SettleFmts
278400200528
278500200528     C     MAPYLn        SUBST     BUFFER:Bfp    TRANS1
278600200528     C                   ADD       MAPYLn        Bfp
278700200528
278800200528     C     MAP2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
278900200528     C                   ADD       MAP2Ln        Bfp                                          CLE106
279000200528                                                                                              CLE106
279100200528     C*****UpSRLn        SUBST     BUFFER:Bfp    TempData#3                       AR1080805 MD020445
279200200528     C**********         ADD       UpSRLn        Bfp                              AR1080805 MD020445
279300200528     C     UpSRLn        SUBST     BUFFER:Bfp    TempData#3                                 MD020733
279400200528     C                   ADD       UpSRLn        Bfp                                        MD020733
279500200528                                                                                            MD020733
279600200528                                                                                              CLE164
279700200528     C     DDAuLn        SUBST     BUFFER:Bfp    TempData7                                    CLE164
279800200528     C                   ADD       DDAuLn        Bfp                                          CLE164
279900200528                                                                                              CLE164
280000200528     C*****10************SUBST     BUFFER:Bfp    ReservID                       BUG2480
280100200528     C*******************ADD       10            Bfp                            BUG2480
280200200528
280300200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
280400200528     C                   ADD       ESSRLn        Bfp
280500200528
280600200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
280700200528     C                   ADD       ESSPLn        Bfp
280800200528                                                                                              CAP086
280900200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
281000200528     C                   ADD       LEIFLn        Bfp                                          CAP086
281100200528
281200200528     C     MAEXLn        SUBST     BUFFER:Bfp    ExtData
281300200528
281400200528     C                   MOVE      ReservID15    ReservID                       BUG2480
281500200528                                                                                BUG2480
281600200528     C                   CALL      'LEMAPYVU'
281700200528     C                   PARM                    HeadIn
281800200528      * Transaction information
281900200528     C                   PARM                    Trans1
282000200528     C                   PARM                    Trans2                                       CLE106
282100200528     C**********         PARM                    TempData#3                       AR1080805 MD020445
282200200528     C                   PARM                    TempData#3                                 MD020733
282300200528     C                   PARM                    TempData7                                    CLE164
282400200528     C                   PARM                    PaySttmt
282500200528     C                   PARM                    RecSttmt
282600200528     C                   PARM                    InfData                                      CAP086
282700200528     C                   PARM                    ExtData
282800200528     C                   PARM                    ReservID         10
282900200528     C                   PARM                    FldNameArr
283000200528     C                   PARM                    MsgIDArr
283100200528     C                   PARM                    MsgDtaArr
283200200528     C                   PARM                    WFldNamArr
283300200528     C                   PARM                    WMsgIDArr
283400200528     C                   PARM                    WMsgDtaArr
283500200528     C                   PARM                    MsgFArray
283600200528     C                   PARM                    UpdateYN
283700200528     C                   PARM                    Buffer
283800200528     C                   PARM                    APIRetc
283900200528                                                                                              CRE020
284000200528     C                   IF        CRE020 = 'Y'                                               CRE020
284100200528     C                   EVAL      WrkPgm = 'LEMAPYUPD'                                       CRE020
284200200528     C                   EVAL      WrkMod = 'LE'                                              CRE020
284300200528     C                   EXSR      SRSndDtaQ                                                  CRE020
284400200528     C                   ENDIF                                                                CRE020
284500200528
284600200528      * Base rates
284700200528     C     TransTYPE     WHENEQ    'BSRT'
284800200528
284900200528     C                   EXSR      BSRTFmts
285000200528     C     BSRTLn        SUBST     BUFFER:Bfp    TRANS1
285100200528     C                   ADD       BSRTLn        Bfp
285200200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
285300200528     C                   ADD       26            Bfp                                         BUG4469
285400200528     C     BSEXLn        SUBST     BUFFER:Bfp    TRANS2
285500200528     C                   ADD       BSEXLn        Bfp                                        BUG22140
285600200528     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
285700200528     C                   ADD       1             Bfp                                        BUG22140
285800200528
285900200528     C                   CALL      'SDBSRTVU'
286000200528
286100200528      * Common header information (DS) from source system
286200200528     C                   PARM                    HeadIn
286300200528
286400200528      * Transaction information
286500200528     C                   PARM                    TRANS1
286600200528     C                   PARM                    TRANS2
286700200528     C                   PARM                    FldNameArr
286800200528     C                   PARM                    MsgIDArr
286900200528     C                   PARM                    MsgDtaArr
287000200528     C                   PARM                    WFldNamArr
287100200528     C                   PARM                    WMsgIDArr
287200200528     C                   PARM                    WMsgDtaArr
287300200528     C                   PARM                    MsgFArray
287400200528     C                   PARM                    UpdateYN
287500200528     C                   PARM                    Buffer
287600200528     C                   PARM                    APIRetc
287700200528     C                   PARM                    @TimeStamp                                  BUG4469
287800200528     C                   PARM                    AAuth                                      BUG22140
287900200528
288000200528      ** Fees                                                                                BUG1100
288100200528     C     TransTYPE     WHENEQ    'FEEM'                                                    BUG1100
288200200528                                                                                             BUG1100
288300200528     C                   EXSR      FEEMFmts                                                  BUG1100
288400200528     C                   EXSR      SettleFmts                                                BUG1100
288500200528                                                                                             BUG1100
288600200528     C     FEEMLn        SUBST     BUFFER:Bfp    Trans1                                      BUG1100
288700200528     C                   ADD       FEEMLn        Bfp                                         BUG1100
288800200528     C     FEEM2Ln       SUBST     BUFFER:Bfp    Trans2                                      BUG1100
288900200528     C                   ADD       FEEM2Ln       Bfp                                         BUG1100
289000200528     C     LESTMLn       SUBST     BUFFER:Bfp    StampTax                                     CER049
289100200528     C                   ADD       LESTMLn       Bfp                                          CER049
289200200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                    BUG1100
289300200528     C                   ADD       ESSRLn        Bfp                                         BUG1100
289400200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                    BUG1100
289500200528     C                   ADD       ESSPLn        Bfp                                         BUG1100
289600200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
289700200528     C                   ADD       LEIFLn        Bfp                                          CAP086
289800200528     C     FEEXLn        SUBST     BUFFER:Bfp    ExtData                                     BUG1100
289900200528                                                                                             BUG1100
290000200528     C                   CALL      'LEFEEMVU'                                                BUG1100
290100200528                                                                                             BUG1100
290200200528      * Common header information (DS) from source system                                    BUG1100
290300200528     C                   PARM                    HeadIn                                      BUG1100
290400200528                                                                                             BUG1100
290500200528      * Transaction information                                                              BUG1100
290600200528     C                   PARM                    Trans1                                      BUG1100
290700200528     C                   PARM                    Trans2                                      BUG1100
290800200528     C                   PARM                    StampTax                                     CER049
290900200528     C                   PARM                    PaySttmt                                    BUG1100
291000200528     C                   PARM                    RecSttmt                                    BUG1100
291100200528     C                   PARM                    InfData                                      CAP086
291200200528     C                   PARM                    Extdata                                     BUG1100
291300200528     C                   PARM                    FldNameArr                                  BUG1100
291400200528     C                   PARM                    MsgIDArr                                    BUG1100
291500200528     C                   PARM                    MsgDtaArr                                   BUG1100
291600200528     C                   PARM                    WFldNamArr                                  BUG1100
291700200528     C                   PARM                    WMsgIDArr                                   BUG1100
291800200528     C                   PARM                    WMsgDtaArr                                  BUG1100
291900200528     C                   PARM                    MsgFArray                                   BUG1100
292000200528     C                   PARM                    UpdateYN                                    BUG1100
292100200528     C                   PARM                    Buffer                                      BUG1100
292200200528     C                   PARM                    APIRetc                                     BUG1100
292300200528                                                                                             BUG1100
292400200528      * On-line printing of Advice                                                           BUG3071
292500200528     C                   IF        CRE020 = 'Y'                                              BUG3071
292600200528     C                   EVAL      WrkPgm = 'LEFEEMUPD'                                      BUG3071
292700200528     C                   EVAL      WrkMod = 'LE'                                             BUG3071
292800200528     C                   EXSR      SRSndDtaQ                                                 BUG3071
292900200528     C                   ENDIF                                                               BUG3071
293000200528      *                                                                                      BUG3071
293100200528      * Fee Adjustment
293200200528     C     TransTYPE     WHENEQ    'FEAD'
293300200528
293400200528     C                   EXSR      FEADFmts
293500200528      ***Need*to*add*10*chars*for*the*status*field*not*included*on*format             BUG1218 CLE106
293600200528      ***file*LEFEADPD*but*in*API*XML*file*FEAD.XML********************               BUG1218 CLE106
293700200528      ***S#STAT********************************************************               BUG1218 CLE106
293800200528     C*******************ADD*******10************FEADLn****************               BUG1218 CLE106
293900200528      ***Need*to*add*50*chars*for*fields*not*included*on*format********               BUG1304 CLE106
294000200528      ***file*LEFEADPD*but*in*API*XML*file*FEAD.XML********************               BUG1304 CLE106
294100200528      ***S_FTYP*S_FCOD*S_FENV*S_ACCD***********************************               BUG1304 CLE106
294200200528     C*******************ADD*******50************FEADLn****************               BUG1304 CLE106
294300200528                                                                                              CLE106
294400200528     C     FEADLn        SUBST     BUFFER:Bfp    TRANS1
294500200528     C                   ADD       FEADLn        Bfp
294600200528     C     FEA2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
294700200528     C                   ADD       FEA2Ln        Bfp                                          CLE106
294800200528                                                                                              CLE106
294900200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
295000200528
295100200528     C                   CALL      'LEFEADVU'
295200200528
295300200528      * Common header information (DS) from source system
295400200528     C                   PARM                    HeadIn
295500200528
295600200528      * Transaction information
295700200528     C                   PARM                    TRANS1
295800200528     C                   PARM                    TRANS2                                       CLE106
295900200528     C                   PARM                    InfData                                      CAP086
296000200528     C                   PARM                    FldNameArr
296100200528     C                   PARM                    MsgIDArr
296200200528     C                   PARM                    MsgDtaArr
296300200528     C                   PARM                    WFldNamArr
296400200528     C                   PARM                    WMsgIDArr
296500200528     C                   PARM                    WMsgDtaArr
296600200528     C                   PARM                    MsgFArray
296700200528     C                   PARM                    UpdateYN
296800200528     C                   PARM                    Buffer
296900200528     C                   PARM                    APIRetc
297000200528
297100200528      * Fee settlement
297200200528     C     TransTYPE     WHENEQ    'FEST'
297300200528
297400200528     C                   EXSR      FESTFmts
297500200528     C                   EXSR      SettleFmts
297600200528      ***Need*to*add*60*chars*for*fields*not*included*on*format**************                 CLE106
297700200528      ***file*LEFESTPD*but*in*API*XML*file*FEST.XML**************************                 CLE106
297800200528      ***S_STAT*S_FTYP*S_FCOD*S_FENV*S_DUPD**********************************                 CLE106
297900200528                                                                                              CLE106
298000200528      ** 60 chars removed and created new file to hold the information                        CLE106
298100200528     C**********         ADD       60            FESTLn                                       CLE106
298200200528     C     FESTLn        SUBST     BUFFER:Bfp    TRANS1
298300200528     C                   ADD       FESTLn        Bfp
298400200528     C     FES2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
298500200528     C                   ADD       FES2Ln        Bfp                                          CLE106
298600200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
298700200528     C                   ADD       ESSRLn        Bfp
298800200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
298900200528     C                   ADD       ESSPLn        Bfp
299000200528                                                                                              CAP086
299100200528     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
299200200528     C                   ADD       LEIFLn        Bfp                                          CAP086
299300200528
299400200528     C                   CALL      'LEFESTVU'
299500200528
299600200528      * Common header information (DS) from source system
299700200528     C                   PARM                    HeadIn
299800200528
299900200528      * Transaction information
300000200528     C                   PARM                    TRANS1
300100200528     C                   PARM                    TRANS2                                       CLE106
300200200528     C                   PARM                    PaySttmt
300300200528     C                   PARM                    RecSttmt
300400200528     C                   PARM                    InfData                                      CAP086
300500200528     C                   PARM                    FldNameArr
300600200528     C                   PARM                    MsgIDArr
300700200528     C                   PARM                    MsgDtaArr
300800200528     C                   PARM                    WFldNamArr
300900200528     C                   PARM                    WMsgIDArr
301000200528     C                   PARM                    WMsgDtaArr
301100200528     C                   PARM                    MsgFArray
301200200528     C                   PARM                    UpdateYN
301300200528     C                   PARM                    Buffer
301400200528     C                   PARM                    APIRetc
301500200528                                                                                              CRE020
301600200528     C                   IF        CRE020 = 'Y'                                               CRE020
301700200528     C                   EVAL      WrkPgm = 'LEFESTUPD'                                       CRE020
301800200528     C                   EVAL      WrkMod = 'LE'                                              CRE020
301900200528     C                   EXSR      SRSndDtaQ                                                  CRE020
302000200528     C                   ENDIF                                                                CRE020
302100200528
302200200528      * Funding Participant
302300200528     C     TransTYPE     WHENEQ    'FPRT'
302400200528
302500200528     C                   EXSR      FPRTFmts
302600200528     C                   EXSR      SettleFmts
302700200528     C     FPRTLn        SUBST     BUFFER:Bfp    TRANS1
302800200528     C                   ADD       FPRTLn        Bfp
302900200528      *
303000200528      * Primary Facility screen details
303100200528     C     76            SUBST     BUFFER:Bfp    PFData           76
303200200528     C                   ADD       76            Bfp
303300200528
303400200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
303500200528     C                   ADD       ESSRLn        Bfp
303600200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
303700200528     C                   ADD       ESSPLn        Bfp
303800200528
303900200528     C                   CALL      'LEFPRTVU'
304000200528
304100200528      * Common header information (DS) from source system
304200200528     C                   PARM                    HeadIn
304300200528
304400200528      * Transaction information
304500200528     C                   PARM                    TRANS1
304600200528     C                   PARM                    PaySttmt
304700200528     C                   PARM                    RecSttmt
304800200528     C                   PARM                    FldNameArr
304900200528     C                   PARM                    MsgIDArr
305000200528     C                   PARM                    MsgDtaArr
305100200528     C                   PARM                    WFldNamArr
305200200528     C                   PARM                    WMsgIDArr
305300200528     C                   PARM                    WMsgDtaArr
305400200528     C                   PARM                    MsgFArray
305500200528     C                   PARM                    UpdateYN
305600200528     C                   PARM                    Buffer
305700200528     C                   PARM                    APIRetc
305800200528
305900200528      * Assignments
306000200528     C     TransTYPE     WHENEQ    'ASGN'
306100200528
306200200528     C                   EXSR      ASGNFmts
306300200528     C                   EXSR      SettleFmts
306400200528     C     ASGNLn        SUBST     BUFFER:Bfp    TRANS1
306500200528     C                   ADD       ASGNLn        Bfp
306600200528      * Assignments screen details
306700200528     C     17            SUBST     BUFFER:Bfp    PFData17         17
306800200528     C                   ADD       17            Bfp
306900200528
307000200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
307100200528     C                   ADD       ESSRLn        Bfp
307200200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
307300200528     C                   ADD       ESSPLn        Bfp
307400200528
307500200528     C                   CALL      'LEASGNVU'
307600200528
307700200528      * Common header information (DS) from source system
307800200528     C                   PARM                    HeadIn
307900200528
308000200528      * Transaction information
308100200528     C                   PARM                    TRANS1
308200200528     C                   PARM                    PaySttmt
308300200528     C                   PARM                    RecSttmt
308400200528     C                   PARM                    ReservID
308500200528     C                   PARM                    ExtData
308600200528     C                   PARM                    FldNameArr
308700200528     C                   PARM                    MsgIDArr
308800200528     C                   PARM                    MsgDtaArr
308900200528     C                   PARM                    WFldNamArr
309000200528     C                   PARM                    WMsgIDArr
309100200528     C                   PARM                    WMsgDtaArr
309200200528     C                   PARM                    MsgFArray
309300200528     C                   PARM                    UpdateYN
309400200528     C                   PARM                    Buffer
309500200528     C                   PARM                    APIRetc
309600200528
309700200528      * FRA - Forward Rate Agreement deals
309800200528     C     TransTYPE     WHENEQ    'FRA '
309900200528
310000200528     C                   EXSR      FRAFmts
310100200528     C                   EXSR      SettleFmts
310200200528     C                   EXSR      RPIFFmts                                                   CSW213
310300200528     C     FRALn         SUBST     BUFFER:Bfp    TRANS1
310400200528     C                   ADD       FRALn         Bfp
310500200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
310600200528     C                   ADD       26            Bfp                                         BUG4469
310700200528     C     5             SUBST     BUFFER:Bfp    @TLNU             5                         BUG4469
310800200528     C                   ADD       5             Bfp                                         BUG4469
310900200528     C     6             SUBST     BUFFER:Bfp    SUINFD            6                         BUG6377
311000200528     C                   ADD       6             Bfp                                         BUG6377
311100200528     C     6             SUBST     BUFFER:Bfp    STINFD            6                         BUG6377
311200200528     C                   ADD       6             Bfp                                         BUG6377
311300200528     C     24            SUBST     BUFFER:Bfp    DDSTS            24                         BUG5871
311400200528     C                   ADD       24            Bfp                                         BUG5871
311500200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
311600200528     C                   ADD       ESSRLn        Bfp
311700200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
311800200528     C                   ADD       ESSPLn        Bfp
311900200528     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
312000200528     C                   ADD       ESSFLn        Bfp
312100200528     C     IRFRLn        SUBST     BUFFER:Bfp    InfData                                    BUG18701
312200200528     C                   ADD       IRFRLn        Bfp                                          CSW213
312300200528     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213
312400200528
312500200528     C                   CALL      'IRFRAVU'
312600200528
312700200528      * Common header information (DS) from source system
312800200528     C                   PARM                    HeadIn
312900200528
313000200528      * Transaction information
313100200528     C                   PARM                    TRANS1
313200200528     C                   PARM                    PaySttmt
313300200528     C                   PARM                    RecSttmt
313400200528     C                   PARM                    FRASttmt
313500200528     C                   PARM                    InfData                                    BUG18701
313600200528     C                   PARM                    ReservID
313700200528     C                   PARM                    ExtData
313800200528     C                   PARM                    InSwift2013                                  CSW213
313900200528     C                   PARM                    FldNameArr
314000200528     C                   PARM                    MsgIDArr
314100200528     C                   PARM                    MsgDtaArr
314200200528     C                   PARM                    WFldNamArr
314300200528     C                   PARM                    WMsgIDArr
314400200528     C                   PARM                    WMsgDtaArr
314500200528     C                   PARM                    MsgFArray
314600200528     C                   PARM                    UpdateYN
314700200528     C                   PARM                    Buffer
314800200528     C                   PARM                    APIRetc
314900200528     C                   PARM                    @TimeStamp                                  BUG4469
315000200528     C                   PARM                    @TLNU                                       BUG4469
315100200528                                                                                              CRE020
315200200528     C                   IF        CRE020 = 'Y'                                               CRE020
315300200528     C                   EVAL      WrkPgm = 'IRFRAUPD'                                        CRE020
315400200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
315500200528     C                   EXSR      SRSndDtaQ                                                  CRE020
315600200528     C                   ENDIF                                                                CRE020
315700200528
315800200528      ** Single Currency IRS (SIRS)
315900200528
316000200528     C     TransTYPE     WHENEQ    'SIRS'
316100200528
316200200528     C                   EXSR      SrSIRS
316300200528
316400200528      ** Cross Currency IRS (CIRS)
316500200528     C     TransTYPE     WHENEQ    'CIRS'
316600200528
316700200528     C                   EXSR      CIRSFmts
316800200528     C                   EXSR      SettleFmts
316900200528     C                   EXSR      RPIFFmts                                                   CSW213
317000200528
317100200528     C*****CIRSLn******* SUBST     BUFFER:Bfp    TRANS1                                       CDL028
317200200528     C     CIRSLn        SUBST     BUFFER:Bfp    TRANS1A                                      CDL028
317300200528     C                   ADD       CIRSLn        Bfp
317400200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
317500200528     C                   ADD       ESSRLn        Bfp
317600200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
317700200528     C                   ADD       ESSPLn        Bfp
317800200528     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                    BUG5449
317900200528     C                   ADD       ESSFLn        Bfp                                         BUG5449
318000200528      ** Extra Settlements
318100200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtV
318200200528     C                   ADD       ESSRLn        Bfp
318300200528     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtV
318400200528     C                   ADD       ESSPLn        Bfp
318500200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtM
318600200528     C                   ADD       ESSRLn        Bfp
318700200528     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtM
318800200528     C                   ADD       ESSPLn        Bfp
318900200528
319000200528      **  Non-Screen Interface Data for Class 1 enhancements
319100200528
319200200528     C     IRRXLn        SUBST     BUFFER:Bfp    InfData
319300200528     C                   ADD       IRRXLn        Bfp
319400200528
319500200528     C                   EVAL      IRCS2Ln = 6000 - Bfp                                     MD029663
319600200528     C*****IRCSLn        SUBST     BUFFER:Bfp    ExtData                                    MD029663
319700200528     C**********         ADD       IRCSLn        Bfp                                 CSW213 MD029663
319800200528     C     IRCS2Ln       SUBST     Buffer:Bfp    TempData#7                                 MD029663
319900200528     C**********         ADD       IRCS2Ln       Bfp                               MD029663 MD030454
320000200528     C**********         ADD       168           Bfp                                 CSW213 MD030454
320100200528     C**********         EVAL      InSwift2013 = %SUBST(BufferTotal:Bfp:RPIFLn)      CSW213 MD030454
320200200528
320300200528     C                   EVAL      IRCS3Ln = IRCSLn - IRCS2Ln                               MD029663
320400200528     C     IRCS3Ln       SUBST     BUFFER2:Bfp2  TempData#8                                 MD029663
320500200528     C                   ADD       IRCS3Ln       Bfp2                                       MD029663
320600200528     C                   EVAL      TempData#9 = TempData#7 + TempData#8                     MD029663
320700200528     C                   MOVEL     TempData#9    ExtData                                    MD029663
320800200528     C                   ADD       IRCSLn        Bfp                                        MD030454
320900200528     C                   ADD       168           Bfp                                        MD030454
321000200528     C                   EVAL      InSwift2013 = %SUBST(BufferTotal:Bfp:RPIFLn)             MD030454
321100200528                                                                                            MD029663
321200200528     C                   CALL      'IRCIRSVU'
321300200528
321400200528      * Common header information (DS) from source system
321500200528     C                   PARM                    HeadIn
321600200528
321700200528      * Transaction information
321800200528     C**********         PARM                    TRANS1                                       CDL028
321900200528     C                   PARM                    TRANS1A                                      CDL028
322000200528     C                   PARM                    PaySttmt
322100200528     C                   PARM                    RecSttmt
322200200528     C                   PARM                    FRASttmt
322300200528     C                   PARM                    PayStmtV
322400200528     C                   PARM                    RecStmtV
322500200528     C                   PARM                    PayStmtM
322600200528     C                   PARM                    RecStmtM
322700200528     C                   PARM                    InfData                                     BUG6671
322800200528     C                   PARM                    ExtData
322900200528     C                   PARM                    InSwift2013                                  CSW213
323000200528     C                   PARM                    FldNameArr
323100200528     C                   PARM                    MsgIDArr
323200200528     C                   PARM                    MsgDtaArr
323300200528     C                   PARM                    WFldNamArr
323400200528     C                   PARM                    WMsgIDArr
323500200528     C                   PARM                    WMsgDtaArr
323600200528     C                   PARM                    MsgFArray
323700200528     C                   PARM                    UpdateYN
323800200528     C                   PARM                    Buffer
323900200528     C                   PARM                    Buffer2                                     BUG5449
324000200528     C                   PARM                    BufferEx2                                   BUG5449
324100200528     C                   PARM                    BufferEx3                                   BUG5449
324200200528     C                   PARM                    BufferEx4                                   BUG5449
324300200528     C                   PARM                    BufferEx5                                   BUG5449
324400200528     C                   PARM                    BufferEx6                                   BUG5449
324500200528     C                   PARM                    BufferEx7                                   BUG5449
324600200528     C                   PARM                    BufferEx8                                   BUG5449
324700200528     C                   PARM                    BufferEx9                                   BUG5449
324800200528     C                   PARM                    APIRetc
324900200528                                                                                              CRE020
325000200528     C                   IF        CRE020 = 'Y'                                               CRE020
325100200528     C                   EVAL      WrkPgm = 'IRCIRSUPD'                                       CRE020
325200200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
325300200528     C                   EXSR      SRSndDtaQ                                                  CRE020
325400200528     C                   ENDIF                                                                CRE020
325500200528
325600200528      * SE Securities Details
325700200528     C     TransTYPE     WHENEQ    'SECS'
325800200528
325900200528     C                   EXSR      SECSFmts
326000200528
326100200528     C     SEC1Ln        SUBST     BUFFER:Bfp    TRANS1
326200200528     C                   ADD       SEC1Ln        Bfp
326300200528     C     SEC2Ln        SUBST     BUFFER:Bfp    TRANS2
326400200528     C                   ADD       SEC2Ln        Bfp
326500200528     C     SEC3Ln        SUBST     BUFFER:Bfp    TRANS3
326600200528     C                   ADD       SEC3Ln        Bfp
326700200528     C     SEC4Ln        SUBST     BUFFER:Bfp    TRANS4
326800200528     C                   ADD       SEC4Ln        Bfp
326900200528     C     SEC5Ln        SUBST     BUFFER:Bfp    TRANS5
327000200528     C                   ADD       SEC5Ln        Bfp
327100200528     C     SEC6Ln        SUBST     BUFFER:Bfp    TRANS6                                       CSE071
327200200528     C                   ADD       SEC6Ln        Bfp                                          CSE071
327300200528      **  Restore Timestamp field from the record                                            BUG1569
327400200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG1569
327500200528     C                   ADD       26            Bfp                                         BUG1569
327600200528     C     SECSFLn       SUBST     BUFFER:Bfp    SECSFiller                                  BUG5988
327700200528     C                   ADD       SECSFLn       Bfp                                         BUG5988
327800200528     C     SEEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
327900200528     C                   ADD       SEEXLn        Bfp                                        MD044880
328000200528     C     SERXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
328100200528     C                   ADD       SERXLn        Bfp                                          CER001
328200200528     C*****SEEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
328300200528
328400200528     C                   CALL      'SESECSVU'
328500200528
328600200528      * Common header information (DS) from source system
328700200528     C                   PARM                    HeadIn
328800200528
328900200528      * Transaction information
329000200528     C                   PARM                    TRANS1
329100200528     C                   PARM                    TRANS2
329200200528     C                   PARM                    TRANS3
329300200528     C                   PARM                    TRANS4
329400200528     C                   PARM                    TRANS5
329500200528     C                   PARM                    TRANS6                                       CSE071
329600200528     C                   PARM                    RegData                                      CER001
329700200528     C                   PARM                    ExtData
329800200528
329900200528     C                   PARM                    FldNameArr
330000200528     C                   PARM                    MsgIDArr
330100200528     C                   PARM                    MsgDtaArr
330200200528     C                   PARM                    WFldNamArr
330300200528     C                   PARM                    WMsgIDArr
330400200528     C                   PARM                    WMsgDtaArr
330500200528     C                   PARM                    MsgFArray
330600200528     C                   PARM                    UpdateYN
330700200528     C                   PARM                    Buffer
330800200528     C                   PARM                    APIRetc
330900200528     C                   PARM                    @TimeStamp                                  BUG1569
331000200528
331100200528      * SE Trade
331200200528
331300200528     C     TransTYPE     WHENEQ    'TRAD'
331400200528
331500200528     C                   EXSR      TRADFmts
331600200528
331700200528     C     TRPRLn        SUBST     BUFFER:Bfp    TRANS1
331800200528     C                   ADD       TRPRLn        Bfp
331900200528     C     TRSELn        SUBST     BUFFER:Bfp    TRANS2
332000200528     C                   ADD       TRSELn        Bfp
332100200528     C     TRPVLn        SUBST     BUFFER:Bfp    TRANS2B                                    BUG11194
332200200528     C                   ADD       TRPVLn        Bfp                                        BUG11194
332300200528     C     TREXLn        SUBST     BUFFER:Bfp    TRANS3
332400200528     C                   ADD       TREXLn        Bfp
332500200528     C*****TRSTLn        SUBST     BUFFER:Bfp    TRANS4                                      CSF011A
332600200528     C     TRSTLn        SUBST     BUFFER:Bfp    TRANS4A                                     CSF011A
332700200528     C                   ADD       TRSTLn        Bfp
332800200528     C     TRCCLn        SUBST     BUFFER:Bfp    TRANS5
332900200528     C                   ADD       TRCCLn        Bfp
333000200528     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS6
333100200528     C                   ADD       TRSWLn        Bfp
333200200528     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS7
333300200528     C                   ADD       TRSWLn        Bfp
333400200528     C*****TRX2Ln        SUBST     BUFFER:Bfp    OthrData                                    CSF011A
333500200528     C**********         ADD       TRX2Ln        Bfp                                         CSF011A
333600200528     C     4667          SUBST     BUffer:Bfp    TempData#5                                  CSF011A
333700200528     C                   SUB       4667          TRX2Ln                                      CSF011A
333800200528     C     TRX2Ln        SUBST     BUFFER2:Bfp2  TempData#6                                  CSF011A
333900200528     C                   ADD       TRX2Ln        Bfp2                                        CSF011A
334000200528     C                   MOVEL     TempData#5    TRADSettleData                              CSF011A
334100200528     C                   MOVE      TempData#6    TRADSettleData                              CSF011A
334200200528     C*****TRHALn        SUBST     BUFFER:Bfp    TRANS8                                      CSF011A
334300200528     C**********         ADD       TRHALn        Bfp                                         CSF011A
334400200528     C     TRHALn        SUBST     BUFFER2:Bfp2  TRANS8                                      CSF011A
334500200528     C                   ADD       TRHALn        Bfp2                                        CSF011A
334600200528      **  Restore Timestamp field from the record                                            BUG1569
334700200528     C*****26***         SUBST     BUFFER:Bfp    @TimeStamp                          BUG1569 CSF011A
334800200528     C**********         ADD       26            Bfp                                 BUG1569 CSF011A
334900200528     C     26            SUBST     BUFFER2:Bfp2  @TimeStamp                                  CSF011A
335000200528     C                   ADD       26            Bfp2                                        CSF011A
335100200528      **  Other Data                                                                         BUG9584
335200200528     C*****TDAXLn        SUBST     BUFFER:Bfp    OthData1                            BUG9584 CSF011A
335300200528     C**********         ADD       TDAXLn        Bfp                                 BUG9584 CSF011A
335400200528     C     TDAXLn        SUBST     BUFFER2:Bfp2  OthData1                                    CSF011A
335500200528     C                   ADD       TDAXLn        Bfp2                                        CSF011A
335600200528      ** InfData does not exists in TRAD.xml                                                BUG10202
335700200528      ****Non-Screen*Interface*Data*for*Class*1*enhancements***********                     BUG10202
335800200528     C*****SETILn        SUBST     BUFFER:Bfp    InfData                                    BUG10202
335900200528     C**********         ADD       SETILn        Bfp                                        BUG10202
336000200528     C*****20***         SUBST     BUFFER:Bfp    FRNT                              AR698195B CSF011A
336100200528     C**********         ADD       20            Bfp                               AR698195B CSF011A
336200200528     C*****20***         SUBST     BUffer:Bfp    TradQ            20                  CER049 CSF011A
336300200528     C**********         ADD       20            Bfp                                  CER049 CSF011A
336400200528     C*****1****         SUBST     Buffer:Bfp    AAuth                             AR698195B CSF011A
336500200528     C**********         ADD       1             Bfp                               AR698195B CSF011A
336600200528     C*****TDRXLn        SUBST     BUFFER:Bfp    RegData                              CER001 CSF011A
336700200528     C**********         ADD       TDRXLn        Bfp                                  CER001 CSF011A
336800200528     C*****SETRLn        SUBST     BUFFER:Bfp    ExtData                                     CSF011A
336900200528     C     20            SUBST     BUFFER2:Bfp2  FRNT                                        CSF011A
337000200528     C                   ADD       20            Bfp2                                        CSF011A
337100200528     C     20            SUBST     BUffer2:Bfp2  TradQ            20                         CSF011A
337200200528     C                   ADD       20            Bfp2                                        CSF011A
337300200528     C     1             SUBST     Buffer2:Bfp2  AAuth                                       CSF011A
337400200528     C                   ADD       1             Bfp2                                        CSF011A
337500200528     C     TDRXLn        SUBST     BUFFER2:Bfp2  RegData                                     CSF011A
337600200528     C                   ADD       TDRXLn        Bfp2                                        CSF011A
337700200528     C     SETRLn        SUBST     BUFFER2:Bfp2  ExtData                                     CSF011A
337800200528     C**********         ADD       SETRLn        Bfp                              BUG22155 AR698195B
337900200528     C*****1****         SUBST     BUFFER:Bfp    AAuth                            BUG22155 AR698195B
338000200528     C**********         ADD       1             Bfp                              BUG22155 AR698195B
338100200528
338200200528     C                   CALL      'SETRADVU'
338300200528
338400200528      * Common header information (DS) from source system
338500200528     C                   PARM                    HeadIn
338600200528
338700200528      * Transaction information
338800200528     C                   PARM                    TRANS1
338900200528     C                   PARM                    TRANS2
339000200528     C                   PARM                    TRANS2B                                    BUG11194
339100200528     C                   PARM                    TRANS3
339200200528     C**********         PARM                    TRANS4                                      CSF011A
339300200528     C                   PARM                    TRANS4A                                     CSF011A
339400200528     C                   PARM                    TRANS5
339500200528     C                   PARM                    TRANS6
339600200528     C                   PARM                    TRANS7
339700200528     C                   PARM                    TRANS8
339800200528     C**********         PARM                    OthrData                                    CSF011A
339900200528     C                   PARM                    TRADSettleData                              CSF011A
340000200528     C                   PARM                    OthData1                                     CER001
340100200528     C**********         PARM                    InfData                                    BUG10202
340200200528     C                   PARM                    RegData                                      CER001
340300200528     C                   PARM                    ExtData
340400200528
340500200528     C                   PARM                    FldNameArr
340600200528     C                   PARM                    MsgIDArr
340700200528     C                   PARM                    MsgDtaArr
340800200528     C                   PARM                    WFldNamArr
340900200528     C                   PARM                    WMsgIDArr
341000200528     C                   PARM                    WMsgDtaArr
341100200528     C                   PARM                    MsgFArray
341200200528     C                   PARM                    UpdateYN
341300200528     C                   PARM                    Buffer
341400200528     C                   PARM                    Buffer2                                     CSF011A
341500200528     C                   PARM                    APIRetc
341600200528     C                   PARM                    @TimeStamp                                  BUG1569
341700200528     C                   PARM                    TradQ                                        CER049
341800200528     C                   PARM                    AAuth                                      BUG22155
341900200528     C                   PARM                    FRNT                                      AR698195B
342000200528                                                                                              CRE020
342100200528     C                   IF        CRE020 = 'Y'                                               CRE020
342200200528     C                   EVAL      WrkPgm = 'SETRADUPD'                                       CRE020
342300200528     C                   EVAL      WrkMod = 'SE'                                              CRE020
342400200528     C                   EXSR      SRSndDtaQ                                                  CRE020
342500200528     C                   ENDIF                                                                CRE020
342600200528
342700200528      * Request for transfer
342800200528
342900200528     C     TransTYPE     WHENEQ    'RFTD'
343000200528
343100200528     C                   EVAL      Trans1 = Buffer
343200200528     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)
343300200528
343400200528     C                   CALL      'FTM1011VU'
343500200528     C                   PARM                    HeadIn
343600200528      * Transaction information
343700200528     C                   PARM                    Trans1
343800200528     C                   PARM                    Trans2
343900200528     C                   PARM                    FldNameArr
344000200528     C                   PARM                    MsgIDArr
344100200528     C                   PARM                    MsgDtaArr
344200200528     C                   PARM                    WFldNamArr
344300200528     C                   PARM                    WMsgIDArr
344400200528     C                   PARM                    WMsgDtaArr
344500200528     C                   PARM                    MsgFArray
344600200528     C                   PARM                    UpdateYN
344700200528     C                   PARM                    Buffer
344800200528     C                   PARM                    APIRetc
344900200528                                                                                              CRE020
345000200528     C                   IF        CRE020 = 'Y'                                               CRE020
345100200528     C                   EVAL      WrkPgm = 'FTM101UPD'                                       CRE020
345200200528     C                   EVAL      WrkMod = 'FT'                                              CRE020
345300200528     C                   EXSR      SRSndDtaQ                                                  CRE020
345400200528     C                   ENDIF                                                                CRE020
345500200528
345600200528      * Request for transfer details
345700200528
345800200528     C     TransTYPE     WHENEQ    'RFT2'
345900200528
346000200528     C                   EVAL      Trans1 = Buffer
346100200528     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)
346200200528     C                   EVAL      Trans3 = %SUBST(Buffer:1001:500)
346300200528
346400200528     C                   CALL      'FTM1012VU'
346500200528     C                   PARM                    HeadIn
346600200528      * Transaction information
346700200528     C                   PARM                    Trans1
346800200528     C                   PARM                    Trans2
346900200528     C                   PARM                    Trans3
347000200528     C                   PARM                    FldNameArr
347100200528     C                   PARM                    MsgIDArr
347200200528     C                   PARM                    MsgDtaArr
347300200528     C                   PARM                    WFldNamArr
347400200528     C                   PARM                    WMsgIDArr
347500200528     C                   PARM                    WMsgDtaArr
347600200528     C                   PARM                    MsgFArray
347700200528     C                   PARM                    UpdateYN
347800200528     C                   PARM                    Buffer
347900200528     C                   PARM                    APIRetc
348000200528                                                                                              CRE020
348100200528     C                   IF        CRE020 = 'Y'                                               CRE020
348200200528     C                   EVAL      WrkPgm = 'FTM101UPD'                                       CRE020
348300200528     C                   EVAL      WrkMod = 'FT'                                              CRE020
348400200528     C                   EXSR      SRSndDtaQ                                                  CRE020
348500200528     C                   ENDIF                                                                CRE020
348600200528
348700200528      * Credit customer transfer
348800200528
348900200528     C     TransTYPE     WHENEQ    'CCTD'
349000200528
349100200528     C                   EVAL      Trans1 = Buffer
349200200528     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)
349300200528
349400200528     C                   CALL      'FTM1021VU'
349500200528     C                   PARM                    HeadIn
349600200528      * Transaction information
349700200528     C                   PARM                    Trans1
349800200528     C                   PARM                    Trans2
349900200528     C                   PARM                    FldNameArr
350000200528     C                   PARM                    MsgIDArr
350100200528     C                   PARM                    MsgDtaArr
350200200528     C                   PARM                    WFldNamArr
350300200528     C                   PARM                    WMsgIDArr
350400200528     C                   PARM                    WMsgDtaArr
350500200528     C                   PARM                    MsgFArray
350600200528     C                   PARM                    UpdateYN
350700200528     C                   PARM                    Buffer
350800200528     C                   PARM                    APIRetc
350900200528                                                                                              CRE020
351000200528     C                   IF        CRE020 = 'Y'                                               CRE020
351100200528     C                   EVAL      WrkPgm = 'FTM102UPD'                                       CRE020
351200200528     C                   EVAL      WrkMod = 'FT'                                              CRE020
351300200528     C                   EXSR      SRSndDtaQ                                                  CRE020
351400200528     C                   ENDIF                                                                CRE020
351500200528
351600200528      * Customer credit transfer details
351700200528
351800200528     C     TransTYPE     WHENEQ    'CCT2'
351900200528
352000200528     C                   EVAL      Trans1 = Buffer
352100200528     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)
352200200528     C                   EVAL      Trans3 = %SUBST(Buffer:1001:500)
352300200528
352400200528     C                   CALL      'FTM1022VU'
352500200528     C                   PARM                    HeadIn
352600200528      * Transaction information
352700200528     C                   PARM                    Trans1
352800200528     C                   PARM                    Trans2
352900200528     C                   PARM                    Trans3
353000200528     C                   PARM                    FldNameArr
353100200528     C                   PARM                    MsgIDArr
353200200528     C                   PARM                    MsgDtaArr
353300200528     C                   PARM                    WFldNamArr
353400200528     C                   PARM                    WMsgIDArr
353500200528     C                   PARM                    WMsgDtaArr
353600200528     C                   PARM                    MsgFArray
353700200528     C                   PARM                    UpdateYN
353800200528     C                   PARM                    Buffer
353900200528     C                   PARM                    APIRetc
354000200528                                                                                              CRE020
354100200528     C                   IF        CRE020 = 'Y'                                               CRE020
354200200528     C                   EVAL      WrkPgm = 'FTM102UPD'                                       CRE020
354300200528     C                   EVAL      WrkMod = 'FT'                                              CRE020
354400200528     C                   EXSR      SRSndDtaQ                                                  CRE020
354500200528     C                   ENDIF                                                                CRE020
354600200528
354700200528      * FF OTCC
354800200528
354900200528     C     TransTYPE     WHENEQ    'OTCC'
355000200528
355100200528     C                   EXSR      OTCCFmts
355200200528
355300200528     C     OTCCLn        SUBST     BUFFER:Bfp    TRANS1
355400200528     C                   ADD       OTCCLn        Bfp
355500200528     C     OTCCLnS       SUBST     BUFFER:Bfp    TRANS2
355600200528     C                   ADD       OTCCLnS       Bfp
355700200528     C*****OTCCLnX       SUBST     BUFFER:Bfp    ExtData                                      CER001
355800200528     C**********         ADD       OTCCLnX       Bfp                                  BUG4258 CER001
355900200528      **  Restore Timestamp field from the record                                            BUG4258
356000200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
356100200528     C                   ADD       26            Bfp                                         BUG4258
356200200528     C     15            SUBST     BUFFER:Bfp    SPREM            15                         BUG6274
356300200528     C                   ADD       15            Bfp                                         BUG6274
356400200528     C     1             SUBST     BUFFER:Bfp    WNewInst          1                         BUG9601
356500200528     C                   ADD       1             Bfp                                         BUG9601
356600200528     C     OTRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
356700200528     C                   ADD       OTRXLn        Bfp                                          CER001
356800200528     C     OTCCLnX       SUBST     BUFFER:Bfp    ExtData                                      CER001
356900200528     C                   ADD       OTCCLnX       Bfp                                          CER001
357000200528
357100200528     C                   CALL      'FFOTCCVU'
357200200528     C                   PARM                    HeadIn
357300200528      * Transaction information
357400200528     C                   PARM                    Trans1
357500200528     C                   PARM                    Trans2
357600200528     C                   PARM                    RegData                                      CER001
357700200528     C                   PARM                    ExtData
357800200528     C                   PARM                    FldNameArr
357900200528     C                   PARM                    MsgIDArr
358000200528     C                   PARM                    MsgDtaArr
358100200528     C                   PARM                    WFldNamArr
358200200528     C                   PARM                    WMsgIDArr
358300200528     C                   PARM                    WMsgDtaArr
358400200528     C                   PARM                    MsgFArray
358500200528     C                   PARM                    UpdateYN
358600200528     C                   PARM                    Buffer
358700200528     C                   PARM                    APIRetc
358800200528     C                   PARM                    @TimeStamp                                  BUG4258
358900200528     C                   PARM                    SPREM                                       BUG6274
359000200528                                                                                              CRE020
359100200528     C                   IF        CRE020 = 'Y'                                               CRE020
359200200528     C                   EVAL      WrkPgm = 'FFOTCCSIN'                                       CRE020
359300200528     C                   EVAL      WrkMod = 'FF'                                              CRE020
359400200528     C                   EXSR      SRSndDtaQ                                                  CRE020
359500200528     C                   ENDIF                                                                CRE020
359600200528
359700200528      * FF OTCO
359800200528
359900200528     C     TransTYPE     WHENEQ    'OTCO'
360000200528
360100200528     C                   EXSR      OTCOFmts
360200200528
360300200528     C     OTCOLn        SUBST     BUFFER:Bfp    TRANS1
360400200528     C                   ADD       OTCOLn        Bfp
360500200528     C     OTCOLnS       SUBST     BUFFER:Bfp    TRANS2
360600200528     C                   ADD       OTCOLnS       Bfp
360700200528     C*****OTCOLnX       SUBST     BUFFER:Bfp    ExtData                                     BUG8163
360800200528     C**********         ADD       OTCOLnX       Bfp                                 BUG4258 BUG8163
360900200528      **  Restore Timestamp field from the record                                            BUG4258
361000200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
361100200528     C                   ADD       26            Bfp                                         BUG4258
361200200528     C     15            SUBST     BUFFER:Bfp    SPREM            15                         BUG6274
361300200528     C                   ADD       15            Bfp                                         BUG6274
361400200528
361500200528     C                   CALL      'FFOTCOVU'
361600200528     C                   PARM                    HeadIn
361700200528      * Transaction information
361800200528     C                   PARM                    Trans1
361900200528     C                   PARM                    Trans2
362000200528     C                   PARM                    ExtData
362100200528     C                   PARM                    FldNameArr
362200200528     C                   PARM                    MsgIDArr
362300200528     C                   PARM                    MsgDtaArr
362400200528     C                   PARM                    WFldNamArr
362500200528     C                   PARM                    WMsgIDArr
362600200528     C                   PARM                    WMsgDtaArr
362700200528     C                   PARM                    MsgFArray
362800200528     C                   PARM                    UpdateYN
362900200528     C                   PARM                    Buffer
363000200528     C                   PARM                    APIRetc
363100200528     C                   PARM                    @TimeStamp                                  BUG4258
363200200528     C                   PARM                    SPREM                                       BUG6274
363300200528                                                                                              CRE020
363400200528     C                   IF        CRE020 = 'Y'                                               CRE020
363500200528     C                   EVAL      WrkPgm = 'FFOTCOSIN'                                       CRE020
363600200528     C                   EVAL      WrkMod = 'FF'                                              CRE020
363700200528     C                   EXSR      SRSndDtaQ                                                  CRE020
363800200528     C                   ENDIF                                                                CRE020
363900200528
364000200528      * FF Exchange-Traded Transactions
364100200528
364200200528     C     TransTYPE     WHENEQ    'EXTR'
364300200528
364400200528     C                   EXSR      EXTRFmts
364500200528
364600200528     C     EXTRLn        SUBST     BUFFER:Bfp    TRANS1
364700200528     C                   ADD       EXTRLn        Bfp
364800200528     C     EXTRLnCS      SUBST     BUFFER:Bfp    TRANS2
364900200528     C                   ADD       EXTRLnCS      Bfp
365000200528     C*****EXTRLnBS      SUBST     BUFFER:Bfp    TRANS2                                     BUG26906
365100200528     C     EXTRLnBS      SUBST     BUFFER:Bfp    TRANS3                                     BUG26906
365200200528     C                   ADD       EXTRLnBS      Bfp
365300200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP191
365400200528     C                   ADD       26            Bfp                                          CAP191
365500200528     C     1             SUBST     BUFFER:Bfp    AAUTH                                        CAP191
365600200528     C                   ADD       1             Bfp                                          CAP191
365700200528     C     EXTRLnR       SUBST     BUFFER:Bfp    RegData                                      CAP191
365800200528     C                   ADD       EXTRLnR       Bfp                                          CAP191
365900200528     C     EXTRLnX       SUBST     BUFFER:Bfp    ExtData
366000200528     C                   ADD       EXTRLnX       Bfp                                          CAP191
366100200528     C     20            SUBST     BUFFER:Bfp    FRNT                                         CAP191
366200200528     C                   ADD       20            Bfp                                          CAP191
366300200528     C     20            SUBST     BUFFER:Bfp    AFRT                                         CAP191
366400200528     C                   ADD       20            Bfp                                          CAP191
366500200528
366600200528     C                   CALL      'FFEXTRVU'
366700200528     C                   PARM                    HeadIn
366800200528      * Transaction information
366900200528     C                   PARM                    Trans1
367000200528     C                   PARM                    Trans2
367100200528     C                   PARM                    Trans3
367200200528     C                   PARM                    RegData                                      CAP191
367300200528     C                   PARM                    ExtData
367400200528     C                   PARM                    FldNameArr
367500200528     C                   PARM                    MsgIDArr
367600200528     C                   PARM                    MsgDtaArr
367700200528     C                   PARM                    WFldNamArr
367800200528     C                   PARM                    WMsgIDArr
367900200528     C                   PARM                    WMsgDtaArr
368000200528     C                   PARM                    MsgFArray
368100200528     C                   PARM                    UpdateYN
368200200528     C                   PARM                    Buffer
368300200528     C                   PARM                    APIRetc
368400200528     C                   PARM                    @TimeStamp                                   CAP191
368500200528     C                   PARM                    AAUTH                                        CAP191
368600200528     C                   PARM                    FRNT                                         CAP191
368700200528     C                   PARM                    AFRT                                         CAP191
368800200528                                                                                              CRE020
368900200528     C                   IF        CRE020 = 'Y'                                               CRE020
369000200528     C                   EVAL      WrkPgm = 'FFEXTRSIN'                                       CRE020
369100200528     C                   EVAL      WrkMod = 'FF'                                              CRE020
369200200528     C                   EXSR      SRSndDtaQ                                                  CRE020
369300200528     C                   ENDIF                                                                CRE020
369400200528
369500200528      * SE Depot Movements
369600200528
369700200528     C     TransTYPE     WHENEQ    'DPWI'
369800200528     C     TransTYPE     OREQ      'DPWO'
369900200528     C     TransTYPE     OREQ      'DPMV'                                                     CAP087
370000200528
370100200528     C                   EXSR      DPMVFmts
370200200528     C     DMWILn        SUBST     BUFFER:Bfp    TRANS1
370300200528     C                   ADD       DMWILn        Bfp
370400200528
370500200528     C     DMesLn        SUBST     BUFFER:Bfp    OthrData
370600200528     C                   ADD       DMesLn        Bfp
370700200528      *   Depot Movement Type for Walk-In (WI)/ Walk-Out (WO)
370800200528     C     2             SUBST     BUFFER:Bfp    DPMVType          2
370900200528     C                   ADD       2             Bfp
371000200528      **  Restore Timestamp field from the record                                            BUG1569
371100200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG1569
371200200528     C                   ADD       26            Bfp                                         BUG1569
371300200528     C     DMAXLn        SUBST     BUFFER:Bfp    OthData                                     BUG9089
371400200528     C                   ADD       DMAXLn        Bfp                                         BUG9089
371500200528     C     DMRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
371600200528     C                   ADD       DMRXLn        Bfp                                          CER001
371700200528      **  Non-Screen Interface Data for Class 1 enhancements
371800200528     C     DMEXLn        SUBST     BUFFER:Bfp    ExtData
371900200528     C                   ADD       DMEXLn        Bfp                                        BUG22140
372000200528     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
372100200528     C                   ADD       1             Bfp                                        BUG22140
372200200528
372300200528     C                   CALL      'SEDPMVVU'
372400200528
372500200528      * Common header information (DS) from source system
372600200528     C                   PARM                    HeadIn
372700200528
372800200528      * Transaction information
372900200528     C                   PARM                    TRANS1
373000200528     C                   PARM                    OthrData
373100200528     C                   PARM                    DPMVType
373200200528     C                   PARM                    OthData                                     BUG9089
373300200528     C                   PARM                    RegData                                      CER001
373400200528     C                   PARM                    ExtData
373500200528
373600200528     C                   PARM                    FldNameArr
373700200528     C                   PARM                    MsgIDArr
373800200528     C                   PARM                    MsgDtaArr
373900200528     C                   PARM                    WFldNamArr
374000200528     C                   PARM                    WMsgIDArr
374100200528     C                   PARM                    WMsgDtaArr
374200200528     C                   PARM                    MsgFArray
374300200528     C                   PARM                    UpdateYN
374400200528     C                   PARM                    Buffer
374500200528     C                   PARM                    APIRetc
374600200528     C                   PARM                    @TimeStamp                                  BUG1569
374700200528     C                   PARM                    AAuth                                      BUG22140
374800200528                                                                                              CRE020
374900200528     C                   IF        CRE020 = 'Y'                                               CRE020
375000200528     C                   EVAL      WrkPgm = 'SEDPMVUPD'                                       CRE020
375100200528     C                   EVAL      WrkMod = 'SE'                                              CRE020
375200200528     C                   EXSR      SRSndDtaQ                                                  CRE020
375300200528     C                   ENDIF                                                                CRE020
375400200528
375500200528      * MM Negotiable Assets Purchased
375600200528
375700200528     C     TransTYPE     WHENEQ    'NASP'
375800200528
375900200528     C                   EXSR      NASPFmts
376000200528     C                   EXSR      SettleFmts
376100200528
376200200528     C     NASPLn        SUBST     BUFFER:Bfp    TRANS1
376300200528     C                   ADD       NASPLn        Bfp
376400200528      **  Restore Timestamp field from the record                                            BUG4146
376500200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4146
376600200528     C                   ADD       26            Bfp                                         BUG4146
376700200528     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
376800200528     C                   ADD       20            Bfp                                          239400
376900200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
377000200528     C                   ADD       ESSRLn        Bfp
377100200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
377200200528     C                   ADD       ESSPLn        Bfp
377300200528     C     NAIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
377400200528     C                   ADD       NAIFLn        Bfp                                          CAP086
377500200528     C     NPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
377600200528     C                   ADD       NPEXLn        Bfp                                        MD044880
377700200528     C     NPRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
377800200528     C                   ADD       NPRXLn        Bfp                                          CER001
377900200528     C*****NPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
378000200528
378100200528     C                   CALL      'MMNASPVU'
378200200528      * Common header information (DS) from source system
378300200528     C                   PARM                    HeadIn
378400200528      * Transaction information in a single large field from source system
378500200528     C                   PARM                    Trans1
378600200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
378700200528     C                   PARM                    PaySttmt
378800200528     C                   PARM                    RecSttmt
378900200528     C                   PARM                    FRASttmt
379000200528     C                   PARM                    InfData                                      CAP086
379100200528     C                   PARM                    RegData                                      CER001
379200200528     C                   PARM                    ExtData
379300200528     C                   PARM                    FldNameArr
379400200528     C                   PARM                    MsgIDArr
379500200528     C                   PARM                    MsgDtaArr
379600200528     C                   PARM                    WFldNamArr
379700200528     C                   PARM                    WMsgIDArr
379800200528     C                   PARM                    WMsgDtaArr
379900200528     C                   PARM                    MsgFArray
380000200528     C                   PARM                    UpdateYN
380100200528     C                   PARM                    Buffer
380200200528     C                   PARM                    APIRetc
380300200528     C                   PARM                    @TimeStamp                                  BUG4146
380400200528     C                   PARM                    DDFOID                                       239400
380500200528                                                                                              CRE020
380600200528     C                   IF        CRE020 = 'Y'                                               CRE020
380700200528     C                   EVAL      WrkPgm = 'MMNASPUPD'                                       CRE020
380800200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
380900200528     C                   EXSR      SRSndDtaQ                                                  CRE020
381000200528     C                   ENDIF                                                                CRE020
381100200528
381200200528      * MM Negotiable Assets Sold
381300200528
381400200528     C     TransTYPE     WHENEQ    'NASS'
381500200528
381600200528     C                   EXSR      NASSFmts
381700200528     C                   EXSR      SettleFmts
381800200528
381900200528     C     NASSLn        SUBST     BUFFER:Bfp    TRANS1
382000200528     C                   ADD       NASSLn        Bfp
382100200528      **  Restore Timestamp field from the record                                            BUG4146
382200200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4146
382300200528     C                   ADD       26            Bfp                                         BUG4146
382400200528     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
382500200528     C                   ADD       20            Bfp                                          239400
382600200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
382700200528     C                   ADD       ESSRLn        Bfp
382800200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
382900200528     C                   ADD       ESSPLn        Bfp
383000200528     C     NAIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
383100200528     C                   ADD       NAIFLn        Bfp                                          CAP086
383200200528     C     NSEXLn        SUBST     BUFFER:Bfp    ExtData
383300200528
383400200528     C                   CALL      'MMNASSVU'
383500200528      * Common header information (DS) from source system
383600200528     C                   PARM                    HeadIn
383700200528      * Transaction information in a single large field from source system
383800200528     C                   PARM                    Trans1
383900200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
384000200528     C                   PARM                    PaySttmt
384100200528     C                   PARM                    RecSttmt
384200200528     C                   PARM                    FRASttmt
384300200528     C                   PARM                    InfData                                      CAP086
384400200528     C                   PARM                    ExtData
384500200528     C                   PARM                    FldNameArr
384600200528     C                   PARM                    MsgIDArr
384700200528     C                   PARM                    MsgDtaArr
384800200528     C                   PARM                    WFldNamArr
384900200528     C                   PARM                    WMsgIDArr
385000200528     C                   PARM                    WMsgDtaArr
385100200528     C                   PARM                    MsgFArray
385200200528     C                   PARM                    UpdateYN
385300200528     C                   PARM                    Buffer
385400200528     C                   PARM                    APIRetc
385500200528     C                   PARM                    @TimeStamp                                  BUG4146
385600200528     C                   PARM                    DDFOID                                       239400
385700200528                                                                                              CRE020
385800200528     C                   IF        CRE020 = 'Y'                                               CRE020
385900200528     C                   EVAL      WrkPgm = 'MMNASSUPD'                                       CRE020
386000200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
386100200528     C                   EXSR      SRSndDtaQ                                                  CRE020
386200200528     C                   ENDIF                                                                CRE020
386300200528
386400200528      * MM Rollover Deals Maintenance
386500200528
386600200528     C     TransTYPE     WHENEQ    'RODL'
386700200528
386800200528     C                   EXSR      RODLFmts
386900200528     C                   EXSR      SettleFmts
387000200528
387100200528     C*****RODLLn        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
387200200528     C     RODLLn        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
387300200528     C                   ADD       RODLLn        Bfp
387400200528     C*****ROIFLn        SUBST     BUFFER:Bfp    TRANS2                                      CSF011A
387500200528     C**********         ADD       ROIFLn        Bfp                                         CSF011A
387600200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
387700200528     C                   ADD       ESSRLn        Bfp
387800200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
387900200528     C                   ADD       ESSPLn        Bfp
388000200528      ** CER050 Fields                                                                      MD054538
388100200528     C                   ADD       9             Bfp                                        MD054538
388200200528     C     ROEXLn        SUBST     BUFFER:Bfp    ExtData
388300200528
388400200528     C                   CALL      'MMRODLVU'
388500200528      * Common header information (DS) from source system
388600200528     C                   PARM                    HeadIn
388700200528      * Transaction information in a single large field from source system
388800200528     C**********         PARM                    Trans1                                      CSF011A
388900200528     C                   PARM                    Trans1A                                     CSF011A
389000200528     C**********         PARM                    Trans2                                      CSF011A
389100200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
389200200528     C                   PARM                    PaySttmt
389300200528     C                   PARM                    RecSttmt
389400200528     C                   PARM                    FRASttmt
389500200528     C                   PARM                    ExtData
389600200528     C                   PARM                    FldNameArr
389700200528     C                   PARM                    MsgIDArr
389800200528     C                   PARM                    MsgDtaArr
389900200528     C                   PARM                    WFldNamArr
390000200528     C                   PARM                    WMsgIDArr
390100200528     C                   PARM                    WMsgDtaArr
390200200528     C                   PARM                    MsgFArray
390300200528     C                   PARM                    UpdateYN
390400200528     C                   PARM                    Buffer
390500200528     C                   PARM                    APIRetc
390600200528
390700200528      * IR Caps/Collars/Floors
390800200528
390900200528     C     TransTYPE     WHENEQ    'CACF'
391000200528
391100200528     C                   EXSR      CACFFmts
391200200528     C                   EXSR      SettleFmts
391300200528     C                   EXSR      RPIFFmts                                                   CSW213
391400200528
391500200528     C     CACFLn        SUBST     BUFFER:Bfp    TRANS1
391600200528     C                   ADD       CACFLn        Bfp
391700200528     C     CAC2Ln        SUBST     BUFFER:Bfp    TRANS2
391800200528     C                   ADD       CAC2Ln        Bfp
391900200528     C     CFIFLn        SUBST     BUFFER:Bfp    InfData
392000200528     C                   ADD       CFIFLn        Bfp
392100200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
392200200528     C                   ADD       ESSRLn        Bfp
392300200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
392400200528     C                   ADD       ESSPLn        Bfp
392500200528     C     CFEXLn        SUBST     BUFFER:Bfp    ExtData
392600200528     C                   ADD       CFEXLn        Bfp                                          CSW213
392700200528     C                   ADD       61            Bfp                                          CSW213
392800200528     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213
392900200528
393000200528     C                   CALL      'IRCACFVU'
393100200528      * Common header information (DS) from source system
393200200528     C                   PARM                    HeadIn
393300200528      * Transaction information in a single large field from source system
393400200528     C                   PARM                    Trans1
393500200528     C                   PARM                    Trans2
393600200528     C                   PARM                    InfData
393700200528      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
393800200528     C                   PARM                    PaySttmt
393900200528     C                   PARM                    RecSttmt
394000200528     C                   PARM                    FRASttmt
394100200528     C                   PARM                    ExtData
394200200528     C                   PARM                    InSwift2013                                  CSW213
394300200528     C                   PARM                    FldNameArr
394400200528     C                   PARM                    MsgIDArr
394500200528     C                   PARM                    MsgDtaArr
394600200528     C                   PARM                    WFldNamArr
394700200528     C                   PARM                    WMsgIDArr
394800200528     C                   PARM                    WMsgDtaArr
394900200528     C                   PARM                    MsgFArray
395000200528     C                   PARM                    UpdateYN
395100200528     C                   PARM                    Buffer
395200200528     C                   PARM                    Buffer2                                     BUG5403
395300200528     C                   PARM                    BufferEx2                                   BUG5403
395400200528     C                   PARM                    APIRetc
395500200528                                                                                              CRE020
395600200528     C                   IF        CRE020 = 'Y'                                               CRE020
395700200528     C                   EVAL      WrkPgm = 'IRCACFUPD'                                       CRE020
395800200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
395900200528     C                   EXSR      SRSndDtaQ                                                  CRE020
396000200528     C                   ENDIF                                                                CRE020
396100200528
396200200528      ** FX CLS Pay-in Schedule Header
396300200528
396400200528     C     TransTYPE     WHENEQ    'CLSP'
396500200528
396600200528     C                   EXSR      CLSPFmts
396700200528     C     CLSPLn        SUBST     BUFFER:Bfp    TRANS1
396800200528     C                   ADD       CLSPLn        Bfp
396900200528     C     CLIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
397000200528     C                   ADD       CLIFLn        Bfp                                          CAP086
397100200528
397200200528     C                   CALL      'FXCLSPVU'
397300200528     C                   PARM                    HeadIn
397400200528     C                   PARM                    Trans1
397500200528     C                   PARM                    InfData                                      CAP086
397600200528     C                   PARM                    FldNameArr
397700200528     C                   PARM                    MsgIDArr
397800200528     C                   PARM                    MsgDtaArr
397900200528     C                   PARM                    WFldNamArr
398000200528     C                   PARM                    WMsgIDArr
398100200528     C                   PARM                    WMsgDtaArr
398200200528     C                   PARM                    MsgFArray
398300200528     C                   PARM                    UpdateYN
398400200528     C                   PARM                    Buffer
398500200528     C                   PARM                    APIRetc
398600200528
398700200528      ** FX CLS Pay-in Schedule Detail
398800200528
398900200528     C     TransTYPE     WHENEQ    'CLS2'
399000200528
399100200528     C                   EXSR      CLS2Fmts
399200200528     C     CLS2Ln        SUBST     BUFFER:Bfp    TRANS1
399300200528     C                   ADD       CLS2Ln        Bfp
399400200528
399500200528     C                   CALL      'FXCLSPVU2'
399600200528     C                   PARM                    HeadIn
399700200528     C                   PARM                    Trans1
399800200528     C                   PARM                    FldNameArr
399900200528     C                   PARM                    MsgIDArr
400000200528     C                   PARM                    MsgDtaArr
400100200528     C                   PARM                    WFldNamArr
400200200528     C                   PARM                    WMsgIDArr
400300200528     C                   PARM                    WMsgDtaArr
400400200528     C                   PARM                    MsgFArray
400500200528     C                   PARM                    UpdateYN
400600200528     C                   PARM                    Buffer
400700200528     C                   PARM                    APIRetc
400800200528
400900200528      ** Internal Contracts
401000200528
401100200528     C     TransTYPE     WHENEQ    'INTC'
401200200528
401300200528     C                   EXSR      INTCFmts
401400200528
401500200528      ** Need to add 109 chars for the following fields not included on
401600200528      ** Format file ABINTCPD.
401700200528      ** DDLL2RT/DDL2CB/DDL2BA/DDL2CS/DDL2SA/DDLOIA/DDDPIA/DDSTS
401800200528     C                   ADD       109           INTCLn
401900200528     C     INTCLn        SUBST     BUFFER:Bfp    TRANS1
402000200528     C                   ADD       INTCLn        Bfp
402100200528     C     20            SUBST     BUFFER:Bfp    FRNT                                         261962
402200200528     C                   ADD       20            Bfp                                          261962
402300200528     C     20            SUBST     BUFFER:Bfp    AFRT                                         261962
402400200528     C                   ADD       20            Bfp                                          261962
402500200528     C     1             SUBST     BUFFER:Bfp    AAuth             1                        BUG22140
402600200528     C                   ADD       1             Bfp                                        BUG22140
402700200528     C/COPY WNCPYSRC,APH00032
402800200528
402900200528     C                   CALL      'ABINTCVU'
403000200528     C                   PARM                    HeadIn
403100200528     C                   PARM                    Trans1
403200200528     C/COPY WNCPYSRC,APH00033
403300200528     C                   PARM                    FldNameArr
403400200528     C                   PARM                    MsgIDArr
403500200528     C                   PARM                    MsgDtaArr
403600200528     C                   PARM                    WFldNamArr
403700200528     C                   PARM                    WMsgIDArr
403800200528     C                   PARM                    WMsgDtaArr
403900200528     C                   PARM                    MsgFArray
404000200528     C                   PARM                    UpdateYN
404100200528     C                   PARM                    Buffer
404200200528     C                   PARM                    APIRetc
404300200528     C                   PARM                    AAuth                                      BUG22140
404400200528     C                   PARM                    FRNT                                         261962
404500200528     C                   PARM                    AFRT                                         261962
404600200528
404700200528      ** Internal Funding Deals
404800200528
404900200528     C     TransTYPE     WHENEQ    'FUND'
405000200528
405100200528     C                   EXSR      FUNDFmts
405200200528     C     FUNDLn        SUBST     BUFFER:Bfp    TRANS1
405300200528     C                   ADD       FUNDLn        Bfp
405400200528     C                   ADD       7             Bfp                                          CAP191
405500200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP191
405600200528     C                   ADD       26            Bfp                                          CAP191
405700200528     C     FUEXLn        SUBST     BUFFER:Bfp    ExtData                                      CAP191
405800200528     C                   ADD       FUEXLn        Bfp                                          CAP191
405900200528     C     1             SUBST     BUFFER:Bfp    AAUTH                                        CAP191
406000200528     C                   ADD       1             Bfp                                          CAP191
406100200528     C     20            SUBST     BUFFER:Bfp    FRNT                                         261140
406200200528     C                   ADD       20            Bfp                                          261140
406300200528     C     20            SUBST     BUFFER:Bfp    AFRT                                         261140
406400200528     C                   ADD       20            Bfp                                          261140
406500200528
406600200528     C                   CALL      'ABFUNDVU'
406700200528     C                   PARM                    HeadIn
406800200528     C                   PARM                    Trans1
406900200528     C                   PARM                    ExtData                                      CAP191
407000200528     C                   PARM                    FldNameArr
407100200528     C                   PARM                    MsgIDArr
407200200528     C                   PARM                    MsgDtaArr
407300200528     C                   PARM                    WFldNamArr
407400200528     C                   PARM                    WMsgIDArr
407500200528     C                   PARM                    WMsgDtaArr
407600200528     C                   PARM                    MsgFArray
407700200528     C                   PARM                    UpdateYN
407800200528     C                   PARM                    Buffer
407900200528     C                   PARM                    APIRetc
408000200528     C                   PARM                    @TimeStamp                                   CAP191
408100200528     C                   PARM                    AAUTH                                        CAP191
408200200528     C                   PARM                    FRNT                                         261140
408300200528     C                   PARM                    AFRT                                         261140
408400200528
408500200528      ** Spot Rates
408600200528
408700200528     C     TransTYPE     WHENEQ    'SPTR'
408800200528
408900200528     C                   EXSR      SPTRFmts
409000200528     C     SPTRLn        SUBST     BUFFER:Bfp    TRANS1
409100200528     C                   ADD       SPTRLn        Bfp
409200200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
409300200528     C                   ADD       26            Bfp                                         BUG4469
409400200528     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
409500200528     C                   ADD       1             Bfp                                        BUG22140
409600200528
409700200528     C                   CALL      'SDSPTRVU'
409800200528     C                   PARM                    HeadIn
409900200528     C                   PARM                    Trans1
410000200528     C                   PARM                    FldNameArr
410100200528     C                   PARM                    MsgIDArr
410200200528     C                   PARM                    MsgDtaArr
410300200528     C                   PARM                    WFldNamArr
410400200528     C                   PARM                    WMsgIDArr
410500200528     C                   PARM                    WMsgDtaArr
410600200528     C                   PARM                    MsgFArray
410700200528     C                   PARM                    UpdateYN
410800200528     C                   PARM                    Buffer
410900200528     C                   PARM                    APIRetc
411000200528     C                   PARM                    @TimeStamp                                  BUG4469
411100200528     C                   PARM                    AAuth                                      BUG22140
411200200528
411300200528      * MM Interest Rates
411400200528     C     TransTYPE     WHENEQ    'INTR'
411500200528
411600200528     C                   EXSR      INTRFmts
411700200528
411800200528     C     INT1Ln        SUBST     BUFFER:Bfp    TRANS1
411900200528     C                   ADD       INT1Ln        Bfp
412000200528     C     INT2Ln        SUBST     BUFFER:Bfp    TRANS2
412100200528     C                   ADD       INT2Ln        Bfp
412200200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
412300200528     C                   ADD       26            Bfp                                         BUG4469
412400200528     C     INEXLn        SUBST     BUFFER:Bfp    ExtData
412500200528
412600200528     C                   CALL      'FDINTRVU'
412700200528
412800200528      * Common header information (DS) from source system
412900200528     C                   PARM                    HeadIn
413000200528
413100200528      * Transaction information
413200200528     C                   PARM                    TRANS1
413300200528     C                   PARM                    TRANS2
413400200528     C                   PARM                    ExtData
413500200528     C                   PARM                    FldNameArr
413600200528     C                   PARM                    MsgIDArr
413700200528     C                   PARM                    MsgDtaArr
413800200528     C                   PARM                    WFldNamArr
413900200528     C                   PARM                    WMsgIDArr
414000200528     C                   PARM                    WMsgDtaArr
414100200528     C                   PARM                    MsgFArray
414200200528     C                   PARM                    UpdateYN
414300200528     C                   PARM                    Buffer
414400200528     C                   PARM                    APIRetc
414500200528     C                   PARM                    @TimeStamp                                  BUG4469
414600200528
414700200528
414800200528      * SE Security Diary Events
414900200528     C     TransTYPE     WHENEQ    'SEDE'
415000200528
415100200528     C                   EXSR      SEDEFmts
415200200528
415300200528     C     SEDELn        SUBST     BUFFER:Bfp    TRANS1
415400200528     C                   ADD       SEDELn        Bfp
415500200528      **  Restore Timestamp field from the record                                            BUG4258
415600200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
415700200528     C                   ADD       26            Bfp                                         BUG4258
415800200528     C     SDEXLn        SUBST     BUFFER:Bfp    ExtData
415900200528
416000200528     C                   CALL      'SESEDEVU'
416100200528
416200200528      * Common header information (DS) from source system
416300200528     C                   PARM                    HeadIn
416400200528
416500200528      * Transaction information
416600200528     C                   PARM                    TRANS1
416700200528     C                   PARM                    ExtData
416800200528     C                   PARM                    FldNameArr
416900200528     C                   PARM                    MsgIDArr
417000200528     C                   PARM                    MsgDtaArr
417100200528     C                   PARM                    WFldNamArr
417200200528     C                   PARM                    WMsgIDArr
417300200528     C                   PARM                    WMsgDtaArr
417400200528     C                   PARM                    MsgFArray
417500200528     C                   PARM                    UpdateYN
417600200528     C                   PARM                    Buffer
417700200528     C                   PARM                    APIRetc
417800200528     C                   PARM                    @TimeStamp                                  BUG4258
417900200528
418000200528
418100200528      * SE Prices Input
418200200528     C     TransTYPE     WHENEQ    'PRCS'
418300200528
418400200528     C                   EXSR      PRCSFmts
418500200528
418600200528     C     PRCSLn        SUBST     BUFFER:Bfp    TRANS1
418700200528     C                   ADD       PRCSLn        Bfp
418800200528      **  Restore Timestamp field from the record                                            BUG4258
418900200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
419000200528     C                   ADD       26            Bfp                                         BUG4258
419100200528     C     PRCXLn        SUBST     BUFFER:Bfp    ExtData
419200200528     C                   ADD       PRCXLn        Bfp                                        BUG22140
419300200528     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
419400200528     C                   ADD       1             Bfp                                        BUG22140
419500200528
419600200528     C                   CALL      'SEPRCSVU'
419700200528
419800200528      * Common header information (DS) from source system
419900200528     C                   PARM                    HeadIn
420000200528
420100200528      * Transaction information
420200200528     C                   PARM                    TRANS1
420300200528     C                   PARM                    ExtData
420400200528     C                   PARM                    FldNameArr
420500200528     C                   PARM                    MsgIDArr
420600200528     C                   PARM                    MsgDtaArr
420700200528     C                   PARM                    WFldNamArr
420800200528     C                   PARM                    WMsgIDArr
420900200528     C                   PARM                    WMsgDtaArr
421000200528     C                   PARM                    MsgFArray
421100200528     C                   PARM                    UpdateYN
421200200528     C                   PARM                    Buffer
421300200528     C                   PARM                    APIRetc
421400200528     C                   PARM                    @TimeStamp                                  BUG4258
421500200528     C                   PARM                    AAuth                                      BUG22140
421600200528
421700200528      * FD Forward rates
421800200528
421900200528     C     TransTYPE     WHENEQ    'FWRT'
422000200528
422100200528     C                   EXSR      FWRTFmts
422200200528
422300200528     C     FWR1Ln        SUBST     BUFFER:Bfp    TRANS1
422400200528     C                   ADD       FWR1Ln        Bfp
422500200528     C     FWR2Ln        SUBST     BUFFER:Bfp    TRANS2
422600200528     C                   ADD       FWR2Ln        Bfp
422700200528     C     FWEXLn        SUBST     BUFFER:Bfp    ExtData
422800200528
422900200528     C                   CALL      'FDFWRTVU'
423000200528
423100200528      * Common header information (DS) from source system
423200200528     C                   PARM                    HeadIn
423300200528      * Transaction information
423400200528     C                   PARM                    Trans1
423500200528     C                   PARM                    Trans2
423600200528     C                   PARM                    ExtData
423700200528     C                   PARM                    FldNameArr
423800200528     C                   PARM                    MsgIDArr
423900200528     C                   PARM                    MsgDtaArr
424000200528     C                   PARM                    WFldNamArr
424100200528     C                   PARM                    WMsgIDArr
424200200528     C                   PARM                    WMsgDtaArr
424300200528     C                   PARM                    MsgFArray
424400200528     C                   PARM                    UpdateYN
424500200528     C                   PARM                    Buffer
424600200528     C                   PARM                    APIRetc
424700200528                                                                                             CGP010
424800200528      * Global BSPL Requests                                                                 CGP010
424900200528     C     TransTYPE     WHENEQ    'BSRQ'                                                    CGP010
425000200528                                                                                             CGP010
425100200528     C                   EXSR      BSRQFmts                                                  CGP010
425200200528                                                                                             CGP010
425300200528     C     BSRQLn        SUBST     BUFFER:Bfp    TRANS1                                      CGP010
425400200528     C                   ADD       BSRQLn        Bfp                                         CGP010
425500200528     C     BSRXLn        SUBST     BUFFER:Bfp    ExtData                                     CGP010
425600200528                                                                                             CGP010
425700200528     C                   CALL      'GOBSRQVU'                                                CGP010
425800200528                                                                                             CGP010
425900200528      * Common header information (DS) from source system                                    CGP010
426000200528     C                   PARM                    HeadIn                                      CGP010
426100200528                                                                                             CGP010
426200200528      * Transaction information                                                              CGP010
426300200528     C                   PARM                    TRANS1                                      CGP010
426400200528     C                   PARM                    FldNameArr                                  CGP010
426500200528     C                   PARM                    MsgIDArr                                    CGP010
426600200528     C                   PARM                    MsgDtaArr                                   CGP010
426700200528     C                   PARM                    WFldNamArr                                  CGP010
426800200528     C                   PARM                    WMsgIDArr                                   CGP010
426900200528     C                   PARM                    WMsgDtaArr                                  CGP010
427000200528     C                   PARM                    MsgFArray                                   CGP010
427100200528     C                   PARM                    UpdateYN                                    CGP010
427200200528     C                   PARM                    Buffer                                      CGP010
427300200528     C                   PARM                    APIRetc                                     CGP010
427400200528
427500200528      * Settlement Module                                                                     CLE106
427600200528                                                                                              CLE106
427700200528     C     TransTYPE     WHENEQ    'SETL'                                                     CLE106
427800200528                                                                                              CLE106
427900200528     C                   EXSR      SETLFmts                                                   CLE106
428000200528                                                                                              CLE106
428100200528     C     SET1Ln        SUBST     BUFFER:Bfp    Trans1                                       CLE106
428200200528     C                   ADD       SET1Ln        Bfp                                          CLE106
428300200528     C     SET2Ln        SUBST     BUFFER:Bfp    RecSttmt                                     CLE106
428400200528     C                   ADD       SET2Ln        Bfp                                          CLE106
428500200528     C     SET3Ln        SUBST     BUFFER:Bfp    PaySttmt                                     CLE106
428600200528     C                   ADD       SET3Ln        Bfp                                          CLE106
428700200528                                                                                              CLE106
428800200528     C                   CALL      'SDSETLVU'                                                 CLE106
428900200528      * Common header information (DS) from source system                                     CLE106
429000200528     C                   PARM                    HeadIn                                       CLE106
429100200528      * Transaction information in a single large field from source system                    CLE106
429200200528     C                   PARM                    Trans1                                       CLE106
429300200528      * Transaction information in a single large field from source system                    CLE106
429400200528     C                   PARM                    RecSttmt                                     CLE106
429500200528      * Transaction information in a single large field from source system                    CLE106
429600200528     C                   PARM                    PaySttmt                                     CLE106
429700200528     C                   PARM                    FldNameArr                                   CLE106
429800200528     C                   PARM                    MsgIDArr                                     CLE106
429900200528     C                   PARM                    MsgDtaArr                                    CLE106
430000200528     C                   PARM                    WFldNamArr                                   CLE106
430100200528     C                   PARM                    WMsgIDArr                                    CLE106
430200200528     C                   PARM                    WMsgDtaArr                                   CLE106
430300200528     C                   PARM                    MsgFArray                                    CLE106
430400200528     C                   PARM                    UpdateYN                                     CLE106
430500200528     C                   PARM                    Buffer                                       CLE106
430600200528     C                   PARM                    APIRetc                                      CLE106
430700200528      * Function to drop column from UDF Extension table                                     BUG5728
430800200528     C     TransTYPE     WHENEQ    'COLD'                                                    BUG5728
430900200528                                                                                             BUG5728
431000200528     C     4             SUBST     BUFFER:Bfp    ApiName                                     BUG5728
431100200528     C                   ADD       4             Bfp                                         BUG5728
431200200528     C     10            SUBST     BUFFER:Bfp    DropCol                                     BUG5728
431300200528                                                                                             BUG5728
431400200528     C                   CALL      'GPCDROPCOL'                                              BUG5728
431500200528     C                   PARM                    ApiName           4                         BUG5728
431600200528     C                   PARM                    DropCol          10                         BUG5728
431700200528     C                   PARM                    MsgArrOUT                                   BUG5728
431800200528     C                   PARM                    APIRetc                                     BUG5728
431900200528      ** DL Dealing Fees                                                                      CAS011
432000200528     C     TransTYPE     WHENEQ    'DLFE'                                                     CAS011
432100200528                                                                                              CAS011
432200200528     C                   EXSR      DLFEFmts                                                   CAS011
432300200528     C                   EXSR      SettleFmts                                                 CAS011
432400200528                                                                                              CAS011
432500200528     C     DLFELn        SUBST     BUFFER:Bfp    TRANS1                                       CAS011
432600200528     C                   ADD       DLFELn        Bfp                                          CAS011
432700200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAS011
432800200528     C                   ADD       ESSRLn        Bfp                                          CAS011
432900200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAS011
433000200528     C                   ADD       ESSPLn        Bfp                                          CAS011
433100200528                                                                                              CAS011
433200200528     C                   CALL      'DLDLFEVU'                                                 CAS011
433300200528                                                                                              CAS011
433400200528      ** Common header information (DS) from source system                                    CAS011
433500200528     C                   PARM                    HeadIn                                       CAS011
433600200528                                                                                              CAS011
433700200528      ** Transaction information                                                              CAS011
433800200528     C                   PARM                    TRANS1                                       CAS011
433900200528     C                   PARM                    PaySttmt                                     CAS011
434000200528     C                   PARM                    RecSttmt                                     CAS011
434100200528     C                   PARM                    FldNameArr                                   CAS011
434200200528     C                   PARM                    MsgIDArr                                     CAS011
434300200528     C                   PARM                    MsgDtaArr                                    CAS011
434400200528     C                   PARM                    WFldNamArr                                   CAS011
434500200528     C                   PARM                    WMsgIDArr                                    CAS011
434600200528     C                   PARM                    WMsgDtaArr                                   CAS011
434700200528     C                   PARM                    MsgFArray                                    CAS011
434800200528     C                   PARM                    UpdateYN                                     CAS011
434900200528     C                   PARM                    Buffer                                       CAS011
435000200528     C                   PARM                    APIRetc                                      CAS011
435100200528                                                                                             BUG6417
435200200528      * Cash Management Hierarchy Validation                                                 BUG6417
435300200528                                                                                             BUG6417
435400200528     C     TransTYPE     WHENEQ    'HIER'                                                    BUG6417
435500200528                                                                                             BUG6417
435600200528     C     9             SUBST     BUFFER:1      Hierarchy         9                         BUG6417
435700200528     C                   MOVE      *BLANKS       ZFIELD                                      BUG6417
435800200528     C                   MOVEL     Hierarchy     ZFIELD                                      BUG6417
435900200528     C                   CALLB     'ZALIGN'                                                  BUG6417
436000200528     C                   PARM                    ZALIGNok          1                         BUG6417
436100200528     C                   PARM                    ZFIELD           16                         BUG6417
436200200528     C                   PARM      0             ZADEC             1 0                       BUG6417
436300200528     C                   PARM      9             ZADIG             2 0                       BUG6417
436400200528     C                   MOVE      ZFIELD        HierarchyID       9 0                       BUG6417
436500200528     C     2             SUBST     BUFFER:10     HierarchyType     2                         BUG6417
436600200528                                                                                             BUG6417
436700200528     C                   CALL      'REC100411'                                               BUG6417
436800200528     C                   PARM                    HierarchyID                                 BUG6417
436900200528     C                   PARM                    HierarchyType                               BUG6417
437000200528     C                   PARM                    FldNameArr                                  BUG6417
437100200528     C                   PARM                    MsgIDArr                                    BUG6417
437200200528     C                   PARM                    MsgDtaArr                                   BUG6417
437300200528     C                   PARM                    MsgFArray                                   BUG6417
437400200528     C                   PARM                    ErrorInd          1                         BUG6417
437500200528                                                                                             BUG6417
437600200528      *                                                                                       CRE026
437700200528      ** Collateral Type Details Validation                                                   CRE026
437800200528      *                                                                                       CRE026
437900200528     C     TransTYPE     WHENEQ    'COTY'                                                     CRE026
438000200528                                                                                              CRE026
438100200528     C                   EXSR      COTYFmts                                                   CRE026
438200200528                                                                                              CRE026
438300200528     C     COTYLn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
438400200528     C                   ADD       COTYLn        Bfp                                          CRE026
438500200528      *                                                                                       CRE026
438600200528      ** Restore Timestamp field from the record                                              CRE026
438700200528      *                                                                                       CRE026
438800200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
438900200528     C                   ADD       26            Bfp                                          CRE026
439000200528     C     SDCXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
439100200528                                                                                              CRE026
439200200528     C                   CALL      'SDCOTYVU'                                                 CRE026
439300200528      *                                                                                       CRE026
439400200528      ** Common header information (DS) from source system                                    CRE026
439500200528      *                                                                                       CRE026
439600200528     C                   PARM                    HeadIn                                       CRE026
439700200528      *                                                                                       CRE026
439800200528      ** Transaction information in a single large field from source system                   CRE026
439900200528      *                                                                                       CRE026
440000200528     C                   PARM                    Trans1                                       CRE026
440100200528                                                                                              CRE026
440200200528     C                   PARM                    ExtData                                      CRE026
440300200528     C                   PARM                    FldNameArr                                   CRE026
440400200528     C                   PARM                    MsgIDArr                                     CRE026
440500200528     C                   PARM                    MsgDtaArr                                    CRE026
440600200528     C                   PARM                    WFldNamArr                                   CRE026
440700200528     C                   PARM                    WMsgIDArr                                    CRE026
440800200528     C                   PARM                    WMsgDtaArr                                   CRE026
440900200528     C                   PARM                    MsgFArray                                    CRE026
441000200528     C                   PARM                    UpdateYN                                     CRE026
441100200528     C                   PARM                    Buffer                                       CRE026
441200200528     C                   PARM                    APIRetc                                      CRE026
441300200528     C                   PARM                    @TimeStamp                                   CRE026
441400200528      *                                                                                       CRE026
441500200528      ** Country Details Validation                                                           CRE026
441600200528      *                                                                                       CRE026
441700200528     C     TransTYPE     WHENEQ    'CNTY'                                                     CRE026
441800200528                                                                                              CRE026
441900200528     C                   EXSR      CNTYFmts                                                   CRE026
442000200528                                                                                              CRE026
442100200528     C     CNTYLn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
442200200528     C                   ADD       CNTYLn        Bfp                                          CRE026
442300200528                                                                                              CRE026
442400200528     C     CTX1Ln        SUBST     BUFFER:Bfp    BCLData                                      CRE026
442500200528     C                   ADD       CTX1Ln        Bfp                                          CRE026
442600200528                                                                                              CRE026
442700200528     C     CTX2Ln        SUBST     BUFFER:Bfp    EurRepData                                   CRE026
442800200528     C                   ADD       CTX2Ln        Bfp                                          CRE026
442900200528      *                                                                                       CRE026
443000200528      ** Restore Timestamp field from the record                                              CRE026
443100200528      *                                                                                       CRE026
443200200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
443300200528     C                   ADD       26            Bfp                                          CRE026
443400200528     C     SDCXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
443500200528                                                                                              CRE026
443600200528     C                   CALL      'SDCNTYVU'                                                 CRE026
443700200528      *                                                                                       CRE026
443800200528      ** Common header information (DS) from source system                                    CRE026
443900200528      *                                                                                       CRE026
444000200528     C                   PARM                    HeadIn                                       CRE026
444100200528      *                                                                                       CRE026
444200200528      ** Transaction information in a single large field from source system                   CRE026
444300200528      *                                                                                       CRE026
444400200528     C                   PARM                    Trans1                                       CRE026
444500200528     C                   PARM                    BCLData                                      CRE026
444600200528     C                   PARM                    EurRepData                                   CRE026
444700200528                                                                                              CRE026
444800200528     C                   PARM                    ExtData                                      CRE026
444900200528     C                   PARM                    FldNameArr                                   CRE026
445000200528     C                   PARM                    MsgIDArr                                     CRE026
445100200528     C                   PARM                    MsgDtaArr                                    CRE026
445200200528     C                   PARM                    WFldNamArr                                   CRE026
445300200528     C                   PARM                    WMsgIDArr                                    CRE026
445400200528     C                   PARM                    WMsgDtaArr                                   CRE026
445500200528     C                   PARM                    MsgFArray                                    CRE026
445600200528     C                   PARM                    UpdateYN                                     CRE026
445700200528     C                   PARM                    Buffer                                       CRE026
445800200528     C                   PARM                    APIRetc                                      CRE026
445900200528     C                   PARM                    @TimeStamp                                   CRE026
446000200528      *                                                                                       CRE026
446100200528      ** Alternative Name and Addresses Validation                                            CRE026
446200200528      *                                                                                       CRE026
446300200528     C     TransTYPE     WHENEQ    'ALNA'                                                     CRE026
446400200528     C     TransTYPE     OREQ      'ALNU'                                                     CRE026
446500200528                                                                                              CRE026
446600200528     C                   EXSR      ALNAFmts                                                   CRE026
446700200528     C     ALNALn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
446800200528     C                   ADD       ALNALn        Bfp                                          CRE026
446900200528      *                                                                                       CRE026
447000200528      ** Restore Timestamp field from the record                                              CRE026
447100200528      *                                                                                       CRE026
447200200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
447300200528     C                   ADD       26            Bfp                                          CRE026
447400200528     C     SDAXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
447500200528     C                   ADD       SDAXLn        Bfp                                        BUG22140
447600200528     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
447700200528     C                   ADD       1             Bfp                                        BUG22140
447800200528                                                                                              CRE026
447900200528     C                   CALL      'SDALNAVU'                                                 CRE026
448000200528      *                                                                                       CRE026
448100200528      ** Common header information (DS) from source system                                    CRE026
448200200528      *                                                                                       CRE026
448300200528     C                   PARM                    HeadIn                                       CRE026
448400200528      *                                                                                       CRE026
448500200528      ** Transaction information in a single large field from source system                   CRE026
448600200528      *                                                                                       CRE026
448700200528     C                   PARM                    Trans1                                       CRE026
448800200528                                                                                              CRE026
448900200528     C                   PARM                    ExtData                                      CRE026
449000200528     C                   PARM                    FldNameArr                                   CRE026
449100200528     C                   PARM                    MsgIDArr                                     CRE026
449200200528     C                   PARM                    MsgDtaArr                                    CRE026
449300200528     C                   PARM                    WFldNamArr                                   CRE026
449400200528     C                   PARM                    WMsgIDArr                                    CRE026
449500200528     C                   PARM                    WMsgDtaArr                                   CRE026
449600200528     C                   PARM                    MsgFArray                                    CRE026
449700200528     C                   PARM                    UpdateYN                                     CRE026
449800200528     C                   PARM                    Buffer                                       CRE026
449900200528     C                   PARM                    APIRetc                                      CRE026
450000200528     C                   PARM                    @TimeStamp                                   CRE026
450100200528     C                   PARM                    AAuth                                      BUG22140
450200200528      *                                                                                       CRE026
450300200528      ** User Definitions + Menu Items Details Validation                                     CRE026
450400200528      *                                                                                       CRE026
450500200528     C     TransTYPE     WHENEQ    'AMUS'                                                     CRE026
450600200528                                                                                              CRE026
450700200528     C                   EXSR      AMUSFmts                                                   CRE026
450800200528                                                                                              CRE026
450900200528     C                   EVAL      TRANS1 = %SUBST(BUFFERTOTAL:Bfp:AMUSLn)                    CRE026
451000200528     C                   ADD       AMUSLn        Bfp                                          CRE026
451100200528     C                   EVAL      TRANS2 = %SUBST(BUFFERTOTAL:Bfp:BBR1Ln)                    CRE026
451200200528     C                   ADD       BBR1Ln        Bfp                                          CRE026
451300200528     C                   EVAL      TRANS3 = %SUBST(BUFFERTOTAL:Bfp:BBR2Ln)                    CRE026
451400200528     C                   ADD       BBR2Ln        Bfp                                          CRE026
451500200528     C                   EVAL      TRANS4 = %SUBST(BUFFERTOTAL:Bfp:BBR3Ln)                    CRE026
451600200528     C                   ADD       BBR3Ln        Bfp                                          CRE026
451700200528     C                   EVAL      TRANS5 = %SUBST(BUFFERTOTAL:Bfp:BBR4Ln)                    CRE026
451800200528     C                   ADD       BBR4Ln        Bfp                                          CRE026
451900200528     C                   EVAL      TRANS6 = %SUBST(BUFFERTOTAL:Bfp:BBR5Ln)                    CRE026
452000200528     C                   ADD       BBR5Ln        Bfp                                          CRE026
452100200528     C                   EVAL      TRANS7 = %SUBST(BUFFERTOTAL:Bfp:BBR6Ln)                    CRE026
452200200528     C                   ADD       BBR6Ln        Bfp                                          CRE026
452300200528     C                   EVAL      TRANS8 = %SUBST(BUFFERTOTAL:Bfp:BBR7Ln)                    CRE026
452400200528     C                   ADD       BBR7Ln        Bfp                                          CRE026
452500200528     C                   EVAL      TRANS9 = %SUBST(BUFFERTOTAL:Bfp:BBR8Ln)                    CRE026
452600200528     C                   ADD       BBR8Ln        Bfp                                          CRE026
452700200528     C                   EVAL      TRANS10 = %SUBST(BUFFERTOTAL:Bfp:OBR1Ln)                   CRE026
452800200528     C                   ADD       OBR1Ln        Bfp                                          CRE026
452900200528     C                   EVAL      TRANS11 = %SUBST(BUFFERTOTAL:Bfp:OBR2Ln)                   CRE026
453000200528     C                   ADD       OBR2Ln        Bfp                                          CRE026
453100200528     C                   EVAL      TRANS12 = %SUBST(BUFFERTOTAL:Bfp:OBR3Ln)                   CRE026
453200200528     C                   ADD       OBR3Ln        Bfp                                          CRE026
453300200528     C                   EVAL      TRANS13 = %SUBST(BUFFERTOTAL:Bfp:OBR4Ln)                   CRE026
453400200528     C                   ADD       OBR4Ln        Bfp                                          CRE026
453500200528     C                   EVAL      TRANS14 = %SUBST(BUFFERTOTAL:Bfp:OBR5Ln)                   CRE026
453600200528     C                   ADD       OBR5Ln        Bfp                                          CRE026
453700200528     C                   EVAL      TRANS15 = %SUBST(BUFFERTOTAL:Bfp:OBR6Ln)                   CRE026
453800200528     C                   ADD       OBR6Ln        Bfp                                          CRE026
453900200528     C                   EVAL      TRANS16 = %SUBST(BUFFERTOTAL:Bfp:OBR7Ln)                   CRE026
454000200528     C                   ADD       OBR7Ln        Bfp                                          CRE026
454100200528     C                   EVAL      TRANS17 = %SUBST(BUFFERTOTAL:Bfp:OBR8Ln)                   CRE026
454200200528     C                   ADD       OBR8Ln        Bfp                                          CRE026
454300200528     C                   EVAL      TRANS18 = %SUBST(BUFFERTOTAL:Bfp:COMPLn)                   CRE026
454400200528     C                   ADD       COMPLn        Bfp                                          CRE026
454500200528      *                                                                                       CRE026
454600200528      ** Restore Timestamp field from the record                                              CRE026
454700200528      *                                                                                       CRE026
454800200528     C                   EVAL      @TimeStamp = %SUBST(BUFFERTOTAL:Bfp:26)                    CRE026
454900200528     C                   ADD       26            Bfp                                          CRE026
455000200528     C                   EVAL      ExtData = %SUBST(BUFFERTOTAL:Bfp:SFUXLn)                   CRE026
455100200528                                                                                              CRE026
455200200528     C                   CALL      'SFAMUSVU'                                                 CRE026
455300200528      *                                                                                       CRE026
455400200528      ** Common header information (DS) from source system                                    CRE026
455500200528      *                                                                                       CRE026
455600200528     C                   PARM                    HeadIn                                       CRE026
455700200528      *                                                                                       CRE026
455800200528      ** Transaction information in a single large field from source system                   CRE026
455900200528      *                                                                                       CRE026
456000200528     C                   PARM                    Trans1                                       CRE026
456100200528     C                   PARM                    Trans2                                       CRE026
456200200528     C                   PARM                    Trans3                                       CRE026
456300200528     C                   PARM                    Trans4                                       CRE026
456400200528     C                   PARM                    Trans5                                       CRE026
456500200528     C                   PARM                    Trans6                                       CRE026
456600200528     C                   PARM                    Trans7                                       CRE026
456700200528     C                   PARM                    Trans8                                       CRE026
456800200528     C                   PARM                    Trans9                                       CRE026
456900200528     C                   PARM                    Trans10                                      CRE026
457000200528     C                   PARM                    Trans11                                      CRE026
457100200528     C                   PARM                    Trans12                                      CRE026
457200200528     C                   PARM                    Trans13                                      CRE026
457300200528     C                   PARM                    Trans14                                      CRE026
457400200528     C                   PARM                    Trans15                                      CRE026
457500200528     C                   PARM                    Trans16                                      CRE026
457600200528     C                   PARM                    Trans17                                      CRE026
457700200528     C                   PARM                    Trans18                                      CRE026
457800200528                                                                                              CRE026
457900200528     C                   PARM                    ExtData                                      CRE026
458000200528     C                   PARM                    FldNameArr                                   CRE026
458100200528     C                   PARM                    MsgIDArr                                     CRE026
458200200528     C                   PARM                    MsgDtaArr                                    CRE026
458300200528     C                   PARM                    WFldNamArr                                   CRE026
458400200528     C                   PARM                    WMsgIDArr                                    CRE026
458500200528     C                   PARM                    WMsgDtaArr                                   CRE026
458600200528     C                   PARM                    MsgFArray                                    CRE026
458700200528     C                   PARM                    UpdateYN                                     CRE026
458800200528     C                   PARM                    Buffer                                       CRE026
458900200528     C                   PARM                    Buffer2                                      CRE026
459000200528     C                   PARM                    APIRetc                                      CRE026
459100200528     C                   PARM                    @TimeStamp                                   CRE026
459200200528      *                                                                                       CRE026
459300200528      ** Nostro Codes Detail Validation                                                       CRE026
459400200528      *                                                                                       CRE026
459500200528     C     TransTYPE     WHENEQ    'NOSR'                                                     CRE026
459600200528     C     TransTYPE     OREQ      'NOSU'                                                     CRE026
459700200528                                                                                              CRE026
459800200528     C                   EXSR      NOSRFmts                                                   CRE026
459900200528                                                                                              CRE026
460000200528     C     NOSRLn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
460100200528     C                   ADD       NOSRLn        Bfp                                          CRE026
460200200528      *                                                                                       CRE026
460300200528      ** Restore Timestamp field from the record                                              CRE026
460400200528      *                                                                                       CRE026
460500200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
460600200528     C                   ADD       26            Bfp                                          CRE026
460700200528     C     SDNXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
460800200528                                                                                              CRE026
460900200528     C                   CALL      'SDNOSRVU'                                                 CRE026
461000200528      *                                                                                       CRE026
461100200528      ** Common header information (DS) from source system                                    CRE026
461200200528      *                                                                                       CRE026
461300200528     C                   PARM                    HeadIn                                       CRE026
461400200528      *                                                                                       CRE026
461500200528      ** Transaction information in a single large field from source system                   CRE026
461600200528      *                                                                                       CRE026
461700200528     C                   PARM                    Trans1                                       CRE026
461800200528                                                                                              CRE026
461900200528     C                   PARM                    ExtData                                      CRE026
462000200528     C                   PARM                    FldNameArr                                   CRE026
462100200528     C                   PARM                    MsgIDArr                                     CRE026
462200200528     C                   PARM                    MsgDtaArr                                    CRE026
462300200528     C                   PARM                    WFldNamArr                                   CRE026
462400200528     C                   PARM                    WMsgIDArr                                    CRE026
462500200528     C                   PARM                    WMsgDtaArr                                   CRE026
462600200528     C                   PARM                    MsgFArray                                    CRE026
462700200528     C                   PARM                    UpdateYN                                     CRE026
462800200528     C                   PARM                    Buffer                                       CRE026
462900200528     C                   PARM                    APIRetc                                      CRE026
463000200528     C                   PARM                    @TimeStamp                                   CRE026
463100200528      *                                                                                       CRE026
463200200528      ** Yield Curve Detail Validation                                                        CRE026
463300200528      *                                                                                       CRE026
463400200528     C     TransTYPE     WHENEQ    'YLCU'                                                     CRE026
463500200528                                                                                              CRE026
463600200528     C                   EXSR      YLCUFmts                                                   CRE026
463700200528                                                                                              CRE026
463800200528     C     YLCULn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
463900200528     C                   ADD       YLCULn        Bfp                                          CRE026
464000200528      *                                                                                       CRE026
464100200528      ** Restore Timestamp field from the record                                              CRE026
464200200528      *                                                                                       CRE026
464300200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
464400200528     C                   ADD       26            Bfp                                          CRE026
464500200528     C     SDYXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
464600200528                                                                                              CRE026
464700200528     C                   CALL      'SDYLCUVU'                                                 CRE026
464800200528      *                                                                                       CRE026
464900200528      ** Common header information (DS) from source system                                    CRE026
465000200528      *                                                                                       CRE026
465100200528     C                   PARM                    HeadIn                                       CRE026
465200200528      *                                                                                       CRE026
465300200528      ** Transaction information in a single large field from source system                   CRE026
465400200528      *                                                                                       CRE026
465500200528     C                   PARM                    Trans1                                       CRE026
465600200528                                                                                              CRE026
465700200528     C                   PARM                    ExtData                                      CRE026
465800200528     C                   PARM                    FldNameArr                                   CRE026
465900200528     C                   PARM                    MsgIDArr                                     CRE026
466000200528     C                   PARM                    MsgDtaArr                                    CRE026
466100200528     C                   PARM                    WFldNamArr                                   CRE026
466200200528     C                   PARM                    WMsgIDArr                                    CRE026
466300200528     C                   PARM                    WMsgDtaArr                                   CRE026
466400200528     C                   PARM                    MsgFArray                                    CRE026
466500200528     C                   PARM                    UpdateYN                                     CRE026
466600200528     C                   PARM                    Buffer                                       CRE026
466700200528     C                   PARM                    APIRetc                                      CRE026
466800200528     C                   PARM                    @TimeStamp                                   CRE026
466900200528      *                                                                                       CRE026
467000200528      ** Yield Rates Detail Validation                                                        CRE026
467100200528      *                                                                                       CRE026
467200200528     C     TransTYPE     WHENEQ    'YRAT'                                                     CRE026
467300200528                                                                                              CRE026
467400200528     C                   EXSR      YRATFmts                                                   CRE026
467500200528      *                                                                                       CRE026
467600200528      ** Restore Timestamp field from the record                                              CRE026
467700200528      *                                                                                       CRE026
467800200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
467900200528     C                   ADD       26            Bfp                                          CRE026
468000200528     C     YRA1Ln        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
468100200528     C                   ADD       YRA1Ln        Bfp                                          CRE026
468200200528     C     YRA2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CRE026
468300200528     C                   ADD       YRA2Ln        Bfp                                          CRE026
468400200528     C     YRA3Ln        SUBST     BUFFER:Bfp    TRANS3                                       CRE026
468500200528     C                   ADD       YRA3Ln        Bfp                                          CRE026
468600200528     C     YRA4Ln        SUBST     BUFFER:Bfp    TRANS4                                       CRE026
468700200528     C                   ADD       YRA4Ln        Bfp                                          CRE026
468800200528     C     SDYELn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
468900200528                                                                                              CRE026
469000200528     C                   CALL      'SDYRATVU'                                                 CRE026
469100200528      *                                                                                       CRE026
469200200528      ** Common header information (DS) from source system                                    CRE026
469300200528      *                                                                                       CRE026
469400200528     C                   PARM                    HeadIn                                       CRE026
469500200528      *                                                                                       CRE026
469600200528      ** Transaction information in a single large field from source system                   CRE026
469700200528      *                                                                                       CRE026
469800200528     C                   PARM                    Trans1                                       CRE026
469900200528     C                   PARM                    Trans2                                       CRE026
470000200528     C                   PARM                    Trans3                                       CRE026
470100200528     C                   PARM                    Trans4                                       CRE026
470200200528                                                                                              CRE026
470300200528     C                   PARM                    ExtData                                      CRE026
470400200528     C                   PARM                    FldNameArr                                   CRE026
470500200528     C                   PARM                    MsgIDArr                                     CRE026
470600200528     C                   PARM                    MsgDtaArr                                    CRE026
470700200528     C                   PARM                    WFldNamArr                                   CRE026
470800200528     C                   PARM                    WMsgIDArr                                    CRE026
470900200528     C                   PARM                    WMsgDtaArr                                   CRE026
471000200528     C                   PARM                    MsgFArray                                    CRE026
471100200528     C                   PARM                    UpdateYN                                     CRE026
471200200528     C                   PARM                    Buffer                                       CRE026
471300200528     C                   PARM                    APIRetc                                      CRE026
471400200528     C                   PARM                    @TimeStamp                                   CRE026
471500200528                                                                                              CSD092
471600200528      ** Account Review Detail Validation                                                     CSD092
471700200528                                                                                              CSD092
471800200528     C     TransTYPE     WHENEQ    'ACRV'                                                     CSD092
471900200528                                                                                              CSD092
472000200528     C                   EXSR      ACRFFmts                                                   CSD092
472100200528                                                                                              CSD092
472200200528     C     ACRFLn        SUBST     BUFFER:Bfp    TRANS1A                                      CSD092
472300200528     C                   ADD       ACRFLn        Bfp                                          CSD092
472400200528                                                                                              CSD092
472500200528      ** Restore Timestamp field from the record                                              CSD092
472600200528                                                                                              CSD092
472700200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD092
472800200528     C                   ADD       26            Bfp                                          CSD092
472900200528     C     ACEXLn        SUBST     BUFFER:Bfp    ExtData                                      CSD092
473000200528                                                                                              CSD092
473100200528     C                   CALL      'SDACRVVU'                                                 CSD092
473200200528                                                                                              CSD092
473300200528      ** Common header information (DS) from source system                                    CSD092
473400200528                                                                                              CSD092
473500200528     C                   PARM                    HeadIn                                       CSD092
473600200528                                                                                              CSD092
473700200528      ** Transaction information in a single large field from source system                   CSD092
473800200528                                                                                              CSD092
473900200528     C                   PARM                    Trans1A                                      CSD092
474000200528                                                                                              CSD092
474100200528     C                   PARM                    ExtData                                      CSD092
474200200528     C                   PARM                    FldNameArr                                   CSD092
474300200528     C                   PARM                    MsgIDArr                                     CSD092
474400200528     C                   PARM                    MsgDtaArr                                    CSD092
474500200528     C                   PARM                    WFldNamArr                                   CSD092
474600200528     C                   PARM                    WMsgIDArr                                    CSD092
474700200528     C                   PARM                    WMsgDtaArr                                   CSD092
474800200528     C                   PARM                    MsgFArray                                    CSD092
474900200528     C                   PARM                    UpdateYN                                     CSD092
475000200528     C                   PARM                    Buffer                                       CSD092
475100200528     C                   PARM                    APIRetc                                      CSD092
475200200528     C                   PARM                    @TimeStamp                                   CSD092
475300200528                                                                                              CSD093
475400200528     C     TransTYPE     WHENEQ    'DCMT'                                                     CSD093
475500200528                                                                                              CSD093
475600200528     C                   EXSR      DCMTFmts                                                   CSD093
475700200528     C     DCMTLn        SUBST     BUFFER:Bfp    TRANS1                                       CSD093
475800200528     C                   ADD       DCMTLn        Bfp                                          CSD093
475900200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD093
476000200528     C                   ADD       26            Bfp                                          CSD093
476100200528     C     DCMXLn        SUBST     BUFFER:Bfp    TRANS2                                       CSD093
476200200528     C                   ADD       DCMXLn        Bfp                                          CSD093
476300200528     C     1             SUBST     BUFFER:Bfp    AAuth                                        CSD093
476400200528     C                   ADD       1             Bfp                                          CSD093
476500200528                                                                                              CSD093
476600200528     C                   CALL      'SDDCMTVU'                                                 CSD093
476700200528                                                                                              CSD093
476800200528      * Common header information (DS) from source system                                     CSD093
476900200528     C                   PARM                    HeadIn                                       CSD093
477000200528                                                                                              CSD093
477100200528      * Transaction information                                                               CSD093
477200200528     C                   PARM                    TRANS1                                       CSD093
477300200528     C                   PARM                    TRANS2                                       CSD093
477400200528     C                   PARM                    FldNameArr                                   CSD093
477500200528     C                   PARM                    MsgIDArr                                     CSD093
477600200528     C                   PARM                    MsgDtaArr                                    CSD093
477700200528     C                   PARM                    WFldNamArr                                   CSD093
477800200528     C                   PARM                    WMsgIDArr                                    CSD093
477900200528     C                   PARM                    WMsgDtaArr                                   CSD093
478000200528     C                   PARM                    MsgFArray                                    CSD093
478100200528     C                   PARM                    UpdateYN                                     CSD093
478200200528     C                   PARM                    Buffer                                       CSD093
478300200528     C                   PARM                    APIRetc                                      CSD093
478400200528     C                   PARM                    @TimeStamp                                   CSD093
478500200528      *                                                                                       CSD079
478600200528      ** Risk Weighted Asset Detail Validation                                                CSD079
478700200528      *                                                                                       CSD079
478800200528     C     TransTYPE     WHENEQ    'RWAN'                                                     CSD079
478900200528                                                                                              CSD079
479000200528     C                   EXSR      RWANFmts                                                   CSD079
479100200528                                                                                              CSD079
479200200528     C     RWANLn        SUBST     BUFFER:Bfp    TRANS1                                       CSD079
479300200528     C                   ADD       RWANLn        Bfp                                          CSD079
479400200528      *                                                                                       CSD079
479500200528      ** Restore Timestamp field from the record                                              CSD079
479600200528      *                                                                                       CSD079
479700200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD079
479800200528     C                   ADD       26            Bfp                                          CSD079
479900200528                                                                                              CSD079
480000200528     C                   CALL      'SDRWANVU'                                                 CSD079
480100200528      *                                                                                       CSD079
480200200528      ** Common header information (DS) from source system                                    CSD079
480300200528      *                                                                                       CSD079
480400200528     C                   PARM                    HeadIn                                       CSD079
480500200528      *                                                                                       CSD079
480600200528      ** Transaction information in a single large field from source system                   CSD079
480700200528      *                                                                                       CSD079
480800200528     C                   PARM                    Trans1                                       CSD079
480900200528                                                                                              CSD079
481000200528     C                   PARM                    FldNameArr                                   CSD079
481100200528     C                   PARM                    MsgIDArr                                     CSD079
481200200528     C                   PARM                    MsgDtaArr                                    CSD079
481300200528     C                   PARM                    WFldNamArr                                   CSD079
481400200528     C                   PARM                    WMsgIDArr                                    CSD079
481500200528     C                   PARM                    WMsgDtaArr                                   CSD079
481600200528     C                   PARM                    MsgFArray                                    CSD079
481700200528     C                   PARM                    UpdateYN                                     CSD079
481800200528     C                   PARM                    Buffer                                       CSD079
481900200528     C                   PARM                    APIRetc                                      CSD079
482000200528     C                   PARM                    @TimeStamp                                   CSD079
482100200528      *                                                                                       CSD079
482200200528      ** Customer Withholding Tax Detail Validation                                           CSD079
482300200528      *                                                                                       CSD079
482400200528     C     TransTYPE     WHENEQ    'CUWT'                                                     CSD079
482500200528     C     TransTYPE     OREQ      'CUWU'                                                     CSD079
482600200528                                                                                              CSD079
482700200528     C                   EXSR      CUWTFmts                                                   CSD079
482800200528      *                                                                                       CSD079
482900200528      ** Restore Timestamp field from the record                                              CSD079
483000200528      *                                                                                       CSD079
483100200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD079
483200200528     C                   ADD       26            Bfp                                          CSD079
483300200528                                                                                              CSD079
483400200528     C     CUW1Ln        SUBST     BUFFER:Bfp    TRANS1                                       CSD079
483500200528     C                   ADD       CUW1Ln        Bfp                                          CSD079
483600200528     C     CUW2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CSD079
483700200528     C                   ADD       CUW2Ln        Bfp                                          CSD079
483800200528     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
483900200528     C                   ADD       1             Bfp                                        BUG22140
484000200528                                                                                              CSD079
484100200528     C                   CALL      'SDCUWTVU'                                                 CSD079
484200200528      *                                                                                       CSD079
484300200528      ** Common header information (DS) from source system                                    CSD079
484400200528      *                                                                                       CSD079
484500200528     C                   PARM                    HeadIn                                       CSD079
484600200528      *                                                                                       CSD079
484700200528      ** Transaction information in a single large field from source system                   CSD079
484800200528      *                                                                                       CSD079
484900200528     C                   PARM                    Trans1                                       CSD079
485000200528     C                   PARM                    Trans2                                       CSD079
485100200528                                                                                              CSD079
485200200528     C                   PARM                    FldNameArr                                   CSD079
485300200528     C                   PARM                    MsgIDArr                                     CSD079
485400200528     C                   PARM                    MsgDtaArr                                    CSD079
485500200528     C                   PARM                    WFldNamArr                                   CSD079
485600200528     C                   PARM                    WMsgIDArr                                    CSD079
485700200528     C                   PARM                    WMsgDtaArr                                   CSD079
485800200528     C                   PARM                    MsgFArray                                    CSD079
485900200528     C                   PARM                    UpdateYN                                     CSD079
486000200528     C                   PARM                    Buffer                                       CSD079
486100200528     C                   PARM                    APIRetc                                      CSD079
486200200528     C                   PARM                    @TimeStamp                                   CSD079
486300200528     C                   PARM                    AAuth                                      BUG22140
486400200528                                                                                              CSD079
486500200528      *                                                                                       CLE134
486600200528      ** PDCL Input                                                                           CLE134
486700200528      *                                                                                       CLE134
486800200528     C     TransTYPE     WHENEQ    'PDCL'                                                     CLE134
486900200528      *                                                                                       CLE134
487000200528     C                   EXSR      CPDCFmts                                                   CLE134
487100200528      *                                                                                       CLE134
487200200528     C     CPD1Ln        SUBST     BUFFER:Bfp    TRANS1A                                      CLE134
487300200528     C                   ADD       CPD1Ln        Bfp                                          CLE134
487400200528      *                                                                                       CLE134
487500200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CLE134
487600200528     C                   ADD       26            Bfp                                          CLE134
487700200528      *                                                                                       CLE134
487800200528     C                   CALL      'LEPDCLVU'                                                 CLE134
487900200528      *                                                                                       CLE134
488000200528      ** Common header information (DS) from source system                                    CLE134
488100200528      *                                                                                       CLE134
488200200528     C                   PARM                    HeadIn                                       CLE134
488300200528      *                                                                                       CLE134
488400200528      ** Transaction information in a single large field from source system                   CLE134
488500200528      *                                                                                       CLE134
488600200528     C                   PARM                    Trans1A                                      CLE134
488700200528      *                                                                                       CLE134
488800200528     C                   PARM                    FldNameArr                                   CLE134
488900200528     C                   PARM                    MsgIDArr                                     CLE134
489000200528     C                   PARM                    MsgDtaArr                                    CLE134
489100200528     C                   PARM                    WFldNamArr                                   CLE134
489200200528     C                   PARM                    WMsgIDArr                                    CLE134
489300200528     C                   PARM                    WMsgDtaArr                                   CLE134
489400200528     C                   PARM                    MsgFArray                                    CLE134
489500200528     C                   PARM                    UpdateYN                                     CLE134
489600200528     C                   PARM                    Buffer                                       CLE134
489700200528     C                   PARM                    APIRetc                                      CLE134
489800200528     C                   PARM                    @TimeStamp                                   CLE134
489900200528      *                                                                                       CAP210
490000200528      ** Adjustment to Accured interest                                                       CAP210
490100200528      *                                                                                       CAP210
490200200528     C     TransTYPE     WHENEQ    'DLAA'                                                     CAP210
490300200528     C                   EXSR      DLAAFmts                                                   CAP210
490400200528                                                                                              CAP210
490500200528     C     DLAALn        SUBST     BUFFER:Bfp    TRANS1                                       CAP210
490600200528     C                   ADD       DLAALn        Bfp                                          CAP210
490700200528      *                                                                                       CAP210
490800200528      ** Restore Timestamp field from the record                                              CAP210
490900200528      *                                                                                       CAP210
491000200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP210
491100200528     C                   ADD       26            Bfp                                          CAP210
491200200528                                                                                              CAP210
491300200528     C                   CALL      'DLDLAAVU'                                                 CAP210
491400200528      *                                                                                       CAP210
491500200528      ** Common header information (DS) from source system                                    CAP210
491600200528      *                                                                                       CAP210
491700200528     C                   PARM                    HeadIn                                       CAP210
491800200528      *                                                                                       CAP210
491900200528      ** Transaction information in a single large field from source system                   CAP210
492000200528      *                                                                                       CAP210
492100200528     C                   PARM                    Trans1                                       CAP210
492200200528                                                                                              CAP210
492300200528     C                   PARM                    FldNameArr                                   CAP210
492400200528     C                   PARM                    MsgIDArr                                     CAP210
492500200528     C                   PARM                    MsgDtaArr                                    CAP210
492600200528     C                   PARM                    WFldNamArr                                   CAP210
492700200528     C                   PARM                    WMsgIDArr                                    CAP210
492800200528     C                   PARM                    WMsgDtaArr                                   CAP210
492900200528     C                   PARM                    MsgFArray                                    CAP210
493000200528     C                   PARM                    UpdateYN                                     CAP210
493100200528     C                   PARM                    Buffer                                       CAP210
493200200528     C                   PARM                    APIRetc                                      CAP210
493300200528      *                                                                                    AR1086546
493400200528      ** Currency/Time of Netting Detail Validation                                        AR1086546
493500200528      *                                                                                    AR1086546
493600200528     C     TransTYPE     WHENEQ    'CTNM'                                                  AR1086546
493700200528     C     TransTYPE     OREQ      'CCTN'                                                  AR1086546
493800200528                                                                                           AR1086546
493900200528     C                   EXSR      CCTNFmts                                                AR1086546
494000200528                                                                                           AR1086546
494100200528     C     CCTNLn        SUBST     BUFFER:Bfp    TRANS1                                    AR1086546
494200200528     C                   ADD       CCTNLn        Bfp                                       AR1086546
494300200528      *                                                                                    AR1086546
494400200528      ** Restore Timestamp field from the record                                           AR1086546
494500200528      *                                                                                    AR1086546
494600200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                AR1086546
494700200528     C                   ADD       26            Bfp                                       AR1086546
494800200528                                                                                           AR1086546
494900200528     C                   CALL      'SDCTNMVU'                                              AR1086546
495000200528      *                                                                                    AR1086546
495100200528      ** Common header information (DS) from source system                                 AR1086546
495200200528      *                                                                                    AR1086546
495300200528     C                   PARM                    HeadIn                                    AR1086546
495400200528      *                                                                                    AR1086546
495500200528      ** Transaction information in a single large field from source system                AR1086546
495600200528      *                                                                                    AR1086546
495700200528     C                   PARM                    Trans1                                    AR1086546
495800200528                                                                                           AR1086546
495900200528     C                   PARM                    FldNameArr                                AR1086546
496000200528     C                   PARM                    MsgIDArr                                  AR1086546
496100200528     C                   PARM                    MsgDtaArr                                 AR1086546
496200200528     C                   PARM                    WFldNamArr                                AR1086546
496300200528     C                   PARM                    WMsgIDArr                                 AR1086546
496400200528     C                   PARM                    WMsgDtaArr                                AR1086546
496500200528     C                   PARM                    MsgFArray                                 AR1086546
496600200528     C                   PARM                    UpdateYN                                  AR1086546
496700200528     C                   PARM                    Buffer                                    AR1086546
496800200528     C                   PARM                    APIRetc                                   AR1086546
496900200528     C                   PARM                    @TimeStamp                                AR1086546
497000200528     C***/COPY*OFCPYSRCZ,CAP090_003                                                    CAP090 CLE164
497100200528     C/COPY OFCPYSRCZ,CGL158_003                                                              CGL158
497200200528      *                                                                                       CAP212
497300200528      ** Nostro Transfer API                                                                  CAP212
497400200528      *                                                                                       CAP212
497500200528     C     TransTYPE     WHENEQ    'FTNT'                                                     CAP212
497600200528                                                                                              CAP212
497700200528     C                   EXSR      FTNTFmts                                                   CAP212
497800200528                                                                                              CAP212
497900200528     C     FTNTLn        SUBST(P)  BUFFER:Bfp    Trans1A                                      CAP212
498000200528     C                   ADD       FTNTLn        Bfp                                          CAP212
498100200528     C     FTEXLn        SUBST(P)  BUFFER:Bfp    ExtData                                      CAP212
498200200528     C                   ADD       FTEXLn        Bfp                                          CAP212
498300200528     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP212
498400200528     C                   ADD       26            Bfp                                          CAP212
498500200528     C     20            SUBST     BUFFER:Bfp    AuthUsers                                    CFT163
498600200528     C                   ADD       20            Bfp                                          CFT163
498700200528                                                                                              CAP212
498800200528     C                   CALL      'FTFTNTVU'                                                 CAP212
498900200528     C                   PARM                    HeadIn                                       CAP212
499000200528     C                   PARM                    Trans1A                                      CAP212
499100200528     C                   PARM                    ExtData                                      CAP212
499200200528     C                   PARM                    FldNameArr                                   CAP212
499300200528     C                   PARM                    MsgIDArr                                     CAP212
499400200528     C                   PARM                    MsgDtaArr                                    CAP212
499500200528     C                   PARM                    WFldNamArr                                   CAP212
499600200528     C                   PARM                    WMsgIDArr                                    CAP212
499700200528     C                   PARM                    WMsgDtaArr                                   CAP212
499800200528     C                   PARM                    MsgFArray                                    CAP212
499900200528     C                   PARM                    UpdateYN                                     CAP212
500000200528     C                   PARM                    Buffer                                       CAP212
500100200528     C                   PARM                    APIRetc                                      CAP212
500200200528     C                   PARM                    @TimeStamp                                   CAP212
500300200528     C                   PARM                    AuthUsers                                    CFT163
500400200528      *                                                                                       CLE164
500500200528      ** Initiate Batch Process API                                                           CLE164
500600200528      *                                                                                       CLE164
500700200528     C     TransTYPE     WHENEQ    'SBJB'                                                     CLE164
500800200528     C                   EXSR      SBJBFmts                                                   CLE164
500900200528                                                                                              CLE164
501000200528     C     SBJBLen       SUBST     BUFFER:Bfp    SBJBParm                                     CLE164
501100200528     C                   ADD       SBJBLen       Bfp                                          CLE164
501200200528      *                                                                                       CLE164
501300200528     C     SBEXLen       SUBST     BUFFER:Bfp    ExtData                                      CLE164
501400200528      *                                                                                       CLE164
501500200528     C                   CALL      'APSBJBVU'                                                 CLE164
501600200528      *                                                                                       CLE164
501700200528      ** Common header information (DS) from source system                                    CLE164
501800200528      *                                                                                       CLE164
501900200528     C                   PARM                    HeadIn                                       CLE164
502000200528      *                                                                                       CLE164
502100200528      ** Transaction information in a single large field from source system                   CLE164
502200200528      *                                                                                       CLE164
502300200528     C                   PARM                    SBJBParm                                     CLE164
502400200528      *                                                                                       CLE164
502500200528     C                   PARM                    ExtData                                      CLE164
502600200528     C                   PARM                    FldNameArr                                   CLE164
502700200528     C                   PARM                    MsgIDArr                                     CLE164
502800200528     C                   PARM                    MsgDtaArr                                    CLE164
502900200528     C                   PARM                    WFldNamArr                                   CLE164
503000200528     C                   PARM                    WMsgIDArr                                    CLE164
503100200528     C                   PARM                    WMsgDtaArr                                   CLE164
503200200528     C                   PARM                    MsgFArray                                    CLE164
503300200528     C                   PARM                    UpdateYN                                     CLE164
503400200528     C                   PARM                    Buffer                                       CLE164
503500200528     C                   PARM                    APIRetc                                      CLE164
503600200528      *
503700200528      * If unknown API requested, make sure this is reported back
503800200528     C                   OTHER
503900200528     C                   EXSR      *PSSR
504000200528
504100200528     C                   ENDSL
504200200528
504300200528     C                   ENDSR
504400200528      ****************************************************************
504500200528      /SPACE 5
504600200528      ****************************************************************
504700200528      *  SrSIRS - Call the validate/update program for SIRS
504800200528      ****************************************************************
504900200528     C     SrSIRS        BEGSR
505000200528
505100200528     C                   EXSR      SIRSFmts
505200200528     C**********         EXSR      SCHEDFmts                                                 BUG4646
505300200528     C                   EXSR      SettleFmts
505400200528     C                   EXSR      RPIFFmts                                                   CSW213
505500200528     C**********         EVAL      APTGTTYPE = %SUBST(BUFFER:1:6)                            BUG4646
505600200528     C**********         ADD       6             Bfp                                         BUG4646
505700200528      **********                                                                             BUG4646
505800200528     C**********         SELECT                                                              BUG4646
505900200528
506000200528      ** Single Currency IRS - Main details
506100200528      **********                                                                             BUG4646
506200200528     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSIRS'                             BUG4646
506300200528     C*****SIRSLn        SUBST     BUFFER:Bfp    Trans1                                       CIR017
506400200528     C     SIRSLn        SUBST     BUFFER:Bfp    Trans1A                                      CIR017
506500200528     C                   ADD       SIRSLn        Bfp
506600200528     C*****DTORLn        SUBST     BUFFER:Bfp    Trans2                                      BUG4646
506700200528     C**********         ADD       DTORLn        Bfp                                         BUG4646
506800200528     C*****DTOPLn        SUBST     BUFFER:Bfp    Trans3                                      BUG4646
506900200528     C**********         ADD       DTOPLn        Bfp                                         BUG4646
507000200528     C*****DTTRLn        SUBST     BUFFER:Bfp    Trans4                                      BUG4646
507100200528     C**********         ADD       DTTRLn        Bfp                                         BUG4646
507200200528     C*****DTTPLn        SUBST     BUFFER:Bfp    Trans5                                      BUG4646
507300200528
507400200528      ***Rate*Change*&*Interest*Payment*Dates*-*Single*Currency*IRS****                      BUG4646
507500200528      *****************************************************************                      BUG4646
507600200528     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSIRI'                             BUG4646
507700200528     C*****DTORLn        SUBST     BUFFER:Bfp    Trans1                                      BUG4646
507800200528     C**********         ADD       DTORLn        Bfp                                         BUG4646
507900200528     C*****DTOPLn        SUBST     BUFFER:Bfp    Trans2                                      BUG4646
508000200528     C**********         ADD       DTOPLn        Bfp                                         BUG4646
508100200528     C*****DTTRLn        SUBST     BUFFER:Bfp    Trans3                                      BUG4646
508200200528     C**********         ADD       DTTRLn        Bfp                                         BUG4646
508300200528     C*****DTTPLn        SUBST     BUFFER:Bfp    Trans4                                      BUG4646
508400200528      *****************************************************************                      BUG4646
508500200528      ***Cash*Flow*Schedules*-*Single*Currency*IRS*********************                      BUG4646
508600200528      *****************************************************************                      BUG4646
508700200528     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSICF'                             BUG4646
508800200528     C*****WCFSC1OLn     SUBST     BUFFER:Bfp    Trans1                                      BUG4646
508900200528     C**********         ADD       WCFSC1OLn     Bfp                                         BUG4646
509000200528     C*****WCFSC2OLn     SUBST     BUFFER:Bfp    Trans2                                      BUG4646
509100200528     C**********         ADD       WCFSC2OLn     Bfp                                         BUG4646
509200200528     C*****WCFSC3OLn     SUBST     BUFFER:Bfp    Trans3                                      BUG4646
509300200528     C**********         ADD       WCFSC3OLn     Bfp                                         BUG4646
509400200528     C*****WCFSC4OLn     SUBST     BUFFER:Bfp    Trans4                                      BUG4646
509500200528     C**********         ADD       WCFSC4OLn     Bfp                                         BUG4646
509600200528     C*****WCFSC1TLn     SUBST     BUFFER:Bfp    Trans5                                      BUG4646
509700200528     C**********         ADD       WCFSC1TLn     Bfp                                         BUG4646
509800200528     C*****WCFSC2TLn     SUBST     BUFFER:Bfp    Trans6                                      BUG4646
509900200528     C**********         ADD       WCFSC2TLn     Bfp                                         BUG4646
510000200528     C*****WCFSC3TLn     SUBST     BUFFER:Bfp    Trans7                                      BUG4646
510100200528     C**********         ADD       WCFSC3TLn     Bfp                                         BUG4646
510200200528     C*****WCFSC4TLn     SUBST     BUFFER:Bfp    Trans8                                      BUG4646
510300200528      *****************************************************************                      BUG4646
510400200528      ***Principal*Change*Schedules*-*Single*Currency*IRS**************                      BUG4646
510500200528      *****************************************************************                      BUG4646
510600200528     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSIPC'                             BUG4646
510700200528     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    Trans1                                      BUG4646
510800200528     C**********         ADD       WPCSC1OLn     Bfp                                         BUG4646
510900200528     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    Trans2                                      BUG4646
511000200528     C**********         ADD       WPCSC2OLn     Bfp                                         BUG4646
511100200528     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    Trans3                                      BUG4646
511200200528     C**********         ADD       WPCSC3OLn     Bfp                                         BUG4646
511300200528     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    Trans4                                      BUG4646
511400200528      *****************************************************************                      BUG4646
511500200528      ***Trailer*record*-*Single*Currency*IRS**************************                      BUG4646
511600200528      *****************************************************************                      BUG4646
511700200528     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSITR'                             BUG4646
511800200528     C*****WTRSCLn       SUBST     BUFFER:Bfp    Trans1                                      BUG4646
511900200528     C**********         ADD       WTRSCLn       Bfp                                         BUG4646
512000200528     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
512100200528     C                   ADD       ESSRLn        Bfp
512200200528     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
512300200528     C                   ADD       ESSPLn        Bfp
512400200528     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
512500200528     C                   ADD       ESSFLn        Bfp                                         BUG6671
512600200528                                                                                             BUG6671
512700200528      **  Non-Screen Interface Data for Class 1 enhancements                                 BUG6671
512800200528                                                                                             BUG6671
512900200528     C     IRRSLn        SUBST     BUFFER:Bfp    InfData                                     BUG6671
513000200528     C                   ADD       IRRSLn        Bfp                                         BUG6671
513100200528                                                                                             BUG6671
513200200528     C     IRSSLn        SUBST     BUFFER:Bfp    ExtData                                     BUG6671
513300200528     C                   ADD       IRSSLn        Bfp                                          CSW213
513400200528     C                   ADD       168           Bfp                                          CSW213
513500200528     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213
513600200528                                                                                             BUG6671
513700200528
513800200528     C**********         ENDSL                                                               BUG4646
513900200528
514000200528     C                   CALL      'IRSIRSVU'
514100200528     C                   PARM                    HeadIn
514200200528     C**********         PARM                    Trans1                                       CIR017
514300200528     C                   PARM                    Trans1A                                      CIR017
514400200528     C**********         PARM                    Trans2                                      BUG4646
514500200528     C**********         PARM                    Trans3                                      BUG4646
514600200528     C**********         PARM                    Trans4                                      BUG4646
514700200528     C**********         PARM                    Trans5                                      BUG4646
514800200528     C**********         PARM                    Trans6                                      BUG4646
514900200528     C**********         PARM                    Trans7                                      BUG4646
515000200528     C**********         PARM                    Trans8                                      BUG4646
515100200528     C                   PARM                    RecSttmt
515200200528     C                   PARM                    PaySttmt
515300200528     C                   PARM                    FRASttmt
515400200528     C                   PARM                    InfData                                     BUG6671
515500200528     C                   PARM                    ExtData                                     BUG6671
515600200528     C                   PARM                    InSwift2013                                  CSW213
515700200528     C                   PARM                    FldNameArr
515800200528     C                   PARM                    MsgIDArr
515900200528     C                   PARM                    MsgDtaArr
516000200528     C                   PARM                    WFldNamArr
516100200528     C                   PARM                    WMsgIDArr
516200200528     C                   PARM                    WMsgDtaArr
516300200528     C                   PARM                    MsgFArray
516400200528     C                   PARM                    UpdateYN
516500200528     C                   PARM                    Buffer
516600200528     C                   PARM                    Buffer2                                     BUG4646
516700200528     C                   PARM                    BufferEx2                                   BUG4646
516800200528     C                   PARM                    BufferEx3                                   BUG4646
516900200528     C                   PARM                    BufferEx4                                   BUG4646
517000200528     C                   PARM                    BufferEx5                                   BUG4646
517100200528     C                   PARM                    BufferEx6                                   BUG4646
517200200528     C                   PARM                    BufferEx7                                   BUG4646
517300200528     C                   PARM                    BufferEx8                                   BUG4646
517400200528     C                   PARM                    BufferEx9                                   BUG4646
517500200528     C                   PARM                    APIRetc
517600200528                                                                                              CRE020
517700200528     C                   IF        CRE020 = 'Y'                                               CRE020
517800200528     C                   EVAL      WrkPgm = 'IRSIRSUPD'                                       CRE020
517900200528     C                   EVAL      WrkMod = 'DL'                                              CRE020
518000200528     C                   EXSR      SRSndDtaQ                                                  CRE020
518100200528     C                   ENDIF                                                                CRE020
518200200528
518300200528     C                   ENDSR
518400200528      ****************************************************************
518500200528      /SPACE 5
518600200528      ****************************************************************
518700200528      * Edit the Messages for output
518800200528      ****************************************************************
518900200528     C     EDTMSGS       BEGSR
519000200528     C                                                                                        CBF011
519100200528     C                   EVAL      APINam  = TransType                                        CBF011
519200200528     C                   CALLB     'APEDTMSGS'
519300200528     C                   PARM                    FldNameArr
519400200528     C                   PARM                    MsgIDArr
519500200528     C                   PARM                    MsgDtaArr
519600200528     C                   PARM                    WFldNamArr
519700200528     C                   PARM                    WMsgIDArr
519800200528     C                   PARM                    WMsgDtaArr
519900200528     C                   PARM                    MsgFArray
520000200528     C                   PARM                    MsgArrOUT
520100200528     C                   PARM                    APINam                                       CBF011
520200200528                                                                                              CBF011
520300200528     C                   ENDSR
520400200528      *****************************************************************
520500200528      /SPACE 5
520600200528      *****************************************************************
520700200528      * FX Deal
520800200528      *****************************************************************
520900200528     C     FXDLFmts      BEGSR
521000200528
521100200528     C                   MOVEL     *BLANKS       FileName
521200200528     C                   MOVEL     'FXFXDLPD'    FileName
521300200528     C                   EXSR      GETRCDLN
521400200528     C                   Z-ADD     RecordLen     FXDLLn            4 0
521500200528
521600200528      **Add*DDNBRF*(19)*DDNSRF*(19)*DDSTS*(24)*BNNMAM*(1)**************                       CTI004
521700200528      **and*BJLCCY*(3)*to*end*of*details.******************************                       CTI004
521800200528     C**********         ADD       66            FXDLLn                                       CTI004
521900200528      * Add DDNBRF (19) DDNSRF (19) DDSTS (24) BNNMAM (1)                                     CTI004
522000200528      **BJLCCY*(3)*and*DDFOID*(20)*to*end*of*details.******************                CTI004 261692
522100200528      * BJLCCY (3) DDFOID (20) and DDAFID (20) to end of details.                             261692
522200200528     C**********         ADD       86            FXDLLn                                CTI004 261692
522300200528     C                   ADD       106           FXDLLn                                       261692
522400200528      * Add Override flag, overriding officer and overriding officer password                 CFX114
522500200528     C                   ADD       21            FXDLLn                                       CFX114
522600200528      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG4562
522700200528     C                   ADD       6             FXDLLn                                      BUG4562
522800200528
522900200528     C                   MOVEL     'FXFXIFPD'    FileName                                    BUG4815
523000200528     C                   EXSR      GETRCDLN                                                  BUG4815
523100200528     C                   Z-ADD     RecordLen     FXIFLn            4 0                       BUG4815
523200200528                                                                                             BUG4815
523300200528     C                   MOVEL     'FXFXEXPD'    FileName
523400200528     C                   EXSR      GETRCDLN
523500200528     C                   Z-ADD     RecordLen     FXFXLn            4 0
523600200528
523700200528     C                   MOVEL     'FXDLEXPD'    FileName                                     CDL099
523800200528     C                   EXSR      GETRCDLN                                                   CDL099
523900200528     C                   Z-ADD     RecordLen     FXEDLn            4 0                        CDL099
524000200528                                                                                              CDL099
524100200528     C**********         MOVEL     'SDCUCUPD'    FileName                              CER043 CSF011
524200200528     C**********         EXSR      GETRCDLN                                            CER043 CSF011
524300200528     C**********         Z-ADD     RecordLen     SDCULn                                CER043 CSF011
524400200528      **********                                                                       CER043 CSF011
524500200528     C                   ENDSR
524600200528      *****************************************************************                       CSW213
524700200528      /SPACE 5                                                                                CSW213
524800200528      *****************************************************************                       CSW213
524900200528      * DL RPIF - Reporting Information                                                       CSW213
525000200528      *****************************************************************                       CSW213
525100200528     C     RPIFFmts      BEGSR                                                                CSW213
525200200528                                                                                              CSW213
525300200528     C                   EVAL      FileName = 'DLRIS1PD'                                      CSW213
525400200528     C                   EXSR      GETRCDLN                                                   CSW213
525500200528     C                   EVAL      RPIF1Ln = RecordLen                                        CSW213
525600200528     C                                                                                        CSW213
525700200528     C                   EVAL      FileName = 'DLRIS2PD'                                      CSW213
525800200528     C                   EXSR      GETRCDLN                                                   CSW213
525900200528     C                   EVAL      RPIF2Ln = RecordLen                                        CSW213
526000200528     C                                                                                        CSW213
526100200528     C                   EVAL      FileName = 'DLRIS3PD'                                      CSW213
526200200528     C                   EXSR      GETRCDLN                                                   CSW213
526300200528     C                   EVAL      RPIF3Ln = RecordLen                                        CSW213
526400200528     C                                                                                        CSW213
526500200528     C                   EVAL      FileName = 'DLRIS4PD'                                      CSW214
526600200528     C                   EXSR      GETRCDLN                                                   CSW214
526700200528     C                   EVAL      RPIF4Ln = RecordLen                                        CSW214
526800200528                                                                                              CSW214
526900200528     C                   EVAL      RPIFLn = RPIF1Ln + RPIF2Ln + RPIF3Ln                       CSW213
527000200528     C                             + RPIF4Ln                                                  CSW214
527100200528                                                                                              CSW213
527200200528     C                   ENDSR                                                                CSW213
527300200528      *****************************************************************
527400200528      /SPACE 5
527500200528      *****************************************************************
527600200528      * MM Loan/Deposit
527700200528      *****************************************************************
527800200528     C     LDNIFmts      BEGSR
527900200528
528000200528     C                   MOVEL     *BLANKS       FileName
528100200528     C                   MOVEL     'MMLDNIPD'    FileName
528200200528     C                   EXSR      GETRCDLN
528300200528     C                   Z-ADD     RecordLen     LDNILn            4 0
528400200528      **Add*TRAM*fields,*Counterpary and Broker Stati and visibility flags           BUG6512 BUG7664
528500200528     C*******************ADD       6             LDNILn                              BUG6512 BUG7664
528600200528
528700200528     C                   MOVEL     'MMLDIFPD'    FileName
528800200528     C                   EXSR      GETRCDLN
528900200528     C                   Z-ADD     RecordLen     LDIFLn            4 0
529000200528      * Add RFormula/PFormula                                                                 CDL033
529100200528     C                   ADD       16            LDIFLn                                       CDL033
529200200528      * Add Remarks                                                                           CMM105
529300200528     C                   ADD       35            LDIFLn                                       CMM105
529400200528      * Add Deal Status                                                                      BUG3986
529500200528     C                   ADD       34            LDIFLn                                      BUG3986
529600200528      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG7664
529700200528     C                   ADD       6             LDIFLn                                      BUG7664
529800200528
529900200528     C                   MOVEL     'MMLDRXPD'    FileName                                     CER001
530000200528     C                   EXSR      GETRCDLN                                                   CER001
530100200528     C                   Z-ADD     RecordLen     LDRXLn                                       CER001
530200200528                                                                                              CER001
530300200528     C                   MOVEL     'MMLDEXPD'    FileName
530400200528     C                   EXSR      GETRCDLN
530500200528     C                   Z-ADD     RecordLen     LDEXLn            4 0
530600200528
530700200528     C                   MOVEL     'SDCUCUPD'    FileName                                     CER043
530800200528     C                   EXSR      GETRCDLN                                                   CER043
530900200528     C                   Z-ADD     RecordLen     SDCULn                                       CER043
531000200528      *                                                                                       CER043
531100200528     C                   MOVEL     *BLANKS       FileName                                     CER049
531200200528     C                   MOVEL     'DLSTMPPD'    FileName                                     CER049
531300200528     C                   EXSR      GETRCDLN                                                   CER049
531400200528     C                   Z-ADD     RecordLen     LDSTQLn           4 0                        CER049
531500200528     C                   ENDSR
531600200528      *****************************************************************
531700200528      /SPACE 5
531800200528      *****************************************************************
531900200528      ** GL Accounts maintenance : Master, Debit interests, Credit interests
532000200528      **               Commissions & Overdraft charges and Other details
532100200528      *****************************************************************
532200200528     C     AMADFmts      BEGSR
532300200528
532400200528     C                   MOVEL     *BLANKS       FileName
532500200528     C                   MOVEL     'GLAMADPD'    FileName
532600200528     C                   EXSR      GETRCDLN
532700200528     C                   Z-ADD     RecordLen     AMMDLn            4 0
532800200528
532900200528     C                   MOVEL     'GLAMDIPD'    FileName
533000200528     C                   EXSR      GETRCDLN
533100200528     C                   Z-ADD     RecordLen     AMDILn            4 0
533200200528
533300200528     C                   MOVEL     'GLAMCIPD'    FileName
533400200528     C                   EXSR      GETRCDLN
533500200528     C                   Z-ADD     RecordLen     AMCILn            4 0
533600200528
533700200528     C                   MOVEL     'GLAMCOPD'    FileName
533800200528     C                   EXSR      GETRCDLN
533900200528     C                   Z-ADD     RecordLen     AMCOLn            4 0
534000200528
534100200528     C                   MOVEL     'GLAMODPD'    FileName
534200200528     C                   EXSR      GETRCDLN
534300200528     C                   Z-ADD     RecordLen     AMODLn            4 0
534400200528                                                                                              CAP086
534500200528     C                   EVAL      AMADFLn = %LEN(AMADFldDS1)                                BUG5988
534600200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
534700200528     C                   MOVEL     'GLAMIFPD'    FileName                                     CAP086
534800200528     C                   EXSR      GETRCDLN                                                   CAP086
534900200528     C                   Z-ADD     RecordLen     AMIFLn            4 0                        CAP086
535000200528      *                                                                                       CER001
535100200528     C                   MOVEL     'GLAMRXPD'    FileName                                     CER001
535200200528     C                   EXSR      GETRCDLN                                                   CER001
535300200528     C                   Z-ADD     RecordLen     AMRXLn                                       CER001
535400200528     C                   MOVEL     'GLAMEXPD'    Filename                                   BUG10280
535500200528     C                   EXSR      GETRCDLN                                                 BUG10280
535600200528     C                   Z-ADD     Recordlen     AMEXLn            4 0                      BUG10280
535700200528      *                                                                                     MD054028
535800200528     C                   Z-ADD     17            AMCR50Ln          4 0                      MD054028
535900200528      *                                                                                     MD054028
536000200528     C                   EVAL      FileName = 'GLAMPP1PD'                                     CRE015
536100200528     C                   EXSR      GETRCDLN                                                   CRE015
536200200528     C                   EVAL      AMPPLn1 = RecordLen                                        CRE015
536300200528      ** Add Interest Scale Flag                                                            AR802610
536400200528     C                   ADD       1             AMPPLn1                                    AR802610
536500200528                                                                                            AR802610
536600200528     C                   EVAL      FileName = 'GLAMPP2PD'                                     CRE015
536700200528     C                   EXSR      GETRCDLN                                                   CRE015
536800200528     C                   EVAL      AMPPLn2 = RecordLen                                        CRE015
536900200528     C/COPY OFCPYSRCZ,CRE101_005                                                              CRE101
537000200528
537100200528     C                   ENDSR
537200200528      *****************************************************************
537300200528      /SPACE 5
537400200528      *****************************************************************
537500200528      * (Dealing) Extended Payment Instructions
537600200528      *****************************************************************
537700200528     C     SettleFmts    BEGSR
537800200528
537900200528     C                   MOVEL     *BLANKS       FileName
538000200528     C                   MOVEL     'SDESSPPD'    FileName
538100200528     C                   EXSR      GETRCDLN
538200200528     C                   Z-ADD     RecordLen     ESSPLn            4 0
538300200528
538400200528     C                   MOVEL     'SDESSRPD'    FileName
538500200528     C                   EXSR      GETRCDLN
538600200528     C                   Z-ADD     RecordLen     ESSRLn            4 0
538700200528
538800200528     C                   MOVEL     'SDESSFPD'    FileName
538900200528     C                   EXSR      GETRCDLN
539000200528     C                   Z-ADD     RecordLen     ESSFLn            4 0
539100200528
539200200528     C                   ENDSR
539300200528      *****************************************************************
539400200528      /SPACE 5
539500200528      *****************************************************************                       CDL018
539600200528      * Further Settlement Instructions                                                       CDL018
539700200528      *****************************************************************                       CDL018
539800200528     C     FSettleFmts   BEGSR                                                                CDL018
539900200528                                                                                              CDL018
540000200528     C                   MOVEL     'SDFSSPPD'    FileName                                     CDL018
540100200528     C                   EXSR      GETRCDLN                                                   CDL018
540200200528     C                   Z-ADD     RecordLen     FSSPLn            4 0                        CDL018
540300200528                                                                                              CDL018
540400200528     C                   MOVEL     'SDFSSRPD'    FileName                                     CDL018
540500200528     C                   EXSR      GETRCDLN                                                   CDL018
540600200528     C                   Z-ADD     RecordLen     FSSRLn            4 0                        CDL018
540700200528                                                                                              CDL018
540800200528     C                   ENDSR                                                                CDL018
540900200528      *****************************************************************                       CDL018
541000200528      /SPACE 5                                                                                CDL018
541100200528      *****************************************************************
541200200528      ** FT Outgoing Payment : First, Second, Third and Fourth Details
541300200528      **                     : Fifth, Sixth, Seventh and Eighth
541400200528      *****************************************************************
541500200528     C     OPAYFmts      BEGSR
541600200528
541700200528     C                   MOVEL     *BLANKS       FileName
541800200528     C                   MOVEL     'FTOPY1PD'    FileName
541900200528     C                   EXSR      GETRCDLN
542000200528     C                   Z-ADD     RecordLen     OPY1Ln            4 0
542100200528
542200200528     C                   MOVEL     'FTOPY1APD'   FileName
542300200528     C                   EXSR      GETRCDLN
542400200528     C                   Z-ADD     RecordLen     OPY2Ln            4 0
542500200528
542600200528     C                   MOVEL     *BLANKS       FileName
542700200528     C                   MOVEL     'FTOPY2PD'    FileName
542800200528     C                   EXSR      GETRCDLN
542900200528     C                   Z-ADD     RecordLen     OPY3Ln            4 0
543000200528
543100200528     C                   MOVEL     'FTOPY3PD'    FileName
543200200528     C                   EXSR      GETRCDLN
543300200528     C                   Z-ADD     RecordLen     OPY4Ln            4 0
543400200528
543500200528     C                   MOVEL     'FTOPY4PD'    FileName
543600200528     C                   EXSR      GETRCDLN
543700200528     C                   Z-ADD     RecordLen     OPY5Ln            4 0
543800200528
543900200528     C                   MOVEL     'FTOPY5PD'    FileName
544000200528     C                   EXSR      GETRCDLN
544100200528     C                   Z-ADD     RecordLen     OPY6Ln            4 0
544200200528
544300200528     C                   MOVEL     'FTOPY6PD'    FileName
544400200528     C                   EXSR      GETRCDLN
544500200528     C                   Z-ADD     RecordLen     OPY7Ln            4 0
544600200528
544700200528     C                   MOVEL     'FTOPY7PD'    FileName
544800200528     C                   EXSR      GETRCDLN
544900200528     C                   Z-ADD     RecordLen     OPY9Ln            4 0
545000200528                                                                                              CSW209
545100200528     C**********         IF        CSW209 = 'Y'                                     CSW209 AR1002463
545200200528                                                                                              CSW209
545300200528     C                   MOVEL     'FTOPYAPD'    FileName                                     CSW209
545400200528     C                   EXSR      GETRCDLN                                                   CSW209
545500200528     C                   Z-ADD     RecordLen     OPY10Ln                                      CSW209
545600200528                                                                                              CSW209
545700200528     C                   MOVEL     'FTOPYCPD'    FileName                                     CSW209
545800200528     C                   EXSR      GETRCDLN                                                   CSW209
545900200528     C                   Z-ADD     RecordLen     OPY11Ln                                      CSW209
546000200528                                                                                              CSW209
546100200528     C**********         ENDIF                                                      CSW209 AR1002463
546200200528                                                                                              CSW209
546300200528      * Add MT110 generation flag, MT110 customer and cheque number                           CFT116
546400200528      *                                                                                       CFT116
546500200528     C                   ADD       13            OPY9Ln                                       CFT116
546600200528      **Add*Cheque*Print*Indicator*************************************                CFT118 CFT118
546700200528      **********                                                                       CFT118 CFT118
546800200528     C**********         ADD       1             OPY9Ln                                CFT118 CFT118
546900200528      * Add Cheque Print Indicator and Print Draft flag (1-char each)                         CFT118
547000200528      *                                                                                       CFT118
547100200528     C                   ADD       2             OPY9Ln                                       CFT118
547200200528      *                                                                                       CER030
547300200528     C                   MOVEL     'FTOPY7APD'   Filename                                     CER030
547400200528     C                   EXSR      GETRCDLN                                                   CER030
547500200528     C                   Z-ADD     RecordLen     OPY10LAn          4 0                        CER030
547600200528      *                                                                                       CER030
547700200528     C                   MOVEL     'FTOPY7BPD'   Filename                                     CER030
547800200528     C                   EXSR      GETRCDLN                                                   CER030
547900200528     C                   Z-ADD     RecordLen     OPY11LAn          4 0                        CER030
548000200528      *                                                                                       CER030
548100200528      ** Blanking out the name for the next name to be moved correctly                        CER030
548200200528      *                                                                                       CER030
548300200528     C                   MOVE      *BLANKS       Filename                                     CER030
548400200528
548500200528     C                   MOVEL     'FTOPRXPD'    FileName                                     CER001
548600200528     C                   EXSR      GETRCDLN                                                   CER001
548700200528     C                   Z-ADD     RecordLen     OPRXLn                                       CER001
548800200528                                                                                              CER001
548900200528     C                   MOVEL     'FTOPEXPD'    FileName
549000200528     C                   EXSR      GETRCDLN
549100200528     C                   Z-ADD     RecordLen     OPEXLn            4 0
549200200528      *                                                                                       CSD083
549300200528     C**********         ADD       181           WLCLn             4 0               CSD083 AR819540
549400200528     C                   ADD       184           WLCLn             4 0                      AR819540
549500200528                                                                                              CER049
549600200528     C                   MOVEL     'FTOPY9PD'    FileName                                     CER049
549700200528     C                   EXSR      GETRCDLN                                                   CER049
549800200528     C                   Z-ADD     RecordLen     OPY12Ln           4 0                        CER049
549900200528
550000200528     C                   MOVEL     'FTOPY10APD'  FileName                                   MD050928
550100200528     C                   EXSR      GETRCDLN                                                 MD050928
550200200528     C                   Z-ADD     RecordLen     StopOPlen         4 0                      MD050928
550300200528     C                   ENDSR
550400200528      *****************************************************************
550500200528      /SPACE 5
550600200528      *****************************************************************
550700200528      *  IPAYFmts - Set up the screen definitions for Incoming        *
550800200528      *             payments                                          *
550900200528      *                                                               *
551000200528      *****************************************************************
551100200528     C     IPAYFmts      BEGSR
551200200528
551300200528     C                   MOVEL     'FTIPY1PD  '  FileName
551400200528     C                   EXSR      GETRCDLN
551500200528     C                   Z-ADD     RecordLen     IPY1Ln            4 0
551600200528
551700200528     C                   MOVEL     'FTIPY1APD '  FileName
551800200528     C                   EXSR      GETRCDLN
551900200528     C                   Z-ADD     RecordLen     IPY2Ln            4 0
552000200528
552100200528     C                   MOVEL     'FTIPY2PD  '  FileName
552200200528     C                   EXSR      GETRCDLN
552300200528     C                   Z-ADD     RecordLen     IPY3Ln            4 0
552400200528
552500200528     C                   MOVEL     'FTIPY3PD  '  FileName
552600200528     C                   EXSR      GETRCDLN
552700200528     C                   Z-ADD     RecordLen     IPY4Ln            4 0
552800200528
552900200528     C                   MOVEL     'FTIPY4PD  '  FileName
553000200528     C                   EXSR      GETRCDLN
553100200528     C                   Z-ADD     RecordLen     IPY5Ln            4 0
553200200528
553300200528     C                   MOVEL     'FTIPY4APD '  FileName
553400200528     C                   EXSR      GETRCDLN
553500200528     C                   Z-ADD     RecordLen     IPY6Ln            4 0
553600200528
553700200528     C                   MOVEL     'FTIPY5PD  '  FileName
553800200528     C                   EXSR      GETRCDLN
553900200528     C                   Z-ADD     RecordLen     IPY7Ln            4 0
554000200528
554100200528     C                   MOVEL     'FTIPY6PD  '  FileName
554200200528     C                   EXSR      GETRCDLN
554300200528     C                   Z-ADD     RecordLen     IPY8Ln            4 0
554400200528      * Add Override flag, overriding officer and overriding officer password                 CFT115
554500200528     C                   ADD       21            IPY8Ln                                       CFT115
554600200528      *                                                                                       CSW209
554700200528     C                   IF        CSW209 = 'Y'                                               CSW209
554800200528     C                   MOVEL     'FTIPY7PD'    FileName                                     CSW209
554900200528     C                   EXSR      GETRCDLN                                                   CSW209
555000200528     C                   Z-ADD     RecordLen     IPY9ALn                                      CSW209
555100200528      *                                                                                       CSW209
555200200528     C                   MOVEL     'FTIPY8PD'    FileName                                     CSW209
555300200528     C                   EXSR      GETRCDLN                                                   CSW209
555400200528     C                   Z-ADD     RecordLen     IPY9BLn                                      CSW209
555500200528      *                                                                                       CSW209
555600200528     C                   ENDIF                                                                CSW209
555700200528      *                                                                                       CER030
555800200528     C                   MOVEL     'FTIPY6APD '  FileName                                     CER030
555900200528     C                   EXSR      GETRCDLN                                                   CER030
556000200528     C                   Z-ADD     RecordLen     IPY9Ln            4 0                        CER030
556100200528      *                                                                                       CER049
556200200528     C                   MOVEL     'FTIPY9PD  '  FileName                                     CER049
556300200528     C                   EXSR      GETRCDLN                                                   CER049
556400200528     C                   Z-ADD     RecordLen     IPY10Ln           4 0                        CER049
556500200528
556600200528     C                   MOVEL     'FTIPRXPD  '  FileName                                     CER001
556700200528     C                   EXSR      GETRCDLN                                                   CER001
556800200528     C                   Z-ADD     RecordLen     IPRXLn                                       CER001
556900200528                                                                                              CER001
557000200528     C                   MOVEL     'FTIPEXPD  '  FileName
557100200528     C                   EXSR      GETRCDLN
557200200528     C                   Z-ADD     RecordLen     IPEXLn            4 0
557300200528
557400200528     C                   MOVEL     'FTIPY10APD'  FileName                                   MD050928
557500200528     C                   EXSR      GETRCDLN                                                 MD050928
557600200528     C                   Z-ADD     RecordLen     StopIPlen         4 0                      MD050928
557700200528     C                   ENDSR
557800200528      *****************************************************************
557900200528      /SPACE 5
558000200528      *****************************************************************
558100200528      * SD Customers
558200200528      *****************************************************************
558300200528     C     CUSDFmts      BEGSR
558400200528
558500200528     C                   MOVEL     *BLANKS       FileName
558600200528     C                   MOVEL     'SDCUPRPD'    FileName
558700200528     C                   EXSR      GETRCDLN
558800200528     C                   Z-ADD     RecordLen     SDPRLn            4 0
558900200528
559000200528     C                   MOVEL     'SDCUSEPD'    FileName
559100200528     C                   EXSR      GETRCDLN
559200200528     C                   Z-ADD     RecordLen     SDSELn            4 0
559300200528
559400200528     C                   MOVEL     'SDCUMRPD'    FileName
559500200528     C                   EXSR      GETRCDLN
559600200528     C                   Z-ADD     RecordLen     SDMRLn            4 0
559700200528
559800200528     C                   MOVEL     'SDCUPBPD'    FileName
559900200528     C                   EXSR      GETRCDLN
560000200528     C                   Z-ADD     RecordLen     SDPBLn            4 0
560100200528
560200200528     C                   MOVEL     'SDCUBRPD'    FileName
560300200528     C                   EXSR      GETRCDLN
560400200528     C                   Z-ADD     500           SDB1Ln            4 0
560500200528     C     RecordLen     SUB       500           SDB2Ln            4 0
560600200528
560700200528     C                   MOVEL     'SDCUMTPD'    FileName                                   BUG14485
560800200528     C                   EXSR      GETRCDLN                                                 BUG14485
560900200528     C                   Z-ADD     RecordLen     SDMTLn            4 0                      BUG14485
561000200528                                                                                            BUG14485
561100200528                                                                                              CSD079
561200200528     C                   MOVEL     'SDCUMIPD'    FileName                                     CSD079
561300200528     C                   EXSR      GETRCDLN                                                   CSD079
561400200528     C                   Z-ADD     RecordLen     SDMILn            4 0                        CSD079
561500200528                                                                                              CSD079
561600200528     C                   MOVEL     'SDCUADPD'    FileName                                     CSD079
561700200528     C                   EXSR      GETRCDLN                                                   CSD079
561800200528     C                   Z-ADD     500           SDADLn            4 0                        CSD079
561900200528     C                   Z-ADD     500           SDADLnA           4 0                        CSD079
562000200528     C*****RecordLen     SUB       1000          SDADLnB           4 0               CSD079 MD050342
562100200528     C                   Z-ADD     500           SDADLnB           4 0                      MD050342
562200200528     C     RecordLen     SUB       1500          SDADLnC           4 0                      MD050342
562300200528                                                                                              CSD079
562400200528     C                   MOVEL     'SDACU3DPD'   FileName                                     CER059
562500200528     C                   EXSR      GETRCDLN                                                   CER059
562600200528     C                   Z-ADD     RecordLen     SDADLn3           4 0                        CER059
562700200528                                                                                              CER059
562800200528     C                   MOVEL     'SDACU4DPD'   FileName                                     CER059
562900200528     C                   EXSR      GETRCDLN                                                   CER059
563000200528     C                   Z-ADD     RecordLen     SDADLn4           4 0                        CER059
563100200528     C                   MOVEL     *BLANKS       FileName                                     CER059
563200200528                                                                                              CER059
563300200528     C                   MOVEL     'SDSFEEPD'    FileName                                     CSD079
563400200528     C                   EXSR      GETRCDLN                                                   CSD079
563500200528     C                   Z-ADD     RecordLen     SDSFLn            4 0                        CSD079
563600200528                                                                                              CSD079
563700200528     C                   MOVEL     'SDCHECPD'    FileName                                     CSD079
563800200528     C                   EXSR      GETRCDLN                                                   CSD079
563900200528     C                   Z-ADD     RecordLen     SDCHLn            4 0                        CSD079
564000200528                                                                                              CSD079
564100200528     C                   MOVEL     'SDCUSFPD'    FileName                                     CSD079
564200200528     C                   EXSR      GETRCDLN                                                   CSD079
564300200528     C                   Z-ADD     RecordLen     SDCSLn            4 0                        CSD079
564400200528                                                                                              CSD079
564500200528     C                   MOVEL     'SDCUFXPD'    FileName                                     CSD079
564600200528     C                   EXSR      GETRCDLN                                                   CSD079
564700200528     C                   Z-ADD     RecordLen     SDFXLn            4 0                        CSD079
564800200528                                                                                              CSD079
564900200528     C                   MOVEL     'SDCUFDPD'    FileName                                     CSD079
565000200528     C                   EXSR      GETRCDLN                                                   CSD079
565100200528     C                   Z-ADD     RecordLen     SDFDLn            4 0                        CSD079
565200200528                                                                                              CSD079
565300200528     C                   MOVEL     'SDRWANPD'    FileName                                     CSD079
565400200528     C                   EXSR      GETRCDLN                                                   CSD079
565500200528     C                   Z-ADD     RecordLen     SDRWLn            4 0                        CSD079
565600200528                                                                                              CSD079
565700200528     C                   MOVEL     'SDCUFOPD'    FileName                                     CSD079
565800200528     C                   EXSR      GETRCDLN                                                   CSD079
565900200528     C                   Z-ADD     RecordLen     SDFOLn            4 0                        CSD079
566000200528                                                                                              CSD079
566100200528     C                   MOVEL     'SDCUPMPD'    FileName                                     CSD079
566200200528     C                   EXSR      GETRCDLN                                                   CSD079
566300200528     C                   Z-ADD     RecordLen     SDPMLn            4 0                        CSD079
566400200528                                                                                              CSD079
566500200528     C                   MOVEL     'SDTICDPD'    FileName                                     CSD079
566600200528     C                   EXSR      GETRCDLN                                                   CSD079
566700200528     C                   Z-ADD     RecordLen     SDTILn            4 0                        CSD079
566800200528                                                                                              CSD079
566900200528     C                   MOVEL     'SDCUEXPD'    FileName
567000200528     C                   EXSR      GETRCDLN
567100200528     C                   Z-ADD     RecordLen     SDEXLn            4 0
567200200528
567300200528     C                   MOVEL     'SDCURXPD'    FileName                                     CSD079
567400200528     C                   EXSR      GETRCDLN                                                   CSD079
567500200528     C                   Z-ADD     RecordLen     SDCULn            4 0                        CSD079
567600200528                                                                                              CSD079
567700200528     C                   MOVEL     'SDCUSWPD'    FileName                                   BUG14992
567800200528     C                   EXSR      GETRCDLN                                                 BUG14992
567900200528     C                   Z-ADD     RecordLen     CUSWLn            4 0                      BUG14992
568000200528                                                                                            BUG14992
568100200528     C                   MOVEL     'SDCUAHDPD'   FileName                                     CER059
568200200528     C                   EXSR      GETRCDLN                                                   CER059
568300200528     C                   Z-ADD     500           CUA1Ln            4 0                        CER059
568400200528     C                   Z-ADD     500           CUA2Ln            4 0                        CER059
568500200528     C     RecordLen     SUB       1000          CUA3Ln            4 0                        CER059
568600200528                                                                                              CER059
568700200528     C                   MOVEL     'SDCCTXDPD'   FileName                                     CER059
568800200528     C                   EXSR      GETRCDLN                                                   CER059
568900200528     C                   Z-ADD     500           ACT1Ln            4 0                        CER059
569000200528     C                   Z-ADD     500           ACT2Ln            4 0                        CER059
569100200528     C                   Z-ADD     500           ACT3Ln            4 0                        CER059
569200200528     C                   Z-ADD     500           ACT4Ln            4 0                        CER059
569300200528     C                   Z-ADD     500           ACT5Ln            4 0                        CER059
569400200528     C     RecordLen     SUB       2500          ACT6Ln            4 0                        CER059
569500200528                                                                                              CER059
569600200528     C                   EVAL      CCTNLn1 = %LEN(CTNMFldDS1)                              AR1086546
569700200528     C                   MOVEL     *BLANKS       FileName                                  AR1086546
569800200528     C                   MOVEL     'SDCCTNPD'    FileName                                  AR1086546
569900200528     C                   EXSR      GETRCDLN                                                AR1086546
570000200528     C                   Z-ADD     RecordLen     CCTNLn            4 0                     AR1086546
570100200528     C                   EVAL      CCTNLn = CCTNLn - CCTNLn1                               AR1086546
570200200528                                                                                           AR1086546
570300200528     C                   EVAL      FileName = 'SDSW13PD'                                      CSW213
570400200528     C                   EXSR      GETRCDLN                                                   CSW213
570500200528     C                   EVAL      SW13Ln = RecordLen                                         CSW213
570600200528                                                                                              CSW213
570700200528     C                   EVAL      FileName = 'SDCUXCPD'                                      CGL132
570800200528     C                   EXSR      GETRCDLN                                                   CGL132
570900200528     C                   EVAL      CUXCLn = RecordLen                                         CGL132
571000200528                                                                                              CGL132
571100200528     C                   EVAL      FileName = 'SDFTCRPD'                                      CGL132
571200200528     C                   EXSR      GETRCDLN                                                   CGL132
571300200528     C                   EVAL      FTCRLn = RecordLen                                         CGL132
571400200528                                                                                              CGL132
571500200528     C                   EVAL      FileName = 'SDCRSSPD'                                      CGL157
571600200528     C                   EXSR      GETRCDLN                                                   CGL157
571700200528     C                   EVAL      CRSSLn = RecordLen                                         CGL157
571800200528                                                                                              CGL157
571900200528     C                   EVAL      FileName = 'SDCRDDPD'                                      CGL157
572000200528     C                   EXSR      GETRCDLN                                                   CGL157
572100200528     C                   Z-ADD     500           CRS01Ln           4 0                        CGL157
572200200528     C                   Z-ADD     500           CRS02Ln           4 0                        CGL157
572300200528     C                   Z-ADD     500           CRS03Ln           4 0                        CGL157
572400200528     C                   Z-ADD     500           CRS04Ln           4 0                        CGL157
572500200528     C                   Z-ADD     500           CRS05Ln           4 0                        CGL157
572600200528     C                   Z-ADD     500           CRS06Ln           4 0                        CGL157
572700200528     C                   Z-ADD     500           CRS07Ln           4 0                        CGL157
572800200528     C                   Z-ADD     500           CRS08Ln           4 0                        CGL157
572900200528     C                   Z-ADD     500           CRS09Ln           4 0                        CGL157
573000200528     C                   Z-ADD     500           CRS10Ln           4 0                        CGL157
573100200528     C                   Z-ADD     500           CRS11Ln           4 0                        CGL157
573200200528     C                   Z-ADD     500           CRS12Ln           4 0                        CGL157
573300200528     C                   Z-ADD     39            CRS13Ln           4 0                        CGL157
573400200528     C                   Z-ADD     500           CRS14Ln           4 0                        CGL157
573500200528     C     RecordLen     SUB       6539          CRS15Ln           4 0                        CGL157
573600200528                                                                                              CGL157
573700200528     C                   ENDSR
573800200528      *****************************************************************
573900200528      /SPACE 5
574000200528      *****************************************************************
574100200528      * GL Journal Entry Header Maintenance
574200200528      *****************************************************************
574300200528     C     BITHFmts      BEGSR
574400200528
574500200528     C                   MOVEL     *BLANKS       FileName
574600200528     C                   MOVEL     'GLBITHPD'    FileName
574700200528     C                   EXSR      GETRCDLN
574800200528     C                   Z-ADD     RecordLen     BITHLn            4 0
574900200528                                                                                              CAP086
575000200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
575100200528     C                   MOVEL     'GLJEIFPD'    FileName                                     CAP086
575200200528     C                   EXSR      GETRCDLN                                                   CAP086
575300200528     C                   Z-ADD     RecordLen     GLIFLn            4 0                        CAP086
575400200528
575500200528     C                   MOVEL     'GLBHEXPD'    FileName
575600200528     C                   EXSR      GETRCDLN
575700200528     C                   Z-ADD     RecordLen     BHEXLn            4 0
575800200528
575900200528     C                   ENDSR
576000200528      *****************************************************************
576100200528      /SPACE 5
576200200528      *****************************************************************
576300200528      * GL Journal Entry Item Maintenance
576400200528      *****************************************************************
576500200528     C     BITPFmts      BEGSR
576600200528
576700200528     C                   MOVEL     *BLANKS       FileName
576800200528     C                   MOVEL     'GLBITPPD'    FileName
576900200528     C                   EXSR      GETRCDLN
577000200528     C                   Z-ADD     RecordLen     BITPLn            4 0
577100200528      * Add SGD Nostro indicator, Branch Name, Branch Reference                               CMM121
577200200528     C**********         ADD       71            BITPLn                                CMM121 246418
577300200528      * Also add Additional Information Indicator                                             246418
577400200528     C**********         ADD       72            BITPLn                              246418 BUG28091
577500200528     C                   ADD       73            BITPLn                                     BUG28091
577600200528                                                                                              246418
577700200528     C                   MOVEL     *BLANKS       FileName                                     246418
577800200528     C                   MOVEL     'GLBITPXPD'   FileName                                     246418
577900200528     C                   EXSR      GETRCDLN                                                   246418
578000200528     C                   Z-ADD     RecordLen     BIPXLn            4 0                        246418
578100200528                                                                                              246418
578200200528
578300200528     C                   MOVEL     *BLANKS       FileName                                     246418
578400200528     C                   MOVEL     'GLBPRXPD'    FileName                                     CER001
578500200528     C                   EXSR      GETRCDLN                                                   CER001
578600200528     C                   Z-ADD     RecordLen     BPRXLn                                       CER001
578700200528                                                                                              CER001
578800200528     C                   MOVEL     *BLANKS       FileName                                     246418
578900200528     C                   MOVEL     'GLBPEXPD'    FileName
579000200528     C                   EXSR      GETRCDLN
579100200528     C                   Z-ADD     RecordLen     BPEXLn            4 0
579200200528     C/COPY OFCPYSRCZ,CGL135_045                                                             CGL135A
579300200528
579400200528     C                   ENDSR
579500200528      *****************************************************************
579600200528      /SPACE 5
579700200528      *****************************************************************
579800200528      * SD Securities Customers
579900200528      *****************************************************************
580000200528     C     SECDFmts      BEGSR
580100200528
580200200528     C                   MOVEL     *BLANKS       FileName
580300200528     C                   MOVEL     'SDSECDPD'    FileName
580400200528     C                   EXSR      GETRCDLN
580500200528     C                   Z-ADD     RecordLen     SDSCLn            4 0
580600200528
580700200528     C                   MOVEL     'SDSEEXPD'    FileName
580800200528     C                   EXSR      GETRCDLN
580900200528     C                   Z-ADD     RecordLen     SDSXLn            4 0
581000200528
581100200528     C                   ENDSR
581200200528      *****************************************************************
581300200528      /SPACE 5
581400200528      *****************************************************************
581500200528      * PM Portfolio Definition
581600200528      *****************************************************************
581700200528     C     PFDMFmts      BEGSR
581800200528
581900200528     C                   MOVEL     *BLANKS       FileName
582000200528     C                   MOVEL     'PMPFDMPD'    FileName
582100200528     C                   EXSR      GETRCDLN
582200200528     C                   Z-ADD     RecordLen     PMPMLn            4 0
582300200528
582400200528     C                   MOVEL     'PMPFEXPD'    FileName
582500200528     C                   EXSR      GETRCDLN
582600200528     C                   Z-ADD     RecordLen     PMEXLn            4 0
582700200528
582800200528     C                   ENDSR
582900200528      *****************************************************************
583000200528      /SPACE 5
583100200528      *****************************************************************
583200200528      * LE loans
583300200528      *****************************************************************
583400200528     C     LOANFmts      BEGSR
583500200528
583600200528     C                   MOVEL     *BLANKS       FileName
583700200528     C                   MOVEL     'LEN1MFPD'    FileName
583800200528     C                   EXSR      GETRCDLN
583900200528     C                   Z-ADD     RecordLen     LOANLn            4 0
584000200528
584100200528     C                   ENDSR
584200200528      *****************************************************************
584300200528      /SPACE 5
584400200528      *****************************************************************
584500200528      * MM Deal Amendments
584600200528      *****************************************************************
584700200528     C     DEAMFmts      BEGSR
584800200528
584900200528     C                   MOVEL     *BLANKS       FileName
585000200528     C                   MOVEL     'MMDEAMPD'    FileName
585100200528     C                   EXSR      GETRCDLN
585200200528     C                   Z-ADD     RecordLen     DEAMLn            4 0
585300200528
585400200528     C                   MOVEL     'MMDAIFPD'    FileName
585500200528     C                   EXSR      GETRCDLN
585600200528     C                   Z-ADD     RecordLen     DAIFLn            4 0
585700200528
585800200528     C                   MOVEL     'MMDAEXPD'    FileName
585900200528     C                   EXSR      GETRCDLN
586000200528     C                   Z-ADD     RecordLen     DAEXLn            4 0
586100200528
586200200528     C                   MOVEL     'SDCUCUPD'    FileName                                     CER043
586300200528     C                   EXSR      GETRCDLN                                                   CER043
586400200528     C                   Z-ADD     RecordLen     SDCULn                                       CER043
586500200528      *                                                                                       CER043
586600200528     C                   ENDSR
586700200528      *****************************************************************
586800200528      /SPACE 5
586900200528      *****************************************************************
587000200528      * LE Facilities Amendements
587100200528      *****************************************************************
587200200528     C     FAMDFmts      BEGSR
587300200528
587400200528     C                   MOVEL     *BLANKS       FileName
587500200528     C                   MOVEL     'LEFAMDPD'    FileName
587600200528     C                   EXSR      GETRCDLN
587700200528     C                   Z-ADD     RecordLen     FAMDLn            4 0
587800200528                                                                                              CAP086
587900200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
588000200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
588100200528     C                   EXSR      GETRCDLN                                                   CAP086
588200200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
588300200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
588400200528     C                   MOVEL     'LEFAM2PD'    FileName                                     CLE106
588500200528     C                   EXSR      GETRCDLN                                                   CLE106
588600200528     C                   Z-ADD     RecordLen     FAM2Ln            4 0                        CLE106
588700200528
588800200528     C                   ENDSR
588900200528      *****************************************************************
589000200528      /SPACE 5
589100200528      *****************************************************************
589200200528      * GL Collateral Details
589300200528      *****************************************************************
589400200528     C     COLLFmts      BEGSR
589500200528
589600200528     C                   MOVEL     *BLANKS       FileName
589700200528     C                   MOVEL     'GLCOL1PD'    FileName
589800200528     C                   EXSR      GETRCDLN
589900200528     C                   Z-ADD     RecordLen     COL1Ln            4 0
590000200528
590100200528     C                   MOVEL     *BLANKS       FileName
590200200528     C                   MOVEL     'GLCOL2PD'    FileName
590300200528     C                   EXSR      GETRCDLN
590400200528     C                   Z-ADD     RecordLen     COL2Ln            4 0
590500200528
590600200528     C                   MOVEL     *BLANKS       FileName
590700200528     C                   MOVEL     'GLCOL3PD'    FileName
590800200528     C                   EXSR      GETRCDLN
590900200528     C                   Z-ADD     RecordLen     COL3Ln            4 0
591000200528
591100200528     C                   MOVEL     *BLANKS       FileName
591200200528     C                   MOVEL     'GLCOL4PD'    FileName
591300200528     C                   EXSR      GETRCDLN
591400200528     C                   Z-ADD     RecordLen     COL4Ln            4 0
591500200528
591600200528     C                   ENDSR
591700200528      *****************************************************************
591800200528      /SPACE 5
591900200528      ****************************************************************
592000200528      * GL Collateral Allocations
592100200528      ****************************************************************
592200200528     C     COLAFmts      BEGSR
592300200528
592400200528     C                   MOVEL     *BLANKS       FileName
592500200528     C                   MOVEL     'GLSCLAPD'    FileName
592600200528     C                   EXSR      GETRCDLN
592700200528     C                   Z-ADD     RecordLen     COLALn            4 0
592800200528
592900200528     C                   ENDSR
593000200528      ****************************************************************
593100200528      /SPACE 5
593200200528      *****************************************************************
593300200528      * LE Facilities Details
593400200528      *****************************************************************
593500200528     C     FCIPFmts      BEGSR
593600200528
593700200528     C                   MOVEL     *BLANKS       FileName
593800200528     C                   MOVEL     'LEFCPPPD'    FileName
593900200528     C                   EXSR      GETRCDLN
594000200528     C                   Z-ADD     RecordLen     FCI1Ln            4 0
594100200528
594200200528     C                   MOVEL     *BLANKS       FileName
594300200528     C                   MOVEL     'LEFCSPPD'    FileName
594400200528     C                   EXSR      GETRCDLN
594500200528     C                   Z-ADD     RecordLen     FCI2Ln            4 0
594600200528                                                                                              CAP086
594700200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
594800200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
594900200528     C                   EXSR      GETRCDLN                                                   CAP086
595000200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
595100200528                                                                                              CLE106
595200200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
595300200528     C                   MOVEL     'LEFCXPPD'    FileName                                     CLE106
595400200528     C                   EXSR      GETRCDLN                                                   CLE106
595500200528     C                   Z-ADD     RecordLen     FCI7Ln            4 0                        CLE106
595600200528                                                                                              CLE106
595700200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
595800200528     C                   MOVEL     'LEFCZPPD'    FileName                                     CLE106
595900200528     C                   EXSR      GETRCDLN                                                   CLE106
596000200528     C                   Z-ADD     RecordLen     FCI9Ln            4 0                        CLE106
596100200528                                                                                            BUG10093
596200200528     C                   MOVEL     'LEFCNTPD'    FileName                                   BUG10093
596300200528     C                   EXSR      GETRCDLN                                                 BUG10093
596400200528     C                   Z-ADD     RecordLen     FCRNLn                                     BUG10093
596500200528
596600200528     C                   MOVEL     'LEFCRXPD'    FileName                                     CER001
596700200528     C                   EXSR      GETRCDLN                                                   CER001
596800200528     C                   Z-ADD     RecordLen     FCRXLn                                       CER001
596900200528                                                                                              CER001
597000200528     C                   MOVEL     'LEFCEXPD'    FileName
597100200528     C                   EXSR      GETRCDLN
597200200528     C                   Z-ADD     RecordLen     FCEXLn            4 0
597300200528
597400200528     C                   ENDSR
597500200528      *****************************************************************
597600200528      /SPACE 5
597700200528      *****************************************************************
597800200528      * LE Loan Details
597900200528      *****************************************************************
598000200528     C     CLIPFmts      BEGSR
598100200528
598200200528     C                   MOVEL     *BLANKS       FileName
598300200528     C                   MOVEL     'LECLI1PD'    FileName
598400200528     C                   EXSR      GETRCDLN
598500200528     C                   Z-ADD     RecordLen     CLI1Ln            4 0
598600200528
598700200528     C                   MOVEL     *BLANKS       FileName
598800200528     C                   MOVEL     'LECLI2PD'    FileName
598900200528     C                   EXSR      GETRCDLN
599000200528     C                   Z-ADD     RecordLen     CLI2Ln            4 0
599100200528
599200200528     C                   MOVEL     *BLANKS       FileName
599300200528     C                   MOVEL     'LECLI3PD'    FileName
599400200528     C                   EXSR      GETRCDLN
599500200528     C                   Z-ADD     RecordLen     CLI3Ln            4 0
599600200528
599700200528     C                   MOVEL     *BLANKS       FileName
599800200528     C                   MOVEL     'LECLI4PD'    FileName
599900200528     C                   EXSR      GETRCDLN
600000200528     C                   Z-ADD     RecordLen     CLI4Ln            4 0
600100200528                                                                                              CAP086
600200200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
600300200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
600400200528     C                   EXSR      GETRCDLN                                                   CAP086
600500200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
600600200528                                                                                              CLE106
600700200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
600800200528     C                   MOVEL     'LECLI5PD'    FileName                                     CLE106
600900200528     C                   EXSR      GETRCDLN                                                   CLE106
601000200528     C                   Z-ADD     RecordLen     CLI5Ln            4 0                        CLE106
601100200528      * Add Asset code and Health Code                                          CLE120
601200200528      *                                                                         CLE120
601300200528     C**********         ADD       8             CLI4Ln                                CLE120 CLE106
601400200528     C                   ADD       8             CLI5Ln                                       CLE106
601500200528
601600200528     C                   MOVEL     'LECLRXPD'    FileName                                     CER001
601700200528     C                   EXSR      GETRCDLN                                                   CER001
601800200528     C                   Z-ADD     RecordLen     CLRXLn                                       CER001
601900200528                                                                                              CER001
602000200528     C                   MOVEL     'LECLEXPD'    FileName
602100200528     C                   EXSR      GETRCDLN
602200200528     C                   Z-ADD     RecordLen     CLEXLn            4 0
602300200528      *                                                                                     MD054028
602400200528     C                   Z-ADD     24            CLCR50Ln          4 0                      MD054028
602500200528                                                                                              CER049
602600200528     C                   MOVEL     *BLANKS       FileName                                     CER049
602700200528     C                   MOVEL     'LESTMP2PD'   FileName                                     CER049
602800200528     C                   EXSR      GETRCDLN                                                   CER049
602900200528     C                   Z-ADD     RecordLen     CLIQLn            4 0                        CER049
603000200528                                                                                              CER049
603100200528     C                   MOVEL     *BLANKS       FileName                                  AR1021983
603200200528     C                   MOVEL     'LECLI6PD'    FileName                                  AR1021983
603300200528     C                   EXSR      GETRCDLN                                                AR1021983
603400200528     C                   Z-ADD     RecordLen     CLI6Ln            4 0                     AR1021983
603500200528
603600200528     C                   MOVEL     *BLANKS       FileName                                     CLE141
603700200528     C                   MOVEL     'LECLI7PD'    FileName                                     CLE141
603800200528     C                   EXSR      GETRCDLN                                                   CLE141
603900200528     C                   Z-ADD     RecordLen     CLI7Ln            4 0                        CLE141
604000200528
604100200528     C                   ENDSR
604200200528      *****************************************************************
604300200528      /SPACE 5
604400200528      *****************************************************************
604500200528      * LE Rollover Instructions
604600200528      *****************************************************************
604700200528     C     LERIFmts      BEGSR
604800200528
604900200528     C                   MOVEL     *BLANKS       FileName
605000200528     C                   MOVEL     'LELERIPD'    FileName
605100200528     C                   EXSR      GETRCDLN
605200200528     C                   Z-ADD     RecordLen     LERILn            4 0
605300200528
605400200528     C                   MOVEL     *BLANKS       FileName
605500200528     C                   MOVEL     'LELERI2PD'   FileName
605600200528     C                   EXSR      GETRCDLN
605700200528     C                   Z-ADD     RecordLen     LER2Ln            4 0
605800200528
605900200528     C                   MOVEL     *BLANKS       FileName                                      BUG19
606000200528     C                   MOVEL     'LELERI3PD'   FileName                                      BUG19
606100200528     C                   EXSR      GETRCDLN                                                    BUG19
606200200528     C                   Z-ADD     RecordLen     LER3Ln            4 0                         BUG19
606300200528                                                                                              CAP086
606400200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
606500200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
606600200528     C                   EXSR      GETRCDLN                                                   CAP086
606700200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
606800200528                                                                                               BUG19
606900200528     C                   MOVEL     *BLANKS       FileName
607000200528     C                   MOVEL     'LELEEXPD'    FileName
607100200528     C                   EXSR      GETRCDLN
607200200528     C                   Z-ADD     RecordLen     LEEXLn            4 0
607300200528
607400200528     C                   ENDSR
607500200528      *****************************************************************
607600200528      /SPACE 5
607700200528      *****************************************************************
607800200528      * LE Repayment schedule
607900200528      *****************************************************************
608000200528     C     RPSCFmts      BEGSR
608100200528
608200200528     C                   MOVEL     *BLANKS       FileName
608300200528     C                   MOVEL     'LERPSCPD'    FileName
608400200528     C                   EXSR      GETRCDLN
608500200528     C                   Z-ADD     RecordLen     RPSCLn            4 0
608600200528                                                                                              CAP086
608700200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
608800200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
608900200528     C                   EXSR      GETRCDLN                                                   CAP086
609000200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
609100200528
609200200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
609300200528     C                   MOVEL     'LERPS2PD'    FileName                                     CLE106
609400200528     C                   EXSR      GETRCDLN                                                   CLE106
609500200528     C                   Z-ADD     RecordLen     RPS2Ln            4 0                        CLE106
609600200528                                                                                              CLE106
609700200528     C                   MOVEL     'LERPEXPD'    FileName
609800200528     C                   EXSR      GETRCDLN
609900200528     C                   Z-ADD     RecordLen     RPEXLn            4 0
610000200528
610100200528
610200200528     C                   ENDSR
610300200528      *****************************************************************
610400200528      /SPACE 5
610500200528      *****************************************************************
610600200528      * LE Loam Amendments
610700200528      *****************************************************************
610800200528     C     LOAMFmts      BEGSR
610900200528
611000200528     C                   MOVEL     *BLANKS       FileName
611100200528     C                   MOVEL     'LELOAMPD'    FileName
611200200528     C                   EXSR      GETRCDLN
611300200528     C                   Z-ADD     RecordLen     LOAMLn            4 0
611400200528                                                                                              CAP086
611500200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
611600200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
611700200528     C                   EXSR      GETRCDLN                                                   CAP086
611800200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
611900200528
612000200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
612100200528     C                   MOVEL     'LELOA2PD'    FileName                                     CLE106
612200200528     C                   EXSR      GETRCDLN                                                   CLE106
612300200528     C                   Z-ADD     RecordLen     LOA2Ln            4 0                        CLE106
612400200528                                                                                              CLE106
612500200528     C                   MOVEL     'LELOEXPD'    FileName
612600200528     C                   EXSR      GETRCDLN
612700200528     C                   Z-ADD     RecordLen     LOEXLn            4 0
612800200528
612900200528
613000200528     C                   ENDSR
613100200528      *****************************************************************
613200200528      /SPACE 5
613300200528      *****************************************************************
613400200528      * LE Manual Repayment
613500200528      *****************************************************************
613600200528     C     MAPYFmts      BEGSR
613700200528
613800200528     C                   MOVEL     *BLANKS       FileName
613900200528     C                   MOVEL     'LEMAPYPD'    FileName
614000200528     C                   EXSR      GETRCDLN
614100200528     C                   Z-ADD     RecordLen     MAPYLn            4 0
614200200528                                                                                              CAP086
614300200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
614400200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
614500200528     C                   EXSR      GETRCDLN                                                   CAP086
614600200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
614700200528
614800200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
614900200528     C                   MOVEL     'LEMAP2PD'    FileName                                     CLE106
615000200528     C                   EXSR      GETRCDLN                                                   CLE106
615100200528     C                   Z-ADD     RecordLen     MAP2Ln            4 0                        CLE106
615200200528                                                                                              CLE106
615300200528     C**********         Z-ADD     1             UpSRLn            1 0            AR1080805 MD020445
615400200528     C                   Z-ADD     1             UpSRLn            1 0                      MD020733
615500200528     C                   Z-ADD     1             DDAuLn            1 0                        CLE164
615600200528      **********                                                                  AR1080805 MD020445
615700200528     C                   MOVEL     'LEMAEXPD'    FileName
615800200528     C                   EXSR      GETRCDLN
615900200528     C                   Z-ADD     RecordLen     MAEXLn            4 0
616000200528
616100200528
616200200528     C                   ENDSR
616300200528      *****************************************************************
616400200528      /SPACE 5
616500200528      *****************************************************************
616600200528      * SD Base rates
616700200528      *****************************************************************
616800200528     C     BSRTFmts      BEGSR
616900200528
617000200528     C                   MOVEL     *BLANKS       FileName
617100200528     C                   MOVEL     'SDBSRSPD'    FileName
617200200528     C                   EXSR      GETRCDLN
617300200528     C                   Z-ADD     RecordLen     BSRTLn            4 0
617400200528
617500200528     C                   MOVEL     *BLANKS       FileName
617600200528     C                   MOVEL     'SDBSEXPD'    FileName
617700200528     C                   EXSR      GETRCDLN
617800200528     C                   Z-ADD     RecordLen     BSEXLn            4 0
617900200528
618000200528     C                   ENDSR
618100200528      *****************************************************************                       CSD093
618200200528      /SPACE 5                                                                                CSD093
618300200528      *****************************************************************                       CSD093
618400200528      * SD Document Management                                                                CSD093
618500200528      *****************************************************************                       CSD093
618600200528     C     DCMTFmts      BEGSR                                                                CSD093
618700200528                                                                                              CSD093
618800200528     C                   MOVEL     *BLANKS       FileName                                     CSD093
618900200528     C                   MOVEL     'SDDCMSPD'    FileName                                     CSD093
619000200528     C                   EXSR      GETRCDLN                                                   CSD093
619100200528     C                   Z-ADD     RecordLen     DCMTLn            4 0                        CSD093
619200200528                                                                                              CSD093
619300200528     C                   MOVEL     *BLANKS       FileName                                     CSD093
619400200528     C                   MOVEL     'SDDCMXPD'    FileName                                     CSD093
619500200528     C                   EXSR      GETRCDLN                                                   CSD093
619600200528     C                   Z-ADD     RecordLen     DCMXLn            4 0                        CSD093
619700200528                                                                                              CSD093
619800200528     C                   ENDSR                                                                CSD093
619900200528      *****************************************************************                       CSD092
620000200528      /SPACE 5                                                                                CSD092
620100200528      *****************************************************************                       CSD092
620200200528      * SD Account Review                                             *                       CSD092
620300200528      *****************************************************************                       CSD092
620400200528     C     ACRFFmts      BEGSR                                                                CSD092
620500200528                                                                                              CSD092
620600200528     C                   MOVEL     *BLANKS       FileName                                     CSD092
620700200528     C                   MOVEL     'SDACRFPD'    FileName                                     CSD092
620800200528     C                   EXSR      GETRCDLN                                                   CSD092
620900200528     C                   Z-ADD     RecordLen     ACRFLn                                       CSD092
621000200528                                                                                              CSD092
621100200528     C                   MOVEL     'SDACEXPD'    FileName                                     CSD092
621200200528     C                   EXSR      GETRCDLN                                                   CSD092
621300200528     C                   Z-ADD     RecordLen     ACEXLn                                       CSD092
621400200528                                                                                              CSD092
621500200528     C                   ENDSR                                                                CSD092
621600200528      *****************************************************************
621700200528      /SPACE 5
621800200528      ****************************************************************                       BUG1100
621900200528      * LE Fees Master file                                                                  BUG1100
622000200528      ****************************************************************                       BUG1100
622100200528     C     FEEMFmts      BEGSR                                                               BUG1100
622200200528                                                                                             BUG1100
622300200528     C                   MOVEL     *BLANKS       FileName                                    BUG1100
622400200528                                                                                             BUG1100
622500200528     C                   MOVEL     'LEFEEMPD'    FileName                                    BUG1100
622600200528     C                   EXSR      GETRCDLN                                                  BUG1100
622700200528     C                   Z-ADD     RecordLen     FEEMLn            4 0                       BUG1100
622800200528                                                                                             BUG1100
622900200528     C                   MOVEL     'LEFEEM2PD'   FileName                                    BUG1100
623000200528     C                   EXSR      GETRCDLN                                                  BUG1100
623100200528     C                   Z-ADD     RecordLen     FEEM2Ln           4 0                       BUG1100
623200200528                                                                                              CAP086
623300200528     C                   MOVEL     *BLANKS       FileName                                     CER049
623400200528     C                   MOVEL     'LESTMPPD'    FileName                                     CER049
623500200528     C                   EXSR      GETRCDLN                                                   CER049
623600200528     C                   Z-ADD     RecordLen     LESTMLn           4 0                        CER049
623700200528                                                                                              CER049
623800200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
623900200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
624000200528     C                   EXSR      GETRCDLN                                                   CAP086
624100200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
624200200528                                                                                             BUG1100
624300200528     C                   MOVEL     *BLANKS       FileName                                    BUG1100
624400200528     C                   MOVEL     'LEFEEXPD'    FileName                                    BUG1100
624500200528     C                   EXSR      GETRCDLN                                                  BUG1100
624600200528     C                   Z-ADD     RecordLen     FEEXLn            4 0                       BUG1100
624700200528                                                                                             BUG1100
624800200528     C                   ENDSR                                                               BUG1100
624900200528      ****************************************************************                       BUG1100
625000200528      /SPACE 5                                                                               BUG1100
625100200528      ****************************************************************
625200200528      * LE Fee Adjustments
625300200528      ****************************************************************
625400200528     C     FEADFmts      BEGSR
625500200528
625600200528     C                   MOVEL     *BLANKS       FileName
625700200528     C                   MOVEL     'LEFEADPD'    FileName
625800200528     C                   EXSR      GETRCDLN
625900200528     C                   Z-ADD     RecordLen     FEADLn            4 0
626000200528                                                                                              CAP086
626100200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
626200200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
626300200528     C                   EXSR      GETRCDLN                                                   CAP086
626400200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
626500200528
626600200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
626700200528     C                   MOVEL     'LEFEA2PD'    FileName                                     CLE106
626800200528     C                   EXSR      GETRCDLN                                                   CLE106
626900200528     C                   Z-ADD     RecordLen     FEA2Ln            4 0                        CLE106
627000200528                                                                                              CLE106
627100200528     C                   ENDSR
627200200528      ****************************************************************
627300200528      /SPACE 5
627400200528      ****************************************************************
627500200528      * LE Fee settlement
627600200528      ****************************************************************
627700200528     C     FESTFmts      BEGSR
627800200528
627900200528     C                   MOVEL     *BLANKS       FileName
628000200528     C                   MOVEL     'LEFESTPD'    FileName
628100200528     C                   EXSR      GETRCDLN
628200200528     C                   Z-ADD     RecordLen     FESTLn            4 0
628300200528                                                                                              CAP086
628400200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
628500200528     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
628600200528     C                   EXSR      GETRCDLN                                                   CAP086
628700200528     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
628800200528
628900200528     C                   MOVEL     *Blanks       FileName                                     CLE106
629000200528     C                   MOVEL     'LEFES2PD'    FileName                                     CLE106
629100200528     C                   EXSR      GETRCDLN                                                   CLE106
629200200528     C                   Z-ADD     RecordLen     FES2Ln            4 0                        CLE106
629300200528     C                   ENDSR
629400200528      ****************************************************************
629500200528      /SPACE 5
629600200528      ****************************************************************
629700200528      * LE Funding Partcipant
629800200528      ****************************************************************
629900200528     C     FPRTFmts      BEGSR
630000200528
630100200528     C                   MOVEL     *BLANKS       FileName
630200200528     C                   MOVEL     'LEFPRTPD'    FileName
630300200528     C                   EXSR      GETRCDLN
630400200528     C                   Z-ADD     RecordLen     FPRTLn            4 0
630500200528
630600200528     C                   ENDSR
630700200528      ****************************************************************
630800200528      /SPACE 5
630900200528      ****************************************************************
631000200528      * LE Assignments
631100200528      ****************************************************************
631200200528     C     ASGNFmts      BEGSR
631300200528
631400200528     C                   MOVEL     *BLANKS       FileName
631500200528     C                   MOVEL     'LEASGNPD'    FileName
631600200528     C                   EXSR      GETRCDLN
631700200528     C                   Z-ADD     RecordLen     ASGNLn            4 0
631800200528
631900200528     C                   ENDSR
632000200528      ****************************************************************
632100200528      /SPACE 5
632200200528      ****************************************************************
632300200528      * IR Forward Rate Agreements
632400200528      ****************************************************************
632500200528     C     FRAFmts       BEGSR
632600200528
632700200528     C                   MOVEL     *BLANKS       FileName
632800200528     C                   MOVEL     'IRFRAPD'     FileName
632900200528     C                   EXSR      GETRCDLN
633000200528     C                   Z-ADD     RecordLen     FRALn             4 0
633100200528      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG6512
633200200528     C                   ADD       6             FRALn                                       BUG6512
633300200528
633400200528      ** Fwd Rate Agreement Interface Data Format Definition Layout                         BUG18701
633500200528     C                   MOVEL     'IRFRIFPD'    FileName                                   BUG18701
633600200528     C                   EXSR      GETRCDLN                                                 BUG18701
633700200528     C                   Z-ADD     RecordLen     IRFRLn            4 0                      BUG18701
633800200528                                                                                            BUG18701
633900200528     C                   ENDSR
634000200528      ****************************************************************
634100200528      /SPACE 5
634200200528      *****************************************************************
634300200528      *  IR Single Currency IRS                                       *
634400200528      *****************************************************************
634500200528     C     SIRSFmts      BEGSR
634600200528
634700200528     C                   MOVEL     *BLANKS       FileName
634800200528     C                   MOVEL     'IRSIRSPD'    FileName
634900200528     C                   EXSR      GETRCDLN
635000200528     C                   Z-ADD     RecordLen     SIRSLn            4 0
635100200528     C**********         MOVEL     'IRDTSCPD'    FileName                                    BUG4646
635200200528     C**********         EXSR      GETRCDLN                                                  BUG4646
635300200528     C**********         Z-ADD     RecordLen     DTORLn            4 0                       BUG4646
635400200528     C**********         Z-ADD     RecordLen     DTOPLn            4 0                       BUG4646
635500200528     C**********         Z-ADD     RecordLen     DTTRLn            4 0                       BUG4646
635600200528     C**********         Z-ADD     RecordLen     DTTPLn            4 0                       BUG4646
635700200528     C**********         MOVEL     'IRSSEXPD'    FileName                                    BUG4646
635800200528     C**********         EXSR      GETRCDLN                                                  BUG4646
635900200528     C**********         Z-ADD     RecordLen     IRSSLn            4 0                       BUG4646
636000200528                                                                                             BUG6671
636100200528      ** IR Single Currency Interface Data Format Definition Layout                          BUG6671
636200200528                                                                                             BUG6671
636300200528     C                   MOVEL     'IRRSIFPD'    FileName                                    BUG6671
636400200528     C                   EXSR      GETRCDLN                                                  BUG6671
636500200528     C                   Z-ADD     RecordLen     IRRSLn            4 0                       BUG6671
636600200528                                                                                             BUG6671
636700200528      ** IR IRS Single Ccy Extra Data file (50 byte narrative text plus any                  BUG6671
636800200528      ** custom info)                                                                        BUG6671
636900200528                                                                                             BUG6671
637000200528     C                   MOVEL     'IRSSEXPD'    FileName                                    BUG6671
637100200528     C                   EXSR      GETRCDLN                                                  BUG6671
637200200528     C                   Z-ADD     RecordLen     IRSSLn            4 0                       BUG6671
637300200528
637400200528     C                   ENDSR
637500200528      ****************************************************************
637600200528      /SPACE 5
637700200528      ****************************************************************
637800200528      *  IR Cross Currency IRS
637900200528      ****************************************************************
638000200528     C     CIRSFmts      BEGSR
638100200528
638200200528     C                   MOVEL     *BLANKS       FileName
638300200528     C                   MOVEL     'IRCIRSPD'    FileName
638400200528     C                   EXSR      GETRCDLN
638500200528     C                   Z-ADD     RecordLen     CIRSLn            4 0
638600200528
638700200528      ** IR Cross Currency Interface Data Format Definition Layout
638800200528
638900200528     C                   MOVEL     'IRRXIFPD'    FileName
639000200528     C                   EXSR      GETRCDLN
639100200528     C                   Z-ADD     RecordLen     IRRXLn            4 0
639200200528
639300200528      ** IR IRS Cross Ccy Extra Data file (50 byte narrative text plus any
639400200528      ** custom info)
639500200528
639600200528     C                   MOVEL     'IRCSEXPD'    FileName
639700200528     C                   EXSR      GETRCDLN
639800200528     C                   Z-ADD     RecordLen     IRCSLn            4 0
639900200528     C                   Z-ADD     0             IRCS2Ln           4 0                      MD029663
640000200528     C                   Z-ADD     0             IRCS3Ln           4 0                      MD029663
640100200528
640200200528     C                   ENDSR
640300200528      ****************************************************************
640400200528      /SPACE 5
640500200528      ****************************************************************
640600200528      * SE Securities Detail
640700200528      ****************************************************************
640800200528     C     SECSFmts      BEGSR
640900200528
641000200528     C                   MOVEL     'SESEC1PD  '  Filename
641100200528     C                   EXSR      GETRCDLN
641200200528     C                   Z-ADD     Recordlen     SEC1Ln            4 0
641300200528      *
641400200528     C                   MOVEL     'SESEC2PD  '  Filename
641500200528     C                   EXSR      GETRCDLN
641600200528     C                   Z-ADD     Recordlen     SEC2Ln            4 0
641700200528      *
641800200528     C                   MOVEL     'SESEC3PD  '  Filename
641900200528     C                   EXSR      GETRCDLN
642000200528     C                   Z-ADD     Recordlen     SEC3Ln            4 0
642100200528      *
642200200528     C                   MOVEL     'SESEC4PD  '  Filename
642300200528     C                   EXSR      GETRCDLN
642400200528     C                   Z-ADD     Recordlen     SEC4Ln            4 0
642500200528     C                   MOVEL     'SESEC5PD  '  Filename
642600200528     C                   EXSR      GETRCDLN
642700200528     C                   Z-ADD     Recordlen     SEC5Ln            4 0
642800200528      *                                                                                       CSE071
642900200528     C                   MOVEL     'SESEC6PD  '  Filename                                     CSE071
643000200528     C                   EXSR      GETRCDLN                                                   CSE071
643100200528     C                   Z-ADD     Recordlen     SEC6Ln            4 0                        CSE071
643200200528                                                                                              CER001
643300200528     C                   MOVEL     'SESERXPD  '  Filename                                     CER001
643400200528     C                   EXSR      GETRCDLN                                                   CER001
643500200528     C                   Z-ADD     Recordlen     SERXLn                                       CER001
643600200528      *
643700200528      ** Get record length of Extra Data Layout file for SE
643800200528      ** Securities - API.
643900200528      *
644000200528     C                   MOVEL     'SESEEXPD  '  Filename
644100200528     C                   EXSR      GETRCDLN
644200200528     C                   Z-ADD     Recordlen     SEEXLn            4 0
644300200528                                                                                             BUG5988
644400200528     C                   EVAL      SECSFLn = %LEN(SECSFldDS1)                                BUG5988
644500200528
644600200528
644700200528     C                   ENDSR
644800200528      ****************************************************************
644900200528      /SPACE 5
645000200528      ****************************************************************
645100200528      * SE Securities Trade
645200200528      ****************************************************************
645300200528     C     TRADFmts      BEGSR
645400200528
645500200528      ** SE Trade: Primary, Secondary, Exchange Rates, Settlement Details,
645600200528      **           Charges & Commissions, SWIFT Details
645700200528
645800200528     C                   MOVEL     'SETRPRPD'    FileName
645900200528     C                   EXSR      GETRCDLN
646000200528     C                   Z-ADD     RecordLen     TRPRLn            4 0
646100200528     C                   MOVEL     'SETRSEPD'    FileName
646200200528     C                   EXSR      GETRCDLN
646300200528     C                   Z-ADD     RecordLen     TRSELn            4 0
646400200528     C                   MOVEL     'SETRPVPD'    FileName                                   BUG11194
646500200528     C                   EXSR      GETRCDLN                                                 BUG11194
646600200528     C                   Z-ADD     RecordLen     TRPVLn            4 0                      BUG11194
646700200528     C                   MOVEL     'SETREXPD'    FileName
646800200528     C                   EXSR      GETRCDLN
646900200528     C                   Z-ADD     RecordLen     TREXLn            4 0
647000200528     C                   MOVEL     'SETRSTPD'    FileName
647100200528     C                   EXSR      GETRCDLN
647200200528     C                   Z-ADD     RecordLen     TRSTLn            4 0
647300200528     C                   MOVEL     'SETRCCPD'    FileName
647400200528     C                   EXSR      GETRCDLN
647500200528     C                   Z-ADD     RecordLen     TRCCLn            4 0
647600200528     C                   MOVEL     'SETRSWPD'    FileName
647700200528     C                   EXSR      GETRCDLN
647800200528     C                   Z-ADD     RecordLen     TRSWLn            4 0
647900200528     C                   MOVEL     'SETESDPD'    FileName
648000200528     C                   EXSR      GETRCDLN
648100200528     C                   Z-ADD     RecordLen     TRX2Ln            4 0
648200200528     C                   EVAL      TRX2Ln = TRX2Ln * 2
648300200528
648400200528      *  Hedge Accounting file
648500200528
648600200528     C                   MOVEL     'SETRTHPD'    FileName
648700200528     C                   EXSR      GETRCDLN
648800200528     C                   Z-ADD     RecordLen     TRHALn            4 0
648900200528
649000200528      ** SE Trades Interface Data  Format Definition Layout
649100200528      ** (50 byte narrative text plus any custom info)
649200200528
649300200528     C                   MOVEL     'SETRIFPD'    FileName
649400200528     C                   EXSR      GETRCDLN
649500200528     C                   Z-ADD     RecordLen     SETILn            4 0
649600200528
649700200528     C                   MOVEL     'SETDRXPD'    FileName                                     CER001
649800200528     C                   EXSR      GETRCDLN                                                   CER001
649900200528     C                   Z-ADD     RecordLen     TDRXLn                                       CER001
650000200528                                                                                              CER001
650100200528     C                   MOVEL     'SETRAXPD'    FileName                                    BUG9584
650200200528     C                   EXSR      GETRCDLN                                                  BUG9584
650300200528     C                   Z-ADD     RecordLen     TDAXLn                                      BUG9584
650400200528                                                                                             BUG9584
650500200528      ** SE Trades Extra Data file (50 byte narrative text plus any
650600200528      ** custom info)
650700200528
650800200528     C                   MOVEL     'SETDEXPD'    FileName
650900200528     C                   EXSR      GETRCDLN
651000200528     C                   Z-ADD     RecordLen     SETRLn            4 0
651100200528
651200200528     C                   ENDSR
651300200528      ****************************************************************
651400200528      /SPACE 5
651500200528      ****************************************************************
651600200528      * SE Depot Movements
651700200528      ****************************************************************
651800200528     C     DPMVFmts      BEGSR
651900200528
652000200528
652100200528     C                   MOVEL     'SEDMIDPD'    FileName
652200200528     C                   EXSR      GETRCDLN
652300200528     C                   Z-ADD     RecordLen     DMWILn            4 0
652400200528      *  Depot Movement SWIFT Messages Infomation
652500200528     C                   MOVEL     'SEDMESPD'    FileName
652600200528     C                   EXSR      GETRCDLN
652700200528     C                   Z-ADD     RecordLen     DMesLn            4 0
652800200528
652900200528     C                   MOVEL     'SEDMAXPD'    FileName                                    BUG9089
653000200528     C                   EXSR      GETRCDLN                                                  BUG9089
653100200528     C                   Z-ADD     RecordLen     DMAXLn            4 0                       BUG9089
653200200528     C                   MOVEL     'SEDMRXPD'    FileName                                     CER001
653300200528     C                   EXSR      GETRCDLN                                                   CER001
653400200528     C                   Z-ADD     RecordLen     DMRXLn                                       CER001
653500200528                                                                                              CER001
653600200528      ** SE Depot Movements file (50 byte narrative text plus any
653700200528      ** custom info)
653800200528
653900200528     C                   MOVEL     'SEDMEXPD'    FileName
654000200528     C                   EXSR      GETRCDLN
654100200528     C                   Z-ADD     RecordLen     DMEXLn            4 0
654200200528
654300200528     C                   ENDSR
654400200528      ****************************************************************
654500200528      /SPACE 5
654600200528      *****************************************************************
654700200528      * MM Negotiable Assets Purchased
654800200528      *****************************************************************
654900200528     C     NASPFmts      BEGSR
655000200528
655100200528     C                   MOVEL     *BLANKS       FileName
655200200528     C                   MOVEL     'MMNASPPD'    FileName
655300200528     C                   EXSR      GETRCDLN
655400200528     C                   Z-ADD     RecordLen     NASPLn            4 0
655500200528      *                                                                                       BUG629
655600200528      ** Add field size for Deal Status (DDSTS) for TRANS1 mapping.                           BUG629
655700200528      ** (note: DDSTS was added in MMNASPVU to be passed to Java)                             BUG629
655800200528     C                   ADD       24            NASPLn                                       BUG629
655900200528      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG6512
656000200528     C                   ADD       6             NASPLn                                      BUG6512
656100200528                                                                                              CAP086
656200200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
656300200528     C                   MOVEL     'MMNAIFPD'    FileName                                     CAP086
656400200528     C                   EXSR      GETRCDLN                                                   CAP086
656500200528     C                   Z-ADD     RecordLen     NAIFLn            4 0                        CAP086
656600200528
656700200528     C                   MOVEL     'MMNPEXPD'    FileName
656800200528     C                   EXSR      GETRCDLN
656900200528     C                   Z-ADD     RecordLen     NPEXLn            4 0
657000200528                                                                                              CER001
657100200528     C                   MOVEL     'MMNPRXPD'    FileName                                     CER001
657200200528     C                   EXSR      GETRCDLN                                                   CER001
657300200528     C                   Z-ADD     RecordLen     NPRXLn                                       CER001
657400200528
657500200528     C                   ENDSR
657600200528      *****************************************************************
657700200528      /SPACE 5
657800200528      *****************************************************************
657900200528      * MM Negotiable Assets Sold
658000200528      *****************************************************************
658100200528     C     NASSFmts      BEGSR
658200200528
658300200528     C                   MOVEL     *BLANKS       FileName
658400200528     C                   MOVEL     'MMNASSPD'    FileName
658500200528     C                   EXSR      GETRCDLN
658600200528     C                   Z-ADD     RecordLen     NASSLn            4 0
658700200528      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG6512
658800200528     C                   ADD       6             NASSLn                                      BUG6512
658900200528                                                                                              CAP086
659000200528     C                   MOVEL     *BLANKS       FileName                                     CAP086
659100200528     C                   MOVEL     'MMNAIFPD'    FileName                                     CAP086
659200200528     C                   EXSR      GETRCDLN                                                   CAP086
659300200528     C                   Z-ADD     RecordLen     NAIFLn            4 0                        CAP086
659400200528
659500200528     C                   MOVEL     'MMNSEXPD'    FileName
659600200528     C                   EXSR      GETRCDLN
659700200528     C                   Z-ADD     RecordLen     NSEXLn            4 0
659800200528
659900200528     C                   ENDSR
660000200528      *****************************************************************
660100200528      /SPACE 5
660200200528      *****************************************************************
660300200528      * MM Rollover Details Maintenance
660400200528      *****************************************************************
660500200528     C     RODLFmts      BEGSR
660600200528
660700200528     C                   MOVEL     *BLANKS       FileName
660800200528     C                   MOVEL     'MMLDNIPD'    FileName
660900200528     C                   EXSR      GETRCDLN
661000200528     C                   Z-ADD     RecordLen     RODLLn            4 0
661100200528
661200200528      * Add DDRAMN (14A) and DDRACT (1A) at the end of deal details.
661300200528     C                   ADD       15            RODLLn
661400200528
661500200528     C                   MOVEL     'MMLDIFPD'    FileName
661600200528     C                   EXSR      GETRCDLN
661700200528     C                   Z-ADD     RecordLen     ROIFLn            4 0
661800200528
661900200528     C                   MOVEL     'MMLDEXPD'    FileName
662000200528     C                   EXSR      GETRCDLN
662100200528     C                   Z-ADD     RecordLen     ROEXLn            4 0
662200200528
662300200528     C                   ENDSR
662400200528      *****************************************************************
662500200528      /SPACE 5
662600200528      *****************************************************************
662700200528      * IR Caps/Collars/Floors Maintenance
662800200528      *****************************************************************
662900200528     C     CACFFmts      BEGSR
663000200528
663100200528     C                   MOVEL     *BLANKS       FileName
663200200528     C                   MOVEL     'IRCACFPD'    FileName
663300200528     C                   EXSR      GETRCDLN
663400200528     C                   Z-ADD     RecordLen     CACFLn            4 0
663500200528
663600200528     C                   MOVEL     'IRCACF2PD'   FileName
663700200528     C                   EXSR      GETRCDLN
663800200528     C                   Z-ADD     RecordLen     CAC2Ln            4 0
663900200528
664000200528     C                   MOVEL     *BLANKS       FileName
664100200528     C                   MOVEL     'IRRPIFPD'    FileName
664200200528     C                   EXSR      GETRCDLN
664300200528     C                   Z-ADD     RecordLen     CFIFLn            4 0
664400200528
664500200528     C                   MOVEL     'IRCPEXPD'    FileName
664600200528     C                   EXSR      GETRCDLN
664700200528     C                   Z-ADD     RecordLen     CFEXLn            4 0
664800200528
664900200528     C                   ENDSR
665000200528      *****************************************************************
665100200528      /SPACE 5
665200200528      *****************************************************************
665300200528      * FX CLS Pay-in Schedule (Header)                               *
665400200528      *****************************************************************
665500200528     C     CLSPFmts      BEGSR
665600200528
665700200528     C                   EVAL      FileName = 'FXCLSPHPD'
665800200528     C                   EXSR      GETRCDLN
665900200528     C                   Z-ADD     RecordLen     CLSPLn            4 0
666000200528      * Add PPayRcv(1) to end of details.                                                     BUG683
666100200528     C                   ADD       1             CLSPLn                                       BUG683
666200200528                                                                                             BUG9829
666300200528     C                   MOVEL     *BLANKS       FileName                                    BUG9829
666400200528     C                   MOVEL     'FXCLIFPD'    FileName                                    BUG9829
666500200528     C                   EXSR      GETRCDLN                                                  BUG9829
666600200528     C                   Z-ADD     RecordLen     CLIFLn            4 0                       BUG9829
666700200528
666800200528     C                   ENDSR
666900200528      *****************************************************************
667000200528      /SPACE 5
667100200528      *****************************************************************
667200200528      * FX CLS Pay-in Schedule (Detail)                               *
667300200528      *****************************************************************
667400200528     C     CLS2Fmts      BEGSR
667500200528
667600200528     C                   EVAL      FileName = 'FXCLSPDPD'
667700200528     C                   EXSR      GETRCDLN
667800200528     C                   Z-ADD     RecordLen     CLS2Ln            4 0
667900200528      * Add PPayRcv(1) to end of details.                                                     BUG683
668000200528     C                   ADD       1             CLS2Ln                                       BUG683
668100200528                                                                                              CAP086
668200200528     C**********         MOVEL     *BLANKS       FileName                             CAP086 BUG9829
668300200528     C**********         MOVEL     'FXCLIFPD'    FileName                             CAP086 BUG9829
668400200528     C**********         EXSR      GETRCDLN                                           CAP086 BUG9829
668500200528     C**********         Z-ADD     RecordLen     CLIFLn            4 0                CAP086 BUG9829
668600200528
668700200528     C                   ENDSR
668800200528      *****************************************************************
668900200528      * Internal Contracts                                            *
669000200528      *****************************************************************
669100200528     C     INTCFmts      BEGSR
669200200528
669300200528     C                   EVAL      FileName = 'ABINTCPD'
669400200528     C                   EXSR      GETRCDLN
669500200528     C                   Z-ADD     RecordLen     INTCLn            4 0
669600200528
669700200528     C/COPY WNCPYSRC,APH00034
669800200528     C                   ENDSR
669900200528      *****************************************************************
670000200528      /SPACE 5
670100200528      *****************************************************************
670200200528      * Internal Funding Deals                                        *
670300200528      *****************************************************************
670400200528     C     FUNDFmts      BEGSR
670500200528
670600200528     C                   EVAL      FileName = 'ABFUNDPD'
670700200528     C                   EXSR      GETRCDLN
670800200528     C                   Z-ADD     RecordLen     FUNDLn            4 0
670900200528
671000200528     C                   EVAL      FileName = 'ABFUEXPD'                                      CAP191
671100200528     C                   EXSR      GETRCDLN                                                   CAP191
671200200528     C                   Z-ADD     RecordLen     FUEXLn            4 0                        CAP191
671300200528                                                                                              CAP191
671400200528     C                   ENDSR
671500200528      *****************************************************************
671600200528      /SPACE 5
671700200528      *****************************************************************
671800200528      * FF Over The Counter OTCC
671900200528      *****************************************************************
672000200528     C     OTCCFmts      BEGSR
672100200528
672200200528     C                   MOVEL     *BLANKS       FileName
672300200528     C                   MOVEL     'FFOTCCPD'    FileName
672400200528     C                   EXSR      GETRCDLN
672500200528     C                   Z-ADD     RecordLen     OTCCLn            4 0
672600200528
672700200528     C                   MOVEL     'FFCSETPD'    FileName
672800200528     C                   EXSR      GETRCDLN
672900200528     C                   Z-ADD     RecordLen     OTCCLnS           4 0
673000200528
673100200528     C                   MOVEL     'FFOTRXPD'    FileName                                     CER001
673200200528     C                   EXSR      GETRCDLN                                                   CER001
673300200528     C                   Z-ADD     RecordLen     OTRXLn                                       CER001
673400200528                                                                                              CER001
673500200528     C                   MOVEL     'FFOTEXPD'    FileName
673600200528     C                   EXSR      GETRCDLN
673700200528     C                   Z-ADD     RecordLen     OTCCLnX           4 0
673800200528
673900200528     C                   ENDSR
674000200528      *****************************************************************
674100200528      * FF Non Currency Over The Counter OTCO
674200200528      *****************************************************************
674300200528     C     OTCOFmts      BEGSR
674400200528
674500200528     C                   MOVEL     *BLANKS       FileName
674600200528     C                   MOVEL     'FFOTCOPD'    FileName
674700200528     C                   EXSR      GETRCDLN
674800200528     C                   Z-ADD     RecordLen     OTCOLn            4 0
674900200528
675000200528     C                   MOVEL     'FFCSETPD'    FileName
675100200528     C                   EXSR      GETRCDLN
675200200528     C                   Z-ADD     RecordLen     OTCOLnS           4 0
675300200528
675400200528     C                   MOVEL     'FFOTEXPD'    FileName
675500200528     C                   EXSR      GETRCDLN
675600200528     C                   Z-ADD     RecordLen     OTCOLnX           4 0
675700200528
675800200528     C                   ENDSR
675900200528      *****************************************************************
676000200528      /SPACE 5
676100200528      *****************************************************************
676200200528      * FF Exchange Traded Transaction EXTR
676300200528      *****************************************************************
676400200528     C     EXTRFmts      BEGSR
676500200528
676600200528      * The main file...
676700200528     C                   MOVEL     *BLANKS       FileName
676800200528     C                   MOVEL     'FFEXTRPD'    FileName
676900200528     C                   EXSR      GETRCDLN
677000200528     C                   Z-ADD     RecordLen     EXTRLn            4 0
677100200528
677200200528      * ... Customer Settlement details...
677300200528     C                   MOVEL     'FFCSETPD'    FileName
677400200528     C                   EXSR      GETRCDLN
677500200528     C                   Z-ADD     RecordLen     EXTRLnCS          4 0
677600200528
677700200528      * ... Broker Settlement details...
677800200528     C                   MOVEL     'FFBSETPD'    FileName
677900200528     C                   EXSR      GETRCDLN
678000200528     C                   Z-ADD     RecordLen     EXTRLnBS          4 0
678100200528                                                                                              CAP191
678200200528      * Exchange-traded reg extra data layout                                                 CAP191
678300200528     C                   MOVEL     'FFETRXPD'    FileName                                     CAP191
678400200528     C                   EXSR      GETRCDLN                                                   CAP191
678500200528     C                   Z-ADD     RecordLen     EXTRLnR           4 0                        CAP191
678600200528
678700200528      * ... and Extra details.
678800200528     C                   MOVEL     'FFETEXPD'    FileName
678900200528     C                   EXSR      GETRCDLN
679000200528     C                   Z-ADD     RecordLen     EXTRLnX           4 0
679100200528
679200200528     C                   ENDSR
679300200528      *****************************************************************
679400200528      /SPACE 5
679500200528      *****************************************************************
679600200528      * SD Spot Rates                                                 *
679700200528      *****************************************************************
679800200528     C     SPTRFmts      BEGSR
679900200528
680000200528     C                   EVAL      FileName = 'SDSPTRPD'
680100200528     C                   EXSR      GETRCDLN
680200200528     C                   Z-ADD     RecordLen     SPTRLn            4 0
680300200528
680400200528     C                   ENDSR
680500200528      *****************************************************************
680600200528      /SPACE 5
680700200528      ****************************************************************
680800200528      *  SCHEDFmts - IR Schedules Formats                            *
680900200528      ****************************************************************
681000200528     C*****SCHEDFmts*****BEGSR                                                               BUG4646
681100200528      **********                                                                             BUG4646
681200200528      ***Cash*Flow*Schedules*******************************************                      BUG4646
681300200528      **********                                                                             BUG4646
681400200528     C**********         CLEAR                   FileName                                    BUG4646
681500200528     C**********         MOVEL     'IRCFSC1PD'   FileName                                    BUG4646
681600200528     C**********         EXSR      GETRCDLN                                                  BUG4646
681700200528     C**********         Z-ADD     RecordLen     WCFSC1OLn                                   BUG4646
681800200528     C**********         Z-ADD     RecordLen     WCFSC1TLn                                   BUG4646
681900200528     C**********         MOVEL     'IRCFSC2PD'   FileName                                    BUG4646
682000200528     C**********         EXSR      GETRCDLN                                                  BUG4646
682100200528     C**********         Z-ADD     RecordLen     WCFSC2OLn                                   BUG4646
682200200528     C**********         Z-ADD     RecordLen     WCFSC2TLn                                   BUG4646
682300200528     C**********         MOVEL     'IRCFSC3PD'   FileName                                    BUG4646
682400200528     C**********         EXSR      GETRCDLN                                                  BUG4646
682500200528     C**********         Z-ADD     RecordLen     WCFSC3OLn                                   BUG4646
682600200528     C**********         Z-ADD     RecordLen     WCFSC3TLn                                   BUG4646
682700200528     C**********         MOVEL     'IRCFSC4PD'   FileName                                    BUG4646
682800200528     C**********         EXSR      GETRCDLN                                                  BUG4646
682900200528     C**********         Z-ADD     RecordLen     WCFSC4OLn                                   BUG4646
683000200528     C**********         Z-ADD     RecordLen     WCFSC4TLn                                   BUG4646
683100200528      **********                                                                             BUG4646
683200200528      ***Principal*Change*Schedules************************************                      BUG4646
683300200528      **********                                                                             BUG4646
683400200528     C**********         MOVEL     'IRPCSC1PD'   FileName                                    BUG4646
683500200528     C**********         EXSR      GETRCDLN                                                  BUG4646
683600200528     C**********         Z-ADD     RecordLen     WPCSC1OLn                                   BUG4646
683700200528     C**********         Z-ADD     RecordLen     WPCSC1TLn                                   BUG4646
683800200528     C**********         MOVEL     'IRPCSC2PD'   FileName                                    BUG4646
683900200528     C**********         EXSR      GETRCDLN                                                  BUG4646
684000200528     C**********         Z-ADD     RecordLen     WPCSC2OLn                                   BUG4646
684100200528     C**********         Z-ADD     RecordLen     WPCSC2TLn                                   BUG4646
684200200528     C**********         MOVEL     'IRPCSC3PD'   FileName                                    BUG4646
684300200528     C**********         EXSR      GETRCDLN                                                  BUG4646
684400200528     C**********         Z-ADD     RecordLen     WPCSC3OLn                                   BUG4646
684500200528     C**********         Z-ADD     RecordLen     WPCSC3TLn                                   BUG4646
684600200528     C**********         MOVEL     'IRPCSC4PD'   FileName                                    BUG4646
684700200528     C**********         EXSR      GETRCDLN                                                  BUG4646
684800200528     C**********         Z-ADD     RecordLen     WPCSC4OLn                                   BUG4646
684900200528     C**********         Z-ADD     RecordLen     WPCSC4TLn                                   BUG4646
685000200528      **********                                                                             BUG4646
685100200528      ***Trailer*Record************************************************                      BUG4646
685200200528      **********                                                                             BUG4646
685300200528     C**********         CLEAR                   FileName                                    BUG4646
685400200528     C**********         MOVEL     'IRTRSCPD'    FileName                                    BUG4646
685500200528     C**********         EXSR      GETRCDLN                                                  BUG4646
685600200528     C**********         Z-ADD     RecordLen     WTRSCLn                                     BUG4646
685700200528      **********                                                                             BUG4646
685800200528     C**********         ENDSR                                                               BUG4646
685900200528      ****************************************************************
686000200528      /SPACE 5
686100200528      *****************************************************************
686200200528      * MM Interest Rates                                             *
686300200528      *****************************************************************
686400200528     C     INTRFmts      BEGSR
686500200528
686600200528     C                   MOVEL     *BLANKS       FileName
686700200528     C                   MOVEL     'FDINTRPD'    FileName
686800200528     C                   EXSR      GETRCDLN
686900200528     C                   Z-ADD     500           INT1Ln            4 0
687000200528     C     RecordLen     SUB       500           INT2Ln            4 0
687100200528
687200200528     C                   MOVEL     'FDIREXPD'    FileName
687300200528     C                   EXSR      GETRCDLN
687400200528     C                   Z-ADD     RecordLen     INEXLn            4 0
687500200528
687600200528     C                   ENDSR
687700200528      ****************************************************************
687800200528      /SPACE 5
687900200528      *****************************************************************
688000200528      * SE Security Diary Events                                      *
688100200528      *****************************************************************
688200200528     C     SEDEFmts      BEGSR
688300200528
688400200528     C                   MOVEL     *BLANKS       FileName
688500200528     C                   MOVEL     'SESEDEPD'    FileName
688600200528     C                   EXSR      GETRCDLN
688700200528     C                   Z-ADD     RecordLen     SEDELn            4 0
688800200528
688900200528     C                   MOVEL     'SESDEXPD'    FileName
689000200528     C                   EXSR      GETRCDLN
689100200528     C                   Z-ADD     RecordLen     SDEXLn            4 0
689200200528
689300200528     C                   ENDSR
689400200528      ****************************************************************
689500200528      /SPACE 5
689600200528      *****************************************************************
689700200528      * SE Prices Input                                               *
689800200528      *****************************************************************
689900200528     C     PRCSFmts      BEGSR
690000200528
690100200528     C                   MOVEL     *BLANKS       FileName
690200200528     C                   MOVEL     'SEPRCSPD'    FileName
690300200528     C                   EXSR      GETRCDLN
690400200528     C                   Z-ADD     RecordLen     PRCSLn            4 0
690500200528
690600200528     C                   MOVEL     'SEPREXPD'    FileName
690700200528     C                   EXSR      GETRCDLN
690800200528     C                   Z-ADD     RecordLen     PRCXLn            4 0
690900200528
691000200528     C                   ENDSR
691100200528      ****************************************************************
691200200528      /SPACE 5
691300200528      *****************************************************************
691400200528      * FD Forward Rates                                              *
691500200528      *****************************************************************
691600200528     C     FWRTFmts      BEGSR
691700200528
691800200528     C                   MOVEL     *BLANKS       FileName
691900200528     C                   MOVEL     'FDFWRTPD'    FileName
692000200528     C                   EXSR      GETRCDLN
692100200528     C                   Z-ADD     500           FWR1Ln            4 0
692200200528     C     RecordLen     SUB       500           FWR2Ln            4 0
692300200528
692400200528     C                   MOVEL     *BLANKS       FileName
692500200528     C                   MOVEL     'FDFREXPD'    FileName
692600200528     C                   EXSR      GETRCDLN
692700200528     C                   Z-ADD     RecordLen     FWEXLn            4 0
692800200528
692900200528     C                   ENDSR
693000200528      *****************************************************************                       CLE106
693100200528      * Settlement Details                                                                    CLE106
693200200528      *****************************************************************                       CLE106
693300200528     C     SETLFmts      BEGSR                                                                CLE106
693400200528                                                                                              CLE106
693500200528     C                   MOVEL     *BLANKS       FileName                                     CLE106
693600200528     C                   MOVEL     'SDESSXPD'    FileName                                     CLE106
693700200528     C                   EXSR      GETRCDLN                                                   CLE106
693800200528     C                   Z-ADD     RecordLen     SET1Ln            4 0                        CLE106
693900200528                                                                                              CLE106
694000200528     C                   MOVEL     'SDESSRPD'    FileName                                     CLE106
694100200528     C                   EXSR      GETRCDLN                                                   CLE106
694200200528     C                   Z-ADD     RecordLen     SET2Ln            4 0                        CLE106
694300200528                                                                                              CLE106
694400200528     C                   MOVEL     'SDESSPPD'    FileName                                     CLE106
694500200528     C                   EXSR      GETRCDLN                                                   CLE106
694600200528     C                   Z-ADD     RecordLen     SET3Ln            4 0                        CLE106
694700200528                                                                                              CLE106
694800200528     C                   ENDSR                                                                CLE106
694900200528      *****************************************************************
695000200528      /SPACE 5                                                                                CGP010
695100200528      *****************************************************************                       CGP010
695200200528      * BSPL Requests                                                 *                       CGP010
695300200528      *****************************************************************                       CGP010
695400200528     C     BSRQFmts      BEGSR                                                                CGP010
695500200528                                                                                              CGP010
695600200528     C                   MOVEL     *BLANKS       FileName                                     CGP010
695700200528     C                   MOVEL     'GOBSRQPD'    FileName                                     CGP010
695800200528     C                   EXSR      GETRCDLN                                                   CGP010
695900200528     C                   Z-ADD     RecordLen     BSRQLn            4 0                        CGP010
696000200528                                                                                              CGP010
696100200528     C                   MOVEL     'GOBSRXPD'    FileName                                     CGP010
696200200528     C                   EXSR      GETRCDLN                                                   CGP010
696300200528     C                   Z-ADD     RecordLen     BSRXLn            4 0                        CGP010
696400200528                                                                                              CGP010
696500200528     C                   ENDSR                                                                CGP010
696600200528      ****************************************************************                        CGP010
696700200528      /SPACE 5                                                                                CAS011
696800200528      *****************************************************************                       CAS011
696900200528      * DL Dealing Fees                                               *                       CAS011
697000200528      *****************************************************************                       CAS011
697100200528     C     DLFEFmts      BEGSR                                                                CAS011
697200200528                                                                                              CAS011
697300200528     C                   MOVEL     *BLANKS       FileName                                     CAS011
697400200528     C                   MOVEL     'DLDLFEPD'    FileName                                     CAS011
697500200528     C                   EXSR      GETRCDLN                                                   CAS011
697600200528     C                   Z-ADD     RecordLen     DLFELn            4 0                        CAS011
697700200528                                                                                              CAS011
697800200528     C                   ENDSR                                                                CAS011
697900200528      *****************************************************************                       CRE026
698000200528      /SPACE 5                                                                                CRE026
698100200528      *****************************************************************                       CRE026
698200200528      * SD Collateral Type                                                                    CRE026
698300200528      *****************************************************************                       CRE026
698400200528     C     COTYFmts      BEGSR                                                                CRE026
698500200528                                                                                              CRE026
698600200528     C                   MOVEL     *BLANKS       FileName                                     CRE026
698700200528     C                   MOVEL     'SDCOTYPD'    FileName                                     CRE026
698800200528     C                   EXSR      GETRCDLN                                                   CRE026
698900200528     C                   Z-ADD     RecordLen     COTYLn                                       CRE026
699000200528                                                                                              CRE026
699100200528     C                   MOVEL     'SDCOEXPD'    FileName                                     CRE026
699200200528     C                   EXSR      GETRCDLN                                                   CRE026
699300200528     C                   Z-ADD     RecordLen     SDCXLn                                       CRE026
699400200528                                                                                              CRE026
699500200528     C                   ENDSR                                                                CRE026
699600200528      *****************************************************************                       CRE026
699700200528      /SPACE 5                                                                                CRE026
699800200528      *****************************************************************                       CRE026
699900200528      * SD Country                                                                            CRE026
700000200528      *****************************************************************                       CRE026
700100200528     C     CNTYFmts      BEGSR                                                                CRE026
700200200528                                                                                              CRE026
700300200528     C                   MOVEL     *BLANKS       FileName                                     CRE026
700400200528     C                   MOVEL     'SDCNTYPD'    FileName                                     CRE026
700500200528     C                   EXSR      GETRCDLN                                                   CRE026
700600200528     C                   Z-ADD     RecordLen     CNTYLn                                       CRE026
700700200528                                                                                              CRE026
700800200528     C                   MOVEL     'SDCNT3PD'    FileName                                     CRE026
700900200528     C                   EXSR      GETRCDLN                                                   CRE026
701000200528     C                   Z-ADD     RecordLen     CTX1Ln                                       CRE026
701100200528                                                                                              CRE026
701200200528     C                   MOVEL     'SDCNT2PD'    FileName                                     CRE026
701300200528     C                   EXSR      GETRCDLN                                                   CRE026
701400200528     C                   Z-ADD     RecordLen     CTX2Ln                                       CRE026
701500200528                                                                                              CRE026
701600200528     C                   MOVEL     'SDCTEXPD'    FileName                                     CRE026
701700200528     C                   EXSR      GETRCDLN                                                   CRE026
701800200528     C                   Z-ADD     RecordLen     SDCXLn                                       CRE026
701900200528                                                                                              CRE026
702000200528     C                   ENDSR                                                                CRE026
702100200528      *****************************************************************                       CRE026
702200200528      /SPACE 5                                                                                CRE026
702300200528      *****************************************************************                       CRE026
702400200528      * SD Alternative Name and Addresses                                                     CRE026
702500200528      *****************************************************************                       CRE026
702600200528     C     ALNAFmts      BEGSR                                                                CRE026
702700200528                                                                                              CRE026
702800200528     C                   MOVEL     *BLANKS       FileName                                     CRE026
702900200528     C                   MOVEL     'SDALNAPD'    FileName                                     CRE026
703000200528     C                   EXSR      GETRCDLN                                                   CRE026
703100200528     C                   Z-ADD     RecordLen     ALNALn                                       CRE026
703200200528                                                                                              CRE026
703300200528     C                   MOVEL     'SDALEXPD'    FileName                                     CRE026
703400200528     C                   EXSR      GETRCDLN                                                   CRE026
703500200528     C                   Z-ADD     RecordLen     SDAXLn                                       CRE026
703600200528                                                                                              CRE026
703700200528     C                   ENDSR                                                                CRE026
703800200528      *****************************************************************                       CRE026
703900200528      /SPACE 5                                                                                CRE026
704000200528      *****************************************************************                       CRE026
704100200528      * SF User Definitions and Menu Items                                                    CRE026
704200200528      *****************************************************************                       CRE026
704300200528     C     AMUSFmts      BEGSR                                                                CRE026
704400200528                                                                                              CRE026
704500200528     C                   MOVEL     *BLANKS       FileName                                     CRE026
704600200528     C                   MOVEL     'SFAMUSPD'    FileName                                     CRE026
704700200528     C                   EXSR      GETRCDLN                                                   CRE026
704800200528     C                   Z-ADD     RecordLen     AMUSLn                                       CRE026
704900200528                                                                                              CRE026
705000200528     C                   MOVEL     'SFBBRCPD'    FileName                                     CRE026
705100200528     C                   EXSR      GETRCDLN                                                   CRE026
705200200528     C                   Z-ADD     500           BBR1Ln                                       CRE026
705300200528     C                   Z-ADD     500           BBR2Ln                                       CRE026
705400200528     C                   Z-ADD     500           BBR3Ln                                       CRE026
705500200528     C                   Z-ADD     500           BBR4Ln                                       CRE026
705600200528     C                   Z-ADD     500           BBR5Ln                                       CRE026
705700200528     C                   Z-ADD     500           BBR6Ln                                       CRE026
705800200528     C                   Z-ADD     500           BBR7Ln                                       CRE026
705900200528     C     RecordLen     SUB       3500          BBR8Ln                                       CRE026
706000200528                                                                                              CRE026
706100200528     C                   MOVEL     'SFOBRCPD'    FileName                                     CRE026
706200200528     C                   EXSR      GETRCDLN                                                   CRE026
706300200528     C                   Z-ADD     500           OBR1Ln                                       CRE026
706400200528     C                   Z-ADD     500           OBR2Ln                                       CRE026
706500200528     C                   Z-ADD     500           OBR3Ln                                       CRE026
706600200528     C                   Z-ADD     500           OBR4Ln                                       CRE026
706700200528     C                   Z-ADD     500           OBR5Ln                                       CRE026
706800200528     C                   Z-ADD     500           OBR6Ln                                       CRE026
706900200528     C                   Z-ADD     500           OBR7Ln                                       CRE026
707000200528     C     RecordLen     SUB       3500          OBR8Ln                                       CRE026
707100200528                                                                                              CRE026
707200200528     C                   MOVEL     'SFCOMPPD'    FileName                                     CRE026
707300200528     C                   EXSR      GETRCDLN                                                   CRE026
707400200528     C                   Z-ADD     RecordLen     COMPLn                                       CRE026
707500200528                                                                                              CRE026
707600200528     C                   MOVEL     'SFUSEXPD'    FileName                                     CRE026
707700200528     C                   EXSR      GETRCDLN                                                   CRE026
707800200528     C                   Z-ADD     RecordLen     SFUXLn                                       CRE026
707900200528                                                                                              CRE026
708000200528     C                   ENDSR                                                                CRE026
708100200528      *****************************************************************                       CRE026
708200200528      /SPACE 5                                                                                CRE026
708300200528      *****************************************************************                       CRE026
708400200528      * SD Nostro Codes                                                                       CRE026
708500200528      *****************************************************************                       CRE026
708600200528     C     NOSRFmts      BEGSR                                                                CRE026
708700200528                                                                                              CRE026
708800200528     C                   MOVEL     *BLANKS       FileName                                     CRE026
708900200528     C                   MOVEL     'SDNOSRPD'    FileName                                     CRE026
709000200528     C                   EXSR      GETRCDLN                                                   CRE026
709100200528     C                   Z-ADD     RecordLen     NOSRLn                                       CRE026
709200200528                                                                                              CRE026
709300200528     C                   MOVEL     'SDNVEXPD'    FileName                                     CRE026
709400200528     C                   EXSR      GETRCDLN                                                   CRE026
709500200528     C                   Z-ADD     RecordLen     SDNXLn                                       CRE026
709600200528                                                                                              CRE026
709700200528     C                   ENDSR                                                                CRE026
709800200528      *****************************************************************                       CRE026
709900200528      /SPACE 5                                                                                CRE026
710000200528      *****************************************************************                       CRE026
710100200528      * SD Yield Curve                                                                        CRE026
710200200528      *****************************************************************                       CRE026
710300200528     C     YLCUFmts      BEGSR                                                                CRE026
710400200528                                                                                              CRE026
710500200528     C                   MOVEL     *BLANKS       FileName                                     CRE026
710600200528     C                   MOVEL     'SDYLCUPD'    FileName                                     CRE026
710700200528     C                   EXSR      GETRCDLN                                                   CRE026
710800200528     C                   Z-ADD     RecordLen     YLCULn                                       CRE026
710900200528                                                                                              CRE026
711000200528     C                   MOVEL     'SDYCEXPD'    FileName                                     CRE026
711100200528     C                   EXSR      GETRCDLN                                                   CRE026
711200200528     C                   Z-ADD     RecordLen     SDYXLn                                       CRE026
711300200528                                                                                              CRE026
711400200528     C                   ENDSR                                                                CRE026
711500200528      *****************************************************************                       CRE026
711600200528      /SPACE 5                                                                                CRE026
711700200528      *****************************************************************                       CRE026
711800200528      * SD Yield Rates                                                                        CRE026
711900200528      *****************************************************************                       CRE026
712000200528     C     YRATFmts      BEGSR                                                                CRE026
712100200528                                                                                              CRE026
712200200528     C                   MOVEL     *BLANKS       FileName                                     CRE026
712300200528     C                   MOVEL     'SDYRATPD'    FileName                                     CRE026
712400200528     C                   EXSR      GETRCDLN                                                   CRE026
712500200528     C                   Z-ADD     500           YRA1Ln                                       CRE026
712600200528     C                   Z-ADD     500           YRA2Ln                                       CRE026
712700200528     C                   Z-ADD     500           YRA3Ln                                       CRE026
712800200528     C     RecordLen     SUB       1500          YRA4Ln                                       CRE026
712900200528                                                                                              CRE026
713000200528     C                   MOVEL     'SDYREXPD'    FileName                                     CRE026
713100200528     C                   EXSR      GETRCDLN                                                   CRE026
713200200528     C                   Z-ADD     RecordLen     SDYELn                                       CRE026
713300200528                                                                                              CRE026
713400200528     C                   ENDSR                                                                CRE026
713500200528      *****************************************************************                       CSD079
713600200528      /SPACE 5                                                                                CSD079
713700200528      *****************************************************************                       CSD079
713800200528      * SD Risk Weighted Assets                                                               CSD079
713900200528      *****************************************************************                       CSD079
714000200528     C     RWANFmts      BEGSR                                                                CSD079
714100200528                                                                                              CSD079
714200200528     C                   MOVEL     *BLANKS       FileName                                     CSD079
714300200528     C                   MOVEL     'SDRWANPD'    FileName                                     CSD079
714400200528     C                   EXSR      GETRCDLN                                                   CSD079
714500200528     C                   Z-ADD     RecordLen     RWANLn            4 0                        CSD079
714600200528                                                                                              CSD079
714700200528     C                   ENDSR                                                                CSD079
714800200528      *****************************************************************                       CSD079
714900200528      /SPACE 5                                                                                CSD079
715000200528      *****************************************************************                       CSD079
715100200528      * SD Customer Withholding Tax                                                           CSD079
715200200528      *****************************************************************                       CSD079
715300200528     C     CUWTFmts      BEGSR                                                                CSD079
715400200528                                                                                              CSD079
715500200528     C                   MOVEL     *BLANKS       FileName                                     CSD079
715600200528     C                   MOVEL     'SDCUWTPD'    FileName                                     CSD079
715700200528     C                   EXSR      GETRCDLN                                                   CSD079
715800200528     C                   Z-ADD     500           CUW1Ln            4 0                        CSD079
715900200528     C     RecordLen     SUB       500           CUW2Ln            4 0                        CSD079
716000200528                                                                                              CSD079
716100200528     C                   ENDSR                                                                CSD079
716200200528      *****************************************************************                       CSD079
716300200528      /SPACE 5                                                                             AR1086546
716400200528      *****************************************************************                    AR1086546
716500200528      * SD Currency/Time of Netting                                                        AR1086546
716600200528      *****************************************************************                    AR1086546
716700200528     C     CCTNFmts      BEGSR                                                             AR1086546
716800200528                                                                                           AR1086546
716900200528     C                   MOVEL     *BLANKS       FileName                                  AR1086546
717000200528     C                   MOVEL     'SDCCTNPD'    FileName                                  AR1086546
717100200528     C                   EXSR      GETRCDLN                                                AR1086546
717200200528     C                   Z-ADD     RecordLen     CCTNLn            4 0                     AR1086546
717300200528                                                                                           AR1086546
717400200528     C                   ENDSR                                                             AR1086546
717500200528      *****************************************************************                    AR1086546
717600200528      /SPACE 5                                                                                CLE134
717700200528      *****************************************************************                       CLE134
717800200528      * PDCL layout                                                                           CLE134
717900200528      *****************************************************************                       CLE134
718000200528     C     CPDCFmts      BEGSR                                                                CLE134
718100200528      *                                                                                       CLE134
718200200528     C                   MOVEL     *BLANKS       FileName                                     CLE134
718300200528     C                   MOVEL     'LEPDCLPD'    FileName                                     CLE134
718400200528     C                   EXSR      GETRCDLN                                                   CLE134
718500200528     C                   Z-ADD     RecordLen     CPD1Ln                                       CLE134
718600200528      *                                                                                       CLE134
718700200528     C                   ENDSR                                                                CLE134
718800200528      *****************************************************************                       CLE134
718900200528      * Adjustment to Accrued Interest                                                        CAP210
719000200528      *****************************************************************                       CAP210
719100200528     C     DLAAFmts      BEGSR                                                                CAP210
719200200528                                                                                              CAP210
719300200528     C                   MOVEL     *BLANKS       FileName                                     CAP210
719400200528     C                   MOVEL     'DLDLAAPD'    FileName                                     CAP210
719500200528     C                   EXSR      GETRCDLN                                                   CAP210
719600200528     C                   Z-ADD     RecordLen     DLAALn                                       CAP210
719700200528                                                                                              CAP210
719800200528     C                   ENDSR                                                                CAP210
719900200528      *****************************************************************                       CAP210
720000200528     C***/COPY*OFCPYSRCZ,CAP090_004                                                    CAP090 CLE164
720100200528     C/COPY OFCPYSRCZ,CGL158_004                                                              CGL158
720200200528      /SPACE 5                                                                                CAP212
720300200528      *****************************************************************                       CAP212
720400200528      * FT Nostrp Transfers                                                                   CAP212
720500200528      *****************************************************************                       CAP212
720600200528     C     FTNTFmts      BEGSR                                                                CAP212
720700200528                                                                                              CAP212
720800200528     C                   MOVEL     *BLANKS       FileName                                     CAP212
720900200528     C                   MOVEL     'FTFTNTPD'    FileName                                     CAP212
721000200528     C                   EXSR      GETRCDLN                                                   CAP212
721100200528     C                   Z-ADD     RecordLen     FTNTLn            4 0                        CAP212
721200200528                                                                                              CAP212
721300200528     C                   MOVEL     *BLANKS       FileName                                     CAP212
721400200528     C                   MOVEL     'FTFTEXPD'    FileName                                     CAP212
721500200528     C                   EXSR      GETRCDLN                                                   CAP212
721600200528     C                   Z-ADD     RecordLen     FTEXLn            4 0                        CAP212
721700200528                                                                                              CAP212
721800200528     C                   ENDSR                                                                CAP212
721900200528      *****************************************************************                       CAP212
722000200528     C     SBJBFmts      BEGSR                                                                CLE164
722100200528                                                                                              CLE164
722200200528     C                   MOVEL     *BLANKS       FileName                                     CLE164
722300200528     C                   MOVEL     'APSBJBTD'    FileName                                     CLE164
722400200528     C                   EXSR      GETRCDLN                                                   CLE164
722500200528     C                   Z-ADD     RecordLen     SBJBLen                                      CLE164
722600200528                                                                                              CLE164
722700200528     C                   MOVEL     *BLANKS       FileName                                     CLE164
722800200528     C                   MOVEL     'APSBEXTD'    FileName                                     CLE164
722900200528     C                   EXSR      GETRCDLN                                                   CLE164
723000200528     C                   Z-ADD     RecordLen     SBEXLen                                      CLE164
723100200528                                                                                              CLE164
723200200528     C                   ENDSR                                                                CLE164
723300200528      /SPACE 5                                                                                BG0505
723400200528      ****************************************************************                        BG0505
723500200528      * Block question marks in input buffer                                                  BG0505
723600200528      ****************************************************************                        BG0505
723700200528     C     BLOCK_QM      BEGSR                                                                BG0505
723800200528                                                                                              BG0505
723900200528     C     APQMBXK       KLIST                                                                BG0505
724000200528     C                   KFLD                    TransType                                    BG0505
724100200528     C                   KFLD                    #I                                           BG0505
724200200528     C     APQMBXKP      KLIST                                                                BG0505
724300200528     C                   KFLD                    TransType                                    BG0505
724400200528                                                                                              BG0505
724500200528     C                   MOVEL     'N'           QM_Blocked        1                          BG0505
724600200528     C                   MOVEL     'N'           QM_Allowed        1                          BG0505
724700200528     C                   Z-ADD     1             #I                5 0                        BG0505
724800200528     C                   BITOFF    '01234567'    CTLC              1                          BG0505
724900200528                                                                                              BG0505
725000200528      * Remove question marks - if required                                                   BG0505
725100200528                                                                                              BG0505
725200200528     C     *IN99         DOUEQ     *OFF                                                       BG0505
725300200528     C     '?'           SCAN      BufferTotal   #I                       99                  BG0505
725400200528     C     *IN99         IFEQ      *ON                                                        BG0505
725500200528     C     APQMBXK       SETLL     APQMBXD0                                                   BG0505
725600200528     C     APQMBXKP      READE     APQMBXD0                               98                  BG0505
725700200528     C     *IN98         IFEQ      *OFF                                                       BG0505
725800200528     C     #I            ANDGE     QXBSPS                                                     BG0505
725900200528     C     #I            ANDLE     QXBEPS                                                     BG0505
726000200528     C                   EVAL      %subst(BufferTotal:#I:1) = CTLC                            BG0505
726100200528     C                   EVAL      QM_Allowed = 'Y'                                           BG0505
726200200528     C                   ELSE                                                                 BG0505
726300200528     C                   EVAL      %subst(BufferTotal:#I:1) = ' '                             BG0505
726400200528     C                   EVAL      QM_Blocked = 'Y'                                           BG0505
726500200528     C                   ENDIF                                                                BG0505
726600200528     C                   ENDIF                                                                BG0505
726700200528     C                   ENDDO                                                                BG0505
726800200528                                                                                              BG0505
726900200528      * Reinstate '?' (NOTE: SCAN BufferTotal:X NOT USED ABOVE AS IT IS EXTREMELY SLOW)       BG0505
727000200528                                                                                              BG0505
727100200528     C     QM_Allowed    IFEQ      'Y'                                                        BG0505
727200200528     C     *IN99         DOUEQ     *OFF                                                       BG0505
727300200528     C     CTLC          SCAN      BufferTotal   #I                       99                  BG0505
727400200528     C     *IN99         IFEQ      *ON                                                        BG0505
727500200528     C                   EVAL      %subst(BufferTotal:#I:1) = '?'                             BG0505
727600200528     C                   ENDIF                                                                BG0505
727700200528     C                   ENDDO                                                                BG0505
727800200528     C                   ENDIF                                                                BG0505
727900200528                                                                                              BG0505
728000200528     C                   ENDSR                                                                BG0505
728100200528      *****************************************************************                       BG0505
728200200528      /SPACE 5                                                                                BG0505
728300200528      ****************************************************************                        BG0505
728400200528      * Add question mark error to warning messages                                           BG0505
728500200528      ****************************************************************                        BG0505
728600200528     C     ADD_QM_ERROR  BEGSR                                                                BG0505
728700200528                                                                                              BG0505
728800200528     C                   Z-ADD     1             #I                                           BG0505
728900200528     C     *BLANK        LOOKUP    WFldNamArr(#I)                         99                  BG0505
729000200528     C                   MOVEL     'NOFLD '      WFldNamArr(#I)                               BG0505
729100200528     C                   MOVEL     'APM0300'     WMsgIDArr(#I)                                BG0505
729200200528                                                                                              BG0505
729300200528     C                   ENDSR                                                                BG0505
729400200528      *****************************************************************                     MD022093
729500200528      /SPACE 5                                                                              MD022093
729600200528      *****************************************************************                     MD022093
729700200528      * Extract buffer total                                                                MD022093
729800200528      *****************************************************************                     MD022093
729900200528     C     ExtCUSDBufTot BEGSR                                                              MD022093
730000200528                                                                                            MD022093
730100200528     C                   EVAL      BFTotLn -= Bfp                                           MD022093
730200200528                                                                                            MD022093
730300200528     C                   ENDSR                                                              MD022093
730400200528      *****************************************************************                     MD022093
730500200528      /SPACE 5                                                                              MD022093
730600200528      *****************************************************************                     MD022093
730700200528      * Extract buffer ex 2                                                                 MD022093
730800200528      *****************************************************************                     MD022093
730900200528     C     ExtCUSDBufEx2 BEGSR                                                              MD022093
731000200528      *                                                                                     MD022093
731100200528      ** The FillerBufEx2 must be used by any upcoming CORE or CAR                          MD022093
731200200528      ** enhancements. If in case BufferEx2 becomes FULL (i.e. the new                      MD022093
731300200528      ** file definition will not exactly fit to the remaining                              MD022093
731400200528      ** FillerBufEx2), this new CORE or CAR data must make use of the                      MD022093
731500200528      ** next BufferEx3 instead. Therefore the "repeated fields" must                       MD022093
731600200528      ** be moved forward from BufferEx3 to BufferEx4                                       MD022093
731700200528      *                                                                                     MD022093
731800200528     C                   EVAL      Bfp   = 1                                                MD022093
731900200528     C                   EVAL      TransCS13 = %SUBST(BufferEx2:Bfp:SW13Ln)                 MD022093
732000200528      *                                                                                     MD022093
732100200528     C                   EVAL      Bfp  += SW13Ln                                           MD022093
732200200528     C                   EVAL      TransCUXC = %SUBST(BufferEx2:Bfp:CUXCLn)                   CGL132
732300200528     C                   EVAL      Bfp  += CUXCLn                                             CGL132
732400200528     C                   EVAL      TransFTCR = %SUBST(BufferEx2:Bfp:FTCRLn)                   CGL132
732500200528     C                   EVAL      Bfp  += FTCRLn                                             CGL132
732600200528     C                   EVAL      TransCUEX = %SUBST(BufferEx2:Bfp:SDEXLn)                 MD044880
732700200528     C                   EVAL      Bfp  += SDEXLn                                           MD044880
732800200528     C                   EVAL      TransCRSH = %SUBST(BufferEx2:Bfp:CRSSLn)                   CGL157
732900200528     C                   EVAL      Bfp  += CRSSLn                                             CGL157
733000200528      *** APR Calculation Required Field (CUSD)                                             MD054028
733100200528     C                   EVAL      TransCR50 = %SUBST(BufferEx2:Bfp:1)                      MD054028
733200200528     C                   EVAL      Bfp  += 1                                                MD054028
733300200528     C                                                                                      MD054028
733400200528     C                   EVAL      BFEX2Ln -= Bfp                                           MD022093
733500200528                                                                                            MD022093
733600200528     C                   ENDSR                                                              MD022093
733700200528      *****************************************************************                     MD022093
733800200528      /SPACE 5                                                                              MD022093
733900200528      *****************************************************************                     MD022093
734000200528      * Extract buffer ex 3                                                                 MD022093
734100200528      *****************************************************************                     MD022093
734200200528     C     ExtCUSDBufEx3 BEGSR                                                              MD022093
734300200528                                                                                            MD022093
734400200528     C                   EVAL      Bfp = 1                                                  MD022093
734500200528     C                   EVAL      BFEx3Ln -= Bfp                                           MD022093
734600200528                                                                                            MD022093
734700200528     C                   ENDSR                                                              MD022093
734800200528      *****************************************************************                     MD022093
734900200528      /SPACE 5                                                                              MD022093
735000200528      ****************************************************************                      MD022093
735100200528      * Extract buffer ex 4                                                                 MD022093
735200200528      ****************************************************************                      MD022093
735300200528     C     ExtCUSDBufEx4 BEGSR                                                              MD022093
735400200528      *                                                                                     MD022093
735500200528     C                   EVAL      Bfp   = 1                                                MD022093
735600200528     C                   EVAL      TransCUA1 = %SUBST(BufferEx4:Bfp:CUA1Ln)                 MD022093
735700200528     C                   ADD       CUA1Ln        Bfp                                        MD022093
735800200528      *                                                                                     MD022093
735900200528     C                   EVAL      TransCUA2 = %SUBST(BufferEx4:Bfp:CUA2Ln)                 MD022093
736000200528     C                   ADD       CUA2Ln        Bfp                                        MD022093
736100200528      *                                                                                     MD022093
736200200528     C                   EVAL      TransCUA3 = %SUBST(BufferEx4:Bfp:CUA3Ln)                 MD022093
736300200528     C                   ADD       CUA3Ln        Bfp                                        MD022093
736400200528     C                   EVAL      TransCUAH = TransCUA1 + TransCUA2                        MD022093
736500200528     C                                       + TransCUA3                                    MD022093
736600200528      *                                                                                     MD022093
736700200528     C                   EVAL      TransACT1 = %SUBST(BufferEx4:Bfp:ACT1Ln)                 MD022093
736800200528     C                   ADD       ACT1Ln        Bfp                                        MD022093
736900200528      *                                                                                     MD022093
737000200528     C                   EVAL      TransACT2 = %SUBST(BufferEx4:Bfp:ACT2Ln)                 MD022093
737100200528     C                   ADD       ACT2Ln        Bfp                                        MD022093
737200200528      *                                                                                     MD022093
737300200528     C                   EVAL      TransACT3 = %SUBST(BufferEx4:Bfp:ACT3Ln)                 MD022093
737400200528     C                   ADD       ACT3Ln        Bfp                                        MD022093
737500200528      *                                                                                     MD022093
737600200528     C                   EVAL      TransACT4 = %SUBST(BufferEx4:Bfp:ACT4Ln)                 MD022093
737700200528     C                   ADD       ACT4Ln        Bfp                                        MD022093
737800200528      *                                                                                     MD022093
737900200528     C                   EVAL      TransACT5 = %SUBST(BufferEx4:Bfp:ACT5Ln)                 MD022093
738000200528     C                   ADD       ACT5Ln        Bfp                                        MD022093
738100200528     C                   EVAL      TransACT6 = %SUBST(BufferEx4:Bfp:ACT6Ln)                 MD022093
738200200528     C                   ADD       ACT6Ln        Bfp                                        MD022093
738300200528     C                   EVAL      TransCCTX = TransACT1 + TransACT2                        MD022093
738400200528     C                                       + TransACT3 + TransACT4                        MD022093
738500200528     C                                       + TransACT5 + TransACT6                        MD022093
738600200528     C                   EVAL      TRANS19   = %SUBST(TransCCTN:1:CCTNLn1) +                MD041996
738700200528     C                                         %SUBST(BufferEx4:Bfp:CCTNLn)                 MD041996
738800200528     C                   ADD       CCTNLn        Bfp                                        MD041996
738900200528     C**********         EVAL      ExtData   = %SUBST(BufferEx4:Bfp:SDEXLn)        MD022093 MD044880
739000200528     C**********         ADD       SDEXLn        Bfp                               MD022093 MD004480
739100200528      *                                                                                       CGL157
739200200528     C                   EVAL      TransCRS01 = %SUBST(BufferEx4:Bfp:CRS01Ln)                 CGL157
739300200528     C                   ADD       CRS01Ln       Bfp                                          CGL157
739400200528      *                                                                                       CGL157
739500200528     C                   EVAL      TransCRS02 = %SUBST(BufferEx4:Bfp:CRS02Ln)                 CGL157
739600200528     C                   ADD       CRS02Ln       Bfp                                          CGL157
739700200528      *                                                                                       CGL157
739800200528     C                   EVAL      TransCRS03 = %SUBST(BufferEx4:Bfp:CRS03Ln)                 CGL157
739900200528     C                   ADD       CRS03Ln       Bfp                                          CGL157
740000200528      *                                                                                       CGL157
740100200528     C                   EVAL      TransCRS04 = %SUBST(BufferEx4:Bfp:CRS04Ln)                 CGL157
740200200528     C                   ADD       CRS04Ln       Bfp                                          CGL157
740300200528      *                                                                                       CGL157
740400200528     C                   EVAL      TransCRS05 = %SUBST(BufferEx4:Bfp:CRS05Ln)                 CGL157
740500200528     C                   ADD       CRS05Ln       Bfp                                          CGL157
740600200528      *                                                                                       CGL157
740700200528     C                   EVAL      TransCRS06 = %SUBST(BufferEx4:Bfp:CRS06Ln)                 CGL157
740800200528     C                   ADD       CRS06Ln       Bfp                                          CGL157
740900200528      *                                                                                       CGL157
741000200528     C                   EVAL      TransCRS07 = %SUBST(BufferEx4:Bfp:CRS07Ln)                 CGL157
741100200528     C                   ADD       CRS07Ln       Bfp                                          CGL157
741200200528      *                                                                                       CGL157
741300200528     C                   EVAL      TransCRS08 = %SUBST(BufferEx4:Bfp:CRS08Ln)                 CGL157
741400200528     C                   ADD       CRS08Ln       Bfp                                          CGL157
741500200528      *                                                                                       CGL157
741600200528     C                   EVAL      TransCRS09 = %SUBST(BufferEx4:Bfp:CRS09Ln)                 CGL157
741700200528     C                   ADD       CRS09Ln       Bfp                                          CGL157
741800200528      *                                                                                       CGL157
741900200528     C                   EVAL      TransCRS10 = %SUBST(BufferEx4:Bfp:CRS10Ln)                 CGL157
742000200528     C                   ADD       CRS10Ln       Bfp                                          CGL157
742100200528      *                                                                                       CGL157
742200200528     C                   EVAL      TransCRS11 = %SUBST(BufferEx4:Bfp:CRS11Ln)                 CGL157
742300200528     C                   ADD       CRS11Ln       Bfp                                          CGL157
742400200528      *                                                                                       CGL157
742500200528     C                   EVAL      TransCRS12 = %SUBST(BufferEx4:Bfp:CRS12Ln)                 CGL157
742600200528     C                   ADD       CRS12Ln       Bfp                                          CGL157
742700200528      *                                                                                       CGL157
742800200528     C                   EVAL      TransCRS13 = %SUBST(BufferEx4:Bfp:CRS13Ln)                 CGL157
742900200528     C                   ADD       CRS13Ln       Bfp                                          CGL157
743000200528      *                                                                                       CGL157
743100200528     C                   EVAL      TransCRDD1 = TransCRS01 + TransCRS02                       CGL157
743200200528     C                                        + TransCRS03 + TransCRS04                       CGL157
743300200528     C                                        + TransCRS05 + TransCRS06                       CGL157
743400200528     C                                        + TransCRS07 + TransCRS08                       CGL157
743500200528     C                                        + TransCRS09 + TransCRS10                       CGL157
743600200528     C                                        + TransCRS11 + TransCRS12                       CGL157
743700200528     C                                        + TransCRS13                                    CGL157
743800200528      *                                                                                       CGL157
743900200528                                                                                            MD022093
744000200528     C                   EVAL      BFEx4Ln  -= Bfp                                          MD022093
744100200528      *                                                                                     MD022093
744200200528                                                                                            MD022093
744300200528     C                   ENDSR                                                              MD022093
744400200528      *****************************************************************                       CGL157
744500200528      /SPACE 5                                                                                CGL157
744600200528      *****************************************************************                       CGL157
744700200528      * Extract buffer ex 5                                                                   CGL157
744800200528      *****************************************************************                       CGL157
744900200528     C     ExtCUSDBufEx5 BEGSR                                                                CGL157
745000200528                                                                                              CGL157
745100200528     C                   EVAL      Bfp = 1                                                    CGL157
745200200528                                                                                              CGL157
745300200528     C                   EVAL      TransCRS14 = %SUBST(BufferEx5:Bfp:CRS14Ln)                 CGL157
745400200528     C                   ADD       CRS14Ln       Bfp                                          CGL157
745500200528                                                                                              CGL157
745600200528     C                   EVAL      TransCRS15 = %SUBST(BufferEx5:Bfp:CRS15Ln)                 CGL157
745700200528     C                   ADD       CRS15Ln       Bfp                                          CGL157
745800200528                                                                                              CGL157
745900200528     C                   EVAL      TransCRDD2 = TransCRS14 + TransCRS15                       CGL157
746000200528                                                                                              CGL157
746100200528     C                   EVAL      ExtData   = %SUBST(BufferEx5:Bfp:SDEXLn)                   CGL157
746200200528     C                   ADD       SDEXLn        Bfp                                          CGL157
746300200528                                                                                              CGL157
746400200528     C                   EVAL      BFEx5Ln -= Bfp                                             CGL157
746500200528                                                                                              CGL157
746600200528     C                   ENDSR                                                                CGL157
746700200528      *****************************************************************                       BG0505
746800200528      /SPACE 5
746900200528      ****************************************************************
747000200528      *  Initialisation                                              *
747100200528      ****************************************************************
747200200528     C     *INZSR        BEGSR
747300200528                                                                                              CRE020
747400200528      ** Check if Online Printing of Advices (GE7) is on.                                     CRE020
747500200528                                                                                              CRE020
747600200528     C                   EVAL      CRE020 = 'N'                                               CRE020
747700200528     C                   CALL      'AOSARDR0'                                                 CRE020
747800200528     C                   PARM      *BLANKS       PRTCD                                        CRE020
747900200528     C                   PARM      '*VERIFY'     POPTN                                        CRE020
748000200528     C                   PARM      'CRE020'      PSARD                                        CRE020
748100200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
748200200528                                                                                              CRE020
748300200528     C                   IF        PRTCD = *BLANKS                                            CRE020
748400200528     C                   EVAL      CRE020 = 'Y'                                               CRE020
748500200528     C                   ENDIF                                                                CRE020
748600200528     C/COPY WNCPYSRC,APH00035
748700200528
748800200528      ** Check if SWIFT2009 is installed                                                      CSW209
748900200528                                                                                              CSW209
749000200528     C                   Eval      CSW209 = 'N'                                               CSW209
749100200528     C                   Call      'SWIF2009'                                                 CSW209
749200200528     C                   Parm      *BLANKS       PRTCD                                        CSW209
749300200528                                                                                              CSW209
749400200528     C                   If        PRTCD = 'CSW2009'                                          CSW209
749500200528     C                   Eval      CSW209 = 'Y'                                               CSW209
749600200528     C                   EndIf                                                                CSW209
749700200528      *                                                                                       CSW209
749800200528     C/COPY OFCPYSRCZ,CAP090_005                                                              CAP090
749900200528     C/COPY OFCPYSRCZ,CGL135_046                                                             CGL135A
750000200528     C/COPY OFCPYSRCZ,CGL158_005                                                              CGL158
750100200528      **--------------------------------------------------------------
750200200528      ** The following /COPY sets the values of program, module and
750300200528      ** procedure names for database error processing.
750400200528     C/COPY ZACPYSRC,DBFIELDS
750500200528      **--------------------------------------------------------------
750600200528
750700200528     C                   ENDSR
750800200528      *****************************************************************
750900200528      /SPACE 5
751000200528      ****************************************************************
751100200528      *  Get Record Lengths of Transaction Data Blocks               *
751200200528      ****************************************************************
751300200528     C     GETRCDLN      BEGSR
751400200528
751500200528     C                   CALLB     'UTGETRCDLN'
751600200528
751700200528      ** Return code
751800200528     C                   PARM                    ReturnCode       10
751900200528      ** Record length
752000200528     C                   PARM      *ZERO         RecordLen         5 0
752100200528
752200200528      ** File name
752300200528     C                   PARM                    FileName         10
752400200528      ** File library
752500200528     C                   PARM      '*LIBL     '  FileLib          10
752600200528
752700200528      ** If file not found (or any other error) shut down the program
752800200528     C     ReturnCode    Ifne      *Blanks
752900200528     C                   EXSR      *pssr
753000200528     C                   EndIf
753100200528
753200200528     C                   ENDSR
753300200528      *****************************************************************                       CRE020
753400200528      /SPACE 5                                                                                CRE020
753500200528      ****************************************************************                        CRE020
753600200528      *  Send Message to Retail Advice Generation DTAQ               *                        CRE020
753700200528      ****************************************************************                        CRE020
753800200528     C     SRSndDtaQ     BEGSR                                                                CRE020
753900200528                                                                                              CRE020
754000200528     C                   EVAL      PDtqMsg = WDSPgmMod                                        CRE020
754100200528     C                   EVAL      PDtqLen = 12                                               CRE020
754200200528                                                                                              CRE020
754300200528     C                   CALL      'QSNDDTAQ'                                                 CRE020
754400200528     C                   PARM      'APRTADDTQ'   PDtqNam                                      CRE020
754500200528     C                   PARM      '*LIBL'       PDtqLib                                      CRE020
754600200528     C                   PARM                    PDtqLen                                      CRE020
754700200528     C                   PARM                    PDtqMsg                                      CRE020
754800200528                                                                                              CRE020
754900200528     C                   ENDSR                                                                CRE020
755000200528      ****************************************************************
755100200528      /EJECT
755200200528      *****************************************************************
755300200528      * *PSSR - Program exception error routine                       *
755400200528      *                                                               *
755500200528      *****************************************************************
755600200528      ** The following /COPY contains the standard program status
755700200528      ** subroutine, excluding a bound call to the DBERRCTL module.
755800200528     C/COPY ZACPYSRC,PSSR_ILENE
755900200528     C                   EVAL      APIRetC = '0'
756000200528     C                   RETURN
756100200528     C                   ENDSR
756200200528      ****************************************************************
756300200528**  CPY@
756400200528(c) Finastra International Limited 2003
