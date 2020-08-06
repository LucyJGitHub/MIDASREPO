     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Validate and update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APTRANVU - Transaction Validate and Update                   *
      *                                                               *
      *  Function: This module is used to validate and update         *
      *            transactions in the Midas database.                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD039064           Date 31May16               *
      *  Prev Amend No. MD030856           Date 06Nov19               *
      *                 MD054354           Date 23Oct19               *
      *                 MD055446           Date 04Apr20               *
      *                 MD054696           Date 29Oct19               *
      *                 MD054538           Date 08Oct19               *
      *                 MD054028           Date 05Sep19               *
      *                 CER050             Date 16Jun19               *
      *                 MD052075           Date 07Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD050928A          Date 28Jun18               *
      *                 MD050928           Date 15May18               *
      *                 MD050345           Date 04Apr18               *
      *                 MD050342           Date 04Apr18               *
      *                 CGL157             Date 17Aug15               *
      *                 CFT163             Date 04May18               *
      *                 MD044880           Date 15Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 03Nov17               *
      *                 MD041996           Date 12Oct16               *
      *                 MD042042           Date 14Feb17               *
      *                 MD042033           Date 30Sep16               *
      *                 MD043890           Date 06Feb17               *
      *                 MD039986           Date 10Aug16               *
      *                 AR1090283          Date 10Aug16               *
      *                 CSW216             Date 14Mar16               *
      *                 AR701789           Date 26Sep16               *
      *                 MD038485           Date 10Aug16               *
      *                 CER071             Date 01Aug16               *
      *                 CLE141             Date 08Feb16               *
      *                 AR316373           Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 AR702532           Date 13Jan15               *
      *                 CAP212             Date 15Sep14               *
      *                 CGL158             Date 16Sep14               *
      *                 CRE101             Date 27Aug14               *
      *                 CGL165             Date 17Mar15               *
      *                 MD030621           Date 26Feb15               *
      *                 CLE164             Date 18Aug14               *
      *                 CDL096             Date 24Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD030454           Date 29Sep14               *
      *                 CFT157             Date 29Aug14               *
      *                 MD029663           Date 13Aug14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD026979           Date 09Jun14               *
      *                 CIR017             Date 10Apr14               *
      *                 CGL132             Date 01May13               *
      *                 CSD092             Date 01Apr13               *
      *                 CSD093             Date 10Mar14               *
      *                 MD024631           Date 12Feb14               *
      *                 MD023331           Date 08Nov13               *
      *                 CGL135A            Date 10Jul13               *
      *                 CAP090             Date 10Jul13               *
      *                 AR1086546          Date 18Jun13               *
      *                 MD022093           Date 01Sep13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD020733           Date 14Jun13               *
      *                 MD000091           Date 03May13               *
      *                 MD020445           Date 16May13               *
      *                 AR1080805          Date 25Feb13               *
      *                 AR910559           Date 10Dec12               *
      *                 AR804863           Date 10Dec12               *
      *                 CAP210             Date 28Sep12               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 AR1021983          Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CSW212             Date 03May12               *
      *                 AR1005984          Date 18Jul12               *
      *                 AR1005162          Date 16Jul12               *
      *                 AR1002463          Date 11Jul12               *
      *                 AR971184           Date 28May12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR946674           Date 03Apr12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863281           Date 16Nov11               *
      *                 AR863279           Date 16Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 CSF011             Date 12Sep11               *
      *                 CBF011             Date 04Jul11               *
      *                 AR819540A          Date 30Aug11               *
      *                 AR819540           Date 25Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 AR802610           Date 15Jul11               *
      *                 AR698195B          Date 20Jan11               *
      *                 261692             Date 17Nov09               *
      *                 261962             Date 23Sep09               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23742           Date 09May09               *
      *                 BUG22321           Date 20Jan09               *
      *                 CER030             Date 09Jul08               *
      *                 CER043             Date 19May08               *
      *                 BUG28091           Date 06Sep10               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 BUG26906           Date 21Jan10               *
      *                 CAP191             Date 26Nov09               *
      *                 261140             Date 16Sep09               *
      *                 BUG25664           Date 20Aug09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22155           Date 16Jan09               *
      *                 BUG22140           Date 14Jan09               *
      *                 256564             Date 17Sep08               *
      *                 255190             Date 21Jul08               *
      *                 BUG18701           Date 12May08               *
      *                 BUG15872           Date 12Feb08               *
      *                 248299             Date 05Jun07               *
      *                 247172             Date 10May07               *
      *                 246418             Date 14Mar07               *
      *                 244505             Date 12Jan07               *
      *                 BUG14803           Date 06Sep07               *
      *                 BUG14485           Date 31Jul07               *
      *                 BUG13579           Date 22Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CSD079             Date 05Feb07               *
      *                 BUG12213           Date 16Jan07               *
      *                 CRE026             Date 24May06               *
      *                 BUG13174           Date 02Feb07               *
      *                 BUG13172           Date 30Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240684             Date 26Jun06               *
      *                 BUG8953            Date 07Nov05               *
      *                 CDL049             Date 04Jul06               *
      *                 BUG11194           Date 24Apr06               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10540           Date 14Feb06               *
      *                 BUG10563           Date 14Feb06               *
      *                 BUG10296           Date 07Feb06               *
      *                 BUG10384           Date 06Feb06               *
      *                 BUG10280           Date 02Feb06               *
      *                 BUG10202           Date 27Jan06               *
      *                 BUG10093           Date 26Jan06               *
      *                 BUG9829            Date 10Jan06               *
      *                 239400             Date 26Jun06               *
      *                 BUG8953            Date 07Nov05               *
      *                 BUG9009            Date 03Nov05               *
      *                 CAP087             Date 04Aug05               *
      *                 BUG9601            Date 13Dec05               *
      *                 BUG9584            Date 25Apr05               *
      *                 BUG8163            Date 16Aug05               *
      *                 BUG9089            Date 25Apr05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG5988            Date 10Feb05               *
      *                 BUG9493            Date 07Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CSE071             Date 26May05               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG7664            Date 21Jun05               *
      *                 CDL033             Date 10Feb05               *
      *                 CGP010             Date 17Jan05               *
      *                 BUG5871            Date 24May05               *
      *                 BUG6512            Date 17May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6417            Date 28Mar05               *
      *                 BUG4562            Date 15Mar05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG6671            Date 25Apr05               *
      *                 BUG6472            Date 23Apr05               *
      *                 BUG6534            Date 08Apr05               *
      *                 BUG6274            Date 18Mar05               *
      *                 BUG5728            Date 28Jan05               *
      *                 BUG5403            Date 10Jan05               *
      *                 BUG5449            Date 07Dec04               *
      *                 BUG683             Date 22Dec04               *
      *                 BUG4646            Date 25Oct04               *
      *                 BUG4815            Date 24Nov04               *
      *                 BUG4469            Date 06Oct04               *
      *                 BUG3792            Date 29Sep04               *
      *                 BUG4258            Date 13Sep04               *
      *                 BUG4196            Date 08Sep04               *
      *                 BUG4190            Date 08Sep04               *
      *                 BUG4146            Date 01Sep04               *
      *                 CFT118             Date 01Sep04               *
      *                 BUG4087            Date 26Aug04               *
      *                 CFT118             Date 24Aug04               *
      *                 BUG3684            Date 18Aug04               *
      *                 CLE120             Date 09Aug04               *
      *                 CFT116             Date 12Jul04               *
      *                 CFT115             Date 01Jul04               *
      *                 BUG3986            Date 13Aug04               *
      *                 CMM121             Date 29Jun04               *
      *                 CMM105             Date 22Jun04               *
      *                 CFX114             Date 15Jun04               *
      *                 BUG629             Date 30Jul04               *
      *                 BUG3071            Date 17Jun04               *
      *                 BUG2789            Date 21May04               *
      *                 CTI004             Date 12Apr04               *
      *                 BUG2480           Date 26May04                *
      *                 CGL014             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 BG1105             Date 15Dec03               *
      *                 BUG19  (CAP084)    Date 26Jan04               *
      *                 BUG1100            Date 04May04               *
      *                 CRE020             Date 20Jan04               *
      *                 BUG1569            Date 17Mar04               *
      *                 BUG1304            Date 11Mar04               *
      *                 BUG1218            Date 11Mar04               *
      *                 BG0505             Date 04Mar04               *
      *                 CAP084  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *     
      *                                                               *
      *  MD030856 - Introduced reject processing to FEEM              *
      *  MD054354 - Settlement of fee accrual for prior period for    *
      *             backdated notional change                         *
      *  MD055446 - There are parties and fields missing from the BRT *	
      *             details tab in Customer Input plus date of birth  *	
      *             issues.                                           *	
      *           - Include BRT century fields on TransInEx2.         *
      *  MD054696 - Journal Entries Avoid Shadow Postings Update.     *
      *  MD039064 - Incorrect mapping for RPIF details                * 
      *             Add Shadow Post Indicator in BITH API (SOAP/JMS). *
      *  MD054538 - Buffer issue on Rollover Maintenance              *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate                          *
      *           (Change applied to CRE101_064 as well)              *
      *  MD052075 - [CGL150] Warning message should be displayed when *
      *           the system defaults the value date.                 *
      *  CSD102 - Password Length Extension                           *
      *  MD050928A - Reinstate codes by CFT157 as codes on FTOP* files*
      *              were reversed.                                   *
      *  MD050928 - SP15_MQ: Unclear error message - Error validating *
      *             'Stamp Tax Amount' : Invalid Numeric Value        *
      *           - Patterned after fix MD039094                      *
      *  MD050345 - Data under CRS Country Details are not aligned to *
      *             their corresponding columns                       *
      *  MD050342 - Mailing Country details is not displayed during   *
      *             Pre-Confirmation page                             *
      *  CGL157 - CRS Reporting                                       *
      *  CFT163 - FT Nostro Transfer Authorisation (RPG)              *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date                                    *
      *           Applied for MD-48461                                *
      *  MD041996 - Incorrect mapping for FX Netting                  *
      *  MD042042 - Input Officer 1 and Input Officer 2 in IPAY and   *
      *             OPAY are being populated with WIP authoriser.     *
      *             Use the WIP input user profile instead.           *
      *  MD042033 - Correct DECPRIF positioning based on new CLIP.xml.*
      *  MD043890 - Cannot insert term and notice (Recompile)         *
      *  MD039986 - Additional codes to upgrade AR1090283.            *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  MD038485 - Correct mapping of Stamp Tax fields (CER049).     *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  AR316373 - BOE @ MPlus - BOE cust dtls are not displayed in  *
      *             java wrapped function. Retrieve customer details  *
      *             from screen passed by java.                       *
      *  LLN022 - BOE Upgrade to MidasPlus (Recompile)                *
      *  AR702532 - After rejection, there is no WIP record but RSTS  *
      *             is still 'R'. Pass reject action parameter to     *
      *             skip validation during rejection to prevent the   *
      *             error. Applied fix 262574. (Child: AR702533)      *
      *           - Applied for MD023814                              *
      *  CAP212 - FT Nostro Transfer API                              *
      *  CGL158 - Nostro Sweeping Rules Maintenance                   *
      *           Added hooks: CGL158_001, CGL158_002, CGL158_003     *
      *                        CGL158_004, CGL158_005                 *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *           Added hooks: CRE101_001, CRE101_002, CRE101_003,    *
      *                        CRE101_004, CRE101_005, CRE101_063,    *
      *                        CRE101_064, CRE101_065, CRE101_066     *
      *  CGL165 - Dual Withholding Tax                                *
      *  MD030621 - Add @DEPI (Decrease Principal indicator) for PDCL *
      *             generated during IC.                              *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD030454 - Errors encountered during confirm authorise.      *
      *             Correct mapping done by MD029663.                 *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *  MD029663 - Misaligned Data in CIRS API.                      *
      *  CDL094 - Enhance Receive Settlement Instructions.            *
      *           Recompile based on additional field on SDESSRPD.    *
      *  MD026979 - Added field for Retail account and IBAN           *
      *             validation against WIP entries                    *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD092 - Account Review                                      *
      *  CSD093 - Document Management                                 *
      *  MD024631 - Incorporation of SWIFT 2013 to BF Midas 2.1.      *
      *             Renamed DDACTN in SDCUPR, DDCUST in SDRWAN and    *
      *             DDNTCP in SDCUFX.                                 *
      *  MD023331 - Database error encountered when CGL135 is         *
      *             switched off.                                     *
      *             Amended hook: CGL135_042, CGL135_045              *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_041, CGL135_042, CGL135_043,   *
      *                         CGL135_044, CGL135_045, CGL135_046    *
      *  CAP090 - Initiate Batch Process API                          *
      *           Added hooks: CAP090_001, CAP090_002, CAP090_003,    *
      *                        CAP090_004, CAP090_005                 *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813 (Recompile)                 *
      *  MD022093 - Additional Delivery for CSW213 Drop 2             *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD020733 - CLE134_transfer to past due duplicated. Output    *
      *             record to LELOMKPD (same as LOAMSDK) when MR is   *
      *             created by PDCL generation in IC. Reuse UpSRFlg   *
      *             to check MR Autogen events from PDCL online.      *
      *  MD000091 - Event Codes Substitution (Recompile)              *
      *  MD020445 - CLE134 CCR2 updated functionality                 *
      *  AR1080805 - Error in LEMAPYUPD                               *
      *  AR910559 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Introduce *
      *             @ACTRV variable to indicate reject action. Apply  *
      *             part of fix AR725754. (Child: AR910560)           *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
      *              in POC                                           *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  AR1005984 - A serious midas error was encountered in OPAY    *
      *  AR1005162 - Base ccy exchange rate in corrective batch has   *
      *              incorrect number of decimal places               *
      *  AR1002463- Incorrect retrieval of auto-authorization flag    *
      *             for OPAY & IPAY (Child:AR1002464)                 *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  CSC054 - Period End Adjustments                              *
      *  AR946674 - Serious midas error has occured (Child: AR946675) *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted ;  *
      *            fixes for artifacts 863281 and 863279 will be      *
      *            physically deleted                                 *
      *  AR863281 - Pay Settlement Customer Name on Input fields      *
      *             are not displayed                                 *
      *  AR863279 - Pay Settlement Customer Name on Input fields      *
      *             are not displayed                                 *
      *  CLE147 - Aggregate Facility                                  *
      *  CSF011 - Customer Name on Inputs                             *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *  AR819540A - Mapping error encountered in LDNI                *
      *  AR819540 - Mapping error encountered in OPAY transaction     *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *  AR802610 - Add Interest Scale flag in API definition.        *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  261692 - Amended so that system can get the associated       *
      *           front office ID from JAVA.                          *
      *  261962 - Amended so that system can get the associated front *
      *           office ID from Java for INTC.                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  BUG22321 - Mapping error causes Midas Error in Spot Rates    *
      *             input.                                            *
      *  CER030 - Multicash German Feature                            *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG28091 - Error "The batch is in used by another operator.  *
      *             It was last used by operator..." appeared upon    *
      *             input of a second batch item.                     *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  BUG26906 - Values for Broker and Customer tabs were reset    *
      *             to blanks                                         *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
      *  BUG25664 - Database Error Encountered.                       *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG22155 - Missing authorization field in repository for     *
      *             SECD and TRAD.                                    *
      *  BUG22140 - Missing authorization field in repository.        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255190 - Added message type parameter on call to FTIPAYVU.   *
      *  BUG18701 - Implement Auto Authorisation                      *
      *  BUG15872 - Applied fix BUG14992                              *
      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
      *  248299 - Extdata no more setup for MMLDNIVU                  *
      *           Redo it based on MMLDEXPD                           *
      *  247172 - Re-arrange the sending of buffer so that  Extdata   *
      *           is at the end of the string.                        *
      *  246418 - CGL013 changes for midasplus                        *
      *  244505 - FCIP: fields for REGDATAZ not correctly retrieved   *
      *           due to additional fild 'DDPATH' sent by JAVA        *
      *           (field added by BUG11649)                           *
      *  BUG14803 - XML Input falls into Repair Queue due             *
      *             to field mismatched.                              *
      *  BUG14485 - MidasPlus Definition for CUSD is not in synch     *
      *             with that of API XML definition                   *
      *             Applied fix is BUG14228                           *
      *  BUG13579 - A Midas Plus error on FCIP insert (Recompile)     *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  BUG12213 - Depot details missing on wholesale customer input *
      *  CRE026 - Consumer Banking                                    *
      *  BUG13174 - Applied fix 244505                                *
      *  BUG13172 - A serious midas error occurred (Recompile)        *
      *  240684 - Applied fix BUG9009.                                *
      *  BUG9009 - Implement CGL037                                   *
      *  BUG8953 - Recompile                                          *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  BUG11194 - SEFRN- Purchased Interest not recalculated when   *
      *             trade value date is changed                       *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10540 - Add new assignment indicator. (Recompile)         *
      *  BUG10563 - Resolve conflict between BUG10296 and 9827        *
      *  BUG10296 - LUX extension fields are missing                  *
      *  BUG10384 - Incorrect buffer position in FAMD.                *
      *  BUG10280- Could not Amend record on AMAD                     *
      *  BUG10202- Mapping error in TRAD                              *
      *  BUG10093- Mapping error in FCIP                              *
      *  BUG9829 - CAP086 incorrectly applied a code change for       *
      *            CLIFLn to the wrong subroutine                     *
      *  239400 - Add Front Office ID for LDNI, DEAM, NASP and NASS   *
      *  BUG8953 - Recompile                                          *
      *  BUG9009 - Implement CGL037                                   *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           Amend to handle TransType='DPMV' for Repos          *
      *           and Depot Transfers.                                *
      *  BUG9601- Mapping error in APTRANVU                           *
      *  BUG9584- Mapping correction with Java.                       *
      *  BUG8163 - FF Non-currency OTCs - TimeStamp value is not shown*
      *            after completion.                                  *
      *  BUG9089 - Mapping error with Java for DPMV                   *
      *  CER001 - Lux upgrade to MidasPlus                            *
      *  BUG5988- Data mapping for AMAD and SECS not consistent with  *
      *           the buffer setup in GLAMADVU and SESECSVU           *
      *  BUG9493 - Corrected position of ExtData data structure on    *
      *            buffer.                                            *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7664- change position of TRAM fields LDNI                 *
      *  CDL033 - Floating Rate CDs Issued.                           *
      *  CGP010 - Global BSPL                                         *
      *  BUG5871- Send deal status to midasplus for FRA/IRS modules   *
      *  BUG6512- Retrieve TRAM details, All Modules                  *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6417- Cash management components are missing in MidasPlus *
      *  BUG4562- Retrieve TRAM details                               *
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG6671- Implement Automatic Authorisation for CIRS/SIRS     *
      *  BUG6472- Changes to screen fmt file for CIRS/SIRS/CACF       *
      *  BUG6534- Condition settlement tabs on Loan or Deposit.       *
      *           Add Loan/Deposit indicator.                         *
      *  BUG6274- Premium amount does not revise on first confirmation*
      *           for insert                                          *
      *  BUG5728- UDF API to drop columns from a table                *
      *  BUG683 - Add PPayRcv to CLSP/CLS2                            *
      *  BUG5403 - Principle Change Schedule missing in CACF          *
      *  BUG5449- Schedules for CIRS api                              *
      *  BUG4646- Completion of SIRS api                              *
      *  BUG4815- Rationalise parameters for FXFXDLVU call.           *
      *  BUG4469- Stopping users overwrite changes for BSRT, SPTR,    *
      *           INTR and FRAS when amending the same record at the  *
      *           same time by passing the Timestamp to and from APIs.*
      *  BUG3792- Only allow Block/Unblock on Deposits.               *
      *           Add Placing/Taking indicator.                       *
      *  BUG4258- Stopping users overwrite changes for OTCC, OTCO,    *
      *           SEDE and PRCS when amending the same record at the  *
      *           same time.                                          *
      *  BUG4196- Stopping users overwrite changes for OPAY, IPAY,    *
      *           AMAD and CUSD when amending the same record at the  *
      *           same time.                                          *
      *  BUG4190- Missing parameter on call to FXFXDLVU               *
      *  BUG4146- Stopping users updating the same DEAM, NASP and NASS*
      *           records at the same time.                           *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts Printing - Upgrade to Midasplus.      *
      *           (Re-delivery) Add new field CQIN in the buffer.     *
      *  BUG4087- Stopping users updating the same FXDL record at the *
      *           same time.                                          *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts Printing. Upgrade to Midasplus.       *
      *  BUG3684- Pass the Block/Unblock action from the LDNI Pre-    *
      *           confirmation screen action buttons.                 *
      *  CLE120 - Core changes for GBO020.                            *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *  CFT116 - Core changes for GBO016                             *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *  CFT115 - Core changes for GBO015                             *
      *         - Incoming Payments Beneficiary Validation            *
      *         - Upgrade to Midasplus                                *
      *  BUG3986- Pass the status and TimeStamp out to the MidasPlus  *
      *           by LDNI                                             *
      *  CMM121 - Core changes for GBO021                             *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *         - Upgrade to Midasplus                                *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *  BUG629 - Add Deal Status field (DDSTS) in TRANS1 mapping     *
      *           for NASP function.                                  *
      *  BUG3071 - Online Printing of Advice for Fees Maintenance.    *
      *  BUG2789 - System test SOAP call from TI.                     *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           FX Deals Integration                                *
      *  BUG2480 - Send the reservation id to the back end            *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Truly Autumatic Rollover of Fixed Term Loan/Deposit *
      *           (Recompile)                                         *
      *  BG1105 - Bug1105 Make MSGARROUT a variable length string     *
      *  BUG19  - Changes on LERI processing.                         *
      *  BUG1100 - Added FEEM processing.                             *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  BUG1569- Stop multi-user updating the same record at the     *
      *           time by holding original timestamp with the record  *
      *           retreated by each user.                             *
      *  BUG1304- Fee fields missing from display                     *
      *  BUG1218- Status not shown for FEAD records                   *
      *  BG0505 - Block question marks                                *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
     FAPQMBXPD  IF   E           K DISK                                                       BG0505
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

     D WDSPgmMod       DS                                                                     CRE020
     D  WrkPgm                 1     10                                                       CRE020
     D  WrkMod                11     12                                                       CRE020
                                                                                              CRE020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
      ** Midas Switchable features file accessed via access program                           CRE020
                                                                                              CRE020
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE020
      ** DS for access programs - Short data structure                                        CRE020
                                                                                              CRE020
     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions
     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions
     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions
     D PayStmtV      E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(V)
      * Pay Settlement Instructions (Value Date)
     D RecStmtV      E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(V)
      * Receive Settlement Instructions (Value Date)
     D PayStmtM      E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(M)
      * Pay Settlement Instructions (Maturity Date)
     D RecStmtM      E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(M)
      * Receive Settlement Instructions (Maturity Date)
                                                                                              CDL018
     D #FRECS        E DS                  EXTNAME(SDFSSRPD)                                  CDL018
      * Receive Further Settlement instructions in screen format                              CDL018
                                                                                              CDL018
     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)                                  CDL018
      * Payment Further Settlement instructions in screen format                              CDL018
      ** Midas DL Dealing Reporting Information file                                          CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
                                                                                              CSW213
     D TransInTot      DS          9999                                                       CSW213
     D  TransCUPR                          LIKE(SDCUPR)                                       CSW213
     D  TransCUSE                          LIKE(SDCUSE)                                       CSW213
     D  TransCUMT                          LIKE(SDCUMT)                                       CSW213
     D  TransCUMR                          LIKE(SDCUMR)                                       CSW213
     D  TransCUBR                          LIKE(SDCUBR)                                       CSW213
     D  TransCUPB                          LIKE(SDCUPB)                                       CSW213
     D  TransCUMI                          LIKE(SDCUMI)                                       CSW213
     D  TransCUAD                          LIKE(SDCUAD)                                       CSW213
     D  TransACU3                          LIKE(SDACU3)                                       CSW213
     D  TransACU4                          LIKE(SDACU4)                                       CSW213
     D  TransSFEE                          LIKE(SDSFEE)                                       CSW213
     D  TransCHEC                          LIKE(SDCHEC)                                       CSW213
     D  TransCUSF                          LIKE(SDCUSF)                                       CSW213
     D  TransCUFX                          LIKE(SDCUFX)                                       CSW213
     D  TransCUFD                          LIKE(SDCUFD)                                       CSW213
     D  TransCUFO                          LIKE(SDCUFO)                                       CSW213
     D  TransCUPM                          LIKE(SDCUPM)                                       CSW213
     D  TransTICD                          LIKE(SDTICD)                                       CSW213
     D  TransCUSW                          LIKE(SDCUSW)                                       CSW213
     D  TransCURX                          LIKE(SDCURX)                                       CSW213
     D  TransTimeStmp                      LIKE(@Timestamp)                                   CSW213
     D  TransRWAN                          LIKE(SDRWAN)                                       CSW213
     D  TransStmpTax                       LIKE(StampTax)                                   MD022093
     D  TransAUTH                          LIKE(AAUTH)                                        CSW213
                                                                                              CSW213
     D TransInEx2      DS          9999                                                       CSW213
     D  TransCS13                          LIKE(SDSW13)                                       CSW213
     D  TransCUXC                          LIKE(SDCUXC)                                       CGL132
     D  TransFTCR                          LIKE(SDFTCR)                                       CGL132
     D  TransCUEX                          LIKE(SDCUEX)                                     MD044880
     D  TransCRSH                          LIKE(SDCRSS)                                       CGL157
     D  TransCR50                     1A                                                    MD054028
     D  TransBRTCent                 10A                                                    MD055446
                                                                                              CSW213
     D TransInEx3      DS          9999                                                       CSW213
     D  TransCARS              1   9999                                                       CSW213
                                                                                              CSW213
     D TransInEx4      DS          9999                                                       CSW213
     D  TransCUAH                          LIKE(SDCUAH)                                       CSW213
     D  TransCCTX                          LIKE(SDCCTX)                                       CSW213
     D  TransCRDD1                 6039                                                       CGL157
                                                                                              CGL157
     D TransInEx5      DS          9999                                                       CGL157
     D  TransCRDD2                  651                                                       CGL157
                                                                                              CSW213
     D SDCUPR        E DS                  EXTNAME(SDCUPRPD)                                  CSW213
     D  DDACTN_CP    E                     EXTFLD(DDACTN)                                   MD024631
     D SDCUSE        E DS                  EXTNAME(SDCUSEPD)                                  CSW213
     D SDCUMT        E DS                  EXTNAME(SDCUMTPD)                                  CSW213
     D SDCUMR        E DS                  EXTNAME(SDCUMRPD)                                  CSW213
     D SDCUBR        E DS                  EXTNAME(SDCUBRPD)                                  CSW213
     D SDCUPB        E DS                  EXTNAME(SDCUPBPD)                                  CSW213
     D SDCUMI        E DS                  EXTNAME(SDCUMIPD)                                  CSW213
     D  DDACTN_CU    E                     EXTFLD(DDACTN)                                     CSW213
     D SDCUAD        E DS                  EXTNAME(SDCUADPD)                                  CSW213
     D  DDACTN_CA    E                     EXTFLD(DDACTN)                                     CSW213
     D  DDCNA1_CA    E                     EXTFLD(DDCNA1)                                     CSW213
     D  DDCNA2_CA    E                     EXTFLD(DDCNA2)                                     CSW213
     D  DDCNA3_CA    E                     EXTFLD(DDCNA3)                                     CSW213
     D  DDCNA4_CA    E                     EXTFLD(DDCNA4)                                     CSW213
     D  DDCSSN_CA    E                     EXTFLD(DDCSSN)                                     CSW213
     D SDACU3        E DS                  EXTNAME(SDACU3DPD)                                 CSW213
     D SDACU4        E DS                  EXTNAME(SDACU4DPD)                                 CSW213
     D SDSFEE        E DS                  EXTNAME(SDSFEEPD)                                  CSW213
     D  DDACTN_FE    E                     EXTFLD(DDACTN)                                     CSW213
     D SDCHEC        E DS                  EXTNAME(SDCHECPD)                                  CSW213
     D  DDACTN_CH    E                     EXTFLD(DDACTN)                                     CSW213
     D SDCUSF        E DS                  EXTNAME(SDCUSFPD)                                  CSW213
     D  DDACTN_SF    E                     EXTFLD(DDACTN)                                     CSW213
     D SDCUFX        E DS                  EXTNAME(SDCUFXPD)                                  CSW213
     D  DDACTN_FX    E                     EXTFLD(DDACTN)                                     CSW213
     D  DDNTCP_FX    E                     EXTFLD(DDNTCP)                                   MD024631
     D SDCUFD        E DS                  EXTNAME(SDCUFDPD)                                  CSW213
     D  DDACTN_FD    E                     EXTFLD(DDACTN)                                     CSW213
     D SDCUFO        E DS                  EXTNAME(SDCUFOPD)                                  CSW213
     D  DDACTN_FO    E                     EXTFLD(DDACTN)                                     CSW213
     D  DDSMAC_FO    E                     EXTFLD(DDSMAC)                                     CSW213
     D SDCUPM        E DS                  EXTNAME(SDCUPMPD)                                  CSW213
     D  DDACTN_PM    E                     EXTFLD(DDACTN)                                     CSW213
     D SDTICD        E DS                  EXTNAME(SDTICDPD)                                  CSW213
     D  DDACTN_TI    E                     EXTFLD(DDACTN)                                     CSW213
     D SDCUSW        E DS                  EXTNAME(SDCUSWPD)                                  CSW213
     D SDCURX        E DS                  EXTNAME(SDCURXPD)                                  CSW213
     D SDRWAN        E DS                  EXTNAME(SDRWANPD)                                  CSW213
     D  DDACTN_RW    E                     EXTFLD(DDACTN)                                     CSW213
     D  DDCUST_RW    E                     EXTFLD(DDCUST)                                   MD024631
     D  DDCSSN_RW    E                     EXTFLD(DDCSSN)                                     CSW213
     D  DDCRNM_RW    E                     EXTFLD(DDCRNM)                                     CSW213
     D  DDCNA2_RW    E                     EXTFLD(DDCNA2)                                     CSW213
     D SDCUAH        E DS                  EXTNAME(SDCUAHDPD)                                 CSW213
     D SDCCTX        E DS                  EXTNAME(SDCCTXDPD)                                 CSW213
     D SDSW13        E DS                  EXTNAME(SDSW13PD)                                  CSW213
     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CSW213
     D  S13DDCITY    E                     EXTFLD(DDCITY)                                     CSW213
     D  S13DDPOBN    E                     EXTFLD(DDPOBN)                                     CSW213
                                                                                              CSW213
     D SDCUXC        E DS                  EXTNAME(SDCUXCPD)                                  CGL132
     D SDFTCR        E DS                  EXTNAME(SDFTCRPD)                                  CGL132
     D  DDCUST_FC    E                     EXTFLD(DDCUST)                                     CGL132
     D SDCRSS        E DS                  EXTNAME(SDCRSSPD)                                  CGL157
     D                                     PREFIX(W)                                          CGL157
     D SDCRDD        E DS                  EXTNAME(SDCRDDPD)                                  CGL157
     D                                     PREFIX(W)                                          CGL157
                                                                                              CDL099
      ** CDL099 Split Value Date with additional extra fields                                 CDL099
     D InCDL099      E DS                  EXTNAME(FXDLEXPD)                                  CDL099
     D DDEXDT_FX     E                     EXTFLD(DDEXDT)                                     CDL099
     D SDCUEX        E DS                  EXTNAME(SDCUEXPD)                                MD044880
      *                                                                                     BUG23742
     D POthNarr1       S            500A                                                    BUG23742
      *                                                                                     BUG23742
      ** External DS on BITP Additional Info 1                                              BUG23742
      *                                                                                     BUG23742
     D POthNarr2       S            500A                                                    BUG23742
      *                                                                                     BUG23742
      ** External DS on BITP Additional Info 2                                              BUG23742

      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)

      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)

      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)

      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNamArr      S             10A   DIM(ArrayMax)

      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)

      ** Array of warning message data.
     D WMsgDtaArr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)

      ** Entry parameters
     D TransType       S              4
     D Parm            S           1000
     D Buffer          S           6000
     D***ApHead*         S            200                                            AR971184 CSD102
     D ApHead          S            318                                                       CSD102
      * In order to allow for growing and variable buffers, this buffer must be split up
      * Any APIs requiring more than 6000 buffer should use buffer2
     D BufferTotal     S           9999
     D Buffer9999      S           9999                                                       CER059
     D Buffer2         S           3999
     D BufferEx2       S           9999                                                      BUG4646
     D BufferEx3       S           9999                                                      BUG4646
     D BufferEx4       S           9999                                                      BUG4646
     D BufferEx5       S           9999                                                      BUG4646
     D BufferEx6       S           9999                                                      BUG4646
     D BufferEx7       S           9999                                                      BUG4646
     D BufferEx8       S           9999                                                      BUG4646
     D BufferEx9       S           9999                                                      BUG4646
     D****** MsgArrOUT       S           2000                                                 BG1105
     D MsgArrOUT       S           9999                                                       BG1105
     D APIRetC         S              1
     D @TimeStamp      S             26                                                      BUG1569
     D NewButton       S              3                                                       255190
     D DDACTC          S              1                                                      BUG3684
     D DDFOID          S             20                                                       239400
     D PLATAK          S              1                                                      BUG3792
     D LONDEP          S              1                                                      BUG6534
     D ACTRJ           S              1                                                     AR701789
     D DepData         S           4050                                                     BUG12213
     D FRNT            S             20                                                       261140
     D AFRT            S             20                                                       261140
     D*WLCData**       S            181                                                CSD083 CFT039
     D WLCData         S            184                                                       CFT039
     D APINam          S             20                                                       CBF011
     D @ACTRV          S              1                                                     AR910559
     D @DEPI           S              1                                                     MD030621
     D AuthUsers       S             20                                                       CFT163
     D P_SIGN          S              1                                                     MD054354
     D DRejFlg         S              1                                                     MD030856
      ** DS/variables to split up incoming parameter
     D APParm          DS          1000
     D  UPDATEYN               1      1
     D  ReservID15             2     16                                         BUG2480
                                                                                             BUG5988
      ** Extra fields for AMAD                                                               BUG5988
     D AMADFldDS1      DS                                                                    BUG5988
     D  DDFAMT                 1      8                                                      BUG5988
     D  AMATYP                 9      9                                                      BUG5988
     D  AMSTYP                10     10                                                      BUG5988
     D  DODRCD                11     16                                                      BUG5988
     D  DOCRCD                17     22                                                      BUG5988
     D  INCST                 23     23                                                      BUG5988
     D  BRT                   24     24                                                      BUG5988
     D  ALT                   25     25                                                      BUG5988
     D  LTYP                  26     26                                                      BUG5988
     D  LINK                  27     44                                                      BUG5988
     D  IBA1                  45     45                                                      BUG5988
     D  DOPOLC                46     51                                                      BUG5988
     D  DOPOLE                52     57                                                      BUG5988
     D  DSPTFR                58     58                                                      BUG5988
     D  DDDRMG1               59     70                                                      BUG5988
     D  DDCRMG1               71     82                                                      BUG5988
     D  DDCEXA1               83     93                                                      BUG5988
     D  DDCEXB1               94    104                                                      BUG5988
     D  DDCEXC1              105    115                                                      BUG5988
     D  DDCEXD1              116    123                                                      BUG5988
     D  DDCEXE1              124    131                                                      BUG5988
     D  DDCEXF1              132    139                                                      BUG5988
     D  DDCEXG1              140    147                                                      BUG5988
     D  DDEABC               148    148                                                      BUG5988
                                                                                             BUG5988
      ** Extra fields for SECS                                                               BUG5988
     D SECSFldDS1      DS                                                                    BUG5988
     D  PPROT                  1      1                                                      BUG5988
     D  PTRBS                  2      2                                                      BUG5988
     D  PPRBS                  3      3                                                      BUG5988
     D  ASDC1                  4      9                                                      BUG5988
     D  ASDC2                 10     15                                                      BUG5988
     D  ASDC3                 16     21                                                      BUG5988
      *                                                                                     MD021813
      ** Extra fields for CTNM                                                              MD021813
     D CTNMFldDS1      DS                                                                   MD021813
     D  DDACTN                 1      1                                                     MD021813
     D  DDCUST                 2      7                                                     MD021813
     D  DDNTCP                 8      8                                                     MD021813

      ** Extra fields for CSW213                                                              CSW213
     D InSwift2013     DS                                                                     CSW213
     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
RGC  D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
                                                                                              CSW213
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Standard parameters for called programs
     D TRANS1A         S           1000                                                       CDL028
     D TRANS1          S            500
     D TRANS2          S            500
     D TRANS2A         S           1000                                                      CSF011A
     D TRANS2B         S            500                                                     BUG11194
     D TRANS3          S            500
     D TRANS3A         S           1000                                                      CSF011A
     D TRANS4          S            500
     D TRANS4A         S           1000                                                      CSF011A
     D TRANS5          S            500
     D TRANS5A         S           1000                                                      CSF011A
     D TRANS6          S            500
     D TRANS6A         S           1000                                                      CSF011A
     D TRANS7a         S            500                                                     BUG14485
     D TRANS7          S            500
     D TRANS8          S            500
     D TRANS9          S            500
     D TRANSQ          S            500                                                       CER049
     D OthData         S            500                                                      BUG9089
     D OthData1        S            500                                                      BUG9584
     D RegData         S            500                                                       CER001
     D TRANS10         S            500                                                       CSD079
     D TRANS10A        S            500                                                       CER030
     D TRANSEXT        S            500                                                       CSD079
     D TRANS11         S            500                                                       CSD079
     D TRANS11A        S            500                                                       CER030
     D TRANS11B        S            500                                                       CFT039
     D TRANS12         S            500                                                       CSD079
     D TRANS13         S            500                                                       CSD079
     D TRANS14         S            500                                                       CSD079
     D TRANS15         S            500                                                       CSD079
     D TRANS16         S            500                                                       CSD079
     D TransSW         S            500                                                     BUG14992
     D TransCUA1       S            500                                                       CER059
     D TransCUA2       S            500                                                       CER059
     D TransCUA3       S            500                                                       CER059
     D TransACT1       S            500                                                       CER059
     D TransACT2       S            500                                                       CER059
     D TransACT3       S            500                                                       CER059
     D TransACT4       S            500                                                       CER059
     D TransACT5       S            500                                                       CER059
     D TransACT6       S            500                                                       CER059
     D TransCRS01      S            500                                                       CGL157
     D TransCRS02      S            500                                                       CGL157
     D TransCRS03      S            500                                                       CGL157
     D TransCRS04      S            500                                                       CGL157
     D TransCRS05      S            500                                                       CGL157
     D TransCRS06      S            500                                                       CGL157
     D TransCRS07      S            500                                                       CGL157
     D TransCRS08      S            500                                                       CGL157
     D TransCRS09      S            500                                                       CGL157
     D TransCRS10      S            500                                                       CGL157
     D TransCRS11      S            500                                                       CGL157
     D TransCRS12      S            500                                                       CGL157
     D TransCRS13      S             39                                                       CGL157
     D TransCRS14      S            500                                                       CGL157
     D TransCRS15      S            500                                                       CGL157
     D TRANS17         S            500                                                       CSD079
     D TRANS18         S            500                                                       CSD079
     D BCLData         S            500                                                       CSD079
     D EurRepData      S            500                                                       CSD079
     D TRANS8A         S            500                                                       CSD079
     D TRANS8B         S            500                                                       CSD079
     D TRANS8C         S            500                                                       CGL157
     D Trans83         S            500                                                       CER059
     D Trans84         S            500                                                       CER059
     D TRANS19         S            500                                                    AR1086546
     D TransCCTN       S            500                                                     MD021813
     D ExtData         S            500
     D InfData         S            500
     D FCIPNotes       S            500                                                     BUG10093
     D CustData        S            500                                                       CER043
     D StampTax        S            500                                                       CER049
     D OthrData        S           4755A
     D TRADSettleData  S           4878A                                                     CSF011A
     D*RepeatData      S           4500A                                                      CRE015
     D RepeatData      S           5382A                                                      CRE073
     D*TempData#1      S           4972A                                               CRE073 CSF011
     D*TempData#2      S            410A                                               CRE073 CSF011
     D TempData#1      S           4932A                                                      CSF011
     D TempData#2      S            450A                                                      CSF011
     D*TempData#3      S              2A                                            CSF011 AR1005984
     D*TempData#4      S             18A                                            CSF011 AR1005984
     D TempData#3      S              1A                                                   AR1005984
     D TempData#4      S             19A                                                   AR1005984
     D TempData#5      S           4667A                                                      CSF011
     D TempData#6      S            211A                                                      CSF011
     D TempData#7      S             13A                                                    MD029663
     D TempData#8      S             37A                                                    MD029663
     D TempData#9      S             50A                                                    MD029663
     D GLFullAcct      S             24A                                                    MD026979
     D TempData7       S              1A                                                      CLE164
     D InputUser       S             10A                                                    MD042042
     D StopFTDta       S             10A                                                    MD050928

     D*WCFSC1OLn       S              4P 0                                                   BUG4646
     D*WCFSC2OLn       S              4P 0                                                   BUG4646
     D*WCFSC3OLn       S              4P 0                                                   BUG4646
     D*WCFSC4OLn       S              4P 0                                                   BUG4646
     D*WPCSC1OLn       S              4P 0                                                   BUG4646
     D*WPCSC2OLn       S              4P 0                                                   BUG4646
     D*WPCSC3OLn       S              4P 0                                                   BUG4646
     D*WPCSC4OLn       S              4P 0                                                   BUG4646
     D*WCFSC1TLn       S              4P 0                                                   BUG4646
     D*WCFSC2TLn       S              4P 0                                                   BUG4646
     D*WCFSC3TLn       S              4P 0                                                   BUG4646
     D*WCFSC4TLn       S              4P 0                                                   BUG4646
     D*WPCSC1TLn       S              4P 0                                                   BUG4646
     D*WPCSC2TLn       S              4P 0                                                   BUG4646
     D*WPCSC3TLn       S              4P 0                                                   BUG4646
     D*WPCSC4TLn       S              4P 0                                                   BUG4646
     D*WTRSCLn**       S              4P 0                                                   BUG4646
                                                                                              CRE020
     D CRE020          S              1                                                       CRE020
     D PRTCD           S              7A                                                      CRE020
     D POPTN           S              7A                                                      CRE020
     D PSARD           S              6A                                                      CRE020
     D PDtqNam         S             10A                                                      CRE020
     D PDtqLib         S             10A                                                      CRE020
     D PDtqLen         S              5  0                                                    CRE020
     D PDtqMsg         S             50A                                                      CRE020
                                                                                             BUG5988
     D AMADFLn         S              4  0                                                   BUG5988
     D AMADFiller      S            500A                                                     BUG5988
     D SECSFLn         S              4  0                                                   BUG5988
     D SECSFiller      S            500A                                                     BUG5988
     D*LDNIFiller      S           4000A                                           BUG10296 BUG10563
     D RatDateDS       S           4800A                                                    BUG10563
     D PayDateDS       S           4800A                                                    BUG10563
     D WDUMMY          S             90A                                                    BUG10563

      *                                                                                       CER001
      ** Length for regional fields                                                           CER001
      *                                                                                       CER001
     D AMRXLn          S              4  0                                                    CER001
     D BPRXLn          S              4  0                                                    CER001
     D CLRXLn          S              4  0                                                    CER001
     D DMRXLn          S              4  0                                                    CER001
     D FCRXLn          S              4  0                                                    CER001
     D IPRXLn          S              4  0                                                    CER001
     D LDRXLn          S              4  0                                                    CER001
     D NPRXLn          S              4  0                                                    CER001
     D OPRXLn          S              4  0                                                    CER001
     D OTEXLn          S              4  0                                                    CER001
     D OTRXLn          S              4  0                                                    CER001
     D RORXLn          S              4  0                                                    CER001
     D SERXLn          S              4  0                                                    CER001
     D TDRXLn          S              4  0                                                    CER001
     D TDAXLn          S              4  0                                                   BUG9584
     D FCRNLn          S              4  0                                                  BUG10093
     D ExtLength       S              4  0                                                    CSD079
     D SDARLn          S              4  0                                                    CSD092
     D ACEXLn          S              4P 0                                                    CSD092
     D ACRFLn          S              4P 0                                                    CSD092
     D SDMILn          S              4  0                                                    CRE026
     D SDADLn          S              4  0                                                    CRE026
     D SDADLnA         S              4  0                                                    CRE026
     D SDADLnB         S              4  0                                                    CRE026
     D SDADLnC         S              4  0                                                    CGL157
     D SDADLn3         S              4  0                                                    CER059
     D SDADLn4         S              4  0                                                    CER059
     D SDSFLn          S              4  0                                                    CRE026
     D SDCHLn          S              4  0                                                    CRE026
     D SDCSLn          S              4  0                                                    CRE026
     D SDFXLn          S              4  0                                                    CRE026
     D SDFDLn          S              4  0                                                    CRE026
     D SDRWLn          S              4  0                                                    CRE026
     D SDFOLn          S              4  0                                                    CRE026
     D SDPMLn          S              4  0                                                    CRE026
     D SDTILn          S              4  0                                                    CRE026
     D SDCULn          S              4  0                                                    CRE026
     D COTYLn          S              4  0                                                    CRE026
     D SDCXLn          S              4  0                                                    CRE026
     D CNTYLn          S              4  0                                                    CRE026
     D CTX1Ln          S              4  0                                                    CRE026
     D CTX2Ln          S              4  0                                                    CRE026
     D ALNALn          S              4  0                                                    CRE026
     D SDAXLn          S              4  0                                                    CRE026
     D AMUSLn          S              4  0                                                    CRE026
     D BBR1Ln          S              4  0                                                    CRE026
     D BBR2Ln          S              4  0                                                    CRE026
     D BBR3Ln          S              4  0                                                    CRE026
     D BBR4Ln          S              4  0                                                    CRE026
     D BBR5Ln          S              4  0                                                    CRE026
     D BBR6Ln          S              4  0                                                    CRE026
     D BBR7Ln          S              4  0                                                    CRE026
     D BBR8Ln          S              4  0                                                    CRE026
     D OBR1Ln          S              4  0                                                    CRE026
     D OBR2Ln          S              4  0                                                    CRE026
     D OBR3Ln          S              4  0                                                    CRE026
     D OBR4Ln          S              4  0                                                    CRE026
     D OBR5Ln          S              4  0                                                    CRE026
     D OBR6Ln          S              4  0                                                    CRE026
     D OBR7Ln          S              4  0                                                    CRE026
     D OBR8Ln          S              4  0                                                    CRE026
     D SFUXLn          S              4  0                                                    CRE026
     D COMPLn          S              4  0                                                    CRE026
     D NOSRLn          S              4  0                                                    CRE026
     D SDNXLn          S              4  0                                                    CRE026
     D YLCULn          S              4  0                                                    CRE026
     D SDYXLn          S              4  0                                                    CRE026
     D YRA1Ln          S              4  0                                                    CRE026
     D YRA2Ln          S              4  0                                                    CRE026
     D YRA3Ln          S              4  0                                                    CRE026
     D YRA4Ln          S              4  0                                                    CRE026
     D SDYELn          S              4  0                                                    CRE026
     D RWANLn          S              4  0                                                    CRE026
     D CUW1Ln          S              4  0                                                    CRE026
     D CUW2Ln          S              4  0                                                    CRE026
     D AMPPLn1         S              4  0                                                    CRE015
     D AMPPLn2         S              4  0                                                    CRE015
     D CPD1Ln          S              4  0                                                    CLE134
     D DLAALn          S              4  0                                                    CAP210
     D CCTNLn          S              4  0                                                 AR1086546
     D CCTNLn1         S              4  0                                                  MD021813
                                                                                              CSW209
      ** Work variable used by CSW209                                                         CSW209
     D IPY9ALn         S              4P 0                                                    CSW209
     D IPY9BLn         S              4P 0                                                    CSW209
     D OPY10Ln         S              4P 0                                                    CSW209
     D OPY11Ln         S              4P 0                                                    CSW209
     D TRANS9A         S           1000A                                                      CSW209
     D TRANS9B         S           1000A                                                      CSW209
     D CSW209          S              1                                                       CSW209
                                                                                              CSW209
     D yAAuth          S              1A                                                    AR316373
     D OPY12Ln         S              4P 0                                                    CER049
      *                                                                                       CER049
      ** Work variable used by CSW213                                                         CSW213
     D RPIFLn          S              4  0                                                    CSW213
     D RPIF1Ln         S              4  0                                                    CSW213
     D RPIF2Ln         S              4  0                                                    CSW213
     D RPIF3Ln         S              4  0                                                    CSW213
RGC  D RPIF4LN         S              4  0                                                    CSW214
                                                                                              CSW213
     D SW13Ln          S              4  0                                                    CSW213
     D BFTotLn         S              4  0 INZ(9999)                                        MD022093
     D BFEX2Ln         S              4  0 INZ(9999)                                        MD022093
     D BFEX3Ln         S              4  0 INZ(9999)                                        MD022093
     D BFEX4Ln         S              4  0 INZ(9999)                                        MD022093
     D BFEX5Ln         S              4  0 INZ(9999)                                          CGL157
                                                                                            MD022093
      ** Remaining filler for CUSP API only                                                 MD022093
     D FillerBufTot    S           5235A                                                    MD022093
     D FillerBufEx2    S           8951A                                                    MD022093
     D FillerBufEx3    S           9999A                                                    MD022093
     D FillerBufEx4    S           6284A                                                    MD022093
                                                                                            MD022093
      *                                                                                    AR1090283
     D BtnPressed      S             10                                                    AR1090283
     D***/COPY*OFCPYSRCZ,CAP090_001                                                    CAP090 CLE164
     D CAP090          S              1A                                                      CLE164
     D SBJBLen         S              4S 0                                                    CLE164
     D SBEXLen         S              4S 0                                                    CLE164
     D SBJBParm        S           2000A                                                      CLE164
     D/COPY OFCPYSRCZ,CGL135_041                                                             CGL135A
     D/COPY OFCPYSRCZ,CGL158_001                                                              CGL158
     D CUXCLn          S              4  0                                                    CGL132
     D FTCRLn          S              4  0                                                    CGL132
     D CRSSLn          S              4  0                                                    CGL157
     D CRDDLn          S              4  0                                                    CGL157
     D/COPY OFCPYSRCZ,CRE101_001                                                              CRE101
      ** +--- Start of main processing -----------------------------------+

     C     *ENTRY        PLIST
     C                   PARM                    TransType
     C                   PARM                    Parm
     C                   PARM                    BufferTotal
     C                   PARM                    BufferEx2                                   BUG4646
     C                   PARM                    BufferEx3                                   BUG4646
     C                   PARM                    BufferEx4                                   BUG4646
     C                   PARM                    BufferEx5                                   BUG4646
     C                   PARM                    BufferEx6                                   BUG4646
     C                   PARM                    BufferEx7                                   BUG4646
     C                   PARM                    BufferEx8                                   BUG4646
     C                   PARM                    BufferEx9                                   BUG4646
     C                   PARM                    MsgArrOUT
     C                   PARM                    APIRetC
     C                   PARM                    ApHead                                     AR971184
      *
      * Extract entry parameters
     C                   Eval      APParm = Parm
                                                                                              BG0505
      * Block question marks in input buffer                                                  BG0505
                                                                                              BG0505
     C                   EXSR      BLOCK_QM                                                   BG0505

      * Clear down buffers
     C                   Eval      Buffer = *BLANKS
     C                   Eval      Buffer2 = *BLANKS
      * Any API requiring more than 6000 should move the remaining BufferTotal
      * into Buffer2 here
     C                   Eval      Buffer = BufferTotal
     C                   MOVE      BufferTotal   Buffer2                                     BUG4646
     C                   EVAL      HeadIn = ApHead                                          AR971184

      * Call the required API

     C                   EXSR      CALLAPI

      * Move the buffers into the full buffer
     C                   EVAL      BufferTotal = Buffer + Buffer2
                                                                                              BG0505
      * Add question mark error to warning messages                                           BG0505
                                                                                              BG0505
     C     QM_Blocked    IFEQ      'Y'                                                        BG0505
     C                   EXSR      ADD_QM_ERROR                                               BG0505
     C                   ENDIF                                                                BG0505

      * Edit the Messages for output

     C                   If        TransTYPE <> 'COLD'                                       BUG5728
     C                   EXSR      EDTMSGS
     C                   EndIf                                                               BUG5728

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /SPACE 5
      ****************************************************************
      * Call the required API
      ****************************************************************
     C     CALLAPI       BEGSR

     C                   CLEAR                   TRANS1
     C                   CLEAR                   TRANS2
     C                   CLEAR                   TRANS2B                                    BUG11194
     C                   CLEAR                   TRANS3
     C                   CLEAR                   TRANS4
     C                   CLEAR                   TRANS4A                                     CSF011A
     C                   CLEAR                   TRANS5
     C                   CLEAR                   TRANS6
     C                   CLEAR                   TRANS7
     C                   CLEAR                   TRANS8
     C                   CLEAR                   TRANS9
     C                   CLEAR                   TRANS9A                                      CSW209
     C                   CLEAR                   TRANS9B                                      CSW209
     C                   CLEAR                   TRANS10                                      CSD079
     C                   CLEAR                   TRANSEXT                                     CSD079
     C                   CLEAR                   TRANS11                                      CSD079
     C                   CLEAR                   TRANS11B                                     CFT039
     C                   CLEAR                   TRANS12                                      CSD079
     C                   CLEAR                   TRANS13                                      CSD079
     C                   CLEAR                   TRANS14                                      CSD079
     C                   CLEAR                   TRANS15                                      CSD079
     C                   CLEAR                   TRANS16                                      CSD079
     C                   CLEAR                   TransSW                                    BUG14992
     C                   CLEAR                   TRANS17                                      CSD079
     C                   CLEAR                   TRANS18                                      CSD079
     C                   CLEAR                   BCLData                                      CSD079
     C                   CLEAR                   EurRepData                                   CSD079
     C                   CLEAR                   TRANS8A                                      CSD079
     C                   CLEAR                   TRANS8B                                      CSD079
     C                   CLEAR                   Trans83                                      CER059
     C                   CLEAR                   Trans84                                      CER059
     C                   CLEAR                   TransCUA1                                    CER059
     C                   CLEAR                   TransCUA2                                    CER059
     C                   CLEAR                   TransCUA3                                    CER059
     C                   CLEAR                   TransACT1                                    CER059
     C                   CLEAR                   TransACT2                                    CER059
     C                   CLEAR                   TransACT3                                    CER059
     C                   CLEAR                   TransACT4                                    CER059
     C                   CLEAR                   TransACT5                                    CER059
     C                   CLEAR                   TransACT6                                    CER059
     C                   CLEAR                   RegData                                      CSD079
     C                   CLEAR                   PaySttmt
     C                   CLEAR                   RecSttmt
     C                   CLEAR                   FRASttmt
     C                   CLEAR                   ExtData
     C                   CLEAR                   InfData
     C                   CLEAR                   FCIPNotes                                  BUG10093
     C                   CLEAR                   CustData                                     CER043
     C                   CLEAR                   StampTax                                     CER049
     C                   CLEAR                   TransQ                                       CER049
     C                   CLEAR                   InSwift2013                                  CSW213
     C***/COPY*OFCPYSRCZ,CAP090_002                                                    CAP090 CLE164
     C                   CLEAR                   SBJBParm                                     CLE164
     C                   CLEAR                   InputUser                                  MD042042
     C                   CLEAR                   InCDL099                                     CDL099
     C                   CLEAR                   AuthUsers                                    CFT163
     C/COPY OFCPYSRCZ,CGL135_042                                                             CGL135A
     C/COPY OFCPYSRCZ,CRE101_002                                                              CRE101
     C/COPY OFCPYSRCZ,CGL158_002                                                              CGL158

      ** Position Buffer pointer to 1st byte

     C                   Z-ADD     1             Bfp               4 0
     C                   Z-ADD     1             Bfp2              4 0                      BUG10296

     C                   SELECT

      * FX deals

     C     TransTYPE     WHENEQ    'FXDL'

     C                   EXSR      FXDLFmts
     C                   EXSR      SettleFmts
     C                   EXSR      RPIFFmts                                                   CSW213

     C     FXDLLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FXDLLn        Bfp
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4087
     C                   ADD       26            Bfp                                         BUG4087
      *                                                                                       CER043
     C*****SDCULn        SUBST     BUFFER:Bfp    CustData                              CER043 CSF011
     C**********         ADD       SDCULn        Bfp                                   CER043 CSF011
      *                                                                                       CER043
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CSW212
     C                   ADD       ESSFLn        Bfp                                          CSW212
     C*****CFIFLn        SUBST     BUFFER:Bfp    InfData                              CTI004 BUG2789
     C**********         ADD       CFIFLn        Bfp                                  CTI004 BUG2789
     C     FXIFLn        SUBST     BUFFER:Bfp    InfData                                     BUG4815
     C                   ADD       FXIFLn        Bfp                                         BUG4815
     C     FXFXLn        SUBST     BUFFER:Bfp    ExtData
     C                   ADD       FXFXLn        Bfp                                          CSW213
     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213
     C                   ADD       RPIFLn        Bfp                                          CDL099
     C     FXEDLn        SUBST     BUFFER:Bfp    InCDL099                                     CDL099

     C                   CALL      'FXFXDLVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans1
     C**********         PARM                    CustData                              CER043 CSF011
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                     BUG4815
     C                   PARM                    ExtData
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4190
     C                   PARM                    InCDL099                                     CDL099
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FXFXDLUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * MM Loan/deposit deals

     C     TransTYPE     WHENEQ    'LDNI'

     C                   EXSR      LDNIFmts
     C                   EXSR      SettleFmts
     C                   EXSR      FSettleFmts                                                CDL018

     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
     C     LDNILn        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
     C                   ADD       LDNILn        Bfp
     C     LDIFLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LDIFLn        Bfp
      **  Restore Timestamp field from the record                                            BUG3986
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG3986
     C                   ADD       26            Bfp                                         BUG3986
      **  Send Block/Unblock action from the JSP action button                               BUG3684
     C     1             SUBST     BUFFER:Bfp    DDACTC                                      BUG3684
     C                   ADD       1             Bfp                                         BUG3684
      **  Send Placing/Taking indicator for JSP Block/Unblock conditioning.                  BUG3792
     C     1             SUBST     BUFFER:Bfp    PLATAK                                      BUG3792
     C                   ADD       1             Bfp                                         BUG3792
     C     1             SUBST     BUFFER:Bfp    ACTRJ                                      AR701789
     C                   ADD       1             Bfp                                        AR701789
     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
     C                   ADD       20            Bfp                                          239400
     C     FSSRLn        SUBST     BUFFER:Bfp    #FRECS                                       CDL018
     C                   ADD       FSSRLn        Bfp                                          CDL018
     C     FSSPLn        SUBST     BUFFER:Bfp    #FPAYS                                       CDL018
     C                   ADD       FSSPLn        Bfp                                          CDL018
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     90            SUBST     BUFFER:Bfp    WDUMMY                                     BUG10563
     C                   ADD       90            Bfp                                        BUG10563
      *                                                                                       CER043
      ***Need*to*add*240*+*2072*to*extract*the*Customer*ease*of*use*details*         CER043 MD054028
      ** Need to add 240 + 2034 to extract the Customer ease of use details                 MD054028
      ** Narrative - 240 (SFNARR01 (60A) + SFNARR02 (60A) +                                   CER043
      **                  SFNARR03 (60A) + SFNARR04 (60A))                                    CER043
      ***Filler2*-*2072A***********************************************              CER043 MD054028
      ** Filler2 - 2034A                                                                    MD054028
      *                                                                                       CER043
     C                   ADD       240           Bfp                                          CER043
     C**********         ADD       2072          Bfp                                   CER043 CSF011
     C**********         ADD       605           Bfp                                   CSF011 CDL096
     C**********         ADD       571           Bfp                                   CDL096 CGL165
     C**********         ADD       567           Bfp                                   CGL165 CER050
     C**********         ADD       558           Bfp                                 CER050 MD054028
      ** Buffer1 has remaining 356 fields that should be empty because of Filler2           MD054028
     C                   ADD       356           Bfp                                        MD054028
      ** Remaining from Filler2 is 1678 = 2034 - 356                                        MD054028
                                                                                              CSF011
      ** Start of Buffer2                                                                     CSF011
                                                                                              CSF011
     C**********         ADD       1467          Bfp2                                CSF011 MD038485
     C**********         ADD       1681          Bfp2                                MD038485 CER050
     C**********         ADD       1680          Bfp2                                CER050 MD054028
     C                   ADD       1678          Bfp2                                       MD054028
      *                                                                                       CER043
     C*****LDSTQLn       SUBST     BUffer:Bfp    TransQ                             CER049 AR819540A
     C**********         ADD       LDSTQLn       Bfp                                CER049 AR819540A
                                                                                              CER049
     C*****SDCULn        SUBST     BUFFER:Bfp    CustData                              CER043 CSF011
     C**********         ADD       SDCULn        Bfp                                   CER043 CSF011
                                                                                           AR819540A
     C*****LDSTQLn       SUBST     BUffer:Bfp    TransQ                             AR819540A CSF011
     C**********         ADD       LDSTQLn       Bfp                                AR819540A CSF011
     C     LDSTQLn       SUBST     BUFFER2:Bfp2  TransQ                                       CSF011
     C                   ADD       LDSTQLn       Bfp2                                         CSF011
      *                                                                                       CER043
      ***This*should*be*reduced*everytime*a*core*field*is*added*on*the*buffer      BUG10296 BUG10563
     C*****3953**        SUBST     BUFFER2:Bfp2  LDNIFiller                        BUG10296 BUG10563
     C**********         ADD       3953          Bfp2                              BUG10296 BUG10563
                                                                                              CSF011
      ** Previous data: from Buffer excess and Buffer2 length: 4752                           CSF011
      ** Use current excess from Buffer2 then continue on BUfferEx2                           CSF011
                                                                                              CSF011
     C                   ADD       2437          Bfp2                                         CSF011
                                                                                              CSF011
      ** End of BUffer2                                                                       CSF011
      ** Reset Bfp2 to be re-use for BufferEx2                                                CSF011
                                                                                              CSF011
     C                   Z-ADD     1             Bfp2                                         CSF011
     C                   ADD       2315          Bfp2                                         CSF011
     C     4800          SUBST     BufferEx2:Bfp2RatDateDS                                  BUG10563
     C                   ADD       4800          Bfp2                                       BUG10563
     C*****4800*         SUBST     BufferEx2:Bfp2PayDateDS                           BUG10563 CSF011
     C**********         ADD       4800          Bfp2                                BUG10563 CSF011
     C     2884          SUBST     BufferEx2:Bfp2PayDateDS                                    CSF011
     C                   ADD       2884          Bfp2                                         CSF011
                                                                                              CSF011
      ** End of BufferEx2                                                                     CSF011
      ** Reset Bfp2 to be re-use for BufferEx3                                                CSF011
                                                                                              CSF011
     C                   Z-ADD     1             Bfp2                                         CSF011
     C                   ADD       1916          Bfp2                                         CSF011
     C*****LDRXLn        SUBST     BufferEx2:Bfp2RegData                             BUG10563 CSF011
     C     LDRXLn        SUBST     BufferEx3:Bfp2RegData                                      CSF011
     C*****LDRXLn        SUBST     BUFFER2:Bfp2  RegData                           BUG10296 BUG10563
     C*****LDRXLn        SUBST     BUFFER:Bfp    RegData                             CER001 BUG10296
     C**********         ADD       LDRXLn        Bfp                                 CER001 BUG10296
     C*****LDEXLn        SUBST     BUFFER:Bfp    ExtData                                    BUG10296
     C                   ADD       LDRXLn        Bfp2                                         248299
     C*****LDEXLn        SUBST     BufferEx2:Bfp2ExtData                               248299 CSF011
     C     LDEXLn        SUBST     BufferEx3:Bfp2ExtData                                      CSF011
     C                   ADD       LDEXLn        Bfp2                                         248299

     C                   CALL      'MMLDNIVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C**********         PARM                    Trans1                                      CSF011A
     C                   PARM                    Trans1A                                     CSF011A
     C                   PARM                    Trans2
     C                   PARM                    TransQ                                       CER049
     C**********         PARM                    CustData                              CER043 CSF011
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    #FPAYS                                       CDL018
     C                   PARM                    #FRECS                                       CDL018
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                      CDL033
     C                   PARM                    BufferEx2                                    CDL033
     C                   PARM                    BufferEx3                                    CSF011
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG3986
     C                   PARM                    DDACTC                                      BUG3684
     C                   PARM                    PLATAK                                      BUG3792
     C                   PARM                    ACTRJ                                      AR701789
     C                   PARM                    DDFOID                                       239400
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'MMLDNIUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Incoming Payments

     C     TransTYPE     WHENEQ    'IPAY'

     C                   EXSR      IPAYFmts

     C*****IPY1Ln        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
     C     IPY1Ln        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
     C                   ADD       IPY1Ln        Bfp
     C     IPY2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       IPY2Ln        Bfp
     C*****IPY3Ln        SUBST     BUFFER:Bfp    TRANS3                                      CSF011A
     C     IPY3Ln        SUBST     BUFFER:Bfp    TRANS3A                                     CSF011A
     C                   ADD       IPY3Ln        Bfp
     C     IPY4Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       IPY4Ln        Bfp
     C*****IPY5Ln        SUBST     BUFFER:Bfp    TRANS5                                      CSF011A
     C     IPY5Ln        SUBST     BUFFER:Bfp    TRANS5A                                     CSF011A
     C                   ADD       IPY5Ln        Bfp
     C     IPY6Ln        SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       IPY6Ln        Bfp
     C     IPY7Ln        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       IPY7Ln        Bfp
     C     IPY8Ln        SUBST     BUFFER:Bfp    TRANS8
     C                   ADD       IPY8Ln        Bfp
     C                   IF        CSW209 = 'Y'                                             BUG25664
     C     IPY9ALn       SUBST     BUFFER:Bfp    TRANS9A                                      CSW209
     C                   ADD       IPY9ALn       Bfp                                          CSW209
     C     IPY9BLn       SUBST     BUFFER:Bfp    TRANS9B                                      CSW209
     C                   ADD       IPY9BLn       Bfp                                          CSW209
     C                   ENDIF                                                              BUG25664
      *                                                                                       CER030
     C     IPY9Ln        SUBST     BUFFER:Bfp    TRANS9                                       CER030
     C                   ADD       IPY9Ln        Bfp                                          CER030
      *                                                                                       CER030
      **  Restore Timestamp field from the record                                            BUG4196
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4196
     C                   ADD       26            Bfp                                         BUG4196
      **  Restore value of Newbutton                                                          255190
     C     3             SUBST     BUFFER:Bfp    NewButton                                    255190
     C                   ADD       3             Bfp                                          255190
      *                                                                                       CER049
     C     IPY10Ln       SUBST     BUFFER:Bfp    TRANS10                                      CER049
     C                   ADD       IPY10Ln       Bfp                                          CER049
      *                                                                                    AR1002463
     C     1             SUBST     BUFFER:Bfp    AAuth                                     AR1002463
     C                   ADD       1             Bfp                                       AR1002463
     C     10            SUBST     BUFFER:Bfp    BtnPressed                                AR1090283
     C                   ADD       10            Bfp                                       AR1090283
      *                                                                                     MD042042
     C     IPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD042042
     C                   ADD       IPEXLn        Bfp                                        MD042042
      *                                                                                     MD042042
     C     10            SUBST     BUFFER:Bfp    InputUser                                  MD042042
     C                   ADD       10            Bfp                                        MD042042
     C/COPY WNCPYSRC,APH00058
      *                                                                                       CER049
     C     IPRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       IPRXLn        Bfp                                          CER001
     C*****IPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD042042
     C**********         ADD       IPEXLn        Bfp                               BUG22140 MD042042
     C/COPY WNCPYSRC,APH00059
     C*****1****         SUBST     BUFFER:Bfp    AAuth                            BUG22140 AR1002463
     C**********         ADD       1             Bfp                              BUG22140 AR1002463
     C/COPY WNCPYSRC,APH00060
     C     StopIPLen     SUBST     BUFFER:Bfp    StopFTDta                                  MD050928
     C                   ADD       StopIPLen     Bfp                                        MD050928

     C                   CALL      'FTIPAYVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C**********         PARM                    Trans1                                      CSF011A
     C                   PARM                    Trans1A                                     CSF011A
     C                   PARM                    Trans2
     C**********         PARM                    Trans3                                      CSF011A
     C                   PARM                    Trans3A                                     CSF011A
     C                   PARM                    Trans4
     C**********         PARM                    Trans5                                      CSF011A
     C                   PARM                    Trans5A                                     CSF011A
     C                   PARM                    Trans6
     C                   PARM                    Trans7
     C                   PARM                    Trans8
     C                   PARM                    Trans9A                                      CSW209
     C                   PARM                    Trans9B                                      CSW209
     C                   PARM                    Trans9                                       CER030
     C                   PARM                    Trans10                                      CER049
      ** Extra Data
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    StopFTDta                                  MD050928
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4196
     C                   PARM                    NewButton                                    255190
     C                   PARM                    AAuth                                      BUG22140
     C                   PARM                    InputUser                                  MD042042
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FTIPAYUPD'                                       CRE020
     C                   EVAL      WrkMod = 'FT'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Outgoing payments

     C     TransTYPE     WHENEQ    'OPAY'

     C                   EXSR      OPAYFmts

     C*****OPY1Ln        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
     C     OPY1Ln        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
     C                   ADD       OPY1Ln        Bfp
     C*****OPY2Ln        SUBST     BUFFER:Bfp    TRANS2                                      CSF011A
     C     OPY2Ln        SUBST     BUFFER:Bfp    TRANS2A                                     CSF011A
     C                   ADD       OPY2Ln        Bfp
     C*****OPY3Ln        SUBST     BUFFER:Bfp    TRANS3                                      CSF011A
     C     OPY3Ln        SUBST     BUFFER:Bfp    TRANS3A                                     CSF011A
     C                   ADD       OPY3Ln        Bfp
     C*****OPY4Ln        SUBST     BUFFER:Bfp    TRANS4                                       CFT120
     C     OPY4Ln        SUBST     BUFFER:Bfp    TRANS4A                                      CFT120
     C                   ADD       OPY4Ln        Bfp
     C     OPY5Ln        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       OPY5Ln        Bfp
     C*****OPY6Ln        SUBST     BUFFER:Bfp    TRANS6                                      CSF011A
     C*****OPY6Ln        SUBST     BUFFER:Bfp    TRANS6A                              CSF011A CFT120
     C     OPY6Ln        SUBST     BUFFER:Bfp    TRANS6                                       CFT120
     C                   ADD       OPY6Ln        Bfp
     C     OPY7Ln        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       OPY7Ln        Bfp
     C     OPY7Ln        SUB       500           OPY8Ln            4 0
     C                   SUB       OPY8Ln        Bfp
     C     OPY8Ln        SUBST     BUFFER:Bfp    TRANS8
     C                   ADD       OPY8Ln        Bfp
     C     OPY9Ln        SUBST     BUFFER:Bfp    TRANS9
     C                   ADD       OPY9Ln        Bfp
     C                   IF        CSW209 = 'Y'                                             BUG25664
     C     OPY10Ln       SUBST     BUFFER:Bfp    TRANS9A                                      CSW209
     C                   ADD       OPY10Ln       Bfp                                          CSW209
     C     OPY11Ln       SUBST     BUFFER:Bfp    TRANS9B                                      CSW209
     C                   ADD       OPY11Ln       Bfp                                          CSW209
     C                   ENDIF                                                              BUG25664
      *                                                                                       CER030
     C     OPY10LAn      SUBST     BUFFER:Bfp    TRANS10A                                     CER030
     C                   ADD       OPY10LAn      Bfp                                          CER030
      *                                                                                       CER030
     C     OPY11LAn      SUBST     BUFFER:Bfp    TRANS11A                                     CER030
     C                   ADD       OPY11LAn      Bfp                                          CER030
      *                                                                                       CER030
      **  Restore Timestamp field from the record                                            BUG4196
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4196
     C                   ADD       26            Bfp                                         BUG4196
     C     WLCLn         SUBST     BUFFER:Bfp    WLCData                                      CSD083
     C                   ADD       WLCLn         Bfp                                          CSD083
     C                   EVAL      TRANS11B = %SUBST(WLCData:9:176)                           CFT039
     C*****OPY12Ln       SUBST     BUFFER:Bfp    TRANS12                               CER049 CFT120
     C**********         ADD       OPY12Ln       Bfp                                   CER049 CFT120
     C*****19            SUBST     BUFFER:Bfp    #TempData        19                   CFT120 CFT157
     C*****              ADD       19            Bfp                                   CFT120 CFT157
     C*****9             SUBST     BUFFER:Bfp    #TempData         9                CFT157 MD050928A
     C******             ADD       9             Bfp                                CFT157 MD050928A
     C     19            SUBST     BUFFER:Bfp    #TempData        19                       MD050928A
     C                   ADD       19            Bfp                                       MD050928A
      *                                                                                    AR1002463
     C*****1****         SUBST     BUFFER:Bfp    AAuth                              AR1002463 CFT120
     C**********         ADD       1             Bfp                                AR1002463 CFT120
     C*****1             SUBST     BUFFER2:Bfp2  #TempData2        1                   CFT120 CFT157
     C*****              ADD       1             Bfp2                                  CFT120 CFT157
     C*****11            SUBST     BUFFER2:Bfp2  #TempData2       11                CFT157 MD050928A
     C*****              ADD       11            Bfp2                               CFT157 MD050928A
     C     1             SUBST     BUFFER2:Bfp2  #TempData2        1                       MD050928A
     C                   ADD       1             Bfp2                                      MD050928A
     C                   MOVEL     #TempData     #TempTrans12     20                          CFT120
     C                   MOVE      #TempData2    #TempTrans12                                 CFT120
     C                   EVAL      TRANS12 = #TempTrans12                                     CFT120
      *                                                                                       CFT120
     C     1             SUBST     BUFFER2:Bfp2  AAuth                                        CFT120
     C                   ADD       1             Bfp2                                         CFT120
     C     10            SUBST     BUFFER:Bfp2   BtnPressed                                 MD039986
     C                   ADD       10            Bfp2                                       MD039986
      *                                                                                     MD042042
     C     OPEXLn        SUBST     BUFFER2:Bfp2  ExtData                                    MD042042
     C                   ADD       OPEXLn        Bfp2                                       MD042042
      *                                                                                     MD042042
     C     10            SUBST     BUFFER2:Bfp2  InputUser                                  MD042042
     C                   ADD       10            Bfp2                                       MD042042
      *                                                                                    AR1002463
     C*****2****         SUBST     BUFFER:Bfp    TempData#3                         CSF011 AR1005984
     C/COPY WNCPYSRC,APH00061
     C**********         ADD       2             Bfp                                CSF011 AR1005984
     C*****1****         SUBST     BUFFER:Bfp    TempData#3                         AR1005984 CFT120
     C**********         ADD       1             Bfp                                AR1005984 CFT120
     C**********         SUB       2             OPRXLn                             CSF011 AR1005984
     C**********         SUB       1             OPRXLn                             AR1005984 CFT120
     C*****OPRXLn        SUBST     BUFFER:Bfp    RegData                               CER001 CSF011
     C*****OPRXLn        SUBST     BUFFER2:Bfp2  TempData#4                            CSF011 CFT120
     C     OPRXLn        SUBST     BUFFER2:Bfp2  RegData                                      CFT120
     C**********         MOVEL     TempData#3    RegData                               CSF011 CFT120
     C**********         MOVE      TempData#4    RegData                               CSF011 CFT120
     C**********         ADD       OPRXLn        Bfp                                   CER001 CSF011
     C*****OPEXLn        SUBST     BUFFER:Bfp    ExtData                                      CSF011
     C**********         ADD       OPEXLn        Bfp                                 BUG22140 CSF011
     C*****1****         SUBST     BUFFER:Bfp    AAuth                               BUG22140 CSF011
     C**********         ADD       1             Bfp                                 BUG22140 CSF011
     C                   ADD       OPRXLn        Bfp2                                         CSF011
     C*****OPEXLn        SUBST     BUFFER2:Bfp2  ExtData                             CSF011 MD042042
     C**********         ADD       OPEXLn        Bfp2                                CSF011 MD042042
     C/COPY WNCPYSRC,APH00062
     C*****1****         SUBST     BUFFER2:Bfp2  AAuth                              CSF011 AR1002463
     C**********         ADD       1             Bfp2                               CSF011 AR1002463
     C/COPY WNCPYSRC,APH00063
     C                   EVAL      StopFTDta = %SUBST(BUFFER2:Bfp2:StopOPLen)               MD050928
     C                   ADD       StopOPLen     Bfp2                                       MD050928

     C                   CALL      'FTOPAYVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C**********         PARM                    Trans1                                      CSF011A
     C**********         PARM                    Trans2                                      CSF011A
     C**********         PARM                    Trans3                                      CSF011A
     C                   PARM                    Trans1A
     C                   PARM                    Trans2A
     C                   PARM                    Trans3A
     C**********         PARM                    Trans4                                       CFT120
     C                   PARM                    Trans4A                                      CFT120
     C                   PARM                    Trans5
     C**********         PARM                    Trans6                                      CSF011A
     C**********         PARM                    Trans6A                              CSF011A CFT120
     C                   PARM                    Trans6                                       CFT120
     C                   PARM                    Trans7
     C                   PARM                    Trans8
     C                   PARM                    Trans9
     C                   PARM                    Trans9A                                      CSW209
     C                   PARM                    Trans9B                                      CSW209
     C                   PARM                    Trans10A                                     CER030
     C                   PARM                    Trans11A                                     CER030
     C                   PARM                    Trans11B                                     CFT039
     C                   PARM                    Trans12                                      CER049

     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    StopFTDta                                  MD050928

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                      CSF011
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4196
     C                   PARM                    AAuth                                      BUG22140
     C                   PARM                    InputUser                                  MD042042
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FTOPAYUPD'                                       CRE020
     C                   EVAL      WrkMod = 'FT'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * GL Accounts Maintenance

     C     TransTYPE     WHENEQ    'AMAD'
     C     TransTYPE     OREQ      'ACMC'                                                     CRE026
     C     TransTYPE     OREQ      'ACMI'                                                     CRE026
     C     TransTYPE     OREQ      'ACMN'                                                     CRE026

     C                   EXSR      AMADFmts

     C*****AMMDLn        SUBST     BUFFER:Bfp    TRANS1                                     MD044880
     C                   EVAL      TRANS1 = %SUBST(BufferTotal:Bfp:AMMDLn)                  MD044880
     C                   ADD       AMMDLn        Bfp
     C*****AMDILn        SUBST     BUFFER:Bfp    TRANS2                                     MD044880
     C                   EVAL      TRANS2 = %SUBST(BufferTotal:Bfp:AMDILn)                  MD044880
     C                   ADD       AMDILn        Bfp
     C*****AMCILn        SUBST     BUFFER:Bfp    TRANS3                                     MD044880
     C                   EVAL      TRANS3 = %SUBST(BufferTotal:Bfp:AMCILn)                  MD044880
     C                   ADD       AMCILn        Bfp
     C*****AMCOLn        SUBST     BUFFER:Bfp    TRANS4                                     MD044880
     C                   EVAL      TRANS4 = %SUBST(BufferTotal:Bfp:AMCOLn)                  MD044880
     C                   ADD       AMCOLn        Bfp
     C*****AMODLn        SUBST     BUFFER:Bfp    TRANS5                                     MD044880
     C                   EVAL      TRANS5 = %SUBST(BufferTotal:Bfp:AMODLn)                  MD044880
     C                   ADD       AMODLn        Bfp                                         BUG4196
      **  Restore Timestamp field from the record                                            BUG4196
     C*****26***         SUBST     BUFFER:Bfp    @TimeStamp                         BUG4196 MD044880
     C                   EVAL      @TimeStamp = %SUBST(BufferTotal:Bfp:26)                  MD044880
     C                   ADD       26            Bfp                                         BUG4196
     C*****AMADFLn       SUBST     BUFFER:Bfp    AMADFiller                         BUG5988 MD044880
     C                   EVAL      AMADFiller = %SUBST(BufferTotal:Bfp:AMADFLn)             MD044880
     C                   ADD       AMADFLn       Bfp                                         BUG5988
     C*****AMPPLn1       SUBST     BUFFER:Bfp    TRANS6                              CRE015 MD044880
     C                   EVAL      TRANS6 = %SUBST(BufferTotal:Bfp:AMPPLn1)                 MD044880
     C                   ADD       AMPPLn1       Bfp                                          CRE015
     C*****124**         SUBST     BUFFER:Bfp    StampTax                            CER049 MD044880
     C                   EVAL      StampTax = %SUBST(BufferTotal:Bfp:124)                   MD044880
     C                   ADD       124           Bfp                                          CER049
     C*****24***         SUBST     BUFFER:Bfp    GLFullAcct                        MD026979 MD044880
     C                   EVAL      GLFullAcct = %SUBST(BufferTotal:Bfp:24)                  MD044880
     C                   ADD       24            Bfp                                        MD026979
     C***/COPY*OFCPYSRCZ,CRE101_003                                                  CRE101 MD044880
     C                   EVAL      ACMILn = 10                                              MD054028
     C                   EVAL      ACMIData = %SUBST(BufferTotal:Bfp:ACMILn)                MD044880
     C                   ADD       ACMILn        Bfp                                        MD044880
     C*****AMIFLn        SUBST     BUFFER:Bfp    InfData                             CAP086 MD044880
     C                   EVAL      InfData = %SUBST(BufferTotal:Bfp:AMIFLn)                 MD044880
     C                   ADD       AMIFLn        Bfp                                        BUG10280
     C                   EVAL      ExtData = %SUBST(BufferTotal:Bfp:AMEXLn)                 MD044880
     C                   ADD       AMEXLn        Bfp                                        MD044800
                                                                                            MD054028
      *** APR Fields for AMAD (CER050)                                                      MD054028
     C     AMCR50Ln      SUBST     BUFFER:Bfp    AMAPRDta         17                        MD054028
     C                   EVAL      ExtData = %SUBST(ExtData:1:AMEXLn) + AMAPRDta            MD054028
     C                   ADD       AMCR50Ln      Bfp                                        MD054028
                                                                                            MD054028
     C                   EVAL      RepeatData = %SUBST(BufferTotal:Bfp:AMPPLn2)             MD044880
     C                   ADD       AMPPLn2       Bfp                                        MD044880
     C                   EVAL      RegData = %SUBST(BufferTotal:Bfp:AMRXLn)                 MD044880
     C                   ADD       AMRXLn        Bfp                                        MD044880
     C*****AMPPLn2       SUBST     BUFFER:Bfp    RepeatData                            CRE015 CRE073
     C**********         ADD       AMPPLn2       Bfp                                   CRE015 CRE073
     C*****AMRXLn        SUBST     BUFFER:Bfp    RegData                               CER001 CRE073
     C**********         ADD       AMRXLn        Bfp                                   CER001 CRE073
     C*****AMEXLn        SUBST     BUFFER:bfp    Extdata                             BUG10280 CRE073
     C**********         ADD       AMEXLn        Bfp                                 BUG10280 CRE073
     C*****4972*         SUBST     BUFFER:Bfp    TempData#1                           CRE073 CSF011A
     C**********         ADD       4972          Bfp                                  CRE073 CSF011A
     C*****410**         SUBST     BUFFER2:Bfp2  TempData#2                           CRE073 CSF011A
     C*****4932*         SUBST     BUFFER:Bfp    TempData#1                         CSF011A AR946674
     C**********         ADD       4932          Bfp                                CSF011A AR946674
     C*****4923*         SUBST     BUFFER:Bfp    TempData#1                        AR946674 MD026979
     C**********         ADD       4923          Bfp                               AR946674 MD026979
     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
     C*****4899*         SUBST     BUFFER:Bfp    TempData#1                        MD026979 MD044880
     C**********         ADD       4899          Bfp                               MD026979 MD044880
     C***/COPY*OFCPYSRCZ,CRE101_064                                                  CRE101 MD044880
     C*****450**         SUBST     BUFFER2:Bfp2  TempData#2                         CSF011A AR946674
     C*****459**         SUBST     BUFFER2:Bfp2  TempData#2                        AR946674 MD026979
     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
     C*****483**         SUBST     BUFFER2:Bfp2  TempData#2                        MD026979 MD044880
     C***/COPY*OFCPYSRCZ,CRE101_065                                                  CRE101 MD044880
     C**********         MOVEL     TempData#1    RepeatData                          CRE073 MD044880
     C**********         MOVE      TempData#2    RepeatData                          CRE073 MD044880
     C**********         ADD       410           Bfp2                                 CRE073 CSF011A
     C*****AMRXLn        SUBST     BUFFER:Bfp2   InfData                              CRE073 CSF011A
     C**********         ADD       AMRXLn        Bfp                                  CRE073 CSF011A
     C**********         ADD       450           Bfp2                               CSF011A AR946674
     C**********         ADD       459           Bfp2                              AR946674 MD026979
     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
     C**********         ADD       483           Bfp2                              MD026979 MD044880
     C***/COPY*OFCPYSRCZ,CRE101_066                                                  CRE101 MD044880
     C*****AMRXLn        SUBST     BUFFER2:Bfp2  RegData                            CSF011A MD044880
     C**********         ADD       AMRXLn        Bfp2                               CSF011A MD044880
     C*****AMEXLn        SUBST     BUFFER2:Bfp2  Extdata                             CRE073 MD044880
     C**********         ADD       AMEXLn        Bfp2                                CRE073 MD044880
      ** Remove fix MD054028                                                                MD054538
     C**********         EVAL      Buffer9999 = Buffer + Buffer2                   MD054028 MD054538

     C                   CALL      'GLAMADVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    Trans4
     C                   PARM                    Trans5
     C                   PARM                    Trans6                                       CRE015
     C                   PARM                    StampTax                                     CER049
     C/COPY OFCPYSRCZ,CRE101_004                                                              CRE101
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    RepeatData                                   CRE015
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C**********         PARM                    Buffer                                     MD044880
     C**********         PARM                    Buffer2                             CRE073 MD044880
     C                   PARM                    Buffer9999                                 MD044880
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4196
     C                   PARM                    GLFullAcct                                 MD026979

     C                   MOVEL     Buffer9999    Buffer                                     MD044880
     C                   MOVE      Buffer9999    Buffer2                                    MD044880

      * GL Journal Entry Header Maintenance
      * GL Journal Entry Header Maintenance - Non-retail                                     BUG9009

     C     TransTYPE     WHENEQ    'BITH'
     C     TransTYPE     OrEq      'BINH'                                                    BUG9009

     C                   EXSR      BITHFmts

     C     BITHLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       BITHLn        Bfp
     C     8             SUBST     BUFFER:Bfp    PEAHeader         8                          CSC054
     C                   ADD       8             Bfp                                          CSC054
     C     GLIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       GLIFLn        Bfp                                          CAP086
     C     BHEXLn        SUBST     BUFFER:Bfp    ExtData
     C                   ADD       BHEXLn        Bfp                                        MD054696
     C     1             SUBST     BUFFER:Bfp    PShadowPost       1                        MD054696
     C                   ADD       1             Bfp                                        MD054696

     C                   CALL      'GLBITHVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    PEAHeader                                    CSC054
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ExtData
     C                   PARM                    PShadowPost                                MD054696
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * GL Journal Entry Item Maintenance
      * GL Journal Entry Item Maintenance - Non-retail                                       BUG9009

     C     TransTYPE     WHENEQ    'BITP'
     C     TransTYPE     OrEq      'BINP'                                                    BUG9009

     C                   EXSR      BITPFmts

     C     BITPLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       BITPLn        Bfp
     C     BIPXLn        SUBST     BUFFER:Bfp    OthData                                      246418
     C                   ADD       BIPXLn        Bfp                                          246418
      *                                                                                     BUG23742
     C     500           SUBST     BUFFER:Bfp    POthNarr1                                  BUG23742
     C                   ADD       500           Bfp                                        BUG23742
      *                                                                                     BUG23742
     C     270           SUBST     BUFFER:Bfp    POthNarr2                                  BUG23742
     C                   ADD       270           Bfp                                        BUG23742
      *                                                                                     BUG23742
     C*****13***         SUBST     BUFFER:Bfp    PEADetail        13                CSC054 AR1005162
     C**********         ADD       13            Bfp                                CSC054 AR1005162
     C     15            SUBST     BUFFER:Bfp    PEADetail        15                       AR1005162
     C                   ADD       15            Bfp                                       AR1005162
      *                                                                                       CSC054
     C/COPY OFCPYSRCZ,CGL135_043                                                             CGL135A
     C     1             SUBST     BUFFER:Bfp    VDFLTF            1                        MD052075
     C                   ADD       1             Bfp                                        MD052075
     C
     C     BPRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       BPRXLn        Bfp                                          CER001
     C     BPEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'GLBITPVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    OthData                                      246418
     C                   PARM                    POthNarr1                                  BUG23742
     C                   PARM                    POthNarr2                                  BUG23742
     C                   PARM                    PEADetail                                    CSC054
     C/COPY OFCPYSRCZ,CGL135_044                                                             CGL135A
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF                                     MD052075
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * SD Customers

     C     TransTYPE     WHENEQ    'CUSD'
     C     TransTYPE     OREQ      'CSDU'                                                     CSD079
     C     TransTYPE     OREQ      'CSDV'                                                     CSD079

     C                   EXSR      CUSDFmts

     C     SDPRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   EVAL      TransCUPR = TRANS1                                       MD022093
     C                   ADD       SDPRLn        Bfp
     C     SDSELn        SUBST     BUFFER:Bfp    TRANS2
     C                   EVAL      TransCUSE = TRANS2                                       MD022093
     C                   ADD       SDSELn        Bfp
     C     SDMTLn        SUBST     BUFFER:Bfp    TRANS7a                                    BUG14803
     C                   EVAL      TransCUMT = TRANS7a                                      MD022093
     C                   ADD       SDMTLn        Bfp                                        BUG14803
     C     SDMRLn        SUBST     BUFFER:Bfp    TRANS3
     C                   EVAL      TransCUMR = TRANS3                                       MD022093
     C                   ADD       SDMRLn        Bfp
     C     SDB1Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       SDB1Ln        Bfp
     C     SDB2Ln        SUBST     BUFFER:Bfp    TRANS5
     C                   EVAL      TransCUBR = TRANS4 + TRANS5                              MD022093
     C                   ADD       SDB2Ln        Bfp
     C     SDPBLn        SUBST     BUFFER:Bfp    TRANS6
     C                   EVAL      TransCUPB = TRANS6                                       MD022093
     C                   ADD       SDPBLn        Bfp
     C*****SDMTLn        SUBST     BUFFER:Bfp    TRANS7a                           BUG14485 BUG14803
     C**********         ADD       SDMTLn        Bfp                               BUG14485 BUG14803
     C     SDMILn        SUBST     BUFFER:Bfp    TRANS7                                       CSD079
     C                   EVAL      TransCUMI = TRANS7                                       MD022093
     C                   ADD       SDMILn        Bfp                                          CSD079
     C                   EVAL      TRANS8  = %SUBST(BUFFER:Bfp:SDADLn)                        CSD079
     C                   ADD       SDADLn        Bfp                                          CSD079
     C                   EVAL      TRANS8A = %SUBST(BUFFER:Bfp:SDADLnA)                       CSD079
     C                   ADD       SDADLnA       Bfp                                          CSD079
     C                   EVAL      TRANS8B = %SUBST(BUFFER:Bfp:SDADLnB)                       CSD079
     C                   ADD       SDADLnB       Bfp                                        MD050342
     C                   EVAL      TRANS8C = %SUBST(BUFFER:Bfp:SDADLnC)                       CGL157
     C                   EVAL      TransCUAD = TRANS8 + TRANS8A + TRANS8B                   MD022093
     C                                         + TRANS8C                                      CGL157
     C**********         ADD       SDADLnB       Bfp                                 CSD079 MD050342
     C                   ADD       SDADLnC       Bfp                                          CGL157
     C                   EVAL      Trans83 = %SUBST(BUFFERTOTAL:Bfp:SDADLn3)                  CER059
     C                   EVAL      TransACU3 = TRANS83                                      MD022093
     C                   ADD       SDADLn3       Bfp                                          CER059
     C                   EVAL      Trans84 = %SUBST(BUFFERTOTAL:Bfp:SDADLn4)                  CER059
     C                   EVAL      TransACU4 = TRANS84                                      MD022093
     C                   ADD       SDADLn4       Bfp                                          CER059
     C     SDSFLn        SUBST     BUFFER:Bfp    TRANS9                                       CSD079
     C                   EVAL      TransSFEE = TRANS9                                       MD022093
     C                   ADD       SDSFLn        Bfp                                          CSD079
     C     SDCHLn        SUBST     BUFFER:Bfp    TRANS10                                      CSD079
     C                   EVAL      TransCHEC = TRANS10                                      MD022093
     C                   ADD       SDCHLn        Bfp                                          CSD079
     C     SDCHLn        SUB       500           ExtLength                                    CSD079
     C                   SUB       ExtLength     Bfp                                          CSD079
     C     ExtLength     SUBST     BUFFER:Bfp    TRANSEXT                                     CSD079
     C                   ADD       ExtLength     Bfp                                          CSD079
     C     SDCSLn        SUBST     BUFFER:Bfp    TRANS11                                      CSD079
     C                   EVAL      TransCUSF = TRANS11                                      MD022093
     C                   ADD       SDCSLn        Bfp                                          CSD079
     C     SDFXLn        SUBST     BUFFER:Bfp    TRANS12                                      CSD079
     C                   EVAL      TransCUFX = TRANS12                                      MD022093
     C                   ADD       SDFXLn        Bfp                                          CSD079
     C     SDFDLn        SUBST     BUFFER:Bfp    TRANS13                                      CSD079
     C                   EVAL      TransCUFD = TRANS13                                      MD022093
     C                   ADD       SDFDLn        Bfp                                          CSD079
     C     SDFOLn        SUBST     BUFFER:Bfp    TRANS14                                      CSD079
     C                   EVAL      TransCUFO = TRANS14                                      MD022093
     C                   ADD       SDFOLn        Bfp                                          CSD079
     C     SDPMLn        SUBST     BUFFER:Bfp    TRANS15                                      CSD079
     C                   EVAL      TransCUPM = TRANS15                                      MD022093
     C                   ADD       SDPMLn        Bfp                                          CSD079
     C     SDTILn        SUBST     BUFFER:Bfp    TRANS16                                      CSD079
     C                   EVAL      TransTICD = TRANS16                                      MD022093
     C                   ADD       SDTILn        Bfp                                          CSD079
     C     CUSWLn        SUBST     BUFFER:Bfp    TransSW                                    BUG14992
     C                   EVAL      TransCUSW = TRANSSW                                      MD022093
     C                   ADD       CUSWLn        Bfp                                        BUG14992
     C     SDCULn        SUBST     BUFFER:Bfp    RegData                                      CSD079
     C                   EVAL      TransCURX = RegData                                      MD022093
     C                   ADD       SDCULn        Bfp                                          CSD079
      **  Restore Timestamp field from the record                                            BUG4196
     C*****26***         SUBST     BUFFER:Bfp    @TimeStamp                         BUG4196 MD022093
     C     26            SUBST     BUFFER:Bfp    TransTimeStmp                              MD022093
     C                   ADD       26            Bfp                                         BUG4196
     C     SDRWLn        SUBST     BUFFER:Bfp    TRANS17                                      CSD079
     C                   EVAL      TransRWAN = TRANS17                                      MD022093
     C                   ADD       SDRWLn        Bfp                                          CSD079
     C*****31***         SUBST     BUFFER:Bfp    StampTax                            CER049 MD022093
     C     31            SUBST     BUFFER:Bfp    TransStmpTax                               MD022093
     C                   ADD       31            Bfp                                          CER049
     C                   EVAL      TransCCTN = %SUBST(BUFFERTOTAL:Bfp:CCTNLn1)              MD021813
     C                   ADD       CCTNLn1       Bfp                                        MD021813
     C**********         EVAL      AAuth     = %SUBST(BUFFERTOTAL:Bfp:1)             CER059 MD022093
     C                   EVAL      TransAUTH = %SUBST(BUFFERTOTAL:Bfp:1)                    MD022093
     C                   Z-ADD     Bfp           xBfp              4 0                      AR316373
     C                   MOVE      TransAUTH     xAAuth            1                        AR316373
     C                   ADD       1             Bfp                                          CER059
     C**********         EVAL      TransCUA1 = %SUBST(BUFFERTOTAL:Bfp:CUA1Ln)        CER059 MD022093
     C**********         ADD       CUA1Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransCUA2 = %SUBST(BUFFERTOTAL:Bfp:CUA2Ln)        CER059 MD022093
     C**********         ADD       CUA2Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransCUA3 = %SUBST(BUFFERTOTAL:Bfp:CUA3Ln)        CER059 MD022093
     C**********         ADD       CUA3Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransACT1 = %SUBST(BUFFERTOTAL:Bfp:ACT1Ln)        CER059 MD022093
     C**********         ADD       ACT1Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransACT2 = %SUBST(BUFFERTOTAL:Bfp:ACT2Ln)        CER059 MD022093
     C**********         ADD       ACT2Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransACT3 = %SUBST(BUFFERTOTAL:Bfp:ACT3Ln)        CER059 MD022093
     C**********         ADD       ACT3Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransACT4 = %SUBST(BUFFERTOTAL:Bfp:ACT4Ln)        CER059 MD022093
     C**********         ADD       ACT4Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransACT5 = %SUBST(BUFFERTOTAL:Bfp:ACT5Ln)        CER059 MD022093
     C**********         ADD       ACT5Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TransACT6 = %SUBST(BUFFERTOTAL:Bfp:ACT6Ln)        CER059 MD022093
     C**********         ADD       ACT6Ln        Bfp                                 CER059 MD022093
     C**********         EVAL      TRANS19   = %SUBST(TransCCTN:1:CCTNLn1) +       MD021813 MD041996
     C**********                               %SUBST(BUFFERTOTAL:Bfp:CCTNLn)      MD021813 MD041996
     C**********         ADD       CCTNLn        Bfp                               MD021813 MD041996
     C**********         EVAL      ExtData   = %SUBST(BUFFERTOTAL:Bfp:SDEXLn)        CER059 MD022093
     C**********         ADD       SDEXLn        Bfp                                 CER059 MD022093
      ** REMINDER : Moving forward, STOP adding new data in the first buffer                MD022093
     C                   EXSR      ExtCUSDBufTot                                            MD022093
      ** Extract from BufferEx2                                                             MD022093
     C                   EXSR      ExtCUSDBufEx2                                            MD022093
      ** Extract from BufferEx3                                                             MD022093
     C                   EXSR      ExtCUSDBufEx3                                            MD022093
      ** Extract from BufferEx4                                                             MD022093
     C                   EXSR      ExtCUSDBufEx4                                            MD022093
                                                                                              CSW059
     C                   EXSR      ExtCUSDBufEx5                                              CGL157
                                                                                              CGL157
     C*****CCTNLn        SUBST     BUFFER:Bfp    TRANS19                          AR1086546 MD021813
     C**********         ADD       CCTNLn        Bfp                              AR1086546 MD021813
     C*****SDEXLn        SUBST     BUFFER:Bfp    ExtData                                      CER059
     C**********         ADD       SDEXLn        Bfp                                 BUG22140 CER059
     C*****1****         SUBST     BUFFER:Bfp    AAuth                               BUG22140 CER059
     C**********         ADD       1             Bfp                                 BUG22140 CER059

     C                   CALL      'SDCUSDVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C**********         PARM                    Trans1                                     MD022093
     C**********         PARM                    Trans2                                     MD022093
     C**********         PARM                    Trans7a                           BUG14803 MD022093
     C**********         PARM                    Trans3                                     MD022093
     C**********         PARM                    Trans4                                     MD022093
     C**********         PARM                    Trans5                                     MD022093
     C**********         PARM                    Trans6                                     MD022093
     C**********         PARM                    Trans7a                           BUG14485 BUG14803
     C**********         PARM                    Trans7                              CSD079 MD022093
     C**********         PARM                    Trans8                              CSD079 MD022093
     C**********         PARM                    Trans8A                             CSD079 MD022093
     C**********         PARM                    Trans8B                             CSD079 MD022093
     C**********         PARM                    Trans83                             CER059 MD022093
     C**********         PARM                    Trans84                             CER059 MD022093
     C**********         PARM                    Trans9                              CSD079 MD022093
     C**********         PARM                    Trans10                             CSD079 MD022093
     C**********         PARM                    TransExt                            CSD079 MD022093
     C**********         PARM                    Trans11                             CSD079 MD022093
     C**********         PARM                    Trans12                             CDS079 MD022093
     C**********         PARM                    Trans13                             CSD079 MD022093
     C**********         PARM                    Trans14                             CSD079 MD022093
     C**********         PARM                    Trans15                             CSD079 MD022093
     C**********         PARM                    Trans16                             CSD079 MD022093
     C**********         PARM                    TransSW                           BUG14992 MD022093
     C**********         PARM                    RegData                             CSD079 MD022093
     C**********         PARM                    Trans17                             CSD079 MD022093
     C**********         PARM                    StampTax                            CER049 MD022093
     C**********         PARM                    TransCUA1                           CER059 MD022093
     C**********         PARM                    TransCUA2                           CER059 MD022093
     C**********         PARM                    TransCUA3                           CER059 MD022093
     C**********         PARM                    TransACT1                           CER059 MD022093
     C**********         PARM                    TransACT2                           CER059 MD022093
     C**********         PARM                    TransACT3                           CER059 MD022093
     C**********         PARM                    TransACT4                           CER059 MD022093
     C**********         PARM                    TransACT5                           CER059 MD022093
     C**********         PARM                    TransACT6                           CER059 MD022093
     C                   PARM                    Trans19                                   AR1086546
     C**********         PARM                    ExtData                                    MD022093
     C                   PARM                    TransInTot                                 MD022093
     C                   PARM                    TransInEx2                                 MD022093
     C                   PARM                    TransInEx3                                 MD022093
     C                   PARM                    TransInEx4                                 MD022093
     C                   PARM                    TransInEx5                                   CGL157
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C**********         PARM                    Buffer                                       CER059
     C                   PARM                    Buffer9999                                   CER059
     C                   PARM                    BufferEx2                                  MD022093
     C                   PARM                    BufferEx3                                  MD022093
     C                   PARM                    BufferEx4                                  MD022093
     C                   PARM                    BufferEx5                                    CGL157
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4196
     C                   PARM                    AAuth                                      BUG22140

     C                   MOVEL     Buffer9999    Buffer                                       CER059
     C                   MOVE      Buffer9999    Buffer2                                      CER059
                                                                                              CER059
      * SD Securities Customers

     C     TransTYPE     WHENEQ    'SECD'

     C                   EXSR      SECDFmts

     C     SDSCLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SDSCLn        Bfp
     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22155
     C                   ADD       1             Bfp                                        BUG22155
     C     4050          SUBST     BUFFER:Bfp    DepData                                    BUG12213
     C                   ADD       4050          Bfp                                        BUG12213
     C     SDSXLn        SUBST     BUFFER:Bfp    ExtData
     C                   ADD       SDSXLn        Bfp                                        BUG22140
     C*****1****         SUBST     BUFFER:Bfp    AAuth                             BUG22140 BUG22155
     C**********         ADD       1             Bfp                               BUG22140 BUG22155

     C                   CALL      'SDSECDVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    ExtData
     C                   PARM                    DepData                                    BUG12213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    AAuth                                      BUG22140

      * PM Portfolio Definition

     C     TransTYPE     WHENEQ    'PFDM'

     C                   EXSR      PFDMFmts

     C     PMPMLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       PMPMLn        Bfp
     C     PMEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'PMPFDMVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * MM Deal Amendments

     C     TransTYPE     WHENEQ    'DEAM'

     C                   EXSR      DEAMFmts
     C                   EXSR      SettleFmts

     C     DEAMLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       DEAMLn        Bfp
      **  Restore Timestamp field from the record                                            BUG4146
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4146
     C                   ADD       26            Bfp                                         BUG4146
      *                                                                                       CER043
     C     SDCULn        SUBST     BUFFER:Bfp    CustData                                     CER043
     C                   ADD       SDCULn        Bfp                                          CER043
      *                                                                                       CER043
      **  Send Loan/Deposit indicator for settlement tab conditioning.                       BUG6534
     C     1             SUBST     BUFFER:Bfp    LONDEP                                      BUG6534
     C                   ADD       1             Bfp                                         BUG6534
     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
     C                   ADD       20            Bfp                                          239400
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     DAIFLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       DAIFLn        Bfp
     C     DAEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'MMDEAMVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans1
     C                   PARM                    CustData                                     CER043
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    Trans2
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4146
     C                   PARM                    LONDEP                                      BUG6534
     C                   PARM                    DDFOID                                       239400
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'MMDEAMUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Facilities amendments

     C     TransTYPE     WHENEQ    'FAMD'

     C                   EXSR      FAMDFmts
     C     FAMDLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FAMDLn        Bfp                                          CAP086
     C     FAM2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
     C                   ADD       FAM2Ln        Bfp                                        BUG10384
                                                                                              CAP086
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086

     C                   CALL      'LEFAMDVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2                                       CLE106
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * Collateral details

     C     TransTYPE     WHENEQ    'COLL'

     C                   EXSR      COLLFmts
     C     COL1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       COL1Ln        Bfp
     C     COL2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       COL2Ln        Bfp
     C     COL3Ln        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       COL3Ln        Bfp
     C     COL4Ln        SUBST     BUFFER:Bfp    TRANS4

     C                   CALL      'GLCOLLVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    Trans4
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * Collateral Allocations
     C     TransTYPE     WHENEQ    'COLA'

     C                   EXSR      COLAFmts
     C                   EXSR      SettleFmts
     C     COLALn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       COLALn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp

     C                   CALL      'GLCOLAVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    ReservID
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * Facilities details

     C     TransTYPE     WHENEQ    'FCIP'

     C                   EXSR      FCIPFmts
     C                   EXSR      SettleFmts                                                 CLE106

     C     FCI1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FCI1Ln        Bfp

     C     FCI2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       FCI2Ln        Bfp
                                                                                              CLE106
     C     FCI7Ln        SUBST     BUFFER:Bfp    TRANS7                                       CLE106
     C                   ADD       FCI7Ln        Bfp                                          CLE106
                                                                                              CLE106
     C     FCI9Ln        SUBST     BUFFER:Bfp    TRANS9                                       CLE106
     C                   ADD       FCI9Ln        Bfp                                          CLE106
                                                                                            BUG10093
     C     FCRNLn        SUBST     BUFFER:Bfp    FCIPNotes                                  BUG10093
     C                   ADD       FCRNLn        Bfp                                        BUG10093
                                                                                            BUG13174
      ** Field 'DDPATH'                                                                     BUG13174
                                                                                            BUG13174
     C     LEIFLn        SUBST     BUFFER:Bfp    DDPATH          200                        BUG13174
     C                   ADD       200           Bfp                                        BUG13174
                                                                                              CER049
      ** Stamp Tax fields                                                                     CER049
                                                                                              CER049
     C     51            SUBST     BUFFER:Bfp    TranStamp        51                          CER049
     C                   ADD       51            Bfp                                          CER049
                                                                                              CLE147
      ** Credit Agreement Change Flag                                                         CLE147
                                                                                              CLE147
     C     33            SUBST     BUFFER:Bfp    CADetails        33                          CLE147
     C                   ADD       33            Bfp                                          CLE147
                                                                                              CAP086
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086

     C*****FCRXLn        SUBST     BUFFER:Bfp    RegData                             CER001 BUG10093
     C**********         ADD       FCRXLn        Bfp                                 CER001 BUG10093
      **********                                                                     CER001 BUG10093
     C*****FCEXLn        SUBST     BUFFER:Bfp    ExtData                                    BUG10093
     C**********         ADD       FCEXLn        Bfp                                 CLE106 BUG10093
                                                                                              CLE106
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CLE106
     C                   ADD       ESSRLn        Bfp                                          CLE106
                                                                                              CLE106
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CLE106
     C                   ADD       ESSPLn        Bfp                                        BUG10093
                                                                                            BUG10093
     C     FCEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
     C                   ADD       FCEXLn        Bfp                                        MD044880
                                                                                            MD044880
     C     FCRXLn        SUBST     BUFFER:Bfp    RegData                                    BUG10093
     C                   ADD       FCRXLn        Bfp                                        BUG10093
                                                                                            BUG10093
     C*****FCEXLn        SUBST     BUFFER:Bfp    ExtData                           BUG10093 MD044880

     C                   CALL      'LEFCIPVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans7                                       CLE106
     C                   PARM                    Trans9                                       CLE106
     C                   PARM                    FCIPNotes                                  BUG10093
     C                   PARM                    TranStamp                                    CER049
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    PaySttmt                                     CLE106
     C                   PARM                    RecSttmt                                     CLE106
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    DDPATH                                     BUG13174
     C                   PARM                    CADetails                                    CLE147

      * Loan Input

     C     TransTYPE     WHENEQ    'CLIP'

     C                   EXSR      CLIPFmts
     C                   EXSR      SettleFmts

     C     CLI1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       CLI1Ln        Bfp

     C     CLI2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       CLI2Ln        Bfp

     C     CLI3Ln        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       CLI3Ln        Bfp

     C     CLI4Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       CLI4Ln        Bfp

     C     CLI5Ln        SUBST     BUFFER:Bfp    TRANS5                                       CLE106
     C                   ADD       CLI5Ln        Bfp                                          CLE106
                                                                                              CLE106
      *                                                                                     AR804863
      ** Restore Reject Action Code.                                                        AR804863
      *                                                                                     AR804863
     C     1             SUBST     BUFFER:Bfp    @ACTRV                                     AR804863
     C                   ADD       1             Bfp                                        AR804863
     C     CLIQLn        SUBST     Buffer:Bfp    TRANSQ                                       CER049
     C                   ADD       CLIQLn        Bfp                                          CER049
                                                                                              CER049
     C     CLI6Ln        SUBST     BUFFER:Bfp    TRANS6                                    AR1021983
     C                   ADD       CLI6Ln        Bfp                                       AR1021983
                                                                                           AR1021983
     C     CLI7Ln        SUBST     BUFFER:Bfp    TRANS7                                       CLE141
     C                   ADD       CLI7Ln        Bfp                                          CLE141
                                                                                              CLE141
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
      *                                                                                     MD030621
     C*****Bfp**         Add       1             BfpTMP            4 0             MD030621 MD042033
     C*****1****         SUBST     BUFFER:BfpTMP @DEPI                             MD030621 MD042033
     C     1             SUBST     BUFFER:Bfp    @DEPI                                      MD042033
     C                   ADD       1             Bfp                                        MD042033
      *                                                                                     MD030621
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086

     C*****10************SUBST     BUFFER:Bfp    ReservID                       BUG2480
     C*******************ADD       10            Bfp                            BUG2480

     C     CLEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
     C                   ADD       CLEXLn        Bfp                                        MD044880
                                                                                            MD044880
      *** APR Fields for CLIP (CER050)                                                      MD054028
     C     CLCR50Ln      SUBST     BUFFER:Bfp    CLAPRDta         24                        MD054028
     C                   EVAL      ExtData = %SUBST(ExtData:1:CLEXLn) + CLAPRDta            MD054028
     C                   ADD       CLCR50Ln      Bfp                                        MD054028
                                                                                            MD054028
     C     CLRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       CLRXLn        Bfp                                          CER001
                                                                                              CER001
     C*****CLEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
     C**********         ADD       CLEXLn        Bfp                                        MD044880

     C                   MOVE      ReservID15    ReservID                       BUG2480
                                                                                BUG2480
     C                   CALL      'LECLIPVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    Trans4
     C                   PARM                    Trans5                                       CLE106
     C                   PARM                    TransQ                                       CER049
     C                   PARM                    Trans6                                    AR1021983
     C                   PARM                    Trans7                                       CLE141
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    ReservID         10
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C                   PARM                    @DEPI                                      MD030621
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'LECLIPUPD'                                       CRE020
     C                   EVAL      WrkMod = 'LE'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Rollover instructions

     C     TransTYPE     WHENEQ    'LERI'

     C                   EXSR      LERIFmts
     C                   EXSR      SettleFmts

     C     LERILn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LERILn        Bfp

     C     LER2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       LER2Ln        Bfp

     C     LER3Ln        SUBST     BUFFER:Bfp    TRANS3                                        BUG19
     C                   ADD       LER3Ln        Bfp                                           BUG19
                                                                                               BUG19
      *                                                                                     AR702532
      **  Restore Reject Action Code.                                                       AR702532
      *                                                                                     AR702532
     C     1             SUBST     BUFFER:Bfp    @ACTRV                                     AR702532
     C                   ADD       1             Bfp                                        AR702532
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp

     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086

     C     LEEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'LELERIVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3                                        BUG19
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @ACTRV                                     AR702532

      * Repayment schedule

     C     TransTYPE     WHENEQ    'RPSC'

     C                   EXSR      RPSCFmts
     C                   EXSR      SettleFmts

     C     RPSCLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       RPSCLn        Bfp

     C     RPS2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
     C                   ADD       RPS2Ln        Bfp                                          CLE106
                                                                                              CLE106
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp

     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
                                                                                              CAP086
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086

     C     RPEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'LERPSCVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2                                       CLE106
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'LERPSCUPD'                                       CRE020
     C                   EVAL      WrkMod = 'LE'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Loan Amendment

     C     TransTYPE     WHENEQ    'LOAM'

     C                   EXSR      LOAMFmts
     C                   EXSR      SettleFmts

     C     LOAMLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       LOAMLn        Bfp

     C     LOA2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
     C                   ADD       LOA2Ln        Bfp                                          CLE106
                                                                                              CLE106
     C*****LOEXLn        SUBST     BUFFER:Bfp    ExtData                              BUG9493 247172
     C**********         ADD       LOEXLn        Bfp                                  BUG9493 247172
     C*****10************SUBST     BUFFER:Bfp    ReservID                       BUG2480
     C*******************ADD       10            Bfp                            BUG2480

     C*****16***         SUBST     BUFFER:Bfp    DDSTAT                                       CLE106
     C**********         ADD       16            Bfp                                          CLE106

     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp

     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
                                                                                              CAP086
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086

     C     LOEXLn        SUBST     BUFFER:Bfp    ExtData                                      247172
     C                   ADD       LOEXLn        Bfp                                          247172
     C*****LOEXLn        SUBST     BUFFER:Bfp    ExtData                                     BUG9493
     C**********         ADD       LOEXLn        Bfp                                         BUG9493

     C                   MOVE      ReservID15    ReservID                       BUG2480
                                                                                BUG2480
     C                   CALL      'LELOAMVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2                                       CLE106
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ExtData
     C                   PARM                    ReservID         10
     C                   PARM                    DDSTAT           16
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'LELOAMUPD'                                       CRE020
     C                   EVAL      WrkMod = 'LE'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Manual repayment

     C     TransTYPE     WHENEQ    'MAPY'

     C                   EXSR      MAPYFmts
     C                   EXSR      SettleFmts

     C     MAPYLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       MAPYLn        Bfp

     C     MAP2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
     C                   ADD       MAP2Ln        Bfp                                          CLE106
                                                                                              CLE106
     C*****UpSRLn        SUBST     BUFFER:Bfp    TempData#3                       AR1080805 MD020445
     C**********         ADD       UpSRLn        Bfp                              AR1080805 MD020445
     C     UpSRLn        SUBST     BUFFER:Bfp    TempData#3                                 MD020733
     C                   ADD       UpSRLn        Bfp                                        MD020733
                                                                                            MD020733
                                                                                              CLE164
     C     DDAuLn        SUBST     BUFFER:Bfp    TempData7                                    CLE164
     C                   ADD       DDAuLn        Bfp                                          CLE164
                                                                                              CLE164
     C*****10************SUBST     BUFFER:Bfp    ReservID                       BUG2480
     C*******************ADD       10            Bfp                            BUG2480

     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp

     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
                                                                                              CAP086
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086

     C     MAEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   MOVE      ReservID15    ReservID                       BUG2480
                                                                                BUG2480
     C                   CALL      'LEMAPYVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2                                       CLE106
     C**********         PARM                    TempData#3                       AR1080805 MD020445
     C                   PARM                    TempData#3                                 MD020733
     C                   PARM                    TempData7                                    CLE164
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ExtData
     C                   PARM                    ReservID         10
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'LEMAPYUPD'                                       CRE020
     C                   EVAL      WrkMod = 'LE'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Base rates
     C     TransTYPE     WHENEQ    'BSRT'

     C                   EXSR      BSRTFmts
     C     BSRTLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       BSRTLn        Bfp
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
     C                   ADD       26            Bfp                                         BUG4469
     C     BSEXLn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       BSEXLn        Bfp                                        BUG22140
     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
     C                   ADD       1             Bfp                                        BUG22140

     C                   CALL      'SDBSRTVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    TRANS2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4469
     C                   PARM                    AAuth                                      BUG22140

      ** Fees                                                                                BUG1100
     C     TransTYPE     WHENEQ    'FEEM'                                                    BUG1100
                                                                                             BUG1100
     C                   EXSR      FEEMFmts                                                  BUG1100
     C                   EXSR      SettleFmts                                                BUG1100
                                                                                             BUG1100
     C     FEEMLn        SUBST     BUFFER:Bfp    Trans1                                      BUG1100
     C                   ADD       FEEMLn        Bfp                                         BUG1100
     C     FEEM2Ln       SUBST     BUFFER:Bfp    Trans2                                      BUG1100
     C                   ADD       FEEM2Ln       Bfp                                         BUG1100
     C     LESTMLn       SUBST     BUFFER:Bfp    StampTax                                     CER049
     C                   ADD       LESTMLn       Bfp                                          CER049
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                    BUG1100
     C                   ADD       ESSRLn        Bfp                                         BUG1100
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                    BUG1100
     C                   ADD       ESSPLn        Bfp                                         BUG1100
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086
     C     FEEXLn        SUBST     BUFFER:Bfp    ExtData                                     BUG1100
     C                   ADD       FEEXLn        Bfp                                        MD030856
      ** Add FEEM Reject Flag                                                               MD030856
     C     1             SUBST     BUFFER:Bfp    DRejFlg                                    MD030856
     C                   ADD       1             Bfp                                        MD030856
                                                                                             BUG1100
     C                   CALL      'LEFEEMVU'                                                BUG1100
                                                                                             BUG1100
      * Common header information (DS) from source system                                    BUG1100
     C                   PARM                    HeadIn                                      BUG1100
                                                                                             BUG1100
      * Transaction information                                                              BUG1100
     C                   PARM                    Trans1                                      BUG1100
     C                   PARM                    Trans2                                      BUG1100
     C                   PARM                    StampTax                                     CER049
     C                   PARM                    PaySttmt                                    BUG1100
     C                   PARM                    RecSttmt                                    BUG1100
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    Extdata                                     BUG1100
     C                   PARM                    DRejFlg                                    MD030856
     C                   PARM                    FldNameArr                                  BUG1100
     C                   PARM                    MsgIDArr                                    BUG1100
     C                   PARM                    MsgDtaArr                                   BUG1100
     C                   PARM                    WFldNamArr                                  BUG1100
     C                   PARM                    WMsgIDArr                                   BUG1100
     C                   PARM                    WMsgDtaArr                                  BUG1100
     C                   PARM                    MsgFArray                                   BUG1100
     C                   PARM                    UpdateYN                                    BUG1100
     C                   PARM                    Buffer                                      BUG1100
     C                   PARM                    APIRetc                                     BUG1100
                                                                                             BUG1100
      * On-line printing of Advice                                                           BUG3071
     C                   IF        CRE020 = 'Y'                                              BUG3071
     C                   EVAL      WrkPgm = 'LEFEEMUPD'                                      BUG3071
     C                   EVAL      WrkMod = 'LE'                                             BUG3071
     C                   EXSR      SRSndDtaQ                                                 BUG3071
     C                   ENDIF                                                               BUG3071
      *                                                                                      BUG3071
      * Fee Adjustment
     C     TransTYPE     WHENEQ    'FEAD'

     C                   EXSR      FEADFmts
      ***Need*to*add*10*chars*for*the*status*field*not*included*on*format             BUG1218 CLE106
      ***file*LEFEADPD*but*in*API*XML*file*FEAD.XML********************               BUG1218 CLE106
      ***S#STAT********************************************************               BUG1218 CLE106
     C*******************ADD*******10************FEADLn****************               BUG1218 CLE106
      ***Need*to*add*50*chars*for*fields*not*included*on*format********               BUG1304 CLE106
      ***file*LEFEADPD*but*in*API*XML*file*FEAD.XML********************               BUG1304 CLE106
      ***S_FTYP*S_FCOD*S_FENV*S_ACCD***********************************               BUG1304 CLE106
     C*******************ADD*******50************FEADLn****************               BUG1304 CLE106
                                                                                              CLE106
     C     FEADLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FEADLn        Bfp
     C     FEA2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
     C                   ADD       FEA2Ln        Bfp                                          CLE106
                                                                                              CLE106
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086

     C                   CALL      'LEFEADVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    TRANS2                                       CLE106
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * Fee settlement
     C     TransTYPE     WHENEQ    'FEST'

     C                   EXSR      FESTFmts
     C                   EXSR      SettleFmts
      ***Need*to*add*60*chars*for*fields*not*included*on*format**************                 CLE106
      ***file*LEFESTPD*but*in*API*XML*file*FEST.XML**************************                 CLE106
      ***S_STAT*S_FTYP*S_FCOD*S_FENV*S_DUPD**********************************                 CLE106
                                                                                              CLE106
      ** 60 chars removed and created new file to hold the information                        CLE106
     C**********         ADD       60            FESTLn                                       CLE106
     C     FESTLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FESTLn        Bfp
     C     FES2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CLE106
     C                   ADD       FES2Ln        Bfp                                          CLE106
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
                                                                                              CAP086
     C     LEIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       LEIFLn        Bfp                                          CAP086
      ** Add P_Sign                                                                         MD054354
     C     1             SUBST     BUFFER:Bfp    P_SIGN                                     MD054354
     C                   ADD       1             Bfp                                        MD054354
     C                   CALL      'LEFESTVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    TRANS2                                       CLE106
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    P_SIGN                                     MD054354
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'LEFESTUPD'                                       CRE020
     C                   EVAL      WrkMod = 'LE'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Funding Participant
     C     TransTYPE     WHENEQ    'FPRT'

     C                   EXSR      FPRTFmts
     C                   EXSR      SettleFmts
     C     FPRTLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FPRTLn        Bfp
      *
      * Primary Facility screen details
     C     76            SUBST     BUFFER:Bfp    PFData           76
     C                   ADD       76            Bfp

     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp

     C                   CALL      'LEFPRTVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * Assignments
     C     TransTYPE     WHENEQ    'ASGN'

     C                   EXSR      ASGNFmts
     C                   EXSR      SettleFmts
     C     ASGNLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       ASGNLn        Bfp
      * Assignments screen details
     C     17            SUBST     BUFFER:Bfp    PFData17         17
     C                   ADD       17            Bfp

     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp

     C                   CALL      'LEASGNVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    ReservID
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * FRA - Forward Rate Agreement deals
     C     TransTYPE     WHENEQ    'FRA '

     C                   EXSR      FRAFmts
     C                   EXSR      SettleFmts
     C                   EXSR      RPIFFmts                                                   CSW213
     C     FRALn         SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FRALn         Bfp
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
     C                   ADD       26            Bfp                                         BUG4469
     C     5             SUBST     BUFFER:Bfp    @TLNU             5                         BUG4469
     C                   ADD       5             Bfp                                         BUG4469
     C     6             SUBST     BUFFER:Bfp    SUINFD            6                         BUG6377
     C                   ADD       6             Bfp                                         BUG6377
     C     6             SUBST     BUFFER:Bfp    STINFD            6                         BUG6377
     C                   ADD       6             Bfp                                         BUG6377
     C     24            SUBST     BUFFER:Bfp    DDSTS            24                         BUG5871
     C                   ADD       24            Bfp                                         BUG5871
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp
     C     IRFRLn        SUBST     BUFFER:Bfp    InfData                                    BUG18701
     C                   ADD       IRFRLn        Bfp                                          CSW213
     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213

     C                   CALL      'IRFRAVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                    BUG18701
     C                   PARM                    ReservID
     C                   PARM                    ExtData
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4469
     C                   PARM                    @TLNU                                       BUG4469
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'IRFRAUPD'                                        CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      ** Single Currency IRS (SIRS)

     C     TransTYPE     WHENEQ    'SIRS'

     C                   EXSR      SrSIRS

      ** Cross Currency IRS (CIRS)
     C     TransTYPE     WHENEQ    'CIRS'

     C                   EXSR      CIRSFmts
     C                   EXSR      SettleFmts
     C                   EXSR      RPIFFmts                                                   CSW213

     C*****CIRSLn******* SUBST     BUFFER:Bfp    TRANS1                                       CDL028
     C     CIRSLn        SUBST     BUFFER:Bfp    TRANS1A                                      CDL028
     C                   ADD       CIRSLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                    BUG5449
     C                   ADD       ESSFLn        Bfp                                         BUG5449
      ** Extra Settlements
     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtV
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtV
     C                   ADD       ESSPLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecStmtM
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PayStmtM
     C                   ADD       ESSPLn        Bfp

      **  Non-Screen Interface Data for Class 1 enhancements

     C     IRRXLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       IRRXLn        Bfp

     C                   EVAL      IRCS2Ln = 6000 - Bfp                                     MD029663
     C*****IRCSLn        SUBST     BUFFER:Bfp    ExtData                                    MD029663
     C**********         ADD       IRCSLn        Bfp                                 CSW213 MD029663
     C     IRCS2Ln       SUBST     Buffer:Bfp    TempData#7                                 MD029663
     C**********         ADD       IRCS2Ln       Bfp                               MD029663 MD030454
     C**********         ADD       168           Bfp                                 CSW213 MD030454
     C**********         EVAL      InSwift2013 = %SUBST(BufferTotal:Bfp:RPIFLn)      CSW213 MD030454

     C                   EVAL      IRCS3Ln = IRCSLn - IRCS2Ln                               MD029663
     C     IRCS3Ln       SUBST     BUFFER2:Bfp2  TempData#8                                 MD029663
     C                   ADD       IRCS3Ln       Bfp2                                       MD029663
     C                   EVAL      TempData#9 = TempData#7 + TempData#8                     MD029663
     C                   MOVEL     TempData#9    ExtData                                    MD029663
     C                   ADD       IRCSLn        Bfp                                        MD030454
     C                   ADD       168           Bfp                                        MD030454
     C                   ADD       20            Bfp                                        MD039064
     C                   EVAL      InSwift2013 = %SUBST(BufferTotal:Bfp:RPIFLn)             MD030454
                                                                                            MD029663
     C                   CALL      'IRCIRSVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C**********         PARM                    TRANS1                                       CDL028
     C                   PARM                    TRANS1A                                      CDL028
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    PayStmtV
     C                   PARM                    RecStmtV
     C                   PARM                    PayStmtM
     C                   PARM                    RecStmtM
     C                   PARM                    InfData                                     BUG6671
     C                   PARM                    ExtData
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG5449
     C                   PARM                    BufferEx2                                   BUG5449
     C                   PARM                    BufferEx3                                   BUG5449
     C                   PARM                    BufferEx4                                   BUG5449
     C                   PARM                    BufferEx5                                   BUG5449
     C                   PARM                    BufferEx6                                   BUG5449
     C                   PARM                    BufferEx7                                   BUG5449
     C                   PARM                    BufferEx8                                   BUG5449
     C                   PARM                    BufferEx9                                   BUG5449
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'IRCIRSUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * SE Securities Details
     C     TransTYPE     WHENEQ    'SECS'

     C                   EXSR      SECSFmts

     C     SEC1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SEC1Ln        Bfp
     C     SEC2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       SEC2Ln        Bfp
     C     SEC3Ln        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       SEC3Ln        Bfp
     C     SEC4Ln        SUBST     BUFFER:Bfp    TRANS4
     C                   ADD       SEC4Ln        Bfp
     C     SEC5Ln        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       SEC5Ln        Bfp
     C     SEC6Ln        SUBST     BUFFER:Bfp    TRANS6                                       CSE071
     C                   ADD       SEC6Ln        Bfp                                          CSE071
      **  Restore Timestamp field from the record                                            BUG1569
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG1569
     C                   ADD       26            Bfp                                         BUG1569
     C     SECSFLn       SUBST     BUFFER:Bfp    SECSFiller                                  BUG5988
     C                   ADD       SECSFLn       Bfp                                         BUG5988
     C     SEEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
     C                   ADD       SEEXLn        Bfp                                        MD044880
     C     SERXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       SERXLn        Bfp                                          CER001
     C*****SEEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880

     C                   CALL      'SESECSVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    TRANS2
     C                   PARM                    TRANS3
     C                   PARM                    TRANS4
     C                   PARM                    TRANS5
     C                   PARM                    TRANS6                                       CSE071
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG1569

      * SE Trade

     C     TransTYPE     WHENEQ    'TRAD'

     C                   EXSR      TRADFmts

     C     TRPRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       TRPRLn        Bfp
     C     TRSELn        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       TRSELn        Bfp
     C     TRPVLn        SUBST     BUFFER:Bfp    TRANS2B                                    BUG11194
     C                   ADD       TRPVLn        Bfp                                        BUG11194
     C     TREXLn        SUBST     BUFFER:Bfp    TRANS3
     C                   ADD       TREXLn        Bfp
     C*****TRSTLn        SUBST     BUFFER:Bfp    TRANS4                                      CSF011A
     C     TRSTLn        SUBST     BUFFER:Bfp    TRANS4A                                     CSF011A
     C                   ADD       TRSTLn        Bfp
     C     TRCCLn        SUBST     BUFFER:Bfp    TRANS5
     C                   ADD       TRCCLn        Bfp
     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS6
     C                   ADD       TRSWLn        Bfp
     C     TRSWLn        SUBST     BUFFER:Bfp    TRANS7
     C                   ADD       TRSWLn        Bfp
     C*****TRX2Ln        SUBST     BUFFER:Bfp    OthrData                                    CSF011A
     C**********         ADD       TRX2Ln        Bfp                                         CSF011A
     C     4667          SUBST     BUffer:Bfp    TempData#5                                  CSF011A
     C                   SUB       4667          TRX2Ln                                      CSF011A
     C     TRX2Ln        SUBST     BUFFER2:Bfp2  TempData#6                                  CSF011A
     C                   ADD       TRX2Ln        Bfp2                                        CSF011A
     C                   MOVEL     TempData#5    TRADSettleData                              CSF011A
     C                   MOVE      TempData#6    TRADSettleData                              CSF011A
     C*****TRHALn        SUBST     BUFFER:Bfp    TRANS8                                      CSF011A
     C**********         ADD       TRHALn        Bfp                                         CSF011A
     C     TRHALn        SUBST     BUFFER2:Bfp2  TRANS8                                      CSF011A
     C                   ADD       TRHALn        Bfp2                                        CSF011A
      **  Restore Timestamp field from the record                                            BUG1569
     C*****26***         SUBST     BUFFER:Bfp    @TimeStamp                          BUG1569 CSF011A
     C**********         ADD       26            Bfp                                 BUG1569 CSF011A
     C     26            SUBST     BUFFER2:Bfp2  @TimeStamp                                  CSF011A
     C                   ADD       26            Bfp2                                        CSF011A
      **  Other Data                                                                         BUG9584
     C*****TDAXLn        SUBST     BUFFER:Bfp    OthData1                            BUG9584 CSF011A
     C**********         ADD       TDAXLn        Bfp                                 BUG9584 CSF011A
     C     TDAXLn        SUBST     BUFFER2:Bfp2  OthData1                                    CSF011A
     C                   ADD       TDAXLn        Bfp2                                        CSF011A
      ** InfData does not exists in TRAD.xml                                                BUG10202
      ****Non-Screen*Interface*Data*for*Class*1*enhancements***********                     BUG10202
     C*****SETILn        SUBST     BUFFER:Bfp    InfData                                    BUG10202
     C**********         ADD       SETILn        Bfp                                        BUG10202
     C*****20***         SUBST     BUFFER:Bfp    FRNT                              AR698195B CSF011A
     C**********         ADD       20            Bfp                               AR698195B CSF011A
     C*****20***         SUBST     BUffer:Bfp    TradQ            20                  CER049 CSF011A
     C**********         ADD       20            Bfp                                  CER049 CSF011A
     C*****1****         SUBST     Buffer:Bfp    AAuth                             AR698195B CSF011A
     C**********         ADD       1             Bfp                               AR698195B CSF011A
     C*****TDRXLn        SUBST     BUFFER:Bfp    RegData                              CER001 CSF011A
     C**********         ADD       TDRXLn        Bfp                                  CER001 CSF011A
     C*****SETRLn        SUBST     BUFFER:Bfp    ExtData                                     CSF011A
     C     20            SUBST     BUFFER2:Bfp2  FRNT                                        CSF011A
     C                   ADD       20            Bfp2                                        CSF011A
     C     20            SUBST     BUffer2:Bfp2  TradQ            20                         CSF011A
     C                   ADD       20            Bfp2                                        CSF011A
     C     1             SUBST     Buffer2:Bfp2  AAuth                                       CSF011A
     C                   ADD       1             Bfp2                                        CSF011A
     C     TDRXLn        SUBST     BUFFER2:Bfp2  RegData                                     CSF011A
     C                   ADD       TDRXLn        Bfp2                                        CSF011A
     C     SETRLn        SUBST     BUFFER2:Bfp2  ExtData                                     CSF011A
     C**********         ADD       SETRLn        Bfp                              BUG22155 AR698195B
     C*****1****         SUBST     BUFFER:Bfp    AAuth                            BUG22155 AR698195B
     C**********         ADD       1             Bfp                              BUG22155 AR698195B

     C                   CALL      'SETRADVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    TRANS2
     C                   PARM                    TRANS2B                                    BUG11194
     C                   PARM                    TRANS3
     C**********         PARM                    TRANS4                                      CSF011A
     C                   PARM                    TRANS4A                                     CSF011A
     C                   PARM                    TRANS5
     C                   PARM                    TRANS6
     C                   PARM                    TRANS7
     C                   PARM                    TRANS8
     C**********         PARM                    OthrData                                    CSF011A
     C                   PARM                    TRADSettleData                              CSF011A
     C                   PARM                    OthData1                                     CER001
     C**********         PARM                    InfData                                    BUG10202
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     CSF011A
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG1569
     C                   PARM                    TradQ                                        CER049
     C                   PARM                    AAuth                                      BUG22155
     C                   PARM                    FRNT                                      AR698195B
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'SETRADUPD'                                       CRE020
     C                   EVAL      WrkMod = 'SE'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Request for transfer

     C     TransTYPE     WHENEQ    'RFTD'

     C                   EVAL      Trans1 = Buffer
     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)

     C                   CALL      'FTM1011VU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FTM101UPD'                                       CRE020
     C                   EVAL      WrkMod = 'FT'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Request for transfer details

     C     TransTYPE     WHENEQ    'RFT2'

     C                   EVAL      Trans1 = Buffer
     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)
     C                   EVAL      Trans3 = %SUBST(Buffer:1001:500)

     C                   CALL      'FTM1012VU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FTM101UPD'                                       CRE020
     C                   EVAL      WrkMod = 'FT'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Credit customer transfer

     C     TransTYPE     WHENEQ    'CCTD'

     C                   EVAL      Trans1 = Buffer
     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)

     C                   CALL      'FTM1021VU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FTM102UPD'                                       CRE020
     C                   EVAL      WrkMod = 'FT'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * Customer credit transfer details

     C     TransTYPE     WHENEQ    'CCT2'

     C                   EVAL      Trans1 = Buffer
     C                   EVAL      Trans2 = %SUBST(Buffer:501:500)
     C                   EVAL      Trans3 = %SUBST(Buffer:1001:500)

     C                   CALL      'FTM1022VU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FTM102UPD'                                       CRE020
     C                   EVAL      WrkMod = 'FT'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * FF OTCC

     C     TransTYPE     WHENEQ    'OTCC'

     C                   EXSR      OTCCFmts

     C     OTCCLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       OTCCLn        Bfp
     C     OTCCLnS       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       OTCCLnS       Bfp
     C*****OTCCLnX       SUBST     BUFFER:Bfp    ExtData                                      CER001
     C**********         ADD       OTCCLnX       Bfp                                  BUG4258 CER001
      **  Restore Timestamp field from the record                                            BUG4258
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
     C                   ADD       26            Bfp                                         BUG4258
     C     15            SUBST     BUFFER:Bfp    SPREM            15                         BUG6274
     C                   ADD       15            Bfp                                         BUG6274
     C     1             SUBST     BUFFER:Bfp    WNewInst          1                         BUG9601
     C                   ADD       1             Bfp                                         BUG9601
     C     OTRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       OTRXLn        Bfp                                          CER001
     C     OTCCLnX       SUBST     BUFFER:Bfp    ExtData                                      CER001
     C                   ADD       OTCCLnX       Bfp                                          CER001

     C                   CALL      'FFOTCCVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4258
     C                   PARM                    SPREM                                       BUG6274
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FFOTCCSIN'                                       CRE020
     C                   EVAL      WrkMod = 'FF'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * FF OTCO

     C     TransTYPE     WHENEQ    'OTCO'

     C                   EXSR      OTCOFmts

     C     OTCOLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       OTCOLn        Bfp
     C     OTCOLnS       SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       OTCOLnS       Bfp
     C*****OTCOLnX       SUBST     BUFFER:Bfp    ExtData                                     BUG8163
     C**********         ADD       OTCOLnX       Bfp                                 BUG4258 BUG8163
      **  Restore Timestamp field from the record                                            BUG4258
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
     C                   ADD       26            Bfp                                         BUG4258
     C     15            SUBST     BUFFER:Bfp    SPREM            15                         BUG6274
     C                   ADD       15            Bfp                                         BUG6274

     C                   CALL      'FFOTCOVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4258
     C                   PARM                    SPREM                                       BUG6274
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FFOTCOSIN'                                       CRE020
     C                   EVAL      WrkMod = 'FF'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * FF Exchange-Traded Transactions

     C     TransTYPE     WHENEQ    'EXTR'

     C                   EXSR      EXTRFmts

     C     EXTRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       EXTRLn        Bfp
     C     EXTRLnCS      SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       EXTRLnCS      Bfp
     C*****EXTRLnBS      SUBST     BUFFER:Bfp    TRANS2                                     BUG26906
     C     EXTRLnBS      SUBST     BUFFER:Bfp    TRANS3                                     BUG26906
     C                   ADD       EXTRLnBS      Bfp
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP191
     C                   ADD       26            Bfp                                          CAP191
     C     1             SUBST     BUFFER:Bfp    AAUTH                                        CAP191
     C                   ADD       1             Bfp                                          CAP191
     C     EXTRLnR       SUBST     BUFFER:Bfp    RegData                                      CAP191
     C                   ADD       EXTRLnR       Bfp                                          CAP191
     C     EXTRLnX       SUBST     BUFFER:Bfp    ExtData
     C                   ADD       EXTRLnX       Bfp                                          CAP191
     C     20            SUBST     BUFFER:Bfp    FRNT                                         CAP191
     C                   ADD       20            Bfp                                          CAP191
     C     20            SUBST     BUFFER:Bfp    AFRT                                         CAP191
     C                   ADD       20            Bfp                                          CAP191

     C                   CALL      'FFEXTRVU'
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    Trans3
     C                   PARM                    RegData                                      CAP191
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                   CAP191
     C                   PARM                    AAUTH                                        CAP191
     C                   PARM                    FRNT                                         CAP191
     C                   PARM                    AFRT                                         CAP191
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'FFEXTRSIN'                                       CRE020
     C                   EVAL      WrkMod = 'FF'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * SE Depot Movements

     C     TransTYPE     WHENEQ    'DPWI'
     C     TransTYPE     OREQ      'DPWO'
     C     TransTYPE     OREQ      'DPMV'                                                     CAP087

     C                   EXSR      DPMVFmts
     C     DMWILn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       DMWILn        Bfp

     C     DMesLn        SUBST     BUFFER:Bfp    OthrData
     C                   ADD       DMesLn        Bfp
      *   Depot Movement Type for Walk-In (WI)/ Walk-Out (WO)
     C     2             SUBST     BUFFER:Bfp    DPMVType          2
     C                   ADD       2             Bfp
      **  Restore Timestamp field from the record                                            BUG1569
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG1569
     C                   ADD       26            Bfp                                         BUG1569
     C     DMAXLn        SUBST     BUFFER:Bfp    OthData                                     BUG9089
     C                   ADD       DMAXLn        Bfp                                         BUG9089
     C     DMRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       DMRXLn        Bfp                                          CER001
      **  Non-Screen Interface Data for Class 1 enhancements
     C     DMEXLn        SUBST     BUFFER:Bfp    ExtData
     C                   ADD       DMEXLn        Bfp                                        BUG22140
     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
     C                   ADD       1             Bfp                                        BUG22140

     C                   CALL      'SEDPMVVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    OthrData
     C                   PARM                    DPMVType
     C                   PARM                    OthData                                     BUG9089
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG1569
     C                   PARM                    AAuth                                      BUG22140
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'SEDPMVUPD'                                       CRE020
     C                   EVAL      WrkMod = 'SE'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * MM Negotiable Assets Purchased

     C     TransTYPE     WHENEQ    'NASP'

     C                   EXSR      NASPFmts
     C                   EXSR      SettleFmts

     C     NASPLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       NASPLn        Bfp
      **  Restore Timestamp field from the record                                            BUG4146
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4146
     C                   ADD       26            Bfp                                         BUG4146
     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
     C                   ADD       20            Bfp                                          239400
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     NAIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       NAIFLn        Bfp                                          CAP086
     C     NPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880
     C                   ADD       NPEXLn        Bfp                                        MD044880
     C     NPRXLn        SUBST     BUFFER:Bfp    RegData                                      CER001
     C                   ADD       NPRXLn        Bfp                                          CER001
     C*****NPEXLn        SUBST     BUFFER:Bfp    ExtData                                    MD044880

     C                   CALL      'MMNASPVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans1
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4146
     C                   PARM                    DDFOID                                       239400
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'MMNASPUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * MM Negotiable Assets Sold

     C     TransTYPE     WHENEQ    'NASS'

     C                   EXSR      NASSFmts
     C                   EXSR      SettleFmts

     C     NASSLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       NASSLn        Bfp
      **  Restore Timestamp field from the record                                            BUG4146
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4146
     C                   ADD       26            Bfp                                         BUG4146
     C     20            SUBST     BUFFER:Bfp    DDFOID                                       239400
     C                   ADD       20            Bfp                                          239400
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     NAIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       NAIFLn        Bfp                                          CAP086
     C     NSEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'MMNASSVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans1
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4146
     C                   PARM                    DDFOID                                       239400
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'MMNASSUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      * MM Rollover Deals Maintenance

     C     TransTYPE     WHENEQ    'RODL'

     C                   EXSR      RODLFmts
     C                   EXSR      SettleFmts

     C*****RODLLn        SUBST     BUFFER:Bfp    TRANS1                                      CSF011A
     C     RODLLn        SUBST     BUFFER:Bfp    TRANS1A                                     CSF011A
     C                   ADD       RODLLn        Bfp
     C*****ROIFLn        SUBST     BUFFER:Bfp    TRANS2                                      CSF011A
     C**********         ADD       ROIFLn        Bfp                                         CSF011A
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
      ** CER050 Fields                                                                      MD054538
     C                   ADD       9             Bfp                                        MD054538
     C     ROEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'MMRODLVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C**********         PARM                    Trans1                                      CSF011A
     C                   PARM                    Trans1A                                     CSF011A
     C**********         PARM                    Trans2                                      CSF011A
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      * IR Caps/Collars/Floors

     C     TransTYPE     WHENEQ    'CACF'

     C                   EXSR      CACFFmts
     C                   EXSR      SettleFmts
     C                   EXSR      RPIFFmts                                                   CSW213

     C     CACFLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       CACFLn        Bfp
     C     CAC2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       CAC2Ln        Bfp
     C     CFIFLn        SUBST     BUFFER:Bfp    InfData
     C                   ADD       CFIFLn        Bfp
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     CFEXLn        SUBST     BUFFER:Bfp    ExtData
     C                   ADD       CFEXLn        Bfp                                          CSW213
     C                   ADD       61            Bfp                                          CSW213
     C                   ADD       20            Bfp                                        MD039064
     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213

     C                   CALL      'IRCACFVU'
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    InfData
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    ExtData
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG5403
     C                   PARM                    BufferEx2                                   BUG5403
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'IRCACFUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

      ** FX CLS Pay-in Schedule Header

     C     TransTYPE     WHENEQ    'CLSP'

     C                   EXSR      CLSPFmts
     C     CLSPLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       CLSPLn        Bfp
     C     CLIFLn        SUBST     BUFFER:Bfp    InfData                                      CAP086
     C                   ADD       CLIFLn        Bfp                                          CAP086

     C                   CALL      'FXCLSPVU'
     C                   PARM                    HeadIn
     C                   PARM                    Trans1
     C                   PARM                    InfData                                      CAP086
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      ** FX CLS Pay-in Schedule Detail

     C     TransTYPE     WHENEQ    'CLS2'

     C                   EXSR      CLS2Fmts
     C     CLS2Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       CLS2Ln        Bfp

     C                   CALL      'FXCLSPVU2'
     C                   PARM                    HeadIn
     C                   PARM                    Trans1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc

      ** Internal Contracts

     C     TransTYPE     WHENEQ    'INTC'

     C                   EXSR      INTCFmts

      ** Need to add 109 chars for the following fields not included on
      ** Format file ABINTCPD.
      ** DDLL2RT/DDL2CB/DDL2BA/DDL2CS/DDL2SA/DDLOIA/DDDPIA/DDSTS
     C                   ADD       109           INTCLn
     C     INTCLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       INTCLn        Bfp
     C     20            SUBST     BUFFER:Bfp    FRNT                                         261962
     C                   ADD       20            Bfp                                          261962
     C     20            SUBST     BUFFER:Bfp    AFRT                                         261962
     C                   ADD       20            Bfp                                          261962
     C     1             SUBST     BUFFER:Bfp    AAuth             1                        BUG22140
     C                   ADD       1             Bfp                                        BUG22140
     C/COPY WNCPYSRC,APH00032

     C                   CALL      'ABINTCVU'
     C                   PARM                    HeadIn
     C                   PARM                    Trans1
     C/COPY WNCPYSRC,APH00033
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    AAuth                                      BUG22140
     C                   PARM                    FRNT                                         261962
     C                   PARM                    AFRT                                         261962

      ** Internal Funding Deals

     C     TransTYPE     WHENEQ    'FUND'

     C                   EXSR      FUNDFmts
     C     FUNDLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FUNDLn        Bfp
     C                   ADD       7             Bfp                                          CAP191
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP191
     C                   ADD       26            Bfp                                          CAP191
     C     FUEXLn        SUBST     BUFFER:Bfp    ExtData                                      CAP191
     C                   ADD       FUEXLn        Bfp                                          CAP191
     C     1             SUBST     BUFFER:Bfp    AAUTH                                        CAP191
     C                   ADD       1             Bfp                                          CAP191
     C     20            SUBST     BUFFER:Bfp    FRNT                                         261140
     C                   ADD       20            Bfp                                          261140
     C     20            SUBST     BUFFER:Bfp    AFRT                                         261140
     C                   ADD       20            Bfp                                          261140

     C                   CALL      'ABFUNDVU'
     C                   PARM                    HeadIn
     C                   PARM                    Trans1
     C                   PARM                    ExtData                                      CAP191
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                   CAP191
     C                   PARM                    AAUTH                                        CAP191
     C                   PARM                    FRNT                                         261140
     C                   PARM                    AFRT                                         261140

      ** Spot Rates

     C     TransTYPE     WHENEQ    'SPTR'

     C                   EXSR      SPTRFmts
     C     SPTRLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SPTRLn        Bfp
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
     C                   ADD       26            Bfp                                         BUG4469
     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
     C                   ADD       1             Bfp                                        BUG22140

     C                   CALL      'SDSPTRVU'
     C                   PARM                    HeadIn
     C                   PARM                    Trans1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4469
     C                   PARM                    AAuth                                      BUG22140

      * MM Interest Rates
     C     TransTYPE     WHENEQ    'INTR'

     C                   EXSR      INTRFmts

     C     INT1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       INT1Ln        Bfp
     C     INT2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       INT2Ln        Bfp
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4469
     C                   ADD       26            Bfp                                         BUG4469
     C     INEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'FDINTRVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    TRANS2
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4469


      * SE Security Diary Events
     C     TransTYPE     WHENEQ    'SEDE'

     C                   EXSR      SEDEFmts

     C     SEDELn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       SEDELn        Bfp
      **  Restore Timestamp field from the record                                            BUG4258
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
     C                   ADD       26            Bfp                                         BUG4258
     C     SDEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'SESEDEVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4258


      * SE Prices Input
     C     TransTYPE     WHENEQ    'PRCS'

     C                   EXSR      PRCSFmts

     C     PRCSLn        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       PRCSLn        Bfp
      **  Restore Timestamp field from the record                                            BUG4258
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                  BUG4258
     C                   ADD       26            Bfp                                         BUG4258
     C     PRCXLn        SUBST     BUFFER:Bfp    ExtData
     C                   ADD       PRCXLn        Bfp                                        BUG22140
     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
     C                   ADD       1             Bfp                                        BUG22140

     C                   CALL      'SEPRCSVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    TRANS1
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp                                  BUG4258
     C                   PARM                    AAuth                                      BUG22140

      * FD Forward rates

     C     TransTYPE     WHENEQ    'FWRT'

     C                   EXSR      FWRTFmts

     C     FWR1Ln        SUBST     BUFFER:Bfp    TRANS1
     C                   ADD       FWR1Ln        Bfp
     C     FWR2Ln        SUBST     BUFFER:Bfp    TRANS2
     C                   ADD       FWR2Ln        Bfp
     C     FWEXLn        SUBST     BUFFER:Bfp    ExtData

     C                   CALL      'FDFWRTVU'

      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans1
     C                   PARM                    Trans2
     C                   PARM                    ExtData
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    APIRetc
                                                                                             CGP010
      * Global BSPL Requests                                                                 CGP010
     C     TransTYPE     WHENEQ    'BSRQ'                                                    CGP010
                                                                                             CGP010
     C                   EXSR      BSRQFmts                                                  CGP010
                                                                                             CGP010
     C     BSRQLn        SUBST     BUFFER:Bfp    TRANS1                                      CGP010
     C                   ADD       BSRQLn        Bfp                                         CGP010
     C     BSRXLn        SUBST     BUFFER:Bfp    ExtData                                     CGP010
                                                                                             CGP010
     C                   CALL      'GOBSRQVU'                                                CGP010
                                                                                             CGP010
      * Common header information (DS) from source system                                    CGP010
     C                   PARM                    HeadIn                                      CGP010
                                                                                             CGP010
      * Transaction information                                                              CGP010
     C                   PARM                    TRANS1                                      CGP010
     C                   PARM                    FldNameArr                                  CGP010
     C                   PARM                    MsgIDArr                                    CGP010
     C                   PARM                    MsgDtaArr                                   CGP010
     C                   PARM                    WFldNamArr                                  CGP010
     C                   PARM                    WMsgIDArr                                   CGP010
     C                   PARM                    WMsgDtaArr                                  CGP010
     C                   PARM                    MsgFArray                                   CGP010
     C                   PARM                    UpdateYN                                    CGP010
     C                   PARM                    Buffer                                      CGP010
     C                   PARM                    APIRetc                                     CGP010

      * Settlement Module                                                                     CLE106
                                                                                              CLE106
     C     TransTYPE     WHENEQ    'SETL'                                                     CLE106
                                                                                              CLE106
     C                   EXSR      SETLFmts                                                   CLE106
                                                                                              CLE106
     C     SET1Ln        SUBST     BUFFER:Bfp    Trans1                                       CLE106
     C                   ADD       SET1Ln        Bfp                                          CLE106
     C     SET2Ln        SUBST     BUFFER:Bfp    RecSttmt                                     CLE106
     C                   ADD       SET2Ln        Bfp                                          CLE106
     C     SET3Ln        SUBST     BUFFER:Bfp    PaySttmt                                     CLE106
     C                   ADD       SET3Ln        Bfp                                          CLE106
                                                                                              CLE106
     C                   CALL      'SDSETLVU'                                                 CLE106
      * Common header information (DS) from source system                                     CLE106
     C                   PARM                    HeadIn                                       CLE106
      * Transaction information in a single large field from source system                    CLE106
     C                   PARM                    Trans1                                       CLE106
      * Transaction information in a single large field from source system                    CLE106
     C                   PARM                    RecSttmt                                     CLE106
      * Transaction information in a single large field from source system                    CLE106
     C                   PARM                    PaySttmt                                     CLE106
     C                   PARM                    FldNameArr                                   CLE106
     C                   PARM                    MsgIDArr                                     CLE106
     C                   PARM                    MsgDtaArr                                    CLE106
     C                   PARM                    WFldNamArr                                   CLE106
     C                   PARM                    WMsgIDArr                                    CLE106
     C                   PARM                    WMsgDtaArr                                   CLE106
     C                   PARM                    MsgFArray                                    CLE106
     C                   PARM                    UpdateYN                                     CLE106
     C                   PARM                    Buffer                                       CLE106
     C                   PARM                    APIRetc                                      CLE106
      * Function to drop column from UDF Extension table                                     BUG5728
     C     TransTYPE     WHENEQ    'COLD'                                                    BUG5728
                                                                                             BUG5728
     C     4             SUBST     BUFFER:Bfp    ApiName                                     BUG5728
     C                   ADD       4             Bfp                                         BUG5728
     C     10            SUBST     BUFFER:Bfp    DropCol                                     BUG5728
                                                                                             BUG5728
     C                   CALL      'GPCDROPCOL'                                              BUG5728
     C                   PARM                    ApiName           4                         BUG5728
     C                   PARM                    DropCol          10                         BUG5728
     C                   PARM                    MsgArrOUT                                   BUG5728
     C                   PARM                    APIRetc                                     BUG5728
      ** DL Dealing Fees                                                                      CAS011
     C     TransTYPE     WHENEQ    'DLFE'                                                     CAS011
                                                                                              CAS011
     C                   EXSR      DLFEFmts                                                   CAS011
     C                   EXSR      SettleFmts                                                 CAS011
                                                                                              CAS011
     C     DLFELn        SUBST     BUFFER:Bfp    TRANS1                                       CAS011
     C                   ADD       DLFELn        Bfp                                          CAS011
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAS011
     C                   ADD       ESSRLn        Bfp                                          CAS011
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAS011
     C                   ADD       ESSPLn        Bfp                                          CAS011
                                                                                              CAS011
     C                   CALL      'DLDLFEVU'                                                 CAS011
                                                                                              CAS011
      ** Common header information (DS) from source system                                    CAS011
     C                   PARM                    HeadIn                                       CAS011
                                                                                              CAS011
      ** Transaction information                                                              CAS011
     C                   PARM                    TRANS1                                       CAS011
     C                   PARM                    PaySttmt                                     CAS011
     C                   PARM                    RecSttmt                                     CAS011
     C                   PARM                    FldNameArr                                   CAS011
     C                   PARM                    MsgIDArr                                     CAS011
     C                   PARM                    MsgDtaArr                                    CAS011
     C                   PARM                    WFldNamArr                                   CAS011
     C                   PARM                    WMsgIDArr                                    CAS011
     C                   PARM                    WMsgDtaArr                                   CAS011
     C                   PARM                    MsgFArray                                    CAS011
     C                   PARM                    UpdateYN                                     CAS011
     C                   PARM                    Buffer                                       CAS011
     C                   PARM                    APIRetc                                      CAS011
                                                                                             BUG6417
      * Cash Management Hierarchy Validation                                                 BUG6417
                                                                                             BUG6417
     C     TransTYPE     WHENEQ    'HIER'                                                    BUG6417
                                                                                             BUG6417
     C     9             SUBST     BUFFER:1      Hierarchy         9                         BUG6417
     C                   MOVE      *BLANKS       ZFIELD                                      BUG6417
     C                   MOVEL     Hierarchy     ZFIELD                                      BUG6417
     C                   CALLB     'ZALIGN'                                                  BUG6417
     C                   PARM                    ZALIGNok          1                         BUG6417
     C                   PARM                    ZFIELD           16                         BUG6417
     C                   PARM      0             ZADEC             1 0                       BUG6417
     C                   PARM      9             ZADIG             2 0                       BUG6417
     C                   MOVE      ZFIELD        HierarchyID       9 0                       BUG6417
     C     2             SUBST     BUFFER:10     HierarchyType     2                         BUG6417
                                                                                             BUG6417
     C                   CALL      'REC100411'                                               BUG6417
     C                   PARM                    HierarchyID                                 BUG6417
     C                   PARM                    HierarchyType                               BUG6417
     C                   PARM                    FldNameArr                                  BUG6417
     C                   PARM                    MsgIDArr                                    BUG6417
     C                   PARM                    MsgDtaArr                                   BUG6417
     C                   PARM                    MsgFArray                                   BUG6417
     C                   PARM                    ErrorInd          1                         BUG6417
                                                                                             BUG6417
      *                                                                                       CRE026
      ** Collateral Type Details Validation                                                   CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'COTY'                                                     CRE026
                                                                                              CRE026
     C                   EXSR      COTYFmts                                                   CRE026
                                                                                              CRE026
     C     COTYLn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
     C                   ADD       COTYLn        Bfp                                          CRE026
      *                                                                                       CRE026
      ** Restore Timestamp field from the record                                              CRE026
      *                                                                                       CRE026
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
     C                   ADD       26            Bfp                                          CRE026
     C     SDCXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
                                                                                              CRE026
     C                   CALL      'SDCOTYVU'                                                 CRE026
      *                                                                                       CRE026
      ** Common header information (DS) from source system                                    CRE026
      *                                                                                       CRE026
     C                   PARM                    HeadIn                                       CRE026
      *                                                                                       CRE026
      ** Transaction information in a single large field from source system                   CRE026
      *                                                                                       CRE026
     C                   PARM                    Trans1                                       CRE026
                                                                                              CRE026
     C                   PARM                    ExtData                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    WFldNamArr                                   CRE026
     C                   PARM                    WMsgIDArr                                    CRE026
     C                   PARM                    WMsgDtaArr                                   CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    UpdateYN                                     CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    APIRetc                                      CRE026
     C                   PARM                    @TimeStamp                                   CRE026
      *                                                                                       CRE026
      ** Country Details Validation                                                           CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'CNTY'                                                     CRE026
                                                                                              CRE026
     C                   EXSR      CNTYFmts                                                   CRE026
                                                                                              CRE026
     C     CNTYLn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
     C                   ADD       CNTYLn        Bfp                                          CRE026
                                                                                              CRE026
     C     CTX1Ln        SUBST     BUFFER:Bfp    BCLData                                      CRE026
     C                   ADD       CTX1Ln        Bfp                                          CRE026
                                                                                              CRE026
     C     CTX2Ln        SUBST     BUFFER:Bfp    EurRepData                                   CRE026
     C                   ADD       CTX2Ln        Bfp                                          CRE026
      *                                                                                       CRE026
      ** Restore Timestamp field from the record                                              CRE026
      *                                                                                       CRE026
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
     C                   ADD       26            Bfp                                          CRE026
     C     SDCXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
                                                                                              CRE026
     C                   CALL      'SDCNTYVU'                                                 CRE026
      *                                                                                       CRE026
      ** Common header information (DS) from source system                                    CRE026
      *                                                                                       CRE026
     C                   PARM                    HeadIn                                       CRE026
      *                                                                                       CRE026
      ** Transaction information in a single large field from source system                   CRE026
      *                                                                                       CRE026
     C                   PARM                    Trans1                                       CRE026
     C                   PARM                    BCLData                                      CRE026
     C                   PARM                    EurRepData                                   CRE026
                                                                                              CRE026
     C                   PARM                    ExtData                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    WFldNamArr                                   CRE026
     C                   PARM                    WMsgIDArr                                    CRE026
     C                   PARM                    WMsgDtaArr                                   CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    UpdateYN                                     CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    APIRetc                                      CRE026
     C                   PARM                    @TimeStamp                                   CRE026
      *                                                                                       CRE026
      ** Alternative Name and Addresses Validation                                            CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'ALNA'                                                     CRE026
     C     TransTYPE     OREQ      'ALNU'                                                     CRE026
                                                                                              CRE026
     C                   EXSR      ALNAFmts                                                   CRE026
     C     ALNALn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
     C                   ADD       ALNALn        Bfp                                          CRE026
      *                                                                                       CRE026
      ** Restore Timestamp field from the record                                              CRE026
      *                                                                                       CRE026
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
     C                   ADD       26            Bfp                                          CRE026
     C     SDAXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
     C                   ADD       SDAXLn        Bfp                                        BUG22140
     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
     C                   ADD       1             Bfp                                        BUG22140
                                                                                              CRE026
     C                   CALL      'SDALNAVU'                                                 CRE026
      *                                                                                       CRE026
      ** Common header information (DS) from source system                                    CRE026
      *                                                                                       CRE026
     C                   PARM                    HeadIn                                       CRE026
      *                                                                                       CRE026
      ** Transaction information in a single large field from source system                   CRE026
      *                                                                                       CRE026
     C                   PARM                    Trans1                                       CRE026
                                                                                              CRE026
     C                   PARM                    ExtData                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    WFldNamArr                                   CRE026
     C                   PARM                    WMsgIDArr                                    CRE026
     C                   PARM                    WMsgDtaArr                                   CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    UpdateYN                                     CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    APIRetc                                      CRE026
     C                   PARM                    @TimeStamp                                   CRE026
     C                   PARM                    AAuth                                      BUG22140
      *                                                                                       CRE026
      ** User Definitions + Menu Items Details Validation                                     CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'AMUS'                                                     CRE026
                                                                                              CRE026
     C                   EXSR      AMUSFmts                                                   CRE026
                                                                                              CRE026
     C                   EVAL      TRANS1 = %SUBST(BUFFERTOTAL:Bfp:AMUSLn)                    CRE026
     C                   ADD       AMUSLn        Bfp                                          CRE026
     C                   EVAL      TRANS2 = %SUBST(BUFFERTOTAL:Bfp:BBR1Ln)                    CRE026
     C                   ADD       BBR1Ln        Bfp                                          CRE026
     C                   EVAL      TRANS3 = %SUBST(BUFFERTOTAL:Bfp:BBR2Ln)                    CRE026
     C                   ADD       BBR2Ln        Bfp                                          CRE026
     C                   EVAL      TRANS4 = %SUBST(BUFFERTOTAL:Bfp:BBR3Ln)                    CRE026
     C                   ADD       BBR3Ln        Bfp                                          CRE026
     C                   EVAL      TRANS5 = %SUBST(BUFFERTOTAL:Bfp:BBR4Ln)                    CRE026
     C                   ADD       BBR4Ln        Bfp                                          CRE026
     C                   EVAL      TRANS6 = %SUBST(BUFFERTOTAL:Bfp:BBR5Ln)                    CRE026
     C                   ADD       BBR5Ln        Bfp                                          CRE026
     C                   EVAL      TRANS7 = %SUBST(BUFFERTOTAL:Bfp:BBR6Ln)                    CRE026
     C                   ADD       BBR6Ln        Bfp                                          CRE026
     C                   EVAL      TRANS8 = %SUBST(BUFFERTOTAL:Bfp:BBR7Ln)                    CRE026
     C                   ADD       BBR7Ln        Bfp                                          CRE026
     C                   EVAL      TRANS9 = %SUBST(BUFFERTOTAL:Bfp:BBR8Ln)                    CRE026
     C                   ADD       BBR8Ln        Bfp                                          CRE026
     C                   EVAL      TRANS10 = %SUBST(BUFFERTOTAL:Bfp:OBR1Ln)                   CRE026
     C                   ADD       OBR1Ln        Bfp                                          CRE026
     C                   EVAL      TRANS11 = %SUBST(BUFFERTOTAL:Bfp:OBR2Ln)                   CRE026
     C                   ADD       OBR2Ln        Bfp                                          CRE026
     C                   EVAL      TRANS12 = %SUBST(BUFFERTOTAL:Bfp:OBR3Ln)                   CRE026
     C                   ADD       OBR3Ln        Bfp                                          CRE026
     C                   EVAL      TRANS13 = %SUBST(BUFFERTOTAL:Bfp:OBR4Ln)                   CRE026
     C                   ADD       OBR4Ln        Bfp                                          CRE026
     C                   EVAL      TRANS14 = %SUBST(BUFFERTOTAL:Bfp:OBR5Ln)                   CRE026
     C                   ADD       OBR5Ln        Bfp                                          CRE026
     C                   EVAL      TRANS15 = %SUBST(BUFFERTOTAL:Bfp:OBR6Ln)                   CRE026
     C                   ADD       OBR6Ln        Bfp                                          CRE026
     C                   EVAL      TRANS16 = %SUBST(BUFFERTOTAL:Bfp:OBR7Ln)                   CRE026
     C                   ADD       OBR7Ln        Bfp                                          CRE026
     C                   EVAL      TRANS17 = %SUBST(BUFFERTOTAL:Bfp:OBR8Ln)                   CRE026
     C                   ADD       OBR8Ln        Bfp                                          CRE026
     C                   EVAL      TRANS18 = %SUBST(BUFFERTOTAL:Bfp:COMPLn)                   CRE026
     C                   ADD       COMPLn        Bfp                                          CRE026
      *                                                                                       CRE026
      ** Restore Timestamp field from the record                                              CRE026
      *                                                                                       CRE026
     C                   EVAL      @TimeStamp = %SUBST(BUFFERTOTAL:Bfp:26)                    CRE026
     C                   ADD       26            Bfp                                          CRE026
     C                   EVAL      ExtData = %SUBST(BUFFERTOTAL:Bfp:SFUXLn)                   CRE026
                                                                                              CRE026
     C                   CALL      'SFAMUSVU'                                                 CRE026
      *                                                                                       CRE026
      ** Common header information (DS) from source system                                    CRE026
      *                                                                                       CRE026
     C                   PARM                    HeadIn                                       CRE026
      *                                                                                       CRE026
      ** Transaction information in a single large field from source system                   CRE026
      *                                                                                       CRE026
     C                   PARM                    Trans1                                       CRE026
     C                   PARM                    Trans2                                       CRE026
     C                   PARM                    Trans3                                       CRE026
     C                   PARM                    Trans4                                       CRE026
     C                   PARM                    Trans5                                       CRE026
     C                   PARM                    Trans6                                       CRE026
     C                   PARM                    Trans7                                       CRE026
     C                   PARM                    Trans8                                       CRE026
     C                   PARM                    Trans9                                       CRE026
     C                   PARM                    Trans10                                      CRE026
     C                   PARM                    Trans11                                      CRE026
     C                   PARM                    Trans12                                      CRE026
     C                   PARM                    Trans13                                      CRE026
     C                   PARM                    Trans14                                      CRE026
     C                   PARM                    Trans15                                      CRE026
     C                   PARM                    Trans16                                      CRE026
     C                   PARM                    Trans17                                      CRE026
     C                   PARM                    Trans18                                      CRE026
                                                                                              CRE026
     C                   PARM                    ExtData                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    WFldNamArr                                   CRE026
     C                   PARM                    WMsgIDArr                                    CRE026
     C                   PARM                    WMsgDtaArr                                   CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    UpdateYN                                     CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    Buffer2                                      CRE026
     C                   PARM                    APIRetc                                      CRE026
     C                   PARM                    @TimeStamp                                   CRE026
      *                                                                                       CRE026
      ** Nostro Codes Detail Validation                                                       CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'NOSR'                                                     CRE026
     C     TransTYPE     OREQ      'NOSU'                                                     CRE026
                                                                                              CRE026
     C                   EXSR      NOSRFmts                                                   CRE026
                                                                                              CRE026
     C     NOSRLn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
     C                   ADD       NOSRLn        Bfp                                          CRE026
      *                                                                                       CRE026
      ** Restore Timestamp field from the record                                              CRE026
      *                                                                                       CRE026
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
     C                   ADD       26            Bfp                                          CRE026
     C     SDNXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
                                                                                              CRE026
     C                   CALL      'SDNOSRVU'                                                 CRE026
      *                                                                                       CRE026
      ** Common header information (DS) from source system                                    CRE026
      *                                                                                       CRE026
     C                   PARM                    HeadIn                                       CRE026
      *                                                                                       CRE026
      ** Transaction information in a single large field from source system                   CRE026
      *                                                                                       CRE026
     C                   PARM                    Trans1                                       CRE026
                                                                                              CRE026
     C                   PARM                    ExtData                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    WFldNamArr                                   CRE026
     C                   PARM                    WMsgIDArr                                    CRE026
     C                   PARM                    WMsgDtaArr                                   CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    UpdateYN                                     CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    APIRetc                                      CRE026
     C                   PARM                    @TimeStamp                                   CRE026
      *                                                                                       CRE026
      ** Yield Curve Detail Validation                                                        CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'YLCU'                                                     CRE026
                                                                                              CRE026
     C                   EXSR      YLCUFmts                                                   CRE026
                                                                                              CRE026
     C     YLCULn        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
     C                   ADD       YLCULn        Bfp                                          CRE026
      *                                                                                       CRE026
      ** Restore Timestamp field from the record                                              CRE026
      *                                                                                       CRE026
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
     C                   ADD       26            Bfp                                          CRE026
     C     SDYXLn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
                                                                                              CRE026
     C                   CALL      'SDYLCUVU'                                                 CRE026
      *                                                                                       CRE026
      ** Common header information (DS) from source system                                    CRE026
      *                                                                                       CRE026
     C                   PARM                    HeadIn                                       CRE026
      *                                                                                       CRE026
      ** Transaction information in a single large field from source system                   CRE026
      *                                                                                       CRE026
     C                   PARM                    Trans1                                       CRE026
                                                                                              CRE026
     C                   PARM                    ExtData                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    WFldNamArr                                   CRE026
     C                   PARM                    WMsgIDArr                                    CRE026
     C                   PARM                    WMsgDtaArr                                   CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    UpdateYN                                     CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    APIRetc                                      CRE026
     C                   PARM                    @TimeStamp                                   CRE026
      *                                                                                       CRE026
      ** Yield Rates Detail Validation                                                        CRE026
      *                                                                                       CRE026
     C     TransTYPE     WHENEQ    'YRAT'                                                     CRE026
                                                                                              CRE026
     C                   EXSR      YRATFmts                                                   CRE026
      *                                                                                       CRE026
      ** Restore Timestamp field from the record                                              CRE026
      *                                                                                       CRE026
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CRE026
     C                   ADD       26            Bfp                                          CRE026
     C     YRA1Ln        SUBST     BUFFER:Bfp    TRANS1                                       CRE026
     C                   ADD       YRA1Ln        Bfp                                          CRE026
     C     YRA2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CRE026
     C                   ADD       YRA2Ln        Bfp                                          CRE026
     C     YRA3Ln        SUBST     BUFFER:Bfp    TRANS3                                       CRE026
     C                   ADD       YRA3Ln        Bfp                                          CRE026
     C     YRA4Ln        SUBST     BUFFER:Bfp    TRANS4                                       CRE026
     C                   ADD       YRA4Ln        Bfp                                          CRE026
     C     SDYELn        SUBST     BUFFER:Bfp    ExtData                                      CRE026
                                                                                              CRE026
     C                   CALL      'SDYRATVU'                                                 CRE026
      *                                                                                       CRE026
      ** Common header information (DS) from source system                                    CRE026
      *                                                                                       CRE026
     C                   PARM                    HeadIn                                       CRE026
      *                                                                                       CRE026
      ** Transaction information in a single large field from source system                   CRE026
      *                                                                                       CRE026
     C                   PARM                    Trans1                                       CRE026
     C                   PARM                    Trans2                                       CRE026
     C                   PARM                    Trans3                                       CRE026
     C                   PARM                    Trans4                                       CRE026
                                                                                              CRE026
     C                   PARM                    ExtData                                      CRE026
     C                   PARM                    FldNameArr                                   CRE026
     C                   PARM                    MsgIDArr                                     CRE026
     C                   PARM                    MsgDtaArr                                    CRE026
     C                   PARM                    WFldNamArr                                   CRE026
     C                   PARM                    WMsgIDArr                                    CRE026
     C                   PARM                    WMsgDtaArr                                   CRE026
     C                   PARM                    MsgFArray                                    CRE026
     C                   PARM                    UpdateYN                                     CRE026
     C                   PARM                    Buffer                                       CRE026
     C                   PARM                    APIRetc                                      CRE026
     C                   PARM                    @TimeStamp                                   CRE026
                                                                                              CSD092
      ** Account Review Detail Validation                                                     CSD092
                                                                                              CSD092
     C     TransTYPE     WHENEQ    'ACRV'                                                     CSD092
                                                                                              CSD092
     C                   EXSR      ACRFFmts                                                   CSD092
                                                                                              CSD092
     C     ACRFLn        SUBST     BUFFER:Bfp    TRANS1A                                      CSD092
     C                   ADD       ACRFLn        Bfp                                          CSD092
                                                                                              CSD092
      ** Restore Timestamp field from the record                                              CSD092
                                                                                              CSD092
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD092
     C                   ADD       26            Bfp                                          CSD092
     C     ACEXLn        SUBST     BUFFER:Bfp    ExtData                                      CSD092
                                                                                              CSD092
     C                   CALL      'SDACRVVU'                                                 CSD092
                                                                                              CSD092
      ** Common header information (DS) from source system                                    CSD092
                                                                                              CSD092
     C                   PARM                    HeadIn                                       CSD092
                                                                                              CSD092
      ** Transaction information in a single large field from source system                   CSD092
                                                                                              CSD092
     C                   PARM                    Trans1A                                      CSD092
                                                                                              CSD092
     C                   PARM                    ExtData                                      CSD092
     C                   PARM                    FldNameArr                                   CSD092
     C                   PARM                    MsgIDArr                                     CSD092
     C                   PARM                    MsgDtaArr                                    CSD092
     C                   PARM                    WFldNamArr                                   CSD092
     C                   PARM                    WMsgIDArr                                    CSD092
     C                   PARM                    WMsgDtaArr                                   CSD092
     C                   PARM                    MsgFArray                                    CSD092
     C                   PARM                    UpdateYN                                     CSD092
     C                   PARM                    Buffer                                       CSD092
     C                   PARM                    APIRetc                                      CSD092
     C                   PARM                    @TimeStamp                                   CSD092
                                                                                              CSD093
     C     TransTYPE     WHENEQ    'DCMT'                                                     CSD093
                                                                                              CSD093
     C                   EXSR      DCMTFmts                                                   CSD093
     C     DCMTLn        SUBST     BUFFER:Bfp    TRANS1                                       CSD093
     C                   ADD       DCMTLn        Bfp                                          CSD093
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD093
     C                   ADD       26            Bfp                                          CSD093
     C     DCMXLn        SUBST     BUFFER:Bfp    TRANS2                                       CSD093
     C                   ADD       DCMXLn        Bfp                                          CSD093
     C     1             SUBST     BUFFER:Bfp    AAuth                                        CSD093
     C                   ADD       1             Bfp                                          CSD093
                                                                                              CSD093
     C                   CALL      'SDDCMTVU'                                                 CSD093
                                                                                              CSD093
      * Common header information (DS) from source system                                     CSD093
     C                   PARM                    HeadIn                                       CSD093
                                                                                              CSD093
      * Transaction information                                                               CSD093
     C                   PARM                    TRANS1                                       CSD093
     C                   PARM                    TRANS2                                       CSD093
     C                   PARM                    FldNameArr                                   CSD093
     C                   PARM                    MsgIDArr                                     CSD093
     C                   PARM                    MsgDtaArr                                    CSD093
     C                   PARM                    WFldNamArr                                   CSD093
     C                   PARM                    WMsgIDArr                                    CSD093
     C                   PARM                    WMsgDtaArr                                   CSD093
     C                   PARM                    MsgFArray                                    CSD093
     C                   PARM                    UpdateYN                                     CSD093
     C                   PARM                    Buffer                                       CSD093
     C                   PARM                    APIRetc                                      CSD093
     C                   PARM                    @TimeStamp                                   CSD093
      *                                                                                       CSD079
      ** Risk Weighted Asset Detail Validation                                                CSD079
      *                                                                                       CSD079
     C     TransTYPE     WHENEQ    'RWAN'                                                     CSD079
                                                                                              CSD079
     C                   EXSR      RWANFmts                                                   CSD079
                                                                                              CSD079
     C     RWANLn        SUBST     BUFFER:Bfp    TRANS1                                       CSD079
     C                   ADD       RWANLn        Bfp                                          CSD079
      *                                                                                       CSD079
      ** Restore Timestamp field from the record                                              CSD079
      *                                                                                       CSD079
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD079
     C                   ADD       26            Bfp                                          CSD079
                                                                                              CSD079
     C                   CALL      'SDRWANVU'                                                 CSD079
      *                                                                                       CSD079
      ** Common header information (DS) from source system                                    CSD079
      *                                                                                       CSD079
     C                   PARM                    HeadIn                                       CSD079
      *                                                                                       CSD079
      ** Transaction information in a single large field from source system                   CSD079
      *                                                                                       CSD079
     C                   PARM                    Trans1                                       CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
     C                   PARM                    MsgFArray                                    CSD079
     C                   PARM                    UpdateYN                                     CSD079
     C                   PARM                    Buffer                                       CSD079
     C                   PARM                    APIRetc                                      CSD079
     C                   PARM                    @TimeStamp                                   CSD079
      *                                                                                       CSD079
      ** Customer Withholding Tax Detail Validation                                           CSD079
      *                                                                                       CSD079
     C     TransTYPE     WHENEQ    'CUWT'                                                     CSD079
     C     TransTYPE     OREQ      'CUWU'                                                     CSD079
                                                                                              CSD079
     C                   EXSR      CUWTFmts                                                   CSD079
      *                                                                                       CSD079
      ** Restore Timestamp field from the record                                              CSD079
      *                                                                                       CSD079
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CSD079
     C                   ADD       26            Bfp                                          CSD079
                                                                                              CSD079
     C     CUW1Ln        SUBST     BUFFER:Bfp    TRANS1                                       CSD079
     C                   ADD       CUW1Ln        Bfp                                          CSD079
     C     CUW2Ln        SUBST     BUFFER:Bfp    TRANS2                                       CSD079
     C                   ADD       CUW2Ln        Bfp                                          CSD079
     C     1             SUBST     BUFFER:Bfp    AAuth                                      BUG22140
     C                   ADD       1             Bfp                                        BUG22140
                                                                                              CSD079
     C                   CALL      'SDCUWTVU'                                                 CSD079
      *                                                                                       CSD079
      ** Common header information (DS) from source system                                    CSD079
      *                                                                                       CSD079
     C                   PARM                    HeadIn                                       CSD079
      *                                                                                       CSD079
      ** Transaction information in a single large field from source system                   CSD079
      *                                                                                       CSD079
     C                   PARM                    Trans1                                       CSD079
     C                   PARM                    Trans2                                       CSD079
                                                                                              CSD079
     C                   PARM                    FldNameArr                                   CSD079
     C                   PARM                    MsgIDArr                                     CSD079
     C                   PARM                    MsgDtaArr                                    CSD079
     C                   PARM                    WFldNamArr                                   CSD079
     C                   PARM                    WMsgIDArr                                    CSD079
     C                   PARM                    WMsgDtaArr                                   CSD079
     C                   PARM                    MsgFArray                                    CSD079
     C                   PARM                    UpdateYN                                     CSD079
     C                   PARM                    Buffer                                       CSD079
     C                   PARM                    APIRetc                                      CSD079
     C                   PARM                    @TimeStamp                                   CSD079
     C                   PARM                    AAuth                                      BUG22140
                                                                                              CSD079
      *                                                                                       CLE134
      ** PDCL Input                                                                           CLE134
      *                                                                                       CLE134
     C     TransTYPE     WHENEQ    'PDCL'                                                     CLE134
      *                                                                                       CLE134
     C                   EXSR      CPDCFmts                                                   CLE134
      *                                                                                       CLE134
     C     CPD1Ln        SUBST     BUFFER:Bfp    TRANS1A                                      CLE134
     C                   ADD       CPD1Ln        Bfp                                          CLE134
      *                                                                                       CLE134
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CLE134
     C                   ADD       26            Bfp                                          CLE134
      *                                                                                       CLE134
     C                   CALL      'LEPDCLVU'                                                 CLE134
      *                                                                                       CLE134
      ** Common header information (DS) from source system                                    CLE134
      *                                                                                       CLE134
     C                   PARM                    HeadIn                                       CLE134
      *                                                                                       CLE134
      ** Transaction information in a single large field from source system                   CLE134
      *                                                                                       CLE134
     C                   PARM                    Trans1A                                      CLE134
      *                                                                                       CLE134
     C                   PARM                    FldNameArr                                   CLE134
     C                   PARM                    MsgIDArr                                     CLE134
     C                   PARM                    MsgDtaArr                                    CLE134
     C                   PARM                    WFldNamArr                                   CLE134
     C                   PARM                    WMsgIDArr                                    CLE134
     C                   PARM                    WMsgDtaArr                                   CLE134
     C                   PARM                    MsgFArray                                    CLE134
     C                   PARM                    UpdateYN                                     CLE134
     C                   PARM                    Buffer                                       CLE134
     C                   PARM                    APIRetc                                      CLE134
     C                   PARM                    @TimeStamp                                   CLE134
      *                                                                                       CAP210
      ** Adjustment to Accured interest                                                       CAP210
      *                                                                                       CAP210
     C     TransTYPE     WHENEQ    'DLAA'                                                     CAP210
     C                   EXSR      DLAAFmts                                                   CAP210
                                                                                              CAP210
     C     DLAALn        SUBST     BUFFER:Bfp    TRANS1                                       CAP210
     C                   ADD       DLAALn        Bfp                                          CAP210
      *                                                                                       CAP210
      ** Restore Timestamp field from the record                                              CAP210
      *                                                                                       CAP210
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP210
     C                   ADD       26            Bfp                                          CAP210
                                                                                              CAP210
     C                   CALL      'DLDLAAVU'                                                 CAP210
      *                                                                                       CAP210
      ** Common header information (DS) from source system                                    CAP210
      *                                                                                       CAP210
     C                   PARM                    HeadIn                                       CAP210
      *                                                                                       CAP210
      ** Transaction information in a single large field from source system                   CAP210
      *                                                                                       CAP210
     C                   PARM                    Trans1                                       CAP210
                                                                                              CAP210
     C                   PARM                    FldNameArr                                   CAP210
     C                   PARM                    MsgIDArr                                     CAP210
     C                   PARM                    MsgDtaArr                                    CAP210
     C                   PARM                    WFldNamArr                                   CAP210
     C                   PARM                    WMsgIDArr                                    CAP210
     C                   PARM                    WMsgDtaArr                                   CAP210
     C                   PARM                    MsgFArray                                    CAP210
     C                   PARM                    UpdateYN                                     CAP210
     C                   PARM                    Buffer                                       CAP210
     C                   PARM                    APIRetc                                      CAP210
      *                                                                                    AR1086546
      ** Currency/Time of Netting Detail Validation                                        AR1086546
      *                                                                                    AR1086546
     C     TransTYPE     WHENEQ    'CTNM'                                                  AR1086546
     C     TransTYPE     OREQ      'CCTN'                                                  AR1086546
                                                                                           AR1086546
     C                   EXSR      CCTNFmts                                                AR1086546
                                                                                           AR1086546
     C     CCTNLn        SUBST     BUFFER:Bfp    TRANS1                                    AR1086546
     C                   ADD       CCTNLn        Bfp                                       AR1086546
      *                                                                                    AR1086546
      ** Restore Timestamp field from the record                                           AR1086546
      *                                                                                    AR1086546
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                AR1086546
     C                   ADD       26            Bfp                                       AR1086546
                                                                                           AR1086546
     C                   CALL      'SDCTNMVU'                                              AR1086546
      *                                                                                    AR1086546
      ** Common header information (DS) from source system                                 AR1086546
      *                                                                                    AR1086546
     C                   PARM                    HeadIn                                    AR1086546
      *                                                                                    AR1086546
      ** Transaction information in a single large field from source system                AR1086546
      *                                                                                    AR1086546
     C                   PARM                    Trans1                                    AR1086546
                                                                                           AR1086546
     C                   PARM                    FldNameArr                                AR1086546
     C                   PARM                    MsgIDArr                                  AR1086546
     C                   PARM                    MsgDtaArr                                 AR1086546
     C                   PARM                    WFldNamArr                                AR1086546
     C                   PARM                    WMsgIDArr                                 AR1086546
     C                   PARM                    WMsgDtaArr                                AR1086546
     C                   PARM                    MsgFArray                                 AR1086546
     C                   PARM                    UpdateYN                                  AR1086546
     C                   PARM                    Buffer                                    AR1086546
     C                   PARM                    APIRetc                                   AR1086546
     C                   PARM                    @TimeStamp                                AR1086546
     C***/COPY*OFCPYSRCZ,CAP090_003                                                    CAP090 CLE164
     C/COPY OFCPYSRCZ,CGL158_003                                                              CGL158
      *                                                                                       CAP212
      ** Nostro Transfer API                                                                  CAP212
      *                                                                                       CAP212
     C     TransTYPE     WHENEQ    'FTNT'                                                     CAP212
                                                                                              CAP212
     C                   EXSR      FTNTFmts                                                   CAP212
                                                                                              CAP212
     C     FTNTLn        SUBST(P)  BUFFER:Bfp    Trans1A                                      CAP212
     C                   ADD       FTNTLn        Bfp                                          CAP212
     C     FTEXLn        SUBST(P)  BUFFER:Bfp    ExtData                                      CAP212
     C                   ADD       FTEXLn        Bfp                                          CAP212
     C     26            SUBST     BUFFER:Bfp    @TimeStamp                                   CAP212
     C                   ADD       26            Bfp                                          CAP212
     C     20            SUBST     BUFFER:Bfp    AuthUsers                                    CFT163
     C                   ADD       20            Bfp                                          CFT163
                                                                                              CAP212
     C                   CALL      'FTFTNTVU'                                                 CAP212
     C                   PARM                    HeadIn                                       CAP212
     C                   PARM                    Trans1A                                      CAP212
     C                   PARM                    ExtData                                      CAP212
     C                   PARM                    FldNameArr                                   CAP212
     C                   PARM                    MsgIDArr                                     CAP212
     C                   PARM                    MsgDtaArr                                    CAP212
     C                   PARM                    WFldNamArr                                   CAP212
     C                   PARM                    WMsgIDArr                                    CAP212
     C                   PARM                    WMsgDtaArr                                   CAP212
     C                   PARM                    MsgFArray                                    CAP212
     C                   PARM                    UpdateYN                                     CAP212
     C                   PARM                    Buffer                                       CAP212
     C                   PARM                    APIRetc                                      CAP212
     C                   PARM                    @TimeStamp                                   CAP212
     C                   PARM                    AuthUsers                                    CFT163
      *                                                                                       CLE164
      ** Initiate Batch Process API                                                           CLE164
      *                                                                                       CLE164
     C     TransTYPE     WHENEQ    'SBJB'                                                     CLE164
     C                   EXSR      SBJBFmts                                                   CLE164
                                                                                              CLE164
     C     SBJBLen       SUBST     BUFFER:Bfp    SBJBParm                                     CLE164
     C                   ADD       SBJBLen       Bfp                                          CLE164
      *                                                                                       CLE164
     C     SBEXLen       SUBST     BUFFER:Bfp    ExtData                                      CLE164
      *                                                                                       CLE164
     C                   CALL      'APSBJBVU'                                                 CLE164
      *                                                                                       CLE164
      ** Common header information (DS) from source system                                    CLE164
      *                                                                                       CLE164
     C                   PARM                    HeadIn                                       CLE164
      *                                                                                       CLE164
      ** Transaction information in a single large field from source system                   CLE164
      *                                                                                       CLE164
     C                   PARM                    SBJBParm                                     CLE164
      *                                                                                       CLE164
     C                   PARM                    ExtData                                      CLE164
     C                   PARM                    FldNameArr                                   CLE164
     C                   PARM                    MsgIDArr                                     CLE164
     C                   PARM                    MsgDtaArr                                    CLE164
     C                   PARM                    WFldNamArr                                   CLE164
     C                   PARM                    WMsgIDArr                                    CLE164
     C                   PARM                    WMsgDtaArr                                   CLE164
     C                   PARM                    MsgFArray                                    CLE164
     C                   PARM                    UpdateYN                                     CLE164
     C                   PARM                    Buffer                                       CLE164
     C                   PARM                    APIRetc                                      CLE164
      *
      * If unknown API requested, make sure this is reported back
     C                   OTHER
     C                   EXSR      *PSSR

     C                   ENDSL

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      *  SrSIRS - Call the validate/update program for SIRS
      ****************************************************************
     C     SrSIRS        BEGSR

     C                   EXSR      SIRSFmts
     C**********         EXSR      SCHEDFmts                                                 BUG4646
     C                   EXSR      SettleFmts
     C                   EXSR      RPIFFmts                                                   CSW213
     C**********         EVAL      APTGTTYPE = %SUBST(BUFFER:1:6)                            BUG4646
     C**********         ADD       6             Bfp                                         BUG4646
      **********                                                                             BUG4646
     C**********         SELECT                                                              BUG4646

      ** Single Currency IRS - Main details
      **********                                                                             BUG4646
     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSIRS'                             BUG4646
     C*****SIRSLn        SUBST     BUFFER:Bfp    Trans1                                       CIR017
     C     SIRSLn        SUBST     BUFFER:Bfp    Trans1A                                      CIR017
     C                   ADD       SIRSLn        Bfp
     C*****DTORLn        SUBST     BUFFER:Bfp    Trans2                                      BUG4646
     C**********         ADD       DTORLn        Bfp                                         BUG4646
     C*****DTOPLn        SUBST     BUFFER:Bfp    Trans3                                      BUG4646
     C**********         ADD       DTOPLn        Bfp                                         BUG4646
     C*****DTTRLn        SUBST     BUFFER:Bfp    Trans4                                      BUG4646
     C**********         ADD       DTTRLn        Bfp                                         BUG4646
     C*****DTTPLn        SUBST     BUFFER:Bfp    Trans5                                      BUG4646

      ***Rate*Change*&*Interest*Payment*Dates*-*Single*Currency*IRS****                      BUG4646
      *****************************************************************                      BUG4646
     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSIRI'                             BUG4646
     C*****DTORLn        SUBST     BUFFER:Bfp    Trans1                                      BUG4646
     C**********         ADD       DTORLn        Bfp                                         BUG4646
     C*****DTOPLn        SUBST     BUFFER:Bfp    Trans2                                      BUG4646
     C**********         ADD       DTOPLn        Bfp                                         BUG4646
     C*****DTTRLn        SUBST     BUFFER:Bfp    Trans3                                      BUG4646
     C**********         ADD       DTTRLn        Bfp                                         BUG4646
     C*****DTTPLn        SUBST     BUFFER:Bfp    Trans4                                      BUG4646
      *****************************************************************                      BUG4646
      ***Cash*Flow*Schedules*-*Single*Currency*IRS*********************                      BUG4646
      *****************************************************************                      BUG4646
     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSICF'                             BUG4646
     C*****WCFSC1OLn     SUBST     BUFFER:Bfp    Trans1                                      BUG4646
     C**********         ADD       WCFSC1OLn     Bfp                                         BUG4646
     C*****WCFSC2OLn     SUBST     BUFFER:Bfp    Trans2                                      BUG4646
     C**********         ADD       WCFSC2OLn     Bfp                                         BUG4646
     C*****WCFSC3OLn     SUBST     BUFFER:Bfp    Trans3                                      BUG4646
     C**********         ADD       WCFSC3OLn     Bfp                                         BUG4646
     C*****WCFSC4OLn     SUBST     BUFFER:Bfp    Trans4                                      BUG4646
     C**********         ADD       WCFSC4OLn     Bfp                                         BUG4646
     C*****WCFSC1TLn     SUBST     BUFFER:Bfp    Trans5                                      BUG4646
     C**********         ADD       WCFSC1TLn     Bfp                                         BUG4646
     C*****WCFSC2TLn     SUBST     BUFFER:Bfp    Trans6                                      BUG4646
     C**********         ADD       WCFSC2TLn     Bfp                                         BUG4646
     C*****WCFSC3TLn     SUBST     BUFFER:Bfp    Trans7                                      BUG4646
     C**********         ADD       WCFSC3TLn     Bfp                                         BUG4646
     C*****WCFSC4TLn     SUBST     BUFFER:Bfp    Trans8                                      BUG4646
      *****************************************************************                      BUG4646
      ***Principal*Change*Schedules*-*Single*Currency*IRS**************                      BUG4646
      *****************************************************************                      BUG4646
     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSIPC'                             BUG4646
     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    Trans1                                      BUG4646
     C**********         ADD       WPCSC1OLn     Bfp                                         BUG4646
     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    Trans2                                      BUG4646
     C**********         ADD       WPCSC2OLn     Bfp                                         BUG4646
     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    Trans3                                      BUG4646
     C**********         ADD       WPCSC3OLn     Bfp                                         BUG4646
     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    Trans4                                      BUG4646
      *****************************************************************                      BUG4646
      ***Trailer*record*-*Single*Currency*IRS**************************                      BUG4646
      *****************************************************************                      BUG4646
     C**********         WHEN      %SUBST(BUFFER:1:6) = 'IRSITR'                             BUG4646
     C*****WTRSCLn       SUBST     BUFFER:Bfp    Trans1                                      BUG4646
     C**********         ADD       WTRSCLn       Bfp                                         BUG4646
     C     ESSRLn        SUBST     BUFFER:Bfp    RecSttmt
     C                   ADD       ESSRLn        Bfp
     C     ESSPLn        SUBST     BUFFER:Bfp    PaySttmt
     C                   ADD       ESSPLn        Bfp
     C     ESSFLn        SUBST     BUFFER:Bfp    FRASttmt
     C                   ADD       ESSFLn        Bfp                                         BUG6671
                                                                                             BUG6671
      **  Non-Screen Interface Data for Class 1 enhancements                                 BUG6671
                                                                                             BUG6671
     C     IRRSLn        SUBST     BUFFER:Bfp    InfData                                     BUG6671
     C                   ADD       IRRSLn        Bfp                                         BUG6671
                                                                                             BUG6671
     C     IRSSLn        SUBST     BUFFER:Bfp    ExtData                                     BUG6671
     C                   ADD       IRSSLn        Bfp                                          CSW213
     C                   ADD       168           Bfp                                          CSW213
     C                   ADD       20            Bfp                                        MD039064
     C     RPIFLn        SUBST     BUFFER:Bfp    InSwift2013                                  CSW213
                                                                                             BUG6671

     C**********         ENDSL                                                               BUG4646

     C                   CALL      'IRSIRSVU'
     C                   PARM                    HeadIn
     C**********         PARM                    Trans1                                       CIR017
     C                   PARM                    Trans1A                                      CIR017
     C**********         PARM                    Trans2                                      BUG4646
     C**********         PARM                    Trans3                                      BUG4646
     C**********         PARM                    Trans4                                      BUG4646
     C**********         PARM                    Trans5                                      BUG4646
     C**********         PARM                    Trans6                                      BUG4646
     C**********         PARM                    Trans7                                      BUG4646
     C**********         PARM                    Trans8                                      BUG4646
     C                   PARM                    RecSttmt
     C                   PARM                    PaySttmt
     C                   PARM                    FRASttmt
     C                   PARM                    InfData                                     BUG6671
     C                   PARM                    ExtData                                     BUG6671
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG4646
     C                   PARM                    BufferEx2                                   BUG4646
     C                   PARM                    BufferEx3                                   BUG4646
     C                   PARM                    BufferEx4                                   BUG4646
     C                   PARM                    BufferEx5                                   BUG4646
     C                   PARM                    BufferEx6                                   BUG4646
     C                   PARM                    BufferEx7                                   BUG4646
     C                   PARM                    BufferEx8                                   BUG4646
     C                   PARM                    BufferEx9                                   BUG4646
     C                   PARM                    APIRetc
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WrkPgm = 'IRSIRSUPD'                                       CRE020
     C                   EVAL      WrkMod = 'DL'                                              CRE020
     C                   EXSR      SRSndDtaQ                                                  CRE020
     C                   ENDIF                                                                CRE020

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Edit the Messages for output
      ****************************************************************
     C     EDTMSGS       BEGSR
     C                                                                                        CBF011
     C                   EVAL      APINam  = TransType                                        CBF011
     C                   CALLB     'APEDTMSGS'
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    MsgArrOUT
     C                   PARM                    APINam                                       CBF011
                                                                                              CBF011
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * FX Deal
      *****************************************************************
     C     FXDLFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FXFXDLPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FXDLLn            4 0

      **Add*DDNBRF*(19)*DDNSRF*(19)*DDSTS*(24)*BNNMAM*(1)**************                       CTI004
      **and*BJLCCY*(3)*to*end*of*details.******************************                       CTI004
     C**********         ADD       66            FXDLLn                                       CTI004
      * Add DDNBRF (19) DDNSRF (19) DDSTS (24) BNNMAM (1)                                     CTI004
      **BJLCCY*(3)*and*DDFOID*(20)*to*end*of*details.******************                CTI004 261692
      * BJLCCY (3) DDFOID (20) and DDAFID (20) to end of details.                             261692
     C**********         ADD       86            FXDLLn                                CTI004 261692
     C                   ADD       106           FXDLLn                                       261692
      * Add Override flag, overriding officer and overriding officer password                 CFX114
     C                   ADD       21            FXDLLn                                       CFX114
      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG4562
     C                   ADD       6             FXDLLn                                      BUG4562

     C                   MOVEL     'FXFXIFPD'    FileName                                    BUG4815
     C                   EXSR      GETRCDLN                                                  BUG4815
     C                   Z-ADD     RecordLen     FXIFLn            4 0                       BUG4815
                                                                                             BUG4815
     C                   MOVEL     'FXFXEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FXFXLn            4 0

     C                   MOVEL     'FXDLEXPD'    FileName                                     CDL099
     C                   EXSR      GETRCDLN                                                   CDL099
     C                   Z-ADD     RecordLen     FXEDLn            4 0                        CDL099
                                                                                              CDL099
     C**********         MOVEL     'SDCUCUPD'    FileName                              CER043 CSF011
     C**********         EXSR      GETRCDLN                                            CER043 CSF011
     C**********         Z-ADD     RecordLen     SDCULn                                CER043 CSF011
      **********                                                                       CER043 CSF011
     C                   ENDSR
      *****************************************************************                       CSW213
      /SPACE 5                                                                                CSW213
      *****************************************************************                       CSW213
      * DL RPIF - Reporting Information                                                       CSW213
      *****************************************************************                       CSW213
     C     RPIFFmts      BEGSR                                                                CSW213
                                                                                              CSW213
     C                   EVAL      FileName = 'DLRIS1PD'                                      CSW213
     C                   EXSR      GETRCDLN                                                   CSW213
     C                   EVAL      RPIF1Ln = RecordLen                                        CSW213
     C                                                                                        CSW213
     C                   EVAL      FileName = 'DLRIS2PD'                                      CSW213
     C                   EXSR      GETRCDLN                                                   CSW213
     C                   EVAL      RPIF2Ln = RecordLen                                        CSW213
     C                                                                                        CSW213
     C                   EVAL      FileName = 'DLRIS3PD'                                      CSW213
     C                   EXSR      GETRCDLN                                                   CSW213
     C                   EVAL      RPIF3Ln = RecordLen                                        CSW213
     C                                                                                        CSW213
     C                   EVAL      FileName = 'DLRIS4PD'                                      CSW214
     C                   EXSR      GETRCDLN                                                   CSW214
     C                   EVAL      RPIF4Ln = RecordLen                                        CSW214
                                                                                              CSW214
     C                   EVAL      RPIFLn = RPIF1Ln + RPIF2Ln + RPIF3Ln                       CSW213
     C                             + RPIF4Ln                                                  CSW214
                                                                                              CSW213
     C                   ENDSR                                                                CSW213
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * MM Loan/Deposit
      *****************************************************************
     C     LDNIFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'MMLDNIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LDNILn            4 0
      **Add*TRAM*fields,*Counterpary and Broker Stati and visibility flags           BUG6512 BUG7664
     C*******************ADD       6             LDNILn                              BUG6512 BUG7664

     C                   MOVEL     'MMLDIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LDIFLn            4 0
      * Add RFormula/PFormula                                                                 CDL033
     C                   ADD       16            LDIFLn                                       CDL033
      * Add Remarks                                                                           CMM105
     C                   ADD       35            LDIFLn                                       CMM105
      * Add Deal Status                                                                      BUG3986
     C                   ADD       34            LDIFLn                                      BUG3986
      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG7664
     C                   ADD       6             LDIFLn                                      BUG7664

     C                   MOVEL     'MMLDRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     LDRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     'MMLDEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LDEXLn            4 0

     C                   MOVEL     'SDCUCUPD'    FileName                                     CER043
     C                   EXSR      GETRCDLN                                                   CER043
     C                   Z-ADD     RecordLen     SDCULn                                       CER043
      *                                                                                       CER043
     C                   MOVEL     *BLANKS       FileName                                     CER049
     C                   MOVEL     'DLSTMPPD'    FileName                                     CER049
     C                   EXSR      GETRCDLN                                                   CER049
     C                   Z-ADD     RecordLen     LDSTQLn           4 0                        CER049
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** GL Accounts maintenance : Master, Debit interests, Credit interests
      **               Commissions & Overdraft charges and Other details
      *****************************************************************
     C     AMADFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLAMADPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMMDLn            4 0

     C                   MOVEL     'GLAMDIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMDILn            4 0

     C                   MOVEL     'GLAMCIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMCILn            4 0

     C                   MOVEL     'GLAMCOPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMCOLn            4 0

     C                   MOVEL     'GLAMODPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     AMODLn            4 0
                                                                                              CAP086
     C                   EVAL      AMADFLn = %LEN(AMADFldDS1)                                BUG5988
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'GLAMIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     AMIFLn            4 0                        CAP086
      *                                                                                       CER001
     C                   MOVEL     'GLAMRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     AMRXLn                                       CER001
     C                   MOVEL     'GLAMEXPD'    Filename                                   BUG10280
     C                   EXSR      GETRCDLN                                                 BUG10280
     C                   Z-ADD     Recordlen     AMEXLn            4 0                      BUG10280
      *                                                                                     MD054028
     C                   Z-ADD     17            AMCR50Ln          4 0                      MD054028
      *                                                                                     MD054028
     C                   EVAL      FileName = 'GLAMPP1PD'                                     CRE015
     C                   EXSR      GETRCDLN                                                   CRE015
     C                   EVAL      AMPPLn1 = RecordLen                                        CRE015
      ** Add Interest Scale Flag                                                            AR802610
     C                   ADD       1             AMPPLn1                                    AR802610
                                                                                            AR802610
     C                   EVAL      FileName = 'GLAMPP2PD'                                     CRE015
     C                   EXSR      GETRCDLN                                                   CRE015
     C                   EVAL      AMPPLn2 = RecordLen                                        CRE015
     C/COPY OFCPYSRCZ,CRE101_005                                                              CRE101

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * (Dealing) Extended Payment Instructions
      *****************************************************************
     C     SettleFmts    BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'SDESSPPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ESSPLn            4 0

     C                   MOVEL     'SDESSRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ESSRLn            4 0

     C                   MOVEL     'SDESSFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ESSFLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************                       CDL018
      * Further Settlement Instructions                                                       CDL018
      *****************************************************************                       CDL018
     C     FSettleFmts   BEGSR                                                                CDL018
                                                                                              CDL018
     C                   MOVEL     'SDFSSPPD'    FileName                                     CDL018
     C                   EXSR      GETRCDLN                                                   CDL018
     C                   Z-ADD     RecordLen     FSSPLn            4 0                        CDL018
                                                                                              CDL018
     C                   MOVEL     'SDFSSRPD'    FileName                                     CDL018
     C                   EXSR      GETRCDLN                                                   CDL018
     C                   Z-ADD     RecordLen     FSSRLn            4 0                        CDL018
                                                                                              CDL018
     C                   ENDSR                                                                CDL018
      *****************************************************************                       CDL018
      /SPACE 5                                                                                CDL018
      *****************************************************************
      ** FT Outgoing Payment : First, Second, Third and Fourth Details
      **                     : Fifth, Sixth, Seventh and Eighth
      *****************************************************************
     C     OPAYFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FTOPY1PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY1Ln            4 0

     C                   MOVEL     'FTOPY1APD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY2Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FTOPY2PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY3Ln            4 0

     C                   MOVEL     'FTOPY3PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY4Ln            4 0

     C                   MOVEL     'FTOPY4PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY5Ln            4 0

     C                   MOVEL     'FTOPY5PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY6Ln            4 0

     C                   MOVEL     'FTOPY6PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY7Ln            4 0

     C                   MOVEL     'FTOPY7PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPY9Ln            4 0
                                                                                              CSW209
     C**********         IF        CSW209 = 'Y'                                     CSW209 AR1002463
                                                                                              CSW209
     C                   MOVEL     'FTOPYAPD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     OPY10Ln                                      CSW209
                                                                                              CSW209
     C                   MOVEL     'FTOPYCPD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     OPY11Ln                                      CSW209
                                                                                              CSW209
     C**********         ENDIF                                                      CSW209 AR1002463
                                                                                              CSW209
      * Add MT110 generation flag, MT110 customer and cheque number                           CFT116
      *                                                                                       CFT116
     C                   ADD       13            OPY9Ln                                       CFT116
      **Add*Cheque*Print*Indicator*************************************                CFT118 CFT118
      **********                                                                       CFT118 CFT118
     C**********         ADD       1             OPY9Ln                                CFT118 CFT118
      * Add Cheque Print Indicator and Print Draft flag (1-char each)                         CFT118
      *                                                                                       CFT118
     C                   ADD       2             OPY9Ln                                       CFT118
      *                                                                                       CER030
     C                   MOVEL     'FTOPY7APD'   Filename                                     CER030
     C                   EXSR      GETRCDLN                                                   CER030
     C                   Z-ADD     RecordLen     OPY10LAn          4 0                        CER030
      *                                                                                       CER030
     C                   MOVEL     'FTOPY7BPD'   Filename                                     CER030
     C                   EXSR      GETRCDLN                                                   CER030
     C                   Z-ADD     RecordLen     OPY11LAn          4 0                        CER030
      *                                                                                       CER030
      ** Blanking out the name for the next name to be moved correctly                        CER030
      *                                                                                       CER030
     C                   MOVE      *BLANKS       Filename                                     CER030

     C                   MOVEL     'FTOPRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     OPRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     'FTOPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OPEXLn            4 0
      *                                                                                       CSD083
     C**********         ADD       181           WLCLn             4 0               CSD083 AR819540
     C                   ADD       184           WLCLn             4 0                      AR819540
                                                                                              CER049
     C                   MOVEL     'FTOPY9PD'    FileName                                     CER049
     C                   EXSR      GETRCDLN                                                   CER049
     C                   Z-ADD     RecordLen     OPY12Ln           4 0                        CER049

     C                   MOVEL     'FTOPY10APD'  FileName                                   MD050928
     C                   EXSR      GETRCDLN                                                 MD050928
     C                   Z-ADD     RecordLen     StopOPlen         4 0                      MD050928
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  IPAYFmts - Set up the screen definitions for Incoming        *
      *             payments                                          *
      *                                                               *
      *****************************************************************
     C     IPAYFmts      BEGSR

     C                   MOVEL     'FTIPY1PD  '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY1Ln            4 0

     C                   MOVEL     'FTIPY1APD '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY2Ln            4 0

     C                   MOVEL     'FTIPY2PD  '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY3Ln            4 0

     C                   MOVEL     'FTIPY3PD  '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY4Ln            4 0

     C                   MOVEL     'FTIPY4PD  '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY5Ln            4 0

     C                   MOVEL     'FTIPY4APD '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY6Ln            4 0

     C                   MOVEL     'FTIPY5PD  '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY7Ln            4 0

     C                   MOVEL     'FTIPY6PD  '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPY8Ln            4 0
      * Add Override flag, overriding officer and overriding officer password                 CFT115
     C                   ADD       21            IPY8Ln                                       CFT115
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     'FTIPY7PD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     IPY9ALn                                      CSW209
      *                                                                                       CSW209
     C                   MOVEL     'FTIPY8PD'    FileName                                     CSW209
     C                   EXSR      GETRCDLN                                                   CSW209
     C                   Z-ADD     RecordLen     IPY9BLn                                      CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CER030
     C                   MOVEL     'FTIPY6APD '  FileName                                     CER030
     C                   EXSR      GETRCDLN                                                   CER030
     C                   Z-ADD     RecordLen     IPY9Ln            4 0                        CER030
      *                                                                                       CER049
     C                   MOVEL     'FTIPY9PD  '  FileName                                     CER049
     C                   EXSR      GETRCDLN                                                   CER049
     C                   Z-ADD     RecordLen     IPY10Ln           4 0                        CER049

     C                   MOVEL     'FTIPRXPD  '  FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     IPRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     'FTIPEXPD  '  FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IPEXLn            4 0

     C                   MOVEL     'FTIPY10APD'  FileName                                   MD050928
     C                   EXSR      GETRCDLN                                                 MD050928
     C                   Z-ADD     RecordLen     StopIPlen         4 0                      MD050928
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SD Customers
      *****************************************************************
     C     CUSDFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'SDCUPRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDPRLn            4 0

     C                   MOVEL     'SDCUSEPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDSELn            4 0

     C                   MOVEL     'SDCUMRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDMRLn            4 0

     C                   MOVEL     'SDCUPBPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDPBLn            4 0

     C                   MOVEL     'SDCUBRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           SDB1Ln            4 0
     C     RecordLen     SUB       500           SDB2Ln            4 0

     C                   MOVEL     'SDCUMTPD'    FileName                                   BUG14485
     C                   EXSR      GETRCDLN                                                 BUG14485
     C                   Z-ADD     RecordLen     SDMTLn            4 0                      BUG14485
                                                                                            BUG14485
                                                                                              CSD079
     C                   MOVEL     'SDCUMIPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDMILn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUADPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     500           SDADLn            4 0                        CSD079
     C                   Z-ADD     500           SDADLnA           4 0                        CSD079
     C*****RecordLen     SUB       1000          SDADLnB           4 0               CSD079 MD050342
     C                   Z-ADD     500           SDADLnB           4 0                      MD050342
     C     RecordLen     SUB       1500          SDADLnC           4 0                      MD050342
                                                                                              CSD079
     C                   MOVEL     'SDACU3DPD'   FileName                                     CER059
     C                   EXSR      GETRCDLN                                                   CER059
     C                   Z-ADD     RecordLen     SDADLn3           4 0                        CER059
                                                                                              CER059
     C                   MOVEL     'SDACU4DPD'   FileName                                     CER059
     C                   EXSR      GETRCDLN                                                   CER059
     C                   Z-ADD     RecordLen     SDADLn4           4 0                        CER059
     C                   MOVEL     *BLANKS       FileName                                     CER059
                                                                                              CER059
     C                   MOVEL     'SDSFEEPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDSFLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCHECPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDCHLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUSFPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDCSLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUFXPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDFXLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUFDPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDFDLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDRWANPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDRWLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUFOPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDFOLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUPMPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDPMLn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDTICDPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDTILn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDEXLn            4 0

     C                   MOVEL     'SDCURXPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     SDCULn            4 0                        CSD079
                                                                                              CSD079
     C                   MOVEL     'SDCUSWPD'    FileName                                   BUG14992
     C                   EXSR      GETRCDLN                                                 BUG14992
     C                   Z-ADD     RecordLen     CUSWLn            4 0                      BUG14992
                                                                                            BUG14992
     C                   MOVEL     'SDCUAHDPD'   FileName                                     CER059
     C                   EXSR      GETRCDLN                                                   CER059
     C                   Z-ADD     500           CUA1Ln            4 0                        CER059
     C                   Z-ADD     500           CUA2Ln            4 0                        CER059
     C     RecordLen     SUB       1000          CUA3Ln            4 0                        CER059
                                                                                              CER059
     C                   MOVEL     'SDCCTXDPD'   FileName                                     CER059
     C                   EXSR      GETRCDLN                                                   CER059
     C                   Z-ADD     500           ACT1Ln            4 0                        CER059
     C                   Z-ADD     500           ACT2Ln            4 0                        CER059
     C                   Z-ADD     500           ACT3Ln            4 0                        CER059
     C                   Z-ADD     500           ACT4Ln            4 0                        CER059
     C                   Z-ADD     500           ACT5Ln            4 0                        CER059
     C     RecordLen     SUB       2500          ACT6Ln            4 0                        CER059
                                                                                              CER059
     C                   EVAL      CCTNLn1 = %LEN(CTNMFldDS1)                              AR1086546
     C                   MOVEL     *BLANKS       FileName                                  AR1086546
     C                   MOVEL     'SDCCTNPD'    FileName                                  AR1086546
     C                   EXSR      GETRCDLN                                                AR1086546
     C                   Z-ADD     RecordLen     CCTNLn            4 0                     AR1086546
     C                   EVAL      CCTNLn = CCTNLn - CCTNLn1                               AR1086546
                                                                                           AR1086546
     C                   EVAL      FileName = 'SDSW13PD'                                      CSW213
     C                   EXSR      GETRCDLN                                                   CSW213
     C                   EVAL      SW13Ln = RecordLen                                         CSW213
                                                                                              CSW213
     C                   EVAL      FileName = 'SDCUXCPD'                                      CGL132
     C                   EXSR      GETRCDLN                                                   CGL132
     C                   EVAL      CUXCLn = RecordLen                                         CGL132
                                                                                              CGL132
     C                   EVAL      FileName = 'SDFTCRPD'                                      CGL132
     C                   EXSR      GETRCDLN                                                   CGL132
     C                   EVAL      FTCRLn = RecordLen                                         CGL132
                                                                                              CGL132
     C                   EVAL      FileName = 'SDCRSSPD'                                      CGL157
     C                   EXSR      GETRCDLN                                                   CGL157
     C                   EVAL      CRSSLn = RecordLen                                         CGL157
                                                                                              CGL157
     C                   EVAL      FileName = 'SDCRDDPD'                                      CGL157
     C                   EXSR      GETRCDLN                                                   CGL157
     C                   Z-ADD     500           CRS01Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS02Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS03Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS04Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS05Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS06Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS07Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS08Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS09Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS10Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS11Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS12Ln           4 0                        CGL157
     C                   Z-ADD     39            CRS13Ln           4 0                        CGL157
     C                   Z-ADD     500           CRS14Ln           4 0                        CGL157
     C     RecordLen     SUB       6539          CRS15Ln           4 0                        CGL157
                                                                                              CGL157
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * GL Journal Entry Header Maintenance
      *****************************************************************
     C     BITHFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLBITHPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     BITHLn            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'GLJEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     GLIFLn            4 0                        CAP086

     C                   MOVEL     'GLBHEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     BHEXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * GL Journal Entry Item Maintenance
      *****************************************************************
     C     BITPFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLBITPPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     BITPLn            4 0
      * Add SGD Nostro indicator, Branch Name, Branch Reference                               CMM121
     C**********         ADD       71            BITPLn                                CMM121 246418
      * Also add Additional Information Indicator                                             246418
     C**********         ADD       72            BITPLn                              246418 BUG28091
     C                   ADD       73            BITPLn                                     BUG28091
                                                                                              246418
     C                   MOVEL     *BLANKS       FileName                                     246418
     C                   MOVEL     'GLBITPXPD'   FileName                                     246418
     C                   EXSR      GETRCDLN                                                   246418
     C                   Z-ADD     RecordLen     BIPXLn            4 0                        246418
                                                                                              246418

     C                   MOVEL     *BLANKS       FileName                                     246418
     C                   MOVEL     'GLBPRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     BPRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     *BLANKS       FileName                                     246418
     C                   MOVEL     'GLBPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     BPEXLn            4 0
     C/COPY OFCPYSRCZ,CGL135_045                                                             CGL135A

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SD Securities Customers
      *****************************************************************
     C     SECDFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'SDSECDPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDSCLn            4 0

     C                   MOVEL     'SDSEEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDSXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * PM Portfolio Definition
      *****************************************************************
     C     PFDMFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'PMPFDMPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     PMPMLn            4 0

     C                   MOVEL     'PMPFEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     PMEXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * LE loans
      *****************************************************************
     C     LOANFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEN1MFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LOANLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * MM Deal Amendments
      *****************************************************************
     C     DEAMFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'MMDEAMPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DEAMLn            4 0

     C                   MOVEL     'MMDAIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DAIFLn            4 0

     C                   MOVEL     'MMDAEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DAEXLn            4 0

     C                   MOVEL     'SDCUCUPD'    FileName                                     CER043
     C                   EXSR      GETRCDLN                                                   CER043
     C                   Z-ADD     RecordLen     SDCULn                                       CER043
      *                                                                                       CER043
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * LE Facilities Amendements
      *****************************************************************
     C     FAMDFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEFAMDPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FAMDLn            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LEFAM2PD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     FAM2Ln            4 0                        CLE106

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * GL Collateral Details
      *****************************************************************
     C     COLLFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLCOL1PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     COL1Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLCOL2PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     COL2Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLCOL3PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     COL3Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLCOL4PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     COL4Ln            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      * GL Collateral Allocations
      ****************************************************************
     C     COLAFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'GLSCLAPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     COLALn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *****************************************************************
      * LE Facilities Details
      *****************************************************************
     C     FCIPFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEFCPPPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FCI1Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEFCSPPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FCI2Ln            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
                                                                                              CLE106
     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LEFCXPPD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     FCI7Ln            4 0                        CLE106
                                                                                              CLE106
     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LEFCZPPD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     FCI9Ln            4 0                        CLE106
                                                                                            BUG10093
     C                   MOVEL     'LEFCNTPD'    FileName                                   BUG10093
     C                   EXSR      GETRCDLN                                                 BUG10093
     C                   Z-ADD     RecordLen     FCRNLn                                     BUG10093

     C                   MOVEL     'LEFCRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     FCRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     'LEFCEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FCEXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * LE Loan Details
      *****************************************************************
     C     CLIPFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LECLI1PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CLI1Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LECLI2PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CLI2Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LECLI3PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CLI3Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LECLI4PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CLI4Ln            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
                                                                                              CLE106
     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LECLI5PD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     CLI5Ln            4 0                        CLE106
      * Add Asset code and Health Code                                          CLE120
      *                                                                         CLE120
     C**********         ADD       8             CLI4Ln                                CLE120 CLE106
     C                   ADD       8             CLI5Ln                                       CLE106

     C                   MOVEL     'LECLRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     CLRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     'LECLEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CLEXLn            4 0
      *                                                                                     MD054028
     C                   Z-ADD     24            CLCR50Ln          4 0                      MD054028
                                                                                              CER049
     C                   MOVEL     *BLANKS       FileName                                     CER049
     C                   MOVEL     'LESTMP2PD'   FileName                                     CER049
     C                   EXSR      GETRCDLN                                                   CER049
     C                   Z-ADD     RecordLen     CLIQLn            4 0                        CER049
                                                                                              CER049
     C                   MOVEL     *BLANKS       FileName                                  AR1021983
     C                   MOVEL     'LECLI6PD'    FileName                                  AR1021983
     C                   EXSR      GETRCDLN                                                AR1021983
     C                   Z-ADD     RecordLen     CLI6Ln            4 0                     AR1021983

     C                   MOVEL     *BLANKS       FileName                                     CLE141
     C                   MOVEL     'LECLI7PD'    FileName                                     CLE141
     C                   EXSR      GETRCDLN                                                   CLE141
     C                   Z-ADD     RecordLen     CLI7Ln            4 0                        CLE141

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * LE Rollover Instructions
      *****************************************************************
     C     LERIFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LELERIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LERILn            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LELERI2PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LER2Ln            4 0

     C                   MOVEL     *BLANKS       FileName                                      BUG19
     C                   MOVEL     'LELERI3PD'   FileName                                      BUG19
     C                   EXSR      GETRCDLN                                                    BUG19
     C                   Z-ADD     RecordLen     LER3Ln            4 0                         BUG19
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
                                                                                               BUG19
     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LELEEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LEEXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * LE Repayment schedule
      *****************************************************************
     C     RPSCFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LERPSCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     RPSCLn            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086

     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LERPS2PD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     RPS2Ln            4 0                        CLE106
                                                                                              CLE106
     C                   MOVEL     'LERPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     RPEXLn            4 0


     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * LE Loam Amendments
      *****************************************************************
     C     LOAMFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LELOAMPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LOAMLn            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086

     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LELOA2PD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     LOA2Ln            4 0                        CLE106
                                                                                              CLE106
     C                   MOVEL     'LELOEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     LOEXLn            4 0


     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * LE Manual Repayment
      *****************************************************************
     C     MAPYFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEMAPYPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MAPYLn            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086

     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LEMAP2PD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     MAP2Ln            4 0                        CLE106
                                                                                              CLE106
     C**********         Z-ADD     1             UpSRLn            1 0            AR1080805 MD020445
     C                   Z-ADD     1             UpSRLn            1 0                      MD020733
     C                   Z-ADD     1             DDAuLn            1 0                        CLE164
      **********                                                                  AR1080805 MD020445
     C                   MOVEL     'LEMAEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     MAEXLn            4 0


     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SD Base rates
      *****************************************************************
     C     BSRTFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'SDBSRSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     BSRTLn            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'SDBSEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     BSEXLn            4 0

     C                   ENDSR
      *****************************************************************                       CSD093
      /SPACE 5                                                                                CSD093
      *****************************************************************                       CSD093
      * SD Document Management                                                                CSD093
      *****************************************************************                       CSD093
     C     DCMTFmts      BEGSR                                                                CSD093
                                                                                              CSD093
     C                   MOVEL     *BLANKS       FileName                                     CSD093
     C                   MOVEL     'SDDCMSPD'    FileName                                     CSD093
     C                   EXSR      GETRCDLN                                                   CSD093
     C                   Z-ADD     RecordLen     DCMTLn            4 0                        CSD093
                                                                                              CSD093
     C                   MOVEL     *BLANKS       FileName                                     CSD093
     C                   MOVEL     'SDDCMXPD'    FileName                                     CSD093
     C                   EXSR      GETRCDLN                                                   CSD093
     C                   Z-ADD     RecordLen     DCMXLn            4 0                        CSD093
                                                                                              CSD093
     C                   ENDSR                                                                CSD093
      *****************************************************************                       CSD092
      /SPACE 5                                                                                CSD092
      *****************************************************************                       CSD092
      * SD Account Review                                             *                       CSD092
      *****************************************************************                       CSD092
     C     ACRFFmts      BEGSR                                                                CSD092
                                                                                              CSD092
     C                   MOVEL     *BLANKS       FileName                                     CSD092
     C                   MOVEL     'SDACRFPD'    FileName                                     CSD092
     C                   EXSR      GETRCDLN                                                   CSD092
     C                   Z-ADD     RecordLen     ACRFLn                                       CSD092
                                                                                              CSD092
     C                   MOVEL     'SDACEXPD'    FileName                                     CSD092
     C                   EXSR      GETRCDLN                                                   CSD092
     C                   Z-ADD     RecordLen     ACEXLn                                       CSD092
                                                                                              CSD092
     C                   ENDSR                                                                CSD092
      *****************************************************************
      /SPACE 5
      ****************************************************************                       BUG1100
      * LE Fees Master file                                                                  BUG1100
      ****************************************************************                       BUG1100
     C     FEEMFmts      BEGSR                                                               BUG1100
                                                                                             BUG1100
     C                   MOVEL     *BLANKS       FileName                                    BUG1100
                                                                                             BUG1100
     C                   MOVEL     'LEFEEMPD'    FileName                                    BUG1100
     C                   EXSR      GETRCDLN                                                  BUG1100
     C                   Z-ADD     RecordLen     FEEMLn            4 0                       BUG1100
                                                                                             BUG1100
     C                   MOVEL     'LEFEEM2PD'   FileName                                    BUG1100
     C                   EXSR      GETRCDLN                                                  BUG1100
     C                   Z-ADD     RecordLen     FEEM2Ln           4 0                       BUG1100
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CER049
     C                   MOVEL     'LESTMPPD'    FileName                                     CER049
     C                   EXSR      GETRCDLN                                                   CER049
     C                   Z-ADD     RecordLen     LESTMLn           4 0                        CER049
                                                                                              CER049
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086
                                                                                             BUG1100
     C                   MOVEL     *BLANKS       FileName                                    BUG1100
     C                   MOVEL     'LEFEEXPD'    FileName                                    BUG1100
     C                   EXSR      GETRCDLN                                                  BUG1100
     C                   Z-ADD     RecordLen     FEEXLn            4 0                       BUG1100
                                                                                             BUG1100
     C                   ENDSR                                                               BUG1100
      ****************************************************************                       BUG1100
      /SPACE 5                                                                               BUG1100
      ****************************************************************
      * LE Fee Adjustments
      ****************************************************************
     C     FEADFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEFEADPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FEADLn            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086

     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'LEFEA2PD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     FEA2Ln            4 0                        CLE106
                                                                                              CLE106
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * LE Fee settlement
      ****************************************************************
     C     FESTFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEFESTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FESTLn            4 0
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'LELEIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     LEIFLn            4 0                        CAP086

     C                   MOVEL     *Blanks       FileName                                     CLE106
     C                   MOVEL     'LEFES2PD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     FES2Ln            4 0                        CLE106
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * LE Funding Partcipant
      ****************************************************************
     C     FPRTFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEFPRTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FPRTLn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * LE Assignments
      ****************************************************************
     C     ASGNFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'LEASGNPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ASGNLn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * IR Forward Rate Agreements
      ****************************************************************
     C     FRAFmts       BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'IRFRAPD'     FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FRALn             4 0
      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG6512
     C                   ADD       6             FRALn                                       BUG6512

      ** Fwd Rate Agreement Interface Data Format Definition Layout                         BUG18701
     C                   MOVEL     'IRFRIFPD'    FileName                                   BUG18701
     C                   EXSR      GETRCDLN                                                 BUG18701
     C                   Z-ADD     RecordLen     IRFRLn            4 0                      BUG18701
                                                                                            BUG18701
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *****************************************************************
      *  IR Single Currency IRS                                       *
      *****************************************************************
     C     SIRSFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'IRSIRSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SIRSLn            4 0
     C**********         MOVEL     'IRDTSCPD'    FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     DTORLn            4 0                       BUG4646
     C**********         Z-ADD     RecordLen     DTOPLn            4 0                       BUG4646
     C**********         Z-ADD     RecordLen     DTTRLn            4 0                       BUG4646
     C**********         Z-ADD     RecordLen     DTTPLn            4 0                       BUG4646
     C**********         MOVEL     'IRSSEXPD'    FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     IRSSLn            4 0                       BUG4646
                                                                                             BUG6671
      ** IR Single Currency Interface Data Format Definition Layout                          BUG6671
                                                                                             BUG6671
     C                   MOVEL     'IRRSIFPD'    FileName                                    BUG6671
     C                   EXSR      GETRCDLN                                                  BUG6671
     C                   Z-ADD     RecordLen     IRRSLn            4 0                       BUG6671
                                                                                             BUG6671
      ** IR IRS Single Ccy Extra Data file (50 byte narrative text plus any                  BUG6671
      ** custom info)                                                                        BUG6671
                                                                                             BUG6671
     C                   MOVEL     'IRSSEXPD'    FileName                                    BUG6671
     C                   EXSR      GETRCDLN                                                  BUG6671
     C                   Z-ADD     RecordLen     IRSSLn            4 0                       BUG6671

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      *  IR Cross Currency IRS
      ****************************************************************
     C     CIRSFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'IRCIRSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CIRSLn            4 0

      ** IR Cross Currency Interface Data Format Definition Layout

     C                   MOVEL     'IRRXIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRRXLn            4 0

      ** IR IRS Cross Ccy Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'IRCSEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     IRCSLn            4 0
     C                   Z-ADD     0             IRCS2Ln           4 0                      MD029663
     C                   Z-ADD     0             IRCS3Ln           4 0                      MD029663

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * SE Securities Detail
      ****************************************************************
     C     SECSFmts      BEGSR

     C                   MOVEL     'SESEC1PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC1Ln            4 0
      *
     C                   MOVEL     'SESEC2PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC2Ln            4 0
      *
     C                   MOVEL     'SESEC3PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC3Ln            4 0
      *
     C                   MOVEL     'SESEC4PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC4Ln            4 0
     C                   MOVEL     'SESEC5PD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEC5Ln            4 0
      *                                                                                       CSE071
     C                   MOVEL     'SESEC6PD  '  Filename                                     CSE071
     C                   EXSR      GETRCDLN                                                   CSE071
     C                   Z-ADD     Recordlen     SEC6Ln            4 0                        CSE071
                                                                                              CER001
     C                   MOVEL     'SESERXPD  '  Filename                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     Recordlen     SERXLn                                       CER001
      *
      ** Get record length of Extra Data Layout file for SE
      ** Securities - API.
      *
     C                   MOVEL     'SESEEXPD  '  Filename
     C                   EXSR      GETRCDLN
     C                   Z-ADD     Recordlen     SEEXLn            4 0
                                                                                             BUG5988
     C                   EVAL      SECSFLn = %LEN(SECSFldDS1)                                BUG5988


     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * SE Securities Trade
      ****************************************************************
     C     TRADFmts      BEGSR

      ** SE Trade: Primary, Secondary, Exchange Rates, Settlement Details,
      **           Charges & Commissions, SWIFT Details

     C                   MOVEL     'SETRPRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRPRLn            4 0
     C                   MOVEL     'SETRSEPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRSELn            4 0
     C                   MOVEL     'SETRPVPD'    FileName                                   BUG11194
     C                   EXSR      GETRCDLN                                                 BUG11194
     C                   Z-ADD     RecordLen     TRPVLn            4 0                      BUG11194
     C                   MOVEL     'SETREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TREXLn            4 0
     C                   MOVEL     'SETRSTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRSTLn            4 0
     C                   MOVEL     'SETRCCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRCCLn            4 0
     C                   MOVEL     'SETRSWPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRSWLn            4 0
     C                   MOVEL     'SETESDPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRX2Ln            4 0
     C                   EVAL      TRX2Ln = TRX2Ln * 2

      *  Hedge Accounting file

     C                   MOVEL     'SETRTHPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     TRHALn            4 0

      ** SE Trades Interface Data  Format Definition Layout
      ** (50 byte narrative text plus any custom info)

     C                   MOVEL     'SETRIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SETILn            4 0

     C                   MOVEL     'SETDRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     TDRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     'SETRAXPD'    FileName                                    BUG9584
     C                   EXSR      GETRCDLN                                                  BUG9584
     C                   Z-ADD     RecordLen     TDAXLn                                      BUG9584
                                                                                             BUG9584
      ** SE Trades Extra Data file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'SETDEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SETRLn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * SE Depot Movements
      ****************************************************************
     C     DPMVFmts      BEGSR


     C                   MOVEL     'SEDMIDPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DMWILn            4 0
      *  Depot Movement SWIFT Messages Infomation
     C                   MOVEL     'SEDMESPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DMesLn            4 0

     C                   MOVEL     'SEDMAXPD'    FileName                                    BUG9089
     C                   EXSR      GETRCDLN                                                  BUG9089
     C                   Z-ADD     RecordLen     DMAXLn            4 0                       BUG9089
     C                   MOVEL     'SEDMRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     DMRXLn                                       CER001
                                                                                              CER001
      ** SE Depot Movements file (50 byte narrative text plus any
      ** custom info)

     C                   MOVEL     'SEDMEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     DMEXLn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *****************************************************************
      * MM Negotiable Assets Purchased
      *****************************************************************
     C     NASPFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'MMNASPPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     NASPLn            4 0
      *                                                                                       BUG629
      ** Add field size for Deal Status (DDSTS) for TRANS1 mapping.                           BUG629
      ** (note: DDSTS was added in MMNASPVU to be passed to Java)                             BUG629
     C                   ADD       24            NASPLn                                       BUG629
      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG6512
     C                   ADD       6             NASPLn                                      BUG6512
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'MMNAIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     NAIFLn            4 0                        CAP086

     C                   MOVEL     'MMNPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     NPEXLn            4 0
                                                                                              CER001
     C                   MOVEL     'MMNPRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     NPRXLn                                       CER001

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * MM Negotiable Assets Sold
      *****************************************************************
     C     NASSFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'MMNASSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     NASSLn            4 0
      * Add TRAM fields, Counterpary and Broker Stati and visibility flags                   BUG6512
     C                   ADD       6             NASSLn                                      BUG6512
                                                                                              CAP086
     C                   MOVEL     *BLANKS       FileName                                     CAP086
     C                   MOVEL     'MMNAIFPD'    FileName                                     CAP086
     C                   EXSR      GETRCDLN                                                   CAP086
     C                   Z-ADD     RecordLen     NAIFLn            4 0                        CAP086

     C                   MOVEL     'MMNSEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     NSEXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * MM Rollover Details Maintenance
      *****************************************************************
     C     RODLFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'MMLDNIPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     RODLLn            4 0

      * Add DDRAMN (14A) and DDRACT (1A) at the end of deal details.
     C                   ADD       15            RODLLn

     C                   MOVEL     'MMLDIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ROIFLn            4 0

     C                   MOVEL     'MMLDEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     ROEXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * IR Caps/Collars/Floors Maintenance
      *****************************************************************
     C     CACFFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'IRCACFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CACFLn            4 0

     C                   MOVEL     'IRCACF2PD'   FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CAC2Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'IRRPIFPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CFIFLn            4 0

     C                   MOVEL     'IRCPEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CFEXLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * FX CLS Pay-in Schedule (Header)                               *
      *****************************************************************
     C     CLSPFmts      BEGSR

     C                   EVAL      FileName = 'FXCLSPHPD'
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CLSPLn            4 0
      * Add PPayRcv(1) to end of details.                                                     BUG683
     C                   ADD       1             CLSPLn                                       BUG683
                                                                                             BUG9829
     C                   MOVEL     *BLANKS       FileName                                    BUG9829
     C                   MOVEL     'FXCLIFPD'    FileName                                    BUG9829
     C                   EXSR      GETRCDLN                                                  BUG9829
     C                   Z-ADD     RecordLen     CLIFLn            4 0                       BUG9829

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * FX CLS Pay-in Schedule (Detail)                               *
      *****************************************************************
     C     CLS2Fmts      BEGSR

     C                   EVAL      FileName = 'FXCLSPDPD'
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CLS2Ln            4 0
      * Add PPayRcv(1) to end of details.                                                     BUG683
     C                   ADD       1             CLS2Ln                                       BUG683
                                                                                              CAP086
     C**********         MOVEL     *BLANKS       FileName                             CAP086 BUG9829
     C**********         MOVEL     'FXCLIFPD'    FileName                             CAP086 BUG9829
     C**********         EXSR      GETRCDLN                                           CAP086 BUG9829
     C**********         Z-ADD     RecordLen     CLIFLn            4 0                CAP086 BUG9829

     C                   ENDSR
      *****************************************************************
      * Internal Contracts                                            *
      *****************************************************************
     C     INTCFmts      BEGSR

     C                   EVAL      FileName = 'ABINTCPD'
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     INTCLn            4 0

     C/COPY WNCPYSRC,APH00034
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Internal Funding Deals                                        *
      *****************************************************************
     C     FUNDFmts      BEGSR

     C                   EVAL      FileName = 'ABFUNDPD'
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FUNDLn            4 0

     C                   EVAL      FileName = 'ABFUEXPD'                                      CAP191
     C                   EXSR      GETRCDLN                                                   CAP191
     C                   Z-ADD     RecordLen     FUEXLn            4 0                        CAP191
                                                                                              CAP191
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * FF Over The Counter OTCC
      *****************************************************************
     C     OTCCFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FFOTCCPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCCLn            4 0

     C                   MOVEL     'FFCSETPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCCLnS           4 0

     C                   MOVEL     'FFOTRXPD'    FileName                                     CER001
     C                   EXSR      GETRCDLN                                                   CER001
     C                   Z-ADD     RecordLen     OTRXLn                                       CER001
                                                                                              CER001
     C                   MOVEL     'FFOTEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCCLnX           4 0

     C                   ENDSR
      *****************************************************************
      * FF Non Currency Over The Counter OTCO
      *****************************************************************
     C     OTCOFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FFOTCOPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCOLn            4 0

     C                   MOVEL     'FFCSETPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCOLnS           4 0

     C                   MOVEL     'FFOTEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     OTCOLnX           4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * FF Exchange Traded Transaction EXTR
      *****************************************************************
     C     EXTRFmts      BEGSR

      * The main file...
     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FFEXTRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     EXTRLn            4 0

      * ... Customer Settlement details...
     C                   MOVEL     'FFCSETPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     EXTRLnCS          4 0

      * ... Broker Settlement details...
     C                   MOVEL     'FFBSETPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     EXTRLnBS          4 0
                                                                                              CAP191
      * Exchange-traded reg extra data layout                                                 CAP191
     C                   MOVEL     'FFETRXPD'    FileName                                     CAP191
     C                   EXSR      GETRCDLN                                                   CAP191
     C                   Z-ADD     RecordLen     EXTRLnR           4 0                        CAP191

      * ... and Extra details.
     C                   MOVEL     'FFETEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     EXTRLnX           4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SD Spot Rates                                                 *
      *****************************************************************
     C     SPTRFmts      BEGSR

     C                   EVAL      FileName = 'SDSPTRPD'
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SPTRLn            4 0

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      *  SCHEDFmts - IR Schedules Formats                            *
      ****************************************************************
     C*****SCHEDFmts*****BEGSR                                                               BUG4646
      **********                                                                             BUG4646
      ***Cash*Flow*Schedules*******************************************                      BUG4646
      **********                                                                             BUG4646
     C**********         CLEAR                   FileName                                    BUG4646
     C**********         MOVEL     'IRCFSC1PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WCFSC1OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WCFSC1TLn                                   BUG4646
     C**********         MOVEL     'IRCFSC2PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WCFSC2OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WCFSC2TLn                                   BUG4646
     C**********         MOVEL     'IRCFSC3PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WCFSC3OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WCFSC3TLn                                   BUG4646
     C**********         MOVEL     'IRCFSC4PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WCFSC4OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WCFSC4TLn                                   BUG4646
      **********                                                                             BUG4646
      ***Principal*Change*Schedules************************************                      BUG4646
      **********                                                                             BUG4646
     C**********         MOVEL     'IRPCSC1PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WPCSC1OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WPCSC1TLn                                   BUG4646
     C**********         MOVEL     'IRPCSC2PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WPCSC2OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WPCSC2TLn                                   BUG4646
     C**********         MOVEL     'IRPCSC3PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WPCSC3OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WPCSC3TLn                                   BUG4646
     C**********         MOVEL     'IRPCSC4PD'   FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WPCSC4OLn                                   BUG4646
     C**********         Z-ADD     RecordLen     WPCSC4TLn                                   BUG4646
      **********                                                                             BUG4646
      ***Trailer*Record************************************************                      BUG4646
      **********                                                                             BUG4646
     C**********         CLEAR                   FileName                                    BUG4646
     C**********         MOVEL     'IRTRSCPD'    FileName                                    BUG4646
     C**********         EXSR      GETRCDLN                                                  BUG4646
     C**********         Z-ADD     RecordLen     WTRSCLn                                     BUG4646
      **********                                                                             BUG4646
     C**********         ENDSR                                                               BUG4646
      ****************************************************************
      /SPACE 5
      *****************************************************************
      * MM Interest Rates                                             *
      *****************************************************************
     C     INTRFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FDINTRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           INT1Ln            4 0
     C     RecordLen     SUB       500           INT2Ln            4 0

     C                   MOVEL     'FDIREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     INEXLn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *****************************************************************
      * SE Security Diary Events                                      *
      *****************************************************************
     C     SEDEFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'SESEDEPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SEDELn            4 0

     C                   MOVEL     'SESDEXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     SDEXLn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *****************************************************************
      * SE Prices Input                                               *
      *****************************************************************
     C     PRCSFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'SEPRCSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     PRCSLn            4 0

     C                   MOVEL     'SEPREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     PRCXLn            4 0

     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *****************************************************************
      * FD Forward Rates                                              *
      *****************************************************************
     C     FWRTFmts      BEGSR

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FDFWRTPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     500           FWR1Ln            4 0
     C     RecordLen     SUB       500           FWR2Ln            4 0

     C                   MOVEL     *BLANKS       FileName
     C                   MOVEL     'FDFREXPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FWEXLn            4 0

     C                   ENDSR
      *****************************************************************                       CLE106
      * Settlement Details                                                                    CLE106
      *****************************************************************                       CLE106
     C     SETLFmts      BEGSR                                                                CLE106
                                                                                              CLE106
     C                   MOVEL     *BLANKS       FileName                                     CLE106
     C                   MOVEL     'SDESSXPD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     SET1Ln            4 0                        CLE106
                                                                                              CLE106
     C                   MOVEL     'SDESSRPD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     SET2Ln            4 0                        CLE106
                                                                                              CLE106
     C                   MOVEL     'SDESSPPD'    FileName                                     CLE106
     C                   EXSR      GETRCDLN                                                   CLE106
     C                   Z-ADD     RecordLen     SET3Ln            4 0                        CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************
      /SPACE 5                                                                                CGP010
      *****************************************************************                       CGP010
      * BSPL Requests                                                 *                       CGP010
      *****************************************************************                       CGP010
     C     BSRQFmts      BEGSR                                                                CGP010
                                                                                              CGP010
     C                   MOVEL     *BLANKS       FileName                                     CGP010
     C                   MOVEL     'GOBSRQPD'    FileName                                     CGP010
     C                   EXSR      GETRCDLN                                                   CGP010
     C                   Z-ADD     RecordLen     BSRQLn            4 0                        CGP010
                                                                                              CGP010
     C                   MOVEL     'GOBSRXPD'    FileName                                     CGP010
     C                   EXSR      GETRCDLN                                                   CGP010
     C                   Z-ADD     RecordLen     BSRXLn            4 0                        CGP010
                                                                                              CGP010
     C                   ENDSR                                                                CGP010
      ****************************************************************                        CGP010
      /SPACE 5                                                                                CAS011
      *****************************************************************                       CAS011
      * DL Dealing Fees                                               *                       CAS011
      *****************************************************************                       CAS011
     C     DLFEFmts      BEGSR                                                                CAS011
                                                                                              CAS011
     C                   MOVEL     *BLANKS       FileName                                     CAS011
     C                   MOVEL     'DLDLFEPD'    FileName                                     CAS011
     C                   EXSR      GETRCDLN                                                   CAS011
     C                   Z-ADD     RecordLen     DLFELn            4 0                        CAS011
                                                                                              CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CRE026
      *****************************************************************                       CRE026
      * SD Collateral Type                                                                    CRE026
      *****************************************************************                       CRE026
     C     COTYFmts      BEGSR                                                                CRE026
                                                                                              CRE026
     C                   MOVEL     *BLANKS       FileName                                     CRE026
     C                   MOVEL     'SDCOTYPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     COTYLn                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDCOEXPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     SDCXLn                                       CRE026
                                                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CRE026
      *****************************************************************                       CRE026
      * SD Country                                                                            CRE026
      *****************************************************************                       CRE026
     C     CNTYFmts      BEGSR                                                                CRE026
                                                                                              CRE026
     C                   MOVEL     *BLANKS       FileName                                     CRE026
     C                   MOVEL     'SDCNTYPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     CNTYLn                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDCNT3PD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     CTX1Ln                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDCNT2PD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     CTX2Ln                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDCTEXPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     SDCXLn                                       CRE026
                                                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CRE026
      *****************************************************************                       CRE026
      * SD Alternative Name and Addresses                                                     CRE026
      *****************************************************************                       CRE026
     C     ALNAFmts      BEGSR                                                                CRE026
                                                                                              CRE026
     C                   MOVEL     *BLANKS       FileName                                     CRE026
     C                   MOVEL     'SDALNAPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     ALNALn                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDALEXPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     SDAXLn                                       CRE026
                                                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CRE026
      *****************************************************************                       CRE026
      * SF User Definitions and Menu Items                                                    CRE026
      *****************************************************************                       CRE026
     C     AMUSFmts      BEGSR                                                                CRE026
                                                                                              CRE026
     C                   MOVEL     *BLANKS       FileName                                     CRE026
     C                   MOVEL     'SFAMUSPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     AMUSLn                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SFBBRCPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     500           BBR1Ln                                       CRE026
     C                   Z-ADD     500           BBR2Ln                                       CRE026
     C                   Z-ADD     500           BBR3Ln                                       CRE026
     C                   Z-ADD     500           BBR4Ln                                       CRE026
     C                   Z-ADD     500           BBR5Ln                                       CRE026
     C                   Z-ADD     500           BBR6Ln                                       CRE026
     C                   Z-ADD     500           BBR7Ln                                       CRE026
     C     RecordLen     SUB       3500          BBR8Ln                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SFOBRCPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     500           OBR1Ln                                       CRE026
     C                   Z-ADD     500           OBR2Ln                                       CRE026
     C                   Z-ADD     500           OBR3Ln                                       CRE026
     C                   Z-ADD     500           OBR4Ln                                       CRE026
     C                   Z-ADD     500           OBR5Ln                                       CRE026
     C                   Z-ADD     500           OBR6Ln                                       CRE026
     C                   Z-ADD     500           OBR7Ln                                       CRE026
     C     RecordLen     SUB       3500          OBR8Ln                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SFCOMPPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     COMPLn                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SFUSEXPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     SFUXLn                                       CRE026
                                                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CRE026
      *****************************************************************                       CRE026
      * SD Nostro Codes                                                                       CRE026
      *****************************************************************                       CRE026
     C     NOSRFmts      BEGSR                                                                CRE026
                                                                                              CRE026
     C                   MOVEL     *BLANKS       FileName                                     CRE026
     C                   MOVEL     'SDNOSRPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     NOSRLn                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDNVEXPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     SDNXLn                                       CRE026
                                                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CRE026
      *****************************************************************                       CRE026
      * SD Yield Curve                                                                        CRE026
      *****************************************************************                       CRE026
     C     YLCUFmts      BEGSR                                                                CRE026
                                                                                              CRE026
     C                   MOVEL     *BLANKS       FileName                                     CRE026
     C                   MOVEL     'SDYLCUPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     YLCULn                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDYCEXPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     SDYXLn                                       CRE026
                                                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CRE026
      /SPACE 5                                                                                CRE026
      *****************************************************************                       CRE026
      * SD Yield Rates                                                                        CRE026
      *****************************************************************                       CRE026
     C     YRATFmts      BEGSR                                                                CRE026
                                                                                              CRE026
     C                   MOVEL     *BLANKS       FileName                                     CRE026
     C                   MOVEL     'SDYRATPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     500           YRA1Ln                                       CRE026
     C                   Z-ADD     500           YRA2Ln                                       CRE026
     C                   Z-ADD     500           YRA3Ln                                       CRE026
     C     RecordLen     SUB       1500          YRA4Ln                                       CRE026
                                                                                              CRE026
     C                   MOVEL     'SDYREXPD'    FileName                                     CRE026
     C                   EXSR      GETRCDLN                                                   CRE026
     C                   Z-ADD     RecordLen     SDYELn                                       CRE026
                                                                                              CRE026
     C                   ENDSR                                                                CRE026
      *****************************************************************                       CSD079
      /SPACE 5                                                                                CSD079
      *****************************************************************                       CSD079
      * SD Risk Weighted Assets                                                               CSD079
      *****************************************************************                       CSD079
     C     RWANFmts      BEGSR                                                                CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANKS       FileName                                     CSD079
     C                   MOVEL     'SDRWANPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     RecordLen     RWANLn            4 0                        CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /SPACE 5                                                                                CSD079
      *****************************************************************                       CSD079
      * SD Customer Withholding Tax                                                           CSD079
      *****************************************************************                       CSD079
     C     CUWTFmts      BEGSR                                                                CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANKS       FileName                                     CSD079
     C                   MOVEL     'SDCUWTPD'    FileName                                     CSD079
     C                   EXSR      GETRCDLN                                                   CSD079
     C                   Z-ADD     500           CUW1Ln            4 0                        CSD079
     C     RecordLen     SUB       500           CUW2Ln            4 0                        CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /SPACE 5                                                                             AR1086546
      *****************************************************************                    AR1086546
      * SD Currency/Time of Netting                                                        AR1086546
      *****************************************************************                    AR1086546
     C     CCTNFmts      BEGSR                                                             AR1086546
                                                                                           AR1086546
     C                   MOVEL     *BLANKS       FileName                                  AR1086546
     C                   MOVEL     'SDCCTNPD'    FileName                                  AR1086546
     C                   EXSR      GETRCDLN                                                AR1086546
     C                   Z-ADD     RecordLen     CCTNLn            4 0                     AR1086546
                                                                                           AR1086546
     C                   ENDSR                                                             AR1086546
      *****************************************************************                    AR1086546
      /SPACE 5                                                                                CLE134
      *****************************************************************                       CLE134
      * PDCL layout                                                                           CLE134
      *****************************************************************                       CLE134
     C     CPDCFmts      BEGSR                                                                CLE134
      *                                                                                       CLE134
     C                   MOVEL     *BLANKS       FileName                                     CLE134
     C                   MOVEL     'LEPDCLPD'    FileName                                     CLE134
     C                   EXSR      GETRCDLN                                                   CLE134
     C                   Z-ADD     RecordLen     CPD1Ln                                       CLE134
      *                                                                                       CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
      * Adjustment to Accrued Interest                                                        CAP210
      *****************************************************************                       CAP210
     C     DLAAFmts      BEGSR                                                                CAP210
                                                                                              CAP210
     C                   MOVEL     *BLANKS       FileName                                     CAP210
     C                   MOVEL     'DLDLAAPD'    FileName                                     CAP210
     C                   EXSR      GETRCDLN                                                   CAP210
     C                   Z-ADD     RecordLen     DLAALn                                       CAP210
                                                                                              CAP210
     C                   ENDSR                                                                CAP210
      *****************************************************************                       CAP210
     C***/COPY*OFCPYSRCZ,CAP090_004                                                    CAP090 CLE164
     C/COPY OFCPYSRCZ,CGL158_004                                                              CGL158
      /SPACE 5                                                                                CAP212
      *****************************************************************                       CAP212
      * FT Nostrp Transfers                                                                   CAP212
      *****************************************************************                       CAP212
     C     FTNTFmts      BEGSR                                                                CAP212
                                                                                              CAP212
     C                   MOVEL     *BLANKS       FileName                                     CAP212
     C                   MOVEL     'FTFTNTPD'    FileName                                     CAP212
     C                   EXSR      GETRCDLN                                                   CAP212
     C                   Z-ADD     RecordLen     FTNTLn            4 0                        CAP212
                                                                                              CAP212
     C                   MOVEL     *BLANKS       FileName                                     CAP212
     C                   MOVEL     'FTFTEXPD'    FileName                                     CAP212
     C                   EXSR      GETRCDLN                                                   CAP212
     C                   Z-ADD     RecordLen     FTEXLn            4 0                        CAP212
                                                                                              CAP212
     C                   ENDSR                                                                CAP212
      *****************************************************************                       CAP212
     C     SBJBFmts      BEGSR                                                                CLE164
                                                                                              CLE164
     C                   MOVEL     *BLANKS       FileName                                     CLE164
     C                   MOVEL     'APSBJBTD'    FileName                                     CLE164
     C                   EXSR      GETRCDLN                                                   CLE164
     C                   Z-ADD     RecordLen     SBJBLen                                      CLE164
                                                                                              CLE164
     C                   MOVEL     *BLANKS       FileName                                     CLE164
     C                   MOVEL     'APSBEXTD'    FileName                                     CLE164
     C                   EXSR      GETRCDLN                                                   CLE164
     C                   Z-ADD     RecordLen     SBEXLen                                      CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      /SPACE 5                                                                                BG0505
      ****************************************************************                        BG0505
      * Block question marks in input buffer                                                  BG0505
      ****************************************************************                        BG0505
     C     BLOCK_QM      BEGSR                                                                BG0505
                                                                                              BG0505
     C     APQMBXK       KLIST                                                                BG0505
     C                   KFLD                    TransType                                    BG0505
     C                   KFLD                    #I                                           BG0505
     C     APQMBXKP      KLIST                                                                BG0505
     C                   KFLD                    TransType                                    BG0505
                                                                                              BG0505
     C                   MOVEL     'N'           QM_Blocked        1                          BG0505
     C                   MOVEL     'N'           QM_Allowed        1                          BG0505
     C                   Z-ADD     1             #I                5 0                        BG0505
     C                   BITOFF    '01234567'    CTLC              1                          BG0505
                                                                                              BG0505
      * Remove question marks - if required                                                   BG0505
                                                                                              BG0505
     C     *IN99         DOUEQ     *OFF                                                       BG0505
     C     '?'           SCAN      BufferTotal   #I                       99                  BG0505
     C     *IN99         IFEQ      *ON                                                        BG0505
     C     APQMBXK       SETLL     APQMBXD0                                                   BG0505
     C     APQMBXKP      READE     APQMBXD0                               98                  BG0505
     C     *IN98         IFEQ      *OFF                                                       BG0505
     C     #I            ANDGE     QXBSPS                                                     BG0505
     C     #I            ANDLE     QXBEPS                                                     BG0505
     C                   EVAL      %subst(BufferTotal:#I:1) = CTLC                            BG0505
     C                   EVAL      QM_Allowed = 'Y'                                           BG0505
     C                   ELSE                                                                 BG0505
     C                   EVAL      %subst(BufferTotal:#I:1) = ' '                             BG0505
     C                   EVAL      QM_Blocked = 'Y'                                           BG0505
     C                   ENDIF                                                                BG0505
     C                   ENDIF                                                                BG0505
     C                   ENDDO                                                                BG0505
                                                                                              BG0505
      * Reinstate '?' (NOTE: SCAN BufferTotal:X NOT USED ABOVE AS IT IS EXTREMELY SLOW)       BG0505
                                                                                              BG0505
     C     QM_Allowed    IFEQ      'Y'                                                        BG0505
     C     *IN99         DOUEQ     *OFF                                                       BG0505
     C     CTLC          SCAN      BufferTotal   #I                       99                  BG0505
     C     *IN99         IFEQ      *ON                                                        BG0505
     C                   EVAL      %subst(BufferTotal:#I:1) = '?'                             BG0505
     C                   ENDIF                                                                BG0505
     C                   ENDDO                                                                BG0505
     C                   ENDIF                                                                BG0505
                                                                                              BG0505
     C                   ENDSR                                                                BG0505
      *****************************************************************                       BG0505
      /SPACE 5                                                                                BG0505
      ****************************************************************                        BG0505
      * Add question mark error to warning messages                                           BG0505
      ****************************************************************                        BG0505
     C     ADD_QM_ERROR  BEGSR                                                                BG0505
                                                                                              BG0505
     C                   Z-ADD     1             #I                                           BG0505
     C     *BLANK        LOOKUP    WFldNamArr(#I)                         99                  BG0505
     C                   MOVEL     'NOFLD '      WFldNamArr(#I)                               BG0505
     C                   MOVEL     'APM0300'     WMsgIDArr(#I)                                BG0505
                                                                                              BG0505
     C                   ENDSR                                                                BG0505
      *****************************************************************                     MD022093
      /SPACE 5                                                                              MD022093
      *****************************************************************                     MD022093
      * Extract buffer total                                                                MD022093
      *****************************************************************                     MD022093
     C     ExtCUSDBufTot BEGSR                                                              MD022093
                                                                                            MD022093
     C                   EVAL      BFTotLn -= Bfp                                           MD022093
                                                                                            MD022093
     C                   ENDSR                                                              MD022093
      *****************************************************************                     MD022093
      /SPACE 5                                                                              MD022093
      *****************************************************************                     MD022093
      * Extract buffer ex 2                                                                 MD022093
      *****************************************************************                     MD022093
     C     ExtCUSDBufEx2 BEGSR                                                              MD022093
      *                                                                                     MD022093
      ** The FillerBufEx2 must be used by any upcoming CORE or CAR                          MD022093
      ** enhancements. If in case BufferEx2 becomes FULL (i.e. the new                      MD022093
      ** file definition will not exactly fit to the remaining                              MD022093
      ** FillerBufEx2), this new CORE or CAR data must make use of the                      MD022093
      ** next BufferEx3 instead. Therefore the "repeated fields" must                       MD022093
      ** be moved forward from BufferEx3 to BufferEx4                                       MD022093
      *                                                                                     MD022093
     C                   EVAL      Bfp   = 1                                                MD022093
     C                   EVAL      TransCS13 = %SUBST(BufferEx2:Bfp:SW13Ln)                 MD022093
      *                                                                                     MD022093
     C                   EVAL      Bfp  += SW13Ln                                           MD022093
     C                   EVAL      TransCUXC = %SUBST(BufferEx2:Bfp:CUXCLn)                   CGL132
     C                   EVAL      Bfp  += CUXCLn                                             CGL132
     C                   EVAL      TransFTCR = %SUBST(BufferEx2:Bfp:FTCRLn)                   CGL132
     C                   EVAL      Bfp  += FTCRLn                                             CGL132
     C                   EVAL      TransCUEX = %SUBST(BufferEx2:Bfp:SDEXLn)                 MD044880
     C                   EVAL      Bfp  += SDEXLn                                           MD044880
     C                   EVAL      TransCRSH = %SUBST(BufferEx2:Bfp:CRSSLn)                   CGL157
     C                   EVAL      Bfp  += CRSSLn                                             CGL157
      *** APR Calculation Required Field (CUSD)                                             MD054028
     C                   EVAL      TransCR50 = %SUBST(BufferEx2:Bfp:1)                      MD054028
     C                   EVAL      Bfp  += 1                                                MD054028
      *** BRT Customer Details - Century                                                    MD055446
     C                   EVAL      TransBRTCent = %SUBST(BufferEx2:Bfp:10)                  MD055446
     C                   EVAL      Bfp  += 10                                               MD055446
     C                                                                                      MD054028
     C                   EVAL      BFEX2Ln -= Bfp                                           MD022093
                                                                                            MD022093
     C                   ENDSR                                                              MD022093
      *****************************************************************                     MD022093
      /SPACE 5                                                                              MD022093
      *****************************************************************                     MD022093
      * Extract buffer ex 3                                                                 MD022093
      *****************************************************************                     MD022093
     C     ExtCUSDBufEx3 BEGSR                                                              MD022093
                                                                                            MD022093
     C                   EVAL      Bfp = 1                                                  MD022093
     C                   EVAL      BFEx3Ln -= Bfp                                           MD022093
                                                                                            MD022093
     C                   ENDSR                                                              MD022093
      *****************************************************************                     MD022093
      /SPACE 5                                                                              MD022093
      ****************************************************************                      MD022093
      * Extract buffer ex 4                                                                 MD022093
      ****************************************************************                      MD022093
     C     ExtCUSDBufEx4 BEGSR                                                              MD022093
      *                                                                                     MD022093
     C                   EVAL      Bfp   = 1                                                MD022093
     C                   EVAL      TransCUA1 = %SUBST(BufferEx4:Bfp:CUA1Ln)                 MD022093
     C                   ADD       CUA1Ln        Bfp                                        MD022093
      *                                                                                     MD022093
     C                   EVAL      TransCUA2 = %SUBST(BufferEx4:Bfp:CUA2Ln)                 MD022093
     C                   ADD       CUA2Ln        Bfp                                        MD022093
      *                                                                                     MD022093
     C                   EVAL      TransCUA3 = %SUBST(BufferEx4:Bfp:CUA3Ln)                 MD022093
     C                   ADD       CUA3Ln        Bfp                                        MD022093
     C                   EVAL      TransCUAH = TransCUA1 + TransCUA2                        MD022093
     C                                       + TransCUA3                                    MD022093
      *                                                                                     MD022093
     C                   EVAL      TransACT1 = %SUBST(BufferEx4:Bfp:ACT1Ln)                 MD022093
     C                   ADD       ACT1Ln        Bfp                                        MD022093
      *                                                                                     MD022093
     C                   EVAL      TransACT2 = %SUBST(BufferEx4:Bfp:ACT2Ln)                 MD022093
     C                   ADD       ACT2Ln        Bfp                                        MD022093
      *                                                                                     MD022093
     C                   EVAL      TransACT3 = %SUBST(BufferEx4:Bfp:ACT3Ln)                 MD022093
     C                   ADD       ACT3Ln        Bfp                                        MD022093
      *                                                                                     MD022093
     C                   EVAL      TransACT4 = %SUBST(BufferEx4:Bfp:ACT4Ln)                 MD022093
     C                   ADD       ACT4Ln        Bfp                                        MD022093
      *                                                                                     MD022093
     C                   EVAL      TransACT5 = %SUBST(BufferEx4:Bfp:ACT5Ln)                 MD022093
     C                   ADD       ACT5Ln        Bfp                                        MD022093
     C                   EVAL      TransACT6 = %SUBST(BufferEx4:Bfp:ACT6Ln)                 MD022093
     C                   ADD       ACT6Ln        Bfp                                        MD022093
     C                   EVAL      TransCCTX = TransACT1 + TransACT2                        MD022093
     C                                       + TransACT3 + TransACT4                        MD022093
     C                                       + TransACT5 + TransACT6                        MD022093
     C                   EVAL      TRANS19   = %SUBST(TransCCTN:1:CCTNLn1) +                MD041996
     C                                         %SUBST(BufferEx4:Bfp:CCTNLn)                 MD041996
     C                   ADD       CCTNLn        Bfp                                        MD041996
     C**********         EVAL      ExtData   = %SUBST(BufferEx4:Bfp:SDEXLn)        MD022093 MD044880
     C**********         ADD       SDEXLn        Bfp                               MD022093 MD004480
      *                                                                                       CGL157
     C                   EVAL      TransCRS01 = %SUBST(BufferEx4:Bfp:CRS01Ln)                 CGL157
     C                   ADD       CRS01Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS02 = %SUBST(BufferEx4:Bfp:CRS02Ln)                 CGL157
     C                   ADD       CRS02Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS03 = %SUBST(BufferEx4:Bfp:CRS03Ln)                 CGL157
     C                   ADD       CRS03Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS04 = %SUBST(BufferEx4:Bfp:CRS04Ln)                 CGL157
     C                   ADD       CRS04Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS05 = %SUBST(BufferEx4:Bfp:CRS05Ln)                 CGL157
     C                   ADD       CRS05Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS06 = %SUBST(BufferEx4:Bfp:CRS06Ln)                 CGL157
     C                   ADD       CRS06Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS07 = %SUBST(BufferEx4:Bfp:CRS07Ln)                 CGL157
     C                   ADD       CRS07Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS08 = %SUBST(BufferEx4:Bfp:CRS08Ln)                 CGL157
     C                   ADD       CRS08Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS09 = %SUBST(BufferEx4:Bfp:CRS09Ln)                 CGL157
     C                   ADD       CRS09Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS10 = %SUBST(BufferEx4:Bfp:CRS10Ln)                 CGL157
     C                   ADD       CRS10Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS11 = %SUBST(BufferEx4:Bfp:CRS11Ln)                 CGL157
     C                   ADD       CRS11Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS12 = %SUBST(BufferEx4:Bfp:CRS12Ln)                 CGL157
     C                   ADD       CRS12Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRS13 = %SUBST(BufferEx4:Bfp:CRS13Ln)                 CGL157
     C                   ADD       CRS13Ln       Bfp                                          CGL157
      *                                                                                       CGL157
     C                   EVAL      TransCRDD1 = TransCRS01 + TransCRS02                       CGL157
     C                                        + TransCRS03 + TransCRS04                       CGL157
     C                                        + TransCRS05 + TransCRS06                       CGL157
     C                                        + TransCRS07 + TransCRS08                       CGL157
     C                                        + TransCRS09 + TransCRS10                       CGL157
     C                                        + TransCRS11 + TransCRS12                       CGL157
     C                                        + TransCRS13                                    CGL157
      *                                                                                       CGL157
                                                                                            MD022093
     C                   EVAL      BFEx4Ln  -= Bfp                                          MD022093
      *                                                                                     MD022093
                                                                                            MD022093
     C                   ENDSR                                                              MD022093
      *****************************************************************                       CGL157
      /SPACE 5                                                                                CGL157
      *****************************************************************                       CGL157
      * Extract buffer ex 5                                                                   CGL157
      *****************************************************************                       CGL157
     C     ExtCUSDBufEx5 BEGSR                                                                CGL157
                                                                                              CGL157
     C                   EVAL      Bfp = 1                                                    CGL157
                                                                                              CGL157
     C                   EVAL      TransCRS14 = %SUBST(BufferEx5:Bfp:CRS14Ln)                 CGL157
     C                   ADD       CRS14Ln       Bfp                                          CGL157
                                                                                              CGL157
     C                   EVAL      TransCRS15 = %SUBST(BufferEx5:Bfp:CRS15Ln)                 CGL157
     C                   ADD       CRS15Ln       Bfp                                          CGL157
                                                                                              CGL157
     C                   EVAL      TransCRDD2 = TransCRS14 + TransCRS15                       CGL157
                                                                                              CGL157
     C                   EVAL      ExtData   = %SUBST(BufferEx5:Bfp:SDEXLn)                   CGL157
     C                   ADD       SDEXLn        Bfp                                          CGL157
                                                                                              CGL157
     C                   EVAL      BFEx5Ln -= Bfp                                             CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       BG0505
      /SPACE 5
      ****************************************************************
      *  Initialisation                                              *
      ****************************************************************
     C     *INZSR        BEGSR
                                                                                              CRE020
      ** Check if Online Printing of Advices (GE7) is on.                                     CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
     C                   CALL      'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRTCD                                        CRE020
     C                   PARM      '*VERIFY'     POPTN                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        PRTCD = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
     C/COPY WNCPYSRC,APH00035

      ** Check if SWIFT2009 is installed                                                      CSW209
                                                                                              CSW209
     C                   Eval      CSW209 = 'N'                                               CSW209
     C                   Call      'SWIF2009'                                                 CSW209
     C                   Parm      *BLANKS       PRTCD                                        CSW209
                                                                                              CSW209
     C                   If        PRTCD = 'CSW2009'                                          CSW209
     C                   Eval      CSW209 = 'Y'                                               CSW209
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209
     C/COPY OFCPYSRCZ,CAP090_005                                                              CAP090
     C/COPY OFCPYSRCZ,CGL135_046                                                             CGL135A
     C/COPY OFCPYSRCZ,CGL158_005                                                              CGL158
      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      *  Get Record Lengths of Transaction Data Blocks               *
      ****************************************************************
     C     GETRCDLN      BEGSR

     C                   CALLB     'UTGETRCDLN'

      ** Return code
     C                   PARM                    ReturnCode       10
      ** Record length
     C                   PARM      *ZERO         RecordLen         5 0

      ** File name
     C                   PARM                    FileName         10
      ** File library
     C                   PARM      '*LIBL     '  FileLib          10

      ** If file not found (or any other error) shut down the program
     C     ReturnCode    Ifne      *Blanks
     C                   EXSR      *pssr
     C                   EndIf

     C                   ENDSR
      *****************************************************************                       CRE020
      /SPACE 5                                                                                CRE020
      ****************************************************************                        CRE020
      *  Send Message to Retail Advice Generation DTAQ               *                        CRE020
      ****************************************************************                        CRE020
     C     SRSndDtaQ     BEGSR                                                                CRE020
                                                                                              CRE020
     C                   EVAL      PDtqMsg = WDSPgmMod                                        CRE020
     C                   EVAL      PDtqLen = 12                                               CRE020
                                                                                              CRE020
     C                   CALL      'QSNDDTAQ'                                                 CRE020
     C                   PARM      'APRTADDTQ'   PDtqNam                                      CRE020
     C                   PARM      '*LIBL'       PDtqLib                                      CRE020
     C                   PARM                    PDtqLen                                      CRE020
     C                   PARM                    PDtqMsg                                      CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      ****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRetC = '0'
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2003