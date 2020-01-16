     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account posting')                             *
/*OVR *: OVRDBF FILE(REIAC2) TOFILE(REIAC) SHARE(*NO)               : *
      *****************************************************************
      *                                                               *
      *  Midas General Ledger Module                                  *
      *                                                               *
      *  GL0600 - Account Posting                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR954846           Date 09Jan20               *
      *  Prev Amend No. 255478A            Date 03Oct19               *
      *                 MD045515           Date 02Jul17               *
      *                 MD037555           Date 24Feb15               *
      *                 MD048056           Date 16Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL184             Date 07Dec16               *
      *                 CGL154             Date 13Oct14               *
      *                 256758             Date 21Jun16               *
      *                 MD038510           Date 20Jun16               *
      *                 MD035554           Date 25May16               *
      *                 MD037046           Date 12Feb16               *
      *                 CRE095             Date 25Apr14               *
      *                 MD031057           Date 24Feb15             *
      *                 240699             Date 19Aug14               *
      *                 MD028392           Date 14Jul14               *
      *                 CRE090             Date 14Feb14               *
      *                 MD022971           Date 21Oct13               *
      *                 AR1095876          Date 30Sep13               *
      *                 MD021994           Date 30Aug13               *
      *                 AR1097401          Date 24Apr13               *
      *                 MD020105           Date 18Apr13               *
      *                 AR1097218          Date 05Apr13               *
      *                 AR1097375          Date 26Mar13               *
      *                 CGL142 *REWRITE    Date 06Aug12               *
      *                 AR1093639          Date 04Mar13               *
      *                 AR1091700          Date 27Feb13               *
      *                 CGL001             Date 06Aug12               *
      *                 CGL120             Date 06Aug12               *
      *                 AR1005304          Date 25Nov12               *
      *                 AR934701           Date 22Mar12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 AR871745           Date 05Dec11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER042             Date 11May11               *
      *                 AR750832           Date 27Apr11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23767           Date 20Apr09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      *                 260176             Date 08May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG17926           Date 25Apr08               *
      *                 248369             Date 08Jun07               *
      *                 246729             Date 02Apr07               *
      *                 BUG14211B          Date 01Aug07               *
      *                 BUG14211A          Date 13Jul07               *
      *                 BUG14211           Date 05Jul07               *
      *                 244250             Date 08Dec06               *
      *                 BUG13258           Date 09FEB07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 215194             Date 19Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CGL048             Date 18Jan06               *
      *                 B11354             Date 12May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10413           Date 10Feb06               *
      *                 BUG9866            Date 12Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 BUG6597            Date 04Jul05               *
      *                 CRE023             Date 29Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD023             Date 18Nov04               *
      *                 CAS010             Date 09Feb05               *
      *                 CPK021             Date 11Jul02               *
      *                 CPB004             Date 11Jul02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3616            Date 12Jul04               *
      *                 CTI004             Date 12Apr04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA102             Date 30Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208553             Date 20Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 177177             Date 27Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175976             Date 02Jun00               *
      *                 178802             Date 10May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 01Jun99               *
      *                 CRT001             Date 28Feb95               *
      *                 CAP035             Date 10Sep99               *
      *                 CFT004             Date 19Jul99               *
      *                 169210             Date 19Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 01Mar99               *
      *                 CTI002             Date 19Sep98               *
      *                 133292             Date 19May98               *
      *                 CEU013             Date 28May98               *
      *                 117743             Date 02Apr98               *
      *                 120500             Date 27Feb98               *
      *                 114984             Date 27Feb98               *
      *                 107654             Date 24Feb98               *
      *                 121296             Date 16Feb98               *
      *                 CTI001             Date 28Oct97               *
      *                 104507             Date 08May97               *
      *                 104037             Date 10Apr97               *
      *                 085308             Date 04Feb97               *
      *                 100767             Date 03Mar96               *
      *                 CCB002             Date 25Jul96               *
      *                 S01408             Date 03Sep96               *
      *                 S01408             Date 20Jun96               *
      *                 S01408             Date 03Jun96               *
      *                 S01408             Date 24Apr96               *
      *                 S01408             Date 17Apr96               *
      *                 S01408             Date 10Apr96               *
      *                 S01408             Date 04Apr96               *
      *                 S01408             Date 24Jan96               *
      *                 S01408             Date 18Jan96               *
      *                 095544             Date 17Jan96               *
      *                 S01408             Date 0                     *
      *                 S01408             Date 18Oct95               *
      *                 S01408             Date 04Oct95               *
      *                 S01408             Date 05Sep95               *
      *                 S01408             Date 05Jun95               *
      *                 085872             Date 16Mar95               *
      *                 085809             Date 10Mar95               *
      *                 S01408             Date 17May94               *
      *                 064478             Date 12May94               *
      *                 056932             Date 07Mar94               *
      *                 058559             Date 28Sep93               *
      *                 056409             Date 28Sep93               *
      *                 047535             Date 28Sep93               *
      *                 045811             Date 28Sep93               *
      *                 S01413             Date 13Apr93               *
      *                 063626             Date 08Feb94               *
      *                 S01449             Date 06Jan94               *
      *                 046303             Date 17Jan94               *
      *                 056524             Date 17Nov93               *
      *                 S01421             Date 07Jul93               *
      *                 S01427             Date 12Jul93               *
      *                 E38323             Date 30Jul92               *
      *                 S01383             Date 27Apr92               *
      *                 S01340             Date 14Oct91               *
      *                 E24351             Date 17Sep91               *
      *                 RT0018             Date 08May91               *
      *                 S01314             Date 13Mar91               *
      *                 E20703             Date 13Feb90               *
      *                 E20557             Date 31Jan90               *
      *                 S01182             Date 10/11/88              *
      *                 E15411             Date 17Jul89               *
      *                 E15826             Date 16/01/89              *
      *                 BHF478             Date 22Aug90               *
      *                 LN0249             Date 07Jun90               *
      *                 S01245             Date 16Mar90               *
      *                 S01246             Date 22Feb90               *
      *                 S01195             Date 30/03/89              *
      *                 S01194             Date 29/03/89              *
      *                 S01197             Date 07/03/89              *
      *                 S01117             Date 10/03/89              *
      *                 E13383             Date 13/07/88              *
      *                 S01127             Date 10/05/88              *
      *                 S03220             Date 10/05/88              *
      *                 E12039             Date 11/04/88              *
      *                 S01161             Date 07/04/88              *
      *                 S05452             Date 20/08/87              *
      *                 E80756             Date 23/12/86              *
      *                 E43564             Date 14/10/86              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR954846 - No statement produced for newly generated accounts*
      *             Set NSTD = RUND for STFQ = 'D' to generate report.*
      *           - Applied for MD-54704                              *
      *  255478A - Correct the BGNOST to BGN0ST to validate Analytical*
      *            Accounting instead of Leo Letters of Credit.       *
      *            Applied fix for MD054339.                          *
      *  MD045515 - Real-time postings resulted in duplicate movements*
      *             in Midas. Remove fix MD037555.                    *
      *  MD037555 - Correction of MD028392.  This fix cause the loss  *
      *             of posting in Clearpd  with future value of more  *
      *             than 1 day after next working date.  The change is*
      *             to use TEST on RIND instead of TESTB 4. RIND is   *
      *             the value in REC3065 to skip copy of real time    *
      *             entries from CLEARPD because Real time post does  *
      *             not set it to 1. Records from MANPOPD have the    *
      *             indicator set up.                                 *
      *             The advantage of this is that DEPT and NITMS value*
      *             are preserved also.                               *
      *  MD048056 - GPAMT of REOUTLPD should also be updated when     *
      *             holiday is before next working day                *
      *  MD046248 - Finastra Rebranding.                              *
      *  CGL184 - New Frequencies for Account Statements              *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  256758 - Bit 0 of PRIN should not be checked when updating   *
      *           Last Activity Date. Applied fix 232450.             *
      *         - Applied for MD-38413.                               *
      *  MD038510 - Statement for system generatd accounts not        *
      *             produced. Rewrite processing STMTAH.              *
      *  MD035554 - 2o'clock/ABC compatibility (Recompile)            *
      *  MD037046 - MEMOS missing balances from CLEARPD of future     *
      *             dated posting. Modified validation of MD028392    *
      *  CRE095 - Rate Fixing for RE Accounts                         *
      *  MD031057 - REC002008 00001 failed due to FOOB                *
      *  240699 - Applied fix 217081, such that retail a/c will be    *
      *           active if there is cust-orig. trans. and RETB       *
      *           should be set off.                                  *
      *  MD028392 - Retail Discrepancy report have accounts that has  *
      *             differences on History and Cleared Balance        *
      *             due to Real Time postings with forward value date *
      *  CRE090 - Delay Capitalisation of Interest                    *
      *  MD022971 - GLC0600 06035 Database Error                      *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  MD021994 - GLC0600 failed trying to allocate REIAC record    *
      *  AR1097401 - Do not process READ unless RRN Lt GLTERN         *
      *  MD020105 - Incorrect balance reflected on Account Details    *
      *             and Customer Account Balance Enquiry              *
      *  AR1097218 - GLC0720 seq 10001 failed Out of Balance          *
      *  AR1097375 - Database error in SDRETRPD                       *
      *  CGL142 - Tactical COB changes GL                             *
      *  AR1093639 - CGL120 Incorp related issues encountered during  *
      *              link testing.                                    *
      *  AR1091700- GLC0600 03002 Component on MSGW                   *
      *  CGL001 - Introduction of New statement frequency 'N' (NEVER) *
      *  CGL120 - GL COB Components Task Split                        *
      *         - Incorporate AR699797                                *
      *         - Incorporate CGL104                                  *
      *  AR1005304 - GLC30 failed due to CSD023 feature               *
      *              (Child: AR1005305)                               *
      *  AR934701 - GLC30 FOOB in GL0600AU                            *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  AR871745 - GLC3571 00001 CPF5075 IO error was detected in    *
      *             GL3572P1; applied fix AR850272                    *
      *  AR850272 - Spread/sign, rounding fraction/decimal and        *
      *             rounding method were deleted after COB            *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  AR750832 - Effective dates were reset to blanks after COB    *
      *             (Child: AR750833)                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23767 - Accntab not updating to capture                   *
      *           amended customers with KWG set to Y                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  260176 - Applied MP1.2.1 core fix 253561.                    *
      *  253561 - PF/REANX1PD is populated only if ULX004 is ON.      *
      *  BUG17926 - GLC30 File out of balance.                        *
      *  248369 - Only Nostro Accounts opened by the system should    *
      *           have a Profit Centre if Analytical Accounting is on.*
      *  246729 - Additional condition on when to set the value of    *
      *           WPB004 to 'Y' or 'N'. Applied fix 241479.           *
      *  BUG14211B - File out of balance                              *
      *  BUG14211A - GL0600 does not contain the narrative            *
      *              for BUG14211 and Error occured on day 3          *
      *  BUG14211 - GLC30 00001 - File out of balance                 *
      *  244250 - File out of balance in GLC30.  Partially applied    *
      *           core fix 237350.                                    *
      *  237350 - Reinstate additon to NOREP.                         *
      *  BUG13258-BUG9866 is incorrect. REVERSE OUT.                  *
      *           FP trailer is unusual in that it carries no of recs *
      *           on detail file whereas other trailers show 2 more   *
      *           than no of records on details. This must be         *
      *           allowed for when calculating NOREP                  *
      *  215194 - GLC43 loops. Update next stmt. date (NSTD) upon     *
      *           reopening of a/c. Applied fix 214612.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL048 - Confirmation and Statement Layout Changes           *
      *           Suppress printing of an automatic demand statement  *
      *           after six months for those accounts with a          *
      *           statement frequency of 'Z'.                         *
      *  B11354 - Test for Private Banking feature CPB004 is          *
      *           incorrect.                                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10413- Blanks is written in the Encashment facility (EFAC)*
      *            in ACCNTAB instead of '00'                         *
      *  BUG9866 - Ensure NORE is accumulated properly.               *
      *  BUG6597 - Ensure new account opened by the system is         *
      *            defaulted as a non-TI account. Applied fix 230076. *
      *  CRE023 - 2 O'clock Flag Upgrade to MidasPLus                 *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD023 - Automatic Customer Account Closure                  *
      *  CSD025 - Customer De-Activation                              *
      *  CAS010 - IAS + PB Enhancements Upgrade to MidasPlus          *
      *  CPK021 - Release 4.02 pacakging.  Error in calling AOSARDR0. *
      *  CPB004 - Replicate account closure details. Replicate if     *
      *           Privete Banking customer and the account code is    *
      *           to be transferred to TOF.                           *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG3616 - Missing accounts in extension file GLACNTQD        *
      *  CTI004 - MidasPlus TI Integration Enhancements               *
      *           Accounts Integration                                *
      *  CLE025 - Credit Lines                                        *
      *  TDA102 - Account code not written to CLEARPD.                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information                                         *
      *  208553 - FIX over 178802 for the timestamp problem.          *
      *  177177 - If a posting opens a new account the profit centre  *
      *         - of the account should be taken from the posting.    *
      *  175976 - Customer last activity date is being incorrectly    *
      *           updated for non customer originated transactions    *
      *  178802 - Define a default value for the timestamp field      *
      *           before updating the database. (Program fell over    *
      *           with decimal data error in field TMST whilst trying *
      *           to write to ACORDAB). Output newly formatted        *
      *           timestamp when a new account has been created       *
      *           (*IN79 is off) else output TMST as before.          *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Midas/TOF Interface.                                *
      *  CRT001 - Retail Teller System                                *
      *  CAP035 - Account maintenance API; recompiled over changed    *
      *           ACORDAB                                             *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *           International Bank Account Numbers (IBAN)           *
      *  169210 - Duplicate hooks renamed from GL0600C007 to          *
      *           GL0600CADO                                          *
      *  CGL007 - Account Postings Enquiry.                           *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
      *  133292 - Statement frequency for automatic account openings  *
      *           is on demand yet next statement date has a value.   *
      *  CEU013 - EMU Account Posting Narrative. ACCNT file layout    *
      *           extended.                                           *
      *  117743 - Remove *IN02 as validation in determining accounts  *
      *           for balance statement                               *
      *  120500 - Prohibit opening of account with blank account type *
      *  114984 - Move RUNDATE in original entry date on account      *
      *           automatically opened.                               *
      *  107654 - Duplicate record written to ACORDAB. Caused by a    *
      *           closed a/c which had an a/c with the same a/c no.   *
      *           but different branch as an alternative a/c; this    *
      *           a/c is still live. When the live a/c capitalises,   *
      *           LCD for the closed a/c is set to RUND somewhere in  *
      *           the system, which causes the closed a/c to be       *
      *           processed as if it is closing today. As a result,   *
      *           and also because REIAC2 overwrites the branch, the  *
      *           closed a/c is output to ACORDAB with the branch of  *
      *           the live a/c and the RECOMD record for the live a/c *
      *           is closed.                                          *
      *  121296 - Revalidate if posting is customer originated or     *
      *           not in order for LRCR to update correctly.          *
      *           Applied Fix No. 120624                              *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *           ACCNT file layout extended.                         *
      *  104507 - Problem when closing an a/c which was setup for     *
      *           interest.  Applied fix 104081.                      *
      *  104037 - Account left with Cleared Balance after Closure,    *
      *           due to overwriting.                                 *
      *  085308 - Set on indicator U7 if database error occurs.       *
      *  CCB002 - COB Performance Enhancements                        *
      *           Access now via access object                        *
      *           MEMOS is now accessed via GL/RE key rather than old *
      *           relative record number.                             *
      *  S01408 - Core hook GL0600OOP5                                *
      *         - Core hook GL0600CP22                                *
      *  100767 - Extend file lengths to 316.                         *
      *  S01408 - Core hook GL0600CP21                                *
      *  S01408 - Core hook GL0600IIP3                                *
      *           Core hook GL0600CP20                                *
      *  S01408 - Core hook GL0600CP19                                *
      *  S01408 - Core hook GL0600CP17                                *
      *           Core hook GL0600CP18                                *
      *  S01408 - Core hook GL0600CP14                                *
      *           Core hook GL0600CP15                                *
      *           Core hook GL0600CP16                                *
      *  S01408 - Core hook GL0600CP13                                *
      *  S01408 - Core hook GL0600FFP1                                *
      *           Core hook GL0600FFP2                                *
      *           Core hook GL0600IIP2                                *
      *           Core hook GL0600OOP2                                *
      *           Core hook GL0600OOP3                                *
      *           Core hook GL0600OOP4                                *
      *  S01408 - Core hook GL0600CP12 added.                         *
      *  095544 - Some accounts opened by the system are set as RCII  *
      *  S01408 - Core hook GL0600IIP1                                *
      *  S01408 - Core hook GL0600EEP1                                *
      *           Core hook GL0600CP11                                *
      *  S01408 - Core hook GL0600CP10                                *
      *  S01408 - Core hook GL0600CCP6                                *
      *           Core hook GL0600CCP7                                *
      *           Core hook GL0600CCP8                                *
      *           Core hook GL0600CCP9                                *
      *           Core hook GL0600OOP1                                *
      *  S01408 - Core hook GL0600CCPG added                          *
      *           Core hook GL0600CCP1 added                          *
      *           Core hook GL0600CCP2 added                          *
      *           Core hook GL0600CCP3 added                          *
      *           Core hook GL0600CCP4 added                          *
      *           Core hook GL0600CCP5 added                          *
      *  085872 - Missing output of PTFR and HLEX on ACORDAB          *
      *  085809 - FILE LAYOUTS EXTENDED TO INCLUDE PORTFOLIO REFERENCE*
      *  S01408 - Core hook GL0600FFPG added                          *
      *           Core hook GL0600OOPG added                          *
      *  064478 - A/c opened by system with incorrect next stmt date. *
      *           Amended sr/ZFREQS such that: for default freq L, R, *
      *           or S (last day of month, 6 days to last day of      *
      *           month, semi-monthly), do not add 1 to ZMNTH (i.e.   *
      *           stmt is on same month as rundate).                  *
      *  056932 - Last customer activity date reported incorrectly    *
      *  058559 - FOOB in GL0480 and incorrect closure for account    *
      *           with alternate accounts. (fields overwriting)       *
      *  056409 - Wrong update on RECOMD when account closed has      *
      *           alternate account (rename fields of REIAC2)         *
      *  047535 - Non-Retail accounts must be opened by the system    *
      *           with ACNO equal to Zeroes                           *
      *  045811 - I/O Error in RE3572P1 due to Fields not             *
      *           Initialised.                                        *
      *  S01413 - Retail 3 Incorporation                              *
      *           a) The files are not updated correctly when         *
      *           alternative                                         *
      *           b) 'No Credit for 31 Days' reported incorrectly.    *
      *           LRCR only updated with postings from Clearing.      *
      *           Now checks if customer originated and NOT from      *
      *           Clearing (i.e. PRIN Bit '0' on and Bit '4' off).    *
      *  063626 - System opens GL accnt with non-blank subtype if the *
      *           previous A/C record processed is a retail A/C bec.  *
      *           when system opens an accnt, the subtype is not being*
      *           initialised to blank.  Fix is to initialise A/C     *
      *           subtype when opening an account.                    *
      *  S01449 - AutoRecs II                                         *
      *             o Field added to ACCNTAB                          *
      *  046303 - /COPY source subr. ZFWDT amended to prevent array   *
      *           error if no holiday record found - fixed by S01434. *
      *           Program recompiled.                                 *
      *  056524 - EODPOPD Missing Real time Postings - CLEARPD is     *
      *           written with PRIN bit 6 on, preventing CLBL Update. *
      *  S01421 - Recompile for BLI Step 1 development                *
      *           LF/SACPO changed for new Customer Service Fees      *
      *           feature (S01423)                                    *
      *  S01427 - R10 CHIPS Incorporation                             *
      *  E38323 - Recompiled due to a change in copy source ZFWDT SR  *
      *  E38323 - Recompiled due to a change in copy source ZFWDT SR  *
      *  S01383 - Basic Rate Tax Incorporation                        *
      *  S01340 - MIS GL Real time posting                            *
      *  E24351 - Field used to obtain transaction reference for      *
      *           deal number on security trading posting has been    *
      *           changed.  It is also used for customer exchange     *
      *           posting.  Non-numeric deal numbers are changed      *
      *           to blanks.                                          *
      *  RT0018 - Set up NSTD for accounts opened by the system.      *
      *  S01314 - Changes made during R10 PTF Incorporation.          *
      *           Field length greater than max of 256.               *
      *  E20703 - Fix 13383 prevented check of customer origination.  *
      *  E20557 - The file 'POSTG' specified in database error        *
      *           number 22 does not exist on the AS/400 and          *
      *           should be changed to the file 'SACPO'.              *
      *  S01182 - Writes new account posting fields to the            *
      *           generated entries file LF/CLEAR for MIS.            *
      *  E15411 - System should prompt database error if the          *
      *           branch code in posting is different from the        *
      *           account to be posted.                               *
      *  E15826 - Program does not use address reference field        *
      *           found on the ACCNT file, therefore this field       *
      *           is updated by the previous ACCNT file record        *
      *           for system created accounts.                        *
      *  BHF478 - Wrong account name and NSTD on accounts opened.     *
      *  LN0249 - Remove DB error processing and reinstate            *
      *           warning.  Replaced New York error fix BHF045        *
      *           which left U5 on when it was not required for       *
      *           the GLC37B post.                                    *
      *  S0134  - BHF SAR:  Statement frequency default for           *
      *           accounts opened by the system is changed to 'B'.    *
      *           (Last business day of the month)                    *
      *  S01246 - BHF SAR:  Output account name from a/c code         *
      *           table for accounts opened by the system.            *
      *  S01195 - Holiday amendment                                   *
      *  S01194 - New Standing Data                                   *
      *  S01197 - RE -- > GL Conversion                               *
      *  S01117 - Multibranching.                                     *
      *  E13383 - Fix E43284 was made because LRCR was not            *
      *           being updated if a debit was booked                 *
      *           across an account on the same day as a              *
      *           customer originated posting(CR).                    *
      *           However this fix created another problem -          *
      *           LRCR is now updated if either a debit or a          *
      *           credit is booked across the account.                *
      *  S01127 - Interface for futures and options                   *
      *  S03220 - Interface for funds transfer                        *
      *  E12039 - Database error 21 not reported in the file          *
      *           controls report when file 'OPEN' has a              *
      *           database error.                                     *
      *  S01161 - COB improvements: New fields on STMTAH included     *
      *  S05452 - Inclusion of auto reconciliations.                  *
      *  E80756 - Change RECI to be 'H' (POS 1) instead of            *
      *           'HH' ( POS 1-2) on ACORDAA                          *
      *  E43564 - Changes applied to GL0350 - A/C'S post - have       *
      *           been added as also applicable.                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *       01  Account Master - Header                             *
      *       02  Detail (OPEN & CLOSED)                              *
      *       03  Dummy (Unmatched Postings)                          *
      *       04  Catchall                                            *
      *       05  Sorted A/C posting - balance change                 *
      *       06  Rate Change seq 1                                   *
      *       07  Catchall                                            *
      *       10  REACR detail                                        *
      *       11  Trailer                                             *
      *       12  Trailer                                             *
      *       13  Sorted A/C posting - Rate Change seq 2 or 3         *
      *       16  Sorted A/C posting - Trailer                        *
      *       17  RECOM - DETAIL                                      *
      *       18  Outward clearing postings before 'next'             *
      *           next working day.                                   *
      *       20  Retail Account                                      *
      *       21  Accrue on last day                                  *
      *       22  Ledger Balance already updated                      *                     MD028392
      *       23  Daily accrual profit frequency                      *
      *       24  GEFP Record read                                    *
      *       25  Account open                                        *
      *       27  Do not update account balances                      *
      *       28  Analytical accounting module switched on            *
      *       29  Nostro account to be opened                         *
      *       30  Source of posting is GE-DL                          *
      *       31  Source of posting is GE-ST                          *
      *       33  No retail accrued interest for thos closed account  *
      *       34  No amount capitalised for this closed account       *
      *       35  Posting to credit                                   *
      *       36  Transaction type equal to '00022'/'00023' or        *
      *           Transaction type equal to '20022'/'20023'           *
      *       37  Subsidiary retail account files to be updated       *
      *       38  Account reopened                                    *
      *       39  REACR Trailer to be updated                         *
      *       40  Not first cycle                                     *
      *       41  Work ind                                            *
      *       43  Next statement date zero                            *
      *       47  Run date is an accrual date                         *
      *       48  Run date is last working day in month               *
      *       49  Test on bit 0 of GLBT                               *
      *       52  Last movement GT. last statement date               *
      *       53  A/C has postings in clearing                        *
      *       56  Balances not zero                                   *
      *       60  Posting date processed ind on                       *
      *       61  Value date too far ahead                            *
      *       62  Posting date greater than lmud                      *
      *       63  Last activity date to be updated                    *
      *       65  STMT record output / AV. BALS CALC                  *
      *    66-69  Used for STMT output                                *
      *       70  Account flagged for closing.                        *
      *       71  Update O/D days                                     *
      *       73  Reopening an A/C closed today                       *
      *       74  Output A/C to REANX1PD                              *
      *       75  Int rate or cleared balance zero                    *
      *       76  Postings exist for account                          *
      *       77  First posting for account to be opened              *
      *       78  First posting for account to be re-opened           *
      *       79  AIC Master for posting                              *
      *       80  Output A/C to acord HDR and trailer.                *
      *       81  Output A/C to acord.                                *
      *       85  A/C'S opened by system                              *
      *       86  Balance statements                                  *
      *       88  Posting in clearing                                 *
      *    90-99  Used in system subroutines                          *
      *       U1  Accounts post daily - STMT output only if U1        *
      *       U5  O/P Clear - Main post or post after end of period   *
      *       U6  GEFPZZ Record read                                  *
      *    U7-U8  Database Error                                      *
      *       U8  File Imbalance                                      *
      *                                                               *
      *  Database error location numbers:                             *
      *                                                               *
      *       03  Retail installation Control Record                  *
      *           in first1 subroutine                                *
      *       04  Attempted O/P to clear not in main post or          *
      *           end of period post                                  *
      *       11  GLZSUM overflow                                     *
      *       20  Postings for closed retail account                  *
      *       21  Postings for unopened retail account                *
      *       60  REIAC read error in cloret subroutine               *
      *       61  REACR read error in cloret                          *
      *       62  SREC read error in cloret                           *
      *       90  REACR trailer read error on last record             *
      *                                                               *
      *****************************************************************
     F/COPY WNCPYSRC,GL0600F001
     F***GLACPOPD  IP   E             DISK                                                  MD021994
     FGLACPOPD  UF   E             DISK                                                     MD021994
     FZACCNTAB  IF   F  687        DISK    RECNO(RRN)
     FACCBA     UF   E           K DISK
     F                                     RENAME(ACCNTABF:ACCBAABF)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F                                     COMMIT
     F/COPY WNCPYSRC,GL0600F002
     FACNUM     IF   E           K DISK
     F                                     RENAME(ACCNTABF:ACNUMABF)
     FGLACNTL3  UF A E           K DISK
     F                                     COMMIT
     F/COPY WNCPYSRC,GLH00526
     FREIAC2    UF   E           K DISK
     F                                     RENAME(REIACDF:REIACD2F)
     F                                     IGNORE(REIACAF)
     F                                     IGNORE(REIACZF)
     F                                     COMMIT
     FSACPO     IF   F  620    24AIDISK    KEYLOC(2)
     FREIAC     UF   F  218    24AIDISK    KEYLOC(2)
     F                                     COMMIT
     FREACR     UF   F  191    24AIDISK    KEYLOC(2)
     F                                     EXTIND(*INU5)
     F                                     COMMIT
     FRECOM     UF   E           K DISK
     F                                     COMMIT
     FREHISBL   UF   E           K DISK
     F                                     COMMIT

     F/COPY WNCPYSRC,GL0600FFP1

     F/COPY WNCPYSRC,GL0600FFP2

     F/COPY WNCPYSRC,GL0600F003
     F/COPY WNCPYSRC,GL0600F004
     FACCNTL0   UF A F  687    24AIDISK    COMMIT
     FGLACCTAC  UF A E             DISK    COMMIT
     FSYSOPAJ   O  A F   71        DISK
     F                                     COMMIT
     FGLSYSOZX  UF A E             DISK    COMMIT
     FCLEARPD   O    F  620        DISK    EXTIND(*INU5)
     F                                     COMMIT
     FGLCLEAZZ  UF A E             DISK    COMMIT
     F                                     EXTIND(*INU5)
     F***GL0600AU  O    F  132        PRINTER                                               MD021994
     FGL0600AU  O    E             PRINTER USROPN                                           MD021994

      ** Core hook for externalisation.
     F/COPY WNCPYSRC,GL0600FFPG
     FREACX1PD  IF   E           K DISK
     F                                     COMMIT
     FREOUTLPD  O    F   47        DISK    EXTIND(*INU4)
     F                                     COMMIT
     FSTMTAH    UF A E             DISK    COMMIT                                           MD038510
     FGLOUTLPT  UF A E             DISK    COMMIT
     F                                     EXTIND(*INU4)

      ** Outward Clearing Transaction Types
     FRETTYPL0  IF   E           K DISK    EXTIND(*INU4)

     D/COPY WNCPYSRC,GL0600EEP1

     D REC_CTR         S             10U 0 INZ                                              MD021994
     D CBTASKSP      E DS                  DTAARA(CBTASKSP)                                 MD021994
     D                                     EXTNAME(CBTASKSP)                                MD021994
     D CommitSize                    10S 0 OVERLAY(CMTBLK)                                  MD021994
     D True            C                   CONST(*ON)                                       MD021994
     D False           C                   CONST(*OFF)                                      MD021994
     D ForceCommit     S               N   INZ(False)                                       MD021994
     D PrintHeader     S               N   INZ(True)                                        MD021994
     D*INT******       S             15  0 DIM(14)                                          MD022971
     D INT             S             15  0 DIM(14) INZ(0)                                   MD022971
     D*DEC******       S              3  0 DIM(14)                                          MD022971
     D DEC             S              3  0 DIM(14) INZ(0)                                   MD022971
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
     D/COPY WNCPYSRC,GL0600E001
     D RTT             S              5    DIM(1000)
     D COI             S              1    DIM(1000)
     D WRun            S              1A

      ** Standard local data area fields
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBERR                134    170
     D                 DS
     D  WALT                   1     24
     D  WCNUM                  1      6
     D  WCCY                   7      9
     D  WACOD                 10     19  0
     D  WACSQ                 20     21  0
     D  WBRCA                 22     24
     D  WALT5                 11     21
     D  WALT10                 1     10  0

      ** Data Structure for ACNK using 10 digit A/C code
     D ACNK            DS
     D  WNOCC1                 1      9
     D  WACOD1                10     19  0
     D  WSEQ1                 20     21  0

      ** Data Structure for ACPOKY using 10 digit A/C code
     D ACPOKY          DS
     D  WNOCC2                 1      9
     D  WACOD2                10     19  0
     D  WSEQ2                 20     21  0
     D/COPY WNCPYSRC,GL0600I009
     D RUNDT           DS

      ** Data area rundat
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13

     D SDACOD        E DS                  EXTNAME(SDACODPD)

      ** External DS for Bank Details
     D  QQACC1       E                     EXTFLD(QQACCD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)

      ** External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC2       E                     EXTFLD(QQACCD)

     ** External DS for Midas Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)

      ** Retail Transaction Types Details
     D SDRETR        E DS                  EXTNAME(SDRETRPD)

      ** Data Structure for access to Customer Details.
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Midas SC Switchable feaures descriptions
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  LCD_SARC     E                     EXTFLD(LCD)

     D/COPY WNCPYSRC,GL0600IIP1

      ** First DS for Access Programs, Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Third DS for Access Programs, Very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

     D/COPY ZSRSRC,ZHOLILE
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            MD031057
      ** Outward Clearing Trailer File structure                                            MD031057
     D GLOUTLDS        DS                  INZ LIKEREC( GLOUTLT0 : *OUTPUT )                MD031057

      ** Second DS for Access Programs, long data structure
     D DSCOMK          DS
     D  CNUM                   1      6
     D  CCY                    7      9
     D  ACOD                  10     19  0
     D  ACSQ                  20     21  0
     D  BRCA                  22     24

      ** Data Structure to hold update details for ACCNTAB
     D DSACCNTAB_O     DS
     D  AREC1O                 1    200
     D  AREC2O               201    687
     D  RECIAM                 1      1
     D  ATYP                  26     26
     D  ASTYP                 27     27
     D  ACST                  29     29
     D  DACO                  30     32P 0
     D  DACC                  33     35P 0
     D  ANAM                  36     55
     D  LDBL                  56     63P 0
     D  CLBL                  64     71P 0
     D  STFQ                  72     72
     D  DMST                  73     74  0
     D  LSTD                  75     77P 0
     D  NSTD                  78     80P 0
     D  LSTP                  81     82P 0
     D  CFSB                  83     90P 0
     D  LMVD                  91     93P 0
     D  EPLB                  94    101P 0
     D  EPCB                 102    109P 0
     D  YTDB                 110    117P 0
     D  GLBT                 118    118
     D  ADREF1               119    126
     D  ORED                 135    137P 0
     D  DLIM                 138    140P 0
     D  LRCR                 141    143P 0
     D  RTCB                 144    151P 0
     D  RTLB                 152    159P 0
     D  DITM                 160    166P 0
     D  CITM                 167    173P 0
     D  ADREF2               174    175
     D  CDIR                 178    183P 7
     D  CCIR                 184    189P 7
     D  ACNO                 190    199  0
     D  RETB                 200    200
     D  ODSC                 201    201
     D  ODLN                 202    207P 0
     D  ODED                 208    210P 0
     D  DIOD                 211    212P 0
     D  FACT                 213    215  0
     D  FCNO                 216    217  0
     D  EFAC                 218    219  0
     D  HELD                 220    227P 0
     D  MINB                 228    233P 0
     D  LACD                 234    236P 0
     D  LISP                 237    238P 0
     D  DRIB                 242    243  0
     D  DRIS                 244    249P 7
     D  DRCD                 250    252P 0
     D  DRIC                 253    253  0
     D  DRIF                 254    254
     D  DRDY                 255    256  0
     D  NDID                 257    259P 0
     D  LDID                 260    262P 0
     D  LDIA                 263    269P 0
     D  SDAP                 270    270
     D  LPAR                 271    273P 0
     D  DIIE                 274    280P 0
     D  DAIC                 281    288P 0
     D  MADI                 289    295P 0
     D  GADI                 296    302P 0
     D  DDIS_O               303    303
     D  DDIA                 304    306P 0
     D  OLDR                 307    309P 0
     D  OLDB                 310    311  0
     D  OLDS                 312    317P 7
     D  CRIB                 318    319  0
     D  CRIS                 320    325P 7
     D  CRCD                 326    328P 0
     D  CRIC                 329    329  0
     D  CRIF                 330    330
     D  CRDY                 331    332  0
     D  NCID                 333    335P 0
     D  LCID                 336    338P 0
     D  LCIA                 339    345P 0
     D  SCAP                 346    346
     D  LPAP                 347    349P 0
     D  CIIE                 350    356P 0
     D  CAIC                 357    364P 0
     D  MACI                 365    371P 0
     D  GACI                 372    378P 0
     D  CDIS_O               379    379
     D  DCIA                 380    382P 0
     D  OLCR                 383    385P 0
     D  OLCB                 386    387  0
     D  OLCS                 388    393P 7
     D  LCD                  394    396P 0
     D  CHTP                 397    397
     D  TNLU                 398    400P 0
     D  BRTCA                401    401
     D  NACSG                402    402
     D  R4ACNT               403    403
     D  ENOC                 404    405P 0
     D  EPNO                 406    407P 0
     D  ECFB                 408    415P 0
     D  LTAB                 416    418
     D  LTACQQ               419    422  0
     D  LTAS                 423    424  0
     D  PTFR                 433    436
     D  HLEX                 437    437
     D  EUSB                 448    448
     D  IBAN                 449    482
     D  IBSEQN               483    485
     D  FRNT                 486    505
     D  AFRT                 506    525
     D  REPA                 526    526
     D  TMST                 527    552Z
     D  REPI                 553    553
     D  LTAC                 564    573  0
     D  FCCU                 574    579
     D  COLF                 580    580
     D  BCOA                 581    588P 0
     D  COLA                 589    596P 0
     D  PFCU                 597    602
     D  PFTP                 603    605  0
     D  PFSQ                 606    607  0
     D  A5ACKY               608    641
     D  A5INTL               642    642
     D  A5TIAB               643    646
     D  AUTH                 647    647
     D  K24C                 648    648
     D  ACEFDT               649    651P 0
     D  DCSP                 652    657P 7
     D  DCSG                 658    658
     D  DRMT                 659    665
     D  DRFD                 666    669
     D  CCSP                 670    675P 7
     D  CCSG                 676    676
     D  CRMT                 677    683
     D  CRFD                 684    687

     D/COPY WNCPYSRC,GL0600IIP2

     D PSYSVL          C                   CONST('AllowCOBGLTlrImblnce')
     I/COPY ZSRSRC,ZHOLELE

     IZACCNTAB  NS  02    1 CD
     I         OR   02    1 CC
     I                                  1    1  RECIAM
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ

     I                                  2   10  WNOCC1
     I                                 15   16 0WSEQ1
     I                                554  563 0WACOD1

     I                                 23   25  BRCA              02
     I                                 26   26  ATYP
     I                                 27   27  ASTYP
     I                                 29   29  ACST
     I                             P   30   32 0DACO
     I                             P   33   35 0DACC
     I                                 36   55  ANAM
     I**********                       39   43  TRAT                                       AR1097375
     I                             P   56   63 0LDBL
     I                             P   64   71 0CLBL
     I                                 72   72  STFQ
     I                                 73   74 0DMST
     I                             P   75   77 0LSTD
     I                             P   78   80 0NSTD
     I                             P   81   82 0LSTP
     I                             P   83   90 0CFSB
     I                             P   91   93 0LMVD
     I                             P   94  101 0EPLB
     I                             P  102  109 0EPCB
     I                             P  110  117 0YTDB
     I                                118  118  GLBT
     I                                119  126  ADREF1
     I                             P  135  137 0ORED
     I                             P  138  140 0DLIM
     I                             P  141  143 0LRCR
     I                             P  144  151 0RTCB
     I                             P  152  159 0RTLB
     I                             P  160  166 0DITM
     I                             P  167  173 0CITM
     I                                174  175  ADREF2
     I                             P  178  183 7CDIR
     I                             P  184  189 7CCIR
     I                                190  199 0ACNO

     I/COPY WNCPYSRC,GL0600IIP3

     I                                200  200  RETB
     I                                201  201  ODSC
     I                             P  202  207 0ODLN
     I                             P  208  210 0ODED
     I                             P  211  212 0DIOD
     I                                213  215 0FACT
     I                                216  217 0FCNO
     I                                218  219 0EFAC
     I                             P  220  227 0HELD
     I                             P  228  233 0MINB
     I                             P  234  236 0LACD
     I                             P  237  238 0LISP

     I/COPY WNCPYSRC,GL0600I002

     I                                242  243 0DRIB
     I                             P  244  249 7DRIS
     I                             P  250  252 0DRCD
     I                                253  253 0DRIC
     I                                254  254  DRIF
     I                                255  256 0DRDY
     I                             P  257  259 0NDID
     I                             P  260  262 0LDID
     I                             P  263  269 0LDIA
     I                                270  270  SDAP
     I                             P  271  273 0LPAR
     I                             P  274  280 0DIIE
     I                             P  281  288 0DAIC
     I                             P  289  295 0MADI
     I                             P  296  302 0GADI
     I                                303  303  DDIS
     I                             P  304  306 0DDIA
     I                             P  307  309 0OLDR
     I                                310  311 0OLDB
     I                             P  312  317 7OLDS
     I                                318  319 0CRIB
     I                             P  320  325 7CRIS
     I                             P  326  328 0CRCD
     I                                329  329 0CRIC
     I                                330  330  CRIF
     I                                331  332 0CRDY
     I                             P  333  335 0NCID
     I                             P  336  338 0LCID
     I                             P  339  345 0LCIA
     I                                346  346  SCAP
     I                             P  347  349 0LPAP
     I                             P  350  356 0CIIE
     I                             P  357  364 0CAIC
     I                             P  365  371 0MACI
     I                             P  372  378 0GACI
     I                                379  379  CDIS
     I                             P  380  382 0DCIA
     I                             P  383  385 0OLCR
     I                                386  387 0OLCB
     I                             P  388  393 7OLCS
     I                             P  394  396 0LCD
     I                                397  397  CHTP
     I                             P  398  400 0TNLU
     I                                401  401  BRTCA
     I                                402  402  NACSG
     I                                403  403  R4ACNT
     I                             P  404  405 0ENOC
     I                             P  406  407 0EPNO
     I                             P  408  415 0ECFB
     I                                416  418  LTAB
     I                                419  422 0LTACQQ
     I                                423  424 0LTAS
     I                                433  436  PTFR
     I                                437  437  HLEX
     I                                438  438  A5TIAC
     I                                439  444  A5TIAN
     I                                445  447  A5TIAS
     I                                448  448  EUSB
     I                                449  482  IBAN
     I                                483  485  IBSEQN
     I                                486  505  FRNT
     I                                506  525  AFRT
     I                                526  526  REPA
     I                                527  552  TMSTX
     I                             Z  527  552  TMST
     I                                553  553  REPI
     I                                554  563 0ACOD
     I                                564  573 0LTAC
     I                                574  579  FCCU
     I                                580  580  COLF
     I                             P  581  588 0BCOA
     I                             P  589  596 0COLA
     I                                597  602  PFCU
     I                                603  605 0PFTP
     I                                606  607 0PFSQ
     I                                608  641  A5ACKY
     I                                642  642  A5INTL
     I                                643  646  A5TIAB
     I                                647  647  AUTH
     I                                648  648  K24C
     I                             P  649  651 0ACEFDT
     I                             P  652  657 7DCSP
     I                                658  658  DCSG
     I                                659  665  DRMT
     I                                666  669  DRFD
     I                             P  670  675 7CCSP
     I                                676  676  CCSG
     I                                677  683  CRMT
     I                                684  687  CRFD

     I/COPY WNCPYSRC,GL0600I004

     I                                  1  200  AREC1

     I/COPY WNCPYSRC,GL0600I005

     I                                201  687  AREC2

     I/COPY WNCPYSRC,GL0600I006

     I          NS  03    1 CX
     I                                  1    1  RECIAM
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ
     I                                  2   10  WNOCC1
     I                                 15   16 0WSEQ1
     I                                554  563 0WACOD1
     I                                 23   25  BRCA              03
     I                                 26   26  ATYP
     I                                 27   27  ASTYP
     I                                 29   29  ACST
     I                             P   30   32 0DACO
     I                             P   33   35 0DACC
     I                                 36   55  ANAM
     I**********                       39   43  TRAT                                       AR1097375
     I                             P   56   63 0LDBL
     I                             P   64   71 0CLBL
     I                                 72   72  STFQ
     I                                 73   74 0DMST
     I                             P   75   77 0LSTD
     I                             P   78   80 0NSTD
     I                             P   81   82 0LSTP
     I                             P   83   90 0CFSB
     I                             P   91   93 0LMVD
     I                             P   94  101 0EPLB
     I                             P  102  109 0EPCB
     I                             P  110  117 0YTDB
     I                                118  118  GLBT
     I                                119  126  ADREF1
     I                             P  135  137 0ORED
     I                             P  138  140 0DLIM
     I                             P  141  143 0LRCR
     I                             P  144  151 0RTCB
     I                             P  152  159 0RTLB
     I                             P  160  166 0DITM
     I                             P  167  173 0CITM
     I                                174  175  ADREF2
     I                             P  178  183 7CDIR
     I                             P  184  189 7CCIR
     I                                190  199 0ACNO
     I                                200  200  RETB
     I                                201  201  ODSC
     I                             P  202  207 0ODLN
     I                             P  208  210 0ODED
     I                             P  211  212 0DIOD
     I                                213  215 0FACT
     I                                216  217 0FCNO
     I                                218  219 0EFAC
     I                             P  220  227 0HELD
     I                             P  228  233 0MINB
     I                             P  234  236 0LACD
     I                             P  237  238 0LISP
     I                                242  243 0DRIB
     I                             P  244  249 7DRIS
     I                             P  250  252 0DRCD
     I                                253  253 0DRIC
     I                                254  254  DRIF
     I                                255  256 0DRDY
     I                             P  257  259 0NDID
     I                             P  260  262 0LDID
     I                             P  263  269 0LDIA
     I                                270  270  SDAP
     I                             P  271  273 0LPAR
     I                             P  274  280 0DIIE
     I                             P  281  288 0DAIC
     I                             P  289  295 0MADI
     I                             P  296  302 0GADI
     I                                303  303  DDIS
     I                             P  304  306 0DDIA
     I                             P  307  309 0OLDR
     I                                310  311 0OLDB
     I                             P  312  317 7OLDS
     I                                318  319 0CRIB
     I                             P  320  325 7CRIS
     I                             P  326  328 0CRCD
     I                                329  329 0CRIC
     I                                330  330  CRIF
     I                                331  332 0CRDY
     I                             P  333  335 0NCID
     I                             P  336  338 0LCID
     I                             P  339  345 0LCIA
     I                                346  346  SCAP
     I                             P  347  349 0LPAP
     I                             P  350  356 0CIIE
     I                             P  357  364 0CAIC
     I                             P  365  371 0MACI
     I                             P  372  378 0GACI
     I                                379  379  CDIS
     I                             P  380  382 0DCIA
     I                             P  383  385 0OLCR
     I                                386  387 0OLCB
     I                             P  388  393 7OLCS
     I                             P  394  396 0LCD
     I                                397  397  CHTP
     I                             P  398  400 0TNLU
     I                                401  401  BRTCA
     I                                402  402  NACSG
     I                                403  403  R4ACNT
     I                             P  404  405 0ENOC
     I                             P  406  407 0EPNO
     I                             P  408  415 0ECFB
     I                                416  418  LTAB
     I                                419  422 0LTACQQ
     I                                423  424 0LTAS
     I                                433  436  PTFR
     I                                437  437  HLEX
     I                                438  438  A5TIAC
     I                                439  444  A5TIAN
     I                                445  447  A5TIAS
     I                                448  448  EUSB
     I                                449  482  IBAN
     I                                483  485  IBSEQN
     I                                486  505  FRNT
     I                                506  525  AFRT
     I                                526  526  REPA
     I                                527  552  TMSTX
     I                             Z  527  552  TMST
     I                                553  553  REPI
     I                                554  563 0ACOD
     I                                564  573 0LTAC
     I                                574  579  FCCU
     I                                580  580  COLF
     I                             P  581  588 0BCOA
     I                             P  589  596 0COLA
     I                                597  602  PFCU
     I                                603  605 0PFTP
     I                                606  607 0PFSQ
     I                                608  641  A5ACKY
     I                                642  642  A5INTL
     I                                643  646  A5TIAB
     I                                647  647  AUTH
     I                                648  648  K24C
     I                             P  649  651 0ACEFDT
     I                             P  652  657 7DCSP
     I                                658  658  DCSG
     I                                659  665  DRMT
     I                                666  669  DRFD
     I                             P  670  675 7CCSP
     I                                676  676  CCSG
     I                                677  683  CRMT
     I                                684  687  CRFD
     I                                  1  200  AREC1
     I                                201  687  AREC2

     ISACPO     NS  05    1 CP
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ

     I                                  2   10  WNOCC2
     I                                 15   16 0WSEQ2
     I                                590  599 0WACOD2

     I                                 23   32 0ACNOP
     I                             P   33   35 0PSTD
     I                             P   36   38 0VALD
     I                                 39   43  TRAT
     I                                 44   49  DLNO
     I                                 44   46  SUSI
     I                                 64   69  SUSN
     I                             P   74   80 0PSTA
     I                                 81   81 0DRCR
     I                                 96  102  SPOS
     I                                103  105  BRCDP             05
     I**********                      106  106 0RIND                               MD037555 MD045515
     I                                124  124  ATYPP
     I                                128  128  PRIN
     I                                129  129  GETP
     I                                131  134  PRFC
     I                                216  230  OTRFQQ
     I                                231  240  OTST
     I                                241  250  OTTP
     I                             P  251  258 0SDCB
     I                             P  259  266 0SDLB
     I                                267  268  BOKC
     I                             P  269  271 0NITMS
     I                                272  272  REBI
     I                             P  273  279 0CHGA
     I                             P  310  316 0ORAMT

     I/COPY WNCPYSRC,GL0600I007

     I                                  1  250  LOTSA1
     I                                251  331  LOTSA2

     I                                 11   14 0ACODQQ
     I                                147  147 0LTAI
     I                             P  310  316 0ORAMT
     I                                320  329 0XRFN
     I                                332  351  ACKEY
     I                                352  352  FEEFLG
     I                             P  353  359 0FEEVAL
     I                                360  364  FEEPCT
     I                                365  384  RORACT
     I                                385  386  RORCTY
     I                                387  406  RORBNK
     I                                407  417  RORCDE
     I                                418  437  PORACT
     I                                438  439  PORCTY
     I                                440  459  PORBNK
     I                                460  470  PORCDE
     I                                471  505  DSTACT
     I                                506  507  DSTCTY
     I                                508  527  DSTBNK
     I                             P  528  530 0SETDAT
     I                                531  540  TICKER
     I                                541  560  EXCHNG
     I                                561  573 2NOMINL
     I                                574  589  FDTRID
     I                                590  599 0ACOD
     I                                600  620  OTRF

      ** Rate change posting
     I          NS  06    1 CR
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ

     I                                  2   10  WNOCC2
     I                                 15   16 0WSEQ2
     I                                161  170 0WACOD2

     I                                 23   32 0ACNOP
     I                             P   33   35 0PSTD
     I                             P   36   38 0VALD

     I/COPY WNCPYSRC,GL0600I003

     I                             P  239  241 0RRNM
     I                                 81   81 0DRCR
     I                                 96  102  SPOS
     I                                103  105  BRCDP             06
     I                                124  124  ATYPP
     I                                128  128  PRIN
     I                                  1  250  LOTSA1
     I                                251  331  LOTSA2
     I                                 11   14 0ACODQQ
     I                                147  147 0LTAI
     I                             P  310  316 0ORAMT
     I                                320  329 0XRFN
     I                                332  351  ACKEY
     I                                352  352  FEEFLG
     I                             P  353  359 0FEEVAL
     I                                360  364  FEEPCT
     I                                365  384  RORACT
     I                                385  386  RORCTY
     I                                387  406  RORBNK
     I                                407  417  RORCDE
     I                                418  437  PORACT
     I                                438  439  PORCTY
     I                                440  459  PORBNK
     I                                460  470  PORCDE
     I                                471  505  DSTACT
     I                                506  507  DSTCTY
     I                                508  527  DSTBNK
     I                             P  528  530 0SETDAT
     I                                531  540  TICKER
     I                                541  560  EXCHNG
     I                                561  573 2NOMINL
     I                                574  589  FDTRID

      ** Catchall
     I          NS  07

     I/COPY WNCPYSRC,GL0600I008

      ** REIAC - Retail interest and charges
     IREIAC     NS
     I                                  1    1  RECI
     I                                  2    7  CNUM
     I                                 24   38  DACPQQ
     I                                 48   62  CACPQQ
     I                                 72   86  CHACQQ
     I                                111  113  BRCA
     I                                135  137  WDRBR
     I                                138  140  WCRBR
     I                                141  143  WCHBR
     I                                156  176  WDACP
     I                                177  197  WCACP
     I                                198  218  WCHAC
     I                                  1  143  LOTIAC

      ** REIAC2 - Retail interest and charges for alternate account
     IREIACD2F
     I              RECI                        RECI2
     I              CNUM                        CNUM02
     I              CCY                         CCY2
     I              ACOD                        ACOD2
     I              ACSQ                        ACSQ2
     I              DACP                        WDACP2
     I              CACP                        WCACP2
     I              CHAC                        WCHAC2
     I              BRCA                        BRCA2

     IREACR     NS  10    1 CD
     I                                  1    1  RECI
     I                                  2    7  CNUM
     I                                 11   14 0ACODQQ
     I                                 17   19  BRCA
     I                                182  191 0ACOD

     I                                  1  172  LOTACR

      ** Trailer
     I          NS  11    1 CZ
     I                             P   31   33 0TNLU
     I                                 34   34  IRRI
     I                             P   35   37 0NREC

     I                                  1  128  LOTACZ

      ** Catchall
     I          NS
     I                                  1    1  RECI

     IGLSYSOXF
     I              NORE1                       NORESY

     IGLCLEAZF
     I              NORE1                       NORECL
     I              HRWN                        HRWNCL
     I              HRDC                        HRDCCL

     I***GLOUTLT0                                                                           MD031057
     I**********    GNREC                       LNORE                                       MD031057
     I**********    GHWNP                       HWNP                                        MD031057
     I**********    GHDCP                       HDCP                                        MD031057
     I**********    GHWNT                       HWNT                                        MD031057
     I**********    GHDCT                       HDCT                                        MD031057

     IACCNTL0   NS
     I                             P   56   63 0O_LDBL
     I                                  1  200  AREC3
     I                                201  687  AREC4

     IRECOMDF       17

      ** Rename ACNUMABF Format fields - ACNUM file
     IACNUMABF
     I              RECI                        RRRECI
     I              ACNO                        RACNO
     I              CNUM                        WCNUM
     I              CCY                         WCCY
     I              ACOD                        WACOD
     I              ACSQ                        WACSQ
     I              ATYP                        RATYP
     I              BRCA                        WBRCA
     I              ACST                        #ACST
     I              LCD                         #LCD
     I              CHTP                        #CHTP
     I              MFFQ                        #MFFQ
     I              TNLU                        #TNLU
     I              PTFR                        #PTFR
     I              RRNM                        #RRNM
     I              DACO                        #DACO
     I              ANAM                        #ANAM
     I              CLBL                        #CLBL
     I              RETB                        #RETB
     I              ODLN                        #ODLN
     I              ODED                        #ODED
     I              HELD                        #HELD
     I              MINB                        #MINB
     I              DRIF                        #DRIF
     I              LDID                        #LDID
     I              CRIF                        #CRIF
     I              LCID                        #LCID
     I              STYP                        #STYP

      ** Rename fields from REHISBL
     IREHISPPF
     I              RECI                        BRECI
     I              ZZ001                       BZZ001
     I              BRCA                        BBRCA
     I              CNUM                        BCNUM
     I              CCY                         BCCY
     I              ACOD                        BACOD
     I              ACSQ                        BACSQ
     I              HISD                        BHISD
     I              HISB                        BHISB
     I              MNBL                        BMNBL
     I              CHGAR                       BCHGAR
     I              TCHGAR                      BTCHGR
     I              CHGAN                       BCHGAN
     I              TCHGAN                      BTCHGN
     I              DMVT                        BDMVT
     I              DICT                        BDICT
     I              DRCB                        BDRCB
     I              DRIR                        BDRIR
     I              DRCD                        BDRCD
     I              DAID                        BDAID
     I              MADI                        BMADI
     I              TMADI                       BTMADI
     I              PDID                        BPDID
     I              DMINT                       BDMINT
     I              CMVT                        BCMVT
     I              CICT                        BCICT
     I              CRCB                        BCRCB
     I              CRIR                        BCRIR
     I              CRCD                        BCRCD
     I              CAID                        BCAID
     I              MACI                        BMACI
     I              TMACI                       BTMACI
     I              PCID                        BPCID
     I              CMINT                       BCMINT
     I              DICI                        BDICI
     I              CICI                        BCICI
     I              DRCI                        BDRCI
     I              CRCI                        BCRCI
     I              VDTC                        BVDTC
     I              ADTY                        BADTY
     I              ALTI                        BALTI
     I              MNBCP                       BMNBCP
     I              LGID                        BLGID
     I              VALL                        BVALL
     I              LINK                        BLINK
     I              ZZ008                       BZ008

     IACCBAABF
     I              EFAC                        EFAC2

     I/COPY WNCPYSRC,GL0600I001

     C     *DTAARA       DEFINE                  LDA

     C     COMKEY        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ

     C                   Z-ADD     0             RRN               9 0


     C/COPY WNCPYSRC,GL0600CCP6

     C     KEYAC         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA

     C                   EXSR      FIRST1
     C   U7
     CAN U8              GOTO      END

     C     1             SETLL     GLACPOPD                                                 MD021994
     C                   READ      GLACPOPD                                                 MD021994
     C                   IF        %EOF(GLACPOPD)                                           MD021994
     C                   EVAL      *INLR = *ON                                              MD021994
     C                   GOTO      ENDPGM                                                   MD021994
     C                   ENDIF                                                              MD021994
                                                                                            MD021994
     C     GLFERN        SETLL     ZACCNTAB
     C                   SETOFF                                       0203
     C                   READ      ZACCNTAB
     C                   DOW       NOT %EOF(ZACCNTAB) AND RRN <= GLTERN

      ** Setup Output Image of ACCNTAB from Driver File

     C                   EVAL      AREC1O = AREC1
     C                   EVAL      AREC2O = AREC2

     C     DSCOMK        CHAIN     ACCNTL0
     C                   IF        %FOUND(ACCNTL0)
     C                   Z-ADD     O_LDBL        SVLDBL           15 0
     C                   ENDIF

     C/COPY WNCPYSRC,GL0600CCP7

     C                   SETOFF                                       8081

      ** Ind 38 should retain setting to enable re-opened A/CS to be
      ** output to S/SYSOP if required

     C                   SETOFF                                       3637
     C                   SETOFF                                       838485
     C                   SETOFF                                       86  88

     C/COPY WNCPYSRC,GL0600CADO

      ** Set on indicator for existing account.

     C  N02
     CANN03              GOTO      END

     C     ATYP          COMP      'R'                                    20
     C/COPY WNCPYSRC,GL0600C018
     C     NSTD          COMP      0                                      43

      ** ACCUM. Ledger balance on I/P S/ACCNT

     C     LDBL          DIV       1000          ZZAMT                  41
     C   41              Z-SUB     ZZAMT         ZZAMT
     C   41              Z-ADD     11            X                 2 0
     C  N41              Z-ADD     12            X
     C                   EXSR      HASH

     C     TNRR          ADD       1             TNRR
     C     TNRW          ADD       1             TNRW
     C     RECIAM        COMP      'D'                                    25
     C**********         IF        (*IN25 = *ON AND *INU1 = *ON)                           AR1097218
     C*****TNOA*         ADD       1             TNOA                                      AR1097218
     C**********         ENDIF                                                             AR1097218

     C/COPY WNCPYSRC,GL0600C013
     C/COPY WNCPYSRC,GL0600CCPG

     C     TMSTX         IFEQ      *BLANKS
     C                   MOVE      TSTAMP        TMST
     C                   ENDIF

      ** Postings

     C     T1POST        TAG

     C                   SETOFF                                       767778

     C     DSCOMK        SETLL     SACPO
     C     DSCOMK        READE     SACPO                                  32
     C     *IN32         DOWEQ     *OFF
     C                   SETON                                        76

      ** Account Master with Posting
      ** Reopen if Non-Retail Account closed

     C     *IN78         IFEQ      *OFF
     C  N03
     CANN25
     CAN 20              SETON                                        99
     C   99              MOVE      *BLANKS       DBERR
     C   99              MOVEL     ACNK          W@ACKY           24
     C   99              MOVE      BRCA          W@ACKY
     C   99              MOVEL     'REOPN'       DBFILE
     C   99              MOVEL     W@ACKY        DBKEY
     C   99              MOVEL     '020'         DBASE
     C  N03
     CANN25
     CANN20              EXSR      REOPEN
     C                   SETON                                        78
     C                   ENDIF

     C     DRCR          COMP      0                                  3535
     C     SPOS          COMP      '  GE-DL'                              30
     C  N30SPOS          COMP      '  GE-CL'                              30
     C  N30SPOS          COMP      '  GE-CO'                              30
     C  N30SPOS          COMP      '  GE-LE'                              30
     C  N30SPOS          COMP      '  GE-BC'                              30
     C  N30SPOS          COMP      '  GE-BX'                              30
     C  N30SPOS          COMP      '  GE-ST'                              30
     C  N30SPOS          COMP      '  GE-FF'                              30
     C  N30SPOS          COMP      '  GE-CM'                              30

     C/COPY WNCPYSRC,GL0600CP13

     C  N30              MOVE      '      '      DLNO
     C   30SUSI          COMP      'SUS'                                  30
     C   30              MOVE      SUSN          DLNO

      ** If posting is Security Trading or Customer Exchange then
      ** move the first six characters of the Original Transaction
      ** Reference (from SACPO) into the Deal Number.

     C     SPOS          COMP      '  GE-ST'                              31
     C  N31SPOS          COMP      '  GE-CE'                              31
     C   31              MOVEL     OTRF          DLNO

      ** If Deal Number is not numeric then set it to blanks.

     C                   MOVEL     DLNO          TEST              7
     C                   MOVE      '0'           TEST
     C                   TESTN                   TEST                 3131
     C  N31              MOVE      '      '      DLNO

     C     TNPR          ADD       1             TNPR
     C   38              GOTO      T5A

     C     TMSTX         IFEQ      *BLANKS
     C                   MOVE      TSTAMP        TMST
     C                   ENDIF

     C  N03              GOTO      T6
     C   77              GOTO      T6
     C                   SETON                                        77

      ** Posting for non-retail account which does not exist - so open it
      ** database error if retail A/C to be Opened.

     C     ATYPP         COMP      'R'                                    99
     C   99              MOVE      *BLANK        DBERR
     C   99              MOVEL     ACPOKY        W@ACKY
     C   99              MOVE      BRCDP         W@ACKY
     C   99              MOVEL     'OPEN '       DBFILE
     C   99              MOVEL     W@ACKY        DBKEY
     C   99              MOVEL     '021'         DBASE
     C   99              EXSR      *PSSR
     C   99              GOTO      END

     C/COPY WNCPYSRC,GL0600CP20

      ** Set off ind to signify non-retail.
     C                   SETOFF                                       20

      ** Zeroise balances and interest rates

     C                   Z-ADD     0             CLBL
     C                   Z-ADD     0             LDBL
     C                   Z-ADD     0             CCIR
     C                   Z-ADD     0             CDIR
     C                   Z-ADD     0             LMVD

     C/COPY WNCPYSRC,GL0600C014

     C/COPY ZSRSRC,DFTTSTAMPE

     C                   MOVE      *BLANKS       ADREF1
     C                   MOVE      *BLANKS       ADREF2
     C                   MOVEL     'B'           ADREF1
     C                   MOVE      'D'           RECIAM
     C                   MOVE      ACPOKY        ACNK
     C                   MOVE      BRCDP         BRCA
     C                   MOVE      ' '           ACST
     C                   Z-ADD     RUND          DACO
     C                   MOVE      BKDSFC        STFQ
     C                   Z-ADD     RUND          LSTD

     C/COPY WNCPYSRC,GL0600CP17

     C                   Z-ADD     BKAPDT        NSTD

      ** Calculate next statement date if daily accruals

     C                   Z-ADD     RUND          ZDAYNO
     C                   MOVE      STFQ          ZFREQ
     C                   MOVE      CCY           ZCCY

      ** Move the system location to the ZLOC field.

     C                   MOVE      BJSLCD        ZLOC
     C                   EXSR      ZFREQS

     C     *IN99         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   MOVE      '1'           *INU7
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF
      *                                                                                     AR954846
      **Set NSTD = RUND for STFQ = 'D'                                                      AR954846
      *                                                                                     AR954846
     C     STFQ          IFEQ      'D'                                                      AR954846
     C                   Z-ADD     RUND          NSTD                                       AR954846
     C                   ELSE                                                               AR954846
     C                   Z-ADD     ZDAYNO        NSTD
     C                   ENDIF                                                              AR954846

      ** If not daily post and accrual date before DNWD, set NSTD to DNWD

     C  NU1
     CANN23BJDNWD        COMP      BKAPDT                             47

     C     *INU1         IFEQ      '0'
     C     *IN23         ANDEQ     '0'
     C     *IN47         ANDEQ     '1'
     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   EXSR      ZFREQS
     C                   Z-ADD     ZDAYNO        NSTD
     C                   ENDIF

     C/COPY WNCPYSRC,GL0600CP18

     C                   BITOFF    '01234567'    GLBT
     C                   BITOFF    '01234567'    RETB

     C                   BITON     '2'           GLBT
     C                   MOVE      ATYPP         ATYP
     C                   Z-ADD     RUND          LCD
     C                   Z-ADD     0             LTAC
     C                   Z-ADD     0             LTAS
     C                   Z-ADD     RUND          ORED
     C                   Z-ADD     0             DITM
     C                   Z-ADD     0             CITM
     C                   Z-ADD     0             DAIC
     C                   Z-ADD     0             CAIC
     C                   Z-ADD     0             ENOC
     C                   Z-ADD     0             EPNO
     C                   Z-ADD     0             ECFB
     C                   MOVE      'I'           CHTP

     C                   MOVEL     *BLANK        BRTCA
     C                   MOVEL     *BLANK        NACSG

     C                   MOVEL     *BLANKS       IBAN
     C                   MOVEL     *BLANKS       IBSEQN

     C     TNAO          ADD       1             TNAO
     C     TNOA          ADD       1             TNOA
     C     TNRW          ADD       1             TNRW

      ** Initialise A/C subtype to blank when opening an account

     C                   MOVE      *BLANKS       ASTYP

     C/COPY WNCPYSRC,GL0600CCP1                                           S01408

     C     T5A           TAG
     C  N35              Z-ADD     PSTA          PSTAOP           13 0
     C   35              Z-SUB     PSTA          PSTAOP

     C/COPY WNCPYSRC,GL0600CP10                                           S01408

      ** If Posting_Amount_Equal_Zeros_DONOT_Update_Last_Activity_Date

     C     PSTA          IFNE      *ZEROS
     C                   Z-ADD     RUND          LACD
     C                   ENDIF

     C                   Z-ADD     ACNOP         ACNO
     C                   SETON                                        25

      ** Obtain account name for new accounts
      ** from account codes on table file

     C     *IN38         IFEQ      '0'
     C                   MOVEL     ACOD          ACODX            10
     C                   CALLB     'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ACODX         @ACCD            10
     C     SDACOD        PARM      SDACOD        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        U7U8LR
     C                   MOVE      *BLANKS       DBERR
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   MOVEL     ACODX         DBKEY
     C                   MOVEL     '010'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     A5ACCN        ANAM
     C     WPB004        IFEQ      'Y'
     C                   EXSR      REPLIC
     C                   ENDIF
     C     ATYP          IFEQ      ' '
     C                   MOVE      A5ACTY        ATYP
     C                   MOVE      A5ACTY        ATYPP
     C                   ENDIF
     C                   ENDIF

     C     ATYP          IFEQ      'N'
     C     ATYP          OREQ      'R'
     C                   MOVE      *ON           *IN29
     C                   ELSE
     C                   MOVE      *OFF          *IN29
     C                   ENDIF

     C     STFQ          IFEQ      'Z'
     C                   Z-ADD     *ZEROS        NSTD
     C                   MOVE      *ON           *IN43
     C                   ENDIF

     C                   SETOFF                                       38
     C                   SETON                                        85

      ** When opening new accounts in ACCNTAB, write a corresponding
      ** record in the account details extension file GLACNTQD

     C     KGLACT        KLIST
     C                   KFLD                    F1CNUM
     C                   KFLD                    F1CCY
     C                   KFLD                    F1ACOD
     C                   KFLD                    F1ACSQ
     C                   KFLD                    F1BRCA

     C                   MOVE      CNUM          F1CNUM
     C                   MOVE      CCY           F1CCY
     C                   Z-ADD     ACOD          F1ACOD
     C                   Z-ADD     ACSQ          F1ACSQ
     C                   MOVE      BRCA          F1BRCA

     C     KGLACT        CHAIN     GLACNTD0                           82

     C     *IN82         IFEQ      *ON
     C                   Z-ADD     *ZERO         F1FCHD
     C                   Z-ADD     *ZERO         F1LFCD
     C                   Z-ADD     *ZERO         F1ACBL
     C                   Z-ADD     *ZERO         F1TEXO
     C                   Z-ADD     *ZERO         F1TEOF
     C                   Z-ADD     *ZERO         F1TEOC
     C                   Z-ADD     *ZERO         F1DECD                                       CRE090
     C                   Z-ADD     *ZERO         F1DRFD                                       CRE095
     C                   Z-ADD     *ZERO         F1DNFD                                       CRE095
     C                   Z-ADD     *ZERO         F1DNFM                                       CRE095
     C                   Z-ADD     *ZERO         F1CRFD                                       CRE095
     C                   Z-ADD     *ZERO         F1CNFD                                       CRE095
     C                   Z-ADD     *ZERO         F1CNFM                                       CRE095
     C                   WRITE     GLACNTD0
     C/COPY WNCPYSRC,GLH00527
     C                   ENDIF

     C/COPY WNCPYSRC,GL0600C005

      ** Processing Postings

     C     T6            TAG

      ** Make sure posting and account to be posted have the same branch
      ** code, otherwise, data base error.

     C     BRCDP         COMP      BRCA                               9999
     C     *IN99         IFEQ      '1'
     C                   MOVE      *BLANK        DBERR
     C                   MOVEL     ACPOKY        W@ACKY
     C                   MOVE      BRCDP         W@ACKY
     C                   MOVEL     'SACPO'       DBFILE
     C                   MOVEL     W@ACKY        DBKEY
     C                   MOVEL     '022'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF

      ** Sort retail from non-retail postings and balance from rate changes

     C   05              GOTO      T19

      ** Rate change posting - update relevant rate change dates

     C   35              MOVE      VALD          CRCD
     C   35              MOVE      VALD          OLCR
     C  N35              MOVE      VALD          DRCD
     C  N35              MOVE      VALD          OLDR
     C                   GOTO      T21

      ** Postings Update

     C     T19           TAG
0133
0133  ** Determine if posting to be written to account
0133
0134 C                   SETOFF                                       27
0135 C                   TESTB     '6'           PRIN                     27
0133
0133  ** Accumulate postings read, COB & IC
0133
0133 C     *IN27         IFEQ      '1'
0133 C     TNPRI         ADD       1             TNPRI
0133 C                   ELSE
0133 C     TNPRC         ADD       1             TNPRC
0133 C                   ENDIF
0133
     C                   Z-ADD     7             X
     C     PSTA          DIV       1000          ZZAMT
     C                   EXSR      HASH

      ** Check amounts & dates

     C     T19A          TAG

      ** Retrieve customer-originated indicator of transaction type

     C                   MOVE      *BLANKS       WCOIN             1
     C     TRAT          IFNE      '00000'
     C     TRAT          ANDNE     *BLANKS
     C                   EXSR      SDRET
     C                   ENDIF

     C                   TESTB     '4'           PRIN                 60
     C**N60*****         SETOFF                                       22           MD028392 MD037046
     C***60*****         SETON                                        22           MD028392 MD037046
      *                                                                                     MD037046
      ** Check if already posted to Ledger and Cleared Balance                              MD037046
      *                                                                                     MD037046
     C**********         TESTB     '6'           PRIN                 22           MD037046 MD037555
     C                   SETOFF                                       22                    MD045515
     C     VALD          IFGT      RUND                                                     MD045515
     C     VALD          ANDLE     BKAPDT                                                   MD045515
     C     *IN60         ANDEQ     *OFF                                                     MD045515
     C     *IN27         ANDEQ     *ON                                                      MD045515
     C                   SETON                                        22                    MD045515
     C                   ENDIF                                                              MD045515
     C/COPY WNCPYSRC,GL0600C008
     C   20VALD          COMP      NWKD                                 61
     C   20
     CAN 61VALD          COMP      BKAPDT                               6161
     C  N20              SETON                                        61
     C/COPY WNCPYSRC,GL0600C009

      ** If next working date outward clearing.

     C     *INU4         IFEQ      *ON
     C                   SETOFF                                       18
     C**********N61VALD  COMP      NWKD                                   18                MD048056
      ** Set on IN18 when value date is less than or equal to NWKD.                         MD048056
     C  N61VALD          COMP      NWKD                                 1818                MD048056
     C                   ENDIF
     C     PSTD          COMP      LMVD                               62
     C   62
     CAN 60              Z-ADD     PSTD          LMVD
     C   35              GOTO      T20

      ** Process debit

     C   60
     CAN 05
     CANN27LDBL          ADD       PSTA          LDBL
     C   61
     CAN 05
     C***ANN27CLBL          ADD       PSTA          CLBL                                    MD045515
     CANN27                                                                                 MD045515
     COR 61                                                                                 MD045515
     CAN 05                                                                                 MD045515
     CAN 22              ADD       PSTA          CLBL                                       MD045515
     C/COPY WNCPYSRC,GL0600C010
     C     *INU4         IFEQ      *ON
     C     *IN27         IFEQ      *OFF
     C     *IN05         ANDEQ     *ON

     C   18
     COR 61              EXSR      ACCROU
     C   18
     CANN36
     COR 61
     CANN36GRCLT         COMP      'Y'                                    36
     C   18
     CAN 36GPAMT         SUB       PSTA          GPAMT            15 0

     C                   ENDIF
     C                   ENDIF

     C  N27              Z-ADD     5             X
     C   27              Z-ADD     13            X
     C                   GOTO      T21

      ** Process Credits

     C     T20           TAG
     C   60
     CAN 05
     CANN27LDBL          SUB       PSTA          LDBL
     C   61
     CAN 05
     C***ANN27CLBL          SUB       PSTA          CLBL                                    MD045515
     CANN27                                                                                 MD045515
     COR 61                                                                                 MD045515
     CAN 05                                                                                 MD045515
     CAN 22              SUB       PSTA          CLBL                                       MD045515
     C/COPY WNCPYSRC,GL0600C011
     C     *INU4         IFEQ      *ON
     C     *IN27         IFEQ      *OFF
     C     *IN05         ANDEQ     *ON

     C   18
     COR 61              EXSR      ACCROU
     C   18
     CANN36
     COR 61
     CANN36GOCLR         COMP      'Y'                                    36
     C   18
     CAN 36GPAMT         ADD       PSTA          GPAMT

     C                   ENDIF
     C                   ENDIF

     C  N27              Z-ADD     6             X
     C   27              Z-ADD     14            X

     C     PSTD          COMP      LRCR                               35

      ** The following part finds out whether or not the credit
      ** movement is customer originated. this is done so that
      ** the bank can differentiate between a bank credit
      ** movement and a customer credit movement and hence will
      ** be able to tell when an account is dormant i.e. when
      ** it has been 'X' months since an account has last been used

     C   35              TESTB     '0'           PRIN                     63

      ** Revalidate if posting is customer originated of not.

     C     *IN35         IFEQ      '1'
     C     *IN63         ANDEQ     '0'
     C     WCOIN         ANDEQ     'Y'
     C                   MOVE      '1'           *IN63
     C                   ENDIF

     C   35
     CAN 63              TESTB     '4'           PRIN                 63
     C   35
     CAN 63              Z-ADD     PSTD          LRCR
     C  N35              SETON                                        35

     C     T21           TAG
     C   05PSTA          DIV       1000          ZZAMT
     C   60
     CAN 05              EXSR      HASH
     C**********         TESTB     '0'           PRIN                     63                  256758
     C                   MOVE      '0'           *IN63                                        256758

     C******IN63         IFEQ      '0'                                                        256758
     C*****WCOIN         ANDEQ     'Y'                                                        256758
     C     WCOIN         IFEQ      'Y'                                                        256758
     C     *IN05         ANDEQ     '1'
     C                   MOVE      '1'           *IN63
     C                   ENDIF

     C   63              TESTB     '4'           PRIN                 63
     C   63PSTD          COMP      LACD                               63

      ** If Posting amount equal zeros DO NOT Update Last Activity Date

     C     PSTA          IFNE      *ZEROS

     C   63              Z-ADD     PSTD          LACD
     C     *IN63         IFEQ      '1'                                                        240699
     C     *IN20         ANDEQ     '1'                                                        240699
     C                   BITOFF    '4'           RETB                                         240699
     C                   ENDIF                                                                240699

     C                   ENDIF
     C/COPY WNCPYSRC,GL0600C015

      ** Database error if retail posting & not main post or eop post

     C   20
     CANNU5              SETON                                        99

      ** If posting for retail a/c not in correct post

     C   99              MOVEL     ACNK          W@ACKY
     C   99              MOVE      BRCA          W@ACKY
     C   99              MOVE      *BLANK        DBERR
     C   99              MOVEL     'SACPO'       DBFILE
     C   99              MOVEL     W@ACKY        DBKEY
     C   99              MOVEL     '004'         DBASE
     C   99              EXSR      *PSSR
     C   99              GOTO      END

      ** Set on indicator to signify post

     C                   BITON     '4'           PRIN

      ** Set BIT 6 off on CLEARPD to enable future CLBL Update.

     C                   BITOFF    '6'           PRIN
      **RIND*from*CLEARPD*is*not*set*to*1*to*avoid*duplicate*entry*in*Retail*historMD037555 MD045515
      **Use*it*to*not*output*in*CLEARPD*for*in*following*days.**Record*from*MANPOPDMD037555 MD045515
      **will*be*used*instead*******************************************            MD037555 MD045515
     C*****RIND          IFEQ      1                                               MD037555 MD045515
     C**********         SETON                                        22           MD037555 MD045515
     C**********         ELSE                                                      MD037555 MD045515
     C**********         SETOFF                                       22           MD037555 MD045515
     C**********         END                                                       MD037555 MD045515

      ** Output Retail to clear, only if balance posting

     C                   MOVE      *OFF          *IN88                                        CRE095
     C     *IN27         IFEQ      *OFF                                                     MD045515
     C     *IN60         OREQ      *ON                                                      MD045515
      *                                                                                     MD045515
     C  N61
     CAN 20
     C***AN*05**         SETON                                        88                    MD028392
     C***AN*05**                                                                   MD028392 MD045515
     C***AN*22**         SETON                                        88           MD028392 MD045515
     CAN 05              SETON                                        88                    MD045515
     C                   ENDIF                                                              MD045515
     C/COPY WNCPYSRC,GL0600C019
     C   88              SETON                                        53
     C   88TNPIC         ADD       1             TNPIC
     C   88              Z-ADD     9             X
     C   88PSTA          DIV       1000          ZZAMT
     C   88              EXSR      HASH
     C   88
     CAN U5              EXCEPT    EXCPT4

     C/COPY WNCPYSRC,GL0600CP22

      ** File controls for last posting for this account, or account with
      ** no posting

     C                   SETOFF                                       0506                  MD020105
     C     DSCOMK        READE     SACPO                                  32
     C                   ENDDO

     C     T24           TAG

      ** Set on ind to output to acord.

     C     ATYP          IFNE      'R'
     C                   Z-ADD     0             ACNO
     C                   ENDIF
     C                   SETON                                        81

     C/COPY WNCPYSRC,GL0600CP12

     C                   IF        (*IN03 = *OFF AND SVLDBL <> LDBL)
     C                   Z-ADD     SVLDBL        ZZAMTSUB         15 0
     C     SVLDBL        COMP      0                                    75
     C   75              Z-SUB     ZZAMTSUB      ZZAMTSUB
     C   75              Z-ADD     3             X
     C  N75              Z-ADD     4             X
     C                   EXSR      HASHSUB
     C                   ENDIF

     C                   IF        *IN03 = *ON  OR (*IN03 = *OFF
     C                             AND SVLDBL <> LDBL)
     C     LDBL          DIV       1000          ZZAMT
     C     LDBL          COMP      0                                    75
     C   75              Z-SUB     ZZAMT         ZZAMT
     C   75              Z-ADD     3             X
     C  N75              Z-ADD     4             X
     C                   EXSR      HASH
     C                   ENDIF

     C/COPY WNCPYSRC,GL0600CP11

      ** Hash Total for S/Outcl

     C     *INU4         IFEQ      *ON
     C     GPAMT         COMP      0                                  39
     C  N39GTAMT         COMP      0                                  39
     C   39LNORE         ADD       1             LNORE
     C   39              EXSR      LHASH
     C                   ENDIF

     C  NU1              GOTO      END

      ** Daily processing - check to see if account flagged for closing

     C     CSD023        IFEQ      'Y'
     C                   MOVE      CNUM          @CUST1            6
     C                   MOVE      @CUST         @CUST2            6
     C     @CUST1        IFNE      @CUST2
     C     WPB004        ANDEQ     'Y'
     C                   EXSR      REPLIC
     C                   ENDIF
     C     BBTYLC        IFEQ      'A'
     C     BBLCD         ANDEQ     BJRDNB
     C     BBCLST        ANDEQ     'Y'
     C     BBCLDT        ANDEQ     BJRDNB
     C     ACST          ANDNE     'C'
     C     ACBAKY        CHAIN     ACCBAABF                           99
     C                   MOVE      'C'           ACST
     C                   UPDATE    ACCBAABF
     C                   ENDIF
     C                   ENDIF

     C                   SETOFF                                       70
     C     RECIAM        IFEQ      'D'
     C     ACST          ANDEQ     'C'
     C                   MOVE      '1'           *IN70

      ** Check if account can be closed. Produce statement regardless.

     C     LDBL          COMP      0                                  5656
     C  N56CLBL          COMP      0                                  5656

      ** If A/C has postings in clearing, do not close it

     C  N56
     CAN 53              SETON                                        56

     C     WPB004        IFEQ      'Y'
     C                   EXSR      REPLIC
     C                   ENDIF

      ** Unsuccessful closure of accounts

     C   56TNFTCA        ADD       1             TNFTCA
     C   56              MOVE      ' '           ACST
     C   56              Z-ADD     0             DACC

      ** Successful closure of accounts

     C  N56              MOVE      'C'           RECIAM
     C  N56              Z-ADD     RUND          DACC
     C  N56LMVD          COMP      LSTD                               52
     C  N56
     CAN 52              BITON     '1'           GLBT
     C  N56TNOA          SUB       1             TNOA

      ** If retail account, note account closed date on subsidiary files
      ** only if closed.

     C   20
     CANN56              EXSR      CLORET
     C   99              GOTO      END
     C                   ENDIF

     C/COPY WNCPYSRC,GL0600CCP2

      ** Produce no statement for closed accounts not closed today

     C/COPY WNCPYSRC,GL0600CP14

     C     RECIAM        IFEQ      'D'
     C     *IN70         OREQ      '1'

      ** If STFQ is N, set c/fwd statement balance equal to ledger balance

     C     STFQ          IFEQ      'N'
     C                   Z-ADD     LDBL          CFSB
     C                   Z-ADD     BJDNWD        NSTD
     C                   ENDIF

     C                   ENDIF

     C/COPY WNCPYSRC,GL0600CP15

      ** Updating Account Master

     C  N20              GOTO      END

      ** Clear A/C work indicator

     C                   SETOFF                                       53

      ** Days O/D now updated in RE0860

     C                   GOTO      END

      ** Updating file controls on trailer

     C     T33           TAG

      ** Output trailer.
      ** to allow for GL0600 being run more than once a day

     C  NU1              GOTO      END

     C     END           TAG
     C   37              MOVE      RECIAM        RECI
     C                   EVAL      DDIS_O = *BLANKS
     C                   EVAL      CDIS_O = *BLANKS

      ** Write/Update Account Master File

     C                   IF        *IN03 = *ON
     C                   EXCEPT    EXCPT6
     C                   EXSR      WRTSTMT                                                  MD038510
     C                   ELSE

     C                   IF        (AREC1O <> AREC3) or (AREC2O <> AREC4)
     C                   EXCEPT    EXCPT5
     C                   ENDIF
     C                   ENDIF

      ** SYSOPAJ

     C     *IN85         IFEQ      *ON
     C                   EXCEPT    EXCPTA1
     C                   ENDIF

      ** REOUTLPD

     C     *IN81         IFEQ      *ON
     C     *IN39         ANDEQ     *ON
     C     *INU4         ANDEQ     *ON
     C                   EXCEPT    EXCPTA2
     C                   ENDIF

      ** REIAC

     C     *IN37         IFEQ      *ON
     C                   EXCEPT    EXCPTA3
     C                   EVAL      ForceCommit = True                                       MD021994
     C                   ENDIF

      ** REACR

     C     *IN37         IFEQ      *ON
     C     *IN33         ANDEQ     *OFF
     C                   EXCEPT    EXCPTA4
     C                   ENDIF

      ** RECOMD

     C     *IN37         IFEQ      *ON
     C                   EXCEPT    EXCPTA5
     C                   ENDIF

     C
     C   99              SETON                                        U7LR
     C   99              GOTO      ENDPGM

     C                   SETOFF                                       0203
                                                                                            MD021994
     C                   EVAL      REC_CTR = REC_CTR + 1                                    MD021994
     C                   IF        REC_CTR = CommitSize                                     MD021994
     C                             OR ForceCommit                                           MD021994
     C     1             CHAIN     GLACPOPD                                                 MD021994
     C                   EVAL      GLFERN = RRN + 1                                         MD021994
     C                   UPDATE    GLACPOF                                                  MD021994
     C                   COMMIT                                                             MD021994
     C                   EVAL      REC_CTR = 0                                              MD021994
     C                   EVAL      ForceCommit = False                                      MD021994
     C                   ENDIF                                                              MD021994
                                                                                            MD021994
     C     RRN           IFLT      GLTERN                                                  AR1097401
     C                   READ      ZACCNTAB
     C                   ELSE                                                              AR1097401
     C     1             CHAIN     GLACPOPD                                                 MD021994
                                                                                            MD021994
     C                   IF        GLTERN <> *HIVAL                                         MD021994
     C                   EVAL      GLFERN = GLTERN + 1                                      MD021994
     C                   ELSE                                                               MD021994
     C                   EVAL      GLFERN = GLTERN                                          MD021994
     C                   ENDIF                                                              MD021994
                                                                                            MD021994
     C                   UPDATE    GLACPOF                                                  MD021994
     C                   LEAVE                                                             AR1097401
     C                   ENDIF                                                             AR1097401

     C                   ENDDO
                                                                                            MD021994
     C                   EVAL      *INLR = *ON                                              MD021994

     C     ENDPGM        TAG

     CLR   1             CHAIN     GLACCTAC                           89
     CLR                 SETON                                        80

      ** Trailer record found

     CLR   *IN89         IFEQ      *OFF
     CLR   NINP          ADD       TNAO          NINP
     CLR   NORD          ADD       TNAR          NORD
     CLR   NOCF          ADD       TNFTCA        NOCF
     CLR   NAMP          ADD       TNAA          NAMP
     CLR   NOCL          SUB       TROPEN        NOCL

      ** To allow for GL0600 being run more than once a day

     CLR   NAUP          ADD       TNOA          NAUP
     CLR                 Z-ADD     HWND          ZZTOTI
     CLR                 Z-ADD     HDCD          ZZTOTD
     CLR                 Z-ADD     INT(4)        ZZAMTI
     CLR                 Z-ADD     DEC(4)        ZZAMTD
     CLR                 EXSR      GLZSUM
     CLR                 Z-ADD     ZZTOTI        HWND
     CLR                 Z-ADD     ZZTOTD        HDCD
     CLR                 Z-ADD     HWNC          ZZTOTI
     CLR                 Z-ADD     HDCC          ZZTOTD
     CLR                 Z-ADD     INT(3)        ZZAMTI
     CLR                 Z-ADD     DEC(3)        ZZAMTD
     CLR                 EXSR      GLZSUM
     CLR                 Z-ADD     ZZTOTI        HWNC
     CLR                 Z-ADD     ZZTOTD        HDCC
     CLR                 UPDATE    GLACCTCF
     CLR                 ELSE
     CLR                 Z-ADD     TNAO          NINP
     CLR                 Z-ADD     TNAR          NORD
     CLR                 Z-ADD     TNFTCA        NOCF
     CLR                 Z-ADD     TNAA          NAMP
     CLR                 Z-SUB     TROPEN        NOCL
     CLR                 Z-ADD     TNOA          NAUP
     CLR                 Z-ADD     INT(4)        HWND
     CLR                 Z-ADD     DEC(4)        HDCD
     CLR                 Z-ADD     INT(3)        HWNC
     CLR                 Z-ADD     DEC(3)        HDCC
     CLR                 Z-ADD     *ZEROS        LCD                                        MD022971
     CLR                 Z-ADD     *ZEROS        TNLU                                       MD022971
     CLR                 Z-ADD     *ZEROS        NRET                                       MD022971
     CLR                 Z-ADD     *ZEROS        ACOD                                       MD022971
     CLR                 WRITE     GLACCTCF
     CLR                 ENDIF

      ** Reset trailer totals

     C/COPY WNCPYSRC,GL0600CP16

      ** Update SYSOPZX

     CLR   1             CHAIN     GLSYSOZX                           89
     CLR   TNAO          ADD       NORESY        FNAO              5 0
     CLR                 ADD       TNAR          FNAO
     CLR                 Z-ADD     FNAO          NORESY
     CLR   *IN99         IFEQ      *OFF
     CLR   *In89         IFEQ      *OFF
     CLR                 UPDATE    GLSYSOXF
     CLR                 ELSE
     CLR                 WRITE     GLSYSOXF
     CLR                 ENDIF
     CLR                 ENDIF

      ** Update CLEARZZ

     CLR U51             CHAIN     GLCLEAZZ                           89
     CLR U5TNPIC         ADD       NORECL        FNPIC             5 0
     CLR U5DEC(9)        ADD       HRDCCL        WRKN40            4 0

     CLR U5WRKN40        IFLT      1000
     CLR U5              ADD       HRWNCL        INT(9)
     CLR U5              ADD       HRDCCL        DEC(9)
     CLR                 ELSE
     CLR U5WRKN40        SUB       1000          WRKN40
     CLR U5              ADD       HRWNCL        INT(9)
     CLR U5              ADD       1             INT(9)
     CLR U5              Z-ADD     WRKN40        DEC(9)
     CLR                 ENDIF

     CLR U5*IN99         IFEQ      *OFF
     CLR U5              Z-ADD     FNPIC         NORECL
     CLR U5              Z-ADD     INT(9)        HRWNCL
     CLR U5              Z-ADD     DEC(9)        HRDCCL

     CLR U5*IN89         IFEQ      *OFF
     CLR U5              UPDATE    GLCLEAZF
     CLR                 ELSE
     CLR U5              WRITE     GLCLEAZF
     CLR                 ENDIF

     CLR                 ENDIF

     CLR U4*IN99         IFEQ      *OFF
     CLR U4              EVAL      GLOUTLDS.GNREC = LNORE                                   MD031057
     CLR U4              EVAL      GLOUTLDS.GHWNP = HWNP                                    MD031057
     CLR U4              EVAL      GLOUTLDS.GHDCP = HDCP                                    MD031057
     CLR U4              EVAL      GLOUTLDS.GHWNT = HWNT                                    MD031057
     CLR U4              EVAL      GLOUTLDS.GHDCT = HDCT                                    MD031057
     CLR U41             CHAIN     GLOUTLPT                           89
     CLR U4*IN89         IFEQ      *OFF
     C***LR*U4**            UPDATE    GLOUTLT0
     CLR U4              UPDATE    GLOUTLT0      GLOUTLDS                                   MD031057
     CLR                 ELSE
     C***LR*U4**            WRITE     GLOUTLT0                                              MD031057
     CLR U4              WRITE     GLOUTLT0      GLOUTLDS
     CLR                 ENDIF
     CLR                 ENDIF

      ** If any retail accounts closed, update REACR trailer record count

     CLR   CLOACR        COMP      0                                  39
     CLR 39              MOVE      *ALL'9'       ACRKEY           24
     CLR 39ACRKEY        CHAIN     REACR                              99
     CLR 39
     CAN 99              SETON                                        U7U8
     CLR 39
     CAN 99              MOVE      *BLANK        DBERR
     CLR 39
     CAN 99              MOVEL     'REACR'       DBFILE
     CLR 39
     CAN 99              MOVEL     ACRKEY        DBKEY
     CLR 39
     CAN 99              MOVEL     '090'         DBASE
     CLR 39
     CAN 99              EXSR      *PSSR
     CLR 39NREC          SUB       CLOACR        NREC
     CLR                 WRITE     CONTROL                                                  MD021994
     CLR                 CLOSE     GL0600AU                                                 MD021994
     CLR                 RETURN                                                             MD021994
      *****************************************************************
      *                                                               *
      *  FIRST1 - First cycle processing                              *
      *                                                               *
      *****************************************************************
     C     FIRST1        BEGSR
     C                   Z-ADD     1             I                 4 0
     C                   SETON                                        40
     C                   IF        PrintHeader                                              MD021994
     C                   OPEN      GL0600AU                                                 MD021994
     C                   WRITE     HEADAU                                                   MD021994
     C                   EVAL      PrintHeader = False                                      MD021994
     C                   ENDIF                                                              MD021994
                                                                                            MD021994
     C                   IN        CBTASKSP                                                 MD021994

     C/COPY WNCPYSRC,GL0600CCP8
     C                   Z-ADD     *ZEROS        ZERO01            1 0
     C                   MOVE      *BLANKS       BLANK2            2
     C                   MOVE      *BLANKS       BLANK6            6
     C                   MOVE      *BLANKS       BLAN20           20
     C                   Z-ADD     *ZEROS        ZERO02            2 0
     C                   Z-ADD     *ZEROS        ZERO04            4 0
     C                   Z-ADD     *ZEROS        ZERO15           15 0
     C                   Z-ADD     *ZEROS        ZERO16           16 0
     C                   Z-ADD     *ZEROS        ZERO05            5 0
     C                   MOVE      *BLANKS       BLNK21           21
     C                   MOVE      *BLANKS       BLAN15           15
     C                   MOVE      *BLANKS       BLANK3            3

     C/COPY ZSRSRC,DFTTSTAMPE

     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
     C                   MOVE      ' '           BLK200          200
     C                   MOVE      ' '           BLANK1            1
     C                   MOVEL     'GL0600  '    DBPGM
     C                   Z-ADD     0             NITMS

     C                   MOVE      'N'           ULX004            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX004'      WSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVEL     'ULX004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           ULX004
     C                   SETON                                        74
     C                   ENDIF

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *BLANKS       DBERR
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      ENDFST
     C                   ENDIF

      ** Check system date format, DDMMYY or MMDDYY.

     C     DATF          COMP      'M'                                    98

      ** Access midas module details

     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY

     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *BLANKS       DBERR
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      ENDFST
     C                   ENDIF

      ** If funds transfer installed seton 24

     C     BGFDTR        IFEQ      'Y'
     C                   SETON                                            24
     C                   ELSE
     C                   SETOFF                                           24
     C                   ENDIF

      ** If analytical accounting installed, seton indicator 28.

     C*****BGNOST        IFEQ      'Y'                                                       255478A
     C     BGN0ST        IFEQ      'Y'                                                       255478A
     C                   MOVE      *ON           *IN28
     C                   ELSE
     C                   MOVE      *OFF          *IN28
     C                   ENDIF

      ** Access general ledger details

     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY

     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *BLANKS       DBERR
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   MOVE      '003'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      ENDFST
     C                   ENDIF

      ** Access retail details, when retail module exists

     C     BGRTBN        IFEQ      'Y'

     C                   CALL      'AORETLR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY

     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *BLANKS       DBERR
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   MOVE      '005'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      ENDFST
     C                   ENDIF

     C                   ENDIF

      ** Check if switchable feature CPB004 is switched on

     C                   MOVE      'N'           WPB004            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      'CPB004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF'
     C                   MOVE      *BLANKS       DBERR
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     @OPTN         DBOPTN
     C                   MOVE      '006'         DBASE
     C                   EXSR      *PSSR
     C                   GOTO      ENDFST
     C                   ELSE
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           WPB004
     C                   ELSE
     C                   MOVE      'N'           WPB004
     C                   ENDIF
     C                   ENDIF

     C/COPY WNCPYSRC,GL0600C016

      ** Call AOSARDR0 to see if CGL048 is switched on

     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL048'      @SARD             6

      ** If SAR CGL048 is installed, set up the indicating field

     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL048            1
     C                   ELSE
     C                   MOVE      'N'           CGL048
     C                   ENDIF

      *                                                                                       CGL184
      ** Check if CGL184 is switched ON                                                       CGL184
      *                                                                                       CGL184
     C                   CALL      'AOSARDR0'                                                 CGL184
     C                   PARM      *BLANKS       @RTCD                                        CGL184
     C                   PARM      '*VERIFY'     @OPTN                                        CGL184
     C                   PARM      'CGL184'      @SARD                                        CGL184
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL184
      *                                                                                       CGL184
     C     @RTCD         IFEQ      *BLANKS                                                    CGL184
     C                   MOVE      'Y'           CGL184            1                          CGL184
     C                   ELSE                                                                 CGL184
     C                   MOVE      'N'           CGL184                                       CGL184
     C                   ENDIF                                                                CGL184
      *                                                                                       CGL184
     C/COPY WNCPYSRC,GLH00528

      ** Is rund last working day of month? 48 on if yes.

     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZMTH          DMOTH             2 0
     C                   Z-ADD     RUND          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZMTH          RMOTH             2 0
     C     RMOTH         COMP      DMOTH                              4848

      ** To avoid daily statements if account opened by system with daily
      ** accrual frequency

     C     BMLDAI        COMP      'Y'                                    21
     C     BKAPFQ        COMP      'D'                                    23
     C                   Z-ADD     BJDNWD        NWKD              5 0

     C/COPY WNCPYSRC,GL0600C017

     C                   Z-ADD     0             RRNMMO            5 0
     C                   Z-ADD     0             TNAO              5 0
     C                   Z-ADD     0             TNFTCA            5 0
     C                   Z-ADD     0             TNAR              5 0
     C                   Z-ADD     0             TNRR              5 0
     C                   Z-ADD     0             TNRW              5 0
     C                   Z-ADD     0             TNPR              5 0
     C                   Z-ADD     0             TNPRC             5 0
     C                   Z-ADD     0             TNPRI             5 0
     C                   Z-ADD     0             TNPIC             5 0
     C                   Z-ADD     0             TNSAW             5 0
     C                   Z-ADD     0             TNAA              5 0
     C                   Z-ADD     0             TNOA              5 0
     C                   Z-ADD     0             CLOACR            4 0
     C                   Z-ADD     0             ZERO5             5 0

      ** If Private Banking Module is installed.

     C     BGN4ST        IFEQ      'Y'

      ** Set up Replication Processing Indicator.

     C                   MOVE      'Y'           WUREPL            1

     C                   ENDIF

      ** Call to the Switchable features file to check if CSD023
      ** is switched on.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSD023'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   MOVE      'N'           CSD023            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSD023
     C                   ENDIF

     C     ACBAKY        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ

     C/COPY WNCPYSRC,GL0600CCP3

     C     *INU4         IFEQ      *ON
     C                   Z-ADD     0             LNORE             5 0
     C                   Z-ADD     0             HWNP             15 0
     C                   Z-ADD     0             HDCP              3 0
     C                   Z-ADD     0             HWNT             15 0
     C                   Z-ADD     0             HDCT              3 0
     C                   Z-ADD     0             GTAMT            15 0
     C                   ENDIF

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @RTCDE            7
     C                   PARM      PSYSVL        P@OP01           20
     C                   PARM      *BLANKS       P@VL01          200
     C                   PARM      *BLANKS       P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200

     C                   MOVE      'N'           IMBLNC            1
     C     @RTCDE        IFEQ      *BLANKS
     C     P@VL01        ANDEQ     'Y'
     C                   MOVE      'Y'           IMBLNC
     C                   ENDIF

     C     ENDFST        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXTEN - Check REACX1PD                                       *
      *                                                               *
      *****************************************************************
     C/COPY WNCPYSRC,GL0600CCP9
     C     EXTEN         BEGSR
     C     KEYAC         CHAIN     REACX1PD                           99
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     0             WE1UAC
     C                   Z-ADD     0             WELUSU
     C                   Z-ADD     0             WELURA
     C                   Z-ADD     0             WECOAM
     C                   MOVE      *BLANKS       WECOAC
     C                   MOVE      *BLANKS       WECOBR
     C                   MOVE      '0'           *IN99
     C                   ENDIF
     C                   MOVE      ATYP          WEATYP
     C                   MOVE      BRCA          WEBRCA
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  REOPEN - Reopen closed account                               *
      *                                                               *
      *****************************************************************

     C     REOPEN        BEGSR
     C                   MOVE      ' '           ACST
     C     DACC          COMP      RUND                                   73
     C   73TROPEN        ADD       1             TROPEN            5 0
     C                   Z-ADD     0             DACC
     C                   MOVE      'R'           CHTP
     C                   Z-ADD     RUND          LCD

      ** For accounts to be re-opened, determine if next statement date
      ** is later than rundate.  If before, recompute next statement date
      ** to prevent GLC43 from looping

     C     NSTD          IFLT      RUND

     C                   Z-ADD     RUND          ZDAYNO
     C                   MOVE      STFQ          ZFREQ
     C                   MOVE      CCY           ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   EXSR      ZFREQS

     C     *IN99         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   MOVE      '1'           *INU7
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        NSTD

     C     *INU1         IFEQ      '0'
     C     *IN23         ANDEQ     '0'

     C     BJDNWD        COMP      BKAPDT                             47

     C     *IN47         IFEQ      '1'
     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   EXSR      ZFREQS
     C                   Z-ADD     ZDAYNO        NSTD
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C/COPY WNCPYSRC,GL0600CCP4

     C     TNAR          ADD       1             TNAR

      ** Include reopened accounts in NAUP processing count

     C                   IF        *IN73 = '0'                                             AR1097218
     C     TNOA          ADD       1             TNOA
     C                   ENDIF                                                             AR1097218
     C                   Z-ADD     RUND          LACD
     C                   MOVE      'D'           RECIAM
     C                   SETON                                        38

     C/COPY WNCPYSRC,GL0600CCP5

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRALT - Alternative account update in case of successful     *
      *          close                                                *
      *                                                               *
      *****************************************************************
     C     SRALT         BEGSR
     C     WALTK         KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA

      ** Key list to access alternative accounts on rehisbl

     C     REHIS         KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ

      ** Amend REIAC

     C     WDACP         IFNE      *BLANK

     C                   MOVEL     WDACP         WALT
     C                   MOVE      WDRBR         WALT

      ** Check if retail key

     C     WALT5         IFEQ      *BLANKS
     C     WALT10        CHAIN     ACNUM                              99
     C                   ENDIF
     C     WALTK         CHAIN     REIAC2                             99
     C     *IN99         IFEQ      '0'
     C                   SUB       1             NOALT
     C                   UPDATE    REIACD2F
     C                   EVAL      ForceCommit = True                                       MD021994

      ** Update alti on b record

     C     NOALT         IFEQ      0
     C     REHIS         CHAIN     REHISBL                            59
     C     *IN59         IFEQ      '0'
     C                   MOVE      ' '           BALTI
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C     WCACP         IFNE      *BLANK

     C                   MOVEL     WCACP         WALT
     C                   MOVE      WCRBR         WALT

      ** Check if retail key

     C     WALT5         IFEQ      *BLANKS
     C     WALT10        CHAIN     ACNUM                              99
     C                   ENDIF
     C     WALTK         CHAIN     REIAC2                             99
     C     *IN99         IFEQ      '0'
     C                   SUB       1             NOALT
     C                   UPDATE    REIACD2F
     C                   EVAL      ForceCommit = TRUE                                       MD021994

     C     NOALT         IFEQ      0
     C     REHIS         CHAIN     REHISBL                            59
     C     *IN59         IFEQ      '0'
     C                   MOVE      ' '           BALTI
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     WCHAC         IFNE      *BLANK

     C                   MOVEL     WCHAC         WALT
     C                   MOVE      WCHBR         WALT

      ** Check if retail key

     C     WALT5         IFEQ      *BLANKS
     C     WALT10        CHAIN     ACNUM                              99
     C                   ENDIF
     C     WALTK         CHAIN     REIAC2                             99
     C     *IN99         IFEQ      '0'
     C                   SUB       1             NOALT
     C                   UPDATE    REIACD2F
     C                   EVAL      ForceCommit = True                                       MD021994

     C     NOALT         IFEQ      0
     C     REHIS         CHAIN     REHISBL                            59
     C     *IN59         IFEQ      '0'
     C                   MOVE      ' '           BALTI
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CLORET - Close retail account, subsidiary file updates       *
      *                                                               *
      *****************************************************************
     C     CLORET        BEGSR

      ** Amend REIAC

     C                   MOVEL     ACNK          ACCKEY           24
     C                   MOVE      BRCA          ACCKEY
     C     ACCKEY        CHAIN     REIAC                              99
     C   99              MOVE      *BLANK        DBERR
     C   99              MOVEL     'REIAC'       DBFILE
     C   99              MOVEL     ACCKEY        DBKEY
     C   99              MOVEL     '060'         DBASE
     C   99              EXSR      *PSSR
     C   99              GOTO      CLREND
     C                   EXSR      SRALT

      ** Flag REACR closed of record present, amount of interest accrued

     C     ACCKEY        CHAIN     REACR                              33

      ** Amend REFEE (Conditioning on U3 presently absent)

     C     COMKEY        CHAIN     RECOM                              99
     C   99              MOVE      *BLANKS       DBERR
     C   99              MOVEL     'RECOM'       DBFILE
     C   99              MOVEL     ACCKEY        DBKEY
     C   99              Z-ADD     62            DBASE
     C   99              EXSR      *PSSR
     C   99              GOTO      CLREND

      ** Only update SREC,REIAC & REACR if successful closure

     C  N56              SETON                                        37

      **  If Replication Processing required.

     C     WUREPL        IFEQ      'Y'

      **  If file update required and Retail Account.

     C     *IN37         IFEQ      *ON
     C     ATYP          ANDEQ     'R'
     C                   EXSR      REPLIC

      ** If any error occurred while executing subroutine REPLIC.

     C     *IN99         IFEQ      *ON
     C                   GOTO      CLREND

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C/COPY WNCPYSRC,GL0600C002

     C     CLREND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SDRET - Retrieve customer-originated a transaction type.     *
      *                                                               *
      *****************************************************************
     C     SDRET         BEGSR

     C                   Z-ADD     1             I0                4 0

     C     TRAT          LOOKUP    RTT(I0)                                59

      ** Transaction not found in array(RTT)

     C     *IN59         IFEQ      '0'
     C                   MOVE      TRAT          RTTY              5
     C                   CALL      'AORETRR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    RTTY
     C     SDRETR        PARM      SDRETR        DSFDY

      ** If record does not exist in SDRETRPD

     C     @RTCD         IFNE      *BLANK
     C                   SETON                                        U7U8LR
     C                   MOVEL     'SDRETRPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     RTTY          DBKEY
     C                   EXSR      *PSSR
     C                   GOTO      END
     C                   ELSE

      ** If record exist in SDRETRPD, store transaction in array(RTT)

     C                   MOVEL     A1RTTY        RTT(I)
     C                   MOVE      A1COIN        COI(I)

      ** Transaction is customer originated

     C     A1COIN        IFEQ      'Y'
     C                   MOVE      'Y'           WCOIN
     C                   ENDIF
     C                   ADD       1             I
     C                   ENDIF
     C                   ELSE

      ** Transaction is customer originated

     C     COI(I0)       IFEQ      'Y'
     C                   MOVE      'Y'           WCOIN
     C                   ENDIF

     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY WNCPYSRC,GL0600C001
     C/COPY WNCPYSRC,GL0600C020
     C/COPY WNCPYSRC,GL0600C006
     C/COPY WNCPYSRC,GL0600C007
     C/COPY WNCPYSRC,GL0600C021
     C/COPY WNCPYSRC,GL0600C022
      *****************************************************************
      *                                                               *
      *  HASH - Hash Total                                            *
      *                                                               *
      *****************************************************************
     C     HASH          BEGSR
     C                   Z-ADD     INT(X)        ZZTOTI
     C                   Z-ADD     DEC(X)        ZZTOTD

     C                   EXSR      GLZADD

     C                   Z-ADD     ZZTOTI        INT(X)
     C                   Z-ADD     ZZTOTD        DEC(X)
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  HASHSUB - Hash Total                                         *
      *                                                               *
      *****************************************************************
     C     HASHSUB       BEGSR

     C                   Z-ADD     0             WRK18N0          18 0
     C                   EVAL      WRK18N0  = (INT(X) * 1000) + DEC(X)
     C                   EVAL      WRK18N0 = WRK18N0 - ZZAMTSUB
     C                   EVAL      INT(X) = WRK18N0 / 1000
     C                   EVAL      DEC(X) = WRK18N0 - (INT(X) * 1000)

     C                   ENDSR
     C/COPY WNCPYSRC,GL0600C012
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LHASH - Hash Total                                           *
      *                                                               *
      *****************************************************************
     C     LHASH         BEGSR

     C     GPAMT         IFGT      0
     C     GPAMT         DIV       1000          ZZAMT
     C                   Z-ADD     HWNP          ZZTOTI
     C                   Z-ADD     HDCP          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        HWNP
     C                   Z-ADD     ZZTOTD        HDCP
     C                   ENDIF

     C     GTAMT         IFGT      0
     C     GTAMT         DIV       1000          ZZAMT
     C                   Z-ADD     HWNT          ZZTOTI
     C                   Z-ADD     HDCT          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        HWNT
     C                   Z-ADD     ZZTOTD        HDCT
     C                   ENDIF

     C     LHEND         ENDSR
      *****************************************************************                     MD038510
      /EJECT                                                                                MD038510
      *****************************************************************                     MD038510
      *                                                               *                     MD038510
      *  WRTSTMT - Write to statement file for system generated accnts*                     MD038510
      *                                                               *                     MD038510
      *****************************************************************                     MD038510
     C     WRTSTMT       BEGSR                                                              MD038510
     C                   MOVE      'D'           RECI                                       MD038510
     C                   MOVE      'N'           MSFL                                       MD038510
     C                   BITOFF    '01234567'    GLBT                                       MD038510
     C                   BITON     '2'           GLBT                                       MD038510
     C                   WRITE     STMTAHF                                                  MD038510
     C                   ENDSR                                                              MD038510
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ACCROU - Access Outward Clearing File                        *
      *                                                               *
      *****************************************************************
     C     ACCROU        BEGSR

     C                   MOVE      '0'           *IN36

     C     RETTYK        KLIST
     C                   KFLD                    GTTYP
     C                   MOVEL     TRAT          GTTYP

     C     RETTYK        CHAIN     RETTYPL0                           89

     C     *IN89         IFEQ      *ON
     C     GRECI         ORNE      'D'

      ** Data Base error in RETTYPL0 File

     C                   MOVEL     *BLANKS       GOCLR
     C                   MOVEL     *BLANKS       GRCLT
     C                   MOVEL     *BLANKS       GRCLP
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZADD - Add an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)  *
      *                                                               *
      *****************************************************************
     C     GLZADD        BEGSR
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91
     C   91              GOTO      ZZAEND

      ** SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   Z-ADD     ZZAMT         ZZWK1             3 3
     C                   MOVE      ZZWK1         ZZAMTD            3 0

      ** BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW

     C                   EXSR      GLZSUM
     C     ZZAEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZCMP - Compare an amount to the total.                     *
      *                                                               *
      *           Parameters                                          *
      *                                                               *
      *           I/P - ZZINT - The integer portion of the number.    *
      *           I/P - ZZDEC - The decimal portion of the number.    *
      *           O/P - ZZDIFI - Is the integer difference.           *
      *           O/P - ZZDIFD - Is the decimal difference.           *
      *           O/P - ZZNEGD - For immediate printing only.         *
      *           O/P - 96 Is set if difference is negative.          *
      *                                                               *
      *****************************************************************
     C     GLZCMP        BEGSR

      ** IF AN ERROR HAS OCCURRED ZZDIFI AND ZZDIFD WILL BE ZERO.
      ** '99' - OVERFLOW ERROR
      ** '97' - THE 'SIGN' ZONES OF ZZINT AND ZZDEC ARE DIFFERENT

     C                   SETOFF                                       9799
     C                   Z-ADD     ZZDEC         ZZDEC             3 0919293
     C                   Z-ADD     ZZINT         ZZINT            15 0949596

      ** If sign zones differ, set 97, & return zero.

     C   91
     CAN 95
     COR 92
     CAN 94              SETON                                        97

     C   97              GOTO      ZZQUIT

      ** Special cases dealt with first
      ** either amounts eq '0' or both amounts 'EQ'

     C                   SETOFF                                       9192
     C                   SETOFF                                       9495
     C   93
     CAN 96              SETON                                        91
     C   91              Z-ADD     ZZTOTI        ZZDIFI           15 0
     C   91              Z-ADD     ZZTOTD        ZZDIFD            3 0
     C   91              GOTO      ZZSIGN

     C     ZZTOTI        COMP      ZZINT                                  91
     C   91ZZTOTD        COMP      ZZDEC                                  91
     C   91              Z-ADD     0             ZZDIFI
     C   91              Z-ADD     0             ZZDIFD
     C   91              GOTO      ZZCEND

     C     ZZTOTI        COMP      0                                      91
     C   91ZZTOTD        COMP      0                                      91
     C   91              Z-SUB     ZZINT         ZZDIFI
     C   91              Z-SUB     ZZDEC         ZZDIFD

     C     ZZSIGN        TAG

      ** if ZZDIFD is zero, and ZZDIFI is neg. set up ZZNEGD.

     C                   SETOFF                                       96
     C   91ZZDIFD        COMP      0                                      94
     C   94ZZDIFI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
     C   91              GOTO      ZZCEND

      ** End of special cases

      ** If ZZTOTALS EQ 'B' and ZZINT,ZZDEC EQ 'A' then - to compare
      ** 'A' with 'B'
      ** 1. store original value of 'B'.
      ** 2. negate 'A'.
      ** 3. add 'A' to 'B'.
      ** 4. 'B' is now the difference. store 'B' in field 'C'.
      ** 5. restore 'B'.
      **     N.B. 'A' EQ ZZINT and ZZDEC
      **          'B' EQ ZZTOTI and ZZTOTD
      **          'C' EQ ZZDIFI and ZZDIFD

      ** Step #1

     C                   Z-ADD     ZZTOTI        ZZSTRI           15 0
     C                   Z-ADD     ZZTOTD        ZZSTRD            3 0

      ** Step #2

     C                   Z-SUB     ZZINT         ZZAMTI           15 0
     C                   Z-SUB     ZZDEC         ZZAMTD            3 0

      ** Step #3

     C                   EXSR      GLZSUM
     C   99              GOTO      ZZQUIT

      ** Step #4

     C                   Z-ADD     ZZTOTI        ZZDIFI
     C                   MOVE      ZZTOTD        ZZDIFD

      ** Step #5

     C                   Z-ADD     ZZSTRI        ZZTOTI           15 0
     C                   Z-ADD     ZZSTRD        ZZTOTD            3 0
     C                   GOTO      ZZCEND

     C     ZZQUIT        TAG
     C                   Z-ADD     0             ZZDIFI
     C                   Z-ADD     0             ZZDIFD

     C     ZZCEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZSUM - ADDITION FOR SUBROUTINES GLZADD, GLZSUB,GLZCMP      *
      *                                                               *
      *           Parameters passed                                   *
      *                                                               *
      *           I/P ZZAMTI,ZZAMTD                                   *
      *           O/P ZZTOTI,ZZTOTD,ZZNEGD,IND 96,IND 99.             *
      *                                                               *
      *****************************************************************
     C     GLZSUM        BEGSR
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599

      ** Determine sign of ZZAMTI & D, 92 if neg

     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND

      ** Determine sign of ZZTOTI & D, 91 if neg.

     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193

      ** If ZZTOTAL is zero, return ZZAMOUNT.

     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND

      ** If signs differ bypass overflow checks.

     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS

     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93

     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3

      ** If the modulus of ZZWK3 is LT MOD. ZZTOTI then O/F has occurred

     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI

      ** If O/F Zeroize ZZAMT , ind '99' set and ZZTOT fields left intact.

     C   99              Z-ADD     0             ZZAMT            15 3
     C   99              MOVE      *BLANK        DBERR
     C   99              MOVEL     'ZSUM '       DBFILE
     C   99              MOVEL     'OVERFLOW'    DBKEY
     C   99              MOVEL     '011'         DBASE
     C   99              EXSR      *PSSR
     C                   GOTO      ZZSEND

      ** The 'SIGNS' are different

     C     ZZOFPS        TAG

      ** If ZZAMT was negative, make it pos. to comp with ZZTOT

     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0

      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.

     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD

      ** Both ZZAMT and ZZTOT are now positive.

     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95

      ** If ZZTOT EQ. ZZAMT return zero.

     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND

      ** IF ZZTOT GT. ZZAMT.

     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD

      ** If ZZAMT GT. ZZTOT.

     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD

      ** Reverse sign of ZZTOT if larger I/P fields were negative

     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD

      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed.

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG

      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.

     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZFREQS - Increment a day number date by a period value       *
      *           determined by a code.                               *
      *                                                               *
      *****************************************************************
     C     ZFREQS        BEGSR

      ** Calculations to define/clear fields.

     C                   MOVE      ZFREQ         ZFREQ             1
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   Z-ADD     ZMDAY         ZMDAY             2 0
     C                   MOVE      ZCCY          ZCCY              3

      ** Convert day number to date.

     C                   EXSR      ZDATE2

     C/COPY WNCPYSRC,GL0600CP19

      ** If the day number input (zmday) is zero set it to the same
      ** day of the month as the current run date

     C     ZMDAY         IFEQ      0
     C                   MOVEL     ZADATE        ZZWRK2            2
     C                   MOVE      ZZWRK2        ZMDAY
     C                   ENDIF

      ** Check for and increment for code D-Daily-working day.

     C     ZFREQ         COMP      'D'                                    91
     C     CGL184        IFEQ      'Y'                                                        CGL184
     C  N91ZFREQ         COMP      'K'                                    91                  CGL184
     C                   ENDIF                                                                CGL184
     C/COPY WNCPYSRC,GL0600C004
     C     *IN91         IFEQ      '1'
     C                   Z-ADD     1             ZNRDYS
     C                   EXSR      ZFWDT
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   GOTO      ZFEND
     C                   ENDIF

     C/COPY WNCPYSRC,GL0600CP21

      ** Check for and increment for code W-weekly.

     C     ZFREQ         COMP      'W'                                    91
     C   91ZDAYNO        ADD       7             ZDAYNO
     C   91              GOTO      ZFEND

      ** Check for and increment for code F-fortnightly.

     C     ZFREQ         COMP      'F'                                    91
     C   91ZDAYNO        ADD       14            ZDAYNO
     C   91              GOTO      ZFEND

      ** Check for and increment for code S-semi-monthly.

     C     ZFREQ         COMP      'S'                                    91
     C   91ZDAY          COMP      15                                 939292
     C   91              GOTO      ZFDATE

     C     *IN91         IFEQ      '1'
     C     *IN92         IFEQ      '1'
     C                   Z-ADD     15            ZDAY
     C                   ENDIF
     C     *IN93         IFEQ      '1'
     C                   Z-ADD     31            ZDAY
     C                   ENDIF
     C                   ENDIF

      ** Check for and increment for code M-monthlu.

     C     ZFREQ         COMP      'M'                                    91
     C     CGL184        IFEQ      'Y'                                                        CGL184
     C  N91ZFREQ         COMP      'G'                                    91                  CGL184
     C                   ENDIF                                                                CGL184
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE

      ** Check for and increment for code R-six days before end of month

     C     ZFREQ         COMP      'R'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91              GOTO      ZFDATE

      ** Check for and increment for code T-bimonthly.

     C     ZFREQ         COMP      'T'                                    91
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       2             ZMTH
     C   91              GOTO      ZFDATE

      ** Check for and increment for code Q-quarterly.

     C     ZFREQ         COMP      'Q'                                    91
     C     CGL184        IFEQ      'Y'                                                        CGL184
     C  N91ZFREQ         COMP      'Q'                                    91                  CGL184
     C                   ENDIF                                                                CGL184
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       3             ZMTH
     C   91              GOTO      ZFDATE

      ** Check for and increment for code X-six monthlu.

     C     ZFREQ         COMP      'X'                                    91
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZMTH          ADD       6             ZMTH
     C   91              GOTO      ZFDATE

      ** Check for and increment for code Y-yearly.

     C     ZFREQ         COMP      'Y'                                    91
     C     CGL184        IFEQ      'Y'                                                        CGL184
     C  N91ZFREQ         COMP      'O'                                    91                  CGL184
     C                   ENDIF                                                                CGL184
     C   91              Z-ADD     ZMDAY         ZDAY
     C   91ZYEAR         ADD       1             ZYEAR
     C   91              GOTO      ZFDATE

      ** Check for and increment for code L-last calendar day of month.

     C     ZFREQ         COMP      'L'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91              GOTO      ZFDATE

      ** Check for and increment for code B-last working day of month.

     C     ZFREQ         COMP      'B'                                    91
     C   91              Z-ADD     31            ZDAY
     C   91
     CAN 48
     CANNU1ZMTH          ADD       1             ZMTH
     C   91              GOTO      ZFDATE

      ** Check for and increment for code A-monthlu accrual/profit date.

     C     ZFREQ         COMP      'A'                                    91

     C     *IN91         IFEQ      '1'

      ** Access general ledger details

     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY

     C     @RTCD         IFNE      *BLANK
     C                   SETON                                        99
     C                   SETON                                        U7
     C                   MOVE      *BLANKS       DBERR
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   MOVE      '009'         DBASE
     C                   GOTO      ZFEND
     C                   ELSE
     C                   Z-ADD     BKAPDT        ZDAYNO
     C                   ENDIF

     C                   ENDIF

      ** Bypass if ZFREQ is 'A' or any other value

     C                   GOTO      ZFEND

      ** Reformat date and ensure valid.

     C     ZFDATE        TAG

      ** Validate month.

     C     ZMTH          COMP      12                                 91
     C   91ZMTH          SUB       12            ZMTH
     C   91ZYEAR         ADD       1             ZYEAR

      ** Check for leap year.

     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0    92

      ** Validate day number.

     C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
     C     ZMTH          COMP      2                                      93
     C   92
     CAN 93              Z-ADD     29            ZWRK2

     C     ZDAY          COMP      ZWRK2                              94
     C   94              Z-ADD     ZWRK2         ZDAY

      ** Check if code r, to subtract 6 days.

     C     ZFREQ         COMP      'R'                                    91
     C   91ZDAY          SUB       6             ZDAY

      ** Reformat date, DDMMYY or MMDDYY, and convert to day number.

     C                   MOVEL     ZDAY          ZWRK4             4 0
     C                   MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C   98              MOVE      ZDAY          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C                   EXSR      ZDATE1

      ** Check if code b,to be checked for holiday.

     C     ZFREQ         COMP      'B'                                    91
     C     *IN91         IFEQ      '1'
     C     *IN99         ANDNE     '1'
     C                   Z-ADD     0             ZNRDYS
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   GOTO      ZFEND
     C                   ENDIF

     C     ZFEND         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate dates and convert to a number of days      *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR

      ** Clear day number.

     C                   Z-ADD     0             ZDAYNO            5 0

      ** Calculation to define input date field.

     C                   Z-ADD     ZDATE         ZDATE             6 0

      ** Get individual day, month and year fields.

     C                   MOVE      ZDATE         ZYEAR             2 0
     C  N98              MOVEL     ZDATE         ZDAY              2 0
     C   98              MOVEL     ZDATE         ZMTH              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C  N98              MOVEL     ZWRK4         ZMTH
     C   98              MOVEL     ZWRK4         ZDAY

      ** Ensure month is valid.

     C     ZMTH          COMP      0                                    9999
     C  N99ZMTH          COMP      12                                 99
     C   99              GOTO      ZDEND1

      ** Check for 30 day months.

     C     ZMTH          COMP      4                                      90
     C  N90ZMTH          COMP      6                                      90
     C  N90ZMTH          COMP      9                                      90
     C  N90ZMTH          COMP      11                                     90

      ** Ensure day is valid.

     C     ZDAY          COMP      0                                    9999
     C   90
     CANN99ZDAY          COMP      30                                 99
     C  N90
     CANN99ZDAY          COMP      31                                 99
     C   99              GOTO      ZDEND1

      ** Check for leap year and february.

     C     ZYEAR         ADD       28            ZYEAR
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0    91
     C     ZMTH          COMP      2                                  93  92

      ** If febuary further validate day.

     C  N91
     CAN 92ZDAY          COMP      28                                 99
     C   91
     CAN 92ZDAY          COMP      29                                 99
     C   99              GOTO      ZDEND1

      ** Determine number of days from 31/12/1971.

     C     ZLYR          MULT      1461          ZDAYNO
     C  N91ZDAYNO        ADD       ZYDY(ZLY)     ZDAYNO
     C   91
     CAN 93ZDAYNO        ADD       1             ZDAYNO
     C     ZDAYNO        ADD       ZMDY(ZMTH)    ZDAYNO
     C     ZDAYNO        ADD       ZDAY          ZDAYNO

     C     ZDEND1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Convert a day number to date formats.               *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR

      ** Clear date fields.

     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7

      ** Calculation to define input day number.

     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0

      ** Determine year number.
      ** Adjust day number in case last day of year.

     C     ZDAYNO        SUB       1             ZDAYN1            5 0  99
     C   99              GOTO      ZDEND2

      ** Calculate number of 4 year spans since 31/12/1971.

     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1

      ** Calculate number of remaining years.

     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG
     C     ZDAYN1        COMP      ZYDY(ZWRK2)                          90
     C  N90ZWRK2         ADD       1             ZWRK2
     C  N90              GOTO      ZDTAG1
     C     ZWRK2         SUB       1             ZWRK2                    91

      ** Decrement day no. by days in remaining years.

     C  N91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1

      ** Calculate actual year number.

     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR

      ** Determine month number.
      ** adjust day no. in case last day of leap year febuary.

     C                   SETOFF                                       9293
     C   91ZDAYN1        COMP      59                                   9293
     C   91
     CANN92ZDAYN1        SUB       1             ZDAYN1

      ** Calculate month number.

     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG
     C     ZDAYN1        COMP      ZMDY(ZWRK2)                          94
     C  N94ZWRK2         ADD       1             ZWRK2
     C  N94              GOTO      ZDTAG2
     C     ZWRK2         SUB       1             ZWRK2

     C                   Z-ADD     ZWRK2         ZMTH              2 0

      ** Determine day of month.
      ** Add back last day of year adjustment.

     C     ZDAYN1        ADD       1             ZDAYN1

      ** calculate day of month.

     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0

      ** Add back leap year 29th febuary adjustment, if required.

     C   93ZDAY          ADD       1             ZDAY

      ** format date, DDMMYY or MMDDYY.

     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE

      ** Format alpha date, DDMMMYY.

     C     ZDAY          COMP      10                                   95
     C                   MOVEL     ZDAY          ZWRK5             5
     C   95              MOVEL     ' '           ZWRK5
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE

     C     ZDEND2        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZACCH - ACCESS A HOLIDAY RECORD FOR A PARTICULAR CURRENCY    *
      *          AND (OPTIONAL) LOCATION.                             *
      *                                                               *
      *****************************************************************
     C/COPY ZSRSRC,ZACCHLE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZFWDT - CALCULATE THE NTH WORKING DAY FORWARD FROM A GIVEN   *
      *          START DATE FOR ANY PARTICULAR CURRENCY               *
      *          AND (OPTIONAL) LOCATION.                             *
      *                                                               *
      *****************************************************************
     C/COPY ZSRSRC,ZFWDT_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZBKDT - CALCULATE THE NTH WORKING DAY BACKWARD FROM A GIVEN  *
      *          START DATE FOR ANY PARTICULAR CURRENCY               *
      *          AND (OPTIONAL) LOCATION.                             *
      *                                                               *
      *****************************************************************
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY WNCPYSRC,GL0600C003
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   IF        PrintHeader                                              MD021994
                                                                                            MD021994
     C                   IF        NOT %OPEN(GL0600AU)                                      MD021994
     C                   OPEN      GL0600AU                                                 MD021994
     C                   ENDIF                                                              MD021994
                                                                                            MD021994
     C                   WRITE     HEADAU                                                   MD021994
     C                   EVAL      PrintHeader = False                                      MD021994
     C                   ENDIF                                                              MD021994
                                                                                            MD021994
     C                   WRITE     DBERROR                                                  MD021994
     C                   CLOSE     GL0600AU                                                 MD021994
                                                                                            MD021994
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  REPLIC - set up Replication Indicator.                       *
      *                                                               *
      *****************************************************************
     C     REPLIC        BEGSR

      ** Access Customer Details by using Access Object,
      ** to retrieve Private Banking Customer Indicator.

     C                   MOVE      *BLANKS       @CUST
     C                   MOVEL     CNUM          @CUST
     C                   CALLB     'AOCUSTR2'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CUST            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY

      **  If Customer Details do not exist, handle Database Error.

     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     CSD023        ANDEQ     'Y'
     C     @RTCD         ORNE      *BLANKS
     C     @RTCD         ANDEQ     '*NRF   '
     C     BBDTDL        ANDNE     *ZEROS
     C     CSD023        ANDEQ     'Y'
     C     @RTCD         ORNE      *BLANKS
     C     CSD023        ANDNE     'Y'
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     91            DBASE
     C                   MOVEL     @CUST         DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   GOTO      ENDREP

     C                   ENDIF

      **  If Customer is a Private Banking Customer, set up
      **  Replication Indicator.

     C     BBPRBA        IFEQ      'Y'

      **  Check if account code will be sent to interface

     C                   MOVEL     ACOD          ACODX            10
     C                   CALLB     'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ACODX         @ACCD            10
     C     SDACOD        PARM      SDACOD        DSSDY

     C     @RTCD         IFEQ      *BLANKS
     C     WPB004        ANDEQ     'N'

     C     @RTCD         OREQ      *BLANKS
     C     WPB004        ANDEQ     'Y'
     C     A5TRAN        ANDEQ     'Y'

     C                   MOVE      'Y'           REPI

     C                   ENDIF
     C                   ENDIF

     C     ENDREP        TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Accounts opened by the system

     OSYSOPAJ   EADD 85      EXCPTA1
     O                                            1 'D'
     O                       BRCA                 4
     O                       CNUM                10
     O                       CCY                 13
     O                       ACODQQ              17
     O                       ACSQ                19
     O                       DACO                22P
     O                       DLNO                28
     O                       ATYP                29
     O                       STFQ                30
     O                       NSTD                33P
     O                       PSTAOP              40P
     O                       ANAM                60
     O                       CHTP                61
     O                       ACOD                71

      ** Accounts due for balance statment

     O/COPY WNCPYSRC,GL0600OOP3

     O/COPY WNCPYSRC,GL0600OOP4

     O/COPY WNCPYSRC,GL0600O008

     O/COPY WNCPYSRC,GL0600OOP2

      ** Postings in clearing

     OCLEARPD   E    88 U5   EXCPT4
     O                                            1 'P'
     O                       LOTSA1             250
     O                       LOTSA2             331
     O                       ACODQQ              14
     O                       BRCA               105
     O                       PRIN               128
     O                       PRFC               134
     O                       LTAI               147
     O                       OTRFQQ             230
     O                       OTST               240
     O                       OTTP               250
     O                       SDCB               258P
     O                       SDLB               266P
     O                       BOKC               268
     O                       NITMS              271P
     O                       REBI               272
     O                       CHGA               279P
     O                       ORAMT              316P
     O                       XRFN               329
     O                       ACKEY              351
     O                       FEEFLG             352
     O                       FEEVAL             359P
     O                       FEEPCT             364
     O                       RORACT             384
     O                       RORCTY             386
     O                       RORBNK             406
     O                       RORCDE             417
     O                       PORACT             437
     O                       PORCTY             439
     O                       PORBNK             459
     O                       PORCDE             470
     O                       DSTACT             505
     O                       DSTCTY             507
     O                       DSTBNK             527
     O                       SETDAT             530P
     O                       TICKER             540
     O                       EXCHNG             560
     O                       NOMINL             573
     O                       FDTRID             589
     O                       ACOD               599
     O                       OTRF               620

     O/COPY WNCPYSRC,GL0600OOP5

      ** Core hook for externalisation.

     O/COPY WNCPYSRC,GL0600OOPG

      ** Outward Clearing File.

     OREOUTLPD  E    81 39 U4EXCPTA2
     O                                            1 'L'
     O                       GPAMT          B     9P
     O                       GTAMT          B    17P
     O                       ACNO                27

      ** Accounts Master File - DETAIL

     OACCNTL0   E    81      EXCPT5
     O                       AREC1O             200
     O                       AREC2O             687

     O/COPY WNCPYSRC,GL0600O007

     O/COPY WNCPYSRC,GL0600O006

     O/COPY WNCPYSRC,GL0600O003

     O/COPY WNCPYSRC,GL0600O004

     O/COPY WNCPYSRC,GL0600O001

     O/COPY WNCPYSRC,GL0600O002

     OACCNTL0   EADD 81      EXCPT6
     O                       AREC1              200
     O                       AREC2              687
     O                       RECIAM               1
     O                       WNOCC1              10
     O                       WSEQ1               16
     O                       WACOD1             563
     O                       BRCA                25
     O                       ATYP                26
     O                       ASTYP               27
     O                       ACST                29
     O                       DACO                32P
     O                       DACC                35P
     O                       ANAM                55
     O                       LDBL                63P
     O                       CLBL                71P
     O                       STFQ                72
     O                       DMST                74
     O                       LSTD                77P
     O                       NSTD                80P
     O                       LSTP                82P
     O                       CFSB                90P
     O                       LMVD                93P
     O                       EPLB               101P
     O                       EPCB               109P
     O                       YTDB               117P
     O                       GLBT               118
     O                       ADREF1             126
     O               03      PRFC               130
     O               03 28N29                   130 '    '
     O                       ORED               137P
     O                       DLIM               140P
     O                       LRCR               143P
     O                       RTCB               151P
     O                       RTLB               159P
     O                       DITM               166P
     O                       CITM               173P
     O                       ADREF2             175
     O                       CDIR               183P
     O                       CCIR               189P
     O                       ACNO               199
     O                       RETB               200
     O                       ODSC               201
     O                       ODLN               207P
     O                       ODED               210P
     O                       DIOD               212P
     O                       FACT               215
     O                       FCNO               217
     O                       EFAC               219
     O                       HELD               227P
     O                       MINB               233P
     O                       LACD               236P
     O                       LISP               238P
     O              N20 U1   ZERO5              241P
     O                       DRIB               243
     O                       DRIS               249P
     O                       DRCD               252P
     O                       DRIC               253
     O                       DRIF               254
     O                       DRDY               256
     O                       NDID               259P
     O                       LDID               262P
     O                       LDIA               269P
     O                       SDAP               270
     O                       LPAR               273P
     O                       DIIE               280P
     O                       DAIC               288P
     O                       MADI               295P
     O                       GADI               302P
     O                       BLANK1             303
     O                       DDIA               306P
     O                       OLDR               309P
     O                       OLDB               311
     O                       OLDS               317P
     O                       CRIB               319
     O                       CRIS               325P
     O                       CRCD               328P
     O                       CRIC               329
     O                       CRIF               330
     O                       CRDY               332
     O                       NCID               335P
     O                       LCID               338P
     O                       LCIA               345P
     O                       SCAP               346
     O                       LPAP               349P
     O                       CIIE               356P
     O                       CAIC               364P
     O                       MACI               371P
     O                       GACI               378P
     O                       BLANK1             379
     O                       DCIA               382P
     O                       OLCR               385P
     O                       OLCB               387
     O                       OLCS               393P
     O                       LCD                396P
     O                       CHTP               397
     O                       TNLU               400P
     O                       BRTCA              401
     O                       NACSG              402
     O                       R4ACNT             403
     O                       ENOC               405P
     O                       EPNO               407P
     O                       ECFB               415P
     O                       LTAB               418
     O                       LTACQQ             422
     O                       LTAS               424
     O                       PTFR               436
     O                       HLEX               437
     O                                          438 'N'
     O                                          444 '      '
     O                                          447 '   '
     O                       EUSB               448
     O                       IBAN               482
     O                       IBSEQN             485
     O                       FRNT               505
     O                       AFRT               525
     O                       REPA               526
     O                       TSTAMP             552
     O              N03      TMST               552
     O                       REPI               553
     O                       LTAC               573
     O                       FCCU               579
     O                       COLF               580
     O                       BCOA               588P
     O                       COLA               596P
     O                       PFCU               602
     O                       PFTP               605
     O                       PFSQ               607
     O                       A5ACKY             641
     O                       A5INTL             642
     O                       A5TIAB             646
     O                       AUTH               647
     O                       K24C               648
     O                       ACEFDT             651P
     O                       DCSP               657P
     O                       DCSG               658
     O                       DRMT               665
     O                       DRFD               669
     O                       CCSP               675P
     O                       CCSG               676
     O                       CRMT               683
     O                       CRFD               687

     O/COPY WNCPYSRC,GL0600O005

     OREIAC     E    37      EXCPTA3
     O                       RECIAM               1
     O                       REPI           B   145

     OREACR     E    37N33   EXCPTA4
     O                       RECIAM               1

     ORECOMDF   E    37      EXCPTA5
     O                       RECI

      ** Account post controls

     O***GL0600AU  T    LR                     2 03                                         MD021994
     O**********                                 20 'REFERENCE GL0600AU'                    MD021994
     O**********             BJURPT              89                                         MD021994
     O**********                                106 'DATE'                                  MD021994
     O**********             RUNA               114                                         MD021994
     O**********                                124 'PAGE'                                  MD021994
     O**********             PAGE               129                                         MD021994
     O**********T    LR                                                                     MD021994
     O**********                                 65 'ACCOUNTS POST'                         MD021994
     O**********                                 80 'RUN CONTROLS'                          MD021994
     O**********T    LR                                                                     MD021994
     O**********                                 65 '-------------'                         MD021994
     O**********T    LR                     2 20                                            MD021994
     O**********                                 22 'ACCOUNTS POST CONTROLS'                MD021994
     O**********T    LR                                                                     MD021994
     O**********                                 27 '-NUMBER OF ACCOUNT '                   MD021994
     O**********                                 39 'RECORDS READ'                          MD021994
     O**********             TNRR          1     59                                         MD021994
     O**********T    LR                     1                                               MD021994
     O**********                                 27 '-NUMBER OF ACCOUNTS'                   MD021994
     O**********                                 48 'OPENED BY THE SYSTEM'                  MD021994
     O**********             TNAO          1     59                                         MD021994
     O**********T    LR                     1                                               MD021994
     O**********                                 27 '-NUMBER OF ACCOUNTS'                   MD021994
     O**********                                 51 'RE-OPENED BY THE SYSTEM'               MD021994
     O**********             TNAR          1     59                                         MD021994
     O**********T    LR                     2                                               MD021994
     O**********                                 27 '-NUMBER OF ACCOUNT '                   MD021994
     O**********                                 42 'RECORDS WRITTEN'                       MD021994
     O**********             TNRW          1     59                                         MD021994
     O**********T    LR                     1                                               MD021994
     O**********                                 27 '-NUMBER OF POSTINGS'                   MD021994
     O**********                                 47 'PROCESSED IN C.O.B.'                   MD021994
     O**********             TNPRC         1     59                                         MD021994
     O**********T    LR                     1                                               MD021994
     O**********T    LR                     1                                               MD021994
     O**********                                 27 '-NUMBER OF POSTINGS'                   MD021994
     O**********                                 45 'PROCESSED IN I.C.'                     MD021994
     O**********             TNPRI         1     59                                         MD021994
     O**********T    LR                     1                                               MD021994
     O**********T    LR U1                  1                                               MD021994
     O**********                                 27 '-NUMBER OF POSTINGS'                   MD021994
     O**********                                 39 'IN CLEARING'                           MD021994
     O**********             TNPIC         1     59                                         MD021994
     O**********T    LR                     2                                               MD021994
     O**********T    LR U7               3                                                  MD021994
     O**********                                 48 '*** DATABASE ERROR '                   MD021994
     O**********             DBASE               51                                         MD021994
     O**********                                 59 '-FILE-S/'                              MD021994
     O**********             DBFILE              67                                         MD021994
     O**********                                 76 'KEY-'                                  MD021994
     O**********             DBKEY              105                                         MD021994
     O**********                                109 '***'                                   MD021994

     O/COPY WNCPYSRC,GL0600OOP1

** - ZFMD  -  NUMBER OF DAYS IN MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
     X/COPY WNCPYSRC,GL0600X001
